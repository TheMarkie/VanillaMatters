//=============================================================================
// SkillWeaponHeavy.
//=============================================================================
class SkillWeaponHeavy extends VMSkill;

defaultproperties
{
     SkillName="Weapons: Demolition"
     Description="The use of explosive or heavy weaponry.|n|nAffects: GEP Gun, Flamethrower, LAW, Plasma Rifle, and grenades.|n|n[UNTRAINED]|nAn agent can use heavy weapons, but with difficult movement. They can also throw grenades, attach them to surfaces as proximity devices, or disarm a previously armed one.|n|n[TRAINED]|nAn agent can move slightly easier with heavy weapons.|n<GEP Gun>|nUnlock rocket guiding.|n+25% accuracy|n-25% reload time|n|n<Flamethrower>|n-50% reload time|n|n[ADVANCED]|nAn agent can move swiftly with heavy weapons.|n<GEP Gun>|n+50% accuracy|n-50% reload time|n-50% lock-on time|n|n<Flamethrower>|n-75% reload time|n|n<Plasma Rifle>|n+10% accuracy|n+20% stability|n|n[MASTER]|nAn agent is an expert in all forms of destruction.|n<GEP Gun>|n-90% reload time|n|n<Plasma Rifle>|n+20% accuracy|n+40% stability|n-75% reload time"
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconWeaponHeavy'
     Costs=(1500,3000,4500)
     SkillValues=((Name="HeavyWeaponMovementSpeedBonus",Values=(0,0.25,0.5)),(Name="WeaponGEPGunHoming",Values=(0,1)),(Name="WeaponGEPGunReloadTime",Values=(0,-0.25,-0.5,-0.9)),(Name="WeaponGEPGunAccuracy",Values=(0,0.25,0.5)),(Name="WeaponGEPGunLockTime",Values=(0,0,-0.5)),(Name="WeaponFlamethrowerReloadTime",Values=(0,-0.5,-0.75)),(Name="WeaponPlasmaRifleAccuracy",Values=(0,0,0.1,0.2)),(Name="WeaponPlasmaRifleStability",Values=(0,0,0.2,0.4)),(Name="WeaponPlasmaRifleReloadTime",Values=(0,0,0,-0.75)))
}
