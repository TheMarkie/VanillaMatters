//=============================================================================
// PersonaScreenSkills
//=============================================================================

class PersonaScreenSkills extends PersonaScreenBaseWindow;

// Vanilla Matters: Custom background and border to fix the empty spot of the removed skills.
#exec TEXTURE IMPORT FILE="Textures\SkillsBackground_1.bmp"     NAME="SkillsBackground_1"       GROUP="VMUI" MIPS=Off
#exec TEXTURE IMPORT FILE="Textures\SkillsBackground_2.bmp"     NAME="SkillsBackground_2"       GROUP="VMUI" MIPS=Off
#exec TEXTURE IMPORT FILE="Textures\SkillsBackground_4.bmp"     NAME="SkillsBackground_4"       GROUP="VMUI" MIPS=Off
#exec TEXTURE IMPORT FILE="Textures\SkillsBackground_5.bmp"     NAME="SkillsBackground_5"       GROUP="VMUI" MIPS=Off
#exec TEXTURE IMPORT FILE="Textures\SkillsBackground_6.bmp"     NAME="SkillsBackground_6"       GROUP="VMUI" MIPS=Off
#exec TEXTURE IMPORT FILE="Textures\SkillsBorder_4.bmp"     NAME="SkillsBorder_4"       GROUP="VMUI" MIPS=Off
#exec TEXTURE IMPORT FILE="Textures\SkillsBorder_5.bmp"     NAME="SkillsBorder_5"       GROUP="VMUI" MIPS=Off
#exec TEXTURE IMPORT FILE="Textures\SkillsBorder_6.bmp"     NAME="SkillsBorder_6"       GROUP="VMUI" MIPS=Off

var PersonaActionButtonWindow btnUpgrade;
var TileWindow                winTile;
var PersonaSkillButtonWindow  selectedSkillButton;
var PersonaHeaderTextWindow   winSkillPoints;
var PersonaInfoWindow         winInfo;

var localized String SkillsTitleText;
var localized String UpgradeButtonLabel;
var localized String PointsNeededHeaderText;
var localized String SkillLevelHeaderText;
var localized String SkillPointsHeaderText;
var localized String SkillUpgradedLevelLabel;

// Vanilla Matters
var VMSkillInfo selectedSkill;
var array<PersonaSkillButtonWindow> skillButtons;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
    Super.InitWindow();

    PersonaNavBarWindow(winNavBar).btnSkills.SetSensitivity(False);

    EnableButtons();
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
    Super.CreateControls();

    CreateTitleWindow(9, 5, SkillsTitleText);
    CreateInfoWindow();
    CreateButtons();
    CreateSkillsTileWindow();
    CreateSkillsList();
    CreateSkillPointsWindow();
}

// ----------------------------------------------------------------------
// CreateSkillsTileWindow()
// ----------------------------------------------------------------------

function CreateSkillsTileWindow()
{
    winTile = TileWindow(winClient.NewChild(Class'TileWindow'));
    // Vanilla Matters: Tweak the skills tile window size and position to fit the shortened menu.
    winTile.SetPos( 12, 21 );
    winTile.SetSize( 302, 243 );
    winTile.SetMinorSpacing(0);
    winTile.SetMargins(0, 0);
    winTile.SetOrder(ORDER_Down);
}

// ----------------------------------------------------------------------
// CreateInfoWindow()
// ----------------------------------------------------------------------

function CreateInfoWindow()
{
    winInfo = PersonaInfoWindow(winClient.NewChild(Class'PersonaInfoWindow'));
    winInfo.SetPos(356, 22);
    // Vanilla Matters: Reduce the info window size to fit the shortened menu.
    winInfo.SetSize( 238, 265 );
}

// ----------------------------------------------------------------------
// CreateButtons()
// ----------------------------------------------------------------------

function CreateButtons()
{
    local PersonaButtonBarWindow winActionButtons;

    winActionButtons = PersonaButtonBarWindow(winClient.NewChild(Class'PersonaButtonBarWindow'));
    // Vanilla Matters: Move the button up to fit the new shortened menu.
    winActionButtons.SetPos( 10, 266 );
    winActionButtons.SetWidth(149);
    winActionButtons.FillAllSpace(False);

    btnUpgrade = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
    btnUpgrade.SetButtonText(UpgradeButtonLabel);
}

// ----------------------------------------------------------------------
// CreateSkillsList()
// ----------------------------------------------------------------------
// Vanilla Matters
function CreateSkillsList() {
    local VMSkillInfo info;
    local PersonaSkillButtonWindow skillButton;

    // Iterate through the skills, adding them to our list
    info = player.GetFirstSkillInfo();
    while( info != none ) {
        skillButton = PersonaSkillButtonWindow( winTile.NewChild( class'PersonaSkillButtonWindow' ) );
        skillButton.SetSkill( info );

        skillButtons[-1] = skillButton;

        info = info.Next;
    }

    // Select the first skill
    SelectSkillButton( skillButtons[0] );
}

// ----------------------------------------------------------------------
// CreateSkillPointsWindow()
// ----------------------------------------------------------------------

function CreateSkillPointsWindow()
{
    local PersonaHeaderTextWindow winText;

    winText = PersonaHeaderTextWindow(winClient.NewChild(Class'PersonaHeaderTextWindow'));
    // Vanilla Matters: Move the skill points text up to fit the new shortened menu.
    winText.SetPos( 180, 269 );
    winText.SetHeight(15);
    winText.SetText(SkillPointsHeaderText);

    winSkillPoints = PersonaHeaderTextWindow(winClient.NewChild(Class'PersonaHeaderTextWindow'));
    // Vanilla Matters: Move the skill points text up to fit the new shortened menu.
    winSkillPoints.SetPos( 250, 269 );
    winSkillPoints.SetSize(54, 15);
    winSkillPoints.SetTextAlignments(HALIGN_Right, VALIGN_Center);
    winSkillPoints.SetText(player.SkillPointsAvail);
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
    local bool bHandled;

    if (Super.ButtonActivated(buttonPressed))
        return True;

    bHandled   = True;

    // Check if this is one of our Skills buttons
    if (buttonPressed.IsA('PersonaSkillButtonWindow'))
    {
        SelectSkillButton(PersonaSkillButtonWindow(buttonPressed));
    }
    else
    {
        switch(buttonPressed)
        {
            case btnUpgrade:
                UpgradeSkill();
                break;

            default:
                bHandled = False;
                break;
        }
    }

    return bHandled;
}

// ----------------------------------------------------------------------
// VirtualKeyPressed()
// ----------------------------------------------------------------------

event bool VirtualKeyPressed(EInputKey key, bool bRepeat)
{
    local bool bHandled;

    bHandled = True;

    switch( key )
    {
        case IK_Up:
            SelectPreviousSkillButton();
            break;

        case IK_Down:
            SelectNextSkillButton();
            break;

        default:
            bHandled = False;
            break;
    }

    return bHandled;
}

// ----------------------------------------------------------------------
// SelectSkillButton()
// ----------------------------------------------------------------------

function SelectSkillButton(PersonaSkillButtonWindow buttonPressed)
{
    // Don't do extra work.
    if (selectedSkillButton != buttonPressed)
    {
        // Deselect current button
        if (selectedSkillButton != None)
            selectedSkillButton.SelectButton(False);

        selectedSkillButton = buttonPressed;
        selectedSkill       = selectedSkillButton.GetSkill();

        // Vanilla Matters
        UpdateInfo( selectedSkill );
        selectedSkillButton.SelectButton(True);

        EnableButtons();
    }
}

// ----------------------------------------------------------------------
// SelectPreviousSkillButton()
// ----------------------------------------------------------------------

function SelectPreviousSkillButton()
{
    local int skillIndex;

    skillIndex = GetCurrentSkillButtonIndex();

    if (--skillIndex < 0)
        skillIndex = #skillButtons - 1;

    skillButtons[skillIndex].ActivateButton(IK_LeftMouse);
}

// ----------------------------------------------------------------------
// SelectNextSkillButton()
// ----------------------------------------------------------------------

function SelectNextSkillButton()
{
    local int skillIndex;

    skillIndex = GetCurrentSkillButtonIndex();

    if (++skillIndex >= #skillButtons)
        skillIndex = 0;

    skillButtons[skillIndex].ActivateButton(IK_LeftMouse);
}

// ----------------------------------------------------------------------
// GetCurrentSkillButtonIndex()
// ----------------------------------------------------------------------
// Vanilla Matters
function int GetCurrentSkillButtonIndex() {
    local int buttonIndex;
    local int count;

    count = #skillButtons;
    for( buttonIndex = 0; buttonIndex < count; buttonIndex++ ) {
        if ( skillButtons[buttonIndex] == selectedSkillButton ) {
            return buttonIndex;
        }
    }

    return -1;
}

// ----------------------------------------------------------------------
// GetSkillButtonCount()
// ----------------------------------------------------------------------
// Vanilla Matters: Just use #skillButtons

// ----------------------------------------------------------------------
// UpgradeSkill()
// ----------------------------------------------------------------------

function UpgradeSkill()
{
    // First make sure we have a skill selected
    if ( selectedSkill == None )
        return;

    // Vanilla Matters
    if ( player.IncreaseSkillLevel( selectedSkill.DefinitionClassName ) ) {
        selectedSkillButton.RefreshSkillInfo();
        winSkillPoints.SetText( player.SkillPointsAvail );
    }

    EnableButtons();
}

// ----------------------------------------------------------------------
// EnableButtons()
// ----------------------------------------------------------------------

function EnableButtons()
{
    // Abort if a skill item isn't selected
    if ( selectedSkill == None )
    {
        btnUpgrade.SetSensitivity(False);
    }
    else
    {
        // Upgrade Skill only available if the skill is not at
        // the maximum -and- the user has enough skill points
        // available to upgrade the skill

        // Vanilla Matters
        btnUpgrade.EnableWindow( selectedSkill.CanUpgrade( player.SkillPointsAvail ) );
    }
}

// ----------------------------------------------------------------------
// RefreshWindow()
// ----------------------------------------------------------------------

function RefreshWindow(float DeltaTime)
{
    if (selectedSkill != None)
    {
        selectedSkillButton.RefreshSkillInfo();
    }

    winSkillPoints.SetText(player.SkillPointsAvail);
    EnableButtons();
    Super.RefreshWindow(DeltaTime);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

// Vanilla Matters: Update description window
function UpdateInfo( VMSkillInfo info ) {
    winInfo.Clear();
    winInfo.SetTitle( info.GetName() );
    winInfo.SetText( info.GetDescription() );
}

defaultproperties
{
     SkillsTitleText="Skills"
     UpgradeButtonLabel="|&Upgrade"
     PointsNeededHeaderText="Points Needed"
     SkillLevelHeaderText="Skill Level"
     SkillPointsHeaderText="Skill Points"
     SkillUpgradedLevelLabel="%s upgraded"
     clientBorderOffsetY=33
     ClientWidth=604
     ClientHeight=297
     clientOffsetX=19
     clientOffsetY=12
     clientTextures(0)=Texture'DeusEx.VMUI.SkillsBackground_1'
     clientTextures(1)=Texture'DeusEx.VMUI.SkillsBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.SkillsBackground_3'
     clientTextures(3)=Texture'DeusEx.VMUI.SkillsBackground_4'
     clientTextures(4)=Texture'DeusEx.VMUI.SkillsBackground_5'
     clientTextures(5)=Texture'DeusEx.VMUI.SkillsBackground_6'
     clientBorderTextures(0)=Texture'DeusExUI.UserInterface.SkillsBorder_1'
     clientBorderTextures(1)=Texture'DeusExUI.UserInterface.SkillsBorder_2'
     clientBorderTextures(2)=Texture'DeusExUI.UserInterface.SkillsBorder_3'
     clientBorderTextures(3)=Texture'DeusEx.VMUI.SkillsBorder_4'
     clientBorderTextures(4)=Texture'DeusEx.VMUI.SkillsBorder_5'
     clientBorderTextures(5)=Texture'DeusEx.VMUI.SkillsBorder_6'
     clientTextureRows=2
     clientTextureCols=3
     clientBorderTextureRows=2
     clientBorderTextureCols=3
}
