class VMSkill extends VMUpgrade
    abstract;

//==============================================
// Properties
//==============================================
var() array<int> Costs;
var() array<UpgradeValue> GlobalValues;
var() array<UpgradeCategory> CategoryValues;

//==============================================
// General info
//==============================================
static function int GetMaxLevel() {
    return #default.Costs;
}

//==============================================
// Skill values
//==============================================
static function UpdateValues( TableFloat table, int oldLevel, int newLevel ) {
    local int i, count, valueCount;
    local UpgradeValue skillValue;
    local float value;

    if ( table == none || oldLevel == newLevel ) {
        return;
    }

    count = #default.GlobalValues;
    for ( i = 0; i < count; i++ ) {
        skillValue = default.GlobalValues[i];
        valueCount = #skillValue.Values;

        table.TryGetValue( skillValue.Name, value );
        if ( oldLevel >= 0 ) {
            value -= skillValue.Values[Min( oldLevel, valueCount - 1 )];
        }
        if ( newLevel >= 0 ) {
            value += skillValue.Values[Min( newLevel, valueCount - 1 )];
        }

        table.Set( skillValue.Name, value );
    }
}

static function UpdateCategoryValues( TableTableFloat categories, int oldLevel, int newLevel );

defaultproperties
{
}
