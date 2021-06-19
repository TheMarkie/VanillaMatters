class AugMuscle extends VMAugmentation;

// Vanilla Matters TODO: Restore functionality.
// Vanilla Matters TODO: Combine Combat Strength tooltip.

defaultproperties
{
     Icon=Texture'DeusExUI.UserInterface.AugIconMuscle'
     SmallIcon=Texture'DeusExUI.UserInterface.AugIconMuscle_Small'
     IsPassive=True
     UpgradeName="Microfibral Muscle"
     Description="Muscle strength is amplified with ionic polymeric gel myofibrils that allow the agent to push and lift extraordinarily heavy objects.|n|n[TECH ONE]|nStrength is increased by 100%.|n- The agent can turn any object into a lethal missile with a powerthrow.|n(Powerthrow damage is relative to strength)|n+25% thrown weapon speed and distance|n-10% accuracy penalty from arm injuries|n|n[TECH TWO]|nStrength is increased by 200%.|n+50% thrown weapon speed and distance|n-20% accuracy penalty|n|n[TECH THREE]|nStrength is increased by 300%.|n+75% thrown weapon speed and distance|n-30% accuracy penalty|n|n[TECH FOUR]|nAn agent is inhumanly strong.|nStrength is increased by 400%.|n+100% thrown weapon speed and distance|n-40% accuracy penalty|n|nStarts draining energy when a heavy object is held or a powerthrow is performed, drain rate depends on the object's mass."
     Rates=(0,0,0,0)
     InstallLocation=AugmentationLocationArm
     BehaviourClassName=AugMuscleBehaviour
}
