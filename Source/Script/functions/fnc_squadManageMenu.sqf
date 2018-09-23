
/* ----------------------------------------------------------------------------
Function: dzn_GoTacs_fnc_squadManageMenu

Description:
	Module function to process Squad Manage menu (healing, kits, arsenal, add/remove units)

Parameters:
	_mode 	- mode of the function (e.g. open, heal, etc.) <STRING>
	_arg 	- (optional) argument for function run. Default: []. <ANY>

Returns:
	nothing

Examples:
    (begin example)
		[] spawn dzn_GoTacs_fnc_squadLoop;
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

#include "..\macro.hpp"

params["_mode", ["_arg", []]];

switch (toLower _mode) do {
	case "open": {
		private _units = (units player) - [player];
		private _menu = [
			[0, "HEADER", "Squad Creator"]
		];

		if (isNil "dzn_GoTacs_Kits") then {
			dzn_GoTacs_Kits = (allVariables missionNamespace) select { _x select [0,4] == "kit_" };
		};
		private _kitsDisplayItems = ["Heal", "Arsenal", "ACE Arsenal", "Renew kit", "Copy kit", "Apply kit"] + dzn_GoTacs_Kits + ["Expel", "Delete"];

		private _lineID = 0;

		{
			if (alive _x) then {
				_lineID = _lineID + 1;

				private _lineTitle = [
					_lineId
					, "LABEL"
					, format [
						"<t color='%2'>Unit #%1</t> %3%4"
						, _forEachIndex + 1
						, switch (assignedTeam (_units # _forEachIndex)) do {
							case "RED": 	{ "#f91818" };
							case "BLUE": 	{ "#2667ff" };
							case "GREEN": 	{ "#00aa4c" };
							default 		{ "#ffffff" };
						}
						, [_x, "icon"] call dzn_GoTacs_fnc_getUnitDamageData
						, if (loadAbs _x >= 1000) then { " Over-encumbered" } else { "" }

					]
				];
				private _lineKitSelector = [_lineId, "DROPDOWN", _kitsDisplayItems, _kitsDisplayItems];
				private _lineKitApply = [
					_lineId
					, "BUTTON"
					, "APPLY"
					, compile format ["
						private _unitID = %1; 
						private _unit = ((units player) - [player]) # _unitID;
						private _data = (_this # _unitID) # 1;

						switch (toLower _data) do {
							case 'heal': { 
								[""Hint"", [_unit, ""Healed!""]] call %2;
								[""Heal"", [_unit]] call %2;
							};
							case 'arsenal': {
								[_unit] spawn {
									closeDialog 2; 
									uiSleep 0.05;
									['Open',[true, objnull, _this # 0]] call bis_fnc_arsenal;
								};
							};
							case 'ace arsenal': {
								[_unit] spawn {
									closeDialog 2; uiSleep 0.05;
									[_this # 0, _this # 0, true] call ace_arsenal_fnc_openBox;
								};
							};
							case 'renew kit': {
								[""Hint"", [_unit, ""Kit renewed!""]] call %2;
								[_unit, _unit getVariable 'dzn_gear'] remoteExec ['dzn_fnc_gear_assignKit', _unit];
							};
							case 'copy kit': {
								[""Hint"", [_unit, ""Kit copied!""]] call %2;
								%3 = getUnitLoadout _unit;
							};
							case 'apply kit': {
								if (isNil { %3 }) then {
									[""Hint"", [_unit, ""No kit to apply!""]] call %2;
								} else {
									[""Hint"", [_unit, ""Kit applied!""]] call %2;
									_unit setUnitLoadout %3
								};
							};
							case 'expel': {
								[""Hint"", [_unit, ""Expeled from squad!""]] call %2;
								[""Expel"", [_unit]] call %2;
							};
							case 'delete': {
								[""Hint"", [_unit, ""Deleted from squad!""]] call %2;
								[""Delete"", [_unit]] call %2;
							};
							default {
								[""Hint"", [_unit, ""Kit applied!""]] call %2;
								[_unit, _data] remoteExec ['dzn_fnc_gear_assignKit', _unit];
							};
						}
						"
						, _forEachIndex
						, SVAR(fnc_squadManageMenu)
						, SVAR(CopiedUnitLoadout)
					]
				];

				_menu pushBack _lineTitle;
				_menu pushBack _lineKitSelector;
				_menu pushBack _lineKitApply;
			};
		} forEach _units;

		_lineId = _lineId + 1;
		_menu pushBack [_lineId, "LABEL", ""];

		_lineId = _lineId + 1;
		_menu pushBack [_lineId, "LABEL", ""];
		private _squadAction = ["Heal", "Renew kit","Apply kit"] + dzn_GoTacs_Kits + ["Expel", "Delete"];
		_menu pushBack [_lineId, "DROPDOWN", _squadAction, _squadAction];
		_menu pushBack [_lineId
			, "BUTTON"
			, "APPLY TO SQUAD"
			, compile format ["
				private _units = ((units player) - [player]);
				private _data = (_this # (count _this - 1)) # 1;
				private _hintTitle = ""Squad"";
			
				switch (toLower _data) do {
					case 'heal': { 
						[""Hint"", [_hintTitle, ""Healed!""]] call %2;
						[""Heal"", _units] call %2;
					};
					case 'renew kit': {
						[""Hint"", [_hintTitle, ""Kit renewed!""]] call %2;
						_units apply { [_x, _x getVariable 'dzn_gear'] remoteExec ['dzn_fnc_gear_assignKit', _x] };
					};
					case 'apply kit': {
						if (isNil { %3 }) then {
							[""Hint"", [_hintTitle, ""No kit to apply!""]] call %2;
						} else {
							[""Hint"", [_hintTitle, ""Kit applied!""]] call %2;
							_units apply { _x setUnitLoadout %3 };
						};
					};
					case 'expel': {
						[""Hint"", [_hintTitle, ""All units expeled from squad!""]] call %2;
						[""Expel"", _units] call %2;
					};
					case 'delete': {
						[""Hint"", [_hintTitle, ""All units deleted!""]] call %2;
						[""Delete"", _units] call %2;
					};
					default {
						[""Hint"", [_hintTitle, ""Kit applied!""]] call %2;
						_units apply { [_x, _data] remoteExec ['dzn_fnc_gear_assignKit', _x] };
					};
				}
			"
			, _lineId
			, SVAR(fnc_squadManageMenu)
			, SVAR(CopiedUnitLoadout)
		]];

		_lineId = _lineId + 1;
		_menu pushBack [_lineId, "LABEL", ""];


		_lineId = _lineId + 1;
		_menu pushBack [_lineId, "BUTTON", "CLOSE", { closeDialog 2; }];
		_menu pushBack [_lineId, "LABEL", ""];
		_menu pushBack [_lineId, "BUTTON", "ADD UNIT", {
			[] spawn {
				closeDialog 2;
				uiSleep 0.01;
				private _unit = (group player) createUnit [typeof player, position player, [], 0, "FORM"];
				["Hint", [_unit, 'Unit created!']] call GVAR(fnc_squadManageMenu);

				[_unit] call GVAR(fnc_setupSquadUnits);

				["Open"] spawn GVAR(fnc_squadManageMenu);
			};
		}];


		_menu call dzn_GoTacs_fnc_ShowAdvDialog;
	};


	// --- Healing (vanilla + ACEM_Medical) ---
	case "heal": {
		// _arg = array of units
		if (_arg isEqualTo []) exitWith {};
		{
			_x setDamage 0;
			[_x,_x] call ace_medical_fnc_treatmentAdvanced_fullHealLocal;;
		} forEach _arg;
	};

	// --- Expel unit ---
	case "expel": {
		// _arg = array of units
		if (_arg isEqualTo []) exitWith {};

		_arg spawn {
			closeDialog 2;
			uiSleep 0.05;

			private _newGrp = player getVariable [SVAR(ExpelGroup), grpNull];
			if (isNull _newGrp) then {
				_newGrp = createGroup (side player);
				player setVariable [SVAR(ExpelGroup), _newGrp];
			};

			_this join _newGrp;

			uiSleep 0.005;
			["Open"] call GVAR(fnc_squadManageMenu);
		};
	};

	// --- Delete units ---
	case "delete": {
		// _arg = array of units
		if (_arg isEqualTo []) exitWith {};

		_arg spawn {
			closeDialog 2; 
			uiSleep 0.05;

			_this apply { deleteVehicle _x };
			
			uiSleep 0.005;
			["Open"] call GVAR(fnc_squadManageMenu);
		};
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
