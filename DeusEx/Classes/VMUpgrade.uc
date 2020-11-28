class VMUpgrade extends Object
    abstract;

struct UpgradeValue {
    var() name Name;
    var() array<float> Values;
};

struct UpgradeCategory {
    var() name Name;
    var() array<UpgradeValue> Values;
};

//==============================================
// Description
//==============================================
var() localized string UpgradeName;
var() localized string Description;
var() Texture Icon;

//==============================================
// Properties
//==============================================
var() array<UpgradeValue> GlobalValues;
var() array<UpgradeCategory> CategoryValues;

// UpgradeValue array support
native(3200) static final function int UpgradeValueArrayCount( array<UpgradeValue> A );
static final preoperator int #( out array<UpgradeValue> A ) { return UpgradeValueArrayCount( A ); }

// UpgradeCategory array support
native(3200) static final function int UpgradeCategoryArrayCount( array<UpgradeCategory> A );
static final preoperator int #( out array<UpgradeCategory> A ) { return UpgradeCategoryArrayCount( A ); }

//==============================================
// General info
//==============================================
static function int GetMaxLevel() { return 0; }

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

        globalTable.TryGetValue( valueData.Name, value );
        if ( oldLevel >= 0 ) {
            value -= valueData.Values[Min( oldLevel, valueCount - 1 )];
        }
        if ( newLevel >= 0 ) {
            value += valueData.Values[Min( newLevel, valueCount - 1 )];
        }

        globalTable.Set( valueData.Name, value );
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

            categoryTable.TryGetValue( valueData.Name, value );
            if ( oldLevel >= 0 ) {
                value -= valueData.Values[Min( oldLevel, valueCount - 1 )];
            }
            if ( newLevel >= 0 ) {
                value += valueData.Values[Min( newLevel, valueCount - 1 )];
            }

            categoryTable.Set( valueData.Name, value );
        }
    }
}

defaultproperties
{
}
