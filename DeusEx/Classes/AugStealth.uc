class AugStealth extends VMAugmentation;

var() array<float> RunSilentBonus;
var() array<float> FellDamageResistanceFlat;

static function bool Activate( VMPlayer player, int level ) {
    player.RunSilentValue += default.RunSilentBonus[level];

    return true;
}

static function bool Deactivate( VMPlayer player, int level ) {
    player.RunSilentValue -= default.RunSilentBonus[level];

    return true;
}

defaultproperties
{
     Icon=Texture'DeusExUI.UserInterface.AugIconRunSilent'
     SmallIcon=Texture'DeusExUI.UserInterface.AugIconRunSilent_Small'
     UpgradeName="Run Silent"
     Description="The necessary muscle movements for complete silence when walking or running are determined continuously with reactive kinematics equations produced by embedded nanocomputers.|n|nMovement Sound Reduction: 30% / 50% / 70% / 90%|nFall Damage Reduction: 15 / 30 / 45 / 60"
     InstallLocation=AugmentationLocationLeg
     IsPassive=True
     RunSilentBonus=(0.3,0.5,0.7,0.9)
     FellDamageResistanceFlat=(15,30,45,60)
}
