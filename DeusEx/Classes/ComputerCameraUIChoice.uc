//=============================================================================
// ComputerCameraUIChoice
//=============================================================================

class ComputerCameraUIChoice extends MenuUIChoiceEnum
    abstract;

var ComputerSecurityCameraWindow winCamera;
var ComputerScreenSecurity       securityWindow;

// Vanilla Matters
var() float VM_timeCost;

var int VM_currentCamera;
var byte VM_hackedAlready[3];
var ComputerSecurityCameraWindow VM_cameras[3];

// ----------------------------------------------------------------------
// SetCameraView()
// ----------------------------------------------------------------------

// Vanilla Matters: We need to check the new camera against our list of registered cameras to update any info properly.
function SetCameraView( ComputerSecurityCameraWindow newCamera ) {
    local int i;
    local string str;

    winCamera = newCamera;

    VM_currentCamera = -1;
    for ( i = 0; i < 3; i++ ) {
        if ( newCamera == VM_cameras[i] ) {
            // VM: Update time cost if it's present.
            str = actionText;
            if ( securityWindow.winTerm.bHacked && VM_cameras[i].camera != none ) {
                if ( VM_hackedAlready[i] <= 0 ) {
                    if ( VM_timeCost == int( VM_timeCost ) ) {
                        str = str @ "(" $ int( VM_timeCost ) $ ")";
                    }
                    else {
                        str = str @ "(" $ class'DeusExWeapon'.static.FormatFloatString( VM_timeCost, 0.1 ) $ ")";
                    }
                }
            }

            btnAction.SetButtonText( str );

            VM_currentCamera = i;

            break;
        }
    }

    if ( VM_currentCamera < 0 ) {
        btnAction.SetButtonText( actionText );
    }
}

// ----------------------------------------------------------------------
// SetSecurityWindow()
// ----------------------------------------------------------------------

function SetSecurityWindow(ComputerScreenSecurity newScreen)
{
    securityWindow = newScreen;
}

// ----------------------------------------------------------------------
// DisableChoice()
// ----------------------------------------------------------------------

function DisableChoice()
{
    btnAction.DisableWindow();
    btnInfo.DisableWindow();
}

// Vanilla Matters: Handle time cost.
function HandleTimeCost() {
    if ( securityWindow.winTerm.bHacked && VM_currentCamera >= 0 ) {
        if ( VM_hackedAlready[VM_currentCamera] <= 0 ) {
            securityWindow.winTerm.winHack.AddTimeCost( VM_timeCost );
            VM_hackedAlready[VM_currentCamera] = 1;

            btnAction.SetButtonText( actionText );
        }
    }
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultInfoWidth=113
     defaultInfoPosX=154
}
