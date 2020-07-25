class VMSkillManager extends VMUpgradeManager;

//==============================================
// Strings
//==============================================
var() localized string LevelNames[4];

//==============================================
// Data
//==============================================
var travel TableFloat GlobalValues;
var travel TableTableFloat CategoryValues;
var travel VMSkillInfo FirstSkillInfo;

//==============================================
// General info
//==============================================
static function string GetLevelName( int level, int maxLevel ) {
    return default.LevelNames[3 - maxLevel + level];
}

//==============================================
// Management
//==============================================
function Initialize() {
    GlobalValues = new class'TableFloat';
    CategoryValues = new class'TableTableFloat';
}

function Reset() {
    local VMSkillInfo info;

    GlobalValues.Clear();
    CategoryValues.Clear();

    info = FirstSkillInfo;
    while ( info != none ) {
        info.Level = 0;
        info.RefreshValues( GlobalValues, CategoryValues );

        info = info.Next;
    }
}

function bool Add( name name, optional int startingLevel ) {
    local VMSkillInfo info;

    info = new class'VMSkillInfo';
    info.DefinitionClassName = name;
    info.Level = startingLevel;
    info.Next = FirstSkillInfo;
    FirstSkillInfo = info;

    info.RefreshValues( GlobalValues, CategoryValues );

    return true;
}

function RefreshValues() {
    local VMSkillInfo info;

    GlobalValues.Clear();
    CategoryValues.Clear();

    info = FirstSkillInfo;
    while ( info != none ) {
        info.RefreshValues( GlobalValues, CategoryValues );

        info = info.Next;
    }
}

//==============================================
// Skill Management
//==============================================
function VMSkillInfo GetSkillInfo( name name ) {
    local VMSkillInfo info;

    info = FirstSkillInfo;
    while ( info != none ) {
        if ( info.DefinitionClassName == name ) {
            break;
        }

        info = info.Next;
    }

    return info;
}

function bool IncreaseLevel( VMSkillInfo info ) {
    if ( info.IncreaseLevel() ) {
        info.UpdateValues( GlobalValues, CategoryValues, info.Level - 1, info.Level );

        return true;
    }

    return false;
}
function bool DecreaseLevel( VMSkillInfo info ) {
    if ( info.DecreaseLevel() ) {
        info.UpdateValues( GlobalValues, CategoryValues, info.Level + 1, info.Level );

        return true;
    }

    return false;
}

function IncreaseAllToMax() {
    local VMSkillInfo info;

    GlobalValues.Clear();
    CategoryValues.Clear();

    info = FirstSkillInfo;
    while ( info != none ) {
        info.Level = info.GetMaxLevel();
        info.RefreshValues( GlobalValues, CategoryValues );

        info = info.Next;
    }
}

//==============================================
// Skill values
//==============================================
function float GetValue( name name, optional float defaultValue ) {
    local float value;

    if ( GlobalValues.TryGetValue( name, value ) ) {
        return value;
    }

    return defaultValue;
}

function float GetCategoryValue( name category, name name, optional float defaultValue ) {
    local float value;
    local TableFloat table;

    if ( CategoryValues.TryGetValue( category, table ) ) {
        if ( table.TryGetValue( name, value ) ) {
            return value;
        }
    }

    return defaultValue;
}

function int GetLevel( name name ) {
    local VMSkillInfo info;

    info = GetSkillInfo( name );
    if ( info != none ) {
        return info.Level;
    }

    return -1;
}

defaultproperties
{
     LevelNames(0)="UNTRAINED"
     LevelNames(1)="TRAINED"
     LevelNames(2)="ADVANCED"
     LevelNames(3)="MASTER"
}
