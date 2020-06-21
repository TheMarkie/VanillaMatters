//=============================================================================
// WeaponModRecoil
//
// Decreases recoil amount
//=============================================================================
class WeaponModRecoil extends WeaponMod;

// ----------------------------------------------------------------------
// ApplyMod()
// ----------------------------------------------------------------------

function ApplyMod(DeusExWeapon weapon)
{
    if (weapon != None)
    {
        weapon.ModStability += WeaponModifier;
    }
}

// ----------------------------------------------------------------------
// CanUpgradeWeapon()
// ----------------------------------------------------------------------

simulated function bool CanUpgradeWeapon(DeusExWeapon weapon)
{
    if (weapon != None)
        return (weapon.bCanHaveModStability && !weapon.HasMaxStabilityMod());
    else
        return False;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     WeaponModifier=0.080000
     ItemName="Weapon Modification (Stability)"
     Icon=Texture'DeusExUI.Icons.BeltIconWeaponModRecoil'
     largeIcon=Texture'DeusExUI.Icons.LargeIconWeaponModRecoil'
     Description="A stock cushioned with polycellular shock absorbing material that can increase perceived stability.|n+8% stability."
     beltDescription="MOD RECOL"
     Skin=Texture'DeusExItems.Skins.WeaponModTex5'
}
