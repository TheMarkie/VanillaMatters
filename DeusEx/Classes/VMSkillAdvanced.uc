class VMSkillAdvanced extends VMSkill
    abstract;

//==============================================
// Properties
//==============================================
var() array<UpgradeCategory> CategoryValues;

//==============================================
// Skill values
//==============================================
static function UpdateCategoryValues( TableTableFloat categories, int oldLevel, int newLevel ) {
    local int i, j, categoryCount, count, valueCount;
    local float value;
    local UpgradeCategory category;
    local UpgradeValue skillValue;
    local TableFloat categoryTable;

    if ( categories == none || oldLevel == newLevel ) {
        return;
    }

    categoryCount = #default.CategoryValues;
    for ( i = 0; i < categoryCount; i++ ) {
        category = default.CategoryValues[i];

        if ( !categories.TryGetValue( category.Name, categoryTable ) ) {
            categoryTable = new class'TableFloat';
        }
        count = #category.Values;
        for ( j = 0; j < count; j++ ) {
            skillValue = category.Values[j];
            valueCount = #skillValue.Values;

            categoryTable.TryGetValue( skillValue.Name, value );
            if ( oldLevel >= 0 ) {
                value -= skillValue.Values[Min( oldLevel, valueCount - 1 )];
            }
            if ( newLevel >= 0 ) {
                value += skillValue.Values[Min( newLevel, valueCount - 1 )];
            }

            categoryTable.Set( skillValue.Name, value );
        }

        categories.Set( category.Name, categoryTable );
    }
}

defaultproperties
{
}
