//=============================================================================
// AugBallistic.
//=============================================================================
class AugBallistic extends Augmentation;

var float mpAugValue;
var float mpEnergyDrain;

state Active
{
Begin:
}

function Deactivate()
{
	Super.Deactivate();
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	// If this is a netgame, then override defaults
	if ( Level.NetMode != NM_StandAlone )
	{
		LevelValues[3] = mpAugValue;
		EnergyRate = mpEnergyDrain;
	}
}

defaultproperties
{
     mpAugValue=0.800000
	 bAlwaysActive=True
     Icon=Texture'DeusExUI.UserInterface.AugIconBallistic'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconBallistic_Small'
     AugmentationName="Ballistic Protection"
     Description="Monomolecular plates reinforce the skin's epithelial membrane, reducing the damage an agent receives from projectiles and bladed weapons.|n|nTECH ONE: Absorbs 10% ballistic damage.|n|nTECH TWO: Absorbs 20% ballistic damage.|n|nTECH THREE: Absorbs 35% ballistic damage.|n|nTECH FOUR: An agent is well guarded from projectiles and bladed weapons. Absorbs 55% ballistic damage."
     MPInfo="When active, damage from projectiles and melee weapons is reduced by 20%.  Energy Drain: None"
     LevelValues(0)=0.900000
     LevelValues(1)=0.800000
     LevelValues(2)=0.650000
     LevelValues(3)=0.450000
     AugmentationLocation=LOC_Subdermal
     MPConflictSlot=4
}
