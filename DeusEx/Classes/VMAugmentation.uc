class VMAugmentation extends VMUpgrade
    abstract;

//==============================================
// Description
//==============================================
var() Texture SmallIcon;

var() Sound ActivateSound;
var() Sound DeactivateSound;
var() Sound LoopSound;

//==============================================
// Properties
//==============================================
var() bool IsPassive;
var() array<float> Values;
var() array<float> Rates; // Energy cost per minute.

var bool NeedsTick;

//==============================================
// General info
//==============================================
static function int GetMaxLevel() {
    return #default.Rates;
}

//==============================================
// Behaviours
//==============================================
static final function Toggle( VMPlayer player, VMAugmentationInfo info, bool on ) {
    if ( on ) {
        player.PlaySound( default.ActivateSound, SLOT_None );
        player.UpdateAugmentationDisplay( info, true );

        Activate( player, info );
    }
    else {
        player.PlaySound( default.DeactivateSound, SLOT_None );
        player.UpdateAugmentationDisplay( info, false );

        Deactivate( player, info );
    }
}
static function Activate( VMPlayer player, VMAugmentationInfo info );
static function Deactivate( VMPlayer player, VMAugmentationInfo info );
static function Tick( VMPlayer player, VMAugmentationInfo info, float deltaTime );
static function float GetRate( VMAugmentationInfo info ) {
    if ( !IsPassive && info.Level < GetMaxLevel() ) {
        return default.Rates[info.Level];
    }
}

defaultproperties
{
     ActivateSound=Sound'DeusExSounds.Augmentation.AugActivate'
     DeactivateSound=Sound'DeusExSounds.Augmentation.AugDeactivate'
}
