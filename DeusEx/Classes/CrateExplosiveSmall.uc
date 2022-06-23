//=============================================================================
// CrateExplosiveSmall.
//=============================================================================
class CrateExplosiveSmall extends Containers;

// Vanilla Matters
auto state Active {
     function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name DamageType) {
          if (DamageType == 'Fell') {
               Damage -= 10;
               if (Damage < 5) {
                    return;
               }
          }
          super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType);
     }
}

defaultproperties
{
     HitPoints=10
     bExplosive=True
     explosionDamage=300
     explosionRadius=800.000000
     ItemName="TNT Crate"
     bBlockSight=True
     Mesh=LodMesh'DeusExDeco.CrateExplosiveSmall'
     CollisionRadius=22.500000
     CollisionHeight=16.000000
     Mass=30.000000
     Buoyancy=40.000000
}
