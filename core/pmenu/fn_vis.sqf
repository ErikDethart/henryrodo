/*
	File: fn_vis.sqf
	Author: Alan

	Description:
	To hide an admin

*/
if(param[0,false]) exitWith {
	_unit = lbData[2902,lbCurSel (2902)];
	_unit = call compile format["%1", _unit];
	if(_unit == player) exitWith {};
	if(isNil "_unit") exitWith {};
	if(isNull _unit) exitWith {};
	[player,false,true,false] remoteExecCall ["life_fnc_revived",_unit];
};
_isVis = player getVariable["isInvisible",false];

if(!_isVis) then
{
[player, true, (call life_adminlevel)] remoteExecCall ["ASY_fnc_visible",2];
	player setVariable["isInvisible",true, true];
	hint "You are now invisible!";
} else
{
[player, false, (call life_adminlevel)] remoteExecCall ["ASY_fnc_visible",2];
	player setVariable["isInvisible", false, true];
	hint "You are now visible!";
};
