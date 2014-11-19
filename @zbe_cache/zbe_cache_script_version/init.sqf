//[AI Cache Distance,FPS minimum for caching,Debug,Vehicle enablesimulation]execvm "zbe_cache\main.sqf";

//AI Cache Distance is the distance in which AI groups are cached

////If the FPS drops below this number, then prevent AI from uncaching. -1 is for suggested setting (if (isDedicated) then {_fps = 15} else {_fps = 30};)

//Debug will post to RPT and on screen useful ZBE_Cache metrics such as totalunits, cachedunits, totalvehicles, cachedvehicles

//Vehicle enablesimulation is the distance in which empty vehicles simulate to players and AI. I recommend low values such as 100 as even "cached" vehicles can still receive damage, blow up, pop tires and so on. This may not seem to do much at first glance but consider this: 2287 spawned empty vehicles results in 8FPS for client - with zbe caching FPS was 47.

//(group this) setVariable ["zbe_cacheDisabled",true] to disable cache for group at anytime. Can disable/enable even during mission runtime.

[1000,-1,true,1000]execvm "zbe_cache\main.sqf";