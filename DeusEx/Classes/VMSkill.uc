class VMSkill extends Object
    abstract;

struct SkillValue {
    var() string Name;
    var() array<float> Values;
};

//==============================================
// Description
//==============================================
var() localized transient string SkillName;
var() localized transient string Description;
var() transient Texture SkillIcon;

//==============================================
// Properties
//==============================================
var() array<int> Costs;
var() array<SkillValue> SkillValues;

var travel int Level;
var travel VMSkill Next;

native(3200) static final function int SkillValueArrayCount( array<SkillValue> A );
static final preoperator int #( out array<SkillValue> A ) { return SkillValueArrayCount( A ); }

//==============================================
// General info
//==============================================
function int GetMaxLevel() {
    return #default.Costs;
}
function int GetNextLevelCost() {
    return default.Costs[Level];
}
function bool CanUpgrade( int amount ) {
    if ( Level >= #default.Costs || amount < default.Costs[Level] ) {
        return false;
    }
    else {
        return true;
    }
}

//==============================================
// Management
//==============================================
function bool IncreaseLevel( TableFloat table ) {
    if ( Level < GetMaxLevel() ) {
        UpdateValues( table, Level, Level + 1 );

        Level += 1;

        return true;
    }

    return false;
}
function bool DecreaseLevel( TableFloat table ) {
    if ( Level > 0 ) {
        UpdateValues( table, Level, Level - 1 );

        Level -= 1;

        return true;
    }

    return false;
}

//==============================================
// Skill values
//==============================================
function RefreshValues( TableFloat table ) {
    local int i, count;
    local SkillValue skillValue;
    local float value;

    count = #default.SkillValues;
    Log( "Skill value count:" @ count );
    for ( i = 0; i < count; i++ ) {
        skillValue = default.SkillValues[i];

        table.TryGetValue( skillValue.Name, value );
        value += skillValue.Values[Level];
        Log( "Adding value:" @ skillValue.Name @ value );
        table.Set( skillValue.Name, value );
    }
}

function UpdateValues( TableFloat table, int oldLevel, int newLevel ) {
    local int i, count, valueCount;
    local SkillValue skillValue;
    local float value;

    if ( oldLevel == newLevel ) {
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
