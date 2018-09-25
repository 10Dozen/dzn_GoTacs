/* ----------------------------------------------------------------------------
Function: dzn_GoTacs_fnc_handleTeamSelection

Description:
	Handles team selection via Arma 3 buttons

Parameters:
	

Returns:
	nothing

Examples:
    (begin example)
		["add"] spawn dzn_GoTacs_fnc_handleTeamSelection;
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

#include "..\macro.hpp"

params ["_mode", ["_args", []]];

#define SELF dzn_GoTacs_fnc_handleTeamSelection
#define T_RED GVAR(TeamRedSelected)
#define T_BLUE GVAR(TeamBlueSelected)
#define T_GREEN GVAR(TeamGreenSelected)
#define T_YELLOW GVAR(TeamYellowSelected)

switch (toLower _mode) do {
	case "add": {
		["itemAdd", [
			"SelectTeamHandler"
			, {
				if (inputAction "SelectTeamRed" > 0) exitWith { 
					["Handle", "RED"] call SELF;
				};

				if (inputAction "SelectTeamBlue" > 0) exitWith { 
					["Handle", "BLUE"] call SELF;
				};

				if (inputAction "SelectTeamGreen" > 0) exitWith { 
					["Handle", "GREEN"] call SELF;
				};

				if (inputAction "SelectTeamYellow" > 0) exitWith { 
					["Handle", "YELLOW"] call SELF;
				};
			}
			, 2
			, "frames"
		]] call BIS_fnc_loop;

	};
	case "handle": {
		if (GVAR(TeamSelectionTimeout) > time) exitWith {};

		switch (toLower _args) do {
			case "red": { GVAR(TeamRedSelected) = !GVAR(TeamRedSelected); };
			case "blue": { GVAR(TeamBlueSelected) = !GVAR(TeamBlueSelected); };
			case "green": { GVAR(TeamGreenSelected) = !GVAR(TeamGreenSelected); };
			case "yellow": { GVAR(TeamYellowSelected) = !GVAR(TeamYellowSelected); };
		};

		[
			GVAR(TeamRedSelected)
			,GVAR(TeamBlueSelected)
			,GVAR(TeamGreenSelected)
			,GVAR(TeamYellowSelected)
		] call GVAR(fnc_uiDrawTeamSelection);

		GVAR(TeamSelectionTimeout) = time + 0.25;
		
		GVAR(TeamDeselectionTimeout) = time + 10;
		GVAR(TeamDeselectionTimedHandlerID) = str(round time);

		GVAR(TeamDeselectionTimedHandlerID) spawn {
			waitUntil { 
				sleep 1; 
				GVAR(TeamDeselectionTimeout) < time || GVAR(TeamDeselectionTimedHandlerID) != _this
			};

			if (GVAR(TeamDeselectionTimedHandlerID) != _this) exitWith {};
			["Deselect"] call SELF;
		};
	};
	case "deselect": {
		T_RED = false;
		T_BLUE = false;
		T_GREEN = false;
		T_YELLOW = false;
		
		[T_RED, T_BLUE, T_GREEN, T_YELLOW] call GVAR(fnc_uiDrawTeamSelection);
	}
};



/*
Handle selecting team
see details: https://community.bistudio.com/wiki/inputAction/actions
 
[] spawn { 
 waitUntil {inputAction "SelectTeamRed" > 0};   
 hint "Red team selected"; 
 [(player getVariable "dzn_GoTacs_Teams") # 0, cursorObject] spawn fnc_breach;
};
*/