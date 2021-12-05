class AugPerformanceBehaviour extends VMAugmentationBehaviour;

var() array<int> EnergyThresholds;
var() float MovementSpeedBonus;
var() array<int> HealAmounts;

var float Timer;
var float LastSpeedBonus;

function Refresh( VMPlayer p, VMAugmentationInfo i, VMAugmentationManager m ) {
    super.Refresh( p, i, m );
    m.TickHandlers[-1] = self;
}

function bool Deactivate() {
    ModifySpeedBonus( 0 );
    return true;
}

function Tick( float deltaTime ) {
    local int level, energy, i;
    local float speedBonus;
    local int healAmount, healingAmount;

    Timer -= deltaTime;
    if ( Timer > 0 ) {
        return;
    }
    Timer += 1;

    level = Info.Level;
    energy = Player.Energy;
    if ( energy < EnergyThresholds[level] ) {
        if ( LastSpeedBonus > 0 ) {
            ModifySpeedBonus( 0 );
        }
        return;
    }

    healAmount = HealAmounts[level];
    for ( i = level; i >= 0; i-- ) {
        if ( energy >= EnergyThresholds[i] ) {
            speedBonus += MovementSpeedBonus;
            healingAmount += healAmount;
        }
    }

    ModifySpeedBonus( speedBonus );
    Player.HealPlayer( healingAmount,, true );
}

function ModifySpeedBonus( float amount ) {
    if ( amount == LastSpeedBonus ) {
        return;
    }
    Player.GlobalModifiers.Modify( 'MovementSpeedBonusMult', amount - LastSpeedBonus );
    LastSpeedBonus = amount;
}

defaultproperties
{
     EnergyThresholds=(90,80,70)
     MovementSpeedBonus=1.000000
     HealAmounts=(0,1,2)
}
