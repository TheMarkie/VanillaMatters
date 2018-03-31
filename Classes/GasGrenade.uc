//=============================================================================
// GasGrenade.
//=============================================================================
class GasGrenade extends ThrownProjectile;

var float	mpBlastRadius;
var float	mpProxRadius;
//var float	mpGasDamage;
var float	mpFuselength;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	if ( Level.NetMode != NM_Standalone )
	{
		blastRadius=mpBlastRadius;
		proxRadius=mpProxRadius;
		//Damage=mpGasDamage;
		// Vanilla Matters: Make mpDamage have a consistent name.
		Damage = mpDamage;
		fuseLength=mpFuseLength;
		bIgnoresNanoDefense=True;
	}
}

defaultproperties
{
     mpBlastRadius=512.000000
     mpProxRadius=128.000000
     mpFuselength=1.500000
     fuseLength=3.000000
     proxRadius=128.000000
     AISoundLevel=0.000000
     bBlood=False
     bDebris=False
     DamageType=TearGas
     spawnWeaponClass=Class'DeusEx.WeaponGasGrenade'
     ItemName="Gas Grenade"
     VM_bOverridesDamage=True
     mpDamage=20.000000
     speed=1000.000000
     MaxSpeed=1000.000000
     Damage=10.000000
     MomentumTransfer=50000
     ImpactSound=Sound'DeusExSounds.Weapons.GasGrenadeExplode'
     LifeSpan=0.000000
     Mesh=LodMesh'DeusExItems.GasGrenadePickup'
     CollisionRadius=4.300000
     CollisionHeight=1.400000
     Mass=5.000000
     Buoyancy=2.000000
}
