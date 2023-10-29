class AugEMPBehaviour extends VMAugmentationBehaviour;

var() float Cost;
var() array<float> EMPResistance;
var() array<int> Damage;
var() float Range;
var() float Cooldown;

var float cooldownTimer;

function Refresh( VMPlayer p, VMAugmentationInfo i, VMAugmentationManager m ) {
    super.Refresh( p, i, m );
    Player.CategoryModifiers.Modify( 'DamageResistanceMult', 'EMP', default.EMPResistance[Info.Level] );
}

function bool Activate() {
    local DeusExProjectile projectile;
    local Vector start;

    if ( !Player.DrainEnergy( Cost ) ) {
        Info.WarnNotEnoughEnergy( Cost );
        return false;
    }

    Player.PlaySound(Sound'DeusExSounds.Weapons.ProdFire', SLOT_None, 0.6);
    Player.PlaySound(Sound'BioElectricHiss', SLOT_None, 0.6,,, 0.5);

    start = Player.Location;
    start.Z += Player.BaseEyeHeight * 0.7;
    projectile = Player.Spawn(class'AugEMPProjectile', Player,, start, Player.ViewRotation);
    projectile.VM_fromWeapon = none;
    projectile.VM_MoverDamageMult = 0;
    projectile.Damage = Damage[Info.Level];
    projectile.MaxRange = Range;
    projectile.DrawScale = 0.2 + (0.15 * Info.Level);

    cooldownTimer = Cooldown;

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

    return super.Tick( deltaTime );
}

function OnLevelChanged( int oldLevel, int newLevel ) {
    Player.CategoryModifiers.Modify( 'DamageResistanceMult', 'EMP', default.EMPResistance[newLevel] - default.EMPResistance[oldLevel] );
}

defaultproperties
{
     Cost=20
     EMPResistance=(0.4,0.8,1,1)
     Damage=(10,20,40,80)
     Range=400.000000
     Cooldown=0.500000
}
