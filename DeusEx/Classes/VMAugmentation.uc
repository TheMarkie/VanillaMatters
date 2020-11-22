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
var() array<UpgradeValue> GlobalValues;
var() array<float> Rates; // Energy cost per minute.

var EAugmentationLocation InstallLocation;
var bool HasBehaviour;

//==============================================
// General info
//==============================================
static function int GetMaxLevel() {
    return Max( #default.Rates - 1, 0 );
}

//==============================================
// Values
//==============================================
static function UpdateValues( TableFloat table, int oldLevel, int newLevel ) {
    local int i, count, valueCount;
    local UpgradeValue augValue;
    local float value;

    if ( table == none || oldLevel == newLevel ) {
        return;
    }

    count = #default.GlobalValues;
    for ( i = 0; i < count; i++ ) {
        augValue = default.GlobalValues[i];
        valueCount = #augValue.Values;

        table.TryGetValue( augValue.Name, value );
        if ( oldLevel >= 0 ) {
            value -= augValue.Values[Min( oldLevel, valueCount - 1 )];
        }
        if ( newLevel >= 0 ) {
            value += augValue.Values[Min( newLevel, valueCount - 1 )];
        }

        table.Set( augValue.Name, value );
    }
}

defaultproperties
{
     ActivateSound=Sound'DeusExSounds.Augmentation.AugActivate'
     DeactivateSound=Sound'DeusExSounds.Augmentation.AugDeactivate'
}
