//=============================================================================
// MenuChoice_FOV
//=============================================================================

class MenuChoice_FOV extends MenuUIChoiceSlider;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting() {
    saveValue = player.DefaultFOV;
    SetValue( FClamp( player.DefaultFOV, startValue, endValue ) );
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting() {
    if ( player.DefaultFOV == player.DesiredFOV ) {
        player.SetDesiredFOV( GetValue() );
    }
    else {
        player.DefaultFOV = GetValue();

        player.ConsoleCommand( "set " $ configSetting $ " " $ GetValue() );
    }
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
    local int fov;
    local int enumIndex;

    enumIndex = 0;
    for( fov = 75; fov <= 110; fov++ ) {
        SetEnumeration( enumIndex++, string( fov ) );
    }
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     numTicks=36
     startValue=75.000000
     endValue=110.000000
     defaultValue=85.000000
     HelpText="Affects both horizontal and vertical Field of View. Default: 85."
     actionText="|&Field of View"
     configSetting="PlayerPawn DefaultFOV"
}
