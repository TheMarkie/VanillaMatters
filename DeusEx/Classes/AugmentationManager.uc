//=============================================================================
// AugmentationManager
//=============================================================================
class AugmentationManager extends Actor
    intrinsic;

struct S_AugInfo
{
    var int NumSlots;
    var int AugCount;
    var int KeyBase;
};

var travel S_AugInfo AugLocs[7];
var DeusExPlayer Player;                // which player am I attached to?
var travel Augmentation FirstAug;       // Pointer to first Augmentation

// All the available augmentations
var Class<Augmentation> augClasses[25];
var Class<Augmentation> defaultAugs[3];

var localized string AugLocationFull;
var localized String NoAugInSlot;

// Vanilla Matters
var() travel float VM_energyMult;

var travel int VM_realAugCount[7];      // Count of only the activatable augs in an aug location. For hotkey assignment purposes.

var travel Augmentation VM_augSlots[11]; // Represent the "aug bar".

// ----------------------------------------------------------------------
// Network Replication
// ----------------------------------------------------------------------

replication
{

    //variables server to client
    reliable if ((Role == ROLE_Authority) && (bNetOwner))
        AugLocs, FirstAug, Player;

    //functions client to server
    reliable if (Role < ROLE_Authority)
        ActivateAugByKey, AddAllAugs, SetAllAugsToMaxLevel, ActivateAll, DeactivateAll, GivePlayerAugmentation;

}

// Vanilla Matters: Make sure augs are updated to the latest changes.
function RefreshesAugs() {
    local Augmentation anAug;

    anAug = FirstAug;

    while ( anAug != None ) {
        anAug.bAlwaysActive = anAug.default.bAlwaysActive;

        if ( anAug.bHasIt && ( anAug.bIsActive || anAug.bAlwaysActive ) ) {
            anAug.GoToState( 'Inactive' );
            anAug.GoToState( 'Active' );
            anAug.bIsActive = true;
        }

        anAug = anAug.next;
    }
}

// ----------------------------------------------------------------------
// CreateAugmentations()
// ----------------------------------------------------------------------

function CreateAugmentations(DeusExPlayer newPlayer)
{
    local int augIndex;
    local Augmentation anAug;
    local Augmentation lastAug;

    FirstAug = None;
    LastAug  = None;

    player = newPlayer;

    for(augIndex=0; augIndex<arrayCount(augClasses); augIndex++)
    {
        if (augClasses[augIndex] != None)
        {
            anAug = Spawn(augClasses[augIndex], Self);
            anAug.Player = player;

            // Manage our linked list
            if (anAug != None)
            {
                if (FirstAug == None)
                {
                    FirstAug = anAug;
                }
                else
                {
                    LastAug.next = anAug;
                }

                LastAug  = anAug;
            }
        }
    }
}

// ----------------------------------------------------------------------
// AddDefaultAugmentations()
// ----------------------------------------------------------------------

function AddDefaultAugmentations()
{
    local int augIndex;

    for(augIndex=0; augIndex<arrayCount(defaultAugs); augIndex++)
    {
        if (defaultAugs[augIndex] != None)
            GivePlayerAugmentation(defaultAugs[augIndex]);
    }
}

// ----------------------------------------------------------------------
// RefreshAugDisplay()
//
// Refreshes the Augmentation display with all the augs that are
// currently active.
// ----------------------------------------------------------------------

simulated function RefreshAugDisplay()
{
    // Vanilla Matters
    local int i;

    if (player == None)
        return;

    // First make sure there are no augs visible in the display
    player.ClearAugmentationDisplay();

    // Vanilla Matters: Show only augs from the aug bar that are active.
    // VM: Always show flash light first.
    if ( VM_augSlots[10] != none ) {
        player.AddAugmentationDisplay( VM_augSlots[10] );
    }

    for ( i = 0; i < 10; i++ ) {
        if ( VM_augSlots[i] != none && ( VM_augSlots[i].bIsActive || player.bHUDShowAllAugs ) ) {
            player.AddAugmentationDisplay( VM_augSlots[i] );
        }
    }
}

// ----------------------------------------------------------------------
// NumAugsActive()
//
// How many augs are currently active?
// ----------------------------------------------------------------------

simulated function int NumAugsActive()
{
    local Augmentation anAug;
    local int count;

    if (player == None)
        return 0;

    count = 0;
    anAug = FirstAug;
    while(anAug != None)
    {
        if (anAug.bHasIt && anAug.bIsActive && !anAug.bAlwaysActive)
            count++;

        anAug = anAug.next;
    }

    return count;
}

// ----------------------------------------------------------------------
// SetPlayer()
// ---------------------------------------------------------------------

function SetPlayer(DeusExPlayer newPlayer)
{
    local Augmentation anAug;

    player = newPlayer;

    anAug = FirstAug;
    while(anAug != None)
    {
        anAug.player = player;
        anAug = anAug.next;
    }
}

// ----------------------------------------------------------------------
// BoostAugs()
// ----------------------------------------------------------------------

// Vanilla Matters: Improve the awful vanilla code which needs to be run periodically and costs performance.
function BoostAugs( bool bBoostEnabled, Augmentation augBoosting ) {
    local Augmentation anAug;

    anAug = FirstAug;

    while ( anAug != None ) {
        if ( anAug != augBoosting ) {
            if ( bBoostEnabled ) {
                if ( anAug.CurrentLevel < anAug.MaxLevel && !anAug.bBoosted ) {
                    anAug.CurrentLevel = anAug.CurrentLevel + 1;

                    if ( anAug.bIsActive || anAug.bAlwaysActive ) {
                        anAug.GoToState( 'Inactive' );
                        anAug.GoToState( 'Active' );
                    }

                    anAug.bBoosted = true;
                }
            }
            else if ( anAug.bBoosted ) {
                anAug.CurrentLevel = anAug.CurrentLevel - 1;

                if ( anAug.bIsActive || anAug.bAlwaysActive ) {
                    anAug.GoToState( 'Inactive' );
                    anAug.GoToState( 'Active' );
                }

                anAug.bBoosted = false;
            }
        }

        anAug = anAug.next;
    }
}

// ----------------------------------------------------------------------
// GetClassLevel()
// this returns the level, but only if the augmentation is
// currently turned on
// ----------------------------------------------------------------------

simulated function int GetClassLevel(class<Augmentation> augClass)
{
    local Augmentation anAug;

    anAug = FirstAug;
    while(anAug != None)
    {
        if (anAug.Class == augClass)
        {
            if (anAug.bHasIt && anAug.bIsActive)
                return anAug.CurrentLevel;
            else
                return -1;
        }

        anAug = anAug.next;
    }

    return -1;
}

// ----------------------------------------------------------------------
// GetAugLevelValue()
//
// takes a class instead of being called by actual augmentation
// ----------------------------------------------------------------------

simulated function float GetAugLevelValue(class<Augmentation> AugClass)
{
    local Augmentation anAug;
    local float retval;

    retval = 0;

    anAug = FirstAug;
    while(anAug != None)
    {
        if (anAug.Class == augClass)
        {
            if (anAug.bHasIt && anAug.bIsActive)
                return anAug.LevelValues[anAug.CurrentLevel];
            else
                return -1.0;
        }

        anAug = anAug.next;
    }

    return -1.0;
}

// ----------------------------------------------------------------------
// ActivateAll()
//
// Loops through all the Augmentations, deactivating any that are active.
// ----------------------------------------------------------------------

function ActivateAll()
{
    local Augmentation anAug;

    // Only allow this if the player still has
    // Bioleectric Energy(tm)

    if ((player != None) && (player.Energy > 0))
    {
        anAug = FirstAug;
        while(anAug != None)
        {
         if ( (Level.NetMode == NM_Standalone) || (!anAug.IsA('AugLight')) )
            anAug.Activate();
            anAug = anAug.next;
        }
    }
}

// ----------------------------------------------------------------------
// DeactivateAll()
//
// Loops through all the Augmentations, deactivating any that are active.
// ----------------------------------------------------------------------

function DeactivateAll()
{
    local Augmentation anAug;

    anAug = FirstAug;
    while(anAug != None)
    {
        if (anAug.bIsActive)
            anAug.Deactivate();
        anAug = anAug.next;
    }
}

// ----------------------------------------------------------------------
// FindAugmentation()
//
// Returns the augmentation based on the class name
// ----------------------------------------------------------------------

simulated function Augmentation FindAugmentation(Class<Augmentation> findClass)
{
    local Augmentation anAug;

    anAug = FirstAug;
    while(anAug != None)
    {
        if (anAug.Class == findClass)
            break;

        anAug = anAug.next;
    }

    return anAug;
}

// ----------------------------------------------------------------------
// GivePlayerAugmentation()
// ----------------------------------------------------------------------

function Augmentation GivePlayerAugmentation(Class<Augmentation> giveClass)
{
    local Augmentation anAug;

    // Checks to see if the player already has it.  If so, we want to
    // increase the level
    anAug = FindAugmentation(giveClass);

    if (anAug == None)
        return None;        // shouldn't happen, but you never know!

    if (anAug.bHasIt)
    {
        anAug.IncLevel();
        return anAug;
    }

    if (AreSlotsFull(anAug))
    {
        Player.ClientMessage(AugLocationFull);
        return anAug;
    }

    anAug.bHasIt = True;

    if (anAug.bAlwaysActive)
    {
        anAug.bIsActive = True;
        anAug.GotoState('Active');
    }
    else
    {
        anAug.bIsActive = False;
    }


    if ( Player.Level.Netmode == NM_Standalone )
        Player.ClientMessage(Sprintf(anAug.AugNowHaveAtLevel, anAug.AugmentationName, anAug.CurrentLevel + 1));

    // Manage our AugLocs[] array
    AugLocs[anAug.AugmentationLocation].augCount++;

    // Vanilla Matters: Assign hotkeys using our method so we don't get always active augs taking up hotkey slots.
    if ( Level.NetMode == NM_Standalone ) {
        if ( !anAug.bAlwaysActive ) {
            if ( anAug.class != class'AugLight' ) {
                anAug.HotKeyNum = GetEmptyAugSlot();
                if ( anAug.HotKeyNum >= 0 ) {
                    VM_augSlots[anAug.HotKeyNum] = anAug;
                }
            }
            else {
                anAug.HotKeyNum = 10;
                VM_augSlots[10] = anAug;
            }
        }
        else {
            anAug.HotKeyNum = -1;
        }
    }
    else {
        anAug.HotKeyNum = anAug.MPConflictSlot + 2;
    }

    // Vanilla Matters: Augs are now displayed by their aug bar order.

    // Vanilla Matters: Refresh the display just in case.
    if ( !anAug.bAlwaysActive ) {
        RefreshAugDisplay();
    }

    return anAug;
}

// Vanilla Matters: Get a free slot on the aug bar.
function int GetEmptyAugSlot() {
    local int i;

    for ( i = 0; i < 10; i++ ) {
        if ( VM_augSlots[i] == none ) {
            break;
        }
    }

    if ( i >= 10 ) {
        i = -1;
    }

    return i;
}

// ----------------------------------------------------------------------
// AreSlotsFull()
//
// For the given Augmentation passed in, checks to see if the slots
// for this aug are already filled up.  This is used to prevent to
// prevent the player from adding more augmentations than the slots
// can accomodate.
// ----------------------------------------------------------------------

simulated function Bool AreSlotsFull(Augmentation augToCheck)
{
    local int num;
   local bool bHasMPConflict;
    local Augmentation anAug;

    // You can only have a limited number augmentations in each location,
    // so here we check to see if you already have the maximum allowed.

    num = 0;
   bHasMPConflict = false;
    anAug = FirstAug;
    while(anAug != None)
    {
        if (anAug.AugmentationName != "")
            if (augToCheck != anAug)
            if (Level.Netmode == NM_Standalone)
            {
               if (augToCheck.AugmentationLocation == anAug.AugmentationLocation)
                  if (anAug.bHasIt)
                     num++;
            }
            else
            {
               if ((AnAug.MPConflictSlot == AugToCheck.MPConflictSlot) && (AugToCheck.MPConflictSlot != 0) && (AnAug.bHasIt))
               {
                  bHasMPConflict = true;
               }
            }
        anAug = anAug.next;
    }
    if (Level.NetMode == NM_Standalone)
      return (num >= AugLocs[augToCheck.AugmentationLocation].NumSlots);
   else
      return bHasMPConflict;
}

// ----------------------------------------------------------------------
// CalcEnergyUse()
//
// Calculates energy use for all active augmentations
// ----------------------------------------------------------------------

// Vanilla Matters: Just rewriting the function to be less messy.
simulated function Float CalcEnergyUse( float deltaTime )
{
    local float energyUse, energyMult;
    local Augmentation anAug;

    energyUse = 0;
    energyMult = 1.0;

    anAug = FirstAug;
    while( anAug != None ) {
        if ( anAug.bHasIt ) {
            if ( anAug.bIsActive ) {
                energyUse = energyUse + ( ( anAug.GetEnergyRate() / 60 ) * deltaTime );
            }

            // VM: Get immediate drain rate regardless of active or not.
            energyUse = energyUse + anAug.GetImmediateEnergyRate();
        }

        anAug = anAug.next;
    }

    energyUse = energyUse * VM_energyMult;

    return energyUse;
}

// ----------------------------------------------------------------------
// AddAllAugs()
// ----------------------------------------------------------------------

function AddAllAugs()
{
    local int augIndex;

    // Loop through all the augmentation classes and create
    // any augs that don't exist.  Then set them all to the
    // maximum level.

    for(augIndex=0; augIndex<arrayCount(augClasses); augIndex++)
    {
        if (augClasses[augIndex] != None)
            GivePlayerAugmentation(augClasses[augIndex]);
    }
}

// ----------------------------------------------------------------------
// SetAllAugsToMaxLevel()
// ----------------------------------------------------------------------

function SetAllAugsToMaxLevel()
{
    local Augmentation anAug;

    anAug = FirstAug;
    while(anAug != None)
    {
        if (anAug.bHasIt)
            anAug.CurrentLevel = anAug.MaxLevel;

        anAug = anAug.next;
    }
}

// ----------------------------------------------------------------------
// IncreaseAllAugs()
// ----------------------------------------------------------------------

function IncreaseAllAugs(int Amount)
{
   local Augmentation anAug;

   anAug = FirstAug;
   while(anAug != None)
   {
      if (anAug.bHasIt)
         anAug.CurrentLevel = Min(anAug.CurrentLevel + Amount, anAug.MaxLevel);

      anAug = anAug.next;
   }
}

// ----------------------------------------------------------------------
// ActivateAugByKey()
// ----------------------------------------------------------------------

function bool ActivateAugByKey(int keyNum)
{
    local Augmentation anAug;
    local bool bActivated;

    bActivated = False;

    // Vanilla Matters: Check the aug bar only instead of all augs.
    if ( keyNum >= 0 && keyNum < 11 ) {
        if ( VM_augSlots[keyNum] != none ) {
            if ( VM_augSlots[keyNum].bIsActive ) {
                VM_augSlots[keyNum].Deactivate();
            }
            else {
                VM_augSlots[keyNum].Activate();
            }
        }
        else {
            player.ClientMessage( NoAugInSlot );
        }
    }

    return bActivated;
}

// ----------------------------------------------------------------------
// ResetAugmentations()
// ----------------------------------------------------------------------

function ResetAugmentations()
{
    local Augmentation anAug;
    local Augmentation nextAug;
    local int LocIndex;

    anAug = FirstAug;
    while(anAug != None)
    {
        nextAug = anAug.next;
        anAug.Destroy();
        anAug = nextAug;
    }

    FirstAug = None;

    //Must also clear auglocs.
    for (LocIndex = 0; LocIndex < 7; LocIndex++)
    {
        AugLocs[LocIndex].AugCount = 0;

        // Vanilla Matters: Reset activatable aug count.
        VM_realAugCount[LocIndex] = 0;
    }

    // Vanilla Matters: Clear aug bar.
    for ( LocIndex = 0; LocIndex < 11; LocIndex++ ) {
        VM_augSlots[LocIndex] = none;
    }
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     AugLocs(0)=(NumSlots=1,KeyBase=4)
     AugLocs(1)=(NumSlots=1,KeyBase=7)
     AugLocs(2)=(NumSlots=3,KeyBase=8)
     AugLocs(3)=(NumSlots=1,KeyBase=5)
     AugLocs(4)=(NumSlots=1,KeyBase=6)
     AugLocs(5)=(NumSlots=2,KeyBase=2)
     AugLocs(6)=(NumSlots=3,KeyBase=11)
     augClasses(0)=Class'DeusEx.AugSpeed'
     augClasses(1)=Class'DeusEx.AugTarget'
     augClasses(2)=Class'DeusEx.AugCloak'
     augClasses(3)=Class'DeusEx.AugBallistic'
     augClasses(4)=Class'DeusEx.AugRadarTrans'
     augClasses(5)=Class'DeusEx.AugShield'
     augClasses(6)=Class'DeusEx.AugEnviro'
     augClasses(7)=Class'DeusEx.AugCombat'
     augClasses(8)=Class'DeusEx.AugHealing'
     augClasses(9)=Class'DeusEx.AugStealth'
     augClasses(10)=Class'DeusEx.AugIFF'
     augClasses(11)=Class'DeusEx.AugLight'
     augClasses(12)=Class'DeusEx.AugMuscle'
     augClasses(13)=Class'DeusEx.AugVision'
     augClasses(14)=Class'DeusEx.AugDrone'
     augClasses(15)=Class'DeusEx.AugDefense'
     augClasses(16)=Class'DeusEx.AugAqualung'
     augClasses(17)=Class'DeusEx.AugDatalink'
     augClasses(18)=Class'DeusEx.AugHeartLung'
     augClasses(19)=Class'DeusEx.AugPower'
     defaultAugs(0)=Class'DeusEx.AugLight'
     defaultAugs(1)=Class'DeusEx.AugIFF'
     defaultAugs(2)=Class'DeusEx.AugDatalink'
     AugLocationFull="You can't add any more augmentations to that location!"
     NoAugInSlot="There is no augmentation in that slot"
     VM_energyMult=1.000000
     bHidden=True
     bTravel=True
}
