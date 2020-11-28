class VMSkill extends VMUpgrade
    abstract;

//==============================================
// Properties
//==============================================
var() array<int> Costs;

//==============================================
// General info
//==============================================
static function int GetMaxLevel() {
    return #default.Costs;
}

defaultproperties
{
}
