
/* ----------------------------------------------------------------------------
Function: dzn_GoTacs_fnc_uiHideHUD

Description:
	Hide given HUD

Parameters:
	_hudEnum - name of HUD to display. May be "Squad", "Contacts" or "Command". <STRING>	

Returns:
	nothing

Examples:
    (begin example)
		"Contacts" call dzn_GoTacs_fnc_uiHideHUD;
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

#include "..\macro.hpp"

private _hud = toLower(_this);

private _ehName = switch (_hud) do {
	case "squad": { SVAR(SquadHUD_EH) };
	case "contacts": { SVAR(ContactsHUD_EH) };
	case "command": {};
};

private _ehID = player getVariable [_ehName, -1];

if (_ehID < 0) exitWith {};
[_ehID, "onEachFrame"] call BIS_fnc_removeStackedEventHandler;