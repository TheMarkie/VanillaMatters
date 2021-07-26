class VMSkill extends Object
    abstract;

struct SkillValue {
    var() string Name;
    var() array<float> Values;
};

//==============================================
// Description
//==============================================
var() localized string SkillName;
var() localized string Description;
var() Texture SkillIcon;

//==============================================
// Properties
//==============================================
var() array<int> Costs;
var() array<SkillValue> SkillValues;

native(2300) static final function int SkillValueArrayCount( array<SkillValue> A );
static final preoperator int #( out array<SkillValue> A ) { return SkillValueArrayCount( A ); }

//==============================================
// General info
//==============================================
static function int GetMaxLevel() {
    return #default.Costs;
}

//==============================================
// Skill values
//==============================================
static function UpdateValues( TableFloat table, int oldLevel, int newLevel ) {
    local int i, count, valueCount;
    local SkillValue skillValue;
    local float value;

    if ( table == none || oldLevel == newLevel ) {
        return;
    }

    count = #default.SkillValues;
    for ( i = 0; i < count; i++ ) {
        skillValue = default.SkillValues[i];
        valueCount = #skillValue.Values;

        table.TryGetValue( skillValue.Name, value );
        if ( oldLevel >= 0 ) {
            value -= skillValue.Values[Min( oldLevel, valueCount - 1 )];
        }
        if ( newLevel >= 0 ) {
            value += skillValue.Values[Min( newLevel, valueCount - 1 )];
        }

        table.Set( skillValue.Name, value );
    }
}

defaultproperties
{
}
