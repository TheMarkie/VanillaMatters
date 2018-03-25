//=============================================================================
// AugShield.
//=============================================================================
class AugShield extends Augmentation;

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
      AugmentationLocation = LOC_Arm;
	}
}

defaultproperties
{
     mpAugValue=0.500000
     Icon=Texture'DeusExUI.UserInterface.AugIconShield'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconShield_Small'
     AugmentationName="Energy Shield"
     Description="Polyanilene capacitors below the skin absorb heat and electricity, reducing the damage received from flame, electrical, and plasma attacks.|n|nTECH ONE: Absorbs 20% energy damage.|n- Drains energy per damage taken.|n|nTECH TWO: Absorbs 40% energy damage.|n+100% drain efficiency.|n|nTECH THREE: Absorbs 60% energy damage.|n+200% drain efficiency.|n|nTECH FOUR: An agent is nearly invulnerable to damage from energy attacks. Absorbs 80% energy damage.|n+300% drain efficiency."
     MPInfo="When active, you only take 50% damage from flame and plasma attacks.  Energy Drain: Low"
     LevelValues(0)=0.800000
     LevelValues(1)=0.600000
     LevelValues(2)=0.400000
     LevelValues(3)=0.200000
     AugmentationLocation=LOC_Torso
     MPConflictSlot=1
}
