//	File: fn_vehicleExit.sqf
//	Author: Skalicon
//	Description:

private["_vehicle","_position","_unit","_isTrans"];
_vehicle = _this select 0;
_position = _this select 1;
_unit = _this select 2;

//_vehicle setVariable["spawned",false,true];
[_vehicle] call life_fnc_setIdleTime;
_isTrans = _vehicle getVariable["isTransporting",nil];
if (_unit getVariable ["restrained",false] && !isNil "_isTrans") then{_vehicle setVariable["isTransporting",nil,true];};

if(_vehicle getVariable ["medicsOnly", false] && _position == "driver") then {
	_vehicle enableCoPilot false;
};
