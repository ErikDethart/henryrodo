/*
	File: fn_inventoryOpened.sqf
	Author: John "Paratus" VanderZwet and Sgt. Chronic

	Description:
	Fired when a player opens a container.
*/
[] spawn {
    waitUntil {!isNull (findDisplay 602)};
    [true] spawn life_fnc_inventory;
};
if (((call life_adminlevel) > 1) && {life_adminxray isEqualTo 1}) exitWith { false };

params [
    ["_unit",objNull,[objNull]],
    ["_container",objNull,[objNull]]
];
if (isNull _container) exitWith {false};

if (_container isKindOf "Bag_Base" && cursorTarget getVariable ["playerSurrender",false]) exitWith { false };
if (_container isKindOf "Bag_Base" && !(cursorTarget getVariable ["playerSurrender",false]) && playerSide != west) exitWith { hint "No stealing allowed!"; true };
if (_container isKindOf "Man") exitWith { true };

_lk_var = false;
_nearSupplies = player nearSupplies 5;
_id = {if(_x getVariable["containerId", -1] > -1) exitWith {_x}; objNull} forEach _nearSupplies;
private _house = _id getVariable["house", objNull];
if (!isNull _id) then {
	if(_house in life_houses || [_house] call life_fnc_getBuildID == life_gang) exitWith {};
	_lk_var = ((_house getVariable["life_locked", 1]) > 0);
};

if (_lk_var) exitWith { hint "You cannot open a house crate while the house doors are locked."; true };
if ((locked _container) > 1 && playerSide != west) exitWith { hint "The container is locked and cannot be opened!"; true };
if ((playerSide == civilian) && !(life_gang == "0") && ([_house] call life_fnc_getBuildID == life_gang) && (life_gang_rank > 3)) exitWith { hint "You must be gang rank 3 or higher to open containers"; true };


_container enableSimulation true;

false