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

	private _iconColor = [1,1,1,GVAR(ContactsHUD_Opacity)];
	private _textColor = [1,0,0,GVAR(ContactsHUD_Opacity)];

	private _typeIconPos = [] + _pos;
	_typeIconPos set [2, (_pos # 2) + 0.05*_dist];
	
	private _distTextPos = [] + _pos;
	_distTextPos set [2, (_pos # 2) + 0.09*_dist];

	private _h = 1;
	private _w = 1;


	// --- DRAW ---
	// ------------
	// --- Contact type icon _typeIconPos
	drawIcon3D [_typeIcon, _iconColor, _typeIconPos, _w, _h, 0, "", 0, 0.05, "TahomaB"];
	// --- Distance label
	drawIcon3D ['', _textColor, _distTextPos, 0, 0, 0, _distanceLabel , 2, 0.035, 'PuristaMedium'];	
} forEach GVAR(ContactsData);