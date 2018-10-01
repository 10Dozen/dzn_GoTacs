/* ----------------------------------------------------------------------------
Function: dzn_GoTacs_fnc_uiDrawTeamSelection

Description:
	Hide given HUD

Parameters:
	_teamRedSelected - flag of selection of the team red <BOOLEAN>
	_teamBlueSelected - flag of selection of the team blue <BOOLEAN>
	_teamGreenSelected - flag of selection of the team green <BOOLEAN>
	_teamYellowSelected - flag of selection of the team yellow <BOOLEAN>

Returns:
	nothing

Examples:
    (begin example)
		[false, true, false, false] spawn dzn_GoTacs_fnc_uiDrawTeamSelection; // Draws label of Blue team as selected
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

#include "..\macro.hpp"

disableSerialization;

133799 cutRsc ["dzn_GoTacs_Rsc","PLAIN",0];
private _dialog = uiNamespace getVariable "dzn_GoTacs_Rsc";

private _xOffset = 0.35;
private _yOffset = -0.25;
private _w = 0.2;
private _h = 0.05;

private _teamsUnits = player getVariable SVAR(Teams);

private ["_ctrlLabel", "_ctrlColor"];
{
	_x params ["_toShow", "_label", "_teamSize", "_color"];

	if (_toShow && _teamSize > 0) then {
		_yOffset = _yOffset + 0.05;

		_ctrlLabel = _dialog ctrlCreate ["RscStructuredText", -1];
		_ctrlLabel ctrlSetStructuredText parseText format [
			"<t font=""PuristaMedium"">%2 %1 team</t>"
			, if (_teamSize > 1) then { "men" } else { "man" }
			, _teamSize
		];
		_ctrlLabel ctrlSetBackgroundColor [0,0,0,0.25];
		_ctrlLabel ctrlSetPosition [_xOffset, _yOffset, _w, _h];
		_ctrlLabel ctrlCommit 0;

		_ctrlColor = _dialog ctrlCreate ["RscStructuredText", -1];
		_ctrlColor ctrlSetBackgroundColor _color;
		_ctrlColor ctrlSetPosition [_xOffset + _w, _yOffset, 0.05, _h];
		_ctrlColor ctrlCommit 0;
	};
} forEach [
	[_this # 0, "RED", {alive _x } count (_teamsUnits # 0), [0.85, 0, 0, 1]]
	,[_this # 1, "BLUE", {alive _x } count (_teamsUnits # 1), [0.1, 0.1, 0.95, 1]]
	,[_this # 2, "GREEN", {alive _x }  count (_teamsUnits # 2),  [0, 0.85, 0, 1]]
	,[_this # 3, "YELLOW", {alive _x } count (_teamsUnits # 3), [0.93, 0.86, 0.16, 1]]
];
