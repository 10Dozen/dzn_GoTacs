/* ----------------------------------------------------------------------------
Function: dzn_GoTacs_fnc_uiDrawContactsHUD

Description:
	Each frame contacts HUD draw

Parameters:
	nothing

Returns:
	nothing

Examples:
    (begin example)
		call dzn_GoTacs_fnc_uiDrawContactsHUD;
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

#include "..\macro.hpp"

if (!alive player) exitWith {};
if (!GVAR(ContactsHUD_Draw)) exitWith {};

{
	_x params ["_tgt", "_typeIcon", "_pos", "_distanceLabel", "_dist"];

	private _mainIconPos = [] + _pos;
	_mainIconPos set [2, (_pos # 2) + 0.05*_dist];

	private _typeIconPos = [] + _pos;
	_typeIconPos set [2, (_pos # 2) + 0.035*_dist];
	
	private _distTextPos = [] + _pos;
	_distTextPos set [2, (_pos # 2) + 0.025*_dist];

	private _mainIcon = "\a3\ui_f\data\IGUI\Cfg\TacticalPing\TacticalPingDefault_ca.paa";
	private _color = [1,0,0,1];

	private _h = 1;
	private _w = 1;

	if !(_tgt isKindOf "CAManBase") then {
		_h = 1;
		_w = 1;
	};


	// --- DRAW ---
	// ------------

	// --- Main contact icon 
	// drawIcon3D [_mainIcon, _color, _mainIconPos, 2, 2, 0, "", 1, 0.05, "TahomaB"];
	// --- Contact type icon _typeIconPos
	drawIcon3D [_typeIcon, [1,1,1,1], _mainIconPos, _w, _h, 0, "", 0, 0.05, "TahomaB"];
	// --- Distance label
	drawIcon3D ['', _color, _distTextPos, 0, 0, 0, _distanceLabel , 2, 0.035, 'PuristaMedium'];	
} forEach GVAR(ContactsData);