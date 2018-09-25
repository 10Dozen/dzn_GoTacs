/* ----------------------------------------------------------------------------
Function: dzn_GoTacs_fnc_getUnits

Description:
	Return filtered list of the given units or the player's group according specific conditions.
	Other players are always excluded;

Parameters:
	_mode - filter name <STRING>:
		"" - all units
		"NotCrew" - all units except crew 
		"NotInVehicle" - all units not in vehicle
		"Crew" - only vehicle crew (driver, gunner, commander)
		"InVehicle" - all mounted units 
		"InVehicleCargo" - all mounted units that are not crew

Returns:
	_units - filtered list of units <ARRAY>

Examples:
    (begin example)
		_mountedUnits = ["InVehicle"] call dzn_GoTacs_fnc_getUnits; 
		_unitsNotInCrew = ["NotCrew"] call dzn_GoTacs_fnc_getUnits; 
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

#include "..\macro.hpp"

params [["_filter", ""], ["_units", units player]];

private _result = [];

#define P_UNITS _units
#define NOT_IS_P !(isPlayer _x)

switch (toLower _filter) do {
	case "crew": {
		_result = P_UNITS select { 
			private _vrole = assignedVehicleRole _x;
			NOT_IS_P && ("driver" in _vrole || "gunner" in _vrole || "turret" in _vrole || "Turret" in _vrole)
		};
	};
	case "notcrew": {
		_result = P_UNITS select { 
			private _vrole = assignedVehicleRole _x;
			NOT_IS_P && ("driver" in _vrole || "gunner" in _vrole || "turret" in _vrole || "Turret" in _vrole)
		};
	};	
	case "invehiclecargo": {
		_result = P_UNITS select { 
			NOT_IS_P && ("cargo" in assignedVehicleRole _x)
		};
	};
	case "invehicle": {
		_result = P_UNITS select { NOT_IS_P && vehicle _x != _x };
	};
	case "notinvehicle": {
		_result = P_UNITS select { NOT_IS_P && vehicle _x == _x };
	};
	default {
		_result = P_UNITS select { NOT_IS_P };
	};
};

_result