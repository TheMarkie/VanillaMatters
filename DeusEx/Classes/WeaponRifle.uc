//=============================================================================
// WeaponRifle.
//=============================================================================
class WeaponRifle extends DeusExWeapon;

defaultproperties
{
     LowAmmoWaterMark=6
     GoverningSkill=Class'DeusEx.SkillWeaponRifle'
     NoiseLevel=2.000000
     EnviroEffective=ENVEFF_Air
     ShotTime=1.200000
     reloadTime=2.000000
     HitDamage=50
     maxRange=19200
     AccurateRange=9600
     BaseAccuracy=0.650000
     bCanHaveScope=True
     bHasScope=True
     bCanHaveSilencer=True
     bHasMuzzleFlash=False
     recoilStrength=0.400000
     VM_spreadStrength=0.200000
     bUseWhileCrouched=False
     bCanHaveModReloadCount=True
     bCanHaveModReloadTime=True
     bCanHaveModRecoilStrength=True
     VM_handsTexPos(0)=0
     AmmoName=Class'DeusEx.Ammo3006'
     ReloadCount=6
     PickupAmmoCount=6
     bInstantHit=True
     FireOffset=(X=-20.000000,Y=2.000000,Z=30.000000)
     shakemag=200.000000
     FireSound=Sound'DeusExSounds.Weapons.RifleFire'
     AltFireSound=Sound'DeusExSounds.Weapons.RifleReloadEnd'
     CockingSound=Sound'DeusExSounds.Weapons.RifleReload'
     SelectSound=Sound'DeusExSounds.Weapons.RifleSelect'
     InventoryGroup=5
     ItemName="Sniper Rifle"
     PlayerViewOffset=(X=20.000000,Y=-2.000000,Z=-30.000000)
     PlayerViewMesh=LodMesh'DeusExItems.SniperRifle'
     PickupViewMesh=LodMesh'DeusExItems.SniperRiflePickup'
     ThirdPersonMesh=LodMesh'DeusExItems.SniperRifle3rd'
     LandSound=Sound'DeusExSounds.Generic.DropMediumWeapon'
     Icon=Texture'DeusExUI.Icons.BeltIconRifle'
     largeIcon=Texture'DeusExUI.Icons.LargeIconRifle'
     largeIconWidth=159
     largeIconHeight=47
     invSlotsX=4
     Description="The military sniper rifle is the superior tool for the interdiction of long-range targets. When coupled with the proven 30.06 round, a marksman can achieve tight groupings at better than 1 MOA (minute of angle) depending on environmental conditions."
     beltDescription="SNIPER"
     Mesh=LodMesh'DeusExItems.SniperRiflePickup'
     CollisionRadius=26.000000
     CollisionHeight=2.000000
     Mass=30.000000
}
