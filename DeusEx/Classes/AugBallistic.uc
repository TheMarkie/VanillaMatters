class AugBallistic extends VMAugmentation;

defaultproperties
{
     Icon=Texture'DeusExUI.UserInterface.AugIconBallistic'
     SmallIcon=Texture'DeusExUI.UserInterface.AugIconBallistic_Small'
     UpgradeName="Ballistic Protection"
     Description="Monomolecular plates reinforce the skin's epithelial membrane, reducing the damage an agent receives from projectiles and bladed weapons.|n|n[TECH ONE]|nDamage from projectiles and bladed weapons is reduced by 15%.|n|n[TECH TWO]|nDamage is reduced by 30%.|n|n[TECH THREE]|nDamage is reduced by 45%.|n|n[TECH FOUR]|nAn agent is well armored against projectiles and bladed weapons.|nDamage is reduced by 60%."
     InstallLocation=AugmentationLocationSubdermal
     Rates=(0,0,0,0)
     BehaviourClassName=AugBallisticBehaviour
}
