class AugEMP extends VMAugmentation;

defaultproperties
{
     Icon=Texture'DeusExUI.UserInterface.AugIconEMP'
     SmallIcon=Texture'DeusExUI.UserInterface.AugIconEMP_Small'
     UpgradeName="Passive-Aggressive Capacitor"
     Description="Nanoscale EMP generators partially protect individual nanites and reduce bioelectrical drain by canceling incoming pulses.|n|n[TECH ONE]|nDamage from EMP attacks is reduced by 25%.|n|n[TECH TWO]|nDamage from EMP attacks is reduced by 50%.|n|n[TECH THREE]|nDamage from EMP attacks is reduced by 75%.|n|n[TECH FOUR]|nAn agent is invulnerable to damage from EMP attacks."
     Rates=(4,5,6,7)
     InstallLocation=AugmentationLocationSubdermal
     BehaviourClassName=AugEMPBehaviour
}
