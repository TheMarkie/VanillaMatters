class VMPlayer extends DeusExPlayer
    abstract;

enum EBodyPart {
    BodyPartHead,
    BodyPartTorso,
    BodyPartArmLeft,
    BodyPartArmRight,
    BodyPartLegLeft,
    BodyPartLegRight,
};

//==============================================
// Constants
//==============================================
const AutoSaveDelay = 180;

//==============================================
// Strings
//==============================================
var localized string BodyPartNamesLowercase[6];
var localized string MsgFullHealth;
var localized string MsgFullEnergy;
var localized string MsgTooMuchAmmo;
var localized string MsgChargedPickupAlready;
var localized string MsgUseChargedPickup;

//==============================================
// Configs
//==============================================
var globalconfig bool EnableAutoSave;
var globalconfig bool EnableForwardPressure;
var globalconfig bool EnableCheats;

//==============================================
// Saving
//==============================================
var travel int CurrentQSIndex;
var travel int CurrentASIndex;

var bool IsAutoSaving;
var float AutoSaveTimer;

//==============================================
// Systems
//==============================================
var transient DeusExLevelInfo LevelInfo;
var transient DeusExRootWindow DXRootWindow;

var travel ForwardPressure FPSystem;

var TableFloat GlobalModifiers;
var TableTableFloat CategoryModifiers;

var travel VMSkillManager VMSkillSystem;
var() array< class<VMSKill> > StartingSkills;

var travel VMAugmentationManager VMAugmentationSystem;
var() array< class<VMAugmentation> > StartingAugmentations;
var travel name AugmentationHotBar[11];

//==============================================
// Status
//==============================================
var travel Inventory LastPutAway;               // Last item in hand before PutInHand( None ).
var travel Inventory HeldInHand;                // Item being held.
var travel Inventory LastHeldInHand;            // Some temporary place to keep track of HeldInHand.

var byte ChargedPickupStatus[5];

//==============================================
// Properties
//==============================================
var travel float VisibilityNormal;
var travel float VisibilityRadar;

var travel int LastMissionNumber;               // Keep track of the last mission number in case the player transitions to a new mission.
var travel bool IsMapTravel;                    // Denote if a travel is a normal map travel or game load.

//==============================================
// Replication
//==============================================
replication {
    reliable if ( Role < ROLE_Authority )
        ParseLeftClick, ParseRightClick;
}

//==============================================
// Initializing and Startup
//==============================================
// Override
function PreTravel() {
    super.PreTravel();

    // Gotta do this to keep the held item from being added to the inventory.
    if ( HeldInHand != None ) {
        HeldInHand.SetOwner( None );
    }

    // Save current mission number and marks this as a normal map transition.
    if ( LevelInfo != None ) {
        LastMissionNumber = LevelInfo.MissionNumber;
    }
    else {
        LastMissionNumber = -3;
    }

    IsMapTravel = true;
}

// Override
event TravelPostAccept() {
    local int missionNumber;

    LevelInfo = FindLevelInfo();

    super.TravelPostAccept();

    DXRootWindow = DeusExRootWindow( rootWindow );

    if ( LevelInfo != none ) {
        missionNumber = LevelInfo.MissionNumber;
    }
    else {
        missionNumber = -3;
    }

    RefreshSubSystems();

    // Repair the held item since it's fucked up by vanilla coding.
    if ( HeldInHand != None ) {
        LastHeldInHand = HeldInHand;

        // Gotta do all this to make sure the item is removed properly.
        RemoveItemFromSlot( HeldInHand );
        HeldInHand.DropFrom( Location );
        HeldInHand = None;

        if ( TakeHold( LastHeldInHand ) ) {
            LastHeldInHand = None;
        }
        // Gotta destroy it if it can't be held again for whatever reason.
        else {
            LastHeldInHand.Destroy();
            LastHeldInHand = None;
        }
    }

    // Setup the existing FP system and reset the FP zones.
    if ( FPSystem != none ) {
        FPSystem.SetPlayer( self );
        FPSystem.ResetZoneInfo();
    }

    // If this is a mission transition, applies FP rate, if a normal map transition, keep current FP meter.
    // Assume the player only moves forward in missions, which is currently true. Also lastMission is set to -3 incase level info can't be found.
    if ( LastMissionNumber != -3 && LevelInfo.MissionNumber > LastMissionNumber ) {
        AddForwardPressure( 1, 'Critical' );
    }

    // If a save was loaded, reset forward pressure if the FP system exists, otherwise initialize it because probably a save from pre-FPSystem update was loaded.
    if ( !IsMapTravel ) {
        if ( FPSystem != none ) {
            FPSystem.Reset();
        }
        else {
            FPSystem = Spawn( class'ForwardPressure', self );
            FPSystem.Initialize( self );
            FPSystem.SetOwner( self );
        }
    }

    // Always set this back to false in case the player saves while it's true.
    IsMapTravel = false;

    // Apply cheating status.
    if ( Level.NetMode == NM_Standalone ) {
        bCheatsEnabled = EnableCheats;
    }
}

// Override
function InitializeSkillSystem() {
    local int i;

    VMSkillSystem = Spawn( class'VMSkillManager', self );
    VMSkillSystem.Initialize( self );

    // Start in reverse because we're adding to a linked list.
    for ( i = #StartingSkills - 1; i >= 0; i-- ) {
        VMSkillSystem.Add( StartingSkills[i].Name, StartingSkills[i].Outer.Name );
    }
}

// Override
function InitializeAugmentationSystem() {
    local int i;

    VMAugmentationSystem = Spawn( class'VMAugmentationManager', self );
    VMAugmentationSystem.Initialize( self );

    // Start in reverse because we're adding to a linked list.
    for ( i = #StartingAugmentations - 1; i >= 0; i-- ) {
        VMAugmentationSystem.Add( StartingAugmentations[i].Name, StartingAugmentations[i].Outer.Name );
    }
}

function RefreshSubSystems() {
    if ( GlobalModifiers == none ) {
        GlobalModifiers = new class'TableFloat';
    }
    GlobalModifiers.Clear();
    if ( CategoryModifiers == none ) {
        CategoryModifiers = new class'TableTableFloat';
    }
    CategoryModifiers.Clear();

    if ( FPSystem == none ) {
        FPSystem = Spawn( class'ForwardPressure', self );
        FPSystem.Initialize( self );
    }
    else {
        FPSystem.SetPlayer( self );
    }
    FPSystem.SetOwner( self );

    if ( VMSkillSystem == none ) {
        InitializeSkillSystem();
    }
    else {
        VMSkillSystem.Refresh( self );
    }

    if ( VMAugmentationSystem == none ) {
        InitializeAugmentationSystem();
    }
    else {
        VMAugmentationSystem.Refresh( self );
    }
    RefreshAugmentationDisplay();
}

function ResetSubSystems() {
    if ( GlobalModifiers == none ) {
        GlobalModifiers = new class'TableFloat';
    }
    GlobalModifiers.Clear();
    if ( CategoryModifiers == none ) {
        CategoryModifiers = new class'TableTableFloat';
    }
    CategoryModifiers.Clear();

    if ( FPSystem == none ) {
        FPSystem = Spawn( class'ForwardPressure', self );
        FPSystem.Initialize( self );
    }
    else {
        FPSystem.Reset();
    }

    if ( VMSkillSystem == none ) {
        InitializeSkillSystem();
    }
    else {
        VMSkillSystem.Reset();
    }

    if ( VMAugmentationSystem == none ) {
        InitializeAugmentationSystem();
    }
    else {
        VMAugmentationSystem.Reset();
    }
    RefreshAugmentationDisplay();
}

//==============================================
// Updating
//==============================================
// We handle updating our own stuff here.
function VMPlayerTick( float deltaTime ) {
    UpdateChargedPickupStatus();

    // Calculate visibility values for this frame.
    UpdateVisibility();

    // Build forward pressure as you move.
    if ( FPSystem != none ) {
        FPSystem.BuildForwardPressure( deltaTime );
    }

    if ( EnableAutoSave && IsAutoSaving ) {
        if ( dataLinkPlay == none ) {
            AutoSaveTimer = AutoSaveTimer - deltaTime;
            if ( AutoSaveTimer <= 0 ) {
                AutoSave();
            }
        }
    }
}

// Override
function MaintainEnergy( float deltaTime ) {
    local Float energyUse;

    if ( !IsInState( 'Dying' ) && !IsInState( 'Paralyzed' ) ) {
        if ( Energy > 0 ) {
            energyUse = TickAllAugmentations( deltaTime ) * ( 1 - GetValue( 'EnergyUseReduction' ) );
            Energy -= energyUse;

            AddForwardPressure( energyUse, 'Energy' );

            // Calculate the energy drain due to EMP attacks
            if ( EnergyDrain > 0 ) {
                energyUse = EnergyDrainTotal * deltaTime;
                Energy -= EnergyUse;
                EnergyDrain -= EnergyUse;
                if ( EnergyDrain <= 0 ) {
                    EnergyDrain = 0;
                    EnergyDrainTotal = 0;
                }

                AddForwardPressure( energyUse, 'Damage' );
            }

            if ( Energy <= 0 ) {
                ClientMessage( EnergyDepleted );
                Energy = 0;
                EnergyDrain = 0;
                EnergyDrainTotal = 0;
            }
        }
        else {
            DeactivateAllAugmentations();
        }
    }
}

// Vanilla Matters: Update visibility values.
function UpdateVisibility() {
    local bool adaptiveOn;

    adaptiveOn = UsingChargedPickup( class'AdaptiveArmor' );

    if ( adaptiveOn ) {
        VisibilityRadar = 0;
    }
    else {
        VisibilityRadar = AIVisibility();
    }

    VisibilityRadar *= FMax( 1 - GetValue( 'RadarVisibilityReductionMult' ), 0 );

    if ( adaptiveOn ) {
        VisibilityNormal = 0;
    }
    else {
        VisibilityNormal = AIVisibility();
    }

    VisibilityNormal *= FMax( 1 - GetValue( 'NormalVisibilityReductionMult' ), 0 );
}

// Vanilla Matters: Update the activation status of every type of charged pickups.
function UpdateChargedPickupStatus() {
    local int i;
    local Inventory item;

    for ( i = 0; i < 5; i++ ) {
        ChargedPickupStatus[i] = 0;
    }

    item = Inventory;
    while ( item != none ) {
        if ( ChargedPickup( item ) != none && item.bActive ) {
            if ( AdaptiveArmor( item ) != none ) {
                ChargedPickupStatus[0] = 1;
            }
            else if ( BallisticArmor( item ) != none ) {
                ChargedPickupStatus[1] = 1;
            }
            else if ( HazMatSuit( item ) != none ) {
                ChargedPickupStatus[2] = 1;
            }
            else if ( Rebreather( item ) != none ) {
                ChargedPickupStatus[3] = 1;
            }
            else if ( TechGoggles( item ) != none ) {
                ChargedPickupStatus[4] = 1;
            }
        }

        item = item.Inventory;
    }
}

// Override
event PlayerTick( float deltaTime ) {
    // Update our stuff first.
    VMPlayerTick( deltaTime );

    super.PlayerTick( deltaTime );
}

state PlayerWalking {
    event PlayerTick( float deltaTime ) {
        VMPlayerTick( deltaTime );

        super.PlayerTick( deltaTime );
    }

    // lets us affect the player's movement
    function ProcessMove ( float deltaTime, vector newAccel, eDodgeDir dodgeMove, rotator deltaRot ) {
        local int newSpeed, defaultSpeed;
        local vector HitLocation, HitNormal, checkpoint, downcheck;
        local Actor HitActor, HitActorDown;
        local bool bCantStandUp;
        local Vector loc, traceSize;
        local float alpha, maxLeanDist;

        if ( VMAugmentationSystem != none ) {
            if ( VMAugmentationSystem.ProcessMove( deltaTime ) ) {
                return;
            }
        }

        defaultSpeed = GetCurrentGroundSpeed();

        if ( bIsCrouching || bForceDuck ) {
            SetBasedPawnSize( default.CollisionRadius, 16 );

            // check to see if we could stand up if we wanted to
            checkpoint = Location;
            // check normal standing height
            checkpoint.Z = checkpoint.Z - CollisionHeight + 2 * GetDefaultCollisionHeight();
            traceSize.X = CollisionRadius;
            traceSize.Y = CollisionRadius;
            traceSize.Z = 1;
            HitActor = Trace( HitLocation, HitNormal, checkpoint, Location, true, traceSize );
            bCantStandUp = HitActor != none;
        }
        else {
            GroundSpeed = defaultSpeed;
            if ( !IsLeaning() ) {
                ResetBasedPawnSize();
            }
        }

        bForceDuck = bCantStandUp;

        // if the player's legs are damaged, then reduce our speed accordingly
        newSpeed = defaultSpeed;

        if ( Level.NetMode == NM_Standalone ) {
            if ( HealthLegLeft < 1 ) {
                newSpeed -= defaultSpeed * 0.5 * 0.2;
            }
            else if ( HealthLegLeft < 34 ) {
                newSpeed -= defaultSpeed * 0.5 * 0.15;
            }
            else if ( HealthLegLeft < 67 ) {
                newSpeed -= defaultSpeed * 0.5 * 0.10;
            }

            if ( HealthLegRight < 1 ) {
                newSpeed -= defaultSpeed * 0.5 * 0.2;
            }
            else if ( HealthLegRight < 34 ) {
                newSpeed -= defaultSpeed * 0.5 * 0.15;
            }
            else if ( HealthLegRight < 67 ) {
                newSpeed -= defaultSpeed * 0.5 * 0.10;
            }

            if ( HealthTorso < 67 ) {
                newSpeed -= defaultSpeed * 0.5 * 0.05;
            }
        }

        // let the player pull themselves along with their hands even if both of
        // their legs are blown off
        if ( HealthLegLeft < 1 && HealthLegRight < 1 ) {
            bIsWalking = true;
            bForceDuck = true;
        }
        else if ( bIsCrouching || bForceDuck ) {
            bIsWalking = true;
        }

        // slow the player down if he's carrying something heavy
        // Like a DEAD BODY!  AHHHHHH!!!
        if ( CarriedDecoration != none ) {
            newSpeed -= CarriedDecoration.Mass * 2;
        }
        else if ( inHand != none && inHand.IsA( 'POVCorpse' ) ) {
            newSpeed -= inHand.Mass * 3;
        }

        // Vanilla Matters: Change heavy weapon penalty check to apply a direct penalty instead of level check
        if ( Weapon != none && Weapon.Mass > 30 ) {
            newSpeed = defaultSpeed * ( 0.5 + GetValue( 'HeavyWeaponMovementSpeedBonus' ) );
        }

        // if we are moving really slow, force us to walking
        // Vanilla Matters: Change walking to start at half running speed
        if ( newSpeed <= ( defaultSpeed / 2 ) && !bForceDuck ) {
            bIsWalking = true;
            newSpeed = defaultSpeed;
        }

        GroundSpeed = FMax( newSpeed, 100 );

        // check leaning buttons (axis aExtra0 is used for leaning)
        maxLeanDist = 40;

        if ( IsLeaning() ) {
            if ( PlayerIsClient() || Level.NetMode == NM_Standalone ) {
                ViewRotation.Roll = curLeanDist * 20;
            }

            if ( !bIsCrouching && !bForceDuck ) {
                SetBasedPawnSize( CollisionRadius, GetDefaultCollisionHeight() - Abs( curLeanDist ) / 3.0 );
            }
        }

        if ( bCanLean && aExtra0 != 0 ) {
            DropDecoration();
            if ( AnimSequence != 'CrouchWalk' ) {
                PlayCrawling();
            }

            alpha = maxLeanDist * aExtra0 * 2.0 * deltaTime;

            loc = vect( 0,0,0 );
            loc.Y = alpha;
            if ( Abs( curLeanDist + alpha ) < maxLeanDist ) {
                // check to make sure the destination not blocked
                checkpoint = ( loc >> Rotation ) + Location;
                traceSize.X = CollisionRadius;
                traceSize.Y = CollisionRadius;
                traceSize.Z = CollisionHeight;
                HitActor = Trace( HitLocation, HitNormal, checkpoint, Location, true, traceSize );

                // check down as well to make sure there's a floor there
                downcheck = checkpoint - vect( 0, 0, 1 ) * CollisionHeight;
                HitActorDown = Trace( HitLocation, HitNormal, downcheck, checkpoint, true, traceSize );
                if ( HitActor == none && HitActorDown != none ) {
                    if ( PlayerIsClient() || Level.NetMode == NM_Standalone ) {
                        SetLocation( checkpoint );
                        ServerUpdateLean( checkpoint );
                        curLeanDist += alpha;
                    }
                }
            }
            else {
                if ( PlayerIsClient() || Level.NetMode == NM_Standalone ) {
                    curLeanDist = aExtra0 * maxLeanDist;
                }
            }
        }
        else if ( IsLeaning() ) {
            if ( AnimSequence == 'CrouchWalk' ) {
                PlayRising();
            }

            if ( PlayerIsClient() || Level.NetMode == NM_Standalone ) {
                prevLeanDist = curLeanDist;
                alpha = FClamp( 7.0 * DeltaTime, 0.001, 0.9 );
                curLeanDist *= 1.0 - alpha;
                if ( Abs( curLeanDist ) < 1.0 ) {
                    curLeanDist = 0;
                }
            }

            loc = vect( 0,0,0 );
            loc.Y = -( prevLeanDist - curLeanDist );

            // check to make sure the destination not blocked
            checkpoint = ( loc >> Rotation ) + Location;
            traceSize.X = CollisionRadius;
            traceSize.Y = CollisionRadius;
            traceSize.Z = CollisionHeight;
            HitActor = Trace( HitLocation, HitNormal, checkpoint, Location, true, traceSize );

            // check down as well to make sure there's a floor there
            downcheck = checkpoint - vect( 0,0,1 ) * CollisionHeight;
            HitActorDown = Trace( HitLocation, HitNormal, downcheck, checkpoint, true, traceSize );
            if ( HitActor == none && HitActorDown != none )
            {
                if ( PlayerIsClient() || Level.NetMode == NM_Standalone ) {
                    SetLocation( checkpoint );
                    ServerUpdateLean( checkpoint );
                }
            }
        }

        super.ProcessMove( deltaTime, newAccel, dodgeMove, deltaRot );
    }
}

state PlayerFlying {
    // Override
    event PlayerTick( float deltaTime ) {
        VMPlayerTick( deltaTime );

        super.PlayerTick( deltaTime );
    }
}

state PlayerSwimming {
    // Override
    event PlayerTick( float deltaTime ) {
        VMPlayerTick( deltaTime );

        super.PlayerTick( deltaTime );
    }
}

//==============================================
// Saving and Loading
//==============================================
// Override
exec function QuickSave() {
    // Don't allow saving if:
    // 1) The player is dead
    // 2) We're on the logo map
    // 4) We're interpolating (playing outro)
    // 3) A datalink is playing
    // 4) We're in a multiplayer game

    if ( !ShouldSave() ) {
        return;
    }

    // Disable quicksaving depending on Forward Pressure.
    if ( FPSystem != none ) {
        if ( EnableForwardPressure ) {
            if ( !FPSystem.IsFull() ) {
                return;
            }
        }

        FPSystem.Reset();
    }

    // Allow two quick save slots.
    // We're gonna handle slot indexing before saving so that the variable always holds the index of the last quick save.
    if ( CurrentQSIndex != -3 ) {
        CurrentQSIndex = -3;
    }
    else if ( CurrentQSIndex != -4 ) {
        CurrentQSIndex = -4;
    }

    SaveGame( CurrentQSIndex, QuickSaveGameTitle @ "-" @ TruePlayerName @ "-" @ LevelInfo.MissionLocation );
}

// Override
function RequestAutoSave( optional float delay ) {
    IsAutoSaving = true;
    AutoSaveTimer = delay;
}
// Handle auto save.
function AutoSave() {
    if ( !ShouldSave() ) {
        return;
    }

    if ( CurrentASIndex != -5 ) {
        CurrentASIndex = -5;
    }
    else if ( CurrentASIndex != -6 ) {
        CurrentASIndex = -6;
    }

    IsAutoSaving = false;
    AutoSaveTimer = 0;

    SaveGame( CurrentASIndex, "Auto Save -" @ TruePlayerName @ "-" @ LevelInfo.MissionLocation );
}

function bool ShouldSave() {
    if ( IsInMainMenu()
        || dataLinkPlay != none
        || Level.NetMode != NM_Standalone
    ) {
        return false;
    }
    else {
        return true;
    }
}

exec function QuickLoad() {
    if ( Level.Netmode != NM_Standalone ) {
        return;
    }

    DXRootWindow.ConfirmQuickLoad();
}

function QuickLoadConfirmed() {
    if ( Level.Netmode != NM_Standalone ) {
        return;
    }

    LoadGame( CurrentQSIndex );
}

function bool IsInMainMenu() {
    if ( LevelInfo == none || LevelInfo.MissionNumber < 0 || LevelInfo.MissionLocation == ""
        || IsInState( 'Dying' ) || IsInState( 'Paralyzed' ) || IsInState( 'Interpolating' )
    ) {
        return true;
    }
    else {
        return false;
    }
}

//==============================================
// Rendering
//==============================================
// Override: Add cloaking support
function SetSkinStyle( ERenderStyle newStyle, optional texture newTex, optional float newScaleGlow ) {
    local int i;
    local texture curSkin;

    if ( newScaleGlow == 0 ) {
        newScaleGlow = ScaleGlow;
    }

    for ( i = 0; i < 8; i++ ) {
        curSkin = GetMeshTexture( i );
        MultiSkins[i] = GetStyleTexture( newStyle, curSkin, newTex );
    }

    Skin = GetStyleTexture( newStyle, Skin, newTex );
    ScaleGlow = newScaleGlow;
    Style = newStyle;
}

// Override
function ResetSkinStyle() {
    local int i;

    for ( i = 0; i < 8; i++ ) {
        MultiSkins[i] = Default.MultiSkins[i];
    }

    // Copied from JCDentonMale to deal with skin colors. Pretty much a hack.
    switch( PlayerSkin ) {
        case 0:
            MultiSkins[0] = Texture'JCDentonTex0';
            break;
        case 1:
            MultiSkins[0] = Texture'JCDentonTex4';
            break;
        case 2:
            MultiSkins[0] = Texture'JCDentonTex5';
            break;
        case 3:
            MultiSkins[0] = Texture'JCDentonTex6';
            break;
        case 4:
            MultiSkins[0] = Texture'JCDentonTex7';
            break;
    }

    Skin = Default.Skin;
    ScaleGlow = Default.ScaleGlow;
    Style = Default.Style;
}

// Override
function Texture GetStyleTexture( ERenderStyle newStyle, texture oldTex, optional texture newTex ) {
    local texture defaultTex;

    if ( newStyle == STY_Translucent ) {
        defaultTex = Texture'BlackMaskTex';
    }
    else if ( newStyle == STY_Modulated ) {
        defaultTex = Texture'GrayMaskTex';
    }
    else if ( newStyle == STY_Masked ) {
        defaultTex = Texture'PinkMaskTex';
    }
    else {
        defaultTex = Texture'BlackMaskTex';
    }

    if ( oldTex == None ) {
        return defaultTex;
    }
    else if ( oldTex == Texture'BlackMaskTex' ) {
        return Texture'BlackMaskTex';
    }
    else if ( oldTex == Texture'GrayMaskTex' ) {
        return defaultTex;
    }
    else if ( oldTex == Texture'PinkMaskTex' ) {
        return defaultTex;
    }
    else if ( newTex != None ) {
        return newTex;
    }
    else {
        return oldTex;
    }
}

// Override: Return the appropriate colored skin.
function Texture GetHandsSkin() {
    switch( PlayerSkin ) {
        case 1:
            return Texture'DeusEx.VM.WeaponHandsTex1a';
        case 2:
            return Texture'DeusEx.VM.WeaponHandsTex2a';
        case 3:
            return Texture'DeusEx.VM.WeaponHandsTex3a';
        case 4:
            return Texture'DeusEx.VM.WeaponHandsTex4a';
        default:
            return Texture'DeusEx.VM.WeaponHandsTex3a';
    }
}

// Override
function Texture GetCrossbowHandsSkin() {
    switch( PlayerSkin ) {
        case 1:
            return Texture'DeusEx.VM.WeaponHandsTex1b';
        case 2:
            return Texture'DeusEx.VM.WeaponHandsTex2b';
        case 3:
            return Texture'DeusEx.VM.WeaponHandsTex3b';
        case 4:
            return Texture'DeusEx.VM.WeaponHandsTex4b';
        default:
            return Texture'DeusEx.VM.WeaponHandsTex3b';
    }
}

//==============================================
// State Callbacks
//==============================================
// Override
function Landed( vector HitNormal ) {
    local vector legLocation;
    local int augLevel;
    local float augReduce, dmg;

    PlayLanded( Velocity.Z );

    if ( Velocity.Z < -1.4 * JumpZ ) {
        MakeNoise( -0.5 * Velocity.Z / ( FMax( JumpZ, 150.0 ) ) );

        if ( Velocity.Z < -700 && ReducedDamageType != 'All' ) {
            if ( Role == ROLE_Authority ) {
                dmg = Max( ( -0.16 * ( Velocity.Z + 700 ) ), 0 );
                if ( dmg > 0 ) {
                    legLocation = Location + vect( -1, 0, -1 );
                    TakeDamage( dmg, none, legLocation, vect( 0, 0, 0 ), 'Fell' );

                    legLocation = Location + vect( 1, 0, -1 );
                    TakeDamage( dmg, none, legLocation, vect( 0, 0, 0 ), 'Fell' );
                }

                dmg = Max( ( -0.06 * ( Velocity.Z + 700 ) ), 0 );
                if ( dmg > 0 ) {
                    legLocation = Location + vect( 0, 0, 1 );
                    TakeDamage( dmg, none, legLocation, vect( 0, 0, 0 ), 'Fell' );
                }
            }
        }
    }
    else if ( Velocity.Z > 0.5 * JumpZ ) {
        MakeNoise( 0.1 * CombatDifficulty );
    }

    bJustLanded = true;
}

// Override
function Timer() {
    if ( !InConversation() && bOnFire ) {
        UpdateFire();
    }
}

//==============================================
// Inputs
//==============================================
// Override
exec function ParseLeftClick() {
    local Inventory item;
    local VMAugmentationInfo aug;
    local ChargedPickup cpickup;

    if ( RestrictInput() ) {
        return;
    }

    if ( VMAugmentationSystem != none ) {
        if ( VMAugmentationSystem.ParseLeftClick() ) {
            return;
        }
    }

    if ( inHand != none && !bInHandTransition ) {
        // Prevent the player from activating two charged pickups of the same type at the same time.
        if ( inHand.bActivatable ) {
            cpickup = ChargedPickup( inHand );
            if ( cpickup != none ) {
                if ( UsingChargedPickup( cpickup.class ) ) {
                    if ( cpickup.IsActive() ) {
                        cpickup.Activate();
                    }
                    else {
                        ClientMessage( MsgChargedPickupAlready );
                    }
                }
                // If the charged pickup is being held, tries to put it in the inventory then activate it.
                else if ( IsHolding( inHand ) ) {
                    if ( FindInventorySlot( inHand, true ) ) {
                        // Save inHand since it's gonna be wiped. We're also activating it AFTER it's been picked up, just to be safe.
                        item = inHand;
                        ParseRightClick();
                        item.Activate();
                    }
                    else {
                        ClientMessage( MsgUseChargedPickup );
                    }
                }
                else {
                    inHand.Activate();
                }
            }
            else {
                // Prevent using these consumables if we're at full something.
                if ( MedKit( inHand ) != none && Health >= default.Health ) {
                    ClientMessage( MsgFullHealth );

                    return;
                }
                else if ( BioelectricCell( inHand ) != none && Energy >= EnergyMax ) {
                    ClientMessage( MsgFullEnergy );

                    return;
                }

                inHand.Activate();
            }
        }
        else if ( FrobTarget != none ) {
            // special case for using keys or lockpicks on doors
            if ( DeusExMover( FrobTarget ) != none ) {
                if ( NanoKeyRing( inHand ) != none || Lockpick( inHand ) != none ) {
                    DoFrob( self, inHand );
                }
            }

            // special case for using multitools on hackable things
            if ( HackableDevices( FrobTarget ) != none )
            {
                if ( Multitool( inHand ) != none ) {
                    if ( Level.Netmode != NM_Standalone
                        && TeamDMGame( DXGame ) != none
                        && AutoTurretGun( FrobTarget ) != none
                        && AutoTurretGun( FrobTarget ).team == PlayerReplicationInfo.team
                    ) {
                        MultiplayerNotifyMsg( MPMSG_TeamHackTurret );

                        return;
                    }
                    else {
                        DoFrob( self, inHand );
                    }
                }
            }
        }
    }
    // Allow holding pickups in hands.
    else if ( inHand == None ) {
        if ( FrobTarget != None ) {
            TakeHold( Inventory( FrobTarget ), true );
        }
        else if ( LastPutAway != None ) {
            PutInHand( LastPutAway );
        }
    }
}

// Override
exec function ParseRightClick() {
    local AutoTurret turret;
    local int viewIndex;
    local bool ownedByPlayer;
    local Inventory item, oldFirstItem, oldInHand;
    local Decoration oldCarriedDecoration;
    local Vector loc;
    local bool needKey;
    local DeusExMover mover;
    local HackableDevices hackable;
    local ThrownProjectile thrown;
    local ComputerSecurity computer;

    if ( RestrictInput() ) {
        return;
    }

    item = Inventory( FrobTarget );
    oldFirstItem = Inventory;
    oldInHand = inHand;
    oldCarriedDecoration = CarriedDecoration;

    // Queue the held item so that it can be picked up.
    if ( IsHolding( inHand ) && FrobTarget == none ) {
        FrobTarget = HeldInHand;

        // Gotta do this so that the item can be frobbed properly, since item state and pickup state are different.
        LastHeldInHand = HeldInHand;
        HeldInHand.DropFrom( Location );
        HeldInHand = none;
    }

    if ( FrobTarget != none ) {
        loc = FrobTarget.Location;
    }

    if ( FrobTarget != none ) {
        mover = DeusExMover( FrobTarget );
        hackable = HackableDevices( FrobTarget );

        if ( NanoKey( FrobTarget ) != none ) {
            PickupNanoKey( NanoKey( FrobTarget ) );
            FrobTarget.Destroy();
            FrobTarget = none;
            LastHeldInHand = none;

            return;
        }
        else if ( item != none ) {
            // Allow taking hold of an item if the player can't pick it up.
            if ( !HandleItemPickup( item, true ) ) {
                if ( TakeHold( item ) ) {
                    if ( WasHolding( item ) ) {
                        LastHeldInHand = None;
                    }
                }

                return;
            }

            // Fix some dumb accessed none due to the fact some inventory items just self-destruct on frob, haha very funny Ion Storm. Also the vanilla code looks ugly so.
            if ( FrobTarget != none
                && ( ( Level.NetMode == NM_Standalone && FrobTarget.Owner == Self )
                    || ( Level.NetMode != NM_Standalone && oldFirstItem != Inventory )
                )
            ) {
                if ( Level.NetMode == NM_Standalone ) {
                    FindInventorySlot( item );
                }
                else {
                    FindInventorySlot( Inventory );
                }

                FrobTarget = none;
            }

            LastHeldInHand = none;
        }
        else if ( Decoration( FrobTarget ) != none && Decoration( FrobTarget ).bPushable ) {
            GrabDecoration();
        }
        // If we frob a locked mover, bring up the lockpick, if it can't be picked, then bring up the keyring if it's unlockable that way.
        else if ( inHand == none
            && mover != none && mover.bHighlight && mover.bLocked
            && ( ( mover.bPickable && mover.lockStrength > 0 ) || mover.KeyIDNeeded != '' )
        ) {
            needKey = ( mover.KeyIDNeeded != '' && !mover.bPickable );

            if ( needKey ) {
                BringUpItem( 'NanoKeyRing' );
            }
            else {
                BringUpItem( 'Lockpick' );
            }
        }
        // Do the same for multitool-able devices, but not keypads.
        else if ( inHand == none && hackable != none && hackable.bHighlight && Keypad( FrobTarget ) == none && hackable.hackStrength > 0 && hackable.bHackable ) {
            BringUpItem( 'Multitool' );
        }
        else {
            if ( Level.NetMode != NM_Standalone && TeamDMGame( DXGame ) != none ) {
                thrown = ThrownProjectile( FrobTarget );
                if ( thrown != none ) {
                    if ( thrown.team == PlayerReplicationInfo.team && thrown.Owner != self ) {
                        // You can re-enable a grenade for a teammate
                        if ( thrown.bDisabled ) {
                            thrown.ReEnable();

                            return;
                        }

                        MultiplayerNotifyMsg( MPMSG_TeamLAM );

                        return;
                    }
                }

                computer = ComputerSecurity( FrobTarget );
                if ( computer != none && computer.team == PlayerReplicationInfo.team ) {
                    // Let controlling player re-hack his/her own computer
                    ownedByPlayer = false;
                    foreach AllActors( class'AutoTurret', turret ) {
                        for ( viewIndex = 0; viewIndex < ArrayCount( computer.Views ); viewIndex++ ) {
                            if ( computer.Views[viewIndex].turretTag == turret.Tag ) {
                                if ( turret.safeTarget == self || turret.savedTarget == self ) {
                                    ownedByPlayer = true;

                                    break;
                                }
                            }
                        }
                    }

                    if ( !ownedByPlayer ) {
                        MultiplayerNotifyMsg( MPMSG_TeamComputer );

                        return;
                    }
                }
            }

            // otherwise, just frob it
            DoFrob( self, none );
        }
    }
    else {
        // if there's no FrobTarget, put away an inventory item or drop a decoration
        // or drop the corpse
        if ( inHand != none && POVCorpse( inHand ) != none ) {
            DropItem();
        }
        else {
            PutInHand( none );
        }
    }

    if ( oldInHand == none && inHand != none ) {
        PlayPickupAnim( loc );
    }
    else if ( oldCarriedDecoration == none && CarriedDecoration != none ) {
        PlayPickupAnim( loc );
    }
}

// Rewrite aug activativation functions to be clearer.
exec function AugSlot1() { ToggleAugmentation( AugmentationHotBar[0] ); }
exec function AugSlot2() { ToggleAugmentation( AugmentationHotBar[1] ); }
exec function AugSlot3() { ToggleAugmentation( AugmentationHotBar[2] ); }
exec function AugSlot4() { ToggleAugmentation( AugmentationHotBar[3] ); }
exec function AugSlot5() { ToggleAugmentation( AugmentationHotBar[4] ); }
exec function AugSlot6() { ToggleAugmentation( AugmentationHotBar[5] ); }
exec function AugSlot7() { ToggleAugmentation( AugmentationHotBar[6] ); }
exec function AugSlot8() { ToggleAugmentation( AugmentationHotBar[7] ); }
exec function AugSlot9() { ToggleAugmentation( AugmentationHotBar[8] ); }
exec function AugSlot10() { ToggleAugmentation( AugmentationHotBar[9] ); }

// Flashlight now has its own key and function.
exec function ToggleFlashlight() {
    ToggleAugmentation( AugmentationHotBar[10] );
}

//==============================================
// Actions
//==============================================
function DoJump( optional float F ) {
    if ( ( CarriedDecoration != none && CarriedDecoration.Mass > 20 )
        || ( bForceDuck || IsLeaning() )
        || Physics != PHYS_Walking
    ) {
        return;
    }

    if ( Role == ROLE_Authority ) {
        PlaySound( JumpSound, SLOT_None, 1.5, true, 1200, 1.0 - 0.2 * FRand() );
    }

    MakeNoise( 0.1 * CombatDifficulty );

    PlayInAir();

    Velocity.Z = JumpZ * ( 1 + GetValue( 'JumpVelocityBonusMult' ) );

    if ( Base != Level ) {
        Velocity.Z += Base.Velocity.Z;
    }

    SetPhysics( PHYS_Falling );
}

//==============================================
// Status Management
//==============================================
// Override to optimize
function bool UsingChargedPickup( class<ChargedPickup> itemClass ) {
    local int i;

    if ( itemClass == class'AdaptiveArmor' ) {
        i = 0;
    }
    else if ( itemClass == class'BallisticArmor' ) {
        i = 1;
    }
    else if ( itemClass == class'HazMatSuit' ) {
        i = 2;
    }
    else if ( itemClass == class'Rebreather' ) {
        i = 3;
    }
    else if ( itemClass == class'TechGoggles' ) {
        i = 4;
    }
    else {
        return false;
    }

    return ChargedPickupStatus[i] > 0;
}

// Fetch the currently active charged pickup from the inventory, there can be only one so we're good.
function ChargedPickup GetActiveChargedPickup( class<ChargedPickup> itemclass ) {
    local inventory item;

    for ( item = Inventory; item != None; item = item.inventory ) {
        if ( item.class == itemclass && item.bActive ) {
            return ChargedPickup( item );
        }
    }

    return None;
}

// Combat status
// Override
function bool IsInCombat() {
    local Pawn pawn;
    local ScriptedPawn scriptedPawn;

    for ( pawn = Level.PawnList; pawn != None; pawn = pawn.NextPawn ) {
        scriptedPawn = ScriptedPawn( pawn );
        if ( scriptedPawn != none && VSize( scriptedPawn.Location - Location ) < ( 1600 + scriptedPawn.CollisionRadius ) ) {
            if ( scriptedPawn.GetStateName() == 'Attacking' && scriptedPawn.Enemy == self ) {
                return true;
            }
        }
    }
    return false;
}

//==============================================
// Item Management
//==============================================
// Override
exec function PutInHand( optional Inventory inv ) {
    if ( RestrictInput() ) {
        return;
    }

    if ( inHand != none && inHand.IsA( 'POVCorpse' ) ) {
        return;
    }

    // Can't put away pickups that are active like fire extinguishers.
    if ( IsHolding( inHand ) ) {
        if ( inHand.bActive ) {
            return;
        }

        // If it's being held, meaning it can disappear forever if switched away, then drop it. If that fails, denies putting in hand.
        if ( !DropItem() ) {
            return;
        }
    }

    if ( inv != none ) {
        if ( inv.IsA( 'Ammo' ) ) {
            return;
        }

        // Only non-toggleable charged pickups get the vanilla behaviors. Defined by the bOneUseOnly property.
        if ( ChargedPickup( inv ) != none && ChargedPickup( inv ).IsActive() && ChargedPickup( inv ).bOneUseOnly ) {
            return;
        }

        // Toggle the laser on automatically.
        if ( DeusExWeapon( inv ) != None && DeusExWeapon( inv ).bHasLaser ) {
            DeusExWeapon( inv ).LaserOn();
        }
    }
    // Vanilla Matters: If putting None in hand then saves the previous inHand item.
    else if ( inHand != None ) {
        LastPutAway = inHand;
    }


    if ( CarriedDecoration != none ) {
        DropDecoration();
    }

    SetInHandPending( inv );
}

// Check if the player last put this item away.
function bool WasLastPutAway( Inventory item ) {
    return ( LastPutAway != none && item == LastPutAway );
}
function ClearLastPutAway() {
    LastPutAway = none;
}

// Check if the player is holding this item.
function bool IsHolding( Inventory item ) {
    return ( HeldInHand != none && item == HeldInHand );
}
// Check if the player was holding this item.
function bool WasHolding( Inventory item ) {
    return ( LastHeldInHand != none && item == LastHeldInHand );
}
// Check if the conditions are suitable for taking hold of an item.
function bool CanBeHeld( Inventory item ) {
    local DeusExPickup pickup;

    pickup = DeusExPickup( item );

    if ( pickup != none && HeldInHand == none && inHand == none && CarriedDecoration == none ) {
        return true;
    }

    return false;
}
// Transform the item and put it in holding.
function bool TakeHold( Inventory item, optional bool frobOnFail, optional bool ignoresActive ) {
    local DeusExPickup pickup;

    if ( CanBeHeld( item ) ) {
        pickup = DeusExPickup( item );

        if ( !pickup.bActive || ignoresActive ) {
            // Simulate the process of picking up through frobbing.
            pickup.BecomeItem();
            pickup.SetOwner( self );
            pickup.SetBase( self );

            PutInHand( pickup );

            HeldInHand = pickup;

            return true;
        }
        else if ( frobOnFail ) {
            DoFrob( self, inHand );
        }
    }

    return false;
}
function ClearHold() {
    HeldInHand = none;
}

function bool BringUpItem( name itemName ) {
    local Inventory item;

    while ( item != none ) {
        if ( item.Class.Name == itemName ) {
            PutInHand( item );

            return true;
        }

        item = item.Inventory;
    }

    return false;
}

// Override
function DropDecoration() {
    local float velscale, size, mult, boost;
    local bool success;
    local Vector X, Y, Z, dropVect, origLoc, HitLocation, HitNormal, extent;
    local Actor hitActor;

    if ( CarriedDecoration != None ) {
        origLoc = CarriedDecoration.Location;
        GetAxes( Rotation, X, Y, Z );

        // if we are highlighting something, try to place the object on the target
        if ( FrobTarget != none && !FrobTarget.IsA( 'Pawn' ) ) {
            CarriedDecoration.Velocity = vect( 0, 0, 0 );

            // try to drop the object about one foot above the target
            size = FrobTarget.CollisionRadius - CarriedDecoration.CollisionRadius * 2;
            dropVect.X = size / 2 - FRand() * size;
            dropVect.Y = size / 2 - FRand() * size;
            dropVect.Z = FrobTarget.CollisionHeight + CarriedDecoration.CollisionHeight + 16;
            dropVect += FrobTarget.Location;
        }
        else {
            // Use a boost variable so we have more control over throw power. Base boost is 500, like vanilla.
            boost = 500;
            boost += boost * GetValue( 'ThrowVelocityBonus' );

            if ( IsLeaning() ) {
                CarriedDecoration.Velocity = vect( 0, 0, 0 );
            }
            else {
                CarriedDecoration.Velocity = Normal( Vector( ViewRotation ) ) * boost;
            }

            // scale it based on the mass
            velscale = FClamp( CarriedDecoration.Mass / 20.0, 1.0, 40.0 );

            CarriedDecoration.Velocity /= velscale;
            dropVect = Location + ( CarriedDecoration.CollisionRadius + CollisionRadius + 4 ) * X;
            dropVect.Z += BaseEyeHeight;
        }

        // is anything blocking the drop point? (like thin doors)
        if ( FastTrace( dropVect ) ) {
            CarriedDecoration.SetCollision( true, true, true );
            CarriedDecoration.bCollideWorld = true;

            // check to see if there's space there
            extent.X = CarriedDecoration.CollisionRadius;
            extent.Y = CarriedDecoration.CollisionRadius;
            extent.Z = 1;
            hitActor = Trace( HitLocation, HitNormal, dropVect, CarriedDecoration.Location, true, extent );

            if ( hitActor == none && CarriedDecoration.SetLocation( dropVect ) ) {
                success = true;
            }
            else {
                CarriedDecoration.SetCollision( false, false, false );
                CarriedDecoration.bCollideWorld = false;
            }
        }

        // if we can drop it here, then drop it
        if ( success ) {
            CarriedDecoration.bWasCarried = true;
            CarriedDecoration.SetBase( none);
            CarriedDecoration.SetPhysics( PHYS_Falling );
            CarriedDecoration.Instigator = self;

            // turn off translucency
            CarriedDecoration.Style = CarriedDecoration.Default.Style;
            CarriedDecoration.bUnlit = CarriedDecoration.Default.bUnlit;
            if ( CarriedDecoration.IsA( 'DeusExDecoration' ) ) {
                DeusExDecoration( CarriedDecoration ).ResetScaleGlow();
            }

            CarriedDecoration = None;
        }
        else {
            // otherwise, don't drop it and display a message
            CarriedDecoration.SetLocation( origLoc );
            ClientMessage( CannotDropHere );
        }
    }
}

//==============================================
// Inventory Management
//==============================================
// Override
function bool HandleItemPickup( Inventory item, optional bool searchOnly ) {
    local bool canPickup;
    local bool slotSearchNeeded;
    local Inventory foundItem;
    local Ammo ammo;
    local DeusExWeapon weapon;

    canPickup = true;
    slotSearchNeeded = true;

    if ( DataVaultImage( item ) != none || NanoKey( item ) != none || Credits( item ) != none ) {
        slotSearchNeeded = False;
    }
    else if ( DeusExPickup( item ) != none ) {
        if ( FindInventoryType( item.Class ) != none ) {
            slotSearchNeeded = !DeusExPickup( item ).bCanHaveMultipleCopies;
        }
    }
    else {
        foundItem = GetWeaponOrAmmo( item );

        if ( foundItem != none ) {
            slotSearchNeeded = false;

            weapon = DeusExWeapon( foundItem );
            ammo = Ammo( foundItem );

            if ( ammo != none ) {
                if ( AmmoNone( ammo ) == none && ammo.AmmoAmount >= ammo.MaxAmmo ) {
                    ClientMessage( Sprintf( MsgTooMuchAmmo, ammo.itemName ) );
                    canPickup = false;
                }
            }
            else if ( weapon != none ) {
                if ( weapon.ReloadCount == 0 && weapon.PickupAmmoCount == 0 && weapon.AmmoName != none ) {
                    ClientMessage( Sprintf( CanCarryOnlyOne, weapon.ItemName ) );
                    canPickup = false;
                }
                else if ( weapon.AmmoType.AmmoAmount >= weapon.AmmoType.MaxAmmo ) {
                    ClientMessage( Sprintf( MsgTooMuchAmmo, weapon.itemName ) );
                    canPickup = false;
                }
            }
        }
    }

    if ( slotSearchNeeded && canPickup ) {
        if ( !FindInventorySlot( item, searchOnly ) ) {
            ClientMessage( Sprintf( InventoryFull, item.itemName ) );
            canPickup = False;
            ServerConditionalNotifyMsg( MPMSG_DropItem );
        }
    }

    if ( canPickup ) {
        weapon = DeusExWeapon( item );
        if ( Level.NetMode != NM_Standalone && ( weapon != none || DeusExAmmo( item ) != none ) ) {
            PlaySound( Sound'WeaponPickup', SLOT_Interact, 0.5 + FRand() * 0.25, , 256, 0.95 + FRand() * 0.1 );
        }

        DoFrob( self, inHand );

        // This is bad. We need to reset the number so restocking works
        if ( Level.NetMode != NM_Standalone ) {
            if ( weapon != none && weapon.PickupAmmoCount == 0 ) {
                weapon.PickupAmmoCount = weapon.default.PickupAmmoCount * 3;
            }
        }
    }

    return canPickup;
}

// Override
function bool DeleteInventory( Inventory item ) {
    if ( item == LastPutAway ) {
        LastPutAway = none;
    }

    return super.DeleteInventory( item );
}

// Override
exec function bool DropItem( optional Inventory item, optional bool drop ) {
    local bool dropped;

    dropped = super.DropItem( item, drop );

    if ( dropped ) {
        if ( item == LastPutAway ) {
            LastPutAway = none;
        }

        if ( IsHolding( item ) ) {
            HeldInHand = none;
        }
    }

    return dropped;
}

//==============================================
// Damage Management
//==============================================
// Override
function bool GetModifiedDamage( int damage, name damageType, vector hitLocation, out int modifiedDamage ) {
    local bool reduced;
    local float newDamage;
    local ChargedPickup cpickup;

    newDamage = float( damage );

    newDamage = newDamage - GetCategoryValue( 'DamageResistanceFlat', damageType );
    newDamage *= 1 - GetCategoryValue( 'DamageResistanceMult', damageType );

    // Nullify all damage of the gas type if you have a Rebreather.
    if ( UsingChargedPickup( class'Rebreather' )
        && ( damageType == 'TearGas' || damageType == 'PoisonGas' || damageType == 'HalonGas' )
    ) {
        newDamage = 0.0;
    }

    if ( damageType == 'Shot' || damageType == 'Sabot' || damageType == 'Exploded' || damageType == 'AutoShot' ) {
        cpickup = GetActiveChargedPickup( class'BallisticArmor' );
        if ( cpickup != None ) {
            newDamage -= cpickup.DrainCharge( newDamage - ( newDamage * ( 1 - cpickup.default.VM_DamageResistance ) ) );
        }
    }

    // Make HazMatSuit block more damagetypes to be consistent with vanilla tooltip.
    if ( damageType == 'TearGas' || damageType == 'PoisonGas' || damageType == 'Radiation' || damageType == 'HalonGas'
        || damageType == 'PoisonEffect' || damageType == 'Flamed' || damageType == 'Burned'
            || damageType == 'Shocked' || damageType == 'EMP'
    ) {
        cpickup = GetActiveChargedPickup( class'HazMatSuit' );
        if ( cpickup != None ) {
            newDamage *= 1 - cpickup.default.VM_DamageResistance;
        }
    }

    reduced = newDamage < damage;
    if ( damageType == 'Shot' || damageType == 'AutoShot' ) {
        newDamage *= CombatDifficulty;
    }
    // Make environmental damage scale with difficulty, emphasizing utility resistances.
    else if ( damageType == 'Burned' || damageType == 'Shocked' || damageType == 'Radiation'
        || damageType == 'PoisonGas'
    ) {
        newDamage *= ( CombatDifficulty / 2 ) + 0.5;
    }

    modifiedDamage = Max( int( newDamage ), 0 );

    return reduced;
}

//==============================================
// Modifiers Management
//==============================================
function float GetValue( name name, optional float defaultValue ) {
    local float value;

    if ( GlobalModifiers.TryGetValue( name, value ) ) {
        return value;
    }

    return defaultValue;
}

function float GetCategoryValue( name category, name name, optional float defaultValue ) {
    local float value;
    local TableFloat table;

    if ( CategoryModifiers.TryGetValue( category, table ) ) {
        if ( table.TryGetValue( name, value ) ) {
            return value;
        }
    }

    return defaultValue;
}

//==============================================
// Skill Management
//==============================================
// Override
function VMSkillManager GetSkillSystem() {
    return VMSkillSystem;
}
// Override
function VMSkillInfo GetFirstSkillInfo() {
    if ( VMSkillSystem != none ) {
        return VMSkillSystem.FirstSkillInfo;
    }

    return none;
}

// Override
function bool IncreaseSkillLevel( name name ) {
    return VMSkillSystem.IncreaseLevel( name );
}

// Override
function int GetSkillLevel( name name ) {
    if ( VMSkillSystem != none ) {
        return VMSkillSystem.GetLevel( name );
    }

    return -1;
}

//==============================================
// Aug Management
//==============================================
function VMAugmentationManager GetAugmentationSystem() {
    return VMAugmentationSystem;
}
function VMAugmentationInfo GetFirstAugmentationInfo() {
    if ( VMAugmentationSystem != none ) {
        return VMAugmentationSystem.FirstAugmentationInfo;
    }

    return none;
}

function bool AddAugmentation( name className, name packageName ) {
    local int i;
    local VMAugmentationInfo info;

    if ( VMAugmentationSystem != none ) {
        info = VMAugmentationSystem.Add( className, packageName );
        if ( info != none && !info.IsPassive() ) {
            for ( i = 0; i < 10; i++ ) {
                if ( AugmentationHotBar[i] == '' ) {
                    AugmentationHotBar[i] = className;
                    break;
                }
            }

            RefreshAugmentationDisplay();

            return true;
        }
    }

    return false;
}
function bool IncreaseAugmentationLevel( name name ) {
    if ( VMAugmentationSystem != none ) {
        return VMAugmentationSystem.IncreaseLevel( name );
    }

    return false;
}

function bool SetAugmentation( name name, bool activate ) {
    if ( VMAugmentationSystem != none ) {
        return VMAugmentationSystem.Set( name, activate );
    }
}
function bool ToggleAugmentation( name name ) {
    if ( VMAugmentationSystem != none ) {
        return VMAugmentationSystem.Toggle( name );
    }
}
function bool IsAugmentationActive( name name ) {
    if ( VMAugmentationSystem != none ) {
        return VMAugmentationSystem.IsActive( name );
    }
}
function ActivateAllAugmentations() {
    if ( VMAugmentationSystem != none ) {
        VMAugmentationSystem.ActivateAll();
    }
}
function DeactivateAllAugmentations() {
    if ( VMAugmentationSystem != none ) {
        VMAugmentationSystem.DeactivateAll();
    }
}
function float TickAllAugmentations( float deltaTime ) {
    if ( VMAugmentationSystem != none ) {
        return VMAugmentationSystem.TickAll( deltaTime );
    }

    return 0;
}

function int GetAugmentationLevel( name name ) {
    if ( VMAugmentationSystem != none ) {
        return VMAugmentationSystem.GetLevel( name );
    }

    return -1;
}

function AddAugmentationHotBar( int slot, name name ) {
    if ( slot >= 0 && slot < 10 ) {
        AugmentationHotBar[slot] = name;
    }
}
function RemoveAugmentationHotBar( int slot ) {
    if ( slot >= 0 && slot < 10 ) {
        AugmentationHotBar[slot] = '';
    }
}

function UpdateAugmentationDisplay( VMAugmentationInfo info, bool show ) {
    if ( DXRootWindow == none ) {
        return;
    }

    if ( show ) {
        DXRootWindow.hud.activeItems.AddIcon( info.GetSmallIcon(), info );
    }
    else {
        DXRootWindow.hud.activeItems.RemoveIcon( info );
    }
}
function RefreshAugmentationDisplay() {
    local int i;
    local VMAugmentationInfo info;

    if ( DXRootWindow != none && DXRootWindow.hud != none ) {
        DXRootWindow.hud.activeItems.ClearAugmentationDisplay();

        if ( VMAugmentationSystem != none ) {
            for ( i = 0; i < 10; i++ ) {
                if ( AugmentationHotBar[i] != '' ) {
                    info = VMAugmentationSystem.GetInfo( AugmentationHotBar[i] );
                    if ( info != none ) {
                        DXRootWindow.hud.activeItems.AddIcon( info.GetSmallIcon(), info );
                    }
                }
            }
        }
    }
}
function ClearAugmentationDisplay() {
    if ( DXRootWindow != none && DXRootWindow.hud != none ) {
        DXRootWindow.hud.activeItems.ClearAugmentationDisplay();
    }
}
function DrawAugmentations( GC gc ) {
    if ( VMAugmentationSystem != none ) {
        VMAugmentationSystem.DrawAugmentations( gc );
    }
}

//==============================================
// Stats Management
//==============================================
// Override
function float GetCurrentGroundSpeed() {
    local float bonus;

    // Disable movement speed bonus when crouching.
    if ( !bIsCrouching && !bForceDuck ) {
        bonus = GetValue( 'MovementSpeedBonusMult' );
    }

    return Default.GroundSpeed * ( 1 + bonus );
}

function int GetBodyPartHealth( byte partIndex ) {
    switch ( partIndex ) {
        case EBodyPart.BodyPartHead:
            return HealthHead;
            break;
        case EBodyPart.BodyPartTorso:
            return HealthTorso;
            break;
        case EBodyPart.BodyPartArmLeft:
            return HealthArmLeft;
            break;
        case EBodyPart.BodyPartArmRight:
            return HealthArmRight;
            break;
        case EBodyPart.BodyPartLegLeft:
            return HealthLegLeft;
            break;
        case EBodyPart.BodyPartLegRight:
            return HealthLegRight;
            break;
    }
}

// Override
function int HealPlayer( int baseAmount, optional bool useSkill, optional bool skipMessage, optional name source ) {
    local int totalHealAmount, healAmount, healedAmount;

    if ( Health >= 100 ) {
        return healedAmount;
    }

    healAmount = baseAmount;
    if ( useSkill ) {
        healAmount += GetValue( 'HealingBonus' );
    }
    if ( source != '' ) {
        healAmount += GetCategoryValue( 'HealingBonus', source );
    }

    totalHealAmount = healAmount;

    if ( healAmount > 0 ) {
        if ( useSkill ) {
            PlaySound( sound'MedicalHiss', SLOT_None,,, 256 );
        }

        // Prioritize critical conditions.
        if ( HealthHead <= 30 ) {
            HealPartWithPool( HealthHead, healAmount, 40 );
        }
        if ( HealthTorso <= 30 ) {
            HealPartWithPool( HealthTorso, healAmount, 40 );
        }

        if ( healAmount > 0 ) {
            if ( HealthLegLeft <= 0 ) {
                HealPartWithPool( HealthLegLeft, healAmount, 10 );
            }
            if ( HealthLegRight <= 0 ) {
                HealPartWithPool( HealthLegRight, healAmount, 10 );
            }
            if ( HealthArmLeft <= 0 ) {
                HealPartWithPool( HealthArmLeft, healAmount, 10 );
            }
            if ( HealthArmRight <= 0 ) {
                HealPartWithPool( HealthArmRight, healAmount, 10 );
            }
        }

        if ( healAmount > 0 ) {
            if ( HealthHead <= HealthTorso ) {
                HealPartWithPool( HealthHead, healAmount, healAmount );
                HealPartWithPool( HealthTorso, healAmount, healAmount );
            }
            else {
                HealPartWithPool( HealthTorso, healAmount, healAmount );
                HealPartWithPool( HealthHead, healAmount, healAmount );
            }
            HealPartWithPool( HealthLegLeft, healAmount, healAmount );
            HealPartWithPool( HealthLegRight, healAmount, healAmount );
            HealPartWithPool( HealthArmLeft, healAmount, healAmount );
            HealPartWithPool( HealthArmRight, healAmount, healAmount );
        }

        GenerateTotalHealth();

        healedAmount = totalHealAmount - healAmount;
        if ( !skipMessage ) {
            if ( healedAmount == 1 ) {
                ClientMessage( Sprintf( HealedPointLabel, healedAmount ) );
            }
            else {
                ClientMessage( Sprintf( HealedPointsLabel, healedAmount ) );
            }
        }
    }

    return healedAmount;
}
function HealPartWithPool( out int target, out int pool, int amount ) {
    local int spill;

    if ( pool <= 0 || amount <= 0 || target >= 100 ) {
        return;
    }

    amount = Min( amount, pool );
    target += amount;
    spill = Max( target - 100, 0 );
    if ( spill > 0 ) {
        target = 100;
    }
    pool -= amount;
    pool += spill;

    // Vanilla Matters: Add in FP rate for health restored.
    AddForwardPressure( amount - spill, 'Heal' );
}
function HealPartIndex( byte partIndex, int amount ) {
    switch ( partIndex ) {
        case EBodyPart.BodyPartHead:
            HealPart( HealthHead, amount );
            break;
        case EBodyPart.BodyPartTorso:
            HealPart( HealthTorso, amount );
            break;
        case EBodyPart.BodyPartArmLeft:
            HealPart( HealthArmLeft, amount );
            break;
        case EBodyPart.BodyPartArmRight:
            HealPart( HealthArmRight, amount );
            break;
        case EBodyPart.BodyPartLegLeft:
            HealPart( HealthLegLeft, amount );
            break;
        case EBodyPart.BodyPartLegRight:
            HealPart( HealthLegRight, amount );
            break;
    }
}
function HealPart( out int target, int amount ) {
    if ( amount <= 0 || target >= 100 ) {
        return;
    }
    target = Min( target + amount, 100 );
}

// Override
function float CalculatePlayerVisibility( optional ScriptedPawn P ) {
    if ( Robot( P ) != none ) {
        return VisibilityRadar;
    }
    else {
        return VisibilityNormal;
    }
}

// Override
function bool DrainEnergy( float amount ) {
    if ( amount <= 0 || Energy < amount ) {
        return false;
    }

    Energy -= amount;
    return true;
}

//==============================================
// Misc
//==============================================
// Replace CatchFire to have burn damage depend on initial damage taken.
// Override
function StartBurning( Pawn burner, float burnDamage ) {
    local Fire f;
    local int i;
    local vector loc;

    myBurner = burner;

    burnTimer = burnTimer + ( burnDamage * 2 );

    if ( bOnFire || Region.Zone.bWaterZone ) {
        return;
    }

    bOnFire = true;

    for ( i = 0; i < 8; i++ ) {
        loc.X = 0.5 * CollisionRadius * ( 1.0 - 2.0 * FRand() );
        loc.Y = 0.5 * CollisionRadius * ( 1.0 - 2.0 * FRand() );
        loc.Z = 0.6 * CollisionHeight * ( 1.0 - 2.0 * FRand() );
        loc = loc + Location;

        if ( Level.NetMode == NM_Standalone || i <= 0 ) {
            f = Spawn( class'Fire', Self,, loc );
        }
        else {
            f = Spawn( class'SmokelessFire', Self,, loc );
        }

        if ( f != none ) {
            f.DrawScale = 0.5 * FRand() + 1.0;

            if ( Level.NetMode != NM_Standalone ) {
                f.DrawScale = f.DrawScale * 0.5;
            }

            if ( i > 0 ) {
                f.AmbientSound = None;
                f.LightType = LT_None;
            }

            if ( FRand() < 0.5 && Level.NetMode == NM_Standalone ) {
                f.smokeGen.Destroy();
                f.AddFire();
            }
        }
    }

    SetTimer( 1.0, true );
}

// Copied from ScriptedPawn to handle burning damage.
function UpdateFire() {
    HealthTorso = HealthTorso - 2;
    HealthArmLeft = HealthArmLeft - 2;
    HealthArmRight = HealthArmRight - 2;
    HealthLegLeft = HealthLegLeft - 2;
    HealthLegRight = HealthLegLeft - 2;

    GenerateTotalHealth();

    burnTimer = burnTimer - 10;

    if ( Health <= 0 || burnTimer <= 0 ) {
        ExtinguishFire();

        if ( Health <= 0 ) {
            TakeDamage( 10, none, Location, vect( 0, 0, 0 ), 'Burned' );
        }
    }
}

// Override
function DroneExplode()
{
    local AugDrone aug;

    if ( aDrone != none )
    {
        // Make drone detonation cost energy.
        SetAugmentation( 'AugDrone', false );
        // TODO: Add support for AugDrone detonation.
    }
}

// Override
function DeusExLevelInfo GetLevelInfo() {
    return LevelInfo;
}
function DeusExLevelInfo FindLevelInfo() {
    local DeusExLevelInfo info;

    foreach AllActors( class'DeusExLevelInfo', info ) {
        break;
    }

    return info;
}

//==============================================
// Presentation
//==============================================
// Override
function UpdateDynamicMusic( float deltaTime ) {
    local DeusExLevelInfo info;

    if ( Level.Song == none ) {
        return;
    }

    // DEUS_EX AMSD In singleplayer, do the old thing.
    // In multiplayer, we can come out of dying.
    if ( !PlayerIsClient() ) {
        if ( musicMode == MUS_Dying || musicMode == MUS_Outro ) {
            return;
        }
    }
    else {
        if ( musicMode == MUS_Outro ) {
            return;
        }
    }

    musicCheckTimer += deltaTime;
    musicChangeTimer += deltaTime;

    if ( IsInState( 'Interpolating' ) ) {
        // don't mess with the music on any of the intro maps
        if ( LevelInfo != none && LevelInfo.MissionNumber < 0 ) {
            musicMode = MUS_Outro;
            return;
        }

        if ( musicMode != MUS_Outro ) {
            ClientSetMusic( Level.Song, 5, 255, MTRAN_FastFade );
            musicMode = MUS_Outro;
        }
    }
    else if ( IsInState( 'Conversation' ) ) {
        if ( musicMode != MUS_Conversation ) {
            // save our place in the ambient track
            if ( musicMode == MUS_Ambient ) {
                savedSection = SongSection;
            }
            else {
                savedSection = 255;
            }

            ClientSetMusic( Level.Song, 4, 255, MTRAN_Fade );
            musicMode = MUS_Conversation;
        }
    }
    else if ( IsInState( 'Dying' ) ) {
        if ( musicMode != MUS_Dying ) {
            ClientSetMusic( Level.Song, 1, 255, MTRAN_Fade );
            musicMode = MUS_Dying;
        }
    }
    else {
        // only check for combat music every second
        if ( musicCheckTimer > 1 ) {
            musicCheckTimer -= 1;

            if ( IsInCombat() ) {
                musicChangeTimer = 0.0;

                if ( musicMode != MUS_Combat ) {
                    // save our place in the ambient track
                    if ( musicMode == MUS_Ambient ) {
                        savedSection = SongSection;
                    }
                    else {
                        savedSection = 255;
                    }

                    ClientSetMusic( Level.Song, 3, 255, MTRAN_FastFade );
                    musicMode = MUS_Combat;
                }
            }
            else if ( musicMode != MUS_Ambient ) {
                // wait until we've been out of combat for 5 seconds before switching music
                if ( musicChangeTimer > 5.0 ) {
                    // use the default ambient section for this map
                    if ( savedSection == 255 ) {
                        savedSection = Level.SongSection;
                    }

                    // fade slower for combat transitions
                    if ( musicMode == MUS_Combat ) {
                        ClientSetMusic( Level.Song, savedSection, 255, MTRAN_SlowFade );
                    }
                    else {
                        ClientSetMusic( Level.Song, savedSection, 255, MTRAN_Fade );
                    }

                    savedSection = 255;
                    musicMode = MUS_Ambient;
                    musicChangeTimer = 0.0;
                }
            }
        }
    }
}

//==============================================
// Config
//==============================================
// Override
function SetFeatureEnabled( name featureName, bool enabled ) {
    switch ( featureName ) {
        case 'AutoSave':
            EnableAutoSave = enabled;
            break;
        case 'ForwardPressure':
            EnableForwardPressure = enabled;
            break;
        case 'Cheats':
            EnableCheats = enabled;
            break;
        default:
            break;
    }
}
// Override
function bool IsFeatureEnabled( name featureName ) {
    switch ( featureName ) {
        case 'AutoSave':
            return EnableAutoSave;
        case 'ForwardPressure':
            return EnableForwardPressure;
        case 'Cheats':
            return EnableCheats;
        default:
            return false;
    }
}
// Override
function bool IsFeatureEnabledByDefault( name featureName ) {
    switch ( featureName ) {
        case 'AutoSave':
            return default.EnableAutoSave;
        case 'ForwardPressure':
            return default.EnableForwardPressure;
        case 'Cheats':
            return default.EnableCheats;
        default:
            return false;
    }
}

exec function sv_cheats( bool enabled ) {
    bCheatsEnabled = enabled;

    if ( enabled ) {
        ClientMessage( "Cheats enabled" );
    }
    else {
        ClientMessage( "Cheats disabled" );
    }
}

//==============================================
// Forward Pressure
//==============================================
// Override
function AddForwardPressure( float value, name type ) {
    if ( FPSystem != none ) {
        FPSystem.CalculateAndAdd( value, type );
    }
}
// Override
function ResetForwardPressure() {
    if ( FPSystem != none ) {
        FPSystem.Reset();
    }
}
// Override
function float GetForwardPressure() {
    if ( FPSystem != none ) {
        return FPSystem.GetForwardPressure();
    }

    return 0;
}

// Override
function bool HasFullForwardPressure() {
    if ( !EnableForwardPressure ) {
        return true;
    }

    if ( FPSystem != none ) {
        return FPSystem.IsFull();
    }

    return false;
}

defaultproperties
{
     BodyPartNamesLowercase(0)="head"
     BodyPartNamesLowercase(1)="torso"
     BodyPartNamesLowercase(2)="left arm"
     BodyPartNamesLowercase(3)="right arm"
     BodyPartNamesLowercase(4)="left leg"
     BodyPartNamesLowercase(5)="right leg"
     MsgFullHealth="You already have full health"
     MsgFullEnergy="You already have full energy"
     MsgTooMuchAmmo="You already have enough %s"
     MsgChargedPickupAlready="You are already using that type of equipment"
     MsgUseChargedPickup="You need to have the item in your inventory to activate it"
     SkillPointsTotal=4500
     SkillPointsAvail=4500
     AugmentationHotBar(10)=AugLight
}
