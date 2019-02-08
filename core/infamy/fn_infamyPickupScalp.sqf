/*
	File: fn_infamyPickupSkalp.sqf
	Author: Poseidon
	
	Description: Handle picking up scalps off the ground.
*/
private["_obj","_itemInfo","_itemName","_illegal","_diff","_duped"];
if((time - life_action_delay) < 1) exitWith {hint "You can't rapidly use action keys!"};

if (isNull (findDisplay 1520)) then { 
	_obj = cursorObject; 
}else{
	_obj = objNull;
	if ((lbCurSel 1521) > -1) then
	{
		_obj = life_pickup_item_array select (lbCurSel 1521);
	};
};

if(isNil "_obj" OR isNull _obj OR isPlayer _obj) exitWith {};
_itemInfo = _obj getVariable "item";

if(playerSide == west) exitWith {
	hint "APD cannot pickup scalps.";
	life_action_delay = time;
};

life_action_delay = time;

life_infamyScalps pushBack (_itemInfo select 1);

player playmove "AinvPknlMstpSlayWrflDnon";
deleteVehicle _obj;
titleText[format["You picked up %1's scalp! Turn it in to reap your reward.",((_itemInfo select 1) select 2)],"PLAIN"];

[33, player, format["Scalp of %1 (%2) picked up. ContractID: %3", ((_itemInfo select 1) select 2), ((_itemInfo select 1) select 1), ((_itemInfo select 1) select 0)]] remoteExecCall ["ASY_fnc_logIt",2];
