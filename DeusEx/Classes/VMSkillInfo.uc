class VMSkillInfo extends VMUpgradeInfo;

var travel VMSkillInfo Next;

var transient class<VMSkill> Definition;

function LoadDefinition() {
    if ( Definition == none ) {
        Definition = class<VMSkill>( DynamicLoadObject( string( DefinitionPackageName ) $ "." $ string( DefinitionClassName ), class'Class' ) );
    }
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
function RefreshValues( VMPlayer player ) {
    LoadDefinition();

    Definition.static.UpdateValues( player, -1, Level );
}

function UpdateValues( VMPlayer player, int oldLevel, int newLevel ) {
    Definition.static.UpdateValues( player, oldLevel, newLevel );
}

defaultproperties
{
}
