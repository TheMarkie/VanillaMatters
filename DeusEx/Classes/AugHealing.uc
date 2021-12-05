class AugHealing extends VMAugmentation;

defaultproperties
{
     Icon=Texture'DeusExUI.UserInterface.AugIconHealing'
     SmallIcon=Texture'DeusExUI.UserInterface.AugIconHealing_Small'
     UpgradeName="Regeneration"
     Description="Programmable polymerase automatically directs construction of proteins in injured cells, restoring an agent to full health over time.|n|n[TECH ONE]|nHeals 10 points per second.|n|n[TECH TWO]|nHeals 20 points per second.|n|n[TECH THREE]|nHeals 30 points per second.|n|n[TECH FOUR]|nHeals 40 points per second.|n|nStarts healing when the agent has remained still for at least 2 seconds.|nDrains 1 energy per 10 points healed."
     InstallLocation=AugmentationLocationTorso
     Rates=(0,0,0,0)
     BehaviourClassName=AugHealingBehaviour
}
