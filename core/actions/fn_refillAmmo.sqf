//	File: fn_refillAmmo.sqf
//	Description: Refill your existing magazines with bullets

private _magazines = [];
private _price = 0;
{
	_mag = _x select 0;
	_count = _x select 1;
	_loaded = _x select 2;
	_type = _x select 3;
	_capacity = getNumber(configFile >> "CfgMagazines" >> _mag >> "count");

	if (!_loaded) then {
		_magazines pushBack _mag;
	};

	if (_type in [-1,1,2,4] && _count < _capacity) then {
		_price = _price + 50;
	};
} forEach magazinesAmmoFull player;

if (_price == 0) exitWith {};

private _handle = [format["Do you wish to pay $%1 to refill your magazines?", [_price] call life_fnc_numberText]] spawn life_fnc_confirmMenu;
waitUntil {scriptDone _handle};

if(!life_confirm_response) exitWith {};

if (!([_price] call life_fnc_debitCard)) exitWith {};

player setAmmo [primaryWeapon player, 1000];
player setAmmo [handgunWeapon player, 1000];

{
	player removeMagazine _x;
} forEach magazines player;

{
	player addMagazine[_x, 1000];
} forEach _magazines