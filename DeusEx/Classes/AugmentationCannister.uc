//=============================================================================
// AugmentationCannister.
//=============================================================================
class AugmentationCannister extends DeusExPickup;

var() travel Name AddAugs[2];

var localized string AugsAvailable;
var localized string MustBeUsedOn;

// Vanilla Matters
var travel bool VM_augReplaced;

// ----------------------------------------------------------------------
// Network Replication
// ---------------------------------------------------------------------

replication
{
    //server to client variables
    reliable if ((Role == ROLE_Authority) && (bNetOwner))
        AddAugs;
}

// Vanilla Matters
function PostBeginPlay() {
    local int i;

    super.PostBeginPlay();

    if ( !VM_augReplaced ) {
        for( i = 0; i < ArrayCount( AddAugs ); i++ ) {
            switch ( AddAugs[i] ) {
                case 'AugAqualung':
                    AddAugs[i] = 'AugMed';
                    break;
                case 'AugHeartLung':
                    AddAugs[i] = 'AugEnhance';
                    break;
                case 'AugPower':
                    AddAugs[i] = 'AugDash';
                    break;
            }
        }
        VM_augReplaced = true;
    }
}

// ----------------------------------------------------------------------
// UpdateInfo()
// ----------------------------------------------------------------------
// Vanilla Matters
simulated function bool UpdateInfo( Object winObject ) {
    local Int canIndex;
    local PersonaInfoWindow winInfo;
    local class<VMAugmentation> aug;

    winInfo = PersonaInfoWindow( winObject );
    if ( winInfo == none ) {
        return false;
    }

    winInfo.Clear();
    winInfo.SetTitle( itemName );
    winInfo.SetText( Description );

    winInfo.AppendText( winInfo.CR() $ winInfo.CR() $ AugsAvailable );
    winInfo.AppendText( winInfo.CR() $ winInfo.CR() );

    for( canIndex = 0; canIndex < ArrayCount( AddAugs ); canIndex++ ) {
        if ( AddAugs[canIndex] != '' ) {
            aug = GetAugmentation( canIndex );
            if ( aug != none ) {
                winInfo.AppendText( aug.default.UpgradeName $ winInfo.CR() );
            }
        }
    }

    winInfo.AppendText( winInfo.CR() $ MustBeUsedOn );

    return true;
}

// ----------------------------------------------------------------------
// GetAugmentation()
// ----------------------------------------------------------------------
// Vanilla Matters
function class<VMAugmentation> GetAugmentation( int augIndex ) {
    return class<VMAugmentation>( DynamicLoadObject( "DeusEx." $ string( AddAugs[augIndex] ), class'Class' ) );
}

// ----------------------------------------------------------------------
// function SpawnCopy()
// DEUS_EX AMSD In multiplayer, it creates a copy (for respawning purposes) and gives
// THAT to the player.  The copy doesn't copy the augadd settings.  So
// we need to overwrite the spawncopy funciton here.
// ----------------------------------------------------------------------
function inventory SpawnCopy( pawn Other )
{
    local inventory Copy;
   local Int augIndex;
   local AugmentationCannister CopyCan;

    Copy = Super.SpawnCopy(Other);
   CopyCan = AugmentationCannister(Copy);
   for (augIndex = 0; augIndex < ArrayCount(Addaugs); augIndex++)
   {
      CopyCan.addAugs[augIndex] = addAugs[augIndex];
   }

}


auto state Pickup
{
// ----------------------------------------------------------------------
// function Frob()
// For autoinstalling in deathmatch, we need to overload frob here
// ----------------------------------------------------------------------
// Vanilla Matters MPTODO: Add multiplayer support for aug cannister install.
}
// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     AugsAvailable="Can Install:"
     MustBeUsedOn="Can only be installed with the help of a MedBot."
     ItemName="Augmentation Canister"
     ItemArticle="an"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DeusExItems.AugmentationCannister'
     PickupViewMesh=LodMesh'DeusExItems.AugmentationCannister'
     ThirdPersonMesh=LodMesh'DeusExItems.AugmentationCannister'
     LandSound=Sound'DeusExSounds.Generic.PlasticHit1'
     Icon=Texture'DeusExUI.Icons.BeltIconAugmentationCannister'
     largeIcon=Texture'DeusExUI.Icons.LargeIconAugmentationCannister'
     largeIconWidth=19
     largeIconHeight=49
     Description="An augmentation canister teems with nanoscale mechanocarbon ROM modules suspended in a carrier serum. When injected into a compatible host subject, these modules augment an individual with extra-sapient abilities. However, proper programming of augmentations must be conducted by a medical robot, otherwise terminal damage may occur. For more information, please see 'Face of the New Man' by Kelley Chance."
     beltDescription="AUG CAN"
     Mesh=LodMesh'DeusExItems.AugmentationCannister'
     CollisionRadius=4.310000
     CollisionHeight=10.240000
     Mass=10.000000
     Buoyancy=12.000000
}
