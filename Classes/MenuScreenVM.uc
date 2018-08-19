//=============================================================================
// MenuScreenVM
//=============================================================================

// // Vanilla Matters: Custom textures for this menu.
#exec TEXTURE IMPORT FILE="Textures\MenuVMBackground_1.pcx"		NAME="MenuVMBackground_1"		GROUP="VMUI" MIPS=Off
#exec TEXTURE IMPORT FILE="Textures\MenuVMBackground_2.pcx"		NAME="MenuVMBackground_2"		GROUP="VMUI" MIPS=Off
#exec TEXTURE IMPORT FILE="Textures\MenuVMBackground_3.pcx"		NAME="MenuVMBackground_3"		GROUP="VMUI" MIPS=Off

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
     choices(1)=Class'DeusEx.MenuChoice_Cheats'
     choices(2)=Class'DeusEx.MenuChoice_CombatDifficulty'
     choices(3)=Class'DeusEx.MenuChoice_FOV'
     actionButtons(0)=(Align=HALIGN_Right,Action=AB_Cancel)
     actionButtons(1)=(Align=HALIGN_Right,Action=AB_OK)
     actionButtons(2)=(Action=AB_Reset)
     Title="Vanilla Matters"
     ClientWidth=537
     ClientHeight=228
     clientTextures(0)=Texture'DeusEx.VMUI.MenuVMBackground_1'
     clientTextures(1)=Texture'DeusEx.VMUI.MenuVMBackground_2'
     clientTextures(2)=Texture'DeusEx.VMUI.MenuVMBackground_3'
     textureRows=1
     helpPosY=174
}
