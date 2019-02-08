//	File: fn_infamyMenuGetDetails.sqf
//	Author: Poseidon
//	Description: Gets the details for the selected infamy talent

private["_display","_text","_index","_talent","_label","_req","_learn","_talentInfo","_talents","_reqInfo"];
disableSerialization;
_display = findDisplay 643700;
_text = _display displayCtrl 643703;
_learn = _display displayCtrl 643710;
_index = lbData[643702,lbCurSel (643702)];
_index = call compile format["%1", _index];

if(isNil "_index") exitWith {_text ctrlSetText "Invalid talent data.";};

_req = [];
_reqText = "";
_talentInfo = life_infamyInfo;
_talents = life_infamyTalents;
_talent = (_talentInfo select (_talentInfo findIf {(_x select 0) == _index}));
_talentRequirements = (_talent select 3);

_label = format["<t font='puristaMedium' shadow='1' size='2'>%1</t><br/>Costs %2 infamy.<br/><br/>", _talent select 2, [_talent select 1] call life_fnc_numberText];

{
	if(((_x select 0) >= (_talentRequirements select 0)) && ((_x select 0) <= (_talentRequirements select 1))) then {
		if(!((_x select 0) in _talents)) then {//Talents we're missin
			_reqText = (_x select 2);

			if(count(_req) > 1) then {
				_reqText = "all skills in this subtree";
			};

			_req pushBack _x;
		};
	};
}foreach _talentInfo;

if ((_talent select 0) in _talents) then {
	_label = format["%1<t color='#00FF00'>You already have this talent.</t><br/><br/>", _label];
}else{
	if (count _req > 0) then {
		_label = format["%1<t color='#FF0000'>You must learn %2 before you can learn this.</t><br/><br/>", _label, _reqText];
	}else{
		_label = format["%1You have not yet learned this talent, but you do meet its requirements.<br/><br/>", _label];
	};
};

_label = format["%1%2", _label, _talent select 4];
_text ctrlSetStructuredText parseText _label;

_max = 15;
_free = _max - (count _talents);

_learn ctrlShow true;
if (!((_talent select 0) in _talents)) then {
	_learn ctrlSetText "Learn";
	_learn ctrlEnable ((((_free > 0) && (count(_req) == 0 || (_talentRequirements select 1) in _talents)) || (_talent select 1) in _talents));
} else {
	_learn ctrlSetText "Unlearn";
	_learn ctrlEnable (((_talentRequirements select 1) in _talents) || ((_talentRequirements select 1) == 0));
};
