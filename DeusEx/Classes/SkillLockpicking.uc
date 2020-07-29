class SkillLockpicking extends VMSkill;

defaultproperties
{
     UpgradeName="Lockpicking"
     Description="Lockpicking is as much art as skill, but with intense study it can be mastered by any agent with patience and a set of lockpicks.|n|n[TRAINED]|nAn agent can pick locks at a rate of 10% per pick.|n|n[ADVANCED]|nPick locks at a rate of 20% per pick.|n|n[MASTER]|nAn agent can defeat almost any mechanical lock.|nPick locks at a rate of 40% per pick."
     Icon=Texture'DeusExUI.UserInterface.SkillIconLockPicking'
     Costs=(2000,3000)
     GlobalValues=((Name=Lockpicking,Values=(10,20,40)))
}
