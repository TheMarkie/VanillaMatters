//=============================================================================
// MenuChoice_ForwardPressure
//=============================================================================

class MenuChoice_ForwardPressure extends MenuChoice_EnabledDisabled;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting() {
    SetValue( int( !player.IsFeatureEnabled( 'ForwardPressure' ) ) );
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting() {
    player.SetFeatureEnabled( 'ForwardPressure', !bool( GetValue() ) );
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault() {
    SetValue( int( !player.IsFeatureEnabledByDefault( 'ForwardPressure' ) ) );
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     HelpText="If enabled, the game will use the Forward Pressure save mechanics. Default: Off."
     actionText="|&Forward Pressure"
}
