//=============================================================================
// AugEnviro.
//=============================================================================
class AugEnviro extends Augmentation;

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
      AugmentationLocation = LOC_Subdermal;
	}
}

defaultproperties
{
     mpAugValue=0.100000
     Icon=Texture'DeusExUI.UserInterface.AugIconEnviro'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconEnviro_Small'
     bAlwaysActive=True
     AugmentationName="Environmental Resistance"
     Description="Induced keratin production strengthens all epithelial tissues and reduces the agent's vulnerability to radiation and other toxins.|n|nTECH ONE: Absorbs 30% toxic damage.|n|nTECH TWO: Absorbs 45% toxic damage.|n|nTECH THREE: Absorbs 65% toxic damage.|n|nTECH FOUR: An agent is nearly invulnerable to damage from toxins. Absorbs 90% toxic damage."
     MPInfo="When active, you only take 10% damage from poison and gas, and poison and gas will not affect your vision.  Energy Drain: None"
     LevelValues(0)=0.700000
     LevelValues(1)=0.550000
     LevelValues(2)=0.350000
     LevelValues(3)=0.100000
     AugmentationLocation=LOC_Torso
     MPConflictSlot=3
}
