//=============================================================================
// VMWeaponRobotMachinegun
//=============================================================================
class VMWeaponRobotMachinegun extends WeaponRobotMachinegun;

// Vanilla Matters: Override Fire to swap gun locations.
function Fire( float value ) {
	if ( FRand() > 0.5 ) {
		FireOffset.Y = - FireOffset.Y;
	}

	if ( FRand() > 0.5 ) {
		if ( FireOffset.Z == default.FireOffset.Z ) {
			FireOffset.Z = FireOffset.Z - 14;
		}
		else {
			FireOffset.Z = default.FireOffset.Z;
		}
	}

	super.Fire( value );
}

defaultproperties
{
     bHasMuzzleFlash=True
     FireOffset=(X=24.000000,Y=-13.000000,Z=20.000000)
}
