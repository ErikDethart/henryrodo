//	File: fn_sessionSetup.sqf
//	Author: Bryan "Tonic" Boardwine

//	Description:
//	Starts the setup process for the player retrieving their saved
//	information from the server, the player will not ever fully initializing
//	without this process being completed.

waitUntil {!isNull player && player == player};
cutText["Contacting server for player information...","BLACK FADED"];
0 cutFadeOut 999999;
[player,playerSide,getPlayerUID player] remoteExecCall ["ASY_fnc_query",2];
