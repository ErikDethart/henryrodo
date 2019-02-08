//	File: fn_vehAmmo.sqf
//	Author: John "Paratus" VanderZwet & Gen. Henry Arnold
//	Description: Reload offroad 50cal and armored vehicle smoke.
if (playerSide == civilian && !(32 in life_talents)) exitWith {hint "You don't have the talent to work with such weaponry.";};
if !(typeOf (vehicle player) in ["B_G_Offroad_01_armed_F","O_LSV_02_armed_F","I_C_Offroad_02_LMG_F","O_MRAP_02_F","I_MRAP_03_F"]) exitWith {hint "The ammunition does not fit this vehicles weapons."};
if (!([false,"vammo",1] call life_fnc_handleInv)) exitWith {};

life_action_in_use = true;

_upp = "Reloading vehicle weapon...";
//Setup our progress bar.
disableSerialization;
5 cutRsc ["life_progress","PLAIN"];
_ui = uiNameSpace getVariable "life_progress";
_progress = _ui displayCtrl 38201;
_pgText = _ui displayCtrl 38202;
_pgText ctrlSetText format["%2 (1%1)...","%",_upp];
_progress progressSetPosition 0.01;
_cP = 0.01;
_success=false;

while{true} do
{
	sleep 0.09;
	_cP = _cP + 0.01;
	_progress progressSetPosition _cP;
	_pgText ctrlSetText format["%3 (%1%2)...",round(_cP * 100),"%",_upp];
	if(_cP >= 1) exitWith {_success=true;};
	if(player == (vehicle player)) exitWith {};
	if(!alive player) exitWith {};
	if(!life_action_in_use) exitWith {};
};
5 cutText ["","PLAIN"];
life_action_in_use = false;

if (_success) then
{
	if (typeOf (vehicle player) in ["O_MRAP_02_F","I_MRAP_03_F"]) then
	{
		_turret = if (typeOf (vehicle player) == "O_MRAP_02_F") then {[-1]} else {[0]};
		_emptySmoke = if (typeOf (vehicle player) == "O_MRAP_02_F") then
		{
			(magazinesAllTurrets (vehicle player) select 0) select 2;
		} else
		{
			(magazinesAllTurrets (vehicle player) select 1) select 2;
		}; //fix for 0 smoke arma bug

		if(_emptySmoke == 0) then
		{
			(vehicle player) setVehicleAmmoDef 1; //resets original smokes
			(vehicle player) addMagazineTurret ["SmokeLauncherMag", _turret];
		} else
		{
			for "_i" from 0 to 1 do
			{
				(vehicle player) addMagazineTurret ["SmokeLauncherMag", _turret];
			};
		};

		life_experience = life_experience + 20;
		hint "Vehicle smokes have been reloaded.";
	}
	else
	{
		(vehicle player) setVehicleAmmoDef 1;
		life_experience = life_experience + 20;
		hint "Vehicle weapons have been reloaded.";
	};
};
