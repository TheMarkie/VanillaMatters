//=============================================================================
// MenuChoice_Decals
//=============================================================================

class MenuChoice_Decals extends MenuChoice_OnOff;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
    local String detailString;
    local int enumIndex;
    local int detailChoice;

    detailString = player.ConsoleCommand("get " $ configSetting);
    detailChoice = 0;

    for (enumIndex=0; enumIndex<arrayCount(FalseTrue); enumIndex++)
    {
        if (FalseTrue[enumIndex] == detailString)
        {
            detailChoice = enumIndex;
            break;
        }
    }

    SetValue(detailChoice);
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
    player.ConsoleCommand("set " $ configSetting $ " " $ FalseTrue[GetValue()]);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     defaultValue=1
     defaultInfoWidth=98
     HelpText="Disabling Decals may improve performance on slower machines"
     actionText="D|&ecals"
     configSetting="ini:Engine.Engine.ViewportManager Decals"
}
