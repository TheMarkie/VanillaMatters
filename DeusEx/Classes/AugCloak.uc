class AugCloak extends VMAugmentation;

defaultproperties
{
     
     Icon=Texture'DeusExUI.UserInterface.AugIconCloak'
     SmallIcon=Texture'DeusExUI.UserInterface.AugIconCloak_Small'
     UpgradeName="Cloak"
     Description="Subdermal pigmentation cells allow the agent to blend with their surrounding environment, rendering them effectively invisible to observation by organic hostiles.|n|n[TECH ONE]|nPower consumption is high.|n|nTECH TWO|nPower consumption is reduced by 20%.|n|n[TECH THREE]|nPower consumption is reduced by 40%.|n|n[TECH FOUR]|nPower consumption is reduced by 60%."
     InstallLocation=AugmentationLocationSubdermal
     Rates=(5,4,3,2)
     BehaviourClassName=AugCloakBehaviour
}
