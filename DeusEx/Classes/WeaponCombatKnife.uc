//=============================================================================
// WeaponCombatKnife.
//=============================================================================
class WeaponCombatKnife extends DeusExWeapon;

defaultproperties
{
     LowAmmoWaterMark=0
     NoiseLevel=0.050000
     EnemyEffective=ENMEFF_Organic
     Concealability=CONC_Visual
     ShotTime=0.300000
     reloadTime=0.000000
     HitDamage=30
     maxRange=64
     BaseAccuracy=1.000000
     bHasMuzzleFlash=False
     bHandToHand=True
     bFallbackWeapon=True
     VM_HeadshotMult=6.000000
     VM_MoverDamageMult=0.200000
     VM_handsTexPos(0)=1
     AmmoName=Class'DeusEx.AmmoNone'
     ReloadCount=0
     bInstantHit=True
     FireOffset=(X=-5.000000,Y=8.000000,Z=14.000000)
     shakemag=20.000000
     FireSound=Sound'DeusExSounds.Weapons.CombatKnifeFire'
     SelectSound=Sound'DeusExSounds.Weapons.CombatKnifeSelect'
     Misc1Sound=Sound'DeusExSounds.Weapons.CombatKnifeHitFlesh'
     Misc2Sound=Sound'DeusExSounds.Weapons.CombatKnifeHitHard'
     Misc3Sound=Sound'DeusExSounds.Weapons.CombatKnifeHitSoft'
     InventoryGroup=11
     ItemName="Combat Knife"
     PlayerViewOffset=(X=5.000000,Y=-8.000000,Z=-14.000000)
     PlayerViewMesh=LodMesh'DeusExItems.CombatKnife'
     PickupViewMesh=LodMesh'DeusExItems.CombatKnifePickup'
     ThirdPersonMesh=LodMesh'DeusExItems.CombatKnife3rd'
     Icon=Texture'DeusExUI.Icons.BeltIconCombatKnife'
     largeIcon=Texture'DeusExUI.Icons.LargeIconCombatKnife'
     largeIconWidth=49
     largeIconHeight=45
     Description="An ultra-high carbon stainless steel knife."
     beltDescription="KNIFE"
     Mesh=LodMesh'DeusExItems.CombatKnifePickup'
     CollisionRadius=12.650000
     CollisionHeight=0.800000
}
