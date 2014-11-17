//[AI Cache Distance,FPS minimum for caching,Debug,Vehicle enablesimulation]execvm "zbe_cache\main.sqf";

//AI Cache Distance is the distance in which AI groups are cached and (optionally) client's objectdrawdistance (so they do not see AI cache/Uncache)

//FPS minimum for caching means that AI groups will not cache as long as FPS is above this number. Setting to -1 sets to predefined settings (if (isDedicated) then {_fps = 25} else {_fps = 45};).

//Debug will post to RPT and on screen useful ZBE_Cache metrics such as totalunits, cachedunits, totalvehicles, cachedvehicles

//Vehicle enablesimulation is the distance in which empty vehicles simulate to players and AI. I recommend low values such as 100 as even "cached" vehicles can still receive damage, blow up, pop tires and so on. This may not seem to do much at first glance but consider this: 2287 spawned empty vehicles results in 8FPS for client - with zbe caching FPS was 47.

//(group this) setVariable ["zbe_cacheDisabled",true] to disable cache for group at anytime. Can disable/enable even during mission runtime.

[1000,-1,true,100]execvm "zbe_cache\main.sqf";