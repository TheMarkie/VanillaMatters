class AugDefense extends VMAugmentation;

defaultproperties
{
     Icon=Texture'DeusExUI.UserInterface.AugIconDefense'
     SmallIcon=Texture'DeusExUI.UserInterface.AugIconDefense_Small'
     UpgradeName="Aggressive Defense System"
     Description="Aerosol nanoparticles are released to form a short-lasting protective bubble around the agent; these nanoparticles will prematurely detonate objects fitting the electromagnetic threat profile of missiles and grenades prior to reaching the agent.|n|nTECH THREE: Release an extra burst of concentrated aerosol nanoparticles, detonating and disabling firearms in close proximity around the agent. Only happens once per activation.|n|nTECH FOUR: Firearm detonation radius is equal to projectile detonation radius.|n|nProjectile Detonate Radius: 40 feet|nFirearm Detonate Radius: 15 / 40 feet|nDuration: 5 / 10 / 10 / 15 seconds|nEnergy Rate: 20 / 20 / 15 / 15 per activation|nCooldown: 10 / 15 / 15 / 15 seconds"
     InstallLocation=AugmentationLocationCranial
     Rates=(0,0,0,0)
     BehaviourClassName=AugDefenseBehaviour
}
