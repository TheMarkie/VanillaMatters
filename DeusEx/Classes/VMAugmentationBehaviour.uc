class VMAugmentationBehaviour extends Object
    abstract;

var VMPlayer Player;
var class<VMAugmentation> Definition;

function Refresh( VMPlayer p ) {
    Player = p;
}

function Activate( int level );

function Deactivate( int level );

function Tick( float deltaTime, int level );

function float GetRate( int level ) {
    if ( !Definition.default.IsPassive ) {
        return Definition.default.Rates[Level];
    }

    return 0;
}

function float GetValueActive( int level, optional float baseValue ) {
    return Definition.default.Values[level];
}

function float GetValueInactive( int level, optional float baseValue ) {
    return baseValue;
}
