//=============================================================================
// AugShield.
//=============================================================================
class AugShield extends Augmentation;

defaultproperties
{
     Icon=Texture'DeusExUI.UserInterface.AugIconShield'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconShield_Small'
     bAlwaysActive=True
     AugmentationName="Energy Shield"
     Description="Polyaniline capacitors below the skin absorb heat and electricity, reducing the damage received from flame, electrical, emp and plasma attacks.|n|n[TECH ONE]|nDamage from energy attacks is reduced by 20%.|n|n[TECH TWO]|nDamage from energy attacks is reduced by 40%.|n|n[TECH THREE]|nDamage from energy attacks is reduced by 60%.|n|n[TECH FOUR]|nAn agent is nearly invulnerable energy attacks. Damage from energy attacks is reduced by 80%."
     MPInfo="When active, you only take 40% damage from flame and plasma attacks.  Energy Drain: None"
     LevelValues(0)=0.800000
     LevelValues(1)=0.600000
     LevelValues(2)=0.400000
     LevelValues(3)=0.200000
     AugmentationLocation=LOC_Subdermal
     MPConflictSlot=1
}
