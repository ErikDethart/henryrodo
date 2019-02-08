//	File: fn_searchVehAction.sqf

_vehicle = param [0,objNull,[objNull]];
if((_vehicle isKindOf "Car") || (_vehicle isKindOf "Air") || (_vehicle isKindOf "Ship")) then
{
	_owners = _vehicle getVariable "vehicle_info_owners";
	if(isNil {_owners}) exitWith {hint "This vehicle has no information, it was probably spawned in through cheats. \n\nDeleting vehicle."; deleteVehicle _vehicle;};

	hint "Searching Vehicle....";
	uiSleep 3;
	if(player distance _vehicle > 10 || !alive player || !alive _vehicle) exitWith {hint "Couldn't search the vehicle";};
	//_inventory = [(_vehicle getVariable "vehicle_info_inv")] call fnc_veh_inv;
	//if(isNil {_inventory}) then {_inventory = "Nothing in storage."};
	_owners = [_owners] call life_fnc_vehicleOwners;

	if(_owners == "any<br/>") then
	{
		_owners = "No owners, impound it<br/>";
	};
	hint parseText format["<t color='#FF0000'><t size='2'>Vehicle Info</t></t><br/><t color='#FFD700'><t size='1.5'>Owners</t></t><br/> %1",_owners];
	[_vehicle] call life_fnc_setIdleTime;
};
