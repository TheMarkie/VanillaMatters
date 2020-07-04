class TableInt extends Table
    native
    noexport;

native final function Add( string key, int value );
native final function Remove( string key );
native final function Clear();

native final function Set( string key, int value );
native final function bool TryGetValue( string key, out int value );

defaultproperties
{
}
