class VMAugmentationBehaviour extends Object
    abstract;

var transient VMPlayer Player;
var transient class<VMAugmentation> Definition;

function Refresh( VMAugmentationManager manager, VMPlayer p ) {
    Player = p;
}

// Functionality
function Activate( int level );
function Tick( float deltaTime, int level );
function Deactivate( int level );

function float GetRate( float time, int level ) {
    return ( Definition.default.Rates[Min( level, #Definition.default.Rates - 1 )] / 60 ) * time;
}

function float GetCooldown( int level );

// Display
function Draw( GC gc );
