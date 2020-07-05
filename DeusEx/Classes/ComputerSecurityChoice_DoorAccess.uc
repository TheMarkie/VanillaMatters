//=============================================================================
// ComputerSecurityChoice_DoorAccess
//=============================================================================

class ComputerSecurityChoice_DoorAccess extends ComputerCameraUIChoice;

// ----------------------------------------------------------------------
// SetCameraView()
// ----------------------------------------------------------------------

function SetCameraView(ComputerSecurityCameraWindow newCamera)
{
    Super.SetCameraView(newCamera);

    if (winCamera != None)
    {
        if (winCamera.door != None)
        {
            EnableWindow();     // In case was previously disabled
        }
        else
        {
            // Disable!
            DisableWindow();
            btnInfo.SetButtonText("");
        }
    }
    else
    {
        // Disable!
        DisableWindow();
        btnInfo.SetButtonText("");
    }
}

// ----------------------------------------------------------------------
// ButtonActivated()
//
// If the action button was pressed, cycle to the next available
// choice (if any)
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
    // Vanilla Matters
    if ( !winCamera.door.bFrobbable || winCamera.door.bOneWay ) {
        securityWindow.TriggerDoor();
    }
    else {
        securityWindow.ToggleDoorLock();
    }

    HandleTimeCost();

    return True;
}

// ----------------------------------------------------------------------
// ButtonActivatedRight()
// ----------------------------------------------------------------------

function bool ButtonActivatedRight( Window buttonPressed )
{
    // Vanilla Matters
    if ( !winCamera.door.bFrobbable || winCamera.door.bOneWay ) {
        securityWindow.TriggerDoor();
    }
    else {
        securityWindow.ToggleDoorLock();
    }

    HandleTimeCost();

    return True;
}

// Vanilla Matters
function CycleNextValue() {
    if ( winCamera.door == none ) {
        return;
    }

    if ( winCamera.door.bLocked ) {
        SetValue( 0 );
    }
    else {
        SetValue( 1 );
    }

    if ( !winCamera.door.bFrobbable || winCamera.door.bOneWay ) {
        if ( winCamera.door.KeyNum != 0 ) {
            btnInfo.SetButtonText( "Open" );
        }
        else {
            btnInfo.SetButtonText( "Closed" );
        }
    }
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     VM_timeCost=5.000000
     enumText(0)="Locked"
     enumText(1)="Unlocked"
     actionText="Door |&Access"
}
