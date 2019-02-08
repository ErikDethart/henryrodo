
//	File: fn_chopShopClaim.sqf
//	Author: Gen. Henry Arnold
//
//	Description:
//	Initates changing the owner of a chopped vehicle

_control = ((findDisplay 39400) displayCtrl 39402); //chopshop screen
_vehicle = _control lbData (lbCurSel _control); //chopshop selection
_vehicle = call compile format["%1", _vehicle];

_nearVehicles = nearestObjects [getMarkerPos life_chopShop,["Car","Truck","Air","Ship"],25];
_vehicle = _nearVehicles select _vehicle;
private "_ind";
{
	if ((_x select 8) == civilian && (typeOf(_vehicle) == (_x select 1) || configName (inheritsFrom (configFile >> "CfgVehicles" >> typeOf(_vehicle))) == _x select 1)) then {
		_ind = _forEachIndex;
	};
} forEach life_vehicleInfo;
_price = ((life_vehicleInfo select _ind) select 2) * 0.5; //Claim at 50% config price
if ((15 in life_honortalents) || (26 in life_infamyTalents)) then { _price = ((life_vehicleInfo select _ind) select 2) * 0.35; };

//pull vars off vehicle to claim
if (count (_vehicle getVariable ["dbinfo",[]]) isEqualTo 0) exitWith {}; //prevents claiming fake vehicles

private _uid = _vehicle getVariable["dbInfo",[]] select 0;
private _plate = _vehicle getVariable["dbInfo",[]] select 1;
private _alarm = _vehicle getVariable["dbInfo",[]] select 3;
private _side = _vehicle getVariable["dbInfo",[]] select 4;

_confirmClaim = ["Are you sure you want to claim this vehicle?"] spawn life_fnc_confirmMenu;
waitUntil {scriptDone _confirmClaim};
if(!life_confirm_response) exitWith {};

//exit checks
if(life_atmmoney < _price) exitWith { hint "You cannot afford to do this!"; _vehicle setVariable ["gettingClaimed", false, true];};
if((_side == "cop") || (_side == "med")) exitWith {hint "You can only claim civilian vehicles!";};
if(_vehicle distance (getMarkerPos life_chopShop) > 100) exitWith { hint "You are too far away from the Chop Shop!"; _vehicle setVariable ["gettingClaimed", false, true];};
if(_uid isEqualTo (getPlayerUID player)) exitWith {hint "This car is already yours!";};
if(_vehicle getVariable ["gettingClaimed",false]) exitWith {hint "Someone is already claiming that vehicle!";};

hint "Swapping license plates, don't move.";

_vehicle setVariable ["gettingClaimed", true, true];
_delay = 0.6; // sec per 1 percent, 0.6 = 60 seconds

_displayName = getText(configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "displayName");
_upp = format["Swapping plates of %1",_displayName];
//Setup our progress bar.
disableSerialization;
5 cutRsc ["life_progress","PLAIN"];
_ui = uiNameSpace getVariable "life_progress";
_progress = _ui displayCtrl 38201;
_pgText = _ui displayCtrl 38202;
_pgText ctrlSetText format["%2 (1%1)...","%",_upp];
_progress progressSetPosition 1;
_cP = 1;
_success = false;
_started = getPosASL player;

life_action_in_use = true;

while{true} do {
	if(!isNull findDisplay 602) exitWith {};
	uiSleep _delay;
	_cP = _cP + 1;
	_progress progressSetPosition _cP;
	_pgText ctrlSetText format["%3 (%1%2)...",_cP,"%",_upp];
	if(_cP >= 100) exitWith {_success = true};
	//continuous failure condition check
	if(!alive player) exitWith {};
	if(!alive _vehicle) exitWith {};
	if(player != vehicle player) exitWith {};
	if(player distance2D _started > 2 || speed player > 2) exitWith {};
	if(player distance2D _vehicle > 22) exitWith {};
	if(player getVariable ["downed",false]) exitWith {};
	if(player getVariable ["playerSurrender",false]) exitWith {};
	if (!life_action_in_use) exitWith {};
};

5 cutText ["","PLAIN"];
life_action_in_use = false;

if (!_success) exitWith { hint "You failed to steal the vehicle."; _vehicle setVariable ["gettingClaimed", false, true];};

{
    if ((getPlayerUID _x) isEqualTo _uid) then {
        [_vehicle] remoteExec ["life_fnc_removeVehKey",_x];
    };
} forEach allPlayers;

[player,_uid,_plate] remoteExec ["ASY_fnc_vehicleOwnerSwap",2];
_vehicle setVariable ["vehicle_info_owners",[[getPlayerUID player,name player]],true];
_vehicle setVariable ["dbInfo",[getPlayerUID player,_plate,player,_alarm,_side],true];
[_vehicle] remoteExecCall ["life_fnc_addVehicle2Chain",player];

_vehicle setVariable ["gettingClaimed", false, true];
closeDialog 0;
life_action_in_use = false;
life_last_sold = time;

["atm","take",_price] call life_fnc_updateMoney;
_endText = format["You have claimed this %1 for $%2",_displayName,[_price] call life_fnc_numberText];
titleText[_endText,"PLAIN"];
