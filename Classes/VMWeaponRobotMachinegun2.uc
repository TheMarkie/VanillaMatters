//=============================================================================
// VMWeaponRobotMachinegun2
//=============================================================================
class VMWeaponRobotMachinegun2 extends WeaponRobotMachinegun;

// Vanilla Matters: Override Fire to swap gun locations.
function Fire( float value ) {
    FireOffset.Y = - FireOffset.Y;

    super.Fire( value );
}

defaultproperties
{
     bHasMuzzleFlash=True
     FireOffset=(X=28.000000,Y=-16.000000,Z=-7.000000)
}
