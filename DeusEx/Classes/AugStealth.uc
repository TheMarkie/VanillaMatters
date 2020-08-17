class AugStealth extends VMAugmentation;

// Vanilla Matters TODO: Restore functionality.

// // Vanilla Matters
// state Active {
// Begin:
//     if ( bHasIt ) {
//         Player.RunSilentValue = LevelValues[CurrentLevel];
//     }
// }

// function Deactivate() {
//     Player.RunSilentValue = 1.0;
//     super.Deactivate();
// }

defaultproperties
{
     Icon=Texture'DeusExUI.UserInterface.AugIconRunSilent'
     SmallIcon=Texture'DeusExUI.UserInterface.AugIconRunSilent_Small'
     UpgradeName="Run Silent"
     Description="The necessary muscle movements for complete silence when walking or running are determined continuously with reactive kinematics equations produced by embedded nanocomputers.|n|n[TECH ONE]|nMovement is 20% quieter.|n- Falling damage reduced by 8 points.|n|n[TECH TWO]|nMovement is 40% quieter.|n- Falling damage reduced by 12 points.|n|n[TECH THREE]|nMovement is 60% quieter.|n- Falling damage reduced by 16 points.|n|n[TECH FOUR]|nAn agent is completely silent.|n- Falling damage reduced by 20 points."
     InstallLocation=AugmentationLocationLeg
}
