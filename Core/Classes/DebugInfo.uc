//=============================================================================
// DebugInfo
//=============================================================================
class DebugInfo extends Object
    transient
    native
    noexport;

native(4000) final function AddTimingData(string obj, string objName, int time);
native(4001) final function Command(string cmd);

native(4002) final function SetString(string Hash, string Value);
native(4003) final function string GetString(string Hash);

defaultproperties
{
}
