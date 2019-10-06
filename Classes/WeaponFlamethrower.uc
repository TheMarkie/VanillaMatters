//=============================================================================
// WeaponFlamethrower.
//=============================================================================
class WeaponFlamethrower extends DeusExWeapon;

// Vanilla Matters
#exec AUDIO IMPORT FILE="Sounds\Flamethrower\fire1.wav"     NAME="FlamethrowerFire1"        GROUP="VMSounds"
#exec AUDIO IMPORT FILE="Sounds\Flamethrower\fire2.wav"     NAME="FlamethrowerFire2"        GROUP="VMSounds"
#exec AUDIO IMPORT FILE="Sounds\Flamethrower\fire3.wav"     NAME="FlamethrowerFire3"        GROUP="VMSounds"
#exec AUDIO IMPORT FILE="Sounds\Flamethrower\fire4.wav"     NAME="FlamethrowerFire4"        GROUP="VMSounds"
#exec AUDIO IMPORT FILE="Sounds\Flamethrower\fire5.wav"     NAME="FlamethrowerFire5"        GROUP="VMSounds"
#exec AUDIO IMPORT FILE="Sounds\Flamethrower\fire6.wav"     NAME="FlamethrowerFire6"        GROUP="VMSounds"
#exec AUDIO IMPORT FILE="Sounds\Flamethrower\fire7.wav"     NAME="FlamethrowerFire7"        GROUP="VMSounds"
#exec AUDIO IMPORT FILE="Sounds\Flamethrower\fire8.wav"     NAME="FlamethrowerFire8"        GROUP="VMSounds"

// Vanilla Matters
var int VM_currentSoundIndex;

var Sound VM_fireSounds[13];

var int BurnTime, BurnDamage;

var int     mpBurnTime;
var int     mpBurnDamage;

simulated function PreBeginPlay()
{
    Super.PreBeginPlay();

    // If this is a netgame, then override defaults
    if ( Level.NetMode != NM_StandAlone )
    {
      HitDamage = mpHitDamage;
      BaseAccuracy=mpBaseAccuracy;
      ReloadTime = mpReloadTime;
      AccurateRange = mpAccurateRange;
      MaxRange = mpMaxRange;
      ReloadCount = mpReloadCount;
      BurnTime = mpBurnTime;
      BurnDamage = mpBurnDamage;
      PickupAmmoCount = mpReloadCount;
    }
}

// Vanilla Matters: Iterate through all the firing sounds.
simulated function PlayFiringSound() {
    FireSound = VM_fireSounds[VM_currentSoundIndex];

    VM_currentSoundIndex = VM_currentSoundIndex + 1;
    if ( VM_currentSoundIndex >= 9 ) {
        VM_currentSoundIndex = Rand( 4 ) + 3;
    }

    super.PlayFiringSound();
}

// Vanilla Matters: Reset the sound index when not firing.
simulated function Tick( float deltaTime ) {
    local Pawn p;

    p = Pawn( Owner );
    if ( p != none && p.bFire == 0 && !bFiring && VM_currentSoundIndex != 0 ) {
        VM_currentSoundIndex = 0;
    }

    super.Tick( deltaTime );
}

defaultproperties
{
     VM_fireSounds(0)=Sound'DeusEx.VMSounds.FlamethrowerFire1'
     VM_fireSounds(1)=Sound'DeusEx.VMSounds.FlamethrowerFire2'
     VM_fireSounds(2)=Sound'DeusEx.VMSounds.FlamethrowerFire3'
     VM_fireSounds(3)=Sound'DeusEx.VMSounds.FlamethrowerFire4'
     VM_fireSounds(4)=Sound'DeusEx.VMSounds.FlamethrowerFire5'
     VM_fireSounds(5)=Sound'DeusEx.VMSounds.FlamethrowerFire6'
     VM_fireSounds(6)=Sound'DeusEx.VMSounds.FlamethrowerFire7'
     VM_fireSounds(7)=Sound'DeusEx.VMSounds.FlamethrowerFire8'
     burnTime=30
     burnDamage=5
     mpBurnTime=15
     mpBurnDamage=2
     LowAmmoWaterMark=50
     GoverningSkill=Class'DeusEx.SkillWeaponHeavy'
     EnviroEffective=ENVEFF_Air
     bAutomatic=True
     ShotTime=0.100000
     reloadTime=5.500000
     HitDamage=15
     maxRange=320
     AccurateRange=320
     BaseAccuracy=0.900000
     AreaOfEffect=AOE_Cone
     bHasMuzzleFlash=False
     mpReloadTime=0.500000
     mpHitDamage=5
     mpBaseAccuracy=0.900000
     mpAccurateRange=320
     mpMaxRange=320
     mpReloadCount=100
     bCanHaveModReloadTime=True
     VM_handsTexPos(0)=0
     AmmoName=Class'DeusEx.AmmoNapalm'
     ReloadCount=100
     PickupAmmoCount=100
     FireOffset=(Y=10.000000,Z=10.000000)
     ProjectileClass=Class'DeusEx.Fireball'
     shakemag=50.000000
     FireSound=Sound'DeusEx.VMSounds.FlamethrowerFire1'
     AltFireSound=Sound'DeusExSounds.Weapons.FlamethrowerReloadEnd'
     CockingSound=Sound'DeusExSounds.Weapons.FlamethrowerReload'
     SelectSound=Sound'DeusExSounds.Weapons.FlamethrowerSelect'
     InventoryGroup=15
     ItemName="Flamethrower"
     PlayerViewOffset=(X=20.000000,Y=-14.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DeusExItems.Flamethrower'
     PickupViewMesh=LodMesh'DeusExItems.FlamethrowerPickup'
     ThirdPersonMesh=LodMesh'DeusExItems.Flamethrower3rd'
     LandSound=Sound'DeusExSounds.Generic.DropLargeWeapon'
     Icon=Texture'DeusExUI.Icons.BeltIconFlamethrower'
     largeIcon=Texture'DeusExUI.Icons.LargeIconFlamethrower'
     largeIconWidth=203
     largeIconHeight=69
     invSlotsX=4
     invSlotsY=2
     Description="A portable flamethrower that discards the old and highly dangerous backpack fuel delivery system in favor of pressurized canisters of napalm. Inexperienced agents will find that a flamethrower can be difficult to maneuver, however."
     beltDescription="FLAMETHWR"
     Mesh=LodMesh'DeusExItems.FlamethrowerPickup'
     CollisionRadius=20.500000
     CollisionHeight=4.400000
     Mass=40.000000
}
