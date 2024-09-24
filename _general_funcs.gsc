#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;


	
hudMoveY(y,time)
{
	self moveOverTime(time);
	self.y = y;
	wait time;
}

hudMoveX(x,time)
{
	self moveOverTime(time);
	self.x = x;
	wait time;
}

hudMoveXY(time,x,y)
{
	self moveOverTime(time);
	self.y = y;
	self.x = x;
}

hudFade(alpha,time)
{
	self fadeOverTime(time);
	self.alpha = alpha;
	wait time;
}

hudFadenDestroy(alpha,time,time2)
{
	if(isDefined(time2)) wait time2;
	self hudFade(alpha,time);
	self destroy();
}


CallLowerText(text,t)
{
	self setLowerMessage(text);
	wait t;
	self clearLowerMessage(1);
}
	
g(g){if(getDvar(g) == "1")return true;return false;}


isOdd(num)
{
	for(m = 1; m < 1000; m+=2)
		if(num == m)
			return true;
	return false;
}
  
 
ResetProperly()
{
	
	for(i=0;i<level.VisionDvars.size;i++)
		self setClientDvar(level.VisionDvars[i],level.VisionValues[i]);
	
	wait 1;
		
	for(i=0;i<level.VisionDvarsUndefined.size;i++)
		self setClientDvar(level.VisionDvarsUndefined[i],"");
		
	wait 1;
	
	if(level.script == "mp_convoy")
	{
		self setClientDvar("r_glowBloomIntensity0","");
		self setClientDvar("r_glowBloomIntensity1","");
		self setClientDvar("r_glowSkyBleedIntensity0","");
	}
	else if(level.script == "mp_backlot" || level.script == "mp_bloc" || level.script == "mp_bog" || level.script == "mp_countdown" || level.script == "mp_crash" || level.script == "mp_crossfire" || level.script == "mp_citystreet" || level.script == "mp_farm" || level.script == "mp_overgrown")
	{
		self setClientDvar("r_glowBloomIntensity0","0.25");
		self setClientDvar("r_glowBloomIntensity1","0.25");
		self setClientDvar("r_glowSkyBleedIntensity0","0.3");
	}
	else
	{
		self setClientDvar("r_glowBloomIntensity0","0.1");
		self setClientDvar("r_glowBloomIntensity1","0.1");
		self setClientDvar("r_glowSkyBleedIntensity0","0.1");	
	}

	
	self setClientDvar("r_lighttweaksunlight",level.LightTweakSunLightTOK[level.scriptNumber]);
	self setClientDvar("r_specularcolorscale",level.SpecularColorScaleTOK[level.scriptNumber]);
	self setClientDvar("r_lighttweaksuncolor",level.LightTweakSunColorTOK[level.scriptNumber]);
	self setClientDvar("r_lighttweaksundirection",level.LightTweakSunDirectionTOK[level.scriptNumber]);
}
   


resetDvars()
{	
	dvar = strTok("jump_height;g_gravity;player_sprintUnlimited;player_sustainAmmo;bg_fallDamageMinHeight;bg_fallDamageMaxHeight;player_sprintCameraBob;player_sprintSpeedScale;player_meleeRange;cg_scoreboardPingText;cg_scoresColor_Zombie;g_ai;cg_fov;cg_scoresColor_Player_0;cg_scoresColor_Player_1;cg_scoresColor_Player_2;cg_scoresColor_Player_3;cg_scoresColor_Transparency;cg_drawGun;cg_drawCrosshair;r_specularMap;ammoCounterHide;miniscoreboardhide;cg_drawOverHeadNames;cg_draw2d;r_flamefx_enable;cg_chatTime;con_gameMsgWindow0MsgTime;con_minicon;r_scaleViewport;cg_overHeadIconSize;timescale", ";");
	value = strTok("39;800;0;0;200;350;0.5;1.5;64;0;0.423529 0.00392157 0 1;1;65;0.490196 0.490196 0.101961 1;0.439216 0.2 0.219608 1;0.160784 0.721569 0.278437 1;0.160784 0.25098 0.180392 1;0.8;1;1;1;0;0;1;1;0;12000;5;0;1;.9;1", ";");
	for(m = 0; m < dvar.size; m++)
		self setClientDvar(dvar[m], value[m]);
}
  
   



getPart(b,string)
{
	for(a = string.size-1;a >= 0; a--) if(string[a] == b) break;
	return(getSubStr(string,a+1));
}
RemoveOneChar(string)
{
	return(getSubStr(string, 0, string.size-1));
}
getPartMoins(b,string)
{
	for(a = 0;	a<= string.size-1; a++) if(string[a] == b) break;
	return(getSubStr(string,0,a));
}


getONLYX_TYPE(string)
{
	for(i=  0;i < string.size; i++)
		if(string[i] == "_" && string[i+1] == "_")
			break;
			
	return(getSubStr(string, i+2));
}


elemMoveY(time, input){self moveOverTime(time);self.y=input;}
elemMoveX(time, input){self moveOverTime(time);self.x=input;}
elemFade(time,alpha){self fadeOverTime(time);self.alpha=alpha;}

DivideColor(a,b,c)
{
	return(a/255,b/255,c/255);
}

getMapName()
{
	switch(level.script)
	{
		case"mp_convoy": return "Ambush";
		case"mp_backlot": return "Backlot";
		case"mp_bloc": return "Bloc";
		case"mp_bog": return "Bog";
		case"mp_countdown": return "Countdown";
		case"mp_crash": return "Crash";
		case"mp_crossfire": return "Crossfire";
		case"mp_citystreets": return "District";
		case"mp_farm": return "Downpour";
		case"mp_pipeline": return "Pipeline";
		case"mp_strike": return "Strike";
		case"mp_vacant": return "Vacant";
		case"mp_shipment": return "Shipment";
		case"mp_cargoship": return "Wetwork";
	}
}
getGameType()
{
	switch(level.gametype)
	{
		case "dm": return "Free-for-all";
		case "sd": return "Search and destroy";
		case "dom": return "Domination";
		case "sab": return "Sabotage";
		case "tdm": return "Team deathmatch";
		case "hq": return "Headquarters";
	}
}


BeforeDestroy(Element)
{
	if(isDefined(Element)) self.HUD_Elements_Used--;
	
	Element destroy();
	
	 
}
AdvancedDestroy(player)
{
	player.HUD_Elements_Used--;
	self destroy();
}


createText(font, fontScale, align, relative, x, y, sort, alpha, color, text, glowcolor, glowalpha,server)
{
	if(!isDefined(server))
	self.HUD_Elements_Used++;
	
	if(isDefined(server))
		Elem = self createServerFontString(font, fontScale);
	else
		Elem = self createFontString(font, fontScale, self);
	
	Elem setPoint(align, relative, x, y);
	Elem.sort = sort;
	Elem.alpha = alpha;
	Elem.color = color;
	Elem.glowColor = glowcolor;
	Elem.glowAlpha = glowalpha;
	Elem setText(text);
	return Elem;
}
createRectangle(align, relative, x, y, width, height, color, shader, sort, alpha, server)
{
	if(isDefined(server))
	{
		Elem = newHudElem(self);
		level.LVL_HUD_Elements_Used++;
	}
	else
	{
		Elem = newClientHudElem(self);
		self.HUD_Elements_Used++;
	}
	
	Elem.elemType = "bar";
	
	if(!level.splitScreen)
	{
		Elem.x = -2;
		Elem.y = -2;
	}
	//Elem.hideWhenInMenu = true;
	Elem.width = width;
	Elem.height = height;
	Elem.align = align;
	Elem.relative = relative;
	Elem.xOffset = 0;
	Elem.yOffset = 0;
	Elem.children = [];
	Elem.sort = sort;
	Elem.color = color;
	Elem.alpha = alpha;
	Elem.shader = shader;
	Elem.horzAlign = "fullscreen";
	Elem.vertAlign = "fullscreen";
	Elem setParent(level.uiParent);
	Elem setShader(shader,width,height);
	Elem.hidden = false;
	Elem setPoint(align, relative, x, y);
	return Elem;
}

	
Create_Rectangle(C1,C2,align, relative, x, y, width, height, color, shader, sort, alpha)
{
	if(!isdefined(self.GM_HUD_Elements_Used))
	self.GM_HUD_Elements_Used = 0;
	
	
	self.GM_HUD_Elements_Used++;
	
	self.HUD_rect[C1][C2] = newClientHudElem(self);
	self.HUD_rect[C1][C2].elemType = "bar";
	self.HUD_rect[C1][C2].width = width;
	self.HUD_rect[C1][C2].height = height;
	self.HUD_rect[C1][C2].align = align;
	self.HUD_rect[C1][C2].relative = relative;
	self.HUD_rect[C1][C2].xOffset = 0;
	self.HUD_rect[C1][C2].yOffset = 0;
	self.HUD_rect[C1][C2].children = [];
	self.HUD_rect[C1][C2].sort = sort;
	self.HUD_rect[C1][C2].color = color;
	self.HUD_rect[C1][C2].alpha = alpha;
	self.HUD_rect[C1][C2].shader = shader;
	self.HUD_rect[C1][C2].horzAlign = "fullscreen";
	self.HUD_rect[C1][C2].vertAlign = "fullscreen";
	self.HUD_rect[C1][C2] setParent(level.uiParent);
	self.HUD_rect[C1][C2] setShader(shader,width,height);
	self.HUD_rect[C1][C2].hidden = false;
	self.HUD_rect[C1][C2] setPoint(align, relative, x, y);
}

Create_Text(C1,C2,font, fontScale, align, relative, x, y, sort, alpha, color, text, glowcolor, glowalpha)
{
	if(!isdefined(self.GM_HUD_Elements_Used))
	self.GM_HUD_Elements_Used = 0;
	
	self.GM_HUD_Elements_Used++;
	
	self.HUD_text[C1][C2] = self createFontString(font, fontScale, self);
	self.HUD_text[C1][C2] setPoint(align,relative);
	self.HUD_text[C1][C2].alpha = alpha;
	self.HUD_text[C1][C2].sort = sort;
	self.HUD_text[C1][C2].color = color;
	self.HUD_text[C1][C2].x = x;
	self.HUD_text[C1][C2].y = y;
	self.HUD_text[C1][C2].glowColor = glowcolor;
	self.HUD_text[C1][C2].glowAlpha = glowalpha;
	self.HUD_text[C1][C2] setText(text);	
}



getClan(joueur)
{
	name = joueur.name;
	
	if(name[0] != "[")
		return "";
	for(m = name.size-1; m >= 0; m--)
		if(name[m] == "]")
			break;
	return(getSubStr(name, 1, m));
}


getName(joueur)
{
	name = joueur.name;
	
	if(name[0] != "[") return name;
	for(a=name.size-1;a>=0;a--) if(name[a] == "]") break;
	return(getSubStr(name,a+1));
}