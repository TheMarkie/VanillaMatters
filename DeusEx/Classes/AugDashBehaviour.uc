class AugDashBehaviour extends VMAugmentationBehaviour;

var() float Distance;
var() array<float> Cost;
var() array<float> Cooldown;

var float cooldownTimer;

function bool Activate() {
    local Vector direction;

    if ( ( Player.CarriedDecoration != none && Player.CarriedDecoration.Mass > 20 )
        || Player.IsLeaning()
        || Player.Physics != PHYS_Walking
    ) {
        return false;
    }

    if ( !Player.DrainEnergy( Cost[Info.Level] ) ) {
        Info.WarnNotEnoughEnergy( Cost[Info.Level] );
        return false;
    }

    direction = Vector( Player.ViewRotation );
    direction.Z = 0.2;
    direction = Normal( direction );
    Player.Velocity += direction * Distance;
    if ( Player.Base != Player.Level ) {
        Player.Velocity += Player.Base.Velocity;
    }
    Player.SetPhysics( PHYS_Falling );

    cooldownTimer = Cooldown[Info.Level];
    return false;
}

function float GetCooldown() {
    return cooldownTimer;
}

function float Tick( float deltaTime ) {
    if ( cooldownTimer > 0 ) {
        cooldownTimer -= deltaTime;
        if ( cooldownTimer <= 0 ) {
            cooldownTimer = 0;
        }
    }
    return 0;
}

defaultproperties
{
     Distance=800
     Cost=(20,20,15,15)
     Cooldown=(6,4,2,1)
}
