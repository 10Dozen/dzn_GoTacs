
#include "macro.hpp"


COMPILE_FUNCTION(fnc_uiCreateClickableLabel);
COMPILE_FUNCTION(fnc_uiShowMainOverlay);
COMPILE_FUNCTION(fnc_uiShowSettingsOverlay);

COMPILE_FUNCTION(fnc_getUnitDamageData);

COMPILE_FUNCTION(fnc_setupSquadUnits);
COMPILE_FUNCTION(fnc_assignTeams);
COMPILE_FUNCTION(fnc_getUnits);
COMPILE_FUNCTION(fnc_getSelectedTeamUnits);
COMPILE_FUNCTION(fnc_getDistibutionMap);

COMPILE_FUNCTION(fnc_issueOrder);

COMPILE_FUNCTION(fnc_handleTeamSelection);

COMPILE_FUNCTION(fnc_uiShowHUD);
COMPILE_FUNCTION(fnc_uiHideHUD);

COMPILE_FUNCTION(fnc_squadLoop);
COMPILE_FUNCTION(fnc_uiDrawSquadHUD);

COMPILE_FUNCTION(fnc_findContacts);
COMPILE_FUNCTION(fnc_contactsLoop);
COMPILE_FUNCTION(fnc_uiDrawContactsHUD);

COMPILE_FUNCTION(fnc_uiDrawTeamSelection);

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


dzn_GoTacs_fnc_onLoadCommandOverlay = {
	uiNamespace setVariable ["dzn_GoTacs_CommandOverlay", _this select 0];
};

fnc_showCommandPointer = {
	switch (toLower _this) do {
		case "show": {
			("dzn_GoTacs_CommandOverlay" call BIS_fnc_rscLayer) cutRsc ["dzn_GoTacs_CommandOverlay", "PLAIN"];

			disableSerialization;

			private _display = uiNamespace getVariable "dzn_GoTacs_CommandOverlay";
			private _ctrl = _display ctrlCreate ["RscStructuredText", 2500];
			_ctrl ctrlSetStructuredText parseText "<img align='center' size='2' image='\a3\ui_f\data\GUI\Rsc\RscDisplayArcadeMap\icon_sidebar_hide_up'/>";
			_ctrl ctrlSetTextColor [1,1,1,0.5];

			_ctrl ctrlSetBackgroundColor [1,0,0,0];
			private _size = [0.2,0.2];
			private _pos = [
				0.5 - (_size # 0)/2
				, 0.4 + (_size # 1)/2
			];
			_ctrl ctrlSetPosition [_pos # 0, _pos # 1, _size # 0, _size # 1];
			_ctrl ctrlCommit 0;

		};
		case "hide": {
			("dzn_GoTacs_CommandOverlay" call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
		}
	};
};




/*
	CAMERA 
*/

fnc_StartCam = {
	// [@Unit] call fnc_cam
	_this call fnc_cam;
	[0,1] call fnc_camRotate;
	[] spawn fnc_showGUI;
};

fnc_EndCam = {
	cam cameraEffect ["Terminate", "Back"];
	camDestroy cam;
	closeDialog 2;
};

fnc_cam = {
	params ["_tgt"];
	cam = "camera" camCreate (getPos _tgt);

	cam cameraEffect ["INTERNAL","BACK"];
	
	cam camSetFov 0.75;
	showCinemaBorder false;
	cameraEffectEnableHUD true;
	cam camCommit 0;

	dzn_cam_dir = getDir _tgt;
	dzn_cam_pos = getPos _tgt;
	dzn_cam_dirDelta = 0;

	dzn_cam_h = 3.75;
	dzm_cam_hLimit = [0.25, 3.75];

	dzn_keyPressTimeout = 0;

	dzn_CamTarget = _tgt;

	[] spawn {
		while { !isNull cam } do {
			uiSleep 0.5;
			if (speed dzn_CamTarget > 0) then {
				while { speed dzn_CamTarget > 0 } do {
					uiSleep 0.15;
					[dzn_cam_dirDelta, 0.15] call fnc_camRotate;
				};
			};
		};
	};
};

fnc_camRotate = {
	params["_newDir", "_commitTime"];

	if (!camCommitted cam) exitWith {};

	private _dir = _newDir + dzn_cam_dir;
	tgtPos = dzn_CamTarget getPos [22.75, _dir];
	camPos = dzn_CamTarget getPos [-2.75, _dir];
	
	// camPos set [2,3.75];
	private _hDelta = ((ATLtoASL tgtPos) # 2) - ((ATLtoASL camPos) # 2);

	camPos set [2, dzn_cam_h - _hDelta;

	camPosRel = camPos vectorDiff tgtPos;
	cam camSetTarget tgtPos;
	cam camSetRelPos camPosRel;

	cam camCommit _commitTime;
};

fnc_showGUI = {
	createDialog "dzn_GoTacs_MainOverlay";
	private _display = (findDisplay 134102);

	setMousePosition [0.5, 0.3];
	dzn_cc_moveMode_Enabled = false;

	["add", (findDisplay 134102)] call fnc_addButtonsEH;

	[] spawn {
		waitUntil { !dialog };
		[] spawn fnc_EndCam;
	};
};

fnc_addButtonsEH = {
	params ["_mode", "_display"];

	if (_mode == "add") then {
		dzn_cc_keyDownEH = _display displayAddEventHandler ["KeyDown", "_handled = _this call fnc_buttonEH"];
		dzn_cc_mouseZEH = _display displayAddEventHandler ["MouseZChanged", "_handled = _this call fnc_mouseZEH"];
		// dzn_cc_mouseDownEH = _display displayAddEventHandler ["MouseButtonDown", "_handled = _this call fnc_mouseEH"];
	} else {
		_display displayRemoveEventHandler ["KeyDown", dzn_cc_keyDownEH];
		_display displayRemoveEventHandler ["MouseZChanged", dzn_cc_mouseZEH];
		// _display displayRemoveEventHandler ["MouseButtonDown", dzn_cc_mouseDownEH];
	};
};

fnc_buttonEH = {
	params ["", "_key", "_shift", "_ctrl", "_alt"];

	if (dzn_keyPressTimeout > time) exitWith {};

	private _doRotate = false;
	private _doDeselect = false;
	private _step = 15;
	switch _key do {
		// A 
		case 30: {
			dzn_cam_dirDelta = dzn_cam_dirDelta - _step;
			_doRotate = true;
		};
		// D
		case 32: {
			dzn_cam_dirDelta = dzn_cam_dirDelta + _step;
			_doRotate = true;
		};
		// F1
		case 59: {
			hint parseText format [
				"<t size='1' color='#FFD000' shadow='1'>Blue team:</t><br />Camera view!"
			];
			["handle", "blue"] call dzn_GoTacs_fnc_handleTeamSelection;
			["camera", [] call GVAR(fnc_getSelectedTeamUnits)] call GVAR(fnc_issueOrder);
			_doDeselect = true;
		};
		// F2
		case 60: {
			hint parseText format [
				"<t size='1' color='#FFD000' shadow='1'>Red team:</t><br />Camera view!"
			];
			["handle", "red"] call dzn_GoTacs_fnc_handleTeamSelection;
			["camera", [] call GVAR(fnc_getSelectedTeamUnits)] call GVAR(fnc_issueOrder);
			_doDeselect = true;
		};

		// N 
		case 49: {
			if (isNil "cam_nvgState") then { 
				cam_nvgState = true;
			} else {
				cam_nvgState = !cam_nvgState;
			};

			camUseNVG cam_nvgState;
		};
	};

	if (_doRotate) then {
		dzn_keyPressTimeout = time + 0.15;
		[dzn_cam_dirDelta, 0.15] call fnc_camRotate;		
	};

	if (_doDeselect) then {
		[] spawn { 
			uiSleep 0.1; 
			["Deselect"] call GVAR(fnc_handleTeamSelection);
		};
	};

	true
};

fnc_mouseZEH = {
	params ["_displayorcontrol", "_scroll"];

	dzn_cam_h = ((dzn_cam_h + _scroll/3) max (dzm_cam_hLimit # 0)) min (dzm_cam_hLimit # 1);
	[dzn_cam_dirDelta,0.05] call fnc_camRotate;
};

