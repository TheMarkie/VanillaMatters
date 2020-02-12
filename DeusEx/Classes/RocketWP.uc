//=============================================================================
// RocketWP.
//=============================================================================
class RocketWP extends Rocket;

//var float mpExplodeDamage;

#exec OBJ LOAD FILE=Effects

simulated function DrawExplosionEffects(vector HitLocation, vector HitNormal)
{
    local ExplosionLight light;
    local ParticleGenerator gen;
   local ExplosionSmall expeffect;

    // draw a pretty explosion
    light = Spawn(class'ExplosionLight',,, HitLocation);
    if (light != None)
   {
      light.RemoteRole = ROLE_None;
        light.size = 12;
   }

   expeffect = Spawn(class'ExplosionSmall',,, HitLocation);
   if (expeffect != None)
      expeffect.RemoteRole = ROLE_None;

    // create a particle generator shooting out white-hot fireballs
    gen = Spawn(class'ParticleGenerator',,, HitLocation, Rotator(HitNormal));
    if (gen != None)
    {
      gen.RemoteRole = ROLE_None;
        gen.particleDrawScale = 1.0;
        gen.checkTime = 0.05;
        gen.frequency = 1.0;
        gen.ejectSpeed = 200.0;
        gen.bGravity = True;
        gen.bRandomEject = True;
        gen.particleTexture = Texture'Effects.Fire.FireballWhite';
        gen.LifeSpan = 2.0;
    }
}

simulated function PreBeginPlay()
{
    Super.PreBeginPlay();

    if ( ( Level.NetMode != NM_Standalone ) && (Class == Class'RocketWP') )
    {
      speed = 2000.0000;
      SetTimer(5,false);
      //Damage = mpExplodeDamage;
      // Vanilla Matters: Make mpDamage have a consistent name.
      Damage = mpDamage;
        blastRadius = mpBlastRadius;
        SoundRadius=76;
    }
}

defaultproperties
{
     mpBlastRadius=768.000000
     bBlood=False
     bDebris=False
     blastRadius=512.000000
     DamageType=Flamed
     ItemName="WP Rocket"
     VM_bOverridesDamage=True
     mpDamage=75.000000
     ImpactSound=Sound'DeusExSounds.Generic.SmallExplosion2'
     Mesh=LodMesh'DeusExItems.RocketHE'
     DrawScale=1.000000
     AmbientSound=Sound'DeusExSounds.Weapons.WPApproach'
}
