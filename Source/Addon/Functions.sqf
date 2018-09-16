
#include "macro.hpp"


COMPILE_FUNCTION(fnc_uiCreateClickableLabel);
COMPILE_FUNCTION(fnc_uiShowMainOverlay);
COMPILE_FUNCTION(fnc_uiShowSettingsOverlay);

COMPILE_FUNCTION(fnc_setupSquadUnits);
COMPILE_FUNCTION(fnc_assignTeams);

COMPILE_FUNCTION(fnc_uiShowHUD);
COMPILE_FUNCTION(fnc_uiHideHUD);

COMPILE_FUNCTION(fnc_squadLoop);
COMPILE_FUNCTION(fnc_uiDrawSquadHUD);

COMPILE_FUNCTION(fnc_findContacts);
COMPILE_FUNCTION(fnc_contactsLoop);
COMPILE_FUNCTION(fnc_uiDrawContactsHUD);


dzn_GoTacs_fnc_createSquad = {
	private _units = (units player) - [player];
	private _menu = [
		[0, "HEADER", "Squad Creator"]
	];

	if (isNil "dzn_GoTacs_Kits") then {
		dzn_GoTacs_Kits = (allVariables missionNamespace) select { _x select [0,4] == "kit_" };
	};
	private _kitsDisplayItems = ["Heal", "Arsenal", "ACE Arsenal", "Renew kit"] + dzn_GoTacs_Kits + ["Expel", "Delete"];

	private _lineID = 0;

	{
		if (alive _x) then {
			_lineID = _lineID + 1;

			private _lineTitle = [
				_lineId
				, "LABEL"
				, format [
					"<t color='%2'>Unit #%1</t>"
					, _forEachIndex + 1
					, switch (assignedTeam (_units # _forEachIndex)) do {
						case "RED": 	{ "#f91818" };
						case "BLUE": 	{ "#2667ff" };
						case "GREEN": 	{ "#00aa4c" };
						default 		{ "#ffffff" };
					}
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
							[_unit, 'Healed!'] call dzn_GoTacs_fnc_hint;
							_unit call dzn_GoTacs_fnc_heal;
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
							[_unit, 'Kit renewed!'] call dzn_GoTacs_fnc_hint;
							[_unit, _unit getVariable 'dzn_gear'] remoteExec ['dzn_fnc_gear_assignKit', _unit];
						};
						case 'expel': {
							[_unit, 'Expeled from squad!'] call dzn_GoTacs_fnc_hint;
							[_unit] spawn {
								closeDialog 2; 
								uiSleep 0.05;

								private _newGrp = player getVariable ['dzn_GoTacs_ExpelGroup', grpNull];
								if (isNull _newGrp) then {
									_newGrp = createGroup (side player);
									player setVariable ['dzn_GoTacs_ExpelGroup', _newGrp];
								};						
								
								_this join _newGrp;

								uiSleep 0.005;
								[] spawn dzn_GoTacs_fnc_createSquad;								
							};
						};
						case 'delete': {
							[_unit, 'Deleted from squad!'] call dzn_GoTacs_fnc_hint;
							[_unit] spawn {
								closeDialog 2; 
								uiSleep 0.05;
								deleteVehicle (_this # 0);

								uiSleep 0.005;
								[] spawn dzn_GoTacs_fnc_createSquad;
							};
						};
						default {
							[_unit, 'Kit applied!'] call dzn_GoTacs_fnc_hint;
							[_unit, _data] remoteExec ['dzn_fnc_gear_assignKit', _unit];
						};
					}
					", _forEachIndex
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
	_menu pushBack [_lineId, "BUTTON", "CLOSE", { closeDialog 2; }];
	_menu pushBack [_lineId, "LABEL", ""];
	_menu pushBack [_lineId, "BUTTON", "ADD UNIT", {
		[] spawn {
			closeDialog 2;
			uiSleep 0.01;
			private _unit = (group player) createUnit [typeof player, position player, [], 0, "FORM"];
			[_unit, 'Unit created!'] call dzn_GoTacs_fnc_hint;

			[_unit] call dzn_GoTacs_fnc_setupSquadUnits;

			[] spawn dzn_GoTacs_fnc_createSquad;
		};
	}];

	_menu call dzn_GoTacs_fnc_ShowAdvDialog;
};

dzn_GoTacs_fnc_heal = {
	_this setDamage 0;
	[_this,_this] call ace_medical_fnc_treatmentAdvanced_fullHealLocal;
};

dzn_GoTacs_fnc_hint = {
	params ["_unit","_action"];
	hint parseText format [
		"<t size='1' color='#FFD000' shadow='1'>Unit %1:</t>
		<br />%2"
		, name _unit
		, _action
	];
};
