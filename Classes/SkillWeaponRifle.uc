//=============================================================================
// SkillWeaponRifle.
//=============================================================================
class SkillWeaponRifle extends Skill;

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
     SkillName="Weapons: Precision"
     Description="The use of sharpshooting weapons, including sniper rifles, the stealth pistol, and the mini-crossbow.|n|nUNTRAINED: An agent can use sniper rifles, the stealth pistol and the mini-crossbow.|n|nTRAINED:|n+20% damage, +5% accuracy.|n-20% stabilization time and +10% recoil recovery.|n-10% reload time.|n|nADVANCED:|n+50% damage, +12.5% accuracy.|n-50% stabilization time and +25% recoil recovery.|n-25% reload time.|n|nMASTER: An agent can take down a target a mile away with one shot.|n+100% damage, +25% accuracy.|n-100% stabilization time and +50% recoil recovery.|n-50% reload time."
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconWeaponRifle'
     cost(0)=1575
     cost(1)=3150
     cost(2)=5250
     LevelValues(1)=-0.100000
     LevelValues(2)=-0.250000
     LevelValues(3)=-0.500000
}
