//	File: fn_infamyOpenMenu.sqf
//	Author: Poseidon
//	Description: Opens the infamy talent page in the phone.

disableSerialization;
waitUntil {!isNull (findDisplay 643700)};
private _display = findDisplay 643700;
private _list = _display displayCtrl 643702;
private _learn = _display displayCtrl 643710;
private _stats = _display displayCtrl 643712;
private _text = "";

//Purge List
lbClear _list;

// Disable buttons by default since none are pre-selected
_learn ctrlShow false;

// Populate general talent stats
private _max = 15;
if ((_max - (count life_infamyTalents)) > 0) then {
	_text = [life_infamyLevel] call life_fnc_numberText;
} else {
	_text = "Maxed Out";
};

_stats ctrlSetText format["Available Infamy: %1.", _text];

// And populate the talents
[_list, 0, 0] call life_fnc_infamyMenuAddRow;
