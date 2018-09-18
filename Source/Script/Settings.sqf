

#include "macro.hpp";

// Keybinding 
[
	"dzn GoTacs"
	, "dzn_GoTacs_SquadMenu"
	, "Open Squad menu"
	, {
		[] spawn GVAR(fnc_uiShowMainOverlay);
		true
	}
	, {	true }
	, [15, [false,false,false]]
	, false
	, 0
	, true
] call CBA_fnc_addKeybind;

