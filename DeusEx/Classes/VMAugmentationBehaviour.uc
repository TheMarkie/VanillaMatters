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

function float GetRate( float time, int level ) {
    return ( Definition.default.Rates[Min( level, #Definition.default.Rates - 1 )] / 60 ) * time;
}

function float IsOnCooldown( int level );