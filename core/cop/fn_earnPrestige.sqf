/*
	File: fn_earnPrestige.sqf
	Author: John "Paratus" VanderZwet

	Description:
	Player earned prestige.  Distribute!
*/

private ["_amount"];

_amount = [_this,0,0,[0]] call BIS_fnc_param;

if (playerSide != west) exitWith {};

[player, _amount] remoteExecCall ["life_fnc_addPrestige",west];

if (!life_precinct && (call life_coplevel) < 6) exitWith {};
life_prestige = life_prestige + (_amount * 0.4);

systemChat format["You've earned %1 prestige.", (_amount * 0.4)];
