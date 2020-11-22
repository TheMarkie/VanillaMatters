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
static function UpdateValues( TableFloat table, int level, bool active ) {
    local int i, count, valueCount;
    local UpgradeValue augValue;
    local float value;

    if ( table == none ) {
        return;
    }

    count = #default.GlobalValues;
    for ( i = 0; i < count; i++ ) {
        augValue = default.GlobalValues[i];
        valueCount = #augValue.Values;

        table.TryGetValue( augValue.Name, value );
        if ( active ) {
            value += augValue.Values[Min( level, valueCount - 1 )];
        }
        else {
            value -= augValue.Values[Min( level, valueCount - 1 )];
        }

        table.Set( augValue.Name, value );
    }
}

defaultproperties
{
     ActivateSound=Sound'DeusExSounds.Augmentation.AugActivate'
     DeactivateSound=Sound'DeusExSounds.Augmentation.AugDeactivate'
}
