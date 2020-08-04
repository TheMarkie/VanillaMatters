class VMUpgradeInfo extends Object
    abstract;

var travel name DefinitionClassName;
var travel int Level;

function Initialize( name name, int level ) {
    DefinitionClassName = name;
    Level = level;
}

//==============================================
// General info
//==============================================
function string GetName() { return ""; }
function string GetDescription() { return ""; }
function Texture GetIcon() { return none; }
function int GetMaxLevel() { return 0; }
function bool CanUpgrade( optional int amount ) { return false; }

//==============================================
// Management
//==============================================
function bool IncreaseLevel() {
    if ( Level < GetMaxLevel() ) {
        Level += 1;

        return true;
    }

    return false;
}

function bool DecreaseLevel() {
    if ( Level > 0 ) {
        Level -= 1;

        return true;
    }

    return false;
}

defaultproperties
{
}
