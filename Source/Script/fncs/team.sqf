fnc_assignTeam = {
	params ["_grp", "_template"];

	private _units = units _grp;
	private _teamRed = [];
	private _teamBlue = [];
	private _teamGreen = [];

	private _mapping = [];

	switch (toLower _template) do {
		case "nato": {
			_mapping = [ [1,3,5,7], [2,4,6,8] ];
		};
		case "rumsv": {
			_mapping = [ [1,3,5], [2,4,6], [7,8]];
		};
	};

	for "_i" from 1 to (count _units) do {
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

	player setVariable ["dzn_GoTacs_TeamAssignmentName", _template];
};


fnc_addFiredEH = {
	private _squad = (units player) - [player];

	{
		_x addEventHandler ["FiredMan", { _this call fnc_firedEH }];
	} forEach _squad;
};

fnc_firedEH = {
	params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_vehicle"];

	_unit setVariable ["dzn_GoTacs_isFiring", true];
	_unit spawn {
		sleep 0.1;
		_this setVariable ["dzn_GoTacs_isFiring", false];
	};
};


fnc_findTargets = {
	private _targets = [];
	private _squad = units player - [player];
	private _units = [];

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
};
