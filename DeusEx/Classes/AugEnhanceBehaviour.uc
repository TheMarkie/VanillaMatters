class AugEnhanceBehaviour extends VMAugmentationBehaviour;

var() array<int> EnergyThresholds;
var() float MovementSpeedBonus;
var() array<int> HealAmounts;

var float Timer;
var float LastSpeedBonus;

function bool Deactivate() {
    ModifySpeedBonus( 0 );
    return true;
}

function float Tick( float deltaTime ) {
    local int level, energy, i;
    local float speedBonus;
    local int healAmount, healingAmount;

    if ( !Info.IsActive ) {
        return 0;
    }

    Timer -= deltaTime;
    if ( Timer > 0 ) {
        return super.Tick( deltaTime );
    }
    Timer += 1;

    level = Info.Level;
    energy = Player.Energy;
    if ( energy < EnergyThresholds[level] ) {
        if ( LastSpeedBonus > 0 ) {
            ModifySpeedBonus( 0 );
        }
        return super.Tick( deltaTime );
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

    return super.Tick( deltaTime );
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
     MovementSpeedBonus=0.100000
     HealAmounts=(5,5,5)
}
