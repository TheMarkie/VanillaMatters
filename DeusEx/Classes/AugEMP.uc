class AugEMP extends VMAugmentation;

defaultproperties
{
     Icon=Texture'DeusExUI.UserInterface.AugIconEMP'
     SmallIcon=Texture'DeusExUI.UserInterface.AugIconEMP_Small'
     UpgradeName="EMP Supercapacitor"
     Description="Nanoscale EMP generators concentrate and direct electromagnetic pulses, allowing the agent to project a damaging short-length electromagnetic beam while also capable of protecting the agent from incoming pulses.|n|nDamage: 15 / 30 / 45 / 60 per second|nRange: 10 feet|nEMP Resistance: 40% / 80% / 100% / 100%|n|nEnergy Rate: 4 / 5 / 6 / 7 per second"
     InstallLocation=AugmentationLocationSubdermal
     Rates=(4,5,6,7)
     BehaviourClassName=AugEMPBehaviour
}
