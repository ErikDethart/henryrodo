//	File: fn_jackpot.sqf
//	Author: John "Paratus" VanderZwet
//	Description:
//	Won he lottery!

//	Parameter(s):
//	0: Number - Amount of money won.

//	Returns: Nothing
params [["_amount", 0, [0]]];


["atm","add",_amount] call life_fnc_updateMoney;
[[0,1,2],format["Congratulations, %1! You have won the jackpot of $%2! $%3 has already been added to your bank account.", [name player] call life_fnc_cleanName, [_amount] call life_fnc_numberText, [_amount] call life_fnc_numberText]] call life_fnc_broadcast;

_headline = format["%1 has won the Lottery!", [name player] call life_fnc_cleanName];
_message = format["Lottery winnings amount to $%1", [_amount] call life_fnc_numberText];
_sender = format["The Government of %1", worldName];
[_headline,_message,_sender] remoteExec ["life_fnc_showBroadcast",-2];
