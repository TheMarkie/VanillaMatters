class AugTarget extends VMAugmentation;

// Vanilla Matters TODO: Restore functionality.

// // ----------------------------------------------------------------------------
// // Network Replication
// // ----------------------------------------------------------------------------

// replication
// {
//    //Server to client function replication
//    reliable if (Role == ROLE_Authority)
//       SetTargetingAugStatus;
// }

// state Active
// {
// Begin:
//    SetTargetingAugStatus(CurrentLevel,True);
// }

// function Deactivate()
// {
//     Super.Deactivate();

//    SetTargetingAugStatus(CurrentLevel,False);
// }

// // ----------------------------------------------------------------------
// // SetTargetingAugStatus()
// // ----------------------------------------------------------------------

// simulated function SetTargetingAugStatus(int Level, bool IsActive)
// {
//     DeusExRootWindow(Player.rootWindow).hud.augDisplay.bTargetActive = IsActive;
//     DeusExRootWindow(Player.rootWindow).hud.augDisplay.targetLevel = Level;
// }

defaultproperties
{
     Icon=Texture'DeusExUI.UserInterface.AugIconTarget'
     SmallIcon=Texture'DeusExUI.UserInterface.AugIconTarget_Small'
     UpgradeName="Targeting"
     Description="Image-scaling and recognition provided by multiplexing the optic nerve with doped polyacetylene 'quantum wires' not only increases accuracy, but also delivers limited situational info about a target.|n|n[TECH ONE]|nGeneral target information.|n+4% weapon accuracy|n|n[TECH TWO]|nExtensive target information.|n+8% weapon accuracy|n|n[TECH THREE]|nSpecific target information.|n+12% weapon accuracy|n|n[TECH FOUR]|nTelescopic vision.|n+16% weapon accuracy"
     InstallLocation=AugmentationLocationEye
}
