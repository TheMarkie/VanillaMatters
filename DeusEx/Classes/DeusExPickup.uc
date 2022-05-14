//=============================================================================
// DeusExPickup.
//=============================================================================
class DeusExPickup extends Pickup
    abstract;

var bool            bBreakable;     // true if we can destroy this item
var class<Fragment> fragType;       // fragments created when pickup is destroyed
var int             maxCopies;      // 0 means unlimited copies

var localized String CountLabel;
var localized String msgTooMany;

// Vanilla Matters
var Texture     VM_handsTex;                        // Hands texture.
var int         VM_handsTexPos[2];                  // Positions in the MultiSkins where they use WeaponHandsTex, so we can replace those.

// ----------------------------------------------------------------------
// Networking Replication
// ----------------------------------------------------------------------

replication
{
   //client to server function
   reliable if ((Role < ROLE_Authority) && (bNetOwner))
      UseOnce;
}

// Vanilla Matters: Override to add in colored hands skin.
simulated function RenderOverlays( Canvas canvas ) {
    local bool changed;
    local int i;
    local DeusExPlayer player;

    if ( Mesh == PlayerViewMesh ) {
        if ( VM_handsTex == none ) {
            player = DeusExPlayer( Owner );
            if ( player != none ) {
                VM_handsTex = player.GetHandsSkin();
            }
        }

        for ( i = 0; i < 2; i++ ) {
            if ( VM_handsTexPos[i] >= 0 ) {
                MultiSkins[VM_handsTexPos[i]] = VM_handsTex;
                changed = true;
            }
        }
    }

    super.RenderOverlays( canvas );

    if ( changed ) {
        for ( i = 0; i < 2; i++ ) {
            if ( VM_handsTexPos[i] >= 0 ) {
                MultiSkins[VM_handsTexPos[i]] = none;
            }
        }
    }
}

// ----------------------------------------------------------------------
// HandlePickupQuery()
//
// If the bCanHaveMultipleCopies variable is set to True, then we want
// to stack items of this type in the player's inventory.
// ----------------------------------------------------------------------

function bool HandlePickupQuery( inventory Item )
{
    local DeusExPlayer player;
    local Inventory anItem;
    local Bool bAlreadyHas;
    local Bool bResult;

    if ( Item.Class == Class )
    {
        player = DeusExPlayer(Owner);
        bResult = False;

        // Check to see if the player already has one of these in
        // his inventory
        anItem = player.FindInventoryType(Item.Class);

        if ((anItem != None) && (bCanHaveMultipleCopies))
        {
            // don't actually put it in the hand, just add it to the count

            // Vanilla Matters: Let the player fill up the stack and allows a chance to quick use the remaining copies.
            NumCopies = NumCopies + DeusExPickup( item ).NumCopies;
            if ( MaxCopies > 0 && NumCopies > MaxCopies ) {
                player.ClientMessage(msgTooMany);

                DeusExPickup( Item ).NumCopies = FMin( NumCopies - MaxCopies, DeusExPickup( Item ).NumCopies );
                NumCopies = MaxCopies;

                UpdateBeltText();

                return true;
            }

            bResult = True;
        }

        if (bResult)
        {
            player.ClientMessage(Item.PickupMessage @ Item.itemArticle @ Item.itemName, 'Pickup');

            // Destroy me!
         // DEUS_EX AMSD In multiplayer, we don't want to destroy the item, we want it to set to respawn
         if (Level.NetMode != NM_Standalone)
            Item.SetRespawn();
         else
            Item.Destroy();
        }
        else
        {
            bResult = Super.HandlePickupQuery(Item);
        }

        // Update object belt text
        if (bResult)
            UpdateBeltText();

        return bResult;
    }

    if ( Inventory == None )
        return false;

    return Inventory.HandlePickupQuery(Item);
}

// ----------------------------------------------------------------------
// UseOnce()
//
// Subtract a use, then destroy if out of uses
// ----------------------------------------------------------------------

function UseOnce()
{
    local DeusExPlayer player;

    player = DeusExPlayer(Owner);
    NumCopies--;

    if (!IsA('SkilledTool'))
        GotoState('DeActivated');

    if (NumCopies <= 0)
    {
        // Vanilla Matters: Clear HeldInHand then makes the pickup destroy itself.
        if ( player.IsHolding( self ) ) {
            player.ClearHold();
        }

        Destroy();
    }
    else
    {
        UpdateBeltText();
    }
}

// ----------------------------------------------------------------------
// UpdateBeltText()
// ----------------------------------------------------------------------

function UpdateBeltText()
{
    local DeusExRootWindow root;

    if (DeusExPlayer(Owner) != None)
    {
        root = DeusExRootWindow(DeusExPlayer(Owner).rootWindow);

        // Update object belt text
        if ((bInObjectBelt) && (root != None) && (root.hud != None) && (root.hud.belt != None))
            root.hud.belt.UpdateObjectText(beltPos);
    }
}

// ----------------------------------------------------------------------
// BreakItSmashIt()
// ----------------------------------------------------------------------

simulated function BreakItSmashIt(class<fragment> FragType, float size)
{
    local int i;
    local DeusExFragment s;

    for (i=0; i<Int(size); i++)
    {
        s = DeusExFragment(Spawn(FragType, Owner));
        if (s != None)
        {
            s.Instigator = Instigator;
            s.CalcVelocity(Velocity,0);
            s.DrawScale = ((FRand() * 0.05) + 0.05) * size;
            s.Skin = GetMeshTexture();

            // play a good breaking sound for the first fragment
            if (i == 0)
                s.PlaySound(sound'GlassBreakSmall', SLOT_None,,, 768);
        }
    }

    Destroy();
}

singular function BaseChange()
{
    Super.BaseChange();

    // Make sure we fall if we don't have a base
    if ((base == None) && (Owner == None))
        SetPhysics(PHYS_Falling);
}

// ----------------------------------------------------------------------
// state Pickup
// ----------------------------------------------------------------------

auto state Pickup
{
    // if we hit the ground fast enough, break it, smash it!!!
    function Landed(Vector HitNormal)
    {
        Super.Landed(HitNormal);

        if (bBreakable)
            if (VSize(Velocity) > 400)
                BreakItSmashIt(fragType, (CollisionRadius + CollisionHeight) / 2);
    }

    // Vanilla Matters: Reset hand skins.
    function BeginState() {
        local int i;

        for ( i = 0; i < 2; i++ ) {
            if ( VM_handsTexPos[i] >= 0 ) {
                MultiSkins[VM_handsTexPos[i]] = none;
            }
        }

        Super.BeginState();
    }
}

state DeActivated
{
}

// ----------------------------------------------------------------------
// UpdateInfo()
// ----------------------------------------------------------------------

simulated function bool UpdateInfo(Object winObject)
{
    local PersonaInfoWindow winInfo;
    local string str;

    winInfo = PersonaInfoWindow(winObject);
    if (winInfo == None)
        return False;

    winInfo.SetTitle(itemName);
    winInfo.SetText(Description $ winInfo.CR() $ winInfo.CR());

    if (bCanHaveMultipleCopies)
    {
        // Print the number of copies
        // Vanilla Matters
        str = CountLabel @ NumCopies @ "/" @ maxCopies;
        winInfo.AppendText(str);
    }

    return True;
}

// ----------------------------------------------------------------------
// PlayLandingSound()
// ----------------------------------------------------------------------

function PlayLandingSound()
{
    if (LandSound != None)
    {
        if (Velocity.Z <= -200)
        {
            PlaySound(LandSound, SLOT_None, TransientSoundVolume,, 768);
            AISendEvent('LoudNoise', EAITYPE_Audio, TransientSoundVolume, 768);
        }
    }
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     FragType=Class'DeusEx.GlassFragment'
     CountLabel="COUNT:"
     msgTooMany="You can't carry any more of those"
     VM_handsTexPos(0)=-1
     VM_handsTexPos(1)=-1
     NumCopies=1
     PickupMessage="You found"
     ItemName="DEFAULT PICKUP NAME - REPORT THIS AS A BUG"
     RespawnTime=30.000000
     LandSound=Sound'DeusExSounds.Generic.PaperHit1'
}
