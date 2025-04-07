class AugMed extends VMAugmentation;

#exec TEXTURE IMPORT FILE="Textures\AugIconMed.bmp" NAME="AugIconMed" GROUP="VMUI" MIPS=Off
#exec TEXTURE IMPORT FILE="Textures\AugIconMed_Small.bmp" NAME="AugIconMed_Small" GROUP="VMUI" MIPS=Off

defaultproperties
{
     Icon=Texture'DeusEx.VMUI.AugIconMed'
     SmallIcon=Texture'DeusEx.VMUI.AugIconMed_Small'
     UpgradeName="AutoMed"
     Description="The AutoMed module installed in lower torso deploys smart neural sensors to detect critical injuries and reacts appropriately by administering corrective treatments.|n|nWhen head or torso goes below 30 HP: Automatically administers a MedKit. Requires a MedKit.|n|nPassively heals damaged limbs up to a threshold. One limb at a time.|nLimb Heal: 10 per second|nLimb Heal Threshold: 20 / 40 / 60 / 80 HP|n|nLEVEL 2: When a limb is fully injured (0 HP): It is healed to 30 HP.|nCooldown: 10 seconds.|n|nLEVEL 3: When you take fatal damage to the head or torso: They are healed to 40 HP.|nCooldown: 30 seconds|n|nLEVEL 4: When you take fatal damage: Head and torso are fully healed."
     InstallLocation=AugmentationLocationTorso
     IsPassive=True
     Rates=(0,0,0,0)
     BehaviourClassName=AugMedBehaviour
}
