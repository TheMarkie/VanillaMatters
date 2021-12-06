class AugCloakBehaviour extends VMAugmentationBehaviour;

var() Name VisibilityModifierName;

// Vanilla Matters: Keep track of the player's last in hand item.
var travel Inventory LastInHand;

function bool Activate() {
    Player.PlaySound( Sound'CloakUp', SLOT_Interact, 0.85,, 768, 1.0 );

    Player.SetSkinStyle( STY_Translucent, Texture'WhiteStatic', 0.05 );
    Player.KillShadow();
    Player.MultiSkins[6] = Texture'BlackMaskTex';
    Player.MultiSkins[7] = Texture'BlackMaskTex';

    Player.GlobalModifiers.Modify( VisibilityModifierName, 1 );

    return true;
}

function float Tick( float deltaTime ) {
    if ( LastInHand == None ) {
        if ( Player.inHand != None ) {
            LastInHand = Player.inHand;
            ToggleTransparency( LastInHand, true, 0.05 );
        }
    }
    else if ( Player.inHand == None ) {
        ToggleTransparency( LastInHand, false );
        LastInHand = None;
    }
    else if ( LastInHand != Player.inHand ) {
        ToggleTransparency( LastInHand, false );
        LastInHand = Player.inHand;
        ToggleTransparency( LastInHand, true, 0.05 );
    }

    return super.Tick( deltaTime );
}

function bool Deactivate() {
    Player.PlaySound( Sound'CloakDown', SLOT_Interact, 0.85,, 768, 1.0 );

    ToggleTransparency( LastInHand, false );
    LastInHand = None;

    Player.ResetSkinStyle();
    Player.CreateShadow();

    Player.GlobalModifiers.Modify( VisibilityModifierName, -1 );

    return true;
}

// Set and reset item transparency.
function ToggleTransparency( Inventory item, bool transparent, optional float newScaleGlow ) {
    if ( item == none ) {
        return;
    }

    if ( transparent ) {
        item.Style = STY_Translucent;
        item.ScaleGlow = newScaleGlow;
    }
    else {
        item.Style = STY_Normal;
        item.ScaleGlow = item.Default.ScaleGlow;
    }
}

defaultproperties
{
     VisibilityModifierName=NormalVisibilityReductionMult
}
