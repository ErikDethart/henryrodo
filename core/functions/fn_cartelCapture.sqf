//	File: fn_cartelCapture.sqf
//	Description: Handles all position checks and progress reports for capturing cartels
private["_zone","_flagObject","_zoneLocation","_zoneName","_captureData"];
_zone = _this param [0,"",[""]];
_flagObject = call compile format["capture_pole_%1",_zone];
_zoneLocation = getPos _flagObject;
_zoneName = switch(_zone) do {
	case "1": {"Arms Dealer";};//Arms dealer
	case "2": {"Drug Cartel";};//Drug cartel
	case "3": {"Oil Cartel";};//Oil cartel
	case "4": {"Wong Triad";};//Wong triad cartel
	default {"My name jeff"};
};

//List of checks, if player is already capturing a cartel, tazed, or all that snazy stuff just exit. You can add checks for restrained, bounty hunter, or whatever. Those checks can also be added in setupCaptureTriggers
if(_zone == "" OR life_capturingCartel OR (isNil "_flagObject" OR isNull _flagObject)) exitWith {};
//Possibly due a check to see if player getVariable 'gang' is not set, if that is the case the capture system will not work. Could be isolated lan testing environment issue.

_captureData = _flagObject getVariable ["capture_data",[_zoneName,"0",0.5]];
life_capturingCartel = true;


//sets up progress bar with related title and sets the progress position
disableSerialization;
5 cutRsc ["life_progress","PLAIN"];

_cpRate = 0;
_ui = uiNamespace getVariable "life_progress";
_progressBar = _ui displayCtrl 38201;
_titleText = _ui displayCtrl 38202;
_title = format["You have entered the %1 zone.",_zoneName];
_titleText ctrlSetText _title;
_currentCaptureProgress = ((round((_captureData select 2) * 3000)) / 3000);
_progressBar progressSetPosition _currentCaptureProgress;
_cP = _currentCaptureProgress;
_updateTime = time + 5;
private _cartelCapStartTime = (time + 60);

while{true} do {
	//Checks to determine if capture should continue (left zone?, dead?)
	if(!alive player) exitWith {};
	if([getPos player select 0, getPos player select 1, 0] distance _zoneLocation > 60) exitWith {};
	if(!life_capturingCartel) exitWith {};
	if(vehicle player != player) exitWith {};
	if(isNull _ui) then {//if UI is not present, add progress bar.
		5 cutRsc ["life_progress","PLAIN"];
		_ui = uiNamespace getVariable "life_progress";
		_progressBar = _ui displayCtrl 38201;
		_titleText = _ui displayCtrl 38202;
	};

	uiSleep 1;

	_captureData = _flagObject getVariable ["capture_data",[_zoneName,"0",0.5]];//lets keep grabbing the latest data
	_currentDataID = _captureData select 1;
	_currentCaptureProgress = ((round((_captureData select 2) * 3000)) / 3000);//Converts the current percentage to a more friendly format.
	_cartelMarker = format["capture_label_%1", _zone];
	_cartelMarkerText = markerText _cartelMarker;
	_newCartelMarkerText = _cartelMarkerText;

	_nearbyGangs = [];
	{
		_targetsGang = (_x getVariable ["gang","0"]);
		if(!(_targetsGang in _nearbyGangs) && _targetsGang != "0" && alive _x) then {
			_nearbyGangs pushBack _targetsGang;
		};
	}foreach (nearestObjects[_zoneLocation,["Man"],60]);

	if(((_currentDataID == life_gang && _currentCaptureProgress < 1) OR (_currentDataID != life_gang)) && (count _nearbyGangs == 1 && ((_nearbyGangs select 0) == (life_gang)))) then {//if flag is not ours, or if it is ours and we have less than full cap continue. And if only 1 gang is within the zone, continue.
		if(serverTime < (_flagObject getVariable["capture_cooldown", serverTime - 100])) exitWith {//Exit capture attempt if on cooldown
			_title = format["Capture cooldown - %1 + minutes remaining.",round(((_flagObject getVariable["capture_cooldown", serverTime - 100]) - serverTime) / 60)];
			_titleText ctrlSetText format["%1",_title];
		};

		if(((_currentDataID) != (life_gang)) && _cp > 0) then {
			_cpRate = -0.0017;
			_title = format["Your gang is taking ownership of %1.",_zoneName];
			_newCartelMarkerText = format["%1 - Contested", _zoneName];
		} else {
			if(_currentDataID != life_gang) then {//The gang taking ownership has gotten the zone to less than 0%, so lets give them ownership now while they finish capturing.
				_captureData set [1, life_gang];
				_captureData set [2, 0];
				_flagObject setVariable["capture_data",_captureData,true];
			};
			_newCartelMarkerText = format["%1 - Contested", _zoneName];
			_title = format["Your gang is capturing %1.",_zoneName];
			_cpRate = 0.0017;
		};

		if((time > life_infamyCartelCooldown) && (time > _cartelCapStartTime)) then {
			[5] call life_fnc_addInfamy;
			life_infamyCartelCooldown = (time + 60);
		};

		_cP = _cP + _cpRate;
		_cP = ((round((_cP) * 3000)) / 3000);
		if(_cP > 1) then {_cP = 1;} else {if(_cP < 0) then {_cp = 0;};};
		_progressBar progressSetPosition _cP;
		_titleText ctrlSetText format["%3 (%1%2)",round(_cP * 100),"%",_title];

		if(_currentDataID == life_gang && _cp >= 1) exitWith {//we have full cap no need to continue.
			_captureData set [1, _currentDataID];
			_captureData set [2, _cP];
			_flagObject setVariable["capture_data",_captureData,true];
			_flagObject setVariable["capture_cooldown",serverTime + 1800, true];

			//We got full cap lets put our name on the marker...
			_newCartelMarkerText = format["%1 - %2", _zoneName, (player getVariable ["gangName","Captured"])];

			private _myGangBois = [];
			{
				_targetsGang = (_x getVariable ["gang","0"]);

				if(_targetsGang == life_gang && _targetsGang != "0") then {
					_myGangBois pushBack _x;
				};
			}foreach (nearestObjects[_zoneLocation,["Man"],60]);

			if(!(_myGangBois isEqualTo [])) then {
				[2,5] remoteExecCall ["life_fnc_addStatistic",_myGangBois];
			};
			//Lets share with nearby bois
		};

		if(_updateTime <= time) then {//Every 5 seconds send out an update on the flag.
			if(((_currentCaptureProgress < _cp) && _cpRate > 0) OR ((_currentCaptureProgress > _cp) && _cpRate < 0)) then {
				_captureData set [1, _currentDataID];
				_captureData set [2, _cP];
				_flagObject setVariable["capture_data",_captureData,true];
				if(isNil {_flagObject getVariable "last_alert"}) then {//Set an alert variable so multiple players don't spam the gang with notifications
					_flagObject setVariable["last_alert",serverTime,true];
				};

				if((_flagObject getVariable["last_alert",serverTime]) < (serverTime - 300)) then {//only sends an update to enemy gang once every 5 minutes.
					if(_currentDataID != life_gang) then {
						[_zone] remoteExecCall ["life_fnc_capNotice",civilian];
						_flagObject setVariable["last_alert",serverTime,true];
					};
				};
			} else {
				_cP = _currentCaptureProgress;
			};
			_updateTime = time + 5;
		};
	} else {
		if(_currentDataID == life_gang && _currentCaptureProgress > 0.99) then {
			_title = format["Your gang currently owns %1.",_zoneName];
			_newCartelMarkerText = format["%1 - %2", _zoneName, (player getVariable ["gangName","Captured"])];
		} else {
			if(serverTime < (_flagObject getVariable["capture_cooldown", serverTime - 100])) then {
				_title = format["Capture cooldown - %1 + minutes remaining.",round(((_flagObject getVariable["capture_cooldown", serverTime - 100]) - serverTime) / 60)];
				_titleText ctrlSetText format["%1",_title];
			}else{
				_title = format["%1 is currently contested.",_zoneName];
			};
		};
		_titleText ctrlSetText format["%3 (%1%2)",round(_cP * 100),"%",_title];
		_updateTime = time + 5;
	};

	if (_newCartelMarkerText != _cartelMarkerText) then { _cartelMarker setMarkerText _newCartelMarkerText; };
};

5 cutText ["","PLAIN"];
life_capturingCartel = false;