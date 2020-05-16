#include "VanillaMattersPrivate.h"
#include "Utilities.h"

string FStringToString( FString fstr ) {
    return string( TCHAR_TO_ANSI( *fstr ) );
}