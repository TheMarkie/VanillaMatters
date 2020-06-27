//=============================================================================
// AugStealth.
//=============================================================================
class AugStealth extends Augmentation;

// Vanilla Matters
state Active {
Begin:
    if ( bHasIt ) {
        Player.RunSilentValue = LevelValues[CurrentLevel];
    }
}

function Deactivate() {
    Player.RunSilentValue = 1.0;
    super.Deactivate();
}

defaultproperties
{
     EnergyRate=20.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconRunSilent'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconRunSilent_Small'
     AugmentationName="Run Silent"
     Description="The necessary muscle movements for complete silence when walking or running are determined continuously with reactive kinematics equations produced by embedded nanocomputers.|n|n[TECH ONE]|nMovement is 20% quieter.|n- Falling damage reduced by 8 points.|n|n[TECH TWO]|nMovement is 40% quieter.|n- Falling damage reduced by 12 points.|n|n[TECH THREE]|nMovement is 60% quieter.|n- Falling damage reduced by 16 points.|n|n[TECH FOUR]|nAn agent is completely silent.|n- Falling damage reduced by 20 points."
     LevelValues(0)=0.800000
     LevelValues(1)=0.600000
     LevelValues(2)=0.400000
     AugmentationLocation=LOC_Leg
     MPConflictSlot=8
     VM_EnergyRateAddition(1)=20.000000
     VM_EnergyRateAddition(2)=40.000000
     VM_EnergyRateAddition(3)=60.000000
     VM_dragIcon=Texture'DeusEx.VMUI.AugIconRunSilent'
}
