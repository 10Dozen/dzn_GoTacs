/* ----------------------------------------------------------------------------
Function: dzn_GoTacs_fnc_uiCreateClickableLabel

Description:
	Create control for given dialog

Parameters:
	_display - UI dialog <DISPLAY>
	_label - Button label, will be parsed to structured text <STRING>
	_code - LMB click code, _this is parsed to params ["_control", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"]; <CODE>
	_xpos - x-position of the control <NUMBER>
	_ypos - y-position of the control <NUMBER>
	_w - width of the control <NUMBER>
	_h - height of the control <NUMBER>
	_bg - (optional) background settings. Default: [0,0,0,1] <ARRAY>

Returns:
	_control - created control <CONTROL>

Examples:
    (begin example)
		_ctrl = [_display, "Click me", { hint "Text" }, 0.5, 0.5, 0.1, 0.05, [0,0,0,1]] spawn dzn_GoTacs_fnc_uiCreateClickableLabel;
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

params ["_display", "_label", "_code", "_xpos", "_ypos", "_w", "_h", ["_bg", [0,0,0,1]]];

if (!isNil "_code") then {
	private _strCode = ((str(_code) splitString "") select [1, count str(_code) - 2]) joinString "";
	_code = compile format [
		'params ["_control", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"]; %1'
		, _strCode
	];
};

private _ctrl = _display ctrlCreate ["RscStructuredText", -1];
_ctrl ctrlSetStructuredText parseText _label;
_ctrl ctrlSetBackgroundColor _bg;
_ctrl ctrlSetPosition [_xpos, _ypos, _w, _h];

if (!isNil "_code") then {
	_ctrl ctrlAddEventHandler ["MouseButtonDown", _code];
};

_ctrl ctrlCommit 0;

(_ctrl)