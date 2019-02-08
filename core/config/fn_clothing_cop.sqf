//	File: fn_clothing_cop.sqf
//	Author: Bryan "Tonic" Boardwine
//	Description: Master config file for Cop clothing store.

private["_filter","_ret"];
_filter = [_this,0,0,[0]] call BIS_fnc_param;
//Classname, Custom Display name (use nil for Cfg->DisplayName, price

//Shop Title Name
ctrlSetText[3103,format["%1 Police Department Shop", worldName]];

_ret = [];
switch (_filter) do
{
	//Uniforms
	case 0:
	{
		/* if((call life_coplevel) == 1) then
		{
			_ret set[count _ret,["U_Competitor","Cadet Uniform",10]];
		}; */
		if((call life_coplevel) >= 1) then
		{
			_ret pushBack ["U_Rangemaster","Police Uniform",12];
			//_ret pushBack ["U_B_GEN_Soldier_F",nil,12];
		};
		if((call life_coplevel) >= 4) then
		{
			_ret pushBack ["U_B_CombatUniform_mcam_worn","Police BDU",100];
		};
		if((call life_coplevel) >= 5) then
		{
			_ret pushBack ["U_B_CombatUniform_mcam_worn","SWAT Uniform",200,"images\c_combat_police_co.jpg"];
		};
		if ((call life_coplevel) >= 2 && (8 in life_lootRewards || 9 in life_lootRewards)) then
		{
			_ret pushBack ["U_O_PilotCoveralls","Pilot Coveralls (Police)",5000,"images\c_coveralls_police.jpg"];
		};
		if ((call life_coplevel) >= 1 && life_donator >= 7) then
		{
			_ret pushBack ["U_B_Protagonist_VR",nil,2000,"#(argb,8,8,3)color(1,1,1,0.05)"];
		};
	};

	//Hats
	case 1:
	{
		if((call life_coplevel) >= 1) then
		{
			_ret pushBack ["H_Cap_police",nil,5];
			_ret pushBack ["H_MilCap_gen_F",nil,5];
		};
		if(life_donator >= 2) then
        {
            _ret pushBack ["H_Beret_blk","Stylish Beret",50];
        };
        if(life_donator >= 4) then
        {
            _ret pushBack ["H_Beret_02","Executive Beret",50];
        };
        if(life_donator >= 7) then
        {
            _ret pushBack ["H_Beret_Colonel","Master Beret",50];
        };
		if ((call life_coplevel) >= 2 && (6 in life_lootRewards || 7 in life_lootRewards)) then
		{
			_ret pushBack ["H_HelmetB_light_black",nil,1300];
		};
	};

	//Glasses
	case 2:
	{
		if((call life_coplevel) >= 1) then
		{
			_ret =
			[
				["G_Shades_Black",nil,2],
				["G_Shades_Blue",nil,2],
				["G_Sport_Blackred",nil,2],
				["G_Sport_Checkered",nil,2],
				["G_Sport_Blackyellow",nil,2],
				["G_Sport_BlackWhite",nil,2],
				["G_Squares",nil,5],
				["G_Combat",nil,5],
				["G_Aviator",nil,15],
				["G_Tactical_Black","Tactical Shades",25],
				["G_Tactical_Clear","Tactical Glasses",25]
			];
		};
		if((call life_coplevel) >= 5) then
		{
			_ret pushBack ["G_Goggles_VR",nil,100];
		};
	};

	//Vest
	case 3:
	{

		if((call life_coplevel) >= 1) then
		{
			_ret pushBack ["V_Rangemaster_belt",nil,150];
			_ret pushBack ["V_BandollierB_khk",nil,200];
			_ret pushBack ["V_BandollierB_cbr",nil,200];
			_ret pushBack ["V_BandollierB_rgr",nil,200];
			_ret pushBack ["V_BandollierB_blk",nil,200];
			_ret pushBack ["V_BandollierB_oli",nil,200];
		};
		if(((call life_coplevel)) >= 1 && (79 in life_talents)) then
		{
			_ret pushBack ["V_TacVest_blk_POLICE",nil,500];
			_ret pushBack ["V_TacVest_gen_F",nil,500];
		};
	};

	//Backpacks
	case 4:
	{
		if(((call life_coplevel)) >= 4 && (71 in life_talents)) then
		{
			_ret pushBack ["B_UAV_01_backpack_F",nil,3000];
		};
	};
};
if (life_coprole in ["detective","all"]) then
{
	_additional = [_filter] call life_fnc_clothing_bruce;
	{ _ret pushBack _x } forEach _additional;
	_additional = [_filter] call life_fnc_clothing_reb;
	{ _ret pushBack _x } forEach _additional;
	_additional = [_filter] call life_fnc_clothing_kart;
	{ _ret pushBack _x } forEach _additional;
	_additional = [_filter] call life_fnc_clothing_dive;
	{ _ret pushBack _x } forEach _additional;
};
if ((call life_coplevel) == 0) then {_ret = "You are not a Police Officer";};
_ret;
