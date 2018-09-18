
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
		private _classname = typeOf _tgt;
		private _simulation = toLower(getText (configFile >> "CfgVehicles" >> typeOf _tgt >> "simulation"));
		private _hasSpeed = (getNumber (configFile >> "CfgVehicles" >> typeOf _tgt >> "maxspeed")) > 0;
		private _generalMacro = getText (configFile >> "CfgVehicles" >> _classname >> "_generalMacro");
		
		_icon = "";
		if (_accuracy > 0.35) then {		
			switch (_simulation) do {
				case "soldier": 			{ 	_icon = "inf"; };
				case "car"; case "carx": 	{ 
					if (["wheeled", _generalMacro, false] call BIS_fnc_inString) then {
						_icon = "apc";
					} else {
						_icon = "car";
					};
				};
				case "tank"; case "tankx":	{
					if (_hasSpeed) then {
						if (
							["tracked", _generalMacro, false] call BIS_fnc_inString
							|| ["bmp", _generalMacro, false] call BIS_fnc_inString
						) then {
							_icon = "ifv";
						} else {
							if (
								["wheeled", _generalMacro, false] call BIS_fnc_inString
								|| ["m113", _generalMacro, false] call BIS_fnc_inString
							) then {
								_icon = "apc";
							} else {
								_icon = "tank";								
							};
						};		
					} else {
						private _mag = getText (configFile >> "CfgMagazines" >> (magazines _classname select 0) >> "ammo");
						private _caliber =  getNumber (configFile >> "CfgAmmo" >> _mag >> "caliber");

						if (_caliber > 2.5) then {
							_icon ="static_at";
						} else {
							_icon ="static_mg"; 
						};				
					};
				};
				case "helicopter"; 
				case "helicopterx"; 
				case "helicopterrtd":		{ 	_icon = "heli"; };
				case "airplane"; 
				case "airplanex":			{ 	_icon = "plane"; };			
				case "ship"; case "shipx"; 
				case "submarinex": 			{	_icon = "unknown"; };
			};
		} else {
			_icon = "unknown";
		};

		_data pushBack (format ["\dzn_GoTacs\ui\icons\icon_%1.paa", _icon]);

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