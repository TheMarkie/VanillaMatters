class TableInt extends Table
    native
    noexport;

native final function Add( string key, int value );
native function Remove( string key );
native function Clear();

native final function Set( string key, out int value );
native final function bool TryGetValue( string key, out int value );
