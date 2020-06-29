//=============================================================================
// SecurityCamera.
//=============================================================================
class SecurityCamera extends HackableDevices;

var() bool bSwing;
var() int swingAngle;
var() float swingPeriod;
var() int cameraFOV;
var() int cameraRange;
var float memoryTime;
var() bool bActive;
var() bool bNoAlarm;            // if True, does NOT sound alarm
var Rotator origRot;
var Rotator ReplicatedRotation; // for net propagation
var bool bTrackPlayer;
var bool bPlayerSeen;
var bool bEventTriggered;
var bool bFoundCurPlayer;  // in multiplayer, if we found a player this tick.
var float lastSeenTimer;
var float playerCheckTimer;
var float swingTimer;
var bool bConfused;             // used when hit by EMP
var float confusionTimer;       // how long until camera resumes normal operation
var float confusionDuration;    // how long does EMP hit last?
var float triggerDelay;         // how long after seeing the player does it trigger?
var float triggerTimer;         // timer used for above
var vector playerLocation;      // last seen position of player

// DEUS_EX AMSD Used for multiplayer target acquisition.
var Actor curTarget;          // current view target
var Actor prevTarget;         // target we had last tick.
var Pawn safeTarget;          // in multiplayer, this actor is strictly off-limits
                               // Usually for the player who activated the turret.

var localized string msgActivated;
var localized string msgDeactivated;

var int team;                       // Keep track of team the camera is  on

// ------------------------------------------------------------------------------------
// Network replication
// ------------------------------------------------------------------------------------

replication
{
   //server to client var
   reliable if (Role == ROLE_Authority)
      bActive, ReplicatedRotation, team, safeTarget;
}

function HackAction(Actor Hacker, bool bHacked)
{
   local ComputerSecurity CompOwner;
   local ComputerSecurity TempComp;
    local AutoTurret turret;
    local name Turrettag;
   local int ViewIndex;

   if (bConfused)
        return;

    Super.HackAction(Hacker, bHacked);

    if (bHacked)
    {
      if (Level.NetMode == NM_Standalone)
      {
         if (bActive)
            UnTrigger(Hacker, Pawn(Hacker));
         else
            Trigger(Hacker, Pawn(Hacker));
      }
      else
      {
         //DEUS_EX AMSD Reset the hackstrength afterwards
         if (hackStrength == 0.0)
            hackStrength = 0.6;
         if (bActive)
            UnTrigger(Hacker, Pawn(Hacker));
         //Find the associated computer.
         foreach AllActors(class'ComputerSecurity',TempComp)
         {
            for (ViewIndex = 0; ViewIndex < ArrayCount(TempComp.Views); ViewIndex++)
            {
               if (TempComp.Views[ViewIndex].cameraTag == self.Tag)
               {
                  CompOwner = TempComp;

                  //find associated turret
                  Turrettag = TempComp.Views[ViewIndex].Turrettag;
                  if (Turrettag != '')
                  {
                     foreach AllActors(class'AutoTurret', turret, TurretTag)
                     {
                        break;
                     }
                  }
               }
            }
         }

         if (CompOwner != None)
         {
            //Turn off the associated turret as well
            if ( (Hacker.IsA('DeusExPlayer')) && (Turret != None))
            {
               Turret.bDisabled = True;
               Turret.gun.HackStrength = 0.6;
            }
         }
      }
   }
}

function Trigger(Actor Other, Pawn Instigator)
{
    Super.Trigger(Other, Instigator);

    if (!bActive)
    {
        if (Instigator != None)
            Instigator.ClientMessage(msgActivated);
        bActive = True;
        LightType = LT_Steady;
        LightHue = 80;
        AmbientSound = sound'CameraHum';
        // Vanilla Matters
        if ( !bConfused ) {
            MultiSkins[2] = Texture'GreenLightTex';
        }
        else {
            MultiSkins[2] = Texture'YellowLightTex';
        }
    }
}

function UnTrigger(Actor Other, Pawn Instigator)
{
    Super.UnTrigger(Other, Instigator);

    if (bActive)
    {
        if (Instigator != None)
            Instigator.ClientMessage(msgDeactivated);
        TriggerEvent(False);
        bActive = False;
        LightType = LT_None;
        AmbientSound = None;
        DesiredRotation = origRot;
        hackStrength = 0.0;
        // Vanilla Matters
        MultiSkins[2] = Texture'BlackMaskTex';
    }
}

function TriggerEvent(bool bTrigger)
{
    bEventTriggered = bTrigger;
    bTrackPlayer = bTrigger;
    triggerTimer = 0;

    // now, the camera sounds its own alarm
    if (bTrigger)
    {
        AmbientSound = Sound'Klaxon2';
        SoundVolume = 128;
        SoundRadius = 64;
        LightHue = 0;
        MultiSkins[2] = Texture'RedLightTex';
        AIStartEvent('Alarm', EAITYPE_Audio, SoundVolume/255.0, 25*(SoundRadius+1));

        // make sure we can't go into stasis while we're alarming
        bStasis = False;
    }
    else
    {
        AmbientSound = Sound'CameraHum';
        SoundRadius = 48;
        SoundVolume = 192;
        LightHue = 80;
        MultiSkins[2] = Texture'GreenLightTex';
        AIEndEvent('Alarm', EAITYPE_Audio);

        // reset our stasis info
        bStasis = Default.bStasis;
    }
}

// Vanilla Matters: Rewrite to add dead body detection.
function CheckPlayerVisibility( DeusExPlayer player ) {
    local float yaw, pitch, dist;
    local Actor hit;
    local Vector HitLocation, HitNormal;
    local Rotator rot;
    local DeusExCarcass carcass;

    if ( player == none ) {
        return;
    }

    dist = Abs( VSize( player.Location - Location ) );

    if ( player.bDetectable && !player.bIgnore && dist <= cameraRange ) {
        hit = Trace( HitLocation, HitNormal, player.Location, Location, true );
        if ( hit == player ) {
            if ( Level.Netmode == NM_Standalone ) {
                if ( player.AugmentationSystem.GetAugLevelValue( class'AugRadarTrans' ) != -1.0 ) {
                    hit = none;
                }
            }
        }
        else {
            hit = none;
        }
    }

    if ( hit == none ) {
        foreach RadiusActors( class'DeusExCarcass', carcass, cameraRange ) {
            if ( carcass.KillerAlliance == 'Player' ) {
                hit = Trace( HitLocation, HitNormal, carcass.Location, Location, true );
                if ( hit == carcass ) {
                    break;
                }
                else {
                    hit = none;
                }
            }
        }
    }

    if ( hit == none ) {
        return;
    }

    rot = Rotator( hit.Location - Location );
    rot.Roll = 0;
    yaw = Abs( Rotation.Yaw - rot.Yaw ) % 65536;
    pitch = Abs( Rotation.Pitch - rot.Pitch ) % 65536;

    if ( yaw > 32767 ) {
        yaw -= 65536;
    }
    if ( pitch > 32767 ) {
        pitch -= 65536;
    }

    if ( Abs( yaw ) < cameraFOV && Abs( pitch ) < cameraFOV ) {
        if ( bTrackPlayer ) {
            DesiredRotation = rot;
        }

        lastSeenTimer = 0;
        bPlayerSeen = true;
        bTrackPlayer = true;
        bFoundCurPlayer = true;

        playerLocation = hit.Location - vect( 0,0,1 ) * ( player.CollisionHeight - 5 );

        if ( !bEventTriggered && triggerTimer >= triggerDelay && Level.Netmode == NM_Standalone ) {
            TriggerEvent( true );
        }
    }
}

function Tick(float deltaTime)
{
    local float ang;
    local Rotator rot;
   local DeusExPlayer curplayer;

   Super.Tick(deltaTime);

   curTarget = None;

    // Vanilla Matters
    if ( !bActive ) {
        // DEUS_EX AMSD For multiplayer
        ReplicatedRotation = DesiredRotation;

        // Vanilla Matters: Still update the confusion timer while it's turned off.
        if ( bConfused ) {
            confusionTimer += deltaTime;
        }

        return;
    }

    // if we've been EMP'ed, act confused
    if (bConfused)
    {
        confusionTimer += deltaTime;

        // pick a random facing at random
        if (confusionTimer % 0.25 > 0.2)
        {
            DesiredRotation.Pitch = origRot.Pitch + 0.5*swingAngle - Rand(swingAngle);
            DesiredRotation.Yaw = origRot.Yaw + 0.5*swingAngle - Rand(swingAngle);
        }

        if (confusionTimer > confusionDuration)
        {
            bConfused = False;
            confusionTimer = 0;
            confusionDuration = Default.confusionDuration;
            LightHue = 80;
            MultiSkins[2] = Texture'GreenLightTex';
            SoundPitch = 64;
            DesiredRotation = origRot;
        }

        return;
    }

    // check the player's visibility every 0.1 seconds
    if (!bNoAlarm)
    {
        playerCheckTimer += deltaTime;

        if (playerCheckTimer > 0.1)
        {
            playerCheckTimer = 0;
         if (Level.NetMode == NM_Standalone)
            CheckPlayerVisibility(DeusExPlayer(GetPlayerPawn()));
         else
         {
            curPlayer = DeusExPlayer(AcquireMultiplayerTarget());
            if (curPlayer != None)
               CheckPlayerVisibility(curPlayer);
         }
        }
    }

    // forget about the player after a set amount of time
    if (bPlayerSeen)
    {
        // if the player has been seen, but the camera hasn't triggered yet,
        // provide some feedback to the player (light and sound)
        if (!bEventTriggered)
        {
            triggerTimer += deltaTime;

            if (triggerTimer % 0.5 > 0.4)
            {
                LightHue = 0;
                MultiSkins[2] = Texture'RedLightTex';
                PlaySound(Sound'Beep6',,,, 1280);
            }
            else
            {
                LightHue = 80;
                MultiSkins[2] = Texture'GreenLightTex';
            }
        }

        if (lastSeenTimer < memoryTime)
            lastSeenTimer += deltaTime;
        else
        {
            lastSeenTimer = 0;
            bPlayerSeen = False;

            // untrigger the event
            TriggerEvent(False);
        }

        return;
    }

    swingTimer += deltaTime;
    MultiSkins[2] = Texture'GreenLightTex';

    // swing back and forth if all is well
    if (bSwing && !bTrackPlayer)
    {
        ang = 2 * Pi * swingTimer / swingPeriod;
        rot = origRot;
        rot.Yaw += Sin(ang) * swingAngle;
        DesiredRotation = rot;
    }

   // DEUS_EX AMSD For multiplayer
   ReplicatedRotation = DesiredRotation;
}

auto state Active
{
    function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name DamageType)
    {
        local float mindmg;

        if (DamageType == 'EMP')
        {
            // duration is based on daamge

            // Vanilla Matters: Scale it to 0 - 120.
            confusionDuration = FClamp( confusionDuration + Damage, 0, 120 );

            confusionTimer = 0;
            if (!bConfused)
            {
                bConfused = True;
                LightHue = 40;
                MultiSkins[2] = Texture'YellowLightTex';
                SoundPitch = 128;
                PlaySound(sound'EMPZap', SLOT_None,,, 1280);
            }
            return;
        }
        if (( Level.NetMode != NM_Standalone ) && (EventInstigator.IsA('DeusExPlayer')))
            DeusExPlayer(EventInstigator).ServerConditionalNotifyMsg( DeusExPlayer(EventInstigator).MPMSG_CameraInv );

        Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType);
    }
}

function BeginPlay()
{
    Super.BeginPlay();

    origRot = Rotation;
    DesiredRotation = origRot;

    playerLocation = Location;

   if (Level.NetMode != NM_Standalone)
   {
      bInvincible=True;
      HackStrength = 0.6;
   }
}

// ------------------------------------------------------------------------
// AcquireMultiplayerTarget()
// DEUS_EX AMSD Copied from Turret so that cameras will track enemy players
// in multiplayer.
// ------------------------------------------------------------------------
function Actor AcquireMultiplayerTarget()
{
   local Pawn apawn;
    local DeusExPlayer aplayer;
    local Vector dist;

   //DEUS_EX AMSD See if our old target is still valid.
   if ((prevtarget != None) && (prevtarget != safetarget) && (Pawn(prevtarget) != None))
   {
      if (Pawn(prevtarget).AICanSee(self, 1.0, false, false, false, true) > 0)
      {
         if (DeusExPlayer(prevtarget) == None)
         {
            curtarget = prevtarget;
            return curtarget;
         }
         else
         {
            if (DeusExPlayer(prevtarget).AugmentationSystem.GetAugLevelValue(class'AugRadarTrans') == -1.0)
            {
               curtarget = prevtarget;
               return curtarget;
            }
         }
      }
   }
    // MB Optimized to use pawn list, previous way used foreach VisibleActors
    apawn = Level.PawnList;
    while ( apawn != None )
    {
      if (apawn.bDetectable && !apawn.bIgnore && apawn.IsA('DeusExPlayer'))
      {
            aplayer = DeusExPlayer(apawn);

            dist = aplayer.Location - Location;

            if ( VSize(dist) < CameraRange )
            {
                // Only players we can see
                if ( aplayer.FastTrace( aplayer.Location, Location ))
                {
                    //only track players who aren't the safetarget.
                    //we already know prevtarget not valid.
                    if ((aplayer != safeTarget) && (aplayer != prevTarget))
                    {
                        if (! ( (TeamDMGame(aplayer.DXGame) != None) && (safeTarget != None) && (TeamDMGame(aplayer.DXGame).ArePlayersAllied( DeusExPlayer(safeTarget),aplayer)) ) )
                        {
                            // If the player's RadarTrans aug is off, the turret can see him
                            if (aplayer.AugmentationSystem.GetAugLevelValue(class'AugRadarTrans') == -1.0)
                            {
                                curTarget = apawn;
                                break;
                            }
                        }
                    }
                }
            }
      }
        apawn = apawn.nextPawn;
    }
   return curtarget;
}

defaultproperties
{
     swingAngle=8192
     swingPeriod=8.000000
     cameraFOV=4096
     cameraRange=1024
     memoryTime=5.000000
     bActive=True
     confusionDuration=10.000000
     triggerDelay=4.000000
     msgActivated="Camera activated"
     msgDeactivated="Camera deactivated"
     Team=-1
     HitPoints=50
     minDamageThreshold=50
     bInvincible=False
     FragType=Class'DeusEx.MetalFragment'
     ItemName="Surveillance Camera"
     Physics=PHYS_Rotating
     Texture=Texture'DeusExDeco.Skins.SecurityCameraTex2'
     Mesh=LodMesh'DeusExDeco.SecurityCamera'
     SoundRadius=48
     SoundVolume=192
     AmbientSound=Sound'DeusExSounds.Generic.CameraHum'
     CollisionRadius=10.720000
     CollisionHeight=11.000000
     LightType=LT_Steady
     LightBrightness=120
     LightHue=80
     LightSaturation=100
     LightRadius=1
     bRotateToDesired=True
     Mass=20.000000
     Buoyancy=5.000000
     RotationRate=(Pitch=65535,Yaw=65535)
     bVisionImportant=True
}
