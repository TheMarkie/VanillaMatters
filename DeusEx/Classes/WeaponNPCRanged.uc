//=============================================================================
// WeaponNPCRanged.
//=============================================================================
class WeaponNPCRanged extends DeusExWeapon
    abstract;

// Vanilla Matters: Override Fire to handle muzzle flash.
function Fire( float value ) {
    local rotator rot;
    local VMMuzzleFlash muzzleFlash;

    PlayerViewOffset = - FireOffset;

    super.Fire( value );

    // VM: Only do muzzle flashes with instant hit weapons.
    if ( bInstantHit && bHasMuzzleFlash ) {
        rot = Pawn( Owner ).ViewRotation;
        rot.Pitch = 0;

        muzzleFlash = Spawn( class'VMMuzzleFlash', Owner,, Owner.Location + ( ( Owner.default.CollisionHeight - Owner.CollisionHeight ) * 0.5 * vect( 0, 0, 1 ) ) + ( FireOffset >> rot ), rot );
        if ( muzzleFlash != none ) {
            muzzleFlash.DrawScale = muzzleFlash.default.DrawScale * ( ( Owner.CollisionHeight + Owner.CollisionRadius ) / 120 );

            muzzleFlash.SetBase( Owner );
        }

        MuzzleFlashLight();
    }
}

defaultproperties
{
     LowAmmoWaterMark=0
     EnemyEffective=ENMEFF_Organic
     ShotTime=0.300000
     reloadTime=0.000000
     BaseAccuracy=0.850000
     bHasMuzzleFlash=False
     bOwnerWillNotify=True
     bNativeAttack=True
     ReloadCount=159
     shakemag=0.000000
     Misc1Sound=Sound'DeusExSounds.Weapons.CombatKnifeHitFlesh'
     Misc2Sound=Sound'DeusExSounds.Weapons.CombatKnifeHitHard'
     Misc3Sound=Sound'DeusExSounds.Weapons.CombatKnifeHitSoft'
     InventoryGroup=99
     PlayerViewOffset=(X=0.000000,Z=0.000000)
     PlayerViewMesh=LodMesh'DeusExItems.InvisibleWeapon'
     PickupViewMesh=LodMesh'DeusExItems.InvisibleWeapon'
     ThirdPersonMesh=LodMesh'DeusExItems.InvisibleWeapon'
     Icon=None
     largeIconWidth=1
     largeIconHeight=1
     Mesh=LodMesh'DeusExItems.InvisibleWeapon'
     CollisionRadius=1.000000
     CollisionHeight=1.000000
     Mass=5.000000
}
