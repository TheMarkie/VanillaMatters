class AugHealingBehaviour extends VMAugmentationBehaviour;

var() array<int> HealAmount;
var() array<float> Costs;

var float StandingTimer;

// Make the aug heals every second AFTER you've been standing still for at least 2 seconds.
function float Tick( float deltaTime ) {
    if ( VSize( Player.Velocity ) < 10 ) {
        StandingTimer += deltaTime;
    }
    else {
        StandingTimer = 0;
    }

    if ( standingTimer >= 2 ) {
        if ( Player.Health < 100 && Player.DrainEnergy( Costs[Info.Level] ) ) {
            Player.HealPlayer( HealAmount[Info.Level], false );
            Player.ClientFlash( 0.5, vect( 0, 0, 500 ) );
        }

        StandingTimer -= 1;
    }

    return super.Tick( deltaTime );
}

defaultproperties
{
     HealAmount=(10,20,30,40)
     Costs=(2,4,6,8)
}
