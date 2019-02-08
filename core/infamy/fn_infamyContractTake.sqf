#include "..\..\macro.h"
if(scriptAvailable(1)) exitWith {};
/*
	File: fn_infamyContractTake.sqf
	Author: Poseidon

	Description: Called when a player clicks on a contract in the browse page. Sets up variables and starts the tracking script.
*/
params [["_contractID", 0, [0]],["_targetID", "", [""]],["_targetName", "", [""]],["_targetBounty", 0, [0]]];
if(_targetID == "" || _targetBounty == 0 || _targetName == "") exitWith {hint "That contract cannot be accepted due to an error."};
if(_targetID == getPlayerUID player) exitWith {hint "You cannot accept a contract against yourself!";};
if(!license_civ_rebel) exitWith {hint "Only rebels may accept contracts!"};

_targetObject = objNull;

{
	if(getPlayerUID _x == _targetID && alive _x) exitWith {_targetObject = _x;};
}foreach allPlayers;

if(isNull _targetObject) exitWith {hint "The target of that contract could not be located."};

[[0,1], "You receive word that someone has accepted a contract on your life. Be careful, trust no one."] remoteExecCall ["life_fnc_broadcast",_targetObject];

life_infamyContractID = _contractID;
life_infamyContractTargetID = _targetID;
life_infamyContractTargetName = _targetName;
life_infamyContractTargetBounty = _targetBounty;
player setVariable ["infamyContract", _targetID, true];

[900000, 'bottom', false] spawn life_fnc_animateDialog;//Close the contracts menu

hint format["Let the hunt begin, you accepted a contract against %1!", life_infamyContractTargetName];

[life_infamyContractID] spawn life_fnc_infamyTrackTarget;
