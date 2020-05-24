//=============================================================================
// WeaponPepperGun.
//=============================================================================
class WeaponPepperGun extends DeusExWeapon;

// Vanilla Matters
#exec AUDIO IMPORT FILE="Sounds\PepperGun\fire1.wav"        NAME="PepperGunFire1"       GROUP="VMSounds"
#exec AUDIO IMPORT FILE="Sounds\PepperGun\fire2.wav"        NAME="PepperGunFire2"       GROUP="VMSounds"
#exec AUDIO IMPORT FILE="Sounds\PepperGun\fire3.wav"        NAME="PepperGunFire3"       GROUP="VMSounds"
#exec AUDIO IMPORT FILE="Sounds\PepperGun\fire4.wav"        NAME="PepperGunFire4"       GROUP="VMSounds"
#exec AUDIO IMPORT FILE="Sounds\PepperGun\fire5.wav"        NAME="PepperGunFire5"       GROUP="VMSounds"

// Vanilla Matters
var int VM_currentSoundIndex;

var Sound VM_fireSounds[5];

simulated function PreBeginPlay()
{
    Super.PreBeginPlay();

    // If this is a netgame, then override defaults
    if ( Level.NetMode != NM_StandAlone )
    {
        HitDamage = mpHitDamage;
        BaseAccuracy = mpBaseAccuracy;
        ReloadTime = mpReloadTime;
        AccurateRange = mpAccurateRange;
        MaxRange = mpMaxRange;
    }
}

// Vanilla Matters: Iterate through all the firing sounds.
simulated function PlayFiringSound() {
    FireSound = VM_fireSounds[VM_currentSoundIndex];

    VM_currentSoundIndex = VM_currentSoundIndex + 1;
    if ( VM_currentSoundIndex >= 5 ) {
        VM_currentSoundIndex = 3;
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
     VM_fireSounds(0)=Sound'DeusEx.VMSounds.PepperGunFire1'
     VM_fireSounds(1)=Sound'DeusEx.VMSounds.PepperGunFire2'
     VM_fireSounds(2)=Sound'DeusEx.VMSounds.PepperGunFire3'
     VM_fireSounds(3)=Sound'DeusEx.VMSounds.PepperGunFire4'
     VM_fireSounds(4)=Sound'DeusEx.VMSounds.PepperGunFire5'
     LowAmmoWaterMark=50
     GoverningSkill=Class'DeusEx.SkillWeaponLowTech'
     NoiseLevel=0.200000
     EnemyEffective=ENMEFF_Organic
     EnviroEffective=ENVEFF_AirVacuum
     Concealability=CONC_Visual
     bAutomatic=True
     ShotTime=0.100000
     reloadTime=3.000000
     HitDamage=7
     maxRange=100
     AccurateRange=100
     BaseAccuracy=0.700000
     AreaOfEffect=AOE_Sphere
     bPenetrating=False
     StunDuration=15.000000
     bHasMuzzleFlash=False
     mpReloadTime=4.000000
     mpBaseAccuracy=0.700000
     mpAccurateRange=100
     mpMaxRange=100
     VM_HeadshotMult=1.000000
     VM_handsTexPos(0)=0
     VM_handsTexPos(1)=4
     AmmoName=Class'DeusEx.AmmoPepper'
     ReloadCount=100
     PickupAmmoCount=100
     FireOffset=(X=8.000000,Y=4.000000,Z=14.000000)
     ProjectileClass=Class'DeusEx.TearGas'
     shakemag=10.000000
     FireSound=Sound'DeusEx.VMSounds.PepperGunFire1'
     AltFireSound=Sound'DeusExSounds.Weapons.PepperGunReloadEnd'
     CockingSound=Sound'DeusExSounds.Weapons.PepperGunReload'
     SelectSound=Sound'DeusExSounds.Weapons.PepperGunSelect'
     InventoryGroup=18
     ItemName="Pepper Gun"
     PlayerViewOffset=(X=16.000000,Y=-10.000000,Z=-16.000000)
     PlayerViewMesh=LodMesh'DeusExItems.PepperGun'
     PickupViewMesh=LodMesh'DeusExItems.PepperGunPickup'
     ThirdPersonMesh=LodMesh'DeusExItems.PepperGun3rd'
     Icon=Texture'DeusExUI.Icons.BeltIconPepperSpray'
     largeIcon=Texture'DeusExUI.Icons.LargeIconPepperSpray'
     largeIconWidth=46
     largeIconHeight=40
     Description="The pepper gun will accept a number of commercially available riot control agents in cartridge form and disperse them as a fine aerosol mist that can cause blindness or blistering at short-range."
     beltDescription="PEPPER"
     Mesh=LodMesh'DeusExItems.PepperGunPickup'
     CollisionRadius=7.000000
     CollisionHeight=1.500000
     Mass=7.000000
     Buoyancy=2.000000
}
