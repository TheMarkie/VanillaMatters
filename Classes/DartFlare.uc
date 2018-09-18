//=============================================================================
// DartFlare.
//=============================================================================
class DartFlare extends Dart;

//var float mpDamage;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	if ( Level.NetMode != NM_Standalone )
		Damage = mpDamage;
}

defaultproperties
{
     DamageType=Burned
     spawnAmmoClass=Class'DeusEx.AmmoDartFlare'
     ItemName="Flare Dart"
     bUnlit=True
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightBrightness=255
     LightHue=16
     LightSaturation=192
     LightRadius=4
     Damage=50.000000
}
