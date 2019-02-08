/*
	File: fn_addInfamy.sqf
	Author: Poseidon

	Description: Add infamy value, typically remote executed from server.
*/
private["_infamy"];
private _infamy = param [0,0,[0]];
life_infamyLevel = life_infamyLevel + round(_infamy);
if (life_is_arrested) exitWith {};

systemChat format["You received %1 infamy for a recent action, you now have %2 infamy.", round(_infamy), life_infamyLevel];