//=============================================================================
// ComputerScreenSpecialOptions
//=============================================================================

class ComputerScreenSpecialOptions expands ComputerUIWindow;

struct S_OptionButtons
{
	var int specialIndex;
	var MenuUIChoiceButton btnSpecial;
};

var S_OptionButtons optionButtons[4];

var MenuUIActionButtonWindow btnReturn;
var MenuUIActionButtonWindow btnLogout;
var MenuUISmallLabelWindow   winSpecialInfo;

var int buttonLeftMargin;
var int firstButtonPosY;
var int specialOffsetY;
var int statusPosYOffset;
var int TopTextureHeight;
var int MiddleTextureHeight;
var int BottomTextureHeight;

var localized String SecurityButtonLabel;
var localized String EmailButtonLabel;

// Vanilla Matters
var bool VM_bHackedAlready;		// Keep track if this option has been "hacked" aka used while hacking at least once.

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	Super.CreateControls();

	btnLogout = winButtonBar.AddButton(ButtonLabelLogout, HALIGN_Right);

	CreateSpecialInfoWindow();
}

// ----------------------------------------------------------------------
// CreateClientWindow()
// ----------------------------------------------------------------------

function CreateClientWindow()
{
	Super.CreateClientWindow();

	if (winClient != None)
		ComputerUIScaleClientWindow(winClient).SetTextureHeights(TopTextureHeight, MiddleTextureHeight, BottomTextureHeight);
}

// ----------------------------------------------------------------------
// CreateSpecialInfoWindow()
// ----------------------------------------------------------------------

function CreateSpecialInfoWindow()
{
	winSpecialInfo = MenuUISmallLabelWindow(winClient.NewChild(Class'MenuUISmallLabelWindow'));

	winSpecialInfo.SetPos(10, 97);
	winSpecialInfo.SetSize(315, 25);
	winSpecialInfo.SetTextAlignments(HALIGN_Left, VALIGN_Center);
	winSpecialInfo.SetTextMargins(0, 0);
}

// ----------------------------------------------------------------------
// SetNetworkTerminal()
// ----------------------------------------------------------------------

function SetNetworkTerminal(NetworkTerminal newTerm)
{
	Super.SetNetworkTerminal(newTerm);

	if (winTerm.IsA('NetworkTerminalPersonal'))
		btnReturn = winButtonBar.AddButton(EmailButtonLabel, HALIGN_Left);
	else if (winTerm.IsA('NetworkTerminalSecurity'))
		btnReturn = winButtonBar.AddButton(SecurityButtonLabel, HALIGN_Left);

	if (btnReturn != None)
		CreateLeftEdgeWindow();
}

// ----------------------------------------------------------------------
// SetCompOwner()
//
// Loop through the special options and create 'em, baby!
// ----------------------------------------------------------------------

function SetCompOwner(ElectronicDevices newCompOwner)
{
	Super.SetCompOwner(newCompOwner);

	CreateOptionButtons();
}

// ----------------------------------------------------------------------
// CreateOptionButtons()
// ----------------------------------------------------------------------

function CreateOptionButtons()
{
	local int specialIndex;
	local int numOptions;
	local MenuUIChoiceButton winButton;

	// Vanilla Matters
	local Computers comp;
	local string str;

	// Figure out how many special options we have

	// Vanilla Matters: Rewrite because messy.
	comp = Computers( compOwner );
	numOptions = 0;
	for ( specialIndex=0; specialIndex < ArrayCount( comp.specialOptions ); specialIndex++ ) {
		if ( comp.specialOptions[specialIndex].userName == "" || Caps( comp.specialOptions[specialIndex].userName ) == winTerm.GetUserName() ) {
			if ( comp.specialOptions[specialIndex].Text != "" ) {
				winButton = MenuUIChoiceButton( winClient.NewChild( class'MenuUIChoiceButton' ) );
				winButton.SetPos( buttonLeftMargin, firstButtonPosY + ( numOptions * MiddleTextureHeight ) );
				winButton.SetSensitivity( !comp.specialOptions[specialIndex].bAlreadyTriggered );
				winButton.SetWidth( 273 );

				// VM: Add the time cost after the button label.
				str = comp.specialOptions[specialIndex].Text;
				if ( winTerm.bHacked ) {
					if ( VM_timeCost == int( VM_timeCost ) ) {
						str = str @ "(" $ int( VM_timeCost ) $ ")";
					}
					else {
						str = str @ "(" $ class'DeusExWeapon'.static.FormatFloatString( VM_timeCost, 0.1 ) $ ")";
					}
				}
				winButton.SetButtonText( str );

				optionButtons[numOptions].specialIndex = specialIndex;
				optionButtons[numOptions].btnSpecial = winButton;

				numOptions = numOptions + 1;				
			}
		}
	}

	ComputerUIScaleClientWindow(winClient).SetNumMiddleTextures(numOptions);

	// Update the location of the Special Info window and the Status window
	winSpecialInfo.SetPos(10, specialOffsetY + TopTextureHeight + (MiddleTextureHeight * numOptions));
	statusPosY = statusPosYOffset + TopTextureHeight + (MiddleTextureHeight * numOptions);
	AskParentForReconfigure();
}

// ----------------------------------------------------------------------
// UpdateOptionsButtons()
// ----------------------------------------------------------------------

function UpdateOptionsButtons()
{
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
	local bool bHandled;

	// First check to see if one of our Special Options 
	// buttons was pressed
	if (buttonPressed.IsA('MenuUIChoiceButton'))
	{
		ActivateSpecialOption(MenuUIChoiceButton(buttonPressed));
		bHandled = True;	
	}
	else
	{
		bHandled = True;
		switch( buttonPressed )
		{
			case btnLogout:
				CloseScreen("LOGOUT");
				break;

			case btnReturn:
				CloseScreen("RETURN");
				break;

			default:
				bHandled = False;
				break;
		}
	}

	if (bHandled)
		return True;
	else
		return Super.ButtonActivated(buttonPressed);
}

// ----------------------------------------------------------------------
// ActivateSpecialOption()
// ----------------------------------------------------------------------

function ActivateSpecialOption(MenuUIChoiceButton buttonPressed)
{
	local int buttonIndex;
	local int specialIndex;
	local Actor A;

	specialIndex = -1;

	// Loop through the buttons and find a Match!
	for(buttonIndex=0; buttonIndex<arrayCount(optionButtons); buttonIndex++)
	{
		if (optionButtons[buttonIndex].btnSpecial == buttonPressed)
		{
			specialIndex = optionButtons[buttonIndex].specialIndex;

			// Disable this button so the user can't activate this 
			// choice again
			optionButtons[buttonIndex].btnSpecial.SetSensitivity(False);

			break;
		}
	}

	// If we found the matching button, activate the option!
	if (specialIndex != -1)
	{
		// Make sure this option wasn't already triggered
		if (!Computers(compOwner).specialOptions[specialIndex].bAlreadyTriggered)
		{
			if (Computers(compOwner).specialOptions[specialIndex].TriggerEvent != '')
				foreach player.AllActors(class'Actor', A, Computers(compOwner).specialOptions[specialIndex].TriggerEvent)
					A.Trigger(None, player);
		
			if (Computers(compOwner).specialOptions[specialIndex].UnTriggerEvent != '')
				foreach player.AllActors(class'Actor', A, Computers(compOwner).specialOptions[specialIndex].UnTriggerEvent)
					A.UnTrigger(None, player);
		
			if (Computers(compOwner).specialOptions[specialIndex].bTriggerOnceOnly)
				Computers(compOwner).specialOptions[specialIndex].bAlreadyTriggered = True;

			// Display a message			
			winSpecialInfo.SetText(Computers(compOwner).specialOptions[specialIndex].TriggerText);

			// Vanilla Matters: Special options should cost something, not sure if that's appropriate.
			HandleTimeCost();
		}
	}
}

function HandleTimeCost() {
	local int i;
	local Computers comp;

	if ( winTerm.bHacked ) {
		if ( !VM_bHackedAlready ) {
			winTerm.winHack.AddTimeCost( VM_timeCost );
			VM_bHackedAlready = true;

			comp = Computers( compOwner );
			for ( i = 0; i < ArrayCount( optionButtons ); i++ ) {
				if ( optionButtons[i].btnSpecial != none ) {
					optionButtons[i].btnSpecial.SetButtonText( comp.specialOptions[optionButtons[i].specialIndex].Text );
				}
			}
		}
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     buttonLeftMargin=25
     firstButtonPosY=17
     specialOffsetY=16
     statusPosYOffset=50
     TopTextureHeight=12
     MiddleTextureHeight=30
     BottomTextureHeight=75
     SecurityButtonLabel="|&Security"
     EmailButtonLabel="|&Email"
     classClient=Class'DeusEx.ComputerUIScaleClientWindow'
     escapeAction="LOGOUT"
     Title="Special Options"
     ClientWidth=331
     clientTextures(0)=Texture'DeusExUI.UserInterface.ComputerSpecialOptionsBackgroundTop_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.ComputerSpecialOptionsBackgroundTop_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.ComputerSpecialOptionsBackgroundMiddle_1'
     clientTextures(3)=Texture'DeusExUI.UserInterface.ComputerSpecialOptionsBackgroundMiddle_2'
     clientTextures(4)=Texture'DeusExUI.UserInterface.ComputerSpecialOptionsBackgroundBottom_1'
     clientTextures(5)=Texture'DeusExUI.UserInterface.ComputerSpecialOptionsBackgroundBottom_2'
     textureCols=2
     bAlwaysCenter=True
     ComputerNodeFunctionLabel="SpecialOptions"
     VM_timeCost=7.500000
}
