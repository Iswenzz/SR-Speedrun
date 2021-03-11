/*

  _|_|_|            _|      _|      _|                  _|            
_|        _|    _|    _|  _|        _|          _|_|    _|  _|_|_|_|  
  _|_|    _|    _|      _|          _|        _|    _|  _|      _|    
	  _|  _|    _|    _|  _|        _|        _|    _|  _|    _|      
_|_|_|      _|_|_|  _|      _|      _|_|_|_|    _|_|    _|  _|_|_|_|  

Map and GSC Made By SuX Lolz.

Steam: http://steamcommunity.com/profiles/76561198163403316/
Discord: https://discord.gg/76aHfGF
Youtube: https://www.youtube.com/channel/UC1vxOXBzEF7W4g7TRU0C1rw
Paypal: suxlolz@outlook.fr
Email Pro: suxlolz@outlook.fr

*/
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

main()
{
	VisionSetNaked("mp_dr_train_rush", 0);
	SetExpFog(50000, 2500, 0.6, 0.59, 0.1, 3);

	thread fx_world();
	thread junk();
	thread yarn();
	thread world_moving();
	thread rotate_train_wheels();
}

// move the world
world_moving()
{
	water = getEnt("water", "targetname");
	mountain = getEnt("mountain", "targetname");
	sand = getEnt("sand", "targetname");
	rail = getEnt("rail", "targetname");
	rocks = getEntArray("rocks", "targetname");
	wind = getEnt("fx_wind", "targetname");
	
	mountain thread maps\mp\mp_dr_train_rush\_misc::move("y", -30000, 25);
	for (i = 0; i < rocks.size; i++)
		rocks[i] thread maps\mp\mp_dr_train_rush\_misc::move("y", -30000, 10);
	
	while (true)
	{
		water moveY(-30000, 10);
		sand moveY(-30000, 10);
		rail moveY(-30000, 10);
		wind moveY(-30000, 10);
		wait 10;
	}
}

// vision & film tweaks
forcedvar_once()
{
	self endon("disconnect");

	if (self.secret)
	{
		self setClientDvar("r_fog", "1");
		self setClientDvar("r_glow", "1");
		self setClientDvar("sm_enable", "0");
		self setClientDvar("r_detail", "1");
		self setClientDvar("r_specular", "1");
		self setClientDvar("r_normal", "1");
		self setClientDvar("r_drawdecals", "1");
		self setClientDvar("r_drawsun", "0");
		self setClientDvar("r_specularmap", "2");
		self setClientDvar("r_dof_bias", "0.5");
		self setClientDvar("r_dof_enable", "1");
		self setClientDvar("r_dof_farblur", "0");
		wait 0.05;
		self setClientDvar("r_dof_farend", "7000");
		self setClientDvar("r_dof_farstart", "1000");
		self setClientDvar("r_dof_nearblur", "6");
		self setClientDvar("r_dof_nearend", "60");
		self setClientDvar("r_dof_nearstart", "10");
		self setClientDvar("r_dof_tweak", "1");
		self setClientDvar("r_dof_viewmodelend", "8");
		self setClientDvar("r_dof_viewmodelstart", "2");
		self setClientDvar("scr_dof_enable", "1");
		self setClientDvar("r_filmtweakcontrast", "1.2");
		self setClientDvar("r_filmtweaklighttint", "1.5 1.5 2");
		self setClientDvar("r_filmtweakdarktint", "1 1 1");
		wait 0.05;
		self setClientDvar("r_filmtweakbrightness", "0");
		self setClientDvar("r_filmtweakdesaturation", "0");
		self setClientDvar("r_filmtweakenable", "1");
		self setClientDvar("r_filmusetweaks", "1");
		self setClientDvar("r_blur", "0.5");
		self setClientDvar("r_glow_allowed", "1");
		self setClientDvar("r_glow_enable", "1");
		self setClientDvar("r_glowtweakenable", "0");
		self setClientDvar("r_glowusetweaks", "0");
	}
	if (!self.secret)
	{
		self setClientDvar("r_fog", "1");
		self setClientDvar("r_glow", "1");
		self setClientDvar("sm_enable"," 0");
		self setClientDvar("r_detail", "1");
		self setClientDvar("r_specular", "1");
		self setClientDvar("r_normal", "1");
		self setClientDvar("r_drawdecals", "1");
		self setClientDvar("r_drawsun", "0");
		self setClientDvar("r_specularmap", "3");
		wait 0.05;
		self setClientDvar("r_dof_bias", "0.5");
		self setClientDvar("r_dof_enable", "1");
		self setClientDvar("r_dof_farblur", "2.5");
		self setClientDvar("r_dof_farend", "7000");
		self setClientDvar("r_dof_farstart", "1000");
		self setClientDvar("r_dof_nearblur", "6");
		self setClientDvar("r_dof_nearend", "60");
		self setClientDvar("r_dof_nearstart", "10");
		self setClientDvar("r_dof_tweak", "1");
		self setClientDvar("r_dof_viewmodelend", "8");
		self setClientDvar("r_dof_viewmodelstart", "2");
		self setClientDvar("scr_dof_enable", "1");
		self setClientDvar("r_filmtweakcontrast", "1.4");
		wait 0.05;
		self setClientDvar("r_filmtweaklighttint", "1.9 1.6 1.4");
		self setClientDvar("r_filmtweakdarktint", "1.2 1.2 1.2");
		self setClientDvar("r_filmtweakbrightness", "0");
		self setClientDvar("r_filmtweakdesaturation", "0");
		self setClientDvar("r_filmtweakenable", "1");
		self setClientDvar("r_filmusetweaks", "1");
		self setClientDvar("r_blur", "0");
		self setClientDvar("r_glow_allowed", "1");
		self setClientDvar("r_glow_enable", "1");
		self setClientDvar("r_glowtweakenable", "0");
		self setClientDvar("r_glowusetweaks", "0");
	}
}

// reset film tweaks on death
dead_reset()
{
	self endon("disconnect");
	self waittill("death");
	self.settings_tweaks = undefined;
}

// get the right vision when speccing players
spec_tweak()
{
	self endon("disconnect");
	self notify("spec_tweak");
	wait 0.05;
	self endon("spec_tweak");
	self endon("spawned_player");

	self common_scripts\utility::waittill_any("death", "joined_spectator");
	wait 0.05;
	while (self.sessionstate != "playing")
	{
		player = self getspectatorClient();
		if (!isDefined(player))
		{
			wait 0.05;
			continue;
		}
		self watch_tweak(player);
		wait 0.1;
	}
}

// get the right vision when speccing players
watch_tweak(player)
{
	player endon("disconnect");
	self endon("disconnect");
	self endon("spawned_player");

	if (player.secret && !self.secret)
	{
		self.secret = true;
		self forcedvar_once();
	}
	else if (!player.secret && self.secret)
	{
		self.secret = false;
		self forcedvar_once();
	}
}

// collectable item
junk()
{
	junk_trig = getEntArray("junk_trig", "targetname");
	junk_bloom = getEntArray("junk_bloom", "targetname");
	junk = getEntArray("junk", "targetname");

	j = 3;
	for (i = 0; i < 2; i++)
	{
		junk[i] rotatePitch(30, 0.05);
		if (i != 1) // 1 = Secret Junk - we dont want the secret junk to be collectable
			junk_trig[i] thread junk_script(junk[i], j);

		wait 0.2;
		junk_bloom[j - 3] thread maps\mp\mp_dr_train_rush\_misc::rotate("yaw", 360, 3);
		junk_bloom[j - 2] thread maps\mp\mp_dr_train_rush\_misc::rotate("yaw", -360, 3);
		junk_bloom[j - 1] thread maps\mp\mp_dr_train_rush\_misc::rotate("roll", 270, 3);
		junk_bloom[j] thread maps\mp\mp_dr_train_rush\_misc::rotate("pitch", 270, 3);
		junk[i] thread maps\mp\mp_dr_train_rush\_misc::rotate("yaw", 270, 3);
		j += 4;
	}
}

// item script
junk_script(model, j)
{
	junk_bloom = getEntArray("junk_bloom", "targetname");

	self waittill("trigger", player);
	player braxi\_rank::giveRankXP("", 200);
	player playSound("get_junk");
	self delete();
	model delete();
	junk_bloom[j-3] delete();
	junk_bloom[j-2] delete();
	junk_bloom[j-1] delete();
	junk_bloom[j] delete();
}

// collectable item
yarn()
{
	yarn_trig = getEntArray("yarn_trig", "targetname");
	yarn_bloom = getEntArray("yarn_bloom", "targetname");
	yarn = getEntArray("yarn", "targetname");

	j = 3;
	for (i = 0; i < 7; i++)
	{
		yarn[i] rotatePitch(30, 0.05);
		yarn_trig[i] thread yarn_script(yarn[i], j);

		wait 0.2;
		yarn_bloom[j-3] thread maps\mp\mp_dr_train_rush\_misc::rotate("yaw", 360, 3);
		yarn_bloom[j-2] thread maps\mp\mp_dr_train_rush\_misc::rotate("yaw", -360, 3);
		yarn_bloom[j-1] thread maps\mp\mp_dr_train_rush\_misc::rotate("roll", 260, 3);
		yarn_bloom[j] thread maps\mp\mp_dr_train_rush\_misc::rotate("pitch", 360, 3);
		yarn[i] thread maps\mp\mp_dr_train_rush\_misc::rotate("yaw", 360, 3);
		j += 4;
	}
}

// item script
yarn_script(model, j)
{
	yarn_bloom = getEntArray("yarn_bloom", "targetname");

	self waittill("trigger",player);
	player braxi\_rank::giveRankXP("", 150);
	player playSound("get_shine");
	self delete();
	model delete();
	yarn_bloom[j-3] delete();
	yarn_bloom[j-2] delete();
	yarn_bloom[j-1] delete();
	yarn_bloom[j] delete();
}

// rotate train wheels init
rotate_train_wheels()
{
	r = getEntArray("rotate_train", "targetname");
	for (i = 0; i < r.size; i++)
		r[i] thread rotate_train_wheels_do();
}

// rotate train wheels loop
rotate_train_wheels_do()
{
	while (true)
	{
		self rotateRoll(360, 0.25);
		wait 0.25;
	}
}

// main effects
fx_world()
{
	dark_smoke = getEnt("fx_dark", "targetname");
	light_smoke = getEnt("fx_lightsmoke", "targetname");
	sfx_loop = getEntArray("sfx_loop", "targetname");
	sfx_loop_2 = getEntArray("sfx_loop_2", "targetname");
	fx = getEnt("rift_fx", "targetname");
	bubble = getEntArray("fx_bubble", "targetname");
	alert = getEntArray("fx_alert", "targetname");
	c = [];

	level waittill("round_started");

	playFX(level.fx_rift, fx.origin);
	// for (i = 0; i < sfx_loop.size; i++)
	// {
	// 	sfx_loop[i] playLoopSound("train_loop");
	// 	sfx_loop_2[i] playLoopSound("train_wind");
	// }
	for (i = 0; i < bubble.size; i++)
	{
		playFX(level.fx_bubble, bubble[i].origin);
		bubble[i] delete();
	}
	for (i = 0; i < alert.size; i++)
	{
		c[i] = spawnfx(level.fx_alert, alert[i].origin);
		c[i].angles = (alert[i].angles);
		triggerfx(c[i]);
		wait .05;
		alert[i] delete();
	}
	a = spawnfx(level.fx_smoke_dark, dark_smoke.origin);
	a.angles = (0, -90, 90);
	triggerfx(a);

	b = spawnfx(level.fx_smoke_light, light_smoke.origin);
	b.angles = (0, -90, 90);
	triggerfx(b);
}
