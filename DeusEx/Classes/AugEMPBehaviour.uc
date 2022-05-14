class AugEMPBehaviour extends VMAugmentationBehaviour;

var() array<float> EMPResistance;
var() array<int> Damage;
var() float Length;

var ElectricityEmitter emitter;

function Refresh( VMPlayer p, VMAugmentationInfo i, VMAugmentationManager m ) {
    super.Refresh( p, i, m );
    Player.CategoryModifiers.Modify( 'DamageResistanceMult', 'EMP', default.EMPResistance[Info.Level] );
}

function bool Activate() {
    if ( emitter == none ) {
        CreateEmitter();
    }
    emitter.damageAmount = Damage[Info.Level];
    SnapToPlayerView();
    emitter.TurnOn();
    return true;
}

function bool Deactivate() {
    if ( emitter != none ) {
        emitter.TurnOff();
    }
    return true;
}

function float Tick( float deltaTime ) {
    if ( !Info.IsActive ) {
        return 0;
    }

    SnapToPlayerView();
    return super.Tick( deltaTime );
}

function OnLevelChanged( int oldLevel, int newLevel ) {
    Player.CategoryModifiers.Modify( 'DamageResistanceMult', 'EMP', -default.EMPResistance[oldLevel] );
    Player.CategoryModifiers.Modify( 'DamageResistanceMult', 'EMP', default.EMPResistance[newLevel] );
}

function CreateEmitter() {
    local Vector location;

    emitter = Player.Spawn( class'ElectricityEmitter', Player );
    if ( emitter != none ) {
        emitter.TurnOff();
        emitter.bFlicker = false;
        emitter.Length = Length;
        emitter.randomAngle = 256;
        emitter.Instigator = Player;
        location = Player.Location;
        location.Z += Player.BaseEyeHeight / 2;
        emitter.SetLocation( location );
        emitter.SetBase( Player );
    }
}

function SnapToPlayerView() {
    local Vector start, end;
    local Rotator rotation;

    rotation = Player.ViewRotation;
    rotation.Pitch += 400;
    emitter.SetRotation( rotation );
}

defaultproperties
{
     EMPResistance=(0.4,0.8,1,1)
     Damage=(4,8,16,32)
     Length=400.000000
}