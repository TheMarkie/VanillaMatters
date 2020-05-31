//=============================================================================
// WeaponShuriken.
//=============================================================================
class WeaponShuriken extends DeusExWeapon;

defaultproperties
{
     LowAmmoWaterMark=5
     GoverningSkill=Class'DeusEx.SkillWeaponLowTech'
     NoiseLevel=0.050000
     EnemyEffective=ENMEFF_Organic
     EnviroEffective=ENVEFF_AirVacuum
     Concealability=CONC_Visual
     ShotTime=0.200000
     reloadTime=0.200000
     HitDamage=40
     maxRange=1280
     AccurateRange=640
     BaseAccuracy=0.600000
     bHasMuzzleFlash=False
     bHandToHand=True
     VM_handsTexPos(0)=0
     VM_handsTexPos(1)=1
     AmmoName=Class'DeusEx.AmmoShuriken'
     ReloadCount=1
     PickupAmmoCount=5
     FireOffset=(X=-10.000000,Y=14.000000,Z=22.000000)
     ProjectileClass=Class'DeusEx.Shuriken'
     shakemag=5.000000
     InventoryGroup=12
     ItemName="Throwing Knives"
     ItemArticle="some"
     PlayerViewOffset=(X=24.000000,Y=-12.000000,Z=-21.000000)
     PlayerViewMesh=LodMesh'DeusExItems.Shuriken'
     PickupViewMesh=LodMesh'DeusExItems.ShurikenPickup'
     ThirdPersonMesh=LodMesh'DeusExItems.Shuriken3rd'
     Icon=Texture'DeusExUI.Icons.BeltIconShuriken'
     largeIcon=Texture'DeusExUI.Icons.LargeIconShuriken'
     largeIconWidth=36
     largeIconHeight=45
     Description="A favorite weapon of assassins in the Far East for centuries, throwing knives can be deadly when wielded by a master but are more generally used when it becomes desirable to send a message. The message is usually 'Your death is coming on swift feet.'"
     beltDescription="THW KNIFE"
     Texture=Texture'DeusExItems.Skins.ReflectionMapTex1'
     Mesh=LodMesh'DeusExItems.ShurikenPickup'
     CollisionRadius=7.500000
     CollisionHeight=0.300000
}
