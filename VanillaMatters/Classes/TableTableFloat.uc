class TableTableFloat extends Table
    native
    noexport;

native final function Set( name key, TableFloat value );
native final function Modify( name tableKey, name valueKey, float value );
native final function bool TryGetValue( name key, out TableFloat value );

native final function Remove( name key );
native final function Clear();

defaultproperties
{
}
