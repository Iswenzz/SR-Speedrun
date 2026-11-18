main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_wiiu_big_blue", 0);

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

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
}

iz_sounds()
{
	ambientPlay("iz_0_ubb", 2);
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
	level.iz_route[level.iz_route.size] = (7419, 2821, 914);
	level.iz_route[level.iz_route.size] = (9768, 2797, 963);
	level.iz_route[level.iz_route.size] = (10915, 2793, 1037);
	level.iz_route[level.iz_route.size] = (11931, 3141, 1116);
	level.iz_route[level.iz_route.size] = (12627, 3729, 1196);
	level.iz_route[level.iz_route.size] = (13019, 4566, 1242);
	level.iz_route[level.iz_route.size] = (13215, 5482, 1305);
	level.iz_route[level.iz_route.size] = (13093, 6365, 1385);
	level.iz_route[level.iz_route.size] = (12377, 7347, 1474);
	level.iz_route[level.iz_route.size] = (11584, 7840, 1534);
	level.iz_route[level.iz_route.size] = (10595, 8008, 1597);
	level.iz_route[level.iz_route.size] = (9467, 7923, 1701);
	level.iz_route[level.iz_route.size] = (8770, 7396, 1725);
	level.iz_route[level.iz_route.size] = (8202, 6562, 1766);
	level.iz_route[level.iz_route.size] = (7969, 5805, 1808);
	level.iz_route[level.iz_route.size] = (7902, 4616, 1856);
	level.iz_route[level.iz_route.size] = (7894, 3679, 1916);
	level.iz_route[level.iz_route.size] = (7900, 1758, 1655);
	level.iz_route[level.iz_route.size] = (7957, 297, 1655);
	level.iz_route[level.iz_route.size] = (8233, -445, 1655);
	level.iz_route[level.iz_route.size] = (8716, -873, 1655);
	level.iz_route[level.iz_route.size] = (9459, -1152, 1655);
	level.iz_route[level.iz_route.size] = (10659, -1044, 1657);
	level.iz_route[level.iz_route.size] = (11588, -676, 1679);
	level.iz_route[level.iz_route.size] = (12372, -60, 1737);
	level.iz_route[level.iz_route.size] = (13051, 579, 1810);
	level.iz_route[level.iz_route.size] = (13713, 995, 1871);
	level.iz_route[level.iz_route.size] = (14641, 1257, 1922);
	level.iz_route[level.iz_route.size] = (15951, 1259, 1949);
	level.iz_route[level.iz_route.size] = (17769, 1263, 2007);
	level.iz_route[level.iz_route.size] = (19404, 1161, 2129);
	level.iz_route[level.iz_route.size] = (20092, 948, 2188);
	level.iz_route[level.iz_route.size] = (20622, 395, 2232);
	level.iz_route[level.iz_route.size] = (20775, -270, 2263);
	level.iz_route[level.iz_route.size] = (20469, -1000, 2312);
	level.iz_route[level.iz_route.size] = (19941, -1356, 2352);
	level.iz_route[level.iz_route.size] = (19052, -1584, 2386);
	level.iz_route[level.iz_route.size] = (18200, -1862, 2440);
	level.iz_route[level.iz_route.size] = (17682, -2296, 2486);
	level.iz_route[level.iz_route.size] = (17462, -2858, 2526);
	level.iz_route[level.iz_route.size] = (17408, -3468, 2564);
	level.iz_route[level.iz_route.size] = (17600, -4255, 2605);
	level.iz_route[level.iz_route.size] = (17661, -5090, 2637);
	level.iz_route[level.iz_route.size] = (17488, -5514, 2656);
	level.iz_route[level.iz_route.size] = (17131, -5843, 2684);
	level.iz_route[level.iz_route.size] = (16535, -6083, 2711);
	level.iz_route[level.iz_route.size] = (15743, -6207, 2734);
	level.iz_route[level.iz_route.size] = (15151, -6224, 2755);
	level.iz_route[level.iz_route.size] = (5224, -6261, 2602);
	level.iz_route[level.iz_route.size] = (3802, -6317, 2618);
	level.iz_route[level.iz_route.size] = (2217, -6227, 2578);
	level.iz_route[level.iz_route.size] = (1149, -6170, 2657);
	level.iz_route[level.iz_route.size] = (363, -5977, 2741);
	level.iz_route[level.iz_route.size] = (-77, -5619, 2803);
	level.iz_route[level.iz_route.size] = (-212, -5073, 2850);
	level.iz_route[level.iz_route.size] = (-167, -4270, 2905);
	level.iz_route[level.iz_route.size] = (-131, -3442, 2963);
	level.iz_route[level.iz_route.size] = (128, -2716, 2969);
	level.iz_route[level.iz_route.size] = (279, -2001, 2946);
	level.iz_route[level.iz_route.size] = (426, -1486, 2907);
	level.iz_route[level.iz_route.size] = (629, -1170, 2856);
	level.iz_route[level.iz_route.size] = (1087, -994, 2778);
	level.iz_route[level.iz_route.size] = (1645, -763, 2679);
	level.iz_route[level.iz_route.size] = (2073, -522, 2615);
	level.iz_route[level.iz_route.size] = (2263, -139, 2564);
	level.iz_route[level.iz_route.size] = (2317, 227, 2528);
	level.iz_route[level.iz_route.size] = (2330, 666, 2511);
	level.iz_route[level.iz_route.size] = (2237, 1272, 2504);
	level.iz_route[level.iz_route.size] = (2026, 1786, 2498);
	level.iz_route[level.iz_route.size] = (2028, 2769, 2344);
	level.iz_route[level.iz_route.size] = (2050, 3751, 2348);
	level.iz_route[level.iz_route.size] = (2103, 4813, 2356);
	level.iz_route[level.iz_route.size] = (2223, 5404, 2360);
	level.iz_route[level.iz_route.size] = (2564, 5918, 2362);
	level.iz_route[level.iz_route.size] = (3250, 6262, 2363);
	level.iz_route[level.iz_route.size] = (4244, 6361, 2351);
	level.iz_route[level.iz_route.size] = (5145, 6512, 2344);
	level.iz_route[level.iz_route.size] = (5745, 7049, 2343);
	level.iz_route[level.iz_route.size] = (6029, 7972, 2336);
	level.iz_route[level.iz_route.size] = (6101, 8688, 2329);
	level.iz_route[level.iz_route.size] = (6159, 9716, 2313);
	level.iz_route[level.iz_route.size] = (6352, 10595, 2290);
	level.iz_route[level.iz_route.size] = (6917, 11256, 2243);
	level.iz_route[level.iz_route.size] = (7554, 11561, 2223);
	level.iz_route[level.iz_route.size] = (8203, 11363, 2153);
	level.iz_route[level.iz_route.size] = (8914, 10885, 2099);
	level.iz_route[level.iz_route.size] = (9177, 10053, 1993);
	level.iz_route[level.iz_route.size] = (9075, 9278, 1958);
	level.iz_route[level.iz_route.size] = (8313, 8734, 1893);
	level.iz_route[level.iz_route.size] = (7620, 8717, 1845);
	level.iz_route[level.iz_route.size] = (7250, 8780, 1827);
	level.iz_route[level.iz_route.size] = (83, 11585, 1814);
	level.iz_route[level.iz_route.size] = (-923, 11764, 1819);
	level.iz_route[level.iz_route.size] = (-1908, 11812, 1830);
	level.iz_route[level.iz_route.size] = (-2702, 11657, 1831);
	level.iz_route[level.iz_route.size] = (-3636, 11377, 1832);
	level.iz_route[level.iz_route.size] = (-4236, 10920, 1840);
	level.iz_route[level.iz_route.size] = (-4420, 10169, 1836);
	level.iz_route[level.iz_route.size] = (-4289, 9566, 1840);
	level.iz_route[level.iz_route.size] = (-3727, 9025, 1842);
	level.iz_route[level.iz_route.size] = (-2523, 8514, 1855);
	level.iz_route[level.iz_route.size] = (-2069, 8212, 1853);
	level.iz_route[level.iz_route.size] = (-1823, 7643, 1845);
	level.iz_route[level.iz_route.size] = (-1891, 6946, 1843);
	level.iz_route[level.iz_route.size] = (-2368, 6316, 1838);
	level.iz_route[level.iz_route.size] = (-3010, 5655, 1842);
	level.iz_route[level.iz_route.size] = (-3555, 4952, 1829);
	level.iz_route[level.iz_route.size] = (-3747, 4163, 1823);
	level.iz_route[level.iz_route.size] = (-3793, 3221, 1815);
	level.iz_route[level.iz_route.size] = (-3752, 1657, 1701);
	level.iz_route[level.iz_route.size] = (-3632, 415, 1701);
	level.iz_route[level.iz_route.size] = (-3429, -22, 1701);
	level.iz_route[level.iz_route.size] = (-2525, -1081, 1701);
	level.iz_route[level.iz_route.size] = (-2363, -1717, 1701);
	level.iz_route[level.iz_route.size] = (-2613, -2352, 1701);
	level.iz_route[level.iz_route.size] = (-2838, -2928, 1701);
	level.iz_route[level.iz_route.size] = (-2924, -3776, 1701);
	level.iz_route[level.iz_route.size] = (-2916, -4861, 1701);
	level.iz_route[level.iz_route.size] = (-2929, -4988, 1701);
	level.iz_route[level.iz_route.size] = (-2434, -4980, 1701);
	level.iz_route[level.iz_route.size] = (-1203, -3908, 1701);
	level.iz_route[level.iz_route.size] = (2506, 586, 1701);
	level.iz_route[level.iz_route.size] = (5298, 3002, 912);
	level.iz_route[level.iz_route.size] = (6317, 2943, 912);
}
