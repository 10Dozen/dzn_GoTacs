

#include "macro.hpp";

// Keybinding 
[
	"dzn GoTacs"
	, "dzn_GoTacs_SquadMenu"
	, "Open Squad menu"
	, {
		[] spawn GVAR(fnc_uiShowSettingsOverlay);
		true
	}
	, {	true }
	, [16, [false,false,false]]
	, false
	, 0
	, true
] call CBA_fnc_addKeybind;

