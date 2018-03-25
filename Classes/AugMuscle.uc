//=============================================================================
// AugMuscle.
//=============================================================================
class AugMuscle extends Augmentation;

var float mpAugValue;
var float mpEnergyDrain;

state Active
{
Begin:
}

function Deactivate()
{
	// Super.Deactivate();

	// // check to see if the player is carrying something too heavy for him
	// if (Player.CarriedDecoration != None)
	// 	if (!Player.CanBeLifted(Player.CarriedDecoration))
	// 		Player.DropDecoration();

    // Vanilla Matters: Doesn't need this anymore since it's all handled in DeusExPlayer.
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
     Icon=Texture'DeusExUI.UserInterface.AugIconMuscle'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconMuscle_Small'
     bAlwaysActive=True
     AugmentationName="Microfibral Muscle"
     Description="Muscle strength is amplified with ionic polymeric gel myofibrils that allow the agent to push and lift extraordinarily heavy objects.|n|nTECH ONE: Strength is increased by 100%.|n- The agent can turn any object into a lethal missile with a powerthrow.|n|nTECH TWO: Strength is increased by 200%.|n+100% powerthrow damage.|n|nTECH THREE: Strength is increased by 300%.|n+300% powerthrow damage.|n|nTECH FOUR: An agent is inhumanly strong. Strength is increased by 400%.|n+700% powerthrow damage.|n|nStarts draining energy when a heavy object is held or a powerthrow is performed, drain rate depends on the object's mass."
     MPInfo="When active, you can pick up large crates.  Energy Drain: Low"
     LevelValues(0)=1.500000
     LevelValues(1)=2.000000
     LevelValues(2)=2.500000
     LevelValues(3)=3.000000
     AugmentationLocation=LOC_Arm
     MPConflictSlot=8
}
