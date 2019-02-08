//	File: fn_handleVehicleDamage.sqf
//	Author: John "Paratus" VanderZwet
//	Description: Handles special damage events

private ["_unit","_damage","_source","_projectile","_hitBox"];

_unit = _this select 0;
_projectile = "";
if ((_this select 4) isEqualTo "<NULL-object>") then {
	_hitBox = _this select 2;
	_damage = _this select 3;
	_source = _this select 4;
} else {
	_hitBox = _this select 1;
	_damage = _this select 2;
	_source = _this select 3;
	_projectile = _this select 4;
};

if (_projectile != "") then {
	if !(isNull _unit) then {
		if(local _unit) then {[_source] call life_fnc_setAggressive} else {[_source] remoteExecCall ["life_fnc_setAggressive",_unit]};
	};
};

if (_hitBox != "?") then {
	_oldDamage = if (_hitBox == "") then { damage _unit } else { _unit getHit _hitBox };

	if !(isNil "_oldDamage") then {
		if (isNull _source && _projectile == "") exitWith {
			_scale = if (_hitBox select [0,5] == "wheel") then {0.15} else {0.35};
			_damage = ((_damage - _oldDamage) * _scale) + _oldDamage;
		};
	};
};

if (_projectile == "mini_Grenade") then {
	_damage = 0;
};

if (_hitBox == "palivo") then { _damage = _damage / 3 };

_damage;