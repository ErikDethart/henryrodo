/*
	File: fn_requestTrial.sqf
	Author: John "Paratus" VanderZwet
	
	Description:
	Requests a trial.
*/
if(profileNameSpace getVariable["asylum",false]) exitWith {titleText["You have already had your chance!","PLAIN"]};
if (!life_can_trial) exitWith {};
if (life_trial_inprogress) exitWith {hint "Another trial is already in process and the courts are at capacity.  Try again shortly."};

[player,life_bail_amount] remoteExec ["life_fnc_trialRequest",2];

life_requested_trial = true;
systemChat "Your trial request has been submitted.  It may take as long as 5 minutes before you receive word concerning the trial.";
profileNameSpace setVariable["asylum",true];
