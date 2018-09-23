//=============================================================================
// MenuChoice_CombatDifficulty
//=============================================================================

class MenuChoice_CombatDifficulty extends MenuUIChoiceSlider;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting() {
	saveValue = player.CombatDifficulty;
	SetValue( FClamp( ( player.CombatDifficulty - 1 ) * 2, startValue, endValue ) );
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting() {
	player.CombatDifficulty = ( ( GetValue() + 2 ) / 2 );
}

// ----------------------------------------------------------------------
// ResetToDefault()
// ----------------------------------------------------------------------

function ResetToDefault() {
	SetValue( ( player.CombatDifficulty - 1 ) * 2 );
}

// ----------------------------------------------------------------------
// SetEnumerators()
// ----------------------------------------------------------------------

function SetEnumerators() {
	local float difficulty;
	local int enumIndex;

	enumIndex = 0;
	for( difficulty = 1.0; difficulty <= 5.0; difficulty = difficulty + 0.5 ) {
		SetEnumeration( enumIndex++, Left( String( difficulty ), Instr( String( difficulty ), "." ) + 2 ) );
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     numTicks=9
     startValue=1.000000
     endValue=5.000000
     defaultValue=1.000000
     HelpText="Combat difficulty of the game. Affects damage received and forward pressure rates.|nEasy = 1; Medium = 1.5; Hard = 2; Realistic = 4. Save-dependent."
     actionText="Combat |&Difficulty"
}
