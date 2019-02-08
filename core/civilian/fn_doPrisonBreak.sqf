#include "..\..\macro.h"
if(scriptAvailable(5)) exitWith {hint "Please don't spam Prison Breaks!";};
// File: fn_doPrisonBreak.sqf
// Author: Jesse "tkcjesse"
// Triggered by addAction - Watch params!
params [
	["_target",objNull,[objNull]]
];

if (life_action_in_use) exitWith {systemChat "You are already performing an action.";};
if !(playerSide isEqualTo civilian) exitWith {};
if !([4] call life_fnc_policeRequired) exitWith {};
if (serverTime - life_lastPrison < 1800) exitWith {hint "This prison is on lockdown.  Try again in a few minutes.";};
if ((currentWeapon player) in ["","Binocular","hgun_Pistol_Signal_F"]) exitWith {hint "The prison guards will not be very intimidated by an unarmed civilian!";};
if (life_prison_inProgress) exitWith {hint "There is already a prison break in progress!";};
if ((player distance _target) > 10) exitWith {hint "You need to stay near the laptop to complete the virus upload!";};
if !(isNull objectParent player) exitWith {};
if (player getVariable ["restrained",false] || player getVariable ["downed",false] || player getVariable ["arrested",false] || player getVariable ["prisoner",false]) exitWith {};

life_action_in_use = true;
disableSerialization;
5 cutRsc ["life_progress","PLAIN"];
private _ui = uiNameSpace getVariable "life_progress";
private _success = false;
private _progress = _ui displayCtrl 38201;
private _pgText = _ui displayCtrl 38202;
_pgText ctrlSetText "Uploading Virus";
_progress progressSetPosition 0.01;
_cP = 0.01;

for "_i" from 0 to 1 step 0 do {
	if (random(100) >= 50) then {
		uiSleep 0.35;
	} else {
		uiSleep 0.25;
	};
	_cP = _cP + 0.01;
	_progress progressSetPosition _cP;
	_pgText ctrlSetText format ["Uploading virus... (%1%2)",round(_cP * 100),"%"];
	if (_cp >= 1) exitWith {_success = true;};
	if (!alive player || player getVariable ["restrained",false] || player getVariable ["downed",false]) exitWith {};
	if ((player distance _target) > 10) exitWith {hint "You need to stay near the laptop to complete the virus upload!";};
	if !(isNull objectParent player) exitWith {};
	if (life_prison_inProgress) exitWith {hint "There is already a prison break in progress!";};
};

5 cutText ["","PLAIN"];
if !(_success) exitWith {life_action_in_use = false;};
if (life_prison_inProgress) exitWith {hint "There is already a prison break in progress!";life_action_in_use = false;};
if !([4] call life_fnc_policeRequired) exitWith {life_action_in_use = false;};

hint "The virus has been uploaded into the Prison security system and is infecting the network. The prisoners will have the ability to escape after 10 minutes. Keep the police away from the computer terminal!";

life_action_in_use = false;

if (life_prison_inProgress) exitWith {hint "There is already a prison break in progress!";};
[1,player,getPlayerUID player,group player] remoteExec ["life_fnc_handlePrisonBreak",2];
