//=============================================================================
// PersonaScreenInventory
//=============================================================================

class PersonaScreenInventory extends PersonaScreenBaseWindow;

var PersonaActionButtonWindow btnEquip;
var PersonaActionButtonWindow btnUse;
var PersonaActionButtonWindow btnDrop;
var PersonaActionButtonWindow btnChangeAmmo;

var Window                        winItems;
var PersonaInventoryInfoWindow    winInfo;
var PersonaItemButton             selectedItem;			// Currently Selected Inventory item
var PersonaInventoryCreditsWindow winCredits;
var PersonaItemDetailWindow       winNanoKeyRing;
var PersonaItemDetailWindow       winAmmo;

var Bool bUpdatingAmmoDisplay;
var float TimeSinceLastUpdate;

// Inventory object belt
var PersonaInventoryObjectBelt invBelt;
var HUDObjectSlot		       selectedSlot;

var	int invButtonWidth;
var int	invButtonHeight;

var int	smallInvWidth;									// Small Inventory Button Width
var int	smallInvHeight;									// Small Inventory Button Heigth

// Drag and Drop Stuff
var Bool         bDragging;
var ButtonWindow dragButton;							// Button we're dragging around
var ButtonWindow lastDragOverButton;
var Window       lastDragOverWindow;
var Window       destroyWindow;							// Used to defer window destroy

var localized String InventoryTitleText;
var localized String EquipButtonLabel;
var localized String UnequipButtonLabel;
var localized String UseButtonLabel;
var localized String DropButtonLabel;
var localized String ChangeAmmoButtonLabel;
var localized String NanoKeyRingInfoText;
var localized String NanoKeyRingLabel;
var localized String DroppedLabel;
var localized String AmmoLoadedLabel;
var localized String WeaponUpgradedLabel;
var localized String CannotBeDroppedLabel;
var localized String AmmoInfoText;
var localized String AmmoTitleLabel;
var localized String NoAmmoLabel;

// Vanilla Matters
var float VM_mouseX;									// Just something to keep track of mouse position during a drag.
var float VM_mouseY;
var int VM_lastMouseSlotX;								// Last slot position the swap checks were run.
var int VM_lastMouseSlotY;

var bool VM_bSwapping;									// Means we're swapping.
var bool VM_bValidSwap;
var PersonaInventoryItemButton VM_swapOriginal;			// The original item being dragged.
var float VM_swapOriginalX;								// The on screen coordinates.
var float VM_swapOriginalY;
var int VM_swapOriginalSlotX;							// The inventory grid coordinates.
var int VM_swapOriginalSlotY;
var PersonaInventoryItemButton VM_swapOthers[15];		// The math shows that there can only be at most 15 items being swapped, so that's our array size.
var int VM_swapOtherCount;								// To keep track of actual amount of element.
var float VM_swapOtherXs[15];
var float VM_swapOtherYs[15];
var int VM_swapOtherSlotXs[15];
var int VM_swapOtherSlotYs[15];

var Color VM_colSwap;									// Color for swap indicators.

// Vanilla Matters: The functions below are for managing arrays.
function int FindSwapOther( PersonaInventoryItemButton other ) {
	local int i;

	for ( i = 0; i < VM_swapOtherCount; i++ ) {
		if ( VM_swapOthers[i] == other ) {
			return i;
		}
	}

	return -1;
}
function bool AddSwapOther( PersonaInventoryItemButton other ) {
	if ( VM_swapOtherCount >= ArrayCount( VM_swapOthers ) ) {
		return false;
	}

	if ( FindSwapOther( other ) < 0 ) {
		VM_swapOthers[VM_swapOtherCount] = other;
		VM_swapOtherCount = VM_swapOtherCount + 1;
	}

	return true;
}
function  ClearSwapOthers() {
	local int i;

	for ( i = 0; i < ArrayCount( VM_swapOthers ); i++ ) {
		VM_swapOthers[i] = None;
	}

	VM_swapOtherCount = 0;
}
function InitSwapOriginal() {
	VM_swapOriginal = None;
	VM_swapOriginalX = -1;
	VM_swapOriginalY = -1;
	VM_swapOriginalSlotX = -1;
	VM_swapOriginalSlotY = -1;
}
function InitSwapOtherSlots() {
	local int i;

	for ( i = 0; i < ArrayCount( VM_swapOthers ); i++ ) {
		VM_swapOtherSlotXs[i] = -1;
		VM_swapOtherSlotYs[i] = -1;
	}
}
function InitSwapOtherCoordinates() {
	local int i;

	for ( i = 0; i < ArrayCount( VM_swapOthers ); i++ ) {
		VM_swapOtherXs[i] = -1;
		VM_swapOtherYs[i] = -1;
	}
}
// Vanilla Matters: Syncs the grid coordinates of these potential swappees with the on screen draw coordinates.
function bool SyncSwapOtherCoordinates() {
	local int i;
	local float relX, relY;

	InitSwapOtherCoordinates();

	for ( i = 0; i < VM_swapOtherCount; i++ ) {
		ConvertCoordinates( winItems, VM_swapOtherSlotXs[i] * invButtonWidth, VM_swapOtherSlotYs[i] * invButtonHeight, self, relX, relY );

		VM_swapOtherXs[i] = relX;
		VM_swapOtherYs[i] = relY;
	}
}

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	PersonaNavBarWindow(winNavBar).btnInventory.SetSensitivity(False);

	EnableButtons();
    //Force an update
    SignalRefresh();

	// Vanilla Matters: Inits swap values.
	InitSwapOriginal();
	InitSwapOtherCoordinates();
	InitSwapOtherSlots();
	ClearSwapOthers();
}

// ---------------------------------------------------------------------
// Tick()
//
// Used to destroy windows that need to be destroyed during 
// MouseButtonReleased calls, which normally causes a CRASH
// ----------------------------------------------------------------------

function Tick(float deltaTime)
{
	if (destroyWindow != None)
	{
		destroyWindow.Destroy();
		bTickEnabled = False;
	}
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	Super.CreateControls();

	CreateTitleWindow(9, 5, InventoryTitleText);
	CreateInfoWindow();
	CreateCreditsWindow();
	CreateObjectBelt();
	CreateButtons();
	CreateItemsWindow();
	CreateNanoKeyRingWindow();
	CreateAmmoWindow();
	CreateInventoryButtons();
	CreateStatusWindow();
}

// ----------------------------------------------------------------------
// CreateStatusWindow()
// ----------------------------------------------------------------------

function CreateStatusWindow()
{
	winStatus = PersonaStatusLineWindow(winClient.NewChild(Class'PersonaStatusLineWindow'));
	winStatus.SetPos(337, 243);
}

// ----------------------------------------------------------------------
// CreateButtons()
// ----------------------------------------------------------------------

function CreateButtons()
{
	local PersonaButtonBarWindow winActionButtons;

	winActionButtons = PersonaButtonBarWindow(winClient.NewChild(Class'PersonaButtonBarWindow'));
	winActionButtons.SetPos(9, 339);
	winActionButtons.SetWidth(267);

	btnChangeAmmo = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnChangeAmmo.SetButtonText(ChangeAmmoButtonLabel);

	btnDrop = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnDrop.SetButtonText(DropButtonLabel);

	btnUse = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnUse.SetButtonText(UseButtonLabel);

	btnEquip = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnEquip.SetButtonText(EquipButtonLabel);
}

// ----------------------------------------------------------------------
// CreateInfoWindow()
// ----------------------------------------------------------------------

function CreateInfoWindow()
{
	winInfo = PersonaInventoryInfoWindow(winClient.NewChild(Class'PersonaInventoryInfoWindow'));
	winInfo.SetPos(337, 17);
	winInfo.SetSize(238, 218);
}

// ----------------------------------------------------------------------
// CreateObjectBelt()
// ----------------------------------------------------------------------

function CreateObjectBelt()
{
	invBelt = PersonaInventoryObjectBelt(NewChild(Class'PersonaInventoryObjectBelt'));
	invBelt.SetWindowAlignments(HALIGN_Right, VALIGN_Bottom, 0, 0);
	invBelt.SetInventoryWindow(Self);
//	invBelt.AskParentForReconfigure();
}

// ----------------------------------------------------------------------
// CreateCreditsWindow()
// ----------------------------------------------------------------------

function CreateCreditsWindow()
{
	winCredits = PersonaInventoryCreditsWindow(winClient.NewChild(Class'PersonaInventoryCreditsWindow'));
	winCredits.SetPos(165, 3);
	winCredits.SetWidth(108);
	winCredits.SetCredits(Player.Credits);
}

// ----------------------------------------------------------------------
// CreateNanoKeyRingWindow()
// ----------------------------------------------------------------------

function CreateNanoKeyRingWindow()
{
	winNanoKeyRing = PersonaItemDetailWindow(winClient.NewChild(Class'PersonaItemDetailWindow'));
	winNanoKeyRing.SetPos(335, 285);
	winNanoKeyRing.SetWidth(121);
	winNanoKeyRing.SetIcon(Class'NanoKeyRing'.Default.LargeIcon);
	winNanoKeyRing.SetItem(player.KeyRing);
	winNanoKeyRing.SetText(NanoKeyRingInfoText);
	winNanoKeyRing.SetTextAlignments(HALIGN_Center, VALIGN_Center);
	winNanoKeyRing.SetCountLabel(NanoKeyRingLabel);
	winNanoKeyRing.SetCount(player.KeyRing.GetKeyCount());
	winNanoKeyRing.SetIconSensitivity(True);
}

// ----------------------------------------------------------------------
// CreateAmmoWindow()
// ----------------------------------------------------------------------

function CreateAmmoWindow()
{
	winAmmo = PersonaItemDetailWindow(winClient.NewChild(Class'PersonaItemDetailWindow'));
	winAmmo.SetPos(456, 285);
	winAmmo.SetWidth(120);
	winAmmo.SetIcon(Class'AmmoShell'.Default.LargeIcon);
	winAmmo.SetIconSize(Class'AmmoShell'.Default.largeIconWidth, Class'AmmoShell'.Default.largeIconHeight);
	winAmmo.SetText(AmmoInfoText);
	winAmmo.SetTextAlignments(HALIGN_Center, VALIGN_Center);
	winAmmo.SetIgnoreCount(True);
	winAmmo.SetIconSensitivity(True);
}

// ----------------------------------------------------------------------
// CreateItemsWindow()
// ----------------------------------------------------------------------

function CreateItemsWindow()
{
	winItems = winClient.NewChild(Class'Window');
	winItems.SetPos(9, 19);
	winItems.SetSize(266, 319);
}

// ----------------------------------------------------------------------
// CreateInventoryButtons()
//
// Loop through all the Inventory items and draw them in our Inventory 
// grid as buttons
//
// As we're doing this, we're going to regenerate the inventory grid
// stored in the player, since it sometimes (very rarely) gets corrupted
// and this is a nice hack to make sure it stays clean should that
// occur.  Ooooooooooo did I say "nice hack"?
// ----------------------------------------------------------------------

function CreateInventoryButtons()
{
	local Inventory anItem;
	local PersonaInventoryItemButton newButton;

	// First, clear the player's inventory grid.
    // DEUS_EX AMSD Due to not being able to guarantee order of delivery for functions,
    // do NOT clear inventory in multiplayer, else we risk clearing AFTER a lot of the sets
    // below.
    if (player.Level.NetMode == NM_Standalone)	
        player.ClearInventorySlots();

	// Iterate through the inventory items, creating a unique button for each
	anItem = player.Inventory;

	while(anItem != None)
	{
		if (anItem.bDisplayableInv)
		{
			// Create another button
			newButton = PersonaInventoryItemButton(winItems.NewChild(Class'PersonaInventoryItemButton'));
			newButton.SetClientObject(anItem);
			newButton.SetInventoryWindow(Self);

			// If the item has a large icon, use it.  Otherwise just use the 
			// smaller icon that's also shared by the object belt 

			if ( anItem.largeIcon != None )
			{
				newButton.SetIcon(anItem.largeIcon);
				newButton.SetIconSize(anItem.largeIconWidth, anItem.largeIconHeight);
			}
			else
			{
				newButton.SetIcon(anItem.icon);
				newButton.SetIconSize(smallInvWidth, smallInvHeight);
			}

			newButton.SetSize(
				(invButtonWidth  * anItem.invSlotsX) + 1, 
				(invButtonHeight * anItem.invSlotsY) + 1);

			// Okeydokey, update the player's inventory grid with this item.
			player.SetInvSlots(anItem, 1);

			// If this item is currently equipped, notify the button
			if ( anItem == player.inHand )
				newButton.SetEquipped( True );

			// If this inventory item already has a position, use it.
			if (( anItem.invPosX != -1 ) && ( anItem.invPosY != -1 ))
			{
				SetItemButtonPos(newButton, anItem.invPosX, anItem.invPosY);
			}
			else
			{
				// Find a place for it.
				if (player.FindInventorySlot(anItem))
					SetItemButtonPos(newButton, anItem.invPosX, anItem.invPosY);
				else
					newButton.Destroy();		// Shit!
			}
		}

		anItem = anItem.Inventory;
	}	
}

// ----------------------------------------------------------------------
// SetItemButtonPos()
// ----------------------------------------------------------------------

function SetItemButtonPos(PersonaInventoryItemButton moveButton, int slotX, int slotY)
{
	moveButton.dragPosX = slotX;
	moveButton.dragPosY = slotY;

	moveButton.SetPos(
		moveButton.dragPosX * (invButtonWidth), 
		moveButton.dragPosY * (invButtonHeight)
		);
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
	local bool bHandled;
	local Class<DeusExAmmo> ammoClass;

	bHandled = True;

	// First check to see if this is an Ammo button
	if (buttonPressed.IsA('PersonaAmmoDetailButton'))
	{
		if (DeusExWeapon(selectedItem.GetClientObject()) != None)
		{
			// Before doing anything, check to see if this button is already
			// selected.

			if (!PersonaAmmoDetailButton(buttonPressed).bSelected)
			{
				winInfo.SelectAmmoButton(PersonaAmmoDetailButton(buttonPressed));
				ammoClass = LoadAmmo();
				DeusExWeapon(selectedItem.GetClientObject()).UpdateAmmoInfo(winInfo, ammoClass);
				EnableButtons();
			}
		}
	}
	// Check to see if this is the Ammo button
	else if ((buttonPressed.IsA('PersonaItemDetailButton')) && 
	         (PersonaItemDetailButton(buttonPressed).icon == Class'AmmoShell'.Default.LargeIcon))
	{
		SelectInventory(PersonaItemButton(buttonPressed));
		UpdateAmmoDisplay();
	}
	// Now check to see if it's an Inventory button
	else if (buttonPressed.IsA('PersonaItemButton'))
	{
		winStatus.ClearText();
		SelectInventory(PersonaItemButton(buttonPressed));
	}
	// Otherwise must be one of our action buttons
	else
	{
		switch( buttonPressed )
		{
			case btnChangeAmmo:
				WeaponChangeAmmo();
				break;

			case btnEquip:
				EquipSelectedItem();
				break;

			case btnUse:
				UseSelectedItem();
				break;

			case btnDrop:
				DropSelectedItem();
				break;

			default:
				bHandled = False;
				break;
		}
	}

	if ( !bHandled )
		bHandled = Super.ButtonActivated(buttonPressed);

	return bHandled;
}

// ----------------------------------------------------------------------
// ToggleChanged()
// ----------------------------------------------------------------------

event bool ToggleChanged(Window button, bool bNewToggle)
{
	if (button.IsA('HUDObjectSlot') && (bNewToggle))
	{
		if ((selectedSlot != None) && (selectedSlot != HUDObjectSlot(button)))
			selectedSlot.HighlightSelect(False);

		selectedSlot = HUDObjectSlot(button);

		// Only allow to be highlighted if the slot isn't empty
		if (selectedSlot.item != None)
		{
			selectedSlot.HighlightSelect(bNewToggle);
			SelectInventoryItem(selectedSlot.item);
		}
		else
		{
			selectedSlot = None;
		}
	}
	else if (button.IsA('PersonaCheckboxWindow'))
	{
		player.bShowAmmoDescriptions = bNewToggle;
		player.SaveConfig();
		UpdateAmmoDisplay();
	}

	EnableButtons();

	return True;
}

// ----------------------------------------------------------------------
// VirtualKeyPressed()
//
// Called when a key is pressed; provides a virtual key value
// ----------------------------------------------------------------------

event bool VirtualKeyPressed(EInputKey key, bool bRepeat)
{
	local int keyIndex;
	local bool bKeyHandled;

	bKeyHandled = True;

	if ( IsKeyDown( IK_Alt ) || IsKeyDown( IK_Shift ) || IsKeyDown( IK_Ctrl ))
		return False;

	// If a number key was pressed and we have a selected inventory item,
	// then assign the hotkey
	if (( key >= IK_1 ) && ( key <= IK_9 ) && (selectedItem != None) && (Inventory(selectedItem.GetClientObject()) != None))
	{
		invBelt.AssignObjectBeltByKey(Inventory(selectedItem.GetClientObject()), key);
	}
	else
	{
		switch( key ) 
		{	
			// Allow a selected object to be dropped
			// TODO: Use the actual key(s) assigned to drop

			case IK_Backspace:
				DropSelectedItem();
				break;

			case IK_Delete:
				ClearSelectedSlot();
				break;

			case IK_Enter:
				UseSelectedItem();
				break;

			default:
				bKeyHandled = False;
		}
	}

	if (!bKeyHandled)
		return Super.VirtualKeyPressed(key, bRepeat);
	else
		return bKeyHandled;
}

// ----------------------------------------------------------------------
// UpdateAmmoDisplay()
//
// Displays a list of ammo inside the info window (when the user clicks
// on the Ammo button)
// ----------------------------------------------------------------------

function UpdateAmmoDisplay()
{
	local Inventory inv;
	local DeusExAmmo ammo;
	local int ammoCount;

	if (!bUpdatingAmmoDisplay)
	{
		bUpdatingAmmoDisplay = True;

		winInfo.Clear();

		winInfo.SetTitle(AmmoTitleLabel);
		winInfo.AddAmmoCheckbox(player.bShowAmmoDescriptions);
		winInfo.AddLine();
		
		inv = Player.Inventory;
		while(inv != None)
		{
			ammo = DeusExAmmo(inv);

			if ((ammo != None) && (ammo.bShowInfo))
			{
				winInfo.AddAmmoInfoWindow(ammo, player.bShowAmmoDescriptions);
				ammoCount++;	
			}

			inv = inv.Inventory;
		}

		if (ammoCount == 0)
		{
			winInfo.Clear();
			winInfo.SetTitle(AmmoTitleLabel);
			winInfo.SetText(NoAmmoLabel);
		}

		bUpdatingAmmoDisplay = False;
	}
}

// ----------------------------------------------------------------------
// SelectInventory()
// ----------------------------------------------------------------------

function SelectInventory(PersonaItemButton buttonPressed)
{
	local Inventory anItem;

	// Don't do extra work.
	if (buttonPressed != None) 
	{
		if (selectedItem != buttonPressed)
		{
			// Deselect current button
			if (selectedItem != None)
				selectedItem.SelectButton(False);

			selectedItem = buttonPressed;

			ClearSpecialHighlights();
			HighlightSpecial(Inventory(selectedItem.GetClientObject()));
			SelectObjectBeltItem(Inventory(selectedItem.GetClientObject()), True);

			selectedItem.SelectButton(True);

			anItem = Inventory(selectedItem.GetClientObject());

			if (anItem != None)
				anItem.UpdateInfo(winInfo);

			EnableButtons();
		}
	}
	else
	{
		if (selectedItem != None)
			PersonaInventoryItemButton(selectedItem).SelectButton(False);

		if (selectedSlot != None)
			selectedSlot.SetToggle(False);

		selectedItem = None;
	}
}

// ----------------------------------------------------------------------
// SelectInventoryItem()
//
// Searches through the inventory items for the item passed in and
// selects it.
// ----------------------------------------------------------------------

function SelectInventoryItem(Inventory item)
{
	local PersonaInventoryItemButton itemButton;
	local Window itemWindow;

	// Special case for NanoKeyRing
	if (item != None)
	{
		if (item.IsA('NanoKeyRing')) 
		{   
			if (winNanoKeyRing != None)
			{
				SelectInventory(winNanoKeyRing.GetItemButton());
			}
		}
		else if (winItems != None)
		{
			// Search through the buttons
			itemWindow = winItems.GetTopChild();
			while(itemWindow != None)
			{
				itemButton = PersonaInventoryItemButton(itemWindow);
				if (itemButton != None)
				{
					if (itemButton.GetClientObject() == item)
					{
						SelectInventory(itemButton);
						break;
					}
				}

				itemWindow = itemWindow.GetLowerSibling();
			}
		}
	}
}

// ----------------------------------------------------------------------
// RefreshInventoryItemButtons()
//
// Refreshes all inventory item buttons.
// ----------------------------------------------------------------------
 
function RefreshInventoryItemButtons()
{
    local Window itemWindow;
    local PersonaInventoryItemButton itemButton;
    local Inventory SelectedInventory;

    if (winItems == None)
        return;

    //record selected item
    if (selectedItem != None)
        SelectedInventory = Inventory(selectedItem.GetClientObject());
    else
        SelectedInventory = None;

    //Delete buttons
    itemWindow = winItems.GetTopChild();

    selecteditem = None;
    while (itemWindow != None)
    {
        itemButton = PersonaInventoryItemButton(itemWindow);
        itemWindow = itemWindow.GetLowerSibling();
        if (itemButton != None)
        {          
            itemButton.Destroy();
        }
    }

    //Create buttons
    CreateInventoryButtons();

    //Select new button version of selected item.
    //We don't use the selectinventoryitem call because the constant
    //item.update(wininfo) calls cause quite a slowdown when any item
    //is selected.  Since we aren't really selecting a different item,
    //we don't need to do that update.
	if (SelectedInventory != None)
	{
        // Search through the buttons
        itemWindow = winItems.GetTopChild();
        while(itemWindow != None)
        {
            itemButton = PersonaInventoryItemButton(itemWindow);
            if (itemButton != None)
            {
                if (itemButton.GetClientObject() == SelectedInventory)
                {
                    selecteditem = itemButton;
                    selectedItem.SelectButton(True);
                    break;
                }
            }
            
            itemWindow = itemWindow.GetLowerSibling();
        }
	}

   // if this does special highlighting, refresh that.
   if (SelectedInventory != None)			   
      HighlightSpecial(SelectedInventory);
}

// ----------------------------------------------------------------------
// SelectObjectBeltItem()
// ----------------------------------------------------------------------

function SelectObjectBeltItem(Inventory item, bool bNewToggle)
{
	invBelt.SelectObject(item, bNewToggle);
}

// ----------------------------------------------------------------------
// UseSelectedItem()
// ----------------------------------------------------------------------

function UseSelectedItem()
{
	local Inventory inv;
	local int numCopies;

	// Vanilla Matters
	local ChargedPickup cpickup;

	inv = Inventory(selectedItem.GetClientObject());

	if (inv != None)
	{
		// If this item was equipped in the inventory screen, 
		// make sure we set inHandPending to None so it's not
		// drawn when we exit the Inventory screen

		if (player.inHandPending == inv)
			player.SetInHandPending(None);

		// If this is a binoculars, then it needs to be equipped
		// before it can be activated
		if (inv.IsA('Binoculars')) 
			player.PutInHand(inv);

		//inv.Activate();

		cpickup = ChargedPickup( inv );

		// Vanilla Matters: Prevents the player from activating two charged pickups of the same type at the same time. Copied from ParseLeftClick().
		if ( cpickup != None ) {
			if ( player.UsingChargedPickup( cpickup.class ) ) {
				// VM: The player is already using a charged pickup, only let them "activate" it if it's the charged pickup being used, which turns it off.
				if ( cpickup.IsActive() ) {
					cpickup.Activate();
				}
				else {
					player.ClientMessage( player.VM_msgChargedPickupAlready );
				}
			}
			else {
				cpickup.Activate();
			}
		}
		else {
			inv.Activate();
		}

		// Check to see if this is a stackable item, and keep track of 
		// the count
		if ((inv.IsA('DeusExPickup')) && (DeusExPickup(inv).bCanHaveMultipleCopies))
			numCopies = DeusExPickup(inv).NumCopies - 1;
		else
			numCopies = 0;

		// Update the object belt
		invBelt.UpdateBeltText(inv);

		// Refresh the info!
		if (numCopies > 0)
			UpdateWinInfo(inv);

		// Vanilla Matters: Updates item info properly.
		inv.UpdateInfo( winInfo );
	}
}

// ----------------------------------------------------------------------
// DropSelectedItem()
// ----------------------------------------------------------------------

function DropSelectedItem()
{
	local Inventory anItem;
	local int numCopies;

	if (selectedItem == None)
		return;

	if (Inventory(selectedItem.GetClientObject()) != None)
	{
		// Now drop it, unless this is the NanoKeyRing
		if (!Inventory(selectedItem.GetClientObject()).IsA('NanoKeyRing'))
		{
			anItem = Inventory(selectedItem.GetClientObject());

			// If this is a DeusExPickup, keep track of the number of copies
			if (anItem.IsA('DeusExPickup'))
				numCopies = DeusExPickup(anItem).NumCopies;

			// First make sure the player can drop it!
			if (player.DropItem(anItem, True))
			{
				// Make damn sure there's nothing pending
            if ((player.inHandPending == anItem) || (player.inHand == anItem))
				   player.SetInHandPending(None);

				// Remove the item, but first check to see if it was stackable
				// and there are more than 1 copies available

				if ( (!anItem.IsA('DeusExPickup')) || 
					 (anItem.IsA('DeusExPickup') && (numCopies <= 1)))
				{
					RemoveSelectedItem();
				}

				// Send status message
				winStatus.AddText(Sprintf(DroppedLabel, anItem.itemName));

				// Update the object belt
				invBelt.UpdateBeltText(anItem);

                //Force an update
                SignalRefresh();
			}
			else
			{
                //DEUS_EX AMSD Don't do this in multiplayer, because the way function repl
                //works, we'll ALWAYS end up here.
                if (player.Level.NetMode == NM_Standalone)				
                    winStatus.AddText(Sprintf(CannotBeDroppedLabel, anItem.itemName));
			}
		}
	}
}

// ----------------------------------------------------------------------
// RemoveSelectedItem()
// ----------------------------------------------------------------------

function RemoveSelectedItem()
{
	local Inventory inv;

	if (selectedItem == None)
		return;

	inv = Inventory(selectedItem.GetClientObject());

	if (inv != None)
	{
		// Destroy the button
		selectedItem.Destroy();
		selectedItem = None;

		// Remove it from the object belt
		invBelt.RemoveObject(inv);

		// Remove it from the inventory screen
		UnequipItemInHand();

		ClearSpecialHighlights();

		SelectInventory(None);

		winInfo.Clear();
		EnableButtons();
	}
}

// ----------------------------------------------------------------------
// WeaponChangeAmmo()
// ----------------------------------------------------------------------

function WeaponChangeAmmo()
{
	local DeusExWeapon aWeapon;

	aWeapon = DeusExWeapon(selectedItem.GetClientObject());

	if ( aWeapon != None )
	{
		aWeapon.CycleAmmo();	

		// Vanilla Matters: Updates weapon info properly.
		aWeapon.UpdateInfo( winInfo );

		// Send status message and update info window
		winStatus.AddText(Sprintf(AmmoLoadedLabel, aWeapon.ammoType.itemName));
		aWeapon.UpdateAmmoInfo(winInfo, Class<DeusExAmmo>(aWeapon.AmmoName));
		winInfo.SetLoaded(aWeapon.AmmoName);

		// Update the object belt
		invBelt.UpdateBeltText(aWeapon);
	}
}

// ----------------------------------------------------------------------
// LoadAmmo()
// ----------------------------------------------------------------------

function Class<DeusExAmmo> LoadAmmo()
{
	local DeusExWeapon aWeapon;
	local Class<DeusExAmmo> ammo;

	aWeapon = DeusExWeapon(selectedItem.GetClientObject());

	if ( aWeapon != None )
	{	
		ammo = Class<DeusExAmmo>(winInfo.GetSelectedAmmo());

		// Only change if this is a different kind of ammo

		if ((ammo != None) && (ammo != aWeapon.AmmoName))
		{
			aWeapon.LoadAmmoClass(ammo);

			// Vanilla Matters: Updates weapon info properly.
			aWeapon.UpdateInfo( winInfo );
			
			// Send status message
			winStatus.AddText(Sprintf(AmmoLoadedLabel, ammo.Default.itemName));

			// Update the object belt
			invBelt.UpdateBeltText(aWeapon);
		}
	}

	return ammo;
}

// ----------------------------------------------------------------------
// EquipSelectedItem()
// ----------------------------------------------------------------------

function EquipSelectedItem()
{
	local Inventory inv;

	// If the object's in-hand, then unequip
	// it.  Otherwise put this object in-hand.

	inv = Inventory(selectedItem.GetClientObject());
	
	if ( inv != None )
	{
		// Make sure the Binoculars aren't activated.
		if ((player.inHand != None) && (player.inHand.IsA('Binoculars')))
			Binoculars(player.inHand).Activate();
		else if ((player.inHandPending != None) && (player.inHandPending.IsA('Binoculars')))
			Binoculars(player.inHandPending).Activate();

		if ((inv == player.inHand) || (inv == player.inHandPending))
		{
			UnequipItemInHand();
		}
		else
		{
			player.PutInHand(inv);
			PersonaInventoryItemButton(selectedItem).SetEquipped(True);
		}

		EnableButtons();
	}
}

// ----------------------------------------------------------------------
// UnequipItemInHand()
// ----------------------------------------------------------------------

function UnequipItemInHand()
{
	if ((PersonaInventoryItemButton(selectedItem) != None) && ((player.inHand != None) || (player.inHandPending != None)))
	{
		player.PutInHand(None);
		player.SetInHandPending(None);

		PersonaInventoryItemButton(selectedItem).SetEquipped(False);
		EnableButtons();
	}
}

// ----------------------------------------------------------------------
// UpdateWinInfo()
// ----------------------------------------------------------------------

function UpdateWinInfo(Inventory inv)
{
	winInfo.Clear();

	if (inv != None)
	{
		winInfo.SetTitle(inv.ItemName);
		winInfo.SetText(inv.Description);
	}
}

// ----------------------------------------------------------------------
// RefreshWindow()
// ----------------------------------------------------------------------

function RefreshWindow(float DeltaTime)
{
    TimeSinceLastUpdate = TimeSinceLastUpdate + DeltaTime;
    if (TimeSinceLastUpdate >= 0.25)
    {
        TimeSinceLastUpdate = 0;
        if (!bDragging)
        {
            RefreshInventoryItemButtons();
            CleanBelt();
        }
    }


    Super.RefreshWindow(DeltaTime);
}
// ----------------------------------------------------------------------
// SignalRefresh()
// ----------------------------------------------------------------------

function SignalRefresh()
{
    //Put it about a quarter of a second back from an update, so that 
    //server has time to propagate.
    TimeSinceLastUpdate = 0;
}

// ----------------------------------------------------------------------
// CleanBelt()
// ----------------------------------------------------------------------

function CleanBelt()
{
    local Inventory CurrentItem;

    invBelt.hudBelt.ClearBelt();
    invBelt.objBelt.ClearBelt();
    invBelt.objBelt.PopulateBelt();
    if (selectedItem != None)    
        SelectObjectBeltItem(Inventory(selectedItem.GetClientObject()), True);
}


// ----------------------------------------------------------------------
// RemoveItem()
//
// Removes this item from the screen.  If this is the selected item, 
// does some additional processing.
// ----------------------------------------------------------------------

function RemoveItem(Inventory item)
{
	local Window itemWindow;

	if (item == None)
		return;

	// Remove it from the object belt
	invBelt.RemoveObject(item);

	if ((selectedItem != None) && (item == selectedItem.GetClientObject()))
	{
		RemoveSelectedItem();
	}
	else
	{	
		// Loop through the PersonaInventoryItemButtons looking for a match
		itemWindow = winItems.GetTopChild();
		while( itemWindow != None )
		{
			if (itemWindow.GetClientObject() == item)
			{
				DeferDestroy(itemWindow);
//				itemWindow.Destroy();
				break;
			}
			
			itemWindow = itemWindow.GetLowerSibling();
		}
	}
}

// ----------------------------------------------------------------------
// DeferDestroy()
// ----------------------------------------------------------------------

function DeferDestroy(Window newDestroyWindow)
{
	destroyWindow = newDestroyWindow;

	if (destroyWindow != None)
		bTickEnabled = True;
}

// ----------------------------------------------------------------------
// InventoryDeleted()
//
// Called when some external force needs to remove an inventory 
// item from the player. For instance, when an item is "used" and it's
// a single-use item, it destroys itself, which will ultimately 
// result in this ItemDeleted() call.
// ----------------------------------------------------------------------

function InventoryDeleted(Inventory item)
{
	if (item != None)
	{
		// Remove the item from the screen
		RemoveItem(item);
	}
}

// ----------------------------------------------------------------------
// ClearSelectedSlot()
// ----------------------------------------------------------------------

function ClearSelectedSlot()
{
	if (selectedSlot == None)
		return;

	// Make sure this isn't the NanoKeyRing
	if ((selectedSlot.item != None) && (!selectedSlot.item.IsA('NanoKeyRing')))
	{
		selectedSlot.SetToggle(False);
		ClearSlotItem(selectedSlot.item);
		selectedSlot = None;

		winInfo.Clear();
		EnableButtons();
	}
}

// ----------------------------------------------------------------------
// ClearSlotItem()
// ----------------------------------------------------------------------

function ClearSlotItem(Inventory item)
{
	invBelt.RemoveObject(item);
}

// ----------------------------------------------------------------------
// EnableButtons()
// ----------------------------------------------------------------------

function EnableButtons()
{
	local Inventory inv;

	// Make sure all the buttons exist!
	if ((btnChangeAmmo == None) || (btnDrop == None) || (btnEquip == None) || (btnUse == None))
		return;

	if ( selectedItem == None )
	{
		btnChangeAmmo.DisableWindow();
		btnDrop.DisableWindow();
		btnEquip.DisableWindow();
		btnUse.DisableWindow();
	}
	else
	{
		btnChangeAmmo.EnableWindow();
		btnEquip.EnableWindow();
		btnUse.EnableWindow();
		btnDrop.EnableWindow();

		inv = Inventory(selectedItem.GetClientObject());

		if (inv != None)
		{
			// Anything can be dropped, except the NanoKeyRing
			btnDrop.EnableWindow();

			if (inv.IsA('WeaponMod'))
			{
				btnChangeAmmo.DisableWindow();
				btnUse.DisableWindow();		
			}
			else if (inv.IsA('NanoKeyRing'))
			{
				btnChangeAmmo.DisableWindow();
				btnDrop.DisableWindow();
				btnEquip.DisableWindow();
				btnUse.DisableWindow();
			}
			// Augmentation Upgrade Cannisters cannot be used
			// on this screen
			else if ( inv.IsA('AugmentationUpgradeCannister') )
			{
				btnUse.DisableWindow();
				btnChangeAmmo.DisableWindow();
			}
			// Ammo can't be used or equipped
			else if ( inv.IsA('Ammo') )
			{
				btnUse.DisableWindow();
				btnEquip.DisableWindow();
			}
			else 
			{
				if ((inv == player.inHand ) || (inv == player.inHandPending))
					btnEquip.SetButtonText(UnequipButtonLabel);
				else
					btnEquip.SetButtonText(EquipButtonLabel);
			}

			// If this is a weapon, check to see if this item has more than 
			// one type of ammo in the player's inventory that can be
			// equipped.  If so, enable the "AMMO" button.
			if ( inv.IsA('DeusExWeapon') )
			{
				btnUse.DisableWindow();

				if ( DeusExWeapon(inv).NumAmmoTypesAvailable() < 2 )
					btnChangeAmmo.DisableWindow();
			}
			else
			{
				btnChangeAmmo.DisableWindow();
			}
		}
		else
		{
			btnChangeAmmo.DisableWindow();
			btnDrop.DisableWindow();
			btnEquip.DisableWindow();
			btnUse.DisableWindow();
		}
	}
}

// ----------------------------------------------------------------------
// UpdateDragMouse()
// ----------------------------------------------------------------------

function UpdateDragMouse(float newX, float newY)
{
	local Window findWin;
	local Float relX, relY;
	local Int slotX, slotY;
	local PersonaInventoryItemButton invButton;
	local HUDObjectSlot objSlot;
	local Bool bValidDrop;
	local Bool bOverrideButtonColor;

	// Vanilla Matters
	local Inventory buttonInv;
	local int i;

	// Vanilla Matters: Saves mouse position for later use.
	VM_mouseX = newX;
	VM_mouseY = newY;

	// Vanilla Matters: Resets swapping indicators.
	for ( i = 0; i < VM_swapOtherCount; i++ ) {
		VM_swapOthers[i].ResetFill();
	}

	VM_bSwapping = false;

	findWin = FindWindow(newX, newY, relX, relY);

	// If we're dragging an inventory button, behave one way, if we're
	// dragging a hotkey button, behave another

	if (dragButton.IsA('PersonaInventoryItemButton'))
	{
		// Vanilla Matters: Gets the inventory item of this button for swapping checks.
		buttonInv = Inventory( dragButton.GetClientObject() );

		invButton = PersonaInventoryItemButton(dragButton);

		// If we're over the Inventory Items window, check to see 
		// if there's enough space to deposit this item here.

		bValidDrop = False;
		bOverrideButtonColor = False;

		// if ((findWin == winItems) || (findWin == dragButton ))
		// {
		// 	if ( findWin == dragButton )
		// 		ConvertCoordinates(Self, newX, newY, winItems, relX, relY);

		// 	bValidDrop = CalculateItemPosition(
		// 		Inventory(dragButton.GetClientObject()), 
		// 		relX, relY, 
		// 		slotX, slotY);

		// 	// If the mouse is still in the window, don't actually hide the 
		// 	// button just yet.

		// 	if (bValidDrop && (player.IsEmptyItemSlot(Inventory(invButton.GetClientObject()), slotX, slotY)))
		// 		SetItemButtonPos(invButton, slotX, slotY);
		// }

		// Check to see if we're over the Object Belt
		//else if (HUDObjectSlot(findWin) != None)
		// Vanilla Matters: We're gonna cut the mess above to do our own indicator handling.
		if ( HUDObjectSlot( findWin ) != None )
		{
			bValidDrop = True;

			if (HUDObjectSlot(findWin).item != None)
				if (HUDObjectSlot(findWin).item.IsA('NanoKeyRing'))
					bValidDrop = False;

			HUDObjectSlot(findWin).SetDropFill(bValidDrop);
		}

		// Check to see if we're over another inventory item
		else if (PersonaInventoryItemButton(findWin) != None)
		{
			// If we're dragging a weapon mod and we're over a weapon, check to 
			// see if the mod can be dropped here.  
			//
			// Otherwise this is a bad drop location

			PersonaInventoryItemButton(findWin).SetDropFill(False);

			// Check for weapon mods being dragged over weapons
			if ((dragButton.GetClientObject().IsA('WeaponMod')) && (findWin.GetClientObject().IsA('DeusExWeapon')))
			{
				if (WeaponMod(invButton.GetClientObject()).CanUpgradeWeapon(DeusExWeapon(findWin.GetClientObject())))
				{
					bValidDrop = True;
					PersonaInventoryItemButton(findWin).SetDropFill(True);
					invButton.bValidSlot = False;
					invButton.bDimIcon   = False;
					bOverrideButtonColor = True;

					invButton.ResetFill();
				}
			}

			// Check for ammo being dragged over weapons
			else if ((dragButton.GetClientObject().IsA('DeusExAmmo')) && (findWin.GetClientObject().IsA('DeusExWeapon')))
			{
				if (DeusExWeapon(findWin.GetClientObject()).CanLoadAmmoType(DeusExAmmo(dragButton.GetClientObject())))
				{
					bValidDrop = True;
					PersonaInventoryItemButton(findWin).SetDropFill(True);
					invButton.bValidSlot = False;
					invButton.bDimIcon   = False;
					bOverrideButtonColor = True;

					invButton.ResetFill();
				}
			}
		}

		// Vanilla Matters: Gathers all item buttons in the drop area so check for swapping capabilities. We're only gonna do this if the item hasn't found a suitable drop place yet.
		if ( !bValidDrop ) {
			// VM: Converts the coordinates from mouse location to grid position. This is where the dragged item will land.
			ConvertCoordinates( self, VM_mouseX, VM_mouseY, winItems, relX, relY );
			bValidDrop = CalculateItemPosition( buttonInv, relX, relY, slotX, slotY );

			// VM: Only checks if the mouse has moved over to a new slot.
			if ( bValidDrop && ( slotX != VM_lastMouseSlotX || slotY != VM_lastMouseSlotY ) ) {
				// VM: Fills the list with all item buttons under the mouse, excluding the dragged item or any duplicate.
				PopulateSwapOthers( buttonInv, slotX, slotY );

				// VM: Performs this check everytime the player moves to a new slot, incase there's at least one position in a big item where a swap is possible.
				VM_bValidSwap = CheckSwapOtherSlots();

				if ( VM_bValidSwap ) {
					// VM: Syncs draw coordinates for swappees.
					SyncSwapOtherCoordinates();

					// VM: Saves the grid position since it's valid.
					VM_swapOriginalSlotX = slotX;
					VM_swapOriginalSlotY = slotY;
				}
			}

			VM_bSwapping = VM_bValidSwap;

			// VM: Fills the draw coordinates of all swapOthers (to draw the yellow indicator), also saves the grid position of swapOriginal, if a swap is possible, also makes the item to be swapped glows green.
			if ( VM_bSwapping ) {
				bOverrideButtonColor = true;
				invButton.ResetFill();
				invButton.bDimIcon = false;

				// VM: Makes swappees glow green.
				for ( i = 0; i < VM_swapOtherCount; i++ ) {
					VM_swapOthers[i].SetDropFill( true );
				}
			}

			// VM: This handles vanilla behaviours of dropping on an empty slot. 
			if ( ( bValidDrop && slotX >= 0 && slotY >= 0 ) && player.IsEmptyItemSlot( buttonInv, slotX, slotY ) ) {
				SetItemButtonPos( invButton, slotX, slotY );
			}
			// VM: ValidDrop was conveniently used to check if the conversion to grid slot is clear, so we're gonna make it consistent again with the current state (bad drop).
			else {
				bValidDrop = false;
			}

			// VM: Calculates draw coordinates for the item being dragged, by converting it from grid coordinates.
			ConvertCoordinates( winItems, FClamp( slotX, 0, player.maxInvCols - Inventory( VM_swapOriginal.GetClientObject() ).invSlotsX ) * invButtonWidth, FClamp( slotY, 0, player.maxInvRows - Inventory( VM_swapOriginal.GetClientObject() ).invSlotsY ) * invButtonHeight, self, relX, relY );

			VM_swapOriginalX = relX;
			VM_swapOriginalY = relY;
		}

		if (!bOverrideButtonColor)
		{
			invButton.SetDropFill(bValidDrop);
			invButton.bDimIcon = !bValidDrop;

			if (HUDObjectSlot(findWin) != None)
				invButton.bValidSlot = False;
			else
				invButton.bValidSlot = bValidDrop;
		}
	}
	else
	{
		// This is an Object Belt item we're dragging

		objSlot = HUDObjectSlot(dragButton);
		bValidDrop = False;

		// Can only be dragged over another object slot
		if (findWin.IsA('HUDObjectSlot'))
		{
			if (HUDObjectSlot(findWin).item != None) 
			{
				if (!HUDObjectSlot(findWin).item.IsA('NanoKeyRing'))
				{
					bValidDrop = True;
				}
			}
			else
			{
				bValidDrop = True;
			}

			HUDObjectSlot(findWin).SetDropFill(bValidDrop);
		}
		
		objSlot.bDimIcon = !bValidDrop;
	}

	// Unhighlight the previous window we were over	
	if ((lastDragOverButton != None) && (lastDragOverButton != findWin))
	{
		if (lastDragOverButton.IsA('HUDObjectSlot'))
		{
			HUDObjectSlot(lastDragOverButton).ResetFill();
		}
		else if (lastDragOverButton.IsA('PersonaInventoryItemButton'))
		{
			PersonaInventoryItemButton(lastDragOverButton).ResetFill();
		}
	}	
		
	// Keep track of the last button window we were over
	lastDragOverButton = ButtonWindow(findWin);	
	lastDragOverWindow = findWin;
}

// Vanilla Matters: We're gonna do our custom DrawWindow here incase we need to draw swap indicators.
event DrawWindow( GC gc ) {
	local int i;

	Super.DrawWindow( gc );

	gc.SetStyle( DSTY_Translucent );
	// VM: Draws swapping indicators.
	if ( VM_bSwapping ) {
		gc.SetTileColor( VM_swapOriginal.colDropGood );
		gc.DrawPattern( VM_swapOriginalX + 1, VM_swapOriginalY + 1, VM_swapOriginal.width - 2, VM_swapOriginal.height - 2, 0, 0, VM_swapOriginal.fillTexture );

		// VM: Draws the yellow indicators.
		gc.SetTileColor( VM_colSwap );

		for ( i = 0; i < VM_swapOtherCount; i++ ) {
			gc.DrawPattern( VM_swapOtherXs[i] + 1, VM_swapOtherYs[i] + 1, VM_swapOthers[i].width - 2, VM_swapOthers[i].height - 2, 0, 0, VM_swapOthers[i].fillTexture );
			gc.SetStyle( DSTY_Masked );
			gc.DrawTexture( VM_swapOtherXs[i] + ( ( VM_swapOthers[i].width / 2 ) - ( VM_swapOthers[i].iconPosWidth / 2 ) ), VM_swapOtherYs[i] + ( ( VM_swapOthers[i].height / 2 ) - ( VM_swapOthers[i].iconPosHeight / 2 ) ), VM_swapOthers[i].iconPosWidth, VM_swapOthers[i].iconPosHeight, 0, 0, VM_swapOthers[i].icon );
			gc.SetStyle( DSTY_Translucent );
		}
	}
	// VM: Draws bad location indicator.
	else if ( bDragging && !VM_swapOriginal.bValidSlot && VM_swapOriginal.fillMode == VM_swapOriginal.FillModes.FM_DropBad ) {
		gc.SetTileColor( VM_swapOriginal.colDropBad );
		gc.DrawPattern( VM_swapOriginalX + 1, VM_swapOriginalY + 1, VM_swapOriginal.width - 2, VM_swapOriginal.height - 2, 0, 0, VM_swapOriginal.fillTexture );
	}
}

// ----------------------------------------------------------------------
// CalculateItemPosition()
//
// Calculates exactly where this item belongs in the window based on 
// the position passed in (relative to "winItems") and the inventory 
// item.  
//
// Returns TRUE if this is a valid drop slot (not out of bounds)
// ----------------------------------------------------------------------

function bool CalculateItemPosition(
	Inventory item, 
	float pointX, 
	float pointY, 
	out int slotX, 
	out int slotY)
{
	local int invWidth;
	local int invHeight;
	local int adjustX;
	local int adjustY;
	local bool bResult;

	// Vanilla Matters: Fixes some accessed none.
	if ( item == None ) {
		return false;
	}

	bResult = True;

	// First get the width and height of the inventory icon
	invWidth  = item.largeIconWidth;
	invHeight = item.largeIconHeight;

	// Calculate the first square that represents where this object is
	adjustX = 0;
	adjustY = 0;

	if (invWidth > invButtonWidth)
		adjustX = ((invWidth/2) - (invButtonWidth / 2));

	if (invWidth > invButtonwidth)
		adjustY = ((invHeight/2) - (invButtonHeight /2));

	// Check to see if we're outside the range of where the 
	// slots are located.
	if ((pointX - adjustX) > (invButtonWidth  * player.maxInvCols))
	{
		slotX = player.maxInvCols - 1;
		if (slotX < 0)
			slotX = 0;

		bResult = False;
	}
	else
	{
		slotX = (pointX - adjustX) / invButtonWidth;

		if (slotX < 0)
			slotX = 0;
	}

	if ((pointY - adjustY) > (invButtonHeight * player.maxInvRows))
	{
		slotY = player.maxInvRows - 1;
		bResult = False;
	}
	else
	{
		slotY = (pointY - adjustY) / invButtonHeight;
	}

	return bResult;
}

// ----------------------------------------------------------------------
// StartButtonDrag()
// ----------------------------------------------------------------------

function StartButtonDrag(ButtonWindow newDragButton)
{
	// Show the object belt
	dragButton = newDragButton;

	ClearSpecialHighlights();

	if (dragButton.IsA('PersonaInventoryItemButton'))
	{
		SelectInventory(None);

		// Clear the space used by this button in the grid so we can
		// still place the button here. 
		player.SetInvSlots(Inventory(dragButton.GetClientObject()), 0);

		// Vanilla Matters: Makes this the original swap button.
		VM_swapOriginal = PersonaInventoryItemButton( dragButton );
		VM_bSwapping = false;
		VM_bValidSwap = false;
		VM_lastMouseSlotX = -1;
		VM_lastMouseSlotY = -1;
	}
	else
	{
		// Make sure no hud icon is selected
		if (selectedSlot != None)
			selectedSlot.SetToggle(False);
	}

    SignalRefresh();
	bDragging  = True;
}

// ----------------------------------------------------------------------
// FinishButtonDrag()
// ----------------------------------------------------------------------

function FinishButtonDrag()
{
	local int beltSlot;
	local Inventory dragInv;
	local PersonaInventoryItemButton dragTarget;
	local HUDObjectSlot itemSlot;

	// Vanilla Matters
	local Inventory otherInv;
	local PersonaInventoryItemButton invButton;
	local int i;

	// Take a look at the last window we were over to determine
	// what to do now.  If we were over the Inventory Items window,
	// then move the item to a new slot.  If we were over the Object belt,
	// then assign this item to the appropriate key

	if (dragButton == None)
	{
		EndDragMode();
		return;
	}

	if (dragButton.IsA('PersonaInventoryItemButton'))
	{	
		// Vanilla Matters: Gets our inventory button.
		invButton = PersonaInventoryItemButton( dragButton );

		dragInv    = Inventory(dragButton.GetClientObject());
		dragTarget = PersonaInventoryItemButton(lastDragOverButton);

		// Check if this is a weapon mod and we landed on a weapon
		if ( (dragInv.IsA('WeaponMod')) && (dragTarget != None) && (dragTarget.GetClientObject().IsA('DeusExWeapon')) )
		{
			if (WeaponMod(dragInv).CanUpgradeWeapon(DeusExWeapon(dragTarget.GetClientObject())))
			{
				// 0.  Unhighlight highlighted weapons
				// 1.  Apply the weapon upgrade
				// 2.  Remove from Object Belt
				// 3.  Destroy the upgrade (will cause button to be destroyed)
				// 4.  Highlight the weapon.

				WeaponMod(dragInv).ApplyMod(DeusExWeapon(dragTarget.GetClientObject()));
				
            Player.RemoveObjectFromBelt(dragInv);
            //invBelt.objBelt.RemoveObjectFromBelt(dragInv);

				// Send status message
				winStatus.AddText(Sprintf(WeaponUpgradedLabel, DeusExWeapon(dragTarget.GetClientObject()).itemName));

            //DEUS_EX AMSD done here for multiplayer propagation.
            WeaponMod(draginv).DestroyMod();
				//player.DeleteInventory(dragInv);

				dragButton = None;
				SelectInventory(dragTarget);
			}
			else
			{
				// move back to original spot
				ReturnButton(PersonaInventoryItemButton(dragButton));
			}
		}

		// Check if this is ammo and we landed on a weapon
		else if ((dragInv.IsA('DeusExAmmo')) && (dragTarget != None) && (dragTarget.GetClientObject().IsA('DeusExWeapon')) )
		{
			if (DeusExWeapon(dragTarget.GetClientObject()).CanLoadAmmoType(DeusExAmmo(dragInv)))
			{
				// Load this ammo into the weapon
				DeusExWeapon(dragTarget.GetClientObject()).LoadAmmoType(DeusExAmmo(dragInv));

				// Send status message
				winStatus.AddText(Sprintf(AmmoLoadedLabel, DeusExAmmo(dragInv).itemName));

				// move back to original spot
				ReturnButton(PersonaInventoryItemButton(dragButton));
			}
		}
		else
		{	
			// if (dragTarget == dragButton)
			// {
			// 	MoveItemButton(PersonaInventoryItemButton(dragButton), PersonaInventoryItemButton(dragButton).dragPosX, PersonaInventoryItemButton(dragButton).dragPosY );
			// }
			// else if ( HUDObjectSlot(lastDragOverButton) != None )
			// Vanilla Matters: We're gonna handle the above by ourselves.
			if ( HUDObjectSlot( lastDragOverButton ) != None )
			{
				beltSlot = HUDObjectSlot(lastDragOverButton).objectNum;

				// Don't allow to be moved over NanoKeyRing
				if (beltSlot > 0)
				{
					invBelt.AddObject(dragInv, beltSlot);
				}

				// Restore item to original slot
				ReturnButton(PersonaInventoryItemButton(dragButton));
			}
			// else if (lastDragOverButton != dragButton)
			// {
			// 	//move back to original spot
			// 	ReturnButton(PersonaInventoryItemButton(dragButton));
			// }
			// Vanilla Matters: We don't need this check anymore since we're gonna handle it ourselves.
		}

		// Vanilla Matters: Swaps the items if possible, otherwise resorts to vanilla behaviors.
		if ( dragButton != None ) {
			if ( VM_bSwapping ) {
				// VM: Moves one by one to their respective location.
				for ( i = 0; i < VM_swapOtherCount; i++ ) {
					MoveItemButton( VM_swapOthers[i], VM_swapOtherSlotXs[i], VM_swapOtherSlotYs[i] );
				}

				// VM: Moves the dragged item.
				MoveItemButton( invButton, VM_swapOriginalSlotX, VM_swapOriginalSlotY );

				// VM: MoveItemButton does a SetInvSlots to 0 (clears slots), clearing the previous location (now for the new swapped ones) of the dragged item, we're gonna fill it back.
				for ( i = 0; i < VM_swapOtherCount; i++ ) {
					otherInv = Inventory( VM_swapOthers[i].GetClientObject() );

					player.SetInvSlots( otherInv, 0 );
					player.PlaceItemInSlot( otherInv, otherInv.invPosX, otherInv.invPosY );
				}
			}
			// VM: The reason we move this down here is because the swapping should take a higher priority, in case of a bad position set which would result in two items in the same slot.
			else if ( dragTarget == dragButton ) {
				MoveItemButton( invButton, invButton.dragPosX, invButton.dragPosY );
			}
			else {
				ReturnButton( invButton );
			}

			InitSwapOriginal();
			InitSwapOtherCoordinates();
			InitSwapOtherSlots();
			ClearSwapOthers();
			VM_bSwapping = false;
			VM_bValidSwap = false;
		}
	}
	else		// 'ObjectSlot'
	{
		// Check to see if this is a valid drop location (which are only 
		// other object slots).
		//
		// Swap the two items and select the one that was dragged
		// but make sure the target isn't the NanoKeyRing

		itemSlot = HUDObjectSlot(lastDragOverButton);

		if (itemSlot != None) 
		{
			if (((itemSlot.Item != None) && (!itemSlot.Item.IsA('NanoKeyRing'))) || (itemSlot.Item == None))
			{
				invBelt.SwapObjects(HUDObjectSlot(dragButton), itemSlot);
				itemSlot.SetToggle(True);
			}
		}
		else
		{
			// If the player drags the item outside the object belt, 
			// then remove it.

			ClearSlotItem(HUDObjectSlot(dragButton).item);
		}
	}

    EndDragMode();
}

// Vanilla Matters: Fills the array with item buttons in the potential space occupied of an item.
function PopulateSwapOthers( Inventory item, int slotX, int slotY ) {
	local Window win;
	local int x, y;
	local float relX, relY;

	VM_lastMouseSlotX = slotX;
	VM_lastMouseSlotY = slotY;

	ClearSwapOthers();

	for ( y = 0; y < item.invSlotsY; y++ ) {
		for ( x = 0; x < item.invSlotsX; x++ ) {
			// VM: The + 1 is to fix a weird problem with FindWindow, sometime it can return a window way lower than our search area (lower means closer to the top left).
			win = winItems.FindWindow( ( ( slotX + x ) * invButtonWidth ) + 1, ( ( slotY + y ) * invButtonHeight ) + 1, relX, relY );

			if ( win != None && win.IsA( 'PersonaInventoryItemButton' ) && Inventory( win.GetClientObject() ) != item ) {
				AddSwapOther( PersonaInventoryItemButton( win ) );
			}

			// VM: Clears it just for sure.
			win = None;
		}
	}

	SortsBySpace();
}

// Vanilla Matters: Function to check if all of the swap slots are valid.
function bool CheckSwapOtherSlots() {
	local Inventory otherInv, originalInv;
	local int i, slotXMouse, slotYMouse, slotX, slotY, slotXAnchor, slotYAnchor, spillX, spillY, saveXs[15], saveYs[15];
	local float relX, relY;
	local bool bValid;

	// VM: Just returns false straight out if the list is empty.
	if ( VM_swapOthers[0] == None || VM_swapOtherCount <= 0 ) {
		return false;
	}

	bValid = true;

	// VM: Saves the grid coordinates since we're gonna do some intricate stuff.
	for ( i = 0; i < VM_swapOtherCount; i++ ) {
		otherInv = Inventory( VM_swapOthers[i].GetClientObject() );

		saveXs[i] = otherInv.invPosX;
		saveYs[i] = otherInv.invPosY;

		player.SetInvSlots( otherInv, 0 );
	}

	originalInv = Inventory( VM_swapOriginal.GetClientObject() );

	// VM: Grabs a slot from mouse coordinates. This is where the dragged item will land. We're also aborting the check if we can't convert the coordinates to any inventory slot.
	ConvertCoordinates( self, VM_mouseX, VM_mouseY, winItems, relX, relY );
	bValid = CalculateItemPosition( originalInv, relX, relY, slotXMouse, slotYMouse );

	// VM: Grabs the first potential item to be swapped from the list.
	otherInv = Inventory( VM_swapOthers[0].GetClientObject() );

	// VM: Here's how we decide where to swap to, first, we have to take an "anchor", this thing will be the basis of where all the swapOther items go.
	// VM: If the original swap item is closer to the top left than the first potential swappee (swapOther), we take that as our anchor.
	if ( otherInv.invPosX > originalInv.invPosX ) {
		slotXAnchor = FMin( player.maxInvCols - otherInv.invSlotsX, FMin( originalInv.invPosX, otherInv.invPosX ) );
	}
	// VM: If not, then we either take the first swappee's location, or a distance from the grid limit so that the item can still fit in properly.
	else {
		slotXAnchor = FMin( player.maxInvCols - otherInv.invSlotsX, FMax( originalInv.invPosX, otherInv.invPosX ) );
	}
	if ( otherInv.invPosY > originalInv.invPosY ) {
		slotYAnchor = FMin( player.maxInvRows - otherInv.invSlotsY, FMin( originalInv.invPosY, otherInv.invPosY ) );
	}
	else {
		slotYAnchor = FMin( player.maxInvRows - otherInv.invSlotsY, FMax( originalInv.invPosY, otherInv.invPosY ) );
	}

	slotXAnchor = FMax( slotXAnchor, 0 );
	slotYAnchor = FMax( slotYAnchor, 0 );

	// VM: Main check for swappees (swapOthers).
	for ( i = 0; i < VM_swapOtherCount; i++ ) {
		otherInv = Inventory( VM_swapOthers[i].GetClientObject() );

		// VM: All swappees start at anchor position.
		slotX = slotXAnchor;
		slotY = slotYAnchor;

		// VM: Resets spills, these are how we fit the items into the area.
		spillX = 0;
		spillY = 0;
		// VM: Here we'll check if the item can fit into the anchored area, and also if the dragged item can still fit into all that.
		while ( bValid ) {
			// VM: Removes the item from the inventory grid (not on screen) to simulate available space.
			player.SetInvSlots( otherInv, 0 );

			// VM: If it fits into the slot, actually places the item there, so that we can simulate potential occupation.
			if ( player.IsEmptyItemSlot( otherInv, slotX, slotY ) ) {
				player.PlaceItemInSlot( otherInv, slotX, slotY );

				// VM: Since we're trying to build an accurate simulation of the resulting swap, we'll check for the mouse drop everytime we place an item down.
				if ( player.IsEmptyItemSlot( originalInv, slotXMouse, slotYMouse ) ) {
					// VM: Saves valid slots and breaks out of loop.
					VM_swapOtherSlotXs[i] = slotX;
					VM_swapOtherSlotYs[i] = slotY;
					break;
				}
			}

			// VM: We're here if we either have a bad anchor, or the swappee is identified to take up a slot it's not supposed to. So we have to deal with it through spilling.
			// VM: Spilling means we're moving the item slot by slot in the anchored area until either it fits or we deem it's invalid and abort.
			if ( spillX < originalInv.invSlotsX ) {
				// VM: We'll spill by column first, and only move it to the end of the area bound to the right.
				spillX = spillX + 1;
				slotX = slotXAnchor + spillX;
			}
			else if ( spillY < originalInv.invSlotsY ) {
				// VM: We've hit the end of the right, but haven't hit the bottom bound, so we're move the item one row down, to the start of that row and keep moving.
				spillX = 0;
				slotX = slotXAnchor + spillX;
				spillY = spillY + 1;
				slotY = slotYAnchor + spillY;
			}
			else {
				// VM: We've moved to the end of the of designated area, still no suitable slot, time to abort.
				bValid = false;
			}
		}
	}

	// VM: Cleans stuff up, sets the items back to its original places.
	for ( i = 0; i < VM_swapOtherCount; i++ ) {
		otherInv = Inventory( VM_swapOthers[i].GetClientObject() );

		player.SetInvSlots( otherInv, 0 );
		player.PlaceItemInSlot( otherInv, saveXs[i], saveYs[i] );
	}

	return bValid;
}

// Vanilla Matters: Sorts the swapOthers list by space occupied from highest to lowest.
function SortsBySpace() {
	local int i, j;
	local PersonaInventoryItemButton tempButton;
	local Inventory invA, invB;

	for ( i = 0; i < VM_swapOtherCount - 1; i++ ) {
		for ( j = 0; j < VM_swapOtherCount - 1 - i; j++ ) {
			invA = Inventory( VM_swapOthers[j].GetClientObject() );
			invB = Inventory( VM_swapOthers[j + 1].GetClientObject() );

			if ( ( invA.invSlotsX * invA.invSlotsY ) < ( invB.invSlotsX * invB.invSlotsY ) ) {
				tempButton = VM_swapOthers[j];
				VM_swapOthers[j] = VM_swapOthers[j + 1];
				VM_swapOthers[j + 1] = tempButton;
			}
		}
	}
}

// ----------------------------------------------------------------------
// EndDragMode()
// ----------------------------------------------------------------------

function EndDragMode()
{
	// Make sure the last inventory item dragged over isn't still highlighted
	if (lastDragOverButton != None)
	{
		if (lastDragOverButton.IsA('PersonaInventoryItemButton'))
			PersonaInventoryItemButton(lastDragOverButton).ResetFill();
		else
			HUDObjectSlot(lastDragOverButton).ResetFill();

		lastDragOverButton = None;
	}

	bDragging = False;

	// Select the item
	if (dragButton != None)
	{
		if (dragButton.IsA('PersonaInventoryItemButton'))
			SelectInventory(PersonaInventoryItemButton(dragButton));
		else if (dragButton.IsA('ToggleWindow'))
			ToggleWindow(dragButton).SetToggle(True);

		dragButton = None;
	}
    
    SignalRefresh();
}

// ----------------------------------------------------------------------
// MoveItemButton()
// ----------------------------------------------------------------------

function MoveItemButton(PersonaInventoryItemButton anItemButton, int col, int row)
{
	player.SetInvSlots(Inventory(anItemButton.GetClientObject()), 0);
	player.PlaceItemInSlot(Inventory(anItemButton.GetClientObject()), col, row );
	SetItemButtonPos(anItemButton, col, row);
    //Set it to refresh again
    SignalRefresh();
}

// ----------------------------------------------------------------------
// ReturnButton()
// ----------------------------------------------------------------------

function ReturnButton(PersonaInventoryItemButton anItemButton)
{
	local Inventory inv;

	inv = Inventory(anItemButton.GetClientObject());

	player.PlaceItemInSlot(inv, inv.invPosX, inv.invPosY);
	SetItemButtonPos(anItemButton, inv.invPosX, inv.invPosY);
}

// ----------------------------------------------------------------------
// HighlightSpecial()
// ----------------------------------------------------------------------

function HighlightSpecial(Inventory item)
{
	if (item != None)
	{
		if (item.IsA('WeaponMod'))
			HighlightModWeapons(WeaponMod(item));
		else if (item.IsA('DeusExAmmo'))
			HighlightAmmoWeapons(DeusExAmmo(item));
	}
}

// ----------------------------------------------------------------------
// HighlightModWeapons()
// 
// Highlights/Unhighlights any weapons that can be upgraded with the 
// weapon mod passed in
// ----------------------------------------------------------------------

function HighlightModWeapons(WeaponMod weaponMod)
{
	local Window itemWindow;
	local PersonaInventoryItemButton itemButton;
	local Inventory anItem;

	// Loop through all our children and check to see if 
	// we have a match.

	itemWindow = winItems.GetTopChild();
	while( itemWindow != None )
	{
		itemButton = PersonaInventoryItemButton(itemWindow);
		if (itemButton != None)
		{
			anItem = Inventory(itemButton.GetClientObject());
			if ((anItem != None) && (anItem.IsA('DeusExWeapon')))
			{
				if ((weaponMod != None) && (weaponMod.CanUpgradeWeapon(DeusExWeapon(anItem))))
				{
					itemButton.HighlightWeapon(True);
				}
			}
			else
			{
				itemButton.ResetFill();
			}
		}	
		itemWindow = itemWindow.GetLowerSibling();
	}
}

// ----------------------------------------------------------------------
// HighlightAmmoWeapons()
// 
// Highlights/Unhighlights any weapons that can be used with the 
// selected ammo
// ----------------------------------------------------------------------

function HighlightAmmoWeapons(DeusExAmmo ammo)
{
	local Window itemWindow;
	local PersonaInventoryItemButton itemButton;
	local Inventory anItem;

	// Loop through all our children and check to see if 
	// we have a match.

	itemWindow = winItems.GetTopChild();
	while( itemWindow != None )
	{
		itemButton = PersonaInventoryItemButton(itemWindow);
		if (itemButton != None)
		{
			anItem = Inventory(itemButton.GetClientObject());
			if ((anItem != None) && (anItem.IsA('DeusExWeapon')))
			{
				if ((ammo != None) && (DeusExWeapon(anItem).CanLoadAmmoType(ammo)))
				{
					itemButton.HighlightWeapon(True);
				}
			}
			else
			{
				itemButton.ResetFill();
			}
		}	
		itemWindow = itemWindow.GetLowerSibling();
	}
}

// ----------------------------------------------------------------------
// ClearSpecialHighlights()
// ----------------------------------------------------------------------

function ClearSpecialHighlights()
{
	local Window itemWindow;
	local PersonaInventoryItemButton itemButton;
	local Inventory anItem;

	// Loop through all our children and check to see if 
	// we have a match.

	itemWindow = winItems.GetTopChild();
	while( itemWindow != None )
	{
		itemButton = PersonaInventoryItemButton(itemWindow);
		if (itemButton != None)
		{
			itemButton.ResetFill();
		}

		itemWindow = itemWindow.GetLowerSibling();
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     invButtonWidth=53
     invButtonHeight=53
     smallInvWidth=40
     smallInvHeight=35
     InventoryTitleText="Inventory"
     EquipButtonLabel="|&Equip"
     UnequipButtonLabel="Un|&equip"
     UseButtonLabel="|&Use"
     DropButtonLabel="|&Drop"
     ChangeAmmoButtonLabel="Change Amm|&o"
     NanoKeyRingInfoText="Click icon to see a list of Nano Keys."
     NanoKeyRingLabel="Keys: %s"
     DroppedLabel="%s dropped"
     AmmoLoadedLabel="%s loaded"
     WeaponUpgradedLabel="%s upgraded"
     CannotBeDroppedLabel="%s cannot be dropped here"
     AmmoInfoText="Click icon to see a list of Ammo."
     AmmoTitleLabel="Ammunition"
     NoAmmoLabel="No Ammo Available"
     VM_colSwap=(R=80,G=80,B=32)
     clientBorderOffsetY=33
     ClientWidth=585
     ClientHeight=361
     clientOffsetX=33
     clientOffsetY=10
     clientTextures(0)=Texture'DeusExUI.UserInterface.InventoryBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.InventoryBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.InventoryBackground_3'
     clientTextures(3)=Texture'DeusExUI.UserInterface.InventoryBackground_4'
     clientTextures(4)=Texture'DeusExUI.UserInterface.InventoryBackground_5'
     clientTextures(5)=Texture'DeusExUI.UserInterface.InventoryBackground_6'
     clientBorderTextures(0)=Texture'DeusExUI.UserInterface.InventoryBorder_1'
     clientBorderTextures(1)=Texture'DeusExUI.UserInterface.InventoryBorder_2'
     clientBorderTextures(2)=Texture'DeusExUI.UserInterface.InventoryBorder_3'
     clientBorderTextures(3)=Texture'DeusExUI.UserInterface.InventoryBorder_4'
     clientBorderTextures(4)=Texture'DeusExUI.UserInterface.InventoryBorder_5'
     clientBorderTextures(5)=Texture'DeusExUI.UserInterface.InventoryBorder_6'
     clientTextureRows=2
     clientTextureCols=3
     clientBorderTextureRows=2
     clientBorderTextureCols=3
}
