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
     mpAugValue=0.250000
     Icon=Texture'DeusExUI.UserInterface.AugIconEnviro'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconEnviro_Small'
     bAlwaysActive=True
     AugmentationName="Environmental Resistance"
     Description="Induced keratin production strengthens all epithelial tissues and reduces the agent's vulnerability to radiation and other toxins.|n|nTECH ONE: Toxic resistance is increased by 15%.|n|nTECH TWO: Toxic resistance is increased by 30%.|n|nTECH THREE: Toxic resistance is increased by 50%.|n|nTECH FOUR: An agent is nearly invulnerable to damage from toxins. Toxic resistance is increased by 75%."
     MPInfo="When active, you only take 25% damage from poison and gas, and poison and gas will not affect your vision.  Energy Drain: None"
     LevelValues(0)=0.850000
     LevelValues(1)=0.700000
     LevelValues(2)=0.500000
     LevelValues(3)=0.250000
     AugmentationLocation=LOC_Torso
     MPConflictSlot=3
}
