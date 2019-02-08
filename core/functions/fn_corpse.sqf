//	File: fn_corpse.sqf
//	Author: Bryan "Tonic" Boardwine
//	Description:Hides dead bodies.
private["_corpse"];
_corpse = [_this,0,ObjNull,[ObjNull]] call BIS_fnc_param;
if(isNull _corpse) exitWith {};
if(alive _corpse) exitWith {}; //Stop script kiddies.

deleteVehicle _corpse;
//_corpse hideObject true;