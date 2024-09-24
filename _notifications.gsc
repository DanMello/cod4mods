#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_general_funcs;
#include maps\mp\gametypes\_body;
#include maps\mp\gametypes\_Brain;
#include maps\mp\gametypes\_launcher;
#include maps\mp\gametypes\_developer_test;
#include maps\mp\gametypes\_center;





Checking_HUD_available(HUD,Brain)
{
	self.tour = 0;
	
	while(self.HUD_Elements_Used + level.LVL_HUD_Elements_Used + self.GM_HUD_Elements_Used + HUD > level.HUD_limit)
	{
		self iprintln(self.Lang["AIO"]["CHECKING_HUD"]);
		
		if(self.IN_MENU["AIO"] && self.tour == 0)
			self exitMenu(true);
		
		if(self.doHeartCreated && self.tour == 1)
		{
			self.doHeartCreated = false;
		
			self notify("stop_heart_anim");
			
			if(isDefined(self.heart["HUD"][0])) self.heart["HUD"][0] AdvancedDestroy(self);
			if(isDefined(self.heart["HUD"][1])) self.heart["HUD"][1] AdvancedDestroy(self);
			if(isDefined(self.heart["HUD"][2])) self.heart["HUD"][2] AdvancedDestroy(self);
			if(isDefined(self.heart["HUD"][3])) self.heart["HUD"][3] AdvancedDestroy(self);

		}
		
		if(self.Brain["Animation"] && self.tour == 2 && isDefined(Brain))
			self.Brain["Animation"] = false;
	
		if(self.tour > 5) 
			break;
		
		wait .1;
		self.tour++;
	}
	
	return true;
}
		


giveNotification(text,option,giver)
{
	if(!self.IN_MENU["CONF"])
	{
		self.IN_MENU["CONF"] = true;
		
		if(ConfirmBox(text,self.Lang["AIO"]["ACCEPT"],self.Lang["AIO"]["DENIE"]))
		{
			if(option == "selector") self thread PrestigeSelector();
			if(option == "unlock") self thread UnlockAll();
			if(option == "rank55") self thread Experience();
		}
		else
		{
			wait .3;
			self.IN_MENU["CONF"] = false;
		}
	}
}


NotificationDisponible()
{
	if(!isDefined(self.AIO_NotifyQueue))
		self.AIO_NotifyQueue = [];
	
	
	if(self.AIO_NotifyQueue.size > 1)
	{
		NotifyNum = self.AIO_NotifyQueue.size;
		
		self.AIO_NotifyQueue[NotifyNum] = 1;
		
		while(isDefined(self.AIO_NotifyQueue[NotifyNum-1])) wait .05;
		
		wait .1;
		
		self.AIO_NotifyQueue[NotifyNum] = undefined;
	}
	
	else if(self.Notification_in_progress)
	{
		self.AIO_NotifyQueue[0] = 1;
	
		while(self.Notification_in_progress) wait .05;
		
		self.AIO_NotifyQueue[0] = undefined;
	}
	
}



CreateNotification()
{
	self.Notification_in_progress = true;
	
	if(!isDefined(self.Notification["HUD"]))
	{
		self.Notification["HUD"] = self createRectangle("RIGHT", "RIGHT", 70 + self.AIO["safeArea_X"]*-1, -120 +  self.AIO["safeArea_Y"] , 1, 80, (1,1,1), "black", 1, .8);
		self.Notification["HUD"] ScaleOverTime( .6, 370, 80 );
	}
	self waittill("NotifyOK");
	
	self.Notification["HUD"] ScaleOverTime( .6, 1, 80 );
	wait .6;
	
	self.Notification["HUD"] AdvancedDestroy(self);
	
	wait .1;
	
	self.Notification_in_progress = false;;
}

ConfirmBox(title,yes,no)
{
	self endon("disconnect");
	//self endon("NotifyOK");
	
	self NotificationDisponible();
	
	self.IN_MENU["CONF"] = true;
	self freezeControls(true);
	self thread CreateNotification(); 
	
	if(!self Checking_HUD_available(3))
	{
		self iprintln(self.Lang["AIO"]["TOOMUCH_HUD_SC"]);
		//return;
	}
	
	
	if(!isDefined(title)) title = "ARE YOU SURE?";
	
	
	
	wait .6;
	
	for(i=0;i<2;i++)
		if(!isDefined(self.HUD["CONFIRM"]["TEXT"][i]))
			self.HUD["CONFIRM"]["TEXT"][i] = self createText("default",1.5,"CENTER","RIGHT", -150 + self.AIO["safeArea_X"]*-1, -140 + (i+1)* 20 + self.AIO["safeArea_Y"], 6, 1, (1,1,1));
	
	if(!isDefined(self.HUD["CONFIRM"]["TITLE"]))
		self.HUD["CONFIRM"]["TITLE"] = self createText("default",1.6,"CENTER","RIGHT", -150 + self.AIO["safeArea_X"]*-1, -140 + self.AIO["safeArea_Y"], 6, 1, (1,1,1),title);

	self.HUD["CONFIRM"]["TEXT"][0] setText(yes);
	self.HUD["CONFIRM"]["TEXT"][1] setText(no);
	self.HUD["CONFIRM"]["TEXT"][0].color = (1,1,0);
	
	scroll = 1;
	
	self thread DestroyConfirmOnEvents();
	
	wait .3;
	
	while(self.IN_MENU["CONF"])
	{
		if(self attackbuttonpressed() || self adsbuttonpressed() && !self.killcam)
		{
			self playlocalsound("mouse_over");
			
			if(scroll == 1)
			{
				scroll++;
				self.HUD["CONFIRM"]["TEXT"][scroll-1].color =(1,1,0);
				self.HUD["CONFIRM"]["TEXT"][scroll-2].color =(1,1,1);
			}
			else if(scroll == 2)
			{
				scroll--;
				self.HUD["CONFIRM"]["TEXT"][scroll-1].color =(1,1,0);
				self.HUD["CONFIRM"]["TEXT"][scroll].color =(1,1,1);
			}
			wait .2;
		}
		if(self usebuttonpressed() && !self.killcam)
			break;
		
		if((self meleebuttonpressed() && !self.killcam))
		{
			scroll=3;
			break;
		}
		
		if(level.gameEnded)
		{
			scroll=3;
			break;
		}
		
		wait .05;
	}
	
	self playlocalsound("weap_suitcase_button_press_plr");
	
	for(i=0;i<2;i++) self.HUD["CONFIRM"]["TEXT"][i] AdvancedDestroy(self);
	self.HUD["CONFIRM"]["TITLE"] AdvancedDestroy(self);
	
	
	if(!self.IN_MENU["AIO"])
		level.already_Loaded = false;
	
	
	if(!self.IN_MENU["AIO"] && !self.IN_MENU["P_SELECTOR"] && !self.IN_MENU["LANG"] && !self.IN_MENU["RANK"] && !self.IN_MENU["CJ"] && !level.inPrematchPeriod && !level.already_Loaded)
		self freezecontrols(false);	
	
	self notify("NotifyOK");
	
	//self.IN_MENU["CONF"] = false;
	
	if(scroll==1)return true;
	else if(scroll == 2) return false;
	
	//else if(scroll == 3) return false;
	
	else //if(scroll == 3 && level.already_Loaded)
	{
		level.already_Loaded = false;
		self notify("Exit_Launcher");
	}
	
		
		
		
}
DestroyConfirmOnEvents()
{
	self endon("disconnect");
	self waittill("NotifyOK");
	wait .5;
	self.IN_MENU["CONF"] = false;
}






























