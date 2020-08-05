class VMAugmentationManager extends VMUpgradeManager;

var travel VMAugmentationInfo FirstAugmentationInfo;

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

function Refresh( VMPlayer player ) {
    local VMAugmentationInfo info;

    super.Refresh( player );

    info = FirstAugmentationInfo;
    while ( info != none ) {
        info.Refresh( player, info.IsActive );

        info = info.Next;
    }
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

//==============================================
// Augmentation Management
//==============================================
function VMAugmentationInfo GetInfo( name name ) {
    local VMAugmentationInfo info;

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

    info = GetInfo( name );
    if ( info != none ) {
        info.Toggle( Player, active );
    }
}
function Toggle( name name ) {
    local VMAugmentationInfo info;

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
    }

    return ( ( rate / 60 ) * deltaTime );
}

//==============================================
// Callbacks
//==============================================
function Tick( float deltaTime ) {
    local VMAugmentationInfo info;

    info = FirstAugmentationInfo;
    while ( info != none ) {
        if ( info.IsActive && info.NeedsTick() ) {
            info.Tick( Player, deltaTime );
        }

        info = info.Next;
    }
}
