//	File: fn_sessionCreate.sqf
//	Author: Bryan "Tonic" Boardwine
//	Description:Start the process and setup the players information on the server.

private["_packet"];

if (playerSide == sideLogic) exitWith
{
	cutText["You do not have permission to use this slot.  Please abort and choose another.","BLACK FADED"];
	0 cutFadeOut 9999999;
};

cutText["Creating player information on server...","BLACK FADED"];
0 cutFadeOut 9999999;
_packet = [player,playerSide,life_money,life_atmmoney,getPlayerUID player];

switch (playerSide) do
{
	case west:
	{
		[] call life_fnc_copDefault;
		_gear = cop_gear;
		_packet set[count _packet,_gear];
	};

	case civilian:
	{
		[] call life_fnc_civFetchGear;
		_packet set[count _packet,life_is_arrested];
	};
};

_packet remoteExec ["ASY_fnc_add",2];
