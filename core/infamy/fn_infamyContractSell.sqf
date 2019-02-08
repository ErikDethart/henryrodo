#include "..\..\macro.h"
if(scriptAvailable(2)) exitWith {};
//	File: fn_infamyContractSell.sqf
//	Author: Poseidon
//	Description: clientside function for selling last scalp in the array.

if(count(life_infamyScalps) == 0) exitWith {hint "You have no scalps to turn in."};
if(!license_civ_rebel) exitWith {hint "You must have a rebel license to turn in a contract.";};

private _selectedScalp = (life_infamyScalps select (count(life_infamyScalps) - 1));
life_infamyScalps deleteAt (count(life_infamyScalps) - 1);

//As of right now no check to see if the group mates also have the contract (_x getVariable["infamyContract","-156"] isEqualTo (_selectedScalp select 1))
private _friends = [units group player, {player distance _x < 100}] call BIS_fnc_conditionalSelect;
if (count _friends == 0) then {_friends pushBack player;};//error no one in group, not even self.

[_selectedScalp select 0, _selectedScalp select 1, _selectedScalp select 2, ([7] call life_fnc_infamyModifiers), _friends] remoteExecCall ["ASY_fnc_infamyTurnInContract",2];


