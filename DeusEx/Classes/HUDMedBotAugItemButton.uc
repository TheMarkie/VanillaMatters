//=============================================================================
// HUDMedBotAugItemButton
//=============================================================================

class HUDMedBotAugItemButton extends PersonaItemButton;

var AugmentationCannister augCan;

var bool bSlotFull;
var bool bHasIt;

var Color colBorder;
var Color colIconDisabled;
var Color colIconNormal;

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------
// Vanilla Matters
event DrawWindow( GC gc ) {
    local VMAugmentationInfo info;

    // Vanilla Matters: We can reinstall the same aug again to upgrade it so it shouldn't be grayed out.
    info = VMAugmentationInfo( GetClientObject() );
    if ( ( !bSlotFull && info == none ) || ( info != none && info.CanUpgrade() ) ) {
        colIcon = colIconNormal;
    }
    else {
        colIcon = colIconDisabled;
    }

    super.DrawWindow( gc );

    // Draw selection border
    if ( !bSelected ) {
        gc.SetTileColor( colBorder );
        gc.SetStyle( DSTY_Masked );
        gc.DrawBorders( 0, 0, borderWidth, borderHeight, 0, 0, 0, 0, texBorders );
    }
}

// ----------------------------------------------------------------------
// SetAugmentation()
// ----------------------------------------------------------------------
// Vanilla Matters
function SetAugmentation( class<VMAugmentation> newAug ) {
    local VMAugmentationManager augSystem;
    local VMAugmentationInfo info;

    augSystem = player.GetAugmentationSystem();
    if ( augSystem != none ) {
        info = augSystem.GetInfo( newAug.Name );
    }

    if ( info != none ) {
        SetClientObject( info );
    }
    else {
        SetClientObject( newAug );
    }
    SetIcon( newAug.default.SmallIcon );

    bSlotFull = augSystem.IsLocationFull( newAug.default.InstallLocation );
}

// ----------------------------------------------------------------------
// SetAugCan()
// ----------------------------------------------------------------------

function SetAugCan(AugmentationCannister newAugCan)
{
    augCan = newAugCan;
}

// ----------------------------------------------------------------------
// GetAugCan()
// ----------------------------------------------------------------------

function AugmentationCannister GetAugCan()
{
    return augCan;
}

// ----------------------------------------------------------------------
// GetAugDesc()
// ----------------------------------------------------------------------
// Vanilla Matters
function string GetAugDesc() {
    local VMAugmentationInfo info;

    info = VMAugmentationInfo( GetClientObject() );
    if ( info != none ) {
        return info.GetName();
    }
    else {
        return "";
    }
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
    local ColorTheme theme;

    Super.StyleChanged();

    colBorder.r = Int(Float(colBackground.r) * 0.75);
    colBorder.g = Int(Float(colBackground.g) * 0.75);
    colBorder.b = Int(Float(colBackground.b) * 0.75);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     colIconDisabled=(R=64,G=64,B=64)
     colIconNormal=(R=255,G=255)
     iconPosWidth=32
     iconPosHeight=32
     buttonWidth=34
     buttonHeight=34
     borderWidth=34
     borderHeight=34
}
