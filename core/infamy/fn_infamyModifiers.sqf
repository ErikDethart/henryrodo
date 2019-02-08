/*
	File: fn_infamyModifiers.sqf
	Author: Pizza Man
	Contributor(s): Poseidon
	
	Description: Used for various variables in the infamy system
*/
params[["_mode", -1, [0]], ["_subMode", ""]];
private["_modifier", "_talentID", "_index", "_return"];
if (_mode isEqualTo -1) exitWith {1};
if(!license_civ_rebel) exitWith {1};//modifiers not active unless they are a rebel
 
_return = switch (_mode) do {
	case 1: {// Illegal Buying
		_talents = [13, 14, 15];
		_talents sort false;

		_index = _talents findIf {_x in life_infamyTalents};
		if(_index != -1) then {
			_talentID = (_talents select _index);
		}else{
			_talentID = -1;
		};

		_modifier = switch (_talentID) do {
			case 13: {0.95}; // Friend of yours
			case 14: {0.9}; // Friend of Mine
			case 15: {0.85}; // Friend of Ours
			default {1};
		};

		_modifier
	};

	case 2: {// Illegal Selling
		_talents = [16, 17, 18];
		_talents sort false;

		_index = _talents findIf {_x in life_infamyTalents};
		if(_index != -1) then {
			_talentID = (_talents select _index);
		}else{
			_talentID = -1;
		};

		_modifier = switch (_talentID) do {
			case 16: {1.07}; // Shakedown
			case 17: {1.15}; // Coercion
			case 18: {1.25}; // F*&@ You - Pay Me
			default {1};
		};

		_modifier
	};

	case 3: {// Gather Speed
		_modifier = switch (_subMode) do {
			case "heroin": {if (19 in life_infamyTalents) then [{0.90}, {1}]}; // Black Tar Pusher
			case "coke": {if (20 in life_infamyTalents) then [{0.90}, {1}]}; // Cokehead
			case "ephedra": {if (21 in life_infamyTalents) then [{0.90}, {1}]}; // Speed Freak
			default {1};
		};

		_modifier
	};

	case 4: {//Lock Picking
		_talents = [24, 25, 26];
		_talents sort false;

		_index = _talents findIf {_x in life_infamyTalents};
		if(_index != -1) then {
			_talentID = (_talents select _index);
		}else{
			_talentID = -1;
		};
		
		_modifier = switch (_talentID) do {
			case 24: {0.9};
			case 25: {0.8};
			case 26: {0.7};
			default {1};
		};

		_modifier
	};

	case 5: {//Gas station robbery profits
		_talents = [27, 28, 29];
		_talents sort false;

		_index = _talents findIf {_x in life_infamyTalents};
		if(_index != -1) then {
			_talentID = (_talents select _index);
		}else{
			_talentID = -1;
		};

		_modifier = switch (_talentID) do {
			case 27: {1.1};
			case 28: {1.3};
			case 29: {1.5};
			default {1};
		};

		_modifier
	};

	case 6: {//action speed
		_modifier = switch (_subMode) do {
			case "bloodbag": {if (30 in life_infamyTalents) then [{0.75}, {1}]};
			case "splint": {if (31 in life_infamyTalents) then [{0.75}, {1}]};
			case "defib": {if (32 in life_infamyTalents) then [{0.75}, {1}]};
			default {1};
		};

		_modifier
	};
	
	case 7: {//Amount of bounty to receive
		_talents = [8, 9, 10];
		_talents sort false;

		_index = _talents findIf {_x in life_infamyTalents};
		if(_index != -1) then {
			_talentID = (_talents select _index);
		}else{
			_talentID = -1;
		};

		_modifier = switch (_talentID) do {
			case 8: {0.4};
			case 9: {0.55};
			case 10: {0.7};
			default {0.3};
		};

		_modifier
	};

	default {1};
};
 
_return