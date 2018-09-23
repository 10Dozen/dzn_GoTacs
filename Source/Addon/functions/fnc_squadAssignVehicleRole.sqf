
/* ----------------------------------------------------------------------------
Function: dzn_GoTacs_fnc_squadAssignVehicleRole

Description:
	Module function to assign units to vehicle

Parameters:
	_mode 	- mode of the function (e.g. open, heal, etc.) <STRING>
	_arg 	- (optional) argument for function run. Default: []. <ANY>

Returns:
	nothing

Examples:
    (begin example)
		["Open", []] spawn dzn_GoTacs_fnc_squadAssignVehicleRole;
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

#include "..\macro.hpp"

params["_mode", ["_arg", []]];

switch (toLower _mode) do {

	// arg - [@Vehicle]
	case "open": {
		private _v = _arg select 0;
		GVAR(VehicleToLoad) = _v;
		private _units = (units player) - [player];
		// --- Header
		private _menu = [
			[0, "HEADER", "Vehicle assignement"]
		];

		// --- Body
		private _displayItems = ["--Select seat--"];
		private _dataItems = [ "" ];
		private _seats = [];
		{
			_seats pushBack [_x, (_v emptyPositions _x)];
		} forEach ["Cargo", "Driver", "Commander", "Gunner"];

		{
			_x params ["_seatType", "_count"];

			if (_count > 0) then {
				_displayItems pushBack _seatType;
				_dataItems pushBack _seatType;
			}


			/*

			for "_i" from 1 to _count do {
				_displayItems pushBack format ["%1 %2", _seatType, _i];
				_dataItems pushBack [_seatType, _i];
			};
			*/
		} forEach _seats;

		private _lineId = 0;
		{
			if (alive _x) then {
				
				_lineID = _lineID + 1;

				private _unit = _x;
				private _lineTitle = [
					_lineID
					, "LABEL"
					, format [
						"<t color='%2'>Unit #%1</t> %3"
						, _forEachIndex + 1
						, switch (assignedTeam _unit) do {
							case "RED": 	{ "#f91818" };
							case "BLUE": 	{ "#2667ff" };
							case "GREEN": 	{ "#00aa4c" };
							case "YELLOW":	{ "#efdb28" };
							default 		{ "#ffffff" };
						}
						, assignedVehicleRole _unit select 0
					]
				];

				private _lineSelector = [_lineID, "DROPDOWN", _displayItems, _dataItems];
				private _lineApply = [
					_lineID
					, "BUTTON"
					, "Assign"
					, compile format ["
						private _unitID = %1; 
						private _unit = ((units player) - [player]) # _unitID;
						private _data = (_this # _unitID) # 1;

						if (_data == ""--Select seat--"") exitWith {};

						[""Hint"", [_unit, ""Assigned to "" + toUpper(_data)]] call %2;

						[""Move"", [_unit, %3, _data]] spawn %2;
						"
						, _forEachIndex
						, SVAR(fnc_squadAssignVehicleRole)
						, SVAR(VehicleToLoad)
					]
				];

				/*
				

						if (_data isEqualTo ["",-1]) exitWith {};
					
						*/

				_menu pushBack _lineTitle;
				_menu pushBack _lineSelector;
				_menu pushBack _lineApply;
			};
		} forEach _units;

		// --- Footer 
		_lineId = _lineId + 1;
		_menu pushBack [_lineId, "LABEL", ""];

		_lineId = _lineId + 1;
		_menu pushBack [_lineId, "BUTTON", "CLOSE", { closeDialog 2; }];
		_menu pushBack [_lineId, "LABEL", ""];
		_menu pushBack [_lineId, "LABEL", ""];
		// _menu pushBack [_lineId, "BUTTON", "APPLY ALL", { closeDialog 2; }];

		_menu call GVAR(fnc_ShowAdvDialog);
	};

	// --- Draw hint ---
	case "hint": {
		// _arg = [@Unit<OBJECT>, @ActionText<STRING>]
		if (_arg isEqualTo []) exitWith {};

		_arg params ["_unitTitle","_action"];

		hint parseText format [
			"<t size='1' color='#FFD000' shadow='1'>%1:</t>
			<br />%2"
			, if (typename _unitTitle == "OBJECT") then { "Unit " + (name _unitTitle) } else { _unitTitle }
			, _action
		];
	};

	// --- Move in selected 
	case "move": {
		_arg params ["_unit", "_v","_seatType"];
	
		[_unit, getPos _v] spawn fnc_sprintTo;

		sleep 5;

		private _timeout = time + 20;		
		waitUntil { sleep 0.5; _unit distance _v < 6.5 || _timeout < time };

		switch (toLower _seatType) do {
			case "cargo": {
				_unit assignAsCargo _v;
				_unit moveInCargo _v;
			};
			case "driver": {
				_unit assignAsDriver _v;
				_unit moveInDriver _v;
			};
			case "gunner": {
				_unit assignAsGunner _v;
				_unit moveInGunner _v;
			};
			case "commander": {
				_unit assignAsCommander _v;
				_unit moveInCommander _v;
			};
		};
	};
};