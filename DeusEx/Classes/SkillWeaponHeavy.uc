class SkillWeaponHeavy extends VMSkill;

defaultproperties
{
     UpgradeName="Weapons: Demolition"
     Description="The use of explosive or heavy weaponry.|n|nAffects: GEP Gun, Flamethrower, Plasma Rifle.|n|nUNTRAINED: Agent can use heavy weapons, but with difficult movement. They can also throw grenades, attach them to surfaces as proximity devices, or disarm a previously armed one.|n|nTRAINED: Agent can move slightly easier with heavy weapons. Unlock GEP Gun's rocket lock-on.|n|nADVANCED: Agent can move swiftly with heavy weapons.|n|nMASTER: Agent is an expert in all forms of destruction.|n|n[GEP Gun]|nAccuracy: +25% / 50% / 50%|nReload Time: -25% / 50% / 90%|nLock-on Time: -0% / 50% / 50%|n|n[Flamethrower]|nReload Time: -50% / 75% / 75%|n|n[Plasma Rifle]|nAccuracy: +0% / 10% / 20%|nStability: +0% / 20% / 40%|nReload Time: -0% / 0% / 75%"
     Icon=Texture'DeusExUI.UserInterface.SkillIconWeaponHeavy'
     Costs=(1500,3000,4500)
     GlobalValues=((Name=HeavyWeaponMovementSpeedBonus,Values=(0,0.25,0.5)))
     CategoryValues=((Name=Accuracy,Values=((Name=WeaponGEPGun,Values=(0,0.25,0.5)),(Name=WeaponPlasmaRifle,Values=(0,0,0.1,0.2)))),(Name=Stability,Values=((Name=WeaponPlasmaRifle,Values=(0,0,0.2,0.4)))),(Name=ReloadTime,Values=((Name=WeaponGEPGun,Values=(0,-0.25,-0.5,-0.9)),(Name=WeaponFlamethrower,Values=(0,-0.5,-0.75)),(Name=WeaponPlasmaRifle,Values=(0,0,0,-0.75)))),(Name=Homing,Values=((Name=WeaponGEPGun,Values=(0,1)))),(Name=LockTime,Values=((Name=WeaponGEPGun,Values=(0,0,-0.5)))))
}
