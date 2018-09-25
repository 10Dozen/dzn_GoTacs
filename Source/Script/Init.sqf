
#include "macro.hpp";

call compile preprocessFileLineNumbers format ["%1\Functions.sqf", PATH];
call compile preprocessFileLineNumbers format ["%1\UIFunctions.sqf", PATH];
call compile preprocessFileLineNumbers format ["%1\Settings.sqf", PATH];
call compile preprocessFileLineNumbers format ["%1\Enums.sqf", PATH];

// --- Teams 
GVAR(Teams) = [];
GVAR(TeamPattern) = "";

GVAR(TeamSelectionTimeout) = 0;
GVAR(TeamRedSelected) = false;
GVAR(TeamBlueSelected) = false;
GVAR(TeamGreenSelected) = false;
GVAR(TeamYellowSelected) = false;

GVAR(CommandMode) = "";

// --- HUD data gathering
GVAR(SquadData) = [];
GVAR(SquadLoopEnabled) = true;

GVAR(ContactsData) = [];
GVAR(ContactsLoopEnabled) = true;
GVAR(ContactsNextRequestTime) = time + 5;

GVAR(CommandHUD_Draw) = false;

// --- HUD settings
GVAR(SquadHUD_Draw) = true;
GVAR(SquadHUD_DataUpdateTimeout) = 15;
GVAR(SquadHUD_Opacity) = 1;

GVAR(ContactsHUD_Draw) = true;
GVAR(ContactsHUD_DataUpdateTimeout) = 15;
GVAR(ContactsHUD_Opacity) = 1;



[] spawn {
	sleep 2;
	waitUntil { !isNull player };
	
	"Squad" call GVAR(fnc_uiShowHUD);
	"Contacts" call GVAR(fnc_uiShowHUD);

	// --- Loops ---
	[] spawn GVAR(fnc_squadLoop);
	[] spawn GVAR(fnc_contactsLoop);

	// --- Init handlers ---
	["add"] spawn GVAR(fnc_handleTeamSelection);
};