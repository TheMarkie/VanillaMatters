//=============================================================================
// HUDHitDisplay
//=============================================================================
class HUDHitDisplay expands HUDBaseWindow;

// Vanilla Matters: Custom border for FP bar and a window for shield compatible HUD.
#exec TEXTURE IMPORT FILE="Textures\HUDHitDisplayBorder_1.bmp"		NAME="HUDHitDisplayBorder_1"		GROUP="VMUI" MIPS=Off
// #exec TEXTURE IMPORT FILE="Textures\HUDHitDisplayBody.bmp"		NAME="HUDHitDisplay_Body"		GROUP="VMUI" MIPS=Off

struct BodyPart
{
	var Window partWindow;
	var int    lastHealth;
	var int    healHealth;
	var int    displayedHealth;
	var float  damageCounter;
	var float  healCounter;
   var float  refreshCounter;
};

var BodyPart head;
var BodyPart torso;
var BodyPart armLeft;
var BodyPart armRight;
var BodyPart legLeft;
var BodyPart legRight;
var BodyPart armor;

var Color    colArmor;

var float    damageFlash;
var float    healFlash;

var Bool			bVisible;
var DeusExPlayer	player;

// Breathing underwater bar
var ProgressBarWindow winBreath;
var bool	bUnderwater;
var float	breathPercent;

// Energy bar
var ProgressBarWindow winEnergy;
var float	energyPercent;

// Used by DrawWindow
var Color colBar;
var int ypos;

// Defaults
var Texture texBackground;
var Texture texBorder;

var localized string O2Text;
var localized string EnergyText;

// Vanilla Matters
var ProgressBarWindow VM_winFP;

// var VMProgressBarWindow VM_winShield;
// var Color VM_colShield;

var localized string VM_ForwardPressureText;
var localized string VM_ForwardPressureFullText;

// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

event InitWindow()
{
	local window bodyWin;

	Super.InitWindow();

	bTickEnabled = True;

	Hide();

	player = DeusExPlayer(DeusExRootWindow(GetRootWindow()).parentPawn);

	SetSize(84, 106);

	CreateBodyPart(head,     Texture'HUDHitDisplay_Head',     39, 17,  4,  7);
	CreateBodyPart(torso,    Texture'HUDHitDisplay_Torso',    36, 25, 10,  23);
	CreateBodyPart(armLeft,  Texture'HUDHitDisplay_ArmLeft',  46, 27, 10,  23);
	CreateBodyPart(armRight, Texture'HUDHitDisplay_ArmRight', 26, 27, 10,  23);
	CreateBodyPart(legLeft,  Texture'HUDHitDisplay_LegLeft',  41, 44,  8,  36);
	CreateBodyPart(legRight, Texture'HUDHitDisplay_LegRight', 33, 44,  8,  36);

	bodyWin = NewChild(Class'Window');
	bodyWin.SetBackground(Texture'HUDHitDisplay_Body');
	bodyWin.SetBackgroundStyle(DSTY_Translucent);
	bodyWin.SetConfiguration(24, 15, 34, 68);
	bodyWin.SetTileColor(colArmor);
	bodyWin.Lower();

	// Vanilla Matters: Create bar for energy shield.
	// VM_winShield = VMProgressBarWindow( NewChild( Class'VMProgressBarWindow' ) );
	// VM_winShield.UseScaledColor( false );
	// VM_winShield.SetBackgroundStyle( DSTY_Translucent );
	// VM_winShield.SetForegroundTexture( Texture'DeusEx.VMUI.HUDHitDisplay_Body' );
	// VM_winShield.SetSize( 34, 68 );
	// VM_winShield.SetPos( 24, 15 );
	// VM_winShield.SetValues( 0, 100 );
	// VM_winShield.SetCurrentValue( 0 );
	// VM_winShield.SetVertical( true );

	winEnergy = CreateProgressBar(15, 20);
	winBreath = CreateProgressBar(61, 20);

	damageFlash = 0.4;  // seconds
	healFlash   = 1.0;  // seconds

	// Vanilla Matters: Create bar for forward pressure.
	VM_winFP = ProgressBarWindow( NewChild( Class'ProgressBarWindow' ) );
	VM_winFP.UseScaledColor( true );
	VM_winFP.SetSize( 50, 5 );
	VM_winFP.SetPos( 9, 90 );
	VM_winFP.SetValues( 0, 100 );
	VM_winFP.SetCurrentValue( 0 );
	VM_winFP.SetVertical( false );
}

// ----------------------------------------------------------------------
// CreateProgressBar()
// ----------------------------------------------------------------------

function ProgressBarWindow CreateProgressBar(int posX, int posY)
{
	local ProgressBarWindow winProgress;

	winProgress = ProgressBarWindow(NewChild(Class'ProgressBarWindow'));
	winProgress.UseScaledColor(True);
	winProgress.SetSize(5, 55);
	winProgress.SetPos(posX, posY);
	winProgress.SetValues(0, 100);
	winProgress.SetCurrentValue(0);
	winProgress.SetVertical(True);

	return winProgress;
}

// ----------------------------------------------------------------------
// CreateBodyPart()
// ----------------------------------------------------------------------

function CreateBodyPart(out BodyPart part, texture tx, float newX, float newY,
                        float newWidth, float newHeight)
{
	local window newWin;

	newWin = NewChild(Class'Window');
	newWin.SetBackground(tx);
	newWin.SetBackgroundStyle(DSTY_Translucent);
	newWin.SetConfiguration(newX, newY, newWidth, newHeight);
	newWin.SetTileColorRGB(0, 0, 0);

	part.partWindow      = newWin;
	part.displayedHealth = 0;
	part.lastHealth      = 0;
	part.healHealth      = 0;
	part.damageCounter   = 0;
	part.healCounter     = 0;
   part.refreshCounter  = 0;
}

// ----------------------------------------------------------------------
// SetHitColor()
// ----------------------------------------------------------------------

function SetHitColor(out BodyPart part, float deltaSeconds, bool bHide, int hitValue)
{
	local Color col;
	local float mult;

	part.damageCounter -= deltaSeconds;
	if (part.damageCounter < 0)
		part.damageCounter = 0;
	part.healCounter -= deltaSeconds;
	if (part.healCounter < 0)
		part.healCounter = 0;

   part.refreshCounter -= deltaSeconds;

   if ((part.healCounter == 0) && (part.damageCounter == 0) && (part.lastHealth == hitValue) && (part.refreshCounter > 0))
      return;

   if (part.refreshCounter <= 0)
      part.refreshCounter = 0.5;
  
	if (hitValue < part.lastHealth)
	{
		part.damageCounter  = damageFlash;
		part.displayedHealth = hitValue;
	}
	else if (hitValue > part.lastHealth)
	{
		part.healCounter = healFlash;
		part.healHealth = part.displayedHealth;
	}
	part.lastHealth = hitValue;

	if (part.healCounter > 0)
	{
		mult = part.healCounter/healFlash;
		part.displayedHealth = hitValue + (part.healHealth-hitValue)*mult;
	}
	else
	{
		part.displayedHealth = hitValue;
	}

	hitValue = part.displayedHealth;
	col = winEnergy.GetColorScaled(hitValue/100.0);

	if (part.damageCounter > 0)
	{
		mult = part.damageCounter/damageFlash;
		col.r += (255-col.r)*mult;
		col.g += (255-col.g)*mult;
		col.b += (255-col.b)*mult;
	}


	if (part.partWindow != None)
	{
		part.partWindow.SetTileColor(col);
		if (bHide)
		{
			if (hitValue > 0)
				part.partWindow.Show();
			else
				part.partWindow.Hide();
		}
	}
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{
	Super.DrawWindow(gc);

	// Draw energy bar
	gc.SetFont(Font'FontTiny');
	gc.SetTextColor(winEnergy.GetBarColor());
	gc.DrawText(13, 74, 8, 8, EnergyText);

	// If we're underwater draw the breathometer
	if (bUnderwater)
	{
		ypos = breathPercent * 0.55;

		// draw the breath bar
		colBar = winBreath.GetBarColor();

		// draw the O2 text and blink it if really low
		gc.SetFont(Font'FontTiny');
		if (breathPercent < 10)
		{
			if ((player.swimTimer % 0.5) > 0.25)
				colBar.r = 255;
			else
				colBar.r = 0;
		}

		gc.SetTextColor(colBar);
		gc.DrawText(61, 74, 8, 8, O2Text);
	}

	// Vanilla Matters: Draw the FP text only if the player enables FP.
	if ( player.VM_bEnableFP ) {
		gc.SetFont( Font'FontTiny' );
		gc.SetTextColor( VM_winFP.GetBarColor() );
		//gc.DrawText( 1, 87, 8, 8, VM_ForwardPressureText );

		if ( VM_winFP.currentValue >= 100 ) {
			gc.DrawText( 60, 87, 8, 8, VM_ForwardPressureFullText );
		} 
	}
}

// ----------------------------------------------------------------------
// DrawBackground()
// ----------------------------------------------------------------------

function DrawBackground(GC gc)
{
	gc.SetStyle(backgroundDrawStyle);
	gc.SetTileColor(colBackground);
	gc.DrawTexture(11, 11, 60, 76, 0, 0, texBackground);
}

// ----------------------------------------------------------------------
// DrawBorder()
// ----------------------------------------------------------------------

function DrawBorder(GC gc)
{
	if (bDrawBorder)
	{
		gc.SetStyle(borderDrawStyle);
		gc.SetTileColor(colBorder);
		//gc.DrawTexture(0, 0, 84, 106, 0, 0, texBorder);

		// Vanilla Matters: Pick the appropriate border for FP.
		if ( player.VM_bEnableFP ) {
			gc.DrawTexture( 0, 0, 84, 106, 0, 0, Texture'DeusEx.VMUI.HUDHitDisplayBorder_1' );
		}
		else {
			gc.DrawTexture( 0, 0, 84, 106, 0, 0, texBorder );
		}
	}
}

// ----------------------------------------------------------------------
// Tick()
//
// Update the Energy and Breath displays
// ----------------------------------------------------------------------

event Tick(float deltaSeconds)
{
   // DEUS_EX AMSD Server doesn't need to do this.
   if ((player.Level.NetMode != NM_Standalone)  && (!Player.PlayerIsClient()))
   {
      Hide();
      return;
   }
	if ((player != None) && ( bVisible ))
	{
		SetHitColor(head,     deltaSeconds, false, player.HealthHead);
		SetHitColor(torso,    deltaSeconds, false, player.HealthTorso);
		SetHitColor(armLeft,  deltaSeconds, false, player.HealthArmLeft);
		SetHitColor(armRight, deltaSeconds, false, player.HealthArmRight);
		SetHitColor(legLeft,  deltaSeconds, false, player.HealthLegLeft);
		SetHitColor(legRight, deltaSeconds, false, player.HealthLegRight);

		// Calculate the energy bar percentage
		energyPercent = 100.0 * (player.Energy / player.EnergyMax);
		winEnergy.SetCurrentValue(energyPercent);
		
		// If we're underwater, draw the breath bar
		if (bUnderwater)
		{
			// if we are already underwater
			if (player.HeadRegion.Zone.bWaterZone)
			{
				// if we are still underwater
				breathPercent = 100.0 * player.swimTimer / player.swimDuration;
				breathPercent = FClamp(breathPercent, 0.0, 100.0);
			}
			else
			{
				// if we are getting out of the water
				bUnderwater = False;
				breathPercent = 100;
			}
		}
		else if (player.HeadRegion.Zone.bWaterZone)
		{
			// if we just went underwater
			bUnderwater = True;
			breathPercent = 100;
		}

		// Now show or hide the breath meter
		if (bUnderwater)
		{
			if (!winBreath.IsVisible())
				winBreath.Show();

			winBreath.SetCurrentValue(breathPercent);
		}
		else
		{
			if (winBreath.IsVisible())
				winBreath.Hide();
		}

		// Vanilla Matters: Update shield value.
		// VM_winShield.SetCurrentValue( ( player.VM_Shield / player.VM_CurrentMaxShield ) * 100 );
		// VM_winShield.SetColors( VM_winShield.colBackground, VM_colShield );

		// Vanilla Matters: Update FP value only if it's enabled, otherwise hide the bar.
		if ( player.VM_bEnableFP && player.FPSystem != none ) {
			if ( !VM_winFP.IsVisible() ) {
				VM_winFP.Show();
			}

			VM_winFP.SetCurrentValue( player.FPSystem.GetForwardPressure() );
		}
		else if ( VM_winFP.IsVisible() ) {
			VM_winFP.Hide();
		}

		Show();
	}
	else
		Hide();
}

// ----------------------------------------------------------------------
// SetVisibility()
// ----------------------------------------------------------------------

function SetVisibility( bool bNewVisibility )
{
	bVisible = bNewVisibility;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     colArmor=(R=255,G=255,B=255)
     texBackground=Texture'DeusExUI.UserInterface.HUDHitDisplayBackground_1'
     texBorder=Texture'DeusExUI.UserInterface.HUDHitDisplayBorder_1'
     O2Text="O2"
     EnergyText="BE"
     VM_ForwardPressureText="FP"
     VM_ForwardPressureFullText="OK"
}
