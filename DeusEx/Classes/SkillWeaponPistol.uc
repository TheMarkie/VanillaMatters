class SkillWeaponPistol extends VMSkill;

defaultproperties
{
     UpgradeName="Weapons: Standard"
     Description="The use of standard weaponry.|n|nAffects: Pistol, Assault Rifle, Sawed-Off Shotgun, Assault Shotgun.|n|nUNTRAINED: Agent can use standard guns.|n|nMASTER: Agent is a street sweeper.|n|n[Pistol]|nDamage: +0% / 25% / 50%|nAccuracy: +15% / 20% / 20%|nStability: +20% / 40% / 40%|n|n[Sawed-Off Shotgun]|nAccuracy: +10% / 20% / 20%|nStability: +20% / 40% / 40%|nReload Time: -50%|n|n[Assault Rifle]|nDamage: +0% / 50% / 100%|nAccuracy: +10% / 15% / 25%|nStability: +0% / 40% / 40%|n|n[Assault Shotgun]|nAccuracy: +0% / 15% / 20%|nStability: +0% / 20% / 40%|nReload Time: -0% / 25% / 50%"
     Icon=Texture'DeusExUI.UserInterface.SkillIconWeaponPistol'
     Costs=(1500,3000,4500)
     CategoryValues=((Name=Damage,Values=((Name=WeaponPistol,Values=(0,0,0.25,0.5)),(Name=WeaponAssaultGun,Values=(0,0,0.5,1)))),(Name=Accuracy,Values=((Name=WeaponPistol,Values=(0,0.15,0.2)),(Name=WeaponAssaultGun,Values=(0,0.1,0.15,0.2)),(Name=WeaponSawedOffShotgun,Values=(0,0.1,0.2)),(Name=WeaponAssaultShotgun,Values=(0,0,0.15,0.2)))),(Name=Stability,Values=((Name=WeaponPistol,Values=(0,0.2,0.4)),(Name=WeaponAssaultGun,Values=(0,0,0.4)),(Name=WeaponSawedOffShotgun,Values=(0,0.2,0.4)),(Name=WeaponAssaultShotgun,Values=(0,0,0.2,0.4)))),(Name=ReloadTime,Values=((Name=WeaponSawedOffShotgun,Values=(0,-0.5)),(Name=WeaponAssaultShotgun,Values=(0,0,-0.25,-0.5)))))
}
