//=============================================================================
// HUDLightIndicator
//=============================================================================
class HUDLightIndicator expands HUDBaseWindow;

#exec TEXTURE IMPORT FILE="Textures\HUDLightBorder_1.bmp"		NAME="HUDLightBorder_1"			GROUP="VMUI" MIPS=Off
#exec TEXTURE IMPORT FILE="Textures\HUDLightBackground_1.bmp"	NAME="HUDLightBackground_1"		GROUP="VMUI" MIPS=Off

var Texture texBackground;
var Texture texBorder;

// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

function InitWindow() {
	Super.InitWindow();

	Hide();

	player = DeusExPlayer( DeusExRootWindow( GetRootWindow() ).parentPawn );

	SetSize( 87, 41 );
}

// ----------------------------------------------------------------------
// DrawBackground()
// ----------------------------------------------------------------------

function DrawBackground( GC gc ) {
	local float vis;
	local color col;

	vis = FMin( player.AIVisibility() * 10, 1 );

	col = GetColorScaled( FMax( 1 - vis, 0.01 ) );

	gc.SetStyle( DSTY_Translucent );
	gc.SetTileColor( col );
	gc.DrawTexture( 5, 6, 80, 24, 0, 0, texBackground );
}

// ----------------------------------------------------------------------
// DrawBorder()
// ----------------------------------------------------------------------

function DrawBorder( GC gc ) {
	if ( bDrawBorder ) {
		gc.SetStyle( borderDrawStyle );
		gc.SetTileColor( colBorder );
		gc.DrawTexture( 0, 0, 87, 41, 0, 0, texBorder );
	}
}

// ----------------------------------------------------------------------
// SetVisibility()
// ----------------------------------------------------------------------

function SetVisibility( bool bNewVisibility ) {
	Show( bNewVisibility );
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     texBackground=Texture'DeusEx.VMUI.HUDLightBackground_1'
     texBorder=Texture'DeusEx.VMUI.HUDLightBorder_1'
}
