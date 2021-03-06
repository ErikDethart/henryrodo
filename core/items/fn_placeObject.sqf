//	File: fn_placeObject.sqf
//	Author: John "Paratus" VanderZwet
//	Description: Places an object in the world.

private ["_item","_index","_object"];

_item = [_this,0,"",[""]] call BIS_fnc_param;
if (_item == "") exitWith {};

closeDialog 0;
closeDialog 0;

if (!isNull life_placing) exitWith {hint "You are already placing another object.";};
if(playerSide == west && ({player distance getMarkerPos format["police_hq_%1",_x] < 75} count [1,2,3,4] > 0)) exitWith {hint "You cannot place checkpoint materials inside of Police HQ's!"};
if(playerSide == west && ({player distance getMarkerPos format["police_hq_%1",_x] < 125} count [5] > 0)) exitWith {hint "You cannot place checkpoint materials inside of Police HQ's!"}; //Pyrgos Specific
if (playerSide != west && player distance capture_pole_1 > 300 && player distance capture_pole_2 > 300 && player distance capture_pole_3 > 300 && player distance capture_pole_4 > 300) exitWith {hint "You can only place this object within 300m of a capture area (cartel)."};

_index = [_item,life_placeable] call life_fnc_index;
if (_index < 0) exitWith {};

_object = ((life_placeable select _index) select 1) createVehicle [0,0,0];
_object attachTo[player,[0,((life_placeable select _index) select 4),0]];
_object setDir ((life_placeable select _index) select 3);
_object addEventHandler ["handleDamage", { _damage = 0.5; player setDamage (damage player + _damage); }];

life_placing = _object;