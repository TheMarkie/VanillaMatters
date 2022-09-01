class AugMed extends VMAugmentation;

#exec TEXTURE IMPORT FILE="Textures\AugIconMed.bmp" NAME="AugIconMed" GROUP="VMUI" MIPS=Off
#exec TEXTURE IMPORT FILE="Textures\AugIconMed_Small.bmp" NAME="AugIconMed_Small" GROUP="VMUI" MIPS=Off

defaultproperties
{
     Icon=Texture'DeusEx.VMUI.AugIconMed'
     SmallIcon=Texture'DeusEx.VMUI.AugIconMed_Small'
     UpgradeName="AutoMed"
     Description="The AutoMed module installed in lower torso deploys smart neural sensors to detect medical needs or critical injuries and reacts appropriately by administering built-in corrective treatments or the agent's own medical resources.|n|nWhen head or torso goes below 30 HP: Automatically administers a MedKit. Consume a MedKit, doesn't trigger if there's none.|n|nWhen a limb is fully injured (0 HP): Automatically restores to 30 HP. Has a cooldown of 10 seconds.|nLEVEL 2: Slowly heals damaged limbs over time up to a threshold.|nCan only heal one limb at a time.|n|nWhen energy goes below 40%: Automatically administers a Bioelectric Cell.|n|nLimb Heal: 10 per second|nLimb Heal Threshold: 40 / 40 / 60 / 80 HP"
     InstallLocation=AugmentationLocationTorso
     IsPassive=True
     Rates=(0,0,0,0)
     BehaviourClassName=AugMedBehaviour
}
