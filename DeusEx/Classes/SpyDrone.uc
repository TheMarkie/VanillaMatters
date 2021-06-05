//=============================================================================
// SpyDrone.
//=============================================================================
class SpyDrone extends Actor;

var float Speed;

defaultproperties
{
     Physics=PHYS_Projectile
     bDirectional=True
     DrawType=DT_Mesh
     Mesh=LodMesh'DeusExCharacters.SpyDrone'
     DrawScale=0.100000
     SoundRadius=24
     SoundVolume=192
     CollisionRadius=1.000000
     CollisionHeight=1.000000
     bCollideActors=True
     bCollideWorld=True
     Mass=10.000000
     Buoyancy=2.000000
}
