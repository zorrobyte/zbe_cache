/*
 ________   ____     ____            ____                     __                              
/\_____  \ /\  _`\  /\  _`\         /\  _`\                  /\ \      __                     
\/____//'/'\ \ \L\ \\ \ \L\_\       \ \ \/\_\     __      ___\ \ \___ /\_\    ___      __     
     //'/'  \ \  _ <'\ \  _\L        \ \ \/_/_  /'__`\   /'___\ \  _ `\/\ \ /' _ `\  /'_ `\   
    //'/'___ \ \ \L\ \\ \ \L\ \       \ \ \L\ \/\ \L\.\_/\ \__/\ \ \ \ \ \ \/\ \/\ \/\ \L\ \  
    /\_______\\ \____/ \ \____/        \ \____/\ \__/.\_\ \____\\ \_\ \_\ \_\ \_\ \_\ \____ \ 
    \/_______/ \/___/   \/___/   _______\/___/  \/__/\/_/\/____/ \/_/\/_/\/_/\/_/\/_/\/___L\ \
                                /\______\                                              /\____/
                                \/______/                                              \_/__/ 
								
Based on NOU_Cache originally written for MSO, modified and redistributed with permission from NOU.
Today, 06:27 PM (5/2/2014)
NouberNou
Re: Nou_Caching
"Do whatever you please with it, I barely had any contribution to the MSO module besides the original proof of concept a long time ago.  No need to attribute in any special way."

 Code had credit to Nou ---> "// Thanks to Nou for this code" in MSO commit 743cfe7f169602b707e6c61488db15cd85992d05 in which I have his explicit permission to modify and redistribute. If explicit permission from original author is invalid, MSO's Apache license applies.

Exceptions:
Vehicle caching FSM - Inspired by CEP_Caching
*/

//Config switches call: [1000,true]execvm "ZBE_Caching\main.sqf"; in init.sqf
ZBE_cache_dist = _this select 0;
ZBE_cache_debug = _this select 1;
ZBE_cache_vehicle = _this select 2;

//Caching functions
ZBE_cached = 0;
ZBE_suspended = 0;
ZBE_stats = "";

ZBE_cacheGroup = {
        
        if(!(_this getVariable ["Cached", false])) then {
                _this setVariable ["Cached", true];
                {

        private["_pos"];
        if(_x != leader _this && {!(isPlayer _x)} && {!("driver" in assignedVehicleRole _x)}) then {
                _x disableAI "TARGET";
                _x disableAI "AUTOTARGET";
                _x disableAI "MOVE";
                _x disableAI "ANIM";
                _x disableAI "FSM";
                _x setSpeedMode "FULL"; //Fix for leader walking (slow) after his buddies are cached
                _x enableSimulation false;
                _x allowDamage false;
				_x hideobject true;
		if (vehicle _x == _x) then {
	                _pos = getPosATL _x;
        	        _pos set [2, -100];
	                _x setPosATL _pos;
		};
                ZBE_cached = ZBE_cached + 1;
	} else {
                _x allowDamage true;
				_x hideobject false;
                _x enableSimulation true;
                _x setSpeedMode "NORMAL"; //Fix for leader walking (slow) after his buddies are cached
                _x enableAI "TARGET";
                _x enableAI "AUTOTARGET";
                _x enableAI "MOVE";
                _x enableAI "ANIM";
                _x enableAI "FSM";
        };
				
                } forEach units _this;
                if (ZBE_cache_debug) then {publicVariable "ZBE_cached";};
        };
};

ZBE_uncacheGroup = {
        
        if(_this getVariable ["Cached",true]) then {
                _this setVariable ["Cached", false];
                {
        if(_x != leader _this && {!(isPlayer _x)} && {!("driver" in assignedVehicleRole _x)}) then {

		if (vehicle _x == _x) then {
	                _x setPosATL (formationPosition _x);
		};
                [_x]spawn {sleep 3;(_this select 0) allowDamage true;};//Spawned AI on leader dropped to death on inclines. This short sleep should be enough for uncached units to drop to ground without dying. Put in a spawn as to not halt function execution, performance impact should be minimal.
                _x enableSimulation true;
				_x hideobject false;
                _x setSpeedMode "NORMAL";
                _x enableAI "TARGET";
                _x enableAI "AUTOTARGET";
                _x enableAI "MOVE";
                _x enableAI "ANIM";
                _x enableAI "FSM";

                                if(ZBE_cached > 0) then {ZBE_cached = ZBE_cached - 1;};
                        };
                } forEach units _this;
                if (ZBE_cache_debug) then {publicVariable "ZBE_cached";};
        };
};

ZBE_syncleader = {
if (!(simulationEnabled (leader _this))) then {
	private ["_x"];
	_x = leader _this;

        _x allowDamage true;
        _x enableSimulation true;
        _x hideobject false;        
        _x enableAI "TARGET";
        _x enableAI "AUTOTARGET";
        _x enableAI "MOVE";
        _x enableAI "ANIM";
        _x enableAI "FSM";
if (ZBE_cache_debug) then {
player sidechat format ["Synced %1 TL!",_x];
};
};
};

ZBE_suspendGroup = {
        
        if(!(_this getVariable ["Suspended", false])) then {
                _this setVariable ["Suspended", true];
                {
                        _x enableSimulation false;
                        ZBE_suspended = ZBE_suspended + 1;
                } forEach units _this - [leader _this];
        };
};

ZBE_unsuspendGroup = {
        
        if(_this getVariable ["Suspended", true]) then {
                _this setVariable ["Suspended", false];
                {
                        _x enableSimulation true;
                        if(ZBE_suspended > 0) then {ZBE_suspended = ZBE_suspended - 1;};
                } forEach units _this - [leader _this];
        };
};

ZBE_deleteunitsnotleaderfnc = {
{
deleteVehicle _x;
} forEach units _this - [leader _this];
};

ZBE_deleteunitsnotleader = {
{
_x call ZBE_deleteunitsnotleaderfnc;
} forEach allGroups;
};

ZBE_closestUnit = {
        
        private["_units", "_unit", "_dist", "_udist"];
        _units = _this select 0;
        _unit = _this select 1;
        _dist = 10^5;
        
        {
                _udist = _x distance _unit;
                if (_udist < _dist) then {_dist = _udist;};
        } forEach _units;
        _dist;
};

ZBE_triggerUnits = {
        
        private ["_ZBE_leader","_trigUnits"];
        _ZBE_leader = _this select 0;
        _trigUnits = [];
        {
                if ((((side _x) getFriend (side _ZBE_leader)) <= 0.6)) then {
                        _trigUnits set [count _trigUnits, leader _x];
                };
        } forEach allGroups;
        _trigUnits = _trigUnits + ([] call BIS_fnc_listPlayers);
        _trigUnits;
};

ZBE_los = {
//code for line of sight check WIP
};

fn_centerpos = {
private ["_center","_return"];
switch toLower(worldName) do {		
        case "altis": {
		_return = [15101.8,16846.1,0.00143814];
        };
		default {
		_center = getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition");
        _return = _center;
        };
	};
_return;
};

waitUntil{typeName allGroups == "ARRAY"};
waitUntil{typeName allUnits == "ARRAY"};
waitUntil{typeName playableUnits == "ARRAY"};

//Client loop
if(!isServer) then {
        diag_log format["%1 ZBE Caching (%2) Starting", time, name player];
[] spawn  {
while {true} do {
                {
                        private["_closest"];
                        _closest = [units player, leader _x] call ZBE_closestUnit;
                        if (_closest > (ZBE_cache_dist * 1.1)) then {
                                _x call ZBE_suspendGroup;
                        };
                        
                        if (_closest < ZBE_cache_dist) then {
                                _x call ZBE_unsuspendGroup;
                        };
                } forEach allGroups;
                
                if(ZBE_cache_debug) then {if(ZBE_stats != format["%1 Groups %2/%3/%4 All/Suspended/Cached Units %5/%6 All/Cached Vehicles", count allGroups, count allUnits, ZBE_suspended, ZBE_cached, allvehicleszbe, allvehiclescachedzbe]) then {
                        ZBE_stats = format["%1 Groups %2/%3/%4 All/Suspended/Cached Units %5/%6 All/Cached Vehicles", count allGroups, count allUnits, ZBE_suspended, ZBE_cached, allvehicleszbe, allvehiclescachedzbe];
                        diag_log format["%1 ZBE Caching (%2) # %3", time, name player, ZBE_stats];
                        hint format["%1 ZBE Caching # %2", time, ZBE_stats];};};  
			sleep 0.01;						
        };
		};
};
//Server loop
if(isServer) then {
        diag_log format["%1 ZBE Caching (%2) Starting", time,"SERVER"];
[]spawn {
while {true} do {
                {
                        private["_closest"];
                        _closest = [([leader _x] call ZBE_triggerUnits), leader _x] call ZBE_closestUnit;
                        //if (diag_fps < 40 && {_closest > (ZBE_cache_dist * 1.1)}) then {
						if (_closest > (ZBE_cache_dist * 1.1)) then {
                                _x call ZBE_cacheGroup;
                        }; //No use caching units if serverFPS is greater then 40. Also used lazy eval for some more performance savings.
                        
                        if (_closest < ZBE_cache_dist) then {
                                _x call ZBE_uncacheGroup;
                        }; //Needs to uncache regardless of server FPS.
								_x call ZBE_syncleader; //Resyncs group leader if one dies (uncaches)
                } forEach allGroups;
                
                if(ZBE_cache_debug) then {if(ZBE_stats != format["%1 Groups %2/%3 Active/Cached Units %4/%5 All/Cached Vehicles", count allGroups, (count allUnits) - ZBE_cached, ZBE_cached,allvehicleszbe, allvehiclescachedzbe]) then {
                        ZBE_stats = format["%1 Groups %2/%3 Active/Cached Units %4/%5 All/Cached Vehicles", count allGroups, (count allUnits) - ZBE_cached, ZBE_cached,allvehicleszbe, allvehiclescachedzbe];
                        diag_log format["%1 ZBE Caching (%2) # %3", time,"SERVER", ZBE_stats];
                        hint format["%1 ZBE Caching # %2", time, ZBE_stats];};}; //A bit spammy to the RPT. May add ZBE_cache_debug switch later on.
						sleep 0.01;
                };       
    };
};

//Vehicle Caching Alpha inspired by CEP_Caching
allvehicleszbe = 0;
allvehiclescachedzbe = 0;
[ZBE_cache_vehicle, 0] spawn {
private ["_timex","_Dist","_dly","_assets"];
zbe_cached_vehs = [];
	_Dist = _this select 0;
	_dly = _this select 1;
	while {true} do {
	_assets = (call fn_centerpos) nearEntities [["LandVehicle","Air","Ship"],50000];
		if(_dly > 0) then {sleep _dly;};
		{
			if !(_x in zbe_cached_vehs) then {
				zbe_cached_vehs = zbe_cached_vehs + [_x];
				if (isDedicated) then {} else {[_x, _Dist] execFSM "ZBE_Caching\zbe_vehiclecaching.fsm";};
			};
		} forEach _assets;

		{
			if (!(_x in _assets)) then {
				zbe_cached_vehs = zbe_cached_vehs - [_x];
			};
		} forEach zbe_cached_vehs;


		_timex = time + 25;
		allvehicleszbe = count _assets;
		waitUntil{time > _timex};
	};
};