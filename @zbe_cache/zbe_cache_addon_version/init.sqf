_zbe_aiCacheDist = getnumber (configfile >> "ZBE_Cache_Key_Setting" >> "zbe_aiCacheDist");
_zbe_vehicleCacheDistCar = getnumber (configfile >> "ZBE_Cache_Key_Setting" >> "zbe_vehicleCacheDistCar");
_zbe_vehicleCacheDistAir = getnumber (configfile >> "ZBE_Cache_Key_Setting" >> "zbe_vehicleCacheDistAir");
_zbe_vehicleCacheDistBoat = getnumber (configfile >> "ZBE_Cache_Key_Setting" >> "zbe_vehicleCacheDistBoat");
_zbe_debug = getnumber (configfile >> "ZBE_Cache_Key_Setting" >> "zbe_cache_debug");
_zbe_minFrameRate = getnumber (configfile >> "ZBE_Cache_Key_Setting" >> "zbe_minFrameRate");
_zbe_cache_debug = false;
if (_zbe_debug == 1) then {_zbe_cache_debug = true} else {_zbe_cache_debug = false};
if (isServer) then {[_zbe_aiCacheDist,_zbe_minFrameRate,_zbe_cache_debug,_zbe_vehicleCacheDistCar,_zbe_vehicleCacheDistAir,_zbe_vehicleCacheDistBoat]execvm "\zbe_cache_addon_version\zbe_cache\main.sqf"};