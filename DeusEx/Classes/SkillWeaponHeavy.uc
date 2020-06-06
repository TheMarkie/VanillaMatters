//=============================================================================
// SkillWeaponHeavy.
//=============================================================================
class SkillWeaponHeavy extends VMSkill;

defaultproperties
{
     SkillName="Weapons: Destructive"
     Description="The use of explosive or heavy weaponry.|nAffects: GEP Gun, Flamethrower, LAW, Plasma Rifle, and grenades.|n|nUNTRAINED: An agent can use heavy weapons, but with difficult movement. They can also throw grenades, attach them to surfaces as proximity devices, or disarm a previously armed one.|n|nTRAINED: An agent can move slightly easier with heavy weapons.|nUnlock GEP Gun homing functionality.|n-25% GEP Gun reload time.|n-50% Flamethrower reload time.|n|nADVANCED: An agent can move swiftly with heavy weapons.|n+25% GEP Gun accuracy.|n-50% GEP Gun reload time.|n-50% GEP Gun lock-on time.|n-75% Flamethrower reload time.|n+10% Plasma Rifle accuracy.|n+25% Plasma Rifle stability.|n|nMASTER: An agent is an expert in all forms of destruction.|n+20% Plasma Rifle accuracy.|n+50% Plasma Rifle stability.|n-50% Plasma Rifle reload time."
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconWeaponHeavy'
     Costs=(1575,3150,5250)
     SkillValues=((Name="HeavyWeaponMovementSpeedBonus",Values=(0,0.25,0.5)),(Name="WeaponGEPGunHoming",Values=(0,1)),(Name="WeaponGEPGunReloadTime",Values=(0,-0.25,-0.5)),(Name="WeaponGEPGunAccuracy",Values=(0,0,0.25)),(Name="WeaponGEPGunLockTime",Values=(0,0,-0.5)),(Name="WeaponFlamethrowerReloadTime",Values=(0,-0.5,-0.75)),(Name="WeaponPlasmaRifleAccuracy",Values=(0,0,0.1,0.2)),(Name="WeaponPlasmaRifleStability",Values=(0,0,0.25,0.5)),(Name="WeaponPlasmaRifleReloadTime",Values=(0,0,0,-0.5)))
}
