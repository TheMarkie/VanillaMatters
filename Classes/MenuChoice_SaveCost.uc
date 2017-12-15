//=============================================================================
// MenuChoice_SaveCost
//=============================================================================

class MenuChoice_SaveCost extends MenuChoice_EnabledDisabled;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting() {
	SetValue( int( !player.VM_bSaveCost ) );
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting() {
	player.VM_bSaveCost = !bool( GetValue() );
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault() {
	SetValue( int( !player.Default.VM_bSaveCost ) );
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     HelpText="If enabled, saving costs 100 credits. JOKE OPTION. Default: Off.|nIf FP is also enabled, costs from 0 to 200 based on missing pressure."
     actionText="|&Save Cost"
}
