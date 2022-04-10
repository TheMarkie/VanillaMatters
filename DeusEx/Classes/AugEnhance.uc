class AugEnhance extends VMAugmentation;

defaultproperties
{
     Icon=Texture'DeusExUI.UserInterface.AugIconSpeedJump'
     SmallIcon=Texture'DeusExUI.UserInterface.AugIconSpeedJump_Small'
     UpgradeName="Nano-Enhancers"
     Description="Nanite bioworkers reinforce and improve body tissue bioprocesses, enhancing the agent's physical performance as well as self regenerative capability.|n|nGain bonuses as long as energy is above a threshold. The higher above threshold, the higher the bonuses.|nScale up every 10% above the threshold.|n|nEnergy Threshold: 90% / 80% / 70%|nMovement Speed: +10% / 20% / 30% at above 90% energy|nHeal: 5 / 10 / 15 HP per second at above 90% energy"
     InstallLocation=AugmentationLocationTorso
     Rates=(0,0,0)
     BehaviourClassName=AugEnhanceBehaviour
}
