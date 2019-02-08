//
//	File: fn_createVehicle.sqf
//	Author: Skalicon
//
//	Description:
//	Spawns and sets up a vehicle
//
private["_veh","_vehicle","_plate","_color","_sp","_dir","_plate","_player"];
_veh = _this select 0;
_color = _this select 1;
_sp = _this select 2;
_dir = _this select 3;
_plate = _this select 4;
_player = _this select 5;
_alarm = [_this,6,false,[false]] call BIS_fnc_param;
_pid = getPlayerUID _player;
//Create vehicle
//_vehicle = _veh createVehicle _sp;
_vehicle = createVehicle [_veh, _sp, [], 0, "CAN_COLLIDE"];
_vehicle setVariable ["BIS_randomSeed1", 0, TRUE];
_vehicle allowDamage false;
[_vehicle] spawn {
	_vehicle = _this select 0;
	uiSleep 5;
	_vehicle allowDamage true;
};

if (_vehicle isKindOf "Ship") then { _vehicle setPosASL _sp; }
else { _vehicle setPosATL _sp; };
_vehicle setDir _dir;

//Set Vehicle color
[_vehicle,_color] call life_fnc_colorVehicle;

_side = switch (side _player) do
{
	case west: { "cop" };
	case independent: { "med" };
	default { "civ" };
};

//Set Vehicle data
[_vehicle] call life_fnc_clearVehicleAmmo;
_vehicle setVariable["vehicle_info_owners",[[_pid,name _player]],true];
//_vehicle setVariable["canChop",true,true];
//_vehicle setVariable["Speedbombed",false,true];
_vehicle setVariable["tracked",[],true];
//_vehicle setVariable["spawned",true,true];
//_vehicle remoteExecCall ["ASY_fnc_setIdleTime",2];
_vehicle setVariable["dbInfo",[_pid,_plate,_player,_alarm,_side],true];
_vehicle addEventHandler["Killed", {_this spawn ASY_fnc_vehicleDead;}];
_vehicle addEventHandler["GetOut", {_this call life_fnc_vehicleExit;}];
_vehicle addEventHandler["GetIn", {_this call life_fnc_vehicleEnter;}];
if (X_Server) then {
	[_vehicle,{_this addEventHandler["handleDamage",{_this call life_fnc_handleVehicleDamage}]; if(67 in life_talents) then {_this addItemCargoGlobal ["ToolKit",2]; _this addBackpackCargoGlobal ["B_AssaultPack_cbr",1]}}] remoteExecCall ["BIS_fnc_call",_player];
} else {
	_vehicle addEventHandler["handleDamage",{_this call life_fnc_handleVehicleDamage;}];
	if(67 in life_talents) then {_vehicle addItemCargoGlobal ["ToolKit",2]; _vehicle addBackpackCargoGlobal ["B_AssaultPack_cbr",1]};
};
_vehicle lock 2;
_vehicle enableRopeAttach false;
[_vehicle] call life_fnc_setIdleTime;

_animate = "";
//Set vehicle animation
if(side _player == civilian) then
{
	if(_veh == "C_Offroad_01_F") then { _animate = "civ_offroad"; };
	if(_veh == "C_Offroad_02_unarmed_F") then { _animate = "civ_jeep"; };
	if(_veh in ["B_Truck_01_fuel_F","C_Truck_02_fuel_F","C_Van_01_fuel_F"]) then { _vehicle setFuelCargo 0; };
	if(_veh == "O_T_LSV_02_unarmed_F") then { _animate = "civ_qilin"; };
	if(_veh == "B_T_LSV_01_unarmed_F") then { _animate = "civ_prowler"; };
	if(_veh == "C_Van_02_transport_F") then { _animate = "civ_dlcVan"; };
};
if(side _player == west) then
{
	if((_veh in ["C_Offroad_01_F","B_G_Offroad_01_armed_F"]) && (_color == 7)) then { _animate = "cop_offroad"; } else {_animate = "civ_offroad";};
	if(_veh == "C_SUV_01_F") then { _animate = "cop_suv"; };
	if(_veh == "B_MRAP_01_F") then { _animate = "cop_hunter"; };
	if(_veh == "I_Plane_Fighter_03_CAS_F") then { _animate = "cop_buzzard"; };
	if(_veh == "C_Hatchback_01_sport_F") then { _animate = "cop_sport"; };
	if((_veh == "C_Offroad_02_unarmed_F") && (_color != 8)) then { _animate = "cop_jeep"; };
	if(_veh == "B_T_LSV_01_unarmed_F") then { _animate = "cop_prowler"; };
	//life_tracked set [count life_tracked, _vehicle];
};
if(side _player == independent) then
{
	if(_veh == "C_Offroad_01_F") then { _animate = "med_offroad"; };
	if(_veh == "C_SUV_01_F") then { _animate = "med_suv"; };
};

if (!isNil "life_veh_shop") then
{
	if((life_veh_shop == "civ_air") && (typeOf _vehicle in ["B_Heli_Light_01_F","C_Heli_Light_01_civil_F"])) then{_animate = "civ_littlebird";};
	if((life_veh_shop == "med_air") && (typeOf _vehicle == "B_Heli_Light_01_F")) then{_animate = "med_littlebird";};
	if((life_veh_shop == "reb_air") && (typeOf _vehicle == "B_Heli_Light_01_F") && _color == 13) then{_animate = "reb_littlebird";};
};

if (_animate != "") then
{
[_vehicle,_animate,true] remoteExecCall ["life_fnc_vehicleAnimate",2];
	[_vehicle,_animate,true] spawn life_fnc_vehicleAnimate;
};

[_vehicle] remoteExecCall ["ASY_fnc_igiInit",2];
_vehicle disableTIEquipment true;

/*if (side _player == west && life_coprole == "detective") then
{
	_vehicle addWeaponCargoGlobal ["SMG_01_ACO_F",1];
	_vehicle addMagazineCargoGlobal ["30Rnd_45ACP_Mag_SMG_01", 4];
	_vehicle addMagazineCargoGlobal ["30Rnd_45ACP_Mag_SMG_01_tracer_green", 3];
};*/

[_vehicle] remoteExecCall ["life_fnc_addVehicle2Chain",_player];

if (_vehicle isKindOf "C_Van_02_transport_F") then {[_vehicle, false, ["Enable_Cargo", 1], false] call BIS_fnc_initVehicle;};

_vehicle;