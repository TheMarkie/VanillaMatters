class SkillWeaponPistol extends VMSkill;

defaultproperties
{
     UpgradeName="Weapons: Ballistic"
     Description="The use of standard weaponry.|n|nAffects: Pistol, Assault Rifle, Sawed-Off Shotgun, Assault Shotgun.|n|n[UNTRAINED]|nAn agent can use standard guns.|n|n[TRAINED]|n<Pistol>|n+15% accuracy|n+20% stability|n|n<Sawed-Off Shotgun>|n+10% accuracy|n+20% stability|n-50% reload time|n|n<Assault Rifle>|n+10% accuracy|n|n[ADVANCED]|n<Pistol>|n+20% accuracy|n+40% stability|n|n<Assault Rifle>|n+15% accuracy|n+40% stability|n|n<Sawed-Off Shotgun>|n+20% accuracy|n+40% stability|n|n<Assault Shotgun>|n+15% accuracy|n+20% stability|n-25% reload time|n|n[MASTER]|nAn agent is a street sweeper.|n<Assault Rifle>|n+25% accuracy|n|n<Assault Shotgun>|n+20% accuracy|n+40% stability|n-50% reload time"
     Icon=Texture'DeusExUI.UserInterface.SkillIconWeaponPistol'
     Costs=(1500,3000,4500)
     CategoryValues=((Name=Accuracy,Values=((Name=WeaponPistol,Values=(0,0.15,0.2)),(Name=WeaponAssaultGun,Values=(0,0.1,0.15,0.2)),(Name=WeaponSawedOffShotgun,Values=(0,0.1,0.2)),(Name=WeaponAssaultShotgun,Values=(0,0,0.15,0.2)))),(Name=Stability,Values=((Name=WeaponPistol,Values=(0,0.2,0.4)),(Name=WeaponAssaultGun,Values=(0,0,0.4)),(Name=WeaponSawedOffShotgun,Values=(0,0.2,0.4)),(Name=WeaponAssaultShotgun,Values=(0,0,0.2,0.4)))),(Name=ReloadTime,Values=((Name=WeaponSawedOffShotgun,Values=(0,-0.5)),(Name=WeaponAssaultShotgun,Values=(0,0,-0.25,-0.5)))))
}
