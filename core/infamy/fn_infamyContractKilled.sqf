/*
	File: fn_infamyContractKilled.sqf
	Author: Poseidon
	
	Description: This function is called on the person who kills their contract target. The target that died will send the appropriate information to here.
	The target who you killed should provide you with this information:
		-Their playerID - You will check to make sure that you have the contract for this ID. This is an extra safety measure check to make sure this file is not called globally or on the wrong person.
		-Their death location - So you can spawn the skalp object at their death location
			-You will then set the appropriate data on skalp object such as the targetsUID, bountyAmount
*/
_this spawn {//we're gonna do a spawny doodly doo here so we can do stuff

if(!params [["_targetPlayerID", "", [""]],["_targetDeathPosition", [], [[]]]]) exitWith {};//Bad data

//this shouldn't happen, but just in case. Only the contract holder who killed the target should have this file called.
if(life_infamyContractTargetID != _targetPlayerID) exitWith {systemChat "Contract error: you were not the correct target for this function.";};

[life_infamyContractID, _targetPlayerID] remoteExecCall ["ASY_fnc_infamyCompleteContract",2];

private _skull = createVehicle ["Land_HumanSkull_F", _targetDeathPosition, [], 2, "CAN_COLLIDE"];
waitUntil{!isNull _skull};
_skull setVariable ["item", ["scalp",[life_infamyContractID, _targetPlayerID, life_infamyContractTargetName]], true];

};


