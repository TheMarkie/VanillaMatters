//=============================================================================
// AugStealth.
//=============================================================================
class AugStealth extends Augmentation;

var float mpAugValue;
var float mpEnergyDrain;

state Active
{
Begin:
	// Player.RunSilentValue = Player.AugmentationSystem.GetAugLevelValue(class'AugStealth');
	// if ( Player.RunSilentValue == -1.0 )
	// 	Player.RunSilentValue = 1.0;

     // Vanilla Matters: No idea why they would call GetAugLevelValue here.
     Player.RunSilentValue = LevelValues[CurrentLevel];
}

function Deactivate()
{
	// Player.RunSilentValue = 1.0;
	// Super.Deactivate();

     // Vanilla Matters: It can't be deactivated because it's always on.
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
     Icon=Texture'DeusExUI.UserInterface.AugIconRunSilent'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconRunSilent_Small'
     bAlwaysActive=True
     AugmentationName="Run Silent"
     Description="The necessary muscle movements for complete silence when walking or running are determined continuously with reactive kinematics equations produced by embedded nanocomputers.|n|nTECH ONE: Movement is 25% quieter.|n- Falling damage reduced by 5 points.|n|nTECH TWO: Movement is 50% quieter.|n- Falling damage reduced by 10 points.|n|nTECH THREE: Movement is 75% quieter.|n- Falling damage reduced by 15 points.|n|nTECH FOUR: An agent is completely silent.|n- Falling damage reduced by 20 points."
     LevelValues(0)=0.750000
     LevelValues(1)=0.500000
     LevelValues(2)=0.250000
     AugmentationLocation=LOC_Leg
     MPConflictSlot=8
}
