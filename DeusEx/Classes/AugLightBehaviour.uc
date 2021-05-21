class AugLightBehaviour extends VMAugmentationBehaviour;

var Beam MainBeam;
var Beam GlowBeam;

var() int Length;

// Behaviours
function bool Activate( int level ) {
    if ( MainBeam != none ) {
        MainBeam.Destroy();
    }
    MainBeam = Player.Spawn( class'Beam', Player,, Player.Location );
    MainBeam.LightHue = 32;
    MainBeam.LightRadius = 4;
    MainBeam.LightSaturation = 140;
    MainBeam.LightBrightness = 192;
    MainBeam.LightType = LT_Steady;
    SetBeamLocation();

    if ( GlowBeam != none ) {
        GlowBeam.Destroy();
    }
    GlowBeam = Player.Spawn( class'Beam', Player,, Player.Location );
    GlowBeam.LightHue = 32;
    GlowBeam.LightRadius = 4;
    GlowBeam.LightSaturation = 140;
    GlowBeam.LightBrightness = 220;
    SetGlowLocation();

    return true;
}

function bool Deactivate( int level ) {
    if ( MainBeam != none ) {
        MainBeam.Destroy();
    }
    MainBeam = none;

    if ( GlowBeam != none ) {
        GlowBeam.Destroy();
    }
    GlowBeam = none;

    return true;
}

function Tick( float deltaTime, int level ) {
    SetBeamLocation();
    SetGlowLocation();
}

// Beam Management
function SetBeamLocation() {
    local float dist, size, radius;
    local Vector HitNormal, HitLocation, StartTrace, EndTrace;

    if ( MainBeam != none ) {
        StartTrace = Player.Location;
        StartTrace.Z += Player.BaseEyeHeight;
        EndTrace = StartTrace + ( Length * Vector( Player.ViewRotation ) );

        Player.Trace( HitLocation, HitNormal, EndTrace, StartTrace, True );
        if ( HitLocation == vect( 0, 0, 0 ) ) {
            HitLocation = EndTrace;
        }

        dist = VSize( HitLocation - StartTrace );
        size = FClamp( dist / Length, 0, 1 );
        radius = ( size * 5.12 ) + 4.0;
        MainBeam.SetLocation( HitLocation - ( Vector( Player.ViewRotation ) * 64 ) );
        MainBeam.LightRadius = byte( radius );
        MainBeam.AIStartEvent( 'Beam', EAITYPE_Visual );
    }
}

function vector SetGlowLocation() {
    local vector pos;

    if ( GlowBeam != none ) {
        pos = Player.Location;
        pos += vect( 0, 0, 1 ) * Player.BaseEyeHeight;
        pos += vect( 1, 1, 0 ) * Vector( Player.Rotation ) * Player.CollisionRadius * 1.5;
        GlowBeam.SetLocation( pos );
    }
}

defaultproperties
{
    Length=1024
}