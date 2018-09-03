



#define GET_CTRL(X) (_display displayCtrl  X)
fnc_uiOnAssignTeamBtnClick = {
	private _display = (findDisplay 134102);	

	private _selectedId = lbCurSel GET_CTRL(2301);
	private _value = GET_CTRL(2301) lbData _selectedId;

	[group player, _value] call fnc_assignTeam;
	hint "Teams assigned";
};

fnc_uiShowMainOverlay = {

	closeDialog 2;
	uiSleep 0.002;

	createDialog "dzn_GoTacs_MainOverlay";
	
	private _display = (findDisplay 134102);
	#define GET_CTRL(X) (_display displayCtrl  X)

	GET_CTRL(2300) ctrlAddEventHandler ["ButtonClick", "call fnc_uiOnAssignTeamBtnClick"];

	private _dataId = 0;
	{
		GET_CTRL(2301) lbAdd (_x select 1);
		GET_CTRL(2301) lbSetData [_forEachIndex, (_x select 0)];

		if ( player getVariable ["dzn_GoTacs_TeamAssignmentName", ""] == (_x select 0)) then {
			_dataId = _forEachIndex;	
		};
	} forEach [
		["nato", "NATO (4/4)"]
		,["rumsv", "RU MSO (3/3/2)"]
	];

	GET_CTRL(2301) lbSetCurSel _dataId;


	// Action buttons 
	private _idc = 4500;
	private _xOffset = 0;
	private _yOffset = 0;
	private _ctrlWidth = 0;
	private _ctrlHeight = 0;

	// MOVE 
	{
		if (_forEachIndex == 0) then {
			_xOffset = _x select 0;
			_yOffset = _x select 1;
			_ctrlWidth = _x select 2;
			_ctrlHeight = _x select 3;
		} else {			
			_idc = _idc + 1;
			_yOffset = _yOffset + 0.051;

			if (count _x > 1) then {
				_x params ["_label", "_code"];

				private _ctrl = _display ctrlCreate ["RscStructuredText", _idc];
				_ctrl ctrlSetStructuredText parseText format ["<t align='center' font='PuristaLight'>%1</t>", _label];
				_ctrl ctrlSetPosition [_xOffset, _yOffset, _ctrlWidth, _ctrlHeight];
				_ctrl ctrlSetFont "PuristaLight";
				_ctrl ctrlSetBackgroundColor [0,0,0,1];

				_ctrl ctrlAddEventHandler ["MouseButtonDown", _code];
				_ctrl ctrlCommit 0;
			};
		};
	} forEach dzn_GoTacs_moveCommandsList;
};

// --- 0: List paramers: @X, @Y
// --- 1+: [@Label, @CodeOnClick]
dzn_GoTacs_moveCommandsList = [
	[0, 0.25, 0.25, 0.05]
	, ["Move to", { hint "MOVE TO" }]
	, [
		"Breach &amp; Clear"
		, { 
			params ["_ctrl", "_button"]; 
			if (_button != 0) exitWith {};
			_ctrl ctrlSetBackgroundColor [1,1,1,1];

			[] spawn {
				uiSleep 0.2;
				hint "BREACH";
				closeDialog 2;
				
				dzn_GoTacs_CommandMode = "breach";
				call fnc_showCommandHUD;
			};
		}]
	, ["null"]
	, ["5m FWD", {}]
];

