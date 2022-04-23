class AugCloak extends VMAugmentation;

defaultproperties
{
     
     Icon=Texture'DeusExUI.UserInterface.AugIconCloak'
     SmallIcon=Texture'DeusExUI.UserInterface.AugIconCloak_Small'
     UpgradeName="Cloak"
     Description="Subdermal pigmentation cells allow the agent to blend with their surrounding environment, rendering them effectively invisible to observation by organic hostiles.|n|nEnergy Consumption: 100% / 80% / 40% / 20%|n|nEnergy Rate: 5 / 4 / 3 / 2 per second"
     InstallLocation=AugmentationLocationSubdermal
     Rates=(5,4,3,2)
     BehaviourClassName=AugCloakBehaviour
}
