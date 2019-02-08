/*
	File: fn_infamyReward.sqf
	Author: Poseidon
	
	Description: The server calls this file on all people who should get the reward for a specific contract that was just turned in.
*/
params[["_contractID", 0, [0]],["_targetID", "", [""]],["_targetName", "", [""]], ["_value", 0, [0]]];

titleText[format["You received $%1 for completing the kill contract against %2.",([_value] call life_fnc_numberText), _targetName],"PLAIN"];

[((_value/100) * 0.2)] call life_fnc_addInfamy;//We give 20% to all people who get a share, including the person who turned it in.
//However the guy who turned it in also got 0.2 already so he's at 40% total which is the desired outcome.

["atm","add",_value] call life_fnc_updateMoney;