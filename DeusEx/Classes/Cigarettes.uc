//=============================================================================
// Cigarettes.
//=============================================================================
class Cigarettes extends DeusExPickup;

// Vanilla Matters
var travel int timesPuffed;     // Check for how many times the smoke puff has appeared.
var travel Actor user;          // The pawn who used this because we're gonna make it disappear.

var localized string VM_msgCantSmoke;

state Activated
{
    function Activate()
    {
        // can't turn it off
    }

    // Vanilla Matters: Make the smoke puff appear over time and do damage.
    function Timer() {
        local Pawn P;
        local DeusExPlayer player;

        local vector loc, dir;
        local SmokeTrail puff;

        P = Pawn( user );
        player = DeusExPlayer( user );

        if ( P != None ) {
            if ( ( player != None && ( player.HeadRegion.Zone.bWaterZone || player.UsingChargedPickup( class'Rebreather' ) ) ) || timesPuffed >= 9 ) {
                SetTimer( 3.0, false );

                bActive = false;

                if ( NumCopies <= 0 ) {
                    Destroy();
                }
                else {
                    UpdateBeltText();
                }
            }

            dir = Vector( P.ViewRotation );
            loc = user.Location;
            loc += 0.9 * user.CollisionRadius * dir;
            loc.Z += user.CollisionHeight * 0.8;
            puff = Spawn( class'SmokeTrail', user,, loc, user.Rotation );

            if (puff != None)
            {
                puff.DrawScale = 0.4;
                puff.origScale = puff.DrawScale;
                puff.VM_Velocity = dir * 20;
            }

            if ( timesPuffed % 2 == 0 ) {
                P.TakeDamage( 2, P, P.Location, vect( 0,0,0 ), 'PoisonGas' );
            }

            timesPuffed = timesPuffed + 1;
        }
    }

    function BeginState() {
        local DeusExPlayer player;

        user = Owner;

        player = DeusExPlayer( Owner );

        if ( player != None ) {
            // VM: Prevent smoking while swimming or using Rebreather.
            if ( player.HeadRegion.Zone.bWaterZone || player.UsingChargedPickup( class'Rebreather' ) ) {
                player.ClientMessage( VM_msgCantSmoke );

                user = None;

                Super.Activate();

                return;
            }

            Super.BeginState();

            timesPuffed = 0;

            bActive = true;

            SetTimer( 3.0, true );

            NumCopies = NumCopies - 1;
            if ( NumCopies <= 0 ) {
                player.DeleteInventory( self );

                if ( player.IsHolding( self ) ) {
                    player.ClearHold();
                }
            }
        }
    }
Begin:
}

defaultproperties
{
     VM_msgCantSmoke="You cannot smoke right now"
     maxCopies=20
     bCanHaveMultipleCopies=True
     bActivatable=True
     ItemName="Cigarettes"
     ItemArticle="some"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DeusExItems.Cigarettes'
     PickupViewMesh=LodMesh'DeusExItems.Cigarettes'
     ThirdPersonMesh=LodMesh'DeusExItems.Cigarettes'
     Icon=Texture'DeusExUI.Icons.BeltIconCigarettes'
     largeIcon=Texture'DeusExUI.Icons.LargeIconCigarettes'
     largeIconWidth=29
     largeIconHeight=43
     Description="'COUGHING NAILS -- when you've just got to have a cigarette.'"
     beltDescription="CIGS"
     Mesh=LodMesh'DeusExItems.Cigarettes'
     CollisionRadius=5.200000
     CollisionHeight=1.320000
     Mass=2.000000
     Buoyancy=3.000000
}
