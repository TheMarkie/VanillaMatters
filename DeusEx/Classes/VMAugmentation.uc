class VMAugmentation extends VMUpgrade
    abstract;

enum EAugmentationLocation {
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
var EAugmentationLocation InstallLocation;
var() bool IsPassive;
var() array<float> Rates; // Energy cost per minute.

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
static function bool Activate( VMPlayer player, int level ) { return true; }
static function bool Deactivate( VMPlayer player, int level ) { return true; }

defaultproperties
{
     Rates=(0)
}
