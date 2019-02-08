/*
	File: fn_dialogLoading.sqf
	Author: Poseidon
	
	Description: Displays an animated loading icon until the provided condition equals false
*/
private["_idc","_position","_controlGroup","_display","_control","_conditionVariable","_text","_loadingText"];
disableSerialization;

_idc = param [0,0,[0]];
_position = param [1,[],[[]]];
_controlGroup = param [2,controlNull,[controlNull]];
_conditionVariable = param [3,"",[""]];
_text = param [4,"",[""]];
_display = param [5,displayNull,[displayNull]];

if(isNull _display || isNull _controlGroup || _position isEqualTo [] || _idc == 0 || _conditionVariable == "") exitWith {hint format["Error: Failed to create loading icon/n%1 - %2 - %3 - %4", _display, _controlGroup, _position, _conditionVariable];};

_control = [_display, "RscPictureKeepAspect", _idc, _controlGroup, _position, [0, 0, 0, 0.5], true, "images\icons\load-1.paa"] call life_fnc_ctrlCreate;
_loadingText = [_display, "RscStructuredText", _idc, _controlGroup, [(_position select 0) - 0.15, ((_position select 1) - 0.05), (_position select 2)+0.3, 0.04], [0, 0, 0, 0], true, _text] call life_fnc_ctrlCreate;

[_control, _conditionVariable, _loadingText] spawn{
	private["_control", "_conditionVar", "_iconNumber"];
	disableSerialization;

	_control = param [0,controlNull,[controlNull]];
	_conditionVar = param [1,"",[""]];
	_loadingText = param [2,controlNull,[controlNull]];

	_iconNumber = 1;

	if(isNull _control) exitWith {hint format["Error 2: Failed to create loading icon/n%1 - %2", _control, _conditionVariable];};

	while{(call compile _conditionVar)} do {
		uiSleep 0.075;

		if(isNull _control) exitWith {};

		_control ctrlSetText format["images\icons\load-%1.paa",_iconNumber];
		_control ctrlCommit 0;

		_iconNumber = _iconNumber + 1;
		if(_iconNumber > 10) then {
			_iconNumber = 1;
		};
	};

	if(!isNull _control) then {
		_control ctrlSetFade 1;
		_control ctrlShow false;
		_control ctrlCommit 0;

		_loadingText ctrlSetFade 1;
		_loadingText ctrlShow false;
		_loadingText ctrlCommit 0;
	};
};

