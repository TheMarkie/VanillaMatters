class AugLightBehaviour extends VMAugmentationBehaviour;

var Beam MainBeam;
var Beam GlowBeam;

// Behaviours
function Activate() {
    if ( MainBeam != none ) {
        MainBeam.Destroy();
    }
    MainBeam = Player.Spawn( class'Beam', Player,, Player.Location );
    MainBeam.LightHue = 32;
    MainBeam.LightRadius = 4;
    MainBeam.LightSaturation = 140;
    MainBeam.LightBrightness = 192;
    MainBeam.LightType = LT_Steady;
    SetBeamLocation( Info.GetValue() );

    if ( GlowBeam != none ) {
        GlowBeam.Destroy();
    }
    GlowBeam = Player.Spawn( class'Beam', Player,, Player.Location );
    GlowBeam.LightHue = 32;
    GlowBeam.LightRadius = 4;
    GlowBeam.LightSaturation = 140;
    GlowBeam.LightBrightness = 220;
    SetGlowLocation();
}

function Deactivate() {
    if ( MainBeam != none ) {
        MainBeam.Destroy();
    }
    MainBeam = none;

    if ( GlowBeam != none ) {
        GlowBeam.Destroy();
    }
    GlowBeam = none;
}

function Tick( float deltaTime ) {
    SetBeamLocation( Info.GetValue() );
    SetGlowLocation();
}

// Beam Management
function SetBeamLocation( int length ) {
    local float dist, size, radius;
    local Vector HitNormal, HitLocation, StartTrace, EndTrace;

    if ( MainBeam != none ) {
        StartTrace = Player.Location;
        StartTrace.Z += Player.BaseEyeHeight;
        EndTrace = StartTrace + ( length * Vector( Player.ViewRotation ) );

        Player.Trace( HitLocation, HitNormal, EndTrace, StartTrace, True );
        if ( HitLocation == vect( 0, 0, 0 ) ) {
            HitLocation = EndTrace;
        }

        dist = VSize( HitLocation - StartTrace );
        size = FClamp( dist / length, 0, 1 );
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

