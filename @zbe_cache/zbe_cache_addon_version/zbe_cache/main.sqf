if (!isServer) exitwith {};
zbe_aiCacheDist		 = _this select 0;
zbe_minFrameRate	 = _this select 1;
zbe_debug		 = _this select 2;
zbe_vehicleCacheDistCar	 = _this select 3;
zbe_vehicleCacheDistAir	 = _this select 4;
zbe_vehicleCacheDistBoat = _this select 5;

zbe_allGroups	   = 0;
zbe_cachedGroups   = [];
zbe_cachedUnits	   = 0;
zbe_allVehicles	   = 0;
zbe_cachedVehicles = 0;
zbe_objectView	   = 0;

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

switch toLower(worldName) do {
case "altis": {
	zbe_centerPOS = [15101.8, 16846.1, 0.00143814];
};
	default {
		zbe_centerPOS = getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition");
	};
};

[] spawn  {
	while {true} do {
		sleep 5;
		{
			_disable = _x getVariable "zbe_cacheDisabled";
			_disable = if (isNil "_disable") then { false;
				} else {_disable;
				};
			if (!_disable && !(_x in zbe_cachedGroups)) then {
					zbe_cachedGroups = zbe_cachedGroups + [_x];
					if (isServer) then { [zbe_aiCacheDist, _x, zbe_minFrameRate, zbe_debug] execFSM "\zbe_cache_addon_version\zbe_cache\zbe_aiCaching.fsm";
						};
				};
		} forEach allGroups;
	};
};

// Vehicle Caching Beta (for client FPS)
[] spawn {
	private ["_assetscar", "_assetsair", "_assetsboat"];
	zbe_cached_vehs = [];
	while {true} do {
		_assetscar = zbe_centerPOS nearEntities ["LandVehicle", 25000];
		{
			if !(_x in zbe_cached_vehs) then {
				zbe_cached_vehs = zbe_cached_vehs + [_x];
				if (isServer) then { [_x, zbe_vehicleCacheDistCar] execFSM "\zbe_cache_addon_version\zbe_cache\zbe_vehicleCaching.fsm";
					};
			};
		} forEach _assetscar;
		_assetsair = zbe_centerPOS nearEntities ["Air", 25000];
		{
			if !(_x in zbe_cached_vehs) then {
				zbe_cached_vehs = zbe_cached_vehs + [_x];
				if (isServer) then { [_x, zbe_vehicleCacheDistAir] execFSM "\zbe_cache_addon_version\zbe_cache\zbe_vehicleCaching.fsm";
					};
			};
		} forEach _assetsair;
		_assetsboat = zbe_centerPOS nearEntities ["Ship", 25000];
		{
			if !(_x in zbe_cached_vehs) then {
				zbe_cached_vehs = zbe_cached_vehs + [_x];
				if (isServer) then { [_x, zbe_vehicleCacheDistBoat] execFSM "\zbe_cache_addon_version\zbe_cache\zbe_vehicleCaching.fsm";
					};
			};
		} forEach _assetsboat;

		{
			if ((!(_x in _assetscar)) || (!(_x in _assetsair)) || (!(_x in _assetsboat)))then {
					zbe_cached_vehs = zbe_cached_vehs - [_x];
				};
		} forEach zbe_cached_vehs;
		zbe_allVehicles = count vehicles;
		sleep 15;
	};
};

[] spawn {
	if (zbe_debug) then {
			while {true} do {
				uiSleep 15;
				hintSilent parseText format ["
                <t color='#FFFFFF' size='1.5'>ZBE Caching</t><br/>
                <t color='#FFFFFF'>Debug data</t><br/><br/>
                <t color='#A1A4AD' align='left'>Game time in seconds:</t><t color='#FFFFFF' align='right'>%1</t><br/><br/>
                <t color='#A1A4AD' align='left'>Number of groups:</t><t color='#FFFFFF' align='right'>%2</t><br/>
                <t color='#A1A4AD' align='left'>All units:</t><t color='#FFFFFF' align='right'>%3</t><br/>
                <t color='#A1A4AD' align='left'>Cached units:</t><t color='#39a0ff' align='right'>%4</t><br/><br/>
                <t color='#A1A4AD' align='left'>All vehicles:</t><t color='#FFFFFF' align='right'>%5</t><br/>
                <t color='#A1A4AD' align='left'>Cached vehicles:</t><t color='#39a0ff' align='right'>%6</t><br/><br/>
                <t color='#A1A4AD' align='left'>FPS:</t><t color='#FFFFFF' align='right'>%7</t><br/><br/>
                <t color='#A1A4AD' align='left'>Obj draw distance:</t><t color='#FFFFFF' align='right'>%8</t><br/>
            ", (round time), count allGroups, count allUnits, zbe_cachedUnits, zbe_allVehicles, zbe_cachedVehicles, (round diag_fps), zbe_objectView];
				zbe_log_stats = format ["Groups: %1 # All/Cached Units: %2/%3 # All/Cached Vehicles: %4/%5 # FPS: %6 # ObjectDrawDistance: %7", count allGroups, count allUnits, zbe_cachedUnits, zbe_allVehicles, zbe_cachedVehicles, (round diag_fps), zbe_objectView];
				diag_log format ["%1 ZBE_Cache (%2) ---  %3", (round time), name player, zbe_log_stats];
			};
		};
};
// Experimental, disabled for now
// if (!isDedicated) then {execFSM "\zbe_cache_addon_version\zbe_cache\zbe_clientObjectDrawAuto.fsm";};