//=============================================================================
// PersonaAugmentationItemButton
//=============================================================================
class PersonaAugmentationItemButton extends PersonaItemButton;

var PersonaLevelIconWindow winLevels;
var bool  bActive;
var int   hotkeyNumber;
var Color colIconActive;
var Color colIconNormal;

// Vanilla Matters
var Augmentation VM_aug;

var bool VM_draggable;
var bool VM_dragStart;
var bool VM_dragging;
var bool VM_dimIcon;
var bool VM_validSlot;
var int  VM_dragStartX;
var int  VM_dragStartY;

var PersonaScreenAugmentations VM_augWnd;

var Texture VM_dragIcon;

// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetActive(False);
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{	
	local String str;

	Super.DrawWindow(gc);

	// Draw the hotkey info in lower-left corner
	// if (hotkeyNumber >= 3)
	// {
	// 	str = "F" $ hotkeyNumber;
	// 	gc.SetFont(Font'FontMenuSmall_DS');
	// 	gc.SetAlignments(HALIGN_Left, VALIGN_Top);
	// 	gc.SetTextColor(colHeaderText);
	// 	gc.DrawText(2, iconPosHeight - 9, iconPosWidth - 2, 10, str);
	// }
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	winLevels = PersonaLevelIconWindow(NewChild(Class'PersonaLevelIconWindow'));
	winLevels.SetPos(30, 54);
	winLevels.SetSelected(True);
}

// ----------------------------------------------------------------------
// SetHotkeyNumber()
// ----------------------------------------------------------------------

function SetHotkeyNumber(int num)
{
	hotkeyNumber = num;
}

// ----------------------------------------------------------------------
// SetActive()
// ----------------------------------------------------------------------

function SetActive(bool bNewActive)
{
	bActive = bNewActive;

	if (bActive)
		colIcon = colIconActive;
	else
		colIcon = colIconNormal;
}

// ----------------------------------------------------------------------
// SetLevel()
// ----------------------------------------------------------------------

function SetLevel(int newLevel)
{
	if (winLevels != None)
		winLevels.SetLevel(newLevel);
}

// Vanilla Matters: Add drag and drop support for aug icons.
function bool MouseButtonPressed( float pointX, float pointY, EInputKey button, int numClicks ) {
	if ( button == IK_LeftMouse ) {
		VM_dragStart = true;
		VM_dragStartX = pointX;
		VM_dragStartY = pointY;
		
		return true;
	}
	
	return false;
}

function MouseMoved( float newX, float newY ) {
	local float invX, invY;

	if ( VM_draggable ) {
		if ( VM_dragStart ) {
			if ( Abs( newX - VM_dragStartX ) > 2 || Abs( newY- VM_dragStartY ) > 2 ) {
				StartButtonDrag();
				SetCursorPos( width / 2, height / 2 );
			}
		}

		if ( VM_dragging ) {
			ConvertCoordinates( self, newX, newY, VM_augWnd, invX, invY );

			VM_augWnd.UpdateDragMouse( invX, invY );
		}
	}
}

function bool MouseButtonReleased( float pointX, float pointY, EInputKey button, int numClicks ) {
	if ( button == IK_LeftMouse ) {
		FinishButtonDrag();

		return true;
	}

	return false;
}

function texture CursorRequested( window win, float pointX, float pointY, out float hotX, out float hotY, out color newColor, out Texture shadowTexture ) {
	shadowTexture = None;

	if ( VM_dragging ) {
		if ( VM_dimIcon ) {
			newColor.R = 64;
			newColor.G = 64;
			newColor.B = 64;
		}
		
		return VM_dragIcon;
	}
	
	return none;
}

function StartButtonDrag() {
	VM_dragStart = false;
	VM_dragging = true;

	VM_augWnd.StartButtonDrag( self );
}

function FinishButtonDrag() {
	VM_dragStart = false;
	VM_dragging = false;

	VM_augWnd.FinishButtonDrag();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     colIconActive=(G=255)
     colIconNormal=(R=255,G=255)
	 buttonHeight=59
	 VM_draggable=True
}
