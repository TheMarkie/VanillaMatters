class TableInt extends Table
    native
    noexport;

native final function Set( name key, int value );
native final function Modify( name key, float value );
native final function bool TryGetValue( name key, out int value );

native final function Remove( name key );
native final function Clear();

defaultproperties
{
}
