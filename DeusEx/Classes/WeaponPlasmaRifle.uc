//=============================================================================
// WeaponPlasmaRifle.
//=============================================================================
class WeaponPlasmaRifle extends DeusExWeapon;

defaultproperties
{
     LowAmmoWaterMark=12
     GoverningSkill=Class'DeusEx.SkillWeaponHeavy'
     EnviroEffective=ENVEFF_AirVacuum
     reloadTime=3.000000
     HitDamage=25
     BaseAccuracy=0.650000
     bCanHaveScope=True
     ScopeFOV=20
     bCanHaveLaser=True
     AreaOfEffect=AOE_Cone
     bPenetrating=False
     recoilStrength=0.300000
     AIFireDelay=1.500000
     bCanHaveModBaseAccuracy=True
     bCanHaveModReloadCount=True
     bCanHaveModReloadTime=True
     bCanHaveModStability=True
     VM_ShotCount=3
     AmmoName=Class'DeusEx.AmmoPlasma'
     ReloadCount=12
     PickupAmmoCount=12
     ProjectileClass=Class'DeusEx.PlasmaBolt'
     shakemag=250.000000
     FireSound=Sound'DeusExSounds.Weapons.PlasmaRifleFire'
     AltFireSound=Sound'DeusExSounds.Weapons.PlasmaRifleReloadEnd'
     CockingSound=Sound'DeusExSounds.Weapons.PlasmaRifleReload'
     SelectSound=Sound'DeusExSounds.Weapons.PlasmaRifleSelect'
     InventoryGroup=8
     ItemName="Plasma Rifle"
     PlayerViewOffset=(X=18.000000,Z=-7.000000)
     PlayerViewMesh=LodMesh'DeusExItems.PlasmaRifle'
     PickupViewMesh=LodMesh'DeusExItems.PlasmaRiflePickup'
     ThirdPersonMesh=LodMesh'DeusExItems.PlasmaRifle3rd'
     LandSound=Sound'DeusExSounds.Generic.DropLargeWeapon'
     Icon=Texture'DeusExUI.Icons.BeltIconPlasmaRifle'
     largeIcon=Texture'DeusExUI.Icons.LargeIconPlasmaRifle'
     largeIconWidth=203
     largeIconHeight=66
     invSlotsX=4
     invSlotsY=2
     Description="An experimental weapon that is currently being produced as a series of one-off prototypes, the plasma gun superheats slugs of magnetically-doped plastic and accelerates the resulting gas-liquid mix using an array of linear magnets. The resulting plasma stream is deadly when used against slow-moving targets."
     beltDescription="PLASMA"
     Mesh=LodMesh'DeusExItems.PlasmaRiflePickup'
     CollisionRadius=15.600000
     CollisionHeight=5.200000
     Mass=50.000000
}
