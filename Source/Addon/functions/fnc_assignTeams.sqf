/* ----------------------------------------------------------------------------
Function: dzn_GoTacs_fnc_assignTeams

Description:
	Assign units to teams according to given template

Parameters:
	_template - name of the team assignment templates <STRING>
	_group - (optional) group to assign teams. Default: player's group <GROUP>

Returns:
	nothing

Examples:
    (begin example)
		["4-4", group player] call dzn_GoTacs_fnc_assignTeams;
		["3-3-2"] call dzn_GoTacs_fnc_assignTeams;
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

#include "..\macro.hpp"

params ["_template", ["_grp", group player]];

private _units = units _grp;
private _teamRed = [];
private _teamBlue = [];
private _teamGreen = [];

private _mapping = [];

switch (toLower _template) do {
	case "4-4": {
		_mapping = [[1,3,5,7], [2,4,6,8] ];
	};
	case "3-3-2": {
		_mapping = [[1,3,5], [2,4,6], [7,8]];
	};
	case "3-4": {
		_mapping = [[1,3,5,7], [0,2,4,6]];
	};
};

for "_i" from 0 to (count _units) do {
	private _unit = _units select _i;
	switch (true) do {
		case (_i in (_mapping # 0)): {
			_unit assignTeam "RED";
			_teamRed pushBack _unit;
		};
		case (_i in (_mapping # 1)): {
			_unit assignTeam "BLUE";
			_teamBlue pushBack _unit;
		};
		case (_i in (_mapping # 2)): {
			_unit assignTeam "GREEN";
			_teamGreen pushBack _unit;
		};
	};
};

player setVariable [SVAR(TeamPattern), _template];
player setVariable [SVAR(Teams), [
	_teamRed
	, _teamBlue
	, _teamGreen
]];