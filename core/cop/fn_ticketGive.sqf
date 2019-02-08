/*
	File: fn_ticketGive.sqf
	Author: Bryan "Tonic" Boardwine
	
	Description:
	Gives a ticket to the targeted player.
*/
private["_val"];
if(isNil {life_ticket_unit}) exitWith {hint "Person to ticket is nil"};
if(isNull life_ticket_unit) exitWith {hint "Person to ticket doesn't exist."};
_val = ctrlText 2652;
if(!([_val] call life_fnc_isnumber)) exitWith {hint "You didn't enter actual number format."};
//if((parseNumber _val) > 1000000) exitWith {hint "Tickets can not be more than $1,000,000!"};
[0,format["%1 gave a ticket of $%2 to %3",name player,[(parseNumber _val)] call life_fnc_numberText,name life_ticket_unit]] remoteExecCall ["life_fnc_broadcast",-2];
//[54, player, format["Gave ticket of %1 to %2", _val, name life_ticket_unit]] remoteExecCall ["ASY_fnc_logIt",2];
[player,(parseNumber _val)] remoteExecCall ["life_fnc_ticketPrompt",life_ticket_unit];
closeDialog 0;
