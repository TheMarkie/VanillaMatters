//=============================================================================
// MenuChoice_AutoSave
//=============================================================================

class MenuChoice_AutoSave extends MenuChoice_EnabledDisabled;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting() {
    SetValue( int( !player.IsFeatureEnabled( 'AutoSave' ) ) );
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting() {
    player.SetFeatureEnabled( 'AutoSave', !bool( GetValue() ) );
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault() {
    SetValue( int( !player.IsFeatureEnabledByDefault( 'AutoSave' ) ) );
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     HelpText="If enabled, the game will automatically save at the start of levels and after objective completion. Default: On."
     actionText="|&Auto Save"
}
