#include "..\..\macro.h"
if(scriptAvailable(0.275)) exitWith {};
//	File: fn_createDialogCustom.sqf
//	Author: Poseidon
//	Description: Adds extra functionality for creating dialogs such as animations.

params [["_dialogName", "", [""]],["_asDisplay", false, [false]],["_closeLast", true, [false]]];
private _dialogID = getNumber(missionconfigfile >> _dialogName >> "idd");
private _location = getText(missionconfigfile >> _dialogName >> "location");
disableSerialization;

if(_dialogName == "" || _dialogID == 0) exitWith {systemChat "Could not create menu, bad data";};
private _dialogControl = (findDisplay _dialogID);

if(!isNull _dialogControl) then {
	[_dialogID, _location, false] spawn life_fnc_animateDialog;//Smoothly close dialog if it's already open
}else{
	if(life_lastDisplay != _dialogID) then {
		if(!isNull (findDisplay life_lastDisplay) && _closeLast) then {
			(findDisplay life_lastDisplay) closeDisplay 0;
			private _waitForClose = diag_tickTime + 0.01;
			while{diag_tickTime < _waitForClose} do {};//Small wait since dialogs do not close instantly, and opening a new one before one closes is problematic
			//Here is where we can disable animations for sub-menus
			//_location = "noAnim";
		};
	};

	if(_asDisplay) then {(findDisplay 46) createDisplay _dialogName;};
	if(!_asDisplay && {!(createDialog _dialogName)}) exitWith {systemChat ("Failed to open dialog " + _dialogName);};

	life_lastDisplay = _dialogID;
	//waitUntil{!isNull (findDisplay _dialogID)};

	[_dialogID,_location, true] spawn life_fnc_animateDialog;

	//Event handler for handling the escape key, allowing it to close these custom dialogs.
	private _closeDialogEVH = compile format["{
			_dialog = _this select 0;_key = _this select 1;_handled = (_key == 0x01);_location = %1; _noEscape = %2;
			if(_handled && !_noEscape) then {[(ctrlIDD _dialog), _location, false] spawn life_fnc_animateDialog;};
			_handled;
	}",str(_location),(isNumber(missionconfigfile >> _dialogName >> "noEVH"))];

	(findDisplay _dialogID) displayAddEventHandler ["keyDown", _this call _closeDialogEVH];
};