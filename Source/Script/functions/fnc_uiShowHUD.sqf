
/* ----------------------------------------------------------------------------
Function: dzn_GoTacs_fnc_uiShowHUD

Description:
	Show given HUD

Parameters:
	_hudEnum - name of HUD to display. May be "Squad", "Contacts" or "Command". <STRING>

Returns:
	_ehID - onEachFrame event handler ID <NUMBER>

Examples:
    (begin example)
		_ehID = "Contacts" call dzn_GoTacs_fnc_uiShowHUD; // Start contacts HUD drawing
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

#include "..\macro.hpp"

private _hud = toLower(_this);

private _ehName = "";
private _ehCode = {};

switch (_hud) do {
	case "squad": {
		_ehName = SVAR(SquadHUD_EH);
		_ehCode = { call GVAR(fnc_uiDrawSquadHUD); };
	};
	case "contacts": {
		_ehName = SVAR(ContactsHUD_EH);
		_ehCode = { call GVAR(fnc_uiDrawContactsHUD); };
	};
	case "command": {};
};


private _ehID = [_ehName, "onEachFrame", _ehCode] call BIS_fnc_addStackedEventHandler;
player setVariable [_ehName, _ehID];

(_ehID)