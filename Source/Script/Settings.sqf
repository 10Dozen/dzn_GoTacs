

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


// Addon Settings

private _add = {
	params ["_var","_type","_val",["_exp", "No Expression"],["_subcat", ""],["_isGlobal", false]];	
	 
	private _arr = [
		FORMAT_VAR(_var)
		, _type
		, [LOCALIZE_FORMAT_STR(_var), LOCALIZE_FORMAT_STR_desc(_var)]		
		, if (_subcat == "") then { TITLE } else { [TITLE, _subcat] }
		, _val
		, _isGlobal
	];
	
	if !(typename _exp == "STRING" && { _exp == "No Expression" }) then { _arr pushBack _exp; };
	_arr call CBA_Settings_fnc_init;
};

// Custom code to run over squad units
[
	"SquadCustomCode_Setting"
	, "EDITBOX"
	, ""
	, { 
		GVAR(SquadCustomCode) = compile (_this);
	}
] call _add;