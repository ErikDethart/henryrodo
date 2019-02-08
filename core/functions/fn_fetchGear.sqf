//	File: fn_fetchGear.sqf
//	Author: Bryan "Tonic" Boardwine
//	Description: Fetches the players current gear and returns it in the correct formatted array.

private["_primary,_launcher","_handgun","_magazines","_uniform","_vest","_backpack","_items","_primitems","_secitems","_handgunitems","_uitems","_vitems","_bitems","_headgear","_goggles"];
_primitems = [];
_secitems = [];
_handgunitems = [];
_primary = primaryWeapon player;
_launcher = secondaryWeapon player;
_handgun = handGunWeapon player;
_magazines = [];
_uniform = uniform player;
_vest = vest player;
_backpack = backpack player;
_items = assignedItems player;
if(primaryWeapon player != "") then {_primitems = primaryWeaponItems player;};
if(handgunWeapon player != "") then {_handgunItems = handgunItems player;};
_headgear = headgear player;
_goggles = goggles player;
_uitems = [];
_vitems = [];
_bitems = [];
if(_uniform != "") then {{_uitems set[count _uitems,_x];} foreach (uniformItems player);};
if(_vest != "") then {{_vitems set[count _vitems,_x];} foreach (vestItems player);};
if(_backpack != "") then {{_bitems set[count _bitems,_x];} foreach (backPackItems player);};

if(primaryWeapon player != "") then
{
	if (count (primaryWeaponMagazine player) > 0) then
	{
		_magazines pushBack ((primaryWeaponMagazine player) select 0);
	};
};

if(secondaryWeapon player != "") then
{
	if (count (secondaryWeaponMagazine player) > 0) then
	{
		_magazines pushBack ((secondaryWeaponMagazine player) select 0);
	};
};

if(handgunWeapon player != "") then
{
	if (count (handgunMagazine player) > 0) then
	{
		_magazines pushBack ((handgunMagazine player) select 0);
	};
};

if(isNil "_handgunItems") then {_handgunItems = ["","",""];};
[_primary,_launcher,_handgun,_magazines,_uniform,_vest,_backpack,_items,_primitems,_secitems,_handgunitems,_uitems,_vitems,_bitems,_headgear,_goggles];