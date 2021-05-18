//=============================================================================
// Augmentation.
//=============================================================================
class Augmentation extends Actor
    intrinsic;

// Vanilla Matters: Import aug icons that have a pinkmask instead of blackmask.
#exec TEXTURE IMPORT FILE="Textures\AugIconCloak.bmp"       NAME="AugIconCloak"     GROUP="VMUI" MIPS=Off
#exec TEXTURE IMPORT FILE="Textures\AugIconCombat.bmp"      NAME="AugIconCombat"    GROUP="VMUI" MIPS=Off
#exec TEXTURE IMPORT FILE="Textures\AugIconDefense.bmp"     NAME="AugIconDefense"   GROUP="VMUI" MIPS=Off
#exec TEXTURE IMPORT FILE="Textures\AugIconDrone.bmp"       NAME="AugIconDrone"     GROUP="VMUI" MIPS=Off
#exec TEXTURE IMPORT FILE="Textures\AugIconHeal.bmp"        NAME="AugIconHeal"      GROUP="VMUI" MIPS=Off
#exec TEXTURE IMPORT FILE="Textures\AugIconHeart.bmp"       NAME="AugIconHeart"     GROUP="VMUI" MIPS=Off
#exec TEXTURE IMPORT FILE="Textures\AugIconRadar.bmp"       NAME="AugIconRadar"     GROUP="VMUI" MIPS=Off
#exec TEXTURE IMPORT FILE="Textures\AugIconRunSilent.bmp"   NAME="AugIconRunSilent" GROUP="VMUI" MIPS=Off
#exec TEXTURE IMPORT FILE="Textures\AugIconSpeed.bmp"       NAME="AugIconSpeed"     GROUP="VMUI" MIPS=Off
#exec TEXTURE IMPORT FILE="Textures\AugIconTarget.bmp"      NAME="AugIconTarget"    GROUP="VMUI" MIPS=Off
#exec TEXTURE IMPORT FILE="Textures\AugIconVision.bmp"      NAME="AugIconVision"    GROUP="VMUI" MIPS=Off

var() bool bAutomatic;
var() float EnergyRate;
var travel int CurrentLevel;
var int MaxLevel;
var texture icon;
var int IconWidth;
var int IconHeight;
var texture smallIcon;
var bool bAlwaysActive;
var travel bool bBoosted;
var travel int HotKeyNum;
var travel Augmentation next;
var bool bUsingMedbot;

var localized String EnergyRateLabel;
var localized string OccupiesSlotLabel;
var localized string AugLocsText[7];

var() localized string AugActivated;
var() localized string AugDeactivated;
var() localized string AugmentationName;
var() localized string Description;
var() localized string MPInfo;
var() localized string AugAlreadyHave;
var() localized string AugNowHave;
var() localized string AugNowHaveAtLevel;
var() localized string AlwaysActiveLabel;
var() localized String CanUpgradeLabel;
var() localized String CurrentLevelLabel;
var() localized String MaximumLabel;

// which player am I attached to?
var DeusExPlayer Player;

var() float LevelValues[4];

// does the player have it?
var travel bool bHasIt;

// is it actually turned on?
var travel bool bIsActive;

var() enum EAugmentationLocation
{
    LOC_Cranial,
    LOC_Eye,
    LOC_Torso,
    LOC_Arm,
    LOC_Leg,
    LOC_Subdermal,
    LOC_Default
} AugmentationLocation;

// DEUS_EX AMSD In multiplayer, we have strict aug pairs, no two augs can have the
// same MPConflict slot value.
var() int MPConflictSlot;

var() sound ActivateSound;
var() sound DeactivateSound;
var() sound LoopSound;

// Vanilla Matters
var() float VM_EnergyRateAddition[4];       // Added to base energy rate at each level.

var travel float VM_immediateEnergyRate;    // The extra amount of energy to be depleted.

var Texture VM_dragIcon;

// ----------------------------------------------------------------------
// network replication
// ----------------------------------------------------------------------

replication
{
    //variables server to client
    reliable if ((Role == ROLE_Authority) && (bNetOwner))
        bHasIt, bIsActive, CurrentLevel, next, HotKeyNum, Player;

    //functions client to server
    reliable if (Role < ROLE_Authority)
        Activate, Deactivate, IncLevel;

}

// ----------------------------------------------------------------------
// state Active
//
// each augmentation should have its own version of this which actually
// implements the effects of having the augmentation on
// ----------------------------------------------------------------------

state Active
{
Begin:
    log("** AUGMENTATION: .Active should never be called!");
}

// ----------------------------------------------------------------------
// state Inactive
//
// don't do anything in this state
// ----------------------------------------------------------------------

auto state Inactive
{
}


// ----------------------------------------------------------------------
// Activate()
// ----------------------------------------------------------------------

function Activate()
{
    // Vanilla Matters: Unused.
}

// ----------------------------------------------------------------------
// Deactivate()
// ----------------------------------------------------------------------

function Deactivate()
{
    // Vanilla Matters: Unused.
}

// ----------------------------------------------------------------------
// IncLevel()
// ----------------------------------------------------------------------

function bool IncLevel()
{
    if ( !CanBeUpgraded() )
    {
        Player.ClientMessage(Sprintf(AugAlreadyHave, AugmentationName));
        return False;
    }

    // if (bIsActive)
    //  Deactivate();

    // CurrentLevel++;

    // Vanilla Matters: We can just do this and ensure uninterrupted functioning of augs.
    if ( bIsActive || bAlwaysActive ) {
        GotoState( 'Inactive' );
        CurrentLevel = CurrentLevel + 1;
        GotoState( 'Active' );
    }
    else {
        CurrentLevel = CurrentLevel + 1;
    }

    Player.ClientMessage(Sprintf(AugNowHave, AugmentationName, CurrentLevel + 1));
}

// ----------------------------------------------------------------------
// CanBeUpgraded()
//
// Checks to see if the player has an Upgrade cannister for this
// augmentation, as well as making sure the augmentation isn't already
// at full strength.
// ----------------------------------------------------------------------

simulated function bool CanBeUpgraded()
{
    local bool bCanUpgrade;
    local Augmentation anAug;
    local AugmentationUpgradeCannister augCan;

    bCanUpgrade = False;

    // Check to see if this augmentation is already at
    // the maximum level
    if ( CurrentLevel < MaxLevel )
    {
        // Now check to see if the player has a cannister that can
        // be used to upgrade this Augmentation
        // augCan = AugmentationUpgradeCannister(player.FindInventoryType(Class'AugmentationUpgradeCannister'));

        // if (augCan != None)
        //  bCanUpgrade = True;

        // Vanilla Matters: Make upgrade independent from the upgrade cannister.
        bCanUpgrade = true;
    }

    return bCanUpgrade;
}

// ----------------------------------------------------------------------
// UsingMedBot()
// ----------------------------------------------------------------------

function UsingMedBot(bool bNewUsingMedbot)
{
    bUsingMedbot = bNewUsingMedbot;
}

// ----------------------------------------------------------------------
// UpdateInfo()
// ----------------------------------------------------------------------

simulated function bool UpdateInfo(Object winObject)
{
    local PersonaInfoWindow winInfo;
    local String strOut;

    winInfo = PersonaInfoWindow(winObject);
    if (winInfo == None)
        return False;

    winInfo.Clear();
    winInfo.SetTitle(AugmentationName);

    if (bUsingMedbot)
    {
        winInfo.SetText(Sprintf(OccupiesSlotLabel, AugLocsText[AugmentationLocation]));
        winInfo.AppendText(winInfo.CR() $ winInfo.CR() $ Description);
    }
    else
    {
        winInfo.SetText(Description);
    }

    // Energy Rate
    //winInfo.AppendText(winInfo.CR() $ winInfo.CR() $ Sprintf(EnergyRateLabel, Int(EnergyRate)));

    // Vanilla Matters: Update the correct energy rate with increase.
    winInfo.AppendText( winInfo.CR() $ winInfo.CR() $ Sprintf( EnergyRateLabel, Int( EnergyRate + Default.VM_EnergyRateAddition[CurrentLevel] ) ) );

    // Current Level
    strOut = Sprintf(CurrentLevelLabel, CurrentLevel + 1);

    // Can Upgrade / Is Active labels
    if (CanBeUpgraded())
        strOut = strOut @ CanUpgradeLabel;
    else if (CurrentLevel == MaxLevel )
        strOut = strOut @ MaximumLabel;

    winInfo.AppendText(winInfo.CR() $ winInfo.CR() $ strOut);

    // Always Active?
    if (bAlwaysActive)
        winInfo.AppendText(winInfo.CR() $ winInfo.CR() $ AlwaysActiveLabel);

    return True;
}

// ----------------------------------------------------------------------
// IsActive()
// ----------------------------------------------------------------------

simulated function bool IsActive()
{
    return bIsActive;
}

// ----------------------------------------------------------------------
// IsAlwaysActive()
// ----------------------------------------------------------------------

simulated function bool IsAlwaysActive()
{
    return bAlwaysActive;
}

// ----------------------------------------------------------------------
// GetHotKey()
// ----------------------------------------------------------------------

simulated function int GetHotKey()
{
    return hotKeyNum;
}

// ----------------------------------------------------------------------
// GetCurrentLevel()
// ----------------------------------------------------------------------

simulated function int GetCurrentLevel()
{
    return CurrentLevel;
}

// ----------------------------------------------------------------------
// GetEnergyRate()
//
// Allows the individual augs to override their energy use
// ----------------------------------------------------------------------

simulated function float GetEnergyRate()
{
    //return energyRate;

    // Vanilla Matters: Make it use the added energy rate.
    return energyRate + VM_EnergyRateAddition[CurrentLevel];
}

// Vanilla Matters: Get the amount of energy that has to be immediately drained.
function float GetImmediateEnergyRate() {
    local float iER;

    // VM: Gotta do this because we're gonna reset immediateEnergyRate to 0 after returning it.
    iER = VM_immediateEnergyRate;
    VM_immediateEnergyRate = 0;

    return iER;
}

// Vanilla Matters: Something to add immediateEnergyRate.
function AddImmediateEnergyRate( float iER ) {
    VM_immediateEnergyRate = VM_immediateEnergyRate + iER;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     MaxLevel=3
     IconWidth=52
     IconHeight=52
     HotKeyNum=-1
     EnergyRateLabel="Energy Rate: %s Units/Minute"
     OccupiesSlotLabel="Occupies Slot: %s"
     AugLocsText(0)="Cranial"
     AugLocsText(1)="Eyes"
     AugLocsText(2)="Torso"
     AugLocsText(3)="Arms"
     AugLocsText(4)="Legs"
     AugLocsText(5)="Subdermal"
     AugLocsText(6)="Default"
     AugActivated="%s activated"
     AugDeactivated="%s deactivated"
     MPInfo="DEFAULT AUG MP INFO - REPORT THIS AS A BUG"
     AugAlreadyHave="You already have the %s at the maximum level"
     AugNowHave="%s upgraded to level %s"
     AugNowHaveAtLevel="Augmentation %s at level %s"
     AlwaysActiveLabel="[Always Active]"
     CanUpgradeLabel="(Can Upgrade)"
     CurrentLevelLabel="Current Level: %s"
     MaximumLabel="(Maximum)"
     ActivateSound=Sound'DeusExSounds.Augmentation.AugActivate'
     DeActivateSound=Sound'DeusExSounds.Augmentation.AugDeactivate'
     LoopSound=Sound'DeusExSounds.Augmentation.AugLoop'
     bHidden=True
     bTravel=True
     NetUpdateFrequency=5.000000
}
