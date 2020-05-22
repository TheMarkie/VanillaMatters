#pragma once

// Convert FString to std::wstring and back
wstring FStringToWString( FString fstr ) {
    return wstring( *fstr );
}
FString WStringToFString( wstring wstr ) {
    return FString( wstr.c_str() );
}

void ToLowerWString( wstring* wstr ) {
    std::transform( wstr->begin(), wstr->end(), wstr->begin(), towlower );
}