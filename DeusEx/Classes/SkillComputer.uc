//=============================================================================
// SkillComputer.
//=============================================================================
class SkillComputer extends VMSkill;

defaultproperties
{
     SkillName="Computer"
     Description="The covert manipulation of computers and security consoles.|n|n[UNTRAINED]|nAn agent can use terminals to read bulletins and news.|n|n[TRAINED]|nAn agent can hack ATMs, computers and security consoles.|n- Available hacking time is 7s.|n|n[ADVANCED]|nAn agent gains the ability to control gun turrets.|n- Available hacking time is 14s.|n|n[MASTER]|nAn agent is an elite hacker that few systems can withstand.|n- Available hacking time is 28s."
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconComputer'
     Costs=(1350,2700,4500)
     SkillValues=((Name="HackingTimeMult",Values=(0,1,2,4)))
}
