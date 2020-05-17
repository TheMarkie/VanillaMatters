#pragma once

// Convert FString to std::string
string FStringToString( FString fstr ) {
    return string( TCHAR_TO_ANSI( *fstr ) );
}
FString StringToFString( string str ) {
    return FString( ANSI_TO_TCHAR( str.c_str() ) );
}