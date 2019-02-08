/*
	File: fn_monitorScriptHandle.sqf
	Author: Poseidon
	
	Description: Used to monitor script executing time by redirecting scripts to here and monitoring their time to complete.
		During testing the added code and monitoring added very minimal overhead.
*/
params [["_arguments", [], []],["_spawnFunc", true, [false]],["_scriptName", "", [""]],["_scriptCaller", "", [""]],["_scriptUniqueID", "", [""]],["_scriptStartTime", 0, [0]]];

diag_log format['FUNCTION START: %1 | Called From: %2 | Time: %3 | Instance Identifier: %4 | Arguments passed: %5 | Was spawned?: %6', _scriptName, _scriptCaller, _scriptStartTime, _scriptUniqueID, str(_arguments), str(_spawnFunc)];

if(_spawnFunc) exitWith {
	_this spawn{
		params [["_arguments", []],["_spawnFunc", true, [false]],["_scriptName", "", [""]],["_scriptCaller", "", [""]],["_scriptUniqueID", "", [""]],["_scriptStartTime", 0, [0]]];
		
		scriptName _scriptUniqueID;
		private _perfMonitoringHandle = (_arguments spawn (missionNamespace getVariable _scriptName));
		waitUntil{uiSleep 0.01; scriptDone _perfMonitoringHandle || (diag_tickTime > (_scriptStartTime + 60))};
		life_monitorFunctions deleteAt (life_monitorFunctions find _scriptName);
		
		if(diag_tickTime > (_scriptStartTime + 60)) then {
			diag_log format["FUNCTION -WARNING- FINISHED OR TOOK TOO LONG: Instance Identifier: %1 | Run Time: %2", _scriptUniqueID, (diag_tickTime - _scriptStartTime)];
		}else{
			diag_log format["FUNCTION FINISHED: Instance Identifier: %1 | Run Time: %2", _scriptUniqueID, (diag_tickTime - _scriptStartTime)];
		};
	};
};

scriptName _scriptUniqueID;
private _perfMonitoringNewReturn = [(_arguments call (missionNamespace getVariable _scriptName))] param[0,'badReturn-8456123', []];
life_monitorFunctions deleteAt (life_monitorFunctions find _scriptName);

if(diag_tickTime > (_scriptStartTime + 60)) then {
	diag_log format["FUNCTION -WARNING- FINISHED: Instance Identifier: %1 | Run Time: %2", _scriptUniqueID, (diag_tickTime - _scriptStartTime)];
}else{
	diag_log format["FUNCTION FINISHED: Instance Identifier: %1 | Run Time: %2", _scriptUniqueID, (diag_tickTime - _scriptStartTime)];
};

if(_perfMonitoringNewReturn isEqualTo "badReturn-8456123") exitWith{};//the call returned nothing... lets exit here.

_perfMonitoringNewReturn;
