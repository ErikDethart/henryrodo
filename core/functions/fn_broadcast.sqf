if (isServer && isDedicated) exitWith {};
//	File: fn_broadcast.sqf
//	Author: Bryan "Tonic" Boardwine
//	Description: Broadcast system used in the life mission for multi-notification purposes.
params [
    ["_type",0,[[],0]],
    ["_message","",[""]],
    ["_localize",false,[false]]
];
if (_message isEqualTo "") exitWith {};

if (_localize) exitWith {
    _arr = _this select 3;
    _msg = switch (count _arr) do {
        case 0: {localize _message;};
        case 1: {format [localize _message,_arr select 0];};
        case 2: {format [localize _message,_arr select 0, _arr select 1];};
        case 3: {format [localize _message,_arr select 0, _arr select 1, _arr select 2];};
        case 4: {format [localize _message,_arr select 0, _arr select 1, _arr select 2, _arr select 3];};
    };

    if (_type isEqualType []) then {
        for "_i" from 0 to (count _type)-1 do {
            switch (_type select _i) do {
                case 0: {systemChat _msg;};
                case 1: {hint parseText format ["%1", _message]};
                case 2: {titleText[_msg,"PLAIN"];};
            };
        };
    } else {
        switch (_type) do {
            case 0: {systemChat _msg;};
            case 1: {hint parseText format ["%1",_msg];};
            case 2: {titleText[_msg,"PLAIN"];};
        };
    };
};

if (_type isEqualType []) then {
    for "_i" from 0 to (count _type)-1 do {
        switch (_type select _i) do {
            case 0: {systemChat _message};
            case 1: {hint parseText format ["%1", _message]};
            case 2: {titleText[format ["%1",_message],"PLAIN"];};
        };
    };
} else {
    switch (_type) do {
        case 0: {systemChat _message};
        case 1: {hint parseText format ["%1", _message];};
        case 2: {titleText [format ["%1",_message],"PLAIN"];};
    };
};

switch (_message) do {
    case "THE RACE BEGINS IN: 3": { playSound "racebeep1"; };
    case "THE RACE BEGINS IN: 2": { playSound "racebeep1"; };
    case "THE RACE BEGINS IN: 1": { playSound "racebeep1"; };
    case "GO GO GO!": { playSound "racebeep2"; };
};