class AugHealing extends VMAugmentation;

// Vanilla Matters TODO: Restore functionality.

// // Vanilla Matters
// var float standingTimer;

// state Active
// {
//     // Vanilla Matters: Make the aug heals every second AFTER you've been standing still for at least 2 seconds.
//     function Tick( float deltaTime ) {
//         if ( VSize( Player.Velocity ) < 10 ) {
//             standingTimer = standingTimer + deltaTime;
//         }
//         else {
//             standingTimer = 0;
//         }

//         if ( standingTimer >= 2.0 ) {
//             if ( Player.Health < 100 ) {
//                 AddImmediateEnergyRate( float( Player.HealPlayer( int( LevelValues[CurrentLevel] ), false ) ) / 5 );
//             }
//             else {
//                 Deactivate();
//                 return;
//             }

//             Player.ClientFlash( 0.5, vect( 0, 0, 500 ) );

//             standingTimer = standingTimer - 1.0;
//         }
//     }

// Begin:
// }

defaultproperties
{
     Icon=Texture'DeusExUI.UserInterface.AugIconHealing'
     SmallIcon=Texture'DeusExUI.UserInterface.AugIconHealing_Small'
     UpgradeName="Regeneration"
     Description="Programmable polymerase automatically directs construction of proteins in injured cells, restoring an agent to full health over time.|n|n[TECH ONE]|nHeals 5 points per second.|n|n[TECH TWO]|nHeals 10 points per second.|n|n[TECH THREE]|nHeals 15 points per second.|n|n[TECH FOUR]|nHeals 20 points per second.|n|nStarts healing when the agent has remained still for at least 2 seconds.|nDrains 1 energy per 5 points healed."
     InstallLocation=AugmentationLocationTorso
}
