//=============================================================================
// SkillWeaponPistol.
//=============================================================================
class SkillWeaponPistol extends VMSkill;

defaultproperties
{
     SkillName="Weapons: Ballistic"
     Description="The use of standard weaponry.|n|nAffects: Pistol, Assault Rifle, Sawed-Off Shotgun, Assault Shotgun.|n|n[UNTRAINED]|nAn agent can use standard guns.|n|n[TRAINED]|n<Pistol>|n+15% accuracy|n+50% stability|n|n<Sawed-Off Shotgun>|n+10% accuracy|n+25% stability|n-50% reload time|n|n<Assault Rifle>|n+10% accuracy|n|n[ADVANCED]|n<Pistol>|n+75% stability|n|n<Assault Rifle>|n+15% accuracy|n+50% stability|n|n<Sawed-Off Shotgun>|n+20% accuracy|n+50% stability|n|n<Assault Shotgun>|n+15% accuracy|n+25% stability|n-25% reload time|n|n[MASTER]|nAn agent is a street sweeper.|n<Assault Rifle>|n+25% accuracy|n|n<Assault Shotgun>|n+20% accuracy|n+50% stability|n-50% reload time"
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconWeaponPistol'
     Costs=(1575,3150,5250)
     SkillValues=((Name="WeaponPistolAccuracy",Values=(0,0.15)),(Name="WeaponPistolStability",Values=(0,0.5,0.75)),(Name="WeaponAssaultGunAccuracy",Values=(0,0.1,0.15,0.2)),(Name="WeaponAssaultGunStability",Values=(0,0,0.5)),(Name="WeaponSawedOffShotgunAccuracy",Values=(0,0.1,0.2)),(Name="WeaponSawedOffShotgunStability",Values=(0,0.25,0.5)),(Name="WeaponSawedOffShotgunReloadTime",Values=(0,-0.5)),(Name="WeaponAssaultShotgunAccuracy",Values=(0,0,0.15,0.2)),(Name="WeaponAssaultShotgunStability",Values=(0,0,0.25,0.5)),(Name="WeaponAssaultShotgunReloadTime",Values=(0,0,-0.25,-0.5)))
}
