#include "VanillaMattersPrivate.h"
#include "Utilities.h"

//==============================================
// Root table class
//==============================================
IMPLEMENT_CLASS( UTable );
IMPLEMENT_FUNCTION( UTable, -1, execRemove );
IMPLEMENT_FUNCTION( UTable, -1, execClear );

UTable::UTable() {
    Count = 0;
}

void UTable::execRemove( FFrame & Stack, RESULT_DECL ) {}
void UTable::execClear( FFrame & Stack, RESULT_DECL ) {}

//==============================================
// Implement tables for different value types
//==============================================
IMPLEMENT_TABLE_CLASS( Float, FLOAT );
IMPLEMENT_TABLE_CLASS( Int, INT );
