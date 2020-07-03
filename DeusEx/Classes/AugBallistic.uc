//=============================================================================
// AugBallistic.
//=============================================================================
class AugBallistic extends Augmentation;

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
     mpAugValue=6.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconBallistic'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconBallistic_Small'
     bAlwaysActive=True
     AugmentationName="Ballistic Protection"
     Description="Monomolecular plates reinforce the skin's epithelial membrane, reducing the damage an agent receives from projectiles and bladed weapons.|n|n[TECH ONE]|nDamage from projectiles and bladed weapons is reduced by 15%.|n|n[TECH TWO]|nDamage is reduced by 30%.|n|n[TECH THREE]|nDamage is reduced by 45%.|n|n[TECH FOUR]|nAn agent is well armored against projectiles and bladed weapons.|nDamage is reduced by 60%."
     MPInfo="When active, damage from projectiles and melee weapons is reduced by 6.  Energy Drain: None"
     LevelValues(0)=0.850000
     LevelValues(1)=0.700000
     LevelValues(2)=0.550000
     LevelValues(3)=0.400000
     AugmentationLocation=LOC_Subdermal
     MPConflictSlot=4
}
