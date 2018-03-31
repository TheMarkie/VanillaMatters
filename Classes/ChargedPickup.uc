//=============================================================================
// ChargedPickup.
//=============================================================================
class ChargedPickup extends DeusExPickup
	abstract;

var() class<Skill> skillNeeded;
var() bool bOneUseOnly;
var() sound ActivateSound;
var() sound DeactivateSound;
var() sound LoopSound;
var Texture ChargedIcon;
var travel bool bIsActive;
var localized String ChargeRemainingLabel;

// Vanilla Matters
var() bool	VM_bQuiet;				// Make the LoopSound not played.
var() bool	VM_bDraining;			// Does it slowly drain?
var() float	VM_DamageResistance;	// How much base resistance it provides, doesn't do anything without proper checks.

var travel int VM_actualCharge;		// To keep track of the actual charge after level scaling.

var localized String VM_msgIsActive;
var localized String VM_msgInfoToggle;
var localized String VM_msgDamageResistance;
var localized String VM_msgInfoYes;
var localized String VM_msgInfoNo;

// ----------------------------------------------------------------------
// UpdateInfo()
// ----------------------------------------------------------------------

simulated function bool UpdateInfo(Object winObject)
{
	local PersonaInfoWindow winInfo;
	local DeusExPlayer player;
	local String outText;

	// Vanilla Matters
	local float damageResistance;
	local float skillLevelValue;

	winInfo = PersonaInfoWindow(winObject);
	if (winInfo == None)
		return False;

	player = DeusExPlayer(Owner);

	if (player != None)
	{
		winInfo.SetTitle(itemName);
		winInfo.SetText(Description $ winInfo.CR() $ winInfo.CR());

		outText = ChargeRemainingLabel @ Int(GetCurrentCharge()) $ "%";
		winInfo.AppendText(outText);

		// Vanilla Matters: Add in damage resistance value if there's any.
		if ( VM_DamageResistance != 0.0 ) {
			winInfo.AppendText( winInfo.CR() $ VM_msgDamageResistance @ class'DeusExWeapon'.static.FormatFloatString( ( 1 - VM_DamageResistance ) * 100, 0.1 ) $ "% " );

			skillLevelValue = player.SkillSystem.GetSkillLevelValue( class'SkillEnviro' );

			damageResistance = ( 1 - ( VM_DamageResistance * skillLevelValue ) ) * 100.0;

			if ( damageResistance != VM_DamageResistance ) {
				winInfo.AppendText( class'DeusExWeapon'.static.BuildPercentString( 1 - skillLevelValue ) @ "=" @ class'DeusExWeapon'.static.FormatFloatString( damageResistance, 0.1 ) $ "%" );
			}
		}

		// Vanilla Matters: Add in whether the charged pickup is toggleable.
		if ( bOneUseOnly ) {
			winInfo.AppendText( winInfo.CR() $ winInfo.CR() $ VM_msgInfoToggle @ VM_msgInfoNo );
		}
		else {
			winInfo.AppendText( winInfo.CR() $ winInfo.CR() $ VM_msgInfoToggle @ VM_msgInfoYes );
		}

		// Vanilla Matters: Add in whether the charged pickup is currently active.
		if ( bIsActive ) {
			winInfo.AppendText( winInfo.CR() $ winInfo.CR() $ VM_msgIsActive @ VM_msgInfoYes );
		}
		else {
			winInfo.AppendText( winInfo.CR() $ winInfo.CR() $ VM_msgIsActive @ VM_msgInfoNo );
		}
	}

	return True;
}

// ----------------------------------------------------------------------
// GetCurrentCharge()
// ----------------------------------------------------------------------

simulated function Float GetCurrentCharge()
{
	//return (Float(Charge) / Float(Default.Charge)) * 100.0;

	// Vanilla Matters: Use actualCharge, since if Charge exceeds the respective default property, the displayed green bar is always full.
	if ( VM_actualCharge > 0 ) {
		return ( float( Charge ) / float( VM_actualCharge ) ) * 100.0;
	}
	else {
		return ( float( Charge ) / float( Default.Charge ) ) * 100.0;
	}
}

// ----------------------------------------------------------------------
// ChargedPickupBegin()
// ----------------------------------------------------------------------

function ChargedPickupBegin(DeusExPlayer Player)
{
	Player.AddChargedDisplay(Self);
	PlaySound(ActivateSound, SLOT_None);
	// if (LoopSound != None)
	// 	AmbientSound = LoopSound;

	// Vanilla Matters: Don't interrupt ambient if quiet.
	if ( LoopSound != None && !VM_bQuiet ) {
		AmbientSound = LoopSound;
	}

   //DEUS_EX AMSD In multiplayer, remove it from the belt if the belt
   //is the only inventory.
   if ((Level.NetMode != NM_Standalone) && (Player.bBeltIsMPInventory))
   {
      if (DeusExRootWindow(Player.rootWindow) != None)
         DeusExRootWindow(Player.rootWindow).DeleteInventory(self);

      bInObjectBelt=False;
      BeltPos=default.BeltPos;
   }

	// Vanilla Matters: Make the charged pickup in player's view invisible.
	Style = STY_Translucent;
	ScaleGlow = 0.0;
	bUnlit = True;

	bIsActive = True;
}

// ----------------------------------------------------------------------
// ChargedPickupEnd()
// ----------------------------------------------------------------------

function ChargedPickupEnd(DeusExPlayer Player)
{
	Player.RemoveChargedDisplay(Self);
	PlaySound(DeactivateSound, SLOT_None);
	// if (LoopSound != None)
	// 	AmbientSound = None;

	// Vanilla Matters: No need to interrupt ambient since it's never changed.
	if ( LoopSound != None && !VM_bQuiet ) {
		AmbientSound = None;
	}

	// remove it from our inventory if this is a one
	// use item
	if (bOneUseOnly)
		Player.DeleteInventory(Self);

	// Vanilla Matters: Makes it visible again.
	Style = STY_Normal;
	ScaleGlow = Default.ScaleGlow;
	bUnlit = False;

	bIsActive = False;
}

// ----------------------------------------------------------------------
// IsActive()
// ----------------------------------------------------------------------

simulated function bool IsActive()
{
	return bIsActive;
}

// ----------------------------------------------------------------------
// ChargedPickupUpdate()
// ----------------------------------------------------------------------

function ChargedPickupUpdate(DeusExPlayer Player)
{
}

// ----------------------------------------------------------------------
// CalcChargeDrain()
// ----------------------------------------------------------------------

simulated function int CalcChargeDrain(DeusExPlayer Player)
{
	local float skillValue;
	local float drain;

	// Vanilla Matters: Return nothing so that no charge is deducted from the pool.
	if ( !VM_bDraining ) {
		return 0;
	}

	drain = 4.0;
	skillValue = 1.0;

	if (skillNeeded != None)
		skillValue = Player.SkillSystem.GetSkillLevelValue(skillNeeded);
	drain *= skillValue;

	return Int(drain);
}

// Vanilla Matters: Drain charge and returns amount actually drained.
function float DrainCharge( float drainAmount ) {
	// VM: There's more charge than the drainAmount, so the actual drained amount is the same.
	if ( Charge >= drainAmount ) {
		Charge = Charge - drainAmount;
	}
	// VM: There's less charge than the drainAmount, so the actual drained amount is lower.
	else {
		drainAmount = drainAmount - Charge;

		Charge = 0;
	}

	return drainAmount;
}

// ----------------------------------------------------------------------
// function UsedUp()
//
// copied from Pickup, but modified to keep items from
// automatically switching
// ----------------------------------------------------------------------

function UsedUp()
{
	local DeusExPlayer Player;

	if ( Pawn(Owner) != None )
	{
		bActivatable = false;
		Pawn(Owner).ClientMessage(ExpireMessage);	
	}
	Owner.PlaySound(DeactivateSound);
	Player = DeusExPlayer(Owner);

	if (Player != None)
	{
		if (Player.inHand == Self)
			ChargedPickupEnd(Player);
	}

	//Destroy();

	// Vanilla Matters: Do UseOnce() to be consistent with the rest.
	UseOnce();
}

// ----------------------------------------------------------------------
// state DeActivated
// ----------------------------------------------------------------------

state DeActivated
{
}

// ----------------------------------------------------------------------
// state Activated
// ----------------------------------------------------------------------

state Activated
{
	function Timer()
	{
		local DeusExPlayer Player;

		Player = DeusExPlayer(Owner);
		if (Player != None)
		{
			ChargedPickupUpdate(Player);
			//Charge -= CalcChargeDrain(Player);

			// Vanilla Matters: Charge draining is reworked to represent duration better. Now 10 charge is worth 1 second.
			if ( VM_bDraining ) {
				Charge = Charge - 1;
			}

			if (Charge <= 0)
				UsedUp();
		}

		// Vanilla Matters: Make sure the chargedpickup is turned off when no one can be using it.
		if ( Owner == None ) {
			super.Activate();
		}
	}

	function BeginState()
	{
		local DeusExPlayer Player;

		// Vanilla Matters
		local int newCharge;

		Super.BeginState();

		Player = DeusExPlayer(Owner);
		if (Player != None)
		{
			// remove it from our inventory, but save our owner info
			if (bOneUseOnly)
			{
//				Player.DeleteInventory(Self);
				
				// Remove from player's hand
				//Player.PutInHand(None);

				// Vanilla Matters: Remove the one-use item from the belt to make it less clunky when it can't be selected again.
				if ( DeusExRootWindow(Player.rootWindow) != None ) {
					DeusExRootWindow( Player.rootWindow ).DeleteInventory( self );
				}

				bInObjectBelt=False;
				BeltPos=default.BeltPos;

				SetOwner( Player );
			}

			// Vanilla Matters: Since we don't do dynamic drain amount like vanilla, we're gonna have to up Charge amount properly upon leveling up.
			if ( VM_bDraining ) {
				newCharge = Default.Charge * ( 2.0 - Player.SkillSystem.GetSkillLevelValue( skillNeeded ) );
			}
			// VM: If the pick up is not draining over time, we use a different formula.
			else {
				newCharge = Default.Charge / Player.SkillSystem.GetSkillLevelValue( skillNeeded );
			}

			// VM: If the newCharge is higher than the previous actualCharge, replace it and scale the current Charge up.
			if ( newCharge > VM_actualCharge ) {
				// VM: If actualCharge is 0, it means this is the first time the player's activated the pickup, so we do some init.
				if ( VM_actualCharge <= 0 ) {
					VM_actualCharge = newCharge;
					Charge = newCharge;
				}
				// VM: Scale up Charge proportionally.
				else {
					Charge = Charge * ( float( newCharge ) / float ( VM_actualCharge ) );
					VM_actualCharge = newCharge;
				}
			}

			// VM: Still deselect the charged pickup to prevent double-clicking.
			Player.PutInHand( None );

			ChargedPickupBegin(Player);
			SetTimer(0.1, True);
		}
	}

	function EndState()
	{
		local DeusExPlayer Player;

		Super.EndState();

		Player = DeusExPlayer(Owner);
		if (Player != None)
		{
			ChargedPickupEnd(Player);
			SetTimer(0.1, False);
		}
	}

	function Activate()
	{
		// if this is a single-use item, don't allow the player to turn it off
		if (bOneUseOnly)
			return;

		Super.Activate();
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     ActivateSound=Sound'DeusExSounds.Pickup.PickupActivate'
     DeActivateSound=Sound'DeusExSounds.Pickup.PickupDeactivate'
     ChargeRemainingLabel="Charge remaining:"
     VM_bDraining=True
     VM_msgIsActive="Currently active:"
     VM_msgInfoToggle="Toggleable:"
     VM_msgDamageResistance="Damage resistance:"
     VM_msgInfoYes="YES"
     VM_msgInfoNo="NO"
     bActivatable=True
     Charge=500
}
