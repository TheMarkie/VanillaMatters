class VMUpgradeManager extends Actor
    abstract;

var VMPlayer Player;

//==============================================
// Management
//==============================================
function Initialize( VMPlayer player ) {
    Player = player;
}
function bool Add( name name, optional int startingLevel ) { return false; }
function Refresh( VMPlayer player ) {
    Player = player;
}
function Reset();

//==============================================
// Management
//==============================================
function bool IncreaseLevel( name name ) { return false; }
function bool DecreaseLevel( name name ) { return false; }
function IncreaseAllToMax();

//==============================================
// Values
//==============================================
function float GetValue( name name, optional float defaultValue ) { return defaultValue; }
function int GetLevel( name name ) { return -1; }

defaultproperties
{
     bHidden=True
     bTravel=True
}
