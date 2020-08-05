//=============================================================================
// PersonaAugmentationBarSlot
//=============================================================================
class PersonaAugmentationBarSlot expands ToggleWindow;

#exec TEXTURE IMPORT FILE="Textures\AugBarSlot.bmp"     NAME="AugBarSlot"       GROUP="VMUI" MIPS=Off

var DeusExPlayer player;

var int slot;
var VMAugmentationInfo aug;

var Color colSlotNum;
var Color colOutline;
var Color colIconActive;
var Color colIconNormal;
var Color fillColor;
var Color colDropGood;
var Color colDropBad;
var Color colNone;
var Color colSelected;
var Color colSelectionBorder;
var int slotFillWidth;
var int slotFillHeight;
var int borderX;
var int borderY;
var int borderWidth;
var int borderHeight;

var bool draggable;
var bool dragStart;
var bool dragging;
var bool dimIcon;
var bool validSlot;
var int  dragStartX;
var int  dragStartY;

var PersonaScreenAugmentations augWnd;

var Texture Icon;

enum FillModes {
    FM_Selected,
    FM_DropGood,
    FM_DropBad,
    FM_None
};

var FillModes fillMode;

var Texture slotTexture;
var int slotIconX;
var int slotIconY;
var int slotNumberX;
var int slotNumberY;

var EDrawStyle backgroundDrawStyle;
var Texture texBackground;
var Color colBackground;

var Texture texBorders[9];

// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

function InitWindow() {
    super.InitWindow();

    slot = -1;
    aug = none;

    SetSelectability( false );

    SetSize( 51, 54 );
    SetFont( Font'FontTiny' );

    player = DeusExPlayer( GetRootWindow().parentPawn );

    StyleChanged();
}

// ----------------------------------------------------------------------
// ToggleChanged()
// ----------------------------------------------------------------------

function bool ToggleChanged( Window button, bool bNewToggle ) {
    if ( aug == none && bNewToggle ) {
        SetToggle( false );

        return true;
    }

    return false;
}

// ----------------------------------------------------------------------
// SetSlot()
// ----------------------------------------------------------------------

function SetSlot( int pos ) {
    slot = pos;
}

// ----------------------------------------------------------------------
// SetAug()
// ----------------------------------------------------------------------

function SetAug( VMAugmentationInfo newAug ) {
    if ( newAug != None ) {
        Icon = newAug.GetSmallIcon();
    }
    else {
        HighlightSelect( false );
        SetToggle( false );
    }

    aug = newAug;
}

// ----------------------------------------------------------------------
// GetItem()
// ----------------------------------------------------------------------

function name GetAugName() {
    if ( aug != none ) {
        return aug.DefinitionClassName;
    }

    return '';
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

function DrawWindow( GC gc ) {
    DrawSlotBackground( gc );

    if ( fillMode != FM_None ) {
        SetFillColor();
        gc.SetStyle( DSTY_Translucent );
        gc.SetTileColor( fillColor );
        gc.DrawPattern( borderX + 1, borderY + 1, slotFillWidth, slotFillHeight, 0, 0, Texture'Solid' );
    }

    if ( aug != none && Icon != none && !dragging ) {
        DrawSlotIcon( gc );

        gc.SetAlignments( HALIGN_Center, VALIGN_Center );
        gc.EnableWordWrap( false );
        gc.SetTextColor( colSlotNum );

        if ( bButtonPressed ) {
            gc.SetTileColor( colSelectionBorder );
            gc.SetStyle( DSTY_Masked );
            gc.DrawBorders( borderX, borderY, borderWidth, borderHeight, 0, 0, 0, 0, texBorders );
        }
    }

    gc.SetAlignments( HALIGN_Right, VALIGN_Center );
    gc.SetTextColor( colSlotNum );
    gc.DrawText( slotNumberX - 1, slotNumberY, 6, 7, slot );
}

function DrawSlotIcon( GC gc ) {
    gc.SetStyle( DSTY_Translucent );

    if ( aug.IsActive ) {
        gc.SetTileColor( colIconActive );
    }
    else {
        gc.SetTileColor( colIconNormal );
    }

    gc.DrawTexture( slotIconX, slotIconY, slotFillWidth, slotFillHeight, 0, 0, Icon );
}

function DrawSlotBackground( GC gc ) {
    local Color newBackground;

    gc.SetStyle( backgroundDrawStyle );
    gc.SetTileColor( colBackground );
    gc.DrawTexture( 0, 0, width, height, 0, 0, texBackground );
}

// ----------------------------------------------------------------------
// SetDropFill()
// ----------------------------------------------------------------------

function SetDropFill( bool bGoodDrop ) {
    if ( bGoodDrop ) {
        fillMode = FM_DropGood;
    }
    else {
        fillMode = FM_DropBad;
    }
}

// ----------------------------------------------------------------------
// ResetFill()
// ----------------------------------------------------------------------

function ResetFill() {
    fillMode = FM_None;
}

// ----------------------------------------------------------------------
// HighlightSelect()
// ----------------------------------------------------------------------

function HighlightSelect( bool bHighlight ) {
    if ( bHighlight ) {
        fillMode = FM_Selected;
    }
    else {
        fillMode = FM_None;
    }
}

// ----------------------------------------------------------------------
// SetFillColor()
// ----------------------------------------------------------------------

function SetFillColor() {
    switch( fillMode ) {
        case FM_Selected:
            fillColor = colSelected;
            break;
        case FM_DropBad:
            fillColor = colDropBad;
            break;
        case FM_DropGood:
            fillColor = colDropGood;
            break;
        case FM_None:
            fillColor = colNone;
            break;
    }
}

// ----------------------------------------------------------------------
// MouseButtonPressed()
// ----------------------------------------------------------------------

function bool MouseButtonPressed( float pointX, float pointY, EInputKey button, int numClicks ) {
    if ( button == IK_LeftMouse ) {
        dragStart = true;
        dragStartX = pointX;
        dragStartY = pointY;

        return true;
    }

    return false;
}

// ----------------------------------------------------------------------
// MouseButtonReleased()
// ----------------------------------------------------------------------

function bool MouseButtonReleased( float pointX, float pointY, EInputKey button, int numClicks ) {
    if ( button == IK_LeftMouse ) {
        FinishButtonDrag();

        return true;
    }

    return false;
}

// ----------------------------------------------------------------------
// MouseMoved()
// ----------------------------------------------------------------------

function MouseMoved( float newX, float newY ) {
    local float invX, invY;

    if ( draggable ) {
        if ( dragStart ) {
            if ( Abs( newX - dragStartX ) > 2 || Abs( newY- dragStartY ) > 2 ) {
                StartButtonDrag();
                SetCursorPos( width / 2, height / 2 );
            }
        }

        if ( dragging ) {
            ConvertCoordinates( self, newX, newY, augWnd, invX, invY );

            augWnd.UpdateDragMouse( invX, invY );
        }
    }
}

// ----------------------------------------------------------------------
// CursorRequested()
// ----------------------------------------------------------------------

function Texture CursorRequested( window win, float pointX, float pointY, out float hotX, out float hotY, out color newColor, out Texture shadowTexture ) {
    shadowTexture = None;

    if ( dragging ) {
        if ( dimIcon ) {
            newColor.R = 64;
            newColor.G = 64;
            newColor.B = 64;
        }

        return Icon;
    }

    return none;
}

// ----------------------------------------------------------------------
// StartButtonDrag()
// ----------------------------------------------------------------------

function StartButtonDrag() {
    dragStart = false;
    dragging = true;

    augWnd.StartButtonDrag( self );
}

// ----------------------------------------------------------------------
// FinishButtonDrag()
// ----------------------------------------------------------------------

function FinishButtonDrag() {
    dragStart = false;
    dragging = false;

    augWnd.FinishButtonDrag();
}

// ----------------------------------------------------------------------
// SetAugWnd()
// ----------------------------------------------------------------------

function SetAugWnd( PersonaScreenAugmentations newAugWnd ) {
    augWnd = newAugWnd;
}

// ----------------------------------------------------------------------
// GetIconPos()
// ----------------------------------------------------------------------

function GetIconPos( out int iconPosX, out int iconPosY ) {
    iconPosX = slotIconX;
    iconPosY = slotIconY;
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

function StyleChanged() {
    local ColorTheme theme;

    theme = player.ThemeManager.GetCurrentHUDColorTheme();

    colBackground = theme.GetColorFromName( 'HUDColor_Background' );
    colSlotNum = theme.GetColorFromName( 'HUDColor_NormalText' );

    colSelected.r = int( float( colBackground.r ) * 0.50 );
    colSelected.g = int( float( colBackground.g ) * 0.50 );
    colSelected.b = int( float( colBackground.b ) * 0.50 );

    if ( player.GetHUDBackgroundTranslucency() ) {
        backgroundDrawStyle = DSTY_Translucent;
    }
    else {
        backgroundDrawStyle = DSTY_Masked;
    }
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     colSlotNum=(G=170,B=255)
     colIconActive=(G=255)
     colIconNormal=(R=255,G=255)
     colDropGood=(R=32,G=128,B=32)
     colDropBad=(R=128,G=32,B=32)
     colSelected=(R=60,G=60,B=60)
     colSelectionBorder=(R=255,G=255,B=255)
     slotFillWidth=42
     slotFillHeight=37
     borderY=7
     borderWidth=44
     borderHeight=39
     draggable=True
     fillMode=FM_None
     slotIconX=6
     slotIconY=10
     slotNumberX=38
     slotNumberY=3
     texBackground=Texture'DeusEx.VMUI.AugBarSlot'
     texBorders(0)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_TL'
     texBorders(1)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_TR'
     texBorders(2)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_BL'
     texBorders(3)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_BR'
     texBorders(4)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_Left'
     texBorders(5)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_Right'
     texBorders(6)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_Top'
     texBorders(7)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_Bottom'
     texBorders(8)=Texture'DeusExUI.UserInterface.PersonaItemHighlight_Center'
}
