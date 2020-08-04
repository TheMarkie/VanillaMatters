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
function Initialize( VMPlayer player ) {
    super.Initialize( player );

    GlobalValues = new class'TableFloat';
    CategoryValues = new class'TableTableFloat';
}

function bool Add( name name, optional int startingLevel ) {
    local VMSkillInfo info;

    info = new class'VMSkillInfo';
    info.Initialize( name, startingLevel );
    info.RefreshValues( GlobalValues, CategoryValues );

    info.Next = FirstSkillInfo;
    FirstSkillInfo = info;

    return true;
}

function Refresh( VMPlayer player ) {
    local VMSkillInfo info;

    super.Refresh( player );

    GlobalValues.Clear();
    CategoryValues.Clear();

    info = FirstSkillInfo;
    while ( info != none ) {
        info.GetDefinitionClass();
        info.RefreshValues( GlobalValues, CategoryValues );

        info = info.Next;
    }
}

function Reset() {
    local VMSkillInfo info;

    GlobalValues.Clear();
    CategoryValues.Clear();

    info = FirstSkillInfo;
    while ( info != none ) {
        info.Level = 0;
        info.GetDefinitionClass();
        info.RefreshValues( GlobalValues, CategoryValues );

        info = info.Next;
    }
}

//==============================================
// Skill Management
//==============================================
function VMSkillInfo GetInfo( name name ) {
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

function bool IncreaseLevel( name name ) {
    local VMSkillInfo info;

    info = GetInfo( name );
    if ( info != none && info.CanUpgrade( Player.SkillPointsAvail ) ) {
        Player.SkillPointsAvail -= info.GetNextLevelCost();
        info.IncreaseLevel();
        info.UpdateValues( GlobalValues, CategoryValues, info.Level - 1, info.Level );

        return true;
    }

    return false;
}
function bool DecreaseLevel( name name ) {
    local VMSkillInfo info;

    info = GetInfo( name );
    if ( info != none && info.DecreaseLevel() ) {
        Player.SkillPointsAvail += info.GetNextLevelCost();
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
// Values
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

    info = GetInfo( name );
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
