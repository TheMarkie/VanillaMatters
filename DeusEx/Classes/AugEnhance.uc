class AugEnhance extends VMAugmentation;

#exec TEXTURE IMPORT FILE="Textures\AugIconEnhance.bmp" NAME="AugIconEnhance" GROUP="VMUI" MIPS=Off
#exec TEXTURE IMPORT FILE="Textures\AugIconEnhance_Small.bmp" NAME="AugIconEnhance_Small" GROUP="VMUI" MIPS=Off

defaultproperties
{
     Icon=Texture'DeusEx.VMUI.AugIconEnhance'
     SmallIcon=Texture'DeusEx.VMUI.AugIconEnhance_Small'
     UpgradeName="Nano-Enhancers"
     Description="Nanite bioworkers reinforce and improve body tissue bioprocesses, enhancing the agent's physical performance as well as self regenerative capability.|n|nGain bonuses as long as energy is above threshold. The higher above threshold, the better the bonuses.|nBonuses start at base and scale up every 10% energy.|n|nBase Energy Threshold: 80% / 70% / 60%|nMovement Speed: +10% per threshold|nMax Movement Speed: 20% / 30% / 40%|nBase Heal: 6 HP per second|nBonus Heal: 2 / 4 / 6 HP per second|nMax Heal: 8 / 14 / 22 HP per second"
     InstallLocation=AugmentationLocationTorso
     IsPassive=true
     Rates=(0,0,0)
     BehaviourClassName=AugEnhanceBehaviour
}
