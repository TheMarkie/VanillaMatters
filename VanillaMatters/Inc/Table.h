//==============================================
// Declare and implement a table for a type
//==============================================
#define DECLARE_TABLE_CLASS( name, type )\
class VANILLAMATTERS_API UTable##name : public UTable {\
public:\
    DECLARE_FUNCTION( execAdd );\
    DECLARE_FUNCTION( execRemove );\
    DECLARE_FUNCTION( execTryGetValue );\
    DECLARE_CLASS( UTable##name, UTable, 0 )\
protected:\
    UTable##name() : UTable() {\
        _map = robin_hood::unordered_map<string, type>();\
    }\
    private:\
        robin_hood::unordered_map<string, type> _map;\
};

#define IMPLEMENT_TABLE_CLASS( name, type )\
IMPLEMENT_CLASS( UTable##name );\
IMPLEMENT_FUNCTION( UTable##name, -1, execAdd );\
IMPLEMENT_FUNCTION( UTable##name, -1, execRemove );\
IMPLEMENT_FUNCTION( UTable##name, -1, execTryGetValue );\
\
void UTable##name::execAdd( FFrame& Stack, RESULT_DECL ) {\
    P_GET_STR( fstr );\
    P_GET_##type( value );\
    P_FINISH;\
\
    string key = FStringToString( fstr );\
    _map[key] = value;\
\
    Count++;\
}\
void UTable##name::execRemove( FFrame& Stack, RESULT_DECL ) {\
    P_GET_STR( fstr );\
    P_FINISH;\
\
    string key = FStringToString( fstr );\
    _map.erase( key );\
\
    Count--;\
}\
void UTable##name::execTryGetValue( FFrame& Stack, RESULT_DECL ) {\
    P_GET_STR( fstr );\
    P_GET_##type##_REF( value );\
    P_FINISH;\
\
    string key = FStringToString( fstr );\
    auto it = _map.find( key );\
    if ( it != _map.end() ) {\
        *value = it->second;\
        *( UBOOL* ) Result = 1;\
    }\
    else {\
        *value = {};\
        *( UBOOL* ) Result = 0;\
    }\
}

//==============================================
// Root table class
//==============================================
class VANILLAMATTERS_API UTable : public UObject {
public:
    INT Count;
    DECLARE_CLASS( UTable, UObject, 0 );
protected:
    UTable();
};

//==============================================
// Declare tables for different value types
//==============================================
DECLARE_TABLE_CLASS( Float, FLOAT );
DECLARE_TABLE_CLASS( Int, INT );