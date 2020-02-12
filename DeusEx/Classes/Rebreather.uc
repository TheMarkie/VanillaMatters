//=============================================================================
// Rebreather.
//=============================================================================
class Rebreather extends ChargedPickup;

// Vanilla Matters
var travel DeusExPlayer VM_player;
var travel float VM_breathTimer;

// Vanilla Matters: We handle it in Tick so we can properly sync the breath provided with the breathing loop sound.
function Tick( float deltaTime ) {
    if ( VM_player == none || !IsActive() ) {
        return;
    }

    VM_breathTimer = VM_breathTimer + deltaTime;
    // VM: All the values are arbitrary timestamps of the "breathing" segment on the specific sound loop.
    if ( VM_breathTimer >= 0.15 && VM_breathTimer <= 1.5 ) {
        VM_player.swimTimer = FClamp( VM_player.swimTimer + ( deltaTime * 3.5 ), 0, VM_player.swimDuration );
    }

    if ( VM_breathTimer >= 2.785 ) {
        VM_breathTimer = VM_breathTimer - 2.785;
    }
}

function ChargedPickupBegin( DeusExPlayer player ) {
    VM_player = player;
    VM_breathTimer = 0;

    super.ChargedPickupBegin( player );
}

function ChargedPickupEnd( DeusExPlayer player ) {
    VM_player = none;
    VM_breathTimer = 0;

    super.ChargedPickupEnd( player );
}

defaultproperties
{
     skillNeeded=Class'DeusEx.SkillEnviro'
     LoopSound=Sound'DeusExSounds.Pickup.RebreatherLoop'
     ChargedIcon=Texture'DeusExUI.Icons.ChargedIconRebreather'
     ExpireMessage="Rebreather power supply used up"
     ItemName="Rebreather"
     PlayerViewOffset=(X=30.000000,Z=-6.000000)
     PlayerViewMesh=LodMesh'DeusExItems.Rebreather'
     PickupViewMesh=LodMesh'DeusExItems.Rebreather'
     ThirdPersonMesh=LodMesh'DeusExItems.Rebreather'
     Charge=300
     LandSound=Sound'DeusExSounds.Generic.PaperHit2'
     Icon=Texture'DeusExUI.Icons.BeltIconRebreather'
     largeIcon=Texture'DeusExUI.Icons.LargeIconRebreather'
     largeIconWidth=44
     largeIconHeight=34
     Description="A disposable chemical scrubber that can extract oxygen from water during brief submerged operations."
     beltDescription="REBREATHR"
     Mesh=LodMesh'DeusExItems.Rebreather'
     CollisionRadius=6.900000
     CollisionHeight=3.610000
     Mass=10.000000
     Buoyancy=8.000000
}
