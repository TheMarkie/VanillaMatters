//=============================================================================
// HUDActiveAugsBorder
//=============================================================================

class HUDActiveAugsBorder extends HUDActiveItemsBorderBase;

var int FirstKeyNum;
var int LastKeyNum;

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

    augItem = HUDActiveAug( winIcons.NewChild( Class'HUDActiveAug' ) );
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
        augItemWindow.Destroy();

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
        if ( currentWindow.GetClientObject() == info ) {
            break;
        }

        currentWindow = currentWindow.GetLowerSibling( false );
    }

    return HUDActiveAug( currentWindow );
}

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
