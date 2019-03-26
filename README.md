Description:
This caching script enablesimulation false & hideobject true all AI units but Team Leaders if players are not within X distance OR enemy AI units are not within X distance. Also empty vehicles are enablesimulation false if no unit near (including AI) allowing the mission dev to spawn thousands of vehicles with minimal server/client FPS drop.

Why?
I was toying with an ambient vehicle spawn script and found empty vehicles still simulated Physx on all clients and killed framerate when spawning 100s/1000s of vehicles. Also, AI caching greatly improves server performance in Co-Op if mission is heavy on AI.


Features:
Caches AI, all but teamleader so group still moves (tested: 25%+ FPS gain DUWS)
Caches empty vehicles (tested: 2385 vehicles 4 FPS no cache, 49 FPS cache)
Uncaches AI for players and other enemy AI groups
Compatible with virtually every addon and script (including HETMAN/HAL, bCombat, ASR_AI)
Per group/vehicle FSM which is performance friendly and fast
Enable/Disable caching for a specific group at anytime
Cached AI units in group are setPOS(moved) to TL's position so they can still receive damage from artillery, bombs, etc
Units that die while cached are uncached and removed from the caching loop
If the group leader dies while group is cached, the next group leader is uncached
Cached empty vehicles can still receive damage and display damage/explosions
Useful RPT/hintSilent debug option

Installation / Usage:
As a note if ran as an addon on server only, client's won't use empty vehicle caching. If your mission intends to have more then 100 empty vehicles, I strongly recommend using the script version!

Installation for Addon version:
Extract into the ArmA 3 Directory, by default this is located in:
32-Bit - C:\Program Files\Steam/Steamapps\Common\ArmA 3\
64-Bit - C:\Program Files (x86)\Steam/Steamapps\Common\ArmA 3\
After extraction it should look like this:
Steam\Steamapps\Common\ArmA 3\@your_mod_folder_name\addons\

You can also use the "Arma 3 Alpha" folder in your "My Documents" folder. Your folder setup could than look like for example this:
mydocuments\Arma3 Alpha\@your_mod_folder_name1\addons\
mydocuments\Arma3 Alpha\@your_mod_folder_name2\addons\
mydocuments\Arma3 Alpha\@your_mod_folder_name2\addons\

When present place the "userconfig" folder into your game install folder, usually:
"C:\Program Files (x86)\Steam\steamapps\common\Arma 3".
You may already have "userconfig" folder from other addons and/or mods in which case it is safe to merge the contents from this archive.

You'll also need to add a Launch Parameter to Steam, in order to do so right-click on ArmA 3 Alpha and click Properties and then Set Launch Options. In the window that opens enter in -mod=@your_mod_folder_name
For using multiple mods you would then do so like this:
-mod=@mod_name;@mod_name2;@mod_name3;@mod_name4;@mod_name5

Note:
You can also use -nosplash to get rid of the splash art and intro videos.

  

And of course you can also enable and disable community made addons and mods through the in-game Options Expansions menu if you do not want to mess with startup parameters!

When the above information still does not provide you with enough to learn how to install custom addons and mods you can always ask in our Guide On Installing Mods.

Installation for script version:
1. Extract contents of \@ZBE_Cache\zbe_cache_script_version to your mission folder. Do not overwrite your existing init.sqf if asked.
2. Open \@ZBE_Cache\zbe_cache_script_version\init.sqf and copy contents into \Documents\Arma 3\missions\missionName\init.sqf file.
3. Set desired options for ZBE_Cache in \Documents\Arma 3\missions\missionName\init.sqf.

Disable/Enable group caching:
Example for unit init from editor: (group this) setVariable ["zbe_cacheDisabled",true]
Broken down: *groupName* setVariable ["zbe_cacheDisabled",*true/false*]

Minimum FPS limiter:
Prevents AI from uncaching if FPS is below desired FPS. Even while the uncaching is being limited, the next group leader will uncache if the group leader dies.

Extras:
zbe_clientObjectDrawAuto.fsm is an experimental FSM to auto set client objectDrawDistance based on FPS and no higher than aiCachingRange so players will never see AI uncache. Please vote here if you would like this feature: http://feedback.arma3.com/view.php?id=21746

Testing
"ZBE 144 Groups, 1145 Units, 17 NoCacheFPS, 51 CachedFPS, 59 DeletedFPS"
C_Offroad_01_F drops FPS to 28 no ZBE_Cache vs 59 FPS ZBE_Cache (600+/- spawned)
DWUS (http://www.armaholic.com/page.php?id=21816) 20%+/- FPS improvement


Known issues:
Units inside vehicle do not cache due to A3 bug: A3 Issue Tracker
Report issues here


License:
ZBE_Caching by Zorrobyte is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
Based on a work at: https://bitbucket.org/zorrobyte/zbe_cache.
https://creativecommons.org/licenses/by-sa/4.0/


Changelog:
v4.6a
- Improved performance of sleep state condition to minimize operations per frame

v4.6
- Moved functions from FSM to zbe_functions.sqf with compilefinal
- Empty vehicle scanning set to 15 second sleep (instead of 5)
- Fixed cached AI and vehicle debug counts by using simulationEnabled (100% accurate now)
- Fixed Error 0 elements provided, 3 expected setPOS RPT spam
- Moved switchableUnits + playableUnits array to 15 second main.sqf loop instead of in FSM
- Added _trandomc/u variable in FSM for a randomized FSM sleep for less concurrent calculations
- Minimized evaluations for zbe_setPosLight/Full
- Fixed empty vehicle FSM as was using True conditions instead of conditions
- Fixed next leader uncache condition as was missing variable to set the new leader in the FSM causing it to loop constantly
- Removing dead is now higher priority in FSM

v4.5c
- Edited count vehicles to count "real vehicles" (discarding odd objects in the map) - Thanks to Zriel
- Introduced zbe_mapSide for counting nearentities in vehicles, boats and air...better performance in small maps (even in Altis, Original 0.095594MS vs NEW 0.0928986MS with 585 cars) - Thanks to Zriel
- Synced changes between Addon and Script version so they are now identical
- Tweaked sleep time between FSM state checking to combat suspected CPS drop

v4.5b
- Readded hideobjectglobal as if not when hits FPS limiter then cached units will glitch around
- Fixed empty vehicle arrays, now FSM only runs one time per vehicle instead of spamming FSM loops constantly
- Tabbed files
- Fixed allVehicle count
- Slight debug hint change

v4.4c
- Added per vehicle type caching distance setting (Car,Air,Boat)
- Fixed missing }; for script version
- Don't forget to update userconfig if using addon!

v4.4b
- Changed setPosASL back to setPos so units don't uncache outside buildings unexpectedly thanks to Zriel
- Improved debug readability thanks to whiztler
- Changed debug loop condition thanks to Pepe Hal
- Removed "Dedicated/Client" FSM segementation and now only using a single FSM for all as setPOS ran from multiple machines causes mayhem thanks to Zriel
- Stopped calling for map center's POS every loop thanks to Pepe Hal
- Empty vehicle caching is now called from isServer using enableSimulationGlobal
- Removed hideObject as no longer needed as units setPos to leader when cached
- Changed zbe_centerPOS function to one time call instead of function
- ZBE_Caching to ZBE_Cache for consistency
- There is now no difference between the addon vs script version and addon only needs to be ran on server
- CBA is no longer required, ever

v4.4a
- Fixed next leader uncache loop, was repeating indefinitely in some cases

v4.4
- Epicly faster performance! Rewrote cache and uncache conditions to be 25x faster. Now CPS is almost native to FPS (no more script lag). 144 groups 1153AI with 59.8CPS/60FPS
- Bumped -1 auto FPS values to 16 dedi 31 client for a target of 15/30
- Players continue to uncache always within distance set but now AI only uncache for other AI groups IF they are aware of each other (using findNearestEnemy). This keeps AI cached if they have nothing to shoot at and will lead to more overall AI being cached in AIvsAI missions
- Cache FSM now exits for player led AI groups

v4.3
- *Critical* FSM would not exit due to FSM condition states hating OR (||) and would loop forever causing poor performance over time and setPOS errors
- Added debug switches for cache start/stop/unit died while cached/synced TL. Baretail Arma's RPT file in \AppData\Local\Arma 3\*.rpt

v4.2
- Removed _orgSpeedMode (cleanup)
- SetPosATL to SetPos for RPT spam fix (Client: Object 14:32 (type Type_89) not found.)
- Resolved disableAI issue (did nothing) as was not implemented properly for dedicated server
- zbe_vehicleCaching.fsm now uses 500ms delay between checking conditions for less load
- Script version no longer uses enableSimulationGlobal/hideObjectGlobal to save packets as it is assumed it will be running on all localities. (Addon version still uses global commands so only the server can run addon, addon still doesn't do empty vehicle caching unless clients run addon as well)
- Updated empty vehicle caching to 1000m until per vehicletype distance is added
- Consumed 3 more cups of Earl Grey tea this version vs v4.1

v4.1
- ZBE_Cache no longer uses setSpeedMode, the AI in your missions will proceed as your waypoints intend.
- Changed setPos to setPos formationposition so group leaders move full speed (if speedMode "Normal"/"Full").
- Changed zbe_setPos to zbe_setPosLight and zbe_SetPosFull. Light setPos formationPosition, Full setPos formationPosition with 3 second allowdamage false so units don't die on inclines when uncached.
- zbe_aiCachingDedicated.fsm now uses disableai commands for additional performance savings. Client/Listen server does not as disableai can break animations

v4
- Created new directory and rewrote from scratch
- Caching now works per group using FSMs instead of iterating through allGroups array

v3
- Script only version for inclusion into missions
- No addon requirements (no more CBA)
- Players are no longer cached or teleported in any circumstances
- ZBE_Debug expanded to include more debug features
- Lazy evalulation used more often
- Manned vehicles now move as expected when cached due to "Driver" -> "driver" change, thanks to Wolfenswan

v2
- 
