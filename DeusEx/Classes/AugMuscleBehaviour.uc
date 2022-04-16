class AugMuscleBehaviour extends VMAugmentationBehaviour;

var() array<float> LiftStrengthBonus;
var() array<float> ThrowVelocityBonus;
var() array<float> InjuryAccuracyPenaltyReduction;

var() array<float> PowerthrowVelocityBoost;
var() float MuscleCost;
var localized string MsgMuscleCost;

function Refresh( VMPlayer p, VMAugmentationInfo i, VMAugmentationManager m ) {
    super.Refresh( p, i, m );
    m.ParseLeftClickHandlers[-1] = self;
}

function bool Activate() {
    local int level;

    level = Info.Level;
    Player.GlobalModifiers.Modify( 'LiftStrengthBonus', default.LiftStrengthBonus[level] );
    Player.GlobalModifiers.Modify( 'ThrowVelocityBonus', default.ThrowVelocityBonus[level] );
    Player.GlobalModifiers.Modify( 'InjuryAccuracyPenaltyReduction', default.InjuryAccuracyPenaltyReduction[level] );

    return true;
}

function bool Deactivate() {
    local int level;

    level = Info.Level;
    Player.GlobalModifiers.Modify( 'LiftStrengthBonus', -default.LiftStrengthBonus[level] );
    Player.GlobalModifiers.Modify( 'ThrowVelocityBonus', -default.ThrowVelocityBonus[level] );
    Player.GlobalModifiers.Modify( 'InjuryAccuracyPenaltyReduction', -default.InjuryAccuracyPenaltyReduction[level] );

    return true;
}

function bool ParseLeftClick() {
    local DeusExDecoration deco;

    deco = DeusExDecoration( Player.CarriedDecoration );
    if ( deco != none ) {
        if ( Player.DrainEnergy( MuscleCost ) ) {
            Player.PlaySound( Player.JumpSound, SLOT_None );
            Player.PlaySound( Info.Definition.default.ActivateSound, SLOT_None );

            Player.DropDecoration();
            if ( deco.bCollideWorld ) {
                deco.Velocity += Normal( deco.Velocity ) * PowerThrowVelocityBoost[Info.Level];
            }
        }
        else {
            Player.ClientMessage( MsgMuscleCost );
        }
    }
}

defaultproperties
{
     LiftStrengthBonus=(1,2,3,4)
     ThrowVelocityBonus=(0.25,0.5,0.75,1)
     InjuryAccuracyPenaltyReduction=(0.1,0.2,0.3,0.4)
     PowerthrowVelocityBoost=(1000,2000,3000,4000)
     MuscleCost=10
     MsgMuscleCost="You don't have enough energy to do a powerthrow"
}
