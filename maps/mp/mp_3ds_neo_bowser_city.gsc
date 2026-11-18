main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_3ds_neo_bowser_city", 0);

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
	ambientPlay("iz_0_114", 2);
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
	level.iz_route[level.iz_route.size] = (156, 1058, 1019);
	level.iz_route[level.iz_route.size] = (155, 283, 1019);
	level.iz_route[level.iz_route.size] = (154, -1210, 1019);
	level.iz_route[level.iz_route.size] = (243, -1855, 1019);
	level.iz_route[level.iz_route.size] = (816, -2231, 1019);
	level.iz_route[level.iz_route.size] = (1425, -2376, 1019);
	level.iz_route[level.iz_route.size] = (1824, -2881, 1036);
	level.iz_route[level.iz_route.size] = (1870, -3606, 1036);
	level.iz_route[level.iz_route.size] = (1651, -4207, 1019);
	level.iz_route[level.iz_route.size] = (1147, -4505, 1019);
	level.iz_route[level.iz_route.size] = (422, -4480, 1019);
	level.iz_route[level.iz_route.size] = (-288, -4457, 1019);
	level.iz_route[level.iz_route.size] = (-815, -4466, 1005);
	level.iz_route[level.iz_route.size] = (-1149, -4496, 922);
	level.iz_route[level.iz_route.size] = (-1552, -4510, 781);
	level.iz_route[level.iz_route.size] = (-1875, -4532, 695);
	level.iz_route[level.iz_route.size] = (-2602, -4579, 679);
	level.iz_route[level.iz_route.size] = (-3482, -4715, 679);
	level.iz_route[level.iz_route.size] = (-4051, -5142, 679);
	level.iz_route[level.iz_route.size] = (-4365, -5824, 679);
	level.iz_route[level.iz_route.size] = (-4058, -6507, 679);
	level.iz_route[level.iz_route.size] = (-3284, -7282, 615);
	level.iz_route[level.iz_route.size] = (-2495, -7887, 537);
	level.iz_route[level.iz_route.size] = (-2048, -8691, 467);
	level.iz_route[level.iz_route.size] = (-1013, -9792, 348);
	level.iz_route[level.iz_route.size] = (-473, -10127, 340);
	level.iz_route[level.iz_route.size] = (1105, -10128, 401);
	level.iz_route[level.iz_route.size] = (1646, -9916, 464);
	level.iz_route[level.iz_route.size] = (2024, -9352, 506);
	level.iz_route[level.iz_route.size] = (2046, -7845, 509);
	level.iz_route[level.iz_route.size] = (2045, -7345, 509);
	level.iz_route[level.iz_route.size] = (2170, -6647, 533);
	level.iz_route[level.iz_route.size] = (2559, -6213, 613);
	level.iz_route[level.iz_route.size] = (3253, -5690, 812);
	level.iz_route[level.iz_route.size] = (3613, -5236, 996);
	level.iz_route[level.iz_route.size] = (3729, -4785, 1145);
	level.iz_route[level.iz_route.size] = (3568, -4166, 1317);
	level.iz_route[level.iz_route.size] = (3125, -3738, 1456);
	level.iz_route[level.iz_route.size] = (2323, -3529, 1590);
	level.iz_route[level.iz_route.size] = (1149, -3512, 1687);
	level.iz_route[level.iz_route.size] = (530, -3448, 1691);
	level.iz_route[level.iz_route.size] = (-15, -3183, 1692);
	level.iz_route[level.iz_route.size] = (-780, -2600, 1688);
	level.iz_route[level.iz_route.size] = (-1167, -2410, 1691);
	level.iz_route[level.iz_route.size] = (-1642, -2408, 1693);
	level.iz_route[level.iz_route.size] = (-3025, -2445, 1699);
	level.iz_route[level.iz_route.size] = (-3582, -2195, 1745);
	level.iz_route[level.iz_route.size] = (-3966, -1667, 1747);
	level.iz_route[level.iz_route.size] = (-4034, -1098, 1748);
	level.iz_route[level.iz_route.size] = (-3833, -556, 1733);
	level.iz_route[level.iz_route.size] = (-3317, -152, 1697);
	level.iz_route[level.iz_route.size] = (-2402, 100, 1710);
	level.iz_route[level.iz_route.size] = (-1842, 419, 1749);
	level.iz_route[level.iz_route.size] = (-1610, 825, 1765);
	level.iz_route[level.iz_route.size] = (-1564, 1457, 1773);
	level.iz_route[level.iz_route.size] = (-1980, 2185, 1776);
	level.iz_route[level.iz_route.size] = (-2694, 2442, 1750);
	level.iz_route[level.iz_route.size] = (-3436, 2242, 1715);
	level.iz_route[level.iz_route.size] = (-4144, 1786, 1717);
	level.iz_route[level.iz_route.size] = (-4868, 1676, 1750);
	level.iz_route[level.iz_route.size] = (-5396, 2025, 1764);
	level.iz_route[level.iz_route.size] = (-5676, 2658, 1757);
	level.iz_route[level.iz_route.size] = (-5516, 3375, 1692);
	level.iz_route[level.iz_route.size] = (-5056, 3760, 1578);
	level.iz_route[level.iz_route.size] = (-3892, 4400, 1244);
	level.iz_route[level.iz_route.size] = (-2558, 4928, 1022);
	level.iz_route[level.iz_route.size] = (-540, 4916, 1019);
	level.iz_route[level.iz_route.size] = (875, 4906, 1015);
	level.iz_route[level.iz_route.size] = (1747, 4931, 989);
	level.iz_route[level.iz_route.size] = (2597, 5018, 985);
	level.iz_route[level.iz_route.size] = (3316, 5436, 985);
	level.iz_route[level.iz_route.size] = (3750, 6080, 984);
	level.iz_route[level.iz_route.size] = (3906, 6883, 985);
	level.iz_route[level.iz_route.size] = (3541, 7867, 984);
	level.iz_route[level.iz_route.size] = (2891, 8445, 985);
	level.iz_route[level.iz_route.size] = (2260, 8640, 985);
	level.iz_route[level.iz_route.size] = (1303, 8519, 985);
	level.iz_route[level.iz_route.size] = (508, 8005, 987);
	level.iz_route[level.iz_route.size] = (160, 6779, 987);
	level.iz_route[level.iz_route.size] = (172, 5437, 1356);
	level.iz_route[level.iz_route.size] = (175, 4421, 1273);
	level.iz_route[level.iz_route.size] = (174, 3580, 1081);
	level.iz_route[level.iz_route.size] = (173, 2511, 1019);
	level.iz_route[level.iz_route.size] = (172, 1758, 1019);
	level.iz_route[level.iz_route.size] = (172, 1539, 1019);
}
