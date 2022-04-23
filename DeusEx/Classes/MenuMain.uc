//=============================================================================
// MenuMain
//=============================================================================

class MenuMain expands MenuUIMenuWindow;

// Vanilla Matters
#exec TEXTURE IMPORT FILE="Textures\MenuMainBackground_1.bmp"       NAME="MenuMainBackground_1"     GROUP="VMUI" MIPS=Off
#exec TEXTURE IMPORT FILE="Textures\MenuMainBackground_3.bmp"       NAME="MenuMainBackground_3"     GROUP="VMUI" MIPS=Off

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
    Super.InitWindow();

    UpdateButtonStatus();
    ShowVersionInfo();

    // Vanilla Matters: Show Vanilla Matters version.
    ShowVanillaMattersInfo();
}

// ----------------------------------------------------------------------
// UpdateButtonStatus()
// ----------------------------------------------------------------------

function UpdateButtonStatus()
{
    // Vanilla Matters
    local bool shouldSave, isInMainMenu;

    isInMainMenu = player.IsInMainMenu();
    shouldSave = !isInMainMenu && player.dataLinkPlay == none && player.HasFullForwardPressure();

    // Disable the "Save Game" and "Back to Game" menu choices
    // if the player's dead or we're on the logo map.
    //
    // Also don't allow the user to save if a DataLink is playing

    // Vanilla Matters
    if ( Player.Level.NetMode == NM_Standalone )
    {
        winButtons[1].SetSensitivity( shouldSave );
        winButtons[6].SetSensitivity( !isInMainMenu );
    }

    if (player.Level.Netmode != NM_Standalone)
    {
        winButtons[0].SetSensitivity(False);
        winButtons[1].SetSensitivity(False);
        winButtons[2].SetSensitivity(False);
        winButtons[4].SetSensitivity(False);
        winButtons[5].SetSensitivity(False);
    }
}

// ----------------------------------------------------------------------
// ShowVersionInfo()
// ----------------------------------------------------------------------

function ShowVersionInfo()
{
    local TextWindow version;

    version = TextWindow(NewChild(Class'TextWindow'));
    version.SetTextMargins(0, 0);
    version.SetWindowAlignments(HALIGN_Right, VALIGN_Bottom);
    version.SetTextColorRGB(255, 255, 255);
    version.SetTextAlignments(HALIGN_Right, VALIGN_Bottom);
    version.SetText(player.GetDeusExVersion());
}

// Vanilla Matters: Show Vanilla Matters version.
function ShowVanillaMattersInfo() {
    local TextWindow vmInfo;

    vmInfo = TextWindow( NewChild( Class'TextWindow' ) );
    vmInfo.SetTextMargins( 0, 10 );
    vmInfo.SetTextAlignments( HALIGN_Left, VALIGN_Top );
    vmInfo.SetTextColorRGB( 255, 255, 255 );
    vmInfo.SetWindowAlignments( HALIGN_Right, VALIGN_Top );
    vmInfo.SetText( "VM" @ class'DeusExGameInfo'.static.GetVMVersion() );
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     ButtonNames(0)="New Game"
     ButtonNames(1)="Save Game"
     ButtonNames(2)="Load Game"
     ButtonNames(3)="Settings"
     ButtonNames(4)="Play Intro"
     ButtonNames(5)="Credits"
     ButtonNames(6)="Back to Game"
     ButtonNames(7)="Exit"
     buttonXPos=7
     buttonWidth=245
     buttonDefaults(0)=(Y=13,Action=MA_MenuScreen,Invoke=Class'DeusEx.MenuSelectDifficulty')
     buttonDefaults(1)=(Y=49,Action=MA_MenuScreen,Invoke=Class'DeusEx.MenuScreenSaveGame')
     buttonDefaults(2)=(Y=85,Action=MA_MenuScreen,Invoke=Class'DeusEx.MenuScreenLoadGame')
     buttonDefaults(3)=(Y=121,Invoke=Class'DeusEx.MenuSettings')
     buttonDefaults(4)=(Y=157,Action=MA_Intro)
     buttonDefaults(5)=(Y=193,Action=MA_MenuScreen,Invoke=Class'DeusEx.CreditsWindow')
     buttonDefaults(6)=(Y=229,Action=MA_Previous)
     buttonDefaults(7)=(Y=283,Action=MA_Quit)
     Title="Welcome to DEUS EX"
     ClientWidth=258
     ClientHeight=329
     verticalOffset=2
     clientTextures(0)=Texture'DeusEx.VMUI.MenuMainBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.MenuMainBackground_2'
     clientTextures(2)=Texture'DeusEx.VMUI.MenuMainBackground_3'
     textureCols=2
}
