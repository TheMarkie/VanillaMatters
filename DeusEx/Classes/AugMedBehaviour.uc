class AugMedBehaviour extends VMAugmentationBehaviour;

var() int HealthThreshold;
var() int EnergyThreshold;
var() float LimbHealCooldown;
var() float LimbHealCost;
var() float LimbRegenInterval;
var() int LimbRegenThreshold;
var() int LimbRegenAmount;
var() int LimbRegenCost;

var array<byte> LimbHealOrder;
var float LimbHealTimer;

function Refresh( VMPlayer p, VMAugmentationInfo i, VMAugmentationManager m ) {
    super.Refresh( p, i, m );
    m.TickHandlers[-1] = self;
}

function Tick( float deltaTime ) {
    local int i;
    local byte partIndex;
    local bool healed;
    local DeusExPickup item;

    if ( Player.HealthHead <= HealthThreshold || Player.HealthTorso <= HealthThreshold ) {
        item = DeusExPickup( Player.FindInventoryType( class'MedKit' ) );
        if ( item != none && item.NumCopies > 1 ) {
            item.Activate();
            return;
        }
    }

    if ( Player.Energy <= EnergyThreshold ) {
        item = DeusExPickup( Player.FindInventoryType( class'BioelectricCell' ) );
        if ( item != none && item.NumCopies > 1 ) {
            item.Activate();
            return;
        }
    }

    if ( LimbHealTimer > 0 ) {
        LimbHealTimer -= deltaTime;
    }
    if ( LimbHealTimer <= 0 ) {
        switch ( Info.Level ) {
            case 1:
                for ( i = 0; i < 4; i++ ) {
                    partIndex = LimbHealOrder[i];
                    if ( Player.GetBodyPartHealth( partIndex ) <= 0 ) {
                        Player.HealPartIndex( partIndex, HealthThreshold );
                        Player.DrainEnergy( LimbHealCost );
                        Player.ClientMessage( Info.Definition.default.UpgradeName @ "has healed your" @ Player.BodyPartNamesLowercase[partIndex] );
                        LimbHealTimer += LimbHealCooldown;
                        healed = true;
                        break;
                    }
                }
                break;
            case 2:
                for ( i = 0; i < 4; i++ ) {
                    partIndex = LimbHealOrder[i];
                    if ( Player.GetBodyPartHealth( partIndex ) < LimbRegenThreshold ) {
                        Player.HealPartIndex( partIndex, LimbRegenAmount );
                        Player.DrainEnergy( LimbRegenCost );
                        LimbHealTimer += LimbRegenInterval;
                        healed = true;
                        break;
                    }
                }
                break;
            case 3:
                for ( i = 0; i < 4; i++ ) {
                    partIndex = LimbHealOrder[i];
                    if ( Player.GetBodyPartHealth( partIndex ) < LimbRegenThreshold ) {
                        Player.HealPartIndex( partIndex, LimbRegenAmount );
                        Player.DrainEnergy( LimbRegenCost );
                        LimbHealTimer += LimbRegenInterval;
                        healed = true;
                    }
                }
                break;
        }
        if ( healed ) {
            Player.GenerateTotalHealth();
        }
    }
}

defaultproperties
{
     HealthThreshold=30
     EnergyThreshold=50
     LimbHealCost=3.000000
     LimbHealCooldown=5.000000
     LimbRegenInterval=1.000000
     LimbRegenThreshold=40
     LimbRegenAmount=10
     LimbRegenCost=1.000000
     LimbHealOrder=(4,5,2,3)
}
