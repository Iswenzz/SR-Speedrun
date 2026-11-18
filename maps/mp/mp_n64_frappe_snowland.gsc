main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_n64_frappe_snowland", 0);

	setExpFog(1181.1024, 3672.4902, 0.4745, 0.5882, 0.8510, 0);

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
	ambientPlay("iz_0_25", 2);
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
	level.iz_route[level.iz_route.size] = (0, 222, 2060);
	level.iz_route[level.iz_route.size] = (-10, -99, 2060);
	level.iz_route[level.iz_route.size] = (9, -1216, 2060);
	level.iz_route[level.iz_route.size] = (-25, -2412, 2060);
	level.iz_route[level.iz_route.size] = (-196, -2820, 2060);
	level.iz_route[level.iz_route.size] = (-441, -3169, 2060);
	level.iz_route[level.iz_route.size] = (-826, -3399, 2060);
	level.iz_route[level.iz_route.size] = (-1464, -3666, 2060);
	level.iz_route[level.iz_route.size] = (-3118, -4215, 2060);
	level.iz_route[level.iz_route.size] = (-4066, -4526, 2060);
	level.iz_route[level.iz_route.size] = (-4825, -4932, 2060);
	level.iz_route[level.iz_route.size] = (-5171, -5299, 2060);
	level.iz_route[level.iz_route.size] = (-5266, -5602, 2060);
	level.iz_route[level.iz_route.size] = (-5265, -5885, 2060);
	level.iz_route[level.iz_route.size] = (-5175, -6188, 2060);
	level.iz_route[level.iz_route.size] = (-4835, -6942, 2060);
	level.iz_route[level.iz_route.size] = (-4495, -7667, 2060);
	level.iz_route[level.iz_route.size] = (-4169, -8407, 2060);
	level.iz_route[level.iz_route.size] = (-3962, -9399, 2060);
	level.iz_route[level.iz_route.size] = (-3764, -10043, 2060);
	level.iz_route[level.iz_route.size] = (-3422, -10815, 2060);
	level.iz_route[level.iz_route.size] = (-2807, -11247, 2060);
	level.iz_route[level.iz_route.size] = (-2060, -11315, 2060);
	level.iz_route[level.iz_route.size] = (-1567, -11104, 2060);
	level.iz_route[level.iz_route.size] = (-1145, -10518, 2060);
	level.iz_route[level.iz_route.size] = (-488, -9463, 2060);
	level.iz_route[level.iz_route.size] = (-43, -8735, 2060);
	level.iz_route[level.iz_route.size] = (427, -8266, 2060);
	level.iz_route[level.iz_route.size] = (919, -7915, 2060);
	level.iz_route[level.iz_route.size] = (1525, -7623, 2060);
	level.iz_route[level.iz_route.size] = (2134, -7412, 2060);
	level.iz_route[level.iz_route.size] = (2861, -7435, 2060);
	level.iz_route[level.iz_route.size] = (3518, -7576, 2060);
	level.iz_route[level.iz_route.size] = (4103, -7854, 2060);
	level.iz_route[level.iz_route.size] = (4902, -8326, 2060);
	level.iz_route[level.iz_route.size] = (5395, -8303, 2060);
	level.iz_route[level.iz_route.size] = (5864, -8162, 2060);
	level.iz_route[level.iz_route.size] = (6333, -7717, 2046);
	level.iz_route[level.iz_route.size] = (6745, -7293, 2002);
	level.iz_route[level.iz_route.size] = (7455, -6413, 1895);
	level.iz_route[level.iz_route.size] = (8372, -5275, 1597);
	level.iz_route[level.iz_route.size] = (9356, -4160, 1761);
	level.iz_route[level.iz_route.size] = (10179, -3284, 1834);
	level.iz_route[level.iz_route.size] = (10625, -2650, 1900);
	level.iz_route[level.iz_route.size] = (10742, -2087, 1908);
	level.iz_route[level.iz_route.size] = (10625, -1501, 1908);
	level.iz_route[level.iz_route.size] = (10132, -938, 1948);
	level.iz_route[level.iz_route.size] = (9781, -469, 2008);
	level.iz_route[level.iz_route.size] = (9476, 188, 2061);
	level.iz_route[level.iz_route.size] = (9100, 539, 2060);
	level.iz_route[level.iz_route.size] = (8795, 1196, 2060);
	level.iz_route[level.iz_route.size] = (8693, 1691, 2060);
	level.iz_route[level.iz_route.size] = (8675, 2884, 2060);
	level.iz_route[level.iz_route.size] = (8702, 4550, 2060);
	level.iz_route[level.iz_route.size] = (8889, 5230, 2060);
	level.iz_route[level.iz_route.size] = (8960, 6169, 2060);
	level.iz_route[level.iz_route.size] = (8749, 6778, 2060);
	level.iz_route[level.iz_route.size] = (8631, 7505, 2061);
	level.iz_route[level.iz_route.size] = (7951, 7857, 2061);
	level.iz_route[level.iz_route.size] = (7247, 7975, 2062);
	level.iz_route[level.iz_route.size] = (6614, 7717, 2062);
	level.iz_route[level.iz_route.size] = (5512, 7060, 2062);
	level.iz_route[level.iz_route.size] = (4879, 6849, 2062);
	level.iz_route[level.iz_route.size] = (4386, 7060, 2062);
	level.iz_route[level.iz_route.size] = (3753, 7623, 2062);
	level.iz_route[level.iz_route.size] = (3190, 8209, 2062);
	level.iz_route[level.iz_route.size] = (2533, 8584, 2062);
	level.iz_route[level.iz_route.size] = (1237, 8752, 2062);
	level.iz_route[level.iz_route.size] = (-988, 8855, 2062);
	level.iz_route[level.iz_route.size] = (-3612, 8866, 2062);
	level.iz_route[level.iz_route.size] = (-6333, 9218, 2062);
	level.iz_route[level.iz_route.size] = (-7916, 9339, 2062);
	level.iz_route[level.iz_route.size] = (-8858, 9292, 2061);
	level.iz_route[level.iz_route.size] = (-9297, 9158, 2062);
	level.iz_route[level.iz_route.size] = (-9553, 8989, 2062);
	level.iz_route[level.iz_route.size] = (-9741, 8633, 2062);
	level.iz_route[level.iz_route.size] = (-9783, 8153, 2062);
	level.iz_route[level.iz_route.size] = (-9720, 7755, 2062);
	level.iz_route[level.iz_route.size] = (-9574, 7316, 2062);
	level.iz_route[level.iz_route.size] = (-9323, 6982, 2062);
	level.iz_route[level.iz_route.size] = (-8628, 6349, 2062);
	level.iz_route[level.iz_route.size] = (-6985, 5224, 2062);
	level.iz_route[level.iz_route.size] = (-6659, 5091, 2062);
	level.iz_route[level.iz_route.size] = (-6053, 4913, 2062);
	level.iz_route[level.iz_route.size] = (-5490, 4810, 2062);
	level.iz_route[level.iz_route.size] = (-4869, 4795, 2062);
	level.iz_route[level.iz_route.size] = (-4380, 4958, 2062);
	level.iz_route[level.iz_route.size] = (-3359, 5402, 2062);
	level.iz_route[level.iz_route.size] = (-2457, 5742, 2061);
	level.iz_route[level.iz_route.size] = (-1939, 5846, 2061);
	level.iz_route[level.iz_route.size] = (-1435, 5875, 2061);
	level.iz_route[level.iz_route.size] = (-1110, 5801, 2061);
	level.iz_route[level.iz_route.size] = (-681, 5564, 2062);
	level.iz_route[level.iz_route.size] = (-429, 5224, 2062);
	level.iz_route[level.iz_route.size] = (-207, 4810, 2062);
	level.iz_route[level.iz_route.size] = (-89, 4306, 2062);
	level.iz_route[level.iz_route.size] = (0, 3522, 2062);
	level.iz_route[level.iz_route.size] = (0, 2146, 2063);
}
