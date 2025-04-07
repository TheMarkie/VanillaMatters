class AugMedBehaviour extends VMAugmentationBehaviour;

var() int HealthThreshold;
var() int CoreHealAmount;
var() float CoreHealCooldown;
var travel float CoreHealTimer;

var() int LimbHealAmount;
var() float LimbHealCooldown;
var() array<int> LimbRegenThresholds;
var() int LimbRegenAmount;
var travel float LimbHealTimer;
var travel float LimbRegenTimer;

var array<byte> LimbHealOrder;

function Refresh( VMPlayer p, VMAugmentationInfo i, VMAugmentationManager m ) {
    super.Refresh( p, i, m );
    m.OnDamageTakenHandlers[-1] = self;
}

function float Tick( float deltaTime ) {
    local int i, threshold, health, minHealth;
    local byte partIndex;
    local bool healed;
    local DeusExPickup item;

    if ( !Info.IsActive ) {
        return 0;
    }

    if ( Player.HealthHead <= HealthThreshold || Player.HealthTorso <= HealthThreshold ) {
        item = DeusExPickup( Player.FindInventoryType( class'MedKit' ) );
        if ( item != none && item.NumCopies > 0 ) {
            item.Activate();
        }
    }

    if ( CoreHealTimer > 0 ) {
        CoreHealTimer -= deltaTime;
        if ( CoreHealTimer <= 0 ) {
            Player.UpdateAugmentationDisplay( Info, false );
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
        minHealth = threshold;
        partIndex = -1;
        for ( i = 0; i < 4; i++ ) {
            health = Player.GetBodyPartHealth( LimbHealOrder[i] );
            if ( health < minHealth ) {
                minHealth = health;
                partIndex = LimbHealOrder[i];
            }
        }

        if ( partIndex >= 0 ) {
            if ( Info.Level > 0 && LimbHealTimer <= 0 && minHealth <= 0 ) {
                Player.HealPartIndex( partIndex, LimbHealAmount );
                Player.ClientMessage( Info.Definition.default.UpgradeName @ "has healed your" @ Player.BodyPartNamesLowercase[partIndex] );
                LimbHealTimer += LimbHealCooldown;
                healed = true;
            }
            else {
                Player.HealPartIndex( partIndex, Min( LimbRegenAmount, threshold - health ) );
                LimbRegenTimer += 1;
                healed = true;
            }
        }
    }

    if ( healed ) {
        Player.GenerateTotalHealth();
    }

    return super.Tick( deltaTime );
}

function OnDamageTaken( int damage, name damageType, Pawn attacker, Vector hitLocation ) {
    local int healAmount;
    local bool healed;
    
    if ( Info.Level < 2 || CoreHealTimer > 0 ) {
        return;
    }

    if ( Player.HealthHead <= 0 || Player.HealthTorso <= 0 ) {
        if ( Info.Level < 3 ) {
            healAmount = CoreHealAmount;
        }
        else {
            healAmount = 100;
        }

        Player.HealthHead = Max( Player.HealthHead, healAmount );
        Player.HealthTorso = Max( Player.HealthTorso, healAmount );;
        healed = true;
    }

    if ( healed ) {
        CoreHealTimer += CoreHealCooldown;
        Player.ClientMessage( Info.Definition.default.UpgradeName @ "has saved you from death!" );
        Player.ClientFlash( 0.5, vect( 0, 0, 500 ) );
        Player.UpdateAugmentationDisplay( Info, true );
    }
}

function float GetCooldown() { return CoreHealTimer; }

defaultproperties
{
     HealthThreshold=30
     CoreHealAmount=40
     CoreHealCooldown=30.000000
     LimbHealAmount=30
     LimbHealCooldown=10.000000
     LimbRegenThresholds=(20,40,60,80)
     LimbRegenAmount=10
     LimbHealOrder=(4,5,2,3)
}
