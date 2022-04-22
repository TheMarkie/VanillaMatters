class AugEnhanceBehaviour extends VMAugmentationBehaviour;

var() array<int> BaseThresholds;
var() int BonusThreshold;
var() float MovementSpeedBonus;
var() float BaseHeal;
var() array<float> BonusHeals;

var float Timer;
var float LastSpeedBonus;

function float Tick( float deltaTime ) {
    local int level, energy, threshold;
    local float speedBonus;
    local int healAmount, bonusHealAmount;

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
    threshold = BaseThresholds[level];
    if ( energy < threshold ) {
        if ( LastSpeedBonus > 0 ) {
            ModifySpeedBonus( 0 );
        }
        return super.Tick( deltaTime );
    }

    speedBonus = MovementSpeedBonus;
    healAmount = BaseHeal;
    bonusHealAmount = BonusHeals[level];
    threshold += BonusThreshold;
    while ( energy > threshold ) {
        speedBonus += MovementSpeedBonus;
        healAmount += bonusHealAmount;
        threshold += BonusThreshold;
    }

    ModifySpeedBonus( speedBonus );
    Player.HealPlayer( healAmount,, true );

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
     BaseThresholds=(80,70,60)
     BonusThreshold=10
     MovementSpeedBonus=0.100000
     BaseHeal=6
     BonusHeals=(2,4,6)
}
