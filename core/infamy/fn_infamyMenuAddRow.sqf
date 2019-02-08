//	File: fn_infamyMenuAddRow.sqf
//	Author: Poseidon
//	Description: This is the function for adding a new row to the infamy talent page in the phone.

private["_label","_list","_parent","_depth","_id","_i","_d"];
_list = [_this,0,controlNull,[controlNull]] call BIS_fnc_param;
_parent = [_this,1,0,[0]] call BIS_fnc_param;
_depth = [_this,2,0,[0]] call BIS_fnc_param;

_talentInfo = life_infamyInfo;
_talents = life_infamyTalents;

for "_i" from 0 to ((count (_talentInfo)) - 1) do
{
	_x = _talentInfo select _i;
	_parentReq = (_x select 3) select 0;

	if (_parentReq == _parent) then
	{
		_id = (_x select 0);
		_label = (_x select 2);
		for [{_d=0}, {_d<_depth}, {_d=_d+1}] do { _label = "- " + _label; };
		_list lbAdd _label;
		_list lbSetdata [(lbSize _list)-1,str(_id)];
		if (!(_id in _talents)) then { _list lbSetColor [(lbSize _list)-1,[1,1,1,0.5]]; };
		if (!(_parentReq in _talents) && _parentReq > 0) then { _list lbSetColor [(lbSize _list)-1,[1,0,0,0.9]]; };
		[_list, _id, (_depth + 1)] call life_fnc_infamyMenuAddRow;
	};
};