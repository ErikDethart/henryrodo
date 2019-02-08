//	File: fn_moveItem.sqf
//	Author: John "Paratus" VanderZwet
//	Description: Player has placed an item or taken an item from a container

params ["_unit", "_container", "_item"];

if (life_laser_inprogress) exitWith { deleteVehicle _container; };

if (typeOf _container == "GroundWeaponHolder") then { _container remoteExecCall ["ASY_fnc_setIdleTime",2]; };

if (playerSide == independent) exitWith {};

if (_item == "ItemRadio") exitWith
{
	if (life_radio_chan > -1 && !("ItemRadio" in (assignedItems player))) then { [nil,nil,nil,-1] spawn life_fnc_useRadio; };
};

private _house = _container getVariable["house", objNull];
if (!isNull _house) then
{
	private _containerId = _container getVariable["containerId", -1];
	if (_containerId > -1) then {
	 if !(_container getVariable["lootModified", false]) then {
			_container setVariable["lootModified", true, true];
		};
	};
};

[4] call life_fnc_sessionUpdatePartial;//Sync gear