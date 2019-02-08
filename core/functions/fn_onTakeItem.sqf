//
//	File: fn_onTakeItem.sqf
//	Author: Dom
//	Description: Monitors what item someone picks up
//
params [
	["_unit",objNull,[objNull]],
	["_container",objNull,[objNull]],
	["_item","",[""]]
];

if (life_laser_inprogress) exitWith {deleteVehicle _container};

private _house = _container getVariable["house", objNull];
if (!isNull _house) exitWith {
	_containerId = _container getVariable["containerId", -1];
	if (_containerId > -1) then {
		if !(_container getVariable["lootModified", false]) then {
			_container setVariable["lootModified", true, true];
		};
	};
};

//remember to add new donor/crate unlocks here
switch _item do {
	//exploitChecks
	case "ItemRadio": {if (life_radio_chan > -1 && !("ItemRadio" in (assignedItems player))) then { [nil,nil,nil,-1] spawn life_fnc_useRadio; };};
	case "U_B_HeliPilotCoveralls": { if (!difficultyEnabledRTD) then { removeUniform player } };
	case "V_HarnessOGL_brn": { if (!(33 in life_talents)) then { removeVest player } };
	case "U_NikosAgedBody": { if (getPlayerUID player != (life_configuration select 0)) then { removeUniform player } };
	case "H_PilotHelmetHeli_O": { if !((vehicle player) isKindOf "Air") then { removeHeadgear player } };
	//crateUnlocks
	case "U_O_CombatUniform_ocamo": { if (!(8 in life_lootRewards) && playerSide != west) then { removeUniform player } };
	case "U_O_PilotCoveralls": { if (!(9 in life_lootRewards) && playerSide != west) then { removeUniform player } };
	case "H_HelmetB_light": { if (!(6 in life_lootRewards)) then { removeHeadgear player } };
	case "H_HelmetB_light_snakeskin": { if (!(7 in life_lootRewards)) then { removeHeadgear player } };
	case "H_HelmetB_light_black": { if (!(6 in life_lootRewards) && !(7 in life_lootRewards)) then { removeHeadgear player } };
	//donor1
	//donor2
	case "H_Beret_blk": { if (life_donator < 2) then { removeHeadgear player } };
	//donor3
	//donor4
	case "U_O_Wetsuit": { if (life_donator < 4) then { removeUniform player } };
	case "H_Beret_02": { if (life_donator < 4) then { removeHeadgear player } };
	//donor5
	case "U_O_Protagonist_VR": { if (life_donator < 5) then { removeUniform player } };
	case "H_EarProtectors_orange_F": { if (life_donator < 5) then { removeHeadgear player } };
	case "H_EarProtectors_red_F": { if (life_donator < 5) then { removeHeadgear player } };
	case "H_EarProtectors_white_F": { if (life_donator < 5) then { removeHeadgear player } };
	case "H_EarProtectors_yellow_F": { if (life_donator < 5) then { removeHeadgear player } };
	case "G_EyeProtectors_F": { if (life_donator < 5) then { removeGoggles player } };
	case "G_EyeProtectors_Earpiece_F": { if (life_donator < 5) then { removeGoggles player } };
	//donor6
	case "H_Hat_Safari_olive_F": { if (life_donator < 6) then { removeHeadgear player } };
	case "H_Hat_Safari_sand_F": { if (life_donator < 6) then { removeHeadgear player } };
	case "H_construction_earprot_yellow_F": { if (life_donator < 6) then { removeHeadgear player } };
	case "H_construction_earprot_orange_F": { if (life_donator < 6) then { removeHeadgear player } };
	case "H_construction_earprot_black_F": { if (life_donator < 6) then { removeHeadgear player } };
	//donor7
	case "H_Beret_Colonel": { if (life_donator < 7) then { removeHeadgear player } };
	case "G_Goggles_VR": { if (life_donator < 7) then { removeGoggles player } };
	case "U_B_Protagonist_VR": { if (life_donator < 7) then { removeUniform player } };
	case "U_O_Protagonist_VR": { if (life_donator < 7) then { removeUniform player } };
	case "U_I_Protagonist_VR": { if (life_donator < 7) then { removeUniform player } };
};
[4] call life_fnc_sessionUpdatePartial;//Sync gear