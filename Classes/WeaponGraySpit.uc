//=============================================================================
// WeaponGraySpit.
//=============================================================================
class WeaponGraySpit extends WeaponNPCRanged;

defaultproperties
{
     HitDamage=15
     maxRange=450
     AccurateRange=300
     AreaOfEffect=AOE_Cone
     bHandToHand=True
     VM_ShotCount(0)=3
     VM_ShotCount(1)=3
     VM_ShotCount(2)=3
     VM_ShotCount(3)=3
     AmmoName=Class'DeusEx.AmmoGraySpit'
     PickupAmmoCount=4
     ProjectileClass=Class'DeusEx.GraySpit'
}
