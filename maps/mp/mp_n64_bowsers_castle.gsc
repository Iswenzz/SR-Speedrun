main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_n64_bowsers_castle", 0);

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
	ambientPlay("iz_0_r_64_kuppa32", 2);
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
	level.iz_route[level.iz_route.size] = (5258, 995, 2325);
	level.iz_route[level.iz_route.size] = (5251, -353, 2325);
	level.iz_route[level.iz_route.size] = (5245, -1450, 2325);
	level.iz_route[level.iz_route.size] = (5241, -2191, 2325);
	level.iz_route[level.iz_route.size] = (5195, -3546, 2325);
	level.iz_route[level.iz_route.size] = (5165, -4421, 2325);
	level.iz_route[level.iz_route.size] = (5048, -5207, 2325);
	level.iz_route[level.iz_route.size] = (4657, -5754, 2325);
	level.iz_route[level.iz_route.size] = (4137, -6131, 2325);
	level.iz_route[level.iz_route.size] = (3667, -6248, 2325);
	level.iz_route[level.iz_route.size] = (3084, -6270, 2325);
	level.iz_route[level.iz_route.size] = (2106, -6251, 2325);
	level.iz_route[level.iz_route.size] = (662, -6227, 2325);
	level.iz_route[level.iz_route.size] = (-1814, -6241, 2325);
	level.iz_route[level.iz_route.size] = (-2257, -6413, 2325);
	level.iz_route[level.iz_route.size] = (-2546, -6635, 2325);
	level.iz_route[level.iz_route.size] = (-2749, -7037, 2325);
	level.iz_route[level.iz_route.size] = (-2782, -7396, 2325);
	level.iz_route[level.iz_route.size] = (-2859, -9212, 2325);
	level.iz_route[level.iz_route.size] = (-2943, -10238, 2325);
	level.iz_route[level.iz_route.size] = (-2987, -10625, 2325);
	level.iz_route[level.iz_route.size] = (-3076, -10992, 2325);
	level.iz_route[level.iz_route.size] = (-3355, -11302, 2325);
	level.iz_route[level.iz_route.size] = (-3740, -11489, 2325);
	level.iz_route[level.iz_route.size] = (-4185, -11559, 2325);
	level.iz_route[level.iz_route.size] = (-6100, -11622, 2325);
	level.iz_route[level.iz_route.size] = (-8805, -11639, 2325);
	level.iz_route[level.iz_route.size] = (-9872, -11696, 2325);
	level.iz_route[level.iz_route.size] = (-10382, -11664, 2325);
	level.iz_route[level.iz_route.size] = (-10749, -11613, 2325);
	level.iz_route[level.iz_route.size] = (-11123, -11348, 2325);
	level.iz_route[level.iz_route.size] = (-11231, -11012, 2326);
	level.iz_route[level.iz_route.size] = (-11257, -9888, 2337);
	level.iz_route[level.iz_route.size] = (-11278, -8950, 2346);
	level.iz_route[level.iz_route.size] = (-11316, -7512, 2358);
	level.iz_route[level.iz_route.size] = (-11334, -6841, 2364);
	level.iz_route[level.iz_route.size] = (-11344, -6435, 2367);
	level.iz_route[level.iz_route.size] = (-11279, -6096, 2376);
	level.iz_route[level.iz_route.size] = (-11046, -5824, 2376);
	level.iz_route[level.iz_route.size] = (-10697, -5777, 2376);
	level.iz_route[level.iz_route.size] = (-9942, -5750, 2376);
	level.iz_route[level.iz_route.size] = (-9006, -5717, 2376);
	level.iz_route[level.iz_route.size] = (-8511, -5697, 2376);
	level.iz_route[level.iz_route.size] = (-7838, -5673, 2376);
	level.iz_route[level.iz_route.size] = (-7498, -5678, 2376);
	level.iz_route[level.iz_route.size] = (-7139, -5678, 2376);
	level.iz_route[level.iz_route.size] = (-6968, -5678, 2376);
	level.iz_route[level.iz_route.size] = (-6747, -5653, 2376);
	level.iz_route[level.iz_route.size] = (-6508, -5473, 2376);
	level.iz_route[level.iz_route.size] = (-6336, -5183, 2376);
	level.iz_route[level.iz_route.size] = (-6208, -4537, 2355);
	level.iz_route[level.iz_route.size] = (-6184, -4021, 2334);
	level.iz_route[level.iz_route.size] = (-6172, -3451, 2311);
	level.iz_route[level.iz_route.size] = (-6159, -2817, 2285);
	level.iz_route[level.iz_route.size] = (-6156, -2381, 2308);
	level.iz_route[level.iz_route.size] = (-6153, -2015, 2328);
	level.iz_route[level.iz_route.size] = (-6156, -1228, 2370);
	level.iz_route[level.iz_route.size] = (-5960, -915, 2370);
	level.iz_route[level.iz_route.size] = (-5461, -672, 2370);
	level.iz_route[level.iz_route.size] = (-4235, -567, 2053);
	level.iz_route[level.iz_route.size] = (-3334, -490, 1820);
	level.iz_route[level.iz_route.size] = (-2098, -419, 1820);
	level.iz_route[level.iz_route.size] = (-1392, -328, 1820);
	level.iz_route[level.iz_route.size] = (-1151, -223, 1820);
	level.iz_route[level.iz_route.size] = (-1039, -34, 1820);
	level.iz_route[level.iz_route.size] = (-998, 385, 1820);
	level.iz_route[level.iz_route.size] = (-979, 796, 1820);
	level.iz_route[level.iz_route.size] = (-1010, 1197, 1820);
	level.iz_route[level.iz_route.size] = (-1082, 1635, 1820);
	level.iz_route[level.iz_route.size] = (-1286, 1835, 1820);
	level.iz_route[level.iz_route.size] = (-1578, 1904, 1820);
	level.iz_route[level.iz_route.size] = (-2054, 1925, 1820);
	level.iz_route[level.iz_route.size] = (-3364, 1926, 1820);
	level.iz_route[level.iz_route.size] = (-4190, 1931, 1820);
	level.iz_route[level.iz_route.size] = (-4759, 1935, 1820);
	level.iz_route[level.iz_route.size] = (-5580, 1951, 1820);
	level.iz_route[level.iz_route.size] = (-6368, 1966, 1820);
	level.iz_route[level.iz_route.size] = (-7212, 2086, 1820);
	level.iz_route[level.iz_route.size] = (-7457, 2294, 1820);
	level.iz_route[level.iz_route.size] = (-7549, 3074, 1820);
	level.iz_route[level.iz_route.size] = (-7612, 3936, 1819);
	level.iz_route[level.iz_route.size] = (-7653, 4488, 1817);
	level.iz_route[level.iz_route.size] = (-7693, 4959, 1816);
	level.iz_route[level.iz_route.size] = (-7710, 5187, 1817);
	level.iz_route[level.iz_route.size] = (-7730, 5472, 1819);
	level.iz_route[level.iz_route.size] = (-7737, 5833, 1816);
	level.iz_route[level.iz_route.size] = (-7745, 6197, 1813);
	level.iz_route[level.iz_route.size] = (-7733, 6779, 1826);
	level.iz_route[level.iz_route.size] = (-7746, 7508, 1842);
	level.iz_route[level.iz_route.size] = (-7885, 9310, 2070);
	level.iz_route[level.iz_route.size] = (-8197, 9844, 2173);
	level.iz_route[level.iz_route.size] = (-8761, 10274, 2273);
	level.iz_route[level.iz_route.size] = (-9488, 10307, 2385);
	level.iz_route[level.iz_route.size] = (-10095, 9843, 2515);
	level.iz_route[level.iz_route.size] = (-10334, 9122, 2622);
	level.iz_route[level.iz_route.size] = (-10240, 8522, 2665);
	level.iz_route[level.iz_route.size] = (-9854, 8045, 2729);
	level.iz_route[level.iz_route.size] = (-9096, 7783, 2835);
	level.iz_route[level.iz_route.size] = (-6799, 7622, 2835);
	level.iz_route[level.iz_route.size] = (-3764, 7528, 2542);
	level.iz_route[level.iz_route.size] = (-1994, 7422, 2325);
	level.iz_route[level.iz_route.size] = (-203, 7186, 2442);
	level.iz_route[level.iz_route.size] = (1724, 7090, 2325);
	level.iz_route[level.iz_route.size] = (2766, 7205, 2325);
	level.iz_route[level.iz_route.size] = (3258, 7421, 2325);
	level.iz_route[level.iz_route.size] = (3515, 7607, 2325);
	level.iz_route[level.iz_route.size] = (3833, 7773, 2325);
	level.iz_route[level.iz_route.size] = (4209, 7885, 2325);
	level.iz_route[level.iz_route.size] = (4446, 7930, 2325);
	level.iz_route[level.iz_route.size] = (4769, 7852, 2325);
	level.iz_route[level.iz_route.size] = (5018, 7673, 2325);
	level.iz_route[level.iz_route.size] = (5164, 7467, 2325);
	level.iz_route[level.iz_route.size] = (5223, 7085, 2325);
	level.iz_route[level.iz_route.size] = (5208, 5678, 2325);
	level.iz_route[level.iz_route.size] = (5239, 4488, 2325);
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
	thread iz_obj_17();
	thread iz_obj_18();
	thread iz_obj_19();
	thread iz_obj_20();
	thread iz_obj_21();
	thread iz_obj_22();
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (442.9134, -6317.7954, 2328.1772);
	angles[0] = (0, -90, 0);
	at[0] = 0;
	points[1] = (442.9134, -6317.7954, 2530.5120);
	angles[1] = (0, -90, 0);
	at[1] = 1.1500;
	points[2] = (442.9134, -6317.7954, 2530.5120);
	angles[2] = (0, -90, 0);
	at[2] = 1.4500;
	points[3] = (442.9134, -6317.7954, 2538.1812);
	angles[3] = (0, -90, 0);
	at[3] = 1.5000;
	points[4] = (442.9134, -6317.7954, 2534.9409);
	angles[4] = (0, -90, 0);
	at[4] = 1.5500;
	points[5] = (442.9134, -6317.7954, 2522.8386);
	angles[5] = (0, -90, 0);
	at[5] = 1.6000;
	points[6] = (442.9134, -6317.7954, 2526.0828);
	angles[6] = (0, -90, 0);
	at[6] = 1.6500;
	points[7] = (442.9134, -6317.7954, 2538.1812);
	angles[7] = (0, -90, 0);
	at[7] = 1.7000;
	points[8] = (442.9134, -6317.7954, 2534.9409);
	angles[8] = (0, -90, 0);
	at[8] = 1.7500;
	points[9] = (442.9134, -6317.7954, 2522.8386);
	angles[9] = (0, -90, 0);
	at[9] = 1.8000;
	points[10] = (442.9134, -6317.7954, 2526.0828);
	angles[10] = (0, -90, 0);
	at[10] = 1.8500;
	points[11] = (442.9134, -6317.7954, 2538.1812);
	angles[11] = (0, -90, 0);
	at[11] = 1.9000;
	points[12] = (442.9134, -6317.7954, 2534.9409);
	angles[12] = (0, -90, 0);
	at[12] = 1.9500;
	points[13] = (442.9134, -6317.7954, 2540.8464);
	angles[13] = (0, -90, 0);
	at[13] = 2;
	points[14] = (442.9134, -6317.7954, 2673.7205);
	angles[14] = (0, -90, 0);
	at[14] = 2.1500;
	points[15] = (442.9134, -6317.7954, 2643.6023);
	angles[15] = (0, -90, 0);
	at[15] = 2.2000;
	points[16] = (442.9134, -6317.7954, 2568.3071);
	angles[16] = (0, -90, 0);
	at[16] = 2.2500;
	points[17] = (442.9134, -6317.7954, 2325.2244);
	angles[17] = (0, -90, 0);
	at[17] = 2.3500;
	points[18] = (442.9134, -6317.7954, 2325.2244);
	angles[18] = (0, -90, 0);
	at[18] = 3.3500;
	points[19] = (442.9134, -6317.7954, 2328.1772);
	angles[19] = (0, -90, 0);
	at[19] = 3.3667;
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
	points[0] = (-88.5827, -6791.3389, 2471.4568);
	angles[0] = (0, -90, 0);
	at[0] = 0;
	points[1] = (-8.8552, -6776.5747, 2471.4568);
	angles[1] = (0, -90, 0);
	at[1] = 0.0833;
	points[2] = (965.5552, -6776.5747, 2471.4568);
	angles[2] = (0, -90, 0);
	at[2] = 1.0833;
	points[3] = (981.7952, -6776.5747, 2471.4568);
	angles[3] = (0, -70, 0);
	at[3] = 1.1667;
	points[4] = (981.7952, -6776.5747, 2471.4568);
	angles[4] = (0, 30, 0);
	at[4] = 1.5000;
	points[5] = (981.7952, -6776.5747, 2471.4568);
	angles[5] = (0, 130, 0);
	at[5] = 1.8333;
	points[6] = (981.7952, -6776.5747, 2471.4568);
	angles[6] = (0, 255, 0);
	at[6] = 2.2500;
	points[7] = (981.7952, -6776.5747, 2486.2205);
	angles[7] = (0, 270, 0);
	at[7] = 2.3333;
	points[8] = (981.7952, -6776.5747, 2560.0396);
	angles[8] = (0, 270, 0);
	at[8] = 2.4167;
	points[9] = (981.7952, -6776.5747, 2614.0747);
	angles[9] = (0, 270, 0);
	at[9] = 2.5000;
	points[10] = (981.7952, -6776.5747, 2513.6812);
	angles[10] = (0, 270, 0);
	at[10] = 2.5833;
	points[11] = (981.7952, -6776.5747, 2325.2244);
	angles[11] = (0, 270, 0);
	at[11] = 2.6667;
	points[12] = (981.7952, -6776.5747, 2325.2244);
	angles[12] = (0, 270, 0);
	at[12] = 3.6667;
	points[13] = (981.7952, -6776.5747, 2471.4568);
	angles[13] = (0, 270, 0);
	at[13] = 4.5000;
	points[14] = (981.7952, -6776.5747, 2471.4568);
	angles[14] = (0, 345, 0);
	at[14] = 4.7500;
	points[15] = (974.4095, -6752.9526, 2471.4568);
	angles[15] = (0, 360, 0);
	at[15] = 4.8333;
	points[16] = (974.4095, -5859.7246, 2471.4568);
	angles[16] = (0, 360, 0);
	at[16] = 5.7500;
	points[17] = (974.4095, -5859.7246, 2471.4568);
	angles[17] = (0, 510, 0);
	at[17] = 6.2500;
	points[18] = (974.4095, -5859.7246, 2471.4568);
	angles[18] = (0, 610, 0);
	at[18] = 6.5833;
	points[19] = (974.4095, -5859.7246, 2471.4568);
	angles[19] = (0, 630, 0);
	at[19] = 6.6667;
	points[20] = (974.4095, -5859.7246, 2619.0945);
	angles[20] = (0, 630, 0);
	at[20] = 6.8333;
	points[21] = (974.4095, -5859.7246, 2543.7993);
	angles[21] = (0, 630, 0);
	at[21] = 6.9167;
	points[22] = (974.4095, -5859.7246, 2343.0120);
	angles[22] = (0, 630, 0);
	at[22] = 7;
	points[23] = (974.4095, -5859.7246, 2325.2244);
	angles[23] = (0, 630, 0);
	at[23] = 7.0833;
	points[24] = (974.4095, -5859.7246, 2325.2244);
	angles[24] = (0, 630, 0);
	at[24] = 8;
	points[25] = (974.4095, -5859.7246, 2337.0354);
	angles[25] = (0, 630, 0);
	at[25] = 8.0833;
	points[26] = (974.4095, -5859.7246, 2469.9094);
	angles[26] = (0, 630, 0);
	at[26] = 8.8333;
	points[27] = (974.4095, -5859.7246, 2471.4568);
	angles[27] = (0, 650, 0);
	at[27] = 8.9167;
	points[28] = (974.4095, -5859.7246, 2471.4568);
	angles[28] = (0, 800, 0);
	at[28] = 9.4167;
	points[29] = (931.5905, -5870.0791, 2471.4568);
	angles[29] = (0, 810, 0);
	at[29] = 9.5000;
	points[30] = (-42.8197, -5870.0791, 2471.4568);
	angles[30] = (0, 810, 0);
	at[30] = 10.5000;
	points[31] = (-91.5402, -5870.0791, 2471.4568);
	angles[31] = (0, 820, 0);
	at[31] = 10.5833;
	points[32] = (-91.5402, -5870.0791, 2471.4568);
	angles[32] = (0, 970, 0);
	at[32] = 11.0833;
	points[33] = (-91.5402, -5870.0791, 2471.4568);
	angles[33] = (0, 990, 0);
	at[33] = 11.1667;
	points[34] = (-91.5402, -5870.0791, 2619.0945);
	angles[34] = (0, 990, 0);
	at[34] = 11.3333;
	points[35] = (-91.5402, -5870.0791, 2543.7993);
	angles[35] = (0, 990, 0);
	at[35] = 11.4167;
	points[36] = (-91.5402, -5870.0791, 2343.0120);
	angles[36] = (0, 990, 0);
	at[36] = 11.5000;
	points[37] = (-91.5402, -5870.0791, 2325.2244);
	angles[37] = (0, 990, 0);
	at[37] = 11.5833;
	points[38] = (-91.5402, -5870.0791, 2325.2244);
	angles[38] = (0, 990, 0);
	at[38] = 12.5000;
	points[39] = (-91.5402, -5870.0791, 2337.0354);
	angles[39] = (0, 990, 0);
	at[39] = 12.5833;
	points[40] = (-91.5402, -5870.0791, 2469.9094);
	angles[40] = (0, 990, 0);
	at[40] = 13.3333;
	points[41] = (-91.5402, -5870.0791, 2471.4568);
	angles[41] = (0, 1010, 0);
	at[41] = 13.4167;
	points[42] = (-91.5402, -5870.0791, 2471.4568);
	angles[42] = (0, 1060, 0);
	at[42] = 13.5833;
	points[43] = (-91.5402, -5870.0791, 2471.4568);
	angles[43] = (0, 1160, 0);
	at[43] = 13.9167;
	points[44] = (-91.5402, -5870.0791, 2471.4568);
	angles[44] = (0, 1260, 0);
	at[44] = 14.2500;
	points[45] = (-88.5827, -5937.9922, 2471.4568);
	angles[45] = (0, 1260, 0);
	at[45] = 14.3333;
	points[46] = (-88.5827, -6750, 2471.4568);
	angles[46] = (0, 1260, 0);
	at[46] = 15.1667;
	points[47] = (-88.5827, -6791.3389, 2471.4568);
	angles[47] = (0, 1275, 0);
	at[47] = 15.2500;
	points[48] = (-88.5827, -6791.3389, 2471.4568);
	angles[48] = (0, 1350, 0);
	at[48] = 15.5000;
	points[49] = (-88.5827, -6791.3389, 2530.5120);
	angles[49] = (0, 1350, 0);
	at[49] = 15.5833;
	points[50] = (-88.5827, -6791.3389, 2604.3308);
	angles[50] = (0, 1350, 0);
	at[50] = 15.6667;
	points[51] = (-88.5827, -6791.3389, 2568.8977);
	angles[51] = (0, 1350, 0);
	at[51] = 15.7500;
	points[52] = (-88.5827, -6791.3389, 2393.2087);
	angles[52] = (0, 1350, 0);
	at[52] = 15.8333;
	points[53] = (-88.5827, -6791.3389, 2325.2244);
	angles[53] = (0, 1350, 0);
	at[53] = 15.9167;
	points[54] = (-88.5827, -6791.3389, 2325.2244);
	angles[54] = (0, 1350, 0);
	at[54] = 16.8333;
	points[55] = (-88.5827, -6791.3389, 2334.0828);
	angles[55] = (0, 1350, 0);
	at[55] = 16.9167;
	points[56] = (-88.5827, -6791.3389, 2466.9568);
	angles[56] = (0, 1350, 0);
	at[56] = 17.6667;
	points[57] = (-88.5827, -6791.3389, 2471.4568);
	angles[57] = (0, 1365, 0);
	at[57] = 17.7500;
	points[58] = (-88.5827, -6791.3389, 2471.4568);
	angles[58] = (0, 1515, 0);
	at[58] = 18.2500;
	points[59] = (-88.5827, -6791.3389, 2471.4568);
	angles[59] = (0, 1615, 0);
	at[59] = 18.5833;
	points[60] = (-88.5827, -6791.3389, 2471.4568);
	angles[60] = (0, 1710, 0);
	at[60] = 18.9000;
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
	points[0] = (-1860.2362, -6317.7954, 2538.1812);
	angles[0] = (0, -90, 0);
	at[0] = 0;
	points[1] = (-1860.2362, -6317.7954, 2534.9409);
	angles[1] = (0, -90, 0);
	at[1] = 0.0500;
	points[2] = (-1860.2362, -6317.7954, 2522.8386);
	angles[2] = (0, -90, 0);
	at[2] = 0.1000;
	points[3] = (-1860.2362, -6317.7954, 2526.0828);
	angles[3] = (0, -90, 0);
	at[3] = 0.1500;
	points[4] = (-1860.2362, -6317.7954, 2538.1812);
	angles[4] = (0, -90, 0);
	at[4] = 0.2000;
	points[5] = (-1860.2362, -6317.7954, 2534.9409);
	angles[5] = (0, -90, 0);
	at[5] = 0.2500;
	points[6] = (-1860.2362, -6317.7954, 2522.8386);
	angles[6] = (0, -90, 0);
	at[6] = 0.3000;
	points[7] = (-1860.2362, -6317.7954, 2526.0828);
	angles[7] = (0, -90, 0);
	at[7] = 0.3500;
	points[8] = (-1860.2362, -6317.7954, 2538.1812);
	angles[8] = (0, -90, 0);
	at[8] = 0.4000;
	points[9] = (-1860.2362, -6317.7954, 2534.9409);
	angles[9] = (0, -90, 0);
	at[9] = 0.4500;
	points[10] = (-1860.2362, -6317.7954, 2540.8464);
	angles[10] = (0, -90, 0);
	at[10] = 0.5000;
	points[11] = (-1860.2362, -6317.7954, 2673.7205);
	angles[11] = (0, -90, 0);
	at[11] = 0.6500;
	points[12] = (-1860.2362, -6317.7954, 2643.6023);
	angles[12] = (0, -90, 0);
	at[12] = 0.7000;
	points[13] = (-1860.2362, -6317.7954, 2568.3071);
	angles[13] = (0, -90, 0);
	at[13] = 0.7500;
	points[14] = (-1860.2362, -6317.7954, 2325.2244);
	angles[14] = (0, -90, 0);
	at[14] = 0.8500;
	points[15] = (-1860.2362, -6317.7954, 2325.2244);
	angles[15] = (0, -90, 0);
	at[15] = 1.8500;
	points[16] = (-1860.2362, -6317.7954, 2528.9646);
	angles[16] = (0, -90, 0);
	at[16] = 3;
	points[17] = (-1860.2362, -6317.7954, 2530.5120);
	angles[17] = (0, -90, 0);
	at[17] = 3.3000;
	points[18] = (-1860.2362, -6317.7954, 2538.1812);
	angles[18] = (0, -90, 0);
	at[18] = 3.3667;
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
	points[0] = (-1328.7402, -5849.4092, 2471.4568);
	angles[0] = (0, -90, 0);
	at[0] = 0;
	points[1] = (-1328.7402, -5849.4092, 2471.4568);
	angles[1] = (0, 85, 0);
	at[1] = 0.5833;
	points[2] = (-1389.2716, -5861.2207, 2471.4568);
	angles[2] = (0, 90, 0);
	at[2] = 0.6667;
	points[3] = (-2363.6851, -5861.2207, 2471.4568);
	angles[3] = (0, 90, 0);
	at[3] = 1.6667;
	points[4] = (-2396.1653, -5861.2207, 2471.4568);
	angles[4] = (0, 105, 0);
	at[4] = 1.7500;
	points[5] = (-2396.1653, -5861.2207, 2471.4568);
	angles[5] = (0, 255, 0);
	at[5] = 2.2500;
	points[6] = (-2396.1653, -5861.2207, 2486.2205);
	angles[6] = (0, 270, 0);
	at[6] = 2.3333;
	points[7] = (-2396.1653, -5861.2207, 2560.0396);
	angles[7] = (0, 270, 0);
	at[7] = 2.4167;
	points[8] = (-2396.1653, -5861.2207, 2614.0747);
	angles[8] = (0, 270, 0);
	at[8] = 2.5000;
	points[9] = (-2396.1653, -5861.2207, 2513.6812);
	angles[9] = (0, 270, 0);
	at[9] = 2.5833;
	points[10] = (-2396.1653, -5861.2207, 2325.2244);
	angles[10] = (0, 270, 0);
	at[10] = 2.6667;
	points[11] = (-2396.1653, -5861.2207, 2325.2244);
	angles[11] = (0, 270, 0);
	at[11] = 3.6667;
	points[12] = (-2396.1653, -5861.2207, 2471.4568);
	angles[12] = (0, 270, 0);
	at[12] = 4.5000;
	points[13] = (-2396.1653, -5861.2207, 2471.4568);
	angles[13] = (0, 345, 0);
	at[13] = 4.7500;
	points[14] = (-2396.1653, -5861.2207, 2471.4568);
	angles[14] = (0, 445, 0);
	at[14] = 5.0833;
	points[15] = (-2396.1653, -5861.2207, 2471.4568);
	angles[15] = (0, 520, 0);
	at[15] = 5.3333;
	points[16] = (-2396.1653, -5861.2207, 2471.4568);
	angles[16] = (0, 540, 0);
	at[16] = 5.4167;
	points[17] = (-2391.7324, -5946.8506, 2471.4568);
	angles[17] = (0, 540, 0);
	at[17] = 5.5000;
	points[18] = (-2391.7324, -6758.8584, 2471.4568);
	angles[18] = (0, 540, 0);
	at[18] = 6.3333;
	points[19] = (-2391.7324, -6791.3389, 2471.4568);
	angles[19] = (0, 555, 0);
	at[19] = 6.4167;
	points[20] = (-2391.7324, -6791.3389, 2471.4568);
	angles[20] = (0, 630, 0);
	at[20] = 6.6667;
	points[21] = (-2391.7324, -6791.3389, 2530.5120);
	angles[21] = (0, 630, 0);
	at[21] = 6.7500;
	points[22] = (-2391.7324, -6791.3389, 2604.3308);
	angles[22] = (0, 630, 0);
	at[22] = 6.8333;
	points[23] = (-2391.7324, -6791.3389, 2568.8977);
	angles[23] = (0, 630, 0);
	at[23] = 6.9167;
	points[24] = (-2391.7324, -6791.3389, 2393.2087);
	angles[24] = (0, 630, 0);
	at[24] = 7;
	points[25] = (-2391.7324, -6791.3389, 2325.2244);
	angles[25] = (0, 630, 0);
	at[25] = 7.0833;
	points[26] = (-2391.7324, -6791.3389, 2325.2244);
	angles[26] = (0, 630, 0);
	at[26] = 8;
	points[27] = (-2391.7324, -6791.3389, 2334.0828);
	angles[27] = (0, 630, 0);
	at[27] = 8.0833;
	points[28] = (-2391.7324, -6791.3389, 2466.9568);
	angles[28] = (0, 630, 0);
	at[28] = 8.8333;
	points[29] = (-2391.7324, -6791.3389, 2471.4568);
	angles[29] = (0, 645, 0);
	at[29] = 8.9167;
	points[30] = (-2391.7324, -6791.3389, 2471.4568);
	angles[30] = (0, 670, 0);
	at[30] = 9;
	points[31] = (-2391.7324, -6791.3389, 2471.4568);
	angles[31] = (0, 820, 0);
	at[31] = 9.5000;
	points[32] = (-2391.7324, -6791.3389, 2471.4568);
	angles[32] = (0, 970, 0);
	at[32] = 10;
	points[33] = (-2391.7324, -6791.3389, 2471.4568);
	angles[33] = (0, 990, 0);
	at[33] = 10.0833;
	points[34] = (-2295.7639, -6776.5747, 2471.4568);
	angles[34] = (0, 990, 0);
	at[34] = 10.1667;
	points[35] = (-1321.3544, -6776.5747, 2471.4568);
	angles[35] = (0, 990, 0);
	at[35] = 11.1667;
	points[36] = (-1321.3544, -6776.5747, 2471.4568);
	angles[36] = (0, 1090, 0);
	at[36] = 11.5000;
	points[37] = (-1321.3544, -6776.5747, 2471.4568);
	angles[37] = (0, 1190, 0);
	at[37] = 11.8333;
	points[38] = (-1321.3544, -6776.5747, 2471.4568);
	angles[38] = (0, 1340, 0);
	at[38] = 12.3333;
	points[39] = (-1321.3544, -6776.5747, 2500.9844);
	angles[39] = (0, 1350, 0);
	at[39] = 12.4167;
	points[40] = (-1321.3544, -6776.5747, 2574.8032);
	angles[40] = (0, 1350, 0);
	at[40] = 12.5000;
	points[41] = (-1321.3544, -6776.5747, 2604.0356);
	angles[41] = (0, 1350, 0);
	at[41] = 12.5833;
	points[42] = (-1321.3544, -6776.5747, 2478.5435);
	angles[42] = (0, 1350, 0);
	at[42] = 12.6667;
	points[43] = (-1321.3544, -6776.5747, 2325.2244);
	angles[43] = (0, 1350, 0);
	at[43] = 12.7500;
	points[44] = (-1321.3544, -6776.5747, 2325.2244);
	angles[44] = (0, 1350, 0);
	at[44] = 13.6667;
	points[45] = (-1321.3544, -6776.5747, 2328.1772);
	angles[45] = (0, 1350, 0);
	at[45] = 13.7500;
	points[46] = (-1321.3544, -6776.5747, 2461.0513);
	angles[46] = (0, 1350, 0);
	at[46] = 14.5000;
	points[47] = (-1321.3544, -6776.5747, 2471.4568);
	angles[47] = (0, 1355, 0);
	at[47] = 14.5833;
	points[48] = (-1321.3544, -6776.5747, 2471.4568);
	angles[48] = (0, 1430, 0);
	at[48] = 14.8333;
	points[49] = (-1328.7402, -6736.6929, 2471.4568);
	angles[49] = (0, 1440, 0);
	at[49] = 14.9167;
	points[50] = (-1328.7402, -5924.6851, 2471.4568);
	angles[50] = (0, 1440, 0);
	at[50] = 15.7500;
	points[51] = (-1328.7402, -5849.4092, 2471.4568);
	angles[51] = (0, 1445, 0);
	at[51] = 15.8333;
	points[52] = (-1328.7402, -5849.4092, 2471.4568);
	angles[52] = (0, 1620, 0);
	at[52] = 16.4167;
	points[53] = (-1328.7402, -5849.4092, 2471.4568);
	angles[53] = (0, 1695, 0);
	at[53] = 16.6667;
	points[54] = (-1328.7402, -5849.4092, 2486.2205);
	angles[54] = (0, 1710, 0);
	at[54] = 16.7500;
	points[55] = (-1328.7402, -5849.4092, 2560.0396);
	angles[55] = (0, 1710, 0);
	at[55] = 16.8333;
	points[56] = (-1328.7402, -5849.4092, 2614.0747);
	angles[56] = (0, 1710, 0);
	at[56] = 16.9167;
	points[57] = (-1328.7402, -5849.4092, 2513.6812);
	angles[57] = (0, 1710, 0);
	at[57] = 17;
	points[58] = (-1328.7402, -5849.4092, 2325.2244);
	angles[58] = (0, 1710, 0);
	at[58] = 17.0833;
	points[59] = (-1328.7402, -5849.4092, 2325.2244);
	angles[59] = (0, 1710, 0);
	at[59] = 18.0833;
	points[60] = (-1328.7402, -5849.4092, 2471.4568);
	angles[60] = (0, 1710, 0);
	at[60] = 18.9167;
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
	points[0] = (-7396.6538, -6326.2598, 2376.2480);
	angles[0] = (0, 90, 0);
	at[0] = 0;
	points[1] = (-7396.6538, -5086.1021, 2376.2480);
	angles[1] = (0, 90, 0);
	at[1] = 2.8000;
	points[2] = (-7396.6538, -5093.5039, 2376.2480);
	angles[2] = (0, 90, 0);
	at[2] = 2.8500;
	points[3] = (-7396.6538, -6333.6616, 2376.2480);
	angles[3] = (0, 90, 0);
	at[3] = 5.6500;
	points[4] = (-7396.6538, -6326.2598, 2376.2480);
	angles[4] = (0, 90, 0);
	at[4] = 5.6667;
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
	points[0] = (-8917.9131, -5086.1021, 2376.2480);
	angles[0] = (0, 90, 0);
	at[0] = 0;
	points[1] = (-8917.9131, -6326.2993, 2376.2480);
	angles[1] = (0, 90, 0);
	at[1] = 2.8000;
	points[2] = (-8917.9131, -6318.8979, 2376.2480);
	angles[2] = (0, 90, 0);
	at[2] = 2.8500;
	points[3] = (-8917.9131, -5078.7402, 2376.2480);
	angles[3] = (0, 90, 0);
	at[3] = 5.6500;
	points[4] = (-8917.9131, -5086.1021, 2376.2480);
	angles[4] = (0, 90, 0);
	at[4] = 5.6667;
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
	points[0] = (-7804.1343, -11527.7158, 2378.3740);
	angles[0] = (0, 85, 0);
	at[0] = 0;
	points[1] = (-7804.1343, -11527.7158, 2449.2402);
	angles[1] = (0, 85, 0);
	at[1] = 0.4000;
	points[2] = (-7804.1343, -11527.7158, 2455.1458);
	angles[2] = (0, 85, 0);
	at[2] = 0.4667;
	points[3] = (-7804.1343, -11527.7158, 2455.1458);
	angles[3] = (0, 85, 0);
	at[3] = 4.7333;
	points[4] = (-7804.1343, -11593.9365, 2455.1458);
	angles[4] = (0, 245, 0);
	at[4] = 5.2667;
	points[5] = (-7804.1343, -11602.4805, 2455.1458);
	angles[5] = (0, 90, 0);
	at[5] = 5.3333;
	points[6] = (-7804.1343, -11606.7725, 2455.1458);
	angles[6] = (0, 90, 0);
	at[6] = 5.4000;
	points[7] = (-7804.1343, -11606.7725, 2455.1458);
	angles[7] = (0, 90, 0);
	at[7] = 6.6000;
	points[8] = (-2471.4568, -11604.6455, 2456.6931);
	angles[8] = (0, 90, 0);
	at[8] = 6.6000;
	points[9] = (-5282.4805, -11604.6455, 2456.6931);
	angles[9] = (0, 90, 0);
	at[9] = 8.8667;
	points[10] = (-5365.1572, -11604.6064, 2456.6931);
	angles[10] = (0, 105, 0);
	at[10] = 8.9333;
	points[11] = (-6026.5747, -11604.6455, 2456.6931);
	angles[11] = (0, 265, 0);
	at[11] = 9.4667;
	points[12] = (-6109.2520, -11558.3467, 2456.6931);
	angles[12] = (0, 85, 0);
	at[12] = 9.5333;
	points[13] = (-6274.6064, -11438.7012, 2456.6931);
	angles[13] = (0, 85, 0);
	at[13] = 9.6667;
	points[14] = (-6357.2837, -11383.1885, 2456.6931);
	angles[14] = (0, 85, 0);
	at[14] = 9.7333;
	points[15] = (-6439.9604, -11331.9287, 2456.6931);
	angles[15] = (0, 85, 0);
	at[15] = 9.8000;
	points[16] = (-6522.6382, -11286.0244, 2456.6931);
	angles[16] = (0, 85, 0);
	at[16] = 9.8667;
	points[17] = (-6605.3149, -11246.2998, 2456.6931);
	angles[17] = (0, 85, 0);
	at[17] = 9.9333;
	points[18] = (-6687.9922, -11213.5439, 2456.6931);
	angles[18] = (0, 85, 0);
	at[18] = 10;
	points[19] = (-6770.6694, -11188.4258, 2456.6931);
	angles[19] = (0, 85, 0);
	at[19] = 10.0667;
	points[20] = (-6853.3462, -11171.3779, 2456.6931);
	angles[20] = (0, 85, 0);
	at[20] = 10.1333;
	points[21] = (-6936.0239, -11162.7959, 2456.6931);
	angles[21] = (0, 85, 0);
	at[21] = 10.2000;
	points[22] = (-7018.7007, -11162.7959, 2456.6931);
	angles[22] = (0, 85, 0);
	at[22] = 10.2667;
	points[23] = (-7101.3779, -11171.3779, 2456.6931);
	angles[23] = (0, 85, 0);
	at[23] = 10.3333;
	points[24] = (-7184.0557, -11188.4258, 2456.6931);
	angles[24] = (0, 85, 0);
	at[24] = 10.4000;
	points[25] = (-7266.7324, -11213.5439, 2456.6931);
	angles[25] = (0, 85, 0);
	at[25] = 10.4667;
	points[26] = (-7349.4097, -11246.2998, 2456.6931);
	angles[26] = (0, 85, 0);
	at[26] = 10.5333;
	points[27] = (-7432.0864, -11286.0244, 2456.6931);
	angles[27] = (0, 85, 0);
	at[27] = 10.6000;
	points[28] = (-7514.7637, -11331.9287, 2456.6931);
	angles[28] = (0, 85, 0);
	at[28] = 10.6667;
	points[29] = (-7597.4414, -11383.1885, 2456.6931);
	angles[29] = (0, 85, 0);
	at[29] = 10.7333;
	points[30] = (-7762.7954, -11497.4805, 2456.6931);
	angles[30] = (0, 85, 0);
	at[30] = 10.8667;
	points[31] = (-7804.1343, -11527.7158, 2471.4568);
	angles[31] = (0, 85, 0);
	at[31] = 10.9333;
	points[32] = (-7804.1343, -11527.7158, 2589.5671);
	angles[32] = (0, 85, 0);
	at[32] = 11.0667;
	points[33] = (-7804.1343, -11527.7158, 2574.2126);
	angles[33] = (0, 85, 0);
	at[33] = 11.1333;
	points[34] = (-7804.1343, -11527.7158, 2463.7795);
	angles[34] = (0, 85, 0);
	at[34] = 11.2000;
	points[35] = (-7804.1343, -11527.7158, 2325.2244);
	angles[35] = (0, 85, 0);
	at[35] = 11.2667;
	points[36] = (-7804.1343, -11527.7158, 2325.2244);
	angles[36] = (0, 85, 0);
	at[36] = 12.2667;
	points[37] = (-7804.1343, -11527.7158, 2378.3740);
	angles[37] = (0, 85, 0);
	at[37] = 12.5667;
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
	points[0] = (-7804.1343, -11822.9922, 2378.3740);
	angles[0] = (0, 85, 0);
	at[0] = 0;
	points[1] = (-7804.1343, -11822.9922, 2449.2402);
	angles[1] = (0, 85, 0);
	at[1] = 0.4000;
	points[2] = (-7804.1343, -11822.9922, 2455.1458);
	angles[2] = (0, 85, 0);
	at[2] = 0.4667;
	points[3] = (-7804.1343, -11822.9922, 2455.1458);
	angles[3] = (0, 85, 0);
	at[3] = 4.7333;
	points[4] = (-7804.1343, -11889.2129, 2455.1458);
	angles[4] = (0, 245, 0);
	at[4] = 5.2667;
	points[5] = (-7804.1343, -11897.7559, 2455.1458);
	angles[5] = (0, 90, 0);
	at[5] = 5.3333;
	points[6] = (-7804.1343, -11902.0479, 2455.1458);
	angles[6] = (0, 90, 0);
	at[6] = 5.4000;
	points[7] = (-7804.1343, -11902.0479, 2455.1458);
	angles[7] = (0, 90, 0);
	at[7] = 6.6000;
	points[8] = (-2471.4568, -11899.9209, 2456.6931);
	angles[8] = (0, 90, 0);
	at[8] = 6.6000;
	points[9] = (-5282.4805, -11899.9209, 2456.6931);
	angles[9] = (0, 90, 0);
	at[9] = 8.8667;
	points[10] = (-5365.1572, -11899.8818, 2456.6931);
	angles[10] = (0, 105, 0);
	at[10] = 8.9333;
	points[11] = (-6026.5747, -11899.9209, 2456.6931);
	angles[11] = (0, 265, 0);
	at[11] = 9.4667;
	points[12] = (-6109.2520, -11853.6221, 2456.6931);
	angles[12] = (0, 85, 0);
	at[12] = 9.5333;
	points[13] = (-6274.6064, -11733.9766, 2456.6931);
	angles[13] = (0, 85, 0);
	at[13] = 9.6667;
	points[14] = (-6357.2837, -11678.4648, 2456.6931);
	angles[14] = (0, 85, 0);
	at[14] = 9.7333;
	points[15] = (-6439.9604, -11627.2051, 2456.6931);
	angles[15] = (0, 85, 0);
	at[15] = 9.8000;
	points[16] = (-6522.6382, -11581.2998, 2456.6931);
	angles[16] = (0, 85, 0);
	at[16] = 9.8667;
	points[17] = (-6605.3149, -11541.5752, 2456.6931);
	angles[17] = (0, 85, 0);
	at[17] = 9.9333;
	points[18] = (-6687.9922, -11508.8193, 2456.6931);
	angles[18] = (0, 85, 0);
	at[18] = 10;
	points[19] = (-6770.6694, -11483.7012, 2456.6931);
	angles[19] = (0, 85, 0);
	at[19] = 10.0667;
	points[20] = (-6853.3462, -11466.6533, 2456.6931);
	angles[20] = (0, 85, 0);
	at[20] = 10.1333;
	points[21] = (-6936.0239, -11458.0713, 2456.6931);
	angles[21] = (0, 85, 0);
	at[21] = 10.2000;
	points[22] = (-7018.7007, -11458.0713, 2456.6931);
	angles[22] = (0, 85, 0);
	at[22] = 10.2667;
	points[23] = (-7101.3779, -11466.6533, 2456.6931);
	angles[23] = (0, 85, 0);
	at[23] = 10.3333;
	points[24] = (-7184.0557, -11483.7012, 2456.6931);
	angles[24] = (0, 85, 0);
	at[24] = 10.4000;
	points[25] = (-7266.7324, -11508.8193, 2456.6931);
	angles[25] = (0, 85, 0);
	at[25] = 10.4667;
	points[26] = (-7349.4097, -11541.5752, 2456.6931);
	angles[26] = (0, 85, 0);
	at[26] = 10.5333;
	points[27] = (-7432.0864, -11581.2998, 2456.6931);
	angles[27] = (0, 85, 0);
	at[27] = 10.6000;
	points[28] = (-7514.7637, -11627.2051, 2456.6931);
	angles[28] = (0, 85, 0);
	at[28] = 10.6667;
	points[29] = (-7597.4414, -11678.4648, 2456.6931);
	angles[29] = (0, 85, 0);
	at[29] = 10.7333;
	points[30] = (-7762.7954, -11792.7568, 2456.6931);
	angles[30] = (0, 85, 0);
	at[30] = 10.8667;
	points[31] = (-7804.1343, -11822.9922, 2471.4568);
	angles[31] = (0, 85, 0);
	at[31] = 10.9333;
	points[32] = (-7804.1343, -11822.9922, 2589.5671);
	angles[32] = (0, 85, 0);
	at[32] = 11.0667;
	points[33] = (-7804.1343, -11822.9922, 2574.2126);
	angles[33] = (0, 85, 0);
	at[33] = 11.1333;
	points[34] = (-7804.1343, -11822.9922, 2463.7795);
	angles[34] = (0, 85, 0);
	at[34] = 11.2000;
	points[35] = (-7804.1343, -11822.9922, 2325.2244);
	angles[35] = (0, 85, 0);
	at[35] = 11.2667;
	points[36] = (-7804.1343, -11822.9922, 2325.2244);
	angles[36] = (0, 85, 0);
	at[36] = 12.2667;
	points[37] = (-7804.1343, -11822.9922, 2378.3740);
	angles[37] = (0, 85, 0);
	at[37] = 12.5667;
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
	points[0] = (-7244.6460, 4553.3467, 1139.5906);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-7244.6460, 4553.3467, 1139.5906);
	angles[1] = (0, 0, 0);
	at[1] = 0.8500;
	points[2] = (-7244.6460, 4553.3467, 1182.8661);
	angles[2] = (0, 0, 0);
	at[2] = 0.9000;
	points[3] = (-7244.6460, 4553.3467, 1236.2520);
	angles[3] = (0, 0, 0);
	at[3] = 0.9500;
	points[4] = (-7244.6460, 4553.3467, 1334.5198);
	angles[4] = (0, 0, 0);
	at[4] = 1.0500;
	points[5] = (-7244.6460, 4553.3467, 1421.4489);
	angles[5] = (0, 0, 0);
	at[5] = 1.1500;
	points[6] = (-7244.6460, 4553.3467, 1460.6614);
	angles[6] = (0, 0, 0);
	at[6] = 1.2000;
	points[7] = (-7244.6460, 4553.3467, 1530.5828);
	angles[7] = (0, 0, 0);
	at[7] = 1.3000;
	points[8] = (-7244.6460, 4553.3467, 1589.1654);
	angles[8] = (0, 0, 0);
	at[8] = 1.4000;
	points[9] = (-7244.6460, 4553.3467, 1636.4094);
	angles[9] = (0, 0, 0);
	at[9] = 1.5000;
	points[10] = (-7244.6460, 4553.3467, 1655.7795);
	angles[10] = (0, 0, 0);
	at[10] = 1.5500;
	points[11] = (-7244.6460, 4553.3467, 1686.0157);
	angles[11] = (0, 0, 0);
	at[11] = 1.6500;
	points[12] = (-7244.6460, 4553.3467, 1704.9133);
	angles[12] = (0, 0, 0);
	at[12] = 1.7500;
	points[13] = (-7244.6460, 4553.3467, 1715.7008);
	angles[13] = (0, 0, 0);
	at[13] = 1.9000;
	points[14] = (-7244.6460, 4553.3467, 1723.6023);
	angles[14] = (0, 0, 0);
	at[14] = 1.9500;
	points[15] = (-7244.6460, 4553.3467, 1727.3149);
	angles[15] = (0, 0, 0);
	at[15] = 2;
	points[16] = (-7244.6460, 4553.3467, 1725.4174);
	angles[16] = (0, 0, 0);
	at[16] = 2.0500;
	points[17] = (-7244.6460, 4553.3467, 1719.1182);
	angles[17] = (0, 0, 0);
	at[17] = 2.1000;
	points[18] = (-7244.6460, 4553.3467, 1142.7402);
	angles[18] = (0, 0, 0);
	at[18] = 5.1500;
	points[19] = (-7244.6460, 4553.3467, 1139.5906);
	angles[19] = (0, 0, 0);
	at[19] = 5.2000;
	points[20] = (-7244.6460, 4553.3467, 1139.5906);
	angles[20] = (0, 0, 0);
	at[20] = 8.5167;
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
	points[0] = (-8041.8110, 4795.0396, 1451.4016);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-8041.8110, 4795.0396, 1139.5906);
	angles[1] = (0, 0, 0);
	at[1] = 1.6500;
	points[2] = (-8041.8110, 4795.0396, 1139.5906);
	angles[2] = (0, 0, 0);
	at[2] = 5.8500;
	points[3] = (-8041.8110, 4795.0396, 1182.8661);
	angles[3] = (0, 0, 0);
	at[3] = 5.9000;
	points[4] = (-8041.8110, 4795.0396, 1236.2520);
	angles[4] = (0, 0, 0);
	at[4] = 5.9500;
	points[5] = (-8041.8110, 4795.0396, 1334.5198);
	angles[5] = (0, 0, 0);
	at[5] = 6.0500;
	points[6] = (-8041.8110, 4795.0396, 1421.4489);
	angles[6] = (0, 0, 0);
	at[6] = 6.1500;
	points[7] = (-8041.8110, 4795.0396, 1460.6614);
	angles[7] = (0, 0, 0);
	at[7] = 6.2000;
	points[8] = (-8041.8110, 4795.0396, 1530.5828);
	angles[8] = (0, 0, 0);
	at[8] = 6.3000;
	points[9] = (-8041.8110, 4795.0396, 1589.1654);
	angles[9] = (0, 0, 0);
	at[9] = 6.4000;
	points[10] = (-8041.8110, 4795.0396, 1636.4094);
	angles[10] = (0, 0, 0);
	at[10] = 6.5000;
	points[11] = (-8041.8110, 4795.0396, 1655.7795);
	angles[11] = (0, 0, 0);
	at[11] = 6.5500;
	points[12] = (-8041.8110, 4795.0396, 1686.0157);
	angles[12] = (0, 0, 0);
	at[12] = 6.6500;
	points[13] = (-8041.8110, 4795.0396, 1704.9133);
	angles[13] = (0, 0, 0);
	at[13] = 6.7500;
	points[14] = (-8041.8110, 4795.0396, 1715.7008);
	angles[14] = (0, 0, 0);
	at[14] = 6.9000;
	points[15] = (-8041.8110, 4795.0396, 1723.6023);
	angles[15] = (0, 0, 0);
	at[15] = 6.9500;
	points[16] = (-8041.8110, 4795.0396, 1727.3149);
	angles[16] = (0, 0, 0);
	at[16] = 7;
	points[17] = (-8041.8110, 4795.0396, 1725.4174);
	angles[17] = (0, 0, 0);
	at[17] = 7.0500;
	points[18] = (-8041.8110, 4795.0396, 1719.1182);
	angles[18] = (0, 0, 0);
	at[18] = 7.1000;
	points[19] = (-8041.8110, 4795.0396, 1451.4016);
	angles[19] = (0, 0, 0);
	at[19] = 8.5167;
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
	points[0] = (-7242.0869, 5023.0317, 1259.2756);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-7242.0869, 5023.0317, 1145.8898);
	angles[1] = (0, 0, 0);
	at[1] = 0.6000;
	points[2] = (-7242.0869, 5023.0317, 1139.5906);
	angles[2] = (0, 0, 0);
	at[2] = 0.6500;
	points[3] = (-7242.0869, 5023.0317, 1139.5906);
	angles[3] = (0, 0, 0);
	at[3] = 4.8000;
	points[4] = (-7242.0869, 5023.0317, 1145.7008);
	angles[4] = (0, 0, 0);
	at[4] = 4.8500;
	points[5] = (-7242.0869, 5023.0317, 1253.4174);
	angles[5] = (0, 0, 0);
	at[5] = 4.9500;
	points[6] = (-7242.0869, 5023.0317, 1303.0237);
	angles[6] = (0, 0, 0);
	at[6] = 5;
	points[7] = (-7242.0869, 5023.0317, 1393.7323);
	angles[7] = (0, 0, 0);
	at[7] = 5.1000;
	points[8] = (-7242.0869, 5023.0317, 1434.8347);
	angles[8] = (0, 0, 0);
	at[8] = 5.1500;
	points[9] = (-7242.0869, 5023.0317, 1508.5354);
	angles[9] = (0, 0, 0);
	at[9] = 5.2500;
	points[10] = (-7242.0869, 5023.0317, 1541.1338);
	angles[10] = (0, 0, 0);
	at[10] = 5.3000;
	points[11] = (-7242.0869, 5023.0317, 1597.8268);
	angles[11] = (0, 0, 0);
	at[11] = 5.4000;
	points[12] = (-7242.0869, 5023.0317, 1643.1812);
	angles[12] = (0, 0, 0);
	at[12] = 5.5000;
	points[13] = (-7242.0869, 5023.0317, 1661.6063);
	angles[13] = (0, 0, 0);
	at[13] = 5.5500;
	points[14] = (-7242.0869, 5023.0317, 1689.9528);
	angles[14] = (0, 0, 0);
	at[14] = 5.6500;
	points[15] = (-7242.0869, 5023.0317, 1706.9607);
	angles[15] = (0, 0, 0);
	at[15] = 5.7500;
	points[16] = (-7242.0869, 5023.0317, 1712.6300);
	angles[16] = (0, 0, 0);
	at[16] = 5.8500;
	points[17] = (-7242.0869, 5023.0317, 1725.4174);
	angles[17] = (0, 0, 0);
	at[17] = 5.9500;
	points[18] = (-7242.0869, 5023.0317, 1727.3149);
	angles[18] = (0, 0, 0);
	at[18] = 6;
	points[19] = (-7242.0869, 5023.0317, 1725.4174);
	angles[19] = (0, 0, 0);
	at[19] = 6.0500;
	points[20] = (-7242.0869, 5023.0317, 1259.2756);
	angles[20] = (0, 0, 0);
	at[20] = 8.5167;
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
	points[0] = (-8181.3389, 5185.0396, 1139.5906);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-8181.3389, 5185.0396, 1139.5906);
	angles[1] = (0, 0, 0);
	at[1] = 2.5000;
	points[2] = (-8181.3389, 5185.0396, 1164.4409);
	angles[2] = (0, 0, 0);
	at[2] = 2.5500;
	points[3] = (-8181.3389, 5185.0396, 1218.7717);
	angles[3] = (0, 0, 0);
	at[3] = 2.6000;
	points[4] = (-8181.3389, 5185.0396, 1318.9292);
	angles[4] = (0, 0, 0);
	at[4] = 2.7000;
	points[5] = (-8181.3389, 5185.0396, 1364.7559);
	angles[5] = (0, 0, 0);
	at[5] = 2.7500;
	points[6] = (-8181.3389, 5185.0396, 1447.9055);
	angles[6] = (0, 0, 0);
	at[6] = 2.8500;
	points[7] = (-8181.3389, 5185.0396, 1485.2284);
	angles[7] = (0, 0, 0);
	at[7] = 2.9000;
	points[8] = (-8181.3389, 5185.0396, 1551.3701);
	angles[8] = (0, 0, 0);
	at[8] = 3;
	points[9] = (-8181.3389, 5185.0396, 1606.1732);
	angles[9] = (0, 0, 0);
	at[9] = 3.1000;
	points[10] = (-8181.3389, 5185.0396, 1629.3229);
	angles[10] = (0, 0, 0);
	at[10] = 3.1500;
	points[11] = (-8181.3389, 5185.0396, 1667.1180);
	angles[11] = (0, 0, 0);
	at[11] = 3.2500;
	points[12] = (-8181.3389, 5185.0396, 1693.5748);
	angles[12] = (0, 0, 0);
	at[12] = 3.3500;
	points[13] = (-8181.3389, 5185.0396, 1708.6929);
	angles[13] = (0, 0, 0);
	at[13] = 3.4500;
	points[14] = (-8181.3389, 5185.0396, 1712.6300);
	angles[14] = (0, 0, 0);
	at[14] = 3.5500;
	points[15] = (-8181.3389, 5185.0396, 1726.6732);
	angles[15] = (0, 0, 0);
	at[15] = 3.6500;
	points[16] = (-8181.3389, 5185.0396, 1726.6732);
	angles[16] = (0, 0, 0);
	at[16] = 3.7000;
	points[17] = (-8181.3389, 5185.0396, 1722.2678);
	angles[17] = (0, 0, 0);
	at[17] = 3.7500;
	points[18] = (-8181.3389, 5185.0396, 1145.8898);
	angles[18] = (0, 0, 0);
	at[18] = 6.8000;
	points[19] = (-8181.3389, 5185.0396, 1139.5906);
	angles[19] = (0, 0, 0);
	at[19] = 6.8500;
	points[20] = (-8181.3389, 5185.0396, 1139.5906);
	angles[20] = (0, 0, 0);
	at[20] = 8.5167;
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
	points[0] = (-7385.5903, 5510, 1712.4724);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-7385.5903, 5510, 1727.3149);
	angles[1] = (0, 0, 0);
	at[1] = 0.1500;
	points[2] = (-7385.5903, 5510, 1725.4174);
	angles[2] = (0, 0, 0);
	at[2] = 0.2000;
	points[3] = (-7385.5903, 5510, 1719.1182);
	angles[3] = (0, 0, 0);
	at[3] = 0.2500;
	points[4] = (-7385.5903, 5510, 1142.7402);
	angles[4] = (0, 0, 0);
	at[4] = 3.3000;
	points[5] = (-7385.5903, 5510, 1139.5906);
	angles[5] = (0, 0, 0);
	at[5] = 3.3500;
	points[6] = (-7385.5903, 5510, 1139.5906);
	angles[6] = (0, 0, 0);
	at[6] = 7.5000;
	points[7] = (-7385.5903, 5510, 1164.4409);
	angles[7] = (0, 0, 0);
	at[7] = 7.5500;
	points[8] = (-7385.5903, 5510, 1218.7717);
	angles[8] = (0, 0, 0);
	at[8] = 7.6000;
	points[9] = (-7385.5903, 5510, 1318.9292);
	angles[9] = (0, 0, 0);
	at[9] = 7.7000;
	points[10] = (-7385.5903, 5510, 1364.7559);
	angles[10] = (0, 0, 0);
	at[10] = 7.7500;
	points[11] = (-7385.5903, 5510, 1447.9055);
	angles[11] = (0, 0, 0);
	at[11] = 7.8500;
	points[12] = (-7385.5903, 5510, 1519.7166);
	angles[12] = (0, 0, 0);
	at[12] = 7.9500;
	points[13] = (-7385.5903, 5510, 1580.1890);
	angles[13] = (0, 0, 0);
	at[13] = 8.0500;
	points[14] = (-7385.5903, 5510, 1629.3229);
	angles[14] = (0, 0, 0);
	at[14] = 8.1500;
	points[15] = (-7385.5903, 5510, 1649.6378);
	angles[15] = (0, 0, 0);
	at[15] = 8.2000;
	points[16] = (-7385.5903, 5510, 1681.7638);
	angles[16] = (0, 0, 0);
	at[16] = 8.3000;
	points[17] = (-7385.5903, 5510, 1702.5513);
	angles[17] = (0, 0, 0);
	at[17] = 8.4000;
	points[18] = (-7385.5903, 5510, 1712.4724);
	angles[18] = (0, 0, 0);
	at[18] = 8.5167;
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
	points[0] = (-8154.3701, 5819.6455, 1574.2362);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-8154.3701, 5819.6455, 1139.5906);
	angles[1] = (0, 0, 0);
	at[1] = 2.3000;
	points[2] = (-8154.3701, 5819.6455, 1139.5906);
	angles[2] = (0, 0, 0);
	at[2] = 2.4500;
	points[3] = (-8154.3701, 5819.6455, 1139.5906);
	angles[3] = (0, 0, 0);
	at[3] = 6.5000;
	points[4] = (-8154.3701, 5819.6455, 1182.8661);
	angles[4] = (0, 0, 0);
	at[4] = 6.5500;
	points[5] = (-8154.3701, 5819.6455, 1286.8031);
	angles[5] = (0, 0, 0);
	at[5] = 6.6500;
	points[6] = (-8154.3701, 5819.6455, 1379.4016);
	angles[6] = (0, 0, 0);
	at[6] = 6.7500;
	points[7] = (-8154.3701, 5819.6455, 1460.6614);
	angles[7] = (0, 0, 0);
	at[7] = 6.8500;
	points[8] = (-8154.3701, 5819.6455, 1530.5828);
	angles[8] = (0, 0, 0);
	at[8] = 6.9500;
	points[9] = (-8154.3701, 5819.6455, 1589.1654);
	angles[9] = (0, 0, 0);
	at[9] = 7.0500;
	points[10] = (-8154.3701, 5819.6455, 1636.4094);
	angles[10] = (0, 0, 0);
	at[10] = 7.1500;
	points[11] = (-8154.3701, 5819.6455, 1672.3149);
	angles[11] = (0, 0, 0);
	at[11] = 7.2500;
	points[12] = (-8154.3701, 5819.6455, 1696.8818);
	angles[12] = (0, 0, 0);
	at[12] = 7.3500;
	points[13] = (-8154.3701, 5819.6455, 1704.9133);
	angles[13] = (0, 0, 0);
	at[13] = 7.4000;
	points[14] = (-8154.3701, 5819.6455, 1715.7008);
	angles[14] = (0, 0, 0);
	at[14] = 7.5500;
	points[15] = (-8154.3701, 5819.6455, 1723.6023);
	angles[15] = (0, 0, 0);
	at[15] = 7.6000;
	points[16] = (-8154.3701, 5819.6455, 1727.3149);
	angles[16] = (0, 0, 0);
	at[16] = 7.6500;
	points[17] = (-8154.3701, 5819.6455, 1725.4174);
	angles[17] = (0, 0, 0);
	at[17] = 7.7000;
	points[18] = (-8154.3701, 5819.6455, 1719.1182);
	angles[18] = (0, 0, 0);
	at[18] = 7.7500;
	points[19] = (-8154.3701, 5819.6455, 1574.2362);
	angles[19] = (0, 0, 0);
	at[19] = 8.5167;
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
	points[0] = (-7297.1655, 5974.7642, 1139.5906);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-7297.1655, 5974.7642, 1139.5906);
	angles[1] = (0, 0, 0);
	at[1] = 4.1500;
	points[2] = (-7297.1655, 5974.7642, 1145.7008);
	angles[2] = (0, 0, 0);
	at[2] = 4.2000;
	points[3] = (-7297.1655, 5974.7642, 1253.4174);
	angles[3] = (0, 0, 0);
	at[3] = 4.3000;
	points[4] = (-7297.1655, 5974.7642, 1303.0237);
	angles[4] = (0, 0, 0);
	at[4] = 4.3500;
	points[5] = (-7297.1655, 5974.7642, 1393.7323);
	angles[5] = (0, 0, 0);
	at[5] = 4.4500;
	points[6] = (-7297.1655, 5974.7642, 1434.8347);
	angles[6] = (0, 0, 0);
	at[6] = 4.5000;
	points[7] = (-7297.1655, 5974.7642, 1508.5354);
	angles[7] = (0, 0, 0);
	at[7] = 4.6000;
	points[8] = (-7297.1655, 5974.7642, 1541.1338);
	angles[8] = (0, 0, 0);
	at[8] = 4.6500;
	points[9] = (-7297.1655, 5974.7642, 1597.8268);
	angles[9] = (0, 0, 0);
	at[9] = 4.7500;
	points[10] = (-7297.1655, 5974.7642, 1643.1812);
	angles[10] = (0, 0, 0);
	at[10] = 4.8500;
	points[11] = (-7297.1655, 5974.7642, 1661.6063);
	angles[11] = (0, 0, 0);
	at[11] = 4.9000;
	points[12] = (-7297.1655, 5974.7642, 1689.9528);
	angles[12] = (0, 0, 0);
	at[12] = 5;
	points[13] = (-7297.1655, 5974.7642, 1706.9607);
	angles[13] = (0, 0, 0);
	at[13] = 5.1000;
	points[14] = (-7297.1655, 5974.7642, 1712.6300);
	angles[14] = (0, 0, 0);
	at[14] = 5.2000;
	points[15] = (-7297.1655, 5974.7642, 1725.4174);
	angles[15] = (0, 0, 0);
	at[15] = 5.3000;
	points[16] = (-7297.1655, 5974.7642, 1727.3149);
	angles[16] = (0, 0, 0);
	at[16] = 5.3500;
	points[17] = (-7297.1655, 5974.7642, 1725.4174);
	angles[17] = (0, 0, 0);
	at[17] = 5.4000;
	points[18] = (-7297.1655, 5974.7642, 1139.5906);
	angles[18] = (0, 0, 0);
	at[18] = 8.5000;
	points[19] = (-7297.1655, 5974.7642, 1139.5906);
	angles[19] = (0, 0, 0);
	at[19] = 8.5167;
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
	points[0] = (-8219.7246, 6170.7876, 1139.5906);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-8219.7246, 6170.7876, 1139.5906);
	angles[1] = (0, 0, 0);
	at[1] = 1.5000;
	points[2] = (-8219.7246, 6170.7876, 1182.8661);
	angles[2] = (0, 0, 0);
	at[2] = 1.5500;
	points[3] = (-8219.7246, 6170.7876, 1236.2520);
	angles[3] = (0, 0, 0);
	at[3] = 1.6000;
	points[4] = (-8219.7246, 6170.7876, 1334.5198);
	angles[4] = (0, 0, 0);
	at[4] = 1.7000;
	points[5] = (-8219.7246, 6170.7876, 1421.4489);
	angles[5] = (0, 0, 0);
	at[5] = 1.8000;
	points[6] = (-8219.7246, 6170.7876, 1460.6614);
	angles[6] = (0, 0, 0);
	at[6] = 1.8500;
	points[7] = (-8219.7246, 6170.7876, 1530.5828);
	angles[7] = (0, 0, 0);
	at[7] = 1.9500;
	points[8] = (-8219.7246, 6170.7876, 1589.1654);
	angles[8] = (0, 0, 0);
	at[8] = 2.0500;
	points[9] = (-8219.7246, 6170.7876, 1636.4094);
	angles[9] = (0, 0, 0);
	at[9] = 2.1500;
	points[10] = (-8219.7246, 6170.7876, 1655.7795);
	angles[10] = (0, 0, 0);
	at[10] = 2.2000;
	points[11] = (-8219.7246, 6170.7876, 1686.0157);
	angles[11] = (0, 0, 0);
	at[11] = 2.3000;
	points[12] = (-8219.7246, 6170.7876, 1704.9133);
	angles[12] = (0, 0, 0);
	at[12] = 2.4000;
	points[13] = (-8219.7246, 6170.7876, 1715.7008);
	angles[13] = (0, 0, 0);
	at[13] = 2.5500;
	points[14] = (-8219.7246, 6170.7876, 1723.6023);
	angles[14] = (0, 0, 0);
	at[14] = 2.6000;
	points[15] = (-8219.7246, 6170.7876, 1727.3149);
	angles[15] = (0, 0, 0);
	at[15] = 2.6500;
	points[16] = (-8219.7246, 6170.7876, 1725.4174);
	angles[16] = (0, 0, 0);
	at[16] = 2.7000;
	points[17] = (-8219.7246, 6170.7876, 1719.1182);
	angles[17] = (0, 0, 0);
	at[17] = 2.7500;
	points[18] = (-8219.7246, 6170.7876, 1142.7402);
	angles[18] = (0, 0, 0);
	at[18] = 5.8000;
	points[19] = (-8219.7246, 6170.7876, 1139.5906);
	angles[19] = (0, 0, 0);
	at[19] = 5.8500;
	points[20] = (-8219.7246, 6170.7876, 1139.5906);
	angles[20] = (0, 0, 0);
	at[20] = 8.5167;
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
	points[0] = (-7178.6616, 6349.6064, 1460.6614);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-7178.6616, 6349.6064, 1530.5828);
	angles[1] = (0, 0, 0);
	at[1] = 0.1000;
	points[2] = (-7178.6616, 6349.6064, 1589.1654);
	angles[2] = (0, 0, 0);
	at[2] = 0.2000;
	points[3] = (-7178.6616, 6349.6064, 1636.4094);
	angles[3] = (0, 0, 0);
	at[3] = 0.3000;
	points[4] = (-7178.6616, 6349.6064, 1672.3149);
	angles[4] = (0, 0, 0);
	at[4] = 0.4000;
	points[5] = (-7178.6616, 6349.6064, 1686.0157);
	angles[5] = (0, 0, 0);
	at[5] = 0.4500;
	points[6] = (-7178.6616, 6349.6064, 1704.9133);
	angles[6] = (0, 0, 0);
	at[6] = 0.5500;
	points[7] = (-7178.6616, 6349.6064, 1715.7008);
	angles[7] = (0, 0, 0);
	at[7] = 0.7000;
	points[8] = (-7178.6616, 6349.6064, 1723.6023);
	angles[8] = (0, 0, 0);
	at[8] = 0.7500;
	points[9] = (-7178.6616, 6349.6064, 1727.3149);
	angles[9] = (0, 0, 0);
	at[9] = 0.8000;
	points[10] = (-7178.6616, 6349.6064, 1725.4174);
	angles[10] = (0, 0, 0);
	at[10] = 0.8500;
	points[11] = (-7178.6616, 6349.6064, 1719.1182);
	angles[11] = (0, 0, 0);
	at[11] = 0.9000;
	points[12] = (-7178.6616, 6349.6064, 1142.7402);
	angles[12] = (0, 0, 0);
	at[12] = 3.9500;
	points[13] = (-7178.6616, 6349.6064, 1139.5906);
	angles[13] = (0, 0, 0);
	at[13] = 4;
	points[14] = (-7178.6616, 6349.6064, 1139.5906);
	angles[14] = (0, 0, 0);
	at[14] = 8.1500;
	points[15] = (-7178.6616, 6349.6064, 1164.4409);
	angles[15] = (0, 0, 0);
	at[15] = 8.2000;
	points[16] = (-7178.6616, 6349.6064, 1218.7717);
	angles[16] = (0, 0, 0);
	at[16] = 8.2500;
	points[17] = (-7178.6616, 6349.6064, 1318.9292);
	angles[17] = (0, 0, 0);
	at[17] = 8.3500;
	points[18] = (-7178.6616, 6349.6064, 1407.7482);
	angles[18] = (0, 0, 0);
	at[18] = 8.4500;
	points[19] = (-7178.6616, 6349.6064, 1460.6614);
	angles[19] = (0, 0, 0);
	at[19] = 8.5167;
	mover = getEnt("iz_obj_16", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_17()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-8206.5352, 4305.0786, 1139.5906);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-8206.5352, 4305.0786, 1139.5906);
	angles[1] = (0, 0, 0);
	at[1] = 3.1500;
	points[2] = (-8206.5352, 4305.0786, 1164.4409);
	angles[2] = (0, 0, 0);
	at[2] = 3.2000;
	points[3] = (-8206.5352, 4305.0786, 1218.7717);
	angles[3] = (0, 0, 0);
	at[3] = 3.2500;
	points[4] = (-8206.5352, 4305.0786, 1318.9292);
	angles[4] = (0, 0, 0);
	at[4] = 3.3500;
	points[5] = (-8206.5352, 4305.0786, 1364.7559);
	angles[5] = (0, 0, 0);
	at[5] = 3.4000;
	points[6] = (-8206.5352, 4305.0786, 1447.9055);
	angles[6] = (0, 0, 0);
	at[6] = 3.5000;
	points[7] = (-8206.5352, 4305.0786, 1485.2284);
	angles[7] = (0, 0, 0);
	at[7] = 3.5500;
	points[8] = (-8206.5352, 4305.0786, 1551.3701);
	angles[8] = (0, 0, 0);
	at[8] = 3.6500;
	points[9] = (-8206.5352, 4305.0786, 1606.1732);
	angles[9] = (0, 0, 0);
	at[9] = 3.7500;
	points[10] = (-8206.5352, 4305.0786, 1629.3229);
	angles[10] = (0, 0, 0);
	at[10] = 3.8000;
	points[11] = (-8206.5352, 4305.0786, 1667.1180);
	angles[11] = (0, 0, 0);
	at[11] = 3.9000;
	points[12] = (-8206.5352, 4305.0786, 1693.5748);
	angles[12] = (0, 0, 0);
	at[12] = 4;
	points[13] = (-8206.5352, 4305.0786, 1708.6929);
	angles[13] = (0, 0, 0);
	at[13] = 4.1000;
	points[14] = (-8206.5352, 4305.0786, 1712.6300);
	angles[14] = (0, 0, 0);
	at[14] = 4.2000;
	points[15] = (-8206.5352, 4305.0786, 1726.6732);
	angles[15] = (0, 0, 0);
	at[15] = 4.3000;
	points[16] = (-8206.5352, 4305.0786, 1726.6732);
	angles[16] = (0, 0, 0);
	at[16] = 4.3500;
	points[17] = (-8206.5352, 4305.0786, 1722.2678);
	angles[17] = (0, 0, 0);
	at[17] = 4.4000;
	points[18] = (-8206.5352, 4305.0786, 1145.8898);
	angles[18] = (0, 0, 0);
	at[18] = 7.4500;
	points[19] = (-8206.5352, 4305.0786, 1139.5906);
	angles[19] = (0, 0, 0);
	at[19] = 7.5000;
	points[20] = (-8206.5352, 4305.0786, 1139.5906);
	angles[20] = (0, 0, 0);
	at[20] = 8.5167;
	mover = getEnt("iz_obj_17", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_18()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-9836.2988, -11752.2832, 2530.5120);
	angles[0] = (0, -90, 0);
	at[0] = 0;
	points[1] = (-9836.2988, -11752.2832, 2530.5120);
	angles[1] = (0, -90, 0);
	at[1] = 1.1000;
	points[2] = (-9836.2988, -11752.2832, 2538.1812);
	angles[2] = (0, -90, 0);
	at[2] = 1.2000;
	points[3] = (-9836.2988, -11752.2832, 2526.0828);
	angles[3] = (0, -90, 0);
	at[3] = 1.2500;
	points[4] = (-9836.2988, -11752.2832, 2522.8386);
	angles[4] = (0, -90, 0);
	at[4] = 1.3000;
	points[5] = (-9836.2988, -11752.2832, 2534.9409);
	angles[5] = (0, -90, 0);
	at[5] = 1.3500;
	points[6] = (-9836.2988, -11752.2832, 2538.1812);
	angles[6] = (0, -90, 0);
	at[6] = 1.4000;
	points[7] = (-9836.2988, -11752.2832, 2526.0828);
	angles[7] = (0, -90, 0);
	at[7] = 1.4500;
	points[8] = (-9836.2988, -11752.2832, 2522.8386);
	angles[8] = (0, -90, 0);
	at[8] = 1.5000;
	points[9] = (-9836.2988, -11752.2832, 2534.9409);
	angles[9] = (0, -90, 0);
	at[9] = 1.5500;
	points[10] = (-9836.2988, -11752.2832, 2538.1812);
	angles[10] = (0, -90, 0);
	at[10] = 1.6000;
	points[11] = (-9836.2988, -11752.2832, 2526.0828);
	angles[11] = (0, -90, 0);
	at[11] = 1.6500;
	points[12] = (-9836.2988, -11752.2832, 2658.9565);
	angles[12] = (0, -90, 0);
	at[12] = 1.8000;
	points[13] = (-9836.2988, -11752.2832, 2658.6614);
	angles[13] = (0, -90, 0);
	at[13] = 1.8500;
	points[14] = (-9836.2988, -11752.2832, 2598.4253);
	angles[14] = (0, -90, 0);
	at[14] = 1.9000;
	points[15] = (-9836.2988, -11752.2832, 2493.0117);
	angles[15] = (0, -90, 0);
	at[15] = 1.9500;
	points[16] = (-9836.2988, -11752.2832, 2342.4214);
	angles[16] = (0, -90, 0);
	at[16] = 2;
	points[17] = (-9836.2988, -11752.2832, 2325.2244);
	angles[17] = (0, -90, 0);
	at[17] = 2.0500;
	points[18] = (-9836.2988, -11752.2832, 2325.2244);
	angles[18] = (0, -90, 0);
	at[18] = 3;
	points[19] = (-9836.2988, -11752.2832, 2331.1299);
	angles[19] = (0, -90, 0);
	at[19] = 3.0500;
	points[20] = (-9836.2988, -11752.2832, 2526.0117);
	angles[20] = (0, -90, 0);
	at[20] = 4.1500;
	points[21] = (-9836.2988, -11752.2832, 2530.5120);
	angles[21] = (0, -90, 0);
	at[21] = 4.2000;
	mover = getEnt("iz_obj_18", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_19()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-9836.2988, -11977.5596, 2325.2244);
	angles[0] = (0, -90, 0);
	at[0] = 0;
	points[1] = (-9836.2988, -11977.5596, 2325.2244);
	angles[1] = (0, -90, 0);
	at[1] = 0.2000;
	points[2] = (-9836.2988, -11977.5596, 2328.1772);
	angles[2] = (0, -90, 0);
	at[2] = 0.2500;
	points[3] = (-9836.2988, -11977.5596, 2530.5120);
	angles[3] = (0, -90, 0);
	at[3] = 1.4000;
	points[4] = (-9836.2988, -11977.5596, 2530.5120);
	angles[4] = (0, -90, 0);
	at[4] = 2.5500;
	points[5] = (-9836.2988, -11977.5596, 2539.3701);
	angles[5] = (0, -90, 0);
	at[5] = 2.6000;
	points[6] = (-9836.2988, -11977.5596, 2521.6538);
	angles[6] = (0, -90, 0);
	at[6] = 2.7000;
	points[7] = (-9836.2988, -11977.5596, 2539.3701);
	angles[7] = (0, -90, 0);
	at[7] = 2.8000;
	points[8] = (-9836.2988, -11977.5596, 2521.6538);
	angles[8] = (0, -90, 0);
	at[8] = 2.9000;
	points[9] = (-9836.2988, -11977.5596, 2539.3701);
	angles[9] = (0, -90, 0);
	at[9] = 3;
	points[10] = (-9836.2988, -11977.5596, 2530.5120);
	angles[10] = (0, -90, 0);
	at[10] = 3.0500;
	points[11] = (-9836.2988, -11977.5596, 2555.6101);
	angles[11] = (0, -90, 0);
	at[11] = 3.1000;
	points[12] = (-9836.2988, -11977.5596, 2644.1929);
	angles[12] = (0, -90, 0);
	at[12] = 3.2000;
	points[13] = (-9836.2988, -11977.5596, 2668.7009);
	angles[13] = (0, -90, 0);
	at[13] = 3.2500;
	points[14] = (-9836.2988, -11977.5596, 2623.5234);
	angles[14] = (0, -90, 0);
	at[14] = 3.3000;
	points[15] = (-9836.2988, -11977.5596, 2533.1692);
	angles[15] = (0, -90, 0);
	at[15] = 3.3500;
	points[16] = (-9836.2988, -11977.5596, 2397.6379);
	angles[16] = (0, -90, 0);
	at[16] = 3.4000;
	points[17] = (-9836.2988, -11977.5596, 2325.2244);
	angles[17] = (0, -90, 0);
	at[17] = 3.4500;
	points[18] = (-9836.2988, -11977.5596, 2325.2244);
	angles[18] = (0, -90, 0);
	at[18] = 4.2000;
	mover = getEnt("iz_obj_19", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_20()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-9836.2988, -11526.9688, 2534.9409);
	angles[0] = (0, -90, 0);
	at[0] = 0;
	points[1] = (-9836.2988, -11526.9688, 2522.8386);
	angles[1] = (0, -90, 0);
	at[1] = 0.0500;
	points[2] = (-9836.2988, -11526.9688, 2526.0828);
	angles[2] = (0, -90, 0);
	at[2] = 0.1000;
	points[3] = (-9836.2988, -11526.9688, 2538.1812);
	angles[3] = (0, -90, 0);
	at[3] = 0.1500;
	points[4] = (-9836.2988, -11526.9688, 2534.9409);
	angles[4] = (0, -90, 0);
	at[4] = 0.2000;
	points[5] = (-9836.2988, -11526.9688, 2540.8464);
	angles[5] = (0, -90, 0);
	at[5] = 0.2500;
	points[6] = (-9836.2988, -11526.9688, 2673.7205);
	angles[6] = (0, -90, 0);
	at[6] = 0.4000;
	points[7] = (-9836.2988, -11526.9688, 2643.6023);
	angles[7] = (0, -90, 0);
	at[7] = 0.4500;
	points[8] = (-9836.2988, -11526.9688, 2568.3071);
	angles[8] = (0, -90, 0);
	at[8] = 0.5000;
	points[9] = (-9836.2988, -11526.9688, 2325.2244);
	angles[9] = (0, -90, 0);
	at[9] = 0.6000;
	points[10] = (-9836.2988, -11526.9688, 2325.2244);
	angles[10] = (0, -90, 0);
	at[10] = 1.6000;
	points[11] = (-9836.2988, -11526.9688, 2528.9646);
	angles[11] = (0, -90, 0);
	at[11] = 2.7500;
	points[12] = (-9836.2988, -11526.9688, 2530.5120);
	angles[12] = (0, -90, 0);
	at[12] = 3.9000;
	points[13] = (-9836.2988, -11526.9688, 2538.1812);
	angles[13] = (0, -90, 0);
	at[13] = 3.9500;
	points[14] = (-9836.2988, -11526.9688, 2534.9409);
	angles[14] = (0, -90, 0);
	at[14] = 4;
	points[15] = (-9836.2988, -11526.9688, 2522.8386);
	angles[15] = (0, -90, 0);
	at[15] = 4.0500;
	points[16] = (-9836.2988, -11526.9688, 2526.0828);
	angles[16] = (0, -90, 0);
	at[16] = 4.1000;
	points[17] = (-9836.2988, -11526.9688, 2538.1812);
	angles[17] = (0, -90, 0);
	at[17] = 4.1500;
	points[18] = (-9836.2988, -11526.9688, 2534.9409);
	angles[18] = (0, -90, 0);
	at[18] = 4.2000;
	mover = getEnt("iz_obj_20", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_21()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-5019.6851, 7293.3071, 1599.7479);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-5019.6851, 7293.3071, 1638.1104);
	angles[1] = (0, 0, 0);
	at[1] = 0.0500;
	points[2] = (-5019.6851, 7293.3071, 1668.5354);
	angles[2] = (0, 0, 0);
	at[2] = 0.1000;
	points[3] = (-5019.6851, 7293.3071, 1691.0237);
	angles[3] = (0, 0, 0);
	at[3] = 0.1500;
	points[4] = (-5019.6851, 7293.3071, 1705.5750);
	angles[4] = (0, 0, 0);
	at[4] = 0.2000;
	points[5] = (-5019.6851, 7293.3071, 1727.3149);
	angles[5] = (0, 0, 0);
	at[5] = 0.4000;
	points[6] = (-5019.6851, 7293.3071, 1725.4174);
	angles[6] = (0, 0, 0);
	at[6] = 0.4500;
	points[7] = (-5019.6851, 7293.3071, 1701.6614);
	angles[7] = (0, 0, 0);
	at[7] = 0.6000;
	points[8] = (-5019.6851, 7293.3071, 1697.9489);
	angles[8] = (0, 0, 0);
	at[8] = 0.6500;
	points[9] = (-5019.6851, 7293.3071, 1699.8466);
	angles[9] = (0, 0, 0);
	at[9] = 0.7000;
	points[10] = (-5019.6851, 7293.3071, 1723.6023);
	angles[10] = (0, 0, 0);
	at[10] = 0.8500;
	points[11] = (-5019.6851, 7293.3071, 1727.3149);
	angles[11] = (0, 0, 0);
	at[11] = 0.9000;
	points[12] = (-5019.6851, 7293.3071, 1725.4174);
	angles[12] = (0, 0, 0);
	at[12] = 0.9500;
	points[13] = (-5019.6851, 7293.3071, 1701.6614);
	angles[13] = (0, 0, 0);
	at[13] = 1.1000;
	points[14] = (-5019.6851, 7293.3071, 1697.9489);
	angles[14] = (0, 0, 0);
	at[14] = 1.1500;
	points[15] = (-5019.6851, 7293.3071, 1699.8466);
	angles[15] = (0, 0, 0);
	at[15] = 1.2000;
	points[16] = (-5019.6851, 7293.3071, 1723.6023);
	angles[16] = (0, 0, 0);
	at[16] = 1.3500;
	points[17] = (-5019.6851, 7293.3071, 1727.3149);
	angles[17] = (0, 0, 0);
	at[17] = 1.4000;
	points[18] = (-5019.6851, 7293.3071, 1725.4174);
	angles[18] = (0, 0, 0);
	at[18] = 1.4500;
	points[19] = (-5019.6851, 7293.3071, 1701.6614);
	angles[19] = (0, 0, 0);
	at[19] = 1.6000;
	points[20] = (-5019.6851, 7293.3071, 1697.9489);
	angles[20] = (0, 0, 0);
	at[20] = 1.6500;
	points[21] = (-5019.6851, 7293.3071, 1699.8466);
	angles[21] = (0, 0, 0);
	at[21] = 1.7000;
	points[22] = (-5019.6851, 7293.3071, 1723.6023);
	angles[22] = (0, 0, 0);
	at[22] = 1.8500;
	points[23] = (-5019.6851, 7293.3071, 1727.3149);
	angles[23] = (0, 0, 0);
	at[23] = 1.9000;
	points[24] = (-5019.6851, 7293.3071, 1725.4174);
	angles[24] = (0, 0, 0);
	at[24] = 1.9500;
	points[25] = (-5019.6851, 7293.3071, 1701.6614);
	angles[25] = (0, 0, 0);
	at[25] = 2.1000;
	points[26] = (-5019.6851, 7293.3071, 1697.9489);
	angles[26] = (0, 0, 0);
	at[26] = 2.1500;
	points[27] = (-5019.6851, 7293.3071, 1699.8466);
	angles[27] = (0, 0, 0);
	at[27] = 2.2000;
	points[28] = (-5019.6851, 7293.3071, 1723.6023);
	angles[28] = (0, 0, 0);
	at[28] = 2.3500;
	points[29] = (-5019.6851, 7293.3071, 1727.3149);
	angles[29] = (0, 0, 0);
	at[29] = 2.4000;
	points[30] = (-5019.6851, 7293.3071, 1725.4174);
	angles[30] = (0, 0, 0);
	at[30] = 2.4500;
	points[31] = (-5019.6851, 7293.3071, 1701.6614);
	angles[31] = (0, 0, 0);
	at[31] = 2.6000;
	points[32] = (-5019.6851, 7293.3071, 1697.9489);
	angles[32] = (0, 0, 0);
	at[32] = 2.6500;
	points[33] = (-5019.6851, 7293.3071, 1699.8466);
	angles[33] = (0, 0, 0);
	at[33] = 2.7000;
	points[34] = (-5019.6851, 7293.3071, 1723.6023);
	angles[34] = (0, 0, 0);
	at[34] = 2.8500;
	points[35] = (-5019.6851, 7293.3071, 1727.3149);
	angles[35] = (0, 0, 0);
	at[35] = 2.9000;
	points[36] = (-5019.6851, 7293.3071, 1725.4174);
	angles[36] = (0, 0, 0);
	at[36] = 2.9500;
	points[37] = (-5019.6851, 7293.3071, 1701.6614);
	angles[37] = (0, 0, 0);
	at[37] = 3.1000;
	points[38] = (-5019.6851, 7293.3071, 1697.9489);
	angles[38] = (0, 0, 0);
	at[38] = 3.1500;
	points[39] = (-5019.6851, 7293.3071, 1699.8466);
	angles[39] = (0, 0, 0);
	at[39] = 3.2000;
	points[40] = (-5019.6851, 7293.3071, 1712.6300);
	angles[40] = (0, 0, 0);
	at[40] = 3.3000;
	points[41] = (-5019.6851, 7293.3071, 19.4033);
	angles[41] = (0, 0, 0);
	at[41] = 6.5000;
	points[42] = (-5019.6851, 7293.3071, 19.4033);
	angles[42] = (0, 0, 0);
	at[42] = 10.7000;
	points[43] = (-5019.6851, 7293.3071, 229.2929);
	angles[43] = (0, 0, 0);
	at[43] = 10.7500;
	points[44] = (-5019.6851, 7293.3071, 378.7732);
	angles[44] = (0, 0, 0);
	at[44] = 10.8000;
	points[45] = (-5019.6851, 7293.3071, 520.3149);
	angles[45] = (0, 0, 0);
	at[45] = 10.8500;
	points[46] = (-5019.6851, 7293.3071, 653.9213);
	angles[46] = (0, 0, 0);
	at[46] = 10.9000;
	points[47] = (-5019.6851, 7293.3071, 779.5905);
	angles[47] = (0, 0, 0);
	at[47] = 10.9500;
	points[48] = (-5019.6851, 7293.3071, 897.3228);
	angles[48] = (0, 0, 0);
	at[48] = 11;
	points[49] = (-5019.6851, 7293.3071, 1007.1181);
	angles[49] = (0, 0, 0);
	at[49] = 11.0500;
	points[50] = (-5019.6851, 7293.3071, 1108.9763);
	angles[50] = (0, 0, 0);
	at[50] = 11.1000;
	points[51] = (-5019.6851, 7293.3071, 1202.8977);
	angles[51] = (0, 0, 0);
	at[51] = 11.1500;
	points[52] = (-5019.6851, 7293.3071, 1288.8818);
	angles[52] = (0, 0, 0);
	at[52] = 11.2000;
	points[53] = (-5019.6851, 7293.3071, 1366.9292);
	angles[53] = (0, 0, 0);
	at[53] = 11.2500;
	points[54] = (-5019.6851, 7293.3071, 1437.0394);
	angles[54] = (0, 0, 0);
	at[54] = 11.3000;
	points[55] = (-5019.6851, 7293.3071, 1499.2126);
	angles[55] = (0, 0, 0);
	at[55] = 11.3500;
	points[56] = (-5019.6851, 7293.3071, 1553.4489);
	angles[56] = (0, 0, 0);
	at[56] = 11.4000;
	points[57] = (-5019.6851, 7293.3071, 1599.7479);
	angles[57] = (0, 0, 0);
	at[57] = 11.4500;
	mover = getEnt("iz_obj_21", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_22()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-5019.6851, 7883.8584, 354.5213);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-5019.6851, 7883.8584, 37.0411);
	angles[1] = (0, 0, 0);
	at[1] = 0.6000;
	points[2] = (-5019.6851, 7883.8584, 19.4033);
	angles[2] = (0, 0, 0);
	at[2] = 0.6500;
	points[3] = (-5019.6851, 7883.8584, 19.4033);
	angles[3] = (0, 0, 0);
	at[3] = 4.8000;
	points[4] = (-5019.6851, 7883.8584, 125.2299);
	angles[4] = (0, 0, 0);
	at[4] = 4.8500;
	points[5] = (-5019.6851, 7883.8584, 280.0016);
	angles[5] = (0, 0, 0);
	at[5] = 4.9000;
	points[6] = (-5019.6851, 7883.8584, 426.8347);
	angles[6] = (0, 0, 0);
	at[6] = 4.9500;
	points[7] = (-5019.6851, 7883.8584, 565.7323);
	angles[7] = (0, 0, 0);
	at[7] = 5;
	points[8] = (-5019.6851, 7883.8584, 696.6929);
	angles[8] = (0, 0, 0);
	at[8] = 5.0500;
	points[9] = (-5019.6851, 7883.8584, 819.7166);
	angles[9] = (0, 0, 0);
	at[9] = 5.1000;
	points[10] = (-5019.6851, 7883.8584, 934.8032);
	angles[10] = (0, 0, 0);
	at[10] = 5.1500;
	points[11] = (-5019.6851, 7883.8584, 1041.9528);
	angles[11] = (0, 0, 0);
	at[11] = 5.2000;
	points[12] = (-5019.6851, 7883.8584, 1141.1654);
	angles[12] = (0, 0, 0);
	at[12] = 5.2500;
	points[13] = (-5019.6851, 7883.8584, 1232.4410);
	angles[13] = (0, 0, 0);
	at[13] = 5.3000;
	points[14] = (-5019.6851, 7883.8584, 1315.7795);
	angles[14] = (0, 0, 0);
	at[14] = 5.3500;
	points[15] = (-5019.6851, 7883.8584, 1391.1810);
	angles[15] = (0, 0, 0);
	at[15] = 5.4000;
	points[16] = (-5019.6851, 7883.8584, 1458.6456);
	angles[16] = (0, 0, 0);
	at[16] = 5.4500;
	points[17] = (-5019.6851, 7883.8584, 1518.1732);
	angles[17] = (0, 0, 0);
	at[17] = 5.5000;
	points[18] = (-5019.6851, 7883.8584, 1569.7639);
	angles[18] = (0, 0, 0);
	at[18] = 5.5500;
	points[19] = (-5019.6851, 7883.8584, 1613.4174);
	angles[19] = (0, 0, 0);
	at[19] = 5.6000;
	points[20] = (-5019.6851, 7883.8584, 1649.1339);
	angles[20] = (0, 0, 0);
	at[20] = 5.6500;
	points[21] = (-5019.6851, 7883.8584, 1676.9135);
	angles[21] = (0, 0, 0);
	at[21] = 5.7000;
	points[22] = (-5019.6851, 7883.8584, 1696.7559);
	angles[22] = (0, 0, 0);
	at[22] = 5.7500;
	points[23] = (-5019.6851, 7883.8584, 1708.6615);
	angles[23] = (0, 0, 0);
	at[23] = 5.8000;
	points[24] = (-5019.6851, 7883.8584, 1725.4174);
	angles[24] = (0, 0, 0);
	at[24] = 5.9500;
	points[25] = (-5019.6851, 7883.8584, 1727.3149);
	angles[25] = (0, 0, 0);
	at[25] = 6;
	points[26] = (-5019.6851, 7883.8584, 1723.6023);
	angles[26] = (0, 0, 0);
	at[26] = 6.0500;
	points[27] = (-5019.6851, 7883.8584, 1699.8466);
	angles[27] = (0, 0, 0);
	at[27] = 6.2000;
	points[28] = (-5019.6851, 7883.8584, 1697.9489);
	angles[28] = (0, 0, 0);
	at[28] = 6.2500;
	points[29] = (-5019.6851, 7883.8584, 1701.6614);
	angles[29] = (0, 0, 0);
	at[29] = 6.3000;
	points[30] = (-5019.6851, 7883.8584, 1725.4174);
	angles[30] = (0, 0, 0);
	at[30] = 6.4500;
	points[31] = (-5019.6851, 7883.8584, 1727.3149);
	angles[31] = (0, 0, 0);
	at[31] = 6.5000;
	points[32] = (-5019.6851, 7883.8584, 1723.6023);
	angles[32] = (0, 0, 0);
	at[32] = 6.5500;
	points[33] = (-5019.6851, 7883.8584, 1699.8466);
	angles[33] = (0, 0, 0);
	at[33] = 6.7000;
	points[34] = (-5019.6851, 7883.8584, 1697.9489);
	angles[34] = (0, 0, 0);
	at[34] = 6.7500;
	points[35] = (-5019.6851, 7883.8584, 1701.6614);
	angles[35] = (0, 0, 0);
	at[35] = 6.8000;
	points[36] = (-5019.6851, 7883.8584, 1725.4174);
	angles[36] = (0, 0, 0);
	at[36] = 6.9500;
	points[37] = (-5019.6851, 7883.8584, 1727.3149);
	angles[37] = (0, 0, 0);
	at[37] = 7;
	points[38] = (-5019.6851, 7883.8584, 1723.6023);
	angles[38] = (0, 0, 0);
	at[38] = 7.0500;
	points[39] = (-5019.6851, 7883.8584, 1699.8466);
	angles[39] = (0, 0, 0);
	at[39] = 7.2000;
	points[40] = (-5019.6851, 7883.8584, 1697.9489);
	angles[40] = (0, 0, 0);
	at[40] = 7.2500;
	points[41] = (-5019.6851, 7883.8584, 1701.6614);
	angles[41] = (0, 0, 0);
	at[41] = 7.3000;
	points[42] = (-5019.6851, 7883.8584, 1725.4174);
	angles[42] = (0, 0, 0);
	at[42] = 7.4500;
	points[43] = (-5019.6851, 7883.8584, 1727.3149);
	angles[43] = (0, 0, 0);
	at[43] = 7.5000;
	points[44] = (-5019.6851, 7883.8584, 1723.6023);
	angles[44] = (0, 0, 0);
	at[44] = 7.5500;
	points[45] = (-5019.6851, 7883.8584, 1699.8466);
	angles[45] = (0, 0, 0);
	at[45] = 7.7000;
	points[46] = (-5019.6851, 7883.8584, 1697.9489);
	angles[46] = (0, 0, 0);
	at[46] = 7.7500;
	points[47] = (-5019.6851, 7883.8584, 1701.6614);
	angles[47] = (0, 0, 0);
	at[47] = 7.8000;
	points[48] = (-5019.6851, 7883.8584, 1725.4174);
	angles[48] = (0, 0, 0);
	at[48] = 7.9500;
	points[49] = (-5019.6851, 7883.8584, 1727.3149);
	angles[49] = (0, 0, 0);
	at[49] = 8;
	points[50] = (-5019.6851, 7883.8584, 1723.6023);
	angles[50] = (0, 0, 0);
	at[50] = 8.0500;
	points[51] = (-5019.6851, 7883.8584, 1699.8466);
	angles[51] = (0, 0, 0);
	at[51] = 8.2000;
	points[52] = (-5019.6851, 7883.8584, 1697.9489);
	angles[52] = (0, 0, 0);
	at[52] = 8.2500;
	points[53] = (-5019.6851, 7883.8584, 1701.6614);
	angles[53] = (0, 0, 0);
	at[53] = 8.3000;
	points[54] = (-5019.6851, 7883.8584, 1725.4174);
	angles[54] = (0, 0, 0);
	at[54] = 8.4500;
	points[55] = (-5019.6851, 7883.8584, 1727.3149);
	angles[55] = (0, 0, 0);
	at[55] = 8.5000;
	points[56] = (-5019.6851, 7883.8584, 1723.6023);
	angles[56] = (0, 0, 0);
	at[56] = 8.5500;
	points[57] = (-5019.6851, 7883.8584, 1699.8466);
	angles[57] = (0, 0, 0);
	at[57] = 8.7000;
	points[58] = (-5019.6851, 7883.8584, 1697.9489);
	angles[58] = (0, 0, 0);
	at[58] = 8.7500;
	points[59] = (-5019.6851, 7883.8584, 1701.6614);
	angles[59] = (0, 0, 0);
	at[59] = 8.8000;
	points[60] = (-5019.6851, 7883.8584, 1709.5631);
	angles[60] = (0, 0, 0);
	at[60] = 8.8500;
	points[61] = (-5019.6851, 7883.8584, 1703.8110);
	angles[61] = (0, 0, 0);
	at[61] = 8.9000;
	points[62] = (-5019.6851, 7883.8584, 354.5213);
	angles[62] = (0, 0, 0);
	at[62] = 11.4500;
	mover = getEnt("iz_obj_22", "targetname");
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
