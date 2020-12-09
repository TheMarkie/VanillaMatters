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
// Values
//==============================================
static function UpdateValues( VMPlayer player, int oldLevel, int newLevel ) {
    local int i, j, count, categoryCount, valueCount;
    local float value;

    local TableFloat globalTable, categoryTable;
    local TableTableFloat categories;

    local UpgradeCategory category;
    local UpgradeValue valueData;

    if ( oldLevel == newLevel ) {
        return;
    }

    globalTable = player.GlobalModifiers;

    count = #default.GlobalValues;
    for ( i = 0; i < count; i++ ) {
        valueData = default.GlobalValues[i];
        valueCount = #valueData.Values;

        value = 0;
        if ( oldLevel >= 0 ) {
            value -= valueData.Values[Min( oldLevel, valueCount - 1 )];
        }
        if ( newLevel >= 0 ) {
            value += valueData.Values[Min( newLevel, valueCount - 1 )];
        }

        globalTable.Modify( valueData.Name, value );
    }

    categories = player.CategoryModifiers;

    categoryCount = #default.CategoryValues;
    for ( i = 0; i < categoryCount; i++ ) {
        category = default.CategoryValues[i];

        if ( !categories.TryGetValue( category.Name, categoryTable ) ) {
            categoryTable = new class'TableFloat';
            categories.Set( category.Name, categoryTable );
        }

        count = #category.Values;
        for ( j = 0; j < count; j++ ) {
            valueData = category.Values[j];
            valueCount = #valueData.Values;

            value = 0;
            if ( oldLevel >= 0 ) {
                value -= valueData.Values[Min( oldLevel, valueCount - 1 )];
            }
            if ( newLevel >= 0 ) {
                value += valueData.Values[Min( newLevel, valueCount - 1 )];
            }

            categoryTable.Modify( valueData.Name, value );
        }
    }
}

defaultproperties
{
}
