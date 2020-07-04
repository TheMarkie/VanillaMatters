//=============================================================================
// WaltonSimons.
//=============================================================================
class WaltonSimons extends HumanMilitary;

//
// Damage type table for Walton Simons:
//
// Shot         - 100%
// Sabot        - 100%
// Exploded     - 100%
// TearGas      - 10%
// PoisonGas    - 10%
// Poison       - 10%
// PoisonEffect - 10%
// HalonGas     - 10%
// Radiation    - 10%
// Shocked      - 10%
// Stunned      - 0%
// KnockedOut   - 0%
// Flamed       - 0%
// Burned       - 0%
// NanoVirus    - 0%
// EMP          - 0%
//

function float ShieldDamage(name damageType)
{
    // handle special damage types
    // Vanilla Matters: Make him vulnerable to Flamed and Burned if he's EMP'd.
    if ( ( ( damageType == 'Flamed' || damageType == 'Burned' ) && CloakEMPTimer <= 0 ) || damageType == 'Stunned' || damageType == 'KnockedOut' ) {
        return 0.0;
    }
    else if ((damageType == 'TearGas') || (damageType == 'PoisonGas') || (damageType == 'HalonGas') ||
            (damageType == 'Radiation') || (damageType == 'Shocked') || (damageType == 'Poison') ||
            (damageType == 'PoisonEffect'))
        return 0.1;
    else
        return Super.ShieldDamage(damageType);
}

function GotoDisabledState(name damageType, EHitLocation hitPos)
{
    if (!bCollideActors && !bBlockActors && !bBlockPlayers)
        return;
    if (CanShowPain())
        TakeHit(hitPos);
    else
        GotoNextState();
}

defaultproperties
{
     BaseAccuracy=26.000000
     CarcassType=Class'DeusEx.WaltonSimonsCarcass'
     WalkingSpeed=0.333333
     bImportant=True
     bInvincible=True
     CloseCombatMult=0.500000
     BaseAssHeight=-23.000000
     BurnPeriod=0.000000
     bHasCloak=True
     walkAnimMult=1.400000
     GroundSpeed=240.000000
     HealthHead=750
     HealthTorso=750
     HealthLegLeft=400
     HealthLegRight=400
     HealthArmLeft=400
     HealthArmRight=400
     Mesh=LodMesh'DeusExCharacters.GM_Trench'
     MultiSkins(0)=Texture'DeusExCharacters.Skins.WaltonSimonsTex0'
     MultiSkins(1)=Texture'DeusExCharacters.Skins.WaltonSimonsTex2'
     MultiSkins(2)=Texture'DeusExCharacters.Skins.PantsTex5'
     MultiSkins(3)=Texture'DeusExCharacters.Skins.WaltonSimonsTex0'
     MultiSkins(4)=Texture'DeusExCharacters.Skins.WaltonSimonsTex1'
     MultiSkins(5)=Texture'DeusExCharacters.Skins.WaltonSimonsTex2'
     MultiSkins(6)=Texture'DeusExItems.Skins.GrayMaskTex'
     MultiSkins(7)=Texture'DeusExItems.Skins.BlackMaskTex'
     CollisionRadius=20.000000
     CollisionHeight=47.500000
     BindName="WaltonSimons"
     FamiliarName="Walton Simons"
     UnfamiliarName="Walton Simons"
}
