// File: srvCycAdjust.sqf

params [
	["_mode",-1,[0]],
	["_pObj",objNull,[objNull]]
];

if (_mode isEqualTo -1 || isNull _pObj) exitWith {};
if ((call life_adminlevel) < 2) exitWith {hint "Insufficient Permissions";};

private _action = [
	"You are about to adjust the server restart cycle. Make sure you adjust the restart type before the time so the proper messages are displayed!",
	"Server Restart Adjustment",
	"Confirm",
	"Cancel"
] call BIS_fnc_guiMessage;

if (_action) then {
	[_mode, _pObj, getPlayerUID player] remoteExec ["ASY_fnc_changeServCycle",2];
} else {
	hint "Server restart adjustment canceled.";
};