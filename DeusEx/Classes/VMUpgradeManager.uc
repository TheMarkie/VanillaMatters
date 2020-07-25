class VMUpgradeManager extends Actor
    abstract;

//==============================================
// Management
//==============================================
function Initialize();
function Reset();
function bool Add( name name, optional int startingLevel ) { return false; }

//==============================================
// Management
//==============================================
function IncreaseAllToMax();

//==============================================
// Skill values
//==============================================
function float GetValue( name name, optional float defaultValue ) { return defaultValue; }
function int GetLevel( name name ) { return -1; }

defaultproperties
{
     bHidden=True
     bTravel=True
}
