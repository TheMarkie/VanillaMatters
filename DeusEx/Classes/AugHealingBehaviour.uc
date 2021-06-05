class AugHealingBehaviour extends VMAugmentationBehaviour;

var() array<int> HealAmount;

var float Cost;
var float StandingTimer;

// Make the aug heals every second AFTER you've been standing still for at least 2 seconds.
function Tick( float deltaTime ) {
    if ( VSize( Player.Velocity ) < 10 ) {
        StandingTimer += deltaTime;
    }
    else {
        StandingTimer = 0;
    }

    if ( standingTimer >= 2 ) {
        if ( Player.Health < 100 ) {
            Cost += float( Player.HealPlayer( HealAmount[Info.Level], false ) ) / 5;
            Player.ClientFlash( 0.5, vect( 0, 0, 500 ) );
        }

        StandingTimer -= 1;
    }
}

function float GetRate( float time ) {
    local float rate;

    rate = Cost;
    Cost = 0;

    return rate;
}

defaultproperties
{
     HealAmount=(5,10,15,20)
}
