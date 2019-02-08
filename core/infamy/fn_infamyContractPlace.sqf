#include "..\..\macro.h"
if(scriptAvailable(5)) exitWith {};//This cooldown will prevent people from adding multiple contracts on accident to the same target
//	File: fn_infamyContractPlace.sqf
//	Author: Poseidon
//	Description: Called when player selects a target and provides a value for the desired contract
params [
	["_bountyValueControlID", 0, [0]],
	["_targetPlayer", "", [""]]
];
disableSerialization;

private _display = life_infamyContractDialogInfo param [0,displayNull,[displayNull]];
_targetPlayer = (call compile _targetPlayer);
if(isNull _targetPlayer || isNull _display) exitWith {};
if(isNull (_display displayCtrl _bountyValueControlID)) exitWith {hint "Error could not retrieve value from input box.";};
private _bountyValue = (ctrlText _bountyValueControlID);
private _value = parseNumber(_bountyValue);

if (isNil "_value") exitWith {hint "Invalid data provided. Please try again.";};
//if ((getPlayerUID player) == (getPlayerUID _targetPlayer)) exitWith {hint "You cannot place a contract on yourself."}; disabled for personal testing.
if (typeName _value != "SCALAR") exitWith {hint "The contract price may only contain numbers.";};
if (_value < 25000) exitWith {hint "The minimum contract is $25,000. Please try gain.";};
if (!([_value] call life_fnc_debitCard)) exitWith {hint "You do not have enough money to create this contract.";};

private _browseContractsButton = (_display displayCtrl 910051);
_browseContractsButton ctrlEnable false;

hint format["Kill contract targeting %2 and worth $%1 has been created.", _bountyValue, ([name _targetPlayer, 0] call life_fnc_cleanName)];

if(!isNull ((findDisplay 900000) displayCtrl 900099)) then {
	ctrlDelete ((findDisplay 900000) displayCtrl 900099);//Close the popup box
};

[(getPlayerUID _targetPlayer), (name _targetPlayer), (_value), (getPlayerUID player), (name player), (_targetPlayer)] remoteExecCall ["ASY_fnc_infamyAddContract",2];

uiSleep 2;

if(!isNull (findDisplay 900000)) then {//make sure they didnt just close the menu real quick.
	_browseContractsButton ctrlEnable true;
};


