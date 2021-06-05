class AugDroneBehaviour extends VMAugmentationBehaviour;

var SpyDrone drone;

var ViewportWindow droneViewport;
var ViewportWindow playerViewport;
var bool isMinimized;

var() array<int> DroneSpeed;

function bool Activate() {
    Initialize();
    return true;
}

function bool Deactivate() {
    if ( drone != none ) {
        ToggleViewport();
        return false;
    }

    return true;
}

function Initialize() {
    local Vector location;

    location = ( 2.0 + class'SpyDrone'.Default.CollisionRadius + Player.CollisionRadius ) * Vector( Player.ViewRotation );
    location.Z = Player.BaseEyeHeight;
    location += Player.Location;
    drone = Player.Spawn( class'SpyDrone', Player,, location, Player.ViewRotation );

    CreateViewportWindows();
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

defaultproperties
{
     DroneSpeed=(50,75,125,150)
}
