//=============================================================================
// ForwardPressure: Class to handle all FP related matters.
//=============================================================================
class ForwardPressure extends Actor;

var DeusExPlayer player;

var travel float forwardPressure;			// The forward pressure meter.

var() float VM_fpCritical;				// FP rate for every critical event like objectives received/completed, mission transitions.
var() float VM_fpConversation;			// FP rate for conversations and datalinks.
var() float VM_fpNoteAdded;				// FP rate for every note added.
var() float VM_fpSPAwarded;				// FP rate for every skill point awarded.
var() float VM_fpTraveling;				// FP rate for moving.
var() float VM_fpStealth;				// FP rate for various stealth-related actions.
var() float VM_fpDamage;					// FP rate for damage dealt/received.
var() float VM_fpDamageBonus;			// FP rate bonus that scales with difficulty.
var() float VM_fpHeal;					// FP rate for healing.
var() float VM_fpHealBonus;
var() float VM_fpEnergy;					// FP rate for energy used.
var() float VM_fpEnergyBonus;
var() float VM_fpRecharge;				// FP rate for recharging.
var() float VM_fpRechargeBonus;
var() float VM_fpUtility;				// FP rate for other activities like lockpicking, bypassing or hacking.
var() float VM_fpUtilityLB;				// FP rate bonus that scales, used for lockpicking and bypassing.
var() float VM_fpUtilityH;				// FP rate bonus that scales, used for hacking.

var travel float fpDamageS;					// FP rate bonus after scaling.
var travel float fpHealS;
var travel float fpEnergyS;
var travel float fpRechargeS;
var travel float fpUtilityLBS;
var travel float fpUtilityHS;

var Vector lastLocation;						// Used for building forward pressure through movement.
var Vector fpZone1;
var Vector fpZone2;
var bool lastLocationEmpty;					// Used to know if any of the 3 vectors above is empty.
var bool fpZone1Empty;
var bool fpZone2Empty;
var float fpZoneDeposit1;					// How much pressure you can harvest out of the current zones.
var float fpZoneDeposit2;
var() float VM_fpZoneRadius;					// How large these zones are.
var() float VM_fpStealthRadius;					// How large the stealth radius is, to check for enemy pawns that the player is sneaking around.

var localized String VM_msgNotEnoughPressure;

// Vanilla Matters: Scale the rates appropriately based on combatdifficulty.
function InitializeFP( DeusExPlayer newPlayer ) {
	player = newPlayer;

	fpDamageS = VM_fpDamageBonus / player.CombatDifficulty;
	fpHealS = VM_fpHealBonus / player.CombatDifficulty;
	fpEnergyS = VM_fpEnergyBonus / player.CombatDifficulty;
	fpRechargeS = VM_fpRechargeBonus / player.CombatDifficulty;
	fpUtilityLBS = VM_fpUtilityLB / player.CombatDifficulty;
	fpUtilityHS = VM_fpUtilityH / player.CombatDifficulty;
}

function SetPlayer( DeusExPlayer newPlayer ) {
	player = newPlayer;
}

// Vanilla Matters: Handle pressure meter.
function AddForwardPressure( float amount ) {
	forwardPressure = FClamp( forwardPressure + amount, 0, 100 );
}
function ResetForwardPressure(){
	forwardPressure = 0;
}
function float GetForwardPressure() {
	return forwardPressure;
}

function bool EnoughPressure( float amount ) {
	return ( forwardPressure >= amount );
}

// Vanilla Matters: Build pressure passively during various activities.
function BuildForwardPressure( float deltaTime ) {
	local float diff, dist;

	local float pressure;

	local float stealthCount;
	local ScriptedPawn sp;

	if ( player == none ) {
		return;
	}

	// VM: There's no way to check if a vector is "empty" or hasn't been set so we use bools.
	if ( fpZone1Empty ) {
		fpZone1 = player.Location;
		fpZone1Empty = false;
		return;
	}

	if ( lastLocationEmpty ) {
		lastLocation = player.Location;
		lastLocationEmpty = false;
		return;
	}

	diff = VSize( player.Location - lastLocation );

	// Vanilla Matters: Here's how the whole travelling FP gain thing works:
	// VM: We set up an "initial" zone right at the player's location when they spawn into a map, it's basically a circle.
	// VM: As long as the player moves in this circle, they gain FP. However, there's a maximum amount of FP the player can "harvest", if it's "exhausted", the zone no longer provides any FP.
	// VM: If the player walks out of the first circle, a second zone is established at the player's location, allowing the player to now harvest FP from up to TWO zones.
	// VM: If both zones are established, and the player walks into a position that's outside of BOTH current zones, then the first zone disappears and is replaced by this new zone.
	// VM: This mechanics is designed to prevent walking back and forth to reap free FP.
	dist = VSize( player.Location - fpZone1 );
	if ( dist > VM_fpZoneRadius ) {
		if ( !fpZone2Empty ) {
			fpZone1 = fpZone2;
			fpZoneDeposit1 = fpZoneDeposit2;
		}

		fpZone2 = player.Location;
		fpZoneDeposit2 = ( VM_fpZoneRadius / 160 ) * VM_fpTraveling;
		fpZone2Empty = false;
	}
	else {
		dist = VSize( lastLocation - fpZone1 );
		if ( dist <= VM_fpZoneRadius ) {
			pressure = FMin( ( diff / 160 ) * VM_fpTraveling, fpZoneDeposit1 );

			AddForwardPressure( pressure );

			fpZoneDeposit1 = fpZoneDeposit1 - pressure;
		}
	}

	if ( !fpZone2Empty ) {
		dist = VSize( player.Location - fpZone2 );
		if ( dist > VM_fpZoneRadius ) {
			fpZone1 = fpZone2;
			fpZoneDeposit1 = fpZoneDeposit2;

			fpZone2 = player.Location;
			fpZoneDeposit2 = ( VM_fpZoneRadius / 160 ) * VM_fpTraveling;
		}
		else {
			dist = VSize( lastLocation - fpZone2 );
			if ( dist <= VM_fpZoneRadius ) {
				pressure = FMin( ( diff / 160 ) * VM_fpTraveling, fpZoneDeposit2 );

				AddForwardPressure( pressure );

				fpZoneDeposit2 = fpZoneDeposit2 - pressure;
			}
		}
	}

	// Vanilla Matters: Stealth FP rate, we simply check in a radius around the player for enemies who have not spotted the player.
	dist = 0;
	stealthCount = 0;
	foreach player.RadiusActors( class'ScriptedPawn', sp, VM_fpStealthRadius - player.CollisionRadius ) {
		dist = VSize( sp.Location - player.Location );

		if ( sp.IsValidEnemy( player ) && sp.Enemy == none ) {
			stealthCount = stealthCount + ( VM_fpStealthRadius - dist );
		}
	}

	// VM: Moving stealthily should give more FP than standing still.
	pressure = ( stealthCount / ( VM_fpStealthRadius / 2 ) ) * ( ( ( diff / 160 ) + deltaTime ) * VM_fpStealth );

	AddForwardPressure( pressure );

	lastLocation = player.Location;
}

// Vanilla Matters: Function to mark all zone related vectors "empty".
function ResetFPZoneInfo() {
	// VM: This should be far enough so the player can't reach it in any way.
	lastLocationEmpty = true;
	fpZone1Empty = true;
	fpZone2Empty = true;
}

defaultproperties
{
     VM_fpCritical=100.000000
     VM_fpConversation=20.000000
     VM_fpNoteAdded=25.000000
     VM_fpSPAwarded=0.500000
     VM_fpTraveling=0.500000
     VM_fpStealth=1.000000
     VM_fpDamage=0.400000
     VM_fpDamageBonus=0.600000
     VM_fpHeal=0.500000
     VM_fpHealBonus=0.600000
     VM_fpEnergy=0.400000
     VM_fpEnergyBonus=0.600000
     VM_fpRecharge=0.500000
     VM_fpRechargeBonus=0.600000
     VM_fpUtility=1.500000
     VM_fpUtilityLB=1.500000
     VM_fpUtilityH=6.000000
     VM_fpZoneRadius=800.000000
     VM_fpStealthRadius=800.000000
	 VM_msgNotEnoughPressure="You don't have enough pressure to save"

	 bHidden=True
     bTravel=True
}