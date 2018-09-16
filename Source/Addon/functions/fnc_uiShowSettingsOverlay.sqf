/* ----------------------------------------------------------------------------
Function: dzn_GoTacs_fnc_uiShowSettingsOverlay

Description:
	Draw main command overlay

Parameters:
	nothing

Returns:
	nothing

Examples:
    (begin example)
		[] spawn dzn_GoTacs_fnc_uiShowSettingsOverlay;
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
	, "<t align='center' font='PuristaMedium'>Command</t>"
	, { [] spawn GVAR(fnc_uiShowMainOverlay) }
	, -0.15, -0.15, 0.2, 0.05
] spawn GVAR(fnc_uiCreateClickableLabel);



// -- Team assignement ---
// -----------------------
private _teamCtrl = [
	_display
	, "<t align='center' font='PuristaMedium'>Team assignment</t>"
	, nil
	, 0, 0, 0.2, 0.05
	, BG_EMPTY
] spawn GVAR(fnc_uiCreateClickableLabel);

private _appliedPattern = player getVariable [SVAR(TeamPattern), ""];
private _pos = [0, 0.05, 0.125, 0.05];
{
	private _label = _x;
	private _code = compile format [
		"['%1'] call %2; [] spawn %3; hint 'Teams assigned';"
		, _label
		, SVAR(fnc_assignTeams)
		, SVAR(fnc_uiShowSettingsOverlay)
	];

	private _bg = BG_BLACK;
	if (_appliedPattern == _label) then {
		_bg = BG_WHITE;
	};

	private _teamBtnCtrl = [
		_display
		, format ["<t align='center' font='PuristaLight'>SL/%1</t>", _label]
		, _code
		, _pos # 0, _pos # 1, _pos # 2, _pos # 3
		, _bg
	] spawn GVAR(fnc_uiCreateClickableLabel);

	_pos set [0, (_pos # 0) + 0.126];
} forEach GVAR(TeamAssignmentEnum);

// -- Team management --
// ---------------------
private _teamMngmtCtrl = [
	_display
	, "<t align='left' font='PuristaMedium'>Team management</t>"
	, nil
	, 0.5, 0, 0.3, 0.05
	, BG_EMPTY
] spawn GVAR(fnc_uiCreateClickableLabel);

private _teamMngmtBtnCtrl = [
	_display
	, "<t align='center' font='PuristaMedium'>Manage</t>"
	, { closeDialog 2; [] spawn { uiSleep 0.05; call dzn_GoTacs_fnc_createSquad; }}
	, 0.5, 0.05, 0.2, 0.05
	, BG_BLACK
] spawn GVAR(fnc_uiCreateClickableLabel);



// --- Team markers ---
// --------------------
private _teamCtrl = [
	_display
	, "<t align='left' font='PuristaMedium'>Squad markers</t>"
	, nil
	, 0, 0.15, 0.2, 0.05
	, BG_EMPTY
] spawn GVAR(fnc_uiCreateClickableLabel);

uiNamespace setVariable ["TeamMarkersControls", []];
private _teamMarkersCtrls = [];

private _yOffset = 0.2;
{
	private _lineItems = _x;
	private _xOffset = 0;

	{
		_x params ["_label", "_code", "_bg", ["_w", 0.1]];

		private _ctrl = [
			_display, _label , if (typename _code == "STRING") then { nil } else { _code  }
			, _xOffset, _yOffset, _w, 0.05
			, _bg
		] call GVAR(fnc_uiCreateClickableLabel);
		_teamMarkersCtrls pushBack _ctrl;

		_xOffset = _xOffset + _w;
	} forEach _lineItems;
	
	_yOffset = _yOffset + 0.05; 
} forEach [
	/* --- Team markers: Team --- */
	[
		["<t align='right' font='PuristaMedium'>Team:</t>", "", BG_EMPTY]
		,["<t align='center' font='PuristaMedium'>On</t>", {
			hint "Squad HUD: ENABLED";
			GVAR(SquadHUD_Draw) = true;
			_ctrlOn = (uiNamespace getVariable "TeamMarkersControls") select 1;
			_ctrlOff = (uiNamespace getVariable "TeamMarkersControls") select 2;

			_ctrlOn ctrlSetBackgroundColor BG_WHITE;
			_ctrlOff ctrlSetBackgroundColor BG_BLACK;

		}, if (GVAR(SquadHUD_Draw)) then { BG_WHITE } else { BG_BLACK }]
		,["<t align='center' font='PuristaMedium'>Off</t>", { 
			hint "Squad HUD: DISABLED"; 
			GVAR(SquadHUD_Draw) = false; 
			_ctrlOn = (uiNamespace getVariable "TeamMarkersControls") select 1;
			_ctrlOff = (uiNamespace getVariable "TeamMarkersControls") select 2;

			_ctrlOn ctrlSetBackgroundColor BG_BLACK;
			_ctrlOff ctrlSetBackgroundColor BG_WHITE;

		}, if !(GVAR(SquadHUD_Draw)) then { BG_WHITE } else { BG_BLACK }]
	]

	/* --- Team markers: Update time --- */
	, [
		["<t align='right' font='PuristaMedium'>Timeout:</t>", "", BG_EMPTY]
		,["<t size='0.7' align='center' font='PuristaMedium'>5</t>", { hint "Squad HUD: Info update time 5"; GVAR(SquadHUD_DataUpdateTimeout) = 5; GVAR(ContactsNextRequestTime) = 0; }, BG_BLACK, 0.05]
		,["<t size='0.7' align='center' font='PuristaMedium'>15</t>", { hint "Squad HUD: Info update time 15"; GVAR(SquadHUD_DataUpdateTimeout) = 15; GVAR(ContactsNextRequestTime) = 0;}, BG_BLACK, 0.05]
		,["<t size='0.7' align='center' font='PuristaMedium'>30</t>", { hint "Squad HUD: Info update time 30"; GVAR(SquadHUD_DataUpdateTimeout) = 30; GVAR(ContactsNextRequestTime) = 0;}, BG_BLACK, 0.05]
		,["<t size='0.7' align='center' font='PuristaMedium'>60</t>", { hint "Squad HUD: Info update time 60"; GVAR(SquadHUD_DataUpdateTimeout) = 60; GVAR(ContactsNextRequestTime) = 0;}, BG_BLACK, 0.05]
	]
];

uiNamespace setVariable ["TeamMarkersControls", _teamMarkersCtrls];


// --- Contact markers ---
// --------------------
private _contactsCtrl = [
	_display
	, "<t align='left' font='PuristaMedium'>Contacts markers</t>"
	, nil
	, 0, _yOffset + 0.15, 0.2, 0.05
	, BG_EMPTY
] spawn GVAR(fnc_uiCreateClickableLabel);

uiNamespace setVariable ["ContactsMarkersControls", []];
private _contactsMarkersCtrls = [];

private _yOffset = _yOffset + 0.2;
{
	private _lineItems = _x;
	private _xOffset = 0;

	{
		_x params ["_label", "_code", "_bg", ["_w", 0.1]];

		private _ctrl = [
			_display, _label , if (typename _code == "STRING") then { nil } else { _code  }
			, _xOffset, _yOffset, _w, 0.05
			, _bg
		] call GVAR(fnc_uiCreateClickableLabel);
		_contactsMarkersCtrls pushBack _ctrl;

		_xOffset = _xOffset + _w;
	} forEach _lineItems;
	
	_yOffset = _yOffset + 0.05; 
} forEach [
	/* --- Contacts markers: Enable --- */
	[
		["<t align='right' font='PuristaMedium'>HUD:</t>", "", BG_EMPTY]
		,["<t align='center' font='PuristaMedium'>On</t>", {
			hint "Contacts HUD: ENABLED";
			GVAR(ContactsHUD_Draw)  = true;
			_ctrlOn = (uiNamespace getVariable "ContactsMarkersControls") select 1;
			_ctrlOff = (uiNamespace getVariable "ContactsMarkersControls") select 2;

			_ctrlOn ctrlSetBackgroundColor BG_WHITE;
			_ctrlOff ctrlSetBackgroundColor BG_BLACK;

		}, if (GVAR(SquadHUD_Draw)) then { BG_WHITE } else { BG_BLACK }]
		,["<t align='center' font='PuristaMedium'>Off</t>", { 
			hint "Contacts HUD: DISABLED"; 
			GVAR(ContactsHUD_Draw)  = false; 
			_ctrlOn = (uiNamespace getVariable "ContactsMarkersControls") select 1;
			_ctrlOff = (uiNamespace getVariable "ContactsMarkersControls") select 2;

			_ctrlOn ctrlSetBackgroundColor BG_BLACK;
			_ctrlOff ctrlSetBackgroundColor BG_WHITE;

		}, if !(GVAR(SquadHUD_Draw)) then { BG_WHITE } else { BG_BLACK }]
	]

	/* --- Contacts markers: Update time --- */
	, [
		["<t align='right' font='PuristaMedium'>Timeout:</t>", "", BG_EMPTY]
		,["<t size='0.7' align='center' font='PuristaMedium'>5</t>", { hint "Contacts HUD: Info update time 5"; GVAR(ContactsHUD_DataUpdateTimeout) = 5; }, BG_BLACK, 0.05]
		,["<t size='0.7' align='center' font='PuristaMedium'>15</t>", { hint "Contacts HUD: Info update time 15"; GVAR(ContactsHUD_DataUpdateTimeout) = 15; }, BG_BLACK, 0.05]
		,["<t size='0.7' align='center' font='PuristaMedium'>30</t>", { hint "Contacts HUD: Info update time 30"; GVAR(ContactsHUD_DataUpdateTimeout) = 30; }, BG_BLACK, 0.05]
		,["<t size='0.7' align='center' font='PuristaMedium'>60</t>", { hint "Contacts HUD: Info update time 60"; GVAR(ContactsHUD_DataUpdateTimeout) = 60;}, BG_BLACK, 0.05]
	]
];

uiNamespace setVariable ["ContactsMarkersControls", _contactsMarkersCtrls];
