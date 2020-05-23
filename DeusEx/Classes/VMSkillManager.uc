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

function RefreshValues() {
    local VMSkillInfo info;

    if ( SkillValues == none ) {
        return;
    }

    SkillValues.Clear();

    info = FirstSkillInfo;
    while ( info != none ) {
        info.RefreshValues( SkillValues );

        info = info.Next;
    }
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
    if ( info != none ) {
        return info.IncreaseLevel( SkillValues );
    }

    return false;
}
function bool IncreaseLevelWithName( name name ) {
    return IncreaseLevel( GetSkillInfo( name ) );
}

function bool DecreaseLevel( VMSkillInfo info ) {
    if ( info != none ) {
        return info.DecreaseLevel( SkillValues );
    }

    return false;
}
function bool DecreaseLevelWithName( name name ) {
    return DecreaseLevel( GetSkillInfo( name ) );
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

function int GetLevel( name skillName ) {
    local VMSkillInfo info;

    info = GetSkill( skillName );
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