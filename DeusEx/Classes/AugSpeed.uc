class AugSpeed extends VMAugmentation;

var() array<float> MovementSpeedBonusMult;
var() array<float> JumpVelocityBonusMult;
var() array<float> FellDamageResistanceFlat;

static function bool Activate( VMPlayer player, int level ) {
    player.GlobalModifiers.Modify( 'MovementSpeedBonusMult', default.MovementSpeedBonusMult[level] );
    player.GlobalModifiers.Modify( 'JumpVelocityBonusMult', default.JumpVelocityBonusMult[level] );
    player.CategoryModifiers.Modify( 'DamageResistanceFlat', 'Fell', default.FellDamageResistanceFlat[level] );

    return true;
}

static function bool Deactivate( VMPlayer player, int level ) {
    player.GlobalModifiers.Modify( 'MovementSpeedBonusMult', -default.MovementSpeedBonusMult[level] );
    player.GlobalModifiers.Modify( 'JumpVelocityBonusMult', -default.JumpVelocityBonusMult[level] );
    player.CategoryModifiers.Modify( 'DamageResistanceFlat', 'Fell', -default.FellDamageResistanceFlat[level] );

    return true;
}

defaultproperties
{
     Icon=Texture'DeusExUI.UserInterface.AugIconSpeedJump'
     SmallIcon=Texture'DeusExUI.UserInterface.AugIconSpeedJump_Small'
     UpgradeName="Speed Enhancement"
     Description="Ionic polymeric gel myofibrils are woven into the leg muscles, increasing the speed at which an agent can run and climb, the height they can jump, and reducing the damage they receive from falls.|n|nProduces noises over a large area when moving.|n|nMovement Speed: +20% / 40% / 60% / 80%|nJump Height: +20% / 40% / 60% / 80%|nFall Damage Reduction: 10 / 20 / 40 / 80|n|nEnergy Rate: 0.5 / 1 / 1.5 / 2 per second"
     InstallLocation=AugmentationLocationLeg
     Rates=(0.5,1,1.5,2)
     MovementSpeedBonusMult=(0.2,0.4,0.6,0.8)
     JumpVelocityBonusMult=(0.2,0.4,0.6,0.8)
     FellDamageResistanceFlat=(10,20,40,80)
}
