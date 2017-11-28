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
     VM_overridesDamage=True
     mpDamage=10.000000
     Damage=8.000000
}
