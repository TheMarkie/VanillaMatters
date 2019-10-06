//=============================================================================
// TechGoggles.
//=============================================================================
class TechGoggles extends ChargedPickup;

// Vanilla Matters
var travel int VM_currentVisionLevel;               // Allow player to swap between night vision and infrared.

// ----------------------------------------------------------------------
// ChargedPickupBegin()
// ----------------------------------------------------------------------

function ChargedPickupBegin( DeusExPlayer Player ) {
    Super.ChargedPickupBegin( Player );

    UpdateHUDDisplay( Player );
}

// ----------------------------------------------------------------------
// UpdateHUDDisplay()
// ----------------------------------------------------------------------

// Vanilla Matters
function UpdateHUDDisplay( DeusExPlayer Player ) {
    local AugmentationDisplayWindow augWnd;

    augWnd = DeusExRootWindow( Player.rootWindow ).hud.augDisplay;

    augWnd.VM_visionLevels[0] = VM_currentVisionLevel;
    if ( VM_currentVisionLevel >= 3 ) {
        augWnd.VM_visionValues[0] = 320;
    }
    else {
        augWnd.VM_visionValues[0] = 0;
    }
}

// Vanilla Matters: Switch between night vision and infrared.
function ExtraFunction( DeusExPlayer player ) {
    local AugmentationDisplayWindow augWnd;
    local int level;

    if ( !bIsActive ) {
        return;
    }

    level = VM_currentVisionLevel;

    if ( VM_currentVisionLevel > 1 ) {
        VM_currentVisionLevel = 1;
    }
    else {
        VM_currentVisionLevel = FMax( player.SkillSystem.GetSkillLevel( class'SkillEnviro' ), 1 );
    }

    if ( level != VM_currentVisionLevel ) {
        PlaySound( ActivateSound, SLOT_None );
    }

    UpdateHUDDisplay( player );
}

// ----------------------------------------------------------------------
// ChargedPickupEnd()
// ----------------------------------------------------------------------

// Vanilla Matters
function ChargedPickupEnd( DeusExPlayer Player ) {
    local AugmentationDisplayWindow augWnd;

    augWnd = DeusExRootWindow( Player.rootWindow ).hud.augDisplay;

    Super.ChargedPickupEnd( Player );

    augWnd.VM_visionLevels[0] = 0;
    augWnd.VM_visionValues[0] = 0;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     VM_currentVisionLevel=1
     skillNeeded=Class'DeusEx.SkillEnviro'
     LoopSound=Sound'DeusExSounds.Pickup.TechGogglesLoop'
     ChargedIcon=Texture'DeusExUI.Icons.ChargedIconGoggles'
     ExpireMessage="TechGoggles power supply used up"
     ItemName="Tech Goggles"
     ItemArticle="some"
     PlayerViewOffset=(X=20.000000,Z=-6.000000)
     PlayerViewMesh=LodMesh'DeusExItems.GogglesIR'
     PickupViewMesh=LodMesh'DeusExItems.GogglesIR'
     ThirdPersonMesh=LodMesh'DeusExItems.GogglesIR'
     Charge=300
     LandSound=Sound'DeusExSounds.Generic.PaperHit2'
     Icon=Texture'DeusExUI.Icons.BeltIconTechGoggles'
     largeIcon=Texture'DeusExUI.Icons.LargeIconTechGoggles'
     largeIconWidth=49
     largeIconHeight=36
     Description="Tech goggles are used by many special ops forces throughout the world under a number of different brand names, but they all provide some form of portable light amplification.|n|n(Press Reload to switch between possible vision types)"
     beltDescription="GOGGLES"
     Mesh=LodMesh'DeusExItems.GogglesIR'
     CollisionRadius=8.000000
     CollisionHeight=2.800000
     Mass=10.000000
     Buoyancy=5.000000
}
