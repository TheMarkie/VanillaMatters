class AugSpeed extends VMAugmentation;

var() array<float> MovementSpeedBonusMult;
var() array<float> JumpVelocityBonusMult;
var() array<float> FellDamageResistanceFlat;

static function Activate( VMPlayer player, int level ) {
    player.GlobalModifiers.Modify( 'MovementSpeedBonusMult', default.MovementSpeedBonusMult[level] );
    player.GlobalModifiers.Modify( 'JumpVelocityBonusMult', default.JumpVelocityBonusMult[level] );
    player.CategoryModifiers.Modify( 'DamageResistanceFlat', 'Fell', default.FellDamageResistanceFlat[level] );
}

static function Deactivate( VMPlayer player, int level ) {
    player.GlobalModifiers.Modify( 'MovementSpeedBonusMult', - default.MovementSpeedBonusMult[level] );
    player.GlobalModifiers.Modify( 'JumpVelocityBonusMult', - default.JumpVelocityBonusMult[level] );
    player.CategoryModifiers.Modify( 'DamageResistanceFlat', 'Fell', - default.FellDamageResistanceFlat[level] );
}

defaultproperties
{
     Icon=Texture'DeusExUI.UserInterface.AugIconSpeedJump'
     SmallIcon=Texture'DeusExUI.UserInterface.AugIconSpeedJump_Small'
     UpgradeName="Speed Enhancement"
     Description="Ionic polymeric gel myofibrils are woven into the leg muscles, increasing the speed at which an agent can run and climb, the height they can jump, and reducing the damage they receive from falls.|n|n[TECH ONE]|n|n[TECH TWO]|n|n[TECH THREE]|n|n[TECH FOUR]"
     InstallLocation=AugmentationLocationLeg
     Rates=(30,60,90,120)
     MovementSpeedBonusMult=(0.5,1,2,4)
     JumpVelocityBonusMult=(0.5,1,2,4)
     FellDamageResistanceFlat=(10,20,40,80)
}
