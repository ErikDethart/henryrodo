#include "..\..\macro.h"
if(scriptAvailable(5)) exitWith {};
//	File: fn_infamyContractMenuChoose.sqf
//	Author: Poseidon
//	Description: This is the page for picking a contract.

disableSerialization;
private _display = life_infamyContractDialogInfo select 0;
private _controlGroup = life_infamyContractDialogInfo select 1;
if(isNull _display || isNull _controlGroup) exitWith {hint format["Failed to create contracts menu/n%1 - %2", _display, _controlGroup];};
private _thisPageButton = (_display displayCtrl 910051);
private _otherPageButton = (_display displayCtrl 910050);
_thisPageButton ctrlEnable false;
_otherPageButton ctrlEnable true;
private _mainWidth = 0.6;
private _mainHeight = 1;
private _mainMarginX = ((1.00001 - _mainWidth)/2);//we add decimals to avoid a zero divisor
private _mainMarginY = ((1.00001 - _mainHeight)/2);
private _cM = 0.01;//content margin
private _cMW = ((_mainWidth - 0.04) - (_cM*2));//content max width.
private _cMH = ((_mainHeight - 0.12)) - 0.06;//content max height.


//============================ Background And Title ============================
private _titleTextControl = (_display displayCtrl 910002);
_titleTextControl ctrlSetText "Active Contracts Manager - Browse contracts";
_titleTextControl ctrlCommit 0;

[_display, "RscStructuredText", 910070, _controlGroup, [0.01, 0.085, (_mainWidth/2) - 0.01, 0.05], [0.8, 0.5, 0.5, 0.4], true, "<t align='center' color='#ffffff'>Contract Target</t>"] call life_fnc_ctrlCreate;
[_display, "RscStructuredText", 910071, _controlGroup, [(_mainWidth/2), 0.085, (_mainWidth/2) - 0.01, 0.05], [0.8, 0.5, 0.5, 0.4], true, "<t align='center' color='#ffffff'>Contributors</t>"] call life_fnc_ctrlCreate;
//============================ END Background And Title ============================

//============================ Data Fetching and wait for receive ============================
if(!isNull (_display displayCtrl 910005)) then {ctrlDelete (_display displayCtrl 910005);};
_cCG = [_display, "RscControlsGroup", 910005, _controlGroup, [0.01, 0.135, (_mainWidth - 0.02), (_mainHeight - 0.145)], [0, 0, 0, 0.4], false, ""] call life_fnc_ctrlCreate;

private _timeLimit = diag_tickTime + 15;
life_infamyAllContractData = [-1];
life_infamyFetchingContracts = true;
_otherPageButton ctrlEnable false;
[player] remoteExecCall ["ASY_fnc_infamyGetContracts",2];
[800100, [((_mainWidth - 0.02)/2) - (0.15/2), 0.1, 0.15, 0.15], _cCG, "life_infamyFetchingContracts", format["<t align='center'>%1</t>", "Loading contracts..."], _display] call life_fnc_dialogLoading;
waitUntil{!(life_infamyAllContractData isEqualTo [-1]) || (diag_tickTime > _timeLimit) || isNull _display};//wait for the server to send us the info....
life_infamyFetchingContracts = false;
if(life_infamyAllContractData isEqualTo [-1]) then {life_infamyAllContractData = [];};
_otherPageButton ctrlEnable true;
if(isNull _display || {isNull (_display displayCtrl 910005)}) exitWith {};

if(!isNull (_display displayCtrl 910005)) then {ctrlDelete (_display displayCtrl 910005);};
_cCG = [_display, "RscControlsGroup", 910005, _controlGroup, [0.01, 0.135, (_mainWidth - 0.02), (_mainHeight - 0.145)], [0, 0, 0, 0.4], false, ""] call life_fnc_ctrlCreate;
//============================ END Data Fetching and wait for receive ============================

//============================ Content Area ============================
_cCB = [_display, "RscText", 910006, _cCG, [0, 0, (_mainWidth - 0.02), (_mainHeight - 0.09)], [0.3, 0.3, 0.3, 0.4], false, ""] call life_fnc_ctrlCreate;
_focusButton = [_display, "RscButtonMenu",910403, _cCG, [0, 0, 0, 0], [0, 0, 0, 0], true, ""] call life_fnc_ctrlCreate;
ctrlSetFocus _focusButton;//This is an invisible button that is essential for keeping UI focus on the right area

if(life_infamyAllContractData isEqualTo []) exitWith {
	[_display, "RscStructuredText", -1, _cCG, [0.01, 0.1, _cMW, 0.1], [0, 0, 0, 0], true, "<t align='center' color='#ff0000'>No active contracts, consider submitting one!</t>"] call life_fnc_ctrlCreate;
};

private _currentRow = 0;
private _viewableRows = 6;
private _rowHeight = ((_cMH - (_cM*(_viewableRows + 1))) / _viewableRows) ;
private _contributorRow = 0;
private _contributorViewableRows = 4;
private _contributorName = "";
private _contributorRowHeight = (((_rowHeight - 0.07) - (_cM * _contributorViewableRows)) / _contributorViewableRows);
private _contributorGroup = controlNull;
private _activeRowGroup = controlNull;

private _backgroundBorder = (_display displayCtrl 910003);
if(count(life_infamyAllContractData) > _viewableRows) then {
	_backgroundBorder ctrlSetPosition [0.01, 0.132, (_mainWidth - 0.04), (_mainHeight - 0.142)];
}else{
	_backgroundBorder ctrlSetPosition [0.01, 0.132, (_mainWidth - 0.02), (_mainHeight - 0.142)];
};
_backgroundBorder ctrlCommit 0;

{
	if(isNull _display || {isNull (_display displayCtrl 910005)}) exitWith {};
	_activeRowGroup = [_display, "RscControlsGroup", -1, _cCG, [_cM, ((_currentRow * (_rowHeight + _cM)) + (_cM*1.5)), _cMW, _rowHeight], [0, 0, 0, 0], false, ""] call life_fnc_ctrlCreate;

	_buttonControl = [_display, "RscButtonMenu", -1, _activeRowGroup, [0, 0, _cMW, _rowHeight], [0, 0, 0, 0.01], true, ""] call life_fnc_ctrlCreate;//Box button - this is where you can click to take contract
	_buttonControl buttonSetAction format["[] spawn{[%1,'%2','%3', %4] spawn life_fnc_infamyContractTake;}",_x select 0,_x select 1, _x select 2, _x select 3];
	[_display, "RscText", -1, _activeRowGroup, [0, 0, _cMW, _rowHeight], [0, 0, 0, 0.5], true, ""] call life_fnc_ctrlCreate;//Box background
	[_display, "RscText", -1, _activeRowGroup, [_cM, 0.01, (_cMW/2) - _cM, 0.05], [0, 0, 0, 0], true, (_x select 2)] call life_fnc_ctrlCreate;//Display player name.
	[_display, "RscText", -1, _activeRowGroup, [_cM, 0.06, (_cMW/2) - _cM, 0.05], [0, 0, 0, 0], true, format["Value: $%1", [(_x select 3)] call life_fnc_numberText]] call life_fnc_ctrlCreate;//Display bounty value.


	_contributorGroup = [_display, "RscControlsGroup", -1, _activeRowGroup, [(_cMW/2) + 0.01, 0.01, (_cMW/2) - 0.02, (_rowHeight - 0.03)], [0, 0, 0, 0.4], false, ""] call life_fnc_ctrlCreate;

	_contributorRow = 0;
	{
		_contributorName = _x;

		[_display, "RscStructuredText", -1, _contributorGroup, [0, (0.0275*_contributorRow), (_cMW/2) - 0.03, 0.04], [0, 0, 0, 0], true, format[" <t size='0.8'>%1</t>", _contributorName]] call life_fnc_ctrlCreate;
		_contributorRow = _contributorRow + 1;
	}foreach (_x select 4);

	[_display, "customDialog_LightFrame", -1, _activeRowGroup, [(_cMW/2) + 0.01, 0.01, (_cMW/2) - 0.02, (_rowHeight - 0.02)], [0, 0, 0, 0.25], true, ""] call life_fnc_ctrlCreate;//contributors border
	[_display, "customDialog_LightFrame", -1, _activeRowGroup, [0, 0, _cMW, _rowHeight], [0, 0, 0, 0.25], true, ""] call life_fnc_ctrlCreate;//item border

	_currentRow = _currentRow + 1;
	if(_currentRow >= _viewableRows) then {
		_backgroundSize = ctrlPosition _cCB;

		_backgroundSize set [3, (_backgroundSize select 3) + (_rowHeight)];
		_cCB ctrlSetPosition _backgroundSize;
		_cCB ctrlCommit 0;
	};
}forEach life_infamyAllContractData;//[playerID, playerName, playerBounty, [list of contributor names]]

