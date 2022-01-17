class AugMedBehaviour extends VMAugmentationBehaviour;

var() int HealthThreshold;
var() int EnergyThreshold;
var() float LimbHealCooldown;
var() array<int> LimbRegenThresholds;
var() int LimbRegenAmount;

var array<byte> LimbHealOrder;
var float LimbHealTimer;
var float LimbRegenTimer;

function float Tick( float deltaTime ) {
    local int i, threshold, health;
    local byte partIndex;
    local bool healed;
    local DeusExPickup item;

    if ( !Info.IsActive ) {
        return 0;
    }

    if ( Player.HealthHead <= HealthThreshold || Player.HealthTorso <= HealthThreshold ) {
        item = DeusExPickup( Player.FindInventoryType( class'MedKit' ) );
        if ( item != none && item.NumCopies > 1 ) {
            item.Activate();
        }
    }

    if ( Player.Energy <= EnergyThreshold ) {
        item = DeusExPickup( Player.FindInventoryType( class'BioelectricCell' ) );
        if ( item != none && item.NumCopies > 1 ) {
            item.Activate();
        }
    }

    if ( LimbHealTimer > 0 ) {
        LimbHealTimer -= deltaTime;
    }
    if ( LimbRegenTimer > 0 ) {
        LimbRegenTimer -= deltaTime;
    }
    if ( LimbRegenTimer <= 0 ) {
        threshold = LimbRegenThresholds[Info.Level];
        for ( i = 0; i < 4; i++ ) {
            partIndex = LimbHealOrder[i];
            health = Player.GetBodyPartHealth( partIndex );

            if ( LimbHealTimer <= 0 && health <= 0 ) {
                Player.HealPartIndex( partIndex, HealthThreshold );
                Player.ClientMessage( Info.Definition.default.UpgradeName @ "has healed your" @ Player.BodyPartNamesLowercase[partIndex] );
                LimbHealTimer += LimbHealCooldown;
                healed = true;
                break;
            }

            if ( Info.Level > 0 && health < threshold ) {
                Player.HealPartIndex( partIndex, Min( LimbRegenAmount, threshold - health ) );
                healed = true;
                break;
            }
        }

        if ( healed ) {
            Player.GenerateTotalHealth();
            LimbRegenTimer += 1;
        }
    }

    return super.Tick( deltaTime );
}

defaultproperties
{
     HealthThreshold=30
     EnergyThreshold=50
     LimbHealCooldown=10.000000
     LimbRegenThresholds=(40,40,60,80)
     LimbRegenAmount=10
     LimbHealOrder=(4,5,2,3)
}
