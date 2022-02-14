class AugDefense extends VMAugmentation;

defaultproperties
{
     Icon=Texture'DeusExUI.UserInterface.AugIconDefense'
     SmallIcon=Texture'DeusExUI.UserInterface.AugIconDefense_Small'
     UpgradeName="Aggressive Defense System"
     Description="Aerosol nanoparticles are released upon the detection of objects fitting the electromagnetic threat profile of missiles and grenades; these nanoparticles will prematurely detonate such objects prior to reaching the agent.|n|n[TECH ONE]|nThe range at which hostile objects are detonated is short.|n|n[TECH TWO]|n+100% detonation range|n|n[TECH THREE]|n+200% detonation range|n|n[TECH FOUR]|nRockets and grenades are detonated almost before they are fired.|n+300% detonation range|n|nProjectile detonation costs 10 energy."
     InstallLocation=AugmentationLocationCranial
     Rates=(0,0,0,0)
     BehaviourClassName=AugDefenseBehaviour
}
