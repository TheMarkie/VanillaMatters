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
     VM_ShotCount=3
     AmmoName=Class'DeusEx.AmmoGraySpit'
     PickupAmmoCount=4
     ProjectileClass=Class'DeusEx.GraySpit'
}
