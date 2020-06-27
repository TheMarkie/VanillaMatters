//=============================================================================
// AugRadarTrans.
//=============================================================================
class AugRadarTrans extends Augmentation;

state Active
{
Begin:
}

function Deactivate()
{
    Super.Deactivate();
}

function float GetEnergyRate()
{
    return energyRate * LevelValues[CurrentLevel];
}

defaultproperties
{
     EnergyRate=300.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconRadarTrans'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconRadarTrans_Small'
     AugmentationName="Radar Transparency"
     Description="Radar-absorbent resin augments epithelial proteins; microprojection units distort agent's visual signature. Provides highly effective concealment from automated detection systems -- bots, cameras, turrets.|n|n[TECH ONE]|nPower consumption is high.|n|n[TECH TWO]|nower consumption is reduced by 20%.|n|n[TECH THREE]|nPower consumption is reduced by 40%.|n|n[TECH FOUR]|nPower consumption is reduced by 60%."
     MPInfo="When active, you are invisible to electronic devices such as cameras, turrets, and proximity mines.  Energy Drain: Very Low"
     LevelValues(0)=1.000000
     LevelValues(1)=0.800000
     LevelValues(2)=0.600000
     LevelValues(3)=0.400000
     AugmentationLocation=LOC_Subdermal
     MPConflictSlot=2
     VM_dragIcon=Texture'DeusEx.VMUI.AugIconRadar'
}
