class AugBallistic extends VMAugmentation;

defaultproperties
{
     Icon=Texture'DeusExUI.UserInterface.AugIconBallistic'
     SmallIcon=Texture'DeusExUI.UserInterface.AugIconBallistic_Small'
     UpgradeName="Ballistic Protection"
     Description="Monomolecular plates reinforce the skin's epithelial membrane, reducing the damage an agent receives from projectiles and bladed weapons.|n|nOnly active when energy is above 50%.|nConsume energy per damage reduced.|n|nDamage Resistance: 40% / 50% / 60% / 70%|nDamage Reduced Per Energy: 4 / 6 / 8 / 10"
     InstallLocation=AugmentationLocationSubdermal
     Rates=(0,0,0,0)
     BehaviourClassName=AugBallisticBehaviour
}
