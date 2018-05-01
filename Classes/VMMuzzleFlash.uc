//=============================================================================
// VMMuzzleFlash
//=============================================================================
class VMMuzzleFlash extends Effects;

var vector FireOffset;

function Spawned() {
	FlipFlashTexture();
}

function FlipFlashTexture() {
	if ( FRand() < 0.5 ) {
		Skin = Texture'FlatFXTex34';
	}
	else {
		Skin = Texture'FlatFXTex37';
	}
}

defaultproperties
{
     LifeSpan=0.100000
     DrawType=DT_Mesh
     Style=STY_Translucent
     Skin=Texture'FlatFXTex34'
     Mesh=LodMesh'DeusExItems.FlatFX'
     DrawScale=0.400000
     ScaleGlow=2.000000
     bUnlit=True
}
