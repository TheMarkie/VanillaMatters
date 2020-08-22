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
var localized string VM_upgradeLabelText;
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

    EnableButtons();
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
    local HUDMedBotAugItemButton btn;

    if ( selectedAugButton != buttonPressed ) {
        // Deselect current button
        if ( selectedAugButton != none ) {
            selectedAugButton.SelectButton( false );
        }

        selectedAugButton = buttonPressed;
        selectedAug = PersonaAugmentationItemButton( buttonPressed ).VM_aug;

        // Check to see if this augmentation has already been installed
        // Vanilla Matters: Allow reinstalling the same aug to upgrade it. If the aug can't be upgraded further, ignore it.
        btn = HUDMedBotAugItemButton( buttonPressed );
        if ( btn != none ) {
            if ( selectedAug != none && !selectedAug.CanUpgrade() ) {
                winInfo.Clear();
                winInfo.SetTitle( selectedAug.GetDescription() );
                winInfo.SetText( VM_CantBeUpgradedText );
                winInfo.SetText( SelectAnotherText );

                selectedAug = none;
                selectedAugButton = none;
            }
            else if ( btn.bSlotFull && selectedAug != none ) {
                winInfo.Clear();
                winInfo.SetTitle( selectedAug.GetDescription() );
                winInfo.SetText( SlotFullText );
                winInfo.SetText( SelectAnotherText );

                selectedAug = none;
                selectedAugButton = none;
            }
            else {
                VM_AugSystem.UpdateInfo( selectedAug, winInfo );
                selectedAugButton.SelectButton( true );

                if ( selectedAug != none ) {
                    btnInstall.SetButtonText( VM_upgradeLabelText );
                }
                else {
                    btnInstall.SetButtonText( InstallButtonLabel );
                }
            }
        }

        EnableButtons();
    }
}

// ----------------------------------------------------------------------
// InstallAugmentation()
// ----------------------------------------------------------------------
// Vanilla Matters
function InstallAugmentation() {
    local HUDMedBotAugItemButton itemButton;
    // Vanilla Matters TODO: Restore functionality.

    local AugmentationCannister augCan;
    local name augClassName;

    // if (HUDMedBotAugItemButton(selectedAugButton) == None)
    //     return;

    // // Get pointers to the AugmentationCannister and the
    // // Augmentation Class

    itemButton = HUDMedBotAugItemButton( selectedAugButton );
    if ( itemButton == none ) {
        return;
    }

    augCan = itemButton.GetAugCan();
    augClassName = itemButton.VM_AugClassName;
    if ( augCan == none || augClassName == '' ) {
        return;
    }

    VM_AugSystem.Add( augClassName );

    // play a cool animation
    medBot.PlayAnim( 'Scan' );

    // Now Destroy the Augmentation cannister
    player.DeleteInventory(augCan);

    // Now remove the cannister from our list
    selectedAugButton.GetParent().Destroy();
    selectedAugButton = None;
    selectedAug = None;

    // Update the Installed Augmentation Icons
    DestroyAugmentationButtons();
    CreateAugmentationButtons();

    // Need to update the aug list
    PopulateAugCanList();

    // Vanilla Matter: Clears stuff and redisables the Install button properly.
    winInfo.Clear();
    EnableButtons();
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

function EnableButtons()
{
    // Only enable the Install button if the player has an
    // Augmentation Cannister aug button selected

    if (HUDMedBotAugItemButton(selectedAugButton) != None)
    {
        btnInstall.EnableWindow(True);
    }
    else
    {
        btnInstall.EnableWindow(False);
    }
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
     SlotFullText="The slot that this augmentation occupies is already full, therefore you cannot install it."
     SelectAnotherText="Please select another augmentation to install."
     VM_upgradeLabelText="|&Upgrade"
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
