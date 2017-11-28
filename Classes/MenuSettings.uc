//=============================================================================
// MenuSettings
//=============================================================================

// Vanilla Matters: Custom textures for new menu slot.
#exec TEXTURE IMPORT FILE="Textures\MenuOptionsBackground_1.pcx"		NAME="MenuOptionsBackground_1"		GROUP="VMUI" MIPS=Off
#exec TEXTURE IMPORT FILE="Textures\MenuOptionsBackground_2.pcx"		NAME="MenuOptionsBackground_2"		GROUP="VMUI" MIPS=Off
#exec TEXTURE IMPORT FILE="Textures\MenuOptionsBackground_3.pcx"		NAME="MenuOptionsBackground_3"		GROUP="VMUI" MIPS=Off
#exec TEXTURE IMPORT FILE="Textures\MenuOptionsBackground_4.pcx"		NAME="MenuOptionsBackground_4"		GROUP="VMUI" MIPS=Off

class MenuSettings expands MenuUIMenuWindow;

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     ButtonNames(0)="Keyboard/Mouse"
     ButtonNames(1)="Controls"
     ButtonNames(2)="Game Options"
     ButtonNames(3)="Vanilla Matters"
     ButtonNames(4)="Display"
     ButtonNames(5)="Colors"
     ButtonNames(6)="Sound"
     ButtonNames(7)="Previous Menu"
     buttonXPos=7
     buttonWidth=282
     buttonDefaults(0)=(Y=13,Action=MA_MenuScreen,Invoke=Class'DeusEx.MenuScreenCustomizeKeys')
     buttonDefaults(1)=(Y=49,Action=MA_MenuScreen,Invoke=Class'DeusEx.MenuScreenControls')
     buttonDefaults(2)=(Y=85,Action=MA_MenuScreen,Invoke=Class'DeusEx.MenuScreenOptions')
     buttonDefaults(3)=(Y=121,Action=MA_MenuScreen,Invoke=Class'DeusEx.MenuScreenVM')
     buttonDefaults(4)=(Y=157,Action=MA_MenuScreen,Invoke=Class'DeusEx.MenuScreenDisplay')
     buttonDefaults(5)=(Y=193,Action=MA_MenuScreen,Invoke=Class'DeusEx.MenuScreenAdjustColors')
     buttonDefaults(6)=(Y=229,Action=MA_MenuScreen,Invoke=Class'DeusEx.MenuScreenSound')
     buttonDefaults(7)=(Y=302,Action=MA_Previous)
     Title="Settings"
     ClientWidth=294
     ClientHeight=344
     clientTextures(0)=Texture'DeusEx.VMUI.MenuOptionsBackground_1'
     clientTextures(1)=Texture'DeusEx.VMUI.MenuOptionsBackground_2'
     clientTextures(2)=Texture'DeusEx.VMUI.MenuOptionsBackground_3'
     clientTextures(3)=Texture'DeusEx.VMUI.MenuOptionsBackground_4'
     textureCols=2
}
