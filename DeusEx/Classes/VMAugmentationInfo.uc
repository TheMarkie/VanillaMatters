class VMAugmentationInfo extends VMUpgradeInfo;

var travel VMAugmentationInfo Next;
var travel bool IsActive;

var travel VMAugmentationBehaviour Behaviour;

var transient VMPlayer Player;
var transient class<VMAugmentation> Definition;

function LoadDefinition() {
    if ( Definition == none ) {
        Definition = class<VMAugmentation>( DynamicLoadObject( DefinitionPackageName $ "." $ DefinitionClassName, class'Class' ) );
    }
}

function LoadBehaviour( VMAugmentationManager manager ) {
    local class<VMAugmentationBehaviour> behaviourClass;

    if ( Definition.default.BehaviourClassName != '' ) {
        behaviourClass = class<VMAugmentationBehaviour>( DynamicLoadObject( DefinitionPackageName $ "." $ Definition.default.BehaviourClassName, class'Class' ) );
        if ( behaviourClass != none ) {
            Behaviour = new behaviourClass;
            Behaviour.Definition = Definition;
        }
    }
}

//==============================================
// General info
//==============================================
function string GetName() {
    return Definition.default.UpgradeName;
}
function string GetDescription() {
    return Definition.default.Description;
}
function Texture GetIcon() {
    return Definition.default.Icon;
}
function Texture GetSmallIcon() {
    return Definition.default.SmallIcon;
}

function int GetMaxLevel() {
    return Definition.static.GetMaxLevel();
}
function bool CanUpgrade( optional int amount ) {
    return Level < Definition.static.GetMaxLevel();
}

function bool IsPassive() {
    return Definition.default.IsPassive;
}
function int GetInstallLocation() {
    return Definition.default.InstallLocation;
}

//==============================================
// Management
//==============================================
function Refresh( VMPlayer playerOwner, optional bool active ) {
    LoadDefinition();

    Player = playerOwner;

    if ( Behaviour != none ) {
        Behaviour.Definition = Definition;
        Behaviour.Refresh( player );
    }

    if ( IsActive ) {
        Deactivate();

        IsActive = false;
    }

    if ( active || Definition.default.IsPassive ) {
        Activate();

        IsActive = true;
    }
}

function Toggle( bool on ) {
    if ( IsActive == on
        || ( Definition.default.IsPassive && !on )
    ) {
        return;
    }

    if ( on ) {
        Player.PlaySound( Definition.default.ActivateSound, SLOT_None );

        Activate();
    }
    else {
        Player.PlaySound( Definition.default.DeactivateSound, SLOT_None );

        Deactivate();
    }

    IsActive = on;
}

function bool IncreaseLevel() {
    if ( Level < GetMaxLevel() ) {
        if ( IsActive ) {
            Deactivate();
        }
        Level += 1;
        if ( IsActive ) {
            Activate();
        }

        return true;
    }

    return false;
}

function bool DecreaseLevel() {
    if ( Level > 0 ) {
        if ( IsActive ) {
            Deactivate();
        }
        Level -= 1;
        if ( IsActive ) {
            Activate();
        }

        return true;
    }

    return false;
}

//==============================================
// Behaviours
//==============================================
function Activate() {
    if ( Behaviour != none ) {
        Behaviour.Activate( Level );
    }
    else {
        Definition.static.Activate( Player, Level );
    }
}

function Deactivate() {
    if ( Behaviour != none ) {
        Behaviour.Deactivate( Level );
    }
    else {
        Definition.static.Deactivate( Player, Level );
    }
}

function Tick( float deltaTime ) {
    if ( Behaviour != none ) {
        Behaviour.Tick( deltaTime, Level );
    }
}

function float GetRate( float time ) {
    if ( Behaviour != none ) {
        return Behaviour.GetRate( time, Level );
    }

    return ( Definition.default.Rates[Min( Level, #Definition.default.Rates - 1 )] / 60 ) * time;
}

function float IsOnCooldown() {
    if ( Behaviour != none ) {
        return Behaviour.IsOnCooldown( Level );
    }

    return 0;
}
