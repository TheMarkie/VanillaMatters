#include "VanillaMattersPrivate.h"
#include "Utilities.h"

//==============================================
// Root table class
//==============================================
IMPLEMENT_CLASS( UTable );

UTable::UTable() {
    Count = 0;
}

//==============================================
// Implement tables for different value types
//==============================================
IMPLEMENT_TABLE_CLASS( Float, FLOAT );
IMPLEMENT_TABLE_CLASS( Int, INT );
