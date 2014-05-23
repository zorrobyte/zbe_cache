_zbe_cache_dist = getnumber (configfile >> "ZBE_Cache_Key_Setting" >> "zbe_cache_dist");
_debug = getnumber (configfile >> "ZBE_Cache_Key_Setting" >> "zbe_cache_debug");
_zbe_cache_debug = false;
if (_debug == 1) then {_zbe_cache_debug = true} else {_zbe_cache_debug = false};
[_zbe_cache_dist,_zbe_cache_debug]execvm "zbe_cache\ZBE_Caching\main.sqf";