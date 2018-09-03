
dzn_GoTacs_fnc_onLoadCommandOverlay = {
	uiNamespace setVariable ["dzn_GoTacs_CommandOverlay", _this select 0];
};

fnc_showCommandHUD = {
	("dzn_GoTacs_CommandOverlay" call BIS_fnc_rscLayer) cutRsc ["dzn_GoTacs_CommandOverlay", "PLAIN"];

	disableSerialization;

	private _display = uiNamespace getVariable "dzn_GoTacs_CommandOverlay";
	private _ctrl = _display ctrlCreate ["RscStructuredText", 2500];
	_ctrl ctrlSetStructuredText parseText "<img align='center' size='2' image='\a3\ui_f\data\GUI\Rsc\RscDisplayArcadeMap\icon_sidebar_hide_up'/><br /><t font='PuristaMedium' align='center'>BREACH</t>";
	_ctrl ctrlSetTextColor [1,1,1,0.5];

	_ctrl ctrlSetBackgroundColor [1,0,0,0];
	private _size = [0.2,0.2];
	private _pos = [
		0.5 - (_size # 0)/2
		, 0.4 + (_size # 1)/2
	];
	_ctrl ctrlSetPosition [_pos # 0, _pos # 1, _size # 0, _size # 1];
	_ctrl ctrlCommit 0;

	call fnc_addCommandEHs;
};

fnc_hideCommandHUD = {
	{ ctrlDelete _x; } forEach (allControls (uiNamespace getVariable "dzn_GoTacs_CommandOverlay"));
	("dzn_GoTacs_CommandOverlay" call BIS_fnc_rscLayer) cutText ["","PLAIN"];

	call fnc_removeCommandEHs;
};

fnc_addCommandEHs = {
	dzn_GoTacs_MainAction = player addAction ["", {}, "", 0, false, true, "DefaultAction", "true"];

	command_MouseButtonEH = ["MouseButtonDown", {_this call dzn_onMousedButton}] call CBA_fnc_addDisplayHandler;
	//	command_MouseScrollEH = ["MouseZChanged", {_this call dzn_onMouseScroll}] call CBA_fnc_addDisplayHandler;
};

fnc_removeCommandEHs = {
	player removeAction dzn_GoTacs_MainAction;
	["MouseButtonDown", command_MouseButtonEH] call CBA_fnc_removeDisplayHandler;
};

dzn_onMousedButton = {
		params ["", "_key"];

		// Left mouse button
		// "DefaultAction" doesn't get executed when in driver seat or in FFV seat with weapon lowered
		if (_key == 0) exitWith {
			hint "Action1 pressed";
			call fnc_removeCommandEHs;
			call fnc_hideCommandHUD;
			dzn_GoTacs_CommandMode = "";
		};

		// Right mouse button
		if (_key == 1) exitWith {
			hint "Action2 pressed";
			false
		};

		// Middle mouse button
		if (_key == 2) exitWith {
			hint "Action3 pressed";
			false
		};

		false
};

dzn_onMouseScroll = {
		params ["", "_amount"];

		hint str _amount;

};


























fnc_handleCommandHUD = {

	if (dzn_GoTacs_CommandMode == "") exitWith {};
	if (dzn_GoTacs_CommandMode == "breach") exitWith {
		_ct = cursorObject;

		if (_ct isKindOf "House" && { [_ct, 1] call BIS_fnc_isBuildingEnterable }) then {

			_posV = getPosVisual _ct;
			_posV set [2,1.5];

			private _textPos = [
				_posV select 0
				, _posV select 1
				, (_posV select 2) - 0.5 + 0.025*(player distance _ct)
			];
			private _iconPos = [
				_posV select 0
				, _posV select 1
				, (_posV select 2) + 0.025*(player distance _ct)
			];

			private _dist = (player distance _ct);
			private _text = if (_dist > 100) then {
				str(100*round(_dist/100)) + "m"
			} else {
				str(round _dist) + "m"
			};
			private _color = [1,1,1,1];
			private _color2 = [0,0,1,0.5];

			drawIcon3D [
				"\a3\ui_f\data\GUI\Rsc\RscDisplayMain\spotlight_backgroundText_ca.paa"
				, _color2
				, _iconPos
				, 2, 2, 0
				, "", 1, 0.05, "TahomaB"
			];
			drawIcon3D [
				"\a3\ui_f\data\GUI\Rsc\RscDisplayMain\exit_ca.paa"
				, _color
				, _iconPos
				, 1, 1, 0
				, "", 1, 0.05, "TahomaB"
			];
			drawIcon3D ['', _color, _textPos, 0, 0, 0, _text , 2, 0.035, 'puristaMedium'];
		};
	};
};

// \a3\ui_f\data\GUI\Rsc\RscDisplayArcadeMap\icon_sidebar_hide_up.paa

