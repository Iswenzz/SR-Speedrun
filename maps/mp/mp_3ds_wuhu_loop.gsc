main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_3ds_wuhu_loop", 0);

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
	ambientPlay("iz_0_108", 2);
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
	level.iz_route[level.iz_route.size] = (10606, 18453, 321);
	level.iz_route[level.iz_route.size] = (6356, 18558, 321);
	level.iz_route[level.iz_route.size] = (1243, 18725, 366);
	level.iz_route[level.iz_route.size] = (-952, 18741, 524);
	level.iz_route[level.iz_route.size] = (-1683, 18570, 586);
	level.iz_route[level.iz_route.size] = (-2356, 18054, 684);
	level.iz_route[level.iz_route.size] = (-3168, 17180, 942);
	level.iz_route[level.iz_route.size] = (-4449, 15868, 1390);
	level.iz_route[level.iz_route.size] = (-4881, 15411, 1524);
	level.iz_route[level.iz_route.size] = (-5012, 14972, 1579);
	level.iz_route[level.iz_route.size] = (-5434, 14876, 1608);
	level.iz_route[level.iz_route.size] = (-5762, 14571, 1608);
	level.iz_route[level.iz_route.size] = (-6156, 14168, 1555);
	level.iz_route[level.iz_route.size] = (-6615, 13720, 1428);
	level.iz_route[level.iz_route.size] = (-7467, 12836, 1128);
	level.iz_route[level.iz_route.size] = (-8587, 11726, 743);
	level.iz_route[level.iz_route.size] = (-9202, 11099, 690);
	level.iz_route[level.iz_route.size] = (-9679, 10637, 661);
	level.iz_route[level.iz_route.size] = (-9895, 10492, 661);
	level.iz_route[level.iz_route.size] = (-10231, 10396, 668);
	level.iz_route[level.iz_route.size] = (-11195, 10482, 694);
	level.iz_route[level.iz_route.size] = (-12474, 10508, 701);
	level.iz_route[level.iz_route.size] = (-12920, 10339, 703);
	level.iz_route[level.iz_route.size] = (-13301, 10051, 712);
	level.iz_route[level.iz_route.size] = (-13603, 9499, 757);
	level.iz_route[level.iz_route.size] = (-13889, 8337, 873);
	level.iz_route[level.iz_route.size] = (-14311, 6601, 1105);
	level.iz_route[level.iz_route.size] = (-14601, 5863, 1210);
	level.iz_route[level.iz_route.size] = (-14943, 5505, 1236);
	level.iz_route[level.iz_route.size] = (-15373, 5225, 1249);
	level.iz_route[level.iz_route.size] = (-15835, 5115, 1235);
	level.iz_route[level.iz_route.size] = (-16375, 5140, 1172);
	level.iz_route[level.iz_route.size] = (-16959, 5318, 1095);
	level.iz_route[level.iz_route.size] = (-17759, 5532, 1013);
	level.iz_route[level.iz_route.size] = (-18308, 5651, 951);
	level.iz_route[level.iz_route.size] = (-19230, 5511, 897);
	level.iz_route[level.iz_route.size] = (-20193, 5281, 869);
	level.iz_route[level.iz_route.size] = (-21041, 4889, 857);
	level.iz_route[level.iz_route.size] = (-21605, 4344, 849);
	level.iz_route[level.iz_route.size] = (-21847, 3600, 860);
	level.iz_route[level.iz_route.size] = (-21866, 2743, 936);
	level.iz_route[level.iz_route.size] = (-21819, 1392, 1081);
	level.iz_route[level.iz_route.size] = (-21484, 840, 1148);
	level.iz_route[level.iz_route.size] = (-21471, -59, 1243);
	level.iz_route[level.iz_route.size] = (-21658, -943, 1335);
	level.iz_route[level.iz_route.size] = (-21760, -1507, 1392);
	level.iz_route[level.iz_route.size] = (-21787, -2716, 1516);
	level.iz_route[level.iz_route.size] = (-21880, -4215, 1625);
	level.iz_route[level.iz_route.size] = (-21892, -5439, 1702);
	level.iz_route[level.iz_route.size] = (-21839, -6564, 1775);
	level.iz_route[level.iz_route.size] = (-21714, -7462, 1834);
	level.iz_route[level.iz_route.size] = (-21504, -8317, 1892);
	level.iz_route[level.iz_route.size] = (-21197, -9121, 1950);
	level.iz_route[level.iz_route.size] = (-20674, -10138, 2026);
	level.iz_route[level.iz_route.size] = (-19961, -11110, 2105);
	level.iz_route[level.iz_route.size] = (-19145, -12002, 2184);
	level.iz_route[level.iz_route.size] = (-18413, -12724, 2249);
	level.iz_route[level.iz_route.size] = (-17405, -13621, 2343);
	level.iz_route[level.iz_route.size] = (-16521, -14469, 2466);
	level.iz_route[level.iz_route.size] = (-15876, -15151, 2559);
	level.iz_route[level.iz_route.size] = (-15397, -16044, 2666);
	level.iz_route[level.iz_route.size] = (-15296, -16867, 2678);
	level.iz_route[level.iz_route.size] = (-15628, -17622, 2556);
	level.iz_route[level.iz_route.size] = (-16463, -18344, 2320);
	level.iz_route[level.iz_route.size] = (-17114, -18985, 2218);
	level.iz_route[level.iz_route.size] = (-17519, -19709, 2167);
	level.iz_route[level.iz_route.size] = (-17559, -20604, 2122);
	level.iz_route[level.iz_route.size] = (-17185, -21347, 2087);
	level.iz_route[level.iz_route.size] = (-16575, -21753, 2073);
	level.iz_route[level.iz_route.size] = (-15626, -21867, 2093);
	level.iz_route[level.iz_route.size] = (-14683, -21747, 2189);
	level.iz_route[level.iz_route.size] = (-13922, -21635, 2350);
	level.iz_route[level.iz_route.size] = (-12815, -21619, 2589);
	level.iz_route[level.iz_route.size] = (-11527, -21823, 2847);
	level.iz_route[level.iz_route.size] = (-10583, -21808, 3001);
	level.iz_route[level.iz_route.size] = (-9503, -21511, 3140);
	level.iz_route[level.iz_route.size] = (-8833, -20938, 3207);
	level.iz_route[level.iz_route.size] = (-8329, -20225, 3282);
	level.iz_route[level.iz_route.size] = (-7830, -19743, 3356);
	level.iz_route[level.iz_route.size] = (-6933, -19632, 3394);
	level.iz_route[level.iz_route.size] = (-5589, -20022, 3277);
	level.iz_route[level.iz_route.size] = (-4219, -20512, 3023);
	level.iz_route[level.iz_route.size] = (-2921, -21223, 2774);
	level.iz_route[level.iz_route.size] = (-1967, -22064, 2579);
	level.iz_route[level.iz_route.size] = (-1288, -22663, 2458);
	level.iz_route[level.iz_route.size] = (-550, -23105, 2382);
	level.iz_route[level.iz_route.size] = (171, -23264, 2300);
	level.iz_route[level.iz_route.size] = (1045, -23103, 2187);
	level.iz_route[level.iz_route.size] = (1742, -22644, 2087);
	level.iz_route[level.iz_route.size] = (2691, -21917, 1953);
	level.iz_route[level.iz_route.size] = (3465, -21516, 1844);
	level.iz_route[level.iz_route.size] = (4165, -21215, 1740);
	level.iz_route[level.iz_route.size] = (5202, -20825, 1587);
	level.iz_route[level.iz_route.size] = (6053, -20247, 1460);
	level.iz_route[level.iz_route.size] = (6949, -19231, 1323);
	level.iz_route[level.iz_route.size] = (8012, -18060, 1182);
	level.iz_route[level.iz_route.size] = (8727, -17473, 1168);
	level.iz_route[level.iz_route.size] = (9690, -17118, 1171);
	level.iz_route[level.iz_route.size] = (10754, -17158, 1168);
	level.iz_route[level.iz_route.size] = (11412, -17472, 1145);
	level.iz_route[level.iz_route.size] = (11955, -18099, 1129);
	level.iz_route[level.iz_route.size] = (12257, -18624, 1129);
	level.iz_route[level.iz_route.size] = (12526, -19383, 1161);
	level.iz_route[level.iz_route.size] = (12781, -20342, 1256);
	level.iz_route[level.iz_route.size] = (13186, -21103, 1373);
	level.iz_route[level.iz_route.size] = (13666, -21416, 1424);
	level.iz_route[level.iz_route.size] = (14551, -21479, 1438);
	level.iz_route[level.iz_route.size] = (15789, -21530, 1435);
	level.iz_route[level.iz_route.size] = (16795, -21649, 1517);
	level.iz_route[level.iz_route.size] = (17756, -22101, 1661);
	level.iz_route[level.iz_route.size] = (18792, -22091, 1897);
	level.iz_route[level.iz_route.size] = (19781, -21474, 2140);
	level.iz_route[level.iz_route.size] = (20082, -20706, 2281);
	level.iz_route[level.iz_route.size] = (19866, -19813, 2461);
	level.iz_route[level.iz_route.size] = (19481, -19006, 2621);
	level.iz_route[level.iz_route.size] = (18677, -17850, 2796);
	level.iz_route[level.iz_route.size] = (17869, -16652, 2908);
	level.iz_route[level.iz_route.size] = (17034, -15412, 2946);
	level.iz_route[level.iz_route.size] = (16576, -14247, 2949);
	level.iz_route[level.iz_route.size] = (16438, -13316, 2954);
	level.iz_route[level.iz_route.size] = (16554, -12419, 2966);
	level.iz_route[level.iz_route.size] = (16870, -11726, 2968);
	level.iz_route[level.iz_route.size] = (17488, -11049, 2959);
	level.iz_route[level.iz_route.size] = (18225, -10421, 2948);
	level.iz_route[level.iz_route.size] = (18969, -9790, 2921);
	level.iz_route[level.iz_route.size] = (19680, -9094, 2896);
	level.iz_route[level.iz_route.size] = (20273, -8323, 2897);
	level.iz_route[level.iz_route.size] = (20810, -7453, 2885);
	level.iz_route[level.iz_route.size] = (21350, -6549, 2886);
	level.iz_route[level.iz_route.size] = (21674, -5968, 2906);
	level.iz_route[level.iz_route.size] = (22022, -5583, 2928);
	level.iz_route[level.iz_route.size] = (22582, -5319, 2963);
	level.iz_route[level.iz_route.size] = (23480, -5223, 3044);
	level.iz_route[level.iz_route.size] = (24403, -5118, 3129);
	level.iz_route[level.iz_route.size] = (24912, -4920, 3172);
	level.iz_route[level.iz_route.size] = (25218, -4679, 3204);
	level.iz_route[level.iz_route.size] = (25512, -4350, 3243);
	level.iz_route[level.iz_route.size] = (25720, -3916, 3283);
	level.iz_route[level.iz_route.size] = (25664, -3166, 3321);
	level.iz_route[level.iz_route.size] = (25396, -838, 3400);
	level.iz_route[level.iz_route.size] = (25145, 644, 3393);
	level.iz_route[level.iz_route.size] = (24885, 1897, 3315);
	level.iz_route[level.iz_route.size] = (24543, 3114, 3165);
	level.iz_route[level.iz_route.size] = (24139, 4552, 2940);
	level.iz_route[level.iz_route.size] = (23691, 5210, 2826);
	level.iz_route[level.iz_route.size] = (23469, 6045, 2693);
	level.iz_route[level.iz_route.size] = (23345, 6485, 2623);
	level.iz_route[level.iz_route.size] = (23453, 7139, 2531);
	level.iz_route[level.iz_route.size] = (23169, 8241, 2367);
	level.iz_route[level.iz_route.size] = (22803, 9159, 2244);
	level.iz_route[level.iz_route.size] = (22351, 9747, 2134);
	level.iz_route[level.iz_route.size] = (21794, 10164, 2016);
	level.iz_route[level.iz_route.size] = (21087, 10438, 1887);
	level.iz_route[level.iz_route.size] = (19860, 10586, 1750);
	level.iz_route[level.iz_route.size] = (18295, 10802, 1609);
	level.iz_route[level.iz_route.size] = (17464, 11166, 1451);
	level.iz_route[level.iz_route.size] = (16737, 11865, 1255);
	level.iz_route[level.iz_route.size] = (16366, 12613, 1075);
	level.iz_route[level.iz_route.size] = (16112, 13542, 928);
	level.iz_route[level.iz_route.size] = (16157, 15576, 617);
	level.iz_route[level.iz_route.size] = (16172, 17042, 430);
	level.iz_route[level.iz_route.size] = (15856, 17727, 407);
	level.iz_route[level.iz_route.size] = (15506, 18149, 380);
	level.iz_route[level.iz_route.size] = (14960, 18466, 333);
	level.iz_route[level.iz_route.size] = (14230, 18465, 321);
	level.iz_route[level.iz_route.size] = (12006, 18498, 321);
}
