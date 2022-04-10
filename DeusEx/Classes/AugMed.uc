class AugMed extends VMAugmentation;

defaultproperties
{
     Icon=Texture'DeusExUI.UserInterface.AugIconAquaLung'
     SmallIcon=Texture'DeusExUI.UserInterface.AugIconAquaLung_Small'
     UpgradeName="AutoMed"
     Description="The AutoMed module installed in lower torso deploys smart neural sensors to detect medical needs or critical injuries and reacts appropriately by administering built-in corrective treatments or the agent's own medical resources.|n|nWhen head or torso goes below 30 HP: Automatically administers a MedKit. Consume a MedKit, doesn't trigger if there's none.|n|nWhen a limb is fully injured (0 HP): Automatically restores to 30 HP. Has a cooldown of 10 seconds.|nSlowly heals damaged limbs over time up to a threshold.|nCan only heal one limb at a time.|n|nWhen energy goes below 50%: Automatically administers a Bioelectric Cell.|n|nLimb Heal: 10 per second|nLimb Heal Threshold: 40 / 40 / 60 / 80 HP|n|nCan be toggled on or off."
     InstallLocation=AugmentationLocationTorso
     Rates=(0,0,0,0)
     BehaviourClassName=AugMedBehaviour
}
