//	File: fn_dispatchSpectate.sqf
//	Author: John "Paratus" VanderZwet
//	Description: Spectates the selected cop.
disableSerialization;

private ["_task","_taskList"];

if (isNull (findDisplay 39500)) exitWith {hint "Can't find dispatch UI."};
if (playerSide != west) exitWith {hint "Police only."};
if ((lbCurSel 39510) < 0) exitWith {hint "Police officer not selected."};

_copList = (findDisplay 39500) displayCtrl 39510;
_cop = call compile (_copList lbData (lbCurSel 39510));

if (isNull _cop) exitWith { hint "Invalid police officer selected." };
closeDialog 0;
if (_cop getVariable["blindfolded",false]) exitWith { hint "The selected officer is blindfolded!" };

cop_viewMode = cameraView;
cop_spectating = _cop;
cop_spectating switchCamera "INTERNAL";

[[0,1],format["Your GoPro has turned on. You are being monitored by dispatch officer %1.", [profileName] call life_fnc_cleanName]] remoteExecCall ["life_fnc_broadcast",_cop];
hint format["You are now viewing the live GoPro feed of Officer %1. \n\n Press F8 to disable the uplink.", name cop_spectating];
cop_exit = (findDisplay 46) displayAddEventHandler ["KeyDown",
	"
		switch(_this select 1) do
		{
			case 1;
			case 66: {(findDisplay 46) displayRemoveEventHandler ['KeyDown',cop_exit];[[0,1],format[""Your GoPro has deactivated.""]] remoteExecCall [""life_fnc_broadcast"",cop_spectating]; cop_spectating = nil; player switchCamera cop_viewMode; cop_viewMode = nil; hint 'The live video uplink has been terminated.'; true;};
		};
	"
];

while {!isNil "cop_spectating"} do
{
	if (cameraView != "INTERNAL") then { cop_spectating switchCamera "INTERNAL"; };
	uiSleep 0.5;
};