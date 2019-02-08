/*
	File: fn_animateDialog.sqf
	Author: Poseidon
	
	Description: Performs the specified animations on the dialogs by applying animations to each control in the created dialog.
	_mode is true for when you create a dialog, false is for close and will reverse the animation if one is provided.
*/
private["_endPosition","_hiddenPos"];//this is a proper situation to use the private array btw gnashes ;)
params [["_dialogID", 0, [0]],["_location", "", [""]],["_mode", true, [false]]];
if(_dialogID == 0) exitWith {};//exit if bad dialog and you're trying to open it
disableSerialization;

_dialogControl = (findDisplay _dialogID);

if(_location == "noAnim") exitWith {if(!_mode) then {closeDialog 0;}else{{_x ctrlSetFade 0;_x ctrlCommit 0;}foreach (allControls (findDisplay _dialogID));};};//if noAnim selected and creatingDialog, instantly unfade it. If closing dialog instantly close it.
if(isNull _dialogControl) exitWith {};

{
	_endPosition = ctrlPosition _x;
	
	_hiddenPos = switch(_location) do {
		case "top": {[(_endPosition select 0), (_endPosition select 1) - 1]};
		case "bottom":{[(_endPosition select 0), (_endPosition select 1) + 1]};
		case "left": {[(_endPosition select 0) - 1, (_endPosition select 1)]};
		case "right":{[(_endPosition select 0) + 1, (_endPosition select 1)]};
		case "fadeOnly": {[(_endPosition select 0), (_endPosition select 1)]};
		case "grow": {[(_endPosition select 0) + ((_endPosition select 2) / 2), (_endPosition select 1) + ((_endPosition select 3) / 2)]};//This affect looks odd since it grows each element individually. I could probably make it good with more maf
		case "leftAndRight": {//This animation is designed to slide 2 seperate panels into the center. You need a panel on the left and one on the right.
			if((_endPosition select 0) > (safeZoneW / 4)) then {
				[(_endPosition select 0) + 1, (_endPosition select 1)];
			} else{
				[(_endPosition select 0) - 1, (_endPosition select 1)];
			};
		};
		default {[(_endPosition select 0), (_endPosition select 1)]};
	};

	if(_mode) then {//Create dialog and animate it to the desired location.
		//This is the pre-animation preperation area
		if(_location == "grow") then {_x ctrlSetScale 0;};//For grow we make all elements 0 in size
		_x ctrlSetPosition _hiddenPos;
		_x ctrlSetFade 1;//Hide the display instantly, for best effect hide all elements in the actual dialog.hpp
		_x ctrlCommit 0;
		
		//This is the start animation area
		if(_location == "grow") then {_x ctrlSetScale 1;};
		_x ctrlSetPosition [_endPosition select 0, _endPosition select 1];
		_x ctrlSetFade 0;
		_x ctrlCommit 0.275;//Animate the elements over a 0.275 second period
	}else{//Close dialog with smooth animation
		if(_location == "grow") then {_x ctrlSetScale 0;};
		_x ctrlSetPosition _hiddenPos;
		_x ctrlSetFade 1;
		_x ctrlCommit 0.14;
	};
}foreach (allControls _dialogControl);

if(!_mode) then {
	uiSleep 0.14;
	closeDialog 0;
};