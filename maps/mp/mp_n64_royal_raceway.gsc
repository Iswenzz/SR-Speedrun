main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_n64_royal_raceway", 0);

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
	ambientPlay("iz_0_30", 2);
	iz_emitter("iz_1_se_cc_env_water_fall", (13744.9189, 5210.4121, 2169.9695), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (13583.9883, 5108.9819, 1375.1948), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (13263.0361, 4825.7241, 1099.1826), 0, 12.0104);
	iz_emitter("iz_2_se_cc_env_audience", (-8910.0615, 4365.3721, 1795.0874), 0, 12.0104);
	iz_emitter("iz_2_se_cc_env_audience", (-8908.8428, 2398.3127, 1792.0122), 0, 12.0104);
	iz_emitter("iz_2_se_cc_env_audience", (-8911.4170, 624.3661, 1784.2396), 0, 12.0104);
}

iz_emitter(alias, origin, interval, length)
{
	ent = spawn("script_origin", origin);
	if (interval <= 0)
		ent playLoopSound(alias);
	else
		ent thread iz_emitter_random(alias, interval, length);
}

// One play at a time: copies started over one another ran out the
// engine's 32 voices, and the sounds that lost theirs restarted.
iz_emitter_random(alias, interval, length)
{
	for (;;)
	{
		wait(randomFloatRange(interval * 0.25, interval));
		self playSound(alias);
		wait(length);
	}
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
	level.iz_route[level.iz_route.size] = (-8012, 1933, 1436);
	level.iz_route[level.iz_route.size] = (-8010, 360, 1436);
	level.iz_route[level.iz_route.size] = (-8012, -1317, 1436);
	level.iz_route[level.iz_route.size] = (-8021, -2965, 1436);
	level.iz_route[level.iz_route.size] = (-8035, -4158, 1436);
	level.iz_route[level.iz_route.size] = (-8010, -4910, 1436);
	level.iz_route[level.iz_route.size] = (-7875, -5548, 1437);
	level.iz_route[level.iz_route.size] = (-7511, -6064, 1439);
	level.iz_route[level.iz_route.size] = (-6823, -6567, 1453);
	level.iz_route[level.iz_route.size] = (-5763, -7306, 1484);
	level.iz_route[level.iz_route.size] = (-4469, -8188, 1529);
	level.iz_route[level.iz_route.size] = (-3756, -8626, 1581);
	level.iz_route[level.iz_route.size] = (-3003, -8846, 1647);
	level.iz_route[level.iz_route.size] = (-2378, -8804, 1670);
	level.iz_route[level.iz_route.size] = (-1906, -8560, 1679);
	level.iz_route[level.iz_route.size] = (-1523, -8124, 1675);
	level.iz_route[level.iz_route.size] = (-1307, -7556, 1659);
	level.iz_route[level.iz_route.size] = (-1296, -6914, 1624);
	level.iz_route[level.iz_route.size] = (-1517, -6242, 1556);
	level.iz_route[level.iz_route.size] = (-1925, -5468, 1499);
	level.iz_route[level.iz_route.size] = (-2478, -4464, 1447);
	level.iz_route[level.iz_route.size] = (-2647, -3926, 1436);
	level.iz_route[level.iz_route.size] = (-2566, -3369, 1436);
	level.iz_route[level.iz_route.size] = (-2229, -2965, 1436);
	level.iz_route[level.iz_route.size] = (-1723, -2788, 1436);
	level.iz_route[level.iz_route.size] = (-1225, -2845, 1436);
	level.iz_route[level.iz_route.size] = (-799, -3159, 1436);
	level.iz_route[level.iz_route.size] = (-453, -3655, 1436);
	level.iz_route[level.iz_route.size] = (122, -4584, 1436);
	level.iz_route[level.iz_route.size] = (752, -5457, 1436);
	level.iz_route[level.iz_route.size] = (1454, -6372, 1436);
	level.iz_route[level.iz_route.size] = (1824, -6931, 1436);
	level.iz_route[level.iz_route.size] = (2052, -7562, 1436);
	level.iz_route[level.iz_route.size] = (2011, -8227, 1436);
	level.iz_route[level.iz_route.size] = (1707, -8855, 1436);
	level.iz_route[level.iz_route.size] = (1285, -9333, 1436);
	level.iz_route[level.iz_route.size] = (629, -9862, 1441);
	level.iz_route[level.iz_route.size] = (-707, -10830, 1511);
	level.iz_route[level.iz_route.size] = (-1590, -11425, 1550);
	level.iz_route[level.iz_route.size] = (-2185, -11690, 1564);
	level.iz_route[level.iz_route.size] = (-2914, -11805, 1585);
	level.iz_route[level.iz_route.size] = (-3632, -11734, 1604);
	level.iz_route[level.iz_route.size] = (-4338, -11461, 1622);
	level.iz_route[level.iz_route.size] = (-5293, -10871, 1630);
	level.iz_route[level.iz_route.size] = (-6372, -10075, 1629);
	level.iz_route[level.iz_route.size] = (-6998, -9589, 1627);
	level.iz_route[level.iz_route.size] = (-7551, -9250, 1615);
	level.iz_route[level.iz_route.size] = (-8162, -9084, 1594);
	level.iz_route[level.iz_route.size] = (-8762, -9120, 1577);
	level.iz_route[level.iz_route.size] = (-9376, -9323, 1554);
	level.iz_route[level.iz_route.size] = (-10783, -9945, 1501);
	level.iz_route[level.iz_route.size] = (-12464, -10725, 1455);
	level.iz_route[level.iz_route.size] = (-14120, -11477, 1436);
	level.iz_route[level.iz_route.size] = (-15296, -11968, 1436);
	level.iz_route[level.iz_route.size] = (-15943, -12062, 1436);
	level.iz_route[level.iz_route.size] = (-16608, -11901, 1436);
	level.iz_route[level.iz_route.size] = (-17162, -11476, 1436);
	level.iz_route[level.iz_route.size] = (-17481, -10901, 1436);
	level.iz_route[level.iz_route.size] = (-17557, -10268, 1436);
	level.iz_route[level.iz_route.size] = (-17374, -9622, 1436);
	level.iz_route[level.iz_route.size] = (-16905, -9057, 1436);
	level.iz_route[level.iz_route.size] = (-16183, -8619, 1436);
	level.iz_route[level.iz_route.size] = (-14845, -7923, 1484);
	level.iz_route[level.iz_route.size] = (-12792, -6843, 1628);
	level.iz_route[level.iz_route.size] = (-11074, -5943, 1767);
	level.iz_route[level.iz_route.size] = (-9184, -4954, 1913);
	level.iz_route[level.iz_route.size] = (-8055, -4356, 1982);
	level.iz_route[level.iz_route.size] = (-6258, -3413, 2078);
	level.iz_route[level.iz_route.size] = (-4137, -2292, 2176);
	level.iz_route[level.iz_route.size] = (-3270, -1850, 2352);
	level.iz_route[level.iz_route.size] = (2313, 1061, 1436);
	level.iz_route[level.iz_route.size] = (3499, 1688, 1436);
	level.iz_route[level.iz_route.size] = (4365, 2156, 1436);
	level.iz_route[level.iz_route.size] = (4858, 2517, 1436);
	level.iz_route[level.iz_route.size] = (5172, 3035, 1436);
	level.iz_route[level.iz_route.size] = (5289, 3579, 1436);
	level.iz_route[level.iz_route.size] = (5221, 4120, 1436);
	level.iz_route[level.iz_route.size] = (4955, 4642, 1436);
	level.iz_route[level.iz_route.size] = (4496, 5026, 1436);
	level.iz_route[level.iz_route.size] = (3724, 5322, 1464);
	level.iz_route[level.iz_route.size] = (2805, 5665, 1506);
	level.iz_route[level.iz_route.size] = (2152, 6089, 1529);
	level.iz_route[level.iz_route.size] = (1724, 6657, 1549);
	level.iz_route[level.iz_route.size] = (1478, 7378, 1570);
	level.iz_route[level.iz_route.size] = (1286, 8070, 1589);
	level.iz_route[level.iz_route.size] = (919, 8524, 1608);
	level.iz_route[level.iz_route.size] = (409, 8699, 1632);
	level.iz_route[level.iz_route.size] = (-97, 8569, 1650);
	level.iz_route[level.iz_route.size] = (-515, 8163, 1645);
	level.iz_route[level.iz_route.size] = (-907, 7235, 1513);
	level.iz_route[level.iz_route.size] = (-1274, 6749, 1457);
	level.iz_route[level.iz_route.size] = (-1895, 6570, 1436);
	level.iz_route[level.iz_route.size] = (-2733, 6729, 1440);
	level.iz_route[level.iz_route.size] = (-3912, 7026, 1450);
	level.iz_route[level.iz_route.size] = (-5185, 7317, 1485);
	level.iz_route[level.iz_route.size] = (-6075, 7414, 1507);
	level.iz_route[level.iz_route.size] = (-6792, 7240, 1509);
	level.iz_route[level.iz_route.size] = (-7399, 6823, 1497);
	level.iz_route[level.iz_route.size] = (-7810, 6206, 1480);
	level.iz_route[level.iz_route.size] = (-7992, 5439, 1448);
	level.iz_route[level.iz_route.size] = (-7997, 3967, 1436);
}
