main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_wiiu_hyrule_circuit", 0);

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
	ambientPlay("iz_0_uhc", 2);
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
	level.iz_route[level.iz_route.size] = (3836, 4166, 1482);
	level.iz_route[level.iz_route.size] = (3465, 1912, 1513);
	level.iz_route[level.iz_route.size] = (3379, 1437, 1526);
	level.iz_route[level.iz_route.size] = (3503, 1080, 1532);
	level.iz_route[level.iz_route.size] = (3846, 672, 1542);
	level.iz_route[level.iz_route.size] = (4254, 32, 1585);
	level.iz_route[level.iz_route.size] = (4330, -263, 1596);
	level.iz_route[level.iz_route.size] = (4346, -564, 1606);
	level.iz_route[level.iz_route.size] = (4256, -990, 1623);
	level.iz_route[level.iz_route.size] = (4102, -1762, 1691);
	level.iz_route[level.iz_route.size] = (4029, -2470, 1771);
	level.iz_route[level.iz_route.size] = (4147, -3017, 1825);
	level.iz_route[level.iz_route.size] = (4418, -3394, 1852);
	level.iz_route[level.iz_route.size] = (5299, -3719, 1835);
	level.iz_route[level.iz_route.size] = (6313, -3794, 1841);
	level.iz_route[level.iz_route.size] = (7937, -3682, 1959);
	level.iz_route[level.iz_route.size] = (9059, -3665, 2150);
	level.iz_route[level.iz_route.size] = (9677, -4072, 2330);
	level.iz_route[level.iz_route.size] = (10093, -4818, 2515);
	level.iz_route[level.iz_route.size] = (10116, -5503, 2618);
	level.iz_route[level.iz_route.size] = (9978, -6149, 2689);
	level.iz_route[level.iz_route.size] = (9513, -6845, 2749);
	level.iz_route[level.iz_route.size] = (8769, -7355, 2737);
	level.iz_route[level.iz_route.size] = (7913, -7368, 2624);
	level.iz_route[level.iz_route.size] = (5791, -6946, 2542);
	level.iz_route[level.iz_route.size] = (3878, -6510, 2469);
	level.iz_route[level.iz_route.size] = (2689, -6473, 2538);
	level.iz_route[level.iz_route.size] = (944, -6395, 2716);
	level.iz_route[level.iz_route.size] = (-1335, -6351, 2502);
	level.iz_route[level.iz_route.size] = (-2461, -6352, 2583);
	level.iz_route[level.iz_route.size] = (-4321, -6339, 2583);
	level.iz_route[level.iz_route.size] = (-5468, -6582, 2587);
	level.iz_route[level.iz_route.size] = (-6099, -7061, 2581);
	level.iz_route[level.iz_route.size] = (-6230, -7622, 2546);
	level.iz_route[level.iz_route.size] = (-6149, -8279, 2463);
	level.iz_route[level.iz_route.size] = (-5683, -8909, 2338);
	level.iz_route[level.iz_route.size] = (-5056, -9114, 2200);
	level.iz_route[level.iz_route.size] = (-4287, -8989, 2020);
	level.iz_route[level.iz_route.size] = (-3787, -8560, 1891);
	level.iz_route[level.iz_route.size] = (-3619, -8025, 1823);
	level.iz_route[level.iz_route.size] = (-3486, -6455, 1713);
	level.iz_route[level.iz_route.size] = (-3824, -5584, 1710);
	level.iz_route[level.iz_route.size] = (-4367, -4339, 1713);
	level.iz_route[level.iz_route.size] = (-4466, -3412, 1810);
	level.iz_route[level.iz_route.size] = (-3857, -2726, 1724);
	level.iz_route[level.iz_route.size] = (-3504, -2227, 1724);
	level.iz_route[level.iz_route.size] = (-3484, -811, 1724);
	level.iz_route[level.iz_route.size] = (-3491, 649, 1703);
	level.iz_route[level.iz_route.size] = (-3534, 2468, 1657);
	level.iz_route[level.iz_route.size] = (-3043, 3445, 1610);
	level.iz_route[level.iz_route.size] = (-2305, 4352, 1549);
	level.iz_route[level.iz_route.size] = (-2229, 4748, 1528);
	level.iz_route[level.iz_route.size] = (-2319, 5191, 1511);
	level.iz_route[level.iz_route.size] = (-2847, 6401, 1553);
	level.iz_route[level.iz_route.size] = (-2865, 6921, 1584);
	level.iz_route[level.iz_route.size] = (-2556, 7367, 1611);
	level.iz_route[level.iz_route.size] = (-2051, 7495, 1593);
	level.iz_route[level.iz_route.size] = (-1517, 7383, 1546);
	level.iz_route[level.iz_route.size] = (-545, 6891, 1475);
	level.iz_route[level.iz_route.size] = (-103, 6578, 1462);
	level.iz_route[level.iz_route.size] = (561, 6524, 1462);
	level.iz_route[level.iz_route.size] = (1078, 6582, 1481);
	level.iz_route[level.iz_route.size] = (1369, 6791, 1497);
	level.iz_route[level.iz_route.size] = (1544, 7153, 1515);
	level.iz_route[level.iz_route.size] = (1713, 7713, 1557);
	level.iz_route[level.iz_route.size] = (1864, 8460, 1645);
	level.iz_route[level.iz_route.size] = (2101, 9032, 1761);
	level.iz_route[level.iz_route.size] = (2377, 9338, 1841);
	level.iz_route[level.iz_route.size] = (2924, 9589, 1912);
	level.iz_route[level.iz_route.size] = (3471, 9654, 1951);
	level.iz_route[level.iz_route.size] = (3949, 9525, 1956);
	level.iz_route[level.iz_route.size] = (4322, 9171, 1901);
	level.iz_route[level.iz_route.size] = (4555, 8739, 1839);
	level.iz_route[level.iz_route.size] = (4606, 8202, 1767);
	level.iz_route[level.iz_route.size] = (4429, 7838, 1723);
	level.iz_route[level.iz_route.size] = (4129, 6144, 1481);
}
