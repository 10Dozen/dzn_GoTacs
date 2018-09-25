/* ----------------------------------------------------------------------------
Function: dzn_GoTacs_fnc_uiDrawSquadHUD

Description:
	Each frame squad HUD draw

Parameters:
	nothing

Returns:
	nothing

Examples:
    (begin example)
		call dzn_GoTacs_fnc_uiDrawSquadHUD;
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

#include "..\macro.hpp"

if (!alive player) exitWith {};
if (!GVAR(SquadHUD_Draw)) exitWith {};

{
	_x params ["_u", "_wpnIcon", "_damageData", "_ammoData", "_pos", "_teamColor"];

	if (alive _u) then {
		// Update position/team data for alive unit. Use last saved data for dead
		_x set [4, getPosVisual _u];
		_x set [5, switch (assignedTeam _u) do {
			case "RED": 	{ [0.85, 0, 0, 1] };
			case "BLUE": 	{ [0.1, 0.1, 0.95, 1] };
			case "GREEN": 	{ [0, 0.85, 0, 1] };
			case "YELLOW":	{ [0.93, 0.86, 0.16, 1] };
			default 		{ [1,1,1,1] };
		}];
	};

	private _dist = player distance _pos;	
	private _posV = _pos;
	_posV set [2, (getPosATL _u select 2) + 1.75];
		
	// --- Distance data ---
	private _distText = "";
	if (_u getVariable [SVAR(CurrentOrder),""] != "") then {
		_distText = "< " + (_u getVariable SVAR(CurrentOrder)) + " >";
	} else {
		_distText = str(round _dist) + "m";
	};

	private _distPos = [] + _posV;
	_distPos set [2, (_posV select 2) + 0.025*_dist];

	// --- Team data ---
	private _teamIcon = "\a3\ui_f\data\GUI\Rsc\RscDisplayInventory\InventoryStripe_ca.paa";
	private _teamIconPos = [] + _posV;
	_teamIconPos set [2, (_posV select 2) + 0.05*_dist];

	if (alive _u && { _u getVariable [SVAR(isFiring), false] }) then {
		// If firing at the moment - make icon white
		_teamColor = [1,1,1,1];
	};

	// --- Opacity ---
	_teamColor set [3,  GVAR(SquadHUD_Opacity)];

	// --- Damage Icon ---
	private _damageIconPos = [];
	if (_damageData select 0 != "" && alive _u) then {
		_damageIconPos = [
			(_posV # 0)
			, _posV # 1
			, (_posV # 2) + 0.1*_dist
		];
	};

	//TODO: --- Ammo Icon ---


	// --- DRAW ---
	// ------------

	// --- Team
	drawIcon3D [_teamIcon, _teamColor, _teamIconPos, 1, 1, 0, "", 1, 0.05, "TahomaB"];
	// --- Weapon 
	drawIcon3D [_wpnIcon, [1,1,1,1], _teamIconPos, 2, 1, 0, "", 1, 0.05, "TahomaB"];
	// --- Distance
	drawIcon3D ["", _teamColor, _distPos, 0, 0, 0, _distText , 2, 0.035, 'PuristaMedium'];

	// --- Damage
	if !(_damageIconPos isEqualTo []) then {
		drawIcon3D [_damageData select 0, _damageData select 1, _damageIconPos,  0.5, 0.5, 0, "" , 1, 0.05, 'PuristaMedium'];
	};
} forEach GVAR(SquadData);
