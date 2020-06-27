//=============================================================================
// MenuChoice_CombatDifficulty
//=============================================================================

class MenuChoice_CombatDifficulty extends MenuUIChoiceSlider;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting() {
    btnSlider.winSlider.SetTickPosition( ( FClamp( player.CombatDifficulty, startValue, endValue ) / 0.5 ) - 1 );
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting() {
    player.CombatDifficulty = ( btnSlider.winSlider.GetTickPosition() + 1 ) * 0.5;
}

// ----------------------------------------------------------------------
// ResetToDefault()
// ----------------------------------------------------------------------

function ResetToDefault() {
    SetValue( player.CombatDifficulty );
}

// ----------------------------------------------------------------------
// SetEnumerators()
// ----------------------------------------------------------------------

function SetEnumerators() {
    local float difficulty;
    local int enumIndex;

    for( difficulty = 0.5; difficulty <= 5.0; difficulty += 0.5 ) {
        SetEnumeration( enumIndex++, Left( String( difficulty ), Instr( String( difficulty ), "." ) + 2 ) );
    }
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     numTicks=10
     startValue=0.500000
     endValue=5.000000
     defaultValue=1.000000
     HelpText="Combat difficulty of the game. Affects damage received and AI detection.|nNormal = 1; Hard = 2; Realistic = 4. Save-dependent."
     actionText="Combat |&Difficulty"
}
