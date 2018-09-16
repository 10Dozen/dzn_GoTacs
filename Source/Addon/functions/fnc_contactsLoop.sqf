
/* ----------------------------------------------------------------------------
Function: dzn_GoTacs_fnc_contactsLoop

Description:
	Contacts loop to collect and update hostile contacs data known by player's squad. 
	Data contains:
		- Target unit <OBJECT>
		- Target type icon <STRING>
		- Known position of unit <ARRAY>
		- Label of known distance to unit <STRING>
		- Known distance to unit rounded <NUMBER>

Parameters:
	nothing

Returns:
	nothing

Examples:
    (begin example)
		[] spawn dzn_GoTacs_fnc_contactsLoop;
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

#include "..\macro.hpp"

while { GVAR(ContactsLoopEnabled) } do {
	waitUntil { sleep 1; alive player };
	waitUntil { sleep 1; time > GVAR(ContactsNextRequestTime) };

	GVAR(ContactsData) = [];
	GVAR(ContactsNextRequestTime) = time + GVAR(ContactsHUD_DataUpdateTimeout);

	private _tgts = call GVAR(fnc_findContacts);
	
	{
		_x params ["_accuracy", "_tgt", "_side", "_type", "_pos", "_age"];

		private _data = [];

		// --- Unit ---
		_data pushBack _tgt;

		// --- Type ---
		private _icon = "";
		private _simulation = toLower(getText (configFile >> "CfgVehicles" >> typeOf _tgt >> "simulation"));
		private _hasSpeed = (getNumber (configFile >> "CfgVehicles" >> typeOf _tgt >> "maxspeed")) > 0;
		/*
		switch (_simulation) do {
			case "soldier": 			{ 	_icon = "\a3\ui_f\data\GUI\Rsc\RscDisplayGarage\crew_ca.paa"; };
			case "car"; case "carx": 	{ 	_icon = "\a3\ui_f\data\GUI\Rsc\RscDisplayGarage\car_ca.paa"; };
			case "tank"; case "tankx":	{
				if (_hasSpeed) then {
											_icon = "\a3\ui_f\data\GUI\Rsc\RscDisplayGarage\tank_ca.paa"; 
				} else {
											_icon = "\a3\ui_f\data\GUI\Rsc\RscDisplayGarage\static_ca.paa"; 
				};
			};
			case "helicopter"; 
			case "helicopterx"; 
			case "helicopterrtd":		{ 	_icon = "\a3\ui_f\data\GUI\Rsc\RscDisplayGarage\helicopter_ca.paa"; };
			case "airplane"; 
			case "airplanex":			{ 	_icon = "\a3\ui_f\data\GUI\Rsc\RscDisplayGarage\plane_ca.paa"; };			
			case "ship"; case "shipx"; 
			case "submarinex": 			{	_icon = "\a3\ui_f\data\GUI\Rsc\RscDisplayGarage\naval_ca.paa"; };
		};
		*/

		_icon = "\dzn_GoTacs\ui\icon\icon_%1.paa";
		if (_accuracy > 0.25) then {		
			switch (_simulation) do {
				case "soldier": 			{ 	_icon = format [_icon, "inf"]; };
				case "car"; case "carx": 	{ 	_icon = format [_icon, "car"]; };
				case "tank"; case "tankx":	{
					if (_hasSpeed) then {
												_icon = format [_icon, "tank"]; 
					} else {
												_icon = format [_icon, "static_mg"]; 
					};
				};
				case "helicopter"; 
				case "helicopterx"; 
				case "helicopterrtd":		{ 	_icon = format [_icon, "heli"]; };
				case "airplane"; 
				case "airplanex":			{ 	_icon = format [_icon, "plane"]; };			
				case "ship"; case "shipx"; 
				case "submarinex": 			{	_icon = format [_icon, "unknown"]; };
			};

		} else {
			_icon = format [_icon, "unknown"];
		};

		_data pushBack _icon;

		// --- Position ---
		private _posV = getPosVisual _tgt;
		_posV set [2, (_posV # 2) max 1.75];

		_data pushBack _posV;

		// --- Distance ---
		private _dist = round(player distance _tgt);
		private _distName = switch (true) do {
			case (_dist > 500): { "very far" };
			case (_dist > 300): { "far" };
			case (_dist > 75): { "medium" };
			case (_dist > 25): { "close" };
			default { "danger" };
		};

		_data pushBack _distName;
		_data pushBack _dist;

		// --- Add target info to contacts list
 		GVAR(ContactsData) pushBack _data;
	} forEach _tgts;
};