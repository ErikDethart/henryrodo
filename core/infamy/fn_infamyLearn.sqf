//	File: fn_infamyLearn.sqf
//	Author: Poseidon
//	Description: Player is trying to learn a new infamy talent, lets make sure they meet the requirments and possibly give it to them.

[] spawn{
private["_display","_index","_id","_max","_free","_str","_talentInfo","_talents","_cost"];
disableSerialization;
_display = findDisplay 643700;
_index = lbData[643702,lbCurSel (643702)];
_index = call compile format["%1", _index];
_learn = _display displayCtrl 643710;

_talentInfo = life_infamyInfo;
_talents = life_infamyTalents;

if(isNil "_index") exitWith {_text ctrlSetText "Invalid talent data.";};

private _talent = (_talentInfo select (_talentInfo findIf {(_x select 0) == _index}));
private _talentRequirements = (_talent select 3);
private _req = [];
private _reqText = "";
private _masterCondition = false;
private _requiredUnlearn = "";

{
	if(!(((_x select 3) select 0) isEqualTo ((_x select 3) select 1))) then {//Find skills that have a range of skill pre-reqs
		if(((_talent select 0) >= ((_x select 3) select 0)) && ((_talent select 0) <= ((_x select 3) select 1))) then {
			if((_x select 0) in _talents) then {
				_masterCondition = true;
				_requiredUnlearn = (_x select 2);
			};
		};
	};

	if(((_x select 0) >= (_talentRequirements select 0)) && ((_x select 0) <= (_talentRequirements select 1))) then {
		if(!((_x select 0) in _talents)) then {//Talents we're missin
			_reqText = (_x select 2);
			_req pushBack _x;
		};
	};
}foreach _talentInfo;

if(_masterCondition) exitWith {
	hint format["%1 is learned, can't unlearn any untill that one is unlearned.",_requiredUnlearn];
};

_id = _talent select 0;
_cost = _talent select 1;
_parent = (_talent select 3) select 0;

if(_id in _talents) then {
	_gotChild = [];
	{
		if ((_id == ((_x select 3) select 0)) && (_x select 0) in _talents) exitWith { _gotChild = _x; };
	} forEach _talentInfo;

	if(count _gotChild > 0) exitWith { hint format["You can't unlearn this talent as it has a child talent, %1, which will need to be unlearned first.", _gotChild select 2] };



	_handle = [format["<t align='center'>If you proceed you will unlearn the talent %1 for a cost of $%2!</t>", _talent select 2, [life_respec_fee] call life_fnc_numberText]] spawn life_fnc_confirmMenu;
	waitUntil {scriptDone _handle};
	if(!life_confirm_response) exitWith {};

	if (life_atmmoney < life_respec_fee) exitWith { hint "You don't have enough money in your bank to unlearn this talent." };
	["atm","take",life_respec_fee] call life_fnc_updateMoney;

	life_infamyTalents = life_infamyTalents - [_id];
	life_infamyLevel = life_infamyLevel + _cost;

	hint format["You have unlearned the talent, %1.", _talent select 2];
} else {
	_max = 15;
	_free = _max - (count _talents);

	if (life_infamyLevel < _cost) exitWith {hint "You don't have enough infamy for this!"; closeDialog 0; };
	if (_free < 1) exitWith { hint "You don't have an available talent point to spend!"; closeDialog 0; };
	if (count(_req) != 0) exitWith { hint "This talent requires another talent that you don't have!"; closeDialog 0; };

	life_infamyTalents pushBack (_talent select 0);
	life_infamyLevel = life_infamyLevel - _cost;

	_str = format["You have learned the talent, %1.", _talent select 2];
	hint _str;
	systemChat _str;
};

[] spawn life_fnc_infamyOpenMenu;
};

