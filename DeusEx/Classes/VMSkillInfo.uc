class VMSkillInfo extends Object;

var travel name SkillClassName;
var travel int Level;

var travel VMSkillInfo Next;

var private transient class<VMSkill> _skillClass;
function class<VMSkill> GetSkillClass() {
    if ( _skillClass == none ) {
        _skillClass = class<VMSkill>( DynamicLoadObject( "DeusEx." $ string( SkillClassName ), class'Class' ) );
    }

    return _skillClass;
}

//==============================================
// General info
//==============================================
function string GetSkillName() {
    return GetSkillClass().default.SkillName;
}
function string GetDescription() {
    return GetSkillClass().default.Description;
}
function Texture GetSkillIcon() {
    return GetSkillClass().default.SkillIcon;
}

function int GetMaxLevel() {
    return GetSkillClass().static.GetMaxLevel();
}

function int GetNextLevelCost() {
    if ( Level < GetMaxLevel() ) {
        return GetSkillClass().default.Costs[Level];
    }
    else {
        return -1;
    }
}

function bool CanUpgrade( int amount ) {
    if ( Level < GetMaxLevel() && amount >= GetNextLevelCost() ) {
        return true;
    }
    else {
        return false;
    }
}

//==============================================
// Management
//==============================================
function RefreshValues( TableFloat table ) {
    GetSkillClass().static.UpdateValues( table, -1, Level );
}

function bool IncreaseLevel( optional TableFloat table ) {
    if ( Level < GetMaxLevel() ) {
        GetSkillClass().static.UpdateValues( table, Level, Level + 1 );
        Level += 1;

        return true;
    }

    return false;
}

function bool DecreaseLevel( optional TableFloat table ) {
    if ( Level > 0 ) {
        GetSkillClass().static.UpdateValues( table, Level, Level - 1 );
        Level -= 1;

        return true;
    }

    return false;
}

function IncreaseToMax( optional TableFloat table ) {
    local int maxLevel;

    maxLevel = GetMaxLevel();
    if ( Level < maxLevel ) {
        GetSkillClass().static.UpdateValues( table, Level, maxLevel );
        Level = maxLevel;
    }
}

defaultproperties
{
}
