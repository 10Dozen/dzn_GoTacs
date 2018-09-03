
/*

Inf to vehicles icons
F:\GMZ\SteamLibrary\steamapps\common\Arma 3\Addons\ui_f_data\a3\ui_f\data\GUI\Rsc\RscDisplayGarage

*/

fnc_handleContactsHUDEH = {

	if (time > GVAR(ContactNextRequestTime)) then {
		GVAR(ContactNextRequestTime) = time + GVAR(ContactLastRequestedTimeout);
		GVAR(ContactsList) = call fnc_findTargets;
	};

	if (GVAR(ContactsList) isEqualTo []) exitWith {};
	
	// [1,O Alpha 1-1:1,EAST,"O_Soldier_AAR_F",[3501.21,4018.35],-1]
	//	,[1,O Alpha 1-2:1,EAST,"O_Soldier_AAR_F",[3499.6,4019.95],-1]
	{
		_x params ["_accuracy", "_tgt", "_side", "_type", "_pos", "_age"];

		private _posV = getPosVisual _tgt;
		_posV set [2, 1.75];

		private _icon = "\a3\ui_f\data\IGUI\Cfg\TacticalPing\TacticalPingDefault_ca.paa";
		private _distOriginal = player distance _tgt;
		private _dist = round(_distOriginal / 10) * 10;

		CX = _dist;

		private _textPos = [
			_posV select 0
			, _posV select 1
			, (_posV select 2) + 0.025*_distOriginal
		];
		private _iconPos = [
			_posV select 0
			, _posV select 1
			, (_posV select 2) + 0.05*_distOriginal
		];
		private _text = str(round(_dist)) + "m";
		private _color = [1,0,0,1];
		
		drawIcon3D [
			_icon
			, _color
			, _iconPos
			, 2, 2, 0
			, "", 1, 0.05, "TahomaB"
		];

		drawIcon3D ['', _color, _textPos, 0, 0, 0, _text , 2, 0.035, 'puristaMedium'];
	} forEach GVAR(ContactsList);
};

