//=============================================================================
// AugEMP.
//=============================================================================
class AugEMP extends Augmentation;

state Active
{
Begin:
}

function Deactivate()
{
    Super.Deactivate();
}

defaultproperties
{
     Icon=Texture'DeusExUI.UserInterface.AugIconEMP'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconEMP_Small'
     bAlwaysActive=True
     AugmentationName="EMP Shield"
     Description="Nanoscale EMP generators partially protect individual nanites and reduce bioelectrical drain by canceling incoming pulses.|n|n[TECH ONE]|nDamage from EMP attacks is reduced by 25%.|n|n[TECH TWO]|nDamage from EMP attacks is reduced by 50%.|n|n[TECH THREE]|nDamage from EMP attacks is reduced by 75%.|n|n[TECH FOUR]|nAn agent is invulnerable to damage from EMP attacks."
     MPInfo="When active, you only take 5% damage from EMP attacks.  Energy Drain: None"
     LevelValues(0)=0.750000
     LevelValues(1)=0.500000
     LevelValues(2)=0.250000
     AugmentationLocation=LOC_Subdermal
     MPConflictSlot=3
}
