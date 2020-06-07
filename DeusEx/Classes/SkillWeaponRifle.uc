//=============================================================================
// SkillWeaponRifle.
//=============================================================================
class SkillWeaponRifle extends VMSkill;

defaultproperties
{
     SkillName="Weapons: Precision"
     Description="The use of sharpshooting weapons.|n|nAffects: Mini-Crossbow, Stealth Pistol, Sniper Rifle.|n|nUNTRAINED: An agent can use precision weapons.|n|nTRAINED:|nMini-Crossbow:|n+20% damage|n+15% accuracy|n-50% reload time|nStealth Pistol:|n+20% damage|n+15% accuracy|n+30% stability|nSniper Rifle:|n+20% damage|n+5% accuracy|n|nADVANCED:|nMini-Crossbow:|n+50% damage|n+25% accuracy|nStealth Pistol:|n+40% damage|n+20% accuracy|n+60% stability|nSniper Rifle:|n+50% damage|n+15% accuracy|n|nMASTER: An agent can take down a target a mile away with one shot.|nStealth Pistol:|n+25% accuracy|nSniper Rifle:|n+100% damage|n+25% accuracy"
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconWeaponRifle'
     Costs=(1575,3150,5250)
     SkillValues=((Name="WeaponMiniCrossbowDamage",Values=(0,0.2,0.5)),(Name="WeaponMiniCrossbowAccuracy",Values=(0,0.15,0.25)),(Name="WeaponMiniCrossbowReloadTime",Values=(0,0,-0.5)),(Name="WeaponStealthPistolDamage",Values=(0,0.2,0.4)),(Name="WeaponStealthPistolAccuracy",Values=(0,0.15,0.2,0.25)),(Name="WeaponStealthPistolStability",Values=(0,0.3,0.6)),(Name="WeaponRifleDamage",Values=(0,0.2,0.5,1)),(Name="WeaponRifleAccuracy",Values=(0,0.05,0.15,0.25)))
}
