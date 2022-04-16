class AugHealing extends VMAugmentation;

defaultproperties
{
     Icon=Texture'DeusExUI.UserInterface.AugIconHealing'
     SmallIcon=Texture'DeusExUI.UserInterface.AugIconHealing_Small'
     UpgradeName="Regeneration"
     Description="Programmable polymerase automatically directs construction of proteins in injured cells, restoring an agent to full health over time.|n|nHeal: 10 / 20 / 30 / 40 HP per second|n|nEnergy Rate: 1 / 2 / 3 / 4 per second healed"
     InstallLocation=AugmentationLocationTorso
     Rates=(0,0,0,0)
     BehaviourClassName=AugHealingBehaviour
}
