//=============================================================================
// AugRadarTrans.
//=============================================================================
class AugRadarTrans extends VMAugmentation;

defaultproperties
{
     Icon=Texture'DeusExUI.UserInterface.AugIconRadarTrans'
     SmallIcon=Texture'DeusExUI.UserInterface.AugIconRadarTrans_Small'
     UpgradeName="Radar Transparency"
     Description="Radar-absorbent resin augments epithelial proteins; microprojection units distort agent's visual signature. Provides highly effective concealment from automated detection systems -- bots, cameras, turrets.|n|nEnergy Consumption: 100% / 80% / 40% / 20%|n|nEnergy Rate: 5 / 4 / 3 / 2 per second"
     InstallLocation=AugmentationLocationSubdermal
     Rates=(5,4,3,2)
     BehaviourClassName=AugRadarTransBehaviour
}
