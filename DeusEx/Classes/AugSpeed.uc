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
    player.GlobalModifiers.Modify( 'MovementSpeedBonusMult', -default.MovementSpeedBonusMult[level] );
    player.GlobalModifiers.Modify( 'JumpVelocityBonusMult', -default.JumpVelocityBonusMult[level] );
    player.CategoryModifiers.Modify( 'DamageResistanceFlat', 'Fell', -default.FellDamageResistanceFlat[level] );
}

defaultproperties
{
     Icon=Texture'DeusExUI.UserInterface.AugIconSpeedJump'
     SmallIcon=Texture'DeusExUI.UserInterface.AugIconSpeedJump_Small'
     UpgradeName="Speed Enhancement"
     Description="Ionic polymeric gel myofibrils are woven into the leg muscles, increasing the speed at which an agent can run and climb, the height they can jump, and reducing the damage they receive from falls.|n|n[TECH ONE]|n+10% movement speed|n+20% jump height|n- Falling damage reduced by 20 points.|n|n[TECH TWO]|n+30% movement speed|n+40% jump height|n- Falling damage reduced by 40 points.|n|n[TECH THREE]|n+50% movement speed|n+60% jump height|n- Falling damage reduced by 60 points.|n|n[TECH FOUR]|nAn agent can run like the wind and leap from the tallest building.|n+70% movement speed|n+80% jump height|n- Falling damage reduced by 80 points.|n|nProduces noises over a large area when moving."
     InstallLocation=AugmentationLocationLeg
     Rates=(30,60,90,120)
     MovementSpeedBonusMult=(0.5,1,2,4)
     JumpVelocityBonusMult=(0.5,1,2,4)
     FellDamageResistanceFlat=(10,20,40,80)
}
