class AugCombat extends VMAugmentation;

var() array<float> MeleeWeaponDamage;
var() array<float> MeleeAttackSpeedBonus;
var() array<float> ReloadTimeReduction;
var() array<float> InjuryAccuracyPenaltyReduction;

static function bool Activate( VMPlayer player, int level ) {
    player.GlobalModifiers.Modify( 'MeleeWeaponDamage', default.MeleeWeaponDamage[level] );
    player.GlobalModifiers.Modify( 'MeleeAttackSpeedBonus', default.MeleeAttackSpeedBonus[level] );
    player.GlobalModifiers.Modify( 'ReloadTimeReduction', default.ReloadTimeReduction[level] );
    player.GlobalModifiers.Modify( 'InjuryAccuracyPenaltyReduction', default.InjuryAccuracyPenaltyReduction[level] );

    return true;
}

static function bool Deactivate( VMPlayer player, int level ) {
    player.GlobalModifiers.Modify( 'MeleeWeaponDamage', -default.MeleeWeaponDamage[level] );
    player.GlobalModifiers.Modify( 'MeleeAttackSpeedBonus', -default.MeleeAttackSpeedBonus[level] );
    player.GlobalModifiers.Modify( 'ReloadTimeReduction', -default.ReloadTimeReduction[level] );
    player.GlobalModifiers.Modify( 'InjuryAccuracyPenaltyReduction', -default.InjuryAccuracyPenaltyReduction[level] );

    return true;
}

defaultproperties
{
     Icon=Texture'DeusExUI.UserInterface.AugIconCombat'
     SmallIcon=Texture'DeusExUI.UserInterface.AugIconCombat_Small'
     UpgradeName="Combat Strength"
     Description="Sorting rotors accelerate calcium ion concentration in the sarcoplasmic reticulum, increasing an agent's muscle speed several-fold and enhancing their combat prowess and speed.|n|nMelee Damage: +25% / 50% / 75% / 100%|nMelee Attack Speed: +10% / 20% / 30% / 40%|nReload Time: -10% / 20% / 30% / 40%|nInjury Accuracy Penalty: -10% / 20% / 30% / 40%|n|nEnergy Rate: 0.4 / 0.6 / 0.8 / 1 per second"
     InstallLocation=AugmentationLocationArm
     Rates=(0.4,0.6,0.8,1)
     MeleeWeaponDamage=(0.25,0.5,0.75,1)
     MeleeAttackSpeedBonus=(0.1,0.2,0.3,0.4)
     ReloadTimeReduction=(0.1,0.2,0.3,0.4)
     InjuryAccuracyPenaltyReduction=(0.1,0.2,0.3,0.4)
}
