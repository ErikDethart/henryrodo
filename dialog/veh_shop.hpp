class Life_vehicle_shop {
	idd = 2300; 
	name= "life_vehicle_shop";
	movingEnable = false;
	enableSimulation = true;
	onLoad = "ctrlShow [2330,false];";
	
	class controlsBackground
	{
		class Life_RscTitleBackground : Life_RscText
		{
			colorBackground[] = {0.4, 0, 0, 0.7};
			idc = -1;
			x = 0.1;
			y = 0.2;
			w = 0.8;
			h = (1 / 25);
		};
		
		class MainBackground : Life_RscText
		{
			colorBackground[] = {0,0,0,0.7};
			idc = -1;
			x = 0.1;
			y = 0.2 + (11 / 250);
			w = 0.8;
			h = 0.7 - (22 / 250);
		};
		
		class Title : Life_RscTitle
		{
			idc = 2301;
			text = "";
			x = 0.1;
			y = 0.2;
			w = 0.8;
			h = (1 / 25);
		};
		
		class VehicleTitleBox : Life_RscText
		{
			idc = -1;
			text = "Available";
			colorBackground[] = {0.4, 0, 0, 0.7};
			x = 0.11; y = 0.26;
			w = 0.3;
			h = (1 / 25);
		};
		
		class VehicleInfoHeader : Life_RscText
		{
			idc = 2330;
			text = "Vehicle Information";
			colorBackground[] = {0.4, 0, 0, 0.7};
			x = 0.42; y = 0.26;
			w = 0.46;
			h = (1 / 25);
		};
		
		class CloseBtn : Life_RscButtonMenu
		{
			idc = -1;
			text = "Close";
			onButtonClick = "closeDialog 0;";
			x = -0.06 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
			y = 0.9 - (1 / 25);
			w = (6.25 / 40);
			h = (1 / 25);
		};
		
		class BuyCar : life_RscButtonMenu 
		{
			idc = 2309;
			text = "Buy";
			onButtonClick = "[false] spawn life_fnc_vehicleShopBuy;";
			x = 0.1 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
			y = 0.9 - (1 / 25);
			w = (6.25 / 40);
			h = (1 / 25);
		};
	};
	
	class controls
	{
		class VehicleList : Life_RscListBox
		{
			idc = 2302;
			text = "";
			sizeEx = 0.04;
			colorBackground[] = {0.1,0.1,0.1,0.9};
			onLBSelChanged = "_this call life_fnc_vehicleShopLBChange";
			
			//Position & height
			x = 0.11; y = 0.302;
			w = 0.303; h = 0.49;
		};
		
		class ColorList : Life_RscCombo
		{
			idc = 2304;
			x = 0.11; y = 0.8;
			w = 0.303; h = 0.03;
		};
		
		class CBSecurity : Life_RscCheckbox
		{
			idc = 2355;
			x = 0.43; y = 0.792;
			w = 0.2; h = 0.04;
			strings[] = {No Alarm Installed};
			checked_strings[] = {Alarm Installed ($500)};
		};
		
		class vehicleInfomationList : Life_RscStructuredText
		{
			idc = 2303;
			text = "";
			sizeEx = 0.035;
			
			x = 0.43; y = 0.31;
			w = 0.5; h = 0.52;
		};
	};
};