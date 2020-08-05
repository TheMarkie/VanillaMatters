class VMSkillInfo extends VMUpgradeInfo;

var travel VMSkillInfo Next;

var private transient class<VMSkill> _definitionClass;
function class<VMSkill> GetDefinitionClass() {
    if ( _definitionClass == none ) {
        _definitionClass = class<VMSkill>( DynamicLoadObject( "DeusEx." $ string( DefinitionClassName ), class'Class' ) );
    }

    return _definitionClass;
}

function Initialize( name name, int startingLevel ) {
    super.Initialize( name, startingLevel );
    GetDefinitionClass();
}

//==============================================
// General info
//==============================================
function string GetName() {
    return _definitionClass.default.UpgradeName;
}
function string GetDescription() {
    return _definitionClass.default.Description;
}
function Texture GetIcon() {
    return _definitionClass.default.Icon;
}

function int GetMaxLevel() {
    return _definitionClass.static.GetMaxLevel();
}
function int GetNextLevelCost() {
    if ( Level < GetMaxLevel() ) {
        return _definitionClass.default.Costs[Level];
    }
    else {
        return -1;
    }
}
function bool CanUpgrade( optional int amount ) {
    return ( Level < GetMaxLevel() && amount >= _definitionClass.default.Costs[Level] );
}

//==============================================
// Management
//==============================================
function RefreshValues( TableFloat globalTable, TableTableFloat categoryTable ) {
    _definitionClass.static.UpdateValues( globalTable, -1, Level );
    _definitionClass.static.UpdateCategoryValues( categoryTable, -1, Level );
}

function UpdateValues( TableFloat globalTable, TableTableFloat categoryTable, int oldLevel, int newLevel ) {
    _definitionClass.static.UpdateValues( globalTable, oldLevel, newLevel );
    _definitionClass.static.UpdateCategoryValues( categoryTable, oldLevel, newLevel );
}

defaultproperties
{
}
