//=============================================================================
// SkillComputer.
//=============================================================================
class SkillComputer extends VMSkill;

defaultproperties
{
     SkillName="Computer"
     Description="The covert manipulation of computers and security consoles.|n|n[TRAINED]|nAn agent can hack ATMs, computers and security consoles.|nAvailable hacking time is 10 seconds.|n|n[ADVANCED]|nAn agent gains the ability to control gun turrets.|nAvailable hacking time is 15 seconds.|n|n[MASTER]|nAn agent is an elite hacker that few systems can withstand.|nAvailable hacking time is 25 seconds."
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconComputer'
     Costs=(2000,3000)
     SkillValues=((Name="HackingTime",Values=(10,15,25)))
}
