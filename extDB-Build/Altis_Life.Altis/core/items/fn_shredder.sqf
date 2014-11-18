/*
	File: fn_shredder.sqf
	Author: Shentoza
	Description: Activates the shredder infront of the truck
*/
_val = 0;
_time = 0;
_gather = "";
_zone = "";
_mode = [_this,0,"",[""]] call BIS_fnc_param;
_vehicle = vehicle player;
_pos = [];
if(_vehicle == player) exitWith {hint localize "STR_NOTF_ShredderVehicle";};
if(driver _vehicle != player) exitWith {hint localize "STR_NOTF_ShredderDriver";};

if(_vehicle getVariable["shredder","stopped"] == "running") exitWith {_vehicle setVariable["shredder","stopped",true];};
if(_mode == "") exitWith{};
_resourceZones = ["heroin_1",
"cocaine_1","cocaine_2",
"weed_1","weed_2",
"grape_1",
"cotton_1"];
//Find out what zone we're near
{
	if(player distance (getMarkerPos _x) < 35) exitWith {_zone = _x;};
} foreach _resourceZones;
if(_zone == "") exitWith {hint localize "STR_NOTF_notNearResource";};

switch(true) do {
	case (_zone in ["heroin_1"]): {_gather = "heroinu";};
	case (_zone in ["cocaine_1","cocaine_2"]): {_gather = "cocaine";};
	case (_zone in ["weed_1","weed_2"]): {_gather = "cannabis";};
	case (_zone in ["grape_1"]): {_gather = "grape";};
	case (_zone in ["cotton_1"]): {_gather = "cotton";};
	default {""};
};

switch (_mode) do {
	case "shredder": 
	{
		switch(_gather) do {
			case "heroinu": {_val = 1;_time = 4;};
			case "cocaine": {_val = 1;_time = 4;};
			case "cannabis": {_val = 1;_time = 3;};
			case "grape": {_val = 2;_time = 3;};
			case "cotton":{_val = 2;_time = 4;};
		};
	};
	case "shredder1": 
	{
		switch(_gather) do {
			case "heroinu": {_val = 1;_time = 3;};
			case "cocaine": {_val = 1;_time = 3;};
			case "cannabis": {_val = 2;_time = 3;};
			case "grape": {_val = 3;_time = 3;};
			case "cotton":{_val = 3;_time = 4;};
		};
	};
	default {_val = 1;_time = 15;};
};
switch(true) do {
	case ((typeOf _vehicle) in ["C_Van_01_box_F"]): {_pos = [0,3.2,-0.8];}; // Boxer Trucks
	case ((typeOf _vehicle) in ["I_Truck_02_transport_F","I_Truck_02_covered_F"]): {_pos = [0,4.7,-1.6];}; //Zamaks
	case ((typeOf _vehicle) in ["B_Truck_01_transport_F","B_Truck_01_covered_F","B_Truck_01_box_F"]): {_pos = [0,5.4,-1.5];}; //Hemmts
	case ((typeOf _vehicle) in ["O_Truck_03_covered_F","O_Truck_03_ammo_F"]): {_pos = [0,4,-1.7];}; //Tempest
	default {_pos = [0,4.5,-1];};
};
_itemName = [([_gather,0] call life_fnc_varHandle)] call life_fnc_varToStr; 

_tool = "Land_Razorwire_F" createVehicle [0,0,0];
_tool attachTo[_vehicle,_pos];
_vehicle setVariable ["shredder","running",true];
_rotation = 0;
_full = false;
_stopped = false;
_tooFar = false;
_nextTime = time + _time;
_trunk = _vehicle getVariable ["Trunk",[[],0]];
_vehicle setVariable ["Trunk",_trunk,true];


waitUntil{
	sleep 0.05;
	if(_vehicle getVariable ["shredder","stopped"] == "stopped") then {_stopped = true;};
	if(vehicle player != _vehicle) then {_stopped = true;_vehicle setVariable["shredder","stopped",true];};
	if(player distance (getMarkerPos _zone) > 45) then {_tooFar = true;_vehicle setVariable["shredder","stopped",true];};
	_tool setVectorDirAndUp [[0,sin(_rotation),cos(_rotation)],[0,cos(_rotation),-sin(_rotation)]]; // ISNT THIS SOME FANCY MATH???!
	_rotation = (_rotation+8) mod 360;
	if(round(_nextTime - time) <= 0) then 
	{
		_trunk = _vehicle getVariable "Trunk";
		_weight = _trunk select 1;
		_currentItems = 0;
		_amount = 0;
		_itemWeight = [_gather] call life_fnc_itemWeight;
		_maxWeight = [(typeOf (_vehicle))] call life_fnc_vehicleWeightCfg;
		_index = -1;
		for "_x" from _val to 0 step -1 do //Check how many items you can gather
		{
			_amount = _x;
			if((_weight+ (_x * _itemWeight)) <= _maxWeight ) exitWith {_weight = _weight + (_amount*_itemWeight);};
			_full = true;
		};
		if(speed _vehicle < 5)then {
			titleText[localize "STR_NOTF_ShredderSpeed","PLAIN"];
			_weight = _weight - (_amount*_itemWeight);
			_amount = 0;
			_full = false;
		};
		//Check if u already have this item
		if(_amount > 0) then
		{
			{
				if(_x select 0 == _gather) exitWith {_index = _forEachIndex;_currentItems = _amount+(_x select 1);};
			}forEach (_trunk select 0);
			if( _index == -1 ) then 
			{
				_currentItems = _amount;
				(_trunk select 0) pushBack [_gather,_currentItems];_trunk set [1,_weight];
			} else {
				((_trunk select 0) select _index) set [1,_currentItems];
				_trunk set [1,_weight];
			};
		_vehicle setVariable ["Trunk",_trunk,true];
		hint format[localize "STR_NOTF_ShredderProgress",_currentItems,_itemName];
		};
		_nextTime = time + _time;
	};
	_full || _stopped || _tooFar
};
if(_full) then {_vehicle setVariable ["shredder","stopped",true];titleText[localize "STR_NOTF_DeviceFull","PLAIN"];};
if(_stopped) then {titleText[localize "STR_NOTF_ShredderStopped","PLAIN"];};
if(_tooFar) then {hint localize "STR_NOTF_notNearResource";};
deleteVehicle _tool;
