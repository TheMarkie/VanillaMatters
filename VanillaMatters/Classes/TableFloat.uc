class TableFloat extends Table
    native
    noexport;

native final function Add( name key, float value );
native final function Remove( name key );
native final function Clear();

native final function Set( name key, float value );
native final function bool TryGetValue( name key, out float value );

defaultproperties
{
}
