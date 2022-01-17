class AugLight extends VMAugmentation;

defaultproperties
{
     Icon=Texture'DeusExUI.UserInterface.AugIconLight'
     SmallIcon=Texture'DeusExUI.UserInterface.AugIconLight_Small'
     ActivateSound=Sound'DeusExSounds.Augmentation.AugActivate'
     DeActivateSound=Sound'DeusExSounds.Augmentation.AugDeactivate'
     UpgradeName="Light"
     Description="Bioluminescent cells within the retina provide coherent illumination of the agent's field of view.|n|nNO UPGRADES"
     InstallLocation=AugmentationLocationDefault
     Rates=(0.1)
     BehaviourClassName=AugLightBehaviour
}
