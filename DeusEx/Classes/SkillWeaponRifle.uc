//=============================================================================
// SkillWeaponRifle.
//=============================================================================
class SkillWeaponRifle extends VMSkill;

defaultproperties
{
     SkillName="Weapons: Precision"
     Description="The use of sharpshooting weapons, including sniper rifles, the stealth pistol, and the mini-crossbow.|n|nUNTRAINED: An agent can use sniper rifles, the stealth pistol and the mini-crossbow.|n|nTRAINED:|n+20% Mini-crossbow damage.|n+10% Mini-crossbow accuracy.|n-50% Mini-crossbow reload time.|n+10% Stealth Pistol accuracy.|n+30% Stealth Pistol stability.|n+20% Sniper Rifle damage.|n+5% Sniper Rifle accuracy.|n|nADVANCED:|n+50% Mini-crossbow damage.|n+25% Mini-crossbow accuracy.|n+20% Stealth Pistol damage.|n+15% Stealth Pistol accuracy.|n+60% Stealth Pistol stability.|n+50% Sniper Rifle damage.|n+10% Sniper Rifle accuracy.|n|nMASTER: An agent can take down a target a mile away with one shot.|n+40% Stealth Pistol damage.|n+25% Stealth Pistol accuracy.|n+100% Sniper Rifle damage.|n+25% Sniper Rifle accuracy."
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconWeaponRifle'
     Costs=(1575,3150,5250)
     SkillValues=((Name="WeaponMiniCrossbowDamage",Values=(0,0.2,0.5)),(Name="WeaponMiniCrossbowAccuracy",Values=(0,0.1,0.25)),(Name="WeaponMiniCrossbowReloadTime",Values=(0,0,-0.5)),(Name="WeaponStealthPistolDamage",Values=(0,0,0.2,0.4)),(Name="WeaponStealthPistolAccuracy",Values=(0,0.1,0.15,0.25)),(Name="WeaponStealthPistolStability",Values=(0,0.3,0.6)),(Name="WeaponRifleDamage",Values=(0,0.2,0.5,1)),(Name="WeaponRifleAccuracy",Values=(0,0.05,0.1,0.25)))
}
