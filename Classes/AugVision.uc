//=============================================================================
// AugVision.
//=============================================================================
class AugVision extends Augmentation;

var float mpAugValue;
var float mpEnergyDrain;

// ----------------------------------------------------------------------------
// Networking Replication
// ----------------------------------------------------------------------------

replication
{
   //server to client function calls
   reliable if (Role == ROLE_Authority)
      SetVisionAugStatus;
}

// Vanilla Matters: I don't even know what the heck is going on here so I'm gonna rewrite this mess.
state Active {
	function BeginState() {
		SetVisionAugStatus( CurrentLevel + 1, LevelValues[CurrentLevel], true );
		Player.RelevantRadius = LevelValues[CurrentLevel];
	}
Begin:
}

state Inactive {
	function BeginState() {
		SetVisionAugStatus( 0, 0, false );
		Player.RelevantRadius = 0;
	}
Begin:
}

// ----------------------------------------------------------------------
// SetVisionAugStatus()
// ----------------------------------------------------------------------

// Vanilla Matters: Gonna rewrite the mess above for readability.
simulated function SetVisionAugStatus( int Level, float LevelValue, bool active ) {
	if ( active ) {
		if ( ++DeusExRootWindow( Player.rootWindow ).hud.augDisplay.activeCount == 1 ) {
			DeusExRootWindow( Player.rootWindow ).hud.augDisplay.bVisionActive = true;
		}
	}
	else {
		if ( --DeusExRootWindow( Player.rootWindow ).hud.augDisplay.activeCount == 0 ) {
			DeusExRootWindow( Player.rootWindow ).hud.augDisplay.bVisionActive = false;
		}

		DeusExRootWindow( Player.rootWindow ).hud.augDisplay.visionBlinder = None;
	}

	DeusExRootWindow( Player.rootWindow ).hud.augDisplay.visionLevel = Level;
	DeusExRootWindow( Player.rootWindow ).hud.augDisplay.visionLevelValue = LevelValue;
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
     mpAugValue=1000.000000
     mpEnergyDrain=60.000000
     EnergyRate=15.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconVision'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconVision_Small'
     AugmentationName="Vision Enhancement"
     Description="By bleaching selected rod photoreceptors and saturating them with metarhodopsin XII, the 'nightvision' present in most nocturnal animals can be duplicated. Subsequent upgrades and modifications add infravision and sonar-resonance imaging that effectively allows an agent to see through walls.|n|nTECH ONE: Infravision.|n|nTECH TWO: Close range sonar imaging.|n|nTECH THREE:|n+100% sonar imaging range.|n|nTECH FOUR:|n+300% sonar imaging range."
     MPInfo="When active, you can see enemy players in the dark from any distance, and for short distances you can see through walls and see cloaked enemies.  Energy Drain: Moderate"
     LevelValues(1)=480.000000
     LevelValues(2)=960.000000
     LevelValues(3)=1920.000000
     AugmentationLocation=LOC_Eye
     MPConflictSlot=6
     VM_EnergyRateAddition(1)=10.000000
     VM_EnergyRateAddition(2)=20.000000
     VM_EnergyRateAddition(3)=30.000000
     VM_dragIcon=Texture'DeusEx.VMUI.AugIconVision'
}
