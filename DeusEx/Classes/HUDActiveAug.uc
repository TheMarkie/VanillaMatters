//=============================================================================
// HUDActiveAug
//=============================================================================

class HUDActiveAug extends HUDActiveItemBase;

var Color ColorEnabled;
var Color ColorDisabled;
var Color ColorCooldown;

var VMAugmentationInfo Info;

event DrawWindow( GC gc ) {
    local Color color;
    local float cooldown, w, h;
    local string str;

    if ( Info != none ) {
        cooldown = Info.GetCooldown();
        if ( Info.IsActive ) {
            color = ColorEnabled;
        }
        else if ( cooldown > 0 ) {
            color = ColorDisabled;
        }
        else {
            color = colItemIcon;
        }
        gc.SetStyle( iconDrawStyle );
        gc.SetTileColor( color );
        gc.DrawTexture( 2, 2, 32, 32, 0, 0, icon );

        if ( cooldown > 0 ) {
            str = FormatFloat( cooldown );
            gc.SetFont( Font'FontMenuTitle' );
            gc.SetTextColor( ColorCooldown );
            gc.GetTextExtent( 0, w, h, str );
            gc.DrawText( ( width - w ) / 2, ( height - h ) / 2, w, h, str );
        }
    }
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     ColorEnabled=(R=0,G=255,B=0)
     ColorDisabled=(R=92,G=92,B=92)
     ColorCooldown=(R=255,G=0,B=0)
}
