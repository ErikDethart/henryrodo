//	File: fn_addToGang.sqf
//	Author: John "Paratus" VanderZwet
//	Description: Sets player as a member of given gang

private ["_id","_rank","_name","_update","_group","_joined"];

params [
 ["_id","0",["0"]],
 ["_rank",4,[4]],
 ["_name","",[""]],
 ["_update",false,[false]]
];

_group = objNull;
_joined = false;
life_gang = _id;
life_gang_rank = _rank;
life_gang_name = _name;
player setVariable ["gang", life_gang, true];
player setVariable ["gangName", _name, true];

if (_update) then {
	[8] call life_fnc_sessionUpdatePartial;//Update gang status
	[life_gang,1] remoteExecCall ["asy_fnc_umc",2];
};

{
	if (((_x getVariable ["gangName","omgRanD0M"]) == _name) && !isNull(_x getVariable ["gangGroup",objNull])) exitWith
	{
		_group = _x getVariable "gangGroup";
		if (count (units _group) < life_groupCap) then
		{
			[player] joinSilent (_group);
		}
		else
		{
			_group = createGroup civilian;
			[player] joinSilent (_group);
		};
		player setVariable ["gangGroup", _group, true];
		life_gang_group = _group;
		_joined = true;
	};
} foreach allPlayers;

if (!_joined) then
{
	player setVariable ["gangGroup", (group player), true];
	life_gang_group = (group player);
};

if(group player getVariable["gangTag",""] != "") exitWith {};
[4,group player,life_gang] remoteExecCall ["life_fnc_setTag",2];