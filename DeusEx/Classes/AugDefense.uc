//=============================================================================
// AugDefense.
//=============================================================================
class AugDefense extends Augmentation;

var float mpAugValue;
var float mpEnergyDrain;
//var bool bDefenseActive;

var float defenseSoundTime;
const defenseSoundDelay = 2;

// Vanilla Matters
var float VM_targetDistance;

var() float VM_defenseBaseCost;

// ----------------------------------------------------------------------------
// Networking Replication
// ----------------------------------------------------------------------------

replication
{
   // //server to client variable propagation.
   // reliable if (Role == ROLE_Authority)
   //    bDefenseActive;

   // //server to client function call
   // reliable if (Role == ROLE_Authority)
   //    TriggerDefenseAugHUD, SetDefenseAugStatus;
}

// Vanilla Matters: Gonna rewrite all that stuff above to optimize things and add new features.
state Active {
    function Timer() {
        local Actor target;
        local DeusExProjectile proj;

        local float cost;
        local bool enoughEnergy;
        local bool enoughDistance;

        if ( Level.NetMode != NM_Standalone ) {
            defenseSoundTime = defenseSoundTime + 0.1;

            if ( defenseSoundTime >= defenseSoundDelay ) {
                Player.PlaySound( Sound'AugDefenseOn', SLOT_Interact, 1.0,, LevelValues[CurrentLevel] * 1.33, 0.75 );
                defenseSoundTime = defenseSoundTime - defenseSoundDelay;
            }
        }

        target = FindNearestTarget();

        if ( target != None ) {
            proj = DeusExProjectile( target );

            cost = VM_defenseBaseCost;
            enoughEnergy = Player.CanDrain( cost );
            enoughDistance = ( VM_targetDistance <= LevelValues[CurrentLevel] );
            SetDefenseAugStatus( true, CurrentLevel, target, enoughEnergy, enoughDistance );

            Player.PlaySound( Sound'GEPGunLock', SLOT_None,,,, 2.0 );
        }
        else {
            SetDefenseAugStatus( false, CurrentLevel, none );
            // VM_defenseWeaponTime = 0;

            return;
        }

        if ( !enoughEnergy || !enoughDistance ) {
            return;
        }

        if ( proj != None ) {
            proj.bAggressiveExploded= true;
            proj.Explode( target.Location, vect( 0, 0, 1 ) );

            AddImmediateEnergyRate( cost );

            Player.PlaySound( Sound'ProdFire', SLOT_None,,,, 2.0 );
        }
    }

    function EndState() {
        SetTimer( 0.1, false );
    }

Begin:
    defenseSoundTime = 0;
    SetTimer( 0.1, true );
}

state Inactive {
Begin:
    SetDefenseAugStatus( false, CurrentLevel, none );
    defenseSoundTime = 0;
}

// ------------------------------------------------------------------------------
// FindNearestProjectile()
// DEUS_EX AMSD Exported to a function since it also needs to exist in the client
// TriggerDefenseAugHUD;
// ------------------------------------------------------------------------------

// Vanilla Matters: A new function that finds also ScriptedPawns attacking the player.
simulated function Actor FindNearestTarget() {
    local DeusExProjectile proj;
    local bool bValid;
    local float dist, mindist;

    local Actor target;

    target = None;
    mindist = LevelValues[CurrentLevel] * 3;
    foreach AllActors( class'DeusExProjectile', proj ) {
        dist = VSize( Player.Location - proj.Location );
        if ( dist > mindist ) {
            continue;
        }

        if (Level.NetMode != NM_Standalone ) {
            bValid = !proj.bIgnoresNanoDefense;
        }
        else {
            // VM: Gonna use a special condition for plasma bolts, because otherwise MIBs will be rendered useless.
            bValid = ( !proj.IsA( 'Cloud' ) && !proj.IsA( 'Tracer' ) && !proj.IsA( 'GreaselSpit' ) && !proj.IsA( 'GraySpit' ) && ( proj.bExplodes && !proj.IsA( 'PlasmaBolt' ) ) );
        }

        bValid = bValid && ( proj.Owner != Player && !( TeamDMGame( Player.DXGame ) != None && TeamDMGame( Player.DXGame ).ArePlayersAllied( DeusExPlayer( proj.Owner ), Player ) ) );

        bValid = bValid && Player.LineOfSightTo( proj );

        if ( bValid ) {
            if ( !proj.bStuck ) {
                mindist = dist;
                target = proj;
            }
        }
    }

    VM_targetDistance = mindist;

    return target;
}

// ------------------------------------------------------------------------------
// TriggerDefenseAugHUD()
// ------------------------------------------------------------------------------

// ------------------------------------------------------------------------------
// SetDefenseAugStatus()
// ------------------------------------------------------------------------------

// Vanilla Matters: Change it to use actor.
simulated function SetDefenseAugStatus( bool bDefenseActive, int defenseLevel, Actor defenseTarget, optional bool enoughEnergy, optional bool enoughDistance ) {
    if ( Player == None || Player.rootWindow == None ) {
        return;
    }

    DeusExRootWindow( Player.rootWindow ).hud.augDisplay.bDefenseActive = bDefenseActive;
    DeusExRootWindow( Player.rootWindow ).hud.augDisplay.defenseLevel = defenseLevel;
    DeusExRootWindow( Player.rootWindow ).hud.augDisplay.defenseTarget = defenseTarget;
    // VM: Pass this to the hud so it won't have to do the calculations again.
    DeusExRootWindow( Player.rootWindow ).hud.augDisplay.VM_bDefenseEnoughEnergy = enoughEnergy;
    DeusExRootWindow( Player.rootWindow ).hud.augDisplay.VM_bDefenseEnoughDistance = enoughDistance;
}

simulated function PreBeginPlay()
{
    Super.PreBeginPlay();

    // If this is a netgame, then override defaults
    if ( Level.NetMode != NM_StandAlone )
    {
        LevelValues[3] = mpAugValue;
        EnergyRate = mpEnergyDrain;
        defenseSoundTime=0;
    }
}

defaultproperties
{
     mpAugValue=500.000000
     mpEnergyDrain=10.000000
     VM_defenseBaseCost=2.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconDefense'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconDefense_Small'
     AugmentationName="Aggressive Defense System"
     Description="Aerosol nanoparticles are released upon the detection of objects fitting the electromagnetic threat profile of missiles and grenades; these nanoparticles will prematurely detonate such objects prior to reaching the agent.|n|n[TECH ONE]|nThe range at which hostile objects are detonated is short.|n|n[TECH TWO]|n+100% detonation range|n|n[TECH THREE]|n+200% detonation range|n|n[TECH FOUR]|nRockets and grenades are detonated almost before they are fired.|n+300% detonation range|n|nProjectile detonation costs 2 energy."
     MPInfo="When active, enemy rockets detonate when they get close, doing reduced damage.  Some large rockets may still be close enough to do damage when they explode.  Energy Drain: Very Low"
     LevelValues(0)=200.000000
     LevelValues(1)=400.000000
     LevelValues(2)=600.000000
     LevelValues(3)=800.000000
     MPConflictSlot=7
     VM_dragIcon=Texture'DeusEx.VMUI.AugIconDefense'
}
