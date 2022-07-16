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

main()
{
	level.trap_8_alternate = true;
	level.ball = getEntArray("ball", "targetname");
	level.ball_damage = getEntArray("ball_damage", "targetname");
	level.ball_explode = getEntArray("ball_explode", "targetname");
	init_balls();

	thread trap1();
	thread trap2();
	thread trap3();
	thread trap4();
	thread trap5();
	thread trap6();
	thread trap7();
	thread trap8();
}

// setup a new trap with specified trig name and XP
setupTrap(trigname, xp)
{
	trig = getEnt(trigname, "targetname");
	trig waittill("trigger", user);

	if (user.pers["team"] != "axis" || level.trapsdisabled)
		return false;

	user braxi\_rank::giveRankXP("", xp);
	trig SetHintString("^2Activated");
	return true;
}

// build balls array and hide them
init_balls()
{
	for (i = 0; i < level.ball.size; i++)
	{
		level.ball[i] hide();
		level.ball[i] notsolid();
		level.ball_damage[i] triggerOff();
		level.ball_damage[i] enableLinkTo();
		level.ball[i].ball_array = i;
	}
}

// balls
trap1()
{
	if (!setupTrap("trap_1_trig", 100))
		return;

	// thread ball_start(0, 3, level.ball_explode[0], 1.25, 0.3125);
	// thread ball_start(3, 6, level.ball_explode[1], 1.25, 0.3125);
}

// balls
trap2()
{
	if (!setupTrap("trap_2_trig", 100))
		return;

	// thread ball_start(6, 12, level.ball_explode[2], 4, 2);
	// thread ball_start(12, 18, level.ball_explode[3], 4, 2);
	// thread ball_start(18, 24, level.ball_explode[4], 4, 2);

	// getEnt("trap_2_brush", "targetname") delete();
}

// push teleported players
trap3()
{
	clip = getEnt("trap_3_clip", "targetname");
	clip notsolid();

	if (!setupTrap("trap_3_trig", 100))
		return;

	// clip solid();
	// trig = getEnt("trap_3_push", "targetname");
	// while (true)
	// {
	// 	trig waittill("trigger",player);
	// 	for (i = 0; i < 4; i++)
	// 	{
	// 		player.health += 40000;
	// 		player finishPlayerDamage(player, player, 40000, 0, "MOD_PROJECTILE", "bh_mp",
	// 			player.origin, (0, 90, 0), "none", 0);
	// 	}
	// }
}

// remove 3 brushes on section 4
trap4()
{
	brush = getEnt("trap_4_brush", "targetname");
	if (!setupTrap("trap_4_trig", 100))
		return;
	// brush notsolid();
}

// spawn lightning grid on section 5
trap5()
{
	fx = getEntArray("trap_5_fx", "targetname");
	hurt = getEnt("trap_5_dmg", "targetname");
	hurt triggerOff();

	for (i = 0; i < fx.size; i++)
	{
		fx[i] hide();
		fx[i] notsolid();
	}
	if (!setupTrap("trap_5_trig", 100))
		return;

	// hurt triggerOn();
	// for (i = 0; i < fx.size; i++)
	// 	fx[i] thread trap5_rotate();

	// while (!trap5_check(hurt, fx))
	// 	wait 1;
}

// rotate trap 5 effects
trap5_rotate()
{
	self solid();
	self show();

	rng = randomIntRange(1, 4);
	while (isDefined(self))
	{
		self rotateRoll(360, rng / 3);
		wait rng / 3;
	}
}

// to pass trap5 you have to activate all falling plats
trap5_check(trig,fx)
{
	if (isDefined(level.fall_validate) && level.fall_validate == 27)
	{
		// trig stopLoopSound();
		trig delete();
		for (i = 0; i < fx.size; i++)
			fx[i] delete();
		return true;
	}
	return false;
}

// remove the bridge
trap6()
{
	brush = getEnt("trap_6_brush", "targetname");
	// if (!setupTrap("trap_6_trig", 100))
	// 	return;
	// brush delete();
}

// flamethrower trap
trap7()
{
	fire = getEntArray("trap_fire", "targetname");
	hurt = getEnt("trap_7_dmg", "targetname");
	hurt triggerOff();

	// if (!setupTrap("trap_7_trig", 100))
	// 	return;

	// wait 0.1;
	// while (true)
	// {
	// 	hurt triggerOn();
	// 	for (i = 0; i < fire.size; i++)
	// 		playFX(level.fx_fire, fire[i].origin);

	// 	fire[1] playSound("fire");
	// 	wait 3.5;
	// 	hurt triggerOff();
	// 	wait 5;
	// }
}

// balls on end section
trap8()
{
	// if (!setupTrap("trap_8_trig", 100))
	// 	return;

	// thread trap8_alternate();
	// thread ball_start(24, 36, level.ball_explode[5], 4, 0.5, "trap8_off");
	// thread ball_start(36, 48, level.ball_explode[6], 4, 0.5, "trap8_off");
	// thread ball_start(48, 60, level.ball_explode[7], 4, 0.5, "trap8_off");
	// thread ball_start(60, 72, level.ball_explode[8], 4, 0.5, "trap8_on");
	// thread ball_start(72, 84, level.ball_explode[9], 4, 0.5, "trap8_on");

	// while (1)
	// {
	// 	level waittill("trap8_alternate");
	// 	wait 0.5;

	// 	thread ball_start(24, 36, level.ball_explode[5], 4, 0.5, "trap8_off");
	// 	thread ball_start(36, 48, level.ball_explode[6], 4, 0.5, "trap8_off");
	// 	thread ball_start(48, 60, level.ball_explode[7], 4, 0.5, "trap8_off");
	// 	thread ball_start(60, 72, level.ball_explode[8], 4, 0.5, "trap8_on");
	// 	thread ball_start(72, 84, level.ball_explode[9], 4, 0.5, "trap8_on");
	// }
}

// alternate balls pattern
trap8_alternate()
{
	while (true)
	{
		wait 9.5;
		level.trap_8_alternate = !level.trap_8_alternate;
		level notify("trap8_alternate");
	}
}

// init a ball trap
ball_start(start_index, end_index, explode_path, time, looptime, special)
{
	for (i = start_index; i < end_index; i++)
	{
		level.ball[i] thread ball_move(explode_path, time, special);
		wait looptime;
	}
}

// all SFX and FX are remove due to engine limits
// move a ball patch with specified origin, time
ball_move(distance,time,special)
{
	level.ball_damage[self.ball_array] triggerOn();
	level.ball_damage[self.ball_array] linkTo(self);

	while (true)
	{
		// check for special move
		if (isDefined(special))
		{
			if (special == "trap8_on")
			{
				if (level.trap_8_alternate)
					break;
			}
			else if (special == "trap8_off")
			{
				if (!level.trap_8_alternate)
					break;
			}
		}
		// self playSound("cannon_fire");
		// playFX(level.fx_cannon_fire, self.origin);
		self show();

		self.realOrigin = self.origin;
		self moveTo(distance.origin, time);
		// self playLoopSound("cannon_loop");

		// self.trail = spawn("script_model", self.origin);
		// self.trail setmodel("tag_origin");
		// self.trail linkto(self);
		wait .05;
		// PlayFXOnTag(level.fx_smoke_geotrail, self.trail, "tag_origin");

		wait time - 0.05;
		// self.trail unlink();
		// self.trail delete();
		// self stopLoopSound();
		// distance playSound("explosion");
		// playFX(level.fx_small_explosion, distance.origin);

		self.origin = self.realOrigin;
		self hide();
	}
}
