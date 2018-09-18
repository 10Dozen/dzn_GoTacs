class CfgPatches
{
	class dzn_GoTacs
	{
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.1;
		requiredAddons[] = {"CBA_MAIN"};
		author[] = {"10Dozen"};
		version = "0.1";
	};
};

class Extended_PreInit_EventHandlers
{
	class dzn_GoTacs
	{
		init = call compile preprocessFileLineNumbers "\dzn_GoTacs\Init.sqf";
	};
};

#include "ui\dialog.hpp"
#include "ui\dzn_GoTacs_ManageMenu.hpp"
#include "ui\dzn_GoTacs_MainOverlay.hpp"
#include "ui\dzn_GoTacs_CommandOverlay.hpp"