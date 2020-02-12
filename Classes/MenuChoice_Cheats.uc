//=============================================================================
// MenuChoice_Cheats
//=============================================================================

class MenuChoice_Cheats extends MenuChoice_EnabledDisabled;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting() {
    SetValue( int( !player.IsFeatureEnabled( 'Cheats' ) ) );
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting() {
    player.SetFeatureEnabled( 'Cheats', !bool( GetValue() ) );
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault() {
    SetValue( int( !player.IsFeatureEnabledByDefault( 'Cheats' ) ) );
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     HelpText="If enabled, allows you to use various console commands. Default: Off."
     actionText="|&Cheats"
}
