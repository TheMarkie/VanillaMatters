class SkillMedicine extends VMSkill;

defaultproperties
{
     UpgradeName="Medicine"
     Description="Practical knowledge of human physiology can be applied by an agent in the field allowing more efficient use of medical supplies.|n|n[UNTRAINED]|nAn agent can use medkits and bioelectric cells.|n- Medkits heal for 30 points.|n- Bioelectric cells recharge 15 points.|n|n[TRAINED]|n- Medkits heal for 50 points.|n- Bioelectric cells recharge 25 points.|n|n[ADVANCED]|n- Medkits heal for 70 points.|n- Bioelectric cells recharge 40 points.|n|n[MASTER]|nAn agent can perform a heart bypass with household materials.|n- Medkits heal for 110 points.|n- Bioelectric cells recharge 60 points."
     Icon=Texture'DeusExUI.UserInterface.SkillIconMedicine'
     Costs=(1250,2000,2750)
     GlobalValues=((Name=HealingBonus,Values=(0,20,40,80)),(Name=RechargeBonus,Values=(0,10,25,45)))
}
