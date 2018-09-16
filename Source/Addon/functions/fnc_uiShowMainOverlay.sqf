/* ----------------------------------------------------------------------------
Function: dzn_GoTacs_fnc_uiShowMainOverlay

Description:
	Draw main command overlay

Parameters:
	nothing

Returns:
	nothing

Examples:
    (begin example)
		[] spawn dzn_GoTacs_fnc_uiShowMainOverlay;
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

#include "..\macro.hpp"
#define GET_CTRL(X) (_display displayCtrl  X)

#define BG_BLACK [0,0,0,1]
#define BG_WHITE [1,1,1,1]
#define BG_EMPTY [0,0,0,0]


closeDialog 2;
uiSleep 0.002;

createDialog "dzn_GoTacs_MainOverlay";
private _display = (findDisplay 134102);

// --- Command/Set up toggle ---
// -----------------------------
private _overlayToggleCtrl = [
	_display
	, "<t align='center' font='PuristaMedium'>Settings</t>"
	, { [] spawn GVAR(fnc_uiShowSettingsOverlay) }
	, -0.15, -0.15, 0.2, 0.05
] spawn GVAR(fnc_uiCreateClickableLabel);


// --- Commanding buttons ---
// --------------------------

private _xOffset = 0;
private _yOffset = 0;
private _ctrlWidth = 0.25;
private _ctrlHeight = 0.05;

// --- MOVE section ---
// --------------------
_yOffset = 0.25;
{
	_x params ["_label", "_code", "_bg"];

	[
		_display
		, _label
		, if (typename _code == "STRING") then { nil } else { _code }
		, _xOffset, _yOffset, _ctrlWidth, _ctrlHeight
	] spawn GVAR(fnc_uiCreateClickableLabel);

	_yOffset = _yOffset + _ctrlHeight;
} forEach [
	[
		"<t align='center' font='PuristaMedium'>Breach &amp; Clear</t>"
		, { hint "Breach and clear" }
		, BG_BLACK		
	]
];

// --- MANAGEMENT section ---
// --------------------------

// --- COMBAT section ---
// ----------------------


