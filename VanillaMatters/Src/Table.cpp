#include <string>
using std::wstring;
#include "robin_hood.h"
using robin_hood::unordered_map;

#include "VanillaMattersPrivate.h"
#include "Table.h"
#include "Utilities.h"

//==============================================
// Implement a table for a type
//==============================================
#define IMPLEMENT_TABLE_CLASS( name, type ) \
IMPLEMENT_CLASS( UTable##name ) \
IMPLEMENT_FUNCTION( UTable##name, -1, execSet ) \
IMPLEMENT_FUNCTION( UTable##name, -1, execModify ) \
IMPLEMENT_FUNCTION( UTable##name, -1, execTryGetValue ) \
IMPLEMENT_FUNCTION( UTable##name, -1, execRemove ) \
IMPLEMENT_FUNCTION( UTable##name, -1, execClear ) \
\
void UTable##name::execSet( FFrame& Stack, RESULT_DECL ) { \
    P_GET_NAME( name ) \
    P_GET_##type( value ) \
    P_FINISH \
    Set( name.GetIndex(), value ); \
} \
void UTable##name::execModify( FFrame& Stack, RESULT_DECL ) { \
    P_GET_NAME( name ) \
    P_GET_##type( value ) \
    P_FINISH \
    Modify( name.GetIndex(), value ); \
} \
void UTable##name::execTryGetValue( FFrame& Stack, RESULT_DECL ) { \
    P_GET_NAME( name ) \
    P_GET_##type##_REF( value ) \
    P_FINISH \
    if ( TryGetValue( name.GetIndex(), *value ) ) { \
        *( UBOOL* ) Result = 1; \
    } \
    else { \
        *( UBOOL* ) Result = 0; \
    } \
} \
void UTable##name::execRemove( FFrame & Stack, RESULT_DECL ) { \
    P_GET_NAME( name ) \
    P_FINISH \
    Remove( name.GetIndex() ); \
} \
void UTable##name::execClear( FFrame& Stack, RESULT_DECL ) { \
    P_FINISH \
    Clear(); \
} \
\
void UTable##name::Set( INT key, type value ) { \
    bool hasKey = _map.contains( key ); \
    _map[key] = value; \
    if ( !hasKey ) { \
        Count++; \
    } \
} \
void UTable##name::Modify( INT key, type value ) { \
    bool hasKey = _map.contains( key ); \
    _map[key] += value; \
    if ( !hasKey ) { \
        Count++; \
    } \
} \
bool UTable##name::TryGetValue( INT key, type& value ) { \
    auto it = _map.find( key ); \
    if ( it != _map.end() ) { \
        value = it->second; \
        return true; \
    } \
    else { \
        value = {}; \
        return false; \
    } \
} \
void UTable##name::Remove( INT key ) { \
    _map.erase( key ); \
    Count--; \
} \
void UTable##name::Clear() { \
    _map.clear(); \
    Count = 0; \
}

//==============================================
// Root table class
//==============================================
IMPLEMENT_CLASS( UTable )

//==============================================
// Implement tables for different value types
//==============================================
IMPLEMENT_TABLE_CLASS( Float, FLOAT )
IMPLEMENT_TABLE_CLASS( Int, INT )

// Table for UTableFloat
IMPLEMENT_CLASS( UTableTableFloat )
IMPLEMENT_FUNCTION( UTableTableFloat, -1, execSet )
IMPLEMENT_FUNCTION( UTableTableFloat, -1, execModify )
IMPLEMENT_FUNCTION( UTableTableFloat, -1, execTryGetValue )
IMPLEMENT_FUNCTION( UTableTableFloat, -1, execRemove )
IMPLEMENT_FUNCTION( UTableTableFloat, -1, execClear )

void UTableTableFloat::execSet( FFrame& Stack, RESULT_DECL ) {
    P_GET_NAME( name )
    P_GET_OBJECT( UTableFloat, value )
    P_FINISH
    Set( name.GetIndex(), value );
}
void UTableTableFloat::execModify( FFrame& Stack, RESULT_DECL ) {
    P_GET_NAME( tableName )
    P_GET_NAME( valueName )
    P_GET_FLOAT( value )
    P_FINISH
    Modify( tableName.GetIndex(), valueName.GetIndex(), value );
}
void UTableTableFloat::execTryGetValue( FFrame& Stack, RESULT_DECL ) {
    P_GET_NAME( name )
    P_GET_OBJECT_REF( UTableFloat, value )
    P_FINISH
    if ( TryGetValue( name.GetIndex(), value ) ) {
        *( UBOOL* ) Result = 1;
    }
    else {
        *( UBOOL* ) Result = 0;
    }
}
void UTableTableFloat::execRemove( FFrame& Stack, RESULT_DECL ) {
    P_GET_NAME( name )
    P_FINISH
    Remove( name.GetIndex() );
}
void UTableTableFloat::execClear( FFrame& Stack, RESULT_DECL ) {
    P_FINISH
    Clear();
}

void UTableTableFloat::Set( INT key, UTableFloat* value ) {
    bool hasKey = _map.contains( key );
    _map[key] = value;
    if ( !hasKey ) {
        Count++;
    }
}
void UTableTableFloat::Modify( INT tableKey, INT valueKey, FLOAT value ) {
    bool hasKey = _map.contains( tableKey );
    if ( !hasKey ) {
        _map[tableKey] = static_cast<UTableFloat*>( UTableFloat::StaticConstructObject( UTableFloat::StaticClass() ) );
        Count++;
    }

    _map[tableKey]->Modify( valueKey, value );
}
bool UTableTableFloat::TryGetValue( INT key, UTableFloat** value ) {
    auto it = _map.find( key );
    if ( it != _map.end() ) {
        *value = it->second;
        return true;
    }
    else {
        *value = {};
        return false;
    }
}
void UTableTableFloat::Remove( INT key ) {
    _map.erase( key );
    Count--;
}
void UTableTableFloat::Clear() {
    _map.clear();
    Count = 0;
}