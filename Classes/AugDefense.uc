//=============================================================================
// AugDefense.
//=============================================================================
class AugDefense extends Augmentation;

var float mpAugValue;
var float mpEnergyDrain;
//var bool bDefenseActive;

var float defenseSoundTime;
const defenseSoundDelay = 2;

var float timePassed;

var ScriptedPawn currentSP;
var float defenseWeaponTime;
const defenseWeaponDelay = 1.5;

// ----------------------------------------------------------------------------
// Networking Replication
// ----------------------------------------------------------------------------

replication
{
   // //server to client variable propagation.
   // reliable if (Role == ROLE_Authority)
   //    bDefenseActive;

   // //server to client function call
   // reliable if (Role == ROLE_Authority)
   //    TriggerDefenseAugHUD, SetDefenseAugStatus;

	// Vanilla Matters: Replicate new values.
	reliable if ( Role == ROLE_Authority )
		timePassed, defenseWeaponTime;

	reliable if ( Role == ROLE_Authority )
		SetDefenseAugStatus;
}

// state Active
// {
// 	function Timer()
// 	{
// 		local DeusExProjectile minproj;
// 		local float mindist;

// 		minproj = None;

//       // DEUS_EX AMSD Multiplayer check
//       if (Player == None)
//       {
//          SetTimer(0.1,False);
//          return;
//       }

// 		// In multiplayer propagate a sound that will let others know their in an aggressive defense field
// 		// with range slightly greater than the current level value of the aug
// 		if ( (Level.NetMode != NM_Standalone) && ( Level.Timeseconds > defenseSoundTime ))
// 		{
// 			Player.PlaySound(Sound'AugDefenseOn', SLOT_Interact, 1.0, ,(LevelValues[CurrentLevel]*1.33), 0.75);
// 			defenseSoundTime = Level.Timeseconds + defenseSoundDelay;
// 		}

//       //DEUS_EX AMSD Exported to function call for duplication in multiplayer.
//       minproj = FindNearestProjectile();

// 		// if we have a valid projectile, send it to the aug display window
// 		if (minproj != None)
// 		{
//          bDefenseActive = True;
//          mindist = VSize(Player.Location - minproj.Location);

//          // DEUS_EX AMSD In multiplayer, let the client turn his HUD on here.
//          // In singleplayer, turn it on normally.
//          if (Level.Netmode != NM_Standalone)
//             TriggerDefenseAugHUD();
//          else
//          {         
//             SetDefenseAugStatus(True,CurrentLevel,minproj);
//          }

// 			// play a warning sound
// 			Player.PlaySound(sound'GEPGunLock', SLOT_None,,,, 2.0);

// 			if (mindist < LevelValues[CurrentLevel])
// 			{
//             minproj.bAggressiveExploded=True;
// 				minproj.Explode(minproj.Location, vect(0,0,1));
// 				Player.PlaySound(sound'ProdFire', SLOT_None,,,, 2.0);
// 			}
// 		}
// 		else
// 		{
//          if ((Level.NetMode == NM_Standalone) || (bDefenseActive))
//             SetDefenseAugStatus(False,CurrentLevel,None);
//          bDefenseActive = false;
// 		}
// 	}

// Begin:
// 	SetTimer(0.1, True);
// }

// function Deactivate()
// {
// 	Super.Deactivate();

// 	SetTimer(0.1, False);
//    SetDefenseAugStatus(False,CurrentLevel,None);
// }

// Vanilla Matters: Gonna rewrite all that stuff above to optimize things and add new features.
state Active {
	simulated function Tick( float deltaTime ) {
		local Actor target;

		local DeusExWeapon w;
		local Vector HitLocation, X, Y, Z;
		local ExplosionLight light;
		local SphereEffect sphere;

		Super.Tick( deltaTime );

		timePassed = timePassed + deltaTime;

		if ( timePassed >= 0.1 ) {
			timePassed = timePassed - 0.1;
		}
		else {
			return;
		}

		if ( Level.NetMode != NM_Standalone ) {
			defenseSoundTime = defenseSoundTime + deltaTime;

			if ( defenseSoundTime >= defenseSoundDelay ) {
				Player.PlaySound( Sound'AugDefenseOn', SLOT_Interact, 1.0,, LevelValues[CurrentLevel] * 1.33, 0.75 );
				defenseSoundTime = defenseSoundTime - defenseSoundDelay;
			}
		}

		target = FindNearestTarget();

		if ( target != None ) {
			SetDefenseAugStatus( true, CurrentLevel, target );
			Player.PlaySound( Sound'GEPGunLock', SLOT_None,,,, 2.0 );
		}
		else {
			SetDefenseAugStatus( false, CurrentLevel, none );
			defenseWeaponTime = 0;
			return;
		}

		if ( DeusExProjectile( target ) != None ) {
			defenseWeaponTime = 0;

			DeusExProjectile( target ).bAggressiveExploded= true;
			DeusExProjectile( target ).Explode( target.Location, vect( 0, 0, 1 ) );

			Player.PlaySound( Sound'ProdFire', SLOT_None,,,, 2.0 );
		}
		else if ( ScriptedPawn( target ) != None ) {
			// VM: Add 0.1 extra because the aug only checks every 0.1 second.
			defenseWeaponTime = defenseWeaponTime + 0.1 + deltaTime;

			if ( defenseWeaponTime >= defenseWeaponDelay ) {
				defenseWeaponTime = 0;

				w = DeusExWeapon( Pawn( target ).Weapon );
				if ( w != None ) {
					// VM: Gotta do this to get the accurate weapon position in third person.
					w.GetAxes( Pawn( target ).ViewRotation, X, Y, Z );
					HitLocation = target.Location + ( w.FireOffset.X * X ) + ( w.FireOffset.Y * Y ) + ( w.FireOffset.Z * Z );

					// VM: Some hacky calculations for the weapon location while the pawn is crouching.
					if ( ScriptedPawn( target ).bCrouching ) {
						HitLocation.Z = HitLocation.Z + ( HitLocation.Z * 0.175 );
						HitLocation.Y = HitLocation.Y + ( HitLocation.Y * 0.0008 );
					}

					ScriptedPawn( target ).DropWeapon();
					target.TakeDamage( w.HitDamage * ( w.ReloadCount - w.ClipCount ) * w.VM_ShotCount[0], Player, HitLocation, vect( 0, 0, 0 ), 'Exploded' );
					w.Destroy();

					// VM: Replicate what happens to projectiles detonated by the aug.
					light = Spawn( class'ExplosionLight',,, HitLocation );
					if ( light != None ) {
						light.RemoteRole = ROLE_None;
					}

					sphere = Spawn( class'SphereEffect',,, HitLocation, rot( 16384, 0, 0 ) );
					if ( sphere != None ) {
						sphere.RemoteRole = ROLE_None;
						sphere.size = 0.5;
					}
					sphere = Spawn( class'SphereEffect',,, HitLocation, rot( 0, 0, 0 ) );
					if ( sphere != None ) {
						sphere.RemoteRole = ROLE_None;
						sphere.size = 0.5;
					}
					sphere = Spawn( class'SphereEffect',,, HitLocation, rot( 0, 16384, 0 ) );
					if ( sphere != None ) {
						sphere.RemoteRole = ROLE_None;
						sphere.size = 0.5;
					}
				}

				Player.PlaySound( Sound'ProdFire', SLOT_None,,,, 2.0 );
				target.PlaySound( Sound'SmallExplosion1', SLOT_None, 1.0,, LevelValues[CurrentLevel], 0.75 );
			}
		}
	}
Begin:
	timePassed = 0;
	defenseSoundTime = 0;
	defenseWeaponTime = 0;
}

state Inactive {
Begin:
	SetDefenseAugStatus( false, CurrentLevel, none );
	timePassed = 0;
	defenseSoundTime = 0;
	defenseWeaponTime = 0;
}

// ------------------------------------------------------------------------------
// FindNearestProjectile()
// DEUS_EX AMSD Exported to a function since it also needs to exist in the client
// TriggerDefenseAugHUD;
// ------------------------------------------------------------------------------

// simulated function DeusExProjectile FindNearestProjectile()
// {
//    local DeusExProjectile proj, minproj;
//    local float dist, mindist;
//    local bool bValidProj;

//    minproj = None;
//    mindist = 999999;
//    foreach AllActors(class'DeusExProjectile', proj)
//    {
//       if (Level.NetMode != NM_Standalone)
//          bValidProj = !proj.bIgnoresNanoDefense;
//       else
//          bValidProj = (!proj.IsA('Cloud') && !proj.IsA('Tracer') && !proj.IsA('GreaselSpit') && !proj.IsA('GraySpit'));

//       if (bValidProj)
//       {
//          // make sure we don't own it
//          if (proj.Owner != Player)
//          {
// 			 // MBCODE : If team game, don't blow up teammates projectiles
// 			if (!((TeamDMGame(Player.DXGame) != None) && (TeamDMGame(Player.DXGame).ArePlayersAllied(DeusExPlayer(proj.Owner),Player))))
// 			{
// 				// make sure it's moving fast enough
// 				if (VSize(proj.Velocity) > 100)
// 				{
// 				   dist = VSize(Player.Location - proj.Location);
// 				   if (dist < mindist)
// 				   {
// 					  mindist = dist;
// 					  minproj = proj;
// 				   }
// 				}
// 			}
//          }
//       }
//    }

//    return minproj;
// }

// Vanilla Matters: A new function that finds also ScriptedPawns attacking the player.
simulated function Actor FindNearestTarget() {
	local DeusExProjectile proj;
	local ScriptedPawn sp;
	local DeusExWeapon w;
	local bool bValid;
	local float dist, mindist;

	local Actor target;

	target = None;
	mindist = LevelValues[CurrentLevel];
	foreach AllActors( class'DeusExProjectile', proj ) {
		dist = VSize( Player.Location - proj.Location );
		if ( dist > mindist ) {
			continue;
		}

		if (Level.NetMode != NM_Standalone ) {
			bValid = !proj.bIgnoresNanoDefense;
		}
		else {
			bValid = ( !proj.IsA( 'Cloud' ) && !proj.IsA( 'Tracer' ) && !proj.IsA( 'GreaselSpit' ) && !proj.IsA( 'GraySpit' ) );
		}

		bValid = bValid && ( proj.Owner != Player && !( TeamDMGame( Player.DXGame ) != None && TeamDMGame( Player.DXGame ).ArePlayersAllied( DeusExPlayer( proj.Owner ), Player ) ) );

		bValid = bValid && Player.LineOfSightTo( proj );

		if ( bValid ) {
			if ( !proj.bStuck ) {
				mindist = dist;
				target = proj;
			}
		}
	}

	if ( target != None ) {
		return target;
	}

	bValid = false;
	mindist = LevelValues[CurrentLevel];
	foreach AllActors( class'ScriptedPawn', sp ) {
		dist = VSize( Player.Location - sp.Location );
		if ( dist > mindist ) {
			continue;
		}

		// VM: This function only works in SP because it'd be insanely unfair in MP.
		bValid = Level.NetMode == NM_Standalone;

		bValid = bValid && ( !sp.IsA( 'Animal' ) && !sp.IsA( 'Robot' ) && !sp.IsA( 'MJ12Commando' ) );

		bValid = bValid && ( !sp.IsInState( 'Dying' ) && sp.IsInState( 'Attacking' ) && sp.Enemy == Player );

		bValid = bValid && ( Player.LineOfSightTo( sp ) && sp.CanSee( Player ) );

		if ( bValid ) {
			w = DeusExWeapon( sp.Weapon );

			if ( w != None && !w.IsInState( 'DownWeapon' ) && w.bInstantHit && !w.bHandtoHand ) {
				mindist = dist;
				target = sp;
			}
		}
	}

	return target;
}

// ------------------------------------------------------------------------------
// TriggerDefenseAugHUD()
// ------------------------------------------------------------------------------

// simulated function TriggerDefenseAugHUD()
// {
//    local DeusExProjectile minproj;
   
//    minproj = None;
      
//    minproj = FindNearestProjectile();
   
//    // if we have a valid projectile, send it to the aug display window
//    // That's all we do.
//    if (minproj != None)
//    {
//       SetDefenseAugStatus(True,CurrentLevel,minproj);      
//    }
// }

// simulated function Tick(float DeltaTime)
// {
//    Super.Tick(DeltaTime);

//    // DEUS_EX AMSD Make sure it gets turned off in multiplayer.
//    if (Level.NetMode == NM_Client)
//    {
//       if (!bDefenseActive)
//          SetDefenseAugStatus(False,CurrentLevel,None);
//    }
// }

// ------------------------------------------------------------------------------
// SetDefenseAugStatus()
// ------------------------------------------------------------------------------
// simulated function SetDefenseAugStatus(bool bDefenseActive, int defenseLevel, DeusExProjectile defenseTarget)
// {
//    if (Player == None)
//       return;
//    if (Player.rootWindow == None)
//       return;
//    DeusExRootWindow(Player.rootWindow).hud.augDisplay.bDefenseActive = bDefenseActive;
//    DeusExRootWindow(Player.rootWindow).hud.augDisplay.defenseLevel = defenseLevel;
//    DeusExRootWindow(Player.rootWindow).hud.augDisplay.defenseTarget = defenseTarget;

// }

// Vanilla Matters: Change it to use actor.
simulated function SetDefenseAugStatus( bool bDefenseActive, int defenseLevel, Actor defenseTarget ) {
	if ( Player == None || Player.rootWindow == None ) {
		return;
	}

	DeusExRootWindow( Player.rootWindow ).hud.augDisplay.bDefenseActive = bDefenseActive;
	DeusExRootWindow( Player.rootWindow ).hud.augDisplay.defenseLevel = defenseLevel;
	DeusExRootWindow( Player.rootWindow ).hud.augDisplay.defenseTarget = defenseTarget;
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	// If this is a netgame, then override defaults
	if ( Level.NetMode != NM_StandAlone )
	{
		LevelValues[3] = mpAugValue;
		EnergyRate = mpEnergyDrain;
		defenseSoundTime=0;
	}
}

defaultproperties
{
     mpAugValue=500.000000
     mpEnergyDrain=10.000000
     EnergyRate=15.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconDefense'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconDefense_Small'
     AugmentationName="Aggressive Defense System"
     Description="Aerosol nanoparticles are released upon the detection of objects fitting the electromagnetic threat profile of hostile projectiles, explosives or weapons to detonate them before they can cause serious harm.|n|nTECH ONE: The range at which hostile objects are detonated is short.|n- Takes 1.5 seconds to detonate a weapon.|n|nTECH TWO:|n+100% detonation range.|n|nTECH THREE:|n+200% detonation range.|n|nTECH FOUR: Rockets and grenades are detonated almost before they are fired.|n+300% detonation range."
     MPInfo="When active, enemy rockets detonate when they get close, doing reduced damage.  Some large rockets may still be close enough to do damage when they explode.  Energy Drain: Very Low"
     LevelValues(0)=240.000000
     LevelValues(1)=480.000000
     LevelValues(2)=720.000000
     LevelValues(3)=960.000000
     MPConflictSlot=7
     VM_EnergyRateAddition(1)=15.000000
     VM_EnergyRateAddition(2)=30.000000
     VM_EnergyRateAddition(3)=45.000000
}
