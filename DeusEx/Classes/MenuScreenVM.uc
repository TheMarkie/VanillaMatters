//=============================================================================
// MenuScreenVM
//=============================================================================
class MenuScreenVM expands MenuUIScreenWindow;

// ----------------------------------------------------------------------
// SaveSettings()
// ----------------------------------------------------------------------

function SaveSettings() {
    local int fov;

    Super.SaveSettings();

    fov = player.DesiredFOV;
    player.DesiredFOV = player.DefaultFOV;

    player.SaveConfig();

    player.DesiredFOV = fov;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     choices(0)=Class'DeusEx.MenuChoice_ForwardPressure'
     choices(1)=Class'DeusEx.MenuChoice_AutoSave'
     choices(2)=Class'DeusEx.MenuChoice_Cheats'
     choices(3)=Class'DeusEx.MenuChoice_FPSCap'
     actionButtons(0)=(Align=HALIGN_Right,Action=AB_Cancel)
     actionButtons(1)=(Align=HALIGN_Right,Action=AB_OK)
     actionButtons(2)=(Action=AB_Reset)
     Title="Vanilla Matters"
     ClientWidth=537
     ClientHeight=228
     clientTextures(0)=Texture'DeusExUI.UserInterface.MenuControlsBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.MenuControlsBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.MenuControlsBackground_3'
     helpPosY=174
}
