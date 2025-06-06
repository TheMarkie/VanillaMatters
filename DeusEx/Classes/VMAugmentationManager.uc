class VMAugmentationManager extends VMUpgradeManager;

var private transient bool refreshed;

var travel VMAugmentationInfo FirstAugmentationInfo;

// Event handlers
var transient array<VMAugmentationBehaviour> ProcessMoveHandlers;
var transient array<VMAugmentationBehaviour> ParseLeftClickHandlers;
var transient array<VMAugmentationBehaviour> TakeDamageHandlers;
var transient array<VMAugmentationBehaviour> OnDamageTakenHandlers;

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
function VMAugmentationInfo Add( name className, name packageName, optional int startingLevel ) {
    local VMAugmentationInfo info;

    if ( GetInfo( className ) != none ) {
        return none;
    }

    info = new class'VMAugmentationInfo';
    info.Initialize( className, packageName, startingLevel );
    info.LoadBehaviour( self );
    info.Refresh( self, Player );
    info.Next = FirstAugmentationInfo;
    FirstAugmentationInfo = info;
    InstallLocationCounts[info.GetInstallLocation()] += 1;

    return info;
}

function Refresh( VMPlayer playerOwner ) {
    local VMAugmentationInfo info;

    super.Refresh( playerOwner );

    info = FirstAugmentationInfo;
    while ( info != none ) {
        info.Refresh( self, Player, info.IsActive );
        info = info.Next;
    }

    refreshed = true;
}

function Reset() {
    local VMAugmentationInfo info;

    info = FirstAugmentationInfo;
    while ( info != none ) {
        info.Level = 0;
        info.Deactivate();
        info.Refresh( self, Player );
        info = info.Next;
    }
}

//==============================================
// Augmentation Events
//==============================================
function float TickAll( float deltaTime ) {
    local VMAugmentationInfo info;
    local float rate;

    info = FirstAugmentationInfo;
    while ( info != none ) {
        rate += info.Tick( deltaTime );
        info = info.Next;
    }

    return rate;
}

function bool ProcessMove( float deltaTime ) {
    local int i, count;
    local bool handled;
    local VMAugmentationBehaviour behaviour;

    count = #ProcessMoveHandlers;
    for ( i = 0; i < count; i++ ) {
        behaviour = ProcessMoveHandlers[i];
        if ( behaviour.Info.IsActive ) {
            handled = handled || behaviour.ProcessMove( deltaTime );
        }
    }

    return handled;
}

function bool ParseLeftClick() {
    local int i, count;
    local bool handled;
    local VMAugmentationBehaviour behaviour;

    count = #ParseLeftClickHandlers;
    for ( i = 0; i < count; i++ ) {
        behaviour = ParseLeftClickHandlers[i];
        if ( behaviour.Info.IsActive ) {
            handled = handled || behaviour.ParseLeftClick();
        }
    }

    return handled;
}

function bool HandleTakeDamage( out int damage, name damageType, Pawn attacker, Vector hitLocation ) {
    local int i, count;
    local bool handled;
    local VMAugmentationBehaviour behaviour;

    count = #TakeDamageHandlers;
    for ( i = 0; i < count; i++ ) {
        behaviour = TakeDamageHandlers[i];
        if ( behaviour.Info.IsActive ) {
            handled = handled || behaviour.TakeDamage( damage, damageType, attacker, hitLocation );
        }
    }

    return handled;
}

function HandleOnDamageTaken( int damage, name damageType, Pawn attacker, Vector hitLocation ) {
    local int i, count;
    local VMAugmentationBehaviour behaviour;

    count = #OnDamageTakenHandlers;
    for ( i = 0; i < count; i++ ) {
        behaviour = OnDamageTakenHandlers[i];
        if ( behaviour.Info.IsActive ) {
            behaviour.OnDamageTaken( damage, damageType, attacker, hitLocation );
        }
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
        info = info.Next;
    }
}

//==============================================
// Augmentation Activation/Deactivation
//==============================================
function bool Set( name name, bool active ) {
    local VMAugmentationInfo info;

    if ( Player == none ) {
        return false;
    }

    info = GetInfo( name );
    if ( info != none ) {
        return info.Toggle( active );
    }
}
function bool Toggle( name name ) {
    local VMAugmentationInfo info;

    if ( Player == none ) {
        return false;
    }

    info = GetInfo( name );
    if ( info != none ) {
        return info.Toggle( !info.IsActive );
    }
}

function ActivateAll() {
    local VMAugmentationInfo info;

    info = FirstAugmentationInfo;
    while ( info != none ) {
        info.Toggle( true );
        info = info.Next;
    }
}
function DeactivateAll() {
    local VMAugmentationInfo info;

    info = FirstAugmentationInfo;
    while ( info != none ) {
        info.Toggle( false );
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
function int GetLevel( name name ) {
    local VMAugmentationInfo info;

    info = GetInfo( name );
    if ( info != none ) {
        return info.Level;
    }

    return -1;
}

//==============================================
// Augmentation Display
//==============================================
function GetFullDescription( VMAugmentationInfo info, PersonaInfoWindow winInfo ) {
    local string str;

    winInfo.Clear();
    winInfo.SetTitle( info.GetName() );
    winInfo.SetText( info.GetDescription() );

    // Install Location
    winInfo.AppendText( winInfo.CR() $ winInfo.CR() $ Sprintf( OccupiesLocationLabel, AugmentationLocationLabels[info.GetInstallLocation()] ) );

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

function DrawAugmentations( GC gc ) {
    local VMAugmentationInfo info;

    if ( !refreshed ) {
        return;
    }

    info = FirstAugmentationInfo;
    while ( info != none ) {
        if ( info.IsActive ) {
            info.DrawAugmentation( gc );
        }

        info = info.Next;
    }
}

//==============================================
// Misc
//==============================================
function bool IsLocationFull( int loc ) {
    return InstallLocationCounts[loc] >= default.InstallLocationMaxCounts[loc];
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
     EnergyRateLabel="Energy Rate: %s Units/Second"
     OccupiesLocationLabel="Occupies Location: %s"
     AlreadyAtMax="You already have the %s at the maximum level"
     NowUpgraded="%s upgraded to level %s"
     NowAtLevel="Augmentation %s at level %s"
     PassiveLabel="[Passive]"
     CanUpgradeLabel="(Can Upgrade)"
     CurrentLevelLabel="Current Level: %s"
     MaximumLabel="(Maximum)"
     AugmentationLocationLabels(0)="Core"
     AugmentationLocationLabels(1)="Cranial"
     AugmentationLocationLabels(2)="Eyes"
     AugmentationLocationLabels(3)="Torso"
     AugmentationLocationLabels(4)="Arms"
     AugmentationLocationLabels(5)="Legs"
     AugmentationLocationLabels(6)="Subdermal"
}
