class TableFloat extends Table
    native
    noexport;

native final function Add( string key, float value );
native final function Remove( string key );
native final function bool TryGetValue( string key, out float value );
