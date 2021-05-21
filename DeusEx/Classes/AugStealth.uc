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
     Description="The necessary muscle movements for complete silence when walking or running are determined continuously with reactive kinematics equations produced by embedded nanocomputers.|n|n[TECH ONE]|nMovement is 20% quieter.|n- Falling damage reduced by 8 points.|n|n[TECH TWO]|nMovement is 40% quieter.|n- Falling damage reduced by 12 points.|n|n[TECH THREE]|nMovement is 60% quieter.|n- Falling damage reduced by 16 points.|n|n[TECH FOUR]|nAn agent is completely silent.|n- Falling damage reduced by 20 points."
     InstallLocation=AugmentationLocationLeg
     RunSilentBonus=(0.2,0.4,0.6,0.8)
     FellDamageResistanceFlat=(10,20,40,80)
}
