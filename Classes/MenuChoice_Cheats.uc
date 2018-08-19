//=============================================================================
// MenuChoice_Cheats
//=============================================================================

class MenuChoice_Cheats extends MenuChoice_EnabledDisabled;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting() {
	SetValue( int( !player.VM_bCheatsEnabled ) );
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting() {
	player.VM_bCheatsEnabled = !bool( GetValue() );
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault() {
	SetValue( int( !player.Default.VM_bCheatsEnabled ) );
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     HelpText="If enabled, allows you to use various console commands. Default: Off."
     actionText="|&Cheats"
}
