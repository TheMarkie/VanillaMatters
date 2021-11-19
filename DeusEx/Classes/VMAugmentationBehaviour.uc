class VMAugmentationBehaviour extends Object
    abstract;

var transient VMPlayer Player;
var transient VMAugmentationInfo Info;

function Refresh( VMPlayer p, VMAugmentationInfo i, VMAugmentationManager m ) {
    Player = p;
    Info = i;
}

// Functionality
function bool Activate() { return true; }
function bool Deactivate() { return true; }

function float GetRate( float time ) {
    return Info.Definition.default.Rates[Info.Level] * time;
}

function float GetCooldown();

// Events
event Tick( float deltaTime );
event bool ProcessMove( float deltaTime );
event bool ParseLeftClick();
event bool TakeDamage( out int damage, name damageType, Pawn attacker, Vector hitLocation );

// Display
function Draw( GC gc );
