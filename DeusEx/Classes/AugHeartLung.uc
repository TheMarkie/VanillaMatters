//=============================================================================
// AugHeartLung.
//=============================================================================
class AugHeartLung extends Augmentation;

state Active
{
Begin:
    // Vanilla Matters: BoostAugs is improved to only need to be run once at the start, reducing performance cost.
    // Vanilla Maters TODO: Fix or replace this aug.
}

function Deactivate()
{
    Super.Deactivate();

    // Vanilla Maters TODO: Fix or replace this aug.
}

defaultproperties
{
     EnergyRate=180.000000
     MaxLevel=0
     Icon=Texture'DeusExUI.UserInterface.AugIconHeartLung'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconHeartLung_Small'
     AugmentationName="Synthetic Heart"
     Description="This synthetic heart circulates not only blood but a steady concentration of mechanochemical power cells, smart phagocytes, and liposomes containing prefab diamondoid machine parts, resulting in upgraded performance for all installed augmentations.|n|n<UNATCO OPS FILE NOTE JR133-VIOLET> However, this will not enhance any augmentation past its maximum upgrade level. -- Jaime Reyes <END NOTE>|n|nNO UPGRADES"
     LevelValues(0)=1.000000
     AugmentationLocation=LOC_Torso
     VM_dragIcon=Texture'DeusEx.VMUI.AugIconHeart'
}
