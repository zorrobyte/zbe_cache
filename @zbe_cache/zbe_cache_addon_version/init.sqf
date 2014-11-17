_zbe_aiCacheDist = getnumber (configfile >> "ZBE_Cache_Key_Setting" >> "zbe_aiCacheDist");
_zbe_vehicleCacheDist = getnumber (configfile >> "ZBE_Cache_Key_Setting" >> "zbe_vehicleCacheDist");
_zbe_debug = getnumber (configfile >> "ZBE_Cache_Key_Setting" >> "zbe_cache_debug");
_zbe_minFrameRate = getnumber (configfile >> "ZBE_Cache_Key_Setting" >> "zbe_minFrameRate");
_zbe_cache_debug = false;
if (_zbe_debug == 1) then {_zbe_cache_debug = true} else {_zbe_cache_debug = false};
[_zbe_aiCacheDist,_zbe_minFrameRate,_zbe_cache_debug,_zbe_vehicleCacheDist]execvm "\zbe_cache_addon_version\zbe_cache\main.sqf";