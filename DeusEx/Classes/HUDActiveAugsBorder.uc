//=============================================================================
// HUDActiveAugsBorder
//=============================================================================

class HUDActiveAugsBorder extends HUDActiveItemsBorderBase;

// Vanilla Matters
function AddIcon( Texture newIcon, Object saveObject ) {
    local HUDActiveAug augItem;

    augItem = HUDActiveAug( winIcons.NewChild( Class'HUDActiveAug' ) );
    augItem.SetIcon( newIcon );
    augItem.SetClientObject( saveObject );
    augItem.Info = VMAugmentationInfo( saveObject );
    augItem.Show();

    // Hide if there are no icons visible
    if ( ++iconCount == 1 ) {
        Show();
    }

    AskParentForReconfigure();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
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
