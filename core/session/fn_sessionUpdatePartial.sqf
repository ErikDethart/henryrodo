//	File: fn_sessionUpdatePartial.sqf
//	Author: Poseidon
//	Description: Update small bits of player data as they change, instead of 1 big update.

private["_mode","_packet","_array","_flag","_inv","_select","_abort","_pos","_cache"];
_mode = param [0,0,[0]];
_abort = false;
_cache = "";

if (X_Server) exitWith {};
if (!life_session_completed) exitWith {};
if (life_activeSWAT)  exitWith {};//Don't sync if swat
if ((player distance (getMarkerPos "Respawn_west")) < 750) exitWith {};//Debug island, don't sync stuff
if ((player distance (getMarkerPos "courtroom")) < 50 && _mode == 6) exitWith {};//In the ocean, don't sync position.
if ((player distance (getMarkerPos "lasertag")) < 35 && _mode in [4, 6]) exitWith {};//Don't save gear or position
if ((player distance (getMarkerPos "life_bank_door")) < 55 && _mode == 6) exitWith {};//Don't save position
if (typeName life_clothing_store == "STRING" && _mode == 4) exitWith {};//Can't sync gear
if ((player distance (getMarkerPos "fed_reserve")) < 185 && _mode == 6) exitWith {}; //Don't save position
if ((player distance (getMarkerPos "capture_label_1")) < 200 && _mode == 6) exitWith {}; //Don't save position
if ((player distance (getMarkerPos "capture_label_2")) < 200 && _mode == 6) exitWith {}; //Don't save position
if ((player distance (getMarkerPos "capture_label_3")) < 200 && _mode == 6) exitWith {}; //Don't save position
if ((player distance (getMarkerPos "capture_label_4")) < 200 && _mode == 6) exitWith {}; //Don't save position


if (life_corruptData || (life_moneyCache != (life_money / 2) + 5) || (life_atmmoneyCache != (life_atmmoney / 2) + 3)) exitWith {
	[] spawn {
		life_corruptData = true;
		hint "YOUR CHARACTER DATA HAS BEEN CORRUPTED. Log out to the lobby and rejoin to fix this. None of your progress will be saved until this is done.";
		[911, player, "Money MEMORY HACK! Ban!"] remoteExecCall ["ASY_fnc_logIt",2];
	};
};

_packet = [getPlayerUID player, ([profileName,1] call life_fnc_cleanName), playerSide, _mode, nil];
_flag = switch(playerSide) do {case west: {"cop"}; case civilian: {"civ"}; case independent: {"med"};};

switch(_mode) do {
	case 0: {//Sync cash on hand
		_packet set[4,life_money];
	};

	case 1: {//Sync bank
		_packet set[4,life_atmmoney];
	};

	case 2: {//Sync both cash and bank
		_packet set[4,life_money];
		_packet set[5,life_atmmoney];
	};

	case 3: {//Sync licenses
		_array = [];
		{
			if(_x select 1 == _flag) then {
				_array set[count _array,[_x select 0,(missionNamespace getVariable (_x select 0))]];
			};
		}foreach life_licenses;

		if(life_licenses_cache isEqualTo format["%1",_array]) exitWith {_abort = true};//Licenses have not changed since the last sync, don't sync em again.
		life_licenses_cache = format["%1",_array];

		_packet set[4, _array];
	};

	case 4: {//Sync Gear
		_array = [];
		switch(_flag) do{
			case "civ":{
				if(life_is_arrested) exitWith {_abort = true};//dont sync gear in prison.

				[] call life_fnc_civFetchGear;
				_array = if(!alive player) then {[]} else {civ_gear};
			};

			case "cop":{
				[] call life_fnc_saveGear;
				[] call life_fnc_checkCopGear;
				_array = if(!alive player) then {[]} else {cop_gear};
			};
		};

		if(life_gear_cache isEqualTo format["%1",_array]) exitWith {_abort = true};//Gear has not changed since the last sync, don't sync it again.
		life_gear_cache = format["%1",_array];

		_packet set[4, _array];
	};

	case 5: {//Sync arrest status (jail time served, etc.)
		_packet set[4,life_jail_time];

		if(life_jail_time == life_jail_cache) exitWith {_abort = true;};
		life_jail_cache = life_jail_time;
	};

	case 6: {//Player position
		_pos = getPosATL player;
		if(vehicle player isKindOf "Air") then { _pos set [2, 1]; };
		if(!alive player) then {_pos = [0,0,0]}; //Exploit prevention, player won't actually spawn at 0,0,0
		if(str(_pos) find "e+" != -1) then { _pos = [3629.74,13088,0.00143528]; }; //Potential fix for SciNot Scripters (Kavala Square)

		_packet set[4, _pos];
	};

	case 7: {//Sync health status
		//
		_packet set[4, (alive player)];
		_packet set[5, (round ((damage player) * 100))];
		_packet set[6, (round (life_pain * 100))];
		_packet set[7, life_brokenLeg];

		if ((player getVariable["can_revive",-1000]) > time) then {
			_packet set[8, (player getVariable["can_revive",time]) - time];
		} else {
			_packet set[8, 0];
		};

		//Lets add this data to cache so we don't sync the same stuff multiple times.
		_cache = format["%1,%2,%3,%4,%5",(_packet select 4), (_packet select 5), (_packet select 6), (_packet select 7), (_packet select 8)];
		if(life_health_cache isEqualTo _cache) exitWith {_abort = true};//all health variables are the same as the last sync, don't sync again.
		life_health_cache = _cache;
	};

	case 8: {//Sync gang status/rank
		_packet set[4, life_gang];
		_packet set[5, life_gang_rank];

		_cache = format["%1,%2",(_packet select 4), (_packet select 5)];
		if(life_gang_cache isEqualTo _cache) exitWith {_abort = true};//all gang variables are the same as the last sync, don't sync again.
		life_gang_cache = _cache;
	};

	case 9: {//Sync players custom uniform texture
		//-civ
		_packet set[4, [player getVariable ["customTexture", ["",""]], player getVariable ["customTextureBP", ["",""]]]];

		_cache = format["%1",(_packet select 4)];
		if(life_texture_cache isEqualTo _cache) exitWith {_abort = true};//last synced uniform exture was the same, don't sync again.
		life_texture_cache = _cache;
	};

	case 10: {//Sync y inventory
		_inv = [];
		{
			_val = missionNameSpace getVariable _x;
			if(_val > 0 && _x != "life_inv_dirty_money") then
			{
				_inv set[count _inv, [_x,_val]];
			};
		} foreach life_inv_items;

		if(playerSide == west) then {
			_select = if(life_coprole == "detective") then {1} else {0};
			life_yItems set[_select,_inv];
		} else {
			life_yItems = _inv
		};

		_packet set[4, life_yItems];

		_cache = format["%1",life_yItems];
		if(life_virtualInventory_cache isEqualTo _cache) exitWith {_abort = true};//virtual inventory was the same last sync, don't sync again.
		life_virtualInventory_cache = _cache;
	};

	case 11: {
		_packet set[4, life_infamyLevel];
		_packet set[5, life_infamyTalents];

		_cache = format["%1,%2",(_packet select 4), (_packet select 5)];
		if(life_infamy_cache isEqualTo _cache) exitWith {_abort = true};//all infamy values are the same as previous
		life_infamy_cache = _cache;
	};
};

if(_abort) exitWith {};

_packet remoteExecCall ["DB_fnc_updatePartialServer",2];
//[player,getPlayerUID player] remoteExec ["ASY_fnc_checkPlayer",2];