//=============================================================================
// SkillWeaponHeavy.
//=============================================================================
class SkillWeaponHeavy extends VMSkill;

defaultproperties
{
     SkillName="Weapons: Destructive"
     Description="The use of explosive or heavy weaponry.|n|nAffects: GEP Gun, Flamethrower, LAW, Plasma Rifle, and grenades.|n|n[UNTRAINED]|nAn agent can use heavy weapons, but with difficult movement. They can also throw grenades, attach them to surfaces as proximity devices, or disarm a previously armed one.|n|n[TRAINED]|nAn agent can move slightly easier with heavy weapons.|n<GEP Gun>|nUnlock homing functionality.|n-25% reload time|n<Flamethrower>|n-50% reload time|n|n[ADVANCED]|nAn agent can move swiftly with heavy weapons.|n<GEP Gun>|n+25% accuracy|n-50% reload time|n-50% lock-on time|n<Flamethrower>|n-75% reload time|n<Plasma Rifle>|n+10% accuracy|n+25% stability|n|n[MASTER]|nAn agent is an expert in all forms of destruction.|n<Plasma Rifle>|n+20% accuracy|n+50% stability|n-50% reload time"
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconWeaponHeavy'
     Costs=(1575,3150,5250)
     SkillValues=((Name="HeavyWeaponMovementSpeedBonus",Values=(0,0.25,0.5)),(Name="WeaponGEPGunHoming",Values=(0,1)),(Name="WeaponGEPGunReloadTime",Values=(0,-0.25,-0.5)),(Name="WeaponGEPGunAccuracy",Values=(0,0,0.25)),(Name="WeaponGEPGunLockTime",Values=(0,0,-0.5)),(Name="WeaponFlamethrowerReloadTime",Values=(0,-0.5,-0.75)),(Name="WeaponPlasmaRifleAccuracy",Values=(0,0,0.1,0.2)),(Name="WeaponPlasmaRifleStability",Values=(0,0,0.25,0.5)),(Name="WeaponPlasmaRifleReloadTime",Values=(0,0,0,-0.5)))
}
