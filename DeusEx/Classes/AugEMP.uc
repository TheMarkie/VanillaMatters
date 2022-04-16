class AugEMP extends VMAugmentation;

#exec TEXTURE IMPORT FILE="Textures\AugIconEMP.bmp" NAME="AugIconEMP" GROUP="VMUI" MIPS=Off
#exec TEXTURE IMPORT FILE="Textures\AugIconEMP_Small.bmp" NAME="AugIconEMP_Small" GROUP="VMUI" MIPS=Off

defaultproperties
{
     Icon=Texture'DeusEx.VMUI.AugIconEMP'
     SmallIcon=Texture'DeusEx.VMUI.AugIconEMP_Small'
     UpgradeName="EMP Supercapacitor"
     Description="Nanoscale EMP generators concentrate and direct electromagnetic pulses, allowing the agent to project a damaging short-length electromagnetic beam while also capable of protecting the agent from incoming pulses.|n|nDamage: 15 / 30 / 50 / 75 per second|nRange: 10 feet|nEMP Resistance: 40% / 80% / 100% / 100%|n|nEnergy Rate: 3 / 4 / 5 / 6 per second"
     InstallLocation=AugmentationLocationSubdermal
     Rates=(3,4,5,6)
     BehaviourClassName=AugEMPBehaviour
}
