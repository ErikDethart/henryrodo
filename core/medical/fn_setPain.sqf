//	File: fn_setPain.sqf
//	Author: John "Paratus" VanderZwet

_pain = param[0,0,[0]];

//_oldPain = life_pain;
life_pain = _pain;

if (_pain > 0) then {

	if (life_cocaine_effect > 0) exitWith {};
	player setVariable["pain", _pain, true];
	systemChat "You are in pain!";
	_pain spawn {
		_pain = _this;
		while {true} do {
			if (_pain != life_pain) exitWith {};
			resetCamShake;
			addCamShake [1, 2, (_pain * 10)];
			uiSleep 3.5;
		};
	};
} else {
	if (player getVariable ["pain",-1] > 0) then {
		player setVariable["pain", nil, true];
	};
};