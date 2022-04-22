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
            // Vanilla Matters
            AIStartEvent( 'Carcass', EAITYPE_Visual, 1, 3200 );
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
        // VM: Non-lethal damage can't kill.
        if ( damageType != 'Stunned' && damageType != 'KnockedOut'
            && damageType != 'Poison' && damageType != 'PoisonEffect'
            && damageType != 'TearGas' && damageType != 'HalonGas'
            && damageType != 'EMP' && damageType != 'NanoVirus'
        ) {
            bNotDead = false;

            if ( !bAnimalCarcass ) {
                itemName = VM_name @ "(" $ default.itemName $ ")";
            }

            if ( FRand() < 0.1 ) {
                bGenerateFlies = true;
            }
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
// Vanilla Matters
function Frob( Actor frobber, Inventory frobWith ) {
    local Vector loc;
    local VMPlayer player;
    local Inventory item, nextItem;
    local Ammo ammo;
    local NanoKey key;
    local Credits credits;

    if ( bQueuedDestroy ) {
        return;
    }

    player = VMPlayer( frobber );
    if ( player == none ) {
        return;
    }

    if ( Level.NetMode == NM_Standalone ) {
        DeusExRootWindow( player.rootWindow ).hud.receivedItems.RemoveItems();
    }

    item = Inventory;
    while ( item != none ) {
        nextItem = item.Inventory;
        DeleteInventory( item );

        ammo = Ammo( item );
        if ( ammo != none ) {
            DeleteInventory( item );
            item.Destroy();
            item = nextItem;
            continue;
        }

        key = NanoKey( item );
        if ( key != none ) {
            player.PickupNanoKey( key );
            AddReceivedItem( player, item, 1 );

            item.Destroy();
            item = nextItem;
            continue;
        }

        credits = Credits( item );
        if ( credits != none ) {
            player.Credits += credits.numCredits;
            AddReceivedItem( player, item, credits.numCredits );
            player.ClientMessage( Sprintf( credits.msgCreditsAdded, credits.numCredits ) );

            item.Destroy();
            item = nextItem;
            continue;
        }

        if ( Level.Game.PickupQuery( player, item ) ) {
            player.FrobTarget = item;
            if ( player.HandleItemPickup( item ) ) {
                item.SpawnCopy( player );
                AddReceivedItem( player, item, 1 );
                player.ClientMessage( item.PickupMessage @ item.itemArticle @ item.itemName, 'Pickup' );

                item = nextItem;
                continue;
            }
        }

        loc = Vect( 0, 0, 0 );
        loc.x = ( FRand() - FRand() ) * CollisionRadius;
        loc.y = CollisionRadius;
        if ( FRand() > 0.5 ) {
            loc.y *= -1;
        }
        loc = loc >> Rotation;
        item.DropFrom( Location + loc );

        item = nextItem;
    }

    if ( Level.Netmode != NM_Standalone ) {
        player.ClientMessage( Sprintf( msgRecharged, 25 ) );
        PlaySound( sound'BioElectricHiss', SLOT_None,,, 256 );
        player.Energy = FMin( player.Energy + 25, player.EnergyMax );

        bQueuedDestroy = true;
        Destroy();
    }
    else {
        if ( !VM_bSearchedOnce ) {
            VM_bSearchedOnce = true;
        }
        else {
            SpawnPOVCorpse( player );
        }
    }
}

// Vanilla Matters
function bool SpawnPOVCorpse( DeusExPlayer player ) {
    local POVCorpse corpse;

    // VM: Even if the body is empty, the player still has to go through the searching phase at least once.
    if ( !bAnimalCarcass && player != none && Level.NetMode == NM_Standalone && !bInvincible ) {
        if ( player.inHand != None ) {
            player.ClientMessage( player.HandsFull );
            return false;
        }

        corpse = Spawn( class'POVCorpse' );
        if ( corpse != none ) {
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
            corpse.VM_bSearchedOnce = VM_bSearchedOnce;

            corpse.Frob( player, none );
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
// Vanilla Matters
function AddReceivedItem( DeusExPlayer player, Inventory item, int count ) {
    local Ammo ammo;

   DeusExRootWindow( player.rootWindow ).hud.receivedItems.AddItem( item, count );

    // Make sure the object belt is updated
    ammo = Ammo( item );
    if ( ammo != none ) {
        player.UpdateAmmoBeltText( ammo );
    }
    else {
        player.UpdateBeltText( item );
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
            // Vanilla Matters
            AIStartEvent( 'Carcass', EAITYPE_Visual, 1, 3200 );
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
     msgRecharged="Recharged %s points"
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
