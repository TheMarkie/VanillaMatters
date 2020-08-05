//=============================================================================
// AugPower.
//=============================================================================
class AugPower extends Augmentation;

state Active
{
Begin:
     // Vanilla Matters: We added a variable to AugmentationManager instead.
     // Vanilla Maters TODO: Fix or replace this aug.
}

defaultproperties
{
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
