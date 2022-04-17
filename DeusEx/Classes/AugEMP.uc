class AugEMP extends VMAugmentation;

#exec TEXTURE IMPORT FILE="Textures\AugIconEMP.bmp" NAME="AugIconEMP" GROUP="VMUI" MIPS=Off
#exec TEXTURE IMPORT FILE="Textures\AugIconEMP_Small.bmp" NAME="AugIconEMP_Small" GROUP="VMUI" MIPS=Off

defaultproperties
{
     Icon=Texture'DeusEx.VMUI.AugIconEMP'
     SmallIcon=Texture'DeusEx.VMUI.AugIconEMP_Small'
     UpgradeName="EMP Supercapacitor"
     Description="Nanoscale EMP generators concentrate and direct electromagnetic pulses, allowing the agent to project a damaging electromagnetic beam while also capable of protecting the agent from incoming pulses.|n|nDamage: 20 / 40 / 80 / 160 per second|nRange: 25 feet|nEMP Resistance: 40% / 80% / 100% / 100%|n|nEnergy Rate: 2 / 4 / 6 / 8 per second"
     InstallLocation=AugmentationLocationSubdermal
     Rates=(2,4,6,8)
     BehaviourClassName=AugEMPBehaviour
}
