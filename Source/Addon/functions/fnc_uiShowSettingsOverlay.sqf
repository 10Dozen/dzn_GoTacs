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

GVAR(fnc_uiSwitchSelectorGroup) = {
	params["_groupName", "_switchToID"];

	private _ctrls = (uiNamespace getVariable _groupName);

	for "_i" from 1 to count _ctrls do {
		if (_i  == _switchToID) then {
			(_ctrls select _i) ctrlSetBackgroundColor BG_WHITE;
		} else {
			(_ctrls select _i) ctrlSetBackgroundColor BG_BLACK;
		};
	};
};

private _addButton = {
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

private _xOffset = 0;
private _yOffset = 0;
private _ctrlWidth = 0.2;
private _ctrlHeight = 0.05;

private _teamCtrl = [
	_display
	, "<t align='center' font='PuristaMedium'>Team assignment</t>"
	, nil
	, _xOffset, _yOffset, _ctrlWidth, _ctrlHeight
	, BG_EMPTY
] spawn GVAR(fnc_uiCreateClickableLabel);

private _appliedPattern = player getVariable [SVAR(TeamPattern), ""];

_xOffset = 0;
_yOffset = 0.05;
_ctrlWidth = 0.1;
_ctrlHeight = 0.05;

// _elementData params ["_label", "_code", "_bg", ["_tooltip", ""]];
{
	[_x, _xOffset, _yOffset, _ctrlWidth, _ctrlHeight] call _addButton;
	_xOffset = _xOffset + _ctrlWidth;
} forEach [
	[
		"<t align='center' font='PuristaMedium'>4-4</t>"
		, { 
			["4-4"] call GVAR(fnc_assignTeams);
			[] spawn GVAR(fnc_uiShowSettingsOverlay);

			hint parseText format ["<t size='1' color='#FFD000' shadow='1'>SQUAD:</t><br />Assigned to %1", "4-4"];
		}
		, if (_appliedPattern == "4-4") then { BG_WHITE } else { BG_BLACK }
		, "2x NATO/US 4 men fireteams"		
	]
	, [
		"<t align='center' font='PuristaMedium'>3-4</t>"
		, { 
			["3-4"] call GVAR(fnc_assignTeams);
			[] spawn GVAR(fnc_uiShowSettingsOverlay);

			hint parseText format ["<t size='1' color='#FFD000' shadow='1'>SQUAD:</t><br />Assigned to %1", "3-4"];
		}
		, if (_appliedPattern == "3-4") then { BG_WHITE } else { BG_BLACK }
		, "2x UK 4 men sections"		
	]
	, [
		"<t align='center' font='PuristaMedium'>2-3-3</t>"
		, { 
			["2-3-3"] call GVAR(fnc_assignTeams);
			[] spawn GVAR(fnc_uiShowSettingsOverlay);

			hint parseText format ["<t size='1' color='#FFD000' shadow='1'>SQUAD:</t><br />Assigned to %1", "2-3-3"];
		}
		, if (_appliedPattern == "2-3-3") then { BG_WHITE } else { BG_BLACK }
		, "RU MSO Crew / Base of fire / Maneuver teams"		
	]
	, [
		"<t align='center' font='PuristaMedium'>Custom</t>"
		, { 
			closeDialog 2;
			["Open", []] spawn GVAR(fnc_squadCustomizeMenu);
		}
		, if (_appliedPattern == "CUSTOM") then { BG_WHITE } else { BG_BLACK }
		, "Customize teams"		
	]
];


/*
	,"3-3-2"
	,"3-4"
];


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
} forEach [
	"4-4"
	,"3-3-2"
	,"3-4"
];;
*/

// -- Team management --
// ---------------------
private _teamMngmtCtrl = [
	_display, "<t align='left' font='PuristaMedium'>Squad management</t>", nil, 0.5, 0, 0.3, 0.05, BG_EMPTY
] spawn GVAR(fnc_uiCreateClickableLabel);

private _teamMngmtBtnCtrl = [
	_display
	, "<t align='center' font='PuristaMedium'>Manage</t>"
	, { closeDialog 2; [] spawn { uiSleep 0.05; ["Open"] call GVAR(fnc_squadManageMenu); }}
	, 0.5, 0.05, 0.2, 0.05, BG_BLACK
] spawn GVAR(fnc_uiCreateClickableLabel);



// --- Team markers ---
// --------------------
private _teamCtrl = [
	_display, "<t align='left' font='PuristaMedium'>Squad markers</t>", nil, 0, 0.15, 0.2, 0.05, BG_EMPTY
] spawn GVAR(fnc_uiCreateClickableLabel);

private _yOffset = 0.2;
{
	private _lineItems = _x;
	private _xOffset = 0;
	private _ctrlGroupName = "";
	private _ctrlGroup = [];

	{
		if (_forEachIndex == 0) then {
			_ctrlGroupName = _x;
		} else {
			_x params ["_label", "_code", "_bg", ["_w", 0.1]];

			private _ctrl = [
				_display, _label 
				, if (typename _code == "STRING") then { nil } else { _code  }
				, _xOffset, _yOffset, _w, 0.05
				, _bg
			] call GVAR(fnc_uiCreateClickableLabel);

			_ctrlGroup pushBack _ctrl;
			_xOffset = _xOffset + _w;
		};
	} forEach _lineItems;

	uiNamespace setVariable [_ctrlGroupName, _ctrlGroup];
	_yOffset = _yOffset + 0.05; 
} forEach [
	/* --- Team markers: Team --- */
	[
		/* Control group name */
		"TeamMarkersControls_Switch"
		/* Controls: */
		,["<t align='right' font='PuristaMedium'>Team:</t>", "", BG_EMPTY]
		,["<t align='center' font='PuristaMedium'>On</t>", {
			hint "Squad HUD: ENABLED";
			GVAR(SquadHUD_Draw) = true;			
			["TeamMarkersControls_Switch", 1] call GVAR(fnc_uiSwitchSelectorGroup);

		}, if (GVAR(SquadHUD_Draw)) then { BG_WHITE } else { BG_BLACK }]
		,["<t align='center' font='PuristaMedium'>Off</t>", { 
			hint "Squad HUD: DISABLED"; 
			GVAR(SquadHUD_Draw) = false;
			["TeamMarkersControls_Switch", 2] call GVAR(fnc_uiSwitchSelectorGroup);
		}, if !(GVAR(SquadHUD_Draw)) then { BG_WHITE } else { BG_BLACK }]
	]

	/* --- Team markers: Update time --- */
	, [
		"TeamMarkersControls_Time"
		,["<t align='right' font='PuristaMedium'>Timeout:</t>", "", BG_EMPTY]
		,["<t size='0.7' align='center' font='PuristaMedium'>5</t>", 
			{ 
				hint "Squad HUD: Info update time 5"; 
				GVAR(SquadHUD_DataUpdateTimeout) = 5; 
				["TeamMarkersControls_Time", 1] call GVAR(fnc_uiSwitchSelectorGroup);
			}, if (GVAR(SquadHUD_DataUpdateTimeout) == 5) then { BG_WHITE } else  { BG_BLACK }
			, 0.05
		]
		,["<t size='0.7' align='center' font='PuristaMedium'>15</t>", 
			{ 
				hint "Squad HUD: Info update time 15"; 
				GVAR(SquadHUD_DataUpdateTimeout) = 15; 
				["TeamMarkersControls_Time", 2] call GVAR(fnc_uiSwitchSelectorGroup);
			}, if (GVAR(SquadHUD_DataUpdateTimeout) == 15) then { BG_WHITE } else  { BG_BLACK }
			, 0.05
		]
		,["<t size='0.7' align='center' font='PuristaMedium'>30</t>", 
			{ 
				hint "Squad HUD: Info update time 30"; 
				GVAR(SquadHUD_DataUpdateTimeout) = 30; 
				["TeamMarkersControls_Time", 3] call GVAR(fnc_uiSwitchSelectorGroup);
			}, if (GVAR(SquadHUD_DataUpdateTimeout) == 30) then { BG_WHITE } else  { BG_BLACK }
			, 0.05
		]
		,["<t size='0.7' align='center' font='PuristaMedium'>60</t>", 
			{ 
				hint "Squad HUD: Info update time 60"; 
				GVAR(SquadHUD_DataUpdateTimeout) = 60; 
				["TeamMarkersControls_Time", 4] call GVAR(fnc_uiSwitchSelectorGroup);
			}, if (GVAR(SquadHUD_DataUpdateTimeout) == 60) then { BG_WHITE } else  { BG_BLACK }
			, 0.05
		]
	]

	/* --- Team markers: Opacity --- */
	, [
		"TeamMarkersControls_Opacity"
		,["<t align='right' font='PuristaMedium'>Opacity:</t>", "", BG_EMPTY]
		,["<t size='0.7' align='center' font='PuristaMedium'>25</t>", 
			{ 
				hint "Squad HUD: Opacity set to 25%";
				GVAR(SquadHUD_Opacity) = 0.25;
				["TeamMarkersControls_Opacity", 1] call GVAR(fnc_uiSwitchSelectorGroup);
			}, if (GVAR(SquadHUD_Opacity) == 0.25) then { BG_WHITE } else  { BG_BLACK }
			, 0.05
		]
		,["<t size='0.7' align='center' font='PuristaMedium'>50</t>", 
			{ 
				hint "Squad HUD: Opacity set to 50%";
				GVAR(SquadHUD_Opacity) = 0.50;
				["TeamMarkersControls_Opacity", 2] call GVAR(fnc_uiSwitchSelectorGroup);
			}, if (GVAR(SquadHUD_Opacity) == 0.50) then { BG_WHITE } else  { BG_BLACK }
			, 0.05
		]
		,["<t size='0.7' align='center' font='PuristaMedium'>75</t>", 
			{ 
				hint "Squad HUD: Opacity set to 75%";
				GVAR(SquadHUD_Opacity) = 0.75;
				["TeamMarkersControls_Opacity", 3] call GVAR(fnc_uiSwitchSelectorGroup);
			}, if (GVAR(SquadHUD_Opacity) == 0.75) then { BG_WHITE } else  { BG_BLACK }
			, 0.05
		]
		,["<t size='0.7' align='center' font='PuristaMedium'>100</t>", 
			{ 
				hint "Squad HUD: Opacity set to 100%";
				GVAR(SquadHUD_Opacity) = 1;
				["TeamMarkersControls_Opacity", 4] call GVAR(fnc_uiSwitchSelectorGroup);
			}, if (GVAR(SquadHUD_Opacity) == 1) then { BG_WHITE } else  { BG_BLACK }
			, 0.05
		]
	]

	/* --- Command pointer --- */
	, [
		"TeamMarkersControls_CommandIcon"
		,["<t align='right' font='PuristaMedium'>Show pointer:</t>", "", BG_EMPTY]
		,["<t align='center' font='PuristaMedium'>On</t>", {

			hint "Command pointer: ENABLED";
			GVAR(CommandHUD_Draw) = true;			
			"show" spawn fnc_showCommandPointer;

		}, if (GVAR(CommandHUD_Draw)) then { BG_WHITE } else { BG_BLACK }]
		,["<t align='center' font='PuristaMedium'>Off</t>", { 

			hint "Command pointer: DISABLED"; 
			GVAR(CommandHUD_Draw) = false;
			"hide" spawn fnc_showCommandPointer;

		}, if !(GVAR(CommandHUD_Draw)) then { BG_WHITE } else { BG_BLACK }]

	]
];


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

	/* --- Contacts markers: Opacity --- */
	, [
		["<t align='right' font='PuristaMedium'>Opacity:</t>", "", BG_EMPTY]
		,["<t size='0.7' align='center' font='PuristaMedium'>25</t>", { hint "Contacts HUD: Opacity set to 25%"; GVAR(ContactsHUD_Opacity) = 0.25; }, BG_BLACK, 0.05]
		,["<t size='0.7' align='center' font='PuristaMedium'>50</t>", { hint "Contacts HUD: Info update time 50%"; GVAR(ContactsHUD_Opacity) = 0.5; }, BG_BLACK, 0.05]
		,["<t size='0.7' align='center' font='PuristaMedium'>75</t>", { hint "Contacts HUD: Info update time 75%"; GVAR(ContactsHUD_Opacity) = 0.75; }, BG_BLACK, 0.05]
		,["<t size='0.7' align='center' font='PuristaMedium'>100</t>", { hint "Contacts HUD: Info update time 100%"; GVAR(ContactsHUD_Opacity) = 1;}, BG_BLACK, 0.05]
	]

	, [
		["", "", BG_EMPTY]
		,["<t align='center' font='PuristaMedium'>Reset</t>", { [] spawn fnc_resetContactLoop; }, BG_BLACK, 0.2]
	]
];

uiNamespace setVariable ["ContactsMarkersControls", _contactsMarkersCtrls];
