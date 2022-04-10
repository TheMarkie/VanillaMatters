class AugShield extends VMAugmentation;

defaultproperties
{
     Icon=Texture'DeusExUI.UserInterface.AugIconShield'
     SmallIcon=Texture'DeusExUI.UserInterface.AugIconShield_Small'
     UpgradeName="Energy Shield"
     Description="Polyaniline capacitors below the skin absorb heat and electricity, reducing the damage received from flame, electrical, emp and plasma attacks.|n|nOnly active when energy is above 60%.|nConsume energy per damage reduced.|n|nDamage Resistance: 60%|nDamage Reduced Per Energy: 1 / 2 / 3 / 4"
     InstallLocation=AugmentationLocationSubdermal
     Rates=(0,0,0,0)
     BehaviourClassName=AugShieldBehaviour
}
