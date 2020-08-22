class VMAugmentationManager extends VMUpgradeManager;

var travel VMAugmentationInfo FirstAugmentationInfo;
var private transient bool _refreshed;

var localized string EnergyRateLabel;
var localized string OccupiesSlotLabel;
var localized string AlreadyAtMax;
var localized string NowUpgraded;
var localized string NowAtLevel;
var localized string PassiveLabel;
var localized string CanUpgradeLabel;
var localized string CurrentLevelLabel;
var localized string MaximumLabel;

//==============================================
// Management
//==============================================
function bool Add( name name, optional int startingLevel ) {
    local VMAugmentationInfo info;

    if ( GetInfo( name ) != none ) {
        return false;
    }

    info = new class'VMAugmentationInfo';
    info.Initialize( name, startingLevel );
    info.Refresh( Player );

    info.Next = FirstAugmentationInfo;
    FirstAugmentationInfo = info;

    return true;
}

function Refresh( VMPlayer playerOwner ) {
    local VMAugmentationInfo info;

    super.Refresh( playerOwner );

    info = FirstAugmentationInfo;
    while ( info != none ) {
        info.Refresh( Player, info.IsActive );

        info = info.Next;
    }

    _refreshed = true;
}

function Reset() {
    local VMAugmentationInfo info;

    info = FirstAugmentationInfo;
    while ( info != none ) {
        info.Level = 0;
        info.Refresh( Player );

        info = info.Next;
    }
}

//==============================================
// Augmentation Display
//==============================================
function RefreshDisplay() {
    local VMAugmentationInfo info;

    info = FirstAugmentationInfo;
    while ( info != none ) {
        player.UpdateAugmentationDisplay( info, info.IsActive );

        info = info.Next;
    }
}

function UpdateInfo( VMAugmentationInfo info, PersonaInfoWindow winInfo ) {
    local string str;

    if ( winInfo == none ) {
        return;
    }

    winInfo.Clear();
    winInfo.SetTitle( info.GetName() );
    winInfo.SetText( info.GetDescription() );

    // Energy Rate
    winInfo.AppendText( winInfo.CR() $ winInfo.CR() $ Sprintf( EnergyRateLabel, int( info.GetCurrentRate() ) ) );

    // Current Level
    str = Sprintf( CurrentLevelLabel, info.Level + 1 );

    // Can Upgrade / Is Active
    if ( info.CanUpgrade() ) {
        str = str @ CanUpgradeLabel;
    }
    else if ( info.Level >= info.GetMaxLevel() ) {
        str = str @ MaximumLabel;
    }

    winInfo.AppendText( winInfo.CR() $ winInfo.CR() $ str );

    // Is Passive
    if ( info.IsPassive() ) {
        winInfo.AppendText( winInfo.CR() $ winInfo.CR() $ PassiveLabel );
    }
}


//==============================================
// Augmentation Management
//==============================================
function VMAugmentationInfo GetInfo( name name ) {
    local VMAugmentationInfo info;

    if ( name == '' ) {
        return info;
    }

    info = FirstAugmentationInfo;
    while ( info != none ) {
        if ( info.DefinitionClassName == name ) {
            break;
        }

        info = info.Next;
    }

    return info;
}

function bool IncreaseLevel( name name ) {
    local VMAugmentationInfo info;

    info = GetInfo( name );
    if ( info != none ) {
        return info.IncreaseLevel();
    }

    return false;
}
function bool DecreaseLevel( name name ) {
    local VMAugmentationInfo info;

    info = GetInfo( name );
    if ( info != none ) {
        return info.DecreaseLevel();
    }

    return false;
}

function IncreaseAllToMax() {
    local VMAugmentationInfo info;

    info = FirstAugmentationInfo;
    while ( info != none ) {
        info.Level = info.GetMaxLevel();
        info.Refresh( Player );

        info = info.Next;
    }
}

//==============================================
// Augmentation Activation/Deactivation
//==============================================
function Set( name name, bool active ) {
    local VMAugmentationInfo info;

    if ( Player == none ) {
        return;
    }

    info = GetInfo( name );
    if ( info != none ) {
        info.Toggle( Player, active );
    }
}
function Toggle( name name ) {
    local VMAugmentationInfo info;

    if ( Player == none ) {
        return;
    }

    info = GetInfo( name );
    if ( info != none ) {
        info.Toggle( Player, !info.IsActive );
    }
}

function ActivateAll() {
    local VMAugmentationInfo info;

    info = FirstAugmentationInfo;
    while ( info != none ) {
        info.Refresh( Player, true );

        info = info.Next;
    }
}
function DeactivateAll() {
    local VMAugmentationInfo info;

    info = FirstAugmentationInfo;
    while ( info != none ) {
        info.Refresh( Player );

        info = info.Next;
    }
}

function bool IsActive( name name ) {
    local VMAugmentationInfo info;

    info = GetInfo( name );
    if ( info != none ) {
        return info.IsActive;
    }

    return false;
}

//==============================================
// Values
//==============================================
function float GetValue( name name, optional float defaultValue ) {
    local VMAugmentationInfo info;

    info = GetInfo( name );
    if ( info != none ) {
        if ( info.IsActive ) {
            return info.GetValue();
        }
    }

    return -1;
}

function int GetLevel( name name ) {
    local VMAugmentationInfo info;

    info = GetInfo( name );
    if ( info != none ) {
        if ( info.IsActive ) {
            return info.Level;
        }
    }

    return -1;
}

//==============================================
// Misc
//==============================================
function float GetTotalRate( float deltaTime ) {
    local VMAugmentationInfo info;
    local float rate;

    info = FirstAugmentationInfo;
    while ( info != none ) {
        if ( info.IsActive ) {
            rate += info.GetCurrentRate();
        }

        info = info.Next;
    }

    return ( ( rate / 60 ) * deltaTime );
}

//==============================================
// Callbacks
//==============================================
function Tick( float deltaTime ) {
    local VMAugmentationInfo info;

    if ( !_refreshed ) {
        return;
    }

    info = FirstAugmentationInfo;
    while ( info != none ) {
        if ( info.IsActive && info.NeedsTick() ) {
            info.Tick( Player, deltaTime );
        }

        info = info.Next;
    }
}

defaultproperties
{
     EnergyRateLabel="Energy Rate: %d Units/Minute"
     OccupiesSlotLabel="Occupies Slot: %s"
     AlreadyAtMax="You already have the %s at the maximum level"
     NowUpgraded="%s upgraded to level %d"
     NowAtLevel="Augmentation %s at level %d"
     PassiveLabel="[Passive]"
     CanUpgradeLabel="(Can Upgrade)"
     CurrentLevelLabel="Current Level: %d"
     MaximumLabel="(Maximum)"
}
