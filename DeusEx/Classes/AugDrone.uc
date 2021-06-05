class AugDrone extends VMAugmentation;

defaultproperties
{
     Icon=Texture'DeusExUI.UserInterface.AugIconDrone'
     SmallIcon=Texture'DeusExUI.UserInterface.AugIconDrone_Small'
     UpgradeName="Spy Drone"
     Description="Advanced nanofactories can assemble a spy drone upon demand which can then be remotely controlled by the agent until released or destroyed, at which a point a new drone will be assembled. Further upgrades equip the spy drones with better armor and a one-shot EMP attack.|n|n[TECH ONE]|nThe drone can take little damage and has a very light EMP attack.|n|n[TECH TWO]|n+33% drone speed|n+100% EMP damage|n+25% blast radius|n|n[TECH THREE]|n+67% drone speed|n+300% EMP damage|n+50% blast radius|n|n[TECH FOUR]|n+100% drone speed|n+700% EMP damage|n+75% blast radius|n|nDrone detonation costs one minute worth of energy drain.|n|nDrones take 30 seconds to be reconstructed."
     InstallLocation=AugmentationLocationCranial
     BehaviourClassName=AugDroneBehaviour
}
