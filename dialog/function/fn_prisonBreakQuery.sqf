//	File: fn_prisonBreakQuery.sqf
//	Author: Jesse "tkcjesse"
//	Description: Displays UI for breaking out of prison if a prisoner after a successful break.

if !(life_is_arrested) exitWith {};
if ((player distance (getMarkerPos "corrections")) > 100) exitWith {};
if (life_trial_inprogress && life_requested_trial) exitWith {hint "A prison break has occurred but you cannot escape when you're waiting on a trial."};

private _time = (time + 65);
private _action = [
	"The Prison's security system has been compromised! Would you like to escape from jail? You have 1 minute to decide!",
	"Escape from Prison?",
	"Yes",
	"No"
] call BIS_fnc_GUImessage;

if (round(_time - time) < 1) exitWith {systemChat "You took too long to decide! You will now serve your sentence out!";};
if (_action) then {
	life_breakout = true;
};