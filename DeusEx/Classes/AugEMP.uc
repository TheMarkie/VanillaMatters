//=============================================================================
// AugEMP.
//=============================================================================
class AugEMP extends Augmentation;

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
     mpAugValue=0.050000
     Icon=Texture'DeusExUI.UserInterface.AugIconEMP'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconEMP_Small'
     bAlwaysActive=True
     AugmentationName="EMP Shield"
     Description="Nanoscale EMP generators partially protect individual nanites and reduce bioelectrical drain by canceling incoming pulses.|n|nTECH ONE: Damage from EMP attacks is reduced by 25%.|n|nTECH TWO: Damage from EMP attacks is reduced by 50%.|n|nTECH THREE: Damage from EMP attacks is reduced by 75%.|n|nTECH FOUR: An agent is invulnerable to damage from EMP attacks."
     MPInfo="When active, you only take 5% damage from EMP attacks.  Energy Drain: None"
     LevelValues(0)=0.750000
     LevelValues(1)=0.500000
     LevelValues(2)=0.250000
     AugmentationLocation=LOC_Subdermal
     MPConflictSlot=3
}
