//	File: fn_marijuana.sqf
//	Author: John "Paratus" VanderZwet
private ["_item"];

_item = _this select 0;

if (!([false,_item,1] call life_fnc_handleInv)) exitWith {};

life_drug_level = life_drug_level + 0.05;
if (life_drug_level > 1) then { life_drug_level = 1; };
systemChat "That's some good shit!";
[nil,nil,nil,player] call life_fnc_painkillers;
[] call life_fnc_hudUpdate;
[_item] call life_fnc_drugUsed;

if (!life_smoking) then
{
	life_smoking = true;
[player] remoteExec ["life_fnc_attachSmoke",-2];
	uiSleep 300;
	life_smoking = false;
};
