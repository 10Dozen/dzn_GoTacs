
/* ----------------------------------------------------------------------------
Function: dzn_GoTacs_fnc_squadLoop

Description:
	Squad loop to collect and update squad data, for each unit:
		- Squad unit 
		- Units weapon picture
		- Damage state icon and color (["", [0,0,0,0]] if not wounded)
		- Ammo state icon anc color (["", [0,0,0,0]] if no need ammo)
		- Visual position of unit 
		- Team color of unit 

Parameters:
	nothing

Returns:
	nothing

Examples:
    (begin example)
		[] spawn dzn_GoTacs_fnc_squadLoop;
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

#include "..\macro.hpp"

while { GVAR(SquadLoopEnabled) } do {

	waitUntil { sleep 1; alive player };

	private _units = (units player) select { !isPlayer _x && alive _x };
	GVAR(SquadData) = [];

	{
		private _u = _x;

		private _data = [];
		/*
			@Unit 
			@WeaponImg
			@Wounded icon & color 
			@Need ammo icon & color
			@PosVisual 
			@TeamColor
		*/
		_data pushBack _u;
		_data pushBack (getText(configFile >> "CfgWeapons" >> primaryWeapon _x >> "picture"));

		//TODO: Wounded state logic
		// \a3\ui_f\data\IGUI\Cfg\simpleTasks\types\heal_ca.paa
		// \a3\ui_f\data\IGUI\Cfg\Actions\heal_ca.paa
		// \a3\ui_f\data\GUI\Rsc\RscDisplayArsenal\cargoMisc_ca.paa
		
		private _damageIconData = [];
		private _damageColor = [_u, "color"] call GVAR(fnc_getUnitDamageData);

		if (_damageColor isEqualTo [0,0,0,0]) then {
			// --- No damage
			_damageIconData = ["", [0,0,0,0]];
		} else {
			// --- Ligth+ damage
			_damageIconData = ["\a3\ui_f\data\IGUI\Cfg\Actions\heal_ca.paa", _damageColor];
		};

		_data pushBack _damageIconData;

		//TODO: Ammo state logic 
		// \a3\ui_f\data\IGUI\Cfg\Actions\gear_ca.paa
		// \a3\ui_f\data\GUI\Rsc\RscDisplayArsenal\cargoMagAll_ca.paa
		private _ammoIcon = ["", [0,0,0,0]];
		_data pushBack _ammoIcon;

		//TODO: In vehicle logic
		// \a3\ui_f\data\IGUI\Cfg\VehicleToggles\VehicleCargoIconOn2_ca.paa
		// \a3\ui_f\data\IGUI\Cfg\Actions\getincargo_ca.paa

		// --- Pos ---
		_data pushBack (getPosVisual _u);

		// --- Team ---
		private _teamColor = switch (assignedTeam _u) do {
			case "RED": 	{ [0.85, 0, 0, 1] };
			case "BLUE": 	{ [0.1, 0.1, 0.95, 1] };
			case "GREEN": 	{ [0, 0.85, 0, 1] };
			default 		{ [1,1,1,1] };
		};
		_data pushBack _teamColor;


		// --- Saving data ---
		GVAR(SquadData) pushBack _data;
	} forEach _units;

	sleep (GVAR(SquadHUD_DataUpdateTimeout) - 1);
}


			
