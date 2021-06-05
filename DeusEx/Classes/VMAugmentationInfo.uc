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
function Refresh( VMAugmentationManager manager, VMPlayer playerOwner, optional bool active ) {
    LoadDefinition();

    Player = playerOwner;

    if ( Behaviour != none ) {
        Behaviour.Refresh( player, self, manager );
    }

    if ( active || Definition.default.IsPassive ) {
        Activate();

        IsActive = true;
    }
}

function bool Toggle( bool on ) {
    if ( IsActive == on
        || ( Definition.default.IsPassive && !on )
    ) {
        return IsActive;
    }

    if ( on ) {
        if ( Activate() ) {
            if ( Definition.default.ActivateSound != none ) {
                Player.PlaySound( Definition.default.ActivateSound, SLOT_None );
            }
            IsActive = true;
        }
    }
    else {
        if ( Deactivate() ) {
            if ( Definition.default.DeactivateSound != none ) {
                Player.PlaySound( Definition.default.DeactivateSound, SLOT_None );
            }
            IsActive = false;
        }
    }

    return IsActive;
}

function bool IncreaseLevel() {
    if ( Level < GetMaxLevel() ) {
        Level += 1;

        return true;
    }

    return false;
}

function bool DecreaseLevel() {
    if ( Level > 0 ) {
        Level -= 1;

        return true;
    }

    return false;
}

//==============================================
// Behaviours
//==============================================
function bool Activate() {
    if ( Behaviour != none ) {
        return Behaviour.Activate();
    }
    else {
        return Definition.static.Activate( Player, Level );
    }
}

function bool Deactivate() {
    if ( Behaviour != none ) {
        return Behaviour.Deactivate();
    }
    else {
        return Definition.static.Deactivate( Player, Level );
    }
}

function Tick( float deltaTime ) {
    if ( Behaviour != none ) {
        Behaviour.Tick( deltaTime );
    }
}

function float GetRate( float time ) {
    if ( Behaviour != none ) {
        return Behaviour.GetRate( time );
    }

    return ( Definition.default.Rates[Min( Level, #Definition.default.Rates - 1 )] / 60 ) * time;
}

function float GetCooldown() {
    if ( Behaviour != none ) {
        return Behaviour.GetCooldown();
    }

    return 0;
}

function DrawAugmentation( GC gc ) {
    if ( Behaviour != none ) {
        Behaviour.Draw( gc );
    }
}
