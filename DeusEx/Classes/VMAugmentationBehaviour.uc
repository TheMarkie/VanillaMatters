class VMAugmentationBehaviour extends Object
    abstract;

var transient VMPlayer Player;
var transient VMAugmentationInfo Info;

function Refresh( VMPlayer p, VMAugmentationInfo i, VMAugmentationManager m ) {
    Player = p;
    Info = i;
}

// Functionality
function bool Activate() { return false; }
function bool Deactivate() { return false; }

function float GetRate( float time ) {
    return ( Info.Definition.default.Rates[Min( Info.Level, #Info.Definition.default.Rates - 1 )] / 60 ) * time;
}

function float GetCooldown();

// Events
event Tick( float deltaTime );
event bool ProcessMove( float deltaTime );

// Display
function Draw( GC gc );
