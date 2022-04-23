class AugDash extends VMAugmentation;

#exec TEXTURE IMPORT FILE="Textures\AugIconDash.bmp" NAME="AugIconDash" GROUP="VMUI" MIPS=Off
#exec TEXTURE IMPORT FILE="Textures\AugIconDash_Small.bmp" NAME="AugIconDash_Small" GROUP="VMUI" MIPS=Off

defaultproperties
{
     Icon=Texture'DeusEx.VMUI.AugIconDash'
     SmallIcon=Texture'DeusEx.VMUI.AugIconDash_Small'
     UpgradeName="D.A.S.H"
     Description="Displacement Assisted by Supercharged Hypercapacitors utilizes a system of fast-charging, high-output capacitors installed across the agent's back to generate a controlled electromagnetic blast behind the agent, propeling them forward for a short distance.|n|nEnergy Cost: 10 / 8 / 6 / 4 per activation|nCooldown: 4 / 3 / 2 / 1 seconds"
     InstallLocation=AugmentationLocationTorso
     Rates=(0,0,0,0)
     BehaviourClassName=AugDashBehaviour
}
