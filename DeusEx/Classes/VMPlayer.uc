class VMPlayer extends DeusExPlayer
    abstract;

// Colored hand textures
#exec TEXTURE IMPORT FILE="Textures\WeaponHandsTex1a.bmp"       NAME="WeaponHandsTex1a"     GROUP="VM" MIPS=On
#exec TEXTURE IMPORT FILE="Textures\WeaponHandsTex2a.bmp"       NAME="WeaponHandsTex2a"     GROUP="VM" MIPS=On
#exec TEXTURE IMPORT FILE="Textures\WeaponHandsTex3a.bmp"       NAME="WeaponHandsTex3a"     GROUP="VM" MIPS=On
#exec TEXTURE IMPORT FILE="Textures\WeaponHandsTex4a.bmp"       NAME="WeaponHandsTex4a"     GROUP="VM" MIPS=On

#exec TEXTURE IMPORT FILE="Textures\WeaponHandsTex1b.bmp"       NAME="WeaponHandsTex1b"     GROUP="VM" MIPS=On
#exec TEXTURE IMPORT FILE="Textures\WeaponHandsTex2b.bmp"       NAME="WeaponHandsTex2b"     GROUP="VM" MIPS=On
#exec TEXTURE IMPORT FILE="Textures\WeaponHandsTex3b.bmp"       NAME="WeaponHandsTex3b"     GROUP="VM" MIPS=On
#exec TEXTURE IMPORT FILE="Textures\WeaponHandsTex4b.bmp"       NAME="WeaponHandsTex4b"     GROUP="VM" MIPS=On

//==============================================
// Constants
//==============================================
const AutoSaveDelay = 180;

//==============================================
// Strings
//==============================================
var localized string MsgFullHealth;
var localized string MsgFullEnergy;
var localized string MsgDroneCost;
var localized string MsgTooMuchAmmo;
var localized string MsgMuscleCost;
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
var travel ForwardPressure FPSystem;

var travel VMSkillManager VMSkillSystem;
var() array< class<VMSKill> > StartingSkills;

//==============================================
// Properties
//==============================================
var travel float VisibilityNormal;
var travel float VisibilityRobot;

var travel Inventory LastPutAway;               // Last item in hand before PutInHand( None ).
var travel Inventory HeldInHand;                // Item being held.
var travel Inventory LastHeldInHand;            // Some temporary place to keep track of HeldInHand.

var travel int LastMissionNumber;               // Keep track of the last mission number in case the player transitions to a new mission.
var travel bool IsMapTravel;                    // Denote if a travel is a normal map travel or game load.

var byte ChargedPickupStatus[5];

//==============================================
// Initializing and Startup
//==============================================
// Override
function PreTravel() {
    local DeusExLevelInfo info;

    super.PreTravel();

    // Gotta do this to keep the held item from being added to the inventory.
    if ( HeldInHand != None ) {
        HeldInHand.SetOwner( None );
    }

    // Save current mission number and marks this as a normal map transition.
    info = GetLevelInfo();
    if ( info != None ) {
        LastMissionNumber = info.MissionNumber;
    }
    else {
        LastMissionNumber = -3;
    }

    IsMapTravel = true;
}

// Override
event TravelPostAccept() {
    local DeusExLevelInfo info;
    local int missionNumber;

    super.TravelPostAccept();

    info = GetLevelInfo();
    if ( info != none ) {
        missionNumber = info.MissionNumber;
    }
    else {
        missionNumber = -3;
    }

    if ( VMSkillSystem == none ) {
        InitializeSkillSystem();
    }
    else {
        VMSkillSystem.RefreshValues();
    }

    if (AugmentationSystem != none) {
        // Should ensure all augs work fine through patches.
        AugmentationSystem.RefreshesAugs();
    }

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
    if ( LastMissionNumber != -3 && info.MissionNumber > LastMissionNumber ) {
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
function InitializeSubSystems() {
    super.InitializeSubSystems();

    // Initiate the FP system if not found, doesn't matter if FP is enabled or not.
    if ( FPSystem == none ) {
        FPSystem = Spawn( class'ForwardPressure', self );
        FPSystem.Initialize( self );
    }
    else {
        FPSystem.SetPlayer( self );
    }
    FPSystem.SetOwner( self );
}

// Override
function InitializeSkillSystem() {
    local int i;

    VMSkillSystem = Spawn( class'VMSkillManager', self );
    VMSkillSystem.Initialize();

    // Start in reverse because we're adding to a linked list.
    for ( i = ( #StartingSkills - 1 ); i >= 0; i-- ) {
        VMSkillSystem.AddSkill( StartingSkills[i] );
    }
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

// Vanilla Matters: Update visibility values.
function UpdateVisibility() {
    local bool adaptiveOn;

    adaptiveOn = UsingChargedPickup( class'AdaptiveArmor' );

    if ( AugmentationSystem.GetAugLevelValue( class'AugRadarTrans' ) != -1.0 || adaptiveOn ) {
        VisibilityRobot = 0;
    }
    else {
        VisibilityRobot = AIVisibility();
    }

    if ( AugmentationSystem.GetAugLevelValue( class'AugCloak' ) != -1.0 || adaptiveOn ) {
        VisibilityNormal = 0;
    }
    else {
        VisibilityNormal = AIVisibility();
    }
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
    local DeusExLevelInfo info;

    // Don't allow saving if:
    // 1) The player is dead
    // 2) We're on the logo map
    // 4) We're interpolating (playing outro)
    // 3) A datalink is playing
    // 4) We're in a multiplayer game

    info = GetLevelInfo();
    if ( !ShouldSave( info ) ) {
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
    if ( CurrentQSIndex != 9996 ) {
        CurrentQSIndex = 9996;
    }
    else if ( CurrentQSIndex != 9997 ) {
        CurrentQSIndex = 9997;
    }

    SaveGame( CurrentQSIndex, QuickSaveGameTitle @ "-" @ info.MissionLocation );
}

// Override
function RequestAutoSave( optional float delay ) {
    IsAutoSaving = true;
    AutoSaveTimer = delay;
}
// Handle auto save.
function AutoSave() {
    local DeusExLevelInfo info;

    info = GetLevelInfo();
    if ( !ShouldSave( info ) ) {
        return;
    }

    if ( CurrentASIndex != 9998 ) {
        CurrentASIndex = 9998;
    }
    else if ( CurrentASIndex != 9999 ) {
        CurrentASIndex = 9999;
    }

    IsAutoSaving = false;
    AutoSaveTimer = 0;

    SaveGame( CurrentASIndex, "Auto Save -" @ info.MissionLocation );
}

function bool ShouldSave( DeusExLevelInfo info ) {
    if ( ( info != none && ( info.MissionNumber < 0 || info.MissionLocation == "" ) )
        || IsInState( 'Dying' ) || IsInState( 'Paralyzed' ) || IsInState( 'Interpolating' )
        || dataLinkPlay != none
        || Level.NetMode != NM_Standalone
    ) {
        return false;
    }
    else {
        return true;
    }
}

// Override
function QuickLoadConfirmed() {
    if ( Level.Netmode != NM_Standalone ) {
        return;
    }

    LoadGame( CurrentQSIndex );
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
                augReduce = 0;
                if ( AugmentationSystem != none ) {
                    // Make AugStealth also reduce a smaller amount of fall damage, while AugSpeed reduce more.
                    augLevel = AugmentationSystem.GetClassLevel( class'AugSpeed' );
                    if ( augLevel >= 0 ) {
                        augReduce = 20 * ( augLevel + 1 );
                    }
                    else {
                        augLevel = AugmentationSystem.GetClassLevel( class'AugStealth' );

                        if ( augLevel >= 0 ) {
                            augReduce = 4 + ( 4 * ( augLevel + 1 ) );
                        }
                    }
                }

                // Don't call TakeDamage if it's fully reduced.
                dmg = Max( ( -0.16 * ( Velocity.Z + 700 ) ) - augReduce, 0 );
                if ( dmg > 0 ) {
                    legLocation = Location + vect( -1, 0, -1 );
                    TakeDamage( dmg, none, legLocation, vect( 0, 0, 0 ), 'fell' );

                    legLocation = Location + vect( 1, 0, -1 );
                    TakeDamage( dmg, none, legLocation, vect( 0, 0, 0 ), 'fell' );
                }

                dmg = Max( ( -0.06 * ( Velocity.Z + 700 ) ) - augReduce, 0 );
                if ( dmg > 0 ) {
                    legLocation = Location + vect( 0, 0, 1 );
                    TakeDamage( dmg, none, legLocation, vect( 0, 0, 0 ), 'fell' );
                }
            }
        }
    }
    else if ( Level.Game != none && Level.Game.Difficulty > 1 && Velocity.Z > 0.5 * JumpZ ) {
        MakeNoise( 0.1 * Level.Game.Difficulty );
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
// Rewrite aug activativation functions to be clearer.
exec function AugSlot1() { ActivateAugByKey( 0 ); }
exec function AugSlot2() { ActivateAugByKey( 1 ); }
exec function AugSlot3() { ActivateAugByKey( 2 ); }
exec function AugSlot4() { ActivateAugByKey( 3 ); }
exec function AugSlot5() { ActivateAugByKey( 4 ); }
exec function AugSlot6() { ActivateAugByKey( 5 ); }
exec function AugSlot7() { ActivateAugByKey( 6 ); }
exec function AugSlot8() { ActivateAugByKey( 7 ); }
exec function AugSlot9() { ActivateAugByKey( 8 ); }
exec function AugSlot10() { ActivateAugByKey( 9 ); }

// Flashlight now has its own key and function.
exec function ToggleFlashlight() {
    ActivateAugByKey( 10 );
}

// Override
exec function ParseLeftClick() {
    local Inventory item;
    local Augmentation aug;
    local ChargedPickup cpickup;

    if ( RestrictInput() ) {
        return;
    }

    // if the spy drone augmentation is active, blow it up
    if ( bSpyDroneActive ) {
        DroneExplode();

        return;
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
    // Allow holding pickups in hands or doing powerthrows.
    else if ( inHand == None ) {
        if ( FrobTarget != None ) {
            TakeHold( Inventory( FrobTarget ), true );
        }
        else if ( CarriedDecoration != None && AugmentationSystem != None ) {
            aug = AugmentationSystem.FindAugmentation( class'AugMuscle' );

            if ( aug != None && aug.bHasIt && aug.bIsActive ) {
                if ( !CanDrain( ( CarriedDecoration.Mass / 50 ) * AugMuscle( aug ).VM_muscleCost ) ) {
                    ClientMessage( MsgMuscleCost );
                }
                else if ( DeusExDecoration( CarriedDecoration ) != None ) {
                    DeusExDecoration( CarriedDecoration ).VM_bPowerthrown = true;
                    DeusExDecoration( CarriedDecoration ).VM_powerThrower = self;

                    PlaySound( JumpSound, SLOT_None );
                    PlaySound( aug.ActivateSound, SLOT_None );

                    DropDecoration();
                }
            }
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
    local Inventory oldFirstItem;
    local Inventory oldInHand;
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
        else if ( Inventory( FrobTarget ) != none ) {
            // Allow taking hold of an item if the player can't pick it up.
            if ( !HandleItemPickup( FrobTarget, true ) ) {
                if ( TakeHold( Inventory( FrobTarget ) ) ) {
                    if ( WasHolding( Inventory( FrobTarget ) ) ) {
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
                    FindInventorySlot( Inventory( FrobTarget ) );
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

//==============================================
// Stats Management
//==============================================
function float CalculatePlayerVisibility( optional ScriptedPawn P ) {
    if ( Robot( P ) != none ) {
        return VisibilityRobot;
    }
    else {
        return VisibilityNormal;
    }
}

function bool CanDrain( float drainAmount ) {
    if ( AugmentationSystem != None ) {
        return ( Energy >= ( drainAmount * AugmentationSystem.VM_energyMult ) );
    }

    return false;
}

// Override: Drain energy then return the amount that doesn't get drained properly if energy is depleted.
function float DrainEnergy( Augmentation augDraining, float drainAmount, optional float efficiency ) {
    if ( efficiency > 0.0 ) {
        // How much energy should be drained per unit of drainAmount.
        drainAmount = drainAmount / efficiency;
    }

    augDraining.AddImmediateEnergyRate( drainAmount );

    if ( !CanDrain( drainAmount ) ) {
        drainAmount = drainAmount - Energy;
    }

    // Return the drainAmount to normal.
    if ( efficiency > 0.0 ) {
        drainAmount = drainAmount * efficiency;
    }

    return drainAmount;
}

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

//==============================================
// Item Management
//==============================================
// Override
exec function PutInHand( optional Inventory inv ) {
    if ( RestrictInput() ) {
        return;
    }

    if ( inHand == none && bSpyDroneActive ) {
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

//==============================================
// Inventory Management
//==============================================
// Override
function bool HandleItemPickup( Actor FrobTarget, optional bool searchOnly ) {
    local bool canPickup;
    local bool slotSearchNeeded;
    local Inventory foundItem;
    local Ammo ammo;
    local DeusExWeapon weapon;

    canPickup = true;
    slotSearchNeeded = true;

    if ( DataVaultImage( FrobTarget ) != none || NanoKey( FrobTarget ) != none || Credits( FrobTarget ) != none ) {
        slotSearchNeeded = False;
    }
    else if ( DeusExPickup( FrobTarget ) != none ) {
        if ( FindInventoryType( FrobTarget.Class ) != none ) {
            slotSearchNeeded = DeusExPickup( FrobTarget ).bCanHaveMultipleCopies;
        }
    }
    else {
        foundItem = GetWeaponOrAmmo( Inventory( FrobTarget ) );

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
            else if ( weapon != none && weapon.VM_isGrenade ) {
                if ( weapon.AmmoType.AmmoAmount >= weapon.AmmoType.MaxAmmo) {
                    ClientMessage( Sprintf( MsgTooMuchAmmo, weapon.itemName ) );

                    canPickup = false;
                }
            }
            else if ( weapon != none ) {
                if ( weapon.AmmoName == none
                    || weapon.AmmoName == class'AmmoNone'
                    || weapon.PickupAmmoCount <= 0
                ) {
                    ClientMessage( Sprintf( CanCarryOnlyOne, weapon.ItemName ) );
                    canPickup = false;
                }
                else if ( weapon.AmmoType.AmmoAmount >= weapon.AmmoType.MaxAmmo ) {
                    ClientMessage( Sprintf( MsgTooMuchAmmo, weapon.AmmoType.ItemName ) );
                    canPickup = false;
                }
            }
        }
    }

    if ( slotSearchNeeded && canPickup ) {
        if ( !FindInventorySlot( Inventory( FrobTarget ), searchOnly ) ) {
            ClientMessage( Sprintf( InventoryFull, Inventory( FrobTarget ).itemName ) );
            canPickup = False;
            ServerConditionalNotifyMsg( MPMSG_DropItem );
        }
    }

    if ( canPickup ) {
        weapon = DeusExWeapon( FrobTarget );
        if ( Level.NetMode != NM_Standalone && ( weapon != none || DeusExAmmo( FrobTarget ) != none ) ) {
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
function bool DXReduceDamage( int Damage, name damageType, vector hitLocation, out int adjustedDamage, bool checkOnly ) {
    local float newDamage;
    local float augValue;
    local float pct;
    local bool reduced;
    local ChargedPickup cpickup;

    reduced = false;
    newDamage = float( Damage );

    if ( damageType == 'TearGas' || damageType == 'PoisonGas' || damageType == 'Radiation'
        || damageType == 'HalonGas'  || damageType == 'PoisonEffect' || damageType == 'Poison'
    ) {
        if ( AugmentationSystem != none ) {
            augValue = AugmentationSystem.GetAugLevelValue(class'AugEnviro');
        }

        if ( augValue >= 0.0 ) {
            newDamage *= augValue;
        }

        if ( newDamage ~= 0.0 ) {
            StopPoison();
            drugEffectTimer = 0;
        }
    }

    // Vanilla Matters: Nullify all damage of the gas type if you have a Rebreather.
    if ( UsingChargedPickup( class'Rebreather' )
        && ( damageType == 'TearGas' || damageType == 'PoisonGas' || damageType == 'HalonGas' )
    ) {
        newDamage = 0.0;
    }

    if ( damageType == 'Shot' || damageType == 'Sabot' || damageType == 'Exploded' || damageType == 'AutoShot' ) {
        // Make Ballistic Armor absorbs the damage properly and deals with spillovers.
        cpickup = GetActiveChargedPickup( class'BallisticArmor' );

        if ( cpickup != None ) {
            newDamage -= cpickup.DrainCharge( newDamage - ( newDamage * ( 1 - ( cpickup.default.VM_DamageResistance * VMSkillSystem.GetValue( "BallisticArmorResistance", 1 ) ) ) ) );
        }
    }

    // Make HazMatSuit block more damagetypes to be consistent with vanilla tooltip.
    if ( damageType == 'TearGas' || damageType == 'PoisonGas' || damageType == 'Radiation' || damageType == 'HalonGas'
        || damageType == 'PoisonEffect' || damageType == 'Flamed' || damageType == 'Burned'
            || damageType == 'Shocked' || damageType == 'EMP' ) {

        cpickup = GetActiveChargedPickup( class'HazMatSuit' );

        if ( cpickup != None ) {
            newDamage *= 1 - ( cpickup.default.VM_DamageResistance * VMSkillSystem.GetValue( "HazMatSuitResistance", 1 ) );
        }
    }

    if ( damageType == 'HalonGas' ) {
        if ( bOnFire && !checkOnly ) {
            ExtinguishFire();
        }
    }

    // Add sabot to augballistic.
    if ( damageType == 'Shot' || damageType == 'AutoShot' || damageType == 'Sabot' )
    {
        if ( AugmentationSystem != none ) {
            augValue = AugmentationSystem.GetAugLevelValue( class'AugBallistic' );
        }

        if ( augValue >= 0.0 ) {
            // AugBallistic now adds a flat damage reduction.
            newDamage -= augValue;
        }
    }

    // Add EMP to augshield.
    if ( damageType == 'Burned' || damageType == 'Flamed' || damageType == 'EMP' ||
        damageType == 'Exploded' || damageType == 'Shocked' )
    {
        if (AugmentationSystem != none) {
            augValue = AugmentationSystem.GetAugLevelValue( class'AugShield' );
        }

        if ( augValue >= 0.0 ) {
            newDamage *= augValue;
        }
    }

    // Allow full damage resistance.
    if ( damageType == 'Shot' || damageType == 'AutoShot' ) {
        newDamage *= CombatDifficulty;
        Damage *= CombatDifficulty;
    }
    // Make environmental damage scale with difficulty, emphasizing utility resistances.
    else if ( damageType == 'Burned' || damageType == 'Shocked' || damageType == 'Radiation'
        || damageType == 'PoisonGas'
    ) {
        newDamage *= ( CombatDifficulty / 2 ) + 0.5;
        Damage *= ( CombatDifficulty / 2 ) + 0.5;
    }

    // Move this all the way to the bottom to be most accurate.
    if ( newDamage < Damage ) {
        if ( !checkOnly ) {
            pct = 1.0 - ( newDamage / Damage );

            SetDamagePercent( pct );
            ClientFlash( 0.01, vect( 0, 0, 50 ) );
        }

        reduced = true;
    }
    else {
        if ( !checkOnly ) {
            SetDamagePercent( 0.0 );
        }
    }

    adjustedDamage = int( newDamage );

    return reduced;
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
function bool IncreaseSkillLevel( VMSkillInfo info ) {
    if ( info.CanUpgrade( SkillPointsAvail ) ) {
        if ( VMSkillSystem.IncreaseLevel( info ) ) {
            SkillPointsAvail -= info.GetNextLevelCost();

            return true;
        }
    }

    return false;
}
// Override
function bool DecreaseSkillLevel( VMSkillInfo info ) {
    if ( VMSkillSystem.DecreaseLevel( info ) ) {
        SkillPointsAvail += info.GetNextLevelCost();

        return true;
    }

    return false;
}

// Override
function float GetSkillValue( string name, optional float defaultValue ) {
    if ( VMSkillSystem != none ) {
        return VMSkillSystem.GetValue( name, defaultValue );
    }
    else {
        return defaultValue;
    }
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
function float GetAugValue( class<Augmentation> class ) {
    if ( AugmentationSystem != none ) {
        return AugmentationSystem.GetAugLevelValue( class );
    }

    return -1;
}

function int GetAugLevel( class<Augmentation> class ) {
    if ( AugmentationSystem != none ) {
        return AugmentationSystem.GetClassLevel( class );
    }

    return -1;
}

//==============================================
// Misc
//==============================================
function ActivateAugByKey( int keyNum ) {
    if ( AugmentationSystem != none ) {
        AugmentationSystem.ActivateAugByKey( keyNum );
    }
}

// Replace CatchFire to have burn damage depend on initial damage taken.
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

// Override
function DroneExplode()
{
    local AugDrone aug;

    if ( aDrone != none )
    {
        // Make drone detonation cost energy.
        aug = AugDrone( AugmentationSystem.FindAugmentation( class'AugDrone' ) );

        if ( aug != None ) {
            if ( !CanDrain( aug.GetEnergyRate() ) ) {
                ClientMessage( MsgDroneCost );

                return;
            }

            aug.Deactivate();

            aDrone.Explode( aDrone.Location, vect( 0, 0, 1 ) );

            DrainEnergy( aug, aug.GetEnergyRate() );
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
     MsgFullHealth="You already have full health"
     MsgFullEnergy="You already have full energy"
     MsgUseChargedPickup="You need to have the item in your inventory to activate it"
     MsgDroneCost="You don't have enough energy to detonate a drone"
     MsgTooMuchAmmo="You already have enough %s"
     MsgMuscleCost="You don't have enough energy to do a powerthrow"
     MsgChargedPickupAlready="You are already using that type of equipment"
}