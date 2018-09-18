
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

COMPILE_FUNCTION(fnc_squadManageMenu);


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