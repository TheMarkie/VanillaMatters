//=============================================================================
// AugCombat.
//=============================================================================
class AugCombat extends Augmentation;

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
     EnergyRate=30.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconCombat'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconCombat_Small'
     AugmentationName="Combat Strength"
     Description="Sorting rotors accelerate calcium ion concentration in the sarcoplasmic reticulum, increasing an agent's muscle speed several-fold and multiplying the damage they inflict in melee combat.|n|n[TECH ONE]|n+ 25% melee damage|n+12.5% melee attack speed|n|n[TECH TWO]|n50% melee damage|n+25% melee attack speed|n|n[TECH THREE]|n75% melee damage|n+37.5% melee attack speed|n|n[TECH FOUR]|nMelee weapons are almost instantly lethal.|n100% melee damage|n+50% melee attack speed"
     MPInfo="When active, you do double damage with melee weapons.  Energy Drain: Moderate"
     LevelValues(0)=0.125000
     LevelValues(1)=0.250000
     LevelValues(2)=0.375000
     LevelValues(3)=0.500000
     AugmentationLocation=LOC_Arm
     MPConflictSlot=1
     VM_EnergyRateAddition(1)=10.000000
     VM_EnergyRateAddition(2)=20.000000
     VM_EnergyRateAddition(3)=30.000000
     VM_dragIcon=Texture'DeusEx.VMUI.AugIconCombat'
}
