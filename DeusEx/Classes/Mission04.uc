//=============================================================================
// Mission04.
//=============================================================================
class Mission04 expands MissionScript;

// Vanilla Matters
var() int VM_RescueReward;
var() string VM_RescueRewardMsg;

// ----------------------------------------------------------------------
// FirstFrame()
//
// Stuff to check at first frame
// ----------------------------------------------------------------------

function FirstFrame()
{
    local ScriptedPawn pawn;

    // Vanilla Matters
    local FlagTrigger ft;
    local FordSchick Ford;
    local PaulDenton Paul;

    Super.FirstFrame();

    if (localURL == "04_NYC_STREET")
    {
        // unhide a bunch of stuff on this flag
        if (flags.GetBool('TalkedToPaulAfterMessage_Played'))
        {
            foreach AllActors(class'ScriptedPawn', pawn)
                if (pawn.IsA('UNATCOTroop') || pawn.IsA('SecurityBot2'))
                    pawn.EnterWorld();
        }

        // Vanilla Matters: Deletes vanilla flags if Paul is indicated to be safe.
        if ( flags.GetBool( 'VM_PaulRescued' ) ) {
            flags.DeleteFlag( 'PaulDenton_Dead', FLAG_Bool );
            flags.DeleteFlag( 'PlayerBailedOutWindow', FLAG_Bool );

            if ( !flags.GetBool( 'VM_PaulRescueRewarded' ) ) {
                Player.SkillPointsAdd( VM_RescueReward );
                Player.ClientMessage( VM_RescueRewardMsg );

                flags.SetBool( 'VM_PaulRescueRewarded', true );
            }
        }
    }
    else if (localURL == "04_NYC_FREECLINIC")
    {
        // unhide a bunch of stuff on this flag
        if (flags.GetBool('TalkedToPaulAfterMessage_Played'))
        {
            foreach AllActors(class'ScriptedPawn', pawn)
                if (pawn.IsA('UNATCOTroop'))
                    pawn.EnterWorld();
        }
    }
    else if (localURL == "04_NYC_HOTEL")
    {
        // unhide the correct JoJo
        if (flags.GetBool('SandraRenton_Dead') ||
            flags.GetBool('GilbertRenton_Dead'))
        {
            if (!flags.GetBool('JoJoFine_Dead'))
                foreach AllActors(class'ScriptedPawn', pawn, 'JoJoInLobby')
                    pawn.EnterWorld();
        }

        // Vanilla Matters: Fix Paul sometime disappearing.
        foreach AllActors( class'FlagTrigger', ft ) {
            if ( ft.Name == 'FlagTrigger17' ) {
                ft.Event = '';
            }
            // Vanilla Matters: Fix Paul being announced dead when exiting through the window.
            else if ( ft.Name == 'FlagTrigger0' ) {
                ft.Destroy();
            }
        }
    }
    // Vanilla Matters: There's no code to spawn Ford in vanilla though he's still in the map, maybe he was never intended to be spawned? But he's functional so let's do it anyway.
    else if ( localURL == "04_NYC_SMUG" ) {
        if( flags.GetBool( 'FordSchickRescued' ) ) {
            foreach AllActors( class'FordSchick', Ford ) {
                Ford.EnterWorld();
            }
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
    // Vanilla Matters
    local ScriptedPawn sp;

    local bool raidCleared;

    // Vanilla Matters: Keep track of Paul's actual status to set flags appropriately.
    if ( localURL == "04_NYC_HOTEL" ) {
        if ( flags.GetBool( 'M04RaidDone' ) ) {
            if ( !flags.GetBool( 'PaulDenton_Dead' ) ) {
                raidCleared = true;
                foreach AllActors( class'ScriptedPawn', sp ) {
                    if ( sp.IsA( 'UNATCOTroop' ) || sp.IsA( 'MIB' ) ) {
                        raidCleared = false;
                    }
                }

                flags.SetBool( 'VM_PaulRescued', raidCleared, true, 5 );
            }
            else {
                flags.SetBool( 'VM_PaulRescued', false, true, 5 );
            }
        }
    }

    Super.PreTravel();
}

// ----------------------------------------------------------------------
// Timer()
//
// Main state machine for the mission
// ----------------------------------------------------------------------

function Timer()
{
    local ScriptedPawn pawn;
    local SatelliteDish dish;
    local SandraRenton Sandra;
    local GilbertRenton Gilbert;
    local GilbertRentonCarcass GilbertCarc;
    local SandraRentonCarcass SandraCarc;
    local UNATCOTroop troop;
    local Actor A;
    local PaulDenton Paul;
    local int count;

    Super.Timer();

    // do this for every map in this mission
    // if the player is "killed" after a certain flag, he is sent to mission 5
    if (!flags.GetBool('MS_PlayerCaptured'))
    {
        if (flags.GetBool('TalkedToPaulAfterMessage_Played'))
        {
            if (Player.IsInState('Dying'))
            {
                flags.SetBool('MS_PlayerCaptured', True,, 5);
                Player.GoalCompleted('EscapeToBatteryPark');
                Level.Game.SendPlayer(Player, "05_NYC_UNATCOMJ12Lab");
            }
        }
    }

    if (localURL == "04_NYC_HOTEL")
    {
        // check to see if the player has killed either Sandra or Gilbert
        if (!flags.GetBool('PlayerKilledRenton'))
        {
            count = 0;
            foreach AllActors(class'SandraRenton', Sandra)
                count++;

            foreach AllActors(class'GilbertRenton', Gilbert)
                count++;

            foreach AllActors(class'SandraRentonCarcass', SandraCarc)
                if (SandraCarc.KillerBindName == "JCDenton")
                    count = 0;

            foreach AllActors(class'GilbertRentonCarcass', GilbertCarc)
                if (GilbertCarc.KillerBindName == "JCDenton")
                    count = 0;

            if (count < 2)
            {
                flags.SetBool('PlayerKilledRenton', True,, 5);
                foreach AllActors(class'Actor', A, 'RentonsHatePlayer')
                    A.Trigger(Self, Player);
            }
        }

        // Vanilla Matters: Moved the raid start check to Tick.

        // make the MIBs mortal
        if (!flags.GetBool('MS_MIBMortal'))
        {
            if (flags.GetBool('TalkedToPaulAfterMessage_Played'))
            {
                foreach AllActors(class'ScriptedPawn', pawn)
                    if (pawn.IsA('MIB'))
                        pawn.bInvincible = False;

                flags.SetBool('MS_MIBMortal', True,, 5);
            }
        }

        // unhide the correct JoJo
        if (!flags.GetBool('MS_JoJoUnhidden') &&
            (flags.GetBool('SandraWaitingForJoJoBarks_Played') ||
            flags.GetBool('GilbertWaitingForJoJoBarks_Played')))
        {
            if (!flags.GetBool('JoJoFine_Dead'))
            {
                foreach AllActors(class'ScriptedPawn', pawn, 'JoJoUpstairs')
                    pawn.EnterWorld();

                flags.SetBool('MS_JoJoUnhidden', True,, 5);
            }
        }

        // unhide the correct JoJo
        if (!flags.GetBool('MS_JoJoUnhidden') &&
            (flags.GetBool('M03OverhearSquabble_Played') &&
            !flags.GetBool('JoJoOverheard_Played') &&
            flags.GetBool('JoJoEntrance')))
        {
            if (!flags.GetBool('JoJoFine_Dead'))
            {
                foreach AllActors(class'ScriptedPawn', pawn, 'JoJoUpstairs')
                    pawn.EnterWorld();

                flags.SetBool('MS_JoJoUnhidden', True,, 5);
            }
        }

        // trigger some stuff based on convo flags
        if (flags.GetBool('JoJoOverheard_Played') && !flags.GetBool('MS_JoJo1Triggered'))
        {
            if (flags.GetBool('GaveRentonGun'))
            {
                foreach AllActors(class'Actor', A, 'GilbertAttacksJoJo')
                    A.Trigger(Self, Player);
            }
            else
            {
                foreach AllActors(class'Actor', A, 'JoJoAttacksGilbert')
                    A.Trigger(Self, Player);
            }

            flags.SetBool('MS_JoJo1Triggered', True,, 5);
        }

        // trigger some stuff based on convo flags
        if (flags.GetBool('JoJoAndSandraOverheard_Played') && !flags.GetBool('MS_JoJo2Triggered'))
        {
            foreach AllActors(class'Actor', A, 'SandraLeaves')
                A.Trigger(Self, Player);

            flags.SetBool('MS_JoJo2Triggered', True,, 5);
        }

        // trigger some stuff based on convo flags
        if (flags.GetBool('JoJoAndGilbertOverheard_Played') && !flags.GetBool('MS_JoJo3Triggered'))
        {
            foreach AllActors(class'Actor', A, 'JoJoAttacksGilbert')
                A.Trigger(Self, Player);

            flags.SetBool('MS_JoJo3Triggered', True,, 5);
        }
    }
    else if (localURL == "04_NYC_NSFHQ")
    {
        // rotate the dish when the computer sets the flag
        if (!flags.GetBool('MS_Dish1Rotated'))
        {
            if (flags.GetBool('Dish1InPosition'))
            {
                foreach AllActors(class'SatelliteDish', dish, 'Dish1')
                    dish.DesiredRotation.Yaw = 49152;

                flags.SetBool('MS_Dish1Rotated', True,, 5);
            }
        }

        // rotate the dish when the computer sets the flag
        if (!flags.GetBool('MS_Dish2Rotated'))
        {
            if (flags.GetBool('Dish2InPosition'))
            {
                foreach AllActors(class'SatelliteDish', dish, 'Dish2')
                    dish.DesiredRotation.Yaw = 0;

                flags.SetBool('MS_Dish2Rotated', True,, 5);
            }
        }

        // rotate the dish when the computer sets the flag
        if (!flags.GetBool('MS_Dish3Rotated'))
        {
            if (flags.GetBool('Dish3InPosition'))
            {
                foreach AllActors(class'SatelliteDish', dish, 'Dish3')
                    dish.DesiredRotation.Yaw = 16384;

                flags.SetBool('MS_Dish3Rotated', True,, 5);
            }
        }

        // set a flag when all dishes are rotated
        if (!flags.GetBool('CanSendSignal'))
        {
            if (flags.GetBool('Dish1InPosition') &&
                flags.GetBool('Dish2InPosition') &&
                flags.GetBool('Dish3InPosition'))
                flags.SetBool('CanSendSignal', True,, 5);
        }

        // count non-living troops
        if (!flags.GetBool('MostWarehouseTroopsDead'))
        {
            count = 0;
            foreach AllActors(class'UNATCOTroop', troop)
                count++;

            // if two or less are still alive
            if (count <= 2)
                flags.SetBool('MostWarehouseTroopsDead', True);
        }
    }
}

// Vanilla Matters: Fix a problem with Paul's raid-starting conversation being triggered inconsistently.
function Tick( float deltaTime ) {
    local int vital, limb;
    local ScriptedPawn pawn;
    local PaulDenton Paul;
    local FlagTrigger ft;

    super.Tick( deltaTime );

    if ( localURL == "04_NYC_HOTEL" ) {
        if ( flags != none && !flags.GetBool( 'M04RaidTeleportDone' ) && flags.GetBool( 'ApartmentEntered' ) && flags.GetBool( 'NSFSignalSent' ) ) {
            if ( flags.GetBool( 'TalkedToPaulAfterMessage_Played' ) ) {
                foreach AllActors( class'ScriptedPawn', pawn ) {
                    if ( pawn.IsA( 'UNATCOTroop' ) || pawn.IsA( 'MIB' ) ) {
                        pawn.EnterWorld();
                    }
                    else if ( pawn.IsA( 'SandraRenton' ) || pawn.IsA( 'GilbertRenton' ) || pawn.IsA( 'HarleyFilben' ) ) {
                        pawn.LeaveWorld();
                    }
                }

                // Vanilla Matters: Make Paul walk all the way to the door instead of just the lobby, by moving the Leaving trigger to near the door.
                foreach AllActors( class'FlagTrigger', ft ) {
                    if ( ft.Name == 'FlagTrigger2' ) {
                        ft.SetLocation( vect( -413, 0, -49 ) );

                        break;
                    }
                }

                flags.SetBool( 'M04RaidTeleportDone', True,, 5 );
            }
            else {
                foreach AllActors( class'PaulDenton', Paul ) {
                    // VM: Only trigger the convo if within range.
                    if ( VSize( Paul.Location - Player.Location ) <= 70 ) {
                        Paul.bInvincible = false;

                        Player.StartConversationByName( 'TalkedToPaulAfterMessage', Paul, False, False );
                    }

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
     VM_RescueReward=500
     VM_RescueRewardMsg="You helped Paul to safety"
}
