//=============================================================================
// AugCombat.
//=============================================================================
class AugCombat extends Augmentation;

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
     mpAugValue=1.000000
     mpEnergyDrain=40.000000
     EnergyRate=20.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconCombat'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconCombat_Small'
     AugmentationName="Combat Strength"
     Description="Sorting rotors accelerate calcium ion concentration in the sarcoplasmic reticulum, increasing an agent's muscle speed several-fold and multiplying the damage they inflict in melee combat.|n|nTECH ONE: Melee damage is increased by 25%.|n|nTECH TWO: Melee damage is increased by 50%.|n|nTECH THREE: Melee damage is increased by 75%.|n|nTECH FOUR: Melee weapons are almost instantly lethal. Melee damage is increased by 100%."
     MPInfo="When active, you do double damage with melee weapons.  Energy Drain: Moderate"
     LevelValues(0)=0.125000
     LevelValues(1)=0.250000
     LevelValues(2)=0.375000
     LevelValues(3)=0.500000
     AugmentationLocation=LOC_Arm
     MPConflictSlot=1
     VM_EnergyRateAddition(1)=10.000000
     VM_EnergyRateAddition(2)=20.000000
     VM_EnergyRateAddition(3)=30.000000
}
