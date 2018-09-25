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

#define SEL_UNITS [] call GVAR(fnc_getSelectedTeamUnits)

#define BG_BLACK [0,0,0,1]
#define BG_WHITE [1,1,1,1]
#define BG_GRAY [0.9,0.9,0.9,1]
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
	_xOffset = _xOffset + 0.015; 
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
		,["<t align='right' font='PuristaMedium'>Speed:</t>", "", BG_EMPTY, 0.1]
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
	
	, [
		"StanceMode_Switch"
		,["<t align='right' font='PuristaMedium'>Stance:</t>", "", BG_EMPTY, 0.125, "Can be applied to specific team"]
		, ["A", {
			hint parseText "<t size='1' color='#FFD000' shadow='1'>Squad stance:</t><br />AUTO";
			(SEL_UNITS) apply { _x setUnitPos "AUTO" };
			RE_OPEN();
		}, BG_GRAY, _cellWidth, "Stance: Auto"]
		, ["U", {
			hint parseText "<t size='1' color='#FFD000' shadow='1'>Squad stance:</t><br />Up";
			(SEL_UNITS) apply { _x setUnitPos "UP" };
			RE_OPEN();
		}, BG_GRAY, _cellWidth, "Stance: Up"]
		, ["M", {
			hint parseText "<t size='1' color='#FFD000' shadow='1'>Squad stance:</t><br />Middle";
			(SEL_UNITS) apply { _x setUnitPos "MIDDLE" };
			RE_OPEN();
		}, BG_GRAY, _cellWidth, "Stance: Middle"]
		, ["D", {
			hint parseText "<t size='1' color='#FFD000' shadow='1'>Squad stance:</t><br />Down";	
			(SEL_UNITS) apply { _x setUnitPos "DOWN" };
			RE_OPEN();
		}, BG_GRAY, _cellWidth, "Stance: Down"]
	]

	#define FM_BGCOLOR(X) if (formation (group player) == X) then { BG_BLUE } else { BG_GRAY }
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

private _addOrderButton = {
	params ["_elementData", "_xOffset", "_yOffset", "_ctrlWidth", "_ctrlHeight"];

	_elementData params ["_label", "_code", "_bg", ["_tooltip", ""]];

	[
		(findDisplay 134102)
		, _label
		, if (typename _code == "STRING") then { nil } else { _code }
		, _xOffset, _yOffset, _ctrlWidth, _ctrlHeight
		, _bg
		, _tooltip
	] spawn GVAR(fnc_uiCreateClickableLabel);
};

// --- MANAGEMENT section ---
// --------------------------
_xOffset = 0.35;
_yOffset = 0.25;
{
	[_x, _xOffset, _yOffset, _ctrlWidth, _ctrlHeight] call _addOrderButton;
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
				["Get In fast", [SEL_UNITS, vehicle player]] spawn GVAR(fnc_issueOrder);
				["Deselect"] call GVAR(fnc_handleTeamSelection);
			} else {
				if (isNull cursorTarget ) exitWith { hint parseText "No vehicle!"; };

				private _v = cursorObject;
				if ((_v call BIS_fnc_vehicleRoles) isEqualTo []) exitWith {  hint parseText "No vehicle!"; };

				hint parseText format [
					"<t size='1' color='#FFD000' shadow='1'>SQUAD:</t><br />Get in vehicle - %1!"
					, getText (configFile >> "CfgVehicles" >> typeof _v >> "displayName")
				];
				
				["Get In fast", [SEL_UNITS, _v]] spawn GVAR(fnc_issueOrder);
				["Deselect"] call GVAR(fnc_handleTeamSelection);
			};
		}
		, BG_BLACK
	]
	, [
		"<t align='center' font='PuristaMedium'>Get In (Custom)</t>"
		, { 
			closeDialog 2;
			if (vehicle player != player) then {
				hint parseText "<t size='1' color='#FFD000' shadow='1'>SQUAD:</t><br />My vehicle";				
				["Open", [vehicle player]] spawn GVAR(fnc_squadAssignVehicleRole);
			} else {
				if (isNull cursorTarget ) exitWith { hint parseText "No vehicle!"; };

				private _v = cursorObject;
				if ((_v call BIS_fnc_vehicleRoles) isEqualTo []) exitWith {  hint parseText "No vehicle!"; };

				hint parseText format [
					"<t size='1' color='#FFD000' shadow='1'>SQUAD:</t><br />Get in vehicle - %1!"
					, getText (configFile >> "CfgVehicles" >> typeof _v >> "displayName")
				];
				["Open", [_v]] spawn GVAR(fnc_squadAssignVehicleRole);
			};
		}
		, BG_BLACK
	]
	, ["","",BG_EMPTY]
	, [
		"<t align='center' font='PuristaMedium'>Unload (fast)</t>"
		, {
			closeDialog 2;
			hint parseText "<t size='1' color='#FFD000' shadow='1'>SQUAD:</t><br />Dismount! Fast!";
			["Dismount fast", SEL_UNITS] spawn GVAR(fnc_issueOrder);
			["Deselect"] call GVAR(fnc_handleTeamSelection);
		}
		, BG_BLACK
	]
	, [
		"<t align='center' font='PuristaMedium'>Bail Out</t>"
		, {
			closeDialog 2;
			hint parseText "<t size='1' color='#FFD000' shadow='1'>SQUAD:</t><br />Bail out! Bail out! Bail out!";
			["Bail out", SEL_UNITS] spawn GVAR(fnc_issueOrder);
			["Deselect"] call GVAR(fnc_handleTeamSelection);
		}
		, BG_BLACK
	]
];


// --- MOVE section ---
// --------------------------
_xOffset = 0.75;
_yOffset = 0.25;
{
	[_x, _xOffset, _yOffset, _ctrlWidth, _ctrlHeight] call _addOrderButton;
	_yOffset = _yOffset + _ctrlHeight;
} forEach [
	[
		"<t align='center' font='PuristaMedium'>M O V E</t>"
		, ""
		, BG_EMPTY
	]
	, [
		"<t align='center' font='PuristaMedium'>Breach</t>"
		, {
			closeDialog 2;

			if (cursorObject isKindOf "House") then {
				hint parseText format [
					"<t size='1' color='#FFD000' shadow='1'>SQUAD:</t><br />Breach that building (%1)!"
					, getText (configFile >> "CfgVehicles" >> typeof cursorObject >> "displayName")
				];

				["Breach", [SEL_UNITS, cursorObject]] spawn GVAR(fnc_issueOrder);
				["Deselect"] call GVAR(fnc_handleTeamSelection);
			} else {
				hint parseText "No house pointed!";
			};
		}
		, BG_BLACK
	]
	, [
		"", "", BG_EMPTY
	]
	, [
		"<t align='center' font='PuristaMedium'>Find cover</t>"
		, {
			closeDialog 2;

			hint parseText format [
				"<t size='1' color='#FFD000' shadow='1'>SQUAD:</t><br />Find cover!"
			];

			["Find cover", SEL_UNITS] spawn GVAR(fnc_issueOrder);

			["Deselect"] call GVAR(fnc_handleTeamSelection);
		}
		, BG_BLACK
	]
	, [
		"<t align='center' font='PuristaMedium'>Rally up</t>"
		, {
			closeDialog 2;

			hint parseText format [
				"<t size='1' color='#FFD000' shadow='1'>SQUAD:</t><br />Rally up!"
			];

			["Rally up", SEL_UNITS] spawn GVAR(fnc_issueOrder);

			["Deselect"] call GVAR(fnc_handleTeamSelection);
		}
		, BG_BLACK
	]
];



// --- COMBAT section ---
// ----------------------


