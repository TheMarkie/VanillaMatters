//=============================================================================
// AugAqualung.
//=============================================================================
class AugAqualung extends Augmentation;

var float mult, pct;

var float mpAugValue;
var float mpEnergyDrain;

state Active
{
Begin:
	// mult = Player.SkillSystem.GetSkillLevelValue(class'SkillEnviro');
	// pct = Player.swimTimer / Player.swimDuration;
	// Player.UnderWaterTime = LevelValues[CurrentLevel];
	// Player.swimDuration = Player.UnderWaterTime * mult;
	// Player.swimTimer = Player.swimDuration * pct;

	// if (( Level.NetMode != NM_Standalone ) && Player.IsA('Human') )
	// {
	// 	mult = Player.SkillSystem.GetSkillLevelValue(class'SkillEnviro');
	// 	Player.WaterSpeed = Human(Player).Default.mpWaterSpeed * 2.0 * mult;
	// }

	// Vanilla Matters: Since it's always active, no need to reapply values everytime.
	Player.UnderWaterTime = LevelValues[CurrentLevel];
}

function Deactivate()
{
	Super.Deactivate();
	
	// mult = Player.SkillSystem.GetSkillLevelValue(class'SkillEnviro');
	// pct = Player.swimTimer / Player.swimDuration;
	// Player.UnderWaterTime = Player.Default.UnderWaterTime;
	// Player.swimDuration = Player.UnderWaterTime * mult;
	// Player.swimTimer = Player.swimDuration * pct;

	// if (( Level.NetMode != NM_Standalone ) && Player.IsA('Human') )
	// {
	// 	mult = Player.SkillSystem.GetSkillLevelValue(class'SkillEnviro');
	// 	Player.WaterSpeed = Human(Player).Default.mpWaterSpeed * mult;
	// }
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
     mpAugValue=240.000000
     EnergyRate=0.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconAquaLung'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconAquaLung_Small'
     bAlwaysActive=True
     AugmentationName="Aqualung"
     Description="Soda lime exostructures imbedded in the alveoli of the lungs convert CO2 to O2, extending the time an agent can remain underwater.|n|nTECH ONE: Lung capacity is extended to 40 seconds.|n|nTECH TWO: Lung capacity is extended to 80 seconds.|n|nTECH THREE: Lung capacity is extended to 240 seconds.|n|nTECH FOUR: An agent can stay underwater indefinitely."
     MPInfo="When active, you can stay underwater 12 times as long and swim twice as fast.  Energy Drain: None"
     LevelValues(0)=40.000000
     LevelValues(1)=80.000000
     LevelValues(2)=240.000000
     LevelValues(3)=2560.000000
     AugmentationLocation=LOC_Torso
     MPConflictSlot=9
}
