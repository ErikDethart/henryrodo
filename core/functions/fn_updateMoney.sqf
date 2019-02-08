//	File: fn_updateMoney.sqf
//	Author: Skalicon / Paratus
//	Description:
//	Updates the players Inventory and ATM cash.

//	Parameter(s):
//	0: String - Where the money is edited: "atm", "cash"
//	1: String -  Operator: "add", "take", "set"
//	2: Number - Amount of money.

//	Returns:
//	Nothing

if (X_Server) exitWith {};

params [
	["_type", "", [""]],
	["_modifier", "", [""]],
	["_amount", 0, [0]]
];

_amount = round(_amount);

if ((life_moneyCache != (life_money / 2) + 5) || (life_atmmoneyCache != (life_atmmoney / 2) + 3)) exitWith {
	[] spawn {
		life_corruptData = true;
		[911, player, "Money MEMORY HACK! Ban!"] remoteExecCall ["ASY_fnc_logIt",2];
	};
};

[] call life_fnc_achievementScan;

if (_type == "atm") then {
	if (_modifier == "add") then {
		life_atmmoney = life_atmmoney + _amount;
		//[1, player, format["ATM: Added %1 and now has %2",_amount,life_atmmoney]] remoteExecCall ["ASY_fnc_logIt",2];
	};
	if (_modifier == "take") then {
		life_atmmoney = life_atmmoney - _amount;
		//[1, player, format["ATM: Removed %1 and has %2 remaining",_amount,life_atmmoney]] remoteExecCall ["ASY_fnc_logIt",2];
	};
	if (_modifier == "set") then {
		life_atmmoney = _amount;
		//[1, player, format["ATM: Set to the amount of %1",life_atmmoney]] remoteExecCall ["ASY_fnc_logIt",2];
	};

	life_atmmoneyCache = (life_atmmoney / 2) + 3;
	[1] call life_fnc_sessionUpdatePartial;//Sync atm
};

if (_type == "cash") then {
	if (_modifier == "add") then {
		life_money = life_money + _amount;
		//[1, player, format["Cash: Added %1 and now has %2",_amount,life_money]] remoteExecCall ["ASY_fnc_logIt",2];
	};
	if (_modifier == "take") then {
		life_money = life_money - _amount;
		//[1, player, format["Cash: Removed %1 and has %2 remaining",_amount,life_money]] remoteExecCall ["ASY_fnc_logIt",2];
	};
	if (_modifier == "set") then {
		life_money = _amount;
		//[1, player, format["Cash: Set to the amount of %1",life_money]] remoteExecCall ["ASY_fnc_logIt",2];
	};

	life_moneyCache = (life_money / 2) + 5;
	[0] call life_fnc_sessionUpdatePartial;//Sync cash
};