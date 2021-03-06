//	File: fn_serviceChopper.sqf
//	Author: Bryan "Tonic" Boardwine
//	Description: Main functionality for the chopper service paid, to be replaced in later version.

disableSerialization;

if (life_action_in_use) exitWith {hint "You are already doing an action. Please wait for it to end."};
private _search = nearestObjects[getPos air_sp, ["Air"],8];
if(count _search isEqualTo 0) exitWith {hint "There isn't a chopper on the helipad!"};
if(life_money < 250) exitWith {hint "You need $250 to service your chopper"};
["cash","take",250] call life_fnc_updateMoney;
life_action_in_use = true;
5 cutRsc ["life_progress","PLAIN"];
_ui = uiNameSpace getVariable "life_progress";
_progress = _ui displayCtrl 38201;
_pgText = _ui displayCtrl 38202;
_pgText ctrlSetText format["Servicing Chopper (1%1)...","%"];
_progress progressSetPosition 0.01;
_cP = 0.01;

for "_i" from 0 to 1 step 0 do {
	uiSleep  0.2;
	_cP = _cP + 0.01;
	_progress progressSetPosition _cP;
	_pgText ctrlSetText format["Servicing Chopper (%1%2)...",round(_cP * 100),"%"];
	if(_cP >= 1) exitWith {};
};

if(!alive (_search select 0) || (_search select 0) distance air_sp > 10) exitWith {life_action_in_use = false; hint "The vehicle is no longer alive or on the helipad!"};
if (!local (_search select 0)) then {
    [(_search select 0),1] remoteExecCall ["life_fnc_setFuel",(_search select 0)];
} else {
    (_search select 0) setFuel 1;
};

(_search select 0) setDamage 0;

5 cutText ["","PLAIN"];
titleText ["Your chopper is now repaired and refuelled.","PLAIN"];
life_action_in_use = false;
