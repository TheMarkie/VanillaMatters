//=============================================================================
// VMProgressBarWindow: Custom progress bar that allows custom textures.
//=============================================================================
class VMProgressBarWindow extends ProgressBarWindow;

var Texture texForeground;

event DrawWindow( GC gc ) {
	gc.SetTileColor( colForeground );

	if ( bVertical ) {
		gc.DrawPattern( 0, height - barSize, width, barSize, 0, height - barSize, texForeground );
	}
	else {
		gc.DrawPattern(0, 0, barSize, height, 0, 0, texForeground );
	}
}

function SetForegroundTexture( Texture tex ) {
	texForeground = tex;
}

defaultproperties
{
     texForeground=Texture'Extension.Solid'
}
