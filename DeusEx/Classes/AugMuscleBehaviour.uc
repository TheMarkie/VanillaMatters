class AugMuscleBehaviour extends VMAugmentationBehaviour;


var() array<float> LiftStrengthBonus;
var() array<float> MeleeWeaponDamage;
var() array<float> MeleeAttackSpeedBonus;
var() array<float> ThrowVelocityBonus;
var() array<float> InjuryAccuracyPenaltyReduction;

var localized string MsgMuscleCost;

function bool Activate() {
    local int level;

    level = Info.Level;
    Player.GlobalModifiers.Modify( 'LiftStrengthBonus', default.LiftStrengthBonus[level] );
    Player.GlobalModifiers.Modify( 'MeleeWeaponDamage', default.MeleeWeaponDamage[level] );
    Player.GlobalModifiers.Modify( 'MeleeAttackSpeedBonus', default.MeleeAttackSpeedBonus[level] );
    Player.GlobalModifiers.Modify( 'ThrowVelocityBonus', default.ThrowVelocityBonus[level] );
    Player.GlobalModifiers.Modify( 'InjuryAccuracyPenaltyReduction', default.InjuryAccuracyPenaltyReduction[level] );

    return true;
}

function bool Deactivate() {
    local int level;

    level = Info.Level;
    Player.GlobalModifiers.Modify( 'LiftStrengthBonus', -default.LiftStrengthBonus[level] );
    Player.GlobalModifiers.Modify( 'MeleeWeaponDamage', -default.MeleeWeaponDamage[level] );
    Player.GlobalModifiers.Modify( 'MeleeAttackSpeedBonus', -default.MeleeAttackSpeedBonus[level] );
    Player.GlobalModifiers.Modify( 'ThrowVelocityBonus', -default.ThrowVelocityBonus[level] );
    Player.GlobalModifiers.Modify( 'InjuryAccuracyPenaltyReduction', -default.InjuryAccuracyPenaltyReduction[level] );

    return true;
}

defaultproperties
{
     LiftStrengthBonus=(1,2,3,4)
     MeleeWeaponDamage=(0.25,0.5,0.75,1)
     MeleeAttackSpeedBonus=(0.1,0.2,0.3,0.4)
     ThrowVelocityBonus=(0.25,0.5,0.75,1)
     InjuryAccuracyPenaltyReduction=(0.1,0.2,0.3,0.4)
     MsgMuscleCost="You don't have enough energy to do a powerthrow"
}
