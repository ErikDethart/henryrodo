/*
	Better handling for setting npc location for rotating illegal areas
*/
private["_illegalAreas","_drugType","_selectedNPC","_index"];
_selectedNPC = _this select 0;
_drugType =_this select 1;
_index = 0;

_illegalAreas = [
	[ [[20902,17459,0],[23253.77,21820.16,0.201]], [[10123,14763,0],[6146.92,11867.1,0.562]] ], // Heroin  this setPos (getMarkerPos ""illegal_marker_1_1"");
	[ [[11597.79,16301.096,0],[14581.303,20760.146,0.604]], [[21639.012,10972.847,0.364],[19531.4,13309.3,0.700]] ], // Cocaine this setPos (getMarkerPos ""illegal_marker_2_1"");
	[ [[17527,10849,0],[22158,14422,0.006]], [[17527,10849,0],[22158,14422,0.006]], [[9661,18055,0],[11711.7,18277,0.187267]] ] // Meth  this setPos (getMarkerPos ""illegal_marker_3_1"");
];

switch(_drugType) do {
	case "heroin":{_index = 0};
	case "cocaine":{_index = 1};
	case "meth":{_index = 2};
};

uiSleep 5;//NPC will be at default location for 5 seconds, this gives us a bit of time for the server to move the markers

{
	{
		if((getMarkerPos format["illegal_marker_%1_1",(_index + 1)] distance _x) < 500) then {//loops through the possible locations, finds the correct one then sets the npc to where it should go.
			_selectedNPC setPosATL _x;
		};
	}foreach _x;
}foreach (_illegalAreas select _index);

