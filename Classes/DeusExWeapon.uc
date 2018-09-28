//=============================================================================
// DeusExWeapon.
//=============================================================================
class DeusExWeapon extends Weapon
	abstract;

//
// enums for weapons (duh)
//
enum EEnemyEffective
{
	ENMEFF_All,
	ENMEFF_Organic,
	ENMEFF_Robot
};

enum EEnviroEffective
{
	ENVEFF_All,
	ENVEFF_Air,
	ENVEFF_Water,
	ENVEFF_Vacuum,
	ENVEFF_AirWater,
	ENVEFF_AirVacuum,
	ENVEFF_WaterVacuum
};

enum EConcealability
{
	CONC_None,
	CONC_Visual,
	CONC_Metal,
	CONC_All
};

enum EAreaType
{
	AOE_Point,
	AOE_Cone,
	AOE_Sphere
};

enum ELockMode
{
	LOCK_None,
	LOCK_Invalid,
	LOCK_Range,
	LOCK_Acquire,
	LOCK_Locked
};

var bool				bReadyToFire;			// true if our bullets are loaded, etc.
var() int				LowAmmoWaterMark;		// critical low ammo count
var travel int			ClipCount;				// number of bullets remaining in current clip

var() class<Skill>		GoverningSkill;			// skill that affects this weapon
var() travel float		NoiseLevel;				// amount of noise that weapon makes when fired
var() EEnemyEffective	EnemyEffective;			// type of enemies that weapon is effective against
var() EEnviroEffective	EnviroEffective;		// type of environment that weapon is effective in
var() EConcealability	Concealability;			// concealability of weapon
var() travel bool		bAutomatic;				// is this an automatic weapon?
var() travel float		ShotTime;				// number of seconds between shots
var() travel float		ReloadTime;				// number of seconds needed to reload the clip
var() int				HitDamage;				// damage done by a single shot (or for shotguns, a single slug)
var() int				MaxRange;				// absolute maximum range in world units (feet * 16)
var() travel int		AccurateRange;			// maximum accurate range in world units (feet * 16)
var() travel float		BaseAccuracy;			// base accuracy (0.0 is dead on, 1.0 is far off)

var bool				bCanHaveScope;			// can this weapon have a scope?
var() travel bool		bHasScope;				// does this weapon have a scope?
var() int				ScopeFOV;				// FOV while using scope
var bool				bZoomed;				// are we currently zoomed?
var bool				bWasZoomed;				// were we zoomed? (used during reloading)

var bool				bCanHaveLaser;			// can this weapon have a laser sight?
var() travel bool		bHasLaser;				// does this weapon have a laser sight?
var bool				bLasing;				// is the laser sight currently on?
var LaserEmitter		Emitter;				// actual laser emitter - valid only when bLasing == True

var bool				bCanHaveSilencer;		// can this weapon have a silencer?
var() travel bool		bHasSilencer;			// does this weapon have a silencer?

var() bool				bCanTrack;				// can this weapon lock on to a target?
var() float				LockTime;				// how long the target must stay targetted to lock
var float				LockTimer;				// used for lock checking
var float            MaintainLockTimer;   // Used for maintaining a lock even after moving off target.
var Actor            LockTarget;          // Used for maintaining a lock even after moving off target.
var Actor				Target;					// actor currently targetted
var ELockMode			LockMode;				// is this target locked?
var string				TargetMessage;			// message to print during targetting
var float				TargetRange;			// range to current target
var() Sound				LockedSound;			// sound to play when locked
var() Sound				TrackingSound;			// sound to play while tracking a target
var float				SoundTimer;				// to time the sounds correctly

var() class<Ammo>		AmmoNames[3];			// three possible types of ammo per weapon
var() class<Projectile> ProjectileNames[3];		// projectile classes for different ammo
var() EAreaType			AreaOfEffect;			// area of effect of the weapon
var() bool				bPenetrating;			// shot will penetrate and cause blood
var() float				StunDuration;			// how long the shot stuns the target
var() bool				bHasMuzzleFlash;		// does this weapon have a flash when fired?
var() bool				bHandToHand;			// is this weapon hand to hand (no ammo)?
var globalconfig vector SwingOffset;     // offsets for this weapon swing.
var() travel float		recoilStrength;			// amount that the weapon kicks back after firing (0.0 is none, 1.0 is large)
var bool				bFiring;				// True while firing, used for recoil
var bool				bOwnerWillNotify;		// True if firing hand-to-hand weapons is dependent on the owner's animations
var bool				bFallbackWeapon;		// If True, only use if no other weapons are available
var bool				bNativeAttack;			// True if weapon represents a native attack
var bool				bEmitWeaponDrawn;		// True if drawing this weapon should make NPCs react
var bool				bUseWhileCrouched;		// True if NPCs should crouch while using this weapon
var bool				bUseAsDrawnWeapon;		// True if this weapon should be carried by NPCs as a drawn weapon
var bool				bWasInFiring;

var bool bNearWall;								// used for prox. mine placement
var Vector placeLocation;						// used for prox. mine placement
var Vector placeNormal;							// used for prox. mine placement
var Mover placeMover;							// used for prox. mine placement

var float ShakeTimer;
var float ShakeYaw;
var float ShakePitch;

var float AIMinRange;							// minimum "best" range for AI; 0=default min range
var float AIMaxRange;							// maximum "best" range for AI; 0=default max range
var float AITimeLimit;							// maximum amount of time an NPC should hold the weapon; 0=no time limit
var float AIFireDelay;							// Once fired, use as fallback weapon until the timeout expires; 0=no time limit

var float standingTimer;						// how long we've been standing still (to increase accuracy)
var float currentAccuracy;						// what the currently calculated accuracy is (updated every tick)

var MuzzleFlash flash;							// muzzle flash actor

var float MinSpreadAcc;        // Minimum accuracy for multiple slug weapons (shotgun).  Affects only multiplayer,
                               // keeps shots from all going in same place (ruining shotgun effect)
var float MinProjSpreadAcc;
var float MinWeaponAcc;        // Minimum accuracy for a weapon at all.  Affects only multiplayer.
var bool bNeedToSetMPPickupAmmo;

var bool	bDestroyOnFinish;

var float	mpReloadTime;			
var int		mpHitDamage;
var float	mpBaseAccuracy;
var int		mpAccurateRange;
var int		mpMaxRange;
var int		mpReloadCount;
var int		mpPickupAmmoCount;

// Used to track weapon mods accurately.
var bool bCanHaveModBaseAccuracy;
var bool bCanHaveModReloadCount;
var bool bCanHaveModAccurateRange;
var bool bCanHaveModReloadTime;
var bool bCanHaveModRecoilStrength;
var travel float ModBaseAccuracy;
var travel float ModReloadCount;
var travel float ModAccurateRange;
var travel float ModReloadTime;
var travel float ModRecoilStrength;

var localized String msgCannotBeReloaded;
var localized String msgOutOf;
var localized String msgNowHas;
var localized String msgAlreadyHas;
var localized String msgNone;
var localized String msgLockInvalid;
var localized String msgLockRange;
var localized String msgLockAcquire;
var localized String msgLockLocked;
var localized String msgRangeUnit;
var localized String msgTimeUnit;
var localized String msgMassUnit;
var localized String msgNotWorking;

//
// strings for info display
//
var localized String msgInfoAmmoLoaded;
var localized String msgInfoAmmo;
var localized String msgInfoDamage;
var localized String msgInfoClip;
var localized String msgInfoROF;
var localized String msgInfoReload;
var localized String msgInfoRecoil;
var localized String msgInfoAccuracy;
var localized String msgInfoAccRange;
var localized String msgInfoMaxRange;
var localized String msgInfoMass;
var localized String msgInfoLaser;
var localized String msgInfoScope;
var localized String msgInfoSilencer;
var localized String msgInfoNA;
var localized String msgInfoYes;
var localized String msgInfoNo;
var localized String msgInfoAuto;
var localized String msgInfoSingle;
var localized String msgInfoRounds;
var localized String msgInfoRoundsPerSec;
var localized String msgInfoSkill;
var localized String msgInfoWeaponStats;

var bool		bClientReadyToFire, bClientReady, bInProcess, bFlameOn, bLooping;
var int		SimClipCount, flameShotCount, SimAmmoAmount;
var float	TimeLockSet;

// Vanilla Matters
var() bool		VM_bAlwaysAccurate;				// Accuracy does not affect this weapon if set to true.
var() bool		VM_pumpAction;					// Reloads one by one.
var() int		VM_ShotCount[4];				// How many shots come out for each unit of ammo. Applies to both projectile and trace weapons.
var() float		VM_SpreadHorWithShotCount;		// Spread the shots as count goes up. Vanilla already does but relies on accuracy, meaning high accuracy would cram all the shots into one place.
var() float		VM_SpreadVerWithShotCount;		// Apply for projectile weapons only. If spread is 0, then only vanilla spread applies.

var() float		VM_ShotBreaksStuff[4];			// Make projectiles break doors/lids with a multiplier. Trace weapons already do, but use this for multiplier.

var() float		VM_HeadshotMult[4];

var() float		VM_baseStandingRate;			// Base standing bonus building rate.
var() float		VM_standingBonus;				// Max accuracy bonus for standing still.

var float		VM_recoilForce;
var float		VM_recoilPenalty;
var() float		VM_recoilRate;

var rotator		VM_recoilRecovery;
var rotator		VM_lastPlayerRotation;

var float			VM_modTimer;					// Timer before laser/scope mods become effective.
var() travel float	VM_modTimerMax;					// The max duration before they become effective. Scales with CombatDifficulty: modTimerMax * CombatDifficulty.

var bool		VM_readyFire;						// If the gun is ready to be fired.

var bool		VM_stopReload;

var Texture		VM_handsTex;						// Hands texture.
var int			VM_handsTexPos[2];					// Positions in the MultiSkins where they use WeaponHandsTex, so we can replace those.

var localized String VM_msgInfoIgnite;				// If an ammo type has the VM_IgnitesOnHit property then it's displayed to notify players.
var localized String VM_msgInfoHeadshot;			// Label the headshot multipler section.
var localized String VM_msgFullClip;
var localized String VM_msgNoAmmo;

//
// network replication
//
replication
{
    // server to client
    reliable if ((Role == ROLE_Authority) && (bNetOwner))
        ClipCount, bZoomed, bHasSilencer, bHasLaser, ModBaseAccuracy, ModReloadCount, ModAccurateRange, ModReloadTime, ModRecoilStrength;

	// Things the client should send to the server
	//reliable if ( (Role<ROLE_Authority) )
		//LockTimer, Target, LockMode, TargetMessage, TargetRange, bCanTrack, LockTarget;

    // Functions client calls on server
    reliable if ( Role < ROLE_Authority )
        ReloadAmmo, LoadAmmo, CycleAmmo, LaserOn, LaserOff, LaserToggle, ScopeOn, ScopeOff, ScopeToggle, PropagateLockState, ServerForceFire, 
		  ServerGenerateBullet, ServerGotoFinishFire, ServerHandleNotify, StartFlame, StopFlame, ServerDoneReloading, DestroyOnFinish;

    // Functions Server calls in client
    reliable if ( Role == ROLE_Authority )
      RefreshScopeDisplay, ReadyClientToFire, SetClientAmmoParams, ClientDownWeapon, ClientActive, ClientReload;
}

// ---------------------------------------------------------------------
// PropagateLockState()
// ---------------------------------------------------------------------
simulated function PropagateLockState(ELockMode NewMode, Actor NewTarget)
{
   LockMode = NewMode;
   LockTarget = NewTarget;
}

// ---------------------------------------------------------------------
// SetLockMode()
// ---------------------------------------------------------------------
simulated function SetLockMode(ELockMode NewMode)
{
   if ((LockMode != NewMode) && (Role != ROLE_Authority))
   {
      if (NewMode != LOCK_Locked)
         PropagateLockState(NewMode, None);
      else
         PropagateLockState(NewMode, Target);
   }
	TimeLockSet = Level.Timeseconds;
   LockMode = NewMode;
}

// ---------------------------------------------------------------------
// PlayLockSound()
// Because playing a sound from a simulated function doesn't play it 
// server side.
// ---------------------------------------------------------------------
function PlayLockSound()
{
   Owner.PlaySound(LockedSound, SLOT_None);
}

//
// install the correct projectile info if needed
//
function TravelPostAccept()
{
	local int i;

	Super.TravelPostAccept();

	// make sure the AmmoName matches the currently loaded AmmoType
	if (AmmoType != None)
		AmmoName = AmmoType.Class;

	if (!bInstantHit)
	{
		if (ProjectileClass != None)
			ProjectileSpeed = ProjectileClass.Default.speed;

		// make sure the projectile info matches the actual AmmoType
		// since we can't "var travel class" (AmmoName and ProjectileClass)
		if (AmmoType != None)
		{
			FireSound = None;
			for (i=0; i<ArrayCount(AmmoNames); i++)
			{
				if (AmmoNames[i] == AmmoName)
				{
					ProjectileClass = ProjectileNames[i];
					break;
				}
			}
		}
	}
}


//
// PreBeginPlay
//

function PreBeginPlay()
{
	Super.PreBeginPlay();

	if ( Default.mpPickupAmmoCount == 0 )
	{
		Default.mpPickupAmmoCount = Default.PickupAmmoCount;
	}
}

//
// PostBeginPlay
//

function PostBeginPlay()
{
	Super.PostBeginPlay();
   if (Level.NetMode != NM_Standalone)
   {
      bWeaponStay = True;
      if (bNeedToSetMPPickupAmmo)
      {
         PickupAmmoCount = PickupAmmoCount * 3;
         bNeedToSetMPPickupAmmo = False;
      }
   }
}

// Vanilla Matters: Override to add in colored hands skin.
simulated function RenderOverlays( Canvas canvas ) {
	local int i;
	local DeusExPlayer player;

	if ( VM_handsTex == none ) {
		player = DeusExPlayer( Owner );
		if ( player != none ) {
			if ( WeaponMiniCrossbow( self ) == none ) {
				VM_handsTex = player.GetHandsSkin();
			}
			else {
				VM_handsTex = player.GetCrossbowHandsSkin();
			}
		}
	}

	if ( Mesh == PlayerViewMesh ) {
		for ( i = 0; i < 2; i++ ) {
			if ( VM_handsTexPos[i] >= 0 ) {
				MultiSkins[VM_handsTexPos[i]] = VM_handsTex;
			}
		}
	}
	else {
		for ( i = 0; i < 2; i++ ) {
			if ( VM_handsTexPos[i] >= 0 ) {
				MultiSkins[VM_handsTexPos[i]] = none;
			}
		}
	}

	super.RenderOverlays( canvas );
}

singular function BaseChange()
{
	Super.BaseChange();

	// Make sure we fall if we don't have a base
	if ((base == None) && (Owner == None))
		SetPhysics(PHYS_Falling);
}

function bool HandlePickupQuery(Inventory Item)
{
	local DeusExWeapon W;
	local DeusExPlayer player;
	local bool bResult;
	local class<Ammo> defAmmoClass;
	local Ammo defAmmo;
	
	// make sure that if you pick up a modded weapon that you
	// already have, you get the mods
	W = DeusExWeapon(Item);
	if ((W != None) && (W.Class == Class))
	{
		if (W.ModBaseAccuracy > ModBaseAccuracy)
			ModBaseAccuracy = W.ModBaseAccuracy;
		if (W.ModReloadCount > ModReloadCount)
			ModReloadCount = W.ModReloadCount;
		if (W.ModAccurateRange > ModAccurateRange)
			ModAccurateRange = W.ModAccurateRange;

		// these are negative
		if (W.ModReloadTime < ModReloadTime)
			ModReloadTime = W.ModReloadTime;
		if (W.ModRecoilStrength < ModRecoilStrength)
			ModRecoilStrength = W.ModRecoilStrength;

		if (W.bHasLaser)
			bHasLaser = True;
		if (W.bHasSilencer)
			bHasSilencer = True;
		if (W.bHasScope)
			bHasScope = True;

		// copy the actual stats as well
		if (W.ReloadCount > ReloadCount)
			ReloadCount = W.ReloadCount;
		if (W.AccurateRange > AccurateRange)
			AccurateRange = W.AccurateRange;

		// these are negative
		if (W.BaseAccuracy < BaseAccuracy)
			BaseAccuracy = W.BaseAccuracy;
		if (W.ReloadTime < ReloadTime)
			ReloadTime = W.ReloadTime;
		if (W.RecoilStrength < RecoilStrength)
			RecoilStrength = W.RecoilStrength;
	}
	player = DeusExPlayer(Owner);

	if (Item.Class == Class)
	{
      if (!( (Weapon(item).bWeaponStay && (Level.NetMode == NM_Standalone)) && (!Weapon(item).bHeldItem || Weapon(item).bTossedOut)))
		{
			// Only add ammo of the default type
			// There was an easy way to get 32 20mm shells, buy picking up another assault rifle with 20mm ammo selected
			if ( AmmoType != None )
			{
				// Add to default ammo only
				if ( AmmoNames[0] == None )
					defAmmoClass = AmmoName;
				else
					defAmmoClass = AmmoNames[0];

				defAmmo = Ammo(player.FindInventoryType(defAmmoClass));
				defAmmo.AddAmmo( Weapon(Item).PickupAmmoCount );

				if ( Level.NetMode != NM_Standalone )
				{
					if (( player != None ) && ( player.InHand != None ))
					{
						if ( DeusExWeapon(item).class == DeusExWeapon(player.InHand).class )
							ReadyToFire();
					}
				}
			}
		}
	}

	bResult = Super.HandlePickupQuery(Item);

	// Notify the object belt of the new ammo
	if (player != None)
		player.UpdateBeltText(Self);

	return bResult;
}

function BringUp()
{
	if ( Level.NetMode != NM_Standalone )
		ReadyClientToFire( False );

	// alert NPCs that I'm whipping it out
	if (!bNativeAttack && bEmitWeaponDrawn)
		AIStartEvent('WeaponDrawn', EAITYPE_Visual);

	// reset the standing still accuracy bonus
	standingTimer = 0;

	Super.BringUp();
}

function bool PutDown()
{
	if ( Level.NetMode != NM_Standalone )
		ReadyClientToFire( False );

	// alert NPCs that I'm putting away my gun
	AIEndEvent('WeaponDrawn', EAITYPE_Visual);

	// reset the standing still accuracy bonus
	standingTimer = 0;

	return Super.PutDown();
}

// Vanilla Matters: Rewrite this function to handle different cases of reload.
function ReloadAmmo( optional bool bForce ) {
	local Pawn p;

	p = Pawn( Owner );

	if ( ReloadCount == 0 ) {
		p.ClientMessage( msgCannotBeReloaded );

		return;
	}

	// Vanilla Matters: Fix the bug where player can reload with a full clip. Also the exploit where triggering a reload animation can quicken equip animation.
	if ( !bForce && ClipCount <= 0 ) {
		p.ClientMessage( VM_msgFullClip );

		return;
	}

	// Vanilla Matters: Fix the bug where player can reload with no ammo left in storage.
	if ( !bForce && ( AmmoType.AmmoAmount - ( ReloadCount - ClipCount ) ) <= 0 ) {
		p.ClientMessage( VM_msgNoAmmo );

		return;
	}

	if ( !IsInState('Reload') ) {
		TweenAnim( 'Still', 0.1 );
		GotoState( 'Reload' );
	}
}

// Vanilla Matters: Make the function take into account where it's called for accuracy or damage, and provides appropriate values.
simulated function float GetWeaponSkill( optional bool forDamage ) {
	local DeusExPlayer player;
	local float value;

	value = 0;

	if ( Owner != None ) {
		player = DeusExPlayer( Owner );

		if ( player != None ) {
			if ( player.SkillSystem != None && player.AugmentationSystem != None ) {
				if ( !forDamage ) {
					value = player.AugmentationSystem.GetAugLevelValue( class'AugTarget' );

					if ( value == -1.0 ) {
						value = 0;
					}
				}
				else if ( bHandToHand ) {
					value = player.AugmentationSystem.GetAugLevelValue( class'AugCombat' );

					if ( value == -1.0 ) {
						value = 0;
					}

					value = value * -1.0;
				}

				value = value + player.SkillSystem.GetSkillLevelValue( GoverningSkill );
			}
		}
	}

	return value;
}

// Vanilla Matters: Fetch the skill level instead of trying to use the SkillSystem which takes more typing :)
function float GetWeaponSkillLevel() {
	local DeusExPlayer player;
	local float level;

	level = 0;

	if ( Owner != None ) {
		player = DeusExPlayer( Owner );

		if ( player != None ) {
			level = player.SkillSystem.GetSkillLevel( GoverningSkill );
		}
	}

	return level;
}

// calculate the accuracy for this weapon and the owner's damage
simulated function float CalculateAccuracy()
{
	local float accuracy;	// 0 is dead on, 1 is pretty far off
	local float tempacc, div;
	local float weapskill; // so we don't keep looking it up (slower).
	local int HealthArmRight, HealthArmLeft, HealthHead;
	local int BestArmRight, BestArmLeft, BestHead;
	local bool checkit;
	local DeusExPlayer player;

	// Vanilla Matters: Set accuracy to 0 (full accuracy) if the weapon is always accurate.
	if ( VM_bAlwaysAccurate ) {
		return 0.0;
	}

	accuracy = BaseAccuracy;		// start with the weapon's base accuracy
	weapskill = GetWeaponSkill();

	player = DeusExPlayer(Owner);

	if (player != None)
	{
		// check the player's skill
		// 0.0 = dead on, 1.0 = way off
		accuracy += weapskill;

		// get the health values for the player
		HealthArmRight = player.HealthArmRight;
		HealthArmLeft  = player.HealthArmLeft;
		HealthHead     = player.HealthHead;
		BestArmRight   = player.Default.HealthArmRight;
		BestArmLeft    = player.Default.HealthArmLeft;
		BestHead       = player.Default.HealthHead;
		checkit = True;
	}
	else if (ScriptedPawn(Owner) != None)
	{
		// update the weapon's accuracy with the ScriptedPawn's BaseAccuracy
		// (BaseAccuracy uses higher values for less accuracy, hence we add)
		accuracy += ScriptedPawn(Owner).BaseAccuracy;

		// get the health values for the NPC
		HealthArmRight = ScriptedPawn(Owner).HealthArmRight;
		HealthArmLeft  = ScriptedPawn(Owner).HealthArmLeft;
		HealthHead     = ScriptedPawn(Owner).HealthHead;
		BestArmRight   = ScriptedPawn(Owner).Default.HealthArmRight;
		BestArmLeft    = ScriptedPawn(Owner).Default.HealthArmLeft;
		BestHead       = ScriptedPawn(Owner).Default.HealthHead;
		checkit = True;
	}
	else
		checkit = False;

	// Disabled accuracy mods based on health in multiplayer
	if ( Level.NetMode != NM_Standalone )
		checkit = False;

	// Vanilla Matters: Apply the effectiveness of scope or laser dynamically over time.
	accuracy = FMax( accuracy * ( ( VM_modTimerMax - VM_modTimer ) / VM_modTimerMax ), 0 );

	// Vanilla Matters: Fix the scope nullifying the laser bonus.
	if ( bHasScope && !bZoomed && !bLasing ) {
		accuracy = accuracy + 0.2;
	}

	// Vanilla Matters: Change penalty values for states of health.
	if ( checkit ) {
		// if ( HealthArmRight <= 0 ) {
		// 	accuracy = accuracy + 0.6;
		// }
		// else if ( HealthArmRight <= ( BestArmRight * 0.33 ) ) {
		// 	accuracy = accuracy + 0.4;
		// }
		// else if ( HealthArmRight <= ( BestArmRight * 0.66 ) ) {
		// 	accuracy = accuracy + 0.2;
		// }

		// if ( HealthArmLeft <= 0 ) {
		// 	accuracy = accuracy + 0.2;
		// }
		// else if ( HealthArmLeft <= ( BestArmLeft * 0.33 ) ) {
		// 	accuracy = accuracy + 0.1;
		// }
		// else if ( HealthArmLeft <= ( BestArmLeft * 0.66 ) ) {
		// 	accuracy = accuracy + 0.05;
		// }

		// if ( HealthHead <= ( BestHead * 0.33 ) ) {
		// 	accuracy = accuracy + 0.4;
		// }
		// else if ( HealthHead <= ( BestHead * 0.66 ) ) {
		// 	accuracy = accuracy + 0.2;
		// }

		// Vanilla Matters: Health penalties now scale dynamically.
		// VM: AugMuscle helps with arm penalties.
		div = 1;
		if ( player != none ) {
			div = player.AugmentationSystem.GetClassLevel( class'AugMuscle' );
			if ( div == -1 ) {
				div = 1;
			}
			else {
				div = 1 - ( div * 0.1 );
			}

			// VM: Add flinching penalty.
			accuracy = accuracy + ( player.VM_flinchPenalty * div );
		}

		accuracy = accuracy + ( ( 1 - FMax( float( HealthArmRight ) / BestArmRight, 0 ) ) * 0.6 * div );
		accuracy = accuracy + ( ( 1 - FMax( float( HealthArmLeft ) / BestArmLeft, 0 ) ) * 0.4 * div );
		accuracy = accuracy + ( ( 1 - FMax( float( HealthHead ) / BestHead, 0 ) ) * 0.6 );
	}

	// increase accuracy (decrease value) if we haven't been moving for awhile
	// this only works for the player, because NPCs don't need any more aiming help!

	// Vanilla Matters: Handle standing bonus differently.
	if ( player != none ) {
		if ( standingTimer > 0 ) {
			div = ( VM_baseStandingRate + ( weapskill * 2 ) ) * 10;
			if ( player.bIsCrouching || player.bForceDuck ) {
				tempacc = VM_standingBonus * 1.5;
			}
			else {
				tempacc = VM_standingBonus;
			}

			accuracy = accuracy - ( ( standingTimer / div ) * tempacc );
		}

		accuracy = FMax( accuracy, 0 );

		if ( !bHandToHand && VM_recoilPenalty > 0 ) {
			accuracy = accuracy + VM_recoilPenalty;
		}
	}

	// Vanilla Matters: Weapons with shot count higher than 1 will be capped below 100% so that all the shots don't go in one place.
	accuracy = FClamp( accuracy, ( VM_ShotCount[GetWeaponSkillLevel()] - 1 ) * 0.05, 2 );
	
	if ( Level.NetMode != NM_Standalone ) {
		accuracy = FMax( accuracy, MinWeaponAcc );
	}

	return accuracy;
}

//
// functions to change ammo types
//
function bool LoadAmmo(int ammoNum)
{
	local class<Ammo> newAmmoClass;
	local Ammo newAmmo;
	local Pawn P;

	if ((ammoNum < 0) || (ammoNum > 2))
		return False;

	P = Pawn(Owner);

	// sorry, only pawns can have weapons
	if (P == None)
		return False;

	newAmmoClass = AmmoNames[ammoNum];

	if (newAmmoClass != None)
	{
		if (newAmmoClass != AmmoName)
		{
			newAmmo = Ammo(P.FindInventoryType(newAmmoClass));
			if (newAmmo == None)
			{
				P.ClientMessage(Sprintf(msgOutOf, newAmmoClass.Default.ItemName));
				return False;
			}
			
			// if we don't have a projectile for this ammo type, then set instant hit
			if (ProjectileNames[ammoNum] == None)
			{
				bInstantHit = True;
				bAutomatic = Default.bAutomatic;
				ShotTime = Default.ShotTime;
				if ( Level.NetMode != NM_Standalone )
				{
					ReloadTime = mpReloadTime;
				}
				else
				{
					ReloadTime = Default.ReloadTime;
				}

				// Vanilla Matters: Handles reload time bonus from mods in GetReloadTime.

				FireSound = Default.FireSound;
				ProjectileClass = None;
			}
			else
			{
				// otherwise, set us to fire projectiles
				bInstantHit = False;
				bAutomatic = False;
				ShotTime = 1.0;

				// Vanilla Matters: Handles reload time bonus from mods in GetReloadTime.

				FireSound = None;		// handled by the projectile
				ProjectileClass = ProjectileNames[ammoNum];
				ProjectileSpeed = ProjectileClass.Default.Speed;
			}

			AmmoName = newAmmoClass;
			AmmoType = newAmmo;

			// AlexB had a new sound for 20mm but there's no mechanism for playing alternate sounds per ammo type
			// Same for WP rocket
			if ( Ammo20mm(newAmmo) != None )
				FireSound=Sound'AssaultGunFire20mm';
			else if ( AmmoRocketWP(newAmmo) != None )
				FireSound=Sound'GEPGunFireWP';
			else if ( AmmoRocket(newAmmo) != None )
				FireSound=Sound'GEPGunFire';

			if ( Level.NetMode != NM_Standalone )
				SetClientAmmoParams( bInstantHit, bAutomatic, ShotTime, FireSound, ProjectileClass, ProjectileSpeed );

			// Notify the object belt of the new ammo
			if (DeusExPlayer(P) != None)
				DeusExPlayer(P).UpdateBeltText(Self);

			// Vanilla Matters: Force the reload with our own reload function, to prevent a situation where changing ammo would skip reloading.
			ReloadAmmo( true );

			P.ClientMessage(Sprintf(msgNowHas, ItemName, newAmmoClass.Default.ItemName));
			return True;
		}
		else
		{
			P.ClientMessage(Sprintf(MsgAlreadyHas, ItemName, newAmmoClass.Default.ItemName));
		}
	}

	return False;
}

// ----------------------------------------------------------------------
//
// ----------------------------------------------------------------------

simulated function SetClientAmmoParams( bool bInstant, bool bAuto, float sTime, Sound FireSnd, class<projectile> pClass, float pSpeed )
{
	bInstantHit = bInstant;
	bAutomatic = bAuto;
	ShotTime = sTime;
	FireSound = FireSnd;
	ProjectileClass = pClass;
	ProjectileSpeed = pSpeed;
}

// ----------------------------------------------------------------------
// CanLoadAmmoType()
//
// Returns True if this ammo type can be used with this weapon
// ----------------------------------------------------------------------

simulated function bool CanLoadAmmoType(Ammo ammo)
{
	local int  ammoIndex;
	local bool bCanLoad;

	bCanLoad = False;

	if (ammo != None)
	{
		// First check "AmmoName"

		if (AmmoName == ammo.Class)
		{
			bCanLoad = True;
		}
		else
		{
			for (ammoIndex=0; ammoIndex<3; ammoIndex++)
			{
				if (AmmoNames[ammoIndex] == ammo.Class)
				{
					bCanLoad = True;
					break;
				}
			}
		}
	}

	return bCanLoad;
}

// ----------------------------------------------------------------------
// LoadAmmoType()
// 
// Load this ammo type given the actual object
// ----------------------------------------------------------------------

function LoadAmmoType(Ammo ammo)
{
	local int i;

	if (ammo != None)
		for (i=0; i<3; i++)
			if (AmmoNames[i] == ammo.Class)
				LoadAmmo(i);
}

// ----------------------------------------------------------------------
// LoadAmmoClass()
// 
// Load this ammo type given the class
// ----------------------------------------------------------------------

function LoadAmmoClass(Class<Ammo> ammoClass)
{
	local int i;

	if (ammoClass != None)
		for (i=0; i<3; i++)
			if (AmmoNames[i] == ammoClass)
				LoadAmmo(i);
}

// ----------------------------------------------------------------------
// CycleAmmo()
// ----------------------------------------------------------------------

function CycleAmmo()
{
	local int i, last;

	if (NumAmmoTypesAvailable() < 2)
		return;

	for (i=0; i<ArrayCount(AmmoNames); i++)
		if (AmmoNames[i] == AmmoName)
			break;

	last = i;

	// Vanilla Matters: Rewrite this part to stop the weapon from trying to cycle to its current ammo.
	i = last + 1;
	while ( i != last ) {
		if ( LoadAmmo( i ) ) {
			break;
		}

		i = i + 1;

		if ( i >= ArrayCount( AmmoNames ) ) {
			i = 0;
		}
	}
}

simulated function bool CanReload()
{
	if ((ClipCount > 0) && (ReloadCount != 0) && (AmmoType != None) && (AmmoType.AmmoAmount > 0) &&
	    (AmmoType.AmmoAmount > (ReloadCount-ClipCount)))
		return true;
	else
		return false;
}

simulated function bool MustReload()
{
	if ((AmmoLeftInClip() == 0) && (AmmoType != None) && (AmmoType.AmmoAmount > 0))
		return true;
	else
		return false;
}

simulated function int AmmoLeftInClip()
{
	if (ReloadCount == 0)	// if this weapon is not reloadable
		return 1;
	else if (AmmoType == None)
		return 0;
	else if (AmmoType.AmmoAmount == 0)		// if we are out of ammo
		return 0;
	else if (ReloadCount - ClipCount > AmmoType.AmmoAmount)		// if we have no clips left
		return AmmoType.AmmoAmount;
	else
		return ReloadCount - ClipCount;
}

simulated function int NumClips()
{
	if (ReloadCount == 0)  // if this weapon is not reloadable
		return 0;
	else if (AmmoType == None)
		return 0;
	else if (AmmoType.AmmoAmount == 0)	// if we are out of ammo
		return 0;
	else  // compute remaining clips
		return ((AmmoType.AmmoAmount-AmmoLeftInClip()) + (ReloadCount-1)) / ReloadCount;
}

simulated function int AmmoAvailable(int ammoNum)
{
	local class<Ammo> newAmmoClass;
	local Ammo newAmmo;
	local Pawn P;

	P = Pawn(Owner);

	// sorry, only pawns can have weapons
	if (P == None)
		return 0;

	newAmmoClass = AmmoNames[ammoNum];

	if (newAmmoClass == None)
		return 0;

	newAmmo = Ammo(P.FindInventoryType(newAmmoClass));

	if (newAmmo == None)
		return 0;

	return newAmmo.AmmoAmount;
}

simulated function int NumAmmoTypesAvailable()
{
	local int i;

	for (i=0; i<ArrayCount(AmmoNames); i++)
		if (AmmoNames[i] == None)
			break;

	// to make Al fucking happy
	if (i == 0)
		i = 1;

	return i;
}

function name WeaponDamageType()
{
	local name                    damageType;
	local Class<DeusExProjectile> projClass;

	projClass = Class<DeusExProjectile>(ProjectileClass);
	if (bInstantHit)
	{
		if (StunDuration > 0)
			damageType = 'Stunned';
		else
			damageType = 'Shot';

		if (AmmoType != None)
			if (AmmoType.IsA('AmmoSabot'))
				damageType = 'Sabot';
	}
	else if (projClass != None)
		damageType = projClass.Default.damageType;
	else
		damageType = 'None';

	return (damageType);
}


//
// target tracking info
//
simulated function Actor AcquireTarget()
{
	local vector StartTrace, EndTrace, HitLocation, HitNormal;
	local Actor hit, retval;
	local Pawn p;

	p = Pawn(Owner);
	if (p == None)
		return None;

	StartTrace = p.Location;
	if (PlayerPawn(p) != None)
		EndTrace = p.Location + (10000 * Vector(p.ViewRotation));
	else
		EndTrace = p.Location + (10000 * Vector(p.Rotation));

	// adjust for eye height
	StartTrace.Z += p.BaseEyeHeight;
	EndTrace.Z += p.BaseEyeHeight;

	foreach TraceActors(class'Actor', hit, HitLocation, HitNormal, EndTrace, StartTrace)
		if (!hit.bHidden && (hit.IsA('Decoration') || hit.IsA('Pawn')))
			return hit;

	return None;
}

//
// Used to determine if we are near (and facing) a wall for placing LAMs, etc.
//
simulated function bool NearWallCheck()
{
	local Vector StartTrace, EndTrace, HitLocation, HitNormal;
	local Actor HitActor;

	// Scripted pawns can't place LAMs
	if (ScriptedPawn(Owner) != None)
		return False;

	// Don't let players place grenades when they have something highlighted
	if ( Level.NetMode != NM_Standalone )
	{
		if ( Owner.IsA('DeusExPlayer') && (DeusExPlayer(Owner).frobTarget != None) )
		{
			if ( DeusExPlayer(Owner).IsFrobbable( DeusExPlayer(Owner).frobTarget ) )
				return False;
		}
	}

	// trace out one foot in front of the pawn
	StartTrace = Owner.Location;
	EndTrace = StartTrace + Vector(Pawn(Owner).ViewRotation) * 32;

	//StartTrace.Z += Pawn(Owner).BaseEyeHeight;
	//EndTrace.Z += Pawn(Owner).BaseEyeHeight;

	// Vanilla Matters: You can now place grenades on floor.

	HitActor = Trace(HitLocation, HitNormal, EndTrace, StartTrace);
	if ((HitActor == Level) || ((HitActor != None) && HitActor.IsA('Mover')))
	{
		placeLocation = HitLocation;
		placeNormal = HitNormal;
		placeMover = Mover(HitActor);
		return True;
	}

	return False;
}

//
// used to place a grenade on the wall
//
function PlaceGrenade()
{
	local ThrownProjectile gren;
	local float dmgX;

	gren = ThrownProjectile(spawn(ProjectileClass, Owner,, placeLocation, Rotator(placeNormal)));
	if (gren != None)
	{
		AmmoType.UseAmmo(1);
		if ( AmmoType.AmmoAmount <= 0 )
			bDestroyOnFinish = True;

		gren.PlayAnim('Open');
		gren.PlaySound(gren.MiscSound, SLOT_None, 0.5+FRand()*0.5,, 512, 0.85+FRand()*0.3);
		gren.SetPhysics(PHYS_None);
		gren.bBounce = False;
		gren.bProximityTriggered = True;
		gren.bStuck = True;
		if (placeMover != None)
			gren.SetBase(placeMover);

		// up the damage based on the skill
		// returned value from GetWeaponSkill is negative, so negate it to make it positive
		// dmgX value ranges from 1.0 to 2.4 (max demo skill and max target aug)
		//dmgX = -2.0 * GetWeaponSkill() + 1.0;

		// Vanilla Matters: Used for damage, so true is added in.
		dmgX = -2.0 * GetWeaponSkill( true ) + 1.0;

		gren.Damage *= dmgX;

		// Update ammo count on object belt
		if (DeusExPlayer(Owner) != None)
			DeusExPlayer(Owner).UpdateBeltText(Self);
	}
}

//
// scope, laser, and targetting updates are done here
//
simulated function Tick(float deltaTime)
{
	local vector loc;
	local rotator rot;
	local float beepspeed, recoil;
	local DeusExPlayer player;
	local Actor RealTarget;
	local Pawn pawn;

	// Vanilla Matters
	local float skillBonus, standingRate;
	local int yaw, pitch;

	skillBonus = GetWeaponSkill();

	player = DeusExPlayer(Owner);
	pawn = Pawn(Owner);

	Super.Tick(deltaTime);

	// don't do any of this if this weapon isn't currently in use
	if (pawn == None)
	{
		LockMode = LOCK_None;
		MaintainLockTimer = 0;
		LockTarget = None;
		LockTimer = 0;
		return;
	}

	if (pawn.Weapon != self)
	{
		LockMode = LOCK_None;
		MaintainLockTimer = 0;
		LockTarget = None;
		LockTimer = 0;
		return;
	}

	// all this should only happen IF you have ammo loaded
	if (ClipCount < ReloadCount)
	{
		// check for LAM or other placed mine placement
		if (bHandToHand && (ProjectileClass != None) && (!Self.IsA('WeaponShuriken')))
		{
			if (NearWallCheck())
			{
				if (( Level.NetMode != NM_Standalone ) && IsAnimating() && (AnimSequence == 'Select'))
				{
				}
				else
				{
					if (!bNearWall || (AnimSequence == 'Select'))
					{
						PlayAnim('PlaceBegin',, 0.1);
						bNearWall = True;
					}
				}
			}
			else
			{
				if (bNearWall)
				{
					PlayAnim('PlaceEnd',, 0.1);
					bNearWall = False;
				}
			}
		}


		SoundTimer += deltaTime;

		if ( (Level.Netmode == NM_Standalone) || ( (Player != None) && (Player.PlayerIsClient()) ) )
		{
			if (bCanTrack)
			{
				Target = AcquireTarget();
				RealTarget = Target;
				
				// calculate the range
				if (Target != None)
					TargetRange = Abs(VSize(Target.Location - Location));
				
				// update our timers
				//SoundTimer += deltaTime;
				MaintainLockTimer -= deltaTime;
				
				// check target and range info to see what our mode is
				if ((Target == None) || IsInState('Reload'))
				{
					if (MaintainLockTimer <= 0)
					{				
						SetLockMode(LOCK_None);
						MaintainLockTimer = 0;
						LockTarget = None;
					}
					else if (LockMode == LOCK_Locked)
					{
						Target = LockTarget;
					}
				}
				else if ((Target != LockTarget) && (Target.IsA('Pawn')) && (LockMode == LOCK_Locked))
				{
					SetLockMode(LOCK_None);
					LockTarget = None;
				}
				else if (!Target.IsA('Pawn'))
				{
					if (MaintainLockTimer <=0 )
					{
						SetLockMode(LOCK_Invalid);
					}
				}
				else if ( (Target.IsA('DeusExPlayer')) && (Target.Style == STY_Translucent) )
				{
					//DEUS_EX AMSD Don't allow locks on cloaked targets.
					SetLockMode(LOCK_Invalid);
				}
				else if ( (Target.IsA('DeusExPlayer')) && (Player.DXGame.IsA('TeamDMGame')) && (TeamDMGame(Player.DXGame).ArePlayersAllied(Player,DeusExPlayer(Target))) )
				{
					//DEUS_EX AMSD Don't allow locks on allies.
					SetLockMode(LOCK_Invalid);
				}
				else
				{
					if (TargetRange > MaxRange)
					{
						SetLockMode(LOCK_Range);
					}
					else
					{
						// change LockTime based on skill
						// -0.7 = max skill
						// DEUS_EX AMSD Only do weaponskill check here when first checking.
						if (LockTimer == 0)
						{
							LockTime = FMax(Default.LockTime + 3.0 * GetWeaponSkill(), 0.0);

							if ((Level.Netmode != NM_Standalone) && (LockTime < 0.25))
							LockTime = 0.25;
						}
						
						LockTimer += deltaTime;
						if (LockTimer >= LockTime)
						{
							SetLockMode(LOCK_Locked);
						}
						else
						{
							SetLockMode(LOCK_Acquire);
						}
					}
				}
				
				// act on the lock mode
				switch (LockMode)
				{
				case LOCK_None:
					TargetMessage = msgNone;
					LockTimer -= deltaTime;
					break;
					
				case LOCK_Invalid:
					TargetMessage = msgLockInvalid;
					LockTimer -= deltaTime;
					break;
					
				case LOCK_Range:
					TargetMessage = msgLockRange @ Int(TargetRange/16) @ msgRangeUnit;
					LockTimer -= deltaTime;
					break;
					
				case LOCK_Acquire:
					TargetMessage = msgLockAcquire @ Left(String(LockTime-LockTimer), 4) @ msgTimeUnit;
					beepspeed = FClamp((LockTime - LockTimer) / Default.LockTime, 0.2, 1.0);
					if (SoundTimer > beepspeed)
					{
						Owner.PlaySound(TrackingSound, SLOT_None);
						SoundTimer = 0;
					}
					break;
					
				case LOCK_Locked:
					// If maintaining a lock, or getting a new one, increment maintainlocktimer
					if ((RealTarget != None) && ((RealTarget == LockTarget) || (LockTarget == None)))
					{
						if (Level.NetMode != NM_Standalone)
							MaintainLockTimer = default.MaintainLockTimer;
						else
							MaintainLockTimer = 0;
						LockTarget = Target;
					}
					TargetMessage = msgLockLocked @ Int(TargetRange/16) @ msgRangeUnit;
					// DEUS_EX AMSD Moved out so server can play it so that client knows for sure when locked.
					/*if (SoundTimer > 0.1)
					{
						Owner.PlaySound(LockedSound, SLOT_None);
						SoundTimer = 0;
					}*/
					break;
				}
			}
			else
			{
				LockMode = LOCK_None;
				TargetMessage = msgNone;
				LockTimer = 0;
				MaintainLockTimer = 0;
				LockTarget = None;
			}
			
			if (LockTimer < 0)
			LockTimer = 0;
		}
	}
	else
	{
		LockMode = LOCK_None;
		TargetMessage=msgNone;
		MaintainLockTimer = 0;
		LockTarget = None;
		LockTimer = 0;
	}

	if ((LockMode == LOCK_Locked) && (SoundTimer > 0.1) && (Role == ROLE_Authority))
	{
		PlayLockSound();
		SoundTimer = 0;
	}

	// Vanilla Matters: Handle recoil and accuracy penalty.
	if ( !bHandToHand && player != none ) {
		if ( VM_recoilRecovery.Pitch > 0 ) {
			VM_recoilRecovery.Pitch = Max( VM_recoilRecovery.Pitch - Abs( player.ViewRotation.Pitch - VM_lastPlayerRotation.Pitch ), 0 );
		}

		if ( VM_recoilForce > 0 ) {
			recoil = VM_recoilRate * ( 1 + ModRecoilStrength ) * deltaTime;
			VM_recoilPenalty = FMin( VM_recoilPenalty + FMin( VM_recoilForce, recoil ), recoilStrength );
			VM_recoilForce = FMax( VM_recoilForce - recoil, 0 );

			yaw = ( Rand( 2048 ) - 1024 ) * recoil;
			pitch = ( Rand( 2048 ) + 2048 ) * recoil;

			player.ViewRotation.Yaw = player.ViewRotation.Yaw + yaw;
			player.ViewRotation.Pitch = player.ViewRotation.Pitch + pitch;
			if ( player.ViewRotation.Pitch > 16384 && player.ViewRotation.Pitch < 32768 ) {
				VM_recoilRecovery.Pitch = VM_recoilRecovery.Pitch - ( player.ViewRotation.Pitch - 16384 );
				player.ViewRotation.Pitch = 16384;
			}

			VM_recoilRecovery.Yaw = VM_recoilRecovery.Yaw + yaw;
			VM_recoilRecovery.Pitch = VM_recoilRecovery.Pitch + pitch;
		}
		else {
			recoil = VM_recoilRate * ( 1 - skillBonus ) * deltaTime;
			if ( VM_recoilPenalty > 0 ) {
				VM_recoilPenalty = FMax( VM_recoilPenalty - ( recoil * ( 1 - FMin( ShotTime * 2, 0.8 ) ) ), 0 );
			}

			recoil = recoil * 3072;
			if ( VM_recoilRecovery.Yaw != 0 ) {
				if ( VM_recoilRecovery.Yaw >= 0 ) {
					yaw = Min( recoil, VM_recoilRecovery.Yaw );
				}
				else {
					yaw = Max( - recoil, VM_recoilRecovery.Yaw );
				}

				player.ViewRotation.Yaw = player.ViewRotation.Yaw - yaw;

				if ( VM_recoilRecovery.Yaw >= 0 ) {
					VM_recoilRecovery.Yaw = Max( VM_recoilRecovery.Yaw - yaw, 0 );
				}
				else {
					VM_recoilRecovery.Yaw = Min( VM_recoilRecovery.Yaw - yaw, 0 );
				}
			}

			if ( VM_recoilRecovery.Pitch > 0 ) {
				pitch = Min( recoil, VM_recoilRecovery.Pitch );

				player.ViewRotation.Pitch = player.ViewRotation.Pitch - pitch;

				VM_recoilRecovery.Pitch = Max( VM_recoilRecovery.Pitch - pitch, 0 );
			}
		}

		VM_lastPlayerRotation = player.ViewRotation;
	}

	// if were standing still, increase the timer

	// Vanilla Matters: Use a new formula for standing bonus.
	standingRate = VM_baseStandingRate + ( skillBonus * 2 );
	beepspeed = VSize( Owner.Velocity );
	if ( beepspeed <= 10 ) {
		standingTimer = FMin( standingTimer + standingRate, standingRate * 10 );
	}
	else if ( beepspeed <= 160 ) {
		standingTimer = FMin( standingTimer + standingRate, standingRate * 5 );
	}
	else {
		standingTimer = FMax( standingTimer - standingRate, 0 );
	}

	// Vanilla Matters: Add in a timer before laser/scope becomes fully effective. Changes to make the laser work only when walking and the scope only when standing still.
	if ( ( bLasing && VSize( Owner.Velocity ) < 160 )  || ( bZoomed && VSize( Owner.Velocity ) < 10 ) ) {
		VM_modTimer = FMin( VM_modTimer + deltaTime, VM_modTimerMax );
	}
	else {
		VM_modTimer = FMax( VM_modTimer - deltaTime, 0 );
	}

	if (bLasing || bZoomed)
	{
		// shake our view to simulate poor aiming
		if (ShakeTimer > 0.25)
		{
			ShakeYaw = currentAccuracy * (Rand(4096) - 2048);
			ShakePitch = currentAccuracy * (Rand(4096) - 2048);
			ShakeTimer -= 0.25;
		}

		ShakeTimer += deltaTime;

		if (bLasing && (Emitter != None))
		{
			loc = Owner.Location;
			loc.Z += Pawn(Owner).BaseEyeHeight;

			// add a little random jitter - looks cool!
			rot = Pawn(Owner).ViewRotation;
			rot.Yaw += Rand(5) - 2;
			rot.Pitch += Rand(5) - 2;

			Emitter.SetLocation(loc);
			Emitter.SetRotation(rot);
		}

		if ((player != None) && bZoomed)
		{
			player.ViewRotation.Yaw += deltaTime * ShakeYaw;
			player.ViewRotation.Pitch += deltaTime * ShakePitch;
		}
	}

	// Vanilla Matters: Move this down here to be more precise.
	currentAccuracy = CalculateAccuracy();

	// Vanilla Matters: Non-automatic weapons need the player to stop holding fire to start firing again.
	if ( pawn != none ) {
		if ( !bAutomatic && !VM_readyFire && ( !bFiring && bReadyToFire ) && pawn.bFire == 0 ) {
			VM_readyFire = true;
		}
	}
}

//
// scope functions for weapons which have them
//

function ScopeOn()
{
	if (bHasScope && !bZoomed && (Owner != None) && Owner.IsA('DeusExPlayer'))
	{
		// Show the Scope View
		bZoomed = True;
		RefreshScopeDisplay(DeusExPlayer(Owner), False, bZoomed);

		// Vanilla Matters: Make turning on the scope always reset the effective timer to 0, regardless if laser is active.
		VM_modTimer = 0;

		// Vanilla Matters: Set modTimerMax depending on the combatDifficulty.
		if ( DeusExPlayer( Owner ) != None ) {
			VM_modTimerMax = Default.VM_modTimerMax * DeusExPlayer( Owner ).CombatDifficulty;
		}
	}
}

function ScopeOff()
{
	if (bHasScope && bZoomed && (Owner != None) && Owner.IsA('DeusExPlayer'))
	{
		bZoomed = False;
		// Hide the Scope View
      RefreshScopeDisplay(DeusExPlayer(Owner), False, bZoomed);
		//DeusExRootWindow(DeusExPlayer(Owner).rootWindow).scopeView.DeactivateView();
	}
}

simulated function ScopeToggle()
{
	if (IsInState('Idle'))
	{
		if (bHasScope && (Owner != None) && Owner.IsA('DeusExPlayer'))
		{
			if (bZoomed)
				ScopeOff();
			else
				ScopeOn();
		}
	}
}

// ----------------------------------------------------------------------
// RefreshScopeDisplay()
// ----------------------------------------------------------------------

simulated function RefreshScopeDisplay(DeusExPlayer player, bool bInstant, bool bScopeOn)
{
	if (bScopeOn && (player != None))
	{
		// Show the Scope View
		DeusExRootWindow(player.rootWindow).scopeView.ActivateView(ScopeFOV, False, bInstant);
	}
   else if (!bScopeOn)
   {
      DeusExrootWindow(player.rootWindow).scopeView.DeactivateView();
   }
}

//
// laser functions for weapons which have them
//

function LaserOn()
{
	if (bHasLaser && !bLasing)
	{
		// if we don't have an emitter, then spawn one
		// otherwise, just turn it on
		if (Emitter == None)
		{
			Emitter = Spawn(class'LaserEmitter', Self, , Location, Pawn(Owner).ViewRotation);
			if (Emitter != None)
			{
				Emitter.SetHiddenBeam(True);
				Emitter.AmbientSound = None;
				Emitter.TurnOn();
			}
		}
		else
			Emitter.TurnOn();

		bLasing = True;

		// Vanilla Matters: Set modTimerMax depending on the combatDifficulty.
		if ( DeusExPlayer( Owner ) != None ) {
			VM_modTimerMax = Default.VM_modTimerMax * DeusExPlayer( Owner ).CombatDifficulty;
		}
	}
}

function LaserOff()
{
	if (bHasLaser && bLasing)
	{
		if (Emitter != None)
			Emitter.TurnOff();

		bLasing = False;
	}
}

function LaserToggle()
{
	if (IsInState('Idle'))
	{
		if (bHasLaser)
		{
			if (bLasing)
				LaserOff();
			else
				LaserOn();
		}
	}
}

simulated function SawedOffCockSound()
{
	if ((AmmoType.AmmoAmount > 0) && (WeaponSawedOffShotgun(Self) != None))
		Owner.PlaySound(SelectSound, SLOT_None,,, 1024);
}

//
// called from the MESH NOTIFY
//
simulated function SwapMuzzleFlashTexture()
{
   if (!bHasMuzzleFlash)
      return;
	if (FRand() < 0.5)
		MultiSkins[2] = Texture'FlatFXTex34';
	else
		MultiSkins[2] = Texture'FlatFXTex37';

	MuzzleFlashLight();
	SetTimer(0.1, False);
}

simulated function EraseMuzzleFlashTexture()
{
	MultiSkins[2] = None;
}

simulated function Timer()
{
	EraseMuzzleFlashTexture();
}

simulated function MuzzleFlashLight()
{
	local Vector offset, X, Y, Z;

 	if (!bHasMuzzleFlash)
		return;

	if ((flash != None) && !flash.bDeleteMe)
		flash.LifeSpan = flash.Default.LifeSpan;
	else
	{
		GetAxes(Pawn(Owner).ViewRotation,X,Y,Z);
		offset = Owner.Location;
		offset += X * Owner.CollisionRadius * 2;
		flash = spawn(class'MuzzleFlash',,, offset);
		if (flash != None)
			flash.SetBase(Owner);
	}
}

function ServerHandleNotify( bool bInstantHit, class<projectile> ProjClass, float ProjSpeed, bool bWarn )
{
	if (bInstantHit)
		TraceFire(0.0);
	else
		ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);
}

//
// HandToHandAttack
// called by the MESH NOTIFY for the H2H weapons
//
simulated function HandToHandAttack()
{
	local bool bOwnerIsPlayerPawn;

	if (bOwnerWillNotify)
		return;

	// The controlling animator should be the one to do the tracefire and projfire
	if ( Level.NetMode != NM_Standalone )
	{
		bOwnerIsPlayerPawn = (DeusExPlayer(Owner) == DeusExPlayer(GetPlayerPawn()));

		if (( Role < ROLE_Authority ) && bOwnerIsPlayerPawn )
			ServerHandleNotify( bInstantHit, ProjectileClass, ProjectileSpeed, bWarnTarget );
		else if ( !bOwnerIsPlayerPawn )
			return;
	}

	if (ScriptedPawn(Owner) != None)
		ScriptedPawn(Owner).SetAttackAngle();

	if (bInstantHit)
		TraceFire(0.0);
	else
		ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);

	// if we are a thrown weapon and we run out of ammo, destroy the weapon
	if ( bHandToHand && (ReloadCount > 0) && (SimAmmoAmount <= 0))
	{
		DestroyOnFinish();
		if ( Role < ROLE_Authority )
		{
			ServerGotoFinishFire();
			GotoState('SimQuickFinish');
		}
	}
}

//
// OwnerHandToHandAttack
// called by the MESH NOTIFY for this weapon's owner
//
simulated function OwnerHandToHandAttack()
{
	local bool bOwnerIsPlayerPawn;

	if (!bOwnerWillNotify)
		return;

	// The controlling animator should be the one to do the tracefire and projfire
	if ( Level.NetMode != NM_Standalone )
	{
		bOwnerIsPlayerPawn = (DeusExPlayer(Owner) == DeusExPlayer(GetPlayerPawn()));

		if (( Role < ROLE_Authority ) && bOwnerIsPlayerPawn )
			ServerHandleNotify( bInstantHit, ProjectileClass, ProjectileSpeed, bWarnTarget );
		else if ( !bOwnerIsPlayerPawn )
			return;
	}

	if (ScriptedPawn(Owner) != None)
		ScriptedPawn(Owner).SetAttackAngle();

	if (bInstantHit)
		TraceFire(0.0);
	else
		ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);
}

function ForceFire()
{
	Fire(0);
}

function ForceAltFire()
{
	AltFire(0);
}

//
// ReadyClientToFire is called by the server telling the client it's ok to fire now
//

simulated function ReadyClientToFire( bool bReady )
{
	bClientReadyToFire = bReady;
}

//
// ClientReFire is called when the client is holding down the fire button, loop firing
//

simulated function ClientReFire( float value )
{
	bClientReadyToFire = True;
	bLooping = True;
	bInProcess = False;
	ClientFire(0);
}

function StartFlame()
{
	flameShotCount = 0;
	bFlameOn = True;
	GotoState('FlameThrowerOn');
}

function StopFlame()
{
	bFlameOn = False;
}

//
// ServerForceFire is called from the client when loop firing
//
function ServerForceFire()
{
	bClientReady = True;
	Fire(0);
}

simulated function int PlaySimSound( Sound snd, ESoundSlot Slot, float Volume, float Radius )
{
	if ( Owner != None )
	{
		if ( Level.NetMode == NM_Standalone )
			return ( Owner.PlaySound( snd, Slot, Volume, , Radius ) );
		else
		{
			Owner.PlayOwnedSound( snd, Slot, Volume, , Radius );
			return 1;
		}
	}
	return 0;
}

//
// ClientFire - Attempts to play the firing anim, sounds, and trace fire hits for instant weapons immediately
//				on the client.  The server may have a different interpretation of what actually happen, but this at least
//				cuts down on preceived lag.
//
simulated function bool ClientFire( float value )
{
	local bool bWaitOnAnim;
	local vector shake;

	// check for surrounding environment
	if ((EnviroEffective == ENVEFF_Air) || (EnviroEffective == ENVEFF_Vacuum) || (EnviroEffective == ENVEFF_AirVacuum))
	{
		if (Region.Zone.bWaterZone)
		{
			if (Pawn(Owner) != None)
			{
				Pawn(Owner).ClientMessage(msgNotWorking);
				if (!bHandToHand)
					PlaySimSound( Misc1Sound, SLOT_None, TransientSoundVolume * 2.0, 1024 );
			}
			return false;
		}
	}

	if ( !bLooping ) // Wait on animations when not looping
	{
		bWaitOnAnim = ( IsAnimating() && ((AnimSequence == 'Select') || (AnimSequence == 'Shoot') || (AnimSequence == 'ReloadBegin') || (AnimSequence == 'Reload') || (AnimSequence == 'ReloadEnd') || (AnimSequence == 'Down')));
	}
	else
	{
		bWaitOnAnim = False;
		bLooping = False;
	}

	if ( (Owner.IsA('DeusExPlayer') && (DeusExPlayer(Owner).NintendoImmunityTimeLeft > 0.01)) ||
		  (!bClientReadyToFire) || bInProcess || bWaitOnAnim )
	{
		DeusExPlayer(Owner).bJustFired = False;
		bPointing = False;
		bFiring = False;
		return false;
	}

	if ( !Self.IsA('WeaponFlamethrower') )
		ServerForceFire();

	if (bHandToHand)
	{
		SimAmmoAmount = AmmoType.AmmoAmount - 1;

		bClientReadyToFire = False;
		bInProcess = True;
		GotoState('ClientFiring');
		bPointing = True;
		if ( PlayerPawn(Owner) != None )
			PlayerPawn(Owner).PlayFiring();
		PlaySelectiveFiring();
		PlayFiringSound();
	}
	else if ((ClipCount < ReloadCount) || (ReloadCount == 0))
	{
		if ((ReloadCount == 0) || (AmmoType.AmmoAmount > 0))
		{
			SimClipCount = ClipCount + 1;

			if ( AmmoType != None )
				AmmoType.SimUseAmmo();

			bFiring = True;
			bPointing = True;
			bClientReadyToFire = False;
			bInProcess = True;
			GotoState('ClientFiring');
			if ( PlayerPawn(Owner) != None )
			{
				shake.X = 0.0;
				shake.Y = 100.0 * (ShakeTime*0.5);
				shake.Z = 100.0 * -(currentAccuracy * ShakeVert);
				PlayerPawn(Owner).ClientShake( shake );
				PlayerPawn(Owner).PlayFiring();
			}
			// Don't play firing anim for 20mm
			if ( Ammo20mm(AmmoType) == None )
				PlaySelectiveFiring();
			PlayFiringSound();

			if ( bInstantHit &&  ( Ammo20mm(AmmoType) == None ))
				TraceFire(currentAccuracy);
			else
			{
				if ( !bFlameOn && Self.IsA('WeaponFlamethrower'))
				{
					bFlameOn = True;
					StartFlame();
				}
				ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);
			}
		}
		else
		{
			if ( Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).bAutoReload )
			{
				if ( MustReload() && CanReload() )
				{
					bClientReadyToFire = False;
					bInProcess = False;
					if ((AmmoType.AmmoAmount == 0) && (AmmoName != AmmoNames[0]))
						CycleAmmo();

					ReloadAmmo();
				}
			}
			PlaySimSound( Misc1Sound, SLOT_None, TransientSoundVolume * 2.0, 1024 );		// play dry fire sound
		}
	}
	else
	{
		if ( Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).bAutoReload )
		{
			if ( MustReload() && CanReload() )
			{
				bClientReadyToFire = False;
				bInProcess = False;
				if ((AmmoType.AmmoAmount == 0) && (AmmoName != AmmoNames[0]))
					CycleAmmo();
				ReloadAmmo();
			}
		}
		PlaySimSound( Misc1Sound, SLOT_None, TransientSoundVolume * 2.0, 1024 );		// play dry fire sound
	}
	return true;
}

//
// from Weapon.uc - modified so we can have the accuracy in TraceFire
//

// Vanilla Matters: Rewrite this mess just because.
function Fire( float value ) {
	local float sndVolume;
	local bool bListenClient;

	local Pawn p;
	local PlayerPawn pp;
	local DeusExPlayer player;

	// Vanilla Matters: Control if we can fire.
	if ( !VM_readyFire ) {
		return;
	}

	player = DeusExPlayer( Owner );

	bListenClient = ( player != none && player.PlayerIsListenClient() );

	sndVolume = TransientSoundVolume;

	if ( Level.NetMode != NM_Standalone ){
		sndVolume = TransientSoundVolume * 2.0;
		if ( player != none && player.NintendoImmunityTimeLeft > 0.01 || ( !bClientReady && !bListenClient ) ) {
			player.bJustFired = False;
			bReadyToFire = True;
			bPointing = False;
			bFiring = False;

			return;
		}
	}

	if ( EnviroEffective == ENVEFF_Air || EnviroEffective == ENVEFF_Vacuum || EnviroEffective == ENVEFF_AirVacuum ) {
		if ( Region.Zone.bWaterZone ) {
			p = Pawn( Owner );
			if ( p != none ) {
				p.ClientMessage( msgNotWorking );

				if ( !bHandToHand ) {
					PlaySimSound( Misc1Sound, SLOT_None, sndVolume, 1024 );
				}
			}

			GotoState('Idle');

			return;
		}
	}

	pp = PlayerPawn( Owner );

	if ( bHandToHand ) {
		if ( ReloadCount > 0 ) {
			AmmoType.UseAmmo( 1 );
		}

		if ( Level.NetMode != NM_Standalone && !bListenClient ) {
			bClientReady = false;
		}

		bReadyToFire = false;

		GotoState('NormalFire');

		// Vanilla Matters: Add shaking to melee.
		if ( pp != None ) {
			if ( Level.NetMode == NM_Standalone || bListenClient ) {
				pp.ShakeView( ShakeTime, currentAccuracy * ShakeMag + ShakeMag, currentAccuracy * ShakeVert );
			}

			pp.PlayFiring();
		}

		bPointing= true;

		PlaySelectiveFiring();
		PlayFiringSound();
	}
	else if ( ClipCount < ReloadCount || ReloadCount == 0 ) {
		if ( ReloadCount == 0 || AmmoType.UseAmmo( 1 ) ) {
			if ( Level.NetMode != NM_Standalone && !bListenClient ) {
				bClientReady = false;
			}

			ClipCount++;
			bFiring = True;
			bReadyToFire = False;

			GotoState('NormalFire');

			if ( bInstantHit ) {
				TraceFire( currentAccuracy );
			}
			else {
				ProjectileFire( ProjectileClass, ProjectileSpeed, bWarnTarget );
			}
			
			if ( pp != None ) {
				if ( Level.NetMode == NM_Standalone || bListenClient ) {
					pp.ShakeView( ShakeTime, currentAccuracy * ShakeMag + ShakeMag, currentAccuracy * ShakeVert );
				}
	
				pp.PlayFiring();
			}

			bPointing= true;

			if ( Ammo20mm( AmmoType ) == none ) {
				PlaySelectiveFiring();
			}

			PlayFiringSound();

			if ( Owner.bHidden ) {
				CheckVisibility();
			}
		}
		else {
			PlaySimSound( Misc1Sound, SLOT_None, sndVolume, 1024 );
		}
	}
	else {
		PlaySimSound( Misc1Sound, SLOT_None, sndVolume, 1024 );
	}

	// Update ammo count on object belt
	if ( player != none ) {
		player.UpdateBeltText( self );
	}
}

function ReadyToFire()
{
	if (!bReadyToFire)
	{
		// BOOGER!
		//if (ScriptedPawn(Owner) != None)
		//	ScriptedPawn(Owner).ReadyToFire();
		bReadyToFire = True;
		if ( Level.NetMode != NM_Standalone )
			ReadyClientToFire( True );
	}
}

function PlayPostSelect()
{
	// let's not zero the ammo count anymore - you must always reload
//	ClipCount = 0;		
}

simulated function PlaySelectiveFiring()
{
	local Pawn aPawn;
	local float rnd;
	local Name anim;

	anim = 'Shoot';

	if (bHandToHand)
	{
		rnd = FRand();
		if (rnd < 0.33)
			anim = 'Attack';
		else if (rnd < 0.66)
			anim = 'Attack2';
		else
			anim = 'Attack3';
	}

	if (( Level.NetMode == NM_Standalone ) || ( DeusExPlayer(Owner) == DeusExPlayer(GetPlayerPawn())) )
	{
		if (bAutomatic)
			LoopAnim(anim,, 0.1);
		else
			PlayAnim(anim,,0.1);
	}
	else if ( Role == ROLE_Authority )
	{
		for ( aPawn = Level.PawnList; aPawn != None; aPawn = aPawn.nextPawn )
		{
			if ( aPawn.IsA('DeusExPlayer') && ( DeusExPlayer(Owner) != DeusExPlayer(aPawn) ) )
			{
				// If they can't see the weapon, don't bother
				if ( DeusExPlayer(aPawn).FastTrace( DeusExPlayer(aPawn).Location, Location ))
					DeusExPlayer(aPawn).ClientPlayAnimation( Self, anim, 0.1, bAutomatic );
			}
		}
	}
}

simulated function PlayFiringSound()
{
	if (bHasSilencer)
		PlaySimSound( Sound'StealthPistolFire', SLOT_None, TransientSoundVolume, 2048 );
	else
	{
		// The sniper rifle sound is heard to it's range in multiplayer
		if ( ( Level.NetMode != NM_Standalone ) &&  Self.IsA('WeaponRifle') )	
			PlaySimSound( FireSound, SLOT_None, TransientSoundVolume, class'WeaponRifle'.Default.mpMaxRange );
		else
			PlaySimSound( FireSound, SLOT_None, TransientSoundVolume, 2048 );
	}
}

simulated function PlayIdleAnim()
{
	local float rnd;

	if (bZoomed || bNearWall)
		return;

	rnd = FRand();

	if (rnd < 0.1)
		PlayAnim('Idle1',,0.1);
	else if (rnd < 0.2)
		PlayAnim('Idle2',,0.1);
	else if (rnd < 0.3)
		PlayAnim('Idle3',,0.1);
}

//
// SpawnBlood
//

function SpawnBlood(Vector HitLocation, Vector HitNormal)
{
   if ((DeusExMPGame(Level.Game) != None) && (!DeusExMPGame(Level.Game).bSpawnEffects))
      return;

   spawn(class'BloodSpurt',,,HitLocation+HitNormal);
	spawn(class'BloodDrop',,,HitLocation+HitNormal);
	if (FRand() < 0.5)
		spawn(class'BloodDrop',,,HitLocation+HitNormal);
}

//
// SelectiveSpawnEffects - Continues the simulated chain for the owner, and spawns the effects for other players that can see them
//			No actually spawning occurs on the server itself.
//
simulated function SelectiveSpawnEffects( Vector HitLocation, Vector HitNormal, Actor Other, float Damage)
{
	local DeusExPlayer fxOwner;
	local Pawn aPawn;

	// The normal path before there was multiplayer
	if ( Level.NetMode == NM_Standalone )
	{
		SpawnEffects(HitLocation, HitNormal, Other, Damage);
		return;
	}

	fxOwner = DeusExPlayer(Owner);

	if ( Role == ROLE_Authority )
	{
		SpawnEffectSounds(HitLocation, HitNormal, Other, Damage );

		for ( aPawn = Level.PawnList; aPawn != None; aPawn = aPawn.nextPawn )
		{
			if ( aPawn.IsA('DeusExPlayer') && ( DeusExPlayer(aPawn) != fxOwner ) )
			{
				if ( DeusExPlayer(aPawn).FastTrace( DeusExPlayer(aPawn).Location, HitLocation ))
					DeusExPlayer(aPawn).ClientSpawnHits( bPenetrating, bHandToHand, HitLocation, HitNormal, Other, Damage );
			}
		}
	}
	if ( fxOwner == DeusExPlayer(GetPlayerPawn()) )
	{
			fxOwner.ClientSpawnHits( bPenetrating, bHandToHand, HitLocation, HitNormal, Other, Damage );
			SpawnEffectSounds( HitLocation, HitNormal, Other, Damage );
	}
}

//
//	 SpawnEffectSounds - Plays the sound for the effect owner immediately, the server will play them for the other players
//	
simulated function SpawnEffectSounds( Vector HitLocation, Vector HitNormal, Actor Other, float Damage )
{
	if (bHandToHand)
	{
		// if we are hand to hand, play an appropriate sound
		if (Other.IsA('DeusExDecoration'))
			Owner.PlayOwnedSound(Misc3Sound, SLOT_None,,, 1024);
		else if (Other.IsA('Pawn'))
			Owner.PlayOwnedSound(Misc1Sound, SLOT_None,,, 1024);
		else if (Other.IsA('BreakableGlass'))
			Owner.PlayOwnedSound(sound'GlassHit1', SLOT_None,,, 1024);
		else if (GetWallMaterial(HitLocation, HitNormal) == 'Glass')
			Owner.PlayOwnedSound(sound'BulletProofHit', SLOT_None,,, 1024);
		else
			Owner.PlayOwnedSound(Misc2Sound, SLOT_None,,, 1024);
	}
}

//
//	SpawnEffects - Spawns the effects like it did in single player
//
function SpawnEffects(Vector HitLocation, Vector HitNormal, Actor Other, float Damage)
{
   local TraceHitSpawner hitspawner;
	local Name damageType;

	damageType = WeaponDamageType();

   if (bPenetrating)
   {
      if (bHandToHand)
      {
         hitspawner = Spawn(class'TraceHitHandSpawner',Other,,HitLocation,Rotator(HitNormal));
      }
      else
      {
         hitspawner = Spawn(class'TraceHitSpawner',Other,,HitLocation,Rotator(HitNormal));
      }
   }
   else
   {
      if (bHandToHand)
      {
         hitspawner = Spawn(class'TraceHitHandNonPenSpawner',Other,,HitLocation,Rotator(HitNormal));
      }
      else
      {
         hitspawner = Spawn(class'TraceHitNonPenSpawner',Other,,HitLocation,Rotator(HitNormal));
      }
   }
   if (hitSpawner != None)
	{
      hitspawner.HitDamage = Damage;
		hitSpawner.damageType = damageType;
	}
	if (bHandToHand)
	{
		// if we are hand to hand, play an appropriate sound
		if (Other.IsA('DeusExDecoration'))
			Owner.PlaySound(Misc3Sound, SLOT_None,,, 1024);
		else if (Other.IsA('Pawn'))
			Owner.PlaySound(Misc1Sound, SLOT_None,,, 1024);
		else if (Other.IsA('BreakableGlass'))
			Owner.PlaySound(sound'GlassHit1', SLOT_None, 0,, 1024);
		else if (GetWallMaterial(HitLocation, HitNormal) == 'Glass')
			Owner.PlaySound(sound'BulletProofHit', SLOT_None,,, 1024);
		else
			Owner.PlaySound(Misc2Sound, SLOT_None,,, 1024);
	}
}


function name GetWallMaterial(vector HitLocation, vector HitNormal)
{
	local vector EndTrace, StartTrace;
	local actor target;
	local int texFlags;
	local name texName, texGroup;

	StartTrace = HitLocation + HitNormal*16;		// make sure we start far enough out
	EndTrace = HitLocation - HitNormal;

	foreach TraceTexture(class'Actor', target, texName, texGroup, texFlags, StartTrace, HitNormal, EndTrace)
		if ((target == Level) || target.IsA('Mover'))
			break;

	return texGroup;
}

simulated function SimGenerateBullet()
{
	if ( Role < ROLE_Authority )
	{
		if ((ClipCount < ReloadCount) && (ReloadCount != 0))
		{
			if ( AmmoType != None )
				AmmoType.SimUseAmmo();

			if ( bInstantHit )
				TraceFire(currentAccuracy);
			else
				ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);

			SimClipCount++;

			if ( !Self.IsA('WeaponFlamethrower') )
				ServerGenerateBullet();
		}
		else
			GotoState('SimFinishFire');
	}
}

function DestroyOnFinish()
{
	bDestroyOnFinish = True;
}

function ServerGotoFinishFire()
{
	GotoState('FinishFire');
}

function ServerDoneReloading()
{
	// Vanilla Matters: Correctly represent the amount of ammo in clip.
	ClipCount = FMax( 0, ReloadCount - AmmoType.AmmoAmount );
}

function ServerGenerateBullet()
{
	if ( ClipCount < ReloadCount )
		GenerateBullet();
}

function GenerateBullet()
{
	if (AmmoType.UseAmmo(1))
	{
		if ( bInstantHit )
			TraceFire(currentAccuracy);
		else
			ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);

		ClipCount++;
	}
	else
		GotoState('FinishFire');
}

function GenerateMultipleBullets( int count ) {
	local int i;

	if ( AmmoType.UseAmmo(1) ) {
		for ( i = 1; i <= count; i++ ) {
			ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);
		}

		ClipCount++;
	}
	else {
		GotoState( 'FinishFire' );
	}
}

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


function GetWeaponRanges(out float wMinRange,
                         out float wMaxAccurateRange,
                         out float wMaxRange)
{
	local Class<DeusExProjectile> dxProjectileClass;

	dxProjectileClass = Class<DeusExProjectile>(ProjectileClass);
	if (dxProjectileClass != None)
	{
		wMinRange         = dxProjectileClass.Default.blastRadius;
		wMaxAccurateRange = dxProjectileClass.Default.AccurateRange;
		wMaxRange         = dxProjectileClass.Default.MaxRange;
	}
	else
	{
		wMinRange         = 0;
		wMaxAccurateRange = AccurateRange;
		wMaxRange         = MaxRange;
	}
}

//
// computes the start position of a projectile/trace
//
simulated function Vector ComputeProjectileStart(Vector X, Vector Y, Vector Z)
{
	local Vector Start;

	// if we are instant-hit, non-projectile, then don't offset our starting point by PlayerViewOffset
	if (bInstantHit)
		Start = Owner.Location + Pawn(Owner).BaseEyeHeight * vect(0,0,1);// - Vector(Pawn(Owner).ViewRotation)*(0.9*Pawn(Owner).CollisionRadius);
	else
		Start = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z;

	return Start;
}

//
// Modified to work better with scripted pawns
//
simulated function vector CalcDrawOffset()
{
	local vector		DrawOffset, WeaponBob;
	local ScriptedPawn	SPOwner;
	local Pawn			PawnOwner;

	SPOwner = ScriptedPawn(Owner);
	if (SPOwner != None)
	{
		DrawOffset = ((0.9/SPOwner.FOVAngle * PlayerViewOffset) >> SPOwner.ViewRotation);
		DrawOffset += (SPOwner.BaseEyeHeight * vect(0,0,1));
	}
	else
	{
		// copied from Engine.Inventory to not be FOVAngle dependent
		PawnOwner = Pawn(Owner);
		DrawOffset = ((0.9/PawnOwner.Default.FOVAngle * PlayerViewOffset) >> PawnOwner.ViewRotation);

		DrawOffset += (PawnOwner.EyeHeight * vect(0,0,1));
		WeaponBob = BobDamping * PawnOwner.WalkBob;
		WeaponBob.Z = (0.45 + 0.55 * BobDamping) * PawnOwner.WalkBob.Z;
		DrawOffset += WeaponBob;
	}

	return DrawOffset;
}

function GetAIVolume(out float volume, out float radius)
{
	volume = 0;
	radius = 0;

	if (!bHasSilencer && !bHandToHand)
	{
		volume = NoiseLevel*Pawn(Owner).SoundDampening;
		radius = volume * 800.0;
	}
}


//
// copied from Weapon.uc
//
simulated function Projectile ProjectileFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn)
{
	local Vector Start, X, Y, Z;
	local DeusExProjectile proj;
	local float mult;
	local float volume, radius;
	local int i, numProj;
	local Pawn aPawn;

	// Vanilla Matters
	local float throwBonus;
	local DeusExPlayer player;

	throwBonus = 1;
	player = DeusExPlayer( Owner );
	if ( player != none ) {
		throwBonus = player.AugmentationSystem.GetAugLevelValue( class'AugMuscle' );
		if ( throwBonus == -1.0 ) {
			throwBonus = 1;
		}
		else {
			throwBonus = ( throwBonus + 1 ) / 2;
		}
	}

	// Vanilla Matters: Used for damage, so true is added in.
	mult = 1.0 + ( -2.0 * GetWeaponSkill( true ) );

	// make noise if we are not silenced
	if (!bHasSilencer && !bHandToHand)
	{
		GetAIVolume(volume, radius);
		Owner.AISendEvent('WeaponFire', EAITYPE_Audio, volume, radius);
		Owner.AISendEvent('LoudNoise', EAITYPE_Audio, volume, radius);
		if (!Owner.IsA('PlayerPawn'))
			Owner.AISendEvent('Distress', EAITYPE_Audio, volume, radius);
	}

	// Vanilla Matters: Set the number of projectiles properly instead of vanilla hardcoding.
	numProj = VM_ShotCount[GetWeaponSkillLevel()];

	GetAxes(Pawn(owner).ViewRotation,X,Y,Z);
	Start = ComputeProjectileStart(X, Y, Z);

	for (i=0; i<numProj; i++)
	{
		// If we have multiple slugs, then lower our accuracy a bit after the first slug so the slugs DON'T all go to the same place
		if ((i > 0) && (Level.NetMode != NM_Standalone))
			if (currentAccuracy < MinProjSpreadAcc)
				currentAccuracy = MinProjSpreadAcc;

		AdjustedAim = pawn(owner).AdjustAim(ProjSpeed, Start, AimError, True, bWarn);
		
		// Vanilla Matters: Add in more spread as count goes up if the spread modifiers are set above zero.
		AdjustedAim.Yaw = AdjustedAim.Yaw + ( currentAccuracy * ( Rand( 1024 ) - 512 ) * ( 1 + ( numProj * VM_SpreadHorWithShotCount ) ) );
		AdjustedAim.Pitch = AdjustedAim.Pitch + ( currentAccuracy * ( Rand( 1024 ) - 512 ) * ( 1 + ( numProj * VM_SpreadVerWithShotCount ) ) );

		if (( Level.NetMode == NM_Standalone ) || ( Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).PlayerIsListenClient()) )
		{
			proj = DeusExProjectile(Spawn(ProjClass, Owner,, Start, AdjustedAim));
			if (proj != None)
			{
				// AugCombat increases our damage as well

				// send the targetting information to the projectile
				if (bCanTrack && (LockTarget != None) && (LockMode == LOCK_Locked))
				{
					proj.Target = LockTarget;
					proj.bTracking = True;
				}

				// Vanilla Matters: Fix weapon's hitdamage not affecting projectiles
				if ( !proj.VM_bOverridesDamage ) {
					proj.Damage = HitDamage * mult;
				}
				else {
					proj.Damage = proj.Damage * mult;
				}

				// Vanilla Matters: AugMuscle now increases throw distance and speed.
				proj.AccurateRange = proj.AccurateRange * throwBonus;
				proj.Speed = proj.Speed * throwBonus;
			}
		}
		else
		{
			if (( Role == ROLE_Authority ) || (DeusExPlayer(Owner) == DeusExPlayer(GetPlayerPawn())) )
			{
				// Do it the old fashioned way if it can track, or if we are a projectile that we could pick up again
				if ( bCanTrack || Self.IsA('WeaponShuriken') || Self.IsA('WeaponMiniCrossbow') || Self.IsA('WeaponLAM') || Self.IsA('WeaponEMPGrenade') || Self.IsA('WeaponGasGrenade'))
				{
					if ( Role == ROLE_Authority )
					{
						proj = DeusExProjectile(Spawn(ProjClass, Owner,, Start, AdjustedAim));
						if (proj != None)
						{
							// AugCombat increases our damage as well

							// send the targetting information to the projectile
							if (bCanTrack && (LockTarget != None) && (LockMode == LOCK_Locked))
							{
								proj.Target = LockTarget;
								proj.bTracking = True;
							}

							// Vanilla Matters: Fix weapon's hitdamage not affecting projectiles
							if ( !proj.VM_bOverridesDamage ) {
								proj.Damage = HitDamage * mult;
							}
							else {
								proj.Damage = proj.Damage * mult;
							}

							// Vanilla Matters: AugMuscle now increases throw distance and speed.
							proj.AccurateRange = proj.AccurateRange * throwBonus;
							proj.Speed = proj.Speed * throwBonus;
						}
					}
				}
				else
				{
					proj = DeusExProjectile(Spawn(ProjClass, Owner,, Start, AdjustedAim));
					if (proj != None)
					{
						proj.RemoteRole = ROLE_None;
						// AugCombat increases our damage as well

						// Vanilla Matters: Fix weapon's hitdamage not affecting projectiles
						if ( Role == ROLE_Authority ) {
							if ( !proj.VM_bOverridesDamage ) {
								proj.Damage = HitDamage * mult;
							}
							else {
								proj.Damage = proj.Damage * mult;
							}
						}
						else {
							proj.Damage = 0;
						}

						// Vanilla Matters: AugMuscle now increases throw distance and speed.
						proj.AccurateRange = proj.AccurateRange * throwBonus;
						proj.Speed = proj.Speed * throwBonus;
					}
					if ( Role == ROLE_Authority )
					{
						for ( aPawn = Level.PawnList; aPawn != None; aPawn = aPawn.nextPawn )
						{
							if ( aPawn.IsA('DeusExPlayer') && ( DeusExPlayer(aPawn) != DeusExPlayer(Owner) ))
								DeusExPlayer(aPawn).ClientSpawnProjectile( ProjClass, Owner, Start, AdjustedAim );
						}
					}
				}
			}
		}

	}

	// Vanilla Matters: Add recoil force.
	if ( !bHandToHand ) {
		VM_recoilForce = FMin( VM_recoilForce + ( recoilStrength * 0.4 ), recoilStrength * 2 );
	}

	return proj;
}

//
// copied from Weapon.uc so we can add range information
//
simulated function TraceFire( float Accuracy )
{
	local vector HitLocation, HitNormal, StartTrace, EndTrace, X, Y, Z;
	local Rotator rot;
	local actor Other;
	local float dist, alpha, degrade;
	local int i, numSlugs;
	local float volume, radius;

	// Vanilla Matters
	local vector start;
	local LaserSpot sp;
	local int accuracyOffset, j;

	// make noise if we are not silenced
	if (!bHasSilencer && !bHandToHand)
	{
		GetAIVolume(volume, radius);
		Owner.AISendEvent('WeaponFire', EAITYPE_Audio, volume, radius);
		Owner.AISendEvent('LoudNoise', EAITYPE_Audio, volume, radius);
		if (!Owner.IsA('PlayerPawn'))
			Owner.AISendEvent('Distress', EAITYPE_Audio, volume, radius);
	}

	GetAxes(Pawn(owner).ViewRotation,X,Y,Z);
	StartTrace = ComputeProjectileStart(X, Y, Z);
	AdjustedAim = pawn(owner).AdjustAim(1000000, StartTrace, 2.75*AimError, False, False);

	// Vanilla Matters: Save the start of the trace.
	start = StartTrace;

	//Vanilla Matters
	numSlugs = VM_ShotCount[GetWeaponSkillLevel()];
	accuracyOffset = AccurateRange / 5;

	// Vanilla Matters: Laser and scope accuracy moved to CalculateAccuracy() for more responsive/honest crosshair. As crosshair updates itself based on current accuracy and ignores here.

	for (i=0; i<numSlugs; i++)
	{
		// If we have multiple slugs, then lower our accuracy a bit after the first slug so the slugs DON'T all go to the same place
		if ((i > 0) && (Level.NetMode != NM_Standalone) && !(bHandToHand))
			if (Accuracy < MinSpreadAcc)
				Accuracy = MinSpreadAcc;

		// Let handtohand weapons have a better swing
		if ((bHandToHand) && (NumSlugs > 1) && (Level.NetMode != NM_Standalone))
		{
			StartTrace = ComputeProjectileStart(X,Y,Z);
			StartTrace = StartTrace + (numSlugs/2 - i) * SwingOffset;
		}
	
		// Vanilla Matters: Replace the vanilla "bullet drop" simulation with a more proper trace format.
		StartTrace = start;
		EndTrace = StartTrace + ( Accuracy * ( FRand() - 0.5 ) * Y * accuracyOffset ) + ( Accuracy * ( FRand() - 0.5 ) * Z * accuracyOffset ) + ( AccurateRange * vector( AdjustedAim ) );

		Other = Pawn( Owner ).TraceShot( HitLocation, HitNormal, EndTrace, StartTrace );

	  	// Vanilla Matters: Debug particles to display the initial trace.
		// dist = VSize( EndTrace - StartTrace );
		// rot = rotator( EndTrace - StartTrace );
		// for ( j = 0; j < dist / 16; j++ ) {
		// 	Spawn( Class'LaserSpot',,, StartTrace + ( 16 * j * vector( rot ) ), );
		// }

		if ( Other == none && MaxRange > AccurateRange ) {
			dist = MaxRange - AccurateRange;

			HitLocation = EndTrace - StartTrace;
			HitLocation.Z = HitLocation.Z - ( dist / 32 );
			StartTrace = EndTrace;
			EndTrace = EndTrace + ( Normal( HitLocation ) * dist );

			Other = Pawn( Owner ).TraceShot( HitLocation, HitNormal, EndTrace, StartTrace );

			// Vanilla Matters: Debug particles to display the second "bullet drop" trace.
			// dist = VSize( EndTrace - StartTrace );
			// rot = Rotator( EndTrace - StartTrace );
			// for ( j = 0; j < dist / 16; j++ ) {
			// 	sp = Spawn( Class'LaserSpot',,, StartTrace + ( 16 * j * Vector( rot ) ), );
			// 	if ( sp != none ) {
			// 		sp.Skin = Texture'LaserSpot2';
			// 	}
			// }
		}

		// randomly draw a tracer for relevant ammo types
		// don't draw tracers if we're zoomed in with a scope - looks stupid
		// DEUS_EX AMSD In multiplayer, draw tracers all the time.
		if ( ((Level.NetMode == NM_Standalone) && (!bZoomed && (numSlugs == 1) && (FRand() < 0.5))) ||
           ((Level.NetMode != NM_Standalone) && (Role == ROLE_Authority) && (numSlugs == 1)) )
		{
			if ((AmmoName == Class'Ammo10mm') || (AmmoName == Class'Ammo3006') ||
				(AmmoName == Class'Ammo762mm'))
			{
				if (VSize(HitLocation - StartTrace) > 250)
				{
					rot = Rotator(EndTrace - StartTrace);
               if ((Level.NetMode != NM_Standalone) && (Self.IsA('WeaponRifle')))
                  Spawn(class'SniperTracer',,, StartTrace + 96 * Vector(rot), rot);
               else
                  Spawn(class'Tracer',,, StartTrace + 96 * Vector(rot), rot);
				}
			}
		}

		// Vanilla Matters: Process the trace hit after firing visual tracer.
		ProcessTraceHit( Other, HitLocation, HitNormal, vector( AdjustedAim ), Y, Z );
	}

	// otherwise we don't hit the target at all

	// Vanilla Matters: Add recoil force.
	if ( !bHandToHand ) {
		VM_recoilForce = FMin( VM_recoilForce + ( recoilStrength * 0.4 ), recoilStrength * 2 );
	}
}

simulated function ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
	local float        mult;
	local name         damageType;
	local DeusExPlayer dxPlayer;

	// Vanilla Matters
	local ScriptedPawn sp;

	if (Other != None)
	{
		// Vanilla Matters: Used for damage, so true is added in.
		mult = 1.0 + ( -2.0 * GetWeaponSkill( true ) );

		// Determine damage type
		damageType = WeaponDamageType();

		if (Other != None)
		{
			if (Other.bOwned)
			{
				dxPlayer = DeusExPlayer(Owner);
				if (dxPlayer != None)
					dxPlayer.AISendEvent('Futz', EAITYPE_Visual);
			}
		}
		if ((Other == Level) || (Other.IsA('Mover')))
		{
			// Vanilla Matters: Make the mover take damage with a multiplier.
			if ( Role == ROLE_Authority ) {
				Other.TakeDamage( HitDamage * mult * VM_ShotBreaksStuff[GetWeaponSkillLevel()], Pawn( Owner ), HitLocation, 1000.0 * X, damageType );
			}

			SelectiveSpawnEffects( HitLocation, HitNormal, Other, HitDamage * mult);
		}
		else if ((Other != self) && (Other != Owner))
		{
			// Vanilla Matters: Let ShotBreaksStuff work against containers and decorations.
			if ( Role == ROLE_Authority ) {
				if ( Other.IsA( 'Containers' ) || Other.IsA( 'Decoration' ) ) {
					Other.TakeDamage( HitDamage * mult * VM_ShotBreaksStuff[GetWeaponSkillLevel()], Pawn( Owner ), HitLocation, 1000.0 * X, damageType );
				}
				else {
					// Vanilla Matters: Pass this in so the pawn knows what hit it.
					sp = ScriptedPawn( Other );
					if ( sp != none ) {
						sp.VM_hitBy = self;
					}

					Other.TakeDamage( HitDamage * mult, Pawn( Owner ), HitLocation, 1000.0 * X, damageType );
				}
			}

			if (bHandToHand)
				SelectiveSpawnEffects( HitLocation, HitNormal, Other, HitDamage * mult);

			if (bPenetrating && Other.IsA('Pawn') && !Other.IsA('Robot'))
				SpawnBlood(HitLocation, HitNormal);

			// Vanilla Matters: Ignite enemies.
			if ( DeusExPlayer( Pawn( Owner ) ) != None && ScriptedPawn( Other ) != None ) {
				if ( DeusExAmmo( AmmoType ).VM_IgnitesOnHit >= 0.0 && GetWeaponSkillLevel() >= DeusExAmmo( AmmoType ).VM_IgnitesOnHit ) {
					ScriptedPawn( Other ).CatchFire( HitDamage );
				}
			}
		}
	}
   if (DeusExMPGame(Level.Game) != None)
   {
      if (DeusExPlayer(Other) != None)
         DeusExMPGame(Level.Game).TrackWeapon(self,HitDamage * mult);
      else
         DeusExMPGame(Level.Game).TrackWeapon(self,0);
   }
}

simulated function IdleFunction()
{
	PlayIdleAnim();
	bInProcess = False;
	if ( bFlameOn )
	{
		StopFlame();
		bFlameOn = False;
	}
}

simulated function SimFinish()
{
	ServerGotoFinishFire();

	bInProcess = False;
	bFiring = False;

	if ( bFlameOn )
	{
		StopFlame();
		bFlameOn = False;
	}

	if (bHasMuzzleFlash)
		EraseMuzzleFlashTexture();

	if ( Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).bAutoReload )
	{
		if ( (SimClipCount >= ReloadCount) && CanReload() )
		{
			// Vanilla Matters: Correctly represent the amount of ammo in clip.
			SimClipCount = FMax( 0, ReloadCount - AmmoType.AmmoAmount );

			bClientReadyToFire = False;
			bInProcess = False;
			if ((AmmoType.AmmoAmount == 0) && (AmmoName != AmmoNames[0]))
				CycleAmmo();
			ReloadAmmo();
		}
	}

	if (Pawn(Owner) == None)
	{
		GotoState('SimIdle');
		return;
	}
	if ( PlayerPawn(Owner) == None )
	{
		if ( (Pawn(Owner).bFire != 0) && (FRand() < RefireRate) )
			ClientReFire(0);
		else
			GotoState('SimIdle');
		return;
	}
	if ( Pawn(Owner).bFire != 0 )
		ClientReFire(0);
	else
		GotoState('SimIdle');
}

// Vanilla Matters: Rewrite to fix non-automatic firing.
function Finish() {
	local Pawn pawn;

	VM_readyFire = ( bAutomatic || bHandToHand );

	ReadyToFire();

	if ( Level.NetMode != NM_Standalone ) {
		ReadyClientToFire( true );
	}

	if ( bHasMuzzleFlash ) {
		EraseMuzzleFlashTexture();
	}

	if ( bChangeWeapon ) {
		GotoState( 'DownWeapon' );

		return;
	}

	if ( Level.NetMode != NM_Standalone && IsInState( 'Active' ) ) {
		GotoState( 'Idle' );

		return;
	}

	pawn = Pawn( Owner );

	if ( pawn == none ) {
		GotoState('Idle');
		
		return;
	}

	if ( PlayerPawn( Owner ) == none ) {;
		if ( ( AmmoType == none || AmmoType.AmmoAmount <= 0 ) && ReloadCount != 0 ) {
			pawn.StopFiring();
			pawn.SwitchToBestWeapon();
		}
		else if ( pawn.bFire != 0 && VM_readyFire && ( FRand() < RefireRate ) ) {
			global.Fire( 0 );
		}
		else {
			pawn.StopFiring();

			GotoState( 'Idle' );
		}

		return;
	}

	if ( bAutomatic && ( Level.NetMode == NM_DedicatedServer || ( Level.NetMode == NM_ListenServer && DeusExPlayer( Owner ) != none && !DeusExPlayer( Owner ).PlayerIsListenClient() ) ) ) {
		GotoState('Idle');

		return;
	}

	if ( ( AmmoType == none || AmmoType.AmmoAmount <= 0 ) || pawn.Weapon != self ) {
		GotoState( 'Idle' );
	}
	else if ( pawn.bFire != 0 && VM_readyFire ) {
		global.Fire( 0 );
	}
	else {
		GotoState( 'Idle' );
	}
}

// ----------------------------------------------------------------------
// UpdateInfo()
// ----------------------------------------------------------------------

simulated function bool UpdateInfo(Object winObject)
{
	local PersonaInventoryInfoWindow winInfo;
	local string str;
	local int i, dmg;
	local float mod;
	local bool bHasAmmo;
	local bool bAmmoAvailable;
	local class<DeusExAmmo> ammoClass;
	local Pawn P;
	local Ammo weaponAmmo;
	local int  ammoAmount;

	// Vanilla Matters: Optimize many calls.
	local float weaponSkillLevel;
	local name damageType;

	weaponSkillLevel = GetWeaponSkillLevel();

	P = Pawn(Owner);
	if (P == None)
		return False;

	winInfo = PersonaInventoryInfoWindow(winObject);
	if (winInfo == None)
		return False;

	winInfo.SetTitle(itemName);
	winInfo.SetText(msgInfoWeaponStats);
	winInfo.AddLine();

	// Create the ammo buttons.  Start with the AmmoNames[] array,
	// which is used for weapons that can use more than one 
	// type of ammo.

	if (AmmoNames[0] != None)
	{
		for (i=0; i<ArrayCount(AmmoNames); i++)
		{
			if (AmmoNames[i] != None) 
			{
				// Check to make sure the player has this ammo type
				// *and* that the ammo isn't empty
				weaponAmmo = Ammo(P.FindInventoryType(AmmoNames[i]));

				if (weaponAmmo != None)
				{
					ammoAmount = weaponAmmo.AmmoAmount;
					bHasAmmo = (weaponAmmo.AmmoAmount > 0);
				}
				else
				{
					ammoAmount = 0;
					bHasAmmo = False;
				}

				winInfo.AddAmmo(AmmoNames[i], bHasAmmo, ammoAmount);
				bAmmoAvailable = True;

				if (AmmoNames[i] == AmmoName)
				{
					winInfo.SetLoaded(AmmoName);
					ammoClass = class<DeusExAmmo>(AmmoName);
				}
			}
		}
	}
	else
	{
		// Now peer at the AmmoName variable, but only if the AmmoNames[] 
		// array is empty
		if ((AmmoName != class'AmmoNone') && (!bHandToHand) && (ReloadCount != 0))
		{	
			weaponAmmo = Ammo(P.FindInventoryType(AmmoName));

			if (weaponAmmo != None)
			{
				ammoAmount = weaponAmmo.AmmoAmount;
				bHasAmmo = (weaponAmmo.AmmoAmount > 0);
			}
			else
			{
				ammoAmount = 0;
				bHasAmmo = False;
			}

			winInfo.AddAmmo(AmmoName, bHasAmmo, ammoAmount);
			winInfo.SetLoaded(AmmoName);
			ammoClass = class<DeusExAmmo>(AmmoName);
			bAmmoAvailable = True;
		}
	}

	// Only draw another line if we actually displayed ammo.
	if (bAmmoAvailable)
		winInfo.AddLine();

	// Ammo loaded
	if ((AmmoName != class'AmmoNone') && (!bHandToHand) && (ReloadCount != 0))
		winInfo.AddAmmoLoadedItem(msgInfoAmmoLoaded, AmmoType.itemName);

	// ammo info
	if ((AmmoName == class'AmmoNone') || bHandToHand || (ReloadCount == 0))
		str = msgInfoNA;
	else
		str = AmmoName.Default.ItemName;
	for (i=0; i<ArrayCount(AmmoNames); i++)
		if ((AmmoNames[i] != None) && (AmmoNames[i] != AmmoName))
			str = str $ "|n" $ AmmoNames[i].Default.ItemName;

	winInfo.AddAmmoTypesItem(msgInfoAmmo, str);

	// base damage

	// Vanilla Matters: Damage is now displayed exactly per hit, ignoring shot count unlike vanilla.
	if ( class<DeusExProjectile>( ProjectileClass ) != None && class<DeusExProjectile>( ProjectileClass ).Default.VM_bOverridesDamage ) {
		if ( Level.NetMode != NM_Standalone ) {
			dmg = class<DeusExProjectile>( ProjectileClass ).Default.mpDamage;

			// VM: Slight hack, mpDamage has a default property value of -1, to denote whether it has a real value defined. If it doesn't, use the normal damage value.
			if ( dmg == -1 ) {
				dmg = ProjectileClass.Default.Damage;
			}
		}
		else {
			dmg = ProjectileClass.Default.Damage;
		}
	}
	else {
		if ( Level.NetMode != NM_Standalone ) {
			dmg = Default.mpHitDamage;
		}
		else {
			dmg = Default.HitDamage;
		}
	}

	str = String(dmg);

	// Vanilla Matters: Display the number of shots to make it clearer how much damage can be dealt.
	if ( Default.VM_ShotCount[weaponSkillLevel] > 1 ) {
		str = str $ "x" $ Default.VM_ShotCount[weaponSkillLevel];
	}

	mod = 1.0 - ( 2.0 * GetWeaponSkill( true ) );

	if (mod != 1.0)
	{
		str = str @ BuildPercentString(mod - 1.0);
		str = str @ "=" @ FormatFloatString(dmg * mod, 1.0);

		// Vanilla Matters: Display the same number of shots afterwards.
		if ( Default.VM_ShotCount[weaponSkillLevel] > 1 ) {
			str = str $ "x" $ Default.VM_ShotCount[weaponSkillLevel];
		}
	}

	winInfo.AddInfoItem(msgInfoDamage, str, (mod != 1.0));

	// Vanilla Matters: Display headshot multiplier.
	str = "x" $ FormatFloatString( Default.VM_HeadshotMult[0], 0.1 );
	mod = ( Default.VM_HeadshotMult[weaponSkillLevel] / Default.VM_HeadshotMult[0] ) - 1;

	if ( mod != 0 ) {
		str = str @ BuildPercentString( mod ) @ "=" @ "x" $ FormatFloatString( Default.VM_HeadshotMult[weaponSkillLevel], 0.1 );
	}

	winInfo.AddInfoItem( VM_msgInfoHeadshot, str, mod != 0 );

	// clip size
	if ((Default.ReloadCount == 0) || bHandToHand)
		str = msgInfoNA;
	else
	{
		if ( Level.NetMode != NM_Standalone )
			str = Default.mpReloadCount @ msgInfoRounds;
		else
			str = Default.ReloadCount @ msgInfoRounds;
	}

	if (HasClipMod())
	{
		str = str @ BuildPercentString(ModReloadCount);
		str = str @ "=" @ ReloadCount @ msgInfoRounds;
	}

	winInfo.AddInfoItem(msgInfoClip, str, HasClipMod());

	// rate of fire
	if ((Default.ReloadCount == 0) || bHandToHand)
	{
		str = msgInfoNA;
	}
	else
	{
		if (bAutomatic)
			str = msgInfoAuto;
		else
			str = msgInfoSingle;

		str = str $ "," @ FormatFloatString(1.0/Default.ShotTime, 0.1) @ msgInfoRoundsPerSec;
	}
	winInfo.AddInfoItem(msgInfoROF, str);

	// reload time

	//  Vanilla Matters: Add in reload time bonus from skills.
	mod = 0;

	if ( Default.ReloadCount == 0 || bHandToHand) {
		str = msgInfoNA;
	}
	else {
		if (Level.NetMode != NM_Standalone ) {
			str = FormatFloatString( default.mpReloadTime, 0.1 );
		}
		else {
			str = FormatFloatString( default.ReloadTime, 0.1 );
		}

		mod = GetWeaponSkill() + ModReloadTime;

		if ( mod != 0 ) {
			str = str @ BuildPercentString( mod );
			str = str @ "=" @ FormatFloatString( default.ReloadTime + ( mod * default.ReloadTime ), 0.1 );
		}

		str = str @ msgTimeUnit;
	}

	winInfo.AddInfoItem( msgInfoReload, str, mod != 0 );

	// recoil
	str = FormatFloatString(Default.recoilStrength, 0.01);
	if (HasRecoilMod())
	{
		str = str @ BuildPercentString(ModRecoilStrength);
		str = str @ "=" @ FormatFloatString(recoilStrength, 0.01);
	}

	winInfo.AddInfoItem(msgInfoRecoil, str, HasRecoilMod());

	// base accuracy (2.0 = 0%, 0.0 = 100%)
	if ( Level.NetMode != NM_Standalone )
	{
		str = Int((2.0 - Default.mpBaseAccuracy)*50.0) $ "%";
		mod = (Default.mpBaseAccuracy - (BaseAccuracy + GetWeaponSkill())) * 0.5;
		if (mod != 0.0)
		{
			str = str @ BuildPercentString(mod);
			str = str @ "=" @ Min(100, Int(100.0*mod+(2.0 - Default.mpBaseAccuracy)*50.0)) $ "%";
		}
	}
	else
	{
		str = Int((2.0 - Default.BaseAccuracy)*50.0) $ "%";
		mod = (Default.BaseAccuracy - (BaseAccuracy + GetWeaponSkill())) * 0.5;
		if (mod != 0.0)
		{
			str = str @ BuildPercentString(mod);
			str = str @ "=" @ Min(100, Int(100.0*mod+(2.0 - Default.BaseAccuracy)*50.0)) $ "%";
		}
	}
	winInfo.AddInfoItem(msgInfoAccuracy, str, (mod != 0.0));

	// accurate range
	if (bHandToHand)
		str = msgInfoNA;
	else
	{
		if ( Level.NetMode != NM_Standalone )
			str = FormatFloatString(Default.mpAccurateRange/16.0, 1.0) @ msgRangeUnit;
		else
			str = FormatFloatString(Default.AccurateRange/16.0, 1.0) @ msgRangeUnit;
	}

	if (HasRangeMod())
	{
		str = str @ BuildPercentString(ModAccurateRange);
		str = str @ "=" @ FormatFloatString(AccurateRange/16.0, 1.0) @ msgRangeUnit;
	}
	winInfo.AddInfoItem(msgInfoAccRange, str, HasRangeMod());

	// max range
	if (bHandToHand)
		str = msgInfoNA;
	else
	{
		if ( Level.NetMode != NM_Standalone )
			str = FormatFloatString(Default.mpMaxRange/16.0, 1.0) @ msgRangeUnit;
		else
			str = FormatFloatString(Default.MaxRange/16.0, 1.0) @ msgRangeUnit;
	}
	winInfo.AddInfoItem(msgInfoMaxRange, str);

	// mass
	winInfo.AddInfoItem(msgInfoMass, FormatFloatString(Default.Mass, 1.0) @ msgMassUnit);

	// laser mod
	if (bCanHaveLaser)
	{
		if (bHasLaser)
			str = msgInfoYes;
		else
			str = msgInfoNo;
	}
	else
	{
		str = msgInfoNA;
	}
	winInfo.AddInfoItem(msgInfoLaser, str, bCanHaveLaser && bHasLaser && (Default.bHasLaser != bHasLaser));

	// scope mod
	if (bCanHaveScope)
	{
		if (bHasScope)
			str = msgInfoYes;
		else
			str = msgInfoNo;
	}
	else
	{
		str = msgInfoNA;
	}
	winInfo.AddInfoItem(msgInfoScope, str, bCanHaveScope && bHasScope && (Default.bHasScope != bHasScope));

	// silencer mod
	if (bCanHaveSilencer)
	{
		if (bHasSilencer)
			str = msgInfoYes;
		else
			str = msgInfoNo;
	}
	else
	{
		str = msgInfoNA;
	}
	winInfo.AddInfoItem(msgInfoSilencer, str, bCanHaveSilencer && bHasSilencer && (Default.bHasSilencer != bHasSilencer));

	// // Governing Skill
	// winInfo.AddInfoItem(msgInfoSkill, GoverningSkill.default.SkillName);

	// Vanilla Matters: Fix some accessed null class context.
	if ( GoverningSkill != None ) {
		winInfo.AddInfoItem( msgInfoSkill, GoverningSkill.default.SkillName );
	}
	else {
		winInfo.AddInfoItem( msgInfoSkill, msgInfoNA );
	}

	winInfo.AddLine();
	winInfo.SetText(Description);

	// If this weapon has ammo info, display it here
	if (ammoClass != None)
	{
		winInfo.AddLine();
		winInfo.AddAmmoDescription(ammoClass.Default.ItemName $ "|n" $ ammoClass.Default.description);

		// Vanilla Matters: Display if the ammo type can ignite people. If the property is disabled with -1.0 then it won't show at all.
		if ( ammoClass.Default.VM_IgnitesOnHit >= 0.0 ) {
			if ( weaponSkillLevel >= ammoClass.Default.VM_IgnitesOnHit ) {
				str = msgInfoYes;
			}
			else {
				str = msgInfoNo;
			}

			winInfo.AddInfoItem( VM_msgInfoIgnite, str, ( weaponSkillLevel >= ammoClass.Default.VM_IgnitesOnHit ) );
		}
	}

	return True;
}

// ----------------------------------------------------------------------
// UpdateAmmoInfo()
// ----------------------------------------------------------------------

simulated function UpdateAmmoInfo(Object winObject, Class<DeusExAmmo> ammoClass)
{
	local PersonaInventoryInfoWindow winInfo;
	local string str;
	local int i;

	winInfo = PersonaInventoryInfoWindow(winObject);
	if (winInfo == None)
		return;

	// Ammo loaded
	if ((AmmoName != class'AmmoNone') && (!bHandToHand) && (ReloadCount != 0))
		winInfo.UpdateAmmoLoaded(AmmoType.itemName);

	// ammo info
	if ((AmmoName == class'AmmoNone') || bHandToHand || (ReloadCount == 0))
		str = msgInfoNA;
	else
		str = AmmoName.Default.ItemName;
	for (i=0; i<ArrayCount(AmmoNames); i++)
		if ((AmmoNames[i] != None) && (AmmoNames[i] != AmmoName))
			str = str $ "|n" $ AmmoNames[i].Default.ItemName;

	winInfo.UpdateAmmoTypes(str);

	// If this weapon has ammo info, display it here
	if (ammoClass != None)
		winInfo.UpdateAmmoDescription(ammoClass.Default.ItemName $ "|n" $ ammoClass.Default.description);
}

// ----------------------------------------------------------------------
// BuildPercentString()
// ----------------------------------------------------------------------

//simulated final function String BuildPercentString(Float value)
// Vanilla Matters: Make it static so it can be used outside of this class easily.
simulated static final function String BuildPercentString(Float value)
{
	local string str;

	//str = String(Int(Abs(value * 100.0)));

	// Vanilla Matters: Should fix the 17 year-old graphical, rounding-error glitch.
	str = String( Int( Abs( value * 100.0 ) + 0.000001 ) );

	if (value < 0.0)
		str = "-" $ str;
	else
		str = "+" $ str;

	return ("(" $ str $ "%)");
}

// ----------------------------------------------------------------------
// FormatFloatString()
// ----------------------------------------------------------------------

//simulated function String FormatFloatString(float value, float precision)
// Vanilla Matters: Make it static so it can be used outside of this class easily.
simulated static function String FormatFloatString(float value, float precision)
{
	local string str;

	if (precision == 0.0)
		return "ERR";

	// build integer part
	str = String(Int(value));

	// build decimal part
	if (precision < 1.0)
	{
		value -= Int(value);
		str = str $ "." $ String(Int((0.5 * precision) + value * (1.0 / precision)));
	}

	return str;
}

// ----------------------------------------------------------------------
// CR()
// ----------------------------------------------------------------------

simulated function String CR()
{
	return Chr(13) $ Chr(10);
}

// ----------------------------------------------------------------------
// HasReloadMod()
// ----------------------------------------------------------------------

simulated function bool HasReloadMod()
{
	return (ModReloadTime != 0.0);
}

// ----------------------------------------------------------------------
// HasMaxReloadMod()
// ----------------------------------------------------------------------

simulated function bool HasMaxReloadMod()
{
	return (ModReloadTime == -0.5);
}

// ----------------------------------------------------------------------
// HasClipMod()
// ----------------------------------------------------------------------

simulated function bool HasClipMod()
{
	return (ModReloadCount != 0.0);
}

// ----------------------------------------------------------------------
// HasMaxClipMod()
// ----------------------------------------------------------------------

simulated function bool HasMaxClipMod()
{
	return (ModReloadCount == 0.5);
}

// ----------------------------------------------------------------------
// HasRangeMod()
// ----------------------------------------------------------------------

simulated function bool HasRangeMod()
{
	return (ModAccurateRange != 0.0);
}

// ----------------------------------------------------------------------
// HasMaxRangeMod()
// ----------------------------------------------------------------------

simulated function bool HasMaxRangeMod()
{
	return (ModAccurateRange == 0.5);
}

// ----------------------------------------------------------------------
// HasAccuracyMod()
// ----------------------------------------------------------------------

simulated function bool HasAccuracyMod()
{
	return (ModBaseAccuracy != 0.0);
}

// ----------------------------------------------------------------------
// HasMaxAccuracyMod()
// ----------------------------------------------------------------------

simulated function bool HasMaxAccuracyMod()
{
	return (ModBaseAccuracy == 0.5);
}

// ----------------------------------------------------------------------
// HasRecoilMod()
// ----------------------------------------------------------------------

simulated function bool HasRecoilMod()
{
	return (ModRecoilStrength != 0.0);
}

// ----------------------------------------------------------------------
// HasMaxRecoilMod()
// ----------------------------------------------------------------------

simulated function bool HasMaxRecoilMod()
{
	return (ModRecoilStrength == -0.5);
}

// ----------------------------------------------------------------------
// ClientDownWeapon()
// ----------------------------------------------------------------------

simulated function ClientDownWeapon()
{
	bWasInFiring = IsInState('ClientFiring') || IsInState('SimFinishFire');
	bClientReadyToFire = False;
	GotoState('SimDownWeapon');
}

simulated function ClientActive()
{
	bWasInFiring = IsInState('ClientFiring') || IsInState('SimFinishFire');
	bClientReadyToFire = False;
	GotoState('SimActive');
}

simulated function ClientReload()
{
	bWasInFiring = IsInState('ClientFiring') || IsInState('SimFinishFire');
	bClientReadyToFire = False;
	GotoState('SimReload');
}

//
// weapon states
//

// Vanilla Matters: Rewrite the mess and fix automatic firing.
state NormalFire {
	function AnimEnd() {
		if ( bAutomatic ) {
			if ( Pawn( Owner ).bFire != 0 && AmmoType.AmmoAmount > 0 ) {
				if ( PlayerPawn( Owner ) != none ) {
					global.Fire( 0 );
				}
				else {
					GotoState( 'FinishFire' );
				}
			}
			else {
				GotoState('FinishFire');
			}
		}
		else {
			if ( bHandToHand && ReloadCount > 0 && AmmoType.AmmoAmount <= 0 ) {
				Destroy();
			}
		}
	}

	function float GetShotTime() {
		local float mult, sTime;
		local ScriptedPawn sp;
		local DeusExPlayer player;

		sp = ScriptedPawn( Owner );

		if ( sp != none ) {
			return ShotTime * ( sp.BaseAccuracy * 2 + 1 );
		}
		else {
			player = DeusExPlayer( Owner );
			mult = 1.0;
			if ( bHandToHand && player != none ) {
				// Vanilla Matters: Tweak AugCombat bonus.
				mult = player.AugmentationSystem.GetAugLevelValue( class'AugCombat' );
				if ( mult == -1 ) {
					mult = 1.0;
				}
				else {
					mult = 1 - mult;
				}
			}

			sTime = ShotTime * mult;

			return ( sTime );
		}
	}

	function HandleFire() {
		local DeusExPlayer player;

		if ( Owner != none ) {
			if ( ScriptedPawn( Owner ) != none ) {
				bFiring = False;
				ReloadAmmo();
			}
			else {
				player = DeusExPlayer( Owner );
				if ( player != none ) {
					bFiring = False;

					if ( player.bAutoReload ) {
						if ( AmmoType.AmmoAmount == 0 && AmmoName != AmmoNames[0] ) {
							CycleAmmo();
						}

						ReloadAmmo();
					}
					else {
						if ( bHasMuzzleFlash ) {
							EraseMuzzleFlashTexture();
						}

						GotoState( 'Idle' );
					}
				}
			}
		}
		else {
			if ( bHasMuzzleFlash ) {
				EraseMuzzleFlashTexture();
			}

			GotoState( 'Idle' );
		}
	}

	function HandlePostFire() {
		local DeusExPlayer player;

		bFiring = False;

		if ( ReloadCount == 0 && !bHandToHand ) {
			player = DeusExPlayer( Owner );
			if ( player != None) {
				player.RemoveItemFromSlot( self );
			}

			Destroy();
		}
	}

Begin:
	VM_readyFire = false;

	if ( ClipCount >= ReloadCount && ReloadCount != 0 ) {
		if ( !bAutomatic ) {
			bFiring = False;
			FinishAnim();
		}

		HandleFire();
	}

	Sleep( GetShotTime() );

	if ( bHandToHand ) {
		FinishAnim();
	}

	HandlePostFire();
Done:
	bFiring = False;
	Finish();
}

state FinishFire
{
Begin:
	bFiring = False;
	if ( bDestroyOnFinish )
		Destroy();
	else
		Finish();
}

state Pickup
{
	function BeginState()
	{
		// alert NPCs that I'm putting away my gun
		AIEndEvent('WeaponDrawn', EAITYPE_Visual);

		Super.BeginState();
	}
}

state Reload
{
ignores Fire, AltFire;

	function float GetReloadTime()
	{
		local float val;

		val = ReloadTime;

		if (ScriptedPawn(Owner) != None)
		{
			val = ReloadTime * (ScriptedPawn(Owner).BaseAccuracy*2+1);
		}
		else if (DeusExPlayer(Owner) != None)
		{
			// check for skill use if we are the player

			// Vanilla Matters: Handle all forms of bonuses here.
			val = GetWeaponSkill() + ModReloadTime;
			val = ReloadTime + ( val * ReloadTime );
		}

		return val;
	}

	function NotifyOwner(bool bStart)
	{
		local DeusExPlayer player;
		local ScriptedPawn pawn;

		player = DeusExPlayer(Owner);
		pawn   = ScriptedPawn(Owner);

		if (player != None)
		{
			if (bStart)
				player.Reloading(self, GetReloadTime()+(1.0/AnimRate));
			else
			{
				player.DoneReloading(self);
			}
		}
		else if (pawn != None)
		{
			if (bStart)
				pawn.Reloading(self, GetReloadTime()+(1.0/AnimRate));
			else
				pawn.DoneReloading(self);
		}
	}

	function Tick( float deltaTime ) {
		global.Tick( deltaTime );

		if ( Pawn( Owner ).bFire != 0 ) {
			VM_stopReload = true;
		}
	}

Begin:
	// Vanilla Matters
	VM_stopReload = false;

	FinishAnim();

	// only reload if we have ammo left
	if (AmmoType.AmmoAmount > 0)
	{
		if (( Level.NetMode == NM_DedicatedServer ) || ((Level.NetMode == NM_ListenServer) && Owner.IsA('DeusExPlayer') && !DeusExPlayer(Owner).PlayerIsListenClient()))
		{
			ClientReload();
			Sleep(GetReloadTime());
			ReadyClientToFire( True );
		}
		else
		{
			bWasZoomed = bZoomed;
			if (bWasZoomed)
				ScopeOff();

			Owner.PlaySound(CockingSound, SLOT_None,,, 1024);		// CockingSound is reloadbegin
			PlayAnim('ReloadBegin');
			NotifyOwner(True);
			FinishAnim();
			LoopAnim('Reload');
			Sleep(GetReloadTime());
			Owner.PlaySound(AltFireSound, SLOT_None,,, 1024);		// AltFireSound is reloadend

			// Vanilla Matters: Add reloading one by one.
			if ( VM_pumpAction ) {
				ClipCount = FMax( ClipCount - 1, 1 - AmmoType.AmmoAmount );

				if ( !VM_stopReload && ClipCount > 0 ) {
					Goto( 'Begin' );
				}
			}

			PlayAnim('ReloadEnd');
			FinishAnim();
			NotifyOwner(False);

			if (bWasZoomed)
				ScopeOn();

			// Vanilla Matters: Correctly represent the amount of ammo in clip.
			if ( !VM_pumpAction ) {
				ClipCount = FMax( 0, ReloadCount - AmmoType.AmmoAmount );
			}
		}
	}
	GotoState('Idle');
}

simulated state ClientFiring
{
	simulated function AnimEnd()
	{
		bInProcess = False;

		if (bAutomatic)
		{
			if ((Pawn(Owner).bFire != 0) && (AmmoType.AmmoAmount > 0))
			{
				if (PlayerPawn(Owner) != None)
					ClientReFire(0);
				else
					GotoState('SimFinishFire');
			}
			else 
				GotoState('SimFinishFire');
		}
	}
	simulated function float GetSimShotTime()
	{
		local float mult, sTime;

		if (ScriptedPawn(Owner) != None)
			return ShotTime * (ScriptedPawn(Owner).BaseAccuracy*2+1);
		else
		{
			// AugCombat decreases shot time
			mult = 1.0;
			if (bHandToHand && DeusExPlayer(Owner) != None)
			{
				mult = 1.0 / DeusExPlayer(Owner).AugmentationSystem.GetAugLevelValue(class'AugCombat');
				if (mult == -1.0)
					mult = 1.0;
				// Vanilla Matters: Compensate for reduced augcombat values.
				else {
					mult = mult / 10.0;
				}
			}
			sTime = ShotTime * mult;
			return (sTime);
		}
	}
Begin:
	if ((ClipCount >= ReloadCount) && (ReloadCount != 0))
	{
		if (!bAutomatic)
		{
			bFiring = False;
			FinishAnim();
		}
		if (Owner != None)
		{
			if (Owner.IsA('DeusExPlayer'))
			{
				bFiring = False;
				if (DeusExPlayer(Owner).bAutoReload)
				{
					bClientReadyToFire = False;
					bInProcess = False;
					if ((AmmoType.AmmoAmount == 0) && (AmmoName != AmmoNames[0]))
						CycleAmmo();
					ReloadAmmo();
					GotoState('SimQuickFinish');
				}
				else
				{
					if (bHasMuzzleFlash)
						EraseMuzzleFlashTexture();
					IdleFunction();
					GotoState('SimQuickFinish');
				}
			}
			else if (Owner.IsA('ScriptedPawn'))
			{
				bFiring = False;
			}
		}
		else
		{
			if (bHasMuzzleFlash)
				EraseMuzzleFlashTexture();
			IdleFunction();
			GotoState('SimQuickFinish');
		}
	}
	Sleep(GetSimShotTime());
	if (bAutomatic)
	{
		SimGenerateBullet();
		Goto('Begin');
	}
	bFiring = False;
	FinishAnim();
	bInProcess = False;
Done:
	bInProcess = False;
	bFiring = False;
	SimFinish();
}

simulated state SimQuickFinish
{
Begin:
	if ( IsAnimating() && (AnimSequence == 'Shoot') )
		FinishAnim();

	if (bHasMuzzleFlash)
		EraseMuzzleFlashTexture();

	bInProcess = False;
	bFiring=False;
}

simulated state SimIdle
{
	function Timer()
	{
		PlayIdleAnim();
	}
Begin:
	bInProcess = False;
	bFiring = False;
	if (!bNearWall)
		PlayAnim('Idle1',,0.1);
	SetTimer(3.0, True);
}


simulated state SimFinishFire
{
Begin:
	FinishAnim();

	if ( PlayerPawn(Owner) != None )
		PlayerPawn(Owner).FinishAnim();

	if (bHasMuzzleFlash)
		EraseMuzzleFlashTexture();

	bInProcess = False;
	bFiring=False;
	SimFinish();
}

simulated state SimDownweapon
{
ignores Fire, AltFire, ClientFire, ClientReFire;

Begin:
	if ( bWasInFiring )
	{
		if (bHasMuzzleFlash)
			EraseMuzzleFlashTexture();
		FinishAnim();
	}
	bInProcess = False;
	bFiring=False;
	TweenDown();
	FinishAnim();
}

simulated state SimActive
{
Begin:
	if ( bWasInFiring )
	{
		if (bHasMuzzleFlash)
			EraseMuzzleFlashTexture();
		FinishAnim();
	}
	bInProcess = False;
	bFiring=False;
	PlayAnim('Select',1.0,0.0);
	FinishAnim();
	SimFinish();
}

simulated state SimReload
{
ignores Fire, AltFire, ClientFire, ClientReFire;

	simulated function float GetSimReloadTime()
	{
		local float val;

		val = ReloadTime;

		if (ScriptedPawn(Owner) != None)
		{
			val = ReloadTime * (ScriptedPawn(Owner).BaseAccuracy*2+1);
		}
		else if (DeusExPlayer(Owner) != None)
		{
			// check for skill use if we are the player
			// val = GetWeaponSkill();
			// val = ReloadTime + (val*ReloadTime);

			// Vanilla Matters: Handle all forms of bonuses here.
			val = GetWeaponSkill() + ModReloadTime;
			val = ReloadTime + ( val * ReloadTime );
		}
		return val;
	}
Begin:
	if ( bWasInFiring )
	{
		if (bHasMuzzleFlash)
			EraseMuzzleFlashTexture();
		FinishAnim();
	}
	bInProcess = False;
	bFiring=False;

	bWasZoomed = bZoomed;
	if (bWasZoomed)
		ScopeOff();

	Owner.PlaySound(CockingSound, SLOT_None,,, 1024);		// CockingSound is reloadbegin
	PlayAnim('ReloadBegin');
	FinishAnim();
	LoopAnim('Reload');
	Sleep(GetSimReloadTime());
	Owner.PlaySound(AltFireSound, SLOT_None,,, 1024);		// AltFireSound is reloadend
	ServerDoneReloading();
	PlayAnim('ReloadEnd');
	FinishAnim();

	if (bWasZoomed)
		ScopeOn();

	GotoState('SimIdle');
}


state Idle
{
	function bool PutDown()
	{
		// alert NPCs that I'm putting away my gun
		AIEndEvent('WeaponDrawn', EAITYPE_Visual);

		return Super.PutDown();
	}

	function AnimEnd()
	{
	}

	function Timer()
	{
		PlayIdleAnim();
	}

Begin:
	bFiring = False;
	ReadyToFire();

	if (( Level.NetMode == NM_DedicatedServer ) || ((Level.NetMode == NM_ListenServer) && Owner.IsA('DeusExPlayer') && !DeusExPlayer(Owner).PlayerIsListenClient()))
	{
	}
	else
	{
		if (!bNearWall)
			PlayAnim('Idle1',,0.1);
		SetTimer(3.0, True);
	}
}

state FlameThrowerOn
{
	function float GetShotTime()
	{
		local float mult, sTime;

		if (ScriptedPawn(Owner) != None)
			return ShotTime * (ScriptedPawn(Owner).BaseAccuracy*2+1);
		else
		{
			// AugCombat decreases shot time
			mult = 1.0;
			if (bHandToHand && DeusExPlayer(Owner) != None)
			{
				mult = 1.0 / DeusExPlayer(Owner).AugmentationSystem.GetAugLevelValue(class'AugCombat');
				if (mult == -1.0)
					mult = 1.0;
			}

			sTime = ShotTime * mult;
			return (sTime);
		}
	}

Begin:
	if ( (DeusExPlayer(Owner).Health > 0) && bFlameOn && (ClipCount < ReloadCount))
	{
		if (( flameShotCount == 0 ) && (Owner != None))
		{
			PlayerPawn(Owner).PlayFiring();
			PlaySelectiveFiring();
			PlayFiringSound();
			flameShotCount = 6;
		}
		else
			flameShotCount--;

		Sleep( GetShotTime() );
		GenerateBullet();
		goto('Begin');
	}
Done:
	bFlameOn = False;
	GotoState('FinishFire');
}

state Active
{
	function bool PutDown()
	{
		// alert NPCs that I'm putting away my gun
		AIEndEvent('WeaponDrawn', EAITYPE_Visual);
		return Super.PutDown();
	}

Begin:
	// Rely on client to fire if we are a multiplayer client

	if ( (Level.NetMode==NM_Standalone) || (Owner.IsA('DeusExPlayer') && DeusExPlayer(Owner).PlayerIsListenClient()) )
		bClientReady = True;
	if (( Level.NetMode == NM_DedicatedServer ) || ((Level.NetMode == NM_ListenServer) && Owner.IsA('DeusExPlayer') && !DeusExPlayer(Owner).PlayerIsListenClient()))
	{
		ClientActive();
		bClientReady = False;
	}

	if (!Owner.IsA('ScriptedPawn'))
		FinishAnim();
	if ( bChangeWeapon )
		GotoState('DownWeapon');

	bWeaponUp = True;
	PlayPostSelect();
	if (!Owner.IsA('ScriptedPawn'))
		FinishAnim();
	// reload the weapon if it's empty and autoreload is true
	if ((ClipCount >= ReloadCount) && (ReloadCount != 0))
	{
		if (Owner.IsA('ScriptedPawn') || ((DeusExPlayer(Owner) != None) && DeusExPlayer(Owner).bAutoReload))
			ReloadAmmo();
	}
	Finish();
}


state DownWeapon
{
ignores Fire, AltFire;

	function bool PutDown()
	{
		// alert NPCs that I'm putting away my gun
		AIEndEvent('WeaponDrawn', EAITYPE_Visual);
		return Super.PutDown();
	}

Begin:
   ScopeOff();
	LaserOff();

	if (( Level.NetMode == NM_DedicatedServer ) || ((Level.NetMode == NM_ListenServer) && Owner.IsA('DeusExPlayer') && !DeusExPlayer(Owner).PlayerIsListenClient()))
		ClientDownWeapon();

	TweenDown();
	FinishAnim();

	// Vanilla Matters: No longer auto reload when put away in mp.

	bOnlyOwnerSee = false;
	if (Pawn(Owner) != None)
		Pawn(Owner).ChangedWeapon();
}

// ----------------------------------------------------------------------
// TestMPBeltSpot()
// Returns true if the suggested belt location is ok for the object in mp.
// ----------------------------------------------------------------------

simulated function bool TestMPBeltSpot(int BeltSpot)
{
   return ((BeltSpot <= 3) && (BeltSpot >= 1));
}

defaultproperties
{
     bReadyToFire=True
     LowAmmoWaterMark=10
     NoiseLevel=1.000000
     ShotTime=0.500000
     reloadTime=1.000000
     HitDamage=10
     maxRange=9600
     AccurateRange=4800
     BaseAccuracy=0.500000
     ScopeFOV=10
     MaintainLockTimer=1.000000
     bPenetrating=True
     bHasMuzzleFlash=True
     bEmitWeaponDrawn=True
     bUseWhileCrouched=True
     bUseAsDrawnWeapon=True
     MinSpreadAcc=0.250000
     MinProjSpreadAcc=1.000000
     bNeedToSetMPPickupAmmo=True
     msgCannotBeReloaded="This weapon can't be reloaded"
     msgOutOf="Out of %s"
     msgNowHas="%s now has %s loaded"
     msgAlreadyHas="%s already has %s loaded"
     msgNone="NONE"
     msgLockInvalid="INVALID"
     msgLockRange="RANGE"
     msgLockAcquire="ACQUIRE"
     msgLockLocked="LOCKED"
     msgRangeUnit="FT"
     msgTimeUnit="SEC"
     msgMassUnit="LBS"
     msgNotWorking="This weapon doesn't work underwater"
     msgInfoAmmoLoaded="Ammo loaded:"
     msgInfoAmmo="Ammo type(s):"
     msgInfoDamage="Base damage:"
     msgInfoClip="Clip size:"
     msgInfoROF="Rate of fire:"
     msgInfoReload="Reload time:"
     msgInfoRecoil="Recoil:"
     msgInfoAccuracy="Base Accuracy:"
     msgInfoAccRange="Acc. range:"
     msgInfoMaxRange="Max. range:"
     msgInfoMass="Mass:"
     msgInfoLaser="Laser sight:"
     msgInfoScope="Scope:"
     msgInfoSilencer="Silencer:"
     msgInfoNA="N/A"
     msgInfoYes="YES"
     msgInfoNo="NO"
     msgInfoAuto="AUTO"
     msgInfoSingle="SINGLE"
     msgInfoRounds="RDS"
     msgInfoRoundsPerSec="RDS/SEC"
     msgInfoSkill="Skill:"
     msgInfoWeaponStats="Weapon Stats:"
     VM_ShotCount(0)=1
     VM_ShotCount(1)=1
     VM_ShotCount(2)=1
     VM_ShotCount(3)=1
     VM_ShotBreaksStuff(0)=1.000000
     VM_ShotBreaksStuff(1)=1.000000
     VM_ShotBreaksStuff(2)=1.000000
     VM_ShotBreaksStuff(3)=1.000000
     VM_HeadshotMult(0)=4.000000
     VM_HeadshotMult(1)=4.000000
     VM_HeadshotMult(2)=4.000000
     VM_HeadshotMult(3)=4.000000
     VM_baseStandingRate=2.500000
     VM_standingBonus=0.200000
     VM_recoilRate=2.000000
     VM_modTimerMax=0.250000
     VM_readyFire=True
     VM_handsTexPos(0)=-1
     VM_handsTexPos(1)=-1
     VM_msgInfoIgnite="Ignites enemies:"
     VM_msgInfoHeadshot="Headshot:"
     VM_msgFullClip="You are already fully loaded"
     VM_msgNoAmmo="No ammo left to reload"
     ReloadCount=10
     shakevert=10.000000
     Misc1Sound=Sound'DeusExSounds.Generic.DryFire'
     AutoSwitchPriority=0
     bRotatingPickup=False
     PickupMessage="You found"
     ItemName="DEFAULT WEAPON NAME - REPORT THIS AS A BUG"
     LandSound=Sound'DeusExSounds.Generic.DropSmallWeapon'
     bNoSmooth=False
     Mass=10.000000
     Buoyancy=5.000000
}
