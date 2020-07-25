class VMUpgrade extends Object
    abstract;

struct UpgradeValue {
    var() name Name;
    var() array<float> Values;
};

struct UpgradeCategory {
    var() name Name;
    var() array<UpgradeValue> Values;
};

//==============================================
// Description
//==============================================
var() localized string UpgradeName;
var() localized string Description;
var() Texture Icon;

// UpgradeValue array support
native(3200) static final function int UpgradeValueArrayCount( array<UpgradeValue> A );
static final preoperator int #( out array<UpgradeValue> A ) { return UpgradeValueArrayCount( A ); }

// UpgradeCategory array support
native(3200) static final function int UpgradeCategoryArrayCount( array<UpgradeCategory> A );
static final preoperator int #( out array<UpgradeCategory> A ) { return UpgradeCategoryArrayCount( A ); }

//==============================================
// General info
//==============================================
static function int GetMaxLevel() { return 0; }

defaultproperties
{
}
