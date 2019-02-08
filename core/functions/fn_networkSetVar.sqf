//	File: fn_networkSetVar.sqf
//	Author: Bryan "Tonic" Boardwine
//	Description: Since some retard guy named KBW fucked with netSetVar and I can't be asked to adjust it, here is the OG tonic version...

disableSerialization;

params [
	["_varName","",[""]],
	["_value",-9999,[sideUnknown,"",[],{},false,0,ObjNull,GrpNull,displayNull]],
	["_ns",missionNamespace,[missionNamespace,objNull]]
];

if (_varName isEqualTo "") exitWith {}; //Error checking
_ns setVariable [_varName, _value];