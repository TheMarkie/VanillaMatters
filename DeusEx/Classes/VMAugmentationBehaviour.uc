class VMAugmentationBehaviour extends Object
    abstract;

var VMPlayer Player;
var VMAugmentationInfo Info;

function Refresh( VMPlayer p, VMAugmentationInfo i ) {
    Player = p;
    Info = i;
}

function Activate();

function Deactivate();

function Tick( float deltaTime );

function float GetRate() {
    if ( !Info.Definition.default.IsPassive ) {
        return Info.Definition.default.Rates[info.Level];
    }

    return 0;
}
