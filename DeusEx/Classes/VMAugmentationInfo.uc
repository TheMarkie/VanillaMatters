class VMAugmentationInfo extends VMUpgradeInfo;

var travel VMAugmentationInfo Next;
var travel bool IsActive;

var private transient class<VMAugmentation> _definitionClass;
function class<VMAugmentation> GetDefinitionClass() {
    if ( _definitionClass == none ) {
        _definitionClass = class<VMAugmentation>( DynamicLoadObject( "DeusEx." $ string( DefinitionClassName ), class'Class' ) );
    }

    return _definitionClass;
}

function Initialize( name name, int startingLevel ) {
    super.Initialize( name, startingLevel );
    GetDefinitionClass();
}

//==============================================
// General info
//==============================================
function string GetName() {
    return _definitionClass.default.UpgradeName;
}
function string GetDescription() {
    return _definitionClass.default.Description;
}
function Texture GetIcon() {
    return _definitionClass.default.Icon;
}
function Texture GetSmallIcon() {
    return _definitionClass.default.SmallIcon;
}

function int GetMaxLevel() {
    return _definitionClass.static.GetMaxLevel();
}
function bool CanUpgrade( optional int amount ) {
    return Level < GetMaxLevel();
}

function bool IsPassive() {
    return _definitionClass.static.IsPassive;
}
function bool NeedsTick() {
    return _definitionClass.static.NeedsTick;
}

//==============================================
// Management
//==============================================
function Toggle( VMPlayer player, bool activate ) {
    if ( IsActive == activate
        || ( IsPassive() && !activate )
    ) {
        return;
    }

    _definitionClass.static.Toggle( player, self, activate );
    IsActive = activate;
}

function Tick( float deltaTime ) {
    _definitionClass.static.Tick( player, self, deltaTime );
}

function Refresh( VMPlayer player, optional bool activate ) {
    if ( IsActive ) {
        _definitionClass.static.Deactivate( player, self );

        IsActive = false;
    }

    if ( activate || IsPassive() ) {
        _definitionClass.static.Activate( player, self );

        IsActive = true;
    }
}

function float GetCurrentRate() {
    return _definitionClass.static.GetRate( self );
}

//==============================================
// Values
//==============================================
function float GetValue() {
    return _definitionClass.static.Values[Level];
}