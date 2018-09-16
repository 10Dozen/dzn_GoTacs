////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by 10Dozen, v1.063, #Wexuqi)
////////////////////////////////////////////////////////
#define GUI_GRID_X	(0)
#define GUI_GRID_Y	(0)
#define GUI_GRID_W	(0.025)
#define GUI_GRID_H	(0.04)
#define GUI_GRID_WAbs	(1)
#define GUI_GRID_HAbs	(1)

class RscTitles {
	class dzn_GoTacs_CommandOverlay: RscControlsGroup
	{
		idd = 134103;
		idc = 2200;
		x = -18.5 * GUI_GRID_W + GUI_GRID_X;
		y = -1.5 * GUI_GRID_H + GUI_GRID_Y;
		w = 77 * GUI_GRID_W;
		h = 22 * GUI_GRID_H;
		colorBackground[] = {0,0,0,0.75};

		fadein = 0;
		fadeout = 0;
		duration = 99999990;

		onLoad = "_this call dzn_GoTacs_fnc_onLoadCommandOverlay"; 

		class controls 
		{
/*
			class dzn_GoTacs_CommandOverlay_Center: RscStructuredText
			{
				idc = 2201;
				x = 10.5 * GUI_GRID_W + GUI_GRID_X;
				y = -5 * GUI_GRID_H + GUI_GRID_Y;
				w = 5 * GUI_GRID_W;
				h = 3.5 * GUI_GRID_H;
				colorBackground[] = {0,0,0,0};
			};
*/

		};
	};

};