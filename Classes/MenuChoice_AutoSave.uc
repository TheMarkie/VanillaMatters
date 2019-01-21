//=============================================================================
// MenuChoice_AutoSave
//=============================================================================

class MenuChoice_AutoSave extends MenuChoice_EnabledDisabled;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting() {
	SetValue( int( !player.VM_bEnableAS ) );
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting() {
	player.VM_bEnableAS = !bool( GetValue() );
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault() {
	SetValue( int( !player.Default.VM_bEnableAS ) );
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     HelpText="If enabled, the game will automatically save at the start of levels and after objective completion. Default: On."
     actionText="|&Auto Save"
}
