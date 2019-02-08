/*
    File: fn_setIdleTime.sqf
    Author: Gnashes

    Description:
    Ensures object exists and then passes to server to update idle time
*/
private _vehicle = param[0,objNull,[objNull]];

if (isNull _vehicle) exitWith {};
_vehicle remoteExecCall ["ASY_fnc_setIdleTime",2];