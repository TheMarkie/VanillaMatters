//=============================================================================
// AugSpeed.
//=============================================================================
class AugSpeed extends Augmentation;

state Active
{
Begin:
    Player.GroundSpeed *= LevelValues[CurrentLevel];

    // Vanilla Matters: Jump height will use a different value from speed bonus.
    Player.JumpZ = Player.JumpZ * ( LevelValues[CurrentLevel] + 0.1 );
}

function Deactivate()
{
    Super.Deactivate();

    Player.GroundSpeed = Player.Default.GroundSpeed;
    Player.JumpZ = Player.Default.JumpZ;
}

defaultproperties
{
     EnergyRate=20.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconSpeedJump'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconSpeedJump_Small'
     AugmentationName="Speed Enhancement"
     Description="Ionic polymeric gel myofibrils are woven into the leg muscles, increasing the speed at which an agent can run and climb, the height they can jump, and reducing the damage they receive from falls.|n|n[TECH ONE]|n+10% movement speed|n+20% jump height|n- Falling damage reduced by 20 points.|n|n[TECH TWO]|n+30% movement speed|n+40% jump height|n- Falling damage reduced by 40 points.|n|n[TECH THREE]|n+50% movement speed|n+60% jump height|n- Falling damage reduced by 60 points.|n|n[TECH FOUR]|nAn agent can run like the wind and leap from the tallest building.|n+70% movement speed|n+80% jump height|n- Falling damage reduced by 80 points.|n|nProduces noises over a large area when moving."
     MPInfo="When active, you move twice as fast and jump twice as high.  Energy Drain: Very High"
     LevelValues(0)=1.100000
     LevelValues(1)=1.300000
     LevelValues(2)=1.500000
     LevelValues(3)=1.700000
     AugmentationLocation=LOC_Leg
     MPConflictSlot=5
     VM_EnergyRateAddition(1)=20.000000
     VM_EnergyRateAddition(2)=40.000000
     VM_EnergyRateAddition(3)=60.000000
     VM_dragIcon=Texture'DeusEx.VMUI.AugIconSpeed'
}
