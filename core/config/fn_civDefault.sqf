/*
	File: fn_civDefault.sqf
	Author: John "Paratus" VanderZwet
	
	Description:
	Default civ loadout.
*/
//Strip the player down
RemoveAllWeapons player;
{player removeMagazine _x;} foreach (magazines player);
removeUniform player;
removeVest player;
removeBackpack player;
removeGoggles player;
removeHeadGear player;
{
	player unassignItem _x;
	player removeItem _x;
} foreach (assignedItems player);

_uniforms = if (getPlayerUID player == (life_configuration select 0)) then { ["U_NikosAgedBody"] } else { ["U_C_Poloshirt_blue","U_C_Poloshirt_burgundy","U_C_Poloshirt_stripped","U_C_Poloshirt_tricolour","U_C_Poloshirt_salmon","U_C_Poloshirt_redwhite","U_C_Poor_1","U_I_G_Story_Protagonist_F","U_I_G_resistanceLeader_F","U_NikosBody","U_OrestesBody","U_C_HunterBody_grn","U_OG_Guerilla3_1","U_OG_Guerilla3_2","U_IG_Guerilla2_1","U_IG_Guerilla2_2","U_IG_Guerilla2_3","U_I_C_Soldier_Bandit_1_F","U_I_C_Soldier_Bandit_2_F","U_I_C_Soldier_Bandit_3_F","U_I_C_Soldier_Bandit_4_F","U_I_C_Soldier_Bandit_5_F","U_C_Man_casual_1_F","U_C_Man_casual_2_F","U_C_Man_casual_3_F","U_C_Man_casual_4_F","U_C_Man_casual_5_F","U_C_Man_casual_6_F"] };

player forceAddUniform (_uniforms call BIS_fnc_selectRandom);
player linkItem "ItemMap";
player linkItem "ItemWatch";
player linkItem "ItemCompass";

["cash","set",0] call life_fnc_updateMoney;
{ missionNamespace setVariable [_x, 0]; } forEach life_inv_items;
life_carryWeight = 0;

if (31 in life_achievements) then { [true,"debitcard",1] call life_fnc_handleInv; };
if (61 in life_talents) then { [true,"redburger",1] call life_fnc_handleInv; [true,"soda",2] call life_fnc_handleInv; };

//[] call life_fnc_saveGear;
//[] call life_fnc_equipGear;