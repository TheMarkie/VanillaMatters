//=============================================================================
// WeaponSawedOffShotgun.
//=============================================================================
class WeaponSawedOffShotgun extends DeusExWeapon;

defaultproperties
{
     LowAmmoWaterMark=4
     GoverningSkill=Class'DeusEx.SkillWeaponPistol'
     EnviroEffective=ENVEFF_Air
     Concealability=CONC_Visual
     reloadTime=0.400000
     maxRange=2400
     AccurateRange=1200
     BaseAccuracy=0.650000
     AmmoNames(0)=Class'DeusEx.AmmoShell'
     AmmoNames(1)=Class'DeusEx.AmmoSabot'
     AreaOfEffect=AOE_Cone
     recoilStrength=0.400000
     VM_spreadStrength=0.400000
     bCanHaveModReloadCount=True
     bCanHaveModReloadTime=True
     bCanHaveModRecoilStrength=True
     VM_pumpAction=True
     VM_ShotCount=6
     VM_handsTexPos(0)=0
     VM_handsTexPos(1)=3
     AmmoName=Class'DeusEx.AmmoShell'
     ReloadCount=4
     PickupAmmoCount=4
     bInstantHit=True
     FireOffset=(X=-11.000000,Y=4.000000,Z=13.000000)
     shakemag=50.000000
     FireSound=Sound'DeusExSounds.Weapons.SawedOffShotgunFire'
     AltFireSound=Sound'DeusExSounds.Weapons.SawedOffShotgunReloadEnd'
     CockingSound=Sound'DeusExSounds.Weapons.SawedOffShotgunReload'
     SelectSound=Sound'DeusExSounds.Weapons.SawedOffShotgunSelect'
     InventoryGroup=6
     ItemName="Sawed-off Shotgun"
     PlayerViewOffset=(X=11.000000,Y=-4.000000,Z=-13.000000)
     PlayerViewMesh=LodMesh'DeusExItems.Shotgun'
     PickupViewMesh=LodMesh'DeusExItems.ShotgunPickup'
     ThirdPersonMesh=LodMesh'DeusExItems.Shotgun3rd'
     LandSound=Sound'DeusExSounds.Generic.DropMediumWeapon'
     Icon=Texture'DeusExUI.Icons.BeltIconShotgun'
     largeIcon=Texture'DeusExUI.Icons.LargeIconShotgun'
     largeIconWidth=131
     largeIconHeight=45
     invSlotsX=3
     Description="The sawed-off, pump-action shotgun features a truncated barrel resulting in a wide spread at close range and will accept either buckshot or sabot shells."
     beltDescription="SAWED-OFF"
     Mesh=LodMesh'DeusExItems.ShotgunPickup'
     CollisionRadius=12.000000
     CollisionHeight=0.900000
     Mass=15.000000
}
