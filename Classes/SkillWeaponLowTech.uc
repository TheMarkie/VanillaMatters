//=============================================================================
// SkillWeaponLowTech.
//=============================================================================
class SkillWeaponLowTech extends Skill;

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
     SkillName="Weapons: Low-Tech"
     Description="The use of melee weapons such as knives, throwing knives, swords, pepper guns, and prods.|n|nUNTRAINED: An agent can use melee weaponry.|n|nTRAINED:|n+20% damage and +5% accuracy.|n+20% prod and pepper gun stun duration.|n|nADVANCED:|n+50% damage and +12.5% accuracy.|n+50% prod and pepper gun stun duration.|n|nMASTER: An agent can render most opponents unconscious or dead with a single blow.|n+100% damage and +25% accuracy.|n+100% prod and pepper gun stun duration."
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconWeaponLowTech'
     cost(0)=1350
     cost(1)=2700
     cost(2)=4500
     LevelValues(1)=-0.100000
     LevelValues(2)=-0.250000
     LevelValues(3)=-0.500000
}
