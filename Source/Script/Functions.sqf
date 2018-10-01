
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

























fnc_helperCreate = { 
	CH = "Sign_Arrow_Direction_F" createVehicle (getPos player); 
};
fnc_rotate3 = {
	private _newDir = (getDir player) + (_this select 0);

	CH1 = "Sign_Arrow_Direction_F" createVehicle (getPos player); 
	CH2 = "Sign_Arrow_Direction_F" createVehicle (getPos player); 

	pos1 = (player) getPos [2.75, _newDir];

	tgtPos = dzn_cam_pos getPos [22.75, _newDir];
	camPos = dzn_cam_pos getPos [-2.75, _newDir];
	camPos set [2,3.75];

	camPosRel = camPos vectorDiff tgtPos;
	

	CH1 setPos camPos;
	CH1 setDir _newDir;

	CH2 setPos tgtPos;
	CH2 setDir _newDir;
};




fnc_cam = {
	cam = "camera" camCreate (getPos player);

	cam cameraEffect ["INTERNAL","BACK"];
	
	[cam, [-20,0,0]] call fnc_SetPitchBankYaw;
	cam camSetFov 0.75;
	showCinemaBorder false;
	cameraEffectEnableHUD true;
	cam camCommit 0;

	dzn_cam_dir = getDir player;
	dzn_cam_pos = getPos player;
	dzn_cam_dirDelta = 0;
	dzn_keyPressTimeout = 0;
};

fnc_closeCam = {
	cam cameraEffect ["Terminate", "Back"];
	camDestroy cam;
};

fnc_camRotate3 = {
	params["_newDir", "_commitTime"];

	private _dir = _newDir + dzn_cam_dir;
	tgtPos = dzn_cam_pos getPos [22.75, _dir];
	camPos = dzn_cam_pos getPos [-2.75, _dir];
	camPos set [2,3.75];

	camPosRel = camPos vectorDiff tgtPos;

	cam camSetTarget tgtPos;
	cam camSetRelPos camPosRel;

	cam camCommit _commitTime;
};

fnc_addButtonsEH = {
	if (_this == "add") then {
		dzn_cam_handler = (findDisplay 46) displayAddEventHandler ["KeyDown", "_handled = _this call fnc_buttonEH"];
	} else {
		(findDisplay 46) displayRemoveEventHandler ["KeyDown", dzn_cam_handler];
	};
};

fnc_buttonEH = {
	params ["", "_key", "_shift", "_ctrl", "_alt"];

	hintSilent str(_this);
	if (dzn_keyPressTimeout > time) exitWith {};

	private _handled = false;
	private _step = 15;
	switch _key do {
		// A 
		case 30: {
			dzn_cam_dirDelta = dzn_cam_dirDelta - _step;
			_handled = true;
		};

		// D
		case 32: {
			dzn_cam_dirDelta = dzn_cam_dirDelta + _step;
			_handled = true;
		};

		// F1
		case 59: {
			hint "Red selected";
			//["handle", "blue"] spawn dzn_GoTacs_fnc_handleTeamSelection;
		};
		// F2
		case 60: {
			hint "Red selected";
			// ["handle", "red"] spawn dzn_GoTacs_fnc_handleTeamSelection;
		};
	};

	if (_handled) then {
		dzn_keyPressTimeout = time + 0.15;
		[dzn_cam_dirDelta, 0.13] call fnc_camRotate3;
	};

	true
};

fnc_StartCam = {
	call fnc_cam;
	[0,1] call fnc_camRotate3;

	"add" call fnc_addButtonsEH;
};

dzn_cam_move = {
	params["_mode", "_args"];

	switch (tolower _mode) do {
		case "create": {
			dzn_pointerMove = "VR_3DSelector_01_default_F" createVehicleLocal (getPos player);
			call dzn_cam_move_addEachFrameHandler;
		};
		case "finish": {
			deleteVehicle dzn_pointerMove;
			removeMissionEventHandler ["EachFrame", dzn_cam_move_mouseEH];
		};
		case "handle mouse move": {
			private _pos = screenToWorld (getMousePosition);
			//_pos set [2, 0];
			dzn_pointerMove setPosATL _pos;
		};
	};
};

dzn_cam_move_addEachFrameHandler = {
	dzn_cam_move_mouseEH = addMissionEventHandler ["EachFrame", { ["handle mouse move"] call dzn_cam_move; }];
};




fnc_handleZWheel = {
	dzn_cam_dirDelta = dzn_cam_dirDelta + ((_this select 1) * 30);

	_camID = time;
	dzn_CAMID = _camID;
	[_camID] spawn {
		sleep 0.04;

		if ((_this select 0) != dzn_CAMID) exitWith {};

		[dzn_cam_dirDelta, 1] spawn fnc_camRotate3;
	}
	
};

fnc_addEH = {
	findDisplay 46 displayAddEventHandler ["MouseZChanged", { _this spawn fnc_handleZWheel }];
};

fnc_mousehandler = {
	waitUntil { !isNull (findDisplay 134102) };

	hint "DIALOG FOUND";

	while { !isNull (findDisplay 134102) } do {

		if (time > dzn_RegisteredTimeout) then {
			private _pos = getMousePosition # 0;
			hint str(_pos);
			
			private _angleStep = [5,15,30];
			private _commitTime = 0.35;
			private _timeout = 0.36;

			private _speedID = -1;
			private _rotateDir = 0;

			switch (true) do {
				case (_pos < 0.01): {
					_rotateDir = 1;
					_speedID = 0;
				};
				case (_pos < 0.03): {
					_rotateDir = 1;
					_speedID = 1;
				};			
				case (_pos < 0.05): {
					_rotateDir = 1;
					_speedID = 2;
				};
				case (_pos > 0.99): {
					_rotateDir = -1;
					_speedID = 2;
				};
				case (_pos > 0.97): {
					_rotateDir = -1;
					_speedID = 1;
				};
				case (_pos > 0.95): {
					_rotateDir = -1;
					_speedID = 0;
				};
			};
			
			if (_speedID > 0) then {
				dzn_cam_dirDelta = dzn_cam_dirDelta - ( _rotateDir * (_angleStep # _speedID));
				[dzn_cam_dirDelta, _commitTime] spawn fnc_camRotate3;
				dzn_RegisteredTimeout = time + _timeout;
			};

		};

	};
};







fnc_SetPitchBankYaw = { 
    private ["_object","_rotations","_aroundX","_aroundY","_aroundZ","_dirX","_dirY",
	"_dirZ","_upX","_upY","_upZ","_dir","_up","_dirXTemp","_upXTemp"];
    _object = _this select 0; 
    _rotations = _this select 1; 
    _aroundX = _rotations select 0; 
    _aroundY = _rotations select 1; 
    _aroundZ = (360 - (_rotations select 2)) - 360; 
    _dirX = 0; 
    _dirY = 1; 
    _dirZ = 0; 
    _upX = 0; 
    _upY = 0; 
    _upZ = 1; 
    if (_aroundX != 0) then { 
        _dirY = cos _aroundX; 
        _dirZ = sin _aroundX; 
        _upY = -sin _aroundX; 
        _upZ = cos _aroundX; 
    }; 
    if (_aroundY != 0) then { 
        _dirX = _dirZ * sin _aroundY; 
        _dirZ = _dirZ * cos _aroundY; 
        _upX = _upZ * sin _aroundY; 
        _upZ = _upZ * cos _aroundY; 
    }; 
    if (_aroundZ != 0) then { 
        _dirXTemp = _dirX; 
        _dirX = (_dirXTemp* cos _aroundZ) - (_dirY * sin _aroundZ); 
        _dirY = (_dirY * cos _aroundZ) + (_dirXTemp * sin _aroundZ);        
        _upXTemp = _upX; 
        _upX = (_upXTemp * cos _aroundZ) - (_upY * sin _aroundZ); 
        _upY = (_upY * cos _aroundZ) + (_upXTemp * sin _aroundZ); 		
    }; 
    _dir = [_dirX,_dirY,_dirZ]; 
    _up = [_upX,_upY,_upZ]; 
    _object setVectorDirAndUp [_dir,_up]; 
}; 


/*
Does anyone has expirience in cameras in A3? 
I want to make an overhead camera pointed to ground (w. about 60 degree angle) and i want to rotate it around object without changing camera pointing angle. 

Is there any guide for camera and vectoring stuff?

Camera creation code is:
fnc_cam = {
	cam = "camera" camCreate (getPos player);

	cam cameraEffect ["INTERNAL","BACK"];
	cam attachTo [player, [0,-2.75,3.75]];  
	cam setVectorUp [0,0.25,0.95];  
	cam camSetFov 0.75;
	showCinemaBorder false;
	cameraEffectEnableHUD true;
	cam camCommit 0;

};

I know that rotation may be made by setDir, but it makes resulting camera position rotated in several axes, like:
 

*/


/*
[] spawn {
	sleep 1;
	if (true) exitWith {};

_cam = "camera" camCreate (getPos player);
_cam cameraEffect ["internal","back"] ;
_cam camPrepareFocus [-1,-1] ;
_cam camCommitPrepared 0 ;
cameraEffectEnableHUD true ;
showCinemaBorder false ;

PLP_animViewerLastHeight = (getPosASL player select 2) + 3.75;


#define UPDATE_CAMERA \
	PLP_animViewercamera camSetTarget ASLtoAGL (PLP_animViewerposCenter vectorAdd [0,0,(missionNamespace getVariable "PLP_animViewerLastHeight")]) ; \
	PLP_animViewercamera camSetRelPos  ([PLP_animViewerzoom * sin PLP_animViewerdirX * cos PLP_animViewerdirY,PLP_animViewerzoom * cos PLP_animViewerdirX * cos PLP_animViewerdirY,PLP_animViewerzoom * (sin PLP_animViewerdirY)]) ; \
	PLP_animViewercamera camCommit 0 ; \

uiNamespace setVariable ["PLP_animViewercamera",_cam] ;
uiNamespace setVariable ["PLP_animViewerdirX",0] ;
uiNamespace setVariable ["PLP_animViewerdirY",5] ;
uiNamespace setVariable ["PLP_animViewerposCenter",getPosASL player] ;
uiNamespace setVariable ["PLP_animViewerzoom",5 * 0.8] ;
uiNamespace setVariable ["PLP_animViewer_loop",false] ;

findDisplay 46 displayAddEventHandler ["MouseButtonDown",{
	with uiNamespace do {
		if ((_this select 1) == 1) then {
			PLP_animViewer_LMB_state = true ;
		} else {
			PLP_animViewer_RMB_state = true ;
		} ;
	} ;
}] ;
findDisplay 46 displayAddEventHandler ["MouseButtonUp",{
	with uiNamespace do {
		if ((_this select 1) == 1) then {
			PLP_animViewer_LMB_state = false ;
		} else {
			PLP_animViewer_RMB_state = false ;
		} ;
	} ;
}] ;

findDisplay 46 displayAddEventHandler ["MouseMoving",{
	with uiNamespace do {
		_moveValue = [PLP_animViewermouseX - (_this select 1),PLP_animViewermouseY - (_this select 2)] ;
		if (PLP_animViewer_LMB_state) then {
			PLP_animViewerdirX = (PLP_animViewerdirX - (_moveValue select 0) * 80) ;
			PLP_animViewerdirY = (PLP_animViewerdirY - (_moveValue select 1) * 80) min 85 max -85 ;
		} ;

		if (PLP_animViewer_RMB_state) then {
			PLP_animViewerposCenter = (
				AGLtoASL positionCameraToWorld [
					 (_moveValue select 0) * PLP_animViewerzoom * 1.3,
					-(_moveValue select 1) * PLP_animViewerzoom * 1.3,
					PLP_animViewerzoom
				] vectorDiff [0,0,missionNamespace getVariable "PLP_animViewerLastHeight"]
			) ;
			PLP_animViewerposCenter set [0,(PLP_animViewerposCenter select 0) min 5 max -5] ;
			PLP_animViewerposCenter set [1,(PLP_animViewerposCenter select 1) min 5 max -5] ;
			PLP_animViewerposCenter set [2,(PLP_animViewerposCenter select 2) min 3 max -3] ;
		} ;
	
		PLP_animViewermouseX = _this select 1 ;
		PLP_animViewermouseY = _this select 2 ;
		UPDATE_CAMERA
	} ;
}] ;

findDisplay 46 displayAddEventHandler ["MouseZChanged",{
	with uiNamespace do {
		PLP_animViewerzoom = PLP_animViewerzoom - ((_this select 1) * 0.25) min 15 max 0.5 ;
		UPDATE_CAMERA
	} ;
}] ;

};

*/

