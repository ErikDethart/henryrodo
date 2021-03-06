//	File: fn_simpleShopMenu.sqf
//	Author: Bryan "Tonic" Boardwine
private ["_magName","_magConfig","_unit","_config"];

_unit = cursorTarget;
if (isNull _unit) then { _unit = _this select 0; };

if ((vehicle player) != player) exitWith { hint "This action cannot be performed from within a vehicle." };
if ((player distance _unit) > 10) exitWith { hint "You are too far away." };
if !(isNil "life_restartLock") exitWith {hint "You cannot access this menu right now. Try again after the restart!"};

private["_config","_itemInfo","_itemList"];
uiNamespace setVariable ["Weapon_Shop",_this select 3];

disableSerialization;
if(!(createDialog "life_simple_shop")) exitwith {};

_config = [_this select 3] call life_fnc_weaponShopCfg;
if(typeName _config == "STRING") exitWith {hint _config; closeDialog 0;};

ctrlSetText[38401,_config select 0];

_itemList = ((findDisplay 38400) displayCtrl 38403);
lbClear _itemList;

{
	_itemInfo = [_x select 0] call life_fnc_fetchCfgDetails;
	_itemList lbAdd format["%1",if(isNil {_x select 1}) then {_itemInfo select 1} else {_x select 1}];
	_itemList lbSetData[(lbSize _itemList)-1,_itemInfo select 0];
	_itemList lbSetPicture[(lbSize _itemList)-1,_itemInfo select 2];
	_price = _x select 2;
	if ((life_configuration select 3) > 0) then
	{
		_price = round (_price + (_price * ((life_configuration select 3) / 100)));
	};
	//_price = _price - (((life_donator * 4) / 100) * _price);
	_qty = (_itemInfo select 0) call life_fnc_getQuantity;
	if (playerSide in [west,independent]) then { _qty = -1; };
	_price = [_itemInfo select 0,_price,_qty] call life_fnc_calcPrice;
	if (_qty == 0) then { _price = _price * 1.25 };
	_point = capture_pole_1 getVariable["capture_data",["Drug Cartel","0",0.5]];
	_armsDealer = ((_point select 1) != "0" && (_point select 1) == life_gang && (_point select 2) == 1);
	_turfOwned = 0;
	{ if (_x select 1 == life_gang) then { _turfOwned = _turfOwned + 1; } } foreach life_turf_list;
	if (_armsDealer && _turfOwned > 1) then { _price = _price * 0.60 };
	if (!_armsDealer && _turfOwned > 1) then { _price = _price * 0.75 };
	_itemList lbSetValue[(lbSize _itemList)-1,_price];
} foreach (_config select 1);

((findDisplay 38400) displayCtrl 38405) ctrlSetText "Buy";
