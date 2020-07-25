//==============================================
// Declare a table for a type
//==============================================
#define DECLARE_TABLE_CLASS( name, type ) \
class VANILLAMATTERS_API UTable##name : public UTable { \
public: \
    DECLARE_FUNCTION( execAdd ) \
    DECLARE_FUNCTION( execRemove ) \
    DECLARE_FUNCTION( execClear ) \
    DECLARE_FUNCTION( execSet ) \
    DECLARE_FUNCTION( execTryGetValue ) \
    DECLARE_CLASS( UTable##name, UTable, 0 ) \
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
