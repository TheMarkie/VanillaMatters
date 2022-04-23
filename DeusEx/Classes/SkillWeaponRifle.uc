class SkillWeaponRifle extends VMSkill;

defaultproperties
{
     UpgradeName="Weapons: Specialist"
     Description="The use of specialist weaponry.|n|nAffects: Mini-Crossbow, Stealth Pistol, Sniper Rifle.|n|nUNTRAINED: Agent can use precision weapons.|n|nMASTER: Agent can take down a target a mile away with one shot.|n|n[Mini-Crossbow]|nDamage: +25% / 50% / 100%|nAccuracy: +15% / 25% / 25%|nReload Time: -50%|n|n[Stealth Pistol]|nDamage: +20% / 60% / 120%|nAccuracy: +15% / 25% / 25%|nStability: +20% / 40% / 40%|n|n[Sniper Rifle]|nDamage: +20% / 50% / 150%|nAccuracy: +10% / 15% / 25%"
     Icon=Texture'DeusExUI.UserInterface.SkillIconWeaponRifle'
     Costs=(1500,3000,4500)
     CategoryValues=((Name=Damage,Values=((Name=WeaponMiniCrossbow,Values=(0,0.25,0.5,1)),(Name=WeaponStealthPistol,Values=(0,0.2,0.6,1.2)),(Name=WeaponRifle,Values=(0,0.2,0.5,1.5)))),(Name=Accuracy,Values=((Name=WeaponMiniCrossbow,Values=(0,0.15,0.25)),(Name=WeaponStealthPistol,Values=(0,0.15,0.25)),(Name=WeaponRifle,Values=(0,0.1,0.15,0.25)))),(Name=ReloadTime,Values=((Name=WeaponMiniCrossbow,Values=(0,-0.5)))),(Name=Stability,Values=((Name=WeaponStealthPistol,Values=(0,0.2,0.4)))))
}
