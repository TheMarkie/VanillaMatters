class AugShieldBehaviour extends VMAugmentationBehaviour;

var() array<name> DamageTypes;
var() float DamageResistance;
var() float EnergyThreshold;
var() array<float> EnergyMultiplier;

function Refresh( VMPlayer p, VMAugmentationInfo i, VMAugmentationManager m ) {
    super.Refresh( p, i, m );
    m.TakeDamageHandlers[-1] = self;
}

function bool TakeDamage( out int damage, name damageType, Pawn attacker, Vector hitLocation ) {
    local int i, count;
    local bool applies;
    local float energy, mult;
    local int reducedDamage;

    count = #DamageTypes;
    for ( i = 0; i < count; i++ ) {
        if ( damageType == DamageTypes[i] ) {
            applies = true;
            break;
        }
    }
    if ( !applies ) {
        return false;
    }

    energy = Player.Energy - EnergyThreshold;
    if ( energy <= 0 ) {
        return false;
    }
    mult = EnergyMultiplier[Info.Level];
    energy *= mult;

    reducedDamage = damage * DamageResistance;
    reducedDamage = Min( reducedDamage, energy );
    Player.Energy = FMax( Player.Energy - ( reducedDamage / mult ), EnergyThreshold );
    damage -= reducedDamage;

    return false;
}

defaultproperties
{
     DamageTypes=(Burned,Flamed,Exploded,Shocked)
     DamageResistance=0.6
     EnergyThreshold=60
     EnergyMultiplier=(1,2,3,4)
}
