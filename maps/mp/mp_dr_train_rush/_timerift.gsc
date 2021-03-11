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
#include maps\mp\gametypes\_hud_util;

main()
{
	thread rift_room_entrance();
	thread rift_entrance();
	thread rift_plat();
	thread rift_exit();
	thread rift_bounce();
	thread rift_checkpoint();
}

// resawn player to a specific platform
rift_checkpoint()
{
	trig = getEnt("secret_respawn", "targetname");
	ori = getEntArray("secret_plat_trig", "targetname");
	spawn = getEnt("rift_enter_ori", "targetname");

	while (true)
	{
		trig waittill("trigger", player);

		if (player.secret_plat[4])
		{
			player setOrigin(ori[4].origin);
			player setPlayerAngles((0, 180, 0));
		}
		else if (player.secret_plat[1])
		{
			player setOrigin(ori[1].origin);
			player setPlayerAngles((0, 90, 0));
		}
		else if (player.secret_plat[2])
		{
			player setOrigin(ori[2].origin);
			player setPlayerAngles((0, 90, 0));
		}
		else if (player.secret_plat[3])
		{
			player setOrigin(ori[3].origin);
			player setPlayerAngles((0, 270, 0));
		}
		else if (player.secret_plat[0])
		{
			player setOrigin(ori[0].origin);
			player setPlayerAngles((0, 180, 0));
		}
		else
		{
			player setOrigin(spawn.origin);
			player setPlayerAngles(spawn.angles);
		}
	}
}

// rift bounce/boost init
rift_bounce()
{
	trig = getEntArray("secret_bounce", "targetname");
	ladder = getEnt("secret_boost", "targetname");

	// rift
	ladder thread rift_boost_do(9, 7);
	trig[0] thread rift_bounce_do(6, 0);
	trig[1] thread rift_bounce_do(6, 1);
	trig[2] thread rift_bounce_do(4, 2);
	trig[3] thread rift_bounce_do(2, 3);
	trig[4] thread rift_bounce_do(4, 4);
	trig[5] thread rift_bounce_do(4, 5);
	trig[6] thread rift_bounce_do(6, 6);

	// bounce room
	trig[7] thread rift_bounce_do(5, 7);
	trig[8] thread rift_bounce_do(5, 8);
}

// boost player trigger
rift_boost_do(power, j)
{
	while (true)
	{
		self waittill("trigger", p);
		if (!p.boosted)
			p thread rift_boost_player(self, power, j);
	}
}

// boost player code
rift_boost_player(trig, power, j)
{
	self endon("disconnect");
	self endon("death");

	self.boosted = true;
	if (self isTouching(trig))
	{
		for (i = 0; i < power; i++)
		{
			self.health += 1000;
			self finishPlayerDamage(self, self, 1000, 0, "MOD_PROJECTILE", "bh_mp", 
				self.origin, AnglesToForward((-90, 0, 0)), "none", 0);
		}
	}
	wait 5;
	self.boosted = false;
}

// bounce player trigger
rift_bounce_do(power,j)
{
	while (true)
	{
		self waittill("trigger", p);
		if (!p.bounced)
			p thread rift_bounce_player(self, power, j);
	}
}

// bounce player code
rift_bounce_player(trig, power, j)
{
	self endon("disconnect");
	self endon("death");

	self.bounced = true;
	if (self isTouching(trig))
	{
		vel = self.vel;
		if (vel[2] > -450)
		{
			for (i = 0; i < power; i++)
			{
				self.health += 1000;
				self finishPlayerDamage(self, self, 1000, 0, "MOD_PROJECTILE", "bh_mp", 
					self.origin, AnglesToForward((-90, 0, 0)), "none", 0);
			}
			wait 0.5;
			self.bounced = false;
			return;
		}
		self.health += 1000;
		setDvar("g_knockback", (vel[2] * -5));
		self finishPlayerDamage(self, self, 1000, 0, "MOD_UNKNOWN", "bounce", 
			self.origin, (0,0,1) , "none", 0);

		wait 0.05;
		setDvar("g_knockback", 1000);
	}
	wait 0.5;
	self.bounced = false;
}

// secret end
rift_exit()
{
	trig = getEnt("secret_end", "targetname");
	ori = getEnt("secret_end_ori", "targetname");

	while (true)
	{
		trig waittill("trigger", player);

		// @todo need atleast 2, different tp/xp for 2/3/4/5 junk
		if (player.secret_plat_count >= 5)
		{
			// iprintlnbold(player.name + " Finished the ^5Time Rift!");
			player notify("secret_finish");
			player setOrigin(ori.origin);
			player setPlayerAngles(ori.angles);
			// player braxi\_rank::giveRankXP("", 600);
			player.secret = false;
			player thread maps\mp\mp_dr_train_rush\_fx::forcedvar_once();
			if (isDefined(player.hud_time_secret))
				player.hud_time_secret Destroy();
			if (isDefined(player.sr_secret) && player.sr_secret)
				player thread braxi\_mod::endTimer();
		}
		else
			player setOrigin((1776, -9061, 25160));
	}
}

// rift platforms init
rift_plat()
{
	trig = getEntArray("secret_plat_trig", "targetname");
	on = getEntArray("secret_plat_on", "targetname");
	off = getEntArray("secret_plat_off", "targetname");

	for (i = 0; i < trig.size; i++)
	{
		on[i] hide();
		trig[i] thread rift_plat_do(trig[i], on[i], off[i], i);
		trig[i] thread rift_plat_fx(trig[i], on[i], off[i]);
	}
}

// rift platforms callback
rift_plat_do(trig, on, off, i)
{
	while (true)
	{
		trig waittill("trigger", player);
		switch (i)
		{
			case 0: if (!player.secret_plat[0]) { player.secret_plat[0] = true; player.secret_plat_count++; } break;
			case 1: if (!player.secret_plat[1]) { player.secret_plat[1] = true; player.secret_plat_count++; } break;
			case 2: if (!player.secret_plat[2]) { player.secret_plat[2] = true; player.secret_plat_count++; } break;
			case 3: if (!player.secret_plat[3]) { player.secret_plat[3] = true; player.secret_plat_count++; } break;
			case 4: if (!player.secret_plat[4]) { player.secret_plat[4] = true; player.secret_plat_count++; } break;
		}
		wait 0.2;
	}
}

// rift platforms effect loop
rift_plat_fx(trig, on, off)
{
	while (true)
	{
		trig waittill("trigger");

		off hide();
		on show();
		wait 0.5;

		off show();
		on hide();
		wait 0.5;
	}
}

// secret entrance trig
rift_entrance()
{
	trig = getEnt("rift_enter_trig", "targetname");
	ori = getEnt("rift_enter_ori", "targetname");

	while (true)
	{
		trig waittill("trigger",player);

		player setOrigin(ori.origin);
		player setPlayerAngles(ori.angles);
		player thread maps\mp\mp_dr_train_rush\_misc::music_loop(7);
		player thread maps\mp\mp_dr_train_rush\_misc::ondeath_music_playback();
		player.secret = true;
		player thread maps\mp\mp_dr_train_rush\_fx::forcedvar_once();
		player thread countdown();
		player thread getvel();
		player sr\api\_map::startSecret(); //Speedrun Copy Paste 
	}
}

// store player's velocity
getvel()
{
	self endon("death");
	self endon("disconnect");
	self endon("secret_finish");

	while (isDefined(self))
	{
		self.vel = self getVelocity();
		wait .05;
	}
}

// countdown hud init
countdown()
{
	self.hud_time_secret = newClientHudElem(self);
	self.hud_time_secret.foreground = true;
	self.hud_time_secret.alignX = "center";
	self.hud_time_secret.alignY = "top";
	self.hud_time_secret.horzAlign = "center";
	self.hud_time_secret.vertAlign = "top";
	self.hud_time_secret.x = 0;
	self.hud_time_secret.y = 0;
	self.hud_time_secret.sort = 0;
  	self.hud_time_secret.fontScale = 1.4;
	self.hud_time_secret.color = (1, 1, 1);
	self.hud_time_secret.glowAlpha = 1;
	self.hud_time_secret.font = "objective";
 	self.hud_time_secret.hidewheninmenu = true;
	self.hud_time_secret.alpha = 1;
	self.hud_time_secret.archived = false;

	self thread countdown_update();
}

// update player's countdown
countdown_update()
{
	self endon("death");
	self endon("disconnect");
	self endon("secret_finish");

	self.secret_countdown = 180; // 3min
	while (self.secret_countdown > 0)
	{
		self.hud_time_secret setText("^5" + self.secret_plat_count + "/5");
		// self.secret_countdown--;
		wait 1;
	}
	// self.hud_time_secret Destroy();
	// self suicide();
}

// near secret room entrance code
rift_room_entrance()
{
	trig = getEnt("rift_secret_entrance", "targetname");
	while (true)
	{
		trig waittill("trigger",player);
		player takeWeapon("claymore_mp");
		player thread maps\mp\mp_dr_train_rush\_misc::music_loop(8);
		player thread maps\mp\mp_dr_train_rush\_misc::ondeath_music_playback();
	}
}
