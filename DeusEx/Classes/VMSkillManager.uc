class VMSkillManager extends Actor;

//==============================================
// Strings
//==============================================
var() localized string SkillLevelNames[4];

//==============================================
// Data
//==============================================
var travel VMSkill FirstSkill;
var travel TableFloat SkillValues;

//==============================================
// Management
//==============================================
function Initialize() {
    SkillValues = new class'TableFloat';
}

function RefreshValues() {
    local VMSkill skill;

    if ( SkillValues == none ) {
        Initialize();
    }

    skill = FirstSkill;
    while ( skill != none ) {
        Log( "Refreshing skill:" @ skill.Class.Name );
        skill.RefreshValues( SkillValues );

        skill = skill.Next;
    }
}

//==============================================
// Skill Management
//==============================================
function VMSkill GetSkill( name skillName ) {
    local VMSkill skill;

    skill = FirstSkill;
    while ( skill != none ) {
        if ( skill.Class.Name == skillName ) {
            return skill;
        }

        skill = skill.Next;
    }

    return none;
}

function bool AddSkill( class<VMSkill> skillClass, optional int startingLevel ) {
    local VMSkill skill;

    if ( startingLevel < 0 || GetSkill( skillClass.Name ) != none ) {
        return false;
    }

    skill = new skillClass;
    skill.Level = startingLevel;
    skill.Next = FirstSkill;
    FirstSkill = skill;

    skill.RefreshValues( SkillValues );

    return true;
}

function bool IncreaseLevel( VMSkill skill ) {
    if ( skill != none ) {
        return skill.IncreaseLevel( SkillValues );
    }

    return false;
}
function bool IncreaseLevelWithName( name skillName ) {
    return IncreaseLevel( GetSkill( skillName ) );
}

function bool DecreaseLevel( VMSkill skill ) {
    if ( skill != none ) {
        return skill.DecreaseLevel( SkillValues );
    }

    return false;
}
function bool DecreaseLevelWithName( name skillName ) {
    return DecreaseLevel( GetSkill( skillName ) );
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
    local VMSkill skill;

    skill = GetSkill( skillName );
    if ( skill != none ) {
        return skill.Level;
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