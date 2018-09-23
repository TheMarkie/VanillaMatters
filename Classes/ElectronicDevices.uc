//=============================================================================
// ElectronicDevices.
//=============================================================================
class ElectronicDevices extends DeusExDecoration
	abstract;

// Vanilla Matters
var bool VM_injected;				// Is this device hit by an injector projectile?

defaultproperties
{
     bInvincible=True
     FragType=Class'DeusEx.PlasticFragment'
     bPushable=False
}
