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
     Description="Sorting rotors accelerate calcium ion concentration in the sarcoplasmic reticulum, increasing an agent's muscle speed several-fold and multiplying the damage they inflict in melee combat.|n|n[TECH ONE]|n+25% melee damage|n+10% melee attack speed|n|n[TECH TWO]|n+50% melee damage|n+20% melee attack speed|n|n[TECH THREE]|n+75% melee damage|n+30% melee attack speed|n|n[TECH FOUR]|nMelee weapons are almost instantly lethal.|n+100% melee damage|n+40% melee attack speed"
     Rates=(0.4,0.6,0.8,1)
     InstallLocation=AugmentationLocationArm
     MeleeWeaponDamage=(0.25,0.5,0.75,1)
     MeleeAttackSpeedBonus=(0.1,0.2,0.3,0.4)
     ReloadTimeReduction=(0.1,0.2,0.3,0.4)
     InjuryAccuracyPenaltyReduction=(0.1,0.2,0.3,0.4)
}
