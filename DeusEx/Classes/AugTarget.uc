class AugTarget extends VMAugmentation;

var() array<float> DamageVsRobot;

static function bool Activate( VMPlayer player, int level ) {
    SetTargetingAugStatus( player, true, level );
    player.GlobalModifiers.Modify( 'DamageVsRobot', default.DamageVsRobot[level] );
    return true;
}

static function bool Deactivate( VMPlayer player, int level ) {
    SetTargetingAugStatus( player, false, level );
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
     Description="Image-scaling and recognition provided by multiplexing the optic nerve with doped polyacetylene 'quantum wires' not only increases accuracy, but also delivers limited situational info about a target.|n|n[TECH ONE]|nGeneral target information.|n+4% weapon accuracy|n|n[TECH TWO]|nExtensive target information.|n+8% weapon accuracy|n|n[TECH THREE]|nSpecific target information.|n+12% weapon accuracy|n|n[TECH FOUR]|nTelescopic vision.|n+16% weapon accuracy"
     InstallLocation=AugmentationLocationEye
     Rates=(0.4,0.5,0.6,0.7)
     DamageVsRobot=(0,0.2,0.4,0.6)
}
