//=============================================================================
// AugShield.
//=============================================================================
class AugShield extends Augmentation;

var float mpAugValue;
var float mpEnergyDrain;

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
     mpAugValue=0.400000
     Icon=Texture'DeusExUI.UserInterface.AugIconShield'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconShield_Small'
     bAlwaysActive=True
     AugmentationName="Energy Shield"
     Description="Polyaniline capacitors below the skin absorb heat and electricity, reducing the damage received from flame, electrical, emp and plasma attacks.|n|nTECH ONE: Damage from energy attacks is reduced by 20%.|n|nTECH TWO: Damage from energy attacks is reduced by 40%.|n|nTECH THREE: Damage from energy attacks is reduced by 60%.|n|nTECH FOUR: An agent is nearly invulnerable energy attacks. Damage from energy attacks is reduced by 80%."
     MPInfo="When active, you only take 40% damage from flame and plasma attacks.  Energy Drain: None"
     LevelValues(0)=0.800000
     LevelValues(1)=0.600000
     LevelValues(2)=0.400000
     LevelValues(3)=0.200000
     AugmentationLocation=LOC_Subdermal
     MPConflictSlot=1
}
