class AugCloak extends VMAugmentation;

// Vanilla Matters TODO: Restore functionality.

// // Vanilla Matters: Keep track of the player's last in hand item.
// var travel Inventory lastInHand;

// state Active
// {
//     // Vanilla Matters: Apply and remove transparency accordingly, applies to newly equipped items and removes from unequipped ones.
//     function Tick( float deltaTime ) {
//         if ( lastInHand == None ) {
//             if ( Player.inHand != None ) {
//                 lastInHand = Player.inHand;
//                 ToggleTransparency( lastInHand, true, 0.05 );
//             }

//             return;
//         }
//         else if ( Player.inHand == None ) {
//             ToggleTransparency( lastInHand, false );
//             lastInHand = None;
//             return;
//         }

//         if ( lastInHand != Player.inHand ) {
//             ToggleTransparency( lastInHand, false );
//             lastInHand = Player.inHand;
//             ToggleTransparency( lastInHand, true, 0.05 );
//         }
//     }
// Begin:
//     if ((Player.inHand != None) && (Player.inHand.IsA('DeusExWeapon')))
//         Player.ServerConditionalNotifyMsg( Player.MPMSG_NoCloakWeapon );
//     Player.PlaySound(Sound'CloakUp', SLOT_Interact, 0.85, ,768,1.0);

//     // Vanilla Matters: Cloak the player in third person.
//     Player.SetSkinStyle( STY_Translucent, Texture'WhiteStatic', 0.05 );
//     Player.KillShadow();
//     Player.MultiSkins[6] = Texture'BlackMaskTex';
//     Player.MultiSkins[7] = Texture'BlackMaskTex';
// }

// function Deactivate()
// {
//     Player.PlaySound(Sound'CloakDown', SLOT_Interact, 0.85, ,768,1.0);
//     Super.Deactivate();

//     // Vanilla Matters: Clean up transparency.
//     ToggleTransparency( lastInHand, false );
//     lastInHand = None;

//     Player.ResetSkinStyle();
//     Player.CreateShadow();
// }

// // Vanilla Matters: Functions to set and reset item transparency.
// function ToggleTransparency( Inventory item, bool transparent, optional float newScaleGlow ) {
//     if ( item == none ) {
//         return;
//     }

//     if ( transparent ) {
//         item.Style = STY_Translucent;
//         item.ScaleGlow = newScaleGlow;
//     }
//     else {
//         item.Style = STY_Normal;
//         item.ScaleGlow = item.Default.ScaleGlow;
//     }
// }

// simulated function float GetEnergyRate()
// {
//     return energyRate * LevelValues[CurrentLevel];
// }

defaultproperties
{
     
     Icon=Texture'DeusExUI.UserInterface.AugIconCloak'
     SmallIcon=Texture'DeusExUI.UserInterface.AugIconCloak_Small'
     UpgradeName="Cloak"
     Description="Subdermal pigmentation cells allow the agent to blend with their surrounding environment, rendering them effectively invisible to observation by organic hostiles.|n|n[TECH ONE]|nPower consumption is high.|n|nTECH TWO|nPower consumption is reduced by 20%.|n|n[TECH THREE]|nPower consumption is reduced by 40%.|n|n[TECH FOUR]|nPower consumption is reduced by 60%."
     InstallLocation=AugmentationLocationSubdermal
}
