class AugBallistic extends VMAugmentation;

defaultproperties
{
     Icon=Texture'DeusExUI.UserInterface.AugIconBallistic'
     SmallIcon=Texture'DeusExUI.UserInterface.AugIconBallistic_Small'
     UpgradeName="Ballistic Protection"
     Description="Monomolecular plates reinforce the skin's epithelial membrane, reducing the damage an agent receives from projectiles and bladed weapons.|n|nOnly active when energy is above 60%.|nConsume energy per damage reduced.|n|nDamage Resistance: 60%|nDamage Reduced Per Energy: 1 / 2 / 3 / 4"
     InstallLocation=AugmentationLocationSubdermal
     Rates=(0,0,0,0)
     BehaviourClassName=AugBallisticBehaviour
}
