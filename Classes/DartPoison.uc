//=============================================================================
// DartPoison.
//=============================================================================
class DartPoison extends Dart;

//var float mpDamage;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	if ( Level.NetMode != NM_Standalone )
		Damage = mpDamage;
}

defaultproperties
{
     DamageType=Poison
     spawnAmmoClass=Class'DeusEx.AmmoDartPoison'
     ItemName="Tranquilizer Dart"
     VM_bOverridesDamage=True
     mpDamage=10.000000
     Damage=10.000000
}
