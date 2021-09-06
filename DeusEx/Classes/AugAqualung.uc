class AugAqualung extends VMAugmentation;

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
     Description="Soda lime exostructures embedded in the alveoli of the lungs convert CO2 to O2, extending the time an agent can remain underwater.|n|n[TECH ONE]|nLung capacity is extended by 15 seconds.|n|n[TECH TWO]|nLung capacity is extended by 30 seconds.|n|n[TECH THREE]|nLung capacity is extended by 60 seconds.|n|n[TECH FOUR]|nAn agent can stay underwater indefinitely."
     InstallLocation=AugmentationLocationTorso
     UnderwaterTimeBonus=(15,30,60,60000)
}
