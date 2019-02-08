//	File: fn_capture.sqf
//	Author: John "Paratus" VanderZwet
//	Description: Displays capturable points

private["_display","_list","_str","_qty","_price","_shrt","_captureData"];

disableSerialization;
waitUntil {!isNull findDisplay 2300};

[] call life_fnc_p_updateMenu;

_display = findDisplay 2300;
_list = _display displayCtrl 2305;
_details = _display displayCtrl 2310;

lbClear _list;
{
	_captureData = _x getVariable ["capture_data",["Error","0",0,-2100,true,"life_inv_dirty_money"]];
	_list lbAdd (_captureData select 0);
	_list lbSetdata [(lbSize _list),str _forEachIndex];
}foreach [capture_pole_1,capture_pole_2,capture_pole_3,capture_pole_4];