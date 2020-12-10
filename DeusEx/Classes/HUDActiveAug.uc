//=============================================================================
// HUDActiveAug
//=============================================================================

class HUDActiveAug extends HUDActiveItemBase;

var Color ColorEnabled;
var Color ColorDisabled;

var VMAugmentationInfo Info;

event DrawWindow( GC gc ) {
    local Color col;

    if ( Info != none ) {
        if ( Info.IsActive ) {
            col = ColorEnabled;
        }
        else {
            col = colItemIcon;
        }

        gc.SetStyle( iconDrawStyle );
        gc.SetTileColor( col );
        gc.DrawTexture( 2, 2, 32, 32, 0, 0, icon );
    }
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     ColorEnabled=(R=0,G=255,B=0)
     ColorDisabled=(R=255,G=0,B=0)
}
