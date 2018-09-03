
/*
	[+] Team assignment by pattern:
	[+]	NATO 	1-4-4
	[+]	RUMSV	3-3-2

	[+] (SquadHUD) Draw squad memebers w. team colors 
	[] (SquadHUD) Toggle 

	[] (ContactsHUD) Draw enemy markers in 3d 
	[] (Orders) Clean building 

	[] Exclude squad from IWCB 
	[] Vanilla/ACE Heal button 
	[] Arsenal for each unit 
*/


#include "macro.hpp";

call compile preprocessFileLineNumbers format ["dzn_GoTacs\Functions.sqf", PATH];



/*
GVAR(MainOverlay_Opened) = false;
GVAR(ContactNextRequestTime) = time;
GVAR(ContactLastRequestedTimeout) = 1;
GVAR(ContactsList) = [];
GVAR(CommandMode) = "";

*/

// Button 
[
	"dzn GoTacs"
	, "dzn_GoTacs_SquadMenu"
	, "Open Squad menu"
	, {
		[] spawn fnc_uiShowMainOverlay;
		true
	}
	, {	true }
	, [16, [false,false,false]]
	, false
	, 0
	, true
] call CBA_fnc_addKeybind;

// Init
["dzn_GoTacs_SquadHUD_EH", "onEachFrame", { call fnc_handleSquadHUDEH; }] call BIS_fnc_addStackedEventHandler;
["dzn_GoTacs_ContacsHUD_EH", "onEachFrame", { call fnc_handleContactsHUDEH; }] call BIS_fnc_addStackedEventHandler;
["dzn_GoTacs_CommandHUD_EH", "onEachFrame", { call fnc_handleCommandHUD; }] call BIS_fnc_addStackedEventHandler;

call fnc_addFiredEH;

/*
player setUserActionText [dzn_GoTacs_MainAction, "<img size='2' image='\a3\ui_f\data\GUI\Rsc\RscDisplayArcadeMap\icon_sidebar_hide_up'/>"]
*/