private ["_r","_key_delay","_max_height"] ;
_max_height = 2.5;

if  (player == vehicle player and player getvariable ["jump",true] and isTouchingGround player ) then
{   
	player setvariable ["jump",false];

	_height = 6-((load player)*10);

	_vel = velocity player;
	_dir = direction player;
	_speed = 0.4;
	If (_height > _max_height) then {_height = _max_height};
	player setVelocity [(_vel select 0)+(sin _dir*_speed),(_vel select 1)+(cos _dir*_speed),(_vel select 2)+_height];

[player,"AovrPercMrunSrasWrflDf"] remoteExecCall ["life_fnc_animSync",-2];
	player spawn {uiSleep 2;_this setvariable ["jump",true]};
};
