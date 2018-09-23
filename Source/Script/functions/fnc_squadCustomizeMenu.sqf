
/* ----------------------------------------------------------------------------
Function: dzn_GoTacs_fnc_squadCustomizeMenu

Description:
	Module function to process Squad Customize menu (team assignement)

Parameters:
	_mode 	- mode of the function (e.g. open, heal, etc.) <STRING>
	_arg 	- (optional) argument for function run. Default: []. <ANY>

Returns:
	nothing

Examples:
    (begin example)
		["Open", []] spawn dzn_GoTacs_fnc_squadCustomizeMenu;
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

#include "..\macro.hpp"

params["_mode", ["_arg", []]];

switch (toLower _mode) do {
	case "open": {
		private _units = (units player) - [player];
		// --- Header
		private _menu = [
			[0, "HEADER", "Team assignement"]
		];

		// --- Body
		private _displayItems = ["RED", "BLUE", "GREEN", "YELLOW", "WHITE"];
		private _lineId = 0;
		{
			if (alive _x) then {
				_lineID = _lineID + 1;
				private _lineTitle = [
					_lineID
					, "LABEL"
					, format [
						"<t color='%2'>Unit #%1</t>"
						, _forEachIndex + 1
						, switch (assignedTeam (_units # _forEachIndex)) do {
							case "RED": 	{ "#f91818" };
							case "BLUE": 	{ "#2667ff" };
							case "GREEN": 	{ "#00aa4c" };
							case "YELLOW":	{ "#efdb28" };
							default 		{ "#ffffff" };
						}
					]
				];

				private _lineSelector = [_lineID, "DROPDOWN", _displayItems, _displayItems];
				private _lineApply = [
					_lineID
					, "BUTTON"
					, "APPLY"
					, compile format ["
						private _unitID = %1; 
						private _unit = ((units player) - [player]) # _unitID;
						private _data = (_this # _unitID) # 1;

						if (_data == ""WHITE"") then { _data = ""MAIN""; };
						_unit assignTeam toUpper(_data);

						[""Hint"", [_unit, ""Assigned to "" + toUpper(_data)]] call %2;
						[""CUSTOM""] call %3;
						"
						, _forEachIndex
						, SVAR(fnc_squadCustomizeMenu)
						, SVAR(fnc_assignTeams)
					]
				];

				_menu pushBack _lineTitle;
				_menu pushBack _lineSelector;
				_menu pushBack _lineApply;
			};
		} forEach _units;


		// -- Squad action
		_lineId = _lineId + 1;
		_menu pushBack [_lineId, "LABEL", ""];
		
		_lineId = _lineId + 1;
		_menu pushBack [_lineId, "LABEL", ""];
		_menu pushBack [_lineId, "DROPDOWN", _displayItems, _displayItems];
		_menu pushBack [_lineId
			, "BUTTON"
			, "APPLY TO SQUAD"
			, compile format ["
				_this spawn {
					private _units = ((units player) - [player]);
					private _data = (_this # (count _this - 1)) # 1;
					private _hintTitle = ""Squad"";

					if (_data == ""WHITE"") then { _data = ""MAIN""; };

					closeDialog 2; uiSleep 0.005;
					{ _x assignTeam toUpper(_data) } forEach _units;

					[""Hint"", [""SQUAD"", ""Assigned to "" + toUpper(_data)]] call %2;

					[""CUSTOM""] call %3;

					[""Open"", []] spawn %2;
				};
				"
				, _lineId
				, SVAR(fnc_squadCustomizeMenu)
				, SVAR(fnc_assignTeams)
			]
		];

		// --- Footer 
		_lineId = _lineId + 1;
		_menu pushBack [_lineId, "LABEL", ""];

		_lineId = _lineId + 1;
		_menu pushBack [_lineId, "BUTTON", "CLOSE", { closeDialog 2; }];
		_menu pushBack [_lineId, "LABEL", ""];
		_menu pushBack [_lineId, "LABEL", ""];

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
};
