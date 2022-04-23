class AugDefenseBehaviour extends VMAugmentationBehaviour;

var() float Cost;
var() array<float> Duration;
var() array<float> Cooldown;
var() float ProjectileRadius;
var() float WeaponRadius;

var VMAugmentationManager manager;

var float cooldownTimer;
var float durationTimer;

function Refresh( VMPlayer p, VMAugmentationInfo i, VMAugmentationManager m ) {
    super.Refresh( p, i, m );
    manager = m;
}

// Functionality
function bool Activate() {
    local ShockRing effect;
    local float radius;
    local ScriptedPawn sp;
    local Weapon weapon;

    if ( !Player.DrainEnergy( Cost ) ) {
        Info.WarnNotEnoughEnergy( Cost );
        return false;
    }

    Player.PlaySound( Sound'GEPGunLock', SLOT_None,,,, 2.0 );
    Player.PlaySound( Sound'DeusExSounds.Weapons.NanoVirusGrenadeExplode', SLOT_None,,,, 2.0 );
    effect = Player.Spawn( class'ShockRing', Player,, Player.Location, rot( 16384, 0, 0 ) );
    if ( effect != none ) {
        effect.SetBase( Player );
        effect.RemoteRole = ROLE_None;
        effect.size = ProjectileRadius / 32;
    }

    if ( Info.Level >= 2 ) {
        if ( Info.Level >= 3 ) {
            radius = ProjectileRadius;
        }
        else {
            radius = WeaponRadius;
        }
        foreach Player.RadiusActors( class'ScriptedPawn', sp, radius ) {
            if ( !sp.IsA( 'Animal' ) && !sp.IsA( 'Robot' ) && !sp.IsA( 'MJ12Commando' )
                && sp.Weapon != none && Player.LineOfSightTo( sp )
            ) {
                weapon = sp.Weapon;
                sp.DropWeapon();
                weapon.Destroy();
                sp.TakeDamage( 1, Player, sp.Location, vect( 0, 0, 0 ), 'Shot' );
            }
        }
        Player.PlaySound( Sound'ProdFire', SLOT_None,,,, 2.0 );
        effect = Player.Spawn( class'ShockRing', Player,, Player.Location, rot( 16384, 0, 0 ) );
        if ( effect != none ) {
            effect.AmbientGlow = 255;
            effect.SetBase( Player );
            effect.RemoteRole = ROLE_None;
            effect.size = radius / 32;
        }
    }

    cooldownTimer = Cooldown[Info.Level];
    durationTimer = Duration[Info.Level];
    return true;
}
function bool Deactivate() { return false; }

function float GetCooldown() {
    return cooldownTimer;
}

function float Tick( float deltaTime ) {
    local DeusExProjectile proj;

    if ( cooldownTimer > 0 ) {
        cooldownTimer -= deltaTime;
        if ( cooldownTimer <= 0 ) {
            cooldownTimer = 0;
        }
    }

    if ( !Info.IsActive ) {
        return 0;
    }

    if ( durationTimer > 0 ) {
        durationTimer -= deltaTime;
        if ( durationTimer <= 0 ) {
            durationTimer = 0;
            Info.IsActive = false;
            Player.PlaySound( Info.Definition.default.DeactivateSound, SLOT_None );
            return 0;
        }
    }

    foreach Player.RadiusActors( class'DeusExProjectile', proj, ProjectileRadius ) {
        if ( !proj.bIgnoresNanoDefense && !proj.bStuck
            && proj.Owner != Player && Player.LineOfSightTo( proj )
        ) {
            proj.bAggressiveExploded= true;
            proj.Explode( proj.Location, vect( 0, 0, 1 ) );
        }
    }

    return 0;
}

defaultproperties
{
     Cost=10
     Duration=(6,8,10,12)
     Cooldown=(12,12,12,12)
     ProjectileRadius=640.000000
     WeaponRadius=240.000000
}
