class AugEMPProjectile extends DeusExProjectile;

#exec OBJ LOAD FILE=Effects

simulated function Tick(float deltaTime) {
    local float distance;

    distance = Abs(VSize(initLoc - Location));
    if (distance > MaxRange) {
        Destroy();
        return;
    }

    super.Tick(deltaTime);
}

defaultproperties
{
     damageType=Stunned
     MaxRange=400
     bIgnoresNanoDefense=True
     speed=1600.000000
     MaxSpeed=1600.000000
     Damage=10.000000
     Style=STY_Translucent
     Mesh=LodMesh'DeusExItems.PlasmaBolt'
     Skin=FireTexture'Effects.Electricity.Nano_SFX'
     bUnlit=true
     DrawScale=0.200000
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightBrightness=200
     LightHue=255
     LightSaturation=255
     LightRadius=1
     bFixedRotationDir=True
}
