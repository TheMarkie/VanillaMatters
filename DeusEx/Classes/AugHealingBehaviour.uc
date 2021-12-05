class AugHealingBehaviour extends VMAugmentationBehaviour;

var() array<int> HealAmount;
var() float Cost;

var float StandingTimer;

function Refresh( VMPlayer p, VMAugmentationInfo i, VMAugmentationManager m ) {
    super.Refresh( p, i, m );
    m.TickHandlers[-1] = self;
}

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
            Player.DrainEnergy( float( Player.HealPlayer( HealAmount[Info.Level], false ) ) / Cost );
            Player.ClientFlash( 0.5, vect( 0, 0, 500 ) );
        }

        StandingTimer -= 1;
    }
}

defaultproperties
{
     HealAmount=(10,20,30,40)
     Cost=10.000000
}
