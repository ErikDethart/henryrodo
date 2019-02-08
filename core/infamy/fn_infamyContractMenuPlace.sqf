#include "..\..\macro.h"
if(scriptAvailable(1)) exitWith {};
/*
	File: fn_infamyContractMenuPlace.sqf
	Author: Poseidon

	Description: This is the page for picking a contract.
*/
disableSerialization;
private _display = life_infamyContractDialogInfo select 0;
private _controlGroup = life_infamyContractDialogInfo select 1;
if(isNull _display || isNull _controlGroup) exitWith {hint format["Failed to create contracts menu/n%1 - %2", _display, _controlGroup];};
private _thisPageButton = (_display displayCtrl 910050);
private _otherPageButton = (_display displayCtrl 910051);
_thisPageButton ctrlEnable false;
_otherPageButton ctrlEnable true;

//============================ Background And Title ============================
private _titleTextControl = (_display displayCtrl 910002);
_titleTextControl ctrlSetText "Active Contracts Manager - Create a contract";
_titleTextControl ctrlCommit 0;
if(!isNull (_display displayCtrl 910070)) then {ctrlDelete (_display displayCtrl 910070);};
if(!isNull (_display displayCtrl 910071)) then {ctrlDelete (_display displayCtrl 910071);};
//============================ END Background And Title ============================


//============================ Content Area ============================
private _mainWidth = 0.6;
private _mainHeight = 1;
private _mainMarginX = ((1.00001 - _mainWidth)/2);//we add decimals to avoid a zero divisor
private _mainMarginY = ((1.00001 - _mainHeight)/2);
private _cM = 0.01;//content margin
private _cMW = ((_mainWidth - 0.04) - (_cM*2));//content max width.
private _cMH = ((_mainHeight - 0.09));//content max height.

if(!isNull (_display displayCtrl 910005)) then {ctrlDelete (_display displayCtrl 910005);};

_cCG = [_display, "RscControlsGroup", 910005, _controlGroup, [0.01, 0.08, (_mainWidth - 0.02), (_mainHeight - 0.09)], [0, 0, 0, 0.4], false, ""] call life_fnc_ctrlCreate;
_cCB = [_display, "RscText", 910006, _cCG, [0, 0, (_mainWidth - 0.02), (_mainHeight - 0.09)], [0.3, 0.3, 0.3, 0.4], false, ""] call life_fnc_ctrlCreate;
_focusButton = [_display, "RscButtonMenu",910403, _cCG, [0, 0, 0, 0], [0, 0, 0, 0], true, ""] call life_fnc_ctrlCreate;
ctrlSetFocus _focusButton;//This is an invisible button that is essential for keeping UI focus on the right area

private _currentRow = 0;
private _viewableRows = 15;
private _rowHeight = ((_cMH - (_cM*(_viewableRows + 1))) / _viewableRows) ;
private _activeRowGroup = controlNull;

_playerList = allPlayers - [player];
_playerList sort true;

private _backgroundBorder = (_display displayCtrl 910003);
if(count(_playerList) > _viewableRows) then {
	_backgroundBorder ctrlSetPosition [0.01, 0.08, (_mainWidth - 0.04), (_mainHeight - 0.09)];
}else{
	_backgroundBorder ctrlSetPosition [0.01, 0.08, (_mainWidth - 0.02), (_mainHeight - 0.09)];
};
_backgroundBorder ctrlCommit 0;

{
	if(isNull _display || {isNull (_display displayCtrl 910005)}) exitWith {};
	_activeRowGroup = [_display, "RscControlsGroup", -1, _cCG, [_cM, ((_currentRow * (_rowHeight + _cM)) + (_cM*1.5)), _cMW, _rowHeight], [0, 0, 0, 0], false, ""] call life_fnc_ctrlCreate;

	_buttonControl = [_display, "RscButtonMenu", -1, _activeRowGroup, [0, 0, _cMW, _rowHeight], [0, 0, 0, 0.01], true, ""] call life_fnc_ctrlCreate;//Box button - this is where you can click to open popup
	_buttonControl buttonSetAction format["[] spawn{['%1'] spawn life_infamyContractPlacePopUP}",str(_x)];
	[_display, "RscText", -1, _activeRowGroup, [0, 0, _cMW, _rowHeight], [0, 0, 0, 0.5], true, ""] call life_fnc_ctrlCreate;//Box background
	[_display, "RscText", -1, _activeRowGroup, [0, 0, (_cMW/2) - _cM, _rowHeight], [0, 0, 0, 0], true, (name _x)] call life_fnc_ctrlCreate;//Display player name.
	[_display, "customDialog_LightFrame", -1, _activeRowGroup, [0, 0, _cMW, _rowHeight], [0, 0, 0, 0.25], true, ""] call life_fnc_ctrlCreate;//item border

	_currentRow = _currentRow + 1;
	if(_currentRow >= _viewableRows) then {
		_backgroundSize = ctrlPosition _cCB;

		_backgroundSize set [3, (_backgroundSize select 3) + (_rowHeight)];
		_cCB ctrlSetPosition _backgroundSize;
		_cCB ctrlCommit 0;
	};
}forEach _playerList;//[playerID, playerName, playerBounty, [list of contributor names]]


life_infamyContractPlacePopUP = {
	private["_auctionID","_type","_display","_control","_controlGroup","_focusButton","_data","_placeContractButton"];
	disableSerialization;

	_targetPlayer = param [0,"",[""]];
	_targetPlayer = call compile _targetPlayer;
	_display = life_infamyContractDialogInfo param [0,displayNull,[displayNull]];
	_controlGroup = life_infamyContractDialogInfo param [1,controlNull,[controlNull]];

	if(isNull _targetPlayer || isNull _display || isNull _controlGroup) exitWith {hint "Invalid data, cannot open info for this target."};
	if(!isNull (_display displayCtrl 900099)) exitWith {hint "A pop up is already open.";};

	private _size = ctrlPosition(_display displayCtrl 910001);
	private _marginPercent = 0.01;
	private _workableWidth = (_size select 2) - ((_size select 2) * (_marginPercent*2));
	private _workableHeight = (_size select 3) - ((_size select 3) * (_marginPercent*2));
	private _wX = (_size select 0) + (_workableWidth * _marginPercent);
	private _wY = (_size select 1) + (_workableHeight * _marginPercent);
	private _popUpWidth = (_workableWidth/1.25);
	private _popUpMargins = ((_workableWidth - _popUpWidth) / 2) * 0.999;

	_popUpControlGroup = [_display, "RscControlsGroup", 900099, _controlGroup, [0,0,_size select 2, _size select 3], [0, 0, 0, 0], true, ""] call life_fnc_ctrlCreate;
	[_display, "RscText", -1, _popUpControlGroup, [0,0,_size select 2, _size select 3], [0.1, 0.1, 0.1, 0.6], true, ""] call life_fnc_ctrlCreate;
	_focusButton = [_display, "RscButtonMenu",910404, _popUpControlGroup, [0, 0, 0, 0], [0, 0, 0, 0], true, ""] call life_fnc_ctrlCreate;
	ctrlSetFocus _focusButton;

	[_display, "customDialog_RscFrame", -1, _popUpControlGroup, [_popUpMargins - 0.012, _wY + 0.15 - 0.012, _popUpWidth + 0.024, 0.25 + 0.024], [0.5411, 0.5647, 0.5803, 0.6], true, ""] call life_fnc_ctrlCreate;
	[_display, "RscText", -1, _popUpControlGroup, [_popUpMargins - 0.008, _wY + 0.15 - 0.008, _popUpWidth + 0.016, 0.25 + 0.016], [0.5411, 0.5647, 0.5803, 1], true, ""] call life_fnc_ctrlCreate;
	[_display, "RscText", -1, _popUpControlGroup, [_popUpMargins, _wY + 0.15, _popUpWidth, 0.05], [0.3980, 0.4490, 0.4529, 1], true, "Create Contract"] call life_fnc_ctrlCreate;
	[_display, "RscStructuredText", -1, _popUpControlGroup, [_popUpMargins, _wY + 0.22, _popUpWidth, 0.12], [0, 0, 0, 0], true, format["<t align='center' color='#ffffff'>How much money would you like to put down towards a kill contract aimed at %1?</t>", (name _targetPlayer)]] call life_fnc_ctrlCreate;

	_bountyPrice = [_display, "RscEdit", 900106, _popUpControlGroup, [(_workableWidth - _popUpMargins - (_popUpWidth/2.5)) - 0.01, _wY + 0.34, (_popUpWidth/2.5), 0.05], [0.204,0.286,0.369,1], true, ""] call life_fnc_ctrlCreate;
	_bountyPrice ctrlAddEventHandler ["SetFocus", "_this call {life_infamyContractMenuStopFocus = true;}"];
	_bountyPrice ctrlAddEventHandler ["KillFocus", "_this call {life_infamyContractMenuStopFocus = false;}"];

	_placeContractButton = [_display, "RscButtonMenu", 900105, _popUpControlGroup, [(_popUpMargins) + 0.01, _wY + 0.34, (_popUpWidth/2.5), 0.05], [0.204,0.286,0.369,1], true, "      Create"] call life_fnc_ctrlCreate;
	_placeContractButton ctrlAddEventHandler ["ButtonClick", format ["_this call {[%1, '%2'] spawn life_fnc_infamyContractPlace}",900106, str(_targetPlayer)]];


	_closeButton = [_display, "RscButtonMenu",-1, _popUpControlGroup, [(_workableWidth - _popUpMargins - 0.04), _wY + 0.15, 0.04, 0.05], [0.906,0.298,0.235,1], true, " X"] call life_fnc_ctrlCreate;
	_closeButton buttonSetAction "[] spawn{uiSleep 0.1; ctrlDelete ((findDisplay 900000) displayCtrl 900099)};";
};
