//=============================================================================
// PersonaAugmentationBar
//=============================================================================
class PersonaAugmentationBar expands HUDBaseWindow;

var DeusExPlayer player;

var TileWindow slotWnd;
var PersonaAugmentationBarSlot augs[10];

var bool interactive;

var Texture texBackgroundLeft;
var Texture texBackgroundRight;
var Texture texBorder[3];

// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

function InitWindow() {
	Super.InitWindow();

	SetSize( 541, 69 );

	player = DeusExPlayer( GetRootWindow().parentPawn );
	
	CreateSlots();

	PopulateBar();
}

// ----------------------------------------------------------------------
// CreateSlots()
// ----------------------------------------------------------------------

function CreateSlots() {
	local int i;
	local RadioBoxWindow winRadio;

	winRadio = RadioBoxWindow( NewChild( Class'RadioBoxWindow' ) );
	winRadio.SetSize( 504, 54 );
	winRadio.SetPos( 10, 6 );
	winRadio.bOneCheck = false;

	slotWnd = TileWindow( winRadio.NewChild( Class'TileWindow' ) );
	slotWnd.SetMargins( 0, 0 );
	slotWnd.SetMinorSpacing( 0 );
	slotWnd.SetOrder( ORDER_LeftThenUp );

	for ( i = 0; i < 10; i++ ) {
		augs[i] = PersonaAugmentationBarSlot( slotWnd.NewChild( Class'PersonaAugmentationBarSlot' ) );
		augs[i].SetSlot( i );
		augs[i].Lower();

		if ( i == 9 ) {
			augs[i].SetWidth( 44 );
		}
	}

	augs[9].Lower();
}

// ----------------------------------------------------------------------
// DrawBackground()
// ----------------------------------------------------------------------

function DrawBackground( GC gc ) {
	gc.SetStyle( backgroundDrawStyle );
	gc.SetTileColor(colBackground);
	gc.DrawTexture( 2, 6, 9, 54, 0, 0, texBackgroundLeft );
	gc.DrawTexture( 514, 6, 8, 54, 0, 0, texBackgroundRight );
}

// ----------------------------------------------------------------------
// DrawBorder()
// ----------------------------------------------------------------------

function DrawBorder( GC gc ) {
	if ( bDrawBorder ) {
		gc.SetStyle( borderDrawStyle );

		gc.DrawTexture( 0, 0, 256, 69, 0, 0, texBorder[0] );
		gc.DrawTexture( 256, 0, 256, 69, 0, 0, texBorder[1] );
		gc.DrawTexture( 512, 0,  29, 69, 0, 0, texBorder[2] );
	}
}

// ----------------------------------------------------------------------
// IsValid()
// ----------------------------------------------------------------------

function bool IsValid( int pos ) {
	return ( pos >= 0 && pos < 10 );
}

// ----------------------------------------------------------------------
// ClearPosition()
// ----------------------------------------------------------------------

function ClearPosition( int pos ) {
	if ( IsValid( pos ) ) {
		augs[pos].SetAug( none );
	}
}

// ----------------------------------------------------------------------
// Clear()
// ----------------------------------------------------------------------

function ClearBar() {
	local int i;

	for( i = 0; i < 10; i++ ) {
		ClearPosition( i );
	}
}

// ----------------------------------------------------------------------
// RemoveAug()
// ----------------------------------------------------------------------

function RemoveAug( Augmentation aug ) {
	local int i;

	for ( i = 0; i < 10; i++ ) {
		if ( augs[i].GetAug() == aug ) {
			augs[i].SetAug( none );
		}
	}
}

// ----------------------------------------------------------------------
// AddAug()
// ----------------------------------------------------------------------

function bool AddAug( Augmentation aug, int pos ) {
	local int  i;
	local int FirstPos;
	local bool retval;

	retval = true;
	if ( aug != None ) {
		if ( IsValid( pos ) ) {
			RemoveAug( aug );

			if ( augs[pos].GetAug() != none ) {
				ClearPosition( pos );
			}

			augs[pos].SetAug( aug );
		}
		else {
			retval = false;
		}
	}
	else {
		retval = false;
	}

	return retval;
}

// ----------------------------------------------------------------------
// SwapAug()
// ----------------------------------------------------------------------

function SwapAug( PersonaAugmentationBarSlot slot1, PersonaAugmentationBarSlot slot2 ) {
	local int pos1, pos2;
	local Augmentation aug1, aug2;

	if ( slot1 == slot2 ) {
		return;
	}

	pos1 = slot1.slot;
	pos2 = slot2.slot;

	aug1 = slot1.aug;
	aug2 = slot2.aug;

	ClearPosition( pos1 );

	if ( aug2 != none ) {
		ClearPosition( pos2 );
	}

	AddAug( aug1, pos2 );

	if ( aug2 != none ) {
		AddAug( aug2, pos1 );
	}
}

// ----------------------------------------------------------------------
// GetAug()
// ----------------------------------------------------------------------

function Augmentation GetAug( int pos ) {
	if ( IsValid( pos ) ) {
		return ( augs[pos].GetAug() );
	}
	else {
		return none;
	}
}

// ----------------------------------------------------------------------
// GetSlot()
// ----------------------------------------------------------------------

function PersonaAugmentationBarSlot GetSlot( Augmentation aug ) {
	local int i;

	for ( i = 0; i < 10; i++ ) {
		if ( augs[i].aug == aug ) {
			return augs[i];
		}
	}

	return none;
}

// ----------------------------------------------------------------------
// PopulateBar()
// ----------------------------------------------------------------------

function PopulateBar() {
	local int i;
	local AugmentationManager manager;

	manager = player.AugmentationSystem;
	if ( manager != none ) {
		for ( i = 0; i < 10; i++ ) {
			if ( manager.VM_augSlots[i] != none ) {
				AddAug( manager.VM_augSlots[i], i );
			}
		}
	}
}

// ----------------------------------------------------------------------
// AssignWinInv()
// ----------------------------------------------------------------------

function SetAugWnd( PersonaScreenAugmentations augWnd ) {
	local int i;

	for ( i = 0; i < 10; i++ ) {
		augs[i].SetAugWnd( augWnd );
	}
}

// ----------------------------------------------------------------------
// SelectAug()
// ----------------------------------------------------------------------

function SelectAug( Augmentation aug, bool bNewToggle ) {
	local int i;

	for ( i = 0; i < 10; i++ ) {
		if ( augs[i].aug == aug ) {
			if ( !augs[i].GetToggle() ) {
				augs[i].SetToggle( bNewToggle );
			}
		}
		else {
			augs[i].SetToggle( false );		
			augs[i].HighlightSelect( false );
		}
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     texBackgroundLeft=Texture'DeusExUI.UserInterface.HUDObjectBeltBackground_Left'
     texBackgroundRight=Texture'DeusExUI.UserInterface.HUDObjectBeltBackground_Right'
     texBorder(0)=Texture'DeusExUI.UserInterface.HUDObjectBeltBorder_1'
     texBorder(1)=Texture'DeusExUI.UserInterface.HUDObjectBeltBorder_2'
     texBorder(2)=Texture'DeusExUI.UserInterface.HUDObjectBeltBorder_3'
}
