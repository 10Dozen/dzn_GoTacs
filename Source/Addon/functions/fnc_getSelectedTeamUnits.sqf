/* ----------------------------------------------------------------------------
Function: dzn_GoTacs_fnc_getSelectedTeamUnits

Description:
	Return list of all units from selected teams (via dzn_GoTacs_fnc_handleTeamSelection).

Parameters:
	nothing

Returns:
	_units - list of the units of the selected teams <ARRAY>

Examples:
    (begin example)
		_units = [] call dzn_GoTacs_fnc_getSelectedTeamUnits; 
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

#include "..\macro.hpp"

#define T_RED GVAR(TeamRedSelected)
#define T_BLUE GVAR(TeamBlueSelected)
#define T_GREEN GVAR(TeamGreenSelected)
#define T_YELLOW GVAR(TeamYellowSelected)

private _result = [];

// --- If no teams selected -- return all squad
if (!T_RED && !T_BLUE && !T_GREEN && !T_YELLOW) exitWith {
	(units player)
};

// --- Selects units from specific groups
private _teamsUnits = player getVariable SVAR(Teams);
{
	if (_x select 0) then {
		_result = _result + (_x select 1);
	};
} forEach [
	[ T_RED, _teamsUnits # 0 ]
	, [ T_BLUE, _teamsUnits # 1 ]
	, [ T_GREEN, _teamsUnits # 2 ]
	, [ T_YELLOW, _teamsUnits # 3 ]
];

_result