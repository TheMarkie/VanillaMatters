//=============================================================================
// MenuScreenVM
//=============================================================================

// // Vanilla Matters: Custom textures for this menu.
#exec TEXTURE IMPORT FILE="Textures\MenuVMBackground_1.bmp"		NAME="MenuVMBackground_1"		GROUP="VMUI" MIPS=Off
#exec TEXTURE IMPORT FILE="Textures\MenuVMBackground_2.bmp"		NAME="MenuVMBackground_2"		GROUP="VMUI" MIPS=Off
#exec TEXTURE IMPORT FILE="Textures\MenuVMBackground_3.bmp"		NAME="MenuVMBackground_3"		GROUP="VMUI" MIPS=Off
#exec TEXTURE IMPORT FILE="Textures\MenuVMBackground_4.bmp"		NAME="MenuVMBackground_4"		GROUP="VMUI" MIPS=Off
#exec TEXTURE IMPORT FILE="Textures\MenuVMBackground_5.bmp"		NAME="MenuVMBackground_5"		GROUP="VMUI" MIPS=Off
#exec TEXTURE IMPORT FILE="Textures\MenuVMBackground_5.bmp"		NAME="MenuVMBackground_6"		GROUP="VMUI" MIPS=Off

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
     choices(3)=Class'DeusEx.MenuChoice_CombatDifficulty'
     choices(4)=Class'DeusEx.MenuChoice_FOV'
     choices(5)=Class'DeusEx.MenuChoice_FPSCap'
     actionButtons(0)=(Align=HALIGN_Right,Action=AB_Cancel)
     actionButtons(1)=(Align=HALIGN_Right,Action=AB_OK)
     actionButtons(2)=(Action=AB_Reset)
     Title="Vanilla Matters"
     ClientWidth=537
     ClientHeight=300
     clientTextures(0)=Texture'DeusEx.VMUI.MenuVMBackground_1'
     clientTextures(1)=Texture'DeusEx.VMUI.MenuVMBackground_2'
     clientTextures(2)=Texture'DeusEx.VMUI.MenuVMBackground_3'
     clientTextures(3)=Texture'DeusEx.VMUI.MenuVMBackground_4'
     clientTextures(4)=Texture'DeusEx.VMUI.MenuVMBackground_5'
     clientTextures(5)=Texture'DeusEx.VMUI.MenuVMBackground_6'
     textureRows=1
     helpPosY=245
}
