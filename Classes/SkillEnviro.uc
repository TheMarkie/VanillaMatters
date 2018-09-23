//=============================================================================
// SkillEnviro.
//=============================================================================
class SkillEnviro extends Skill;

var int mpCost1;
var int mpCost2;
var int mpCost3;
var float mpLevel0;
var float mpLevel1;
var float mpLevel2;
var float mpLevel3;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	if ( Level.NetMode != NM_Standalone )
	{
		cost[0] = mpCost1;
		cost[1] = mpCost2;
		cost[2] = mpCost3;
		LevelValues[0] = mpLevel0;
		LevelValues[1] = mpLevel1;
		LevelValues[2] = mpLevel2;
		LevelValues[3] = mpLevel3;
	}
}

defaultproperties
{
     mpCost1=1000
     mpCost2=1000
     mpCost3=1000
     mpLevel0=1.000000
     mpLevel1=0.750000
     mpLevel2=0.500000
     mpLevel3=0.250000
     SkillName="Environmental Training"
     Description="Experience with operating in various hazardous environments, and using specialized equipments.|n|nUNTRAINED: An agent can use hazmat suits, ballistic armor, thermoptic camo, rebreathers and tech goggles. An agent can also swim normally.|n- Lung capacity is 20 seconds.|n|nTRAINED:|n+33% ballistic armor's and +25% hazmat suit's durability.|n+25% damage resistance from ballistic armor and hazmat suit (diminishingly).|n+25% gadgets' durability.|n+50% swimming speed and +5s lung capacity.|n|nADVANCED:|n+100% armor's and +50% suit's durability.|n+50% damage resistance.|n+50% gadgets' durability.|n- Unlock infravision on Tech Goggles.|n(Press Reload to switch between vision types)|n+100% swimming speed and +10s lung capacity.|n|nMASTER: An agent wears suits and armor like a second skin, moves like a dolphin underwater.|n+300% armor's and +75% suit's durability.|n+75% damage resistance.|n+75% gadgets' durability.|n- Unlock short range sonar imaging on Tech Goggles.|n+150% swimming speed and +15s lung capacity."
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconEnviro'
     bAutomatic=True
     cost(0)=900
     cost(1)=1800
     cost(2)=3000
     LevelValues(0)=1.000000
     LevelValues(1)=0.750000
     LevelValues(2)=0.500000
     LevelValues(3)=0.250000
     VM_subSkillClass=Class'DeusEx.SkillSwimming'
}
