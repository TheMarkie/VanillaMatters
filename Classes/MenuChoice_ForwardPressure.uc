//=============================================================================
// MenuChoice_ForwardPressure
//=============================================================================

class MenuChoice_ForwardPressure extends MenuChoice_EnabledDisabled;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting() {
	SetValue( int( !player.VM_bEnableFP ) );
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting() {
	player.VM_bEnableFP = !bool( GetValue() );
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault() {
	SetValue( int( !player.Default.VM_bEnableFP ) );
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     HelpText="If enabled, the game will use the Forward Pressure save mechanics. Default: On."
     actionText="|&Forward Pressure"
}
