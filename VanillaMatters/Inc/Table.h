//==============================================
// Declare a table for a type
//==============================================
#define DECLARE_TABLE_CLASS( name, type ) \
class VANILLAMATTERS_API UTable##name : public UTable { \
public: \
    DECLARE_FUNCTION( execSet ) \
    DECLARE_FUNCTION( execModify ) \
    DECLARE_FUNCTION( execTryGetValue ) \
    DECLARE_FUNCTION( execRemove ) \
    DECLARE_FUNCTION( execClear ) \
    DECLARE_CLASS( UTable##name, UTable, 0 ) \
\
    void Set( INT key, type value ); \
    void Modify( INT key, type value ); \
    bool TryGetValue( INT key, type& value ); \
    void Remove( INT key ); \
    void Clear(); \
protected: \
    UTable##name() : UTable() { \
        _map = unordered_map<INT, type>(); \
    } \
private: \
    unordered_map<INT, type> _map; \
};

//==============================================
// Root table class
//==============================================
class VANILLAMATTERS_API UTable : public UObject {
public:
    INT Count;
    DECLARE_CLASS( UTable, UObject, 0 )
protected:
    UTable() {
        Count = 0;
    }
};

//==============================================
// Declare tables for different value types
//==============================================
DECLARE_TABLE_CLASS( Float, FLOAT )
DECLARE_TABLE_CLASS( Int, INT )

// Table for UTableFloat
class VANILLAMATTERS_API UTableTableFloat : public UTable {
public:
    DECLARE_FUNCTION( execSet )
    DECLARE_FUNCTION( execModify )
    DECLARE_FUNCTION( execTryGetValue )
    DECLARE_FUNCTION( execRemove )
    DECLARE_FUNCTION( execClear )
    DECLARE_CLASS( UTableTableFloat, UTable, 0 )

    void Set( INT key, UTableFloat* value );
    void Modify( INT tableKey, INT valueKey, FLOAT value );
    bool TryGetValue( INT key, UTableFloat** value );
    void Remove( INT key );
    void Clear();
protected:
    UTableTableFloat() : UTable() {
        _map = unordered_map<INT, UTableFloat*>();
    }
private:
    unordered_map<INT, UTableFloat*> _map;
};
