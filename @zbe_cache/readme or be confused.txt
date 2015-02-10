 ________   ____     ____            ____                     __                              
/\_____  \ /\  _`\  /\  _`\         /\  _`\                  /\ \      __                     
\/____//'/'\ \ \L\ \\ \ \L\_\       \ \ \/\_\     __      ___\ \ \___ /\_\    ___      __     
     //'/'  \ \  _ <'\ \  _\L        \ \ \/_/_  /'__`\   /'___\ \  _ `\/\ \ /' _ `\  /'_ `\   
    //'/'___ \ \ \L\ \\ \ \L\ \       \ \ \L\ \/\ \L\.\_/\ \__/\ \ \ \ \ \ \/\ \/\ \/\ \L\ \  
    /\_______\\ \____/ \ \____/        \ \____/\ \__/.\_\ \____\\ \_\ \_\ \_\ \_\ \_\ \____ \ 
    \/_______/ \/___/   \/___/   _______\/___/  \/__/\/_/\/____/ \/_/\/_/\/_/\/_/\/_/\/___L\ \
                                /\______\                                              /\____/
                                \/______/                                              \_/__/ 
								
ZBE_Cache

License:
ZBE_Cache by Zorrobyte is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
Based on a work at https://bitbucket.org/zorrobyte/zbe_cache.
https://creativecommons.org/licenses/by-sa/4.0/

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
Option to prevent AI from uncaching if FPS lower then set
Useful RPT/hintSilent debug option

Requirements:
None. Use the script version to distribute in your missions or use the addon version only on the server.

Changelog is here:
http://forums.bistudio.com/showthread.php?179777-ZBE_Cache-AI-amp-Vehicle-caching-script-addon

Installation for Addon version:
1. UnZIP @ZBE_Cache into Arma 3 directory
2. Move userconfig folder into Arma 3 directory (\Arma 3\@ZBE_Cache\userconfig -> \Arma 3\userconfig
3. Set desired options in userconfig (\Arma 3\userconfig\zbe_cache\zbe_cache.cpp)
4. Play the game

Installation for script version:
1. Extract contents of \@ZBE_Cache\zbe_cache_script_version to your mission folder. Do not overwrite your existing init.sqf if asked.
2. Open \@ZBE_Cache\zbe_cache_script_version\init.sqf and copy contents into \Documents\Arma 3\missions\missionName\init.sqf file.
3. Set desired options for ZBE_Cache in \Documents\Arma 3\missions\missionName\init.sqf.

Disable/Enable group caching:
Example for unit init from editor: (group this) setVariable ["zbe_cacheDisabled",true]
Broken down: *groupName* setVariable ["zbe_cacheDisabled",*true/false*]

Minimum FPS limiter:
Prevents AI from uncaching if FPS is below desired FPS. This can break missions so if you have issues, set it to 0. In dedicated enviorments, I'd think the server staying below 15FPS may be a mission breaker anyway but up to you. Will uncache AI if/when FPS goes above setting if conditions meet to uncache.

Extras:
zbe_clientObjectDrawAuto.fsm is an experimental FSM to auto set client objectDrawDistance based on FPS and no higher than aiCachingRange so players will never see AI uncache. Please vote here if you would like this feature in a stable release: http://feedback.arma3.com/view.php?id=21746