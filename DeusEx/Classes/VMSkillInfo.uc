class VMSkillInfo extends VMUpgradeInfo;

var travel VMSkillInfo Next;

var private transient class<VMSkill> _definitionClass;
function class<VMSkill> GetDefinitionClass() {
    if ( _definitionClass == none ) {
        _definitionClass = class<VMSkill>( DynamicLoadObject( "DeusEx." $ string( DefinitionClassName ), class'Class' ) );
    }

    return _definitionClass;
}

//==============================================
// General info
//==============================================
function string GetName() {
    return GetDefinitionClass().default.UpgradeName;
}
function string GetDescription() {
    return GetDefinitionClass().default.Description;
}
function Texture GetIcon() {
    return GetDefinitionClass().default.Icon;
}

function int GetMaxLevel() {
    return GetDefinitionClass().static.GetMaxLevel();
}

function int GetNextLevelCost() {
    if ( Level < GetMaxLevel() ) {
        return GetDefinitionClass().default.Costs[Level];
    }
    else {
        return -1;
    }
}

function bool CanUpgrade( int amount ) {
    if ( Level < GetMaxLevel() && amount >= _definitionClass.default.Costs[Level] ) {
        return true;
    }
    else {
        return false;
    }
}

//==============================================
// Management
//==============================================
function RefreshValues( TableFloat globalTable, TableTableFloat categoryTable ) {
    GetDefinitionClass().static.UpdateValues( globalTable, -1, Level );
    _definitionClass.static.UpdateCategoryValues( categoryTable, -1, Level );
}

function UpdateValues( TableFloat globalTable, TableTableFloat categoryTable, int oldLevel, int newLevel ) {
    GetDefinitionClass().static.UpdateValues( globalTable, oldLevel, newLevel );
    _definitionClass.static.UpdateCategoryValues( categoryTable, oldLevel, newLevel );
}

defaultproperties
{
}
