class VMAugmentation extends VMUpgrade
    abstract;

enum EAugmentationLocation
{
    AugmentationLocationDefault,
    AugmentationLocationCranial,
    AugmentationLocationEye,
    AugmentationLocationTorso,
    AugmentationLocationArm,
    AugmentationLocationLeg,
    AugmentationLocationSubdermal
};

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
var() array<float> Rates; // Energy cost per minute.

var EAugmentationLocation InstallLocation;

//==============================================
// General info
//==============================================
static function int GetMaxLevel() {
    return Max( #default.Rates - 1, 0 );
}

defaultproperties
{
     ActivateSound=Sound'DeusExSounds.Augmentation.AugActivate'
     DeactivateSound=Sound'DeusExSounds.Augmentation.AugDeactivate'
}
