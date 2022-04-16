class AugEnhance extends VMAugmentation;

defaultproperties
{
     Icon=Texture'DeusExUI.UserInterface.AugIconSpeedJump'
     SmallIcon=Texture'DeusExUI.UserInterface.AugIconSpeedJump_Small'
     UpgradeName="Nano-Enhancers"
     Description="Nanite bioworkers reinforce and improve body tissue bioprocesses, enhancing the agent's physical performance as well as self regenerative capability.|n|nGain bonuses as long as energy is above threshold. The higher above threshold, the better the bonuses.|nBonuses start at base and scale up every 10% energy.|n|nBase Energy Threshold: 80% / 70% / 60%|nMovement Speed: +10% per threshold|nMax Movement Speed: 20% / 30% / 40%|nBase Heal: 8 HP per second|nBonus Heal: 4 / 6 / 8 HP per second|nMax Heal: 12 / 20 / 32 HP per second"
     InstallLocation=AugmentationLocationTorso
     IsPassive=true
     Rates=(0,0,0)
     BehaviourClassName=AugEnhanceBehaviour
}
