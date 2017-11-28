//=============================================================================
// AugDrone.
//=============================================================================
class AugDrone extends Augmentation;

var float mpAugValue;
var float mpEnergyDrain;

var float reconstructTime;
var float lastDroneTime;

state Active
{
Begin:
	if (Level.TimeSeconds - lastDroneTime < reconstructTime)
	{
		Player.ClientMessage("Reconstruction will be complete in" @ Int(reconstructTime - (Level.TimeSeconds - lastDroneTime)) @ "seconds");
		Deactivate();
	}
	// else
	// {
	// 	Player.bSpyDroneActive = True;
	// 	Player.spyDroneLevel = CurrentLevel;
	// 	Player.spyDroneLevelValue = LevelValues[CurrentLevel];
	// }
	// Vanilla Matters: Allows updating the drone even when it's functioning.
	else {
		if ( Player.aDrone != None ) {
			Player.aDrone.Speed = 75 + ( 25 * CurrentLevel );
			Player.aDrone.MaxSpeed = Player.aDrone.Speed;
			Player.aDrone.Damage = LevelValues[CurrentLevel];
			Player.aDrone.blastRadius = 200 + ( 50 * CurrentLevel );
		}

		Player.bSpyDroneActive = True;
		Player.spyDroneLevel = CurrentLevel;
		Player.spyDroneLevelValue = LevelValues[CurrentLevel];
	}
}

function Deactivate()
{
	Super.Deactivate();

	// record the time if we were just active
	if (Player.bSpyDroneActive)
		lastDroneTime = Level.TimeSeconds;

	Player.bSpyDroneActive = False;
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
     mpAugValue=200.000000
     mpEnergyDrain=15.000000
     reconstructTime=30.000000
     lastDroneTime=-30.000000
     EnergyRate=30.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconDrone'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconDrone_Small'
     AugmentationName="Spy Drone"
     Description="Advanced nanofactories can assemble a spy drone upon demand which can then be remotely controlled by the agent until released or destroyed, at which a point a new drone will be assembled. Further upgrades equip the spy drones with better armor and a one-shot EMP attack.|n|nTECH ONE: The drone can take little damage and has a very light EMP attack.|n|nTECH TWO:|n+33% drone speed.|n+100% EMP damage.|n+25% blast radius.|n|nTECH THREE:|n+67% drone speed.|n+300% EMP damage.|n+50% blast radius.|n|nTECH FOUR:|n+100% drone speed.|n+700% EMP damage.|n+75% blast radius.|n|nDrone detonation costs one minute worth of energy drain."
     MPInfo="Activation creates a remote-controlled spy drone.  Deactivation disables the drone.  Firing while active detonates the drone in a massive EMP explosion.  Energy Drain: Low"
     LevelValues(0)=15.000000
     LevelValues(1)=30.000000
     LevelValues(2)=60.000000
     LevelValues(3)=120.000000
     MPConflictSlot=7
     VM_EnergyRateAddition(1)=10.000000
     VM_EnergyRateAddition(2)=20.000000
     VM_EnergyRateAddition(3)=30.000000
}
