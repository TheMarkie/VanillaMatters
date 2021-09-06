class SkillWeaponHeavy extends VMSkill;

defaultproperties
{
     UpgradeName="Weapons: Demolition"
     Description="The use of explosive or heavy weaponry.|n|nAffects: GEP Gun, Flamethrower, LAW, Plasma Rifle, and grenades.|n|n[UNTRAINED]|nAn agent can use heavy weapons, but with difficult movement. They can also throw grenades, attach them to surfaces as proximity devices, or disarm a previously armed one.|n|n[TRAINED]|nAn agent can move slightly easier with heavy weapons.|n<GEP Gun>|nUnlock rocket guiding.|n-25% reload time|n|n<Flamethrower>|n-50% reload time|n|n[ADVANCED]|nAn agent can move swiftly with heavy weapons.|n<GEP Gun>|n+25% accuracy|n-50% reload time|n-50% lock-on time|n|n<Flamethrower>|n-75% reload time|n|n<Plasma Rifle>|n+10% accuracy|n+20% stability|n|n[MASTER]|nAn agent is an expert in all forms of destruction.|n<GEP Gun>|n-90% reload time|n|n<Plasma Rifle>|n+20% accuracy|n+40% stability|n-75% reload time"
     Icon=Texture'DeusExUI.UserInterface.SkillIconWeaponHeavy'
     Costs=(1500,3000,4500)
     GlobalValues=((Name=HeavyWeaponMovementSpeedBonus,Values=(0,0.25,0.5)))
     CategoryValues=((Name=Accuracy,Values=((Name=WeaponGEPGun,Values=(0,0,0.25)),(Name=WeaponPlasmaRifle,Values=(0,0,0.1,0.2)))),(Name=Stability,Values=((Name=WeaponPlasmaRifle,Values=(0,0,0.2,0.4)))),(Name=ReloadTime,Values=((Name=WeaponGEPGun,Values=(0,-0.25,-0.5,-0.9)),(Name=WeaponFlamethrower,Values=(0,-0.5,-0.75)),(Name=WeaponPlasmaRifle,Values=(0,0,0,-0.75)))),(Name=Homing,Values=((Name=WeaponGEPGun,Values=(0,1)))),(Name=LockTime,Values=((Name=WeaponGEPGun,Values=(0,0,-0.5)))))
}
