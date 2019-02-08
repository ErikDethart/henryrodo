//	File: fn_searchAction.sqf
//	Author: Bryan "Tonic" Boardwine
//	Description: Starts the searching process.

private["_unit"];
_unit = cursorTarget;
if(isNull _unit) exitWith {};
hint "Searching...";
uiSleep 2;
if(player distance _unit > 5 || !alive player || !alive _unit) exitWith {hint "Cannot search that person."};

//[43, player, format["Searched %1", name _unit]] remoteExecCall ["ASY_fnc_logIt",2];

[player] remoteExecCall ["life_fnc_searchClient",_unit];
