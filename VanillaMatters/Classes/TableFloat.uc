class TableFloat extends Table
    native
    noexport;

native final function Add( string key, float value );
native function Remove( string key );
native function Clear();

native final function Set( string key, out float value );
native final function bool TryGetValue( string key, out float value );
