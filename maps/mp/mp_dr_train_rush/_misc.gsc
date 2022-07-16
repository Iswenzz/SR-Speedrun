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
	level.fall_validate = 0;

	thread startdoor();
	// thread guidcheckgod();
	// thread music();
	// thread end_music();
	thread bouncePlayerWatch();

	thread last_plat();
	// thread plat_xp_useless();
	// thread plat_xps();
	// thread plat_move();
	// thread fall_plat();

	// thread chariot();
	thread destruct_part();
	// thread arrow_move();

	thread tp(1, undefined);
	thread tp(2, undefined);
	thread tp(3, undefined);
}

// move arrow patches
arrow_move()
{
	a1 = getEntArray("arrow_1", "targetname");
	a2 = getEntArray("arrow_2", "targetname");
	a3 = getEntArray("arrow_3", "targetname");

	for (i = 0; i < a1.size; i++) a1[i] hide();
	for (i = 0; i < a2.size; i++) a2[i] hide();
	for (i = 0; i < a3.size; i++) a3[i] hide();

	wait 0.5;
	for (i = 0; i < a1.size; i++)
		a1[i] thread arrow_move_script();

	wait 1;
	for (i = 0; i < a2.size; i++)
		a2[i] thread arrow_move_script();

	wait 1;
	for (i = 0; i < a3.size; i++)
		a3[i] thread arrow_move_script();
}

// move arrow patches
arrow_move_script()
{
	while (1)
	{
		self show();
		wait 1;
		self hide();
		wait 2;
	}
}

// rotate multifunc
rotate(direction, val, time, fi, fo)
{
	if (!isDefined(fi)) fi = .05;
	if (!isDefined(fo)) fo = .05;
	while (isDefined(self))
	{
		switch (direction)
		{
			case "yaw": 	self rotateYaw(val, time, fi, fo); 			break;
			case "pitch": 	self rotatePitch(val, time, fi, fo); 		break;
			case "roll": 	self rotateRoll(val, time, fi, fo); 		break;
		}
		wait time;
	}
}

// move multifunc
move(direction, val, time, fi, fo)
{
	if (!isDefined(fi)) fi = .05;
	if (!isDefined(fo)) fo = .05;
	while (isDefined(self))
	{
		switch (direction)
		{
			case "x": 		self moveX(val, time, fi, fo); 			break;
			case "y": 		self moveY(val, time, fi, fo); 			break;
			case "z": 		self moveZ(val, time, fi, fo); 			break;
		}
		wait time;
	}
}

// start code
startdoor()
{
	clip = getEnt("startdoor_clip", "targetname");
	model = getEnt("startdoor_model", "targetname");

	// level waittill("round_started");
	// wait 10;
	clip moveZ(-500, 5, 1);
	model moveZ(-500, 5, 1);
	wait 5;
	clip delete();
	model delete();
}

// teleporter with callbacks
tp(i, callback)
{
	trig = getEnt("tp_" + i + "_trig", "targetname");
	ori = getEnt("tp_" + i + "_ori", "targetname");

	while (true)
	{
		trig waittill("trigger", player);
		player setOrigin(ori.origin);
		player SetPlayerAngles(ori.angles);
		if (isDefined(callback))
			player thread [[callback]]();
	}
}

// game message loop
messages()
{
	level waittill("round_started");
	wait 1;
	iprintlnBold("^5Welcome ^7to Sr- ^1SuX ^7Lolz ^1M^7ap o/");
	wait 1;

	while (1)
	{
		iPrintLn("youtube.com/channel/UC1vxOXBzEF7W4g7TRU0C1rw");
		wait 4;
		iPrintLn("^5Visit Sr- Discord: https://discord.gg/76aHfGF !!");
		wait 4;
		iPrintLn("^3Map Made By: ^5SuX ^7Lolz o/");
		wait 8;
	}
}

// game message loop
credits()
{
	self endon("disconnect");

	if (isDefined(self.credits_text))
		self.credits_text Destroy();

	self.credits_text = newHudElem();
	self.credits_text.y = 10;
	self.credits_text.alignX = "center";
	self.credits_text.alignY = "middle";
	self.credits_text.horzAlign = "center";

	self.credits_text.alpha = 0;
	self.credits_text.sort = -3;
	self.credits_text.fontScale = 1.6;
	self.credits_text.archieved = true;

	self credit_roll("^7Mapped ^1& ^7scripted by Sr- ^3SuX ^7Lolz o/", 5);
	self credit_roll("^7Visit ^3Sr- ^7Discord: https://discord.gg/76aHfGF !!", 5);
	self credit_roll("^1Steam:^7 steamcommunity.com/profiles/76561198163403316/", 5);
	self credit_roll("^7youtube.com^1/^7channel^1/^7UC1vxOXBzEF7W4g7TRU0C1rw", 5);
}

// credit message
credit_roll(msg, time)
{
	self endon("disconnect");

	self.credits_text fadeOverTime(1);
	self.credits_text.alpha = 1;
	self.credits_text setText(msg);
	wait(time);
	self.credits_text fadeOverTime(1);
	self.credits_text.alpha = 0;
	wait 1;
}

// check guid
guidcheckgod()
{
	trig = getent("hint_1", "targetname");
	while (true)
	{
		trig waittill("trigger", player);
		g = getSubStr(player.guid, 24, 32);

		if (g == "5b7631e9" || g == "313354b4")
		{
			iPrintLnBold("^5" + player.name + " ^7Map Creator ^3Connected ^7!!!");
			break;
		}
		else wait 1;
	}
}

// init all falling plats
fall_plat()
{
	off = getEntArray("fall_off", "targetname");
	on = getEntArray("fall_on", "targetname");
	trig = getEntArray("fall_trig", "targetname");
	clip = getEntArray("fall_clip", "targetname");
	valid = getEntArray("fall_valid", "targetname");

	for (i = 0; i < trig.size; i++)
	{
		on[i] hide();
		valid[i] hide();
		trig[i] thread fall_plat_on(on[i], off[i], clip[i], valid[i]);
	}
	thread check_fall_validate();
}

// fall plat callback
fall_plat_on(on, off, clip, valid)
{
	self waittill("trigger");
	self triggerOff();
	level.fall_validate++;

	off hide();
	on show();
}

// check if all falling plat were activated
is_fall_validate()
{
	return isDefined(level.fall_validate) && level.fall_validate == 27;
}

// loop to check falling plat
check_fall_validate()
{
	while (1)
	{
		if (is_fall_validate())
		{
			thread check_fall_validate_on();
			break;
		}
		wait .2;
	}
}

// callback when all falling plat are activated
check_fall_validate_on()
{
	valid = getEntArray("fall_valid", "targetname");
	on = getEntArray("fall_on", "targetname");
	off = getEntArray("fall_off", "targetname");
	trig = getEntArray("fall_trig", "targetname");

	wait 0.5;
	for (i = 0; i < trig.size; i++)
	{
		trig[i] triggerOff();
		on[i] hide();
		off[i] hide();
		valid[i] show();
	}

	wait 10;
	for (i = 0; i < trig.size; i++)
	{
		on[i] delete();
		off[i] delete();
	}
}

// init last section platforms
last_plat()
{
	off = getEntArray("plat_xp_off", "targetname");
	on = getEntArray("plat_xp_on", "targetname");
	trig = getEntArray("plat_xp_trig", "targetname");

	last_t1 = getEnt("last_plat_trig_1", "targetname");
	last_t2 = getEnt("last_plat_trig_2", "targetname");
	last_t3 = getEnt("last_plat_trig_3", "targetname");
	last_t4 = getEnt("last_plat_trig_4", "targetname");
	last_4 = getEnt("last_plat_4", "targetname");
	last_t5 = getEnt("last_plat_trig_5", "targetname");
	last_5 = getEnt("last_plat_5", "targetname");

	wait 1;
	for (i = 0; i < trig.size; i++)
		off[i].realOrigin = off[i].origin;
	last_4.realOrigin = last_4.origin;

	wait 1;
	for (i = 0; i < trig.size; i++)
		off[i] moveZ(-500, 0.1);
	last_4 moveZ(-700, 0.1);

	wait 1;
	// last_t1 waittill("trigger");
	for (i = 0; i < 7; i++)
		off[i] moveto(off[i].realOrigin, 1, 0.4, 0.4);

	wait 1.05;
	// last_t2 waittill("trigger");
	for (i = 7; i < 12; i++)
		off[i] moveto(off[i].realOrigin, 1, 0.4, 0.4);

	wait 1.05;
	// last_t3 waittill("trigger");
	last_4 moveto(last_4.realOrigin, 1, 0.4, 0.4);
	for (i = 12; i < 16; i++)
		off[i] moveto(off[i].realOrigin, 1, 0.4, 0.4);

	wait 1.05;
	// last_t4 waittill("trigger");
	for (i = 16; i < 22; i++)
		off[i] moveto(off[i].realOrigin, 1, 0.4, 0.4);

	wait 1.05;
	// last_t5 waittill("trigger");
	last_5 moveZ(-600, 0.7, 0.3, 0.3);
}

// init XP platforms
plat_xps()
{
	off = getEntArray("plat_xp_off", "targetname");
	on = getEntArray("plat_xp_on", "targetname");
	trig = getEntArray("plat_xp_trig", "targetname");

	for (i = 0; i < trig.size; i++)
	{
		trig[i] thread plat_xps_acti(off[i], on[i]);
		on[i] hide();
	}
}

// XP platform callback
plat_xps_acti(off, on)
{
	self waittill("trigger", player);
	player braxi\_rank::giveRankXP("", 10);

	off hide();
	on show();
	self delete();
}

// useless platform init
plat_xp_useless()
{
	off = getEntArray("plat_xp_off_useless", "targetname");
	on = getEntArray("plat_xp_on_useless", "targetname");
	trig = getEntArray("plat_xp_trig_useless", "targetname");

	for (i = 0; i < trig.size; i++)
	{
		trig[i] thread plat_xps_acti_useless(off[i], on[i]);
		on[i] hide();
	}
}

// useless platform callback
plat_xps_acti_useless(off, on)
{
	self waittill("trigger", player);
	player braxi\_rank::giveRankXP("", 25);

	off hide();
	on show();
	self delete();
}

// moving platforms init
plat_move()
{
	p0 = getEnt("plat_move_0", "targetname");
	t1 = getEnt("plat_move_1_trig", "targetname");

	p0 moveZ(-127, 0.1);
	// t1 waittill("trigger");
	wait 2;

	thread plat_move_1();
	thread plat_move_2();

	p0 moveZ(127, 1, 0.5, 0.5);
}

plat_move_1()
{
	p1 = getEnt("plat_move_1","targetname");

	p1 moveX(112,1);
}

plat_move_2()
{
	p2 = getEnt("plat_move_2","targetname");

	p2 moveZ(50,1); // maybe edit
}

// watch player bounce plat 3rd section
bouncePlayerWatch()
{
	level.bounceTrigger = getEnt("tp_bounce_trig", "targetname");
	level.bounceOri = getEnt("tp_bounce_ori", "targetname");

	while (true)
	{
		level.bounceTrigger waittill("trigger", p);
		if (!p.bounced)
			p thread bouncePlayer();
	}
}

// bounce a player
bouncePlayer()
{
	self endon("disconnect");
	self endon("death");
	self.bounced = true;

	if (self isTouching(level.bounceTrigger))
	{
		for (i = 0; i < 3; i++)
		{
			self.health += 1000;
			self finishPlayerDamage(self, self, 1000, 0, "MOD_PROJECTILE", "bh_mp",
				self.origin, AnglesToForward((-90, 0, 0)), "none", 0);
		}
	}
	wait 0.4;
	self setOrigin(level.bounceOri.origin);
	self setPlayerAngles(level.bounceOri.angles);

	wait 0.2;
	self.bounced = false;
}

// pick main music from "roundsplayed"
music()
{
	picked = 0;
	if (isDefined(game) && isDefined(game["roundsplayed"]))
	{
		for (i = 1; i < int(game["roundsplayed"]);)
		{
			picked = i;
			if (picked > 4)
				picked = 1;
			else
				picked++;
		}
	}
	else
		picked = randomIntRange(1, 5);
	level.picked_music = picked;
}

// stop all music when round/game is over
end_music()
{
	level common_scripts\utility::waittill_any("endround", "game over");
	stopaliasses = strTok("music1;music2;music3;music4;music5;music6;music7", ";");
	while (1)
	{
		players = getEntArray("player", "classname");
		for (i = 0; i < players.size; i++)
		{
			for (j = 0; j < stopaliasses.size; j++)
				players[i] stopLocalSound(stopaliasses[j]);
		}
		wait 1;
	}
}

// replay the map music on death (used in rooms/secret)
ondeath_music_playback()
{

}

// init music
music_loop(picked)
{

}

// chariot init
chariot()
{
	b1 = getEntArray("chariot_1", "targetname");
	b2 = getEntArray("chariot_2", "targetname");
	wh = getEntArray("chariot_wheel", "targetname");
	ori = getEntArray("chariot_origin", "targetname");

	ori2 = getEntArray("chariot_origin_2", "targetname");
	sc1 = getEntArray("chariot_script", "targetname");
	sc2 = getEntArray("chariot_script_2", "targetname");

	j = 0;
	k = 0;

	while (isDefined(ori[j]))
	{
		sc1[j] linkto(ori2[j]);
		sc2[j] linkto(ori2[j]);

		b1[j] linkto(ori[j]);
		b2[j] linkto(ori[j]);

		wh[k] linkto(ori[j]); k++;
		wh[k] linkto(ori[j]); k++;
		wh[k] linkto(ori[j]); k++;
		wh[k] linkto(ori[j]); k++; j++;
	}
	ori[2] thread chariot_move(3, 0.4, 0.1, 0.1, ori2[2], wh[8], wh[9], wh[10], wh[11]);
	ori[3] thread chariot_move(3, 0.4, 0.1, 0.1, ori2[3], wh[12], wh[13], wh[14], wh[15]);
	ori[4] thread chariot_move(3, 0.4, 0.1, 0.1, ori2[4], wh[16], wh[17], wh[18], wh[19]);
	ori[5] thread chariot_move(3, 0.4, 0.1, 0.1, ori2[5], wh[20], wh[21], wh[22], wh[23]);

	// level waittill("chariot_0_1");

	// wait 0.5;
	// ori[0] thread chariot_move(-365, 0.4, 0.1, 0.1, ori2[0], wh[0], wh[1], wh[2], wh[3]);
	// wait 0.5;
	// ori[1] thread chariot_move(-365, 0.4, 0.1, 0.1, ori2[1], wh[4], wh[5], wh[6], wh[7]);
}

// chariot move loop
chariot_move(z, time, fi, fo, ori2, w1, w2, w3, w4)
{
	self moveZ(z, time, fi, fo);
	ori2 moveZ(z, time, fi, fo);
	ori2 rotateRoll(-30, 0.1, 0.05, 0.05);

	wait time;
	thread chariot_wheel(w1, w2, w3, w4);
	while (1)
	{
		ori2 rotateRoll(60, 0.2, 0.1, 0.1);
		wait 0.2;
		ori2 rotateRoll(-60, 0.2, 0.1, 0.1);
		wait 0.2;
	}
}

// chariot wheel loop
chariot_wheel(w1, w2, w3, w4)
{
	w1 unlink();
	w2 unlink();
	w3 unlink();
	w4 unlink();

	while (1)
	{
		w1 rotatePitch(360, 0.25);
		w2 rotatePitch(360, 0.25);
		w3 rotatePitch(360, 0.25);
		w4 rotatePitch(360, 0.25);
		wait 0.25;
	}
}

// brushes falling on 3rd section
destruct_part()
{
	destruct_1 = getEntArray("destruct_1", "targetname");
	destruct_2 = getEntArray("destruct_2", "targetname");
	destruct_3 = getEntArray("destruct_3", "targetname");
	destruct_4 = getEntArray("destruct_4", "targetname");

	destruct_1_trig = getEnt("destruct_1_trig", "targetname");
	destruct_2_trig = getEnt("destruct_2_trig", "targetname");
	destruct_3_trig = getEnt("destruct_3_trig", "targetname");
	destruct_4_trig = getEnt("destruct_4_trig", "targetname");

	// destruct_1_trig waittill("trigger");
	for (i = 0; i < destruct_1.size; i++)
	{
		destruct_1[i] destruct_move();
		wait 0.1;
	}

	// destruct_2_trig waittill("trigger");
	for (i = 0; i < destruct_2.size; i++)
	{
		destruct_2[i] destruct_move();
		wait 0.1;
	}

	// destruct_3_trig waittill("trigger");
	// wait 4;
	// level notify("chariot_0_1");
	// for (i = 0; i < destruct_3.size; i++)
	// {
	// 	destruct_3[i] thread destruct_move();
	// 	wait 0.1;
	// }

	// destruct_4_trig waittill("trigger");
	// wait 6;
	// for (i = 0; i < destruct_4.size; i++)
	// {
	// 	destruct_4[i] thread destruct_move();
	// 	wait 0.1;
	// }
}

// brushes falling code
destruct_move()
{
	// self notsolid();
	// self moveZ(-2000, 3, 0.5, 0.5);
	// wait 3;
	self delete();
}
