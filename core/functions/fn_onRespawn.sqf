/*
	File: fn_onRespawn.sqf
	Author: Bryan "Tonic" Boardwine

	Description:
	Execute various actions when the _unit respawns.
*/
params [
	["_unit",objNull,[objNull]],
	["_corpse",objNull,[objNull]]
];
life_corpse = _corpse;

{
	if (player getVariable [_x, false]) then {
		player setVariable [_x, nil, true];
	};
} forEach ["customTexture","customTextureBP"];

if(life_is_arrested) then {
	hint "You tried to suicide from jail, you will be jailed again.";
	life_is_arrested = false;
	[] spawn life_fnc_jail;
} else {
	switch(playerSide) do {
		case west: {
			if (life_coprole in ["detective","all"] || (str player) in ["cop_detective_1","cop_detective_2","cop_detective_3"]) then {
				[] call life_fnc_detectiveGear
			} else {
				[] spawn life_fnc_loadGear;
				_unit setVariable["copLevel", (call life_coplevel), true]; // for showing rank, etc
				//if((call life_coplevel) > 2) then {_unit setVariable["swatlevel",1,true]};
			};
			if (life_swatlevel > 0) then { _unit setVariable["swatlevel", life_swatlevel, true]; };
			if ((call life_coplevel) < 1) then {["NotWhitelisted",false,false] call BIS_fnc_endMission;};
		};

		case civilian: {
			{
				if !(isNil {_unit getVariable[_x,nil]}) then {_unit setVariable[_x,nil,true];};
			} forEach ["restrained","Escorting","transporting"];
			if(time - (_unit getVariable ["last_revived",-1000]) < 300) then {
				_unit setVariable["last_revived",-1000,true];
			};
			if (headGear player != "") then {removeHeadgear player;};
			if (goggles player != "") then {removeGoggles player;};
			if (!(isNull life_corpse)) then { [life_corpse,true,life_in_vehicle] spawn life_fnc_dropItems; };

			{
				_x params["_code","_var","_val"];

				if (call _code) then {
					if !(_unit getVariable[_var,"setVarCheck"] isEqualTo _val) then {
						_unit setVariable[_var,_val,true];
					};
				};
			}forEach [[{life_gang != "0"},"gang",life_gang],[{life_gang_name != ""},"gangName",life_gang_name],[{!isNull(life_gang_group)},"gangGroup",life_gang_group]];

		};
	};
};

_unit addRating 9999999999999999;

if (life_radio_chan > -1) then { [nil,nil,nil,-1] spawn life_fnc_useRadio; };
[player,life_sidechat,playerSide] remoteExecCall ["ASY_fnc_managesc",2];
player setVariable ["BIS_noCoreConversations", true];

[] call life_fnc_hudUpdate;
[] spawn{uiSleep 3; cutText ["","BLACK IN"];};//Give a few seconds for objects to load in with the dynamic map system...

[] call life_fnc_fetchGear;
[] call life_fnc_equipGear;
[] spawn life_fnc_hudUpdate;
