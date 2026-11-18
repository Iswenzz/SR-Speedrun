main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_3ds_music_park", 0);

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
	ambientPlay("iz_0_110", 2);
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
	level.iz_route[level.iz_route.size] = (778, -5382, 2241);
	level.iz_route[level.iz_route.size] = (266, -5382, 2241);
	level.iz_route[level.iz_route.size] = (-379, -5382, 2241);
	level.iz_route[level.iz_route.size] = (-1188, -5412, 2247);
	level.iz_route[level.iz_route.size] = (-1751, -5486, 2263);
	level.iz_route[level.iz_route.size] = (-2315, -5545, 2263);
	level.iz_route[level.iz_route.size] = (-2849, -5842, 2330);
	level.iz_route[level.iz_route.size] = (-3450, -6057, 2405);
	level.iz_route[level.iz_route.size] = (-3932, -6035, 2431);
	level.iz_route[level.iz_route.size] = (-4547, -5805, 2403);
	level.iz_route[level.iz_route.size] = (-4955, -5516, 2357);
	level.iz_route[level.iz_route.size] = (-5653, -4967, 2335);
	level.iz_route[level.iz_route.size] = (-6194, -4715, 2357);
	level.iz_route[level.iz_route.size] = (-6832, -4514, 2397);
	level.iz_route[level.iz_route.size] = (-7485, -4544, 2426);
	level.iz_route[level.iz_route.size] = (-8011, -4781, 2428);
	level.iz_route[level.iz_route.size] = (-8315, -4967, 2438);
	level.iz_route[level.iz_route.size] = (-8560, -5538, 2438);
	level.iz_route[level.iz_route.size] = (-8664, -5946, 2316);
	level.iz_route[level.iz_route.size] = (-8738, -6487, 2233);
	level.iz_route[level.iz_route.size] = (-8679, -7029, 2139);
	level.iz_route[level.iz_route.size] = (-8567, -7400, 2066);
	level.iz_route[level.iz_route.size] = (-8286, -7963, 1940);
	level.iz_route[level.iz_route.size] = (-7759, -8542, 1770);
	level.iz_route[level.iz_route.size] = (-7277, -8831, 1636);
	level.iz_route[level.iz_route.size] = (-6713, -9009, 1487);
	level.iz_route[level.iz_route.size] = (-5964, -8972, 1279);
	level.iz_route[level.iz_route.size] = (-5259, -8801, 1093);
	level.iz_route[level.iz_route.size] = (-4792, -8505, 957);
	level.iz_route[level.iz_route.size] = (-4414, -8164, 849);
	level.iz_route[level.iz_route.size] = (-3480, -7237, 602);
	level.iz_route[level.iz_route.size] = (-3458, -6881, 578);
	level.iz_route[level.iz_route.size] = (-3443, -6192, 562);
	level.iz_route[level.iz_route.size] = (-3435, -5635, 562);
	level.iz_route[level.iz_route.size] = (-3406, -4960, 562);
	level.iz_route[level.iz_route.size] = (-3398, -4226, 562);
	level.iz_route[level.iz_route.size] = (-3369, -3603, 562);
	level.iz_route[level.iz_route.size] = (-3391, -2824, 562);
	level.iz_route[level.iz_route.size] = (-3384, -2179, 562);
	level.iz_route[level.iz_route.size] = (-3398, -1452, 565);
	level.iz_route[level.iz_route.size] = (-3413, -799, 633);
	level.iz_route[level.iz_route.size] = (-3443, -280, 710);
	level.iz_route[level.iz_route.size] = (-3272, 387, 825);
	level.iz_route[level.iz_route.size] = (-3220, 773, 900);
	level.iz_route[level.iz_route.size] = (-3339, 1307, 1001);
	level.iz_route[level.iz_route.size] = (-3547, 1611, 1058);
	level.iz_route[level.iz_route.size] = (-4066, 1989, 1125);
	level.iz_route[level.iz_route.size] = (-4563, 2412, 1102);
	level.iz_route[level.iz_route.size] = (-4711, 2894, 1301);
	level.iz_route[level.iz_route.size] = (-4763, 3436, 1412);
	level.iz_route[level.iz_route.size] = (-4756, 3992, 1537);
	level.iz_route[level.iz_route.size] = (-4637, 4392, 1628);
	level.iz_route[level.iz_route.size] = (-4407, 4823, 1735);
	level.iz_route[level.iz_route.size] = (-4021, 5171, 1809);
	level.iz_route[level.iz_route.size] = (-3569, 5327, 1824);
	level.iz_route[level.iz_route.size] = (-3079, 5320, 1789);
	level.iz_route[level.iz_route.size] = (-2597, 5149, 1714);
	level.iz_route[level.iz_route.size] = (-2301, 4897, 1630);
	level.iz_route[level.iz_route.size] = (-2160, 4578, 1536);
	level.iz_route[level.iz_route.size] = (-2019, 3992, 1367);
	level.iz_route[level.iz_route.size] = (-1804, 3362, 1328);
	level.iz_route[level.iz_route.size] = (-1633, 2850, 1365);
	level.iz_route[level.iz_route.size] = (-1477, 2457, 1453);
	level.iz_route[level.iz_route.size] = (-1233, 2101, 1555);
	level.iz_route[level.iz_route.size] = (-751, 1811, 1667);
	level.iz_route[level.iz_route.size] = (-142, 1708, 1746);
	level.iz_route[level.iz_route.size] = (355, 1878, 1754);
	level.iz_route[level.iz_route.size] = (755, 2204, 1716);
	level.iz_route[level.iz_route.size] = (1000, 2598, 1654);
	level.iz_route[level.iz_route.size] = (1067, 3043, 1563);
	level.iz_route[level.iz_route.size] = (955, 3621, 1374);
	level.iz_route[level.iz_route.size] = (807, 4163, 1319);
	level.iz_route[level.iz_route.size] = (562, 4786, 1304);
	level.iz_route[level.iz_route.size] = (452, 5031, 1319);
	level.iz_route[level.iz_route.size] = (147, 5825, 1313);
	level.iz_route[level.iz_route.size] = (-232, 6878, 1313);
	level.iz_route[level.iz_route.size] = (-472, 7540, 1313);
	level.iz_route[level.iz_route.size] = (-645, 7971, 1349);
	level.iz_route[level.iz_route.size] = (-745, 8333, 1415);
	level.iz_route[level.iz_route.size] = (-787, 8690, 1498);
	level.iz_route[level.iz_route.size] = (-718, 9131, 1498);
	level.iz_route[level.iz_route.size] = (-582, 9504, 1694);
	level.iz_route[level.iz_route.size] = (-246, 10066, 1793);
	level.iz_route[level.iz_route.size] = (85, 10460, 1840);
	level.iz_route[level.iz_route.size] = (463, 10764, 1857);
	level.iz_route[level.iz_route.size] = (957, 11022, 1862);
	level.iz_route[level.iz_route.size] = (1518, 11095, 1833);
	level.iz_route[level.iz_route.size] = (2107, 10948, 1772);
	level.iz_route[level.iz_route.size] = (2506, 10607, 1715);
	level.iz_route[level.iz_route.size] = (2695, 10155, 1694);
	level.iz_route[level.iz_route.size] = (2863, 9751, 1693);
	level.iz_route[level.iz_route.size] = (3025, 9404, 1706);
	level.iz_route[level.iz_route.size] = (3236, 8930, 1855);
	level.iz_route[level.iz_route.size] = (3330, 8690, 1855);
	level.iz_route[level.iz_route.size] = (3445, 8380, 1651);
	level.iz_route[level.iz_route.size] = (3656, 7766, 1651);
	level.iz_route[level.iz_route.size] = (3829, 7278, 1651);
	level.iz_route[level.iz_route.size] = (4034, 6716, 1651);
	level.iz_route[level.iz_route.size] = (4005, 6041, 1651);
	level.iz_route[level.iz_route.size] = (3963, 5350, 1651);
	level.iz_route[level.iz_route.size] = (4078, 4774, 1651);
	level.iz_route[level.iz_route.size] = (4414, 4260, 1651);
	level.iz_route[level.iz_route.size] = (4979, 3642, 1651);
	level.iz_route[level.iz_route.size] = (5380, 2954, 1651);
	level.iz_route[level.iz_route.size] = (5537, 2444, 1651);
	level.iz_route[level.iz_route.size] = (5742, 1841, 1651);
	level.iz_route[level.iz_route.size] = (5905, 1431, 1651);
	level.iz_route[level.iz_route.size] = (6073, 969, 1651);
	level.iz_route[level.iz_route.size] = (6283, 376, 1651);
	level.iz_route[level.iz_route.size] = (6556, -281, 1651);
	level.iz_route[level.iz_route.size] = (6743, -1187, 1651);
	level.iz_route[level.iz_route.size] = (6728, -1773, 1651);
	level.iz_route[level.iz_route.size] = (6706, -2262, 1669);
	level.iz_route[level.iz_route.size] = (6862, -2789, 1651);
	level.iz_route[level.iz_route.size] = (7062, -3300, 1651);
	level.iz_route[level.iz_route.size] = (7507, -3805, 1651);
	level.iz_route[level.iz_route.size] = (7967, -4287, 1651);
	level.iz_route[level.iz_route.size] = (8241, -4658, 1651);
	level.iz_route[level.iz_route.size] = (8419, -5251, 1684);
	level.iz_route[level.iz_route.size] = (8471, -5459, 1693);
	level.iz_route[level.iz_route.size] = (8627, -5830, 1651);
	level.iz_route[level.iz_route.size] = (8827, -6430, 1725);
	level.iz_route[level.iz_route.size] = (8998, -7113, 1845);
	level.iz_route[level.iz_route.size] = (9042, -7632, 2008);
	level.iz_route[level.iz_route.size] = (9013, -8003, 2147);
	level.iz_route[level.iz_route.size] = (8916, -8515, 2357);
	level.iz_route[level.iz_route.size] = (8627, -8878, 2474);
	level.iz_route[level.iz_route.size] = (8226, -9124, 2526);
	level.iz_route[level.iz_route.size] = (7803, -9253, 2551);
	level.iz_route[level.iz_route.size] = (7345, -9197, 2529);
	level.iz_route[level.iz_route.size] = (6992, -9071, 2504);
	level.iz_route[level.iz_route.size] = (6700, -8876, 2469);
	level.iz_route[level.iz_route.size] = (6418, -8516, 2418);
	level.iz_route[level.iz_route.size] = (6360, -8226, 2372);
	level.iz_route[level.iz_route.size] = (6321, -7716, 2307);
	level.iz_route[level.iz_route.size] = (6259, -7380, 2283);
	level.iz_route[level.iz_route.size] = (6251, -6912, 2256);
	level.iz_route[level.iz_route.size] = (6162, -6482, 2247);
	level.iz_route[level.iz_route.size] = (5918, -6096, 2243);
	level.iz_route[level.iz_route.size] = (5524, -5815, 2241);
	level.iz_route[level.iz_route.size] = (4976, -5607, 2240);
	level.iz_route[level.iz_route.size] = (4404, -5518, 2241);
	level.iz_route[level.iz_route.size] = (3856, -5496, 2241);
	level.iz_route[level.iz_route.size] = (3055, -5414, 2241);
	level.iz_route[level.iz_route.size] = (2343, -5377, 2241);
	level.iz_route[level.iz_route.size] = (1645, -5355, 2241);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (5685.4331, 604.3937, 1895.1969);
	angles[0] = (0, 22, 0);
	at[0] = 0;
	points[1] = (5685.4331, 604.3937, 1891.9528);
	angles[1] = (0, 22, 0);
	at[1] = 0.0500;
	points[2] = (5685.4331, 604.3937, 1879.8542);
	angles[2] = (0, 22, 0);
	at[2] = 0.1000;
	points[3] = (5685.4331, 604.3937, 1883.0945);
	angles[3] = (0, 22, 0);
	at[3] = 0.1500;
	points[4] = (5685.4331, 604.3937, 1895.1969);
	angles[4] = (0, 22, 0);
	at[4] = 0.2000;
	points[5] = (5685.4331, 604.3937, 1891.9528);
	angles[5] = (0, 22, 0);
	at[5] = 0.2500;
	points[6] = (5685.4331, 604.3937, 1897.8583);
	angles[6] = (0, 22, 0);
	at[6] = 0.3000;
	points[7] = (5685.4331, 604.3937, 2030.7323);
	angles[7] = (0, 22, 0);
	at[7] = 0.4500;
	points[8] = (5685.4331, 604.3937, 2000.6143);
	angles[8] = (0, 22, 0);
	at[8] = 0.5000;
	points[9] = (5685.4331, 604.3937, 1925.3188);
	angles[9] = (0, 22, 0);
	at[9] = 0.5500;
	points[10] = (5685.4331, 604.3937, 1804.8466);
	angles[10] = (0, 22, 0);
	at[10] = 0.6000;
	points[11] = (5685.4331, 604.3937, 1651.3032);
	angles[11] = (0, 22, 0);
	at[11] = 0.6500;
	points[12] = (5685.4331, 604.3937, 1651.3032);
	angles[12] = (0, 22, 0);
	at[12] = 1.6500;
	points[13] = (5685.4331, 604.3937, 1881.6180);
	angles[13] = (0, 22, 0);
	at[13] = 2.9500;
	points[14] = (5685.4331, 604.3937, 1887.5237);
	angles[14] = (0, 22, 0);
	at[14] = 3;
	points[15] = (5685.4331, 604.3937, 1887.5237);
	angles[15] = (0, 22, 0);
	at[15] = 4.4500;
	points[16] = (5685.4331, 604.3937, 1895.1969);
	angles[16] = (0, 22, 0);
	at[16] = 4.5000;
	points[17] = (5685.4331, 604.3937, 1891.9528);
	angles[17] = (0, 22, 0);
	at[17] = 4.5500;
	points[18] = (5685.4331, 604.3937, 1879.8542);
	angles[18] = (0, 22, 0);
	at[18] = 4.6000;
	points[19] = (5685.4331, 604.3937, 1883.0945);
	angles[19] = (0, 22, 0);
	at[19] = 4.6500;
	points[20] = (5685.4331, 604.3937, 1895.1969);
	angles[20] = (0, 22, 0);
	at[20] = 4.7000;
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
	points[0] = (6656.8110, 980.4645, 1713.3149);
	angles[0] = (0, 22, 0);
	at[0] = 0;
	points[1] = (6656.8110, 980.4645, 1881.6221);
	angles[1] = (0, 22, 0);
	at[1] = 0.9500;
	points[2] = (6656.8110, 980.4645, 1887.5237);
	angles[2] = (0, 22, 0);
	at[2] = 1;
	points[3] = (6656.8110, 980.4645, 1887.5237);
	angles[3] = (0, 22, 0);
	at[3] = 2.4500;
	points[4] = (6656.8110, 980.4645, 1895.1969);
	angles[4] = (0, 22, 0);
	at[4] = 2.5000;
	points[5] = (6656.8110, 980.4645, 1891.9528);
	angles[5] = (0, 22, 0);
	at[5] = 2.5500;
	points[6] = (6656.8110, 980.4645, 1879.8542);
	angles[6] = (0, 22, 0);
	at[6] = 2.6000;
	points[7] = (6656.8110, 980.4645, 1883.0945);
	angles[7] = (0, 22, 0);
	at[7] = 2.6500;
	points[8] = (6656.8110, 980.4645, 1895.1969);
	angles[8] = (0, 22, 0);
	at[8] = 2.7000;
	points[9] = (6656.8110, 980.4645, 1891.9528);
	angles[9] = (0, 22, 0);
	at[9] = 2.7500;
	points[10] = (6656.8110, 980.4645, 1879.8542);
	angles[10] = (0, 22, 0);
	at[10] = 2.8000;
	points[11] = (6656.8110, 980.4645, 1883.0945);
	angles[11] = (0, 22, 0);
	at[11] = 2.8500;
	points[12] = (6656.8110, 980.4645, 1895.1969);
	angles[12] = (0, 22, 0);
	at[12] = 2.9000;
	points[13] = (6656.8110, 980.4645, 1891.9528);
	angles[13] = (0, 22, 0);
	at[13] = 2.9500;
	points[14] = (6656.8110, 980.4645, 1897.8583);
	angles[14] = (0, 22, 0);
	at[14] = 3;
	points[15] = (6656.8110, 980.4645, 2030.7323);
	angles[15] = (0, 22, 0);
	at[15] = 3.1500;
	points[16] = (6656.8110, 980.4645, 2000.6143);
	angles[16] = (0, 22, 0);
	at[16] = 3.2000;
	points[17] = (6656.8110, 980.4645, 1925.3188);
	angles[17] = (0, 22, 0);
	at[17] = 3.2500;
	points[18] = (6656.8110, 980.4645, 1804.8466);
	angles[18] = (0, 22, 0);
	at[18] = 3.3000;
	points[19] = (6656.8110, 980.4645, 1651.3071);
	angles[19] = (0, 22, 0);
	at[19] = 3.3500;
	points[20] = (6656.8110, 980.4645, 1651.3071);
	angles[20] = (0, 22, 0);
	at[20] = 4.3500;
	points[21] = (6656.8110, 980.4645, 1713.3149);
	angles[21] = (0, 22, 0);
	at[21] = 4.7000;
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
	points[0] = (4670.1577, 5018.5039, 1887.5237);
	angles[0] = (0, 22, 0);
	at[0] = 0;
	points[1] = (4670.1577, 5018.5039, 1887.5237);
	angles[1] = (0, 22, 0);
	at[1] = 1.4500;
	points[2] = (4670.1577, 5018.5039, 1895.1930);
	angles[2] = (0, 22, 0);
	at[2] = 1.5000;
	points[3] = (4670.1577, 5018.5039, 1891.9528);
	angles[3] = (0, 22, 0);
	at[3] = 1.5500;
	points[4] = (4670.1577, 5018.5039, 1879.8503);
	angles[4] = (0, 22, 0);
	at[4] = 1.6000;
	points[5] = (4670.1577, 5018.5039, 1883.0945);
	angles[5] = (0, 22, 0);
	at[5] = 1.6500;
	points[6] = (4670.1577, 5018.5039, 1895.1930);
	angles[6] = (0, 22, 0);
	at[6] = 1.7000;
	points[7] = (4670.1577, 5018.5039, 1891.9528);
	angles[7] = (0, 22, 0);
	at[7] = 1.7500;
	points[8] = (4670.1577, 5018.5039, 1879.8503);
	angles[8] = (0, 22, 0);
	at[8] = 1.8000;
	points[9] = (4670.1577, 5018.5039, 1883.0945);
	angles[9] = (0, 22, 0);
	at[9] = 1.8500;
	points[10] = (4670.1577, 5018.5039, 1895.1930);
	angles[10] = (0, 22, 0);
	at[10] = 1.9000;
	points[11] = (4670.1577, 5018.5039, 1891.9528);
	angles[11] = (0, 22, 0);
	at[11] = 1.9500;
	points[12] = (4670.1577, 5018.5039, 1897.8583);
	angles[12] = (0, 22, 0);
	at[12] = 2;
	points[13] = (4670.1577, 5018.5039, 2030.7323);
	angles[13] = (0, 22, 0);
	at[13] = 2.1500;
	points[14] = (4670.1577, 5018.5039, 2000.6143);
	angles[14] = (0, 22, 0);
	at[14] = 2.2000;
	points[15] = (4670.1577, 5018.5039, 1925.3188);
	angles[15] = (0, 22, 0);
	at[15] = 2.2500;
	points[16] = (4670.1577, 5018.5039, 1804.8466);
	angles[16] = (0, 22, 0);
	at[16] = 2.3000;
	points[17] = (4670.1577, 5018.5039, 1651.3032);
	angles[17] = (0, 22, 0);
	at[17] = 2.3500;
	points[18] = (4670.1577, 5018.5039, 1651.3032);
	angles[18] = (0, 22, 0);
	at[18] = 3.3500;
	points[19] = (4670.1577, 5018.5039, 1881.6180);
	angles[19] = (0, 22, 0);
	at[19] = 4.6500;
	points[20] = (4670.1577, 5018.5039, 1887.5237);
	angles[20] = (0, 22, 0);
	at[20] = 4.7000;
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
	points[0] = (7498.8979, -2734.2993, 1887.5237);
	angles[0] = (0, 22, 0);
	at[0] = 0;
	points[1] = (7498.8979, -2734.2993, 1887.5237);
	angles[1] = (0, 22, 0);
	at[1] = 1.4500;
	points[2] = (7498.8979, -2734.2993, 1895.1969);
	angles[2] = (0, 22, 0);
	at[2] = 1.5000;
	points[3] = (7498.8979, -2734.2993, 1891.9528);
	angles[3] = (0, 22, 0);
	at[3] = 1.5500;
	points[4] = (7498.8979, -2734.2993, 1879.8542);
	angles[4] = (0, 22, 0);
	at[4] = 1.6000;
	points[5] = (7498.8979, -2734.2993, 1883.0945);
	angles[5] = (0, 22, 0);
	at[5] = 1.6500;
	points[6] = (7498.8979, -2734.2993, 1895.1969);
	angles[6] = (0, 22, 0);
	at[6] = 1.7000;
	points[7] = (7498.8979, -2734.2993, 1891.9528);
	angles[7] = (0, 22, 0);
	at[7] = 1.7500;
	points[8] = (7498.8979, -2734.2993, 1879.8542);
	angles[8] = (0, 22, 0);
	at[8] = 1.8000;
	points[9] = (7498.8979, -2734.2993, 1883.0945);
	angles[9] = (0, 22, 0);
	at[9] = 1.8500;
	points[10] = (7498.8979, -2734.2993, 1895.1969);
	angles[10] = (0, 22, 0);
	at[10] = 1.9000;
	points[11] = (7498.8979, -2734.2993, 1891.9528);
	angles[11] = (0, 22, 0);
	at[11] = 1.9500;
	points[12] = (7498.8979, -2734.2993, 1897.8583);
	angles[12] = (0, 22, 0);
	at[12] = 2;
	points[13] = (7498.8979, -2734.2993, 2030.7323);
	angles[13] = (0, 22, 0);
	at[13] = 2.1500;
	points[14] = (7498.8979, -2734.2993, 2000.6143);
	angles[14] = (0, 22, 0);
	at[14] = 2.2000;
	points[15] = (7498.8979, -2734.2993, 1925.3188);
	angles[15] = (0, 22, 0);
	at[15] = 2.2500;
	points[16] = (7498.8979, -2734.2993, 1804.8466);
	angles[16] = (0, 22, 0);
	at[16] = 2.3000;
	points[17] = (7498.8979, -2734.2993, 1651.3071);
	angles[17] = (0, 22, 0);
	at[17] = 2.3500;
	points[18] = (7498.8979, -2734.2993, 1651.3071);
	angles[18] = (0, 22, 0);
	at[18] = 3.3500;
	points[19] = (7498.8979, -2734.2993, 1881.6221);
	angles[19] = (0, 22, 0);
	at[19] = 4.6500;
	points[20] = (7498.8979, -2734.2993, 1887.5237);
	angles[20] = (0, 22, 0);
	at[20] = 4.7000;
	mover = getEnt("iz_obj_3", "targetname");
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
