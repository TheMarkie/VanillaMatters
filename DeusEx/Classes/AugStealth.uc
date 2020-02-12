//=============================================================================
// AugStealth.
//=============================================================================
class AugStealth extends Augmentation;

var float mpAugValue;
var float mpEnergyDrain;

state Active
{
Begin:
     // Vanilla Matters: No idea why they would call GetAugLevelValue here.
     Player.RunSilentValue = LevelValues[CurrentLevel];
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
     Description="The necessary muscle movements for complete silence when walking or running are determined continuously with reactive kinematics equations produced by embedded nanocomputers.|n|nTECH ONE: Movement is 15% quieter.|n- Falling damage reduced by 8 points.|n|nTECH TWO: Movement is 30% quieter.|n- Falling damage reduced by 12 points.|n|nTECH THREE: Movement is 60% quieter.|n- Falling damage reduced by 16 points.|n|nTECH FOUR: An agent is completely silent.|n- Falling damage reduced by 20 points."
     LevelValues(0)=0.850000
     LevelValues(1)=0.700000
     LevelValues(2)=0.400000
     AugmentationLocation=LOC_Leg
     MPConflictSlot=8
}
