/*
	File: fn_searchClient.sqf
	Author: Bryan "Tonic" Boardwine
	
	Description:
	Searches the player and he returns information back to the player.
*/
private["_cop","_licenses","_inv","_var","_val","_robber","_seizableMoney","_runner"];
_cop = [_this,0,Objnull,[objNull]] call BIS_fnc_param;
if(isNull _cop) exitWith {};
_licenses = "";
_inv = [];
_robber = false;
_runner = false;
_seizableMoney = 0;
//Licenses
if (license_civ_bounty) then { missionNamespace setVariable["license_civ_gun",true] };
{
	_val = missionNamespace getVariable [(_x select 0), false];
	if (!isNil "_val") then
	{
		if(_val && _x select 1 == "civ") then
		{
			_licenses = _licenses + ([_x select 0] call life_fnc_varToStr) + "<br/>";
		};
	};
} foreach life_licenses;

//Illegal items
{
	_var = [_x select 0,0] call life_fnc_varHandle;
	_val = missionNamespace getVariable _var;
	if (!isNil "_val") then
	{
		if(_val > 0) then
		{
			_inv set[count _inv,[_x select 0,_val]];
		};
	};
} foreach life_illegal_items;

if(_licenses == "") then {_licenses = "No licenses<br/>"};

if(!life_use_atm) then 
{
	if (life_money > 0) then {_seizableMoney = life_money};
	["cash","set",0] call life_fnc_updateMoney;
	_robber = true;
};
if (time - (player getVariable ["drugtrace",-1000]) < 400) then
{
	if (life_money > 0) then {_seizableMoney = life_money};
	["cash","set",0] call life_fnc_updateMoney;
[getPlayerUID player, "drugtrace", -1000] remoteExecCall ["ASY_fnc_varPersist",2];
	_runner = true;
	_robber = false;
};
if (time - (player getVariable ["banktrace",-1000]) < 400) then
{
	if (life_money > 0) then {_seizableMoney = life_money};
	["cash","set",0] call life_fnc_updateMoney;
[getPlayerUID player, "banktrace", -1000] remoteExecCall ["ASY_fnc_varPersist",2];
	_runner = false;
	_robber = true;
};


[player,_licenses,_inv,_robber,_runner,life_drug_level,life_alcohol_level,_seizableMoney] remoteExecCall ["life_fnc_copSearch",_cop];
