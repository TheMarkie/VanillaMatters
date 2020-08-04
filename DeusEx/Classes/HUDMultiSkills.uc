//=============================================================================
// HUDMultiSkills - In game skill selection for multiplayer
//=============================================================================

class HUDMultiSkills extends HUDBaseWindow;

const   skillListX  = 0.01;             // Screen multiplier
const skillListY    = 0.38;
const skillMsgY = 0.7;
const   skillCostX  = 0.25;
const skillLevelX   = 0.19;
const levelBoxSize = 5;

var localized String        ToExitString;
var localized String        SkillsAvailableString;
var localized String        PressString, PressEndString;
var localized String        SkillPointsString;
var localized String        SkillString;
var localized String        CostString;
var localized String        NAString;
var localized String        LevelString;
var localized String        KeyNotBoundString;

var Color   colBlue, colWhite;
var Color   colGreen, colLtGreen;
var Color   colRed, colLtRed;

const TimeDelay = 10;
var bool                bNotifySkills;
var int             timeToNotify;
var int             curSkillPoints;
var String          curKeyName;

// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

event InitWindow()
{
    Super.InitWindow();
    SetWindowAlignments( HALIGN_Full, VALIGN_Full );
    bNotifySkills = False;
    RefreshKey();
}

// ----------------------------------------------------------------------
// RefreshKey
// ----------------------------------------------------------------------

function RefreshKey()
{
    local String KeyName, Alias;
    local int i;

    curKeyName = "";
    for ( i=0; i<255; i++ )
    {
        KeyName = player.ConsoleCommand ( "KEYNAME "$i );
        if ( KeyName != "" )
        {
            Alias = player.ConsoleCommand( "KEYBINDING "$KeyName );
            if ( Alias ~= "BuySkills" )
            {
                curKeyName = KeyName;
                break;
            }
        }
    }
    if ( curKeyName ~= "" )
        curKeyName = KeyNotBoundString;
}

// ----------------------------------------------------------------------
// DestroyWindow()
// ----------------------------------------------------------------------

event DestroyWindow()
{
    Super.DestroyWindow();
}

// ----------------------------------------------------------------------
function DrawLevel( GC gc, float x, float y, int level )
{
    local int i;

    if (( level < 0 ) || (level > 3 ))
    {
        log("Warning:Bad skill level:"$level$" " );
        return;
    }
    for ( i = 0; i < level; i++ )
    {
        gc.DrawTexture( x, y+2.0, levelBoxSize, levelBoxSize, 0, 0, Texture'Solid');
        x += (levelBoxSize + levelBoxSize/2);
    }
}

// ----------------------------------------------------------------------
// SkillMessage()
// ----------------------------------------------------------------------
function SkillMessage( GC gc )
{
    local bool bShowMsg, bSkillAvail;
    local float curx, cury, w, h, w2, t, offset;
    local String str;

    // Vanilla Matters
    local VMSkillInfo info;

    if ( curSkillPoints != Player.SkillPointsAvail )
        bNotifySkills = False;

    bSkillAvail = False;
    // Vanilla Matters
    info = Player.GetFirstSkillInfo();
    while ( info != none ) {
        if ( info.CanUpgrade( Player.SkillPointsAvail ) ) {
            bSkillAvail = True;
            break;
        }

        info = info.Next;
    }

    if ( bSkillAvail )
    {
        if ( !bNotifySkills )
        {
            RefreshKey();
            timeToNotify = Player.Level.Timeseconds + TimeDelay;
            curSkillPoints = Player.SkillPointsAvail;
            Player.BuySkillSound( 3 );
            bNotifySkills = True;
        }
        if ( timeToNotify > Player.Level.Timeseconds )
        {
            // Flash them to draw a little more attention 1.5 on .5 off
            if ( (Player.Level.Timeseconds % 1.5) < 1 )
            {
                offset = 0;
                gc.SetFont(Font'FontMenuSmall_DS');
                cury = height * skillMsgY;
                curx = width * skillListX;
                str = PressString $ curKeyName $ PressEndString;
                gc.GetTextExtent( 0, w, h, SkillsAvailableString );
                gc.GetTextExtent( 0, w2, h, str );
                if ( (curx + ((w-w2)*0.5)) < 0 )
                    offset = -(curx + ((w-w2)*0.5));
                gc.SetTextColor( colLtGreen );
                gc.GetTextExtent( 0, w, h, SkillsAvailableString );
                gc.DrawText( curx+offset, cury, w, h, SkillsAvailableString );
                cury +=  h;
                gc.GetTextExtent( 0, w2, h, str );
                curx += ((w-w2)*0.5);
                gc.DrawText( curx+offset, cury, w2, h, str );
            }
        }
    }
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{
    local float curx, cury, w, h;
    local String str, costStr;
    local int index;
    local bool bHitSwimming;
    local float barLen, costx, levelx;

    // Vanilla Matters
    local VMSkillInfo info;

    bHitSwimming = False;

    if (( Player == None ) || (!Player.PlayerIsClient()) )
        return;

    if ( Player.bBuySkills )
    {
        // Vanilla Matters
        if ( Player != None )
        {
            gc.SetFont(Font'FontMenuSmall_DS');
            index = 1;
            cury = height * skillListY;
            curx = width * skillListX;
            costx = width * skillCostX;
            levelx = width * skillLevelX;
            gc.GetTextExtent( 0, w, h, CostString );
            barLen = (costx+(w*1.33))-curx;
            gc.DrawBox( curx, cury, barLen, 1, 0, 0, 1, Texture'Solid');
            cury += (h*0.25);
            str = SkillPointsString $ Player.SkillPointsAvail;
            gc.GetTextExtent( 0, w, h, str );
            gc.DrawText( curx, cury, w, h, str );
            cury += h;
            gc.DrawBox( curx, cury, barLen, 1, 0, 0, 1, Texture'Solid');
            cury += (h*0.25);
            str = SkillString;
            gc.GetTextExtent( 0, w, h, str );
            gc.DrawText( curx, cury, w, h, str );
            str = LevelString;
            gc.GetTextExtent( 0, w, h, str );
            gc.DrawText( levelx, cury, w, h, str );
            str = CostString;
            gc.GetTextExtent( 0, w, h, str );
            gc.DrawText( costx, cury, w, h, str );
            cury += h;
            gc.DrawBox( curx, cury, barLen, 1, 0, 0, 1, Texture'Solid');
            cury += (h*0.25);

            // Vanilla Matters
            info = player.GetFirstSkillInfo();
            while ( info != None ) {
                if ( index == 10 ) {
                    str = "0. " $ info.GetName();
                }
                else {
                    str = index $ ". " $ info.GetName();
                }

                gc.GetTextExtent( 0, w, h, str );
                if ( info.Level == 3)
                {
                    gc.SetTileColor( colBlue );
                    gc.SetTextColor( colBlue );
                    costStr = NAString;
                }
                else if ( info.CanUpgrade( Player.SkillPointsAvail ) )
                {
                    if ( info.Level == 2)
                    {
                        gc.SetTextColor( colLtGreen );
                        gc.SetTileColor( colLtGreen );
                    }
                    else
                    {
                        gc.SetTextColor( colGreen );
                        gc.SetTileColor( colGreen );
                    }
                    costStr = "" $ info.GetNextLevelCost();
                }
                else
                {
                    if ( info.Level == 2)
                    {
                        gc.SetTileColor( colLtRed );
                        gc.SetTextColor( colLtRed );
                    }
                    else
                    {
                        gc.SetTileColor( colRed );
                        gc.SetTextColor( colRed );
                    }
                    costStr = "" $ info.GetNextLevelCost();
                }
                gc.DrawText( curx, cury, w, h, str );
                DrawLevel( gc, levelx, cury, info.Level );
                gc.GetTextExtent(   0, w, h, costStr );
                gc.DrawText( costx, cury, w, h, costStr );
                cury += h;
                index += 1;

                info = info.Next;
            }
            gc.SetTileColor( colWhite );
            if ( curKeyName ~= KeyNotBoundString )
                RefreshKey();
            str = PressString $ curKeyName $ ToExitString;
            gc.GetTextExtent( 0, w, h, str );
            gc.DrawBox( curx, cury, barLen, 1, 0, 0, 1, Texture'Solid');
            cury += (h*0.25);
            gc.SetTextColor( colWhite );
            gc.DrawText( curx + ((barLen*0.5)-(w*0.5)), cury, w, h, str );
            cury += h;
            gc.DrawBox( curx, cury, barLen, 1, 0, 0, 1, Texture'Solid');
        }
    }
    else
        SkillMessage( gc );

    Super.DrawWindow(gc);
}

// ----------------------------------------------------------------------
// GetSkillFromIndex()
// ----------------------------------------------------------------------
// Vanilla Matters
function VMSkillInfo GetSkillFromIndex( DeusExPlayer thisPlayer, int index ) {
    local int curIndex;
    local VMSkillInfo info;

    // Zero indexed, but min element is 1, 0 is 10
    if ( index == 0 ) {
        index = 9;
    }
    else {
        index -= 1;
    }

    info = thisPlayer.GetFirstSkillInfo();
    while ( info != None )
    {
        if ( curIndex == index ) {
            return info;
        }

        curIndex += 1;
        info = info.Next;
    }

    return info;
}

// ----------------------------------------------------------------------
// AttemptBuySkill()
// ----------------------------------------------------------------------
// Vanilla Matters
function bool AttemptBuySkill( DeusExPlayer thisPlayer, name name ) {
    if ( info != None ) {
        if ( info.CanUpgrade( thisPlayer.SkillPointsAvail ) ) {
            thisPlayer.BuySkillSound( 0 );
            return thisPlayer.IncreaseSkillLevel( name );
        }
        else {
            thisPlayer.BuySkillSound( 1 );
            return false;
        }
    }
}

// ----------------------------------------------------------------------
// OverrideBelt()
// ----------------------------------------------------------------------
// Vanilla Matters
function bool OverrideBelt( DeusExPlayer thisPlayer, int objectNum ) {
    local VMSkillInfo info;

    if ( !thisPlayer.bBuySkills ) {
        return false;
    }

    info = GetSkillFromIndex( thisPlayer, objectNum );
    if ( AttemptBuySkill( thisPlayer, info.DefinitionClassName ) ) {
        thisPlayer.bBuySkills = false;      // Got our skill, exit out of menu
    }

    if ( ( objectNum >= 0 ) && ( objectNum <= 10) ) {
        return true;
    }
    else {
        return false;
    }
}

defaultproperties
{
     ToExitString="> to exit."
     SkillsAvailableString="Skills available!"
     PressString="Press <"
     PressEndString=">"
     SkillPointsString="Skill Points: "
     skillString="Skill"
     CostString="Cost"
     NAString="MAX"
     LevelString="Level"
     KeyNotBoundString="Key Not Bound"
     colBlue=(B=255)
     colWhite=(R=255,G=255,B=255)
     colGreen=(G=128)
     colLtGreen=(G=255)
     colRed=(R=128)
     colLtRed=(R=255)
}
