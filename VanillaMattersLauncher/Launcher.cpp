#include <windows.h>
#include <stdio.h>

#include <string>
#include <tchar.h>
#include <experimental\filesystem>
#include <fstream>
#include <ctime>
#include <filesystem>
#include <chrono>
#include <thread>

#include "Shlwapi.h"

#pragma comment(lib, "Shlwapi.lib")

using std::string;
using namespace std::literals::chrono_literals;

// Declaring the default paths and names.
const string defaultExePath = "..\\..\\System\\deusex.exe";
const string defaultSteamExePath = "..\\..\\..\\..\\..\\Steam.exe";

const string defaultIniName = "Default.ini";
const string defaultUserIniName = "DefUser.ini";

// These are how the files are gonna be formatted from the mod name.
const string iniName = ".ini";
const string userIniName = "User.ini";
const string logName = ".log";

// Timeout for when the game can't be detected to have launched properly.
const int maxTimeout = 15;

// Copies a file using file stream.
static void copyFile( const string& srcName, const string& newName ) {
	std::ifstream srcFile( srcName, std::ios::binary );
	std::ofstream newFile( newName, std::ios::binary );

	newFile << srcFile.rdbuf();
}

// Converts string to char* because .c_str() would produce a const char* instead.
static char* toChar( const string& str ) {
	char* chr = new char[str.length() + 1];
	strcpy_s( chr, str.length() + 1, str.c_str() );

	return chr;
}

int APIENTRY _tWinMain( HINSTANCE hInstance, HINSTANCE hPrevInstance, LPTSTR lpCmdLine, int nCmdShow ) {
	// If we can't get the name of this executable, that means something is very wrong, we can't do anything without it, so just abort immediately.
	TCHAR fN[MAX_PATH];
	if ( !GetModuleFileName( 0, fN, MAX_PATH ) ) {
		return 2;
	}

	// Converts it to string so we can do manipulations easier.
	string fileName( fN );

	std::size_t pos = fileName.find_last_of( "\\" );
	if ( pos != string::npos ) {
		fileName = fileName.substr( pos + 1, fileName.size() );

		pos = fileName.find_first_of( "." );
		if ( pos != string::npos ) {
			fileName = fileName.substr( 0, pos );
		}
	}

	// Starts writing the log file for this launcher.
	std::ofstream logFile( fileName + "Launcher.log", std::ofstream::out );

	time_t r = time( NULL );
	char cTime[50];
	ctime_s( cTime, sizeof cTime, &r );
	logFile << "Current time: " << cTime << "\n";

	// Gets the current directory of this launcher, we can also use GetCommandLine() and other stuff but this is cleaner.
	string currentPath = std::experimental::filesystem::current_path().string();
	currentPath = currentPath + "\\";

	// Converts it to char* for the upcoming checks.
	char* cP = toChar( currentPath );

	logFile << "Current path: " << cP << "\n";

	logFile << "Finding deusex.exe..." << "\n";

	// Gets the full path of the deusex.exe that's relative to our launcher, the file structure is rigid just to be safe.
	char* exePath = _fullpath( cP, toChar( defaultExePath ), _MAX_PATH );

	// If the deusex.exe can't be found, abort.
	if ( PathFileExists( exePath ) == FALSE ) {
		logFile << "Can't find deusex.exe! Make sure you follow the correct file structure during installation." << "\n";

		logFile.close();

		return 1;
	}
	else {
		logFile << "Found deusex.exe at " << exePath << ", grabbing ini files..." << "\n";
	}

	logFile << "Mod detected: " << fileName << "\n";

	logFile << "Checking for ini files..." << "\n";

	// Sets up the supposed paths for our ini files, they should exist in the same directory as the launcher, so we can decide it from the start.
	string iniPath = currentPath + fileName + iniName;
	string userIniPath = currentPath + fileName + userIniName;
	string relativePath = "..\\" + fileName + "\\System\\";

	string launchParams = "";

	// We're gonna check if each ini file already exists, if it doesn't, generate from the default files.
	char* iP = toChar( iniPath );
	if ( PathFileExists( iP ) == TRUE ) {
		logFile << "Main ini file found at " << iP << ", added to parameters." << "\n";

		launchParams = launchParams + "INI=\"" + relativePath + fileName + iniName + "\" ";
	}
	else {
		logFile << "Main ini file not found at " << iP << ", generating from default..." << "\n";

		string defaultIniPath = currentPath + defaultIniName;

		// Checks if the default file exists, if it does, copies and renames it, if it doesn't, moves on.
		char* diP = toChar( defaultIniPath );
		if ( PathFileExists( diP ) == TRUE ) {
			copyFile( defaultIniName, fileName + iniName );

			if ( PathFileExists( iP ) == TRUE ) {
				logFile << "Main ini file generated." << "\n";

				launchParams = launchParams + "INI=\"" + relativePath + fileName + iniName + "\" ";
			}
		}
		else {
			logFile << "Default ini file not found at " << diP << ", moving on..." << "\n";
		}
	}

	char* uiP = toChar( userIniPath );
	if ( PathFileExists( uiP ) == TRUE ) {
		logFile << "User ini file found at " << uiP << ", added to parameters." << "\n";

		launchParams = launchParams + "USERINI=\"" + relativePath + fileName + userIniName + "\" ";
	}
	else {
		logFile << "User ini file not found at " << uiP << ", generating from default..." << "\n";

		string defaultUserIniPath = currentPath + defaultUserIniName;

		char* duiP = toChar( defaultUserIniPath );
		if ( PathFileExists( duiP ) == TRUE ) {
			copyFile( defaultUserIniName, fileName + userIniName );

			if ( PathFileExists( uiP ) == TRUE ) {
				logFile << "User ini file generated." << "\n";

				launchParams = launchParams + "USERINI=\"" + relativePath + fileName + userIniName + "\" ";
			}
		}
		else {
			logFile << "Default user ini file not found at " << duiP << ", moving on..." << "\n";
		}
	}

	logFile << "Finalizing launch parameters..." << "\n";

	// Adds logging parameter, the -localdata parameter is simply there for kentie's launcher, which makes it use the current folder and the game's folder for saves and settings, just like vanilla.
	launchParams = launchParams + "LOG=\"" + relativePath + fileName + logName + "\" ";
	launchParams = launchParams + "-localdata";

	// Slight hack to get the directory containing deusex.exe, since we always know that it's "deusex.exe", we know how many characters to subtract from the full path.
	string launchDirectory = string( exePath ).substr( 0, string( exePath ).length() - 10 );

	logFile << "Searching for any unrestored vanilla files..." << "\n";

	// This here takes care of a situation where the launcher itself crashes, which prevents it from renaming the vanilla files back, so this cleans it up before we repeat the override again properly.
	for ( const std::experimental::filesystem::directory_entry& f : std::experimental::filesystem::directory_iterator( launchDirectory ) ) {
		if ( f.path().extension() == ".vnt" ) {
			logFile << "Found vanilla file " << f.path().filename() << ", restoring..." << "\n";

			string originalName = f.path().string().substr( 0, f.path().string().length() - 4 );

			if ( PathFileExists( toChar( originalName ) ) ) {
				remove( originalName.c_str() );
			}

			rename( f.path(), originalName );

			logFile << "Restored file " << f.path().filename().string() << " to " << f.path().filename().string().substr( 0, f.path().filename().string().length() - 4 ) << ".\n";
		}
	}

	std::vector<string> intOverrides;
	std::vector<string> intOverridden;

	logFile << "Finding int files for overriding..." << "\n";

	// Searches for any int file then finds its equivalent in System if any exists, we don't have to hardcode which int file to override.
	for ( const std::experimental::filesystem::directory_entry& f : std::experimental::filesystem::directory_iterator( "." ) ) {
		if ( f.path().extension() == ".int" ) {
			logFile << "Found int file " << f.path().filename() << ", beginning override..." << "\n";

			string intName = f.path().filename().string();

			if ( PathFileExists( toChar( currentPath + intName ) ) ) {
				string vanillaIntPath = launchDirectory + intName;

				if ( PathFileExists( toChar( vanillaIntPath ) ) ) {
					logFile << "Found vanilla int equivalent, renaming..." << "\n";

					string overrideName = vanillaIntPath + ".vnt";

					rename( vanillaIntPath.c_str(), overrideName.c_str() );

					logFile << "Vanilla file " << intName << " renamed." << "\n";

					intOverridden.push_back( overrideName );
				}

				copyFile( intName, vanillaIntPath );

				logFile << "Int file " << intName << " copied, overriding done." << "\n";

				intOverrides.push_back( vanillaIntPath );
			}
		}
	}

	string launchCommand = "";

	logFile << "Checking path " << launchDirectory << " for Steam availability..." << "\n";

	// We simply goes up the directory (about 4 times), if the copy is a steam copy, it should have the exact same file structure (steamapps/common/..), so if we follow that and can't find Steam.exe, then this is non-steam.
	// Obviously problematic when the user installs on a steam library on another partition, but then there's nothing much we can do, due to how deus ex is.
	char* sP = _fullpath( toChar( launchDirectory ), toChar( defaultSteamExePath ), _MAX_PATH );
	if ( PathFileExists( sP ) == TRUE ) {
		logFile << "Found Steam at " << sP << "\n";

		launchCommand = string( sP );

		// We have to do this because steam wraps the original exe with DRM, so we can't directly launch it.
		launchParams = "-applaunch 6910 \"" + launchParams + '\"';
	}
	else {
		logFile << "Can't find Steam, resorting to normal launching." << "\n";

		// We're using cmd to be sure, it's much more reliable than passing the exe straight into ShellExecute, which some program doesn't enjoy.
		launchCommand = "cmd.exe";

		launchParams = "/C deusex.exe " + launchParams;
	}

	logFile << "Running command: " << launchCommand << "\n";

	logFile << "Running parameters: " << launchParams << "\n";

	logFile << "Running directory: " << launchDirectory << "\n";


	// Tries to launch the game.
	HINSTANCE result;
	try {
		result = ShellExecute( NULL, "open", launchCommand.c_str(), launchParams.c_str(), launchDirectory.c_str(), 0 );
	}
	catch ( const std::exception& e ) {
		logFile << "EXCEPTION OCCURED WHILE LAUNCHING THE GAME: " << e.what() << "\n";
	}

	logFile << "Finished launching game with code " << ( int ) result << ", waiting for it to close..." << std::endl;

	// Basically checks every one second if the log file has been opened at least once then closed, which means the game started and ended, then cleans up the int overrides if the game's no longer going.
	char* lfP = toChar( currentPath + fileName + logName );
	FILE *lF;

	bool logFileOpened = false;
	bool gameClosed = ( ( int ) result ) <= 32;
	int timePassed = 0;
	while ( !gameClosed ) {
		std::this_thread::sleep_for( 1000ms );
		
		timePassed = timePassed + 1;

		if ( PathFileExists( lfP ) ) {
			fopen_s( &lF, lfP, "r" );
			if ( lF != NULL ) {
				if ( logFileOpened ) {
					gameClosed = true;
				}
				else if ( timePassed > maxTimeout ) {
					logFile << "Game timed out!" << "\n";

					gameClosed = true;
				}

				fclose( lF );
			}
			else {
				logFileOpened = true;
			}
		}
		else {
			gameClosed = 1;
		}
	}

	logFile << "Game closed, cleaning up int overrides..." << "\n";

	// We keep the override paths in two vectors so we don't have to do a directory search again.
	for ( const string& iN : intOverrides ) {
		logFile << "Removing int override " << iN << "...\n";

		remove( iN.c_str() );
	}
	for ( const string& iN : intOverridden ) {
		string originalName = iN.substr( 0, iN.length() - 4 );

		logFile << "Restoring vanilla int file " << originalName << "...\n";

		rename( iN.c_str(), originalName.c_str() );
	}

	logFile << "Everything done. Exiting." << std::endl;

	logFile.close();

	return 0;
}
