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
    P_GET_STR( fstr ) \
    P_GET_##type( value ) \
    P_FINISH \
\
    wstring key = FStringToWString( fstr ); \
    ToLowerWString( &key ); \
    bool hasKey = _map.contains( key ); \
    _map[key] = value; \
    if ( !hasKey ) { \
        Count++; \
    } \
} \
void UTable##name::execRemove( FFrame& Stack, RESULT_DECL ) { \
    P_GET_STR( fstr ) \
    P_FINISH \
\
    wstring key = FStringToWString( fstr ); \
    ToLowerWString( &key ); \
    _map.erase( key ); \
    Count--; \
} \
void UTable##name::execClear( FFrame& Stack, RESULT_DECL ) { \
    P_FINISH \
\
    _map.clear(); \
    Count = 0; \
} \
\
void UTable##name::execSet( FFrame& Stack, RESULT_DECL ) { \
    P_GET_STR( fstr ) \
    P_GET_##type( value ) \
    P_FINISH \
\
    wstring key = FStringToWString( fstr ); \
    ToLowerWString( &key ); \
    bool hasKey = _map.contains( key ); \
    _map[key] = value; \
    if ( !hasKey ) { \
        Count++; \
    } \
} \
void UTable##name::execTryGetValue( FFrame& Stack, RESULT_DECL ) { \
    P_GET_STR( fstr ) \
    P_GET_##type##_REF( value ) \
    P_FINISH \
\
    wstring key = FStringToWString( fstr ); \
    ToLowerWString( &key ); \
    auto it = _map.find( key ); \
    if ( it != _map.end() ) { \
        *value = it->second; \
        *( UBOOL* ) Result = 1; \
    } \
    else { \
        *value = {}; \
        *( UBOOL* ) Result = 0; \
    } \
} \
\
void UTable##name::Serialize( FArchive& Ar ) { \
    UTable::Serialize( Ar ); \
    if ( Ar.IsLoading() ) { \
        INT count; \
        Ar << AR_INDEX( count ); \
        _map.empty(); \
        for ( INT i = 0; i < count; i++ ) { \
            FString* fstr = new FString; \
            Ar << *fstr; \
            type* value = new type; \
            Ar << *value; \
            _map[FStringToWString( *fstr )] = *value; \
        } \
        Count = count; \
    } \
    else { \
        Ar << AR_INDEX( Count ); \
        for ( auto pair : _map ) { \
            Ar << WStringToFString( pair.first ); \
            Ar << pair.second; \
        } \
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
