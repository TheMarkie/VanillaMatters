//=============================================================================
// WeaponModAccuracy
//
// Increases Weapon Accuracy
//=============================================================================
class WeaponModAccuracy extends WeaponMod;

// ----------------------------------------------------------------------
// ApplyMod()
// ----------------------------------------------------------------------

function ApplyMod(DeusExWeapon weapon)
{
    if (weapon != None)
    {
        // Vanilla Matters: Handle mod bonus inside the weapon.

        weapon.ModBaseAccuracy += WeaponModifier;
    }
}

// ----------------------------------------------------------------------
// CanUpgradeWeapon()
// ----------------------------------------------------------------------

simulated function bool CanUpgradeWeapon(DeusExWeapon weapon)
{
    if (weapon != None)
        return (weapon.bCanHaveModBaseAccuracy && !weapon.HasMaxAccuracyMod());
    else
        return False;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     WeaponModifier=0.025000
     ItemName="Weapon Modification (Accuracy)"
     Icon=Texture'DeusExUI.Icons.BeltIconWeaponModAccuracy'
     largeIcon=Texture'DeusExUI.Icons.LargeIconWeaponModAccuracy'
     Description="When clamped to the frame of most projectile weapons, a harmonic balancer will dampen the vertical motion produced by firing a projectile, resulting in increased accuracy.|n+2.5% accuracy.|n|n<UNATCO OPS FILE NOTE SC108-BLUE> Almost any weapon that has a significant amount of vibration can be modified with a balancer; I've even seen it work with the mini-crossbow and a prototype plasma gun. -- Sam Carter <END NOTE>"
     beltDescription="MOD ACCRY"
     Skin=Texture'DeusExItems.Skins.WeaponModTex2'
}
