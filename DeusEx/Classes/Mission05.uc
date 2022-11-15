//=============================================================================
// Mission05.
//=============================================================================
class Mission05 extends MissionScript;

// ----------------------------------------------------------------------
// FirstFrame()
//
// Stuff to check at first frame
// ----------------------------------------------------------------------

function FirstFrame()
{
    local PaulDentonCarcass carc;
    local PaulDenton Paul;
    local Terrorist T;
    local AnnaNavarre Anna;

    Super.FirstFrame();

    if (localURL == "05_NYC_UNATCOMJ12LAB")
    {
        // make sure this goal is completed
        Player.GoalCompleted('EscapeToBatteryPark');

        // delete Paul's carcass if he's still alive
        if (!flags.GetBool('PaulDenton_Dead'))
        {
            foreach AllActors(class'PaulDentonCarcass', carc)
                carc.Destroy();
        }

        // if the player has already talked to Paul, delete him
        if (flags.GetBool('M05PaulDentonDone') ||
            flags.GetBool('PaulDenton_Dead'))
        {
            foreach AllActors(class'PaulDenton', Paul)
                Paul.Destroy();
        }

        // if Miguel is not following the player, delete him
        if (flags.GetBool('MeetMiguel_Played') &&
            !flags.GetBool('MiguelFollowing'))
        {
            foreach AllActors(class'Terrorist', T)
                if (T.BindName == "Miguel")
                    T.Destroy();
        }

        // remove the player's inventory and put it in a room
        // also, heal the player up to 50% of his total health
        if (!flags.GetBool('MS_InventoryRemoved'))
        {
            Player.HealthHead = Max(50, Player.HealthHead);
            Player.HealthTorso =  Max(50, Player.HealthTorso);
            Player.HealthLegLeft =  Max(50, Player.HealthLegLeft);
            Player.HealthLegRight =  Max(50, Player.HealthLegRight);
            Player.HealthArmLeft =  Max(50, Player.HealthArmLeft);
            Player.HealthArmRight =  Max(50, Player.HealthArmRight);
            Player.GenerateTotalHealth();

            // Vanilla Matters: Rewrite to get rid of ammo too.
            RemovePlayerInventory();

            flags.SetBool('MS_InventoryRemoved', True,, 6);
        }
    }
    else if (localURL == "05_NYC_UNATCOHQ")
    {
        // if Miguel is following the player, unhide him
        if (flags.GetBool('MiguelFollowing'))
        {
            foreach AllActors(class'Terrorist', T)
                if (T.BindName == "Miguel")
                    T.EnterWorld();
        }

        // make Anna not flee in this mission
        foreach AllActors(class'AnnaNavarre', Anna)
            Anna.MinHealth = 0;
    }
    else if (localURL == "05_NYC_UNATCOISLAND")
    {
        // if Miguel is following the player, unhide him
        if (flags.GetBool('MiguelFollowing'))
        {
            foreach AllActors(class'Terrorist', T)
                if (T.BindName == "Miguel")
                    T.EnterWorld();
        }
    }
}

// ----------------------------------------------------------------------
// PreTravel()
//
// Set flags upon exit of a certain map
// ----------------------------------------------------------------------

function PreTravel()
{
    Super.PreTravel();
}

// ----------------------------------------------------------------------
// Timer()
//
// Main state machine for the mission
// ----------------------------------------------------------------------

function Timer()
{
    local AnnaNavarre Anna;
    local WaltonSimons Walton;
    local DeusExMover M;

    Super.Timer();

    if (localURL == "05_NYC_UNATCOHQ")
    {
        // unlock a door
        if (flags.GetBool('CarterUnlock') &&
            !flags.GetBool('MS_DoorUnlocked'))
        {
            foreach AllActors(class'DeusExMover', M, 'supplydoor')
            {
                M.bLocked = False;
                M.lockStrength = 0.0;
            }

            flags.SetBool('MS_DoorUnlocked', True,, 6);
        }

        // kill Anna when a flag is set
        if (flags.GetBool('annadies') &&
            !flags.GetBool('MS_AnnaKilled'))
        {
            foreach AllActors(class'AnnaNavarre', Anna)
            {
                Anna.HealthTorso = 0;
                Anna.Health = 0;
                Anna.TakeDamage(1, Anna, Anna.Location, vect(0,0,0), 'Shot');
            }

            flags.SetBool('MS_AnnaKilled', True,, 6);
        }

        // make Anna attack the player after a convo is played
        if (flags.GetBool('M05AnnaAtExit_Played') &&
            !flags.GetBool('MS_AnnaAttacking'))
        {
            foreach AllActors(class'AnnaNavarre', Anna)
                Anna.SetOrders('Attacking', '', True);

            flags.SetBool('MS_AnnaAttacking', True,, 6);
        }

        // unhide Walton Simons
        if (flags.GetBool('simonsappears') &&
            !flags.GetBool('MS_SimonsUnhidden'))
        {
            foreach AllActors(class'WaltonSimons', Walton)
                Walton.EnterWorld();

            flags.SetBool('MS_SimonsUnhidden', True,, 6);
        }

        // hide Walton Simons
        if ((flags.GetBool('M05MeetManderley_Played') ||
            flags.GetBool('M05SimonsAlone_Played')) &&
            !flags.GetBool('MS_SimonsHidden'))
        {
            foreach AllActors(class'WaltonSimons', Walton)
                Walton.LeaveWorld();

            flags.SetBool('MS_SimonsHidden', True,, 6);
        }

        // mark a goal as completed
        if (flags.GetBool('KnowsAnnasKillphrase1') &&
            flags.GetBool('KnowsAnnasKillphrase2') &&
            !flags.GetBool('MS_KillphraseGoalCleared'))
        {
            Player.GoalCompleted('FindAnnasKillphrase');
            flags.SetBool('MS_KillphraseGoalCleared', True,, 6);
        }

        // clear a goal when anna is out of commision
        if (flags.GetBool('AnnaNavarre_Dead') &&
            !flags.GetBool('MS_EliminateAnna'))
        {
            Player.GoalCompleted('EliminateAnna');
            flags.SetBool('MS_EliminateAnna', True,, 6);
        }
    }
    else if (localURL == "05_NYC_UNATCOMJ12LAB")
    {
        // After the player talks to Paul, start a datalink
        if (!flags.GetBool('MS_DL_Played') &&
            flags.GetBool('PaulInMedLab_Played'))
        {
            Player.StartDataLinkTransmission("DL_Paul");
            flags.SetBool('MS_DL_Played', True,, 6);
        }
    }
}

function RemovePlayerInventory() {
    local Inventory item, nextItem;
    local SpawnPoint SP;
    local DeusExWeapon w;
    local bool noValidItemFound;

    if ( Player.Inventory != none ) {
        item = Player.Inventory;
        nextItem = none;
        noValidItemFound = false;

        while (!noValidItemFound) {
            noValidItemFound = true;
            foreach AllActors( class'SpawnPoint', SP, 'player_inv' ) {
                while( item != none
                    && ( ( !item.bDisplayableInv && Ammo( item ) == none )
                        || item.PickupViewMesh == Mesh'TestBox'
                    )
                ) {
                    item = item.Inventory;
                }

                if ( item != none ) {
                    noValidItemFound = false;
                    nextItem = item.Inventory;

                    // Vanilla Matters: Fix a bug where grenades would have their count reset to 1.
                    w = DeusExWeapon( item );
                    if ( w != None && w.AmmoType != None ) {
                        if ( w.AmmoName != class'AmmoNone' && w.AmmoType.PickupViewMesh == Mesh'TestBox' && !w.bInstantHit ) {
                            w.PickupAmmoCount = w.AmmoType.AmmoAmount;
                        }
                        else {
                            w.PickupAmmoCount = w.default.PickupAmmoCount;
                        }
                    }

                    item.DropFrom( SP.Location );
                }

                item = nextItem;
                if (item == none) {
                    break;
                }
            }
        }
    }
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}
