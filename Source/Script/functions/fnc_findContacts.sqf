
/* ----------------------------------------------------------------------------
Function: dzn_GoTacs_fnc_findContacts

Description:
	Return all hostile contacts known by player's squad

Parameters:
	nothing

Returns:
	_targets - list of known targets in format as described in https://community.bistudio.com/wiki/targetsQuery <ARRAY>

Examples:
    (begin example)
		_tgts = call dzn_GoTacs_fnc_findContacts;
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

private _targets = [];
private _units = [];
private _squad = (units player) select { !isPlayer _x };

if (count _squad == 0) exitWith { [] };
if (count _squad > 4) then {
	for "_i" from 1 to 2 do {
		private _selectedUnit = selectRandom _squad;
		_squad = _squad - [_selectedUnit];
		_units pushBack _selectedUnit;
	}
} else {
	_units pushBack (selectRandom _squad);
};

{
	private _unit = _x;
	private _unitTargets = (
		_unit targetsQuery [objNull, sideEnemy, "", [], 0]
	)  select { [side _unit, _x select 2] call BIS_fnc_sideIsEnemy };

	{ _targets pushBackUnique _x; } forEach _unitTargets;
} forEach _units;

_targets