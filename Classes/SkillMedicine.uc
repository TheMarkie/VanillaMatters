//=============================================================================
// SkillMedicine.
//=============================================================================
class SkillMedicine extends Skill;

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
     mpLevel1=1.000000
     mpLevel2=2.000000
     mpLevel3=3.000000
     SkillName="Medicine"
     Description="Practical knowledge of human physiology can be applied by an agent in the field allowing more efficient use of medical supplies.|n|nUNTRAINED: An agent can use medkits and bioelectric cells.|n- Medkits heal for 35 points.|n- Bioelectric cells recharge 15 points.|n|nTRAINED:|n- Medkits heal for 55 points.|n- Bioelectric cells recharge 25 points.|n|nADVANCED:|n- Medkits heal for 85 points.|n- Bioelectric cells recharge 40 points.|n|nMASTER: An agent can perform a heart bypass with household materials.|n- Medkits heal for 125 points.|n- Bioelectric cells recharge 60 points."
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconMedicine'
     cost(0)=1125
     cost(1)=2250
     cost(2)=3750
     LevelValues(1)=20.000000
     LevelValues(2)=50.000000
     LevelValues(3)=90.000000
}
