//	File: fn_useRadio.sqf
//	Author: John "Paratus" VanderZwet
//	Description: Change active radio channel or toggle
_chan = [_this,3,-1,[-1]] call BIS_fnc_param;

life_radio_chan = _chan;

[player, _chan] remoteExecCall ["ASY_fnc_manageRadio",2];