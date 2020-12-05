class VMAugmentationManager extends VMUpgradeManager;

var private transient bool _refreshed;

var travel VMAugmentationInfo FirstAugmentationInfo;

var travel int InstallLocationCounts[7];
var int InstallLocationMaxCounts[7];

var localized string EnergyRateLabel;
var localized string OccupiesLocationLabel;
var localized string AlreadyAtMax;
var localized string NowUpgraded;
var localized string NowAtLevel;
var localized string PassiveLabel;
var localized string CanUpgradeLabel;
var localized string CurrentLevelLabel;
var localized string MaximumLabel;
var localized string AugmentationLocationLabels[7];

//==============================================
// Management
//==============================================
function bool Add( name className, name packageName, optional int startingLevel ) {
    local VMAugmentationInfo info;

    if ( GetInfo( name ) != none ) {
        return false;
    }

    info = new class'VMAugmentationInfo';
    info.Initialize( className, packageName, startingLevel );
    info.LoadBehaviour( self );
    info.Refresh( Player );

    info.Next = FirstAugmentationInfo;
    FirstAugmentationInfo = info;
    InstallLocationCounts[info.GetInstallLocation()] += 1;

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
        if ( !info.IsPassive() ) {
            player.UpdateAugmentationDisplay( info, info.IsActive );
        }

        info = info.Next;
    }
}

function GetFullDescription( VMAugmentationInfo info, PersonaInfoWindow winInfo ) {
    local string str;

    winInfo.Clear();
    winInfo.SetTitle( info.GetName() );
    winInfo.SetText( info.GetDescription() );

    // Install Location
    winInfo.AppendText( winInfo.CR() $ winInfo.CR() $ Sprintf( OccupiesLocationLabel, AugmentationLocationLabels[info.GetInstallLocation()] ) );

    // Energy Rate
    winInfo.AppendText( winInfo.CR() $ winInfo.CR() $ Sprintf( EnergyRateLabel, int( info.GetRate() ) ) );

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

function GetBaseDescription( class<VMAugmentation> augClass, PersonaInfoWindow winInfo ) {
    local string str;

    winInfo.Clear();
    winInfo.SetTitle( augClass.default.UpgradeName );
    winInfo.SetText( augClass.default.Description );

    // Install Location
    winInfo.AppendText( winInfo.CR() $ winInfo.CR() $ Sprintf( OccupiesLocationLabel, AugmentationLocationLabels[augClass.default.InstallLocation] ) );

    // Is Passive
    if ( augClass.default.IsPassive ) {
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
    if ( info != none && info.IncreaseLevel() ) {
        if ( info.IsActive ) {
            info.Deactivate();
            info.Activate();
        }

        return true;
    }

    return false;
}
function bool DecreaseLevel( name name ) {
    local VMAugmentationInfo info;

    info = GetInfo( name );
    if ( info != none && info.DecreaseLevel() ) {
        if ( info.IsActive ) {
            info.Deactivate();
            info.Activate();
        }

        return true;
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

    Player.ClearAugmentationDisplay();
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
function float GetTotalRate( float deltaTime ) {
    local VMAugmentationInfo info;
    local float rate;

    info = FirstAugmentationInfo;
    while ( info != none ) {
        if ( info.IsActive ) {
            rate += info.GetRate();
        }

        info = info.Next;
    }

    return ( ( rate / 60 ) * deltaTime );
}

function int GetLevel( name name ) {
    local VMAugmentationInfo info;

    info = GetInfo( name );
    if ( info != none ) {
        return info.Level;
    }

    return -1;
}

//==============================================
// Misc
//==============================================
function bool IsLocationFull( int loc ) {
    return InstallLocationCounts[loc] >= default.InstallLocationMaxCounts[loc];
}

function class<VMAugmentation> GetAugmentationDefinition( name name ) {
    if ( name == '' ) {
        return none;
    }

    return class<VMAugmentation>( DynamicLoadObject( "DeusEx." $ string( name ), class'Class' ) );
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
        if ( info.IsActive ) {
            info.Tick( deltaTime );
        }

        info = info.Next;
    }
}

defaultproperties
{
     InstallLocationMaxCounts(0)=3
     InstallLocationMaxCounts(1)=1
     InstallLocationMaxCounts(2)=1
     InstallLocationMaxCounts(3)=3
     InstallLocationMaxCounts(4)=1
     InstallLocationMaxCounts(5)=1
     InstallLocationMaxCounts(6)=2
     EnergyRateLabel="Energy Rate: %d Units/Minute"
     OccupiesLocationLabel="Occupies Location: %s"
     AlreadyAtMax="You already have the %s at the maximum level"
     NowUpgraded="%s upgraded to level %d"
     NowAtLevel="Augmentation %s at level %d"
     PassiveLabel="[Passive]"
     CanUpgradeLabel="(Can Upgrade)"
     CurrentLevelLabel="Current Level: %d"
     MaximumLabel="(Maximum)"
     AugmentationLocationLabels(0)="Core"
     AugmentationLocationLabels(1)="Cranial"
     AugmentationLocationLabels(2)="Eyes"
     AugmentationLocationLabels(3)="Torso"
     AugmentationLocationLabels(4)="Arms"
     AugmentationLocationLabels(5)="Legs"
     AugmentationLocationLabels(6)="Subdermal"
}
