//	File: fn_adminMenu.sqf
//	Author: Bryan "Tonic" Boardwine
//	Description: Opens the admin menu, sorry nothing special in here. Take a look for yourself.

if(((call life_adminlevel)) < 2) exitWith {closeDialog 0;};
private["_display","_list","_side"];
disableSerialization;
waitUntil {!isNull (findDisplay 2900)};
_display = findDisplay 2900;
_list = _display displayCtrl 2902;
if((call life_adminlevel) < 2) exitWith {closeDialog 0;};
if((call life_coplevel) < 5 && (call life_adminlevel) < 2) then {
	ctrlShow[1000,false];
	ctrlShow[1001,false];
};
if((call life_adminlevel) < 3) then {
	ctrlShow[2000,false];
};

//Purge List
lbClear _list;

{
	_side = switch(side _x) do {case west: {"Cop"}; case civilian : {"Civ"}; case independent : {"Med"}; default {"Unknown"};};
	_list lbAdd format["%1 - %2", name _x,_side];
	_list lbSetdata [(lbSize _list)-1,str(_x)];
} foreach allPlayers;

lbSort _list;
if((call life_adminlevel) < 2) exitWith {closeDialog 0;};