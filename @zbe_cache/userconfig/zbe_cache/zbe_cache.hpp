zbe_aiCacheDist = 1000; //At what distance is AI cached/uncached?
zbe_cache_debug = 1; //Debug hint/RPT? 1 on 0 off
zbe_vehicleCacheDist = 1000; //At what distance should empty vehicles cache/uncache? Note: vehicles with crew are automatically uncached. Vehicles are never hidden, this is for Physx/Arma simulation only. Recommend small values > 200
zbe_minFrameRate = -1;//If the FPS drops below this number, then prevent AI from uncaching. -1 is for suggested setting (if (isDedicated) then {_fps = 15} else {_fps = 30};).