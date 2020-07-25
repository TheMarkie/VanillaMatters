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
IMPLEMENT_FUNCTION( UTable##name, -1, execAdd ) \
IMPLEMENT_FUNCTION( UTable##name, -1, execRemove ) \
IMPLEMENT_FUNCTION( UTable##name, -1, execClear ) \
IMPLEMENT_FUNCTION( UTable##name, -1, execSet ) \
IMPLEMENT_FUNCTION( UTable##name, -1, execTryGetValue ) \
\
void UTable##name::execAdd( FFrame& Stack, RESULT_DECL ) { \
    P_GET_NAME( name ) \
    P_GET_##type( value ) \
    P_FINISH \
    INT key = name.GetIndex(); \
    bool hasKey = _map.contains( key ); \
    _map[key] = value; \
    if ( !hasKey ) { \
        Count++; \
    } \
} \
void UTable##name::execRemove( FFrame& Stack, RESULT_DECL ) { \
    P_GET_NAME( name ) \
    P_FINISH \
    INT key = name.GetIndex(); \
    _map.erase( key ); \
    Count--; \
} \
void UTable##name::execClear( FFrame& Stack, RESULT_DECL ) { \
    P_FINISH \
    _map.clear(); \
    Count = 0; \
} \
void UTable##name::execSet( FFrame& Stack, RESULT_DECL ) { \
    P_GET_NAME( name ) \
    P_GET_##type( value ) \
    P_FINISH \
    INT key = name.GetIndex(); \
    bool hasKey = _map.contains( key ); \
    _map[key] = value; \
    if ( !hasKey ) { \
        Count++; \
    } \
} \
void UTable##name::execTryGetValue( FFrame& Stack, RESULT_DECL ) { \
    P_GET_NAME( name ) \
    P_GET_##type##_REF( value ) \
    P_FINISH \
    INT key = name.GetIndex(); \
    auto it = _map.find( key ); \
    if ( it != _map.end() ) { \
        *value = it->second; \
        *( UBOOL* ) Result = 1; \
    } \
    else { \
        *value = {}; \
        *( UBOOL* ) Result = 0; \
    } \
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
IMPLEMENT_FUNCTION( UTableTableFloat, -1, execAdd )
IMPLEMENT_FUNCTION( UTableTableFloat, -1, execRemove )
IMPLEMENT_FUNCTION( UTableTableFloat, -1, execClear )
IMPLEMENT_FUNCTION( UTableTableFloat, -1, execSet )
IMPLEMENT_FUNCTION( UTableTableFloat, -1, execTryGetValue )

void UTableTableFloat::execAdd( FFrame& Stack, RESULT_DECL ) {
    P_GET_NAME( name )
    P_GET_OBJECT( UTableFloat, value )
    P_FINISH
    INT key = name.GetIndex();
    bool hasKey = _map.contains( key );
    _map[key] = value;
    if ( !hasKey ) {
        Count++;
    }
}
void UTableTableFloat::execRemove( FFrame& Stack, RESULT_DECL ) {
    P_GET_NAME( name )
    P_FINISH
    INT key = name.GetIndex();
    _map.erase( key );
    Count--;
}
void UTableTableFloat::execClear( FFrame& Stack, RESULT_DECL ) {
    P_FINISH
    _map.clear();
    Count = 0;
}
void UTableTableFloat::execSet( FFrame& Stack, RESULT_DECL ) {
    P_GET_NAME( name )
    P_GET_OBJECT( UTableFloat, value )
    P_FINISH
    INT key = name.GetIndex();
    bool hasKey = _map.contains( key );
    _map[key] = value;
    if ( !hasKey ) {
        Count++;
    }
}
void UTableTableFloat::execTryGetValue( FFrame& Stack, RESULT_DECL ) {
    P_GET_NAME( name )
    P_GET_OBJECT_REF( UTableFloat, value )
    P_FINISH
    INT key = name.GetIndex();
    auto it = _map.find( key );
    if ( it != _map.end() ) {
        *value = it->second;
        *( UBOOL* ) Result = 1;
    }
    else {
        *value = {};
        *( UBOOL* ) Result = 0;
    }
}
