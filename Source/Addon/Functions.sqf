
#include "macro.hpp"


COMPILE_FUNCTION(fnc_uiCreateClickableLabel);
COMPILE_FUNCTION(fnc_uiShowMainOverlay);
COMPILE_FUNCTION(fnc_uiShowSettingsOverlay);

COMPILE_FUNCTION(fnc_getUnitDamageData);

COMPILE_FUNCTION(fnc_setupSquadUnits);
COMPILE_FUNCTION(fnc_assignTeams);

COMPILE_FUNCTION(fnc_uiShowHUD);
COMPILE_FUNCTION(fnc_uiHideHUD);

COMPILE_FUNCTION(fnc_squadLoop);
COMPILE_FUNCTION(fnc_uiDrawSquadHUD);

COMPILE_FUNCTION(fnc_findContacts);
COMPILE_FUNCTION(fnc_contactsLoop);
COMPILE_FUNCTION(fnc_uiDrawContactsHUD);

COMPILE_FUNCTION(fnc_squadManageMenu);
COMPILE_FUNCTION(fnc_squadCustomizeMenu);
COMPILE_FUNCTION(fnc_squadAssignVehicleRole);





// --- UTILITY ---
fnc_resetContactLoop = {
	hint "GoTacs: Reseting contacts HUD in 10 seconds";
	GVAR(ContactsLoopEnabled) = false;
	GVAR(ContactsNextRequestTime) = time;

	sleep 10;

	GVAR(ContactsLoopEnabled) = true;

	GVAR(ContactsData) = [];
	[] spawn GVAR(fnc_contactsLoop);
};



// --- ORDERS: MOVE ---
/*
fnc_breach2 = {
	params ["_units","_building"];

	if (_units isEqualTo []) then {
		_units = units player - [player];
	};

	private _hPositions = [_building] call BIS_fnc_buildingPositions;
	if (_hPositions isEqualTo []) exitWith { hint "Not enterable!"; };

	private _posPerUnits = round ( (count _hPositions) / (count _units) );
	private _index = 0;
	
	{
		private _poses = [];
		for "_i" from 1 to _posPerUnits do {
			_poses pushBack (_hPositions select _index);
			_index = _index + 1;
		};

		[_x, _poses] spawn fnc_doBreach;
	} forEach _units;
};

*/


fnc_breach = {
	params ["_units","_building"];

	if (_units isEqualTo []) then {
		_units = units player - [player];
	};

	private _hPoses = [_building] call BIS_fnc_buildingPositions;
	if (_hPoses isEqualTo []) exitWith { hint "Not enterable!"; };

	// --- Split positions by number of units pairs
	private _pairsCount = floor (count _units / 2);
	private _pairs = [_pairsCount, _units] call fnc_getDistibutionMap;
	private _map = [_pairs, _hPoses] call fnc_getDistibutionMap;

	{
		private _index = _forEachIndex;
		private _pairUnits = _x;
		private _poses = _map select _index;

		{
			[_x, _poses] spawn fnc_doBreach;
		} forEach _pairUnits;
	} forEach _pairs;
};

fnc_doBreach = {
	params ["_u", "_poses"];

	{
		private _timeout = time + 20;
		_u doMove _x;
		waitUntil { sleep 1; _u distance _x < 1.5 || time > _timeout };
	} forEach _poses;
};

fnc_getDistibutionMap = {
	// Return array of items distributed between given consumers, e.g. [ [@Item1, @Item2, @Item3], [@ItemN, @ItemN+1], [@ItemM, @ItenM+1] ]
	// _consumers - <NUMBER> or <ARRAY> to distribute between 
	// _items - <ARRAY> of data to be distributed
	params ["_consumers", "_items"];

	private _itemCount = count _items; 
	private _consumerCount = if (typename _consumers == "SCALAR") then { _consumers } else { count _consumers };

	private _times = floor (_itemCount/_consumerCount); // min. items per each consumer 
	private _left = _itemCount - _times * _consumerCount; // items left undistributed

	private _result = [];

	// --- Divide items between each consumer
	for "_i" from 1 to _consumerCount do {
		private _consumerItems = [];
		for "_j" from 1 to _times do {
			_consumerItems pushBack (_items select ((_i-1)*_times + _j - 1));
		};

		_result pushBack _consumerItems;
	};

	// --- Distribute left items, until any item left
	while { _left > 0 } do {
		for "_i" from 0 to (_consumerCount - 1) do {
			if (_left == 0) exitWith {};
			_result set [_i, (_result select _i) + [ _items select ( _itemCount - _left ) ]];
			_left = _left - 1;
		};
	};
	
	_result
};



// --- ORDERS ---
fnc_dismountFast = {
	private _units = _this select {
		private _vrole = assignedVehicleRole _x;

		!isPlayer _x
		&& !(
			"driver" in _vrole
			|| "gunner" in _vrole
			|| "turret" in _vrole
			|| "Turret" in _vrole
		)
	};

	_units spawn fnc_bailOut;	
};

fnc_bailOut = {
	private _units = _this - [player];

	{
		[_x, assignedVehicle _x, _forEachIndex % 2 == 0] spawn {
			params ["_u", "_v", "_isDirLeft"];

			waitUntil { (velocity _v select 0) < 2 };

			unassignVehicle _u;
			moveOut _u;

			private _posX = if (_isDirLeft) then { 1 } else { -1 };
			private _pos = _v modelToWorld [_posX * 25, -25, 0];
			
			[_u, _pos getPos [10, random 360], 20, [true, _v]] spawn fnc_sprintTo;
		};

		sleep (0.35 + random 0.5);
	} forEach _units;
};

fnc_sprintTo = {
	params ["_u", "_pos", ["_timeout", 20], ["_doOverwatch", [false, objNull]]];
	_timeout = time + _timeout;

	_u doMove _pos;
	waitUntil { 
		_u setAnimSpeedCoef 1.5; 
		
		sleep 0.5;
		_u distance _pos < 2.5 || time > _timeout
	};

	_u setAnimSpeedCoef 1;

	if (_doOverwatch # 0) then {
		sleep 1.5;
		_posToWatch = (_doOverwatch # 1) modelToWorld [selectRandom[1,-1] * 50, 50, 0];
		_u doWatch _posToWatch;

		sleep 3;
		_u doWatch objNull; 
	};
};

fnc_getInFast = {
	params ["_units","_v"];
	_units = _units - [player];

	{
		if (vehicle _x == _x) then {
			[_x, _v, _role] spawn {
				params ["_u","_v","_r"];

				private _timeout = time + 20;

				[_u, getPos _v, 20] spawn fnc_sprintTo;

				waitUntil { 
					_u distance (getPos _v) < 6.5 
					|| time > _timeout
				};

				if (_u distance (getPos _v) < 6.5) then {
					sleep 1.5;
					_u moveInAny _v;
				};

				_u setAnimSpeedCoef 1; 
			};
		};
	} forEach _units;
};