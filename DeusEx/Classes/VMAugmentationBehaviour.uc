class VMAugmentationBehaviour extends Object
    abstract;

var transient VMPlayer Player;
var transient VMAugmentationInfo Info;

function Refresh( VMPlayer p, VMAugmentationInfo i, VMAugmentationManager m ) {
    Player = p;
    Info = i;
}

// Functionality
function bool Activate( int level );
function Tick( float deltaTime, int level );
function bool Deactivate( int level );

function float GetRate( float time, int level ) {
    return ( Info.Definition.default.Rates[Min( level, #Info.Definition.default.Rates - 1 )] / 60 ) * time;
}

function float GetCooldown( int level );

// Display
function Draw( GC gc );
