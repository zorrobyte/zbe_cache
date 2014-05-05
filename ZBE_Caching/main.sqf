/*
 ________   ____     ____            ____                     __                              
/\_____  \ /\  _`\  /\  _`\         /\  _`\                  /\ \      __                     
\/____//'/'\ \ \L\ \\ \ \L\_\       \ \ \/\_\     __      ___\ \ \___ /\_\    ___      __     
     //'/'  \ \  _ <'\ \  _\L        \ \ \/_/_  /'__`\   /'___\ \  _ `\/\ \ /' _ `\  /'_ `\   
    //'/'___ \ \ \L\ \\ \ \L\ \       \ \ \L\ \/\ \L\.\_/\ \__/\ \ \ \ \ \ \/\ \/\ \/\ \L\ \  
    /\_______\\ \____/ \ \____/        \ \____/\ \__/.\_\ \____\\ \_\ \_\ \_\ \_\ \_\ \____ \ 
    \/_______/ \/___/   \/___/   _______\/___/  \/__/\/_/\/____/ \/_/\/_/\/_/\/_/\/_/\/___L\ \
                                /\______\                                              /\____/
                                \/______/                                              \_/__/ 
								
Based on NOU_Cache originally written for MSO, modified and redistributed with permission from NOU.
Today, 06:27 PM (5/2/2014)
NouberNou
Re: Nou_Caching
"Do whatever you please with it, I barely had any contribution to the MSO module besides the original proof of concept a long time ago.  No need to attribute in any special way."

Unless otherwise noted, ZBE_Caching is released under a CC BY-SA 4.0 license (http://creativecommons.org/licenses/by-sa/4.0/)

Credits:
Zorrobyte
NouberNou for original Nou_Cache
MSO team for supporting open source software (at one time) and improving NOU_Cache
The wonderful and sometimes irritating Arma Community
BIS for fixing the enablesimulation bug (but not for withholding how they fixed it) http://feedback.arma3.com/view.php?id=18451

If for any reason CC BY-SA 4.0/Apache is invalidated in your country, please see the following license agreement:

	DO WHAT THE FUCK YOU WANT TO LICENSE

                    Version 1, MAY 2014 

 Copyright (C) 2014 Zorrobyte <ubercomputers@gmail.com> 

 Everyone is permitted to copy and distribute verbatim or modified 
 copies of this software, and changing it is allowed as long 
 as the name is changed. 

            DO WHAT THE FUCK YOU WANT TO LICENSE 
   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION 
  0. If CC BY-SA 4.0 is invalid in your country then go to next line, else abide by http://creativecommons.org/licenses/by-sa/4.0/ .
  1. You just DO WHAT THE FUCK YOU WANT TO.
  2. It would be nice if you credited the authors of this work however if your country doesn't accept CC BY-SA 4.0 then I'd assume you have no legal system (or a shitty one) so no one could do anything about it anyway. However if you are some radical dude on an abandoned oil rig then invite me out sometime and I'll bring beer.
  3. I pity you.
  
 What does this all mean (in a nutshell)?
 1. Give credit to authors in any forum posts/release/readme in script/addon.
 2. Provide your code open source under the same license - REQUIRED (so others can use/modify your work and redistribute).
 3. Don't redistribute your derivatives (modifications) in such a way that makes it look like me or any of the authors endorse (approve of) your work.
 4. No warranties. I'm not responsible if my software/work is so awesome that you play all night and loose your job, etc. On the flip side, I'm not responsible if my software/work sucks so badly that it blows up your PC/Mac, causes Chuck Norris to become wimpy, causes a nuclear test in North Korea to be successful, etc. Use at your own risk.
 5. You have a right to release YOUR software/works under ANY license you see fit (just not THIS ONE or if YOU use THIS code in YOUR project). Arma is successful due to user made content and nothing stifles innovation more then closed source. I prefer to benefit others and release my works open source so others may benefit and learn from my works. If you don't want to open source then it is your right, I disagree but respect your decisions.
 6. Below code had credit to Nou ---> "// Thanks to Nou for this code" in MSO commit 743cfe7f169602b707e6c61488db15cd85992d05 in which I have his explicit permission to modify and redistribute. If explicit permission from original author is invalid (you are stoned/trying to troll), MSO's Apache license applies.
 7. Don't be a dick. I dev for Arma in good faith, for fun, to learn, to help others learn how to dev and to escape reality. I can give a shit less about "fame" or monetization of work. Check your motives before flaming and if you don't like my work, you are free to modify and redistribute long as you follow the CC BY-SA 4.0 license agreement.
 8. If you use this code in another project, such project must also be released under the same license. This is the beauty of open source, it's infectious.
*/

Loop_Funcs = [];

[] spawn {

                       if(!isDedicated) then {
                        waitUntil { player == player && alive player };
                };
                waitUntil {
		        private ["_f","_delta"];
                        {
                                if((count _x) > 0) then {
                                        _f = _x select 0;
                                        _delta = _x select 1;
                                        if(diag_tickTime >= _delta) then {
                                                [(_f select 2), _forEachIndex] call (_f select 0);
                                                _x set[1, diag_tickTime + (_f select 1)];
                                        };
                                };
                        } forEach Loop_Funcs;
                        false;
                };
       
};

remove_loop_handler = {
private ["_id"];
        _id = _this select 0;
        Loop_Funcs set[_id, []];
};

add_loop_handler = {
private ["_id","_forEachIndex","_return"];
_return = -1;
        _id = -1;
        {
                if((count _x) == 0) exitWith {
                        _id = _forEachIndex;
                };
        } forEach Loop_Funcs;
        if(_id == -1) then {
                _id = (count Loop_Funcs);
        };
        Loop_Funcs set[_id, [_this, 0]];
        _return = _id;

_return;
};

private ["_trigDist","_debug","_delay"];

_debug = false;

_trigDist = if(_debug) then {100} else {1000};
if(isNil "_this") then {_this = [];};
if(count _this > 0) then {
        _trigDist = _this select 0;
};
_delay = 0;
if(count _this > 1) then {
        _delay = _this select 1;
};
sleep _delay;

ZBE_cached = 0;
ZBE_suspended = 0;
ZBE_stats = "";

ZBE_cacheGroup = {
        
        if(!(_this getVariable ["Cached", false])) then {
                _this setVariable ["Cached", true];
                {
                        private["_pos"];
                        if(vehicle _x == _x) then {
				/*_x disableAI "TARGET";
				_x disableAI "AUTOTARGET";
				_x disableAI "MOVE";
				_x disableAI "ANIM";
				_x disableAI "FSM";*/
				_x hideobject true; //Fix for unit labels showing for "invisible" units
				//_x hideobjectglobal true;
				//_x setSpeedMode "FULL"; //Fix for leader walking (slow) after his buddies are cached
                                _x enableSimulation false;
								//_x enableSimulationglobal false;
                                _x allowDamage false; //May turn off additional simulation, unknown but won't hurt. "This command only works locally and must be run on all machines to have global affect." Shouldn't spam netcode https://community.bistudio.com/wiki/allowDamage. Also sets up the uncache allowdamage for respawned units not falling to death on inclines.
                                _pos = getPosATL _x;
                                _pos set [2, -2];
                                _x setPosATL _pos;
                                ZBE_cached = ZBE_cached + 1;
                        };
                } forEach units _this - [leader _this];
                publicVariable "ZBE_cached"; //PVAR for debug output? Seems a little wasteful for a release version. May add _debug switch later on.
        };
};

ZBE_uncacheGroup = {
        
        if(_this getVariable ["Cached",true]) then {
                _this setVariable ["Cached", false];
                {
                        private["_pos"];
                        if(vehicle _x == _x) then {
                                _x setPosATL (formationPosition _x);
                                _x enableSimulation true;
								_x enableSimulationglobal true;
								_x hideobject false; //Fix for unit labels showing for "invisible" units
								_x hideobjectglobal false;
								_x setSpeedMode "NORMAL"; //Fix for leader walking after his buddies are cached, sets back to "normal".
				_x enableAI "TARGET";
				_x enableAI "AUTOTARGET";
				_x enableAI "MOVE";
				_x enableAI "ANIM";
				_x enableAI "FSM";
				[_x]spawn {sleep 3;(_this select 0) allowDamage true;};//Spawned AI on leader dropped to death on inclines. This short sleep should be enough for uncached units to drop to ground without dying. Put in a spawn as to not halt function execution, performance impact should be minimal.

                                if(ZBE_cached > 0) then {ZBE_cached = ZBE_cached - 1;};
                        };
                } forEach units _this - [leader _this];
                publicVariable "ZBE_cached"; //PVAR for debug output? Seems a little wasteful for a release version. May add _debug switch later on.
        };
};

ZBE_suspendGroup = {
        
        if(!(_this getVariable ["Suspended", false])) then {
                _this setVariable ["Suspended", true];
                {
                        _x enableSimulation false;
                        ZBE_suspended = ZBE_suspended + 1;
                } forEach units _this - [leader _this];
        };
};

ZBE_unsuspendGroup = {
        
        if(_this getVariable ["Suspended", true]) then {
                _this setVariable ["Suspended", false];
                {
                        _x enableSimulation true;
                        if(ZBE_suspended > 0) then {ZBE_suspended = ZBE_suspended - 1;};
                } forEach units _this - [leader _this];
        };
};

ZBE_closestUnit = {
        
        private["_units", "_unit", "_dist", "_udist"];
        _units = _this select 0;
        _unit = _this select 1;
        _dist = 10^5;
        
        {
                _udist = _x distance _unit;
                if (_udist < _dist) then {_dist = _udist;};
        } forEach _units;
        _dist;
};

ZBE_triggerUnits = {
        
        private ["_ZBE_leader","_trigUnits"];
        _ZBE_leader = _this select 0;
        _trigUnits = [];
        {
                if ((((side _x) getFriend (side _ZBE_leader)) <= 0.6)) then {
                        _trigUnits set [count _trigUnits, leader _x];
                };
        } forEach allGroups;
        _trigUnits = _trigUnits + ([] call BIS_fnc_listPlayers);
        _trigUnits;
};

waitUntil{typeName allGroups == "ARRAY"};
waitUntil{typeName allUnits == "ARRAY"};
waitUntil{typeName playableUnits == "ARRAY"};

//TODO: Add vehicle caching, add into ZBE_suspendGroup/ZBE_unsuspendGroup functions?

if(!isServer) then {
        diag_log format["%1 ZBE Caching Client (%2) Starting", time, name player];
        [{
                private ["_params","_ZBE_cache_dist","_debug"];
                
                _params = _this select 0;
                _ZBE_cache_dist = _params select 0;
                _debug = _params select 1;
                {
                        private["_closest"];
                        _closest = [units player, leader _x] call ZBE_closestUnit;
                        if (_closest > (_ZBE_cache_dist * 1.1)) then {
                                _x call ZBE_suspendGroup;
                        };
                        
                        if (_closest < _ZBE_cache_dist) then {
                                _x call ZBE_unsuspendGroup;
                        };
                } forEach allGroups;
                
                if(ZBE_stats != format["%1 Groups %2/%3/%4 All/Suspended/Cached Units", count allGroups, count allUnits, ZBE_suspended, ZBE_cached]) then {
                        ZBE_stats = format["%1 Groups %2/%3/%4 All/Suspended/Cached Units", count allGroups, count allUnits, ZBE_suspended, ZBE_cached];
                        diag_log format["%1 ZBE Caching (%2) # %3", time, name player, ZBE_stats];
                        if(_debug) then {hint format["%1 ZBE Caching # %2", time, ZBE_stats];};
                };
                
        }, 1, [_trigDist, _debug]] call add_loop_handler;
};

if(isServer) then {
        diag_log format["%1 ZBE Caching Server (%2) Starting", time,"SERVER"];
        [{
                
                private ["_params","_ZBE_cache_dist","_debug"];
                
                _params = _this select 0;
                _ZBE_cache_dist = _params select 0;
                _debug = _params select 1;
                {
                        private["_closest"];
                        _closest = [([leader _x] call ZBE_triggerUnits), leader _x] call ZBE_closestUnit;
                        //if (diag_fps < 40 && {_closest > (_ZBE_cache_dist * 1.1)}) then {
						if (_closest > (_ZBE_cache_dist * 1.1)) then {
                                _x call ZBE_cacheGroup;
                        }; //No use caching units if serverFPS is greater then 40. Also used lazy eval for some more performance savings.
                        
                        if (_closest < _ZBE_cache_dist) then {
                                _x call ZBE_uncacheGroup;
                        }; //Needs to uncache regardless of server FPS.
                } forEach allGroups;
                
                if(ZBE_stats != format["%1 Groups %2/%3 Active/Cached Units", count allGroups, (count allUnits) - ZBE_cached, ZBE_cached]) then {
                        ZBE_stats = format["%1 Groups %2/%3 Active/Cached Units", count allGroups, (count allUnits) - ZBE_cached, ZBE_cached];
                        diag_log format["%1 ZBE Caching (%2) # %3", time,"SERVER", ZBE_stats];
                        if(_debug) then {hint format["%1 ZBE Caching # %2", time, ZBE_stats];};
				
                }; //A bit spammy to the RPT. May add _debug switch later on.
                
        }, 3, [_trigDist, _debug]] call add_loop_handler;
};
