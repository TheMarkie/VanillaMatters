class AugMuscleBehaviour extends VMAugmentationBehaviour;


var() array<float> LiftStrengthBonus;
var() array<float> MeleeWeaponDamage;
var() array<float> MeleeAttackSpeedBonus;
var() array<float> ThrowVelocityBonus;
var() array<float> InjuryAccuracyPenaltyReduction;

function bool Activate() {
    local int level;

    level = Info.Level;
    Player.GlobalModifiers.Modify( 'LiftStrengthBonus', default.LiftStrengthBonus[level] );
    Player.GlobalModifiers.Modify( 'MeleeWeaponDamage', default.MeleeWeaponDamage[level] );
    Player.GlobalModifiers.Modify( 'MeleeAttackSpeedBonus', default.MeleeAttackSpeedBonus[level] );
    Player.GlobalModifiers.Modify( 'ThrowVelocityBonus', default.ThrowVelocityBonus[level] );
    Player.GlobalModifiers.Modify( 'InjuryAccuracyPenaltyReduction', default.InjuryAccuracyPenaltyReduction[level] );
}

function bool Deactivate() {
    local int level;

    level = Info.Level;
    Player.GlobalModifiers.Modify( 'LiftStrengthBonus', -default.LiftStrengthBonus[level] );
    Player.GlobalModifiers.Modify( 'MeleeWeaponDamage', -default.MeleeWeaponDamage[level] );
    Player.GlobalModifiers.Modify( 'MeleeAttackSpeedBonus', -default.MeleeAttackSpeedBonus[level] );
    Player.GlobalModifiers.Modify( 'ThrowVelocityBonus', -default.ThrowVelocityBonus[level] );
    Player.GlobalModifiers.Modify( 'InjuryAccuracyPenaltyReduction', -default.InjuryAccuracyPenaltyReduction[level] );
}

defaultproperties
{
     LiftStrengthBonus=(1,2,3,4)
     MeleeWeaponDamage=(0.25,0.5,0.75,1)
     MeleeAttackSpeedBonus=(0.1,0.2,0.3,0.4)
     ThrowVelocityBonus=(0.25,0.5,0.75,1)
     InjuryAccuracyPenaltyReduction=(0.1,0.2,0.3,0.4)
}
