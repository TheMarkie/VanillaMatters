//=============================================================================
// MenuChoice_Cheats
//=============================================================================

class MenuChoice_Cheats extends MenuChoice_EnabledDisabled;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting() {
	SetValue( int( !player.bCheatsEnabled ) );
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting() {
	player.bCheatsEnabled = !bool( GetValue() );
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault() {
	SetValue( int( !player.Default.bCheatsEnabled ) );
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     HelpText="If enabled, allows you to use various console commands. Default: Off."
     actionText="|&Cheats"
}
