class TableTableFloat extends Table
    native
    noexport;

native final function Add( name key, TableFloat value );
native final function Remove( name key );
native final function Clear();

native final function Set( name key, TableFloat value );
native final function bool TryGetValue( name key, out TableFloat value );

defaultproperties
{
}
