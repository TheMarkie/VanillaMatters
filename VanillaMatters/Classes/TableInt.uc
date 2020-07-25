class TableInt extends Table
    native
    noexport;

native final function Add( name key, int value );
native final function Remove( name key );
native final function Clear();

native final function Set( name key, int value );
native final function bool TryGetValue( name key, out int value );

defaultproperties
{
}
