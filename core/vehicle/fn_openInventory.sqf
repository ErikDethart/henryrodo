//	File: fn_openInventory.sqf
//	Author: Bryan "Tonic" Boardwine
//	Description: Starts the initialization of vehicle virtual inventory menu.
private["_vehicle","_veh_data"];
if (life_action_in_use) exitWith {};
if(dialog) exitWith {};
if (vehicle player == player) then {_vehicle = cursorTarget} else {_vehicle = vehicle player};
if (isNull _vehicle) then { _vehicle = [_this,0,Objnull,[Objnull]] call BIS_fnc_param; };
if (isNull _vehicle) then { _vehicle = [_this,3,Objnull,[Objnull]] call BIS_fnc_param; };
if (isNull _vehicle) then { _vehicle = cursorObject; };
if ((vehicle player isKindOf "Car") || (vehicle player isKindOf "Air")) exitWith {hint "You cannot access the trunk of this vehicle from the inside!"};
if !(isNil "life_restartLock") exitWith {hint "You cannot access this menu right now. Try again after the restart!"};
if ((playerSide == civilian) && !(life_gang == "0") && ([_vehicle getVariable["house", objNull]] call life_fnc_getBuildID == life_gang) && (life_gang_rank > 3)) exitWith { hint "You must be Gang Rank 3 or higher \n to use the gang crate!"; };
if(isNull _vehicle OR !(_vehicle isKindOf "Car" OR _vehicle isKindOf "Air" OR _vehicle isKindOf "Ship" OR (typeOf _vehicle) in ["Land_TentA_F", "Land_TentDome_F", "Box_East_Support_F"] OR (_vehicle getVariable["containerId", -1] > -1))) exitWith {systemChat "Bad Vehicle";}; //Either a null or invalid vehicle type.

if (life_is_processing) exitWith { hint "You cannot use storage while processing."; };
if(_vehicle getVariable ["trunk_in_use",""] != "") exitWith {hint "This vehicle's trunk is in use, only one person can use it at a time."};
_vehicle setVariable["trunk_in_use",getPlayerUID player,true];
if(!createDialog "TrunkMenu") exitWith {systemChat "Failed Creating Dialog";}; //Couldn't create the menu?
disableSerialization;
ctrlSetText[3501,format["Container - %1",getText(configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "displayName")]];
_veh_data = [_vehicle] call life_fnc_vehicleWeight;
if(_veh_data select 0 == -1) exitWith {closeDialog 0};

ctrlSetText[3504,format["Weight: %1/%2",_veh_data select 1,_veh_data select 0]];
[_vehicle] call life_fnc_vehInventory;
life_trunk_vehicle = _vehicle;

[_vehicle] spawn
{
	waitUntil {isNull (findDisplay 3500)};
	[10] call life_fnc_sessionUpdatePartial;//sync Y inventory
	(_this select 0) setVariable["trunk_in_use","",true];
};