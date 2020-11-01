class VMSkillManager extends VMUpgradeManager;

//==============================================
// Strings
//==============================================
var() localized string LevelNames[4];

//==============================================
// Data
//==============================================
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
function bool Add( name className, name packageName, optional int startingLevel ) {
    local VMSkillInfo info;

    info = new class'VMSkillInfo';
    info.Initialize( className, packageName, startingLevel );
    info.RefreshValues( Player );

    info.Next = FirstSkillInfo;
    FirstSkillInfo = info;

    return true;
}

function Refresh( VMPlayer playerOwner ) {
    local VMSkillInfo info;

    super.Refresh( playerOwner );

    info = FirstSkillInfo;
    while ( info != none ) {
        info.RefreshValues( Player );

        info = info.Next;
    }
}

function Reset() {
    local VMSkillInfo info;

    info = FirstSkillInfo;
    while ( info != none ) {
        info.Level = 0;
        info.RefreshValues( Player );

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
        info.UpdateValues( Player, info.Level - 1, info.Level );

        return true;
    }

    return false;
}
function bool DecreaseLevel( name name ) {
    local VMSkillInfo info;

    info = GetInfo( name );
    if ( info != none && info.DecreaseLevel() ) {
        Player.SkillPointsAvail += info.GetNextLevelCost();
        info.UpdateValues( Player, info.Level + 1, info.Level );

        return true;
    }

    return false;
}

function IncreaseAllToMax() {
    local VMSkillInfo info;

    info = FirstSkillInfo;
    while ( info != none ) {
        info.Level = info.GetMaxLevel();
        info.RefreshValues( Player );

        info = info.Next;
    }
}

//==============================================
// Values
//==============================================
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
