//=============================================================================
// ComputerCameraUIChoice
//=============================================================================

class ComputerCameraUIChoice extends MenuUIChoiceEnum
	abstract;

var ComputerSecurityCameraWindow winCamera;
var ComputerScreenSecurity       securityWindow;

// Vanilla Matters
var bool VM_bHackedAlready;		// Keep track if this option has been "hacked" aka used while hacking at least once.

// ----------------------------------------------------------------------
// SetCameraView()
// ----------------------------------------------------------------------

function SetCameraView(ComputerSecurityCameraWindow newCamera)
{
	winCamera = newCamera;
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

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultInfoWidth=113
     defaultInfoPosX=154
}
