/* ----------------------------------------------------------------------------
Function: dzn_GoTacs_fnc_getDistibutionMap

Description:
	Return array of items distributed between given consumers, e.g. 

Parameters:
	_consumers - <NUMBER> or <ARRAY> to distribute between 
	_items - <ARRAY> of data to be distributed

Returns:
	_map - list of items distributed to sub arrays for each consumer <ARRAY> of <ARRAY>'s:
		e.g. [ [@Item1, @Item2, @Item3], [@ItemN, @ItemN+1], [@ItemM, @ItenM+1] ]

Examples:
    (begin example)
		[_pairs, _hPoses] call dzn_GoTacs_fnc_getDistibutionMap;
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

#include "..\macro.hpp"

params ["_consumers", "_items"];

private _itemCount = count _items; 
private _consumerCount = if (typename _consumers == "SCALAR") then { _consumers } else { count _consumers };

private _times = floor (_itemCount/_consumerCount); // min. items per each consumer 
private _left = _itemCount - _times * _consumerCount; // items left undistributed

private _result = [];

// --- Divide items between each consumer
for "_i" from 1 to _consumerCount do {
	private _consumerItems = [];
	for "_j" from 1 to _times do {
		_consumerItems pushBack (_items select ((_i-1)*_times + _j - 1));
	};
	_result pushBack _consumerItems;
};

// --- Distribute left items, until any item left
while { _left > 0 } do {
	for "_i" from 0 to (_consumerCount - 1) do {
		if (_left == 0) exitWith {};
		_result set [_i, (_result select _i) + [ _items select ( _itemCount - _left ) ]];
		_left = _left - 1;
	};
};

_result