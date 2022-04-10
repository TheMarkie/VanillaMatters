class AugAqualung extends VMAugmentation;

// Vanilla Matters: Replaced by AugMed.

var() array<float> UnderwaterTimeBonus;

static function bool Activate( VMPlayer player, int level ) {
    player.GlobalModifiers.Modify( 'UnderwaterTimeBonus', default.UnderwaterTimeBonus[level] );

    return true;
}

static function bool Deactivate( VMPlayer player, int level ) {
    player.GlobalModifiers.Modify( 'UnderwaterTimeBonus', -default.UnderwaterTimeBonus[level] );

    return true;
}

defaultproperties
{
     Icon=Texture'DeusExUI.UserInterface.AugIconAquaLung'
     SmallIcon=Texture'DeusExUI.UserInterface.AugIconAquaLung_Small'
     IsPassive=True
     UpgradeName="Aqualung"
     Description="UNUSED AUGMENTATION, YOU SHOULD NOT SEE THIS!"
     InstallLocation=AugmentationLocationTorso
     UnderwaterTimeBonus=(15,30,60,60000)
}
