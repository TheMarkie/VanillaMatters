//=============================================================================
// SkillWeaponRifle.
//=============================================================================
class SkillWeaponRifle extends VMSkill;

defaultproperties
{
     SkillName="Weapons: Specialist"
     Description="The use of specialist weapons.|n|nAffects: Mini-Crossbow, Stealth Pistol, Sniper Rifle.|n|n[UNTRAINED]|nAn agent can use precision weapons.|n|n[TRAINED]|n<Mini-Crossbow>|n+25% damage|n+15% accuracy|n-50% reload time|n|n<Stealth Pistol>|n+20% damage|n+10% accuracy|n+20% stability|n|n<Sniper Rifle>|n+20% damage|n+10% accuracy|n|n[ADVANCED]|n<Mini-Crossbow>|n+50% damage|n+25% accuracy|n|n<Stealth Pistol>|n+40% damage|n+15% accuracy|n+40% stability|n|n<Sniper Rifle>|n+50% damage|n+15% accuracy|n|n[MASTER]|nAn agent can take down a target a mile away with one shot.|n<Stealth Pistol>|n+20% accuracy|n|n<Sniper Rifle>|n+100% damage|n+25% accuracy"
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconWeaponRifle'
     Costs=(1500,3000,4500)
     SkillValues=((Name="WeaponMiniCrossbowDamage",Values=(0,0.25,0.5)),(Name="WeaponMiniCrossbowAccuracy",Values=(0,0.15,0.25)),(Name="WeaponMiniCrossbowReloadTime",Values=(0,-0.5)),(Name="WeaponStealthPistolDamage",Values=(0,0.2,0.4)),(Name="WeaponStealthPistolAccuracy",Values=(0,0.1,0.15,0.2)),(Name="WeaponStealthPistolStability",Values=(0,0.2,0.4)),(Name="WeaponRifleDamage",Values=(0,0.2,0.5,1)),(Name="WeaponRifleAccuracy",Values=(0,0.1,0.15,0.25)))
}
