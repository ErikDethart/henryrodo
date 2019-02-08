/*
	Description: Creates the triggers for handling capturing areas like cartels. Triggers are made client side and set to the location of the appropriate zone.
*/
private["_zone","_cartelZones","_flagObject"];
_cartelZones = ["1","2","3","4"];//arms, drug, oil, wong

uiSleep 20;//Wait 20 seconds before setting up the zones.

//Cartel triggers
{
	_flagObject = call compile format["capture_pole_%1",_x];//Grab the flag object
	_zone = createTrigger ["EmptyDetector",_flagObject, false];
	_zone setTriggerArea[50,50,0,false];
	_zone setTriggerActivation["CIV","PRESENT",true];
	_zone setTriggerStatements["(vehicle player) in thislist && !((player getVariable ['isBountyHunter', false])) && (vehicle player == player) && !(tolower(primaryWeapon player) in ['','binocular','smg_02_f','hgun_pdw2000_f','arifle_sdar_f']) && life_gang != '0' && !life_capturingCartel",format["[""%1""] spawn life_fnc_cartelCapture",_x],""];
} forEach _cartelZones;