//=============================================================================
// SkillMedicine.
//=============================================================================
class SkillMedicine extends VMSkill;

defaultproperties
{
     SkillName="Medicine"
     Description="Practical knowledge of human physiology can be applied by an agent in the field allowing more efficient use of medical supplies.|n|nUNTRAINED: An agent can use medkits and bioelectric cells.|n- Medkits heal for 35 points.|n- Bioelectric cells recharge 15 points.|n|nTRAINED:|n- Medkits heal for 55 points.|n- Bioelectric cells recharge 25 points.|n|nADVANCED:|n- Medkits heal for 85 points.|n- Bioelectric cells recharge 40 points.|n|nMASTER: An agent can perform a heart bypass with household materials.|n- Medkits heal for 125 points.|n- Bioelectric cells recharge 60 points."
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconMedicine'
     Costs=(1125,2250,3750)
     SkillValues=((Name="HealingBonus",Values=(0,20,50,90)),(Name="RechargeBonus",Values=(0,10,25,45)))
}
