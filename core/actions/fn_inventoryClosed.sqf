/*
	Description: Handles when a container inventory is closed, primarily for disabling simulation on house crates for the client and syncing crates (soon)
*/
private["_container"];
_container = param [1,ObjNull,[ObjNull]];
if(isNull _container) exitWith {};

if((typeOf _container) in ["Box_East_Support_F","Box_East_WpsSpecial_F"]) exitWith {
	_container enableSimulation false;
	if(_container getVariable["lootModified", false]) then {//if inventory has change sync it.
		[_container] remoteExecCall ["DB_fnc_updateStorage",2];
	};
};