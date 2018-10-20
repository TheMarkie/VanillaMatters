//=============================================================================
// DartFlare.
//=============================================================================
class DartFlare extends Dart;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	if ( Level.NetMode != NM_Standalone )
		Damage = mpDamage;
}

// Vanilla Matters: Handle "injecting" into computers.
auto simulated state Flying {
	simulated function ProcessTouch( Actor other, vector hitLocation ) {
		local Computers comp;

		comp = Computers( other );
		if ( comp != none || ATM( other ) != none ) {
			if ( comp != none ) {
				comp.VM_injected = true;
			}

			other.Frob( Owner, none );
		}

		super.ProcessTouch( other, hitLocation );
	}
}

defaultproperties
{
     DamageType=EMP
     spawnAmmoClass=Class'DeusEx.AmmoDartFlare'
     ItemName="Injector Dart"
     Damage=15.000000
     VM_bOverridesDamage=True
}
