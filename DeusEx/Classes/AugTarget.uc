class AugTarget extends VMAugmentation;

var() array<float> AccuracyBonus;
var() array<float> DamageVsRobot;

static function bool Activate( VMPlayer player, int level ) {
    SetTargetingAugStatus( player, true, level );
    player.GlobalModifiers.Modify( 'AccuracyBonus', default.AccuracyBonus[level] );
    player.GlobalModifiers.Modify( 'DamageVsRobot', default.DamageVsRobot[level] );
    return true;
}

static function bool Deactivate( VMPlayer player, int level ) {
    SetTargetingAugStatus( player, false, level );
    player.GlobalModifiers.Modify( 'AccuracyBonus', -default.AccuracyBonus[level] );
    player.GlobalModifiers.Modify( 'DamageVsRobot', -default.DamageVsRobot[level] );
    return true;
}

static function SetTargetingAugStatus( VMPlayer player, bool active, int level ) {
    local AugmentationDisplayWindow augWnd;

    augWnd = player.DXRootWindow.hud.augDisplay;
    augWnd.bTargetActive = active;
    augWnd.targetLevel = level;
}

defaultproperties
{
     Icon=Texture'DeusExUI.UserInterface.AugIconTarget'
     SmallIcon=Texture'DeusExUI.UserInterface.AugIconTarget_Small'
     UpgradeName="Targeting"
     Description="Image-scaling and recognition provided by multiplexing the optic nerve with doped polyacetylene 'quantum wires' not only increases accuracy, but also delivers limited situational info about a target. Complex and precise analysis allows the agent to be more effective against mechanical targets.|n|nTarget information and details increase with tech level.|n|nWeapon Accuracy: +4% / 8% / 12% / 16%|nDamage vs Robots: +0% / 20% / 40% / 60%|n|nEnergy Rate: 0.4 / 0.5 / 0.6 / 0.7 per second"
     InstallLocation=AugmentationLocationEye
     Rates=(0.4,0.5,0.6,0.7)
     AccuracyBonus=(0.04,0.08,0.12,0.16)
     DamageVsRobot=(0,0.2,0.4,0.6)
}
