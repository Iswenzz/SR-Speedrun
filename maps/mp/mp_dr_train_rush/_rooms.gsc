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
	thread games();

	thread room_setup("sniper_trig", "room_wep_jumper", "room_wep_activ", ::sniper_callback);
	thread room_setup("knife_trig", "room_wep_jumper", "room_wep_activ", ::knife_callback);
	thread room_setup("shotgun_trig", "room_wep_jumper", "room_wep_activ", ::shotgun_callback);
	thread room_setup("wavegun_trig", "room_wep_jumper", "room_wep_activ", ::wavegun_callback);
	thread room_setup("ppsh_trig", "room_wep_jumper", "room_wep_activ", ::ppsh_callback);
	thread room_setup("weapons_trig", "room_wep_jumper", "room_wep_activ", ::weapons_callback);
	thread room_setup("bounce_trig", "room_bounce_jumper", "room_bounce_activ", ::bounce_callback);

	thread bounce_gun();
	thread wep_respawn();
}

// create hud used when player enter a room
createhud(messages)
{
	hud_start = NewHudElem();
	hud_start.alignX = "center";
	hud_start.alignY = "middle";
	hud_start.horzalign = "center";
	hud_start.vertalign = "middle";
	hud_start.alpha = 1;
	hud_start.x = 0;
	hud_start.y = -150;
	hud_start.font = "objective";
	hud_start.fontscale = 2;
	hud_start.glowalpha = 1;
	hud_start.glowcolor = (1, 0, 0);
	hud_start setText(messages);
	hud_start SetPulseFX(100, 4000, 500);
	wait 7;

	if (isdefined(hud_start))
		hud_start destroy();
}

// setup a room with specified trigger, jumper/acti origin and room code callback
room_setup(t, j, a, callback)
{
	trig = getent(t, "targetname");
	jumper = getent(j, "targetname");
	acti = getent(a, "targetname");

	while (true)
	{
		trig waittill("trigger", player);
		// @todo
		if (!isDefined(level.activ))
			continue;

		// initial setup
		level.activ.health = 100;
		player.health = 100;
		player freezeControls(true);
		player setorigin(jumper.origin);
		player setPlayerAngles(jumper.angles);
		level.activ freezeControls(true);
		level.activ setorigin(acti.origin);
		level.activ setPlayerAngles(acti.angles);
		player takeallweapons();
		level.activ takeallweapons();

		// specific room script
		if (isDefined(callback))
			player thread [[callback]]();

		wait 4;

		player iprintlnbold("^1FIGHT !!!");
		level.activ iprintlnbold("^1FIGHT !!!");
		player freezeControls(false);
		level.activ freezeControls(false);
	}
}

// sniper room code
sniper_callback()
{
	self endon("disconnect");
	level.activ endon("disconnect");
	self endon("death");
	level.activ endon("death");

	thread createhud(self.name + " ^1Selected ^7Snipah7!");

	self thread maps\mp\mp_dr_train_rush\_misc::music_loop(6);
	self thread maps\mp\mp_dr_train_rush\_misc::ondeath_music_playback();
	level.activ thread maps\mp\mp_dr_train_rush\_misc::music_loop(6);
	level.activ thread maps\mp\mp_dr_train_rush\_misc::ondeath_music_playback();

	self.secret = true;
	level.activ.secret = true;
	self thread maps\mp\mp_dr_train_rush\_fx::forcedvar_once();
	level.activ thread maps\mp\mp_dr_train_rush\_fx::forcedvar_once();

	self giveweapon("m40a3_mp");
	level.activ giveweapon("m40a3_mp");
	self giveweapon("remington700_mp");
	level.activ giveweapon("remington700_mp");

	wait 4;

	self switchtoweapon("m40a3_mp");
	level.activ switchtoweapon("m40a3_mp");
	self givemaxammo("m40a3_mp");
	level.activ givemaxammo("m40a3_mp");
	self givemaxammo("remington700_mp");
	level.activ givemaxammo("remington700_mp");
}

// knife room code
knife_callback()
{
	self endon("disconnect");
	level.activ endon("disconnect");
	self endon("death");
	level.activ endon("death");

	thread createhud(self.name + " ^3Selected ^7Knife!");

	self thread maps\mp\mp_dr_train_rush\_misc::music_loop(6);
	self thread maps\mp\mp_dr_train_rush\_misc::ondeath_music_playback();
	level.activ thread maps\mp\mp_dr_train_rush\_misc::music_loop(6);
	level.activ thread maps\mp\mp_dr_train_rush\_misc::ondeath_music_playback();
	self.secret = true;
	level.activ.secret = true;
	self thread maps\mp\mp_dr_train_rush\_fx::forcedvar_once();
	level.activ thread maps\mp\mp_dr_train_rush\_fx::forcedvar_once();

	self giveweapon("knife_mp");
	level.activ giveweapon("knife_mp");

	wait 4;

	self switchtoweapon("knife_mp");
	level.activ switchtoweapon("knife_mp");
	self givemaxammo("knife_mp");
	level.activ givemaxammo("knife_mp");
}

// bounce room code
bounce_callback()
{
	self endon("disconnect");
	level.activ endon("disconnect");
	self endon("death");
	level.activ endon("death");

	thread createhud(self.name + " ^5Selected ^7Bounce!");

	self thread maps\mp\mp_dr_train_rush\_misc::music_loop(6);
	self thread maps\mp\mp_dr_train_rush\_misc::ondeath_music_playback();
	level.activ thread maps\mp\mp_dr_train_rush\_misc::music_loop(6);
	level.activ thread maps\mp\mp_dr_train_rush\_misc::ondeath_music_playback();
	self.secret = false;
	level.activ.secret = false;
	self thread maps\mp\mp_dr_train_rush\_fx::forcedvar_once();
	level.activ thread maps\mp\mp_dr_train_rush\_fx::forcedvar_once();

	self giveweapon("knife_mp");
	level.activ giveweapon("knife_mp");

	wait 4;

	self switchtoweapon("knife_mp");
	level.activ switchtoweapon("knife_mp");
	self givemaxammo("knife_mp");
	level.activ givemaxammo("knife_mp");
}

// wavegun room code
wavegun_callback()
{
	self endon("disconnect");
	level.activ endon("disconnect");
	self endon("death");
	level.activ endon("death");

	thread createhud(self.name + " ^5Selected ^7Wavegun!");

	self thread maps\mp\mp_dr_train_rush\_misc::music_loop(6);
	self thread maps\mp\mp_dr_train_rush\_misc::ondeath_music_playback();
	level.activ thread maps\mp\mp_dr_train_rush\_misc::music_loop(6);
	level.activ thread maps\mp\mp_dr_train_rush\_misc::ondeath_music_playback();
	self.secret = true;
	level.activ.secret = true;
	self thread maps\mp\mp_dr_train_rush\_fx::forcedvar_once();
	level.activ thread maps\mp\mp_dr_train_rush\_fx::forcedvar_once();

	self giveweapon("wavegun_mp");
	level.activ giveweapon("wavegun_mp");

	wait 4;

	self switchtoweapon("wavegun_mp");
	level.activ switchtoweapon("wavegun_mp");
	self givemaxammo("wavegun_mp");
	level.activ givemaxammo("wavegun_mp");
}

// ppsh room code
ppsh_callback()
{
	self endon("disconnect");
	level.activ endon("disconnect");
	self endon("death");
	level.activ endon("death");

	thread createhud(self.name + " ^1Selected ^7PPSH!");

	self thread maps\mp\mp_dr_train_rush\_misc::music_loop(6);
	self thread maps\mp\mp_dr_train_rush\_misc::ondeath_music_playback();
	level.activ thread maps\mp\mp_dr_train_rush\_misc::music_loop(6);
	level.activ thread maps\mp\mp_dr_train_rush\_misc::ondeath_music_playback();
	self.secret = true;
	level.activ.secret = true;
	self thread maps\mp\mp_dr_train_rush\_fx::forcedvar_once();
	level.activ thread maps\mp\mp_dr_train_rush\_fx::forcedvar_once();

	self giveweapon("p90_acog_mp");
	level.activ giveweapon("p90_acog_mp");

	wait 4;

	self switchtoweapon("p90_acog_mp");
	level.activ switchtoweapon("p90_acog_mp");
	self givemaxammo("p90_acog_mp");
	level.activ givemaxammo("p90_acog_mp");
}

// shotgun room code
shotgun_callback()
{
	self endon("disconnect");
	level.activ endon("disconnect");
	self endon("death");
	level.activ endon("death");

	thread createhud(self.name + " ^1Selected ^7Shotgun!");

	self thread maps\mp\mp_dr_train_rush\_misc::music_loop(6);
	self thread maps\mp\mp_dr_train_rush\_misc::ondeath_music_playback();
	level.activ thread maps\mp\mp_dr_train_rush\_misc::music_loop(6);
	level.activ thread maps\mp\mp_dr_train_rush\_misc::ondeath_music_playback();
	self.secret = true;
	level.activ.secret = true;
	self thread maps\mp\mp_dr_train_rush\_fx::forcedvar_once();
	level.activ thread maps\mp\mp_dr_train_rush\_fx::forcedvar_once();

	self giveweapon("olympia_mp");
	level.activ giveweapon("olympia_mp");

	wait 4;

	self switchtoweapon("olympia_mp");
	level.activ switchtoweapon("olympia_mp");
	self givemaxammo("olympia_mp");
	level.activ givemaxammo("olympia_mp");
}

// weapon room code
weapons_callback()
{
	self endon("disconnect");
	level.activ endon("disconnect");
	self endon("death");
	level.activ endon("death");

	thread createhud(self.name + " ^3Selected ^7Random Weapons!");
	weapons = strTok("m40a3_mp,g3_reflex_mp,m1014_mp,m14_mp,ak47_mp,mp5_acog_mp,ak47_gl_mp,g36c_silencer_mp,m1014_grip_mp,mp5_mp,gl_m14_mp,m60e4_mp,dragunov_mp,p90_acog_mp,rpg_mp,knife_mp", ",");
	r = randomInt(weapons.size);

	level.activ.health = 100;
	self.health = 100;
	self thread maps\mp\mp_dr_train_rush\_misc::music_loop(6);
	self thread maps\mp\mp_dr_train_rush\_misc::ondeath_music_playback();
	level.activ thread maps\mp\mp_dr_train_rush\_misc::music_loop(6);
	level.activ thread maps\mp\mp_dr_train_rush\_misc::ondeath_music_playback();
	self.secret = true;
	level.activ.secret = true;
	self thread maps\mp\mp_dr_train_rush\_fx::forcedvar_once();
	level.activ thread maps\mp\mp_dr_train_rush\_fx::forcedvar_once();

	self giveweapon(weapons[r]);
	level.activ giveweapon(weapons[r]);

	wait 4;

	self switchtoweapon(weapons[r]);
	level.activ switchtoweapon(weapons[r]);
	self givemaxammo(weapons[r]);
	level.activ givemaxammo(weapons[r]);
}

// mini game lobby room
games()
{
	level.games_trig = getEnt("minigames", "targetname");
	games = getEnt("minigames_ori", "targetname");

	while (true)
	{
		level.games_trig waittill("trigger", player);
		// if (!plugins\_respect::roomCheck(player))
		// 	continue;
		if (!isDefined(level.games_trig))
			return;

		player SetPlayerAngles(games.angles);
		player setOrigin(games.origin);
		iPrintlnBold(" ^1" + player.name + " ^7has ^3entered ^7the ^3game ^7selection !^5!^7!");
		player TakeAllWeapons();
		player thread maps\mp\mp_dr_train_rush\_misc::music_loop(5);
		player thread maps\mp\mp_dr_train_rush\_misc::ondeath_music_playback();
		player waitdead();

		while (isAlive(player) && isDefined(player))
			if (isDefined(level.activ) && isAlive(level.activ))
				wait 1;
	}
}

// minigame player ondeath
waitdead()
{
	self common_scripts\utility::waittill_any("death", "disconnect");
	level.activ freezeControls(false);

	iPrintlnBold("^3" + self.name + " ^7is ^1dead"); 
	iPrintlnBold("^3Selection ^7Room ^2is ^5now ^7open^1!!"); 
}

// bounce room give sniper loop
bounce_gun()
{
	trig = getEnt("room_bounce_wep", "targetname");
	trig SetHintString("^1Press ^7[^3USE^7] to get a ^1sniper.");

	while (true)
	{
		trig waittill("trigger", player);

		player giveweapon("m40a3_mp");
		player givemaxammo("m40a3_mp");
		player switchtoweapon("m40a3_mp");
	}
}

// respawn in weapon room
wep_respawn()
{
	trig = getEnt("room_wep_respawn", "targetname");
	jumper = getent("room_wep_jumper", "targetname");
	acti = getent("room_wep_activ", "targetname");

	while (true)
	{
		trig waittill("trigger", player);
		if (player == level.activ)
		{
			player setOrigin(acti.origin);
			player setPlayerAngles(acti.angles);
		}
		else
		{
			player setOrigin(jumper.origin);
			player setPlayerAngles(jumper.angles);
		}
	}
}
