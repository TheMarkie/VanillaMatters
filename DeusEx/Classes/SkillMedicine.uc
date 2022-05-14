class SkillMedicine extends VMSkill;

defaultproperties
{
     UpgradeName="Medicine"
     Description="Practical knowledge of human physiology can be applied by an agent in the field allowing more efficient use of medical supplies.|n|nUNTRAINED: Agent can use medkits and bioelectric cells.|n|nMASTER: Agent can perform a heart bypass with household materials.|n|nMedkit Heal: 40 / 60 / 80 / 120|nBioelectric Cell Recharge: 20 / 30 / 45 / 60"
     Icon=Texture'DeusExUI.UserInterface.SkillIconMedicine'
     Costs=(1250,2000,2750)
     GlobalValues=((Name=HealingBonus,Values=(0,20,40,80)),(Name=RechargeBonus,Values=(0,10,25,40)))
}
