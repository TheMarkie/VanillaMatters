//=============================================================================
// Shuriken.
//=============================================================================
class Shuriken extends DeusExProjectile;

// set it's rotation correctly
simulated function Tick(float deltaTime)
{
    local Rotator rot;

    if (bStuck)
        return;

    Super.Tick(deltaTime);

    if (Level.Netmode != NM_DedicatedServer)
    {
        rot = Rotation;
        rot.Roll += 16384;
        rot.Pitch -= 16384;
        SetRotation(rot);
    }
}

defaultproperties
{
     bBlood=True
     bStickToWall=True
     DamageType=shot
     maxRange=1280
     spawnWeaponClass=Class'DeusEx.WeaponShuriken'
     bIgnoresNanoDefense=True
     ItemName="Throwing Knife"
     ItemArticle="a"
     mpDamage=30.000000
     speed=750.000000
     MaxSpeed=750.000000
     Damage=15.000000
     MomentumTransfer=1000
     ImpactSound=Sound'DeusExSounds.Generic.BulletHitFlesh'
     Mesh=LodMesh'DeusExItems.ShurikenPickup'
     CollisionRadius=5.000000
     CollisionHeight=0.300000
}
