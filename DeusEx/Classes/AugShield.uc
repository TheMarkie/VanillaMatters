class AugShield extends VMAugmentation;

defaultproperties
{
     Icon=Texture'DeusExUI.UserInterface.AugIconShield'
     SmallIcon=Texture'DeusExUI.UserInterface.AugIconShield_Small'
     UpgradeName="Energy Shield"
     Description="Polyaniline capacitors below the skin absorb heat and electricity, reducing the damage received from flame, electrical, emp and plasma attacks.|n|nOnly active when energy is above 50%.|nConsume energy per damage reduced.|n|nDamage Resistance: 50% / 60% / 70% / 80%|nDamage Reduced Per Energy: 2 / 4 / 6 / 8"
     InstallLocation=AugmentationLocationTorso
     Rates=(0,0,0,0)
     BehaviourClassName=AugShieldBehaviour
}
