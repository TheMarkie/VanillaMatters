class AugHealing extends VMAugmentation;

defaultproperties
{
     Icon=Texture'DeusExUI.UserInterface.AugIconHealing'
     SmallIcon=Texture'DeusExUI.UserInterface.AugIconHealing_Small'
     UpgradeName="Regeneration"
     Description="Programmable polymerase automatically directs construction of proteins in injured cells, restoring an agent to full health over time.|n|nOnly begins healing when the agent has stood still for at least 2 seconds. Does not consume when not healing.|n|nHeal: 10 / 20 / 30 / 40 HP per second|nEnergy Rate: 2 / 4 / 6 / 8 per second healed"
     InstallLocation=AugmentationLocationTorso
     Rates=(0,0,0,0)
     BehaviourClassName=AugHealingBehaviour
}
