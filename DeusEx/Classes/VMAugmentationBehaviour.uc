class VMAugmentationBehaviour extends Object
    abstract;

var transient VMPlayer Player;
var transient class<VMAugmentation> Definition;

function Refresh( VMPlayer p ) {
    Player = p;
}

function Activate( int level );
function Tick( float deltaTime, int level );
function Deactivate( int level );

function float GetRate( int level ) {
    return Definition.default.Rates[Level];
}

function float IsOnCooldown( int level );