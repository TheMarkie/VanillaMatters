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
var name BehaviourClassName;

//==============================================
// General info
//==============================================
static function int GetMaxLevel() {
    return Max( #default.Rates - 1, 0 );
}

//==============================================
// Functionality
//==============================================
static function Activate( VMPlayer player, int level );
static function Deactivate( VMPlayer player, int level );

defaultproperties
{
     ActivateSound=Sound'DeusExSounds.Augmentation.AugActivate'
     DeactivateSound=Sound'DeusExSounds.Augmentation.AugDeactivate'
}
