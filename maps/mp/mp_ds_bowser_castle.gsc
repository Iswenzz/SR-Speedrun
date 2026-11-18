main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_ds_bowser_castle", 0);

	level.iz_cue = [];
	level.iz_cue["iz_cue_boost"] = true;
	level.iz_cue["iz_cue_bounce"] = true;
	level.iz_cue["iz_cue_cannon"] = true;
	level.iz_cue["iz_cue_finish"] = true;
	level.iz_cue["iz_cue_item"] = true;
	level.iz_cue["iz_cue_jump"] = true;
	thread iz_sounds();

	thread iz_course();
	thread sr\api\_speedrun::createNormalWays("Normal Way;");

	thread iz_anims();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
}

iz_sounds()
{
	ambientPlay("iz_0_86", 2);
	level thread iz_music("iz_7_se_cr_gbk_env");
}

iz_music(alias)
{
	for (;;)
	{
		level waittill("connected", player);
		player thread iz_music_player(alias);
	}
}

iz_music_player(alias)
{
	self endon("disconnect");
	self waittill("spawned_player");
	self playLocalSound(alias);
}

iz_course()
{
	iz_course_route();
	level.iz_course_gates = 0;
	gates = getEntArray("iz_gate", "targetname");
	for (i = 0; i < gates.size; i++)
	{
		gates[i].iz_order = int(gates[i].script_noteworthy);
		if (gates[i].iz_order > level.iz_course_gates)
			level.iz_course_gates = gates[i].iz_order;
	}
	iz_course_each("iz_gate", ::iz_course_gate);
	iz_course_each("iz_finish", ::iz_course_finish);
	iz_course_each("iz_boost", ::iz_course_boost);
	iz_course_each("iz_cannon", ::iz_course_cannon);
	iz_course_each("iz_jump", ::iz_course_jump);
	iz_course_each("iz_fall", ::iz_course_fall);
	iz_course_each("iz_itembox", ::iz_course_itembox);
	gone = 0;
	for (i = 0; gone < 16; i++)
	{
		mover = getEnt("iz_obj_" + i, "targetname");
		if (!isDefined(mover))
		{
			gone++;
			continue;
		}
		gone = 0;
		mover notSolid();
		if (isDefined(mover.radius))
			mover thread iz_course_hazard();
	}

	for (;;)
	{
		level waittill("player_spawn", player);
		player.iz_gate = 0;
	}
}

// One of the course's own sounds from whoever makes it, no sooner than
// rest milliseconds after they last made it.
iz_course_cue(name, rest)
{
	alias = "iz_cue_" + name;
	if (!isDefined(level.iz_cue) || !isDefined(level.iz_cue[alias]))
		return;
	if (rest > 0)
	{
		if (!isDefined(self.iz_cued))
			self.iz_cued = [];
		if (isDefined(self.iz_cued[name]) && getTime() - self.iz_cued[name] < rest)
			return;
		self.iz_cued[name] = getTime();
	}
	self playSound(alias);
}

iz_course_each(name, run)
{
	ents = getEntArray(name, "targetname");
	for (i = 0; i < ents.size; i++)
		ents[i] thread [[run]]();
}

iz_course_gate()
{
	for (;;)
	{
		self waittill("trigger", player);
		if (isDefined(player.iz_gate) && player.iz_gate == self.iz_order - 1)
			player.iz_gate = self.iz_order;
	}
}

iz_course_finish()
{
	for (;;)
	{
		self waittill("trigger", player);
		if (!isDefined(player.iz_gate) || player.iz_gate < level.iz_course_gates)
			continue;
		player.iz_gate = 0;
		player iz_course_cue("finish", 0);
		player sr\api\_speedrun::finishWay("normal_0");
	}
}

iz_course_boost()
{
	speed = int(self.script_noteworthy);
	for (;;)
	{
		self waittill("trigger", player);
		if (!isPlayer(player) || !isAlive(player))
			continue;

		velocity = player getVelocity();
		way = (velocity[0], velocity[1], 0);
		player iz_course_cue("boost", 1000);
		if (length(way) >= speed)
			continue;
		if (length(way) < 50)
			way = anglesToForward((0, player getPlayerAngles()[1], 0));
		else
			way = vectorNormalize(way);
		player setVelocity((way[0] * speed, way[1] * speed, velocity[2]));
	}
}

iz_course_jump()
{
	toss = strTok(self.script_noteworthy, " ");
	if (toss.size != 4)
		return;
	speed = int(toss[0]);
	rise = int(toss[1]);
	rest = int(toss[2]);
	cue = toss[3];
	for (;;)
	{
		self waittill("trigger", player);
		now = getTime();
		if (!isPlayer(player) || !isAlive(player))
			continue;
		if (rest > 0)
		{
			if (isDefined(player.iz_thrown) && now - player.iz_thrown < rest)
				continue;
			player.iz_thrown = now;
		}

		velocity = player getVelocity();
		if (rest > 0)
		{
			player setVelocity((velocity[0], velocity[1], rise));
			player iz_course_cue(cue, 0);
			continue;
		}
		player iz_course_cue(cue, 1000);
		way = (velocity[0], velocity[1], 0);
		pace = length(way);
		if (pace < 50)
			way = anglesToForward((0, player getPlayerAngles()[1], 0));
		else
			way = vectorNormalize(way);
		if (pace < speed)
			pace = speed;
		player setVelocity((way[0] * pace, way[1] * pace, rise));
	}
}

iz_course_cannon()
{
	ends = getEntArray("iz_cannon_end", "targetname");
	for (i = 0; i < ends.size; i++)
	{
		flight = strTok(ends[i].script_noteworthy, " ");
		if (flight.size == 3 && flight[0] == self.script_noteworthy)
			self.iz_end = ends[i].origin;
	}
	if (!isDefined(self.iz_end))
		return;
	for (;;)
	{
		self waittill("trigger", player);
		if (!isPlayer(player) || !isAlive(player))
			continue;

		velocity = player getVelocity();
		speed = length((velocity[0], velocity[1], 0));
		way = vectorNormalize((self.iz_end[0] - player.origin[0], self.iz_end[1] - player.origin[1], 0));
		player setOrigin(self.iz_end);
		player iz_course_cue("cannon", 0);
		player setPlayerAngles((0, vectorToAngles(way)[1], 0));
		player setVelocity((way[0] * speed, way[1] * speed, velocity[2]));
	}
}

iz_course_fall()
{
	for (;;)
	{
		self waittill("trigger", player);
		if (isPlayer(player) && isAlive(player))
			player suicide();
	}
}

iz_course_itembox()
{
	self notSolid();
	reach = 60;
	if (isDefined(self.radius))
		reach = self.radius;
	marks = getEntArray("iz_itembox_mark", "targetname");
	for (i = 0; i < marks.size; i++)
		if (distance(marks[i].origin, self.origin) < 4)
			self.iz_mark = marks[i];
	if (isDefined(self.iz_mark))
	{
		self.iz_mark notSolid();
		self.iz_mark thread iz_course_turn();
		self.iz_mark thread iz_course_slide();
	}
	self thread iz_course_spin();
	self thread iz_course_slide();
	for (;;)
	{
		wait 0.05;
		players = getEntArray("player", "classname");
		for (i = 0; i < players.size; i++)
		{
			if (!isAlive(players[i]) || distance(players[i].origin + (0, 0, 35), self.origin) > reach)
				continue;
			self.iz_taken = true;
			self iz_course_cue("item", 0);
			self hide();
			if (isDefined(self.iz_mark))
				self.iz_mark hide();
			wait 3;
			self show();
			if (isDefined(self.iz_mark))
				self.iz_mark show();
			self.iz_taken = undefined;
			break;
		}
	}
}

iz_course_hazard()
{
	reach = self.radius;
	for (;;)
	{
		wait 0.05;
		players = getEntArray("player", "classname");
		for (i = 0; i < players.size; i++)
		{
			player = players[i];
			if (!isAlive(player))
				continue;
			away = (player.origin[0] - self.origin[0], player.origin[1] - self.origin[1], 0);
			if (length(away) > reach || player.origin[2] > self.origin[2] + reach * 2 || player.origin[2] + 72 < self.origin[2])
				continue;
			now = getTime();
			if (isDefined(player.iz_struck) && now - player.iz_struck < 1500)
				continue;
			player.iz_struck = now;
			if (length(away) < 1)
				away = anglesToForward((0, randomInt(360), 0));
			away = vectorNormalize(away);
			player setVelocity((away[0] * 320, away[1] * 320, 240));
			player notify("iz_hit", self);
		}
	}
}

iz_course_slide()
{
	if (!isDefined(self.script_noteworthy))
		return;
	path = strTok(self.script_noteworthy, " ");
	if (path.size != 8)
		return;
	from = (int(path[0]), int(path[1]), int(path[2]));
	to = (int(path[3]), int(path[4]), int(path[5]));
	way = int(path[6]) / 2000;
	if (way < 0.1)
		return;
	if (int(path[7]) > 0)
		wait int(path[7]) / 1000;
	for (;;)
	{
		self moveTo(to, way, way / 2, way / 2);
		wait way;
		self moveTo(from, way, way / 2, way / 2);
		wait way;
	}
}

iz_course_spin()
{
	for (;;)
	{
		self rotateVelocity((40, 110, 25), 10);
		wait 10;
	}
}

iz_course_turn()
{
	for (;;)
	{
		self rotateYaw(360, 8);
		wait 8;
	}
}

iz_course_route()
{
	level.iz_route = [];
	level.iz_route[level.iz_route.size] = (7216, 4385, 894);
	level.iz_route[level.iz_route.size] = (6548, 4385, 894);
	level.iz_route[level.iz_route.size] = (5550, 4385, 958);
	level.iz_route[level.iz_route.size] = (4553, 4385, 1037);
	level.iz_route[level.iz_route.size] = (3547, 4385, 1117);
	level.iz_route[level.iz_route.size] = (2470, 4385, 1201);
	level.iz_route[level.iz_route.size] = (1464, 4385, 1223);
	level.iz_route[level.iz_route.size] = (609, 4385, 1223);
	level.iz_route[level.iz_route.size] = (32, 4363, 1223);
	level.iz_route[level.iz_route.size] = (-612, 4390, 1223);
	level.iz_route[level.iz_route.size] = (-1314, 4385, 1223);
	level.iz_route[level.iz_route.size] = (-2223, 4385, 1223);
	level.iz_route[level.iz_route.size] = (-3102, 4426, 1224);
	level.iz_route[level.iz_route.size] = (-3855, 4428, 1224);
	level.iz_route[level.iz_route.size] = (-4277, 4579, 1223);
	level.iz_route[level.iz_route.size] = (-4390, 5047, 1225);
	level.iz_route[level.iz_route.size] = (-4396, 5766, 1225);
	level.iz_route[level.iz_route.size] = (-4372, 6532, 1226);
	level.iz_route[level.iz_route.size] = (-4390, 7476, 1227);
	level.iz_route[level.iz_route.size] = (-4399, 8286, 1228);
	level.iz_route[level.iz_route.size] = (-3922, 8669, 1235);
	level.iz_route[level.iz_route.size] = (-3271, 8713, 1456);
	level.iz_route[level.iz_route.size] = (-2659, 8676, 1664);
	level.iz_route[level.iz_route.size] = (-2098, 8552, 1671);
	level.iz_route[level.iz_route.size] = (-1430, 8445, 1779);
	level.iz_route[level.iz_route.size] = (-671, 8279, 2027);
	level.iz_route[level.iz_route.size] = (-324, 8046, 2102);
	level.iz_route[level.iz_route.size] = (6, 7574, 2102);
	level.iz_route[level.iz_route.size] = (57, 7127, 2102);
	level.iz_route[level.iz_route.size] = (13, 6477, 2102);
	level.iz_route[level.iz_route.size] = (22, 5729, 2102);
	level.iz_route[level.iz_route.size] = (22, 5168, 2102);
	level.iz_route[level.iz_route.size] = (15, 4323, 2102);
	level.iz_route[level.iz_route.size] = (-10, 3718, 2102);
	level.iz_route[level.iz_route.size] = (15, 3068, 2102);
	level.iz_route[level.iz_route.size] = (28, 2356, 2102);
	level.iz_route[level.iz_route.size] = (116, 1688, 2080);
	level.iz_route[level.iz_route.size] = (602, 1007, 2080);
	level.iz_route[level.iz_route.size] = (1018, 597, 2080);
	level.iz_route[level.iz_route.size] = (1175, -96, 2080);
	level.iz_route[level.iz_route.size] = (980, -689, 2080);
	level.iz_route[level.iz_route.size] = (501, -1042, 2080);
	level.iz_route[level.iz_route.size] = (-268, -1118, 2080);
	level.iz_route[level.iz_route.size] = (-817, -891, 2080);
	level.iz_route[level.iz_route.size] = (-1107, -456, 2080);
	level.iz_route[level.iz_route.size] = (-1447, -65, 2080);
	level.iz_route[level.iz_route.size] = (-1977, 17, 2080);
	level.iz_route[level.iz_route.size] = (-2633, 11, 2058);
	level.iz_route[level.iz_route.size] = (-3313, -15, 2058);
	level.iz_route[level.iz_route.size] = (-3975, -21, 2058);
	level.iz_route[level.iz_route.size] = (-4587, -15, 2058);
	level.iz_route[level.iz_route.size] = (-5186, -2, 2058);
	level.iz_route[level.iz_route.size] = (-5820, 54, 2058);
	level.iz_route[level.iz_route.size] = (-6409, 93, 2090);
	level.iz_route[level.iz_route.size] = (-7052, 130, 2102);
	level.iz_route[level.iz_route.size] = (-7386, 130, 2102);
	level.iz_route[level.iz_route.size] = (-8218, 112, 2102);
	level.iz_route[level.iz_route.size] = (-8937, 112, 2102);
	level.iz_route[level.iz_route.size] = (-9467, 49, 2102);
	level.iz_route[level.iz_route.size] = (-9958, -128, 2159);
	level.iz_route[level.iz_route.size] = (-10406, -487, 2222);
	level.iz_route[level.iz_route.size] = (-10601, -1023, 2288);
	level.iz_route[level.iz_route.size] = (-10614, -1521, 2345);
	level.iz_route[level.iz_route.size] = (-10419, -2019, 2397);
	level.iz_route[level.iz_route.size] = (-10066, -2448, 2462);
	level.iz_route[level.iz_route.size] = (-9454, -2719, 2536);
	level.iz_route[level.iz_route.size] = (-8754, -2631, 2615);
	level.iz_route[level.iz_route.size] = (-8275, -2322, 2682);
	level.iz_route[level.iz_route.size] = (-7947, -1824, 2734);
	level.iz_route[level.iz_route.size] = (-7790, -1193, 2761);
	level.iz_route[level.iz_route.size] = (-7790, -456, 2761);
	level.iz_route[level.iz_route.size] = (-7790, 275, 2761);
	level.iz_route[level.iz_route.size] = (-7790, 1095, 2761);
	level.iz_route[level.iz_route.size] = (-7790, 1776, 2697);
	level.iz_route[level.iz_route.size] = (-7790, 2363, 2697);
	level.iz_route[level.iz_route.size] = (-7790, 3037, 2697);
	level.iz_route[level.iz_route.size] = (-7790, 3766, 2697);
	level.iz_route[level.iz_route.size] = (-7790, 4741, 2697);
	level.iz_route[level.iz_route.size] = (-7790, 5464, 2697);
	level.iz_route[level.iz_route.size] = (-7790, 6354, 2697);
	level.iz_route[level.iz_route.size] = (-7790, 7203, 2697);
	level.iz_route[level.iz_route.size] = (-7790, 7863, 2697);
	level.iz_route[level.iz_route.size] = (-7790, 8575, 2697);
	level.iz_route[level.iz_route.size] = (-7790, 9330, 2697);
	level.iz_route[level.iz_route.size] = (-7790, 10241, 2697);
	level.iz_route[level.iz_route.size] = (-7790, 11016, 2541);
	level.iz_route[level.iz_route.size] = (-7790, 11676, 2541);
	level.iz_route[level.iz_route.size] = (-7790, 12619, 2541);
	level.iz_route[level.iz_route.size] = (-7751, 13342, 2541);
	level.iz_route[level.iz_route.size] = (-7604, 13877, 2541);
	level.iz_route[level.iz_route.size] = (-7163, 14130, 2541);
	level.iz_route[level.iz_route.size] = (-6514, 14204, 2427);
	level.iz_route[level.iz_route.size] = (-5896, 14243, 2210);
	level.iz_route[level.iz_route.size] = (-5184, 14285, 1992);
	level.iz_route[level.iz_route.size] = (-4628, 14275, 1992);
	level.iz_route[level.iz_route.size] = (-3895, 14296, 1999);
	level.iz_route[level.iz_route.size] = (-1861, 14916, 1775);
	level.iz_route[level.iz_route.size] = (83, 14947, 1568);
	level.iz_route[level.iz_route.size] = (1831, 15003, 1317);
	level.iz_route[level.iz_route.size] = (3528, 14996, 1125);
	level.iz_route[level.iz_route.size] = (5131, 14967, 874);
	level.iz_route[level.iz_route.size] = (6824, 14899, 564);
	level.iz_route[level.iz_route.size] = (8018, 14876, 564);
	level.iz_route[level.iz_route.size] = (9221, 14894, 564);
	level.iz_route[level.iz_route.size] = (10347, 14905, 564);
	level.iz_route[level.iz_route.size] = (11060, 14700, 564);
	level.iz_route[level.iz_route.size] = (11514, 14344, 564);
	level.iz_route[level.iz_route.size] = (11763, 13863, 564);
	level.iz_route[level.iz_route.size] = (11857, 13077, 564);
	level.iz_route[level.iz_route.size] = (12008, 12294, 564);
	level.iz_route[level.iz_route.size] = (12186, 11475, 564);
	level.iz_route[level.iz_route.size] = (12293, 10709, 639);
	level.iz_route[level.iz_route.size] = (12275, 9818, 773);
	level.iz_route[level.iz_route.size] = (12182, 8907, 894);
	level.iz_route[level.iz_route.size] = (11906, 8498, 894);
	level.iz_route[level.iz_route.size] = (11310, 8088, 894);
	level.iz_route[level.iz_route.size] = (10663, 7850, 894);
	level.iz_route[level.iz_route.size] = (10272, 7200, 894);
	level.iz_route[level.iz_route.size] = (10174, 6416, 894);
	level.iz_route[level.iz_route.size] = (10153, 5588, 894);
	level.iz_route[level.iz_route.size] = (10046, 4911, 894);
	level.iz_route[level.iz_route.size] = (9725, 4644, 894);
	level.iz_route[level.iz_route.size] = (9156, 4440, 894);
	level.iz_route[level.iz_route.size] = (8241, 4395, 894);
}

iz_move(origin, angles, frames)
{
	if (!isDefined(self.iz_step))
	{
		self.iz_step = (0, 0, 0);
		self.iz_turn = (0, 0, 0);
	}
	time = frames * 0.05 + 0.0005;
	if (isDefined(origin))
	{
		to = origin - self.iz_step;
		self.iz_step = (to - self.origin) * (1.0 / frames);
		self moveTo(to, time);
	}
	if (isDefined(angles))
	{
		turn = angles - self.iz_turn - self.angles;
		turn = (iz_wrap(turn[0]), iz_wrap(turn[1]), iz_wrap(turn[2]));
		self.iz_turn = turn * (1.0 / frames);
		self rotateTo(self.angles + turn, time);
	}
}

iz_wrap(angle)
{
	return angle - 360 * floor(angle / 360 + 0.5);
}

iz_place(origin, angles)
{
	self.origin = origin;
	if (isDefined(angles))
		self.angles = angles;
	self.iz_step = (0, 0, 0);
	self.iz_turn = (0, 0, 0);
}

iz_stop(origin, angles)
{
	self iz_move(origin, angles, 1);
	wait 0.05;
	self iz_move(origin, angles, 1);
}

iz_anims()
{
	thread iz_obj_0();
	thread iz_obj_1();
	thread iz_obj_2();
	thread iz_obj_3();
	thread iz_obj_4();
	thread iz_obj_5();
	thread iz_obj_6();
	thread iz_obj_7();
	thread iz_obj_8();
	thread iz_obj_9();
	thread iz_obj_10();
	thread iz_obj_11();
	thread iz_obj_12();
	thread iz_obj_13();
	thread iz_obj_14();
	thread iz_obj_15();
	thread iz_obj_16();
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-4613.0708, -282.1221, 2057.7678);
	angles[0] = (0, -90, 0);
	at[0] = 0;
	points[1] = (-4613.1104, 320.2409, 2057.7678);
	angles[1] = (0, -90, 0);
	at[1] = 2;
	points[2] = (-4613.0708, 303.0252, 2057.7678);
	angles[2] = (0, -90, 0);
	at[2] = 2.0500;
	points[3] = (-4613.1104, -284.2784, 2057.7678);
	angles[3] = (0, -90, 0);
	at[3] = 4;
	points[4] = (-4613.0708, -282.1221, 2057.7678);
	angles[4] = (0, -90, 0);
	at[4] = 4.0333;
	mover = getEnt("iz_obj_0", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_1()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-2111.5081, 4207.7168, 1398.9370);
	angles[0] = (0, -90, 0);
	at[0] = 0;
	points[1] = (-825.2874, 4207.7168, 1398.9370);
	angles[1] = (0, -90, 0);
	at[1] = 2.2000;
	points[2] = (-796.0552, 4207.7168, 1398.9370);
	angles[2] = (0, -85, 0);
	at[2] = 2.2667;
	points[3] = (-796.0552, 4207.7168, 1398.9370);
	angles[3] = (0, 95, 0);
	at[3] = 2.8667;
	points[4] = (-796.0552, 4207.7168, 1398.9370);
	angles[4] = (0, 255, 0);
	at[4] = 3.4000;
	points[5] = (-796.0552, 4207.7168, 1398.9370);
	angles[5] = (0, 270, 0);
	at[5] = 3.4667;
	points[6] = (-796.0552, 4207.7168, 1517.0472);
	angles[6] = (0, 270, 0);
	at[6] = 3.6000;
	points[7] = (-796.0552, 4207.7168, 1531.5159);
	angles[7] = (0, 270, 0);
	at[7] = 3.6667;
	points[8] = (-796.0552, 4207.7168, 1441.1614);
	angles[8] = (0, 270, 0);
	at[8] = 3.7333;
	points[9] = (-796.0552, 4207.7168, 1270.4922);
	angles[9] = (0, 270, 0);
	at[9] = 3.8000;
	points[10] = (-796.0552, 4207.7168, 1223.2480);
	angles[10] = (0, 270, 0);
	at[10] = 3.8667;
	points[11] = (-796.0552, 4207.7168, 1223.2480);
	angles[11] = (0, 270, 0);
	at[11] = 4.8000;
	points[12] = (-796.0552, 4207.7168, 1232.1063);
	angles[12] = (0, 270, 0);
	at[12] = 4.8667;
	points[13] = (-796.0552, 4207.7168, 1397.4606);
	angles[13] = (0, 270, 0);
	at[13] = 5.8000;
	points[14] = (-796.0552, 4207.7168, 1398.9370);
	angles[14] = (0, 285, 0);
	at[14] = 5.8667;
	points[15] = (-796.0552, 4207.7168, 1398.9370);
	angles[15] = (0, 445, 0);
	at[15] = 6.4000;
	points[16] = (-828.7480, 4207.7168, 1398.9370);
	angles[16] = (0, 450, 0);
	at[16] = 6.4667;
	points[17] = (-2114.9724, 4207.7168, 1398.9370);
	angles[17] = (0, 450, 0);
	at[17] = 8.6667;
	points[18] = (-2131.8188, 4207.7168, 1398.9370);
	angles[18] = (0, 460, 0);
	at[18] = 8.7333;
	points[19] = (-2131.8188, 4207.7168, 1398.9370);
	angles[19] = (0, 620, 0);
	at[19] = 9.2667;
	points[20] = (-2131.8188, 4207.7168, 1413.7008);
	angles[20] = (0, 630, 0);
	at[20] = 9.3333;
	points[21] = (-2131.8188, 4207.7168, 1531.8110);
	angles[21] = (0, 630, 0);
	at[21] = 9.4667;
	points[22] = (-2131.8188, 4207.7168, 1516.4568);
	angles[22] = (0, 630, 0);
	at[22] = 9.5333;
	points[23] = (-2131.8188, 4207.7168, 1406.0237);
	angles[23] = (0, 630, 0);
	at[23] = 9.6000;
	points[24] = (-2131.8188, 4207.7168, 1223.2480);
	angles[24] = (0, 630, 0);
	at[24] = 9.6667;
	points[25] = (-2131.8188, 4207.7168, 1223.2480);
	angles[25] = (0, 630, 0);
	at[25] = 10.6667;
	points[26] = (-2131.8188, 4207.7168, 1398.9370);
	angles[26] = (0, 630, 0);
	at[26] = 11.6667;
	points[27] = (-2131.8188, 4207.7168, 1398.9370);
	angles[27] = (0, 450, 0);
	at[27] = 12.2667;
	points[28] = (-2131.8188, 4207.7168, 1398.9370);
	angles[28] = (0, 550, 0);
	at[28] = 12.6000;
	points[29] = (-2131.8188, 4207.7168, 1398.9370);
	angles[29] = (0, 630, 0);
	at[29] = 12.8667;
	points[30] = (-2111.5081, 4207.7168, 1398.9370);
	angles[30] = (0, 630, 0);
	at[30] = 12.9000;
	mover = getEnt("iz_obj_1", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_2()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-797.3740, 4626.2603, 1398.9370);
	angles[0] = (0, -80, 0);
	at[0] = 0;
	points[1] = (-797.3740, 4626.2603, 1398.9370);
	angles[1] = (0, 80, 0);
	at[1] = 0.5333;
	points[2] = (-817.6850, 4626.2603, 1398.9370);
	angles[2] = (0, 90, 0);
	at[2] = 0.6000;
	points[3] = (-2103.9055, 4626.2603, 1398.9370);
	angles[3] = (0, 90, 0);
	at[3] = 2.8000;
	points[4] = (-2133.1379, 4626.2603, 1398.9370);
	angles[4] = (0, 95, 0);
	at[4] = 2.8667;
	points[5] = (-2133.1379, 4626.2603, 1398.9370);
	angles[5] = (0, 255, 0);
	at[5] = 3.4000;
	points[6] = (-2133.1379, 4626.2603, 1398.9370);
	angles[6] = (0, 270, 0);
	at[6] = 3.4667;
	points[7] = (-2133.1379, 4626.2603, 1517.0472);
	angles[7] = (0, 270, 0);
	at[7] = 3.6000;
	points[8] = (-2133.1379, 4626.2603, 1531.5159);
	angles[8] = (0, 270, 0);
	at[8] = 3.6667;
	points[9] = (-2133.1379, 4626.2603, 1441.1614);
	angles[9] = (0, 270, 0);
	at[9] = 3.7333;
	points[10] = (-2133.1379, 4626.2603, 1270.4922);
	angles[10] = (0, 270, 0);
	at[10] = 3.8000;
	points[11] = (-2133.1379, 4626.2603, 1223.2480);
	angles[11] = (0, 270, 0);
	at[11] = 3.8667;
	points[12] = (-2133.1379, 4626.2603, 1223.2480);
	angles[12] = (0, 270, 0);
	at[12] = 4.8000;
	points[13] = (-2133.1379, 4626.2603, 1232.1063);
	angles[13] = (0, 270, 0);
	at[13] = 4.8667;
	points[14] = (-2133.1379, 4626.2603, 1397.4606);
	angles[14] = (0, 270, 0);
	at[14] = 5.8000;
	points[15] = (-2133.1379, 4626.2603, 1398.9370);
	angles[15] = (0, 285, 0);
	at[15] = 5.8667;
	points[16] = (-2133.1379, 4626.2603, 1398.9370);
	angles[16] = (0, 445, 0);
	at[16] = 6.4000;
	points[17] = (-2133.1379, 4626.2603, 1398.9370);
	angles[17] = (0, 625, 0);
	at[17] = 7;
	points[18] = (-2100.4448, 4626.2603, 1398.9370);
	angles[18] = (0, 630, 0);
	at[18] = 7.0667;
	points[19] = (-814.2244, 4626.2603, 1398.9370);
	angles[19] = (0, 630, 0);
	at[19] = 9.2667;
	points[20] = (-797.3740, 4626.2603, 1398.9370);
	angles[20] = (0, 640, 0);
	at[20] = 9.3333;
	points[21] = (-797.3740, 4626.2603, 1398.9370);
	angles[21] = (0, 460, 0);
	at[21] = 9.9333;
	points[22] = (-797.3740, 4626.2603, 1398.9370);
	angles[22] = (0, 620, 0);
	at[22] = 10.4667;
	points[23] = (-797.3740, 4626.2603, 1413.7008);
	angles[23] = (0, 630, 0);
	at[23] = 10.5333;
	points[24] = (-797.3740, 4626.2603, 1531.8110);
	angles[24] = (0, 630, 0);
	at[24] = 10.6667;
	points[25] = (-797.3740, 4626.2603, 1516.4568);
	angles[25] = (0, 630, 0);
	at[25] = 10.7333;
	points[26] = (-797.3740, 4626.2603, 1406.0237);
	angles[26] = (0, 630, 0);
	at[26] = 10.8000;
	points[27] = (-797.3740, 4626.2603, 1223.2480);
	angles[27] = (0, 630, 0);
	at[27] = 10.8667;
	points[28] = (-797.3740, 4626.2603, 1223.2480);
	angles[28] = (0, 630, 0);
	at[28] = 11.8667;
	points[29] = (-797.3740, 4626.2603, 1398.9370);
	angles[29] = (0, 630, 0);
	at[29] = 12.8667;
	points[30] = (-797.3740, 4626.2603, 1398.9370);
	angles[30] = (0, 640, 0);
	at[30] = 12.9000;
	mover = getEnt("iz_obj_2", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_3()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-3896.2993, -2864.3623, 2258.5552);
	angles[0] = (0, -90, 0);
	at[0] = 0;
	points[1] = (-3896.2993, -2864.3623, 2258.5552);
	angles[1] = (0, -90, 0);
	at[1] = 0.4500;
	points[2] = (-3896.2993, -2864.3623, 2266.2283);
	angles[2] = (0, -90, 0);
	at[2] = 0.5000;
	points[3] = (-3896.2993, -2864.3623, 2262.9844);
	angles[3] = (0, -90, 0);
	at[3] = 0.5500;
	points[4] = (-3896.2993, -2864.3623, 2250.8860);
	angles[4] = (0, -90, 0);
	at[4] = 0.6000;
	points[5] = (-3896.2993, -2864.3623, 2254.1260);
	angles[5] = (0, -90, 0);
	at[5] = 0.6500;
	points[6] = (-3896.2993, -2864.3623, 2266.2283);
	angles[6] = (0, -90, 0);
	at[6] = 0.7000;
	points[7] = (-3896.2993, -2864.3623, 2262.9844);
	angles[7] = (0, -90, 0);
	at[7] = 0.7500;
	points[8] = (-3896.2993, -2864.3623, 2250.8860);
	angles[8] = (0, -90, 0);
	at[8] = 0.8000;
	points[9] = (-3896.2993, -2864.3623, 2254.1260);
	angles[9] = (0, -90, 0);
	at[9] = 0.8500;
	points[10] = (-3896.2993, -2864.3623, 2266.2283);
	angles[10] = (0, -90, 0);
	at[10] = 0.9000;
	points[11] = (-3896.2993, -2864.3623, 2262.9844);
	angles[11] = (0, -90, 0);
	at[11] = 0.9500;
	points[12] = (-3896.2993, -2864.3623, 2268.8896);
	angles[12] = (0, -90, 0);
	at[12] = 1;
	points[13] = (-3896.2993, -2864.3623, 2401.7637);
	angles[13] = (0, -90, 0);
	at[13] = 1.1500;
	points[14] = (-3896.2993, -2864.3623, 2371.6458);
	angles[14] = (0, -90, 0);
	at[14] = 1.2000;
	points[15] = (-3896.2993, -2864.3623, 2296.3503);
	angles[15] = (0, -90, 0);
	at[15] = 1.2500;
	points[16] = (-3896.2993, -2864.3623, 2057.7717);
	angles[16] = (0, -90, 0);
	at[16] = 1.3500;
	points[17] = (-3896.2993, -2864.3623, 2057.7717);
	angles[17] = (0, -90, 0);
	at[17] = 2.3500;
	points[18] = (-3896.2993, -2864.3623, 2252.6536);
	angles[18] = (0, -90, 0);
	at[18] = 3.4500;
	points[19] = (-3896.2993, -2864.3623, 2258.5552);
	angles[19] = (0, -90, 0);
	at[19] = 3.5000;
	points[20] = (-3896.2993, -2864.3623, 2258.5552);
	angles[20] = (0, -90, 0);
	at[20] = 4;
	mover = getEnt("iz_obj_3", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_4()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-9743.9375, -671.7559, 2228.1221);
	angles[0] = (0, 90, -66.4789);
	at[0] = 0;
	points[1] = (-9744.0947, -671.7559, 2208.7244);
	angles[1] = (0, 90, -77.8729);
	at[1] = 0.0500;
	points[2] = (-9744.0947, -671.7559, 2189.2363);
	angles[2] = (0, 90, -83.7795);
	at[2] = 0.1000;
	points[3] = (-9744.0947, -671.7559, 2150.2598);
	angles[3] = (0, 90, -88.3683);
	at[3] = 0.2000;
	points[4] = (-9744.0947, -671.7559, 2089.7874);
	angles[4] = (0, 90, -89.7809);
	at[4] = 0.3500;
	points[5] = (-9744.0947, -671.7559, 2041.1024);
	angles[5] = (0, 90, -89.9425);
	at[5] = 0.4500;
	points[6] = (-9744.0947, -671.7559, 1983.5276);
	angles[6] = (0, 90, -89.9849);
	at[6] = 0.5500;
	points[7] = (-9744.0947, -671.7559, 1952.2875);
	angles[7] = (0, 90, -89.9922);
	at[7] = 0.6000;
	points[8] = (-9744.0947, -671.7559, 1919.5433);
	angles[8] = (0, 90, 0);
	at[8] = 0.6500;
	points[9] = (-9744.0947, -671.7559, 1849.2560);
	angles[9] = (0, 90, 0);
	at[9] = 0.7500;
	points[10] = (-9744.0947, -671.7559, 1811.5591);
	angles[10] = (0, 0, 0);
	at[10] = 0.8000;
	points[11] = (-9744.0947, -671.7559, 1730.6458);
	angles[11] = (0, 0, 0);
	at[11] = 0.9000;
	points[12] = (-9744.0947, -671.7559, 1603.8228);
	angles[12] = (0, 0, 0);
	at[12] = 1.0500;
	points[13] = (-9744.0947, -671.7559, 1523.9883);
	angles[13] = (0, 0, 0);
	at[13] = 1.1500;
	points[14] = (-9744.0947, -671.7559, 1447.8938);
	angles[14] = (0, 0, 0);
	at[14] = 1.2500;
	points[15] = (-9744.0947, -671.7559, 1340.3859);
	angles[15] = (0, 0, 0);
	at[15] = 1.4000;
	points[16] = (-9744.0947, -671.7559, 1240.3425);
	angles[16] = (0, 0, 0);
	at[16] = 1.5500;
	points[17] = (-9744.0947, -671.7559, 1147.2520);
	angles[17] = (0, 0, 0);
	at[17] = 1.7000;
	points[18] = (-9744.0947, -671.7559, 1060.6260);
	angles[18] = (0, 0, 0);
	at[18] = 1.8500;
	points[19] = (-9744.0947, -671.7559, 954.4095);
	angles[19] = (0, 0, 0);
	at[19] = 2.0500;
	points[20] = (-9744.0947, -671.7559, 857.9173);
	angles[20] = (0, 0, 0);
	at[20] = 2.2500;
	points[21] = (-9744.0947, -671.7559, 749.6260);
	angles[21] = (0, 0, 0);
	at[21] = 2.5000;
	points[22] = (-9744.0947, -671.7559, 66.7055);
	angles[22] = (0, 0, 0);
	at[22] = 4.2500;
	points[23] = (-9744.0947, -671.7559, 47.2173);
	angles[23] = (0, -90, -88.5004);
	at[23] = 4.3000;
	points[24] = (-9738.5039, -671.7559, 8.6079);
	angles[24] = (0, -90, -84.0675);
	at[24] = 4.4000;
	points[25] = (-9737.4014, -671.7559, 11.3989);
	angles[25] = (0, -90, -78.9267);
	at[25] = 4.4500;
	points[26] = (-9737.4014, -671.7559, 30.8871);
	angles[26] = (0, -90, -64.2674);
	at[26] = 4.5000;
	points[27] = (-9737.4014, -671.7559, 50.3752);
	angles[27] = (0, -90, -34.4617);
	at[27] = 4.5500;
	points[28] = (-9737.4014, -671.7559, 69.8634);
	angles[28] = (0, -90, 7.7610);
	at[28] = 4.6000;
	points[29] = (-9737.4014, -671.7559, 89.3516);
	angles[29] = (0, -90, 43.7088);
	at[29] = 4.6500;
	points[30] = (-9737.4014, -671.7559, 108.8398);
	angles[30] = (0, -90, 65.6327);
	at[30] = 4.7000;
	points[31] = (-9737.4014, -671.7559, 128.6413);
	angles[31] = (0, -90, 77.4302);
	at[31] = 4.7500;
	points[32] = (-9737.4014, -671.7559, 149.1638);
	angles[32] = (0, -90, 83.5516);
	at[32] = 4.8000;
	points[33] = (-9737.4014, -671.7559, 215.3283);
	angles[33] = (0, -90, 89.1340);
	at[33] = 4.9500;
	points[34] = (-9737.4014, -671.7559, 263.5528);
	angles[34] = (0, -90, 89.7729);
	at[34] = 5.0500;
	points[35] = (-9737.4014, -671.7559, 342.6807);
	angles[35] = (0, -90, 89.9695);
	at[35] = 5.2000;
	points[36] = (-9737.4014, -671.7559, 400.3543);
	angles[36] = (0, -90, 89.9920);
	at[36] = 5.3000;
	points[37] = (-9737.4014, -671.7559, 430.7756);
	angles[37] = (0, -90, 0);
	at[37] = 5.3500;
	points[38] = (-9737.4014, -671.7559, 494.9843);
	angles[38] = (0, -90, 0);
	at[38] = 5.4500;
	points[39] = (-9737.4014, -671.7559, 528.8544);
	angles[39] = (0, 0, 0);
	at[39] = 5.5000;
	points[40] = (-9737.4014, -671.7559, 600.3386);
	angles[40] = (0, 0, 0);
	at[40] = 5.6000;
	points[41] = (-9737.4014, -671.7559, 677.1299);
	angles[41] = (0, 0, 0);
	at[41] = 5.7000;
	points[42] = (-9737.4014, -671.7559, 759.6181);
	angles[42] = (0, 0, 0);
	at[42] = 5.8000;
	points[43] = (-9737.4014, -671.7559, 1016.1221);
	angles[43] = (0, 0, 0);
	at[43] = 6.1000;
	points[44] = (-9737.4014, -671.7559, 1182.4252);
	angles[44] = (0, 0, 0);
	at[44] = 6.3000;
	points[45] = (-9737.4014, -671.7559, 1424.8820);
	angles[45] = (0, 0, 0);
	at[45] = 6.6000;
	points[46] = (-9737.4014, -671.7559, 1619.8820);
	angles[46] = (0, 0, 0);
	at[46] = 6.8500;
	points[47] = (-9737.4014, -671.7559, 1729.3741);
	angles[47] = (0, 0, 0);
	at[47] = 7;
	points[48] = (-9737.4014, -671.7559, 1832.2480);
	angles[48] = (0, 0, 0);
	at[48] = 7.1500;
	points[49] = (-9737.4014, -671.7559, 1959.8031);
	angles[49] = (0, 0, 0);
	at[49] = 7.3500;
	points[50] = (-9737.4014, -671.7559, 2048.1104);
	angles[50] = (0, 0, 0);
	at[50] = 7.5000;
	points[51] = (-9737.4014, -671.7559, 2074.0945);
	angles[51] = (0, 0, 0);
	at[51] = 7.5500;
	points[52] = (-9737.4014, -671.7559, 2119.6182);
	angles[52] = (0, 0, 0);
	at[52] = 7.6500;
	points[53] = (-9737.4014, -671.7559, 2236.8818);
	angles[53] = (0, 0, 0);
	at[53] = 7.9500;
	points[54] = (-9737.4014, -671.7559, 2268.2441);
	angles[54] = (0, 0, 0);
	at[54] = 8.0500;
	points[55] = (-9737.4014, -671.7559, 2299.0120);
	angles[55] = (0, 0, 0);
	at[55] = 8.2000;
	points[56] = (-9737.7949, -671.7559, 2297.7639);
	angles[56] = (0, 90, 86.0856);
	at[56] = 8.2500;
	points[57] = (-9738.5039, -671.7559, 2289.5591);
	angles[57] = (0, 90, 74.0717);
	at[57] = 8.3000;
	points[58] = (-9739.3701, -671.7559, 2279.9370);
	angles[58] = (0, 90, 48.4737);
	at[58] = 8.3500;
	points[59] = (-9741.5352, -671.7559, 2255.4292);
	angles[59] = (0, 90, -31.1368);
	at[59] = 8.4500;
	points[60] = (-9742.9131, -671.7559, 2239.9175);
	angles[60] = (0, 90, -56.3298);
	at[60] = 8.5000;
	points[61] = (-9743.9375, -671.7559, 2228.1221);
	angles[61] = (0, 90, -66.4789);
	at[61] = 8.5333;
	mover = getEnt("iz_obj_4", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_5()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-8862.3623, -2087.6929, 2901.5669);
	angles[0] = (0, -90, -62.9582);
	at[0] = 0;
	points[1] = (-8856.7324, -2087.6929, 2878.7874);
	angles[1] = (0, -90, -72.0856);
	at[1] = 0.0500;
	points[2] = (-8858.2676, -2087.6929, 2853.7993);
	angles[2] = (0, -90, -80.7909);
	at[2] = 0.1000;
	points[3] = (-8858.2676, -2087.6929, 2828.9961);
	angles[3] = (0, -90, -85.2798);
	at[3] = 0.1500;
	points[4] = (-8858.2676, -2087.6929, 2729.1260);
	angles[4] = (0, -90, -89.6755);
	at[4] = 0.3500;
	points[5] = (-8858.2676, -2087.6929, 2701.2598);
	angles[5] = (0, -90, -89.8340);
	at[5] = 0.4000;
	points[6] = (-8858.2676, -2087.6929, 2637.1140);
	angles[6] = (0, -90, -89.9565);
	at[6] = 0.5000;
	points[7] = (-8858.2676, -2087.6929, 2561.0195);
	angles[7] = (0, -90, -89.9885);
	at[7] = 0.6000;
	points[8] = (-8858.2676, -2087.6929, 2519.8464);
	angles[8] = (0, -90, -89.9940);
	at[8] = 0.6500;
	points[9] = (-8858.2676, -2087.6929, 2476.6692);
	angles[9] = (0, -90, 0);
	at[9] = 0.7000;
	points[10] = (-8858.2676, -2087.6929, 2383.9016);
	angles[10] = (0, -90, 0);
	at[10] = 0.8000;
	points[11] = (-8858.2676, -2087.6929, 2334.1025);
	angles[11] = (0, 0, 0);
	at[11] = 0.8500;
	points[12] = (-8858.2676, -2087.6929, 2281.8779);
	angles[12] = (0, 0, 0);
	at[12] = 0.9000;
	points[13] = (-8858.2676, -2087.6929, 2062.3347);
	angles[13] = (0, 0, 0);
	at[13] = 1.1000;
	points[14] = (-8858.2676, -2087.6929, 1959.0198);
	angles[14] = (0, 0, 0);
	at[14] = 1.2000;
	points[15] = (-8858.2676, -2087.6929, 1860.6891);
	angles[15] = (0, 0, 0);
	at[15] = 1.3000;
	points[16] = (-8858.2676, -2087.6929, 1722);
	angles[16] = (0, 0, 0);
	at[16] = 1.4500;
	points[17] = (-8858.2676, -2087.6929, 1593.2166);
	angles[17] = (0, 0, 0);
	at[17] = 1.6000;
	points[18] = (-8858.2676, -2087.6929, 1473.6299);
	angles[18] = (0, 0, 0);
	at[18] = 1.7500;
	points[19] = (-8858.2676, -2087.6929, 1362.5865);
	angles[19] = (0, 0, 0);
	at[19] = 1.9000;
	points[20] = (-8858.2676, -2087.6929, 1226.7599);
	angles[20] = (0, 0, 0);
	at[20] = 2.1000;
	points[21] = (-8858.2676, -2087.6929, 1103.7087);
	angles[21] = (0, 0, 0);
	at[21] = 2.3000;
	points[22] = (-8858.2676, -2087.6929, 1046.5984);
	angles[22] = (0, 0, 0);
	at[22] = 2.4000;
	points[23] = (-8858.2676, -2087.6929, 966.0472);
	angles[23] = (0, 0, 0);
	at[23] = 2.5500;
	points[24] = (-8858.2676, -2087.6929, 72.2323);
	angles[24] = (0, 0, 0);
	at[24] = 4.3500;
	points[25] = (-8864.7246, -2087.6929, 48.5807);
	angles[25] = (0, 90, -80.1898);
	at[25] = 4.4000;
	points[26] = (-8881.8506, -2087.6929, 2.0290);
	angles[26] = (0, 90, -72.5193);
	at[26] = 4.5000;
	points[27] = (-8882.5195, -2087.6929, 23.2509);
	angles[27] = (0, 90, -50.4691);
	at[27] = 4.5500;
	points[28] = (-8882.5195, -2087.6929, 72.8571);
	angles[28] = (0, 90, 28.7862);
	at[28] = 4.6500;
	points[29] = (-8882.5195, -2087.6929, 97.6602);
	angles[29] = (0, 90, 57.0581);
	at[29] = 4.7000;
	points[30] = (-8882.5195, -2087.6929, 122.4634);
	angles[30] = (0, 90, 72.8994);
	at[30] = 4.7500;
	points[31] = (-8882.5195, -2087.6929, 147.2760);
	angles[31] = (0, 90, 81.2124);
	at[31] = 4.8000;
	points[32] = (-8882.5195, -2087.6929, 172.7256);
	angles[32] = (0, 90, 85.4963);
	at[32] = 4.8500;
	points[33] = (-8882.5195, -2087.6929, 254.9457);
	angles[33] = (0, 90, 89.3954);
	at[33] = 5;
	points[34] = (-8882.5195, -2087.6929, 315.0268);
	angles[34] = (0, 90, 89.8415);
	at[34] = 5.1000;
	points[35] = (-8882.5195, -2087.6929, 379.6988);
	angles[35] = (0, 90, 89.9585);
	at[35] = 5.2000;
	points[36] = (-8882.5195, -2087.6929, 449.3110);
	angles[36] = (0, 90, 89.9890);
	at[36] = 5.3000;
	points[37] = (-8882.5195, -2087.6929, 486.0905);
	angles[37] = (0, 90, 0);
	at[37] = 5.3500;
	points[38] = (-8882.5195, -2087.6929, 604.9055);
	angles[38] = (0, 90, 0);
	at[38] = 5.5000;
	points[39] = (-8882.5195, -2087.6929, 647.5157);
	angles[39] = (0, 0, 0);
	at[39] = 5.5500;
	points[40] = (-8882.5195, -2087.6929, 785.1851);
	angles[40] = (0, 0, 0);
	at[40] = 5.7000;
	points[41] = (-8882.5195, -2087.6929, 885.7834);
	angles[41] = (0, 0, 0);
	at[41] = 5.8000;
	points[42] = (-8882.5195, -2087.6929, 994.0670);
	angles[42] = (0, 0, 0);
	at[42] = 5.9000;
	points[43] = (-8882.5195, -2087.6929, 1273.5826);
	angles[43] = (0, 0, 0);
	at[43] = 6.1500;
	points[44] = (-8882.5195, -2087.6929, 1544.6968);
	angles[44] = (0, 0, 0);
	at[44] = 6.4000;
	points[45] = (-8882.5195, -2087.6929, 1807.5945);
	angles[45] = (0, 0, 0);
	at[45] = 6.6500;
	points[46] = (-8882.5195, -2087.6929, 2062.2244);
	angles[46] = (0, 0, 0);
	at[46] = 6.9000;
	points[47] = (-8882.5195, -2087.6929, 2206.4094);
	angles[47] = (0, 0, 0);
	at[47] = 7.0500;
	points[48] = (-8882.5195, -2087.6929, 2385.4211);
	angles[48] = (0, 0, 0);
	at[48] = 7.2500;
	points[49] = (-8882.5195, -2087.6929, 2550.3977);
	angles[49] = (0, 0, 0);
	at[49] = 7.4500;
	points[50] = (-8882.5195, -2087.6929, 2663.9370);
	angles[50] = (0, 0, 0);
	at[50] = 7.6000;
	points[51] = (-8882.5195, -2087.6929, 2696.6892);
	angles[51] = (0, 0, 0);
	at[51] = 7.6500;
	points[52] = (-8882.5195, -2087.6929, 2753.6614);
	angles[52] = (0, 0, 0);
	at[52] = 7.7500;
	points[53] = (-8882.5195, -2087.6929, 2902.3464);
	angles[53] = (0, 0, 0);
	at[53] = 8.0500;
	points[54] = (-8882.5195, -2087.6929, 2942.2126);
	angles[54] = (0, 0, 0);
	at[54] = 8.1500;
	points[55] = (-8882.5195, -2087.6929, 2971.6577);
	angles[55] = (0, 0, 0);
	at[55] = 8.2500;
	points[56] = (-8882.5195, -2087.6929, 2983.9331);
	angles[56] = (0, -90, 85.4663);
	at[56] = 8.3000;
	points[57] = (-8879.5674, -2087.6929, 2970.9802);
	angles[57] = (0, -90, 62.4164);
	at[57] = 8.3500;
	points[58] = (-8872.8740, -2087.6929, 2943.9958);
	angles[58] = (0, -90, -17.1014);
	at[58] = 8.4500;
	points[59] = (-8868.7793, -2087.6929, 2927.4607);
	angles[59] = (0, -90, -44.4697);
	at[59] = 8.5000;
	points[60] = (-8862.3623, -2087.6929, 2901.5669);
	angles[60] = (0, -90, -62.9582);
	at[60] = 8.5667;
	mover = getEnt("iz_obj_5", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_6()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-8564.6855, -484.7441, 3047.7795);
	angles[0] = (0, -90, -36.8450);
	at[0] = 0;
	points[1] = (-8562.7949, -484.7441, 3023.2246);
	angles[1] = (0, -90, -60.6687);
	at[1] = 0.0500;
	points[2] = (-8562.9922, -484.7441, 2996.6458);
	angles[2] = (0, -90, -74.8178);
	at[2] = 0.1000;
	points[3] = (-8562.9922, -484.7441, 2970.0708);
	angles[3] = (0, -90, -82.2042);
	at[3] = 0.1500;
	points[4] = (-8562.9922, -484.7441, 2916.9211);
	angles[4] = (0, -90, -87.9544);
	at[4] = 0.2500;
	points[5] = (-8562.9922, -484.7441, 2833.6182);
	angles[5] = (0, -90, -89.7255);
	at[5] = 0.4000;
	points[6] = (-8562.9922, -484.7441, 2766);
	angles[6] = (0, -90, -89.9281);
	at[6] = 0.5000;
	points[7] = (-8562.9922, -484.7441, 2686.3464);
	angles[7] = (0, -90, -89.9812);
	at[7] = 0.6000;
	points[8] = (-8562.9922, -484.7441, 2643.2756);
	angles[8] = (0, -90, -89.9904);
	at[8] = 0.6500;
	points[9] = (-8562.9922, -484.7441, 2598.1101);
	angles[9] = (0, -90, 0);
	at[9] = 0.7000;
	points[10] = (-8562.9922, -484.7441, 2501.0789);
	angles[10] = (0, -90, 0);
	at[10] = 0.8000;
	points[11] = (-8562.9922, -484.7441, 2448.9961);
	angles[11] = (0, -90, 0);
	at[11] = 0.8500;
	points[12] = (-8562.9922, -484.7441, 2394.3779);
	angles[12] = (0, 0, 0);
	at[12] = 0.9000;
	points[13] = (-8562.9922, -484.7441, 2220.6418);
	angles[13] = (0, 0, 0);
	at[13] = 1.0500;
	points[14] = (-8562.9922, -484.7441, 2056.0159);
	angles[14] = (0, 0, 0);
	at[14] = 1.2000;
	points[15] = (-8562.9922, -484.7441, 1902.9135);
	angles[15] = (0, 0, 0);
	at[15] = 1.3500;
	points[16] = (-8562.9922, -484.7441, 1760.5355);
	angles[16] = (0, 0, 0);
	at[16] = 1.5000;
	points[17] = (-8562.9922, -484.7441, 1628.1260);
	angles[17] = (0, 0, 0);
	at[17] = 1.6500;
	points[18] = (-8562.9922, -484.7441, 1504.9921);
	angles[18] = (0, 0, 0);
	at[18] = 1.8000;
	points[19] = (-8562.9922, -484.7441, 1390.4764);
	angles[19] = (0, 0, 0);
	at[19] = 1.9500;
	points[20] = (-8562.9922, -484.7441, 1283.9843);
	angles[20] = (0, 0, 0);
	at[20] = 2.1000;
	points[21] = (-8562.9922, -484.7441, 1153.5000);
	angles[21] = (0, 0, 0);
	at[21] = 2.3000;
	points[22] = (-8562.9922, -484.7441, 1092.8466);
	angles[22] = (0, 0, 0);
	at[22] = 2.4000;
	points[23] = (-8562.9922, -484.7441, 1007.1929);
	angles[23] = (0, 0, 0);
	at[23] = 2.5500;
	points[24] = (-8562.9922, -484.7441, 76.3921);
	angles[24] = (0, 0, 0);
	at[24] = 4.3000;
	points[25] = (-8565.1973, -484.7441, 49.9417);
	angles[25] = (0, 90, -86.8470);
	at[25] = 4.3500;
	points[26] = (-8571.1807, -484.7441, -2.8701);
	angles[26] = (0, 90, -82.8333);
	at[26] = 4.4500;
	points[27] = (-8570.8271, -484.7441, 30.0557);
	angles[27] = (0, 90, -73.1555);
	at[27] = 4.5000;
	points[28] = (-8570.8271, -484.7441, 56.6303);
	angles[28] = (0, 90, -51.7889);
	at[28] = 4.5500;
	points[29] = (-8570.8271, -484.7441, 109.7799);
	angles[29] = (0, 90, 27.2064);
	at[29] = 4.6500;
	points[30] = (-8570.8271, -484.7441, 136.3547);
	angles[30] = (0, 90, 56.1137);
	at[30] = 4.7000;
	points[31] = (-8570.8271, -484.7441, 163.0425);
	angles[31] = (0, 90, 72.3949);
	at[31] = 4.7500;
	points[32] = (-8570.8271, -484.7441, 190.6039);
	angles[32] = (0, 90, 80.9510);
	at[32] = 4.8000;
	points[33] = (-8570.8271, -484.7441, 219.1776);
	angles[33] = (0, 90, 85.3622);
	at[33] = 4.8500;
	points[34] = (-8570.8271, -484.7441, 311.3547);
	angles[34] = (0, 90, 89.3774);
	at[34] = 5;
	points[35] = (-8570.8271, -484.7441, 378.5890);
	angles[35] = (0, 90, 89.8367);
	at[35] = 5.1000;
	points[36] = (-8570.8271, -484.7441, 488.9921);
	angles[36] = (0, 90, 89.9780);
	at[36] = 5.2500;
	points[37] = (-8570.8271, -484.7441, 569.5197);
	angles[37] = (0, 90, 89.9943);
	at[37] = 5.3500;
	points[38] = (-8570.8271, -484.7441, 612.0157);
	angles[38] = (0, 90, 0);
	at[38] = 5.4000;
	points[39] = (-8570.8271, -484.7441, 656.0748);
	angles[39] = (0, 90, 0);
	at[39] = 5.4500;
	points[40] = (-8570.8271, -484.7441, 701.7520);
	angles[40] = (0, 90, 0);
	at[40] = 5.5000;
	points[41] = (-8570.8271, -484.7441, 749.1063);
	angles[41] = (0, 0, 0);
	at[41] = 5.5500;
	points[42] = (-8570.8271, -484.7441, 849.0984);
	angles[42] = (0, 0, 0);
	at[42] = 5.6500;
	points[43] = (-8570.8271, -484.7441, 956.5787);
	angles[43] = (0, 0, 0);
	at[43] = 5.7500;
	points[44] = (-8570.8271, -484.7441, 1364.0631);
	angles[44] = (0, 0, 0);
	at[44] = 6.1000;
	points[45] = (-8570.8271, -484.7441, 1647.6458);
	angles[45] = (0, 0, 0);
	at[45] = 6.3500;
	points[46] = (-8570.8271, -484.7441, 1923.0275);
	angles[46] = (0, 0, 0);
	at[46] = 6.6000;
	points[47] = (-8570.8271, -484.7441, 2189.6377);
	angles[47] = (0, 0, 0);
	at[47] = 6.8500;
	points[48] = (-8570.8271, -484.7441, 2339.6338);
	angles[48] = (0, 0, 0);
	at[48] = 7;
	points[49] = (-8570.8271, -484.7441, 2480.5354);
	angles[49] = (0, 0, 0);
	at[49] = 7.1500;
	points[50] = (-8570.8271, -484.7441, 2655.2009);
	angles[50] = (0, 0, 0);
	at[50] = 7.3500;
	points[51] = (-8570.8271, -484.7441, 2776.4175);
	angles[51] = (0, 0, 0);
	at[51] = 7.5000;
	points[52] = (-8570.8271, -484.7441, 2812.4253);
	angles[52] = (0, 0, 0);
	at[52] = 7.5500;
	points[53] = (-8570.8271, -484.7441, 2875.4805);
	angles[53] = (0, 0, 0);
	at[53] = 7.6500;
	points[54] = (-8570.8271, -484.7441, 3035.9055);
	angles[54] = (0, 0, 0);
	at[54] = 7.9500;
	points[55] = (-8570.8271, -484.7441, 3081.1614);
	angles[55] = (0, 0, 0);
	at[55] = 8.0500;
	points[56] = (-8570.8271, -484.7441, 3115.0750);
	angles[56] = (0, 0, 0);
	at[56] = 8.1500;
	points[57] = (-8570.8271, -484.7441, 3129.5789);
	angles[57] = (0, -90, 88.5511);
	at[57] = 8.2000;
	points[58] = (-8569.7246, -484.7441, 3114.1731);
	angles[58] = (0, -90, 80.6732);
	at[58] = 8.2500;
	points[59] = (-8568.5830, -484.7441, 3099.1812);
	angles[59] = (0, -90, 62.8732);
	at[59] = 8.3000;
	points[60] = (-8567.2832, -484.7441, 3082.0276);
	angles[60] = (0, -90, 28.8953);
	at[60] = 8.3500;
	points[61] = (-8565.7871, -484.7441, 3062.4058);
	angles[61] = (0, -90, -13.5453);
	at[61] = 8.4000;
	points[62] = (-8564.6855, -484.7441, 3047.7795);
	angles[62] = (0, -90, -36.8450);
	at[62] = 8.4333;
	mover = getEnt("iz_obj_6", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_7()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-6615.2759, 12680, 2883.2795);
	angles[0] = (0, -90, -65.5596);
	at[0] = 0;
	points[1] = (-6614.1733, 12680, 2858.9844);
	angles[1] = (0, -90, -76.4407);
	at[1] = 0.0500;
	points[2] = (-6614.1733, 12680, 2809.3779);
	angles[2] = (0, -90, -86.4351);
	at[2] = 0.1500;
	points[3] = (-6614.1733, 12680, 2734.9685);
	angles[3] = (0, -90, -89.5213);
	at[3] = 0.3000;
	points[4] = (-6614.1733, 12680, 2680.0471);
	angles[4] = (0, -90, -89.8745);
	at[4] = 0.4000;
	points[5] = (-6614.1733, 12680, 2614.6692);
	angles[5] = (0, -90, -89.9672);
	at[5] = 0.5000;
	points[6] = (-6614.1733, 12680, 2538.4961);
	angles[6] = (0, -90, -89.9913);
	at[6] = 0.6000;
	points[7] = (-6614.1733, 12680, 2497.3740);
	angles[7] = (0, -90, 0);
	at[7] = 0.6500;
	points[8] = (-6614.1733, 12680, 2408.7046);
	angles[8] = (0, -90, 0);
	at[8] = 0.7500;
	points[9] = (-6614.1733, 12680, 2360.9331);
	angles[9] = (0, -90, 0);
	at[9] = 0.8000;
	points[10] = (-6614.1733, 12680, 2310.7126);
	angles[10] = (0, 0, 0);
	at[10] = 0.8500;
	points[11] = (-6614.1733, 12680, 2091.9961);
	angles[11] = (0, 0, 0);
	at[11] = 1.0500;
	points[12] = (-6614.1733, 12680, 1986.9094);
	angles[12] = (0, 0, 0);
	at[12] = 1.1500;
	points[13] = (-6614.1733, 12680, 1838.7284);
	angles[13] = (0, 0, 0);
	at[13] = 1.3000;
	points[14] = (-6614.1733, 12680, 1701.1653);
	angles[14] = (0, 0, 0);
	at[14] = 1.4500;
	points[15] = (-6614.1733, 12680, 1573.4607);
	angles[15] = (0, 0, 0);
	at[15] = 1.6000;
	points[16] = (-6614.1733, 12680, 1454.9056);
	angles[16] = (0, 0, 0);
	at[16] = 1.7500;
	points[17] = (-6614.1733, 12680, 1344.8464);
	angles[17] = (0, 0, 0);
	at[17] = 1.9000;
	points[18] = (-6614.1733, 12680, 1210.2678);
	angles[18] = (0, 0, 0);
	at[18] = 2.1000;
	points[19] = (-6614.1733, 12680, 1088.3898);
	angles[19] = (0, 0, 0);
	at[19] = 2.3000;
	points[20] = (-6614.1733, 12680, 1031.8386);
	angles[20] = (0, 0, 0);
	at[20] = 2.4000;
	points[21] = (-6614.1733, 12680, 952.0906);
	angles[21] = (0, 0, 0);
	at[21] = 2.5500;
	points[22] = (-6614.1733, 12680, 83.4693);
	angles[22] = (0, 0, 0);
	at[22] = 4.3000;
	points[23] = (-6614.1733, 12680, 58.6661);
	angles[23] = (0, 90, -87.7668);
	at[23] = 4.3500;
	points[24] = (-6625.1968, 12680, 10.1421);
	angles[24] = (0, 90, -81.1533);
	at[24] = 4.4500;
	points[25] = (-6627.1655, 12680, 15.0604);
	angles[25] = (0, 90, -73.5467);
	at[25] = 4.5000;
	points[26] = (-6627.1655, 12680, 39.8634);
	angles[26] = (0, 90, -52.6062);
	at[26] = 4.5500;
	points[27] = (-6627.1655, 12680, 64.6665);
	angles[27] = (0, 90, -15.3323);
	at[27] = 4.6000;
	points[28] = (-6627.1655, 12680, 89.4697);
	angles[28] = (0, 90, 26.1922);
	at[28] = 4.6500;
	points[29] = (-6627.1655, 12680, 114.2728);
	angles[29] = (0, 90, 55.5034);
	at[29] = 4.7000;
	points[30] = (-6627.1655, 12680, 139.0760);
	angles[30] = (0, 90, 72.0681);
	at[30] = 4.7500;
	points[31] = (-6627.1655, 12680, 164.2374);
	angles[31] = (0, 90, 80.7817);
	at[31] = 4.8000;
	points[32] = (-6627.1655, 12680, 190.3461);
	angles[32] = (0, 90, 85.2752);
	at[32] = 4.8500;
	points[33] = (-6627.1655, 12680, 274.7161);
	angles[33] = (0, 90, 89.3655);
	at[33] = 5;
	points[34] = (-6627.1655, 12680, 336.3878);
	angles[34] = (0, 90, 89.8337);
	at[34] = 5.1000;
	points[35] = (-6627.1655, 12680, 437.8740);
	angles[35] = (0, 90, 89.9778);
	at[35] = 5.2500;
	points[36] = (-6627.1655, 12680, 512.0591);
	angles[36] = (0, 90, 89.9940);
	at[36] = 5.3500;
	points[37] = (-6627.1655, 12680, 551.2598);
	angles[37] = (0, 90, 0);
	at[37] = 5.4000;
	points[38] = (-6627.1655, 12680, 634.1378);
	angles[38] = (0, 90, 0);
	at[38] = 5.5000;
	points[39] = (-6627.1655, 12680, 677.9330);
	angles[39] = (0, 0, 0);
	at[39] = 5.5500;
	points[40] = (-6627.1655, 12680, 770.5275);
	angles[40] = (0, 0, 0);
	at[40] = 5.6500;
	points[41] = (-6627.1655, 12680, 870.2205);
	angles[41] = (0, 0, 0);
	at[41] = 5.7500;
	points[42] = (-6627.1655, 12680, 977.5591);
	angles[42] = (0, 0, 0);
	at[42] = 5.8500;
	points[43] = (-6627.1655, 12680, 1312.2401);
	angles[43] = (0, 0, 0);
	at[43] = 6.1500;
	points[44] = (-6627.1655, 12680, 1528.7402);
	angles[44] = (0, 0, 0);
	at[44] = 6.3500;
	points[45] = (-6627.1655, 12680, 1843.6182);
	angles[45] = (0, 0, 0);
	at[45] = 6.6500;
	points[46] = (-6627.1655, 12680, 2096.0432);
	angles[46] = (0, 0, 0);
	at[46] = 6.9000;
	points[47] = (-6627.1655, 12680, 2237.0906);
	angles[47] = (0, 0, 0);
	at[47] = 7.0500;
	points[48] = (-6627.1655, 12680, 2369.1458);
	angles[48] = (0, 0, 0);
	at[48] = 7.2000;
	points[49] = (-6627.1655, 12680, 2532.2244);
	angles[49] = (0, 0, 0);
	at[49] = 7.4000;
	points[50] = (-6627.1655, 12680, 2644.6536);
	angles[50] = (0, 0, 0);
	at[50] = 7.5500;
	points[51] = (-6627.1655, 12680, 2677.7244);
	angles[51] = (0, 0, 0);
	at[51] = 7.6000;
	points[52] = (-6627.1655, 12680, 2735.7756);
	angles[52] = (0, 0, 0);
	at[52] = 7.7000;
	points[53] = (-6627.1655, 12680, 2885.2520);
	angles[53] = (0, 0, 0);
	at[53] = 8;
	points[54] = (-6627.1655, 12680, 2926.9331);
	angles[54] = (0, 0, 0);
	at[54] = 8.1000;
	points[55] = (-6627.1655, 12680, 2943.4763);
	angles[55] = (0, 0, 0);
	at[55] = 8.1500;
	points[56] = (-6627.1655, 12680, 2969.8899);
	angles[56] = (0, 0, 0);
	at[56] = 8.2500;
	points[57] = (-6626.1807, 12680, 2965.2993);
	angles[57] = (0, -90, 79.7815);
	at[57] = 8.3000;
	points[58] = (-6624.5674, 12680, 2953.1575);
	angles[58] = (0, -90, 57.3944);
	at[58] = 8.3500;
	points[59] = (-6620.5903, 12680, 2923.0984);
	angles[59] = (0, -90, -21.9646);
	at[59] = 8.4500;
	points[60] = (-6618.1104, 12680, 2904.5864);
	angles[60] = (0, -90, -49.9285);
	at[60] = 8.5000;
	points[61] = (-6615.2759, 12680, 2883.2795);
	angles[61] = (0, -90, -65.5596);
	at[61] = 8.5500;
	mover = getEnt("iz_obj_7", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_8()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-4488.8975, 16748.9766, 2582.4922);
	angles[0] = (0, -90, -65.1491);
	at[0] = 0;
	points[1] = (-4488.1890, 16748.9766, 2560.9883);
	angles[1] = (0, -90, -76.6238);
	at[1] = 0.0500;
	points[2] = (-4488.1890, 16748.9766, 2516.6968);
	angles[2] = (0, -90, -86.4836);
	at[2] = 0.1500;
	points[3] = (-4488.1890, 16748.9766, 2450.2598);
	angles[3] = (0, -90, -89.5279);
	at[3] = 0.3000;
	points[4] = (-4488.1890, 16748.9766, 2401.4685);
	angles[4] = (0, -90, -89.8763);
	at[4] = 0.4000;
	points[5] = (-4488.1890, 16748.9766, 2343.0120);
	angles[5] = (0, -90, -89.9675);
	at[5] = 0.5000;
	points[6] = (-4488.1890, 16748.9766, 2274.5000);
	angles[6] = (0, -90, -89.9915);
	at[6] = 0.6000;
	points[7] = (-4488.1890, 16748.9766, 2237.5630);
	angles[7] = (0, -90, 0);
	at[7] = 0.6500;
	points[8] = (-4488.1890, 16748.9766, 2158.1301);
	angles[8] = (0, -90, 0);
	at[8] = 0.7500;
	points[9] = (-4488.1890, 16748.9766, 2115.4448);
	angles[9] = (0, -90, 0);
	at[9] = 0.8000;
	points[10] = (-4488.1890, 16748.9766, 2070.6536);
	angles[10] = (0, 0, 0);
	at[10] = 0.8500;
	points[11] = (-4488.1890, 16748.9766, 1875.8110);
	angles[11] = (0, 0, 0);
	at[11] = 1.0500;
	points[12] = (-4488.1890, 16748.9766, 1782.0354);
	angles[12] = (0, 0, 0);
	at[12] = 1.1500;
	points[13] = (-4488.1890, 16748.9766, 1649.7560);
	angles[13] = (0, 0, 0);
	at[13] = 1.3000;
	points[14] = (-4488.1890, 16748.9766, 1526.8859);
	angles[14] = (0, 0, 0);
	at[14] = 1.4500;
	points[15] = (-4488.1890, 16748.9766, 1412.7638);
	angles[15] = (0, 0, 0);
	at[15] = 1.6000;
	points[16] = (-4488.1890, 16748.9766, 1306.7599);
	angles[16] = (0, 0, 0);
	at[16] = 1.7500;
	points[17] = (-4488.1890, 16748.9766, 1208.3032);
	angles[17] = (0, 0, 0);
	at[17] = 1.9000;
	points[18] = (-4488.1890, 16748.9766, 1087.8386);
	angles[18] = (0, 0, 0);
	at[18] = 2.1000;
	points[19] = (-4488.1890, 16748.9766, 978.6693);
	angles[19] = (0, 0, 0);
	at[19] = 2.3000;
	points[20] = (-4488.1890, 16748.9766, 856.4882);
	angles[20] = (0, 0, 0);
	at[20] = 2.5500;
	points[21] = (-4488.1890, 16748.9766, 80.7961);
	angles[21] = (0, 0, 0);
	at[21] = 4.3000;
	points[22] = (-4488.1890, 16748.9766, 58.6504);
	angles[22] = (0, 90, -88.6840);
	at[22] = 4.3500;
	points[23] = (-4493.3071, 16748.9766, 14.6536);
	angles[23] = (0, 90, -84.7954);
	at[23] = 4.4500;
	points[24] = (-4494.9604, 16748.9766, 7.9872);
	angles[24] = (0, 90, -80.2788);
	at[24] = 4.5000;
	points[25] = (-4494.9604, 16748.9766, 30.1329);
	angles[25] = (0, 90, -67.3096);
	at[25] = 4.5500;
	points[26] = (-4494.9604, 16748.9766, 52.2787);
	angles[26] = (0, 90, -40.1191);
	at[26] = 4.6000;
	points[27] = (-4494.9604, 16748.9766, 96.5697);
	angles[27] = (0, 90, 39.1675);
	at[27] = 4.7000;
	points[28] = (-4494.9604, 16748.9766, 118.7154);
	angles[28] = (0, 90, 63.0825);
	at[28] = 4.7500;
	points[29] = (-4494.9604, 16748.9766, 141.0213);
	angles[29] = (0, 90, 76.0915);
	at[29] = 4.8000;
	points[30] = (-4494.9604, 16748.9766, 164.1024);
	angles[30] = (0, 90, 82.8616);
	at[30] = 4.8500;
	points[31] = (-4494.9604, 16748.9766, 238.6520);
	angles[31] = (0, 90, 89.0410);
	at[31] = 5;
	points[32] = (-4494.9604, 16748.9766, 293.1106);
	angles[32] = (0, 90, 89.7486);
	at[32] = 5.1000;
	points[33] = (-4494.9604, 16748.9766, 382.6712);
	angles[33] = (0, 90, 89.9663);
	at[33] = 5.2500;
	points[34] = (-4494.9604, 16748.9766, 448.0945);
	angles[34] = (0, 90, 89.9911);
	at[34] = 5.3500;
	points[35] = (-4494.9604, 16748.9766, 482.6536);
	angles[35] = (0, 90, 0);
	at[35] = 5.4000;
	points[36] = (-4494.9604, 16748.9766, 555.6890);
	angles[36] = (0, 90, 0);
	at[36] = 5.5000;
	points[37] = (-4494.9604, 16748.9766, 594.2678);
	angles[37] = (0, 90, 0);
	at[37] = 5.5500;
	points[38] = (-4494.9604, 16748.9766, 634.2874);
	angles[38] = (0, 0, 0);
	at[38] = 5.6000;
	points[39] = (-4494.9604, 16748.9766, 718.8701);
	angles[39] = (0, 0, 0);
	at[39] = 5.7000;
	points[40] = (-4494.9604, 16748.9766, 809.8937);
	angles[40] = (0, 0, 0);
	at[40] = 5.8000;
	points[41] = (-4494.9604, 16748.9766, 1156.3701);
	angles[41] = (0, 0, 0);
	at[41] = 6.1500;
	points[42] = (-4494.9604, 16748.9766, 1397.6497);
	angles[42] = (0, 0, 0);
	at[42] = 6.4000;
	points[43] = (-4494.9604, 16748.9766, 1631.9015);
	angles[43] = (0, 0, 0);
	at[43] = 6.6500;
	points[44] = (-4494.9604, 16748.9766, 1858.6969);
	angles[44] = (0, 0, 0);
	at[44] = 6.9000;
	points[45] = (-4494.9604, 16748.9766, 1986.2638);
	angles[45] = (0, 0, 0);
	at[45] = 7.0500;
	points[46] = (-4494.9604, 16748.9766, 2144.1851);
	angles[46] = (0, 0, 0);
	at[46] = 7.2500;
	points[47] = (-4494.9604, 16748.9766, 2289.2322);
	angles[47] = (0, 0, 0);
	at[47] = 7.4500;
	points[48] = (-4494.9604, 16748.9766, 2356.9844);
	angles[48] = (0, 0, 0);
	at[48] = 7.5500;
	points[49] = (-4494.9604, 16748.9766, 2387.6968);
	angles[49] = (0, 0, 0);
	at[49] = 7.6000;
	points[50] = (-4494.9604, 16748.9766, 2415.7324);
	angles[50] = (0, 0, 0);
	at[50] = 7.6500;
	points[51] = (-4494.9604, 16748.9766, 2464.7087);
	angles[51] = (0, 0, 0);
	at[51] = 7.7500;
	points[52] = (-4494.9604, 16748.9766, 2505.0552);
	angles[52] = (0, 0, 0);
	at[52] = 7.8500;
	points[53] = (-4494.9604, 16748.9766, 2537.7913);
	angles[53] = (0, 0, 0);
	at[53] = 7.9500;
	points[54] = (-4494.9604, 16748.9766, 2564.3542);
	angles[54] = (0, 0, 0);
	at[54] = 8.0500;
	points[55] = (-4494.9604, 16748.9766, 2596.3779);
	angles[55] = (0, 0, 0);
	at[55] = 8.2000;
	points[56] = (-4494.9604, 16748.9766, 2659.3977);
	angles[56] = (0, 0, 0);
	at[56] = 8.5500;
	points[57] = (-4494.5278, 16748.9766, 2654.8857);
	angles[57] = (0, -90, 83.9562);
	at[57] = 8.6000;
	points[58] = (-4493.7793, 16748.9766, 2645.5039);
	angles[58] = (0, -90, 70.0347);
	at[58] = 8.6500;
	points[59] = (-4492.9531, 16748.9766, 2634.5237);
	angles[59] = (0, -90, 41.3388);
	at[59] = 8.7000;
	points[60] = (-4491.9292, 16748.9766, 2621.6694);
	angles[60] = (0, -90, -0.5979);
	at[60] = 8.7500;
	points[61] = (-4490.7876, 16748.9766, 2606.6221);
	angles[61] = (0, -90, -37.3919);
	at[61] = 8.8000;
	points[62] = (-4488.8975, 16748.9766, 2582.4922);
	angles[62] = (0, -90, -65.1491);
	at[62] = 8.8667;
	mover = getEnt("iz_obj_8", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_9()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-3897.8384, 10139.1338, 1968.2323);
	angles[0] = (0, 90, -78.5171);
	at[0] = 0;
	points[1] = (-3897.6379, 10139.1338, 1934.5590);
	angles[1] = (0, 90, -86.9837);
	at[1] = 0.1000;
	points[2] = (-3897.6379, 10139.1338, 1848.4172);
	angles[2] = (0, 90, -89.8939);
	at[2] = 0.3500;
	points[3] = (-3897.6379, 10139.1338, 1805.8229);
	angles[3] = (0, 90, -89.9723);
	at[3] = 0.4500;
	points[4] = (-3897.6379, 10139.1338, 1755.2126);
	angles[4] = (0, 90, -89.9927);
	at[4] = 0.5500;
	points[5] = (-3897.6379, 10139.1338, 1727.6456);
	angles[5] = (0, 90, 0);
	at[5] = 0.6000;
	points[6] = (-3897.6379, 10139.1338, 1668.2166);
	angles[6] = (0, 90, 0);
	at[6] = 0.7000;
	points[7] = (-3897.6379, 10139.1338, 1636.2126);
	angles[7] = (0, 0, 0);
	at[7] = 0.7500;
	points[8] = (-3897.6379, 10139.1338, 1567.2283);
	angles[8] = (0, 0, 0);
	at[8] = 0.8500;
	points[9] = (-3897.6379, 10139.1338, 1416.4055);
	angles[9] = (0, 0, 0);
	at[9] = 1.0500;
	points[10] = (-3897.6379, 10139.1338, 1345.0669);
	angles[10] = (0, 0, 0);
	at[10] = 1.1500;
	points[11] = (-3897.6379, 10139.1338, 1277.2205);
	angles[11] = (0, 0, 0);
	at[11] = 1.2500;
	points[12] = (-3897.6379, 10139.1338, 1181.6339);
	angles[12] = (0, 0, 0);
	at[12] = 1.4000;
	points[13] = (-3897.6379, 10139.1338, 1092.9843);
	angles[13] = (0, 0, 0);
	at[13] = 1.5500;
	points[14] = (-3897.6379, 10139.1338, 1010.7678);
	angles[14] = (0, 0, 0);
	at[14] = 1.7000;
	points[15] = (-3897.6379, 10139.1338, 934.5197);
	angles[15] = (0, 0, 0);
	at[15] = 1.8500;
	points[16] = (-3897.6379, 10139.1338, 841.3937);
	angles[16] = (0, 0, 0);
	at[16] = 2.0500;
	points[17] = (-3897.6379, 10139.1338, 757.1654);
	angles[17] = (0, 0, 0);
	at[17] = 2.2500;
	points[18] = (-3897.6379, 10139.1338, 663.1103);
	angles[18] = (0, 0, 0);
	at[18] = 2.5000;
	points[19] = (-3897.6379, 10139.1338, 56.4303);
	angles[19] = (0, 0, 0);
	at[19] = 4.3000;
	points[20] = (-3897.6379, 10139.1338, 39.5996);
	angles[20] = (0, -90, -88.2800);
	at[20] = 4.3500;
	points[21] = (-3891.7639, 10139.1338, 6.3809);
	angles[21] = (0, -90, -83.1938);
	at[21] = 4.4500;
	points[22] = (-3890.8425, 10139.1338, 10.9709);
	angles[22] = (0, -90, -77.3075);
	at[22] = 4.5000;
	points[23] = (-3890.8425, 10139.1338, 27.8017);
	angles[23] = (0, -90, -60.6796);
	at[23] = 4.5500;
	points[24] = (-3890.8425, 10139.1338, 44.6323);
	angles[24] = (0, -90, -28.1546);
	at[24] = 4.6000;
	points[25] = (-3890.8425, 10139.1338, 61.4630);
	angles[25] = (0, -90, 14.3687);
	at[25] = 4.6500;
	points[26] = (-3890.8425, 10139.1338, 78.2937);
	angles[26] = (0, -90, 48.1071);
	at[26] = 4.7000;
	points[27] = (-3890.8425, 10139.1338, 95.1244);
	angles[27] = (0, -90, 68.0616);
	at[27] = 4.7500;
	points[28] = (-3890.8425, 10139.1338, 112.1949);
	angles[28] = (0, -90, 78.6993);
	at[28] = 4.8000;
	points[29] = (-3890.8425, 10139.1338, 129.9161);
	angles[29] = (0, -90, 84.2047);
	at[29] = 4.8500;
	points[30] = (-3890.8425, 10139.1338, 187.2402);
	angles[30] = (0, -90, 89.2218);
	at[30] = 5;
	points[31] = (-3890.8425, 10139.1338, 229.1933);
	angles[31] = (0, -90, 89.7960);
	at[31] = 5.1000;
	points[32] = (-3890.8425, 10139.1338, 298.3165);
	angles[32] = (0, -90, 89.9726);
	at[32] = 5.2500;
	points[33] = (-3890.8425, 10139.1338, 348.9051);
	angles[33] = (0, -90, 89.9929);
	at[33] = 5.3500;
	points[34] = (-3890.8425, 10139.1338, 375.6555);
	angles[34] = (0, -90, 0);
	at[34] = 5.4000;
	points[35] = (-3890.8425, 10139.1338, 432.2559);
	angles[35] = (0, -90, 0);
	at[35] = 5.5000;
	points[36] = (-3890.8425, 10139.1338, 462.1851);
	angles[36] = (0, 0, 0);
	at[36] = 5.5500;
	points[37] = (-3890.8425, 10139.1338, 559);
	angles[37] = (0, 0, 0);
	at[37] = 5.7000;
	points[38] = (-3890.8425, 10139.1338, 629.8543);
	angles[38] = (0, 0, 0);
	at[38] = 5.8000;
	points[39] = (-3890.8425, 10139.1338, 859.5354);
	angles[39] = (0, 0, 0);
	at[39] = 6.1000;
	points[40] = (-3890.8425, 10139.1338, 1045.9055);
	angles[40] = (0, 0, 0);
	at[40] = 6.3500;
	points[41] = (-3890.8425, 10139.1338, 1226.3740);
	angles[41] = (0, 0, 0);
	at[41] = 6.6000;
	points[42] = (-3890.8425, 10139.1338, 1400.9961);
	angles[42] = (0, 0, 0);
	at[42] = 6.8500;
	points[43] = (-3890.8425, 10139.1338, 1499.8859);
	angles[43] = (0, 0, 0);
	at[43] = 7;
	points[44] = (-3890.8425, 10139.1338, 1622.2598);
	angles[44] = (0, 0, 0);
	at[44] = 7.2000;
	points[45] = (-3890.8425, 10139.1338, 1734.6143);
	angles[45] = (0, 0, 0);
	at[45] = 7.4000;
	points[46] = (-3890.8425, 10139.1338, 1812.2244);
	angles[46] = (0, 0, 0);
	at[46] = 7.5500;
	points[47] = (-3890.8425, 10139.1338, 1874.6890);
	angles[47] = (0, 0, 0);
	at[47] = 7.7000;
	points[48] = (-3890.8425, 10139.1338, 1991.1379);
	angles[48] = (0, 0, 0);
	at[48] = 8.0500;
	points[49] = (-3890.8425, 10139.1338, 2013.5906);
	angles[49] = (0, 0, 0);
	at[49] = 8.1500;
	points[50] = (-3890.8425, 10139.1338, 2034.4094);
	angles[50] = (0, 0, 0);
	at[50] = 8.3000;
	points[51] = (-3891.1062, 10139.1338, 2034.5039);
	angles[51] = (0, 90, 85.5142);
	at[51] = 8.3500;
	points[52] = (-3891.6340, 10139.1338, 2029.3110);
	angles[52] = (0, 90, 71.8314);
	at[52] = 8.4000;
	points[53] = (-3892.2639, 10139.1338, 2023.0984);
	angles[53] = (0, 90, 43.5055);
	at[53] = 8.4500;
	points[54] = (-3893.0198, 10139.1338, 2015.6653);
	angles[54] = (0, 90, 1.6849);
	at[54] = 8.5000;
	points[55] = (-3893.9214, 10139.1338, 2006.7795);
	angles[55] = (0, 90, -35.3837);
	at[55] = 8.5500;
	points[56] = (-3895.0039, 10139.1338, 1996.1497);
	angles[56] = (0, 90, -58.4193);
	at[56] = 8.6000;
	points[57] = (-3896.2952, 10139.1338, 1983.4370);
	angles[57] = (0, 90, -70.8880);
	at[57] = 8.6500;
	points[58] = (-3897.8384, 10139.1338, 1968.2323);
	angles[58] = (0, 90, -78.5171);
	at[58] = 8.7000;
	mover = getEnt("iz_obj_9", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_10()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (2923.2283, 3466.4211, 1506.1615);
	angles[0] = (0, 90, -49.0997);
	at[0] = 0;
	points[1] = (2923.2283, 3466.4211, 1492.8740);
	angles[1] = (0, 90, -68.6045);
	at[1] = 0.0500;
	points[2] = (2923.2283, 3466.4211, 1479.5867);
	angles[2] = (0, 90, -78.9823);
	at[2] = 0.1000;
	points[3] = (2923.2283, 3466.4211, 1466.2992);
	angles[3] = (0, 90, -84.3503);
	at[3] = 0.1500;
	points[4] = (2923.2283, 3466.4211, 1424.5236);
	angles[4] = (0, 90, -89.2414);
	at[4] = 0.3000;
	points[5] = (2923.2283, 3466.4211, 1390.9370);
	angles[5] = (0, 90, -89.8010);
	at[5] = 0.4000;
	points[6] = (2923.2283, 3466.4211, 1330.5275);
	angles[6] = (0, 90, -89.9734);
	at[6] = 0.5500;
	points[7] = (2923.2283, 3466.4211, 1284.6102);
	angles[7] = (0, 90, -89.9929);
	at[7] = 0.6500;
	points[8] = (2923.2283, 3466.4211, 1259.8149);
	angles[8] = (0, 90, 0);
	at[8] = 0.7000;
	points[9] = (2923.2283, 3466.4211, 1206.2323);
	angles[9] = (0, 90, 0);
	at[9] = 0.8000;
	points[10] = (2923.2283, 3466.4211, 1177.3031);
	angles[10] = (0, 0, 0);
	at[10] = 0.8500;
	points[11] = (2923.2283, 3466.4211, 1091.3308);
	angles[11] = (0, 0, 0);
	at[11] = 1;
	points[12] = (2923.2283, 3466.4211, 1015.0748);
	angles[12] = (0, 0, 0);
	at[12] = 1.1500;
	points[13] = (2923.2283, 3466.4211, 947.5237);
	angles[13] = (0, 0, 0);
	at[13] = 1.3000;
	points[14] = (2923.2283, 3466.4211, 887.6772);
	angles[14] = (0, 0, 0);
	at[14] = 1.4500;
	points[15] = (2923.2283, 3466.4211, 834.6654);
	angles[15] = (0, 0, 0);
	at[15] = 1.6000;
	points[16] = (2923.2283, 3466.4211, 773.2678);
	angles[16] = (0, 0, 0);
	at[16] = 1.8000;
	points[17] = (2923.2283, 3466.4211, 721.0315);
	angles[17] = (0, 0, 0);
	at[17] = 2;
	points[18] = (2923.2283, 3466.4211, 676.5867);
	angles[18] = (0, 0, 0);
	at[18] = 2.2000;
	points[19] = (2923.2283, 3466.4211, 638.7756);
	angles[19] = (0, 0, 0);
	at[19] = 2.4000;
	points[20] = (2923.2283, 3466.4211, 606.6024);
	angles[20] = (0, 0, 0);
	at[20] = 2.6000;
	points[21] = (2923.2283, 3466.4211, 573.0551);
	angles[21] = (0, 0, 0);
	at[21] = 2.8500;
	points[22] = (2923.2283, 3466.4211, 545.6378);
	angles[22] = (0, 0, 0);
	at[22] = 3.1000;
	points[23] = (2923.2283, 3466.4211, 508.3032);
	angles[23] = (0, 0, 0);
	at[23] = 3.5500;
	points[24] = (2923.2283, 3466.4211, 463.3504);
	angles[24] = (0, 0, 0);
	at[24] = 4.3000;
	points[25] = (2923.2283, 3466.4211, 429.9055);
	angles[25] = (0, 0, 0);
	at[25] = 4.7500;
	points[26] = (2923.2283, 3466.4211, 387.8697);
	angles[26] = (0, 0, 0);
	at[26] = 5.2000;
	points[27] = (2923.2283, 3466.4211, 335.0323);
	angles[27] = (0, 0, 0);
	at[27] = 5.6500;
	points[28] = (2923.2283, 3466.4211, 276.7705);
	angles[28] = (0, 0, 0);
	at[28] = 6.0500;
	points[29] = (2923.2283, 3466.4211, 205.3780);
	angles[29] = (0, 0, 0);
	at[29] = 6.4500;
	points[30] = (2923.2283, 3466.4211, 129.8264);
	angles[30] = (0, 0, 0);
	at[30] = 6.8000;
	points[31] = (2923.2283, 3466.4211, 40.4512);
	angles[31] = (0, 0, 0);
	at[31] = 7.1500;
	points[32] = (2923.5984, 3466.4211, 27.1727);
	angles[32] = (0, -90, -89.0180);
	at[32] = 7.2000;
	points[33] = (2924.8621, 3466.4211, 0.6280);
	angles[33] = (0, -90, -87.7298);
	at[33] = 7.3000;
	points[34] = (2924.8779, 3466.4211, 13.2496);
	angles[34] = (0, -90, -84.6233);
	at[34] = 7.3500;
	points[35] = (2924.8779, 3466.4211, 26.5370);
	angles[35] = (0, -90, -77.3165);
	at[35] = 7.4000;
	points[36] = (2924.8779, 3466.4211, 39.8244);
	angles[36] = (0, -90, -60.6991);
	at[36] = 7.4500;
	points[37] = (2924.8779, 3466.4211, 53.1118);
	angles[37] = (0, -90, -28.1877);
	at[37] = 7.5000;
	points[38] = (2924.8779, 3466.4211, 66.3992);
	angles[38] = (0, -90, 14.3355);
	at[38] = 7.5500;
	points[39] = (2924.8779, 3466.4211, 79.7150);
	angles[39] = (0, -90, 48.0856);
	at[39] = 7.6000;
	points[40] = (2924.8779, 3466.4211, 93.4197);
	angles[40] = (0, -90, 68.0498);
	at[40] = 7.6500;
	points[41] = (2924.8779, 3466.4211, 107.6386);
	angles[41] = (0, -90, 78.6931);
	at[41] = 7.7000;
	points[42] = (2924.8779, 3466.4211, 122.3906);
	angles[42] = (0, -90, 84.2017);
	at[42] = 7.7500;
	points[43] = (2924.8779, 3466.4211, 153.5744);
	angles[43] = (0, -90, 88.4791);
	at[43] = 7.8500;
	points[44] = (2924.8779, 3466.4211, 223.2720);
	angles[44] = (0, -90, 89.8955);
	at[44] = 8.0500;
	points[45] = (2924.8779, 3466.4211, 304.0260);
	angles[45] = (0, -90, 89.9929);
	at[45] = 8.2500;
	points[46] = (2924.8779, 3466.4211, 326.1418);
	angles[46] = (0, -90, 0);
	at[46] = 8.3000;
	points[47] = (2924.8779, 3466.4211, 372.8922);
	angles[47] = (0, -90, 0);
	at[47] = 8.4000;
	points[48] = (2924.8779, 3466.4211, 397.5905);
	angles[48] = (0, 0, 0);
	at[48] = 8.4500;
	points[49] = (2924.8779, 3466.4211, 449.7992);
	angles[49] = (0, 0, 0);
	at[49] = 8.5500;
	points[50] = (2924.8779, 3466.4211, 505.9961);
	angles[50] = (0, 0, 0);
	at[50] = 8.6500;
	points[51] = (2924.8779, 3466.4211, 683.6890);
	angles[51] = (0, 0, 0);
	at[51] = 8.9500;
	points[52] = (2924.8779, 3466.4211, 826.8425);
	angles[52] = (0, 0, 0);
	at[52] = 9.2000;
	points[53] = (2924.8779, 3466.4211, 1072.7756);
	angles[53] = (0, 0, 0);
	at[53] = 9.6500;
	points[54] = (2924.8779, 3466.4211, 1149.3622);
	angles[54] = (0, 0, 0);
	at[54] = 9.8000;
	points[55] = (2924.8779, 3466.4211, 1243.8898);
	angles[55] = (0, 0, 0);
	at[55] = 10;
	points[56] = (2924.8779, 3466.4211, 1309.5000);
	angles[56] = (0, 0, 0);
	at[56] = 10.1500;
	points[57] = (2924.8779, 3466.4211, 1390.4291);
	angles[57] = (0, 0, 0);
	at[57] = 10.3500;
	points[58] = (2924.8779, 3466.4211, 1425.4961);
	angles[58] = (0, 0, 0);
	at[58] = 10.4500;
	points[59] = (2924.8779, 3466.4211, 1455.2205);
	angles[59] = (0, 0, 0);
	at[59] = 10.5500;
	points[60] = (2924.8779, 3466.4211, 1534.7008);
	angles[60] = (0, 0, 0);
	at[60] = 10.8500;
	points[61] = (2924.8779, 3466.4211, 1566.4724);
	angles[61] = (0, 0, 0);
	at[61] = 11;
	points[62] = (2924.8779, 3466.4211, 1577.1339);
	angles[62] = (0, 90, 89.3913);
	at[62] = 11.0500;
	points[63] = (2924.5237, 3466.4211, 1563.5669);
	angles[63] = (0, 90, 86.0595);
	at[63] = 11.1000;
	points[64] = (2924.2244, 3466.4211, 1554.1456);
	angles[64] = (0, 90, 78.2311);
	at[64] = 11.1500;
	points[65] = (2923.8938, 3466.4211, 1543.7284);
	angles[65] = (0, 90, 60.5330);
	at[65] = 11.2000;
	points[66] = (2923.5237, 3466.4211, 1532.2008);
	angles[66] = (0, 90, 26.6765);
	at[66] = 11.2500;
	points[67] = (2923.1182, 3466.4211, 1519.4489);
	angles[67] = (0, 90, -15.9041);
	at[67] = 11.3000;
	points[68] = (2923.2283, 3466.4211, 1506.1615);
	angles[68] = (0, 90, -49.0997);
	at[68] = 11.3500;
	mover = getEnt("iz_obj_10", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_11()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (4842.5195, 5278.7793, 1380.6851);
	angles[0] = (0, 90, -74.7650);
	at[0] = 0;
	points[1] = (4842.5195, 5278.7793, 1355.8818);
	angles[1] = (0, 90, -85.9914);
	at[1] = 0.1000;
	points[2] = (4842.5195, 5278.7793, 1330.3308);
	angles[2] = (0, 90, -88.9490);
	at[2] = 0.2000;
	points[3] = (4842.5195, 5278.7793, 1300.2638);
	angles[3] = (0, 90, -89.7244);
	at[3] = 0.3000;
	points[4] = (4842.5195, 5278.7793, 1264.5001);
	angles[4] = (0, 90, -89.9278);
	at[4] = 0.4000;
	points[5] = (4842.5195, 5278.7793, 1202.9961);
	angles[5] = (0, 90, -89.9904);
	at[5] = 0.5500;
	points[6] = (4842.5195, 5278.7793, 1180.5276);
	angles[6] = (0, 90, 0);
	at[6] = 0.6000;
	points[7] = (4842.5195, 5278.7793, 1106.5236);
	angles[7] = (0, 90, 0);
	at[7] = 0.7500;
	points[8] = (4842.5195, 5278.7793, 1079.4803);
	angles[8] = (0, 0, 0);
	at[8] = 0.8000;
	points[9] = (4842.5195, 5278.7793, 950.5472);
	angles[9] = (0, 0, 0);
	at[9] = 1.0500;
	points[10] = (4842.5195, 5278.7793, 880.2441);
	angles[10] = (0, 0, 0);
	at[10] = 1.2000;
	points[11] = (4842.5195, 5278.7793, 814.7874);
	angles[11] = (0, 0, 0);
	at[11] = 1.3500;
	points[12] = (4842.5195, 5278.7793, 753.8464);
	angles[12] = (0, 0, 0);
	at[12] = 1.5000;
	points[13] = (4842.5195, 5278.7793, 697.1063);
	angles[13] = (0, 0, 0);
	at[13] = 1.6500;
	points[14] = (4842.5195, 5278.7793, 595.0984);
	angles[14] = (0, 0, 0);
	at[14] = 1.9500;
	points[15] = (4842.5195, 5278.7793, 534.7559);
	angles[15] = (0, 0, 0);
	at[15] = 2.1500;
	points[16] = (4842.5195, 5278.7793, 466.9843);
	angles[16] = (0, 0, 0);
	at[16] = 2.4000;
	points[17] = (4842.5195, 5278.7793, 32.7121);
	angles[17] = (0, 0, 0);
	at[17] = 4.1500;
	points[18] = (4843.0317, 5278.7793, 20.3209);
	angles[18] = (0, -90, -88.8375);
	at[18] = 4.2000;
	points[19] = (4843.5435, 5278.7793, 7.9301);
	angles[19] = (0, -90, -88.2423);
	at[19] = 4.2500;
	points[20] = (4843.8584, 5278.7793, 5.0554);
	angles[20] = (0, -90, -86.6539);
	at[20] = 4.3000;
	points[21] = (4843.8584, 5278.7793, 17.4570);
	angles[21] = (0, -90, -82.0832);
	at[21] = 4.3500;
	points[22] = (4843.8584, 5278.7793, 29.8586);
	angles[22] = (0, -90, -71.4268);
	at[22] = 4.4000;
	points[23] = (4843.8584, 5278.7793, 42.2602);
	angles[23] = (0, -90, -48.2303);
	at[23] = 4.4500;
	points[24] = (4843.8584, 5278.7793, 67.0634);
	angles[24] = (0, -90, 31.3148);
	at[24] = 4.5500;
	points[25] = (4843.8584, 5278.7793, 79.5984);
	angles[25] = (0, -90, 58.5531);
	at[25] = 4.6000;
	points[26] = (4843.8584, 5278.7793, 92.5795);
	angles[26] = (0, -90, 73.6958);
	at[26] = 4.6500;
	points[27] = (4843.8584, 5278.7793, 106.0299);
	angles[27] = (0, -90, 81.6244);
	at[27] = 4.7000;
	points[28] = (4843.8584, 5278.7793, 134.4075);
	angles[28] = (0, -90, 87.8020);
	at[28] = 4.8000;
	points[29] = (4843.8584, 5278.7793, 197.5850);
	angles[29] = (0, -90, 89.8488);
	at[29] = 5;
	points[30] = (4843.8584, 5278.7793, 270.4079);
	angles[30] = (0, -90, 89.9897);
	at[30] = 5.2000;
	points[31] = (4843.8584, 5278.7793, 290.2886);
	angles[31] = (0, -90, 0);
	at[31] = 5.2500;
	points[32] = (4843.8584, 5278.7793, 354.3492);
	angles[32] = (0, -90, 0);
	at[32] = 5.4000;
	points[33] = (4843.8584, 5278.7793, 377.2654);
	angles[33] = (0, 0, 0);
	at[33] = 5.4500;
	points[34] = (4843.8584, 5278.7793, 451.1063);
	angles[34] = (0, 0, 0);
	at[34] = 5.6000;
	points[35] = (4843.8584, 5278.7793, 639.9764);
	angles[35] = (0, 0, 0);
	at[35] = 5.9500;
	points[36] = (4843.8584, 5278.7793, 797.4528);
	angles[36] = (0, 0, 0);
	at[36] = 6.2500;
	points[37] = (4843.8584, 5278.7793, 1023.8937);
	angles[37] = (0, 0, 0);
	at[37] = 6.7000;
	points[38] = (4843.8584, 5278.7793, 1093.7834);
	angles[38] = (0, 0, 0);
	at[38] = 6.8500;
	points[39] = (4843.8584, 5278.7793, 1159.4331);
	angles[39] = (0, 0, 0);
	at[39] = 7;
	points[40] = (4843.8584, 5278.7793, 1240.8190);
	angles[40] = (0, 0, 0);
	at[40] = 7.2000;
	points[41] = (4843.8584, 5278.7793, 1297.2402);
	angles[41] = (0, 0, 0);
	at[41] = 7.3500;
	points[42] = (4843.8584, 5278.7793, 1343.1732);
	angles[42] = (0, 0, 0);
	at[42] = 7.5000;
	points[43] = (4843.8584, 5278.7793, 1417.9370);
	angles[43] = (0, 0, 0);
	at[43] = 7.8000;
	points[44] = (4843.8584, 5278.7793, 1439.5630);
	angles[44] = (0, 0, 0);
	at[44] = 7.9000;
	points[45] = (4843.8584, 5278.7793, 1456.7323);
	angles[45] = (0, 0, 0);
	at[45] = 8;
	points[46] = (4843.7793, 5278.7793, 1457.7008);
	angles[46] = (0, 90, 88.7606);
	at[46] = 8.0500;
	points[47] = (4843.5825, 5278.7793, 1450.0591);
	angles[47] = (0, 90, 84.8865);
	at[47] = 8.1000;
	points[48] = (4843.3467, 5278.7793, 1441.5355);
	angles[48] = (0, 90, 75.8125);
	at[48] = 8.1500;
	points[49] = (4843.0708, 5278.7793, 1432.0315);
	angles[49] = (0, 90, 55.6135);
	at[49] = 8.2000;
	points[50] = (4842.7559, 5278.7793, 1421.4370);
	angles[50] = (0, 90, 19.0410);
	at[50] = 8.2500;
	points[51] = (4842.4409, 5278.7793, 1409.6221);
	angles[51] = (0, 90, -22.9240);
	at[51] = 8.3000;
	points[52] = (4842.5195, 5278.7793, 1397.2205);
	angles[52] = (0, 90, -53.5124);
	at[52] = 8.3500;
	points[53] = (4842.5195, 5278.7793, 1380.6851);
	angles[53] = (0, 90, -74.7650);
	at[53] = 8.4167;
	mover = getEnt("iz_obj_11", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_12()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (5610.2363, 3306.5039, 1564.2008);
	angles[0] = (0, -90, -72.7916);
	at[0] = 0;
	points[1] = (5610.2363, 3306.5039, 1550.9135);
	angles[1] = (0, -90, -81.1565);
	at[1] = 0.0500;
	points[2] = (5610.2363, 3306.5039, 1537.6260);
	angles[2] = (0, -90, -85.4677);
	at[2] = 0.1000;
	points[3] = (5610.2363, 3306.5039, 1481.5275);
	angles[3] = (0, -90, -89.6885);
	at[3] = 0.3000;
	points[4] = (5610.2363, 3306.5039, 1446.1693);
	angles[4] = (0, -90, -89.9184);
	at[4] = 0.4000;
	points[5] = (5610.2363, 3306.5039, 1382.3229);
	angles[5] = (0, -90, -89.9890);
	at[5] = 0.5500;
	points[6] = (5610.2363, 3306.5039, 1358.8031);
	angles[6] = (0, -90, 0);
	at[6] = 0.6000;
	points[7] = (5610.2363, 3306.5039, 1280.8542);
	angles[7] = (0, -90, 0);
	at[7] = 0.7500;
	points[8] = (5610.2363, 3306.5039, 1252.2008);
	angles[8] = (0, 0, 0);
	at[8] = 0.8000;
	points[9] = (5610.2363, 3306.5039, 1161.4607);
	angles[9] = (0, 0, 0);
	at[9] = 0.9500;
	points[10] = (5610.2363, 3306.5039, 1075.9843);
	angles[10] = (0, 0, 0);
	at[10] = 1.1000;
	points[11] = (5610.2363, 3306.5039, 996.6693);
	angles[11] = (0, 0, 0);
	at[11] = 1.2500;
	points[12] = (5610.2363, 3306.5039, 923.0670);
	angles[12] = (0, 0, 0);
	at[12] = 1.4000;
	points[13] = (5610.2363, 3306.5039, 854.7677);
	angles[13] = (0, 0, 0);
	at[13] = 1.5500;
	points[14] = (5610.2363, 3306.5039, 791.3859);
	angles[14] = (0, 0, 0);
	at[14] = 1.7000;
	points[15] = (5610.2363, 3306.5039, 732.5748);
	angles[15] = (0, 0, 0);
	at[15] = 1.8500;
	points[16] = (5610.2363, 3306.5039, 677.9961);
	angles[16] = (0, 0, 0);
	at[16] = 2;
	points[17] = (5610.2363, 3306.5039, 595.6339);
	angles[17] = (0, 0, 0);
	at[17] = 2.2500;
	points[18] = (5610.2363, 3306.5039, 522.9213);
	angles[18] = (0, 0, 0);
	at[18] = 2.5000;
	points[19] = (5610.2363, 3306.5039, 44.3744);
	angles[19] = (0, 0, 0);
	at[19] = 4.3000;
	points[20] = (5609.8818, 3306.5039, 31.0983);
	angles[20] = (0, 90, -88.6647);
	at[20] = 4.3500;
	points[21] = (5608.1890, 3306.5039, 4.5792);
	angles[21] = (0, 90, -86.9124);
	at[21] = 4.4500;
	points[22] = (5607.9131, 3306.5039, 9.2897);
	angles[22] = (0, 90, -82.6929);
	at[22] = 4.5000;
	points[23] = (5607.9131, 3306.5039, 22.5771);
	angles[23] = (0, 90, -72.8313);
	at[23] = 4.5500;
	points[24] = (5607.9131, 3306.5039, 35.8645);
	angles[24] = (0, 90, -51.1149);
	at[24] = 4.6000;
	points[25] = (5607.9131, 3306.5039, 62.4394);
	angles[25] = (0, 90, 28.0219);
	at[25] = 4.7000;
	points[26] = (5607.9131, 3306.5039, 75.7268);
	angles[26] = (0, 90, 56.6022);
	at[26] = 4.7500;
	points[27] = (5607.9131, 3306.5039, 89.1709);
	angles[27] = (0, 90, 72.6560);
	at[27] = 4.8000;
	points[28] = (5607.9131, 3306.5039, 103.1193);
	angles[28] = (0, 90, 81.0863);
	at[28] = 4.8500;
	points[29] = (5607.9131, 3306.5039, 117.5953);
	angles[29] = (0, 90, 85.4317);
	at[29] = 4.9000;
	points[30] = (5607.9131, 3306.5039, 148.2122);
	angles[30] = (0, 90, 88.8021);
	at[30] = 5;
	points[31] = (5607.9131, 3306.5039, 216.7134);
	angles[31] = (0, 90, 89.9178);
	at[31] = 5.2000;
	points[32] = (5607.9131, 3306.5039, 275.1996);
	angles[32] = (0, 90, 89.9890);
	at[32] = 5.3500;
	points[33] = (5607.9131, 3306.5039, 296.1890);
	angles[33] = (0, 90, 0);
	at[33] = 5.4000;
	points[34] = (5607.9131, 3306.5039, 364.0457);
	angles[34] = (0, 90, 0);
	at[34] = 5.5500;
	points[35] = (5607.9131, 3306.5039, 388.3980);
	angles[35] = (0, 0, 0);
	at[35] = 5.6000;
	points[36] = (5607.9131, 3306.5039, 439.9016);
	angles[36] = (0, 0, 0);
	at[36] = 5.7000;
	points[37] = (5607.9131, 3306.5039, 495.3819);
	angles[37] = (0, 0, 0);
	at[37] = 5.8000;
	points[38] = (5607.9131, 3306.5039, 707.7087);
	angles[38] = (0, 0, 0);
	at[38] = 6.1500;
	points[39] = (5607.9131, 3306.5039, 855.4843);
	angles[39] = (0, 0, 0);
	at[39] = 6.4000;
	points[40] = (5607.9131, 3306.5039, 998.6141);
	angles[40] = (0, 0, 0);
	at[40] = 6.6500;
	points[41] = (5607.9131, 3306.5039, 1137.0394);
	angles[41] = (0, 0, 0);
	at[41] = 6.9000;
	points[42] = (5607.9131, 3306.5039, 1215.1771);
	angles[42] = (0, 0, 0);
	at[42] = 7.0500;
	points[43] = (5607.9131, 3306.5039, 1311.9292);
	angles[43] = (0, 0, 0);
	at[43] = 7.2500;
	points[44] = (5607.9131, 3306.5039, 1400.8188);
	angles[44] = (0, 0, 0);
	at[44] = 7.4500;
	points[45] = (5607.9131, 3306.5039, 1462.1418);
	angles[45] = (0, 0, 0);
	at[45] = 7.6000;
	points[46] = (5607.9131, 3306.5039, 1496.4331);
	angles[46] = (0, 0, 0);
	at[46] = 7.7000;
	points[47] = (5607.9131, 3306.5039, 1525.0552);
	angles[47] = (0, 0, 0);
	at[47] = 7.8000;
	points[48] = (5607.9131, 3306.5039, 1604.1260);
	angles[48] = (0, 0, 0);
	at[48] = 8.1000;
	points[49] = (5607.9131, 3306.5039, 1635.1299);
	angles[49] = (0, 0, 0);
	at[49] = 8.2500;
	points[50] = (5607.9131, 3306.5039, 1642.8151);
	angles[50] = (0, -90, 89.1718);
	at[50] = 8.3000;
	points[51] = (5608.2676, 3306.5039, 1633.2166);
	angles[51] = (0, -90, 84.6439);
	at[51] = 8.3500;
	points[52] = (5608.6616, 3306.5039, 1624.0787);
	angles[52] = (0, -90, 74.0841);
	at[52] = 8.4000;
	points[53] = (5609.1338, 3306.5039, 1614.0079);
	angles[53] = (0, -90, 51.0648);
	at[53] = 8.4500;
	points[54] = (5610.1182, 3306.5039, 1590.6929);
	angles[54] = (0, -90, -28.4471);
	at[54] = 8.5500;
	points[55] = (5610.2363, 3306.5039, 1577.4882);
	angles[55] = (0, -90, -56.8560);
	at[55] = 8.6000;
	points[56] = (5610.2363, 3306.5039, 1564.2008);
	angles[56] = (0, -90, -72.7917);
	at[56] = 8.6500;
	mover = getEnt("iz_obj_12", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_13()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (8946.8506, 13558.8193, 1063.4094);
	angles[0] = (0, 90, -86.9068);
	at[0] = 0;
	points[1] = (8946.8506, 13558.8193, 1019.2678);
	angles[1] = (0, 90, -89.7875);
	at[1] = 0.2000;
	points[2] = (8946.8506, 13558.8193, 991.4724);
	angles[2] = (0, 90, -89.9443);
	at[2] = 0.3000;
	points[3] = (8946.8506, 13558.8193, 944.0276);
	angles[3] = (0, 90, -89.9924);
	at[3] = 0.4500;
	points[4] = (8946.8506, 13558.8193, 926.6614);
	angles[4] = (0, 90, 0);
	at[4] = 0.5000;
	points[5] = (8946.8506, 13558.8193, 889.3859);
	angles[5] = (0, 90, 0);
	at[5] = 0.6000;
	points[6] = (8946.8506, 13558.8193, 869.3898);
	angles[6] = (0, 0, 0);
	at[6] = 0.6500;
	points[7] = (8946.8506, 13558.8193, 767.5905);
	angles[7] = (0, 0, 0);
	at[7] = 0.9000;
	points[8] = (8946.8506, 13558.8193, 659.5236);
	angles[8] = (0, 0, 0);
	at[8] = 1.2000;
	points[9] = (8946.8506, 13558.8193, 565.4764);
	angles[9] = (0, 0, 0);
	at[9] = 1.5000;
	points[10] = (8946.8506, 13558.8193, 483.6299);
	angles[10] = (0, 0, 0);
	at[10] = 1.8000;
	points[11] = (8946.8506, 13558.8193, 423.5945);
	angles[11] = (0, 0, 0);
	at[11] = 2.0500;
	points[12] = (8946.8506, 13558.8193, 370.1224);
	angles[12] = (0, 0, 0);
	at[12] = 2.3000;
	points[13] = (8946.8506, 13558.8193, 28.8277);
	angles[13] = (0, 0, 0);
	at[13] = 4.0500;
	points[14] = (8947.2441, 13558.8193, 19.0948);
	angles[14] = (0, -90, -88.7822);
	at[14] = 4.1000;
	points[15] = (8948.3857, 13558.8193, -0.3595);
	angles[15] = (0, -90, -86.4352);
	at[15] = 4.2000;
	points[16] = (8948.3467, 13558.8193, 10.6952);
	angles[16] = (0, -90, -81.5681);
	at[16] = 4.2500;
	points[17] = (8948.3467, 13558.8193, 20.4393);
	angles[17] = (0, -90, -70.2450);
	at[17] = 4.3000;
	points[18] = (8948.3467, 13558.8193, 30.1834);
	angles[18] = (0, -90, -45.8491);
	at[18] = 4.3500;
	points[19] = (8948.3467, 13558.8193, 49.6717);
	angles[19] = (0, -90, 33.8160);
	at[19] = 4.4500;
	points[20] = (8948.3467, 13558.8193, 59.4500);
	angles[20] = (0, -90, 60.0138);
	at[20] = 4.5000;
	points[21] = (8948.3467, 13558.8193, 69.5260);
	angles[21] = (0, -90, 74.4712);
	at[21] = 4.5500;
	points[22] = (8948.3467, 13558.8193, 79.9563);
	angles[22] = (0, -90, 82.0252);
	at[22] = 4.6000;
	points[23] = (8948.3467, 13558.8193, 101.9299);
	angles[23] = (0, -90, 87.9073);
	at[23] = 4.7000;
	points[24] = (8948.3467, 13558.8193, 150.7043);
	angles[24] = (0, -90, 89.8562);
	at[24] = 4.9000;
	points[25] = (8948.3467, 13558.8193, 206.7063);
	angles[25] = (0, -90, 89.9901);
	at[25] = 5.1000;
	points[26] = (8948.3467, 13558.8193, 221.9583);
	angles[26] = (0, -90, 0);
	at[26] = 5.1500;
	points[27] = (8948.3467, 13558.8193, 271.0063);
	angles[27] = (0, -90, 0);
	at[27] = 5.3000;
	points[28] = (8948.3467, 13558.8193, 288.5185);
	angles[28] = (0, 0, 0);
	at[28] = 5.3500;
	points[29] = (8948.3467, 13558.8193, 344.8346);
	angles[29] = (0, 0, 0);
	at[29] = 5.5000;
	points[30] = (8948.3467, 13558.8193, 613.9567);
	angles[30] = (0, 0, 0);
	at[30] = 6.1500;
	points[31] = (8948.3467, 13558.8193, 811.1221);
	angles[31] = (0, 0, 0);
	at[31] = 6.6500;
	points[32] = (8948.3467, 13558.8193, 865.3347);
	angles[32] = (0, 0, 0);
	at[32] = 6.8000;
	points[33] = (8948.3467, 13558.8193, 932.1024);
	angles[33] = (0, 0, 0);
	at[33] = 7;
	points[34] = (8948.3467, 13558.8193, 993.0670);
	angles[34] = (0, 0, 0);
	at[34] = 7.2000;
	points[35] = (8948.3467, 13558.8193, 1034.0118);
	angles[35] = (0, 0, 0);
	at[35] = 7.3500;
	points[36] = (8948.3467, 13558.8193, 1056.5985);
	angles[36] = (0, 0, 0);
	at[36] = 7.4500;
	points[37] = (8948.3467, 13558.8193, 1115.3031);
	angles[37] = (0, 0, 0);
	at[37] = 7.7500;
	points[38] = (8948.3467, 13558.8193, 1146.8898);
	angles[38] = (0, 0, 0);
	at[38] = 7.9500;
	points[39] = (8948.1494, 13558.8193, 1143.7362);
	angles[39] = (0, 90, 86.9084);
	at[39] = 8;
	points[40] = (8947.8740, 13558.8193, 1136.8820);
	angles[40] = (0, 90, 79.6355);
	at[40] = 8.0500;
	points[41] = (8947.5986, 13558.8193, 1129.3701);
	angles[41] = (0, 90, 63.0895);
	at[41] = 8.1000;
	points[42] = (8947.2441, 13558.8193, 1121.1260);
	angles[42] = (0, 90, 30.6705);
	at[42] = 8.1500;
	points[43] = (8946.8906, 13558.8193, 1112.0867);
	angles[43] = (0, 90, -11.8519);
	at[43] = 8.2000;
	points[44] = (8946.8506, 13558.8193, 1102.3859);
	angles[44] = (0, 90, -46.4571);
	at[44] = 8.2500;
	points[45] = (8946.8506, 13558.8193, 1092.6417);
	angles[45] = (0, 90, -67.1549);
	at[45] = 8.3000;
	points[46] = (8946.8506, 13558.8193, 1082.8977);
	angles[46] = (0, 90, -78.2261);
	at[46] = 8.3500;
	points[47] = (8946.8506, 13558.8193, 1063.4094);
	angles[47] = (0, 90, -86.9068);
	at[47] = 8.4500;
	mover = getEnt("iz_obj_13", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_14()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (9950.7871, 5971.7715, 918.8307);
	angles[0] = (0, 90, -89.1858);
	at[0] = 0;
	points[1] = (9950.7871, 5971.7715, 881.9685);
	angles[1] = (0, 90, -89.9441);
	at[1] = 0.2000;
	points[2] = (9950.7871, 5971.7715, 844.7716);
	angles[2] = (0, 90, -89.9924);
	at[2] = 0.3500;
	points[3] = (9950.7871, 5971.7715, 830.9843);
	angles[3] = (0, 90, 0);
	at[3] = 0.4000;
	points[4] = (9950.7871, 5971.7715, 801.3622);
	angles[4] = (0, 90, 0);
	at[4] = 0.5000;
	points[5] = (9950.7871, 5971.7715, 785.4567);
	angles[5] = (0, 0, 0);
	at[5] = 0.5500;
	points[6] = (9950.7871, 5971.7715, 662.4724);
	angles[6] = (0, 0, 0);
	at[6] = 0.9000;
	points[7] = (9950.7871, 5971.7715, 569.0039);
	angles[7] = (0, 0, 0);
	at[7] = 1.2000;
	points[8] = (9950.7871, 5971.7715, 527.2205);
	angles[8] = (0, 0, 0);
	at[8] = 1.3500;
	points[9] = (9950.7871, 5971.7715, 476.1221);
	angles[9] = (0, 0, 0);
	at[9] = 1.5500;
	points[10] = (9950.7871, 5971.7715, 398.0118);
	angles[10] = (0, 0, 0);
	at[10] = 1.9000;
	points[11] = (9950.7871, 5971.7715, 359.0898);
	angles[11] = (0, 0, 0);
	at[11] = 2.1000;
	points[12] = (9950.7871, 5971.7715, 315.5516);
	angles[12] = (0, 0, 0);
	at[12] = 2.3500;
	points[13] = (9950.7871, 5971.7715, 28.4361);
	angles[13] = (0, 0, 0);
	at[13] = 4.1500;
	points[14] = (9950.7871, 5971.7715, 20.4636);
	angles[14] = (0, -90, -84.9847);
	at[14] = 4.2000;
	points[15] = (9961.7324, 5971.7715, -0.9771);
	angles[15] = (0, -90, -61.0172);
	at[15] = 4.3500;
	points[16] = (9961.1416, 5971.7715, 9.6772);
	angles[16] = (0, -90, -28.7312);
	at[16] = 4.4000;
	points[17] = (9961.1416, 5971.7715, 17.6496);
	angles[17] = (0, -90, 13.7889);
	at[17] = 4.4500;
	points[18] = (9961.1416, 5971.7715, 25.6221);
	angles[18] = (0, -90, 47.7298);
	at[18] = 4.5000;
	points[19] = (9961.1416, 5971.7715, 33.5945);
	angles[19] = (0, -90, 67.8546);
	at[19] = 4.5500;
	points[20] = (9961.1416, 5971.7715, 41.5669);
	angles[20] = (0, -90, 78.5914);
	at[20] = 4.6000;
	points[21] = (9961.1416, 5971.7715, 49.5504);
	angles[21] = (0, -90, 84.1493);
	at[21] = 4.6500;
	points[22] = (9961.1416, 5971.7715, 75.1012);
	angles[22] = (0, -90, 89.2143);
	at[22] = 4.8000;
	points[23] = (9961.1416, 5971.7715, 113.8787);
	angles[23] = (0, -90, 89.9459);
	at[23] = 5;
	points[24] = (9961.1416, 5971.7715, 146.9559);
	angles[24] = (0, -90, 89.9927);
	at[24] = 5.1500;
	points[25] = (9961.1416, 5971.7715, 158.8201);
	angles[25] = (0, -90, 0);
	at[25] = 5.2000;
	points[26] = (9961.1416, 5971.7715, 183.9028);
	angles[26] = (0, -90, 0);
	at[26] = 5.3000;
	points[27] = (9961.1416, 5971.7715, 197.1551);
	angles[27] = (0, 0, 0);
	at[27] = 5.3500;
	points[28] = (9961.1416, 5971.7715, 239.9752);
	angles[28] = (0, 0, 0);
	at[28] = 5.5000;
	points[29] = (9961.1416, 5971.7715, 287.8051);
	angles[29] = (0, 0, 0);
	at[29] = 5.6500;
	points[30] = (9961.1416, 5971.7715, 522.0984);
	angles[30] = (0, 0, 0);
	at[30] = 6.3000;
	points[31] = (9961.1416, 5971.7715, 709.5905);
	angles[31] = (0, 0, 0);
	at[31] = 6.8500;
	points[32] = (9961.1416, 5971.7715, 813.3032);
	angles[32] = (0, 0, 0);
	at[32] = 7.2000;
	points[33] = (9961.1416, 5971.7715, 889.5197);
	angles[33] = (0, 0, 0);
	at[33] = 7.5000;
	points[34] = (9961.1416, 5971.7715, 917.8819);
	angles[34] = (0, 0, 0);
	at[34] = 7.6500;
	points[35] = (9961.1416, 5971.7715, 965.6535);
	angles[35] = (0, 0, 0);
	at[35] = 7.9500;
	points[36] = (9961.1416, 5971.7715, 989.9686);
	angles[36] = (0, 0, 0);
	at[36] = 8.1500;
	points[37] = (9960.3154, 5971.7715, 990.0079);
	angles[37] = (0, 90, 77.0192);
	at[37] = 8.2000;
	points[38] = (9958.8584, 5971.7715, 985.3622);
	angles[38] = (0, 90, 43.6226);
	at[38] = 8.2500;
	points[39] = (9957.2051, 5971.7715, 980.2205);
	angles[39] = (0, 90, 1.1276);
	at[39] = 8.3000;
	points[40] = (9955.3936, 5971.7715, 974.5276);
	angles[40] = (0, 90, -31.8601);
	at[40] = 8.3500;
	points[41] = (9953.3857, 5971.7715, 968.2244);
	angles[41] = (0, 90, -51.1959);
	at[41] = 8.4000;
	points[42] = (9950.7871, 5971.7715, 953.3779);
	angles[42] = (0, 90, -75.2446);
	at[42] = 8.5000;
	points[43] = (9950.7871, 5971.7715, 945.4055);
	angles[43] = (0, 90, -82.4246);
	at[43] = 8.5500;
	points[44] = (9950.7871, 5971.7715, 918.8307);
	angles[44] = (0, 90, -89.1858);
	at[44] = 8.7167;
	mover = getEnt("iz_obj_14", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_15()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (10305.1182, 13594.3701, 945.9764);
	angles[0] = (0, -90, -89.3890);
	at[0] = 0;
	points[1] = (10305.1182, 13594.3701, 919.2717);
	angles[1] = (0, -90, -89.9180);
	at[1] = 0.1500;
	points[2] = (10305.1182, 13594.3701, 884.4489);
	angles[2] = (0, -90, -89.9890);
	at[2] = 0.3000;
	points[3] = (10305.1182, 13594.3701, 871.1812);
	angles[3] = (0, -90, 0);
	at[3] = 0.3500;
	points[4] = (10305.1182, 13594.3701, 826.9095);
	angles[4] = (0, -90, 0);
	at[4] = 0.5000;
	points[5] = (10305.1182, 13594.3701, 810.5236);
	angles[5] = (0, 0, 0);
	at[5] = 0.5500;
	points[6] = (10305.1182, 13594.3701, 682.2363);
	angles[6] = (0, 0, 0);
	at[6] = 0.9000;
	points[7] = (10305.1182, 13594.3701, 585.1851);
	angles[7] = (0, 0, 0);
	at[7] = 1.2000;
	points[8] = (10305.1182, 13594.3701, 502.1457);
	angles[8] = (0, 0, 0);
	at[8] = 1.5000;
	points[9] = (10305.1182, 13594.3701, 420.2992);
	angles[9] = (0, 0, 0);
	at[9] = 1.8500;
	points[10] = (10305.1182, 13594.3701, 370.3094);
	angles[10] = (0, 0, 0);
	at[10] = 2.1000;
	points[11] = (10305.1182, 13594.3701, 326.4134);
	angles[11] = (0, 0, 0);
	at[11] = 2.3500;
	points[12] = (10305.1182, 13594.3701, 23.3169);
	angles[12] = (0, 0, 0);
	at[12] = 4.2500;
	points[13] = (10303.1104, 13594.3701, 15.6261);
	angles[13] = (0, 90, -82.2599);
	at[13] = 4.3000;
	points[14] = (10298.7412, 13594.3701, 0.2923);
	angles[14] = (0, 90, -72.4417);
	at[14] = 4.4000;
	points[15] = (10298.7412, 13594.3701, 8.2707);
	angles[15] = (0, 90, -50.3091);
	at[15] = 4.4500;
	points[16] = (10298.7412, 13594.3701, 24.2156);
	angles[16] = (0, 90, 28.9731);
	at[16] = 4.5500;
	points[17] = (10298.7412, 13594.3701, 32.1881);
	angles[17] = (0, 90, 57.1691);
	at[17] = 4.6000;
	points[18] = (10298.7412, 13594.3701, 40.1606);
	angles[18] = (0, 90, 72.9588);
	at[18] = 4.6500;
	points[19] = (10298.7412, 13594.3701, 48.1331);
	angles[19] = (0, 90, 81.2432);
	at[19] = 4.7000;
	points[20] = (10298.7412, 13594.3701, 73.4165);
	angles[20] = (0, 90, 88.8232);
	at[20] = 4.8500;
	points[21] = (10298.7412, 13594.3701, 112.0382);
	angles[21] = (0, 90, 89.9191);
	at[21] = 5.0500;
	points[22] = (10298.7412, 13594.3701, 145.1945);
	angles[22] = (0, 90, 89.9892);
	at[22] = 5.2000;
	points[23] = (10298.7412, 13594.3701, 157.1307);
	angles[23] = (0, 90, 0);
	at[23] = 5.2500;
	points[24] = (10298.7412, 13594.3701, 195.8421);
	angles[24] = (0, 90, 0);
	at[24] = 5.4000;
	points[25] = (10298.7412, 13594.3701, 209.7780);
	angles[25] = (0, 0, 0);
	at[25] = 5.4500;
	points[26] = (10298.7412, 13594.3701, 254.9752);
	angles[26] = (0, 0, 0);
	at[26] = 5.6000;
	points[27] = (10298.7412, 13594.3701, 305.7406);
	angles[27] = (0, 0, 0);
	at[27] = 5.7500;
	points[28] = (10298.7412, 13594.3701, 530.8228);
	angles[28] = (0, 0, 0);
	at[28] = 6.3500;
	points[29] = (10298.7412, 13594.3701, 704.6693);
	angles[29] = (0, 0, 0);
	at[29] = 6.8500;
	points[30] = (10298.7412, 13594.3701, 812.3661);
	angles[30] = (0, 0, 0);
	at[30] = 7.2000;
	points[31] = (10298.7412, 13594.3701, 867.0866);
	angles[31] = (0, 0, 0);
	at[31] = 7.4000;
	points[32] = (10298.7412, 13594.3701, 916.5552);
	angles[32] = (0, 0, 0);
	at[32] = 7.6000;
	points[33] = (10298.7412, 13594.3701, 945.2363);
	angles[33] = (0, 0, 0);
	at[33] = 7.7500;
	points[34] = (10298.7412, 13594.3701, 993.1417);
	angles[34] = (0, 0, 0);
	at[34] = 8.0500;
	points[35] = (10298.7412, 13594.3701, 1007.2678);
	angles[35] = (0, 0, 0);
	at[35] = 8.1500;
	points[36] = (10298.7412, 13594.3701, 1023.4174);
	angles[36] = (0, 0, 0);
	at[36] = 8.3000;
	points[37] = (10299.5674, 13594.3701, 1019.3425);
	angles[37] = (0, -90, 75.7324);
	at[37] = 8.3500;
	points[38] = (10300.5117, 13594.3701, 1014.3661);
	angles[38] = (0, -90, 46.5095);
	at[38] = 8.4000;
	points[39] = (10301.5752, 13594.3701, 1008.8544);
	angles[39] = (0, -90, 4.4254);
	at[39] = 8.4500;
	points[40] = (10302.7168, 13594.3701, 1002.7559);
	angles[40] = (0, -90, -31.9710);
	at[40] = 8.5000;
	points[41] = (10304.0156, 13594.3701, 996);
	angles[41] = (0, -90, -54.3288);
	at[41] = 8.5500;
	points[42] = (10305.1182, 13594.3701, 980.5236);
	angles[42] = (0, -90, -78.9086);
	at[42] = 8.6500;
	points[43] = (10305.1182, 13594.3701, 964.5787);
	angles[43] = (0, -90, -87.0869);
	at[43] = 8.7500;
	points[44] = (10305.1182, 13594.3701, 945.9764);
	angles[44] = (0, -90, -89.3890);
	at[44] = 8.8667;
	mover = getEnt("iz_obj_15", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_16()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (11574.8037, 12972.4805, 636.4252);
	angles[0] = (0, 90, -89.1349);
	at[0] = 0;
	points[1] = (11574.8037, 12972.4805, 611.6181);
	angles[1] = (0, 90, -89.9407);
	at[1] = 0.2000;
	points[2] = (11574.8037, 12972.4805, 587.4528);
	angles[2] = (0, 90, -89.9920);
	at[2] = 0.3500;
	points[3] = (11574.8037, 12972.4805, 578.5197);
	angles[3] = (0, 90, 0);
	at[3] = 0.4000;
	points[4] = (11574.8037, 12972.4805, 559.2795);
	angles[4] = (0, 90, 0);
	at[4] = 0.5000;
	points[5] = (11574.8037, 12972.4805, 548.9330);
	angles[5] = (0, 0, 0);
	at[5] = 0.5500;
	points[6] = (11574.8037, 12972.4805, 444.9921);
	angles[6] = (0, 0, 0);
	at[6] = 1;
	points[7] = (11574.8037, 12972.4805, 375.2902);
	angles[7] = (0, 0, 0);
	at[7] = 1.3500;
	points[8] = (11574.8037, 12972.4805, 308.5941);
	angles[8] = (0, 0, 0);
	at[8] = 1.7500;
	points[9] = (11574.8037, 12972.4805, 253.4287);
	angles[9] = (0, 0, 0);
	at[9] = 2.1500;
	points[10] = (11574.8037, 12972.4805, 218.4090);
	angles[10] = (0, 0, 0);
	at[10] = 2.4500;
	points[11] = (11574.8037, 12972.4805, 16.3884);
	angles[11] = (0, 0, 0);
	at[11] = 4.3500;
	points[12] = (11575.7090, 12972.4805, 11.1691);
	angles[12] = (0, -90, -84.0482);
	at[12] = 4.4000;
	points[13] = (11577.9521, 12972.4805, 0.7800);
	angles[13] = (0, -90, -79.4242);
	at[13] = 4.5000;
	points[14] = (11578.0312, 12972.4805, 5.1143);
	angles[14] = (0, -90, -65.3820);
	at[14] = 4.5500;
	points[15] = (11578.0312, 12972.4805, 10.4292);
	angles[15] = (0, -90, -36.5011);
	at[15] = 4.6000;
	points[16] = (11578.0312, 12972.4805, 15.7442);
	angles[16] = (0, -90, 5.4896);
	at[16] = 4.6500;
	points[17] = (11578.0312, 12972.4805, 21.0591);
	angles[17] = (0, -90, 42.1447);
	at[17] = 4.7000;
	points[18] = (11578.0312, 12972.4805, 26.3741);
	angles[18] = (0, -90, 64.7596);
	at[18] = 4.7500;
	points[19] = (11578.0312, 12972.4805, 31.6891);
	angles[19] = (0, -90, 76.9726);
	at[19] = 4.8000;
	points[20] = (11578.0312, 12972.4805, 37.0606);
	angles[20] = (0, -90, 83.3158);
	at[20] = 4.8500;
	points[21] = (11578.0312, 12972.4805, 48.3843);
	angles[21] = (0, -90, 88.2466);
	at[21] = 4.9500;
	points[22] = (11578.0312, 12972.4805, 102.6138);
	angles[22] = (0, -90, 89.9918);
	at[22] = 5.3500;
	points[23] = (11578.0312, 12972.4805, 110.5366);
	angles[23] = (0, -90, 0);
	at[23] = 5.4000;
	points[24] = (11578.0312, 12972.4805, 127.2484);
	angles[24] = (0, -90, 0);
	at[24] = 5.5000;
	points[25] = (11578.0312, 12972.4805, 136.0587);
	angles[25] = (0, 0, 0);
	at[25] = 5.5500;
	points[26] = (11578.0312, 12972.4805, 174.5882);
	angles[26] = (0, 0, 0);
	at[26] = 5.7500;
	points[27] = (11578.0312, 12972.4805, 207.2835);
	angles[27] = (0, 0, 0);
	at[27] = 5.9000;
	points[28] = (11578.0312, 12972.4805, 435.3780);
	angles[28] = (0, 0, 0);
	at[28] = 6.8500;
	points[29] = (11578.0312, 12972.4805, 523.7008);
	angles[29] = (0, 0, 0);
	at[29] = 7.2500;
	points[30] = (11578.0312, 12972.4805, 561.9961);
	angles[30] = (0, 0, 0);
	at[30] = 7.4500;
	points[31] = (11578.0312, 12972.4805, 604.7362);
	angles[31] = (0, 0, 0);
	at[31] = 7.7000;
	points[32] = (11578.0312, 12972.4805, 638.1417);
	angles[32] = (0, 0, 0);
	at[32] = 7.9500;
	points[33] = (11578.0312, 12972.4805, 689.4567);
	angles[33] = (0, 0, 0);
	at[33] = 8.4500;
	points[34] = (11577.5195, 12972.4805, 686.0236);
	angles[34] = (0, 90, 79.0285);
	at[34] = 8.5000;
	points[35] = (11576.8506, 12972.4805, 681.4330);
	angles[35] = (0, 90, 55.2606);
	at[35] = 8.5500;
	points[36] = (11575.4326, 12972.4805, 671.7048);
	angles[36] = (0, 90, -24.3642);
	at[36] = 8.6500;
	points[37] = (11574.7236, 12972.4805, 666.5512);
	angles[37] = (0, 90, -52.5118);
	at[37] = 8.7000;
	points[38] = (11574.8037, 12972.4805, 661.2284);
	angles[38] = (0, 90, -70.4583);
	at[38] = 8.7500;
	points[39] = (11574.8037, 12972.4805, 655.9134);
	angles[39] = (0, 90, -79.9466);
	at[39] = 8.8000;
	points[40] = (11574.8037, 12972.4805, 650.5984);
	angles[40] = (0, 90, -84.8461);
	at[40] = 8.8500;
	points[41] = (11574.8037, 12972.4805, 636.4252);
	angles[41] = (0, 90, -89.1349);
	at[41] = 8.9833;
	mover = getEnt("iz_obj_16", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover_loop(points, angles, at, once, closed)
{
	wait 0.05;
	self iz_place(points[0], iz_pose(angles, 0));
	period = at[at.size - 1];
	if (period < 0.05)
		return;
	done = 0;
	for (pass = 0; !once || pass < 1; pass++)
	{
		if (pass && !closed)
			self iz_place(points[0], iz_pose(angles, 0));
		for (i = 1; i < points.size; i++)
		{
			if (at[i] == at[i - 1])
			{
				self iz_place(points[i], iz_pose(angles, i));
				continue;
			}
			due = int((pass * period + at[i]) * 20 + 0.5);
			if (due <= done)
				continue;
			self iz_move(points[i], iz_pose(angles, i), due - done);
			wait 0.05 * (due - done);
			done = due;
		}
	}
	last = points.size - 1;
	self iz_stop(points[last], iz_pose(angles, last));
}

iz_pose(angles, i)
{
	if (isDefined(angles))
		return angles[i];
}
