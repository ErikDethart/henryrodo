//	File: fn_index.sqf

params ["_find","_array"];
_array findIf {_find in _x};