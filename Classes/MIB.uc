//=============================================================================
// MIB.
//=============================================================================
class MIB extends HumanMilitary;

// ----------------------------------------------------------------------
// SpawnCarcass()
//
// Blow up instead of spawning a carcass
// ----------------------------------------------------------------------

function Carcass SpawnCarcass()
{
    if (bStunned)
        return Super.SpawnCarcass();

    Explode();

    return None;
}

function Explode()
{
    local SphereEffect sphere;
    local ScorchMark s;
    local ExplosionLight light;
    local int i;
    local float explosionDamage;
    local float explosionRadius;

    explosionDamage = 100;
    explosionRadius = 256;

    // alert NPCs that I'm exploding
    AISendEvent('LoudNoise', EAITYPE_Audio, , explosionRadius*16);
    PlaySound(Sound'LargeExplosion1', SLOT_None,,, explosionRadius*16);

    // draw a pretty explosion
    light = Spawn(class'ExplosionLight',,, Location);
    if (light != None)
        light.size = 4;

    Spawn(class'ExplosionSmall',,, Location + 2*VRand()*CollisionRadius);
    Spawn(class'ExplosionMedium',,, Location + 2*VRand()*CollisionRadius);
    Spawn(class'ExplosionMedium',,, Location + 2*VRand()*CollisionRadius);
    Spawn(class'ExplosionLarge',,, Location + 2*VRand()*CollisionRadius);

    sphere = Spawn(class'SphereEffect',,, Location);
    if (sphere != None)
        sphere.size = explosionRadius / 32.0;

    // spawn a mark
    s = spawn(class'ScorchMark', Base,, Location-vect(0,0,1)*CollisionHeight, Rotation+rot(16384,0,0));
    if (s != None)
    {
        s.DrawScale = FClamp(explosionDamage/30, 0.1, 3.0);
        s.ReattachDecal();
    }

    // spawn some rocks and flesh fragments
    for (i=0; i<explosionDamage/6; i++)
    {
        if (FRand() < 0.3)
            spawn(class'Rockchip',,,Location);
        else
            spawn(class'FleshFragment',,,Location);
    }

    HurtRadius(explosionDamage, explosionRadius, 'Exploded', explosionDamage*100, Location);
}

// Vanilla Matters: MIBs shouldn't be vulnerable to gas.
function float ShieldDamage( name damageType ) {
    if ( damageType == 'PoisonGas' || damageType == 'HalonGas' || damageType == 'Poison' || damageType == 'PoisonEffect' ) {
        return 0;
    }
    else if ( damageType == 'Stunned' || damageType == 'KnockedOut' ) {
        return 0.5;
    }
    else {
        return super.ShieldDamage( damageType );
    }
}

// Vanilla Matters: Make EMP stun MIBs.
function float ModifyDamage( int Damage, Pawn instigatedBy, Vector hitLocation, Vector offset, Name damageType ) {
    if ( damageType == 'EMP' ) {
        damageType = 'Stunned';
    }

    return super.ModifyDamage( Damage, instigatedBy, hitLocation, offset, damageType );
}

function GotoDisabledState( name damageType, EHitLocation hitPos ) {
    if ( damageType == 'EMP' ) {
        VM_damageTaken = VM_damageTaken / 2;
        damageType = 'Stunned';
    }
    else if ( damageType == 'TearGas' ) {
        VM_damageTaken = 0;
        damageType = 'PoisonGas';
    }

    super.GotoDisabledState( damageType, hitPos );
}

defaultproperties
{
     MinHealth=0.000000
     CarcassType=Class'DeusEx.MIBCarcass'
     WalkingSpeed=0.213333
     CloseCombatMult=0.500000
     GroundSpeed=180.000000
     HealthHead=350
     HealthTorso=350
     HealthLegLeft=175
     HealthLegRight=175
     HealthArmLeft=175
     HealthArmRight=175
     Mesh=LodMesh'DeusExCharacters.GM_Suit'
     DrawScale=1.100000
     MultiSkins(0)=Texture'DeusExCharacters.Skins.MIBTex0'
     MultiSkins(1)=Texture'DeusExCharacters.Skins.PantsTex5'
     MultiSkins(2)=Texture'DeusExCharacters.Skins.MIBTex0'
     MultiSkins(3)=Texture'DeusExCharacters.Skins.MIBTex1'
     MultiSkins(4)=Texture'DeusExCharacters.Skins.MIBTex1'
     MultiSkins(5)=Texture'DeusExCharacters.Skins.FramesTex2'
     MultiSkins(6)=Texture'DeusExCharacters.Skins.LensesTex3'
     MultiSkins(7)=Texture'DeusExItems.Skins.PinkMaskTex'
     CollisionHeight=52.250000
     BindName="MIB"
     FamiliarName="Man In Black"
     UnfamiliarName="Man In Black"
}
