class AugDroneBehaviour extends VMAugmentationBehaviour;

var SpyDrone drone;

var ViewportWindow droneViewport;
var ViewportWindow playerViewport;
var bool isMinimized;

var() array<int> DroneSpeed;
// Vanilla Matters TODO: Rebalance duration.
var() array<float> DroneDuration;

var float durationTimer;

//==============================================
// Callbacks
//==============================================
function Refresh( VMPlayer p, VMAugmentationInfo i, VMAugmentationManager m ) {
    super.Refresh( p, i, m );
    m.ProcessMoveHandlers[-1] = self;
}

function bool Activate() {
    local float rate;

    // Vanilla Matters TODO: Rebalance rate and add message.
    rate = 30;
    if ( Player.Energy < rate ) {
        return false;
    }

    Player.Energy -= rate;

    Initialize();
    return true;
}

function bool Deactivate() {
    if ( drone != none ) {
        ToggleViewport();
        drone.Velocity = vect( 0, 0, 0 );
        return false;
    }

    return true;
}

function Tick( float deltaTime ) {
    durationTimer -= deltaTime;
    if ( durationTimer <= 0 ) {
        CleanUp();
        durationTimer = 0;
        Info.IsActive = false;
    }
}

function bool ProcessMove( float deltaTime ) {
    local Vector direction;

    if ( drone == none || isMinimized ) {
        return false;
    }

    direction = Normal( ( Player.aUp * vect( 0, 0, 1 ) + Player.aForward * vect( 1, 0, 0 ) + Player.aStrafe * vect( 0, 1, 0 ) ) >> Player.ViewRotation );

    drone.SetRotation( Player.ViewRotation );
    if ( VSize( direction ) <= 0 ) {
        drone.Velocity *= 0.5;
    }
    else {
        drone.Velocity += deltaTime * drone.Speed * direction;
    }

    Player.Velocity = vect( 0, 0, 0 );

    return true;
}

//==============================================
// Init
//==============================================
function Initialize() {
    local Vector location;

    location = ( 2.0 + class'SpyDrone'.Default.CollisionRadius + Player.CollisionRadius ) * Vector( Player.ViewRotation );
    location.Z = Player.BaseEyeHeight;
    location += Player.Location;
    drone = Player.Spawn( class'SpyDrone', Player,, location, Player.ViewRotation );
    drone.Speed = DroneSpeed[Info.Level];

    CreateViewportWindows();

    durationTimer = DroneDuration[Info.Level];
}

function CreateViewportWindows() {
    local float w, h, x, y;
    local AugmentationDisplayWindow augDisplay;

    augDisplay = Player.DXRootWindow.hud.augDisplay;

    x = augDisplay.margin;
    y = ( augDisplay.height - h ) / 2;
    w = augDisplay.width / 4;
    h = augDisplay.height / 4;

    droneViewport = ViewportWindow( augDisplay.NewChild( class'ViewportWindow' ) );
    droneViewport.ConfigureChild( 0, 0, Player.DXRootWindow.width, Player.DXRootWindow.height );
    droneViewport.SetViewportActor( drone );

    playerViewport = ViewportWindow( augDisplay.NewChild( class'ViewportWindow' ) );
    playerViewport.ConfigureChild( x, y, w, h );
    playerViewport.SetViewportActor( Player );

    isMinimized = true;
    ToggleViewport();
}

//==============================================
// Management
//==============================================
function ToggleViewport() {
    local float w, h, x, y;
    local AugmentationDisplayWindow augDisplay;

    augDisplay = Player.DXRootWindow.hud.augDisplay;

    w = augDisplay.width / 4;
    h = augDisplay.height / 4;
    x = augDisplay.margin;
    y = ( augDisplay.height - h ) / 2;

    if ( isMinimized ) {
        droneViewport.ConfigureChild( 0, 0, Player.DXRootWindow.width, Player.DXRootWindow.height );
        playerViewport.Show();
        playerViewport.ConfigureChild( x, y, w, h );
    }
    else {
        droneViewport.ConfigureChild( x, y, w, h );
        playerViewport.Hide();
    }

    isMinimized = !isMinimized;
}

function CleanUp() {
    if ( drone != none ) {
        drone.Destroy();
        drone = none;
    }
    if ( droneViewport != none ) {
        droneViewport.Destroy();
    }
    if ( playerViewport != none ) {
        playerViewport.Destroy();
    }
}

defaultproperties
{
     DroneSpeed=(100,125,150,200)
     DroneDuration=(5,10,20,30)
}
