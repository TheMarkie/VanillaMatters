class AugDrone extends VMAugmentation;

defaultproperties
{
     Icon=Texture'DeusExUI.UserInterface.AugIconDrone'
     SmallIcon=Texture'DeusExUI.UserInterface.AugIconDrone_Small'
     UpgradeName="Spy Drone"
     Description="Advanced nanofactories can assemble a spy drone upon demand which can then be remotely controlled by the agent until released, at which a point a new drone will be assembled.|n|nDrone Speed: 100 / 150 / 200 / 250|nDrone Duration: 20 / 40 / 60 / 80 seconds|n|nEnergy Cost: 10 per activation"
     InstallLocation=AugmentationLocationCranial
     BehaviourClassName=AugDroneBehaviour
}
