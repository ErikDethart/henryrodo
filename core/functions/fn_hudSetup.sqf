/*
	File: fn_hudSetup.sqf
	Author: Bryan "Tonic" Boardwine
	
	Description:
	Setups the hud for the player?
*/
private["_display","_alpha","_version","_p","_pg"];
disableSerialization;
_display = findDisplay 46;
_alpha = _display displayCtrl 1001;
_version = _display displayCtrl 1000;

2 cutRsc ["playerHUD","PLAIN"];
_version ctrlSetText life_versionInfo;
[] call life_fnc_hudUpdate;

[] spawn
{
	private["_dam","_wanted"];
	while {true} do
	{
		_dam = damage player;
		//if (!isNil "life_wanted") then { life_wanted = 0 };
		_wanted = life_wanted;
		waitUntil {uiSleep 1; (((damage player) != _dam) || (life_wanted != _wanted))};
		if ((player getVariable ["parole", -1000]) > time && life_wanted >= 3000 && !(player getVariable ["paroleViolated", false])) then
		{
			player setVariable ["paroleViolated", true, true];
			[player,"pv"] remoteExec ["life_fnc_addWanted", 2];
[Str(life_wanted),profileName,11] remoteExecCall ["life_fnc_clientMessage",west];
		};
		[] call life_fnc_hudUpdate;
	};
};
