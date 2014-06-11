class CfgPatches
{
	class ZBE_Cache
	{
		units[] = {};
		weapons[] = {};
		requiredVersion = 1.0;
		requiredAddons[] = {};
		author[] = {"zorrobyte"};

	};
};

class Extended_PostInit_EventHandlers
{
  ZBE_Cache_Post_Init = "ZBE_Cache_Post_Init_Var = [] execVM ""\zbe_cache\init.sqf""";
};

class ZBE_Cache_Key_Setting 
	{
	#include "\userconfig\zbe_cache\zbe_cache.hpp"
	};