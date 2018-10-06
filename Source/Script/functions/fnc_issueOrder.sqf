/* ----------------------------------------------------------------------------
Function: dzn_GoTacs_fnc_issueOrder

Description:
	Modular function for issuing Orders to units

Parameters:
	_order	- name of the mode <STRING>
	_arg 	- (optional) argument for function run. Default: []. <ANY>

Returns:
	nothing

Examples:
    (begin example)
		["get in fast", [_units, cursorObject]] spawn dzn_GoTacs_fnc_issueOrder
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

#include "..\macro.hpp"

#define SELF GVAR(fnc_issueOrder)
#define SET_ORDER_SCRIPT _x setVariable [SVAR(OrderExecutionScript), _script]

params["_order", ["_args", []]];

switch (toLower _order) do {
	// --- Group execution
	case "get in fast": {
		// --- Order to fast vehicle mount 
		_args params ["_units", "_v"];

		private _notMountedUnits = ["NotInVehicle", _units] call GVAR(fnc_getUnits);
		{
			private _script = ["Unit Get in fast", [_x, _v]] spawn SELF;
			SET_ORDER_SCRIPT;
		} forEach _notMountedUnits;
	};
	case "bail out": {
		// --- Order to fast vehicle leaving
		private _mountedUnits = ["InVehicle", _args] call GVAR(fnc_getUnits);
		
		{
			private _script = ["Unit Bail out", [_x, _forEachIndex % 2 == 0]] spawn SELF;
			SET_ORDER_SCRIPT;
		} forEach _mountedUnits;
	};
	case "dismount fast": {
		// --- Order to dismount units from cargo 
		private _mountedCargoUnits = ["InVehicleCargo", _args] call GVAR(fnc_getUnits);

		{
			private _script = ["Unit Bail out", [_x, _forEachIndex % 2 == 0]] spawn SELF;
			SET_ORDER_SCRIPT;
		} forEach _mountedCargoUnits;
	};
	case "breach": {
		// --- Order to clear rooms of building
		_args params ["_units", "_building"];
		
		_units = ["NotInVehicle", _units] call GVAR(fnc_getUnits);
		
		private _hPoses = [_building] call BIS_fnc_buildingPositions;
		if (_hPoses isEqualTo []) exitWith { hint "Not enterable!"; };

		// --- Split positions by number of units pairs
		private _pairsCount = floor (count _units / 2);
		private _pairs = [_pairsCount, _units] call GVAR(fnc_getDistibutionMap);
		private _map = [_pairs, _hPoses] call GVAR(fnc_getDistibutionMap);

		{
			private _index = _forEachIndex;
			private _pairUnits = _x;
			private _poses = _map select _index;

			{
				private _script = ["Unit Breach", [_x, _poses]] spawn SELF;
				SET_ORDER_SCRIPT;
			} forEach _pairUnits;
		} forEach _pairs;
	};
	case "rally up": {
		// --- Order to move to player 
		private _units = ["NotInVehicle", _args] call GVAR(fnc_getUnits);
		{
			private _script = ["Unit Rally up", [_x, player getPos [random 10, random 360]]] spawn SELF;
			SET_ORDER_SCRIPT;
		} forEach _units;
	};
	case "find cover": {
		private _units = ["NotInVehicle", _args] call GVAR(fnc_getUnits);
		{
			private _script = ["Unit Find cover", _x] spawn SELF;
			SET_ORDER_SCRIPT;
		} forEach _units;
	};
	case "abort": {
		private _units = _args;
		{
			["Unit abort", _x] spawn SELF;
		} forEach _units;
	};
	case "camera": {
		private _unit = _args # 0;

		if (!isNull _unit) then {

			// Trying to attach cam to same unit
			if (!isNil "dzn_CamTarget" && { dzn_CamTarget isEqualTo _unit && !isNull cam }) exitWith {};

			if (isNil "cam" || { isNull cam }) then {
				cam = objNull;
				
				call fnc_EndCam;
				[_unit] call fnc_StartCam;
			} else {
				dzn_CamTarget = _unit;
				[0,0] call fnc_camRotate;
			};			
		};
	};

	// --- Unit execution
	case "unit sprint to": {
		// --- Sprint to position (timed)
		_args params ["_u", "_pos", ["_timeout", 10], ["_doOverwatch", [false, objNull]]];	

		private _orderID = "";
		if (_doOverwatch # 0) then {
			_orderID = ["Make order", [_u, "Sprinting"]] call SELF;
		};

		_timeout = time + _timeout;

		_u doMove _pos;
		waitUntil { 
			_u setAnimSpeedCoef 1.5; sleep 0.5;
			_u distance _pos < 2.5 || time > _timeout
		};

		_u setAnimSpeedCoef 1;

		if !(_doOverwatch # 0) exitWith {};		
		sleep 1.5;
		_posToWatch = (_doOverwatch # 1) modelToWorld [selectRandom[1,-1] * 50, 50, 0];
		_u doWatch _posToWatch;
		sleep 3;
		_u doWatch objNull;

		["Finish order", [_u, _orderID]] call SELF;
	};
	case "unit get in fast": {
		// --- Move unit to vehicle and move in
		_args params ["_u","_v"];

		private _orderID = ["Make order", [_u, "Getting In"]] call SELF;
		private _timeout = time + 20;
		private _pos = getPos _v;

		["Unit Sprint to", [_u, _pos, 20]] spawn SELF;

		waitUntil {
			sleep 0.5;
			_u distance _pos < 6.5 || time > _timeout
		};

		if (_u distance (getPos _v) < 6.5) then {
			sleep 1.5;
			_u moveInAny _v;
		};

		_u setAnimSpeedCoef 1;

		["Finish order", [_u, _orderID]] call SELF;
	};
	case "unit bail out": {
		// --- Move unit out of vehicle and move away from vehicle
		_args params ["_u", "_isDirLeft"];

		private _orderID = ["Make order", [_u, "Bailing out"]] call SELF;
		private _v = assignedVehicle _u;

		waitUntil { (velocity _v select 0) < 2 };

		sleep (0.36 + random 0.5);
		unassignVehicle _u;
		moveOut _u;

		private _posX = if (_isDirLeft) then { 1 } else { -1 };
		private _pos = _v modelToWorld [_posX * 25, -25, 0];

		["Finish order", [_u, _orderID]] call SELF;

		private _script = [
			"Unit Sprint to"
			, [_u, _pos getPos [10, random 360], 20, [true, _v]]
		] spawn SELF;
		_u setVariable [SVAR(OrderExecutionScript), _script];
	};
	case "unit breach": {
		// --- Move unit through building positions
		_args params ["_u", "_poses"];
		
		private _orderID = "";
		private _timeout = 0;

		{
			_orderID = ["Make order", [
				_u
				, format ["Clearing %1%2", floor (100 * (_forEachIndex / count _poses)), "%"]
			]] call SELF;

			_timeout = time + 20;
			_u doMove _x;

			waitUntil {
				sleep 1;
				_u distance _x < 1.5 || time > _timeout
			};

			["Finish order", [_u, _orderID]] call SELF;
		} forEach _poses;
	};
	case "unit rally up": {
		// --- Force unit to move on position (player) or teleport if unit stuck
		_args params ["_u", "_pos"];

		private _orderID = "";
		private _timeout = 0;

		for "_i" from 1 to 3 do {
			_orderID = [
				"Make order"
				, [_u, format ["Rallying Up %1/3", _i]]
			] call SELF;

			_timeout = time + 10;

			["Unit Sprint to", [_u, _pos, 10]] spawn SELF;

			waitUntil {
				sleep 0.5;
				_u distance _pos < 5 || time > _timeout
			};

			if (_u distance _pos <= 5) exitWith { 
				["Finish order", [_u, _orderID]] call SELF;
			};
		};

		if (_u distance _pos > 5) then {
			// --- Unit didn't rallied (stuck) -- teleport
			for "_i" from 3 to 0 step -1 do {
				_orderID = [
					"Make order", [_u, format ["Rallying Up [Forced in %1 sec]", _i]]
				] call SELF;
				sleep 1;
			};

			_u allowDamage false;
			_u setVelocity [0,0,0];

			_u setPos _pos;

			sleep 1;
			_u allowDamage true;
			
			["Finish order", [_u, _orderID]] call SELF;
		};
	};
	case "unit find cover": {
		// --- 
		private _u = _args;	
		private _orderID = "";

		private _nearestCovers = nearestTerrainObjects [
			getPos _u
			,  ["BUILDING", "HOUSE", "CHURCH", "CHAPEL", "BUNKER", "FORTRESS", "FOUNTAIN", "HOSPITAL", "RUIN", "TOURISM", "WATERTOWER","POWERSOLAR", "POWERWIND" ]
			, 30
			, true
			, false
		];
		
		if (_nearestCovers isEqualTo []) then {
			_nearestCovers = nearestTerrainObjects [
				getPos _u
				,  ["ROCK", "ROCKS", "TREE", "FOREST", "FOREST BORDER", "FOREST TRIANGLE", "FOREST SQUARE", "FENCE", "WALL", "STACK", "RAILWAY"]
				, 30
				, true
				, false
			];
		};
		
		if (_nearestCovers isEqualTo []) then {
			_orderID = ["Make order", [_u, "No cover"]] call SELF;

			_u setUnitPos "DOWN";
			sleep 10;
			_u setUnitPos "AUTO";

			["Finish order", [_u, _orderID]] call SELF;
		} else {
			_orderID = ["Make order", [_u, "Moving to cover"]] call SELF;
			private _pos = getPos (selectRandom _nearestCovers);
			private _timeout = time + 20;

			["Unit Sprint to", [_u, _pos]] spawn SELF;
			
			waitUntil {
				sleep 1;
				_u distance _pos < 18 || time > _timeout
			};

			_orderID = ["Make order", [_u, "In cover"]] call SELF;
			_u setUnitPos "MIDDLE";
			sleep 5;
			_u setUnitPos "AUTO";
			["Finish order", [_u, _orderID]] call SELF;
		};
	};
	case "unit abort": {
		private _u = _args;	
		private _script = _u getVariable [SVAR(OrderExecutionScript), scriptNull];

		if (scriptDone _script) exitWith {};
		
		terminate _script;

		_u setVariable [SVAR(OrderExecutionScript), nil];
		["Finish order", [_u, "", true]] call SELF; // Force drop of orderID
	};

	// --- UTILITY --- 
	case "make order": {
		// --- Mark unit in order execution state
		_args params ["_u", "_orderType"];

		_u setVariable [SVAR(CurrentOrder), _orderType];

		(_orderType)
	};
	case "finish order": {
		// --- Unmark unit from order execution state if order id is not changed
		_args params ["_u", "_orderType", ["_forced", false]];

		if (!_forced && { _u getVariable [SVAR(CurrentOrder), ""] != _orderType }) exitWith {};

		_u setVariable [SVAR(CurrentOrder), nil];
	};
};

