//=============================================================================
// WeaponMiniCrossbow.
//=============================================================================
class WeaponMiniCrossbow extends DeusExWeapon;

// pinkmask out the arrow when we're out of ammo or the clip is empty
state NormalFire
{
    function BeginState()
    {
        if (ClipCount >= ReloadCount)
            MultiSkins[3] = Texture'PinkMaskTex';

        if ((AmmoType != None) && (AmmoType.AmmoAmount <= 0))
            MultiSkins[3] = Texture'PinkMaskTex';

        Super.BeginState();
    }
}

// unpinkmask the arrow when we reload
function Tick(float deltaTime)
{
    if (MultiSkins[3] != None)
        if ((AmmoType != None) && (AmmoType.AmmoAmount > 0) && (ClipCount < ReloadCount))
            MultiSkins[3] = None;

    Super.Tick(deltaTime);
}

defaultproperties
{
     LowAmmoWaterMark=4
     GoverningSkill=Class'DeusEx.SkillWeaponRifle'
     NoiseLevel=0.050000
     EnemyEffective=ENMEFF_Organic
     Concealability=CONC_All
     ShotTime=0.800000
     reloadTime=2.000000
     HitDamage=30
     maxRange=2400
     AccurateRange=1200
     BaseAccuracy=0.750000
     bCanHaveScope=True
     ScopeFOV=15
     bCanHaveLaser=True
     bHasSilencer=True
     AmmoNames(0)=Class'DeusEx.AmmoDartPoison'
     AmmoNames(1)=Class'DeusEx.AmmoDart'
     AmmoNames(2)=Class'DeusEx.AmmoDartFlare'
     ProjectileNames(0)=Class'DeusEx.DartPoison'
     ProjectileNames(1)=Class'DeusEx.Dart'
     ProjectileNames(2)=Class'DeusEx.DartFlare'
     StunDuration=10.000000
     bHasMuzzleFlash=False
     bCanHaveModBaseAccuracy=True
     bCanHaveModReloadTime=True
     VM_HeadshotMult=5.000000
     VM_handsTexPos(0)=0
     AmmoName=Class'DeusEx.AmmoDartPoison'
     ReloadCount=4
     PickupAmmoCount=4
     FireOffset=(X=-25.000000,Y=8.000000,Z=14.000000)
     ProjectileClass=Class'DeusEx.DartPoison'
     shakemag=30.000000
     FireSound=Sound'DeusExSounds.Weapons.MiniCrossbowFire'
     AltFireSound=Sound'DeusExSounds.Weapons.MiniCrossbowReloadEnd'
     CockingSound=Sound'DeusExSounds.Weapons.MiniCrossbowReload'
     SelectSound=Sound'DeusExSounds.Weapons.MiniCrossbowSelect'
     InventoryGroup=9
     ItemName="Mini-Crossbow"
     PlayerViewOffset=(X=25.000000,Y=-8.000000,Z=-14.000000)
     PlayerViewMesh=LodMesh'DeusExItems.MiniCrossbow'
     PickupViewMesh=LodMesh'DeusExItems.MiniCrossbowPickup'
     ThirdPersonMesh=LodMesh'DeusExItems.MiniCrossbow3rd'
     Icon=Texture'DeusExUI.Icons.BeltIconCrossbow'
     largeIcon=Texture'DeusExUI.Icons.LargeIconCrossbow'
     largeIconWidth=47
     largeIconHeight=46
     Description="The mini-crossbow was specifically developed for espionage work, and accepts a range of dart types (normal, tranquilizer, or flare) that can be changed depending upon the mission requirements."
     beltDescription="CROSSBOW"
     Mesh=LodMesh'DeusExItems.MiniCrossbowPickup'
     CollisionRadius=8.000000
     CollisionHeight=1.000000
     Mass=15.000000
}
