// File: fn_stopPrisonBreak.sqf
// Author: Jesse "tkcjesse"
// Triggered by addAction - Watch params!
params [
	["_target",objNull,[objNull]]
];

if !(playerSide isEqualTo west) exitWith {};
if !(life_prison_inProgress) then {hint "There is no prison break to stop!";};
if !(isNull objectParent player) exitWith {};
if ((player distance _target) > 12) exitWith {hint "You need to stay near the laptop to finish restoring the security system!";};
if (player getVariable ["restrained",false] || player getVariable ["downed",false]) exitWith {};

disableSerialization;
5 cutRsc ["life_progress","PLAIN"];
private _ui = uiNameSpace getVariable "life_progress";
private _success = false;
private _progress = _ui displayCtrl 38201;
private _pgText = _ui displayCtrl 38202;
_pgText ctrlSetText "Restoring Security System";
_progress progressSetPosition 0.01;
_cP = 0.01;

for "_i" from 0 to 1 step 0 do {
	sleep 0.3;
	_cP = _cP + 0.01;
	_progress progressSetPosition _cP;
	_pgText ctrlSetText format ["Restoring Security System... (%1%2)",round(_cP * 100),"%"];
	if (_cp >= 1) exitWith {_success = true};
	if (!alive player || player getVariable ["restrained",false] || player getVariable ["downed",false]) exitWith {};
	if ((player distance _target) > 12) exitWith {hint "You need to stay near the laptop to finish restoring the security system!";};
};

5 cutText ["","PLAIN"];
if !(_success) exitWith {};

hint "You have restored the security system to the Prison!";

if !(life_prison_inProgress) then {hint "There is no prison break to stop!";};
[2,player,getPlayerUID player] remoteExec ["life_fnc_handlePrisonBreak",2];