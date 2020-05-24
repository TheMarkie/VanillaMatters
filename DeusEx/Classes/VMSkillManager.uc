class VMSkillManager extends Actor;

//==============================================
// Strings
//==============================================
var() localized string SkillLevelNames[4];

//==============================================
// Data
//==============================================
var travel VMSkillInfo FirstSkillInfo;
var travel TableFloat SkillValues;

//==============================================
// Management
//==============================================
function Initialize() {
    SkillValues = new class'TableFloat';
}

function bool AddSkill( class<VMSkill> class, optional int startingLevel ) {
    local VMSkillInfo info;

    if ( startingLevel < 0 || GetSkillInfo( class.Name ) != none ) {
        return false;
    }

    info = new class'VMSkillInfo';
    info.SkillClassName = class.Name;
    info.Level = startingLevel;
    info.Next = FirstSkillInfo;
    FirstSkillInfo = info;

    info.RefreshValues( SkillValues );

    return true;
}

function Reset() {
    local VMSkillInfo info;

    SkillValues.Clear();

    info = FirstSkillInfo;
    while ( info != none ) {
        info.Level = 0;
        info.RefreshValues( SkillValues );

        info = info.Next;
    }
}

function RefreshValues() {
    local VMSkillInfo info;

    SkillValues.Clear();

    info = FirstSkillInfo;
    while ( info != none ) {
        info.RefreshValues( SkillValues );

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
        if ( info.SkillClassName == name ) {
            break;
        }

        info = info.Next;
    }

    return info;
}

function bool IncreaseLevel( VMSkillInfo info ) {
    return info.IncreaseLevel( SkillValues );
}
function bool DecreaseLevel( VMSkillInfo info ) {
    return info.DecreaseLevel( SkillValues );
}

function IncreaseToMax( VMSkillInfo info ) {
    info.IncreaseToMax( SkillValues );
}
function IncreaseAllToMax() {
    local VMSkillInfo info;

    SkillValues.Clear();

    info = FirstSkillInfo;
    while ( info != none ) {
        info.Level = info.GetMaxLevel();
        info.RefreshValues( SkillValues );

        info = info.Next;
    }
}

//==============================================
// Skill values
//==============================================
function float GetValue( string name, optional float defaultValue ) {
    local float value;

    if ( SkillValues.TryGetValue( name, value ) ) {
        return value;
    }
    else {
        return defaultValue;
    }
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
     SkillLevelNames(0)="UNTRAINED"
     SkillLevelNames(1)="TRAINED"
     SkillLevelNames(2)="ADVANCED"
     SkillLevelNames(3)="MASTER"
     bHidden=True
     bTravel=True
}