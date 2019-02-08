/*
	File: fn_ctrlCreate.sqf
	Author: Poseidon
	
	Description: Expands functionality of engine command ctrlCreate to reduce lines of code when creating a control.
*/
disableSerialization;
params[
	["_display",displayNull,[displayNull]],
	["_type","",[""]],
	["_idc",0,[0]],
	["_controlGroup",controlNull,[controlNull]],
	["_sizeAndPosition",[],[[]]],
	["_backgroundColor",[],[[]]],
	["_fade",false,[false]],
	["_text","",[""]]
];
private _newCtrl = controlNull;

if(isNull _display || _type == "" || _idc == 0 || _sizeAndPosition isEqualTo [] || _backgroundColor isEqualTo []) exitWith {systemChat format["Control creation failed\n%1 - %2 - %3 - %4", _display, _type, _idc, _controlGroup]; _newCtrl};

if(isNull _controlGroup) then {//If there was no controlgroup provided, create a control group.
	_newCtrl = _display ctrlCreate [_type, _idc];
}else{
	_newCtrl = _display ctrlCreate [_type, _idc, _controlGroup];//Control group provided, create the control inside the specified group.
};

_newCtrl ctrlSetPosition _sizeAndPosition;
_newCtrl ctrlSetBackgroundColor _backgroundColor;

if(_fade) then {
	_newCtrl ctrlSetFade 1;
	_newCtrl ctrlCommit 0;
};
_newCtrl ctrlSetFade 0;

switch(_type) do {//Custom actions for different types.
	case "RscButtonMenu":{
		_newCtrl ctrlSetText _text;

		if(_backgroundColor isEqualTo [0,0,0,0]) exitWith {
			_newCtrl ctrlSetFade 1;
		};

		if(_backgroundColor select 3 == 1) exitWith {
			_newCtrl ctrlSetFade 0;
		};

		_newCtrl ctrlSetFade 0.8;
	};

	case "RscStructuredText":{
		_newCtrl ctrlSetStructuredText parseText(_text);
	};

	case "RscObject":{
		_newCtrl ctrlSetText _text;
		_newCtrl ctrlSetModel _text;
	};

	default {
		if(_text != "") then {
			_newCtrl ctrlSetText _text;
		};
	};
};

if(_fade) then {
	_newCtrl ctrlCommit 0.4;
}else{
	_newCtrl ctrlCommit 0;
};

_newCtrl;//The created control is returned