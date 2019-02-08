class life_admin_menu {
	idd = 2900;
	name= "life_admin_menu";
	movingEnable = false;
	enableSimulation = true;
	onLoad = "[] spawn life_fnc_adminMenu;";

	class controlsBackground {
		class Life_RscTitleBackground: Life_RscText {
			colorBackground[] = {0.4, 0.05, 0.05, 0.7};
			idc = -1;
			x = 0.1;
			y = 0.2;
			w = 0.8;
			h = (1 / 25);
		};

		class MainBackground: Life_RscText {
			colorBackground[] = {0, 0, 0, 0.7};
			idc = -1;
			x = 0.1;
			y = 0.2 + (11 / 250);
			w = 0.8;
			h = 0.6 - (2 / 250);
		};
	};

	class controls {
		class Title: Life_RscTitle {
			colorBackground[] = {0, 0, 0, 0};
			idc = -1;
			text = "Asylum Admin Menu";
			x = 0.1;
			y = 0.2;
			w = 0.6;
			h = (1 / 25);
		};

		class PlayerList_Admin: Life_RscListBox {
			idc = 2902;
			text = "";
			sizeEx = 0.035;
			onLBSelChanged = "[_this] spawn life_fnc_adminQuery";
			x = 0.12;
			y = 0.26;
			w = 0.30;
			h = 0.4;
		};

		class PlayerBInfo: Life_RscStructuredText{
			idc = 2903;
			text = "";
			x = 0.42;
			y = 0.25;
			w = 0.35;
			h = 0.6;
		};

		class CycleUpdate: Life_RscButtonMenu {
			idc = -1;
			text = "Restart Update";
			onButtonClick = "[0, player] spawn life_fnc_srvCycAdjust;";
			x = -0.135 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
			y = 0.88 - (1 / 25);
			w = 0.23;
			h = (1 / 25);
		};

		class CycleHard: Life_RscButtonMenu {
			idc = -1;
			text = "Restart Hard";
			onButtonClick = "[1, player] spawn life_fnc_srvCycAdjust;";
			x = -0.135 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
			y = 0.92 - (1 / 25);
			w = 0.23;
			h = (1 / 25);
		};

		class CycleSoft: Life_RscButtonMenu {
			idc = -1;
			text = "Restart Soft";
			onButtonClick = "[2, player] spawn life_fnc_srvCycAdjust;";
			x = -0.135 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
			y = 0.96 - (1 / 25);
			w = 0.23;
			h = (1 / 25);
		};

		class Cycle60: Life_RscButtonMenu {
			idc = -1;
			text = "60 Minutes";
			onButtonClick = "[3, player] spawn life_fnc_srvCycAdjust;";
			x = 0.10 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
			y = 0.88 - (1 / 25);
			w = (6.25 / 40);
			h = (1 / 25);
		};

		class Cycle30: Life_RscButtonMenu {
			idc = -1;
			text = "30 Minutes";
			onButtonClick = "[4, player] spawn life_fnc_srvCycAdjust;";
			x = 0.10 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
			y = 0.92 - (1 / 25);
			w = (6.25 / 40);
			h = (1 / 25);
		};

		class Cycle10: Life_RscButtonMenu {
			idc = -1;
			text = "10 Minutes";
			onButtonClick = "[5, player] spawn life_fnc_srvCycAdjust;";
			x = 0.10 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
			y = 0.96 - (1 / 25);
			w = (6.25 / 40);
			h = (1 / 25);
		};

		class Cycle1: Life_RscButtonMenu {
			idc = -1;
			text = "1 Minute";
			onButtonClick = "[6, player] spawn life_fnc_srvCycAdjust;";
			x = 0.10 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
			y = 1.00 - (1 / 25);
			w = (6.25 / 40);
			h = (1 / 25);
		};

		class PlayerSpec: Life_RscButtonMenu {
			idc = 2101;
			text = "Spectate";
			onButtonClick = "[] call life_fnc_spec";
			x = 0.26 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
			y = 0.88 - (1 / 25);
			w = (6.25 / 40);
			h = (1 / 25);
		};

		class PJail: Life_RscButtonMenu {
			idc = 7331;
			text = "JAIL THEM";
			onButtonClick = "[true] call life_fnc_spec";
			x = 0.26 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
			y = 0.92 - (1 / 25);
			w = (6.25 / 40);
			h = (1 / 25);
		};

		class Ahidden: Life_RscButtonMenu {
			idc = 2103;
			text = "Invisible";
			onButtonClick = "[] call life_fnc_vis";
			x = 0.26 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
			y = 0.96 - (1 / 25);
			w = (6.25 / 40);
			h = (1 / 25);
		};

		class TeleSpot: Life_RscButtonMenu {
			idc = 2102;
			text = "Teleport";
			onButtonClick = "[false] call life_fnc_tp";
			x = 0.42 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
			y = 0.88 - (1 / 25);
			w = (6.25 / 40);
			h = (1 / 25);
		};

		class TpPlyr2Me: Life_RscButtonMenu {
			idc = 2104;
			text = "TPtoME";
			onButtonClick = "[true] call life_fnc_tp";
			x = 0.42 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
			y = 0.92 - (1 / 25);
			w = (6.25 / 40);
			h = (1 / 25);
		};

		class TpPlyrThem: Life_RscButtonMenu {
			idc = 1337;
			text = "TPtoTHEM";
			onButtonClick = "[true,true] call life_fnc_tp";
			x = 0.42 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
			y = 0.96 - (1 / 25);
			w = (6.25 / 40);
			h = (1 / 25);
		};

		class revTarg: Life_RscButtonMenu {
			idc = 1338;
			text = "Revive";
			onButtonClick = "[true] call life_fnc_vis";
			x = 0.58 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
			y = 0.88 - (1 / 25);
			w = (6.25 / 40);
			h = (1 / 25);
		};

		class CloseButtonKey: Life_RscButtonMenu {
			idc = -1;
			text = "Close";
			onButtonClick = "closeDialog 0;";
			colorText[] = { 1, 0, 0, 1 };
			x = 0.58 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
			y = 0.92 - (1 / 25);
			w = (6.25 / 40);
			h = (1 / 25);
		};
	};
};