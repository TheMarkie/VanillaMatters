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
     Description="Induced keratin production strengthens all epithelial tissues and reduces the agent's vulnerability to radiation and other toxins.|n|n[TECH ONE]|nToxic resistance is increased by 20%.|n|n[TECH TWO]|nToxic resistance is increased by 40%.|n|n[TECH THREE]|nToxic resistance is increased by 60%.|n|n[TECH FOUR]|nAn agent is nearly invulnerable to damage from toxins. Toxic resistance is increased by 80%."
     MPInfo="When active, you only take 25% damage from poison and gas, and poison and gas will not affect your vision.  Energy Drain: None"
     LevelValues(0)=0.800000
     LevelValues(1)=0.600000
     LevelValues(2)=0.400000
     LevelValues(3)=0.200000
     AugmentationLocation=LOC_Torso
     MPConflictSlot=3
}
