class VMUpgradeManager extends Actor
    abstract;

var VMPlayer Player;

//==============================================
// Management
//==============================================
function Initialize( VMPlayer playerOwner ) {
    Player = playerOwner;
}
function Refresh( VMPlayer playerOwner ) {
    Player = playerOwner;
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
function int GetLevel( name name ) { return -1; }

defaultproperties
{
     bHidden=True
     bTravel=True
}
