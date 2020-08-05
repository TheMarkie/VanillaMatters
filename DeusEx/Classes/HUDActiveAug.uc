//=============================================================================
// HUDActiveAug
//=============================================================================

class HUDActiveAug extends HUDActiveItemBase;

var Color colBlack;
var Color colAugActive;
var Color colAugInactive;

// Vanilla Matters
var name DefinitionClassName;

// ----------------------------------------------------------------------
// SetObject()
//
// Had to write this because SetClientObject() is FINAL in Extension
// ----------------------------------------------------------------------

function SetObject(object newClientObject)
{
    UpdateAugIconStatus();
}

// ----------------------------------------------------------------------
// UpdateAugIconStatus()
// ----------------------------------------------------------------------
// Vanilla Matters
function UpdateAugIconStatus()
{
    local VMAugmentationInfo aug;

    aug = VMAugmentationInfo( GetClientObject() );
    if ( aug != none ) {
        if ( aug.IsActive ) {
            colItemIcon = colAugActive;
        }
        else {
            colItemIcon = colAugInactive;
        }
    }
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     colAugActive=(R=255,G=255)
     colAugInactive=(R=100,G=100,B=100)
     colItemIcon=(B=0)
}
