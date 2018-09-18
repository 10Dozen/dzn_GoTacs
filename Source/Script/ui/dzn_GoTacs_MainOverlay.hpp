////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by 10Dozen, v1.063, #Wexuqi)
////////////////////////////////////////////////////////
#define GUI_GRID_X	(0)
#define GUI_GRID_Y	(0)
#define GUI_GRID_W	(0.025)
#define GUI_GRID_H	(0.04)
#define GUI_GRID_WAbs	(1)
#define GUI_GRID_HAbs	(1)


class dzn_GoTacs_MainOverlay: RscControlsGroup
{
	idd = 134102;
	idc = 2200;
	x = -18.5 * GUI_GRID_W + GUI_GRID_X;
	y = -1.5 * GUI_GRID_H + GUI_GRID_Y;
	w = 77 * GUI_GRID_W;
	h = 22 * GUI_GRID_H;
	colorBackground[] = {0,0,0,0.75};

	class controls 
	{
		class IGUIBack_2200: IGUIBack
		{
			idc = 2200;
			x = -18.5 * GUI_GRID_W + GUI_GRID_X;
			y = -1.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 77 * GUI_GRID_W;
			h = 30 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.75};
		};

/*
		class dzn_GoTacs_AssignTeamsBtn: RscButtonMenu
		{
			idc = 2300;
			text = "Assign Teams"; //--- ToDo: Localize;
			x = 0 * GUI_GRID_W + GUI_GRID_X;
			y = -4.1 * GUI_GRID_H + GUI_GRID_Y;
			w = 8.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class dzn_GoTacs_AssignTeamList: RscCombo
		{
			idc = 2301;
			text = ""; //--- ToDo: Localize;
			x = 0 * GUI_GRID_W + GUI_GRID_X;
			y = -3 * GUI_GRID_H + GUI_GRID_Y;
			w = 8.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
*/

	};
};


/*

class dzn_GoTacs_TeamRedIcon_Label: RscStructuredText
{
	idc = 1100;
	x = 10.5 * GUI_GRID_W + GUI_GRID_X;
	y = -5 * GUI_GRID_H + GUI_GRID_Y;
	w = 5 * GUI_GRID_W;
	h = 3.5 * GUI_GRID_H;
	colorBackground[] = {1,0,0,1};
};
class dzn_GoTacs_TeamBlueIcon_Label: RscStructuredText
{
	idc = 1101;
	x = 16 * GUI_GRID_W + GUI_GRID_X;
	y = -5 * GUI_GRID_H + GUI_GRID_Y;
	w = 5 * GUI_GRID_W;
	h = 3.5 * GUI_GRID_H;
	colorBackground[] = {0,0,1,1};
};
class dzn_GoTacs_TeamGreenIcon_Label: RscStructuredText
{
	idc = 1102;
	x = 21.5 * GUI_GRID_W + GUI_GRID_X;
	y = -5 * GUI_GRID_H + GUI_GRID_Y;
	w = 5 * GUI_GRID_W;
	h = 3.5 * GUI_GRID_H;
	colorBackground[] = {0,1,0,1};
};
class dzn_GoTacs_TeamRedState_Label: RscStructuredText
{
	idc = 1103;
	text = "4 | ACE"; //--- ToDo: Localize;
	x = 10.5 * GUI_GRID_W + GUI_GRID_X;
	y = -1.5 * GUI_GRID_H + GUI_GRID_Y;
	w = 5 * GUI_GRID_W;
	h = 1 * GUI_GRID_H;
	colorBackground[] = {0,0,0,0};
};
class dzn_GoTacs_TeamBlueState_Label: RscStructuredText
{
	idc = 1104;
	text = "4 | ACE"; //--- ToDo: Localize;
	x = 16 * GUI_GRID_W + GUI_GRID_X;
	y = -1.5 * GUI_GRID_H + GUI_GRID_Y;
	w = 5 * GUI_GRID_W;
	h = 1 * GUI_GRID_H;
	colorBackground[] = {0,0,0,0};
};
class dzn_GoTacs_TeamGreenState_Label: RscStructuredText
{
	idc = 1105;
	text = "4 | ACE"; //--- ToDo: Localize;
	x = 21.5 * GUI_GRID_W + GUI_GRID_X;
	y = -1.5 * GUI_GRID_H + GUI_GRID_Y;
	w = 5 * GUI_GRID_W;
	h = 1 * GUI_GRID_H;
	colorBackground[] = {0,0,0,0};
};
class dzn_GoTacs_TeamRedOrder_Label: RscStructuredText
{
	idc = 1106;
	text = "WAIT"; //--- ToDo: Localize;
	x = 10.5 * GUI_GRID_W + GUI_GRID_X;
	y = -0.5 * GUI_GRID_H + GUI_GRID_Y;
	w = 5 * GUI_GRID_W;
	h = 1 * GUI_GRID_H;
	colorBackground[] = {0,0,0,0};
};
class dzn_GoTacs_TeamBlueOrder_Label: RscStructuredText
{
	idc = 1107;
	text = "WAIT"; //--- ToDo: Localize;
	x = 16 * GUI_GRID_W + GUI_GRID_X;
	y = -0.5 * GUI_GRID_H + GUI_GRID_Y;
	w = 5 * GUI_GRID_W;
	h = 1 * GUI_GRID_H;
	colorBackground[] = {0,0,0,0};
};
class dzn_GoTacs_TeamGreenOrder_Label: RscStructuredText
{
	idc = 1108;
	text = "WAIT"; //--- ToDo: Localize;
	x = 21.5 * GUI_GRID_W + GUI_GRID_X;
	y = -0.5 * GUI_GRID_H + GUI_GRID_Y;
	w = 5 * GUI_GRID_W;
	h = 1 * GUI_GRID_H;
	colorBackground[] = {0,0,0,0};
};


class CM1: RscStructuredText
{
	idc = 1109;
	x = 5 * GUI_GRID_W + GUI_GRID_X;
	y = 1 * GUI_GRID_H + GUI_GRID_Y;
	w = 1 * GUI_GRID_W;
	h = 1 * GUI_GRID_H;
};
class RscStructuredText_1110: RscStructuredText
{
	idc = 1110;
	text = "Combat Mode"; //--- ToDo: Localize;
	x = 0.5 * GUI_GRID_W + GUI_GRID_X;
	y = 1 * GUI_GRID_H + GUI_GRID_Y;
	w = 4 * GUI_GRID_W;
	h = 1 * GUI_GRID_H;
	colorBackground[] = {0,0,0,0};
};
class CM2: RscStructuredText
{
	idc = 1111;
	x = 6 * GUI_GRID_W + GUI_GRID_X;
	y = 1 * GUI_GRID_H + GUI_GRID_Y;
	w = 1 * GUI_GRID_W;
	h = 1 * GUI_GRID_H;
	colorBackground[] = {1,-1,-1,1};
};
class CM3: RscStructuredText
{
	idc = 1112;
	x = 7 * GUI_GRID_W + GUI_GRID_X;
	y = 1 * GUI_GRID_H + GUI_GRID_Y;
	w = 1 * GUI_GRID_W;
	h = 1 * GUI_GRID_H;
};
class CM4: RscStructuredText
{
	idc = 1113;
	x = 8 * GUI_GRID_W + GUI_GRID_X;
	y = 1 * GUI_GRID_H + GUI_GRID_Y;
	w = 1 * GUI_GRID_W;
	h = 1 * GUI_GRID_H;
	colorBackground[] = {1,-1,-1,1};
};
class CM5: RscStructuredText
{
	idc = 1114;
	x = 9 * GUI_GRID_W + GUI_GRID_X;
	y = 1 * GUI_GRID_H + GUI_GRID_Y;
	w = 1 * GUI_GRID_W;
	h = 1 * GUI_GRID_H;
};
class RscStructuredText_1115: RscStructuredText
{
	idc = 1115;
	text = "Combat Mode"; //--- ToDo: Localize;
	x = 13.16 * GUI_GRID_W + GUI_GRID_X;
	y = 1.81 * GUI_GRID_H + GUI_GRID_Y;
	w = 0.4 * GUI_GRID_W;
	h = 1.5 * GUI_GRID_H;
	colorBackground[] = {0,0,0,0};
};
class RscStructuredText_1116: RscStructuredText
{
	idc = 1116;
	text = "Behavior"; //--- ToDo: Localize;
	x = 11 * GUI_GRID_W + GUI_GRID_X;
	y = 1 * GUI_GRID_H + GUI_GRID_Y;
	w = 4 * GUI_GRID_W;
	h = 1 * GUI_GRID_H;
	colorBackground[] = {0,0,0,0};
};
class B1: RscStructuredText
{
	idc = 1117;
	x = 15 * GUI_GRID_W + GUI_GRID_X;
	y = 1 * GUI_GRID_H + GUI_GRID_Y;
	w = 1 * GUI_GRID_W;
	h = 1 * GUI_GRID_H;
};
class B2: RscStructuredText
{
	idc = 1118;
	x = 16 * GUI_GRID_W + GUI_GRID_X;
	y = 1 * GUI_GRID_H + GUI_GRID_Y;
	w = 1 * GUI_GRID_W;
	h = 1 * GUI_GRID_H;
	colorBackground[] = {1,-1,-1,1};
};
class B3: RscStructuredText
{
	idc = 1119;
	x = 17 * GUI_GRID_W + GUI_GRID_X;
	y = 1 * GUI_GRID_H + GUI_GRID_Y;
	w = 1 * GUI_GRID_W;
	h = 1 * GUI_GRID_H;
	colorBackground[] = {-1,1,-1,1};
};
class B4: RscStructuredText
{
	idc = 1120;
	x = 18 * GUI_GRID_W + GUI_GRID_X;
	y = 1 * GUI_GRID_H + GUI_GRID_Y;
	w = 1 * GUI_GRID_W;
	h = 1 * GUI_GRID_H;
	colorBackground[] = {1,-1,-1,1};
};
class B5: RscStructuredText
{
	idc = 1121;
	x = 19 * GUI_GRID_W + GUI_GRID_X;
	y = 1 * GUI_GRID_H + GUI_GRID_Y;
	w = 1 * GUI_GRID_W;
	h = 1 * GUI_GRID_H;
};
class RscStructuredText_1122: RscStructuredText
{
	idc = 1122;
	text = "Behavior"; //--- ToDo: Localize;
	x = 22.87 * GUI_GRID_W + GUI_GRID_X;
	y = 1.36 * GUI_GRID_H + GUI_GRID_Y;
	w = 0.4 * GUI_GRID_W;
	h = 4.5 * GUI_GRID_H;
	colorBackground[] = {0,0,0,0};
};
class RscStructuredText_1123: RscStructuredText
{
	idc = 1123;
	text = "Behavior"; //--- ToDo: Localize;
	x = 22.75 * GUI_GRID_W + GUI_GRID_X;
	y = 0.67 * GUI_GRID_H + GUI_GRID_Y;
	w = 0.4 * GUI_GRID_W;
	h = 4.5 * GUI_GRID_H;
	colorBackground[] = {0,0,0,0};
};
class RscStructuredText_1124: RscStructuredText
{
	idc = 1124;
	text = "Speed"; //--- ToDo: Localize;
	x = 21 * GUI_GRID_W + GUI_GRID_X;
	y = 1 * GUI_GRID_H + GUI_GRID_Y;
	w = 3.5 * GUI_GRID_W;
	h = 1 * GUI_GRID_H;
	colorBackground[] = {0,0,0,0};
};
class S1: RscStructuredText
{
	idc = 1125;
	x = 25 * GUI_GRID_W + GUI_GRID_X;
	y = 1 * GUI_GRID_H + GUI_GRID_Y;
	w = 1 * GUI_GRID_W;
	h = 1 * GUI_GRID_H;
};
class S2: RscStructuredText
{
	idc = 1126;
	x = 26 * GUI_GRID_W + GUI_GRID_X;
	y = 1 * GUI_GRID_H + GUI_GRID_Y;
	w = 1 * GUI_GRID_W;
	h = 1 * GUI_GRID_H;
	colorBackground[] = {1,-1,-1,1};
};
class S3: RscStructuredText
{
	idc = 1127;
	x = 27 * GUI_GRID_W + GUI_GRID_X;
	y = 1 * GUI_GRID_H + GUI_GRID_Y;
	w = 1 * GUI_GRID_W;
	h = 1 * GUI_GRID_H;
	colorBackground[] = {-1,1,-1,1};
};
class RscButtonMenu_2401: RscButtonMenu
{
	idc = 2401;
	text = "ICON ONLY"; //--- ToDo: Localize;
	x = -7.5 * GUI_GRID_W + GUI_GRID_X;
	y = 1 * GUI_GRID_H + GUI_GRID_Y;
	w = 7 * GUI_GRID_W;
	h = 1 * GUI_GRID_H;
};
class RscStructuredText_1128: RscStructuredText
{
	idc = 1128;
	text = "Squad HUD"; //--- ToDo: Localize;
	x = -7.5 * GUI_GRID_W + GUI_GRID_X;
	y = 0 * GUI_GRID_H + GUI_GRID_Y;
	w = 7 * GUI_GRID_W;
	h = 1 * GUI_GRID_H;
	colorBackground[] = {0,0,0,0};
};
class RscStructuredText_1129: RscStructuredText
{
	idc = 1129;
	text = "Contacts HUD"; //--- ToDo: Localize;
	x = -7.5 * GUI_GRID_W + GUI_GRID_X;
	y = 3 * GUI_GRID_H + GUI_GRID_Y;
	w = 7 * GUI_GRID_W;
	h = 1 * GUI_GRID_H;
	colorBackground[] = {0,0,0,0};
};
class RscButtonMenu_2402: RscButtonMenu
{
	idc = 2402;
	text = "ICON ONLY c"; //--- ToDo: Localize;
	x = -7.5 * GUI_GRID_W + GUI_GRID_X;
	y = 4 * GUI_GRID_H + GUI_GRID_Y;
	w = 7 * GUI_GRID_W;
	h = 1 * GUI_GRID_H;
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////


*/