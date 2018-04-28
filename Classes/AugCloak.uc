//=============================================================================
// AugCloak.
//=============================================================================
class AugCloak extends Augmentation;

var float mpAugValue;
var float mpEnergyDrain;

// Vanilla Matters: Keep track of the player's last in hand item.
var travel Inventory lastInHand;

state Active
{
	// Vanilla Matters: Apply and remove transparency accordingly, applies to newly equipped items and removes from unequipped ones.
	function Tick( float deltaTime ) {
		if ( lastInHand == None ) {
			if ( Player.inHand != None ) {
				lastInHand = Player.inHand;
				ToggleTransparency( lastInHand, true, 0.05 );
			}

			return;
		}
		else if ( Player.inHand == None ) {
			ToggleTransparency( lastInHand, false );
			lastInHand = None;
			return;
		}

		if ( lastInHand != Player.inHand ) {
			ToggleTransparency( lastInHand, false );
			lastInHand = Player.inHand;
			ToggleTransparency( lastInHand, true, 0.05 );
		}
	}
Begin:
	if ((Player.inHand != None) && (Player.inHand.IsA('DeusExWeapon')))
		Player.ServerConditionalNotifyMsg( Player.MPMSG_NoCloakWeapon );
	Player.PlaySound(Sound'CloakUp', SLOT_Interact, 0.85, ,768,1.0);

	// Vanilla Matters: Cloak the player in third person.
	Player.SetSkinStyle( STY_Translucent, Texture'WhiteStatic', 0.05 );
	Player.KillShadow();
	Player.MultiSkins[6] = Texture'BlackMaskTex';
	Player.MultiSkins[7] = Texture'BlackMaskTex';
}

function Deactivate()
{
	Player.PlaySound(Sound'CloakDown', SLOT_Interact, 0.85, ,768,1.0);
	Super.Deactivate();

	// Vanilla Matters: Clean up transparency.
	ToggleTransparency( lastInHand, false );
	lastInHand = None;

	Player.ResetSkinStyle();
	Player.CreateShadow();
}

// Vanilla Matters: Functions to set and reset item transparency.
function ToggleTransparency( Inventory item, bool transparent, optional float newScaleGlow ) {
	if ( item == none ) {
		return;
	}

	if ( transparent ) {
		item.Style = STY_Translucent;
		item.ScaleGlow = newScaleGlow;
	}
	else {
		item.Style = STY_Normal;
		item.ScaleGlow = item.Default.ScaleGlow;
	}
}

simulated function float GetEnergyRate()
{
	return energyRate * LevelValues[CurrentLevel];
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	// If this is a netgame, then override defaults
	if ( Level.NetMode != NM_StandAlone )
	{
		LevelValues[3] = mpAugValue;
		EnergyRate = mpEnergyDrain;
      AugmentationLocation = LOC_Eye;
	}
}

defaultproperties
{
     mpAugValue=1.000000
     mpEnergyDrain=40.000000
     EnergyRate=300.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconCloak'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconCloak_Small'
     AugmentationName="Cloak"
     Description="Subdermal pigmentation cells allow the agent to blend with their surrounding environment, rendering them effectively invisible to observation by organic hostiles.|n|nTECH ONE: Power drain is normal.|n|nTECH TWO: Power drain is reduced by 20%.|n|nTECH THREE: Power drain is reduced by 40%.|n|nTECH FOUR: Power drain is reduced by 60%."
     MPInfo="When active, you are invisible to enemy players.  Electronic devices and players with the vision augmentation can still detect you.  Cannot be used with a weapon.  Energy Drain: Low"
     LevelValues(0)=1.000000
     LevelValues(1)=0.800000
     LevelValues(2)=0.600000
     LevelValues(3)=0.400000
     AugmentationLocation=LOC_Subdermal
     MPConflictSlot=6
}
