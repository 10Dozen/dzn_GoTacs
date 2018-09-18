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
#define BG_RED [0.85,0,0,1]
#define BG_GREEN [0,0.85,0,1]
#define BG_BLUE [0.15, 0.15, 0.75, 1]
#define BG_YELLOW [1,0.95,0,1]
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


// --- States buttons ---
// ----------------------
private _xOffset = -0.35;
private _yOffset = 0;
private _cellWidth = 0.035;
{
	private _lineItems = _x;
	private _ctrlGroupName = "";
	private _ctrlGroup = [];

	{
		if (_forEachIndex == 0) then {
			_ctrlGroupName = _x;
		} else {
			_x params ["_label", "_code", "_bg", ["_w", 0.1], ["_tooltip", ""]];

			private _ctrl = [
				_display, _label 
				, if (typename _code == "STRING") then { nil } else { _code  }
				, _xOffset, _yOffset, _w, 0.05
				, _bg
				, _tooltip
			] call GVAR(fnc_uiCreateClickableLabel);

			_ctrlGroup pushBack _ctrl;
			_xOffset = _xOffset + _w;
		};
	} forEach _lineItems;

	uiNamespace setVariable [_ctrlGroupName, _ctrlGroup];
	_xOffset = _xOffset + 0.05; 
} forEach [
	#define RE_OPEN()	[] spawn { closeDialog 2; [] spawn dzn_GoTacs_fnc_uiShowMainOverlay;}
	#define CM_TITLE(X) if (combatMode (group player) == X) then { "#" } else { "" }
	[
		"CombatMode_Switch"
		,["<t align='right' font='PuristaMedium'>Combat mode:</t>", "", BG_EMPTY, 0.2]
		,[ CM_TITLE("RED"), {
			hint parseText "<t size='1' color='#FFD000' shadow='1'>Squad combat mode:</t><br />RED";
			(group player) setCombatMode "RED";
			RE_OPEN();
		}, BG_RED, _cellWidth]
		,[ CM_TITLE("YELLOW"), {
			hint parseText "<t size='1' color='#FFD000' shadow='1'>Squad combat mode:</t><br />YELLOW";
			(group player) setCombatMode "YELLOW";
			RE_OPEN();
		}, BG_YELLOW, _cellWidth]
		,[ CM_TITLE("WHITE"), {
			hint parseText "<t size='1' color='#FFD000' shadow='1'>Squad combat mode:</t><br />WHITE";
			(group player) setCombatMode "WHITE";
			RE_OPEN();
		}, BG_WHITE, _cellWidth]
		,[ CM_TITLE("GREEN"), {
			hint parseText "<t size='1' color='#FFD000' shadow='1'>Squad combat mode:</t><br />GREEN";
			(group player) setCombatMode "GREEN";
			RE_OPEN();
		}, BG_GREEN, _cellWidth]
		,[ CM_TITLE("BLUE"), {
			hint parseText "<t size='1' color='#FFD000' shadow='1'>Squad combat mode:</t><br />BLUE";
			(group player) setCombatMode "BLUE";
			RE_OPEN();
		}, BG_BLUE, _cellWidth]
	]

	#define BM_TITLE(X) if (behaviour (player) == X) then { "#" } else { "" }
	, [
		"BehaviorMode_Switch"
		,["<t align='right' font='PuristaMedium'>Behaviour:</t>", "", BG_EMPTY, 0.125]
		,[ BM_TITLE("COMBAT"), {
			hint parseText "<t size='1' color='#FFD000' shadow='1'>Squad behaviour:</t><br />COMBAT";
			(group player) setBehaviour "COMBAT";
			RE_OPEN();
		}, BG_RED, _cellWidth, "Combat"]
		,[ BM_TITLE("AWARE"), {
			hint parseText "<t size='1' color='#FFD000' shadow='1'>Squad behaviour:</t><br />AWARE";
			(group player) setBehaviour "AWARE";
			RE_OPEN();
		}, BG_YELLOW, _cellWidth, "Aware"]
		,[ BM_TITLE("SAFE"), {
			hint parseText "<t size='1' color='#FFD000' shadow='1'>Squad behaviour:</t><br />SAFE";
			(group player) setBehaviour "SAFE";
			RE_OPEN();
		}, BG_WHITE, _cellWidth, "Safe"]
		,[ BM_TITLE("CARELESS"), {
			hint parseText "<t size='1' color='#FFD000' shadow='1'>Squad behaviour:</t><br />CARELESS";
			(group player) setBehaviour "CARELESS";
			RE_OPEN();
		}, BG_GREEN, _cellWidth, "Careless"]
		,[ BM_TITLE("STEALTH"), {
			hint parseText "<t size='1' color='#FFD000' shadow='1'>Squad behaviour:</t><br />STEALTH";
			(group player) setBehaviour "STEALTH";
			RE_OPEN();
		}, BG_BLUE, _cellWidth, "Stealth"]
	]

	#define SM_TITLE(X) if (speedMode (group player) == X) then { "#" } else { "" }
	, [
		"SpeedMode_Switch"
		,["<t align='right' font='PuristaMedium'>Speed:</t>", "", BG_EMPTY, 0.125]
		,[ SM_TITLE("FULL"), {
			hint parseText "<t size='1' color='#FFD000' shadow='1'>Squad speed mode:</t><br />FULL";
			(group player) setSpeedMode "FULL";
			RE_OPEN();
		}, BG_RED, _cellWidth, "Full"]
		,[ SM_TITLE("NORMAL"), {
			hint parseText "<t size='1' color='#FFD000' shadow='1'>Squad speed mode:</t><br />NORMAL";
			(group player) setSpeedMode "NORMAL";
			RE_OPEN();
		}, BG_WHITE, _cellWidth, "Normal"]
		,[ SM_TITLE("LIMITED"), {
			hint parseText "<t size='1' color='#FFD000' shadow='1'>Squad speed mode:</t><br />LIMITED";
			(group player) setSpeedMode "LIMITED";
			RE_OPEN();
		}, BG_BLUE, _cellWidth, "Limited"]
	]

	#define FM_BGCOLOR(X) if (formation (group player) == X) then { BG_BLUE } else { [0.9,0.9,0.9,1] }
	, [
		"FormationMode_Switch"
		,["<t align='right' font='PuristaMedium'>Formation:</t>", "", BG_EMPTY, 0.125]
		,[ "W", {
			hint parseText "<t size='1' color='#FFD000' shadow='1'>Squad formation:</t><br />WEDGE";
			(group player) setFormation  "WEDGE";
			RE_OPEN();
		}, FM_BGCOLOR("WEDGE"), _cellWidth, "Wedge"]
		,[ "L", {
			hint parseText "<t size='1' color='#FFD000' shadow='1'>Squad formation:</t><br />LINE";
			(group player) setFormation  "LINE";
			RE_OPEN();
		}, FM_BGCOLOR("LINE"), _cellWidth, "Line"]
		,[ "C", {
			hint parseText "<t size='1' color='#FFD000' shadow='1'>Squad formation:</t><br />COLUMN";
			(group player) setFormation  "COLUMN";
			RE_OPEN();
		}, FM_BGCOLOR("COLUMN"), _cellWidth, "Column"]
		,[ "el", {
			hint parseText "<t size='1' color='#FFD000' shadow='1'>Squad formation:</t><br />ECHELON LEFT";
			(group player) setFormation  "ECH LEFT";
			RE_OPEN();
		}, FM_BGCOLOR("ECH LEFT"), _cellWidth, "Echelon left"]
		,[ "er", {
			hint parseText "<t size='1' color='#FFD000' shadow='1'>Squad formation:</t><br />ECHELON RIGHT";
			(group player) setFormation  "ECH RIGHT";
			RE_OPEN();
		}, FM_BGCOLOR("ECH RIGHT"), _cellWidth, "Echelon right"]
		,[ "S", {
			hint parseText "<t size='1' color='#FFD000' shadow='1'>Squad formation:</t><br />STAGGERED COLUMN";
			(group player) setFormation  "STAG COLUMN";
			RE_OPEN();
		}, FM_BGCOLOR("STAG COLUMN"), _cellWidth, "Staggered column"]
		,[ "F", {
			hint parseText "<t size='1' color='#FFD000' shadow='1'>Squad formation:</t><br />FILE";
			(group player) setFormation  "FILE";
			RE_OPEN();
		}, FM_BGCOLOR("FILE"), _cellWidth, "File"]
		,[ "V", {
			hint parseText "<t size='1' color='#FFD000' shadow='1'>Squad formation:</t><br />VEE";
			(group player) setFormation  "VEE";
			RE_OPEN();
		}, FM_BGCOLOR("VEE"), _cellWidth, "Vee"]
		,[ "D", {
			hint parseText "<t size='1' color='#FFD000' shadow='1'>Squad formation:</t><br />DIAMOND";
			(group player) setFormation  "DIAMOND";
			RE_OPEN();
		}, FM_BGCOLOR("DIAMOND"), _cellWidth, "Diamond"]
	]

];

// --- Commanding buttons ---
// --------------------------

_xOffset = 0;
_yOffset = 0;
private _ctrlWidth = 0.25;
private _ctrlHeight = 0.05;

// --- MOVE section ---
// --------------------
/*
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
*/

// --- MANAGEMENT section ---
// --------------------------
_xOffset = 0.35;
_yOffset = 0.25;
{
	_x params ["_label", "_code", "_bg", ["_tooltip", ""]];

	[
		_display
		, _label
		, if (typename _code == "STRING") then { nil } else { _code }
		, _xOffset, _yOffset, _ctrlWidth, _ctrlHeight
		, _bg
		, _tooltip
	] spawn GVAR(fnc_uiCreateClickableLabel);
	_yOffset = _yOffset + _ctrlHeight;
} forEach [
	[
		"<t align='center' font='PuristaMedium'>O R D E R</t>"
		, ""
		, BG_EMPTY
	]
	, [
		"<t align='center' font='PuristaMedium'>Get In (fast)</t>"
		, {
			closeDialog 2;

			if (vehicle player != player) then {
				hint parseText "<t size='1' color='#FFD000' shadow='1'>SQUAD:</t><br />Get in my vehicle!";
				[units player, vehicle player] call fnc_getInFast;
			} else {
				if (isNull cursorTarget ) exitWith { hint parseText "No vehicle!"; };

				private _v = cursorObject;
				if ((_v call BIS_fnc_vehicleRoles) isEqualTo []) exitWith {  hint parseText "No vehicle!"; };

				hint parseText format [
					"<t size='1' color='#FFD000' shadow='1'>SQUAD:</t><br />Get in vehicle - %1!"
					, getText (configFile >> "CfgVehicles" >> typeof _v >> "displayName")
				];
				[units player, _v] call fnc_getInFast;
			};
		}
		, BG_BLACK
	]
	, [
		"<t align='center' font='PuristaMedium'>Unload (fast)</t>"
		, {
			closeDialog 2;
			hint parseText "<t size='1' color='#FFD000' shadow='1'>SQUAD:</t><br />Dismount! Fast!";
			(units player) spawn fnc_dismountFast;
		}
		, BG_BLACK
	]


	, [
		"<t align='center' font='PuristaMedium'>Bail Out</t>"
		, {
			closeDialog 2;
			hint parseText "<t size='1' color='#FFD000' shadow='1'>SQUAD:</t><br />Bail out! Bail out! Bail out!";
			(units player) spawn fnc_bailOut;
		}
		, BG_BLACK
	]
];

// --- COMBAT section ---
// ----------------------


