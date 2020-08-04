//=============================================================================
// HUDActiveAugsBorder
//=============================================================================

class HUDActiveAugsBorder extends HUDActiveItemsBorderBase;

var int FirstKeyNum;
var int LastKeyNum;

// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

event InitWindow()
{
    Super.InitWindow();

    // Create *ALL* the icons, but hide them.
    CreateIcons();
}

// ----------------------------------------------------------------------
// CreateIcons()
// ----------------------------------------------------------------------

function CreateIcons()
{
    local int keyIndex;
    local HUDActiveAug iconWindow;

    for(keyIndex=FirstKeyNum; keyIndex<=LastKeyNum; keyIndex++)
    {
        iconWindow = HUDActiveAug(winIcons.NewChild(Class'HUDActiveAug'));
        iconWindow.SetKeyNum(keyIndex);
        iconWindow.Hide();
    }
}

// ----------------------------------------------------------------------
// ClearAugmentationDisplay()
// ----------------------------------------------------------------------

function ClearAugmentationDisplay()
{
    local Window currentWindow;
    local Window foundWindow;

    // Loop through all our children and check to see if
    // we have a match.

    currentWindow = winIcons.GetTopChild();
    while(currentWindow != None)
    {
        currentWindow.Hide();
      currentWindow.SetClientObject(None);
        currentWindow = currentWindow.GetLowerSibling();
    }

    iconCount = 0;
}

// ----------------------------------------------------------------------
// AddIcon()
//
// Find the appropriate
// ----------------------------------------------------------------------
// Vanilla Matters
function AddIcon( Texture newIcon, Object saveObject ) {
    local HUDActiveAug augItem;

    augItem = FindAugWindow( VMAugmentationInfo( saveObject ) );
    if ( augItem != none ) {
        augItem.SetIcon( newIcon );
        augItem.SetClientObject( saveObject );
        augItem.SetObject( saveObject );
        augItem.Show();

        // Hide if there are no icons visible
        if ( ++iconCount == 1 ) {
            Show();
        }

        AskParentForReconfigure();
    }
}

// ----------------------------------------------------------------------
// RemoveObject()
// ----------------------------------------------------------------------

function RemoveObject( Object removeObject ) {
    local HUDActiveAug augItemWindow;

    augItemWindow = FindAugWindow( VMAugmentationInfo( removeObject ) );
    if ( augItemWindow != none ) {
        augItemWindow.Hide();
        augItemWindow.SetClientObject( none );

        // Hide if there are no icons visible
        if ( --iconCount == 0 ) {
            Hide();
        }

        AskParentForReconfigure();
    }
}

// ----------------------------------------------------------------------
// FindAugWindowByKey()
// ----------------------------------------------------------------------
// Vanilla Matters
function HUDActiveAug FindAugWindow( VMAugmentationInfo info ) {
    local Window currentWindow;

    // Loop through all our children and check to see if
    // we have a match.

    currentWindow = winIcons.GetTopChild( false );
    while( currentWindow != none ) {
        if ( HUDActiveAug( currentWindow ).DefinitionClassName == anAug.DefinitionClassName ) {
            break;
        }

        currentWindow = currentWindow.GetLowerSibling( false );
    }

    return HUDActiveAug( currentWindow );
}

// ----------------------------------------------------------------------
// UpdateAugIconStatus()
// ----------------------------------------------------------------------
// No longer used.

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     LastKeyNum=10
     texBorderTop=Texture'DeusExUI.UserInterface.HUDAugmentationsBorder_Top'
     texBorderCenter=Texture'DeusExUI.UserInterface.HUDAugmentationsBorder_Center'
     texBorderBottom=Texture'DeusExUI.UserInterface.HUDAugmentationsBorder_Bottom'
     borderTopMargin=13
     borderBottomMargin=9
     borderWidth=62
     topHeight=37
     topOffset=26
     bottomHeight=32
     bottomOffset=28
     tilePosX=20
     tilePosY=13
}
