//=============================================================================
// SkillLockpicking.
//=============================================================================
class SkillLockpicking extends Skill;

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
     mpLevel0=0.075000
     mpLevel1=0.100000
     mpLevel2=0.150000
     mpLevel3=0.250000
     SkillName="Lockpicking"
     Description="Lockpicking is as much art as skill, but with intense study it can be mastered by any agent with patience and a set of lockpicks.|n|nUNTRAINED: An agent can pick locks.|n- Each pick unlocks 7.5%.|n|nTRAINED:|n- Each pick unlocks 10%.|n|nADVANCED:|n- Each pick unlocks 20%.|n|nMASTER: An agent can defeat almost any mechanical lock.|n- Each pick unlocks 40%."
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconLockPicking'
     cost(0)=900
     cost(1)=1800
     cost(2)=3000
     LevelValues(0)=0.075000
     LevelValues(1)=0.100000
     LevelValues(2)=0.200000
     LevelValues(3)=0.400000
     itemNeeded=Class'DeusEx.Lockpick'
}
