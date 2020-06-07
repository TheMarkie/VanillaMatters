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
     Description="Power consumption for all augmentations is reduced by polyaniline circuits, plugged directly into cell membranes, that allow nanite particles to interconnect electronically without leaving their host cells.|n|n[TECH ONE]|nPower consumption of augmentations is reduced by 15%.|n|n[TECH TWO]|nPower consumption is reduced by 30%.|n|n[TECH THREE]|nPower consumption is reduced by 45%.|n|n[TECH FOUR]|nPower consumption is reduced by 60%."
     MPInfo="Reduces the cost of other augs.  Automatically used when needed.  Energy Drain: None"
     LevelValues(0)=0.850000
     LevelValues(1)=0.700000
     LevelValues(2)=0.550000
     LevelValues(3)=0.400000
     AugmentationLocation=LOC_Torso
     MPConflictSlot=5
}
