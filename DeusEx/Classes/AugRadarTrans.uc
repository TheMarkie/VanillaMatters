//=============================================================================
// AugRadarTrans.
//=============================================================================
class AugRadarTrans extends VMAugmentation;

// Vanilla Matters TODO: Restore functionality.

// function float GetEnergyRate()
// {
//     return energyRate * LevelValues[CurrentLevel];
// }

defaultproperties
{
     EnergyRate=300.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconRadarTrans'
     SmallIcon=Texture'DeusExUI.UserInterface.AugIconRadarTrans_Small'
     UpgradeName="Radar Transparency"
     Description="Radar-absorbent resin augments epithelial proteins; microprojection units distort agent's visual signature. Provides highly effective concealment from automated detection systems -- bots, cameras, turrets.|n|n[TECH ONE]|nPower consumption is high.|n|n[TECH TWO]|nower consumption is reduced by 20%.|n|n[TECH THREE]|nPower consumption is reduced by 40%.|n|n[TECH FOUR]|nPower consumption is reduced by 60%."
     InstallLocation=AugmentationLocationSubdermal
}
