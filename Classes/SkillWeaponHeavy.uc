//=============================================================================
// SkillWeaponHeavy.
//=============================================================================
class SkillWeaponHeavy extends Skill;

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
     mpCost1=2000
     mpCost2=2000
     mpCost3=2000
     mpLevel0=-0.100000
     mpLevel1=-0.250000
     mpLevel2=-0.370000
     mpLevel3=-0.500000
     SkillName="Weapons: Destructive"
     Description="The use of explosive or heavy weaponry, including flamethrowers, LAWs, and the experimental plasma and GEP guns, in addition to various grenades.|n|nUNTRAINED: An agent can use heavy weaponry, but with difficult movement. An agent can also throw grenades, attach them to a surface as a proximity device, or attempt to disarm and remove a previously armed proximity device.|n- Gas grenades last for 15 seconds.|n- GEP Gun takes 2 seconds to lock on.|n- The safety margin for disarming proximity devices is 1 second.|n|nTRAINED:|n+20% damage, +5% accuracy, and -10% reload time.|n+20% gas grenade duration.|n- GEP Gun takes 1.7 seconds to lock on.|n- The safety margin is 2 seconds.|n|nADVANCED: An agent can move swiftly with heavy weapons.|n+50% damage, +12.5% accuracy, and -25% reload time.|n+50% gas grenade duration.|n- GEP Gun takes 1.25 seconds to lock on.|n- The safety margin is 5 seconds.|n|nMASTER: An agent is an expert in all forms of destruction.|n+100% damage, +25% accuracy, and -50% reload time.|n+100% gas grenade duration.|n- GEP Gun takes 0.5 seconds to lock on.|n- The safety margin is 10 seconds."
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconWeaponHeavy'
     cost(0)=1575
     cost(1)=3150
     cost(2)=5250
     LevelValues(1)=-0.100000
     LevelValues(2)=-0.250000
     LevelValues(3)=-0.500000
     VM_subSkillClass=Class'DeusEx.SkillDemolition'
}
