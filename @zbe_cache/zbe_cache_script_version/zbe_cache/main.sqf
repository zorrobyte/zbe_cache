zbe_aiCacheDist = _this select 0;
zbe_minFrameRate = _this select 1;
zbe_debug = _this select 2;
zbe_vehicleCacheDist = _this select 3;

zbe_allGroups = 0;
zbe_cachedGroups = [];
zbe_cachedUnits = 0;
zbe_allVehicles = 0;
zbe_cachedVehicles = 0;
zbe_objectView = 0;

zbe_deleteunitsnotleaderfnc = {
{
deleteVehicle _x;
} forEach units _this - [leader _this];
};

zbe_deleteunitsnotleader = {
{
_x call zbe_deleteunitsnotleaderfnc;
} forEach allGroups;
};

zbe_centerPOS = {
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

[] spawn  {
while {true} do {
uisleep 5;	
		{
			_disable = _x getVariable "zbe_cacheDisabled";
			_disable = if(isNil "_disable") then { false; } else {_disable;};
			if (!_disable && !(_x in zbe_cachedGroups)) then {
				zbe_cachedGroups = zbe_cachedGroups + [_x];
				if (!isDedicated) then {[zbe_aiCacheDist,_x,zbe_minFrameRate,zbe_debug] execFSM "zbe_cache\zbe_aiCachingClient.fsm";} else {[zbe_aiCacheDist,_x,zbe_minFrameRate,zbe_debug] execFSM "zbe_cache\zbe_aiCachingDedicated.fsm";};
			};
		} forEach allGroups;
		};					
};

//Vehicle Caching Beta (for client FPS)
[] spawn {
private ["_assets"];
zbe_cached_vehs = [];
	while {true} do {
	_assets = (call zbe_centerPOS) nearEntities [["LandVehicle","Air","Ship"],50000];
		{
			if !(_x in zbe_cached_vehs) then {
				zbe_cached_vehs = zbe_cached_vehs + [_x];
				if (isDedicated) then {} else {[_x, zbe_vehicleCacheDist] execFSM "zbe_cache\zbe_vehicleCaching.fsm";};
			};
		} forEach _assets;

		{
			if (!(_x in _assets)) then {
				zbe_cached_vehs = zbe_cached_vehs - [_x];
			};
		} forEach zbe_cached_vehs;
		
		uiSleep 15;
		zbe_allVehicles = count _assets;
	};
};

[] spawn {
while {true} do {
uiSleep 15;
	if(zbe_debug) then {
    zbe_stats = format["%1 Groups %2/%3 All/Cached Units %4/%5 All/Cached Vehicles %6 FPS %7 ObjectDrawDistance", count allGroups, count allUnits, zbe_cachedUnits, zbe_allVehicles, zbe_cachedVehicles, (round diag_fps), zbe_objectView];
    diag_log format["%1 ZBE_Caching (%2) # %3", (round time), name player, zbe_stats];
    hintSilent format["%1 ZBE_Caching # %2", (round time), zbe_stats];};  
};
};
//Experimental, disabled for now
//if (!isDedicated) then {execFSM "zbe_cache\zbe_clientObjectDrawAuto.fsm";};