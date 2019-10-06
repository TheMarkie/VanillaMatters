//=============================================================================
// AugAqualung.
//=============================================================================
class AugAqualung extends Augmentation;

var float mult, pct;

var float mpAugValue;
var float mpEnergyDrain;

state Active
{
    // Vanilla Matters: Keep increasing the breath span so it never runs out.
    function Timer() {
        Player.swimTimer = FMin( Player.swimTimer + 4, Player.swimDuration );
    }

    function EndState() {
        if ( Level.NetMode == NM_StandAlone && CurrentLevel >= 3 ) {
            SetTimer( 1, false );
        }
    }

Begin:
    // Vanilla Matters: Bonus is now all handled in deusexplayer.
    // VM: We're gonna deal with the last aug level by a timer.
    if ( Level.NetMode == NM_StandAlone && CurrentLevel >= 3 ) {
        SetTimer( 1, true );
    }
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
     mpAugValue=220.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconAquaLung'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconAquaLung_Small'
     bAlwaysActive=True
     AugmentationName="Aqualung"
     Description="Soda lime exostructures imbedded in the alveoli of the lungs convert CO2 to O2, extending the time an agent can remain underwater.|n|nTECH ONE: Lung capacity is extended by 15 seconds.|n|nTECH TWO: Lung capacity is extended by 30 seconds.|n|nTECH THREE: Lung capacity is extended by 60 seconds.|n|nTECH FOUR: An agent can stay underwater indefinitely."
     MPInfo="When active, you can stay underwater 12 times as long.  Energy Drain: None"
     LevelValues(0)=15.000000
     LevelValues(1)=30.000000
     LevelValues(2)=60.000000
     LevelValues(3)=240.000000
     AugmentationLocation=LOC_Torso
     MPConflictSlot=9
}
