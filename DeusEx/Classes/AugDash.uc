class AugDash extends VMAugmentation;

defaultproperties
{
     Icon=Texture'DeusExUI.UserInterface.AugIconSpeedJump'
     SmallIcon=Texture'DeusExUI.UserInterface.AugIconSpeedJump_Small'
     UpgradeName="D.A.S.H"
     Description="Displacement Assisted by Supercharged Hypercapacitors utilizes a system of fast-charging, high-output capacitors installed across the agent's back to generate a controlled electromagnetic blast behind the agent, propeling them forward for a short distance.|n|nEnergy Rate: 20 / 20 / 15 / 15 per activation|nCooldown: 6 / 4.5 / 3 / 1.5 seconds"
     InstallLocation=AugmentationLocationTorso
     Rates=(0,0,0,0)
     BehaviourClassName=AugDashBehaviour
}
