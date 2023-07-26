class AugStealth extends VMAugmentation;

var() array<float> RunSilentBonus;
var() array<float> MovementSpeedBonusMult;
var() array<float> CrouchMovementSpeedBonusMult;
var() array<float> FellDamageResistanceFlat;

static function bool Activate( VMPlayer player, int level ) {
    player.RunSilentValue += default.RunSilentBonus[level];
    player.GlobalModifiers.Modify( 'StealthMovementSpeedBonusMult', default.MovementSpeedBonusMult[level] );
    player.GlobalModifiers.Modify( 'CrouchMovementSpeedBonusMult', default.CrouchMovementSpeedBonusMult[level] );
    player.CategoryModifiers.Modify( 'DamageResistanceFlat', 'Fell', default.FellDamageResistanceFlat[level] );

    return true;
}

static function bool Deactivate( VMPlayer player, int level ) {
    player.RunSilentValue -= default.RunSilentBonus[level];
    player.GlobalModifiers.Modify( 'StealthMovementSpeedBonusMult', -default.MovementSpeedBonusMult[level] );
    player.GlobalModifiers.Modify( 'CrouchMovementSpeedBonusMult', -default.CrouchMovementSpeedBonusMult[level] );
    player.CategoryModifiers.Modify( 'DamageResistanceFlat', 'Fell', -default.FellDamageResistanceFlat[level] );

    return true;
}

defaultproperties
{
     Icon=Texture'DeusExUI.UserInterface.AugIconRunSilent'
     SmallIcon=Texture'DeusExUI.UserInterface.AugIconRunSilent_Small'
     UpgradeName="Run Silent"
     Description="The necessary muscle movements for complete silence when walking or running are determined continuously with reactive kinematics equations produced by embedded nanocomputers.|n|nMovement speed bonus also applies while crouching.|n|nMovement Sound Reduction: 30% / 50% / 70% / 90%|nMovement Speed: +10% / 15% / 20% / 25%|nFall Damage Reduction: 15 / 30 / 45 / 60"
     InstallLocation=AugmentationLocationLeg
     IsPassive=True
     Rates=(0,0,0,0)
     RunSilentBonus=(0.3,0.5,0.7,0.9)
     MovementSpeedBonusMult=(0.1,0.15,0.2,0.25)
     CrouchMovementSpeedBonusMult=(0.1,0.15,0.2,0.25)
     FellDamageResistanceFlat=(15,30,45,60)
}
