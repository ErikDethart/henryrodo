/*
	Master client initialization file
*/

private["_handle","_timeStamp"];
cutText["Setting up client, please wait...","BLACK FADED"];
0 cutFadeOut 9999999;
_timeStamp = diag_tickTime;
diag_log "------------------------------------------------------------------------------------------------------";
diag_log "---------------------------------- Starting Asylum Life Client Init ----------------------------------";
diag_log "------------------------------------------------------------------------------------------------------";

[] spawn life_fnc_abortEnabled; // Monitor for restrain and modify UI menus accordingly
waitUntil {!isNull player && player == player}; //Wait till the player is ready
enableSentences false; // disable the AI radio chatter
//Setup initial client core functions
diag_log "::Life Client:: Initialization Variables";
[] call compile PreprocessFileLineNumbers "core\configuration.sqf";
diag_log "::Life Client:: Variables initialized";
//[player] execVM "core\client\disable_respawn.sqf";
//Monitor player chat
[] call life_fnc_mapConfig;
[] spawn life_fnc_localMapSystem;
execVM "core\chatEvents\init.sqf";
diag_log "::Life Client:: Monitoring player chat input";
waitUntil {!isNil "aniChatEvents_initated"};
// Event Handlers
diag_log "::Life Client:: Setting up Eventhandlers";
[] call life_fnc_setupEVH;
diag_log "::Life Client:: Eventhandlers completed";
diag_log "::Life Client:: Emptying all world fuel pumps..";

_pumps = switch (worldName) do
{
	case "Altis": { nearestObjects [getMarkerPos "police_hq_3", ["Land_fs_feed_F","B_Slingload_01_Fuel_F"], 20000] };
	case "Stratis": { nearestObjects [getMarkerPos "corrections", ["Land_fuelstation_feed_F"], 15000] };
	case "Tanoa": { nearestObjects [getMarkerPos "corrections", ["Land_fs_feed_F","Land_fuelstation_feed_F","Land_FuelStation_01_pump_F","Land_FuelStation_02_pump_F"], 15000] };
	default { [] };
};
{
	_x setFuelCargo 0;
	_x addAction ["Refuel nearest vehicle", life_fnc_refuelVehicle, 1, 3, true, true, "", ' _this distance _target < 5 && cursorTarget == _target '];
	_x addAction["Repair Vehicle ($50)",life_fnc_pumpRepair,"",999,false,false,"",'vehicle player != player && (vehicle player) distance cursorObject < 6 '];
} forEach _pumps;

diag_log "::Life Client:: Waiting for server functions to transfer..";
waitUntil {(!isNil {life_fnc_clientGroupLeader})};
diag_log "::Life Client:: Received server functions.";
[] call life_fnc_sessionSetup;
waitUntil {life_session_completed};
cutText["Finishing client setup procedure","BLACK FADED"];
0 cutFadeOut 9999999;

if ((name player) in ["Unknown","Error: No Unit"]) then {["NotWhitelisted",false,false] call BIS_fnc_endMission;};

switch (playerSide) do
{
	case west:
	{
		_handle = [] spawn life_fnc_initCop;
		waitUntil {scriptDone _handle};
	};

	case civilian:
	{
		//Initialize Civilian Settings
		player enableSimulation false;//we disable simulation for civ so that when they get teleported to their spawn location they freeze in air which gives time for local objects to spawn in
		_handle = [] spawn life_fnc_initCiv;
		waitUntil {scriptDone _handle};
	};

	case independent:
	{
		//Initialize Medics and blah
		_handle = [] spawn life_fnc_initMedic;
		waitUntil {scriptDone _handle};
	};

	case sideLogic:
	{
		_handle = [] spawn life_fnc_initZeus;
		waitUntil {scriptDone _handle};
	};
};

diag_log "Past Settings Init";
[] execFSM "core\fsm\client.fsm";
diag_log "Executing client.fsm";
waitUntil {!(isNull (findDisplay 46))};
diag_log "Display 46 Found";
(findDisplay 46) displayAddEventHandler ["KeyUp", "_this call life_fnc_keyUpHandler"];
(findDisplay 46) displayAddEventHandler ["KeyDown", "_this call life_fnc_keyDownHandler"];
(findDisplay 46) displayAddEventHandler ["MouseButtonDown", "_this call life_fnc_mouseDownHandler"];
(findDisplay 46) displayAddEventHandler ["MouseButtonUp", "_this call life_fnc_mouseUpHandler"];
(findDisplay 46) displayAddEventHandler ["MouseZchanged", "_this spawn life_fnc_enableActions"];
player addRating 99999999;
diag_log "------------------------------------------------------------------------------------------------------";
diag_log format["                End of Asylum Life Client Init :: Total Execution Time %1 seconds ",(diag_tickTime) - _timeStamp];
diag_log "------------------------------------------------------------------------------------------------------";
life_sidechat = true;
if (playerSide == civilian) then {
	[player,life_sidechat,playerSide] remoteExecCall ["ASY_fnc_managesc",2];
};
life_ringer = (profileNamespace getVariable["AsylumSettings",[1200,1200,1600,true,false,0.2]]) select 3;
player enableSimulation true;
cutText ["","BLACK IN"];
[] call life_fnc_hudSetup;
//[player] execVM "core\client\intro.sqf";
LIFE_ID_PlayerTags = ["LIFE_PlayerTags","onEachFrame","life_fnc_playerTags"] call BIS_fnc_addStackedEventHandler;
[] call life_fnc_settingsInit;
//player setVariable["steam64ID",getPlayerUID player, true];

if (playerSide != sideLogic) then
{
	[] spawn life_fnc_survival;
	//[true] spawn life_fnc_sessionUpdate;
	// Force session DB save every 5 + random mins
	[] spawn  {
		for "_i" from 0 to 1 step 0 do {
			uiSleep (300 + (random 180));
			[] call life_fnc_sessionUpdate;
			{
				if(local _x && {(count units _x == 0)}) then {
					deleteGroup _x;
				};
			} forEach allGroups;
		};
	};

};

setPlayerRespawnTime life_respawn_timer; //Set our default respawn time.

[] spawn
{
	for "_i" from 0 to 1 step 0 do {
		waitUntil{!isNull(findDisplay 49)}; //Wait for ESC menu to be opened
		((findDisplay 49) displayCtrl 122) ctrlEnable false;
		((findDisplay 49) displayCtrl 122) ctrlShow false;
		waitUntil {isNull (findDisplay 49)}; //Wait for it to be closed
		showChat true; //Restore chat
	};
};

[] spawn {
    for "_i" from 0 to 1 step 0 do {
        private _rem = [];
        private _units = getPosATL player nearEntities [["Man","Car","Air","Ship"],20];
        _units = _units - [vehicle player];
        { if (_x isKindOf "Animal") then { _rem pushBack _x} } forEach _units;
        _units = _units - _rem;
        life_tag_cache = life_tag_units;
        life_tag_units = _units;
        uiSleep 1.3;
    };
};


[] spawn
{
	for "_i" from 0 to 1 step 0 do {
		uiSleep (4 * 60);
		/*{
			_tex = _x getVariable ["customTexture", ["",""]];
			_tex2 = _x getVariable ["customTextureBP", ["",""]];
			if (_tex select 0 == uniform _x) then
			{
				[_x, _tex] call life_fnc_setUniform;
			};
			if (_tex2 select 0 == backpack _x) then
			{
				[_x, _tex2, true] call life_fnc_setUniform;
			};
		} forEach allPlayers;*/
		if !([player getVariable ["isBountyHunter", false], license_civ_bounty] call BIS_fnc_areEqual) then
		{
			player setVariable ["isBountyHunter", license_civ_bounty, true];
		};
	};
};

[] spawn
{
	waitUntil {!isNil "life_bank_gates"};
	[] spawn
	{
		for "_i" from 0 to 1 step 0 do {
			if (player distance (getMarkerPos "fed_reserve") < 2000) then {uiSleep 0.5} else {uiSleep 30};
			{
				if ((_x animationPhase "Door_1_rot") > (_x getVariable ["gate_max",0])) then
				{
					if ((player distance _x) < 20) then
					{
						_x animate ["Door_1_rot", _x getVariable ["gate_max",0]];
					};
				};
				if (vehicle player distance2D _x < 7) then {
					if !(isNull objectParent player) then {
						if (_x getVariable ["gate_max",0] == 0) then {
							[vehicle player] spawn life_fnc_spikeStripEffect;
						};
					};
				};
			} forEach life_bank_gates;
		};
	};
};

[] spawn
{
	waitUntil {!isNil "life_turf_list"};
	[] spawn life_fnc_updateTurfMarkers;
};

// If player has any vehicles in the world, get the key
[] spawn
{
	{
		_v = _x;
		{
			if (_x select 0 == getPlayerUID player) then { life_vehicles pushBack _v; };
		} forEach (_v getVariable["vehicle_info_owners",[["",""]]]);
		{
			if (((_x select 0) == playerSide) && ((_x select 1) == getPlayerUID player)) then { life_tracked pushBack _v; };
		} forEach (_v getVariable["tracked",[]]);
	} forEach vehicles;
};

//Admin Reminder for logged in Admins
if (((call life_adminlevel) > 1) && !(getPlayerUID player in ["76561197963884021","76561197994201924","76561198003558926","76561198070312797","76561198000669855","76561198125098059"])) then {
	[] spawn {
		for "_i" from 0 to 1 step 0 do {
			waitUntil {uiSleep 7; (call BIS_fnc_Admin == 2)};
			hint "You are logged into Admin!";
			systemChat "You are logged into Admin!";
		}
	};
};

//Initialize crates
{
	[_x] spawn life_fnc_crateAction;
} forEach ((entities "Box_East_WpsSpecial_F") + (entities "Box_East_Support_F") + (entities "Land_WaterBarrel_F"));

//[] spawn SPY_fnc_payLoad;

[player] spawn life_fnc_intro;
[player] spawn life_fnc_messenger;
[life_banned] spawn life_fnc_showBanned;
[] spawn KBW_fnc_autoClaimMailbox;
[] execVM "IgiLoad\IgiLoadInit.sqf";

life_abort_enabled = true;
//enableEnvironment false;

player switchCamera "EXTERNAL";

player setVariable ["BIS_noCoreConversations", true];
0 fadeRadio 0;
enableRadio false;
enableSentences false;
[] call life_fnc_configChanged;
