//=============================================================================
// DeusExCarcass.
//=============================================================================
class DeusExCarcass extends Carcass;

struct InventoryItemCarcass  {
    var() class<Inventory> Inventory;
    var() int              count;
};

var(Display) mesh Mesh2;        // mesh for secondary carcass
var(Display) mesh Mesh3;        // mesh for floating carcass
var(Inventory) InventoryItemCarcass InitialInventory[8];  // Initial inventory items held in the carcass
var() bool bHighlight;

var String          KillerBindName;     // what was the bind name of whoever killed me?
var Name            KillerAlliance;     // what alliance killed me?
var bool            bGenerateFlies;     // should we make flies?
var FlyGenerator    flyGen;
var Name            Alliance;           // this body's alliance
var Name            CarcassName;        // original name of carcass
var int             MaxDamage;          // maximum amount of cumulative damage
var bool            bNotDead;           // this body is just unconscious
var() bool          bEmitCarcass;       // make other NPCs aware of this body
var bool            bQueuedDestroy; // For multiplayer, semaphore so you can't doublefrob bodies (since destroy is latent)

var bool            bInit;

// Used for Received Items window
var bool bSearchMsgPrinted;

var localized string msgSearching;
var localized string msgEmpty;
var localized string msgNotDead;
var localized string msgAnimalCarcass;
var localized string msgCannotPickup;
var localized String msgRecharged;
var localized string itemName;          // human readable name

var() bool bInvincible;
var bool bAnimalCarcass;

// Vanilla Matters
var travel string VM_name;

var travel bool VM_bSearchedOnce;       // Has the player searched this body at least once?

var travel float VM_drownTimer;             // Time we've been drowning if we're in the water.

var localized string VM_msgDrowned;
var localized String VM_msgNoAmmo;

// ----------------------------------------------------------------------
// InitFor()
// ----------------------------------------------------------------------

function InitFor(Actor Other)
{
    // Vanilla Matters
    local ScriptedPawn sp;
    local DeusExPlayer player;

    player = DeusExPlayer( GetPlayerPawn() );

    if (Other != None)
    {
        // Vanilla Matters: Record the name in case we switch body state and need to redo the name string.
        VM_name = player.GetDisplayName( Other );

        // set as unconscious or add the pawns name to the description
        if (!bAnimalCarcass)
        {
            // Vanilla Matters
            if ( bNotDead ) {
                itemName = msgNotDead;
            }

            // Vanilla Matters: Flip the order, we now display name first then concious state in brackets.
            itemName = VM_name @ "(" $ itemName $ ")";
        }

        Mass           = Other.Mass;
        Buoyancy       = Mass * 1.2;
        MaxDamage      = 0.8*Mass;
        if (ScriptedPawn(Other) != None)
            if (ScriptedPawn(Other).bBurnedToDeath)
                CumulativeDamage = MaxDamage-1;

        SetScaleGlow();

        // Will this carcass spawn flies?
        if (bAnimalCarcass)
        {
            itemName = msgAnimalCarcass;
            if (FRand() < 0.2)
                bGenerateFlies = true;
        }
        else if (!Other.IsA('Robot') && !bNotDead)
        {
            if (FRand() < 0.1)
                bGenerateFlies = true;
        }

        // Vanilla Matters: Unconcious bodies should still provoke people.
        bEmitCarcass = !bAnimalCarcass;

        if (Other.AnimSequence == 'DeathFront')
            Mesh = Mesh2;

        // set the instigator and tag information
        if (Other.Instigator != None)
        {
            KillerBindName = Other.Instigator.BindName;
            KillerAlliance = Other.Instigator.Alliance;
        }
        else
        {
            KillerBindName = Other.BindName;
            KillerAlliance = '';
        }
        Tag = Other.Tag;
        Alliance = Pawn(Other).Alliance;
        CarcassName = Other.Name;
    }
}

// ----------------------------------------------------------------------
// PostBeginPlay()
// ----------------------------------------------------------------------

function PostBeginPlay()
{
    local int i, j;
    local Inventory inv;

    bCollideWorld = true;

    // Use the carcass name by default
    CarcassName = Name;

    // Add initial inventory items
    for (i=0; i<8; i++)
    {
        if ((InitialInventory[i].inventory != None) && (InitialInventory[i].count > 0))
        {
            for (j=0; j<InitialInventory[i].count; j++)
            {
                inv = spawn(InitialInventory[i].inventory, self);
                if (inv != None)
                {
                    inv.bHidden = True;
                    inv.SetPhysics(PHYS_None);
                    AddInventory(inv);
                }
            }
        }
    }

    // use the correct mesh
    if (Region.Zone.bWaterZone)
    {
        Mesh = Mesh3;
        bNotDead = False;       // you will die in water every time
    }

    if (bAnimalCarcass)
        itemName = msgAnimalCarcass;

    MaxDamage = 0.8*Mass;
    SetScaleGlow();

    SetTimer(30.0, False);

    Super.PostBeginPlay();
}

// ----------------------------------------------------------------------
// ZoneChange()
// ----------------------------------------------------------------------

function ZoneChange(ZoneInfo NewZone)
{
    Super.ZoneChange(NewZone);

    // use the correct mesh for water
    if (NewZone.bWaterZone)
        Mesh = Mesh3;
}

// ----------------------------------------------------------------------
// Destroyed()
// ----------------------------------------------------------------------

function Destroyed()
{
    if (flyGen != None)
    {
        flyGen.StopGenerator();
        flyGen = None;
    }

    Super.Destroyed();
}

// ----------------------------------------------------------------------
// Tick()
// ----------------------------------------------------------------------

function Tick(float deltaSeconds)
{
    if (!bInit)
    {
        bInit = true;
        if (bEmitCarcass)
            AIStartEvent('Carcass', EAITYPE_Visual);
    }
    Super.Tick(deltaSeconds);

    // Vanilla Matters: Start drowning and eventually die if we land in the water.
    if ( bNotDead ) {
        if ( Region.Zone.bWaterZone ) {
            VM_drownTimer = VM_drownTimer + deltaSeconds;
            if ( VM_drownTimer >= 5 ) {
                bNotDead = false;

                if ( !bAnimalCarcass ) {
                    itemName = VM_name @ "(" $ VM_msgDrowned $ ")";
                }

                if ( FRand() < 0.1 ) {
                    bGenerateFlies = true;
                }
            }
        }
        else {
            // VM: Recover but very slow out of water.
            VM_drownTimer = FMax( VM_drownTimer - ( deltaSeconds * 0.2 ), 0 );
        }
    }
}

// ----------------------------------------------------------------------
// Timer()
// ----------------------------------------------------------------------

function Timer()
{
    if (bGenerateFlies)
    {
        flyGen = Spawn(Class'FlyGenerator', , , Location, Rotation);
        if (flyGen != None)
            flyGen.SetBase(self);
    }
}

// ----------------------------------------------------------------------
// ChunkUp()
// ----------------------------------------------------------------------

function ChunkUp(int Damage)
{
    local int i;
    local float size;
    local Vector loc;
    local FleshFragment chunk;

    // gib the carcass
    size = (CollisionRadius + CollisionHeight) / 2;
    if (size > 10.0)
    {
        for (i=0; i<size/4.0; i++)
        {
            loc.X = (1-2*FRand()) * CollisionRadius;
            loc.Y = (1-2*FRand()) * CollisionRadius;
            loc.Z = (1-2*FRand()) * CollisionHeight;
            loc += Location;
            chunk = spawn(class'FleshFragment', None,, loc);
            if (chunk != None)
            {
                chunk.DrawScale = size / 25;
                chunk.SetCollisionSize(chunk.CollisionRadius / chunk.DrawScale, chunk.CollisionHeight / chunk.DrawScale);
                chunk.bFixedRotationDir = True;
                chunk.RotationRate = RotRand(False);
            }
        }
    }

    Super.ChunkUp(Damage);
}

// ----------------------------------------------------------------------
// TakeDamage()
// ----------------------------------------------------------------------

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitLocation, Vector momentum, name damageType)
{
    local int i;

    if (bInvincible)
        return;

    // only take "gib" damage from these damage types
    if ((damageType == 'Shot') || (damageType == 'Sabot') || (damageType == 'Exploded') || (damageType == 'Munch') ||
        (damageType == 'Tantalus'))
    {
        if ((damageType != 'Munch') && (damageType != 'Tantalus'))
        {
         if ((DeusExMPGame(Level.Game) != None) && (!DeusExMPGame(Level.Game).bSpawnEffects))
         {
         }
         else
         {
            spawn(class'BloodSpurt',,,HitLocation);
            spawn(class'BloodDrop',,, HitLocation);
            for (i=0; i<Damage; i+=10)
               spawn(class'BloodDrop',,, HitLocation);
         }
        }

        // this section copied from Carcass::TakeDamage() and modified a little
        if (!bDecorative)
        {
            bBobbing = false;
            SetPhysics(PHYS_Falling);
        }
        if ((Physics == PHYS_None) && (Momentum.Z < 0))
            Momentum.Z *= -1;
        Velocity += 3 * momentum/(Mass + 200);
        if (DamageType == 'Shot')
            Damage *= 0.4;
        CumulativeDamage += Damage;
        if (CumulativeDamage >= MaxDamage)
            ChunkUp(Damage);
        if (bDecorative)
            Velocity = vect(0,0,0);
    }

    // Vanilla Matters: Make the carcase "die" if taken enough damage.
    if ( bNotDead ) {
        bNotDead = false;

        if ( !bAnimalCarcass ) {
            itemName = VM_name @ "(" $ default.itemName $ ")";
        }

        if ( FRand() < 0.1 ) {
            bGenerateFlies = true;
        }
    }

    SetScaleGlow();
}

// ----------------------------------------------------------------------
// SetScaleGlow()
//
// sets the scale glow for the carcass, based on damage
// ----------------------------------------------------------------------

function SetScaleGlow()
{
    local float pct;

    // scaleglow based on damage
    pct = FClamp(1.0-float(CumulativeDamage)/MaxDamage, 0.1, 1.0);
    ScaleGlow = pct;
}

// ----------------------------------------------------------------------
// Frob()
//
// search the body for inventory items and give them to the frobber
// ----------------------------------------------------------------------

function Frob(Actor Frobber, Inventory frobWith)
{
    local Inventory item, nextItem, startItem;
    local Pawn P;
    local DeusExWeapon W;
    local bool bFoundSomething;
    local ammo AmmoType;
    local bool bPickedItemUp;
    //local POVCorpse corpse;
    local DeusExPickup invItem;
    local int itemCount;

    // Vanilla Matters
    local VMPlayer player;
    local bool bHeldAlready;        // Just something to make sure no two pickups are taken held in the same search.
    local DeusExWeapon tempW;
    local bool ammoPicked;

//log("DeusExCarcass::Frob()--------------------------------");

    // Can we assume only the *PLAYER* would actually be frobbing carci?
    // Vanilla Matters
    player = VMPlayer( Frobber );

    // No doublefrobbing in multiplayer.
    if (bQueuedDestroy)
        return;

    // Vanilla Matters: We have our own function to handle corpse spawning.
    if ( SpawnPOVCorpse( Frobber, frobWith ) ) {
        return;
    }

    bFoundSomething = False;
    bSearchMsgPrinted = False;
    P = Pawn(Frobber);
    if (P != None)
    {
        // Make sure the "Received Items" display is cleared
      // DEUS_EX AMSD Don't bother displaying in multiplayer.  For propagation
      // reasons it is a lot more of a hassle than it is worth.
        if ( (player != None) && (Level.NetMode == NM_Standalone) )
         DeusExRootWindow(player.rootWindow).hud.receivedItems.RemoveItems();

        if (Inventory != None)
        {

            item = Inventory;
            startItem = item;

            do
            {
//              log("===>DeusExCarcass:item="$item );

                nextItem = item.Inventory;

                bPickedItemUp = False;

                if (item.IsA('Ammo'))
                {
                    // Only let the player pick up ammo that's already in a weapon
                    DeleteInventory(item);
                    item.Destroy();
                    item = None;
                }
                else if ( (item.IsA('DeusExWeapon')) )
                {
                    // Any weapons have their ammo set to a random number of rounds (1-4)
                    // unless it's a grenade, in which case we only want to dole out one.
                    // DEUS_EX AMSD In multiplayer, give everything away.
                    W = DeusExWeapon(item);

                    // Grenades and LAMs always pickup 1
                    // Vanilla Matters: Prevent giving weapons more ammo after repeated loot attempts.
                    if ( W.VM_isGrenade ) {
                        W.PickupAmmoCount = 1;
                    }
                    else if ( Level.NetMode == NM_Standalone && !VM_bSearchedOnce ) {
                        // Vanilla Matters: Make the count scale with the weapon's default amount.
                        if ( W.default.PickUpAmmoCount > 10 ) {
                            W.PickupAmmoCount = FMax( FClamp( FRand(), 0.2, 0.4 ) * W.default.PickUpAmmoCount, 4 );
                        }
                        else {
                            W.PickUpAmmoCount = Rand( W.default.PickUpAmmoCount / 2 ) + 2;
                        }
                    }
                }

                if (item != None)
                {
                    bFoundSomething = True;

                    if (item.IsA('NanoKey'))
                    {
                        if (player != None)
                        {
                            player.PickupNanoKey(NanoKey(item));
                            AddReceivedItem(player, item, 1);
                            DeleteInventory(item);
                            item.Destroy();
                            item = None;
                        }
                        bPickedItemUp = True;
                    }
                    else if (item.IsA('Credits'))       // I hate special cases
                    {
                        if (player != None)
                        {
                            AddReceivedItem(player, item, Credits(item).numCredits);
                            player.Credits += Credits(item).numCredits;
                            P.ClientMessage(Sprintf(Credits(item).msgCreditsAdded, Credits(item).numCredits));
                            DeleteInventory(item);
                            item.Destroy();
                            item = None;
                        }
                        bPickedItemUp = True;
                    }
                    else if (item.IsA('DeusExWeapon'))   // I *really* hate special cases
                    {
                        // Okay, check to see if the player already has this weapon.  If so,
                        // then just give the ammo and not the weapon.  Otherwise give
                        // the weapon normally.
                        W = DeusExWeapon(player.FindInventoryType(item.Class));

                        // If the player already has this item in his inventory, piece of cake,
                        // we just give him the ammo.  However, if the Weapon is *not* in the
                        // player's inventory, first check to see if there's room for it.  If so,
                        // then we'll give it to him normally.  If there's *NO* room, then we
                        // want to give the player the AMMO only (as if the player already had
                        // the weapon).

                        // Vanilla Matters: Rewrite because it's really bad.
                        if ( W != None || ( W == None && !player.FindInventorySlot( item, true ) ) ) {
                            // Vanilla Matters: Fix the bug where the player isn't able to pick up ammo properly due to hacky vanilla coding.
                            tempW = DeusExWeapon( item );
                            if ( tempW.AmmoType == None && tempW.AmmoName != None && tempW.AmmoName != class'AmmoNone' ) {
                                tempW.AmmoType = Spawn( tempW.AmmoName );
                                if ( tempW.AmmoType != none ) {
                                    AddInventory( tempW.AmmoType );
                                    tempW.AmmoType.BecomeItem();
                                    tempW.AmmoType.AmmoAmount = tempW.PickUpAmmoCount;
                                    tempW.AmmoType.GotoState( 'Idle2' );
                                }
                            }

                            // Don't bother with this is there's no ammo
                            if ( tempW.AmmoType != None && tempW.AmmoType.AmmoAmount > 0 ) {
                                AmmoType = Ammo( player.FindInventoryType( tempW.AmmoName ) );
                                if ( AmmoType == none ) {
                                    AmmoType = Spawn( tempW.AmmoName );
                                    if ( AmmoType != none ) {
                                        P.AddInventory( AmmoType );
                                        AmmoType.BecomeItem();
                                        AmmoType.AmmoAmount = 0;
                                        AmmoType.GotoState( 'Idle2' );
                                    }
                                }

                                if ( AmmoType != None && AmmoType.AmmoAmount < AmmoType.MaxAmmo && !( AmmoType.PickupViewMesh == Mesh'TestBox' && W == none ) ) {
                                    AmmoType.AddAmmo( tempW.PickupAmmoCount );
                                    AddReceivedItem( player, AmmoType, tempW.PickupAmmoCount );

                                    player.UpdateAmmoBeltText( AmmoType );

                                    if ( AmmoType.PickupViewMesh == Mesh'TestBox' ) {
                                        P.ClientMessage( item.PickupMessage @ item.itemArticle @ item.itemName, 'Pickup' );
                                    }
                                    else {
                                        P.ClientMessage( AmmoType.PickupMessage @ AmmoType.itemArticle @ AmmoType.itemName @ DeusExAmmo( AmmoType ).VM_msgFromWeapon @ tempW.ItemName, 'Pickup' );
                                    }

                                    tempW.AmmoType.AmmoAmount = 0;
                                    tempW.PickUpAmmoCount = 0;

                                    bPickedItemUp = true;
                                }

                                // Vanilla Matters: Let the player know if they can't have anymore of something.
                                if ( !bPickedItemUp ) {
                                    if ( AmmoType != none ) {
                                        if ( AmmoType.PickupViewMesh == Mesh'TestBox' ) {
                                            if ( W != None ) {
                                                P.ClientMessage( Sprintf( player.MsgTooMuchAmmo, item.itemName ) );
                                            }
                                            else {
                                                P.ClientMessage( Sprintf( Player.InventoryFull, item.itemName ) );
                                            }
                                        }
                                        else {
                                            P.ClientMessage( Sprintf( player.MsgTooMuchAmmo, AmmoType.itemName ) );
                                        }
                                    }
                                    else {
                                        if ( W == none ) {
                                            P.ClientMessage( Sprintf( Player.InventoryFull, item.itemName ) );
                                        }
                                    }
                                }
                            }
                            // Vanilla Matters: Report empty weapons so the player gets the proper feedback.
                            else {
                                if ( tempW.AmmoName != none && tempW.AmmoName != class'AmmoNone' ) {
                                    P.ClientMessage( Sprintf( VM_msgNoAmmo, item.itemName ) );
                                }
                                else {
                                    if ( W != none ) {
                                        P.ClientMessage( Sprintf( Player.CanCarryOnlyOne, item.itemName ) );
                                    }
                                    else {
                                        P.ClientMessage( Sprintf( Player.InventoryFull, item.itemName ) );
                                    }
                                }
                            }

                            // Vanilla Matters: Get rid of the grenade weapon if its ammo's been looted.
                            if ( ( tempW != none && tempW.VM_isGrenade && tempW.PickUpAmmoCount <= 0 ) || ( W != none && ( bPickedItemUp || tempW.AmmoName == none || tempW.AmmoName == class'AmmoNone' ) ) ) {
                                DeleteInventory( item );
                                item.Destroy();

                                item = none;
                            }

                            // Print a message "Cannot pickup blah blah blah" if inventory is full
                            // and the player can't pickup this weapon, so the player at least knows
                            // if he empties some inventory he can get something potentially cooler
                            // than he already has.

                            // Vanilla Matters: If the player can't pick it up on their second try, they're to grab the corpse instead.
                            if ( !bPickedItemUp && VM_bSearchedOnce && nextItem == none ) {
                                SpawnPOVCorpse( Frobber, frobWith, true );

                                return;
                            }

                            bPickedItemUp = True;
                        }
                    }

                    else if (item.IsA('DeusExAmmo'))
                    {
                        if (DeusExAmmo(item).AmmoAmount == 0)
                            bPickedItemUp = True;
                    }

                    if (!bPickedItemUp)
                    {
                        // Special case if this is a DeusExPickup(), it can have multiple copies
                        // and the player already has it.

                        if ((item.IsA('DeusExPickup')) && (DeusExPickup(item).bCanHaveMultipleCopies) && (player.FindInventoryType(item.class) != None))
                        {
                            invItem   = DeusExPickup(player.FindInventoryType(item.class));
                            itemCount = DeusExPickup(item).numCopies;

                            // Make sure the player doesn't have too many copies
                            if ((invItem.MaxCopies > 0) && (DeusExPickup(item).numCopies + invItem.numCopies > invItem.MaxCopies))
                            {
                                // Give the player the max #
                                if ((invItem.MaxCopies - invItem.numCopies) > 0)
                                {
                                    itemCount = (invItem.MaxCopies - invItem.numCopies);
                                    DeusExPickup(item).numCopies -= itemCount;
                                    invItem.numCopies = invItem.MaxCopies;
                                    P.ClientMessage(invItem.PickupMessage @ invItem.itemArticle @ invItem.itemName, 'Pickup');
                                    AddReceivedItem(player, invItem, itemCount);
                                }
                                else
                                {
                                    // Vanilla Matters: Let the player grab the corpse on second try, while saving the inventory info, if the item still can't be picked up.
                                    if ( !bHeldAlready && player.TakeHold( item ) ) {
                                        P.ClientMessage( Sprintf( msgCannotPickup, item.itemName ) );

                                        DeleteInventory( item );

                                        AddReceivedItem( player, item, itemCount );

                                        bHeldAlready = true;
                                    }
                                    else if ( VM_bSearchedOnce ) {
                                        if ( nextItem == None && !bHeldAlready ) {
                                            SpawnPOVCorpse( Frobber, frobWith, true );

                                            return;
                                        }
                                    }
                                    else {
                                        P.ClientMessage( Sprintf( msgCannotPickup, item.itemName ) );
                                    }
                                }
                            }
                            else
                            {
                                invItem.numCopies += itemCount;
                                DeleteInventory(item);

                                P.ClientMessage(invItem.PickupMessage @ invItem.itemArticle @ invItem.itemName, 'Pickup');
                                AddReceivedItem(player, invItem, itemCount);
                            }
                        }
                        else
                        {
                            // check if the pawn is allowed to pick this up

                            // Vanilla Matters: Clean up all this part to fit in with the quick use functionality.
                            if ( P.Inventory == None || Level.Game.PickupQuery( P, item ) ) {
                                player.FrobTarget = item;

                                if ( player.HandleItemPickup( item ) ) {
                                    DeleteInventory( item );

                                    item.bInObjectBelt= false;
                                    item.BeltPos= -1;

                                    item.SpawnCopy( P );

                                    AddReceivedItem( player, item, 1 );

                                    player.ClientMessage( item.PickupMessage @ item.itemArticle @ item.itemName, 'Pickup' );
                                    PlaySound( item.PickupSound );
                                }
                                else if ( !bHeldAlready && player.TakeHold( item ) ) {
                                    DeleteInventory( item );

                                    AddReceivedItem( player, item, 1 );

                                    bHeldAlready = true;
                                }
                            }
                            else {
                                DeleteInventory( item );
                                item.Destroy();
                                item = None;
                            }
                        }
                    }
                }

                item = nextItem;
            }
            until ((item == None) || (item == startItem));
        }

//log("  bFoundSomething = " $ bFoundSomething);

        if (!bFoundSomething)
            P.ClientMessage(msgEmpty);

        // Vanilla Matters: Search finished so the body has been searched at least once.
        VM_bSearchedOnce = true;
    }

   if ((player != None) && (Level.Netmode != NM_Standalone))
   {
      player.ClientMessage(Sprintf(msgRecharged, 25));

      PlaySound(sound'BioElectricHiss', SLOT_None,,, 256);

      player.Energy += 25;
      if (player.Energy > player.EnergyMax)
         player.Energy = player.EnergyMax;
   }

    Super.Frob(Frobber, frobWith);

   if ((Level.Netmode != NM_Standalone) && (Player != None))
   {
       bQueuedDestroy = true;
       Destroy();
   }
}

// Vanilla Matters: Move the POVCorpse spawning out of Frob() to have better control over it.
function bool SpawnPOVCorpse( Actor Frobber, Inventory frobWith, optional bool bIgnoresInventory ) {
    local DeusExPlayer player;
    local POVCorpse corpse;
    local Inventory item;
    local Inventory nextItem;

    player = DeusExPlayer( Frobber );

    // VM: Even if the body is empty, the player still has to go through the searching phase at least once.
    if ( !bAnimalCarcass && ( ( VM_bSearchedOnce && Inventory == None ) || bIgnoresInventory ) && player != None && Level.NetMode == NM_Standalone && !bInvincible ) {
        if ( player.inHand != None ) {
            player.ClientMessage( player.HandsFull );

            return false;
        }

        corpse = Spawn( class'POVCorpse' );
        if (corpse != None) {
            corpse.carcClassString = String( Class );
            corpse.KillerAlliance = KillerAlliance;
            corpse.KillerBindName = KillerBindName;
            corpse.Alliance = Alliance;
            corpse.bNotDead = bNotDead;
            corpse.bEmitCarcass = bEmitCarcass;
            corpse.CumulativeDamage = CumulativeDamage;
            corpse.MaxDamage = MaxDamage;
            corpse.CorpseItemName = itemName;
            corpse.CarcassName = CarcassName;
            corpse.VM_name = VM_name;

            // Vanilla Matters: Save inventory information in case the frob ignores inventory.
            item = Inventory;

            while ( item != None ) {
                nextItem = item.Inventory;

                DeleteInventory( item );

                item.Inventory = corpse.VM_corpseInventory;

                corpse.VM_corpseInventory = item;

                item = nextItem;
            }

            corpse.VM_bSearchedOnce = VM_bSearchedOnce;

            corpse.Frob( player, None );
            corpse.SetBase( player );
            player.PutInHand( corpse );

            bQueuedDestroy=True;

            Destroy();

            return true;
        }
    }

    return false;
}


// ----------------------------------------------------------------------
// AddReceivedItem()
// ----------------------------------------------------------------------

function AddReceivedItem(DeusExPlayer player, Inventory item, int count)
{
    local DeusExWeapon w;
    local Inventory altAmmo;

    // Vanilla Matters: Omit the message because it's pretty useless anyhow.

   DeusExRootWindow(player.rootWindow).hud.receivedItems.AddItem(item, 1);

    // Make sure the object belt is updated
    if (item.IsA('Ammo'))
        player.UpdateAmmoBeltText(Ammo(item));
    else
        player.UpdateBeltText(item);

    // Deny 20mm and WP rockets off of bodies in multiplayer
    if ( Level.NetMode != NM_Standalone )
    {
        if ( item.IsA('WeaponAssaultGun') || item.IsA('WeaponGEPGun') )
        {
            w = DeusExWeapon(player.FindInventoryType(item.Class));
            if (( Ammo20mm(w.AmmoType) != None ) || ( AmmoRocketWP(w.AmmoType) != None ))
            {
                altAmmo = Spawn( w.AmmoNames[0] );
                DeusExAmmo(altAmmo).AmmoAmount = w.PickupAmmoCount;
                altAmmo.Frob(player,None);
                altAmmo.Destroy();
                w.AmmoType.Destroy();
                w.LoadAmmo( 0 );
            }
        }
    }
}

// ----------------------------------------------------------------------
// AddInventory()
//
// copied from Engine.Pawn
// Add Item to this carcasses inventory.
// Returns true if successfully added, false if not.
// ----------------------------------------------------------------------

function bool AddInventory( inventory NewItem )
{
    // Skip if already in the inventory.
    local inventory Inv;

    for( Inv=Inventory; Inv!=None; Inv=Inv.Inventory )
        if( Inv == NewItem )
            return false;

    // The item should not have been destroyed if we get here.
    assert(NewItem!=None);

    // Add to front of inventory chain.
    NewItem.SetOwner(Self);
    NewItem.Inventory = Inventory;
    NewItem.InitialState = 'Idle2';
    Inventory = NewItem;

    return true;
}

// ----------------------------------------------------------------------
// DeleteInventory()
//
// copied from Engine.Pawn
// Remove Item from this pawn's inventory, if it exists.
// Returns true if it existed and was deleted, false if it did not exist.
// ----------------------------------------------------------------------

function bool DeleteInventory( inventory Item )
{
    // If this item is in our inventory chain, unlink it.
    local actor Link;

    for( Link = Self; Link!=None; Link=Link.Inventory )
    {
        if( Link.Inventory == Item )
        {
            Link.Inventory = Item.Inventory;
            break;
        }
    }

    // Vanilla Matters: Make sure we don't just set the ownership to None when it's not necessary.
    if ( Item.Owner == self ) {
        Item.SetOwner( None );
    }
}

// ----------------------------------------------------------------------
// auto state Dead
// ----------------------------------------------------------------------

auto state Dead
{
    function Timer()
    {
        // overrides goddamned lifespan crap
        // DEUS_EX AMSD In multiplayer, we want corpses to have lifespans.
        if (Level.NetMode == NM_Standalone)
            Global.Timer();
        else
            Super.Timer();
    }

    function HandleLanding()
    {
        local Vector HitLocation, HitNormal, EndTrace;
        local Actor hit;
        local BloodPool pool;

        if (!bNotDead)
        {
            // trace down about 20 feet if we're not in water
            if (!Region.Zone.bWaterZone)
            {
                EndTrace = Location - vect(0,0,320);
                hit = Trace(HitLocation, HitNormal, EndTrace, Location, False);
                if ((DeusExMPGame(Level.Game) != None) && (!DeusExMPGame(Level.Game).bSpawnEffects))
                {
                    pool = None;
                }
                else
                {
                    pool = spawn(class'BloodPool',,, HitLocation+HitNormal, Rotator(HitNormal));
                }
                if (pool != None)
                    pool.maxDrawScale = CollisionRadius / 40.0;
            }

            // alert NPCs that I'm food
            AIStartEvent('Food', EAITYPE_Visual);
        }

        // by default, the collision radius is small so there won't be as
        // many problems spawning carcii
        // expand the collision radius back to where it's supposed to be
        // don't change animal carcass collisions
        if (!bAnimalCarcass)
            SetCollisionSize(40.0, Default.CollisionHeight);

        // alert NPCs that I'm really disgusting
        if (bEmitCarcass)
            AIStartEvent('Carcass', EAITYPE_Visual);
    }

Begin:
    while (Physics == PHYS_Falling)
    {
        Sleep(1.0);
    }
    HandleLanding();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     bHighlight=True
     msgSearching="In your search:"
     msgEmpty="You don't find anything"
     msgNotDead="Unconscious"
     msgAnimalCarcass="Animal Carcass"
     msgCannotPickup="You cannot pickup the %s"
     msgRecharged="Recharged %d points"
     ItemName="Dead"
     VM_msgDrowned="Drowned"
     VM_msgNoAmmo="You don't find anything useful from the %s"
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=0.000000
     CollisionRadius=20.000000
     CollisionHeight=7.000000
     bCollideWorld=False
     Mass=150.000000
     Buoyancy=170.000000
     BindName="DeadBody"
     bVisionImportant=True
}
