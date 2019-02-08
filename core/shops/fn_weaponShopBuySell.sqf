//	File: fn_weaponShopBuySell.sqf
//	Author: John "Paratus" VanderZwet
//	Description: Master handling of the weapon shop for buying / selling an item.
private["_isWeapon","_price","_item","_itemInfo","_bad","_exit","_qty","_point"];

_isWeapon = [_this,0,true,[true]] call BIS_fnc_param;

if((_isWeapon && (lbCurSel 39403) == -1) || (!_isWeapon && (lbCurSel 39404) == -1)) exitWith {hint "You need to select an item to buy."};
_price = if (_isWeapon) then { lbValue[39403,(lbCurSel 39403)] } else { lbValue[39404,(lbCurSel 39404)] };
if(isNil "_price") then {_price = 0;};
_item = if (_isWeapon) then { lbData[39403,(lbCurSel 39403)] } else { lbData[39404,(lbCurSel 39404)] };

_itemInfo = [_item] call life_fnc_fetchCfgDetails;

_bad = "";
_exit = false;

if((_itemInfo select 6) != "CfgVehicles") then
{
	if((_itemInfo select 4) in [4096,131072,0] || _itemInfo select 6 == "CfgMagazines") then
	{
		if(!(player canAdd _item)) exitWith {_bad = "You don't have enough room for that item."};
	};
};

if(_bad != "") exitWith {hint _bad};

_reqDonor = 0;
/*{
	if (_itemInfo select 0 == _x select 0) exitWith { _reqDonor = _x select 1 };
} forEach life_donor_items;*/

if (_reqDonor > life_donator) exitWith { hint format["You must be donor level %1 to purchase this item.", _reqDonor]; };

_apexWeps = ["arifle_AKS_F","arifle_CTAR_blk_F","LMG_03_F","launch_RPG7_F","SMG_05_F","arifle_SPAR_01_khk_F","arifle_SPAR_01_snd_F","arifle_AKM_F","arifle_AK12_F","arifle_SPAR_03_khk_F","arifle_SPAR_03_snd_F","hgun_Pistol_01_F","arifle_SPAR_01_blk_F","arifle_SPAR_03_blk_F"];
life_confirm_response = true;
if((_item in _apexWeps) && (395180 in getDLCs 2)) then {
	_handle = [format["<t align='center'>You need the Apex DLC in order to re-equip this weapon if you place it on the ground or into a vehicle/crate. Purchase anyway?</t>"]] spawn life_fnc_confirmMenu;
	waitUntil {scriptDone _handle};
};
if(!life_confirm_response) exitWith {};

if (_isWeapon && (primaryWeapon player != "") && (({toLower(_item) find _x > -1} count ["arifle_","srifle_","lmg_","smg_"]) > 0)) then {
    _handle = [format["<t align='center'>You already have a primary weapon equipped, buying another will replace it. Purchase anyway?</t>"]] spawn life_fnc_confirmMenu;
    waitUntil {scriptDone _handle};
};
if(!life_confirm_response) exitWith {};
life_confirm_response = nil;

//_price = _price - (((life_donator * 4) / 100) * _price);
//[95, player, format["Bought a %1 for %2", _itemInfo select 1, _price]] remoteExecCall ["ASY_fnc_logIt",2];

if ((uiNamespace getVariable ["Weapon_Shop", ""]) in ["rebel","turf"]) then
{
	/*_point = life_capture_list select 0;
	_armsDealer = ((_point select 1) != "0" && (_point select 1) == life_gang && (_point select 2) == 1);
	_turfOwned = 0;
	{ if (_x select 1 == life_gang) then { _turfOwned = _turfOwned + 1; } } foreach life_turf_list;
	if (_armsDealer && _turfOwned > 1) then { _price = _price * 0.60 }
	else
	{
		if (_armsDealer || _turfOwned > 1) then { _price = _price * 0.75 };
	};*/
	// ABOVE REMOVED; WAS DOUBLE REDUCTION?
	_price = round(_price * ([1] call life_fnc_infamyModifiers));//modifier for infamy talents
	if (life_money < _price) exitWith {_exit=true; hint format["You do not have enough cash on you to pay for this.  You need $%1.", _price]};
};
if (_exit) exitWith {};

_qty = _item call life_fnc_getQuantity;
if (playerSide in [west,independent]) then { _qty = -1; };
if(!([_price] call life_fnc_debitCard)) exitWith {};
if (_qty > -1) then
{
	life_approved = nil;
	life_stock_update = [_item, -1, player];
	publicVariableServer "life_stock_update";
};
_cut = 0;
_extra = ".";

_point = capture_pole_1 getVariable["capture_data",["Drug Cartel","0",0.5]];
if ((uiNamespace getVariable ["Weapon_Shop", ""]) == "rebel" && ((_point select 2) == 1 && ((_point select 1) != life_gang || life_gang == "0"))) then
{
	_cut = floor (_price * 0.08); // 8% added to arms dealer
	_var = capture_container_1 getVariable ["gangContainer", ["life_inv_dirty_money",0]];
	_newAmount = (_var select 1) + _cut;
	if (_newAmount > 100000) then { _newAmount = 100000; };
	_var set [1, _newAmount];
	capture_container_1 setVariable ["gangContainer", _var, true];
	_extra = format[", with $%1 going to the owner of the arms dealer.", [_cut] call life_fnc_numberText];
};

_hint = format["You bought a %1 for <t color='#8cff9b'>$%2</t>%3",_itemInfo select 1,[_price] call life_fnc_numberText, _extra];
[_item,true,false,true,false] call life_fnc_handleItem;
hint parseText _hint;
PlaySound "purchase";
if(playerSide == west) then
{
	[] call life_fnc_saveGear;
};
