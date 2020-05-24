//=============================================================================
// SkillTech.
//=============================================================================
class SkillTech extends VMSkill;

defaultproperties
{
     SkillName="Electronics"
     Description="By studying electronics and its practical application, agents can more efficiently bypass a number of security systems using multitools.|n|nUNTRAINED: An agent can bypass security systems.|n- Each multitool bypasses 8%.|n|nTRAINED:|n- Each multitool bypasses 10%.|n|nADVANCED:|n- Each multitool bypasses 20%.|n|nMASTER: An agent encounters almost no security system of any challenge.|n- Each multitool bypasses 40%."
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconTech'
     Costs=(900,1800,3000)
     SkillValues=((Name="Multitooling",Values=(8,10,20,40)))
}
