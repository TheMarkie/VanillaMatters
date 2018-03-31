//=============================================================================
// DeusExCarcass.
//=============================================================================
class DeusExCarcass extends Carcass;

struct InventoryItemCarcass  {
	var() class<Inventory> Inventory;
	var() int              count;
};

var(Display) mesh Mesh2;		// mesh for secondary carcass
var(Display) mesh Mesh3;		// mesh for floating carcass
var(Inventory) InventoryItemCarcass InitialInventory[8];  // Initial inventory items held in the carcass
var() bool bHighlight;

var String			KillerBindName;		// what was the bind name of whoever killed me?
var Name			KillerAlliance;		// what alliance killed me?
var bool			bGenerateFlies;		// should we make flies?
var FlyGenerator	flyGen;
var Name			Alliance;			// this body's alliance
var Name			CarcassName;		// original name of carcass
var int				MaxDamage;			// maximum amount of cumulative damage
var bool			bNotDead;			// this body is just unconscious
var() bool			bEmitCarcass;		// make other NPCs aware of this body
var bool		    bQueuedDestroy;	// For multiplayer, semaphore so you can't doublefrob bodies (since destroy is latent)

var bool			bInit;

// Used for Received Items window
var bool bSearchMsgPrinted;

var localized string msgSearching;
var localized string msgEmpty;
var localized string msgNotDead;
var localized string msgAnimalCarcass;
var localized string msgCannotPickup;
var localized String msgRecharged;
var localized string itemName;			// human readable name

var() bool bInvincible;
var bool bAnimalCarcass;

// Vanilla Matters
var travel bool VM_bSearchedOnce;		// Has the player searched this body at least once?

var localized String VM_msgNoAmmo;

// ----------------------------------------------------------------------
// InitFor()
// ----------------------------------------------------------------------

function InitFor(Actor Other)
{
	if (Other != None)
	{
		// set as unconscious or add the pawns name to the description
		if (!bAnimalCarcass)
		{
			if (bNotDead)
				itemName = msgNotDead;
			else if (Other.IsA('ScriptedPawn'))
				itemName = itemName $ " (" $ ScriptedPawn(Other).FamiliarName $ ")";
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
			bEmitCarcass = true;
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
		bNotDead = False;		// you will die in water every time
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
	local DeusExPlayer player;
	local ammo AmmoType;
	local bool bPickedItemUp;
	//local POVCorpse corpse;
	local DeusExPickup invItem;
	local int itemCount;

	// Vanilla Matters
	local bool bHeldAlready;		// Just something to make sure no two pickups are taken held in the same search.
	local Weapon tempW;				// So we don't have to keep casting.

//log("DeusExCarcass::Frob()--------------------------------");

	// Can we assume only the *PLAYER* would actually be frobbing carci?
	player = DeusExPlayer(Frobber);

	// No doublefrobbing in multiplayer.
	if (bQueuedDestroy)
		return;

	// Vanilla Matters: We don't need this whole chunk below now that we have our own function.
	if ( spawnPOVCorpse( Frobber, frobWith ) ) {
		return;
	}

	// if we've already been searched, let the player pick us up
	// don't pick up animal carcii
	// if (!bAnimalCarcass)
	// {
      // DEUS_EX AMSD Since we don't have animations for carrying corpses, and since it has no real use in multiplayer,
      // and since the PutInHand propagation doesn't just work, this is work we don't need to do.
      // Were you to do it, you'd need to check the respawning issue, destroy the POVcorpse it creates and point to the
      // one in inventory (like I did when giving the player starting inventory).
	// 	if ((Inventory == None) && (player != None) && (player.inHand == None) && (Level.NetMode == NM_Standalone))
	// 	{
	// 		if (!bInvincible)
	// 		{
	// 			corpse = Spawn(class'POVCorpse');
	// 			if (corpse != None)
	// 			{
	// 				// destroy the actual carcass and put the fake one
	// 				// in the player's hands
	// 				corpse.carcClassString = String(Class);
	// 				corpse.KillerAlliance = KillerAlliance;
	// 				corpse.KillerBindName = KillerBindName;
	// 				corpse.Alliance = Alliance;
	// 				corpse.bNotDead = bNotDead;
	// 				corpse.bEmitCarcass = bEmitCarcass;
	// 				corpse.CumulativeDamage = CumulativeDamage;
	// 				corpse.MaxDamage = MaxDamage;
	// 				corpse.CorpseItemName = itemName;
	// 				corpse.CarcassName = CarcassName;
	// 				corpse.Frob(player, None);
	// 				corpse.SetBase(player);
	// 				player.PutInHand(corpse);
	// 				bQueuedDestroy=True;
	// 				Destroy();
	// 				return;
	// 			}
	// 		}
	// 	}
	// }

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
//				log("===>DeusExCarcass:item="$item );

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
               if (W.IsA('WeaponNanoVirusGrenade') || 
                  W.IsA('WeaponGasGrenade') || 
                  W.IsA('WeaponEMPGrenade') ||
                  W.IsA('WeaponLAM'))
                  W.PickupAmmoCount = 1;
               else if (Level.NetMode == NM_Standalone)
                  W.PickupAmmoCount = Rand(4) + 1;
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
					else if (item.IsA('Credits'))		// I hate special cases
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

						if ((W != None) || ((W == None) && (!player.FindInventorySlot(item, True))))
						{
							// Vanilla Matters: Fix the bug where the player isn't able to pick up ammo properly due to hacky vanilla coding.
							tempW = Weapon( item );
							if ( tempW.AmmoType == None && tempW.AmmoName != None && tempW.AmmoName != class'AmmoNone' ) {
								tempW.AmmoType = Spawn( tempW.AmmoName );
								AddInventory( tempW.AmmoType );
								tempW.AmmoType.BecomeItem();
								tempW.AmmoType.AmmoAmount = tempW.PickUpAmmoCount;
								tempW.AmmoType.GotoState( 'Idle2' );
							}

							// Don't bother with this is there's no ammo
							if ((Weapon(item).AmmoType != None) && (Weapon(item).AmmoType.AmmoAmount > 0))
							{
								AmmoType = Ammo(player.FindInventoryType(Weapon(item).AmmoName));

								// Vanilla Matters: Fix the bug where you can pick up ammo of "ammo-weapons".
								if ( AmmoType.PickupViewMesh == Mesh'TestBox' && W == None ) {
									AmmoType = None;
								}

                       if ((AmmoType != None) && (AmmoType.AmmoAmount < AmmoType.MaxAmmo))
								{
                           AmmoType.AddAmmo(Weapon(item).PickupAmmoCount);
                           AddReceivedItem(player, AmmoType, Weapon(item).PickupAmmoCount);
                           
									// Update the ammo display on the object belt
									player.UpdateAmmoBeltText(AmmoType);

									// if this is an illegal ammo type, use the weapon name to print the message
									if (AmmoType.PickupViewMesh == Mesh'TestBox')
										P.ClientMessage(item.PickupMessage @ item.itemArticle @ item.itemName, 'Pickup');
									else
										P.ClientMessage(AmmoType.PickupMessage @ AmmoType.itemArticle @ AmmoType.itemName, 'Pickup');

									// Mark it as 0 to prevent it from being added twice
									Weapon(item).AmmoType.AmmoAmount = 0;
								}
								// Vanilla Matters: Let the player know if they can't have anymore of something.
								else if ( !VM_bSearchedOnce && AmmoType != None ) {
									if ( AmmoType.PickupViewMesh == Mesh'TestBox' ) {
										// VM: Make absolute sure the player already has this weapon.
										if ( W != None ) {
											P.ClientMessage( Sprintf( player.VM_msgTooMuchAmmo, item.itemName ) );
										}
									}
									else {
										P.ClientMessage( Sprintf( player.VM_msgTooMuchAmmo, AmmoType.itemName ) );
									}
								}
							}
							// Vanilla Matters: Report empty weapons so the player gets the proper feedback.
							else {
								P.ClientMessage( Sprintf( VM_msgNoAmmo, item.itemName ) );
							}

							// Print a message "Cannot pickup blah blah blah" if inventory is full
							// and the player can't pickup this weapon, so the player at least knows
							// if he empties some inventory he can get something potentially cooler
							// than he already has. 
							// if ((W == None) && (!player.FindInventorySlot(item, True)))
							// 	P.ClientMessage(Sprintf(Player.InventoryFull, item.itemName));

							// Vanilla Matters: If the player can't pick it up on their second try, they're to grab the corpse instead.
							if ( W == None && !player.FindInventorySlot( item, true ) ) {
								if ( VM_bSearchedOnce ) {
									if ( nextItem == None ) {
										spawnPOVCorpse( Frobber, frobWith, true );

										return;
									}
								}
								else  {
									P.ClientMessage( Sprintf( Player.InventoryFull, item.itemName ) );
								}
							}

							// Only destroy the weapon if the player already has it.
							if (W != None)
							{
								// Destroy the weapon, baby!
								DeleteInventory(item);
								item.Destroy();
								item = None;
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
									//P.ClientMessage(Sprintf(msgCannotPickup, invItem.itemName));

									// Vanilla Matters: Let the player grab the corpse on second try, while saving the inventory info, if the item still can't be picked up.
									if ( !bHeldAlready && player.TakeHold( item ) ) {
										P.ClientMessage( Sprintf( msgCannotPickup, item.itemName ) );

										DeleteInventory( item );

										AddReceivedItem( player, item, itemCount );

										P.ClientMessage( Sprintf( player.VM_msgTakeHoldInstead, item.itemName ) );

										bHeldAlready = true;
									}
									else if ( VM_bSearchedOnce ) {
										if ( nextItem == None && !bHeldAlready ) {
											spawnPOVCorpse( Frobber, frobWith, true );

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
							// if ((P.Inventory == None) || (Level.Game.PickupQuery(P, item)))
							// {
							// 	DeusExPlayer(P).FrobTarget = item;
							// 	if (DeusExPlayer(P).HandleItemPickup(Item) != False)
							// 	{
       //                     DeleteInventory(item);

       //                     // DEUS_EX AMSD Belt info isn't always getting cleaned up.  Clean it up.
       //                     item.bInObjectBelt=False;
       //                     item.BeltPos=-1;
									
       //                     item.SpawnCopy(P);

							// 		// Show the item received in the ReceivedItems window and also 
							// 		// display a line in the Log
							// 		AddReceivedItem(player, item, 1);
									
							// 		P.ClientMessage(Item.PickupMessage @ Item.itemArticle @ Item.itemName, 'Pickup');
							// 		PlaySound(Item.PickupSound);
							// 	}
							// }
							// else
							// {
							// 	DeleteInventory(item);
							// 	item.Destroy();
							// 	item = None;
							// }

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

									P.ClientMessage( Sprintf( player.VM_msgTakeHoldInstead, item.itemName ) );

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
function bool spawnPOVCorpse( Actor Frobber, Inventory frobWith, optional bool bIgnoresInventory ) {
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

	// if (!bSearchMsgPrinted)
	// {
	// 	player.ClientMessage(msgSearching);
	// 	bSearchMsgPrinted = True;
	// }

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
   //Item.SetOwner(None);

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
     ItemName="Dead Body"
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
