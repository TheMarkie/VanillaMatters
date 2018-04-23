//=============================================================================
// AugShield.
//=============================================================================
class AugShield extends Augmentation;

var float mpAugValue;
var float mpEnergyDrain;

var travel float VM_ShieldTimer;
var travel float VM_ShieldRegenAmount;
var travel bool VM_bShieldDown;
var travel bool VM_bShieldRegen;

var travel float VM_lastShieldAmount;

var() travel float VM_ShieldCooldown;
var() travel float VM_ShieldRegenTime;

state Active
{
	// Vanilla Matters: Init shield regen stuff.
	function BeginState() {
		VM_ShieldTimer = 0;
		VM_bShieldDown = true;
		VM_bShieldRegen = false;
	
		Player.VM_CurrentMaxShield = LevelValues[CurrentLevel];
	}

	// Vanilla Matters: Check for shield status and regenerate if necessary.
	function Tick( float deltaTime ) {
		local float rate;

		if ( VM_bShieldDown ) {
			VM_ShieldTimer = VM_ShieldTimer + deltaTime;

			if ( VM_ShieldTimer >= VM_ShieldCooldown ) {
				VM_bShieldDown = false;
				VM_bShieldRegen = true;

				VM_ShieldTimer = 0;

				Player.ClientMessage( Player.VM_msgShieldRegen );
				PlayRegenSound();
			}
		}
		else if ( VM_bShieldRegen ) {
			rate = ( LevelValues[CurrentLevel] / VM_ShieldRegenTime ) * deltaTime;
			rate = FMin( rate, LevelValues[CurrentLevel] - Player.VM_Shield );
			rate = Player.DrainEnergy( self, rate, 2 );

			Player.VM_Shield = FMin( Player.VM_Shield + rate, LevelValues[CurrentLevel] );

			VM_ShieldTimer = VM_ShieldTimer + rate;

			if ( VM_ShieldTimer >= LevelValues[CurrentLevel] || Player.VM_Shield >= LevelValues[CurrentLevel] ) {
				VM_bShieldRegen = false;

				VM_ShieldTimer = 0;
			}
		}
		else {
			if ( Player.VM_Shield < LevelValues[CurrentLevel] ) {
				VM_ShieldTimer = VM_ShieldTimer + deltaTime;
			}

			if ( Player.VM_Shield <= 0 ) {
				VM_bShieldDown = true;
				VM_bShieldRegen = false;
	
				VM_ShieldTimer = 0;
	
				Player.ClientMessage( Player.VM_msgShieldBroken );
				Player.PlaySound( class'ChargedPickup'.default.DeactivateSound, SLOT_None );
			}
			else if ( VM_ShieldTimer >= ( VM_ShieldCooldown * 2 ) ) {
				VM_bShieldRegen = true;

				VM_ShieldTimer = 0;

				Player.ClientMessage( Player.VM_msgShieldRegen );
				PlayRegenSound();
			}
		}
	}

	// Vanilla Matters: Play sound when the regen starts.
	function PlayRegenSound() {
		Player.PlaySound( sound'BioElectricHiss', SLOT_None,,,, 0.5 );
	}

Begin:
}

// Vanilla Matters: Just handle a situation where the aug is off but the shield is broken.
state Inactive {
	function Tick( float deltaTime ) {
		if ( Player.VM_Shield <= 0 && Player.VM_Shield < VM_lastShieldAmount ) {
			Player.ClientMessage( Player.VM_msgShieldBroken );
				Player.PlaySound( class'ChargedPickup'.default.DeactivateSound, SLOT_None );
		}

		VM_lastShieldAmount = Player.VM_Shield;
	}
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
      AugmentationLocation = LOC_Arm;
	}
}

defaultproperties
{
     mpAugValue=0.500000
     Icon=Texture'DeusExUI.UserInterface.AugIconShield'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconShield_Small'
     AugmentationName="Energy Shield"
     Description="Electrokinetic capacitors below the skin form an energy shield over an agent, protecting against physical harms.|n|nTECH ONE: Shield can withstand up to 30 damage.|n|nTECH TWO:|n+100% shield durability.|n|nTECH THREE:|n+200% shield durability.|n|nTECH FOUR: An agent bathes in protective energy.|n+300% shield durability.|n|nShield suffers 5 seconds of downtime when broken, and will always fully regenerate over 4 seconds.|n|nDrains 1 energy per 2 shield health regeneration."
     MPInfo="When active, you only take 50% damage from flame and plasma attacks.  Energy Drain: Low"
     LevelValues(0)=30.00000
     LevelValues(1)=60.00000
     LevelValues(2)=90.00000
     LevelValues(3)=120.000000
     AugmentationLocation=LOC_Torso
	 MPConflictSlot=1

     VM_ShieldCooldown=5.000000
     VM_ShieldRegenTime=4.000000
}
