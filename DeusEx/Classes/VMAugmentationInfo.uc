class VMAugmentationInfo extends VMUpgradeInfo;

var travel VMAugmentationInfo Next;
var travel bool IsActive;

var travel VMAugmentationBehaviour Behaviour;

var transient class<VMAugmentation> Definition;

function LoadDefinition() {
    if ( Definition == none ) {
        Definition = class<VMAugmentation>( DynamicLoadObject( "DeusEx." $ string( DefinitionClassName ), class'Class' ) );
    }
}

function Initialize( name name, int startingLevel ) {
    super.Initialize( name, startingLevel );
    LoadDefinition();
}

function LoadBehaviour( VMAugmentationManager manager ) {
    local class<VMAugmentationBehaviour> behaviourClass;

    if ( Definition.default.HasBehaviour && Behaviour == none ) {
        behaviourClass = class<VMAugmentationBehaviour>( DynamicLoadObject( "DeusEx." $ string( DefinitionClassName ) $ "Behaviour", class'Class' ) );
        Behaviour = new behaviourClass;
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
    return Level < GetMaxLevel();
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
function Refresh( VMPlayer player, optional bool active ) {
    LoadDefinition();

    if ( Definition.default.HasBehaviour ) {
        Behaviour.Refresh( player, self );
    }

    if ( IsActive ) {
        Deactivate();

        IsActive = false;
    }

    if ( active || IsPassive() ) {
        Activate();

        IsActive = true;
    }
}

final function Toggle( VMPlayer player, bool on ) {
    if ( IsActive == on
        || ( IsPassive() && !on )
    ) {
        return;
    }

    if ( on ) {
        player.PlaySound( Definition.default.ActivateSound, SLOT_None );
        player.UpdateAugmentationDisplay( self, true );

        Activate();
    }
    else {
        player.PlaySound( Definition.default.DeactivateSound, SLOT_None );
        player.UpdateAugmentationDisplay( self, false );

        Deactivate();
    }

    IsActive = on;
}

//==============================================
// Behaviours
//==============================================
function Activate() {
    if ( Definition.default.HasBehaviour ) {
        Behaviour.Activate();
    }
}

function Deactivate() {
    if ( Definition.default.HasBehaviour ) {
        Behaviour.Deactivate();
    }
}

function Tick( float deltaTime ) {
    if ( Definition.default.HasBehaviour ) {
        Behaviour.Tick( deltaTime );
    }
}

function float GetRate() {
    if ( Definition.default.HasBehaviour ) {
        Behaviour.GetRate();
    }
    else if ( !definition.default.IsPassive && Level < #definition.default.Rates ) {
        return definition.default.Rates[Level];
    }

    return 0;
}

//==============================================
// Values
//==============================================
function float GetValue() {
    return Definition.default.Values[Min( Level, #Definition.default.Values )];
}
