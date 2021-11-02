class AugShield extends VMAugmentation;

defaultproperties
{
     Icon=Texture'DeusExUI.UserInterface.AugIconShield'
     SmallIcon=Texture'DeusExUI.UserInterface.AugIconShield_Small'
     UpgradeName="Energy Shield"
     Description="Polyaniline capacitors below the skin absorb heat and electricity, reducing the damage received from flame, electrical, emp and plasma attacks.|n|n[TECH ONE]|nDamage from energy attacks is reduced by 20%.|n|n[TECH TWO]|nDamage from energy attacks is reduced by 40%.|n|n[TECH THREE]|nDamage from energy attacks is reduced by 60%.|n|n[TECH FOUR]|nAn agent is nearly invulnerable energy attacks. Damage from energy attacks is reduced by 80%."
     Rates=(0,0,0,0)
     InstallLocation=AugmentationLocationSubdermal
     BehaviourClassName=AugShieldBehaviour
}
