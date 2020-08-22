//=============================================================================
// PersonaScreenAugmentations
//=============================================================================

class PersonaScreenAugmentations extends PersonaScreenBaseWindow;

#exec TEXTURE IMPORT FILE="Textures\AugmentationsBorder_6.bmp"      NAME="AugmentationsBorder_6"        GROUP="VMUI" MIPS=Off

var PersonaActionButtonWindow           btnActivate;
var PersonaActionButtonWindow           btnUpgrade;
var PersonaActionButtonWindow           btnUseCell;
var PersonaInfoWindow                   winInfo;
var PersonaAugmentationBodyWindow       winBody;
var PersonaAugmentationOverlaysWindow   winOverlays;
var PersonaItemDetailWindow             winBioCells;
var PersonaItemDetailWindow             winAugCans;
var ProgressBarWindow                   winBioEnergy;
var TextWindow                          winBioEnergyText;

// Vanilla Matters
var VMAugmentationInfo selectedAug;
var PersonaItemButton selectedAugButton;

struct AugLoc_S
{
    var int x;
    var int y;
};

var AugLoc_S augLocs[7];
var PersonaAugmentationItemButton augItems[12];
var Texture                       augHighlightTextures[6];
var Window                        augHighlightWindows[6];

var int augSlotSpacingX;
var int augSlotSpacingY;

var Color colBarBack;

var localized String AugmentationsTitleText;
var localized String UpgradeButtonLabel;
var localized String ActivateButtonLabel;
var localized String DeactivateButtonLabel;
var localized String UseCellButtonLabel;
var localized String AugCanUseText;
var localized String BioCellUseText;

var Localized string AugLocationDefault;
var Localized string AugLocationCranial;
var Localized string AugLocationEyes;
var Localized string AugLocationArms;
var Localized string AugLocationLegs;
var Localized string AugLocationTorso;
var Localized string AugLocationSubdermal;

// Vanilla Matters
var VMAugmentationManager VM_augSystem;

var PersonaAugmentationBar VM_augBar;
var PersonaAugmentationBarSlot VM_selectedSlot;

var bool VM_dragging;
var ButtonWindow VM_dragBtn;
var PersonaAugmentationBarSlot VM_lastDragOverSlot;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
    Super.InitWindow();

    EnableButtons();
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
    Super.CreateControls();

    // Vanilla Matters
    VM_augSystem = Player.GetAugmentationSystem();

    CreateTitleWindow(9, 5, AugmentationsTitleText);
    CreateInfoWindow();
    CreateButtons();
    CreateAugmentationLabels();
    CreateAugmentationHighlights();
    CreateAugmentationButtons();
    CreateOverlaysWindow();
    CreateBodyWindow();
    CreateBioCellBar();
    CreateAugCanWindow();
    CreateBioCellWindow();
    CreateStatusWindow();

    PersonaNavBarWindow(winNavBar).btnAugs.SetSensitivity(False);

    // Vanilla Matters
    CreateAugmentationBar();
}

// ----------------------------------------------------------------------
// CreateStatusWindow()
// ----------------------------------------------------------------------

function CreateStatusWindow()
{
    winStatus = PersonaStatusLineWindow(winClient.NewChild(Class'PersonaStatusLineWindow'));
    winStatus.SetPos(348, 240);
}

// ----------------------------------------------------------------------
// CreateButtons()
// ----------------------------------------------------------------------

function CreateButtons()
{
    local PersonaButtonBarWindow winActionButtons;

    winActionButtons = PersonaButtonBarWindow(winClient.NewChild(Class'PersonaButtonBarWindow'));
    winActionButtons.SetPos(13, 407);
    winActionButtons.SetWidth(187);
    winActionButtons.FillAllSpace(False);

    btnUpgrade = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
    btnUpgrade.SetButtonText(UpgradeButtonLabel);

    btnActivate = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
    btnActivate.SetButtonText(ActivateButtonLabel);

    winActionButtons = PersonaButtonBarWindow(winClient.NewChild(Class'PersonaButtonBarWindow'));
    winActionButtons.SetPos(346, 387);
    winActionButtons.SetWidth(97);
    winActionButtons.FillAllSpace(False);

    btnUseCell = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
    btnUseCell.SetButtonText(UseCellButtonLabel);
}

// ----------------------------------------------------------------------
// CreateBodyWindow()
// ----------------------------------------------------------------------

function CreateBodyWindow()
{
    winBody = PersonaAugmentationBodyWindow(winClient.NewChild(Class'PersonaAugmentationBodyWindow'));
    winBody.SetPos(72, 28);
    winBody.Lower();
}

// ----------------------------------------------------------------------
// CreateOverlaysWindow()
// ----------------------------------------------------------------------

function CreateOverlaysWindow()
{
    winOverlays = PersonaAugmentationOverlaysWindow(winClient.NewChild(Class'PersonaAugmentationOverlaysWindow'));
    winOverlays.SetPos(72, 28);
    winOverlays.Lower();
}

// ----------------------------------------------------------------------
// CreateInfoWindow()
// ----------------------------------------------------------------------

function CreateInfoWindow()
{
    winInfo = PersonaInfoWindow(winClient.NewChild(Class'PersonaInfoWindow'));
    winInfo.SetPos(348, 14);
    winInfo.SetSize(238, 218);
}

// ----------------------------------------------------------------------
// CreateAugmentationLabels()
// ----------------------------------------------------------------------

function CreateAugmentationLabels()
{
    CreateLabel( 57,  27, AugLocationCranial);
    CreateLabel(212,  27, AugLocationEyes);
    CreateLabel( 19, 103, AugLocationArms);
    CreateLabel( 19, 187, AugLocationSubdermal);
    CreateLabel(247, 109, AugLocationTorso);
    CreateLabel( 19, 330, AugLocationDefault);
    CreateLabel(247, 311, AugLocationLegs);
}

// ----------------------------------------------------------------------
// CreateLabel()
// ----------------------------------------------------------------------

function CreateLabel(int posX, int posY, String strLabel)
{
    local PersonaNormalTextWindow winLabel;

    winLabel = PersonaNormalTextWindow(winClient.NewChild(Class'PersonaNormalTextWindow'));
    winLabel.SetPos(posX, posY);
    winLabel.SetSize(52, 11);
    winLabel.SetText(strLabel);
    winLabel.SetTextMargins(2, 1);
}

// ----------------------------------------------------------------------
// CreateAugCanWindow()
// ----------------------------------------------------------------------

function CreateAugCanWindow()
{
    winAugCans = PersonaItemDetailWindow(winClient.NewChild(Class'PersonaItemDetailWindow'));
    winAugCans.SetPos(346, 274);
    winAugCans.SetWidth(242);
    winAugCans.SetIcon(Class'AugmentationUpgradeCannister'.Default.LargeIcon);
    winAugCans.SetIconSize(
        Class'AugmentationUpgradeCannister'.Default.largeIconWidth,
        Class'AugmentationUpgradeCannister'.Default.largeIconHeight);

    UpdateAugCans();
}

// ----------------------------------------------------------------------
// CreateBioCellWindow()
// ----------------------------------------------------------------------

function CreateBioCellWindow()
{
    winBioCells = PersonaItemDetailWindow(winClient.NewChild(Class'PersonaItemDetailWindow'));
    winBioCells.SetPos(346, 332);
    winBioCells.SetWidth(242);
    winBioCells.SetIcon(Class'BioelectricCell'.Default.LargeIcon);
    winBioCells.SetIconSize(
        Class'BioelectricCell'.Default.largeIconWidth,
        Class'BioelectricCell'.Default.largeIconHeight);

    UpdateBioCells();
}

// ----------------------------------------------------------------------
// CreateBioCellBar()
// ----------------------------------------------------------------------

function CreateBioCellBar()
{
    winBioEnergy = ProgressBarWindow(winClient.NewChild(Class'ProgressBarWindow'));

    winBioEnergy.SetPos(446, 389);
    winBioEnergy.SetSize(140, 12);
    winBioEnergy.SetValues(0, 100);
    winBioEnergy.UseScaledColor(True);
    winBioEnergy.SetVertical(False);
    winBioEnergy.SetScaleColorModifier(0.5);
    winBioEnergy.SetDrawBackground(True);
    winBioEnergy.SetBackColor(colBarBack);

    winBioEnergyText = TextWindow(winClient.NewChild(Class'TextWindow'));
    winBioEnergyText.SetPos(446, 391);
    winBioEnergyText.SetSize(140, 12);
    winBioEnergyText.SetTextMargins(0, 0);
    winBioEnergyText.SetTextAlignments(HALIGN_Center, VALIGN_Center);
    winBioEnergyText.SetFont(Font'FontMenuSmall_DS');
    winBioEnergyText.SetTextColorRGB(255, 255, 255);

    UpdateBioEnergyBar();
}

// ----------------------------------------------------------------------
// UpdateBioEnergyBar()
// ----------------------------------------------------------------------

function UpdateBioEnergyBar()
{
    local float energyPercent;

    energyPercent = 100.0 * (player.Energy / player.EnergyMax);

    winBioEnergy.SetCurrentValue(energyPercent);
    winBioEnergyText.SetText(String(Int(energyPercent)) $ "%");
}

// ----------------------------------------------------------------------
// UpdateAugCans()
// ----------------------------------------------------------------------

function UpdateAugCans()
{
    local Inventory anItem;
    local int augCanCount;

    if (winAugCans != None)
    {
        winAugCans.SetText(AugCanUseText);

        // Loop through the player's inventory and count how many upgrade cans
        // the player has
        anItem = player.Inventory;

        while(anItem != None)
        {
            if (anItem.IsA('AugmentationUpgradeCannister'))
                augCanCount++;

            anItem = anItem.Inventory;
        }

        winAugCans.SetCount(augCanCount);
    }
}

// ----------------------------------------------------------------------
// UpdateBioCells()
// ----------------------------------------------------------------------

function UpdateBioCells()
{
    local BioelectricCell bioCell;

    if (winBioCells != None)
    {
        winBioCells.SetText(BioCellUseText);

        bioCell = BioelectricCell(player.FindInventoryType(Class'BioelectricCell'));

        if (bioCell != None)
            winBioCells.SetCount(bioCell.NumCopies);
        else
            winBioCells.SetCount(0);
    }

    UpdateBioEnergyBar();
}

// ----------------------------------------------------------------------
// CreateAugmentationHighlights()
// ----------------------------------------------------------------------

function CreateAugmentationHighlights()
{
    augHighlightWindows[0] = CreateHighlight(augHighlightTextures[0], 142,  45, 16, 19);
    augHighlightWindows[1] = CreateHighlight(augHighlightTextures[1], 161,  63, 19, 12);
    augHighlightWindows[2] = CreateHighlight(augHighlightTextures[2], 157, 108, 34, 48);
    augHighlightWindows[3] = CreateHighlight(augHighlightTextures[3], 105, 110, 24, 43);
    augHighlightWindows[4] = CreateHighlight(augHighlightTextures[4], 165, 222, 32, 94);
    augHighlightWindows[5] = CreateHighlight(augHighlightTextures[5],  84, 160, 14, 36);
}

// ----------------------------------------------------------------------
// CreateHighlight()
// ----------------------------------------------------------------------

function Window CreateHighlight(
    Texture texHighlight,
    int posX, int posY,
    int sizeX, int sizeY)
{
    local Window newHighlight;

    newHighlight = winClient.NewChild(Class'Window');

    newHighlight.SetPos(posX, posY);
    newHighlight.SetSize(sizeX, sizeY);
    newHighlight.SetBackground(texHighlight);
    newHighlight.SetBackgroundStyle(DSTY_Masked);
    newHighlight.Hide();

    return newHighlight;
}

// ----------------------------------------------------------------------
// CreateAugmentationButtons()
//
// Loop through all the Augmentation items and draw them in our Augmentation grid as
// buttons
// ----------------------------------------------------------------------
// Vanilla Matters
function CreateAugmentationButtons() {
    local VMAugmentationInfo info;
    local int i, slot, x, y;
    local int torsoCount, skinCount, defaultCount, augCount;

    // Iterate through the augmentations, creating a unique button for each
    // Vanilla Matters TODO: Add aug screen support.
    info = player.GetFirstAugmentationInfo();
    while( info != none ) {
        i = 0;
        slot = info.GetInstallLocation();
        x = augLocs[slot].x;
        y = augLocs[slot].y;

        // Show the highlight graphic for this augmentation slot as long
        // as it's not the Default slot (for which there is no graphic)
        if ( slot > 0 ) {
            augHighlightWindows[slot - 1].Show();
        }
        else {
            x += defaultCount++ * augSlotSpacingX;
        }

        // Torso
        if ( slot == 3 ) {
            i = torsoCount++;
            y += torsoCount * augSlotSpacingY;
        }
        // Subdermal
        else if ( slot == 5 ) {
            i = skinCount++;
            y += skinCount * augSlotSpacingY;
        }

        augItems[augCount] = CreateAugButton( info, x, y, i );
        augCount++;

        info = info.next;
    }
}

// ----------------------------------------------------------------------
// CreateAugButton
// ----------------------------------------------------------------------
// Vanilla Matters
function PersonaAugmentationItemButton CreateAugButton( VMAugmentationInfo info, int x, int y, int i ) {
    local PersonaAugmentationItemButton newButton;

    newButton = PersonaAugmentationItemButton( winClient.NewChild( Class'PersonaAugmentationItemButton' ) );
    newButton.SetPos( x, y );
    newButton.SetClientObject( info );
    newButton.SetIcon( info.GetIcon() );

    // If the augmentation is currently active, notify the button
    newButton.SetLevel( info.Level );
    newButton.SetActive( info.IsActive );

    // Vanilla Matters: Set up stuff for dragging.
    newButton.VM_aug = info;
    newButton.VM_augWnd = self;
    newButton.VM_draggable = !( info.IsPassive() || info.DefinitionClassName == 'AugLight' );
    newButton.VM_dragIcon = info.GetSmallIcon();

    return newButton;
}

// Vanilla Matters: Create augmentation hotbar.
function CreateAugmentationBar() {
    VM_augBar = PersonaAugmentationBar( NewChild( class'PersonaAugmentationBar' ) );
    VM_augBar.SetWindowAlignments( HALIGN_Right, VALIGN_Bottom, 0, 0 );
    VM_augBar.SetAugWnd( self );
}

// Vanilla Matters: Update the aug display on the HUD.
function DestroyWindow() {
    player.RefreshAugmentationDisplay();

    super.DestroyWindow();
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated(Window buttonPressed)
{
    local bool bHandled;

    if (Super.ButtonActivated(buttonPressed))
        return True;

    bHandled   = True;

    // Check if this is one of our Augmentation buttons
    if (buttonPressed.IsA('PersonaItemButton'))
    {
        SelectAugmentation(PersonaItemButton(buttonPressed));
    }
    else
    {
        switch(buttonPressed)
        {
            case btnUpgrade:
                UpgradeAugmentation();
                break;

            case btnActivate:
                ActivateAugmentation();
                break;

            case btnUseCell:
                UseCell();
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
//
// Called when a key is pressed; provides a virtual key value
// ----------------------------------------------------------------------

event bool VirtualKeyPressed(EInputKey key, bool bRepeat)
{
    local bool bKeyHandled;
    bKeyHandled = True;

    if (Super.VirtualKeyPressed(key, bRepeat))
        return True;

    switch( key )
    {
        // Vanilla Matters: Disable the F hotkeys because aug keys aren't hardcoded anymore.

        // Enter will toggle an aug on/off
        case IK_Enter:
            ActivateAugmentation();
            break;

        default:
            bKeyHandled = False;
            break;
    }

    return bKeyHandled;
}

// ----------------------------------------------------------------------
// SelectAugmentation()
// ----------------------------------------------------------------------

function SelectAugmentation(PersonaItemButton buttonPressed)
{
    // Don't do extra work.
    if (selectedAugButton != buttonPressed)
    {
        // Deselect current button
        if (selectedAugButton != None)
            selectedAugButton.SelectButton(False);

        selectedAugButton = buttonPressed;

        // Vanilla Matters
        selectedAug = PersonaAugmentationItemButton( buttonPressed ).VM_aug;

        VM_AugSystem.UpdateInfo( selectedAug, winInfo );
        selectedAugButton.SelectButton(True);

        // Vanilla Matters: Highlight the slot that the aug is assigned to, if any.
        VM_augBar.SelectAug( selectedAug.DefinitionClassName, true );

        EnableButtons();
    }
}

// ----------------------------------------------------------------------
// UpgradeAugmentation()
// ----------------------------------------------------------------------
// Vanilla Matters
function UpgradeAugmentation() {
    local AugmentationUpgradeCannister augCan;

    // First make sure we have a selected Augmentation
    if ( selectedAug == none ) {
        return;
    }

    // Now check to see if we have an upgrade cannister
    augCan = AugmentationUpgradeCannister( player.FindInventoryType( class'AugmentationUpgradeCannister' ) );
    if ( augCan != none ) {
        // Increment the level and remove the aug cannister from
        // the player's inventory

        selectedAug.IncreaseLevel();
        VM_augSystem.UpdateInfo( selectedAug, winInfo );

        augCan.UseOnce();

        // Update the level icons
        if ( selectedAugButton != none ) {
            PersonaAugmentationItemButton( selectedAugButton ).SetLevel( selectedAug.Level );
        }
    }

    UpdateAugCans();
    EnableButtons();
}

// ----------------------------------------------------------------------
// ActivateAugmentation()
// ----------------------------------------------------------------------
// Vanilla Matters
function ActivateAugmentation() {
    if ( selectedAug == none ) {
        return;
    }

    selectedAug.Toggle( VMPlayer( player ), !selectedAug.IsActive );

    // If the augmentation activated or deactivated, set the
    // button appropriately.

    if (selectedAugButton != None) {
        PersonaAugmentationItemButton( selectedAugButton ).SetActive( selectedAug.IsActive );
    }

    VM_AugSystem.UpdateInfo( selectedAug, winInfo );

    EnableButtons();
}

// ----------------------------------------------------------------------
// UseCell()
// ----------------------------------------------------------------------

function UseCell()
{
    local BioelectricCell bioCell;

    bioCell = BioelectricCell(player.FindInventoryType(Class'BioelectricCell'));

    if (bioCell != None)
        bioCell.Activate();

    UpdateBioCells();
    EnableButtons();
}

// ----------------------------------------------------------------------
// EnableButtons()
// ----------------------------------------------------------------------

function EnableButtons()
{
    // Upgrade can only be enabled if the player has an
    // AugmentationUpgradeCannister that allows this augmentation to
    // be upgraded

    // Vanilla Matters
    if ( selectedAug != None && AugmentationUpgradeCannister( player.FindInventoryType( class'AugmentationUpgradeCannister' ) ) != None ) {
        btnUpgrade.EnableWindow( selectedAug.CanUpgrade() );
    }
    else {
        btnUpgrade.EnableWindow( false );
    }

    // Only allow btnActivate to be active if
    //
    // 1.  We have a selected augmentation
    // 2.  The player's energy is above 0
    // 3.  This augmentation isn't "AlwaysActive"

    // Vanilla Matters
    btnActivate.EnableWindow( selectedAug != none && player.Energy > 0 && !selectedAug.IsPassive() );

    if ( selectedAug != None )
    {
        if ( selectedAug.IsActive )
            btnActivate.SetButtonText(DeactivateButtonLabel);
        else
            btnActivate.SetButtonText(ActivateButtonLabel);
    }

    // Use Cell button
    //
    // Only active if the player has one or more Energy Cells and
    // BioElectricEnergy < 100%

    btnUseCell.EnableWindow(
        (player.Energy < player.EnergyMax) &&
        (player.FindInventoryType(Class'BioelectricCell') != None));
}

// Vanilla Matters: Add drag and drop support for aug icons.
function StartButtonDrag( ButtonWindow dragBtn ) {
    if ( dragBtn != none ) {
        VM_dragging = true;
        VM_dragBtn = dragBtn;
    }
}

function UpdateDragMouse( float newX, float newY ) {
    local PersonaAugmentationBarSlot slot;
    local float relX, relY;
    local int slotX, slotY;
    local bool validDrop;
    local bool overrideBtnColor;

    slot = PersonaAugmentationBarSlot( FindWindow( newX, newY, relX, relY ) );
    if ( slot != None ) {
        slot.SetDropFill( true );
    }

    if ( VM_lastDragOverSlot != none && VM_lastDragOverSlot != slot ) {
        VM_lastDragOverSlot.ResetFill();
    }

    VM_lastDragOverSlot = slot;
}

function FinishButtonDrag() {
    local PersonaAugmentationBarSlot dragSlot, slot;

    dragSlot = PersonaAugmentationBarSlot( VM_dragBtn );

    if ( VM_lastDragOverSlot != none ) {
        if ( dragSlot != none ) {
            VM_augBar.SwapAug( dragSlot, VM_lastDragOverSlot );
            VM_lastDragOverSlot.SetToggle( true );
        }
        else {
            slot = VM_augBar.GetSlot( PersonaAugmentationItemButton( VM_dragBtn ).VM_aug.DefinitionClassName );

            if ( slot != none ) {
                // Vanilla Matters TODO: Add aug screen drag support.
                VM_augBar.SwapAug( slot, VM_lastDragOverSlot );
            }
            else {
                // Vanilla Matters TODO: Add aug screen drag support.
                VM_augBar.AddAug( PersonaAugmentationItemButton( VM_dragBtn ).VM_aug, VM_lastDragOverSlot.slot );
            }
        }
    }
    else {
        if ( dragSlot != none ) {
            // Vanilla Matters TODO: Add aug screen drag support.
            VM_augBar.RemoveAug( dragSlot.aug.DefinitionClassName );
        }
    }

    EndDragMode();
}

function EndDragMode() {
    local PersonaAugmentationItemButton button;

    button = PersonaAugmentationItemButton( VM_dragBtn );
    if ( button != none ) {
        SelectAugmentation( button );
    }

    if ( VM_lastDragOverSlot != none ) {
        VM_lastDragOverSlot.ResetFill();
    }

    VM_dragging = false;
    VM_dragBtn = none;
    VM_lastDragOverSlot = none;

    RefreshAugBar();
}

function RefreshAugBar() {
    if ( VM_augBar != none ) {
        VM_augBar.PopulateBar();
    }
}

// Vanilla Matters: Select the appropriate aug when player clicks on a slot on the aug bar.
function bool ToggleChanged( Window button, bool bNewToggle ) {
    local PersonaAugmentationBarSlot slot;
    local int i;

    slot = PersonaAugmentationBarSlot( button );
    if ( slot != none && bNewToggle ) {
        if ( VM_selectedSlot != none && VM_selectedSlot != slot ) {
            VM_selectedSlot.HighlightSelect( false );
        }

        if ( slot.aug != none ) {
            slot.HighlightSelect( bNewToggle );

            if ( slot.aug != selectedAug ) {
                for ( i = 0; i < 12; i++ ) {
                    if ( augItems[i].VM_aug.DefinitionClassName == slot.aug.DefinitionClassName ) {
                        SelectAugmentation( augItems[i] );

                        break;
                    }
                }
            }

            VM_selectedSlot = slot;
        }
        else {
            VM_selectedSlot = none;
        }
    }

    return true;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     AugLocs(0)=(X=18,Y=341)
     AugLocs(1)=(X=56,Y=38)
     AugLocs(2)=(X=211,Y=38)
     AugLocs(3)=(X=246,Y=120)
     AugLocs(4)=(X=18,Y=114)
     AugLocs(5)=(X=246,Y=322)
     AugLocs(6)=(X=18,Y=198)
     augHighlightTextures(0)=Texture'DeusExUI.UserInterface.AugmentationsLocationCerebral'
     augHighlightTextures(1)=Texture'DeusExUI.UserInterface.AugmentationsLocationEyes'
     augHighlightTextures(2)=Texture'DeusExUI.UserInterface.AugmentationsLocationTorso'
     augHighlightTextures(3)=Texture'DeusExUI.UserInterface.AugmentationsLocationArms'
     augHighlightTextures(4)=Texture'DeusExUI.UserInterface.AugmentationsLocationLegs'
     augHighlightTextures(5)=Texture'DeusExUI.UserInterface.AugmentationsLocationSubdermal'
     augSlotSpacingX=53
     augSlotSpacingY=59
     AugmentationsTitleText="Augmentations"
     UpgradeButtonLabel="|&Upgrade"
     ActivateButtonLabel="Acti|&vate"
     DeactivateButtonLabel="Deac|&tivate"
     UseCellButtonLabel="Us|&e Cell"
     AugCanUseText="To upgrade an Augmentation, click on the Augmentation you wish to upgrade, then on the Upgrade button."
     BioCellUseText="To replenish Bioelectric Energy for your Augmentations, click on the Use Cell button."
     AugLocationDefault="Default"
     AugLocationCranial="Cranial"
     AugLocationEyes="Eyes"
     AugLocationArms="Arms"
     AugLocationLegs="Legs"
     AugLocationTorso="Torso"
     AugLocationSubdermal="Subdermal"
     screenHeight=534
     clientBorderOffsetY=32
     ClientWidth=596
     ClientHeight=427
     clientOffsetX=25
     clientOffsetY=5
     clientTextures(0)=Texture'DeusExUI.UserInterface.AugmentationsBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.AugmentationsBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.AugmentationsBackground_3'
     clientTextures(3)=Texture'DeusExUI.UserInterface.AugmentationsBackground_4'
     clientTextures(4)=Texture'DeusExUI.UserInterface.AugmentationsBackground_5'
     clientTextures(5)=Texture'DeusExUI.UserInterface.AugmentationsBackground_6'
     clientBorderTextures(0)=Texture'DeusExUI.UserInterface.AugmentationsBorder_1'
     clientBorderTextures(1)=Texture'DeusExUI.UserInterface.AugmentationsBorder_2'
     clientBorderTextures(2)=Texture'DeusExUI.UserInterface.AugmentationsBorder_3'
     clientBorderTextures(3)=Texture'DeusExUI.UserInterface.AugmentationsBorder_4'
     clientBorderTextures(4)=Texture'DeusExUI.UserInterface.AugmentationsBorder_5'
     clientBorderTextures(5)=Texture'DeusEx.VMUI.AugmentationsBorder_6'
     clientTextureRows=2
     clientTextureCols=3
     clientBorderTextureRows=2
     clientBorderTextureCols=3
}
