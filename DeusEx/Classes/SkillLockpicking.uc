//=============================================================================
// SkillLockpicking.
//=============================================================================
class SkillLockpicking extends VMSkill;

defaultproperties
{
     SkillName="Lockpicking"
     Description="Lockpicking is as much art as skill, but with intense study it can be mastered by any agent with patience and a set of lockpicks.|n|n[UNTRAINED]|nAn agent can pick locks.|n- Each pick unlocks 8%.|n|n[TRAINED]|n- Each pick unlocks 10%.|n|n[ADVANCED]|n- Each pick unlocks 20%.|n|n[MASTER]|nAn agent can defeat almost any mechanical lock.|n- Each pick unlocks 40%."
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconLockPicking'
     Costs=(900,1800,3000)
     SkillValues=((Name="Lockpicking",Values=(8,10,20,40)))
}
