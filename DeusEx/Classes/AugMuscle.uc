class AugMuscle extends VMAugmentation;

defaultproperties
{
     Icon=Texture'DeusExUI.UserInterface.AugIconMuscle'
     SmallIcon=Texture'DeusExUI.UserInterface.AugIconMuscle_Small'
     ActivateSound=Sound'DeusExSounds.Augmentation.AugActivate'
     IsPassive=True
     UpgradeName="Microfibral Muscle"
     Description="Muscle strength is amplified with ionic polymeric gel myofibrils that allow the agent to push and lift extraordinarily heavy objects. The agent can also turn any object into a lethal missile with a powerthrow.|n|nPress Fire when holding an object to powerthrow.|n|nLift Strength: +100% / 200% / 300% / 400%|nThrow Strength: +25% / 50% / 75% / 100%|nInjury Accuracy Penalty: -10% / 20% / 30% / 40%|n|nEnergy Rate: 15 per powerthrow"
     Rates=(0,0,0,0)
     InstallLocation=AugmentationLocationArm
     BehaviourClassName=AugMuscleBehaviour
}
