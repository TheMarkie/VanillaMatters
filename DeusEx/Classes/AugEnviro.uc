class AugEnviro extends VMAugmentation;

var() array<float> DamageResistance;
var() array<int> FoodHealingBonus;

static function bool Activate( VMPlayer player, int level ) {
    player.CategoryModifiers.Modify( 'DamageResistanceMult', 'Radiation', default.DamageResistance[level] );
    player.CategoryModifiers.Modify( 'DamageResistanceMult', 'TearGas', default.DamageResistance[level] );
    player.CategoryModifiers.Modify( 'DamageResistanceMult', 'PoisonGas', default.DamageResistance[level] );
    player.CategoryModifiers.Modify( 'DamageResistanceMult', 'HalonGas', default.DamageResistance[level] );
    player.CategoryModifiers.Modify( 'DamageResistanceMult', 'Poison', default.DamageResistance[level] );
    player.CategoryModifiers.Modify( 'DamageResistanceMult', 'PoisonEffect', default.DamageResistance[level] );
    player.CategoryModifiers.Modify( 'HealingBonus', 'Food', default.FoodHealingBonus[level] );
    return true;
}

static function bool Deactivate( VMPlayer player, int level ) {
    player.CategoryModifiers.Modify( 'DamageResistanceMult', 'Radiation', -default.DamageResistance[level] );
    player.CategoryModifiers.Modify( 'DamageResistanceMult', 'TearGas', -default.DamageResistance[level] );
    player.CategoryModifiers.Modify( 'DamageResistanceMult', 'PoisonGas', -default.DamageResistance[level] );
    player.CategoryModifiers.Modify( 'DamageResistanceMult', 'HalonGas', -default.DamageResistance[level] );
    player.CategoryModifiers.Modify( 'DamageResistanceMult', 'Poison', -default.DamageResistance[level] );
    player.CategoryModifiers.Modify( 'DamageResistanceMult', 'PoisonEffect', -default.DamageResistance[level] );
    player.CategoryModifiers.Modify( 'HealingBonus', 'Food', -default.FoodHealingBonus[level] );
    return true;
}

defaultproperties
{
     Icon=Texture'DeusExUI.UserInterface.AugIconEnviro'
     SmallIcon=Texture'DeusExUI.UserInterface.AugIconEnviro_Small'
     IsPassive=True
     UpgradeName="Environmental Resistance"
     Description="Induced keratin production strengthens all epithelial tissues and reduces the agent's vulnerability to radiation and other toxins.|n|n[TECH ONE]|nToxic resistance is increased by 20%.|n|n[TECH TWO]|nToxic resistance is increased by 40%.|n|n[TECH THREE]|nToxic resistance is increased by 60%.|n|n[TECH FOUR]|nAn agent is nearly invulnerable to damage from toxins. Toxic resistance is increased by 80%."
     InstallLocation=AugmentationLocationTorso
     Rates=(0,0,0,0)
     DamageResistance=(0.2,0.4,0.6,0.8)
     FoodHealingBonus=(2,4,6,8)
}
