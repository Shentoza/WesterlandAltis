/*
	File: fn_gather.sqf
	Author: Bryan "Tonic" Boardwine
	
	Description:
	Main functionality for gathering.
*/
if(isNil "life_action_gathering") then {life_action_gathering = false;};
private["_gather","_itemWeight","_diff","_itemName","_val","_resourceZones","_zone"];
_resourceZones = ["apple_1","apple_2","apple_3","apple_4","peaches_1","peaches_2","peaches_3","peaches_4","heroin_1","cocaine_1","cocaine_2","weed_1","weed_2","cotton_1","grape_1"];
_zone = "";

if(life_action_gathering) exitWith {}; //Action is in use, exit to prevent spamming.
life_action_gathering = true;
[] spawn {
	private ["_time"];
	_time = time;
	waitUntil{time - _time >= 8 || !(life_action_gathering)};
	if(life_action_gathering) then
	{
		life_action_gathering = false;
		hint "Fehler beim Abbauen. Du kannst nun erneut abbauen.";
	};
};
//Find out what zone we're near
{
	if(player distance (getMarkerPos _x) < 100) exitWith {_zone = _x;}; // Range is limited by the distance in which the action is shown (zoneCreator), so no need to hardcode limit it to 30 here. Raised the limit to fit the distances in zoneCreator but should probably be removed sometime
} foreach _resourceZones;

if(_zone == "") exitWith {
	hint localize "STR_NOTF_notNearResource";
	life_action_mining_hotkey_inuse = false;
	life_action_gathering = false;
};

//Get the resource that will be gathered from the zone name...
switch(true) do {
	case (_zone in ["apple_1","apple_2","apple_3","apple_4"]): {_gather = "apple"; _val = 3;};
	case (_zone in ["peaches_1","peaches_2","peaches_3","peaches_4"]): {_gather = "peach"; _val = 3;};
	case (_zone in ["heroin_1"]): {_gather = "heroinu"; _val = 1;};
	case (_zone in ["cocaine_1","cocaine_2"]): {_gather = "cocaine"; _val = 1;};
	case (_zone in ["weed_1","weed_2"]): {_gather = "cannabis"; _val = 1;};
	case (_zone in ["cotton_1"]): {_gather = "cotton"; _val = 2;};
	case (_zone in ["grape_1"]): {_gather = "grape"; _val = 3;};
	default {""};
};
//gather check??
if(vehicle player != player) exitWith {hint localize "STR_NOTF_GatherVeh";life_action_gathering = false;};

_diff = [_gather,_val,life_carryWeight,life_maxWeight] call life_fnc_calWeightDiff;
if(_diff == 0) exitWith {hint localize "STR_NOTF_InvFull"};
life_action_mining_hotkey_inuse = true;
for "_i" from 0 to 2 do
{
	player playMove "AinvPercMstpSnonWnonDnon_Putdown_AmovPercMstpSnonWnonDnon";
	waitUntil{animationState player != "AinvPercMstpSnonWnonDnon_Putdown_AmovPercMstpSnonWnonDnon";};
	sleep 2.5;
};

if(([true,_gather,_diff] call life_fnc_handleInv)) then
{
	_itemName = [([_gather,0] call life_fnc_varHandle)] call life_fnc_varToStr;
	titleText[format[localize "STR_NOTF_Gather_Success",_itemName,_diff],"PLAIN"];
};

life_action_mining_hotkey_inuse = false;
life_action_gathering = false;