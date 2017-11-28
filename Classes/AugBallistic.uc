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
     mpAugValue=0.600000
     mpEnergyDrain=30.000000
     EnergyRate=30.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconBallistic'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconBallistic_Small'
     AugmentationName="Ballistic Protection"
     Description="Monomolecular plates reinforce the skin's epithelial membrane, reducing the damage an agent receives from projectiles and bladed weapons.|n|nTECH ONE: Absorbs 15% ballistic damage.|n- Drains energy per damage taken.|n|nTECH TWO: Absorbs 30% ballistic damage.|n+100% drain efficiency.|n|nTECH THREE: Absorbs 50% ballistic damage.|n+200% drain efficiency.|n|nTECH FOUR: An agent is nearly invulnerable to damage from projectiles and bladed weapons. Absorbs 75% ballistic damage.|n+300% drain efficiency."
     MPInfo="When active, damage from projectiles and melee weapons is reduced by 40%.  Energy Drain: Low"
     LevelValues(0)=0.850000
     LevelValues(1)=0.700000
     LevelValues(2)=0.500000
     LevelValues(3)=0.250000
     AugmentationLocation=LOC_Subdermal
     MPConflictSlot=4
}
