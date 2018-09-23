//=============================================================================
// AugMuscle.
//=============================================================================
class AugMuscle extends Augmentation;

var float mpAugValue;
var float mpEnergyDrain;

// Vanilla Matters
var() float VM_muscleCost;

state Active
{
Begin:
}

function Deactivate()
{
    // Vanilla Matters: Don't need this anymore since it's all handled in DeusExPlayer.
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	// If this is a netgame, then override defaults
	if ( Level.NetMode != NM_StandAlone )
	{
		LevelValues[3] = mpAugValue;
		EnergyRate = mpEnergyDrain;
      //Lift with your legs, not with your back.
      AugmentationLocation = LOC_Leg;
	}
}

defaultproperties
{
     mpAugValue=2.000000
     VM_muscleCost=10.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconMuscle'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconMuscle_Small'
     bAlwaysActive=True
     AugmentationName="Microfibral Muscle"
     Description="Muscle strength is amplified with ionic polymeric gel myofibrils that allow the agent to push and lift extraordinarily heavy objects.|n|nTECH ONE: Strength is increased by 100%.|n- The agent can turn any object into a lethal missile with a powerthrow.|n(Powerthrow damage is relative to strength)|n+25% thrown weapon speed and distance.|n-10% accuracy penalty from arm injuries.|n-10% accuracy flinch when taking damage.|n|nTECH TWO: Strength is increased by 200%.|n+50% thrown weapon speed and distance.|n-20% accuracy penalty.|n-20% accuracy flinch.|n|nTECH THREE: Strength is increased by 300%.|n+75% thrown weapon speed and distance.|n-30% accuracy penalty.|n-30% accuracy flinch.|n|nTECH FOUR: An agent is inhumanly strong. Strength is increased by 400%.|n+100% thrown weapon speed and distance.|n-40% accuracy penalty.|n-40% accuracy flinch.|n|nStarts draining energy when a heavy object is held or a powerthrow is performed, drain rate depends on the object's mass."
     MPInfo="When active, you can pick up large crates.  Energy Drain: Low"
     LevelValues(0)=1.500000
     LevelValues(1)=2.000000
     LevelValues(2)=2.500000
     LevelValues(3)=3.000000
     AugmentationLocation=LOC_Arm
     MPConflictSlot=8
}
