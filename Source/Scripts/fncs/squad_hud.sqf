
fnc_handleSquadHUDEH = {

	private _squad = (units player) - [player];
	
	{		
		private _posV = getPosVisual _x;
		_posV set [2, 1.75];
		
		private _textPos = [
			_posV select 0
			, _posV select 1
			, (_posV select 2) + 0.025*(player distance _x)
		];
		private _iconPos = [
			_posV select 0
			, _posV select 1
			, (_posV select 2) + 0.05*(player distance _x)
		];

		private _text = str(round(player distance _x)) + "m";

		private _color = [1,1,1,1];
		if !(_x getVariable ["dzn_GoTacs_isFiring", false]) then {		
			_color = switch (assignedTeam _x) do {
				case "RED": 	{ [0.85, 0, 0, 1] };
				case "BLUE": 	{ [0.1, 0.1, 0.95, 1] };
				case "GREEN": 	{ [0, 0.85, 0, 1] };
				default 		{ [1,1,1,1] };
			};
		};

		drawIcon3D [
			"\a3\ui_f\data\GUI\Rsc\RscDisplayInventory\InventoryStripe_ca.paa"
			, _color
			, _iconPos
			, 1, 1, 0
			, "", 1, 0.05, "TahomaB"
		];

		drawIcon3D [
			getText(configFile >> "CfgWeapons" >> primaryWeapon _x >> "picture")
			, [1,1,1,1]
			, _iconPos
			, 2, 1, 0
			, "", 1, 0.05, "TahomaB"
		];

		drawIcon3D ['', _color, _textPos, 0, 0, 0, _text , 2, 0.035, 'puristaMedium'];		
	} forEach _squad;	
};
