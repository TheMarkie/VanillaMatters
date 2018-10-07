//=============================================================================
// ComputerSecurityChoice_DoorOpen
//=============================================================================

class ComputerSecurityChoice_DoorOpen extends ComputerCameraUIChoice;

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
			EnableWindow();		// In case was previously disabled

			if (winCamera.door.KeyNum != 0)
				SetValue(0);
			else
				SetValue(1);
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
	Super.ButtonActivated(buttonPressed);
	securityWindow.TriggerDoor();

	// Vanilla Matters: Make each door toggle cost an amount of time.
	HandleTimeCost();

	return True;
}

// ----------------------------------------------------------------------
// ButtonActivatedRight()
// ----------------------------------------------------------------------

function bool ButtonActivatedRight( Window buttonPressed )
{
	Super.ButtonActivated(buttonPressed);
	securityWindow.TriggerDoor();

	// Vanilla Matters: Make each door toggle cost an amount of time.
	HandleTimeCost();

	return True;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     enumText(0)="Open"
     enumText(1)="Closed"
     actionText="|&Door Status"
     VM_timeCost=5.000000
}
