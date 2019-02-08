/*
	File: fn_vehicleAnimate.sqf
	Author: Bryan "Tonic" Boardwine

	Description:
	Pass what you want to be animated.
*/

private["_vehicle","_animate","_state"];
_vehicle = [_this,0,Objnull,[Objnull]] call BIS_fnc_param;
if(isnull _vehicle) exitwith {}; //FUCK
_animate = [_this,1,"",["",[]]] call BIS_fnc_param;
_preset = [_this,2,false,[false]] call BIS_fnc_param;

if(!_preset) then
{
	if(count _animate > 1) then
	{
		{
			_vehicle animate[_x select 0,_x select 1];
		} foreach _animate;
	}
		else
	{
		_vehicle animate[_animate select 0,_animate select 1];
	};
}
	else
{
	switch (_animate) do
	{
		case "civ_dlcVan":
		{
			[_vehicle, false, ["Enable_Cargo", 1], false] call BIS_fnc_initVehicle;
		};
		case "civ_qilin":
		{
			_vehicle animate ["unarmed_doors_hide", 1];
		};
		case "civ_prowler":
		{
			_vehicle animate ["hidedoor1", 1];
			_vehicle animate ["hidedoor2", 1];
			_vehicle animate ["hidedoor3", 1];
			_vehicle animate ["hidedoor4", 1];
		};
		case "cop_prowler":
		{
			_vehicle animate ["hidedoor1", 1];
			_vehicle animate ["hidedoor2", 1];
			_vehicle animate ["hidedoor3", 1];
			_vehicle animate ["hidedoor4", 1];
		};
		case "civ_littlebird":
		{
			_vehicle animate ["addDoors",1];
			_vehicle animate ["addBenches",0];
			_vehicle animate ["addTread",0];
			_vehicle animate ["AddCivilian_hide",1];
			_vehicle lockCargo [2,true];
			_vehicle lockCargo [3,true];
			_vehicle lockCargo [4,true];
			_vehicle lockCargo [5,true];
		};

		case "civ_offroad":
		{
			_vehicle animate ["HidePolice", 1];
			_vehicle animate ["HideBumper1", 0];
			_vehicle animate ["HideConstruction", 1];
			_vehicle animate ["HideServices", 1];
			_vehicle setVariable["lights",false,true];
		};

		case "cop_jeep";
		case "civ_jeep":
		{
			_vehicle animate ["hideLeftDoor", selectRandom[0,1]];
			_vehicle animate ["hideRightDoor", selectRandom[0,1]];
			_vehicle animate ["hideRearDoor", selectRandom[0,1]];
			_vehicle animate ["hideBullbar", selectRandom[0,1]];
			_vehicle animate ["hideFenders", selectRandom[0,1]];
			_vehicle animate ["hideHeadSupportFront", selectRandom[0,1]];
			_vehicle animate ["hideHeadSupportRear", selectRandom[0,1]];
			_vehicle animate ["hideRollcage", selectRandom[0,1]];
			_vehicle animate ["hideSeatsRear", selectRandom[0,1]];
			_vehicle animate ["hideSpareWheel", selectRandom[0,1]];
		};

		case "med_littlebird":
		{
			_vehicle animate ["addDoors",1];
			_vehicle animate ["addBenches",0];
			_vehicle animate ["addTread",1];
			_vehicle animate ["AddBackseats", 0];
			_vehicle animate ["AddCivilian_hide",1];
			_vehicle lockCargo [0,true];
			_vehicle lockCargo [1,true];
			_vehicle lockCargo [2,true];
			_vehicle lockCargo [3,true];
			_vehicle lockCargo [4,true];
			_vehicle lockCargo [5,true];
			_vehicle setVariable ["medicsOnly", true, true];
			_vehicle enableCoPilot false;
		};

		case "reb_littlebird":
		{
			_vehicle animate ["addDoors",0];
			_vehicle animate ["addBenches",1];
			_vehicle animate ["addTread",1];
			_vehicle animate ["AddCivilian_hide",0];
		};

		case "service_truck":
		{
			_vehicle animate ["HideServices", 0];
			_vehicle animate ["HideDoor3", 1];
		};

		case "cop_offroad":
		{
			_vehicle animate ["HidePolice", 0];
			_vehicle animate ["HideBumper1", 0];
			_vehicle animate ["HideConstruction", 0];
			_vehicle animate ["HideServices", 1];
			_vehicle setVariable["lights",false,true];
		};

		case "cop_suv":
		{
			_vehicle setVariable["lights",false,true];
		};

		case "cop_sport":
		{
			_vehicle setVariable["lights",false,true];
		};

		case "cop_hunter":
		{
			_vehicle setVariable["lights",false,true];
		};

		case "cop_buzzard":
		{
			// Nothing required, yet.
		};

		case "med_offroad":
		{
			_vehicle animate ["HideServices", 0];
			_vehicle animate ["HideBumper1", 0];
			_vehicle animate ["HideBumper2", 0];
			_vehicle setVariable["lights",false,true];
		};

		case "med_suv":
		{
			_vehicle setVariable["lights",false,true];
		};
	};
};
