//=============================================================================
// HUDActiveItemsBorder
//=============================================================================

class HUDActiveItemsBorder extends HUDActiveItemsBorderBase;

// Vanilla Matters
function AddIcon( Texture newIcon, Object saveObject ) {
    local HUDActiveItemBase activeItem;

    activeItem = HUDActiveItemBase( winIcons.NewChild( class'HUDActiveItem' ) );
    activeItem.SetIcon( newIcon );
    activeItem.SetClientObject( saveObject );
    activeItem.SetObject( saveObject );

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
     texBorderTop=Texture'DeusExUI.UserInterface.HUDItemsBorder_Top'
     texBorderCenter=Texture'DeusExUI.UserInterface.HUDItemsBorder_Center'
     texBorderBottom=Texture'DeusExUI.UserInterface.HUDItemsBorder_Bottom'
     borderTopMargin=7
     borderBottomMargin=6
     borderWidth=48
     topHeight=36
     topOffset=21
     bottomHeight=30
     bottomOffset=23
     tilePosX=6
     tilePosY=7
}
