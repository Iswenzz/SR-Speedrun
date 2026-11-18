main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_gp_mario_beach", 0);

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
	ambientPlay("iz_0_gpmb", 2);
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
	level.iz_route[level.iz_route.size] = (5565, 8909, 2093);
	level.iz_route[level.iz_route.size] = (5565, 8615, 2088);
	level.iz_route[level.iz_route.size] = (5557, 8321, 2084);
	level.iz_route[level.iz_route.size] = (5550, 8027, 2080);
	level.iz_route[level.iz_route.size] = (5543, 7733, 2078);
	level.iz_route[level.iz_route.size] = (5536, 7439, 2075);
	level.iz_route[level.iz_route.size] = (5529, 7145, 2072);
	level.iz_route[level.iz_route.size] = (5522, 6851, 2070);
	level.iz_route[level.iz_route.size] = (5516, 6557, 2067);
	level.iz_route[level.iz_route.size] = (5509, 6263, 2066);
	level.iz_route[level.iz_route.size] = (5503, 5969, 2067);
	level.iz_route[level.iz_route.size] = (5496, 5675, 2071);
	level.iz_route[level.iz_route.size] = (5490, 5381, 2079);
	level.iz_route[level.iz_route.size] = (5484, 4794, 2106);
	level.iz_route[level.iz_route.size] = (5484, 4207, 2143);
	level.iz_route[level.iz_route.size] = (5484, 3913, 2163);
	level.iz_route[level.iz_route.size] = (5484, 3620, 2184);
	level.iz_route[level.iz_route.size] = (5484, 3327, 2208);
	level.iz_route[level.iz_route.size] = (5485, 3034, 2232);
	level.iz_route[level.iz_route.size] = (5485, 2741, 2257);
	level.iz_route[level.iz_route.size] = (5485, 2448, 2284);
	level.iz_route[level.iz_route.size] = (5485, 2155, 2312);
	level.iz_route[level.iz_route.size] = (5485, 1863, 2342);
	level.iz_route[level.iz_route.size] = (5485, 1570, 2369);
	level.iz_route[level.iz_route.size] = (5485, 1277, 2397);
	level.iz_route[level.iz_route.size] = (5484, 985, 2427);
	level.iz_route[level.iz_route.size] = (5484, 693, 2458);
	level.iz_route[level.iz_route.size] = (5484, 401, 2490);
	level.iz_route[level.iz_route.size] = (5484, 108, 2522);
	level.iz_route[level.iz_route.size] = (5484, -262, 2557);
	level.iz_route[level.iz_route.size] = (5484, -555, 2587);
	level.iz_route[level.iz_route.size] = (5484, -847, 2616);
	level.iz_route[level.iz_route.size] = (5484, -1140, 2650);
	level.iz_route[level.iz_route.size] = (5484, -1433, 2677);
	level.iz_route[level.iz_route.size] = (5484, -1725, 2705);
	level.iz_route[level.iz_route.size] = (5484, -2018, 2735);
	level.iz_route[level.iz_route.size] = (5484, -2310, 2766);
	level.iz_route[level.iz_route.size] = (5484, -2603, 2798);
	level.iz_route[level.iz_route.size] = (5484, -2895, 2826);
	level.iz_route[level.iz_route.size] = (5484, -3188, 2855);
	level.iz_route[level.iz_route.size] = (5484, -3481, 2882);
	level.iz_route[level.iz_route.size] = (5484, -3773, 2905);
	level.iz_route[level.iz_route.size] = (5484, -4065, 2911);
	level.iz_route[level.iz_route.size] = (5484, -4354, 2886);
	level.iz_route[level.iz_route.size] = (5484, -4638, 2826);
	level.iz_route[level.iz_route.size] = (5484, -4915, 2735);
	level.iz_route[level.iz_route.size] = (5483, -5187, 2625);
	level.iz_route[level.iz_route.size] = (5483, -5456, 2505);
	level.iz_route[level.iz_route.size] = (5483, -5722, 2380);
	level.iz_route[level.iz_route.size] = (5482, -5986, 2252);
	level.iz_route[level.iz_route.size] = (5482, -6250, 2122);
	level.iz_route[level.iz_route.size] = (5482, -6513, 1990);
	level.iz_route[level.iz_route.size] = (5482, -6776, 1859);
	level.iz_route[level.iz_route.size] = (5482, -7040, 1730);
	level.iz_route[level.iz_route.size] = (5482, -7309, 1614);
	level.iz_route[level.iz_route.size] = (5483, -7586, 1522);
	level.iz_route[level.iz_route.size] = (5483, -7870, 1453);
	level.iz_route[level.iz_route.size] = (5483, -8159, 1404);
	level.iz_route[level.iz_route.size] = (5484, -8451, 1370);
	level.iz_route[level.iz_route.size] = (5484, -8743, 1345);
	level.iz_route[level.iz_route.size] = (5484, -9037, 1328);
	level.iz_route[level.iz_route.size] = (5484, -9331, 1319);
	level.iz_route[level.iz_route.size] = (5484, -9625, 1319);
	level.iz_route[level.iz_route.size] = (5483, -9918, 1324);
	level.iz_route[level.iz_route.size] = (5474, -10211, 1336);
	level.iz_route[level.iz_route.size] = (5448, -10503, 1351);
	level.iz_route[level.iz_route.size] = (5395, -10789, 1364);
	level.iz_route[level.iz_route.size] = (5307, -11065, 1371);
	level.iz_route[level.iz_route.size] = (5183, -11328, 1371);
	level.iz_route[level.iz_route.size] = (5024, -11570, 1365);
	level.iz_route[level.iz_route.size] = (4830, -11784, 1356);
	level.iz_route[level.iz_route.size] = (4604, -11962, 1346);
	level.iz_route[level.iz_route.size] = (4350, -12095, 1336);
	level.iz_route[level.iz_route.size] = (4076, -12178, 1328);
	level.iz_route[level.iz_route.size] = (3788, -12221, 1321);
	level.iz_route[level.iz_route.size] = (3495, -12235, 1315);
	level.iz_route[level.iz_route.size] = (3200, -12235, 1309);
	level.iz_route[level.iz_route.size] = (2907, -12233, 1302);
	level.iz_route[level.iz_route.size] = (2614, -12232, 1295);
	level.iz_route[level.iz_route.size] = (2321, -12232, 1287);
	level.iz_route[level.iz_route.size] = (2027, -12232, 1280);
	level.iz_route[level.iz_route.size] = (1733, -12232, 1275);
	level.iz_route[level.iz_route.size] = (1439, -12232, 1271);
	level.iz_route[level.iz_route.size] = (1145, -12233, 1267);
	level.iz_route[level.iz_route.size] = (851, -12233, 1264);
	level.iz_route[level.iz_route.size] = (557, -12234, 1262);
	level.iz_route[level.iz_route.size] = (263, -12234, 1260);
	level.iz_route[level.iz_route.size] = (-60, -12235, 1258);
	level.iz_route[level.iz_route.size] = (-650, -12258, 1283);
	level.iz_route[level.iz_route.size] = (-1744, -12246, 1302);
	level.iz_route[level.iz_route.size] = (-2332, -12251, 1294);
	level.iz_route[level.iz_route.size] = (-3661, -12275, 1234);
	level.iz_route[level.iz_route.size] = (-4101, -12197, 1225);
	level.iz_route[level.iz_route.size] = (-4594, -12092, 1218);
	level.iz_route[level.iz_route.size] = (-5244, -11917, 1118);
	level.iz_route[level.iz_route.size] = (-5519, -11802, 1128);
	level.iz_route[level.iz_route.size] = (-5781, -11657, 1141);
	level.iz_route[level.iz_route.size] = (-6018, -11473, 1153);
	level.iz_route[level.iz_route.size] = (-6235, -11266, 1162);
	level.iz_route[level.iz_route.size] = (-6419, -11029, 1167);
	level.iz_route[level.iz_route.size] = (-6579, -10774, 1169);
	level.iz_route[level.iz_route.size] = (-6699, -10500, 1168);
	level.iz_route[level.iz_route.size] = (-6791, -10217, 1163);
	level.iz_route[level.iz_route.size] = (-6860, -9930, 1153);
	level.iz_route[level.iz_route.size] = (-6911, -9641, 1140);
	level.iz_route[level.iz_route.size] = (-6968, -9056, 1113);
	level.iz_route[level.iz_route.size] = (-6986, -8469, 1090);
	level.iz_route[level.iz_route.size] = (-6983, -7935, 1071);
	level.iz_route[level.iz_route.size] = (-6973, -7416, 1056);
	level.iz_route[level.iz_route.size] = (-6961, -6882, 1042);
	level.iz_route[level.iz_route.size] = (-6940, -6351, 1045);
	level.iz_route[level.iz_route.size] = (-6915, -5764, 1042);
	level.iz_route[level.iz_route.size] = (-6889, -5177, 1037);
	level.iz_route[level.iz_route.size] = (-6870, -4589, 1032);
	level.iz_route[level.iz_route.size] = (-6850, -4001, 1028);
	level.iz_route[level.iz_route.size] = (-6832, -3414, 1022);
	level.iz_route[level.iz_route.size] = (-6812, -2826, 1020);
	level.iz_route[level.iz_route.size] = (-6781, -2239, 1025);
	level.iz_route[level.iz_route.size] = (-6756, -1946, 1034);
	level.iz_route[level.iz_route.size] = (-6720, -1653, 1047);
	level.iz_route[level.iz_route.size] = (-6668, -1359, 1065);
	level.iz_route[level.iz_route.size] = (-6597, -1069, 1086);
	level.iz_route[level.iz_route.size] = (-6505, -785, 1106);
	level.iz_route[level.iz_route.size] = (-6381, -518, 1125);
	level.iz_route[level.iz_route.size] = (-6219, -273, 1141);
	level.iz_route[level.iz_route.size] = (-6034, -50, 1156);
	level.iz_route[level.iz_route.size] = (-5649, 364, 1182);
	level.iz_route[level.iz_route.size] = (-5232, 779, 1207);
	level.iz_route[level.iz_route.size] = (-4792, 1189, 1234);
	level.iz_route[level.iz_route.size] = (-4362, 1576, 1256);
	level.iz_route[level.iz_route.size] = (-3931, 1957, 1280);
	level.iz_route[level.iz_route.size] = (-3491, 2343, 1304);
	level.iz_route[level.iz_route.size] = (-3103, 2682, 1324);
	level.iz_route[level.iz_route.size] = (-2605, 3116, 1350);
	level.iz_route[level.iz_route.size] = (-2163, 3502, 1378);
	level.iz_route[level.iz_route.size] = (-1710, 3876, 1406);
	level.iz_route[level.iz_route.size] = (-1285, 4282, 1434);
	level.iz_route[level.iz_route.size] = (-854, 4681, 1460);
	level.iz_route[level.iz_route.size] = (-643, 4885, 1475);
	level.iz_route[level.iz_route.size] = (-437, 5095, 1490);
	level.iz_route[level.iz_route.size] = (-239, 5311, 1504);
	level.iz_route[level.iz_route.size] = (-54, 5538, 1517);
	level.iz_route[level.iz_route.size] = (111, 5779, 1530);
	level.iz_route[level.iz_route.size] = (244, 6036, 1542);
	level.iz_route[level.iz_route.size] = (336, 6311, 1550);
	level.iz_route[level.iz_route.size] = (390, 6596, 1557);
	level.iz_route[level.iz_route.size] = (419, 7181, 1565);
	level.iz_route[level.iz_route.size] = (417, 7768, 1583);
	level.iz_route[level.iz_route.size] = (415, 8356, 1603);
	level.iz_route[level.iz_route.size] = (420, 8943, 1628);
	level.iz_route[level.iz_route.size] = (425, 9531, 1654);
	level.iz_route[level.iz_route.size] = (425, 10069, 1692);
	level.iz_route[level.iz_route.size] = (424, 10791, 1745);
	level.iz_route[level.iz_route.size] = (429, 11411, 1813);
	level.iz_route[level.iz_route.size] = (435, 12021, 1892);
	level.iz_route[level.iz_route.size] = (442, 12613, 1979);
	level.iz_route[level.iz_route.size] = (448, 13149, 2072);
	level.iz_route[level.iz_route.size] = (458, 13713, 2180);
	level.iz_route[level.iz_route.size] = (509, 14284, 2299);
	level.iz_route[level.iz_route.size] = (574, 14560, 2363);
	level.iz_route[level.iz_route.size] = (668, 14828, 2427);
	level.iz_route[level.iz_route.size] = (789, 15086, 2489);
	level.iz_route[level.iz_route.size] = (937, 15331, 2549);
	level.iz_route[level.iz_route.size] = (1109, 15559, 2608);
	level.iz_route[level.iz_route.size] = (1305, 15768, 2664);
	level.iz_route[level.iz_route.size] = (1523, 15956, 2715);
	level.iz_route[level.iz_route.size] = (1761, 16118, 2760);
	level.iz_route[level.iz_route.size] = (2017, 16252, 2796);
	level.iz_route[level.iz_route.size] = (2289, 16354, 2821);
	level.iz_route[level.iz_route.size] = (2571, 16422, 2837);
	level.iz_route[level.iz_route.size] = (2860, 16454, 2844);
	level.iz_route[level.iz_route.size] = (3151, 16452, 2843);
	level.iz_route[level.iz_route.size] = (3439, 16415, 2834);
	level.iz_route[level.iz_route.size] = (3722, 16346, 2819);
	level.iz_route[level.iz_route.size] = (3994, 16245, 2797);
	level.iz_route[level.iz_route.size] = (4252, 16114, 2766);
	level.iz_route[level.iz_route.size] = (4492, 15953, 2729);
	level.iz_route[level.iz_route.size] = (4710, 15765, 2689);
	level.iz_route[level.iz_route.size] = (4904, 15552, 2646);
	level.iz_route[level.iz_route.size] = (5070, 15319, 2598);
	level.iz_route[level.iz_route.size] = (5209, 15067, 2546);
	level.iz_route[level.iz_route.size] = (5317, 14802, 2494);
	level.iz_route[level.iz_route.size] = (5397, 14526, 2443);
	level.iz_route[level.iz_route.size] = (5475, 14242, 2392);
	level.iz_route[level.iz_route.size] = (5531, 13954, 2346);
	level.iz_route[level.iz_route.size] = (5550, 13664, 2306);
	level.iz_route[level.iz_route.size] = (5565, 13372, 2271);
	level.iz_route[level.iz_route.size] = (5565, 13079, 2242);
	level.iz_route[level.iz_route.size] = (5565, 12786, 2216);
	level.iz_route[level.iz_route.size] = (5565, 12485, 2193);
	level.iz_route[level.iz_route.size] = (5565, 12141, 2171);
	level.iz_route[level.iz_route.size] = (5565, 11730, 2149);
	level.iz_route[level.iz_route.size] = (5565, 11320, 2130);
	level.iz_route[level.iz_route.size] = (5565, 10673, 2114);
	level.iz_route[level.iz_route.size] = (5565, 10379, 2111);
	level.iz_route[level.iz_route.size] = (5565, 10085, 2108);
	level.iz_route[level.iz_route.size] = (5565, 9791, 2103);
	level.iz_route[level.iz_route.size] = (5565, 9497, 2099);
	level.iz_route[level.iz_route.size] = (5565, 9203, 2096);
}
