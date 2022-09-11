//=============================================================================
// HUDMedBotAddAugsScreen
//=============================================================================

class HUDMedBotAddAugsScreen extends PersonaScreenAugmentations;

var MedicalBot medBot;

var PersonaActionButtonWindow btnInstall;
var TileWindow winAugsTile;
var Bool bSkipAnimation;

var Localized String AvailableAugsText;
var Localized String MedbotInterfaceText;
var Localized String InstallButtonLabel;
var Localized String NoCansAvailableText;
var Localized String AlreadyHasItText;
var Localized String SlotFullText;
var Localized String SelectAnotherText;

// Vanilla Matters
var localized string VM_UpgradeLabelText;
var localized String VM_CantBeUpgradedText;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
    Super.InitWindow();

    HUDMedBotNavBarWindow(winNavBar).btnAugs.SetSensitivity(False);

    PopulateAugCanList();

    // Vanilla Matters
    btnInstall.EnableWindow( false );
}

// ----------------------------------------------------------------------
// DestroyWindow()
//
// Let the medbot go about its business.
// ----------------------------------------------------------------------

event DestroyWindow()
{
    if (medBot != None)
    {
        if (!bSkipAnimation)
        {
            medBot.PlayAnim('Stop');
            medBot.PlaySound(sound'MedicalBotLowerArm', SLOT_None);
            medBot.FollowOrders();
        }
    }

    Super.DestroyWindow();
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
    CreateNavBarWindow();
    CreateClientBorderWindow();
    CreateClientWindow();

    CreateTitleWindow(9, 5, AugmentationsTitleText);
    CreateInfoWindow();
    CreateButtons();
    CreateAugmentationLabels();
    CreateAugmentationHighlights();
    CreateAugmentationButtons();
    CreateOverlaysWindow();
    CreateBodyWindow();
    CreateAugsLabel();
    CreateAugCanList();
    CreateMedbotLabel();
}

// ----------------------------------------------------------------------
// CreateNavBarWindow()
// ----------------------------------------------------------------------

function CreateNavBarWindow()
{
    winNavBar = PersonaNavBarBaseWindow(NewChild(Class'HUDMedBotNavBarWindow'));
    winNavBar.SetPos(0, 0);
}

// ----------------------------------------------------------------------
// CreateButtons()
// ----------------------------------------------------------------------

function CreateButtons()
{
    local PersonaButtonBarWindow winActionButtons;

    winActionButtons = PersonaButtonBarWindow(winClient.NewChild(Class'PersonaButtonBarWindow'));
    winActionButtons.SetPos(346, 371);
    winActionButtons.SetWidth(96);

    btnInstall = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
    btnInstall.SetButtonText(InstallButtonLabel);
}

// ----------------------------------------------------------------------
// CreateInfoWindow()
// ----------------------------------------------------------------------

function CreateInfoWindow()
{
    winInfo = PersonaInfoWindow(winClient.NewChild(Class'PersonaInfoWindow'));
    winInfo.SetPos(348, 158);
    winInfo.SetSize(238, 210);
}

// ----------------------------------------------------------------------
// CreateAugsLabel()
// ----------------------------------------------------------------------

function CreateAugsLabel()
{
    CreatePersonaHeaderText(349, 15, AvailableAugsText, winClient);
}

// ----------------------------------------------------------------------
// CreateMedbotLabel()
// ----------------------------------------------------------------------

function CreateMedbotLabel()
{
    local PersonaHeaderTextWindow txtLabel;

    txtLabel = PersonaHeaderTextWindow(NewChild(Class'PersonaHeaderTextWindow'));
    txtLabel.SetPos(305, 9);
    txtLabel.SetSize(250, 16);
    txtLabel.SetTextAlignments(HALIGN_Right, VALIGN_Center);
    txtLabel.SetText(MedbotInterfaceText);
}

// ----------------------------------------------------------------------
// CreateAugCanList()
// ----------------------------------------------------------------------

function CreateAugCanList()
{
    local PersonaScrollAreaWindow winScroll;

    // First create the scroll window
    winScroll = PersonaScrollAreaWindow(winClient.NewChild(Class'PersonaScrollAreaWindow'));
    winScroll.SetPos(348, 34);
    winScroll.SetSize(238, 116);

    winAugsTile = TileWindow(winScroll.ClipWindow.NewChild(Class'TileWindow'));
    winAugsTile.MakeWidthsEqual(False);
    winAugsTile.MakeHeightsEqual(False);
    winAugsTile.SetMinorSpacing(1);
    winAugsTile.SetMargins(0, 0);
    winAugsTile.SetOrder(ORDER_Down);
}

// ----------------------------------------------------------------------
// PopulateAugCanList()
// ----------------------------------------------------------------------

function PopulateAugCanList()
{
    local Inventory item;
    local int canCount;
    local HUDMedBotAugCanWindow augCanWindow;
    local PersonaNormalTextWindow txtNoCans;

    winAugsTile.DestroyAllChildren();

    // Loop through all the Augmentation Cannisters in the player's
    // inventory, adding one row for each can.
    item = player.Inventory;

    while(item != None)
    {
        if (item.IsA('AugmentationCannister'))
        {
            augCanWindow = HUDMedBotAugCanWindow(winAugsTile.NewChild(Class'HUDMedBotAugCanWindow'));
            augCanWindow.SetCannister(AugmentationCannister(item));

            canCount++;
        }
        item = item.Inventory;
    }

    // If we didn't add any cans, then display "No Aug Cannisters Available!"
    if (canCount == 0)
    {
        txtNoCans = PersonaNormalTextWindow(winAugsTile.NewChild(Class'PersonaNormalTextWindow'));
        txtNoCans.SetText(NoCansAvailableText);
        txtNoCans.SetTextMargins(4, 4);
        txtNoCans.SetTextAlignments(HALIGN_Left, VALIGN_Center);
    }
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------
// Vanilla Matters
function bool ButtonActivated( Window buttonPressed ) {
    switch( buttonPressed ) {
        case btnInstall:
            InstallAugmentation();
            break;

        default:
            return super.ButtonActivated( buttonPressed );
    }

    return true;
}

// ----------------------------------------------------------------------
// SelectAugmentation()
// ----------------------------------------------------------------------
// Vanilla Matters
function SelectAugmentation( PersonaItemButton buttonPressed ) {
    local HUDMedBotAugItemButton itemButton;
    local class<VMAugmentation> augClass;

    if ( selectedAugButton != buttonPressed ) {
        // Deselect current button
        if ( selectedAugButton != none ) {
            selectedAugButton.SelectButton( false );
        }

        itemButton = HUDMedBotAugItemButton( buttonPressed );
        if ( itemButton == none ) {
            selectedAugButton = buttonPressed;
            selectedAug = none;

            VM_AugSystem.GetFullDescription( VMAugmentationInfo( buttonPressed.GetClientObject() ), winInfo );
            selectedAugButton.SelectButton( true );

            btnInstall.EnableWindow( false );
            return;
        }

        selectedAugButton = buttonPressed;
        selectedAug = VMAugmentationInfo( itemButton.GetClientObject() );
        if ( selectedAug == none ) {
            augClass = class<VMAugmentation>( itemButton.GetClientObject() );
        }

        // Check to see if this augmentation has already been installed
        // Vanilla Matters: Allow reinstalling the same aug to upgrade it. If the aug can't be upgraded further, ignore it.
        if ( selectedAug != none && !selectedAug.CanUpgrade() ) {
            winInfo.Clear();
            winInfo.SetTitle( selectedAug.GetName() );
            winInfo.SetText( VM_CantBeUpgradedText );
            winInfo.SetText( SelectAnotherText );

            btnInstall.SetButtonText( VM_UpgradeLabelText );
            btnInstall.EnableWindow( false );

            selectedAug = none;
        }
        else if ( itemButton.bSlotFull && selectedAug == none ) {
            winInfo.Clear();
            winInfo.SetTitle( augClass.default.UpgradeName );
            winInfo.SetText( SlotFullText );
            winInfo.SetText( SelectAnotherText );

            btnInstall.SetButtonText( InstallButtonLabel );
            btnInstall.EnableWindow( false );

            selectedAug = none;
        }
        else {
            if ( selectedAug != none ) {
                VM_AugSystem.GetFullDescription( selectedAug, winInfo );
                btnInstall.SetButtonText( VM_UpgradeLabelText );
            }
            else {
                VM_AugSystem.GetBaseDescription( augClass, winInfo );
                btnInstall.SetButtonText( InstallButtonLabel );
            }

            btnInstall.EnableWindow( true );
        }

        selectedAugButton.SelectButton( true );
    }
}

// ----------------------------------------------------------------------
// InstallAugmentation()
// ----------------------------------------------------------------------
// Vanilla Matters
function InstallAugmentation() {
    local HUDMedBotAugItemButton itemButton;
    local AugmentationCannister augCan;
    local VMAugmentationInfo info;

    itemButton = HUDMedBotAugItemButton( selectedAugButton );
    if ( itemButton == none ) {
        return;
    }

    augCan = itemButton.GetAugCan();
    if ( augCan == none ) {
        return;
    }

    info = VMAugmentationInfo( itemButton.GetClientObject() );
    if ( info != none ) {
        info.IncreaseLevel();
    }
    else {
        player.AddAugmentation(itemButton.GetClientObject().Name, itemButton.GetClientObject().Outer.Name);
    }

    // play a cool animation
    medBot.PlayAnim( 'Scan' );

    // Now Destroy the Augmentation cannister
    player.DeleteInventory( augCan );

    // Now remove the cannister from our list
    selectedAugButton.GetParent().Destroy();
    selectedAugButton = none;
    selectedAug = none;

    // Update the Installed Augmentation Icons
    DestroyAugmentationButtons();
    CreateAugmentationButtons();

    // Need to update the aug list
    PopulateAugCanList();

    // Vanilla Matter: Clears stuff and redisables the Install button properly.
    winInfo.Clear();
    btnInstall.EnableWindow( false );
}

// ----------------------------------------------------------------------
// DestroyAugmentationButtons()
// ----------------------------------------------------------------------

function DestroyAugmentationButtons()
{
    local int buttonIndex;

    for(buttonIndex=0; buttonIndex<arrayCount(augItems); buttonIndex++)
    {
        if (augItems[buttonIndex] != None)
            augItems[buttonIndex].Destroy();
    }
}

// ----------------------------------------------------------------------
// EnableButtons()
// ----------------------------------------------------------------------
// Vanilla Matters: Stub because we handle buttons manually.
function EnableButtons() {
}

// ----------------------------------------------------------------------
// SetMedicalBot()
// ----------------------------------------------------------------------

function SetMedicalBot(MedicalBot newBot, optional bool bPlayAnim)
{
    medBot = newBot;

    if (medBot != None)
    {
        medBot.StandStill();

        if (bPlayAnim)
        {
            medBot.PlayAnim('Start');
            medBot.PlaySound(sound'MedicalBotRaiseArm', SLOT_None);
        }
    }
}

// ----------------------------------------------------------------------
// SkipAnimation()
// ----------------------------------------------------------------------

function SkipAnimation(bool bNewSkipAnimation)
{
    bSkipAnimation = bNewSkipAnimation;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     AvailableAugsText="Available Augmentations"
     MedbotInterfaceText="MEDBOT INTERFACE"
     InstallButtonLabel="|&Install"
     NoCansAvailableText="No Augmentation Cannisters Available!"
     AlreadyHasItText="You already have this augmentation, therefore you cannot install it a second time."
     SlotFullText="The location that this augmentation occupies is already full, therefore you cannot install it."
     SelectAnotherText="Please select another augmentation to install."
     VM_UpgradeLabelText="|&Upgrade"
     VM_CantBeUpgradedText="You cannot upgrade this augmentation any further."
     clientTextures(0)=Texture'DeusExUI.UserInterface.HUDMedbotBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.HUDMedbotBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.HUDMedbotBackground_3'
     clientTextures(3)=Texture'DeusExUI.UserInterface.HUDMedbotBackground_4'
     clientTextures(4)=Texture'DeusExUI.UserInterface.HUDMedbotBackground_5'
     clientTextures(5)=Texture'DeusExUI.UserInterface.HUDMedbotBackground_6'
     clientBorderTextures(0)=Texture'DeusExUI.UserInterface.HUDMedBotAugmentationsBorder_1'
     clientBorderTextures(1)=Texture'DeusExUI.UserInterface.HUDMedBotAugmentationsBorder_2'
     clientBorderTextures(2)=Texture'DeusExUI.UserInterface.HUDMedBotAugmentationsBorder_3'
     clientBorderTextures(3)=Texture'DeusExUI.UserInterface.HUDMedBotAugmentationsBorder_4'
     clientBorderTextures(4)=Texture'DeusExUI.UserInterface.HUDMedBotAugmentationsBorder_5'
     clientBorderTextures(5)=Texture'DeusExUI.UserInterface.HUDMedBotAugmentationsBorder_6'
}
