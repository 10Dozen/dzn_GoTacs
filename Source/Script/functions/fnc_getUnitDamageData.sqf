
/* ----------------------------------------------------------------------------
Function: dzn_GoTacs_fnc_getUnitDamageData

Description:
	Return unit's damage related data, depending on given parameters
		- Color data for icon 
		- String status 

Parameters:
	_unit - unit to check <OBJECT>
	_mode - type of data to return: "color" or "string" <STRING>

Returns:
	<ARRAY> of color RGBA or <STRING> of status name

Examples:
    (begin example)
		_damageState = [_unit, "string"] call dzn_GoTacs_fnc_getUnitDamageData; // "Light wounded"
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

#include "..\macro.hpp"

params ["_unit", ["_mode", "color"]];

/*
	getAllHitPointsDamage cursorObject select 0 select 10			
	0: "hitlegs"
	1: "legs"

	getAllHitPointsDamage cursorObject select 0 select 9
	0: "hithands"
	1: "hands"

	getAllHitPointsDamage cursorObject select 0 select 2
	0: "hithead"
	1: "head"

	getAllHitPointsDamage cursorObject select 0 select 7
	0: "hitbody"
	1: "body"
*/

private _modeSelectId = switch (toLower _mode) do {
	case "color": { 0 };
	case "string": { 1 };
	case "icon": { 2 };
	default { 0 };
} ;

private _damageLevel = 0;
{ 
	_damageLevel = _damageLevel max _x;
} forEach (getAllHitPointsDamage _unit select 2);

private _case = switch (true) do {
	case (_damageLevel > 0.75): { 3 };
	case (_damageLevel > 0.5): { 2 };
	case (_damageLevel > 0.25): { 1 };
	default { 0 };
};

private _icon = " <img color='%1' image='\a3\ui_f\data\IGUI\Cfg\Actions\heal_ca.paa' />";
private _result = [
	[	[0,0,0,0]				, ""					, ""] 
	, [	[1, 0.9, 0.17, 1]		, "Light wound"			, format[_icon, "#ffe62b"] ]
	, [	[1, 0.5, 0.06, 1]		, "Medium wound"		, format[_icon, "#ff7f0f"] ]
	, [ [0.88, 0.15, 0.15, 1]	, "Heavy wound"			, format[_icon, "#e02626"] ]
] select _case select _modeSelectId;

_result