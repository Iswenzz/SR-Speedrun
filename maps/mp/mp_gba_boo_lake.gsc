main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_gba_boo_lake", 0);

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
	ambientPlay("iz_0_41", 2);
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
	level.iz_route[level.iz_route.size] = (8625, -3084, 1417);
	level.iz_route[level.iz_route.size] = (8625, -3798, 1417);
	level.iz_route[level.iz_route.size] = (8608, -4611, 1417);
	level.iz_route[level.iz_route.size] = (8608, -5491, 1417);
	level.iz_route[level.iz_route.size] = (8591, -6438, 1417);
	level.iz_route[level.iz_route.size] = (8575, -7700, 1417);
	level.iz_route[level.iz_route.size] = (8558, -8480, 1417);
	level.iz_route[level.iz_route.size] = (8309, -8962, 1417);
	level.iz_route[level.iz_route.size] = (7861, -9294, 1417);
	level.iz_route[level.iz_route.size] = (7221, -9435, 1417);
	level.iz_route[level.iz_route.size] = (6182, -9439, 1417);
	level.iz_route[level.iz_route.size] = (5200, -9447, 1323);
	level.iz_route[level.iz_route.size] = (4492, -9439, 1408);
	level.iz_route[level.iz_route.size] = (3294, -9439, 1326);
	level.iz_route[level.iz_route.size] = (2312, -9431, 1445);
	level.iz_route[level.iz_route.size] = (1397, -9431, 1555);
	level.iz_route[level.iz_route.size] = (473, -9439, 1520);
	level.iz_route[level.iz_route.size] = (-259, -9431, 1499);
	level.iz_route[level.iz_route.size] = (-842, -9431, 1631);
	level.iz_route[level.iz_route.size] = (-1916, -9439, 1610);
	level.iz_route[level.iz_route.size] = (-2548, -9439, 1610);
	level.iz_route[level.iz_route.size] = (-3280, -9431, 1610);
	level.iz_route[level.iz_route.size] = (-3988, -9431, 1610);
	level.iz_route[level.iz_route.size] = (-4495, -9447, 1610);
	level.iz_route[level.iz_route.size] = (-5211, -9439, 1610);
	level.iz_route[level.iz_route.size] = (-5827, -9489, 1611);
	level.iz_route[level.iz_route.size] = (-6376, -9830, 1613);
	level.iz_route[level.iz_route.size] = (-6925, -10113, 1620);
	level.iz_route[level.iz_route.size] = (-7616, -10130, 1641);
	level.iz_route[level.iz_route.size] = (-8149, -9813, 1666);
	level.iz_route[level.iz_route.size] = (-8515, -9381, 1690);
	level.iz_route[level.iz_route.size] = (-8640, -8790, 1711);
	level.iz_route[level.iz_route.size] = (-8448, -8166, 1726);
	level.iz_route[level.iz_route.size] = (-8003, -7614, 1729);
	level.iz_route[level.iz_route.size] = (-7546, -7250, 1729);
	level.iz_route[level.iz_route.size] = (-7153, -6821, 1729);
	level.iz_route[level.iz_route.size] = (-6883, -6344, 1729);
	level.iz_route[level.iz_route.size] = (-6883, -5607, 1729);
	level.iz_route[level.iz_route.size] = (-6888, -5111, 1729);
	level.iz_route[level.iz_route.size] = (-6490, -4253, 1729);
	level.iz_route[level.iz_route.size] = (-6136, -3702, 1729);
	level.iz_route[level.iz_route.size] = (-6117, -3123, 1760);
	level.iz_route[level.iz_route.size] = (-6154, -2413, 1825);
	level.iz_route[level.iz_route.size] = (-6434, -1862, 1910);
	level.iz_route[level.iz_route.size] = (-7060, -1536, 1992);
	level.iz_route[level.iz_route.size] = (-7574, -1340, 2038);
	level.iz_route[level.iz_route.size] = (-9173, -808, 2151);
	level.iz_route[level.iz_route.size] = (-9699, -266, 2163);
	level.iz_route[level.iz_route.size] = (-9731, 388, 2155);
	level.iz_route[level.iz_route.size] = (-9609, 724, 2149);
	level.iz_route[level.iz_route.size] = (-9366, 1153, 2139);
	level.iz_route[level.iz_route.size] = (-9086, 1695, 2129);
	level.iz_route[level.iz_route.size] = (-9030, 2265, 2115);
	level.iz_route[level.iz_route.size] = (-9254, 2778, 2096);
	level.iz_route[level.iz_route.size] = (-9581, 3320, 2064);
	level.iz_route[level.iz_route.size] = (-9731, 3600, 2047);
	level.iz_route[level.iz_route.size] = (-10179, 4347, 1734);
	level.iz_route[level.iz_route.size] = (-10842, 4860, 1732);
	level.iz_route[level.iz_route.size] = (-10898, 5607, 1729);
	level.iz_route[level.iz_route.size] = (-10907, 6438, 1729);
	level.iz_route[level.iz_route.size] = (-10888, 7382, 1729);
	level.iz_route[level.iz_route.size] = (-10898, 7951, 1729);
	level.iz_route[level.iz_route.size] = (-10870, 8689, 1729);
	level.iz_route[level.iz_route.size] = (-10743, 9455, 1729);
	level.iz_route[level.iz_route.size] = (-10145, 9770, 1729);
	level.iz_route[level.iz_route.size] = (-9548, 9571, 1729);
	level.iz_route[level.iz_route.size] = (-9033, 9139, 1729);
	level.iz_route[level.iz_route.size] = (-8385, 8458, 1729);
	level.iz_route[level.iz_route.size] = (-7804, 7861, 1729);
	level.iz_route[level.iz_route.size] = (-7190, 7130, 1729);
	level.iz_route[level.iz_route.size] = (-6666, 6550, 1736);
	level.iz_route[level.iz_route.size] = (-6193, 6001, 1758);
	level.iz_route[level.iz_route.size] = (-5646, 5370, 1795);
	level.iz_route[level.iz_route.size] = (-5055, 4722, 1830);
	level.iz_route[level.iz_route.size] = (-4495, 4166, 1849);
	level.iz_route[level.iz_route.size] = (-3977, 3532, 1856);
	level.iz_route[level.iz_route.size] = (-3528, 3020, 1849);
	level.iz_route[level.iz_route.size] = (-2808, 1703, 1822);
	level.iz_route[level.iz_route.size] = (-2517, 893, 1810);
	level.iz_route[level.iz_route.size] = (-2016, 352, 1799);
	level.iz_route[level.iz_route.size] = (-1252, 259, 1781);
	level.iz_route[level.iz_route.size] = (-634, 419, 1765);
	level.iz_route[level.iz_route.size] = (-114, 834, 1750);
	level.iz_route[level.iz_route.size] = (226, 1538, 1739);
	level.iz_route[level.iz_route.size] = (300, 2382, 1738);
	level.iz_route[level.iz_route.size] = (336, 3290, 1738);
	level.iz_route[level.iz_route.size] = (316, 4653, 1737);
	level.iz_route[level.iz_route.size] = (328, 5438, 1725);
	level.iz_route[level.iz_route.size] = (300, 6223, 1688);
	level.iz_route[level.iz_route.size] = (302, 7019, 1643);
	level.iz_route[level.iz_route.size] = (302, 7776, 1611);
	level.iz_route[level.iz_route.size] = (449, 8361, 1603);
	level.iz_route[level.iz_route.size] = (729, 8786, 1600);
	level.iz_route[level.iz_route.size] = (1008, 9046, 1599);
	level.iz_route[level.iz_route.size] = (1522, 9173, 1598);
	level.iz_route[level.iz_route.size] = (2093, 9080, 1601);
	level.iz_route[level.iz_route.size] = (2588, 8789, 1607);
	level.iz_route[level.iz_route.size] = (3076, 8529, 1610);
	level.iz_route[level.iz_route.size] = (3693, 8282, 1612);
	level.iz_route[level.iz_route.size] = (4364, 8214, 1608);
	level.iz_route[level.iz_route.size] = (5232, 8209, 1606);
	level.iz_route[level.iz_route.size] = (6040, 8203, 1606);
	level.iz_route[level.iz_route.size] = (6992, 8205, 1606);
	level.iz_route[level.iz_route.size] = (7694, 8132, 1609);
	level.iz_route[level.iz_route.size] = (8184, 7834, 1610);
	level.iz_route[level.iz_route.size] = (8503, 7332, 1609);
	level.iz_route[level.iz_route.size] = (8596, 6608, 1601);
	level.iz_route[level.iz_route.size] = (8591, 5761, 1606);
	level.iz_route[level.iz_route.size] = (8596, 5101, 1606);
	level.iz_route[level.iz_route.size] = (8597, 4403, 1606);
	level.iz_route[level.iz_route.size] = (8595, 3726, 1487);
	level.iz_route[level.iz_route.size] = (8595, 2975, 1417);
	level.iz_route[level.iz_route.size] = (8605, 2057, 1417);
	level.iz_route[level.iz_route.size] = (8661, 1532, 1417);
	level.iz_route[level.iz_route.size] = (8828, 865, 1417);
	level.iz_route[level.iz_route.size] = (8826, 177, 1417);
	level.iz_route[level.iz_route.size] = (8673, -291, 1417);
	level.iz_route[level.iz_route.size] = (8460, -745, 1417);
	level.iz_route[level.iz_route.size] = (8373, -1204, 1417);
	level.iz_route[level.iz_route.size] = (8413, -1868, 1417);
	level.iz_route[level.iz_route.size] = (8600, -2521, 1417);
}
