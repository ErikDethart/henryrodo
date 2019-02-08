#include "..\..\macro.h"
if(scriptAvailable(1)) exitWith {};
//	File: fn_infamyInitContractMenu.sqf
//	Author: Poseidon
//	Description: Starts the contract menu and sets up the main elements.
//		Will evenetually display your current contract on this page
//		And will display all your scalps with a button to sell a scalp.

private["_buttonControl"];
disableSerialization;
["customDialogBlank"] call life_fnc_createDialogCustom;
waitUntil{!isNull (findDisplay 900000)};
private _mainWidth = 0.6;
private _mainHeight = 1;
private _mainMarginX = ((1.00001 - _mainWidth)/2);//we add decimals to avoid a zero divisor
private _mainMarginY = ((1.00001 - _mainHeight)/2);
private _cM = 0.01;//content margin
private _cMW = ((_mainWidth - 0.04) - (_cM*2));//content max width.
private _cMH = ((_mainHeight - 0.12) - (_cM*2));//content max height.

private _display = findDisplay 900000;

private _controlGroup = [_display, "RscControlsGroup", 910001, controlNull, [_mainMarginX, _mainMarginY, _mainWidth, _mainHeight + 0.07], [0, 0, 0, 0], false, ""] call life_fnc_ctrlCreate;

life_infamyContractDialogInfo = [_display,_controlGroup];//Set display and control group in a variable so it can be easily accessed by other dialog functions

//A loop that runs while dialog is open to ensure the correct elements keep UI focus
[_display] spawn{
	disableSerialization;
	_display = param [0,displayNull,[displayNull]];

	while{true} do {
		if(isNull _display) exitWith {};

		uiSleep 0.01;

		if(!life_infamyContractMenuStopFocus) then {
			if(!isNull (_display displayCtrl 910005)) then {
				if(isNull (_display displayCtrl 910404)) then {
					ctrlSetFocus (_display displayCtrl 910403);
				}else{
					ctrlSetFocus (_display displayCtrl 910404);
				};
			};
		};
	};
};

//============================ Background And Title ============================
[_display, "RscText", -1, _controlGroup, [0, 0, _mainWidth, _mainHeight], [0, 0, 0, 1], true, ""] call life_fnc_ctrlCreate;//The main window background.
[_display, "customDialog_RscFrame", 910003, _controlGroup, [0.01, 0.08, (_mainWidth - 0.02), (_mainHeight - 0.09)], [0.3, 0.3, 0.3, 0.4], true, ""] call life_fnc_ctrlCreate;
[_display, "RscText", 910002, _controlGroup, [0.01, 0.02, (_mainWidth - 0.02), 0.05], [1, 0, 0, 0.5], true, "Active Contracts Manager"] call life_fnc_ctrlCreate;
//============================ END Background And Title ============================

//============================ Navigation Buttons ============================
_buttonControl = [_display, "RscButton", 910050, _controlGroup, [0, _mainHeight + 0.005, ((_mainWidth/2) - 0.005), 0.05], [0.6, 0, 0, 1], true, "Create a contract"] call life_fnc_ctrlCreate;
_buttonControl buttonSetAction "[] spawn life_fnc_infamyContractMenuPlace;";
_buttonControl = [_display, "RscButton", 910051, _controlGroup, [((_mainWidth/2) + 0.005), _mainHeight + 0.005, ((_mainWidth/2) - 0.005), 0.05], [0.6, 0, 0, 1], true, "Browse contracts"] call life_fnc_ctrlCreate;
_buttonControl buttonSetAction "[] spawn life_fnc_infamyContractMenuChoose;";
//============================ END Navigation Buttons ============================

if(!isNull (_display displayCtrl 910005)) then {ctrlDelete (_display displayCtrl 910005);};

_cCG = [_display, "RscControlsGroup", 910005, _controlGroup, [0.01, 0.08, (_mainWidth - 0.02), (_mainHeight - 0.09)], [0, 0, 0, 0.4], false, ""] call life_fnc_ctrlCreate;
_cCB = [_display, "RscText", 910006, _cCG, [0, 0, (_mainWidth - 0.02), (_mainHeight - 0.09)], [0.3, 0.3, 0.3, 0.4], false, ""] call life_fnc_ctrlCreate;
_focusButton = [_display, "RscButtonMenu",910403, _cCG, [0, 0, 0, 0], [0, 0, 0, 0], true, ""] call life_fnc_ctrlCreate;
ctrlSetFocus _focusButton;//This is an invisible button that is essential for keeping UI focus on the right area

[_display, "RscStructuredText", -1, _cCG, [0.01, 0.1, _cMW, (_mainHeight - 0.2)], [0, 0, 0, 0], true, "<t align='center' color='#ff0000'>Welcome to the Contract Manager system.<br/><br/>You can find or create a new contract using the buttons below.</t>"] call life_fnc_ctrlCreate;

