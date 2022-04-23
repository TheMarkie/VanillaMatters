class AugPower extends VMAugmentation;

// Vanilla Matters: Replaced by AugDash.

var() array<float> EnergyUseReduction;

static function bool Activate( VMPlayer player, int level ) {
    player.GlobalModifiers.Modify( 'EnergyUseReduction', default.EnergyUseReduction[level] );
    return true;
}

static function bool Deactivate( VMPlayer player, int level ) {
    player.GlobalModifiers.Modify( 'EnergyUseReduction', -default.EnergyUseReduction[level] );
    return true;
}

defaultproperties
{
     Icon=Texture'DeusExUI.UserInterface.AugIconPowerRecirc'
     SmallIcon=Texture'DeusExUI.UserInterface.AugIconPowerRecirc_Small'
     IsPassive=True
     UpgradeName="Power Recirculator"
     Description="UNUSED AUGMENTATION, YOU SHOULD NOT SEE THIS!"
     InstallLocation=AugmentationLocationTorso
     EnergyUseReduction=(0.15,0.3,0.45,0.6)
}
