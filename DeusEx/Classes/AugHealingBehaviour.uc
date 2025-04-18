class AugHealingBehaviour extends VMAugmentationBehaviour;

var() array<int> HealAmount;
var() array<float> Costs;

var float Timer;

function bool Activate() {
    Timer = 0;
    return true;
}

function float Tick( float deltaTime ) {
    if ( !Info.IsActive ) {
        return 0;
    }

    Timer += deltaTime;
    if ( Timer >= 1 ) {
        if ( Player.Health < 100 && Player.DrainEnergy( Costs[Info.Level] ) ) {
            Player.HealPlayer( HealAmount[Info.Level], false );
        }
        Timer -= 1;
    }

    return super.Tick( deltaTime );
}

defaultproperties
{
     HealAmount=(10,20,30,40)
     Costs=(0.5,1,1.5,2)
}
