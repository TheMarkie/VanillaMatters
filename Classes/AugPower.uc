//=============================================================================
// AugPower.
//=============================================================================
class AugPower extends Augmentation;

var float mpAugValue;
var float mpEnergyDrain;

state Active
{
Begin:
     // Vanilla Matters: We added a variable to AugmentationManager instead.
     Player.AugmentationSystem.VM_energyMult = LevelValues[CurrentLevel];
}

function Deactivate()
{
    //Super.Deactivate();

     // Vanilla Matters: Can't turn it off now.
}

simulated function PreBeginPlay()
{
    Super.PreBeginPlay();

    // If this is a netgame, then override defaults
    if ( Level.NetMode != NM_StandAlone )
    {
        LevelValues[3] = mpAugValue;
        EnergyRate = mpEnergyDrain;
    }
}

defaultproperties
{
     mpAugValue=0.600000
     Icon=Texture'DeusExUI.UserInterface.AugIconPowerRecirc'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconPowerRecirc_Small'
     bAlwaysActive=True
     AugmentationName="Power Recirculator"
     Description="Power consumption for all augmentations is reduced by polyanilene circuits, plugged directly into cell membranes, that allow nanite particles to interconnect electronically without leaving their host cells.|n|nTECH ONE: Power drain of augmentations is reduced by 15%.|n|nTECH TWO: Power drain is reduced by 30%.|n|nTECH THREE: Power drain is reduced by 45%.|n|nTECH FOUR: Power drain is reduced by 60%."
     MPInfo="Reduces the cost of other augs.  Automatically used when needed.  Energy Drain: None"
     LevelValues(0)=0.850000
     LevelValues(1)=0.700000
     LevelValues(2)=0.550000
     LevelValues(3)=0.400000
     AugmentationLocation=LOC_Torso
     MPConflictSlot=5
}
