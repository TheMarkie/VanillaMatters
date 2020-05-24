//=============================================================================
// SkillLockpicking.
//=============================================================================
class SkillLockpicking extends VMSkill;

defaultproperties
{
     SkillName="Lockpicking"
     Description="Lockpicking is as much art as skill, but with intense study it can be mastered by any agent with patience and a set of lockpicks.|n|nUNTRAINED: An agent can pick locks.|n- Each pick unlocks 8%.|n|nTRAINED:|n- Each pick unlocks 10%.|n|nADVANCED:|n- Each pick unlocks 20%.|n|nMASTER: An agent can defeat almost any mechanical lock.|n- Each pick unlocks 40%."
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconLockPicking'
     Costs=(900,1800,3000)
     SkillValues=((Name="Lockpicking",Values=(8,10,20,40)))
}
