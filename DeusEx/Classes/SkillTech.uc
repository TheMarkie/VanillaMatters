class SkillTech extends VMSkill;

defaultproperties
{
     UpgradeName="Electronics"
     Description="By studying electronics and its practical application, agents can more efficiently bypass a number of security systems using multitools.|n|n[TRAINED]|nAn agent can bypass security systems at a rate of 10% per multitool.|n|n[ADVANCED]|nBypass at a rate of 20% per multitool.|n|n[MASTER]|nAn agent encounters almost no security system of any challenge.|nBypass at a rate of 40% per multitool."
     Icon=Texture'DeusExUI.UserInterface.SkillIconTech'
     Costs=(2000,3000)
     GlobalValues=((Name=Multitooling,Values=(10,20,40)))
}
