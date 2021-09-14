class SkillWeaponRifle extends VMSkill;

defaultproperties
{
     UpgradeName="Weapons: Specialist"
     Description="The use of specialist weaponry.|n|nAffects: Mini-Crossbow, Stealth Pistol, Sniper Rifle.|n|n[UNTRAINED]|nAn agent can use precision weapons.|n|n[TRAINED]|n<Mini-Crossbow>|n+25% damage|n+15% accuracy|n-50% reload time|n|n<Stealth Pistol>|n+20% damage|n+15% accuracy|n+20% stability|n|n<Sniper Rifle>|n+20% damage|n+10% accuracy|n|n[ADVANCED]|n<Mini-Crossbow>|n+50% damage|n+25% accuracy|n|n<Stealth Pistol>|n+60% damage|n+25% accuracy|n+40% stability|n|n<Sniper Rifle>|n+50% damage|n+15% accuracy|n|n[MASTER]|nAn agent can take down a target a mile away with one shot.|n<Stealth Pistol>|n+100% damage|n|n<Sniper Rifle>|n+100% damage|n+25% accuracy"
     Icon=Texture'DeusExUI.UserInterface.SkillIconWeaponRifle'
     Costs=(1500,3000,4500)
     CategoryValues=((Name=Damage,Values=((Name=WeaponMiniCrossbow,Values=(0,0.25,0.5)),(Name=WeaponStealthPistol,Values=(0,0.2,0.6,1)),(Name=WeaponRifle,Values=(0,0.2,0.5,1)))),(Name=Accuracy,Values=((Name=WeaponMiniCrossbow,Values=(0,0.15,0.25)),(Name=WeaponStealthPistol,Values=(0,0.15,0.25)),(Name=WeaponRifle,Values=(0,0.1,0.15,0.25)))),(Name=ReloadTime,Values=((Name=WeaponMiniCrossbow,Values=(0,-0.5)))),(Name=Stability,Values=((Name=WeaponStealthPistol,Values=(0,0.2,0.4)))))
}
