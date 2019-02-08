//	File: fn_infamyTrackTarget.sqf
//	Author: Poseidon
//	Description: Loop that tracks the current target, automatically exits if you choose a new contract.
//		ToDo: Add more situations for it to exit? Like player not found for > 5 minutes or somethin

if(!params [["_contractID", 0, [0]]]) exitWith {};

private _targetPlayer = objNull;
private _lastPositionUpdate = serverTime;
private _accuracyRadius = 0;
private _updateFrequency = 0;
private _useMarker = (11 in life_infamyTalents);

//These switches could be moved to the infamyModifiers function for cleaner-feel
switch(true) do{
	case (4 in life_infamyTalents):{_accuracyRadius = 175};
	case (3 in life_infamyTalents):{_accuracyRadius = 210};
	case (2 in life_infamyTalents):{_accuracyRadius = 250};
	default {_accuracyRadius = 300};
};

switch(true) do{
	case (7 in life_infamyTalents):{_updateFrequency = 90};
	case (6 in life_infamyTalents):{_updateFrequency = 120};
	case (5 in life_infamyTalents):{_updateFrequency = 150};
	default {_updateFrequency = 180};
};


if(!isNil "infamyContract_task") then {
	player removeSimpleTask infamyContract_task;
};

if(_useMarker) then {
	infamyContract_task = player createSimpleTask ["Contract Target"];
	player setCurrentTask infamyContract_task;
};

_marker = createMarkerLocal [format["contract_%1", _contractID], [-10000, -10000, 0]];
_marker setMarkerShapeLocal "ELLIPSE";
_marker setMarkerSizeLocal [_accuracyRadius, _accuracyRadius];
_marker setMarkerTypeLocal "mil_dot";
_marker setMarkerBrushLocal "DiagGrid";
_marker setMarkerColorLocal "ColorRed";
_marker setMarkerTextLocal format["Contract Target %1", life_infamyContractTargetName];

_marker2 = createMarkerLocal [format["contract_dot_%1", _contractID], [-10000, -10000, 0]];
_marker2 setMarkerShapeLocal "ICON";
_marker2 setMarkerTypeLocal "mil_dot";
_marker2 setMarkerColorLocal "ColorRed";
_marker2 setMarkerTextLocal format["Contract Target %1", life_infamyContractTargetName];
private _pos = [0,0,0];
private _lastUpdate = serverTime;

_exitTracking = false;
while{life_infamyContractID == _contractID} do {
	uisleep 2;
	if(_exitTracking) exitWith {};
	if(!license_civ_rebel) exitWith {hint "You need a rebel license to track a contract.";};
	if(life_infamyContractID != _contractID) exitWith {};//they changed contracts
	if(isNull _targetPlayer) then {
		systemChat format["Searching for %1...", life_infamyContractTargetName];
		AllPlayers findif {if(getPlayerUID _x == life_infamyContractTargetID) then {_targetPlayer = _x; true;}};//find the matching player with playerID
		uisleep _updateFrequency;
	}else{
		if((serverTime % _updateFrequency) < 3) then {//we use servertime to have somewhat synchronized updates for group members
			if(_targetPlayer getVariable["infamy_contract_ID",-1] isEqualTo _contractID) then {
				systemChat format["%1 located", life_infamyContractTargetName];

				_lastUpdate = serverTime;
				if(_useMarker) then {
					_pos = [(getPos _targetPlayer), [1,_accuracyRadius] call BIS_fnc_randomInt, [0,359] call BIS_fnc_randomInt] call BIS_fnc_relPos;
					_marker setMarkerPosLocal _pos;
					_marker2 setMarkerPosLocal _pos;
					infamyContract_task setSimpleTaskDestination _pos;
				}else{
					_pos = [(getPos _targetPlayer), [1,_accuracyRadius] call BIS_fnc_randomInt, [0,359] call BIS_fnc_randomInt] call BIS_fnc_relPos;
					_marker setMarkerPosLocal _pos;
					_marker2 setMarkerPosLocal _pos;
				};

				waitUntil{uisleep 1; (vehicle player == player && (player distance _pos < 100)) || (life_infamyContractID != _contractID)};
				if(life_infamyContractID != _contractID) exitWith {_exitTracking = true;};
				waitUntil{uiSleep 1; serverTime >= (_lastUpdate + _updateFrequency)};
			}else{
				systemChat format["%1 located, however your current contract is not valid.", life_infamyContractTargetName];
				_exitTracking = true;
			};
		};
	};
};

deleteMarkerLocal format["contract_%1", _contractID];
deleteMarkerLocal format["contract_dot_%1", _contractID];

systemChat format["Contract tracker shutdown for contract %1.", _contractID];