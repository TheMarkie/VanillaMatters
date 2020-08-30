class VMSkillInfo extends VMUpgradeInfo;

var travel VMSkillInfo Next;

var transient class<VMSkill> Definition;

function LoadDefinition() {
    if ( Definition == none ) {
        Definition = class<VMSkill>( DynamicLoadObject( "DeusEx." $ string( DefinitionClassName ), class'Class' ) );
    }
}

function Initialize( name name, int startingLevel ) {
    super.Initialize( name, startingLevel );
    LoadDefinition();
}

//==============================================
// General info
//==============================================
function string GetName() {
    return Definition.default.UpgradeName;
}
function string GetDescription() {
    return Definition.default.Description;
}
function Texture GetIcon() {
    return Definition.default.Icon;
}

function int GetMaxLevel() {
    return Definition.static.GetMaxLevel();
}
function int GetNextLevelCost() {
    if ( Level < Definition.static.GetMaxLevel() ) {
        return Definition.default.Costs[Level];
    }
    else {
        return -1;
    }
}
function bool CanUpgrade( optional int amount ) {
    return ( Level < Definition.static.GetMaxLevel() && amount >= Definition.default.Costs[Level] );
}

//==============================================
// Management
//==============================================
function RefreshValues( TableFloat globalTable, TableTableFloat categoryTable ) {
    LoadDefinition();

    Definition.static.UpdateValues( globalTable, -1, Level );
    Definition.static.UpdateCategoryValues( categoryTable, -1, Level );
}

function UpdateValues( TableFloat globalTable, TableTableFloat categoryTable, int oldLevel, int newLevel ) {
    Definition.static.UpdateValues( globalTable, oldLevel, newLevel );
    Definition.static.UpdateCategoryValues( categoryTable, oldLevel, newLevel );
}

defaultproperties
{
}
