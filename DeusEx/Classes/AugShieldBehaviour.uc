class AugShieldBehaviour extends VMAugmentationBehaviour;

var() float DamageResistance;
var() float EnergyThreshold;
var() array<float> EnergyMultiplier;

function Refresh( VMPlayer p, VMAugmentationInfo i, VMAugmentationManager m ) {
    super.Refresh( p, i, m );
    m.TakeDamageHandlers[-1] = self;
}

function bool TakeDamage( out int damage, name damageType, Pawn attacker, Vector hitLocation ) {
    local float energy, mult;
    local int reducedDamage;

    if ( !( damageType == 'Burned' || damageType == 'Flamed' ||
        damageType == 'Exploded' || damageType == 'Shocked' )
    ) {
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
     DamageResistance=0.6
     EnergyThreshold=60
     EnergyMultiplier=(1,2,3,4)
}
