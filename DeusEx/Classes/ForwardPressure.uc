//=============================================================================
// ForwardPressure: Class to handle all FP related matters.
//=============================================================================
class ForwardPressure extends Actor;

var localized String MsgNotEnoughPressure;

var DeusExPlayer player;

//==============================================
// Rates
//==============================================
var private travel float forwardPressure;           // The forward pressure meter.

var() float MaxForwardPressure;

var() float CriticalRate;                   // For every critical event like objectives received/completed, mission transitions.
var() float ConversationRate;               // For conversations and datalinks.
var() float NoteAddedRate;                  // For every note added.
var() float SPAwardedRate;                  // For every skill point awarded.
var() float TravelingRate;                  // For moving.
var() float StealthRate;                    // For various stealth-related actions.
var() float DamageRate;                     // For damage dealt/received.
var() float DamageBonusRate;                // Bonus that scales with difficulty.
var() float HealRate;                       // For healing.
var() float HealBonusRate;
var() float EnergyRate;                     // For energy used.
var() float EnergyBonusRate;
var() float RechargeRate;                   // For recharging.
var() float RechargeBonusRate;
var() float UtilityRate;                    // For other activities like lockpicking, bypassing or hacking.
var() float UnlockingBonusRate;             // Bonus that scales, used for lockpicking and bypassing.
var() float HackingBonusRate;               // Bonus that scales, used for hacking.

// FP rate bonuses after scaling.
var travel float DamageBonusScaled;
var travel float HealBonusScaled;
var travel float EnergyBonusScaled;
var travel float RechargeBonusScaled;
var travel float UnlockingBonusScaled;
var travel float HackingBonusScaled;

// Traveling rate handling
var() float ZoneRadius;                     // How large these zones are.
var() float StealthRadius;                  // How large the stealth radius is, to check for enemy pawns that the player is sneaking around.

var private Vector lastLocation;                    // Used for building forward pressure through movement.
var private Vector zone1;
var private Vector zone2;

var private bool isLastLocationEmpty;                 // Used to know if any of the 3 vectors above is empty.
var private bool isZone1Empty;
var private bool isZone2Empty;
var private float zoneDeposit1;                     // How much pressure you can harvest out of the current zones.
var private float zoneDeposit2;

//==============================================
// Management
//==============================================
// Scale the rates appropriately based on CombatDifficulty.
function Initialize( DeusExPlayer newPlayer ) {
    player = newPlayer;

    DamageBonusScaled = DamageBonusRate / player.CombatDifficulty;
    HealBonusScaled = HealBonusRate / player.CombatDifficulty;
    EnergyBonusScaled = EnergyBonusRate / player.CombatDifficulty;
    RechargeBonusScaled = RechargeBonusRate / player.CombatDifficulty;
    UnlockingBonusScaled = UnlockingBonusRate / player.CombatDifficulty;
    HackingBonusScaled = HackingBonusRate / player.CombatDifficulty;
}

function SetPlayer( DeusExPlayer newPlayer ) {
    player = newPlayer;
}

function Add( float amount ) {
    forwardPressure = FClamp( forwardPressure + amount, 0, 100 );
}
function Reset() {
    forwardPressure = 0;
}
function float GetForwardPressure() {
    return forwardPressure;
}

function bool IsFull() {
    return forwardPressure >= MaxForwardPressure;
}

//==============================================
// Contextual calculation
//==============================================
function CalculateAndAdd( float value, name type ) {
    local float rate;

    switch ( type ) {
        case 'Critical':
            rate = CriticalRate;
            break;
        case 'Conversation':
            rate = ConversationRate;
            break;
        case 'NoteAdded':
            rate = NoteAddedRate;
            break;
        case 'SPAwarded':
            rate = SPAwardedRate;
            break;
        case 'Stealth':
            rate = StealthRate;
            break;
        case 'Damage':
            rate = DamageRate + DamageBonusScaled;
            break;
        case 'Heal':
            rate = HealRate + HealBonusScaled;
            break;
        case 'Energy':
            rate = EnergyRate + EnergyBonusScaled;
            break;
        case 'Recharge':
            rate = RechargeRate + RechargeBonusScaled;
            break;
        case 'Unlocking':
            rate = UtilityRate + UnlockingBonusScaled;
            break;
        case 'Hacking':
            rate = UtilityRate + HackingBonusScaled;
            break;
        default:
            rate = 0;
            break;
    }

    Add( FMax( value * rate, 0 ) );
}

//==============================================
// Traveling rate
//==============================================
// Build pressure passively during various activities.
function BuildForwardPressure( float deltaTime ) {
    local float diff, dist;

    local float pressure;

    local float stealthCount;
    local ScriptedPawn sp;

    if ( player == none ) {
        return;
    }

    // There's no way to check if a vector is "empty" or hasn't been set so we use bools.
    if ( isLastLocationEmpty ) {
        lastLocation = player.Location;
        isLastLocationEmpty = false;

        return;
    }

    if ( isZone1Empty ) {
        zone1 = player.Location;
        isZone1Empty = false;
    }

    diff = VSize( player.Location - lastLocation );

    // Here's how the whole travelling FP gain thing works:
    // We set up an "initial" zone right at the player's location when they spawn into a map, it's basically a circle.
    // As long as the player moves in this circle, they gain FP. However, there's a maximum amount of FP the player can "harvest", if it's "exhausted", the zone no longer provides any FP.
    // If the player walks out of the first circle, a second zone is established at the player's location, allowing the player to now harvest FP from up to TWO zones.
    // If both zones are established, and the player walks into a position that's outside of BOTH current zones, then the first zone disappears and is replaced by this new zone.
    // This mechanics is designed to prevent walking back and forth to reap free FP.
    dist = VSize( player.Location - zone1 );
    if ( dist > ZoneRadius ) {
        if ( !_isZone2Empty ) {
            zone1 = zone2;
            zoneDeposit1 = zoneDeposit2;
        }

        zone2 = player.Location;
        zoneDeposit2 = ( ZoneRadius / 160 ) * TravelingRate;
        isZone2Empty = false;
    }
    else {
        dist = VSize( lastLocation - zone1 );
        if ( dist <= ZoneRadius ) {
            pressure = FMin( ( diff / 160 ) * TravelingRate, zoneDeposit1 );

            Add( pressure );

            zoneDeposit1 = zoneDeposit1 - pressure;
        }
    }

    if ( !_isZone2Empty ) {
        dist = VSize( player.Location - zone2 );
        if ( dist > ZoneRadius ) {
            zone1 = zone2;
            zoneDeposit1 = zoneDeposit2;

            zone2 = player.Location;
            zoneDeposit2 = ( ZoneRadius / 160 ) * TravelingRate;
        }
        else {
            dist = VSize( lastLocation - zone2 );
            if ( dist <= ZoneRadius ) {
                pressure = FMin( ( diff / 160 ) * TravelingRate, zoneDeposit2 );

                Add( pressure );

                zoneDeposit2 = zoneDeposit2 - pressure;
            }
        }
    }

    // Stealth FP rate, we simply check in a radius around the player for enemies who have not spotted the player.
    dist = 0;
    stealthCount = 0;
    foreach player.RadiusActors( class'ScriptedPawn', sp, StealthRadius - player.CollisionRadius ) {
        dist = VSize( sp.Location - player.Location );

        if ( sp.IsValidEnemy( player ) && sp.Enemy == none ) {
            stealthCount = stealthCount + ( StealthRadius - dist );
        }
    }

    // VM: Moving stealthily should give more FP than standing still.
    pressure = ( stealthCount / ( StealthRadius / 2 ) ) * ( ( ( diff / 160 ) + deltaTime ) * StealthRate );

    Add( pressure );

    lastLocation = player.Location;
}

// Mark all zone related vectors "empty".
function ResetZoneInfo() {
    isLastLocationEmpty = true;
    isZone1Empty = true;
    isZone2Empty = true;
}

defaultproperties
{
     MsgNotEnoughPressure="You don't have enough pressure to save"
     MaxForwardPressure=100.000000
     CriticalRate=100.000000
     ConversationRate=20.000000
     NoteAddedRate=25.000000
     SPAwardedRate=0.500000
     TravelingRate=0.500000
     StealthRate=1.000000
     DamageRate=0.400000
     DamageBonusRate=0.600000
     HealRate=0.500000
     HealBonusRate=0.600000
     EnergyRate=0.400000
     EnergyBonusRate=0.600000
     RechargeRate=0.500000
     RechargeBonusRate=0.600000
     UtilityRate=1.500000
     UnlockingBonusRate=1.500000
     HackingBonusRate=6.000000
     ZoneRadius=800.000000
     StealthRadius=800.000000
     bHidden=True
     bTravel=True
}
