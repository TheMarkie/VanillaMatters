//=============================================================================
// SkillWeaponPistol.
//=============================================================================
class SkillWeaponPistol extends VMSkill;

defaultproperties
{
     SkillName="Weapons: Ballistic"
     Description="The use of standard weaponry, including pistols, assault rifles, and shotguns.|n|nUNTRAINED: An agent can use standard guns.|n|nTRAINED:|n+20% Pistol accuracy.|n+50% Pistol stability.|n+10% Sawed-Off Shotgun accuracy.|n+25% Sawed-Off Shotgun stability.|n-50% Sawed-Off Shotgun reload time.|n|nADVANCED:|n+75% Pistol stability.|n+15% Assault Rifle accuracy.|n+50% Assault Rifle stability.|n+20% Sawed-Off Shotgun accuracy.|n+50% Sawed-Off Shotgun stability.|n+15% Assault Shotgun accuracy.|n+25% Assault Shotgun stability.|n-25% Assault Shotgun reload time.|n|nMASTER: An agent is a street sweeper.|n+25% Assault Rifle accuracy.|n+20% Assault Shotgun accuracy.|n+50% Assault Shotgun stability.|n-50% Assault Shotgun reload time."
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconWeaponPistol'
     Costs=(1575,3150,5250)
     SkillValues=((Name="WeaponPistolAccuracy",Values=(0,0.2)),(Name="WeaponPistolStability",Values=(0,0.5,0.75)),(Name="WeaponAssaultGunAccuracy",Values=(0,0,0.15,0.25)),(Name="WeaponAssaultGunStability",Values=(0,0,0.5)),(Name="WeaponSawedOffShotgunAccuracy",Values=(0,0.1,0.2)),(Name="WeaponSawedOffShotgunStability",Values=(0,0.25,0.5)),(Name="WeaponSawedOffShotgunReloadTime",Values=(0,-0.5)),(Name="WeaponAssaultShotgunAccuracy",Values=(0,0,0.15,0.2)),(Name="WeaponAssaultShotgunStability",Values=(0,0,0.25,0.5)),(Name="WeaponAssaultShotgunReloadTime",Values=(0,0,-0.25,-0.5)))
}
