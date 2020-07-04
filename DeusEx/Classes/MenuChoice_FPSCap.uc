//=============================================================================
// MenuChoice_FPSCap
//=============================================================================

class MenuChoice_FPSCap extends MenuUIChoiceSlider;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting() {
    saveValue = int( player.ConsoleCommand( "GetFPSCap" ) );
    SetValue( saveValue );
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting() {
    player.ConsoleCommand( "FPSCap" @ GetValue() );
}

// ----------------------------------------------------------------------
// ResetToDefault()
// ----------------------------------------------------------------------

function ResetToDefault() {
    SetValue( defaultValue );
}

// ----------------------------------------------------------------------
// SetEnumerators()
// ----------------------------------------------------------------------

function SetEnumerators() {
    local int fps;
    local int enumIndex;

    enumIndex = 0;
    for( fps = 0; fps <= 120; fps = fps + 10 ) {
        SetEnumeration( enumIndex++, string( fps ) );
    }
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     numTicks=13
     endValue=120.000000
     defaultValue=120.000000
     HelpText="FPS limit. This is not related to VSync. Default: 120."
     actionText="|&FPS Cap"
}
