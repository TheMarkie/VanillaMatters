class AugVision extends VMAugmentation;

var() array<float> SonarRange;

static function bool Activate( VMPlayer player, int level ) {
    SetVisionAugStatus( player, level + 1, default.SonarRange[level], true );
    Player.RelevantRadius = default.SonarRange[level];
    return true;
}

static function bool Deactivate( VMPlayer player, int level ) {
    SetVisionAugStatus( player, 0, 0, false );
    player.RelevantRadius = 0;
    return true;
}

static function SetVisionAugStatus( VMPlayer player, int level, float levelValue, bool active ) {
    local AugmentationDisplayWindow augWnd;

    augWnd = player.DXRootWindow.hud.augDisplay;
    if ( active ) {
        augWnd.VM_visionLevels[1] = level;
        augWnd.VM_visionValues[1] = levelValue;
    }
    else {
        augWnd.visionBlinder = none;
        augWnd.VM_visionLevels[1] = 0;
        augWnd.VM_visionValues[1] = 0;
    }
}

defaultproperties
{
     Icon=Texture'DeusExUI.UserInterface.AugIconVision'
     SmallIcon=Texture'DeusExUI.UserInterface.AugIconVision_Small'
     UpgradeName="Vision Enhancement"
     Description="By bleaching selected rod photoreceptors and saturating them with metarhodopsin XII, the 'nightvision' present in most nocturnal animals can be duplicated. Subsequent upgrades and modifications add infravision and sonar-resonance imaging that effectively allows an agent to see through walls.|n|nTECH ONE: Nightvision.|nTECH TWO: Infravision.|nTECH THREE: Medium range sonar imaging.|nTECH FOUR: Long range sonar imaging.|n|nSonar Range: 30 / 60 feet|n|nEnergy Rate: 0.1 / 0.1 / 0.4 / 0.6 per second"
     InstallLocation=AugmentationLocationEye
     Rates=(0.1,0.1,0.4,0.6)
     SonarRange=(0,0,480,960)
}
