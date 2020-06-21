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
        weapon.ModRecoilStrength += WeaponModifier;
    }
}

// ----------------------------------------------------------------------
// CanUpgradeWeapon()
// ----------------------------------------------------------------------

simulated function bool CanUpgradeWeapon(DeusExWeapon weapon)
{
    if (weapon != None)
        return (weapon.bCanHaveModRecoilStrength && !weapon.HasMaxRecoilMod());
    else
        return False;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     WeaponModifier=-0.100000
     ItemName="Weapon Modification (Recoil)"
     Icon=Texture'DeusExUI.Icons.BeltIconWeaponModRecoil'
     largeIcon=Texture'DeusExUI.Icons.LargeIconWeaponModRecoil'
     Description="A stock cushioned with polycellular shock absorbing material will significantly reduce perceived recoil.|n-10% recoil."
     beltDescription="MOD RECOL"
     Skin=Texture'DeusExItems.Skins.WeaponModTex5'
}
