
/* ----------------------------------------------------------------------------
Function: dzn_GoTacs_fnc_setupSquadUnits

Description:
	Set up units of player's squad and adds EHs and variables

Parameters:
	_this - (optional) units to apply. Default: (units player)

Returns:
	nothing

Examples:
    (begin example)
		call dzn_GoTacs_fnc_setupSquadUnits;
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

#include "..\macro.hpp"

private _units = [];

if (_this isEqualTo []) then {
	_units = units player;
} else {
	_units = _this;
};

{
	// --- Set unit skill
	_x setSkill 1;

	// --- Rating to prevent friendly fire and mounting problems
	_x addRating 999999;

	// --- Add Fired EH ---
	_x getVariable [SVAR(isFiring), false];
	_x addEventHandler ["FiredMan", {
		params ["_unit"];

		_unit setVariable [SVAR(isFiring), true];
		_unit spawn {
			sleep 0.1;
			_this setVariable [SVAR(isFiring), false];
		};
	}];

	// --- Turn off IWB/ICB 
	_x setVariable ["IWB_Disable", true, true];
	
} forEach _units;


