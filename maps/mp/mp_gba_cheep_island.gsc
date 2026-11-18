main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_gba_cheep_island", 0);

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
	ambientPlay("iz_0_46", 2);
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
	level.iz_route[level.iz_route.size] = (-12279, -208, 619);
	level.iz_route[level.iz_route.size] = (-12300, -1456, 619);
	level.iz_route[level.iz_route.size] = (-12315, -2668, 619);
	level.iz_route[level.iz_route.size] = (-12286, -3628, 619);
	level.iz_route[level.iz_route.size] = (-12278, -4100, 619);
	level.iz_route[level.iz_route.size] = (-12264, -4923, 619);
	level.iz_route[level.iz_route.size] = (-12292, -5435, 619);
	level.iz_route[level.iz_route.size] = (-12271, -6104, 619);
	level.iz_route[level.iz_route.size] = (-12208, -6815, 619);
	level.iz_route[level.iz_route.size] = (-11957, -7379, 619);
	level.iz_route[level.iz_route.size] = (-11351, -8069, 619);
	level.iz_route[level.iz_route.size] = (-10724, -8362, 619);
	level.iz_route[level.iz_route.size] = (-9999, -8339, 619);
	level.iz_route[level.iz_route.size] = (-9590, -8184, 619);
	level.iz_route[level.iz_route.size] = (-9042, -8213, 619);
	level.iz_route[level.iz_route.size] = (-8702, -8317, 619);
	level.iz_route[level.iz_route.size] = (-8376, -8569, 619);
	level.iz_route[level.iz_route.size] = (-8169, -8909, 619);
	level.iz_route[level.iz_route.size] = (-7917, -9101, 619);
	level.iz_route[level.iz_route.size] = (-7429, -9175, 619);
	level.iz_route[level.iz_route.size] = (-7015, -9205, 619);
	level.iz_route[level.iz_route.size] = (-6793, -8953, 619);
	level.iz_route[level.iz_route.size] = (-6511, -8657, 619);
	level.iz_route[level.iz_route.size] = (-6068, -8450, 619);
	level.iz_route[level.iz_route.size] = (-5535, -8406, 619);
	level.iz_route[level.iz_route.size] = (-4928, -8421, 619);
	level.iz_route[level.iz_route.size] = (-4351, -8495, 619);
	level.iz_route[level.iz_route.size] = (-3892, -8731, 619);
	level.iz_route[level.iz_route.size] = (-3463, -9027, 619);
	level.iz_route[level.iz_route.size] = (-2975, -9323, 619);
	level.iz_route[level.iz_route.size] = (-2655, -9536, 619);
	level.iz_route[level.iz_route.size] = (-2055, -9535, 619);
	level.iz_route[level.iz_route.size] = (-1526, -9532, 619);
	level.iz_route[level.iz_route.size] = (-873, -9522, 619);
	level.iz_route[level.iz_route.size] = (-105, -9595, 619);
	level.iz_route[level.iz_route.size] = (564, -9846, 619);
	level.iz_route[level.iz_route.size] = (1442, -10201, 619);
	level.iz_route[level.iz_route.size] = (2299, -10306, 619);
	level.iz_route[level.iz_route.size] = (3324, -10264, 619);
	level.iz_route[level.iz_route.size] = (4432, -10013, 619);
	level.iz_route[level.iz_route.size] = (5540, -9553, 619);
	level.iz_route[level.iz_route.size] = (6418, -8926, 619);
	level.iz_route[level.iz_route.size] = (6710, -8341, 619);
	level.iz_route[level.iz_route.size] = (6689, -7672, 619);
	level.iz_route[level.iz_route.size] = (6378, -7473, 619);
	level.iz_route[level.iz_route.size] = (5875, -7192, 619);
	level.iz_route[level.iz_route.size] = (5579, -6926, 619);
	level.iz_route[level.iz_route.size] = (5268, -6497, 619);
	level.iz_route[level.iz_route.size] = (5002, -5905, 619);
	level.iz_route[level.iz_route.size] = (4884, -5328, 619);
	level.iz_route[level.iz_route.size] = (4780, -4691, 619);
	level.iz_route[level.iz_route.size] = (4810, -4055, 619);
	level.iz_route[level.iz_route.size] = (5032, -3226, 619);
	level.iz_route[level.iz_route.size] = (5224, -2767, 619);
	level.iz_route[level.iz_route.size] = (5224, -2205, 619);
	level.iz_route[level.iz_route.size] = (5224, -1554, 619);
	level.iz_route[level.iz_route.size] = (5017, -1317, 619);
	level.iz_route[level.iz_route.size] = (4676, -1006, 619);
	level.iz_route[level.iz_route.size] = (4469, -577, 619);
	level.iz_route[level.iz_route.size] = (4321, -59, 619);
	level.iz_route[level.iz_route.size] = (4262, 503, 619);
	level.iz_route[level.iz_route.size] = (4262, 1140, 619);
	level.iz_route[level.iz_route.size] = (4247, 1879, 619);
	level.iz_route[level.iz_route.size] = (4262, 2605, 619);
	level.iz_route[level.iz_route.size] = (4454, 3152, 619);
	level.iz_route[level.iz_route.size] = (4810, 3655, 619);
	level.iz_route[level.iz_route.size] = (5239, 4188, 619);
	level.iz_route[level.iz_route.size] = (5535, 4736, 619);
	level.iz_route[level.iz_route.size] = (5816, 5150, 619);
	level.iz_route[level.iz_route.size] = (5816, 5594, 619);
	level.iz_route[level.iz_route.size] = (5816, 6038, 619);
	level.iz_route[level.iz_route.size] = (5816, 6467, 619);
	level.iz_route[level.iz_route.size] = (5860, 6793, 619);
	level.iz_route[level.iz_route.size] = (5934, 7177, 619);
	level.iz_route[level.iz_route.size] = (5994, 7636, 619);
	level.iz_route[level.iz_route.size] = (6068, 8213, 619);
	level.iz_route[level.iz_route.size] = (6008, 8643, 619);
	level.iz_route[level.iz_route.size] = (5846, 9116, 619);
	level.iz_route[level.iz_route.size] = (5456, 9637, 619);
	level.iz_route[level.iz_route.size] = (4954, 9971, 619);
	level.iz_route[level.iz_route.size] = (4400, 10049, 619);
	level.iz_route[level.iz_route.size] = (3893, 10034, 619);
	level.iz_route[level.iz_route.size] = (3537, 10034, 619);
	level.iz_route[level.iz_route.size] = (2975, 10048, 619);
	level.iz_route[level.iz_route.size] = (2412, 10048, 619);
	level.iz_route[level.iz_route.size] = (1894, 9900, 619);
	level.iz_route[level.iz_route.size] = (1361, 9649, 619);
	level.iz_route[level.iz_route.size] = (844, 9264, 619);
	level.iz_route[level.iz_route.size] = (400, 8731, 619);
	level.iz_route[level.iz_route.size] = (74, 8036, 619);
	level.iz_route[level.iz_route.size] = (-281, 7177, 619);
	level.iz_route[level.iz_route.size] = (-577, 6452, 619);
	level.iz_route[level.iz_route.size] = (-784, 5757, 619);
	level.iz_route[level.iz_route.size] = (-1000, 5127, 619);
	level.iz_route[level.iz_route.size] = (-1140, 4553, 619);
	level.iz_route[level.iz_route.size] = (-1121, 4065, 619);
	level.iz_route[level.iz_route.size] = (-1016, 3625, 619);
	level.iz_route[level.iz_route.size] = (-1006, 3185, 619);
	level.iz_route[level.iz_route.size] = (-1006, 2619, 619);
	level.iz_route[level.iz_route.size] = (-1006, 2242, 619);
	level.iz_route[level.iz_route.size] = (-1090, 1771, 619);
	level.iz_route[level.iz_route.size] = (-1289, 1467, 619);
	level.iz_route[level.iz_route.size] = (-1268, 1215, 619);
	level.iz_route[level.iz_route.size] = (-1393, 870, 619);
	level.iz_route[level.iz_route.size] = (-1634, 587, 619);
	level.iz_route[level.iz_route.size] = (-2074, 346, 619);
	level.iz_route[level.iz_route.size] = (-2682, 283, 619);
	level.iz_route[level.iz_route.size] = (-3185, 356, 619);
	level.iz_route[level.iz_route.size] = (-3698, 482, 619);
	level.iz_route[level.iz_route.size] = (-4327, 618, 619);
	level.iz_route[level.iz_route.size] = (-4882, 775, 619);
	level.iz_route[level.iz_route.size] = (-5301, 911, 619);
	level.iz_route[level.iz_route.size] = (-5710, 1173, 619);
	level.iz_route[level.iz_route.size] = (-6003, 1561, 619);
	level.iz_route[level.iz_route.size] = (-6097, 2022, 619);
	level.iz_route[level.iz_route.size] = (-5994, 2353, 619);
	level.iz_route[level.iz_route.size] = (-6008, 2738, 619);
	level.iz_route[level.iz_route.size] = (-6008, 3197, 619);
	level.iz_route[level.iz_route.size] = (-6008, 3581, 619);
	level.iz_route[level.iz_route.size] = (-5875, 3892, 619);
	level.iz_route[level.iz_route.size] = (-5619, 4076, 619);
	level.iz_route[level.iz_route.size] = (-5483, 4489, 619);
	level.iz_route[level.iz_route.size] = (-5453, 4881, 619);
	level.iz_route[level.iz_route.size] = (-5453, 5412, 619);
	level.iz_route[level.iz_route.size] = (-5468, 5918, 619);
	level.iz_route[level.iz_route.size] = (-5479, 6415, 619);
	level.iz_route[level.iz_route.size] = (-5462, 6817, 619);
	level.iz_route[level.iz_route.size] = (-5568, 7173, 619);
	level.iz_route[level.iz_route.size] = (-5918, 7520, 619);
	level.iz_route[level.iz_route.size] = (-5979, 7932, 619);
	level.iz_route[level.iz_route.size] = (-5979, 8391, 619);
	level.iz_route[level.iz_route.size] = (-5979, 9101, 619);
	level.iz_route[level.iz_route.size] = (-5994, 9678, 619);
	level.iz_route[level.iz_route.size] = (-5999, 10243, 619);
	level.iz_route[level.iz_route.size] = (-6167, 10494, 619);
	level.iz_route[level.iz_route.size] = (-6501, 10703, 619);
	level.iz_route[level.iz_route.size] = (-7254, 10703, 619);
	level.iz_route[level.iz_route.size] = (-7923, 10703, 619);
	level.iz_route[level.iz_route.size] = (-8529, 10661, 619);
	level.iz_route[level.iz_route.size] = (-9135, 10661, 619);
	level.iz_route[level.iz_route.size] = (-9846, 10640, 619);
	level.iz_route[level.iz_route.size] = (-10264, 10473, 619);
	level.iz_route[level.iz_route.size] = (-10473, 10013, 619);
	level.iz_route[level.iz_route.size] = (-10473, 9281, 619);
	level.iz_route[level.iz_route.size] = (-10473, 8278, 619);
	level.iz_route[level.iz_route.size] = (-10577, 7316, 619);
	level.iz_route[level.iz_route.size] = (-10995, 6146, 619);
	level.iz_route[level.iz_route.size] = (-11393, 5038, 619);
	level.iz_route[level.iz_route.size] = (-11790, 3951, 619);
	level.iz_route[level.iz_route.size] = (-11957, 2864, 619);
	level.iz_route[level.iz_route.size] = (-12145, 1693, 619);
	level.iz_route[level.iz_route.size] = (-12273, -99, 619);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-9097.5195, -1421.2480, 1830.7087);
	angles[0] = (0, -57.7822, 0);
	at[0] = 0;
	points[1] = (-9457.2441, -1647.9371, 1830.7087);
	angles[1] = (0, -58.0022, 0);
	at[1] = 1.2000;
	points[2] = (-9577.1650, -1723.5001, 1830.7087);
	angles[2] = (0, -61.4968, 0);
	at[2] = 1.6000;
	points[3] = (-9637.0869, -1761.2795, 1830.7087);
	angles[3] = (0, -72.9502, 0);
	at[3] = 1.8000;
	points[4] = (-9697.0469, -1799.0631, 1830.7087);
	angles[4] = (0, -114.4843, 0);
	at[4] = 2;
	points[5] = (-9764.0947, -1820.7521, 1830.7087);
	angles[5] = (0, -185.2894, 0);
	at[5] = 2.2000;
	points[6] = (-9832.4805, -1839.2913, 1830.7087);
	angles[6] = (0, -233.0491, 0);
	at[6] = 2.4000;
	points[7] = (-9900.8662, -1857.8307, 1830.7087);
	angles[7] = (0, -248.6237, 0);
	at[7] = 2.6000;
	points[8] = (-9969.2520, -1876.3661, 1830.7087);
	angles[8] = (0, -253.0793, 0);
	at[8] = 2.8000;
	points[9] = (-10242.8740, -1950.5237, 1830.7087);
	angles[9] = (0, -254.8237, 0);
	at[9] = 3.6000;
	points[10] = (-10313.2285, -1944.5984, 1830.7087);
	angles[10] = (0, -270, 0);
	at[10] = 3.8000;
	points[11] = (-10383.7012, -1937.1299, 1830.7087);
	angles[11] = (0, -274.3387, 0);
	at[11] = 4;
	points[12] = (-11017.9141, -1869.9292, 1830.7087);
	angles[12] = (0, -276.0480, 0);
	at[12] = 5.8000;
	points[13] = (-11086.3779, -1853.1458, 1830.7087);
	angles[13] = (0, -283.2339, 0);
	at[13] = 6;
	points[14] = (-11153.5049, -1830.4370, 1830.7087);
	angles[14] = (0, -287.1494, 0);
	at[14] = 6.2000;
	points[15] = (-11690.5117, -1648.7480, 1830.7087);
	angles[15] = (0, -288.6917, 0);
	at[15] = 7.8000;
	points[16] = (-11747.9531, -1607.6851, 1830.7087);
	angles[16] = (0, -301.7452, 0);
	at[16] = 8;
	points[17] = (-11804.6064, -1565.1063, 1830.7087);
	angles[17] = (0, -305.4650, 0);
	at[17] = 8.2000;
	points[18] = (-12257.7949, -1224.4725, 1830.7087);
	angles[18] = (0, -307.6645, 0);
	at[18] = 9.8000;
	points[19] = (-12358.9365, -1125.1221, 1830.7087);
	angles[19] = (0, -313.7581, 0);
	at[19] = 10.2000;
	points[20] = (-12865.1572, -629.3229, 1830.7087);
	angles[20] = (0, -315.8718, 0);
	at[20] = 12.2000;
	points[21] = (-12955.9844, -520.5236, 1830.7087);
	angles[21] = (0, -319.7997, 0);
	at[21] = 12.6000;
	points[22] = (-13455.5908, 77.8535, 1830.7087);
	angles[22] = (0, -320.1403, 0);
	at[22] = 14.8000;
	points[23] = (-13506.4961, 127.0240, 1830.7087);
	angles[23] = (0, -315.1738, 0);
	at[23] = 15;
	points[24] = (-13610.9844, 222.7961, 1830.7087);
	angles[24] = (0, -312.7230, 0);
	at[24] = 15.4000;
	points[25] = (-14133.3867, 701.6575, 1830.7087);
	angles[25] = (0, -312.5105, 0);
	at[25] = 17.4000;
	points[26] = (-14182.8340, 751.9724, 1830.7087);
	angles[26] = (0, -315.9143, 0);
	at[26] = 17.6000;
	points[27] = (-14223.3467, 810.1142, 1830.7087);
	angles[27] = (0, -322.5190, 0);
	at[27] = 17.8000;
	points[28] = (-14263.8584, 868.2520, 1830.7087);
	angles[28] = (0, -324.3886, 0);
	at[28] = 18;
	points[29] = (-14831.1816, 1682.1890, 1830.7087);
	angles[29] = (0, -325.1247, 0);
	at[29] = 20.8000;
	points[30] = (-14861.7725, 1745.0552, 1830.7087);
	angles[30] = (0, -333.8266, 0);
	at[30] = 21;
	points[31] = (-14881.5352, 1813.1143, 1830.7087);
	angles[31] = (0, -340.9854, 0);
	at[31] = 21.2000;
	points[32] = (-14901.2998, 1881.1693, 1830.7087);
	angles[32] = (0, -343.0127, 0);
	at[32] = 21.4000;
	points[33] = (-15118.6221, 2629.7834, 1830.7087);
	angles[33] = (0, -343.8108, 0);
	at[33] = 23.6000;
	points[34] = (-14861.2607, 1743.2245, 1830.7087);
	angles[34] = (0, -343.8108, 0);
	at[34] = 26.2000;
	points[35] = (-14830.0781, 1680.6221, 1830.7087);
	angles[35] = (0, -366.0316, 0);
	at[35] = 26.4000;
	points[36] = (-14789.5674, 1622.4844, 1830.7087);
	angles[36] = (0, -435.7658, 0);
	at[36] = 26.6000;
	points[37] = (-14749.0156, 1564.3466, 1830.7087);
	angles[37] = (0, -483.4106, 0);
	at[37] = 26.8000;
	points[38] = (-14708.5049, 1506.2087, 1830.7087);
	angles[38] = (0, -498.9343, 0);
	at[38] = 27;
	points[39] = (-14627.4805, 1389.9291, 1830.7087);
	angles[39] = (0, -504.6304, 0);
	at[39] = 27.4000;
	points[40] = (-14181.7324, 750.4095, 1830.7087);
	angles[40] = (0, -505.1247, 0);
	at[40] = 29.6000;
	points[41] = (-14131.9688, 700.3662, 1830.7087);
	angles[41] = (0, -496.9220, 0);
	at[41] = 29.8000;
	points[42] = (-14027.4805, 604.5945, 1830.7087);
	angles[42] = (0, -492.8625, 0);
	at[42] = 30.2000;
	points[43] = (-13454.3701, 76.3894, 1830.7087);
	angles[43] = (0, -494.5750, 0);
	at[43] = 32.4000;
	points[44] = (-13363.5430, -32.4067, 1830.7087);
	angles[44] = (0, -499.6963, 0);
	at[44] = 32.8000;
	points[45] = (-12863.9365, -630.7874, 1830.7087);
	angles[45] = (0, -500.1404, 0);
	at[45] = 35;
	points[46] = (-12763.3857, -730.5984, 1830.7087);
	angles[46] = (0, -494.8638, 0);
	at[46] = 35.4000;
	points[47] = (-12256.1025, -1225.4213, 1830.7087);
	angles[47] = (0, -494.2869, 0);
	at[47] = 37.4000;
	points[48] = (-12142.9922, -1310.7756, 1830.7087);
	angles[48] = (0, -487.5177, 0);
	at[48] = 37.8000;
	points[49] = (-11746.4561, -1608.8307, 1830.7087);
	angles[49] = (0, -486.9303, 0);
	at[49] = 39.2000;
	points[50] = (-11688.7012, -1649.3583, 1830.7087);
	angles[50] = (0, -483.5013, 0);
	at[50] = 39.4000;
	points[51] = (-11621.5742, -1672.0709, 1830.7087);
	angles[51] = (0, -472.8926, 0);
	at[51] = 39.6000;
	points[52] = (-11554.4492, -1694.7797, 1830.7087);
	angles[52] = (0, -469.8786, 0);
	at[52] = 39.8000;
	points[53] = (-11084.5674, -1853.7598, 1830.7087);
	angles[53] = (0, -468.6920, 0);
	at[53] = 41.2000;
	points[54] = (-11016.0244, -1870.1300, 1830.7087);
	angles[54] = (0, -463.5307, 0);
	at[54] = 41.4000;
	points[55] = (-10875.0781, -1885.0630, 1830.7087);
	angles[55] = (0, -456.6456, 0);
	at[55] = 41.8000;
	points[56] = (-10311.2998, -1944.7992, 1830.7087);
	angles[56] = (0, -456.0480, 0);
	at[56] = 43.4000;
	points[57] = (-10241.0244, -1950.0237, 1830.7087);
	angles[57] = (0, -452.0745, 0);
	at[57] = 43.6000;
	points[58] = (-10172.6387, -1931.4843, 1830.7087);
	angles[58] = (0, -439.7326, 0);
	at[58] = 43.8000;
	points[59] = (-10104.2129, -1912.9448, 1830.7087);
	angles[59] = (0, -436.2188, 0);
	at[59] = 44;
	points[60] = (-9762.2441, -1820.2521, 1830.7087);
	angles[60] = (0, -434.8374, 0);
	at[60] = 45;
	points[61] = (-9695.4336, -1798.0472, 1830.7087);
	angles[61] = (0, -430.2505, 0);
	at[61] = 45.2000;
	points[62] = (-9635.4727, -1760.2638, 1830.7087);
	angles[62] = (0, -421.3145, 0);
	at[62] = 45.4000;
	points[63] = (-9575.5508, -1722.4843, 1830.7087);
	angles[63] = (0, -418.7801, 0);
	at[63] = 45.6000;
	points[64] = (-9095.9053, -1420.2322, 1830.7087);
	angles[64] = (0, -417.7821, 0);
	at[64] = 47.2000;
	points[65] = (-9097.5195, -1421.2480, 1830.7087);
	angles[65] = (0, -417.7821, 0);
	at[65] = 47.2333;
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
	points[0] = (1086.6851, -7054.2520, 1830.7087);
	angles[0] = (0, 22.4552, 0);
	at[0] = 0;
	points[1] = (1411.5000, -7840.1577, 1830.7087);
	angles[1] = (0, 21.6117, 0);
	at[1] = 2.4000;
	points[2] = (1463.5906, -7932.8350, 1830.7087);
	angles[2] = (0, -28.0502, 0);
	at[2] = 2.7000;
	points[3] = (1515.4922, -8025.5908, 1830.7087);
	angles[3] = (0, -122.1423, 0);
	at[3] = 3;
	points[4] = (1567.3898, -8118.3857, 1830.7087);
	angles[4] = (0, -146.4019, 0);
	at[4] = 3.3000;
	points[5] = (1671.1929, -8303.8984, 1830.7087);
	angles[5] = (0, -150.6763, 0);
	at[5] = 3.9000;
	points[6] = (2086.3899, -9046.0635, 1830.7087);
	angles[6] = (0, -150.7749, 0);
	at[6] = 6.3000;
	points[7] = (2087.5591, -9150.9844, 1830.7087);
	angles[7] = (0, -176.8840, 0);
	at[7] = 6.6000;
	points[8] = (2083.3977, -9257.2051, 1830.7087);
	angles[8] = (0, -181.4384, 0);
	at[8] = 6.9000;
	points[9] = (2041.7914, -10319.3701, 1830.7087);
	angles[9] = (0, -182.2432, 0);
	at[9] = 9.9000;
	points[10] = (2017.7559, -10422.2441, 1830.7087);
	angles[10] = (0, -193.5311, 0);
	at[10] = 10.2000;
	points[11] = (1986.8584, -10523.9766, 1830.7087);
	angles[11] = (0, -196.3929, 0);
	at[11] = 10.5000;
	points[12] = (1585.1733, -11846.1816, 1830.7087);
	angles[12] = (0, -196.8985, 0);
	at[12] = 14.4000;
	points[13] = (1513.2875, -11923.8584, 1830.7087);
	angles[13] = (0, -219.7388, 0);
	at[13] = 14.7000;
	points[14] = (1439.6497, -12000.5508, 1830.7087);
	angles[14] = (0, -223.2295, 0);
	at[14] = 15;
	points[15] = (703.2913, -12767.1660, 1830.7087);
	angles[15] = (0, -223.8462, 0);
	at[15] = 18;
	points[16] = (616.4016, -12823.7002, 1830.7087);
	angles[16] = (0, -240.4068, 0);
	at[16] = 18.3000;
	points[17] = (516.8701, -12861.0244, 1830.7087);
	angles[17] = (0, -248.0851, 0);
	at[17] = 18.6000;
	points[18] = (417.3386, -12898.3467, 1830.7087);
	angles[18] = (0, -249.2399, 0);
	at[18] = 18.9000;
	points[19] = (-279.3780, -13159.6064, 1830.7087);
	angles[19] = (0, -249.4438, 0);
	at[19] = 21;
	points[20] = (-381.2331, -13188.4648, 1830.7087);
	angles[20] = (0, -255.8259, 0);
	at[20] = 21.3000;
	points[21] = (-590.5197, -13225.8271, 1830.7087);
	angles[21] = (0, -259.7843, 0);
	at[21] = 21.9000;
	points[22] = (-1427.6692, -13375.3154, 1830.7087);
	angles[22] = (0, -259.8755, 0);
	at[22] = 24.3000;
	points[23] = (-1531.9371, -13381.2207, 1830.7087);
	angles[23] = (0, -270.8343, 0);
	at[23] = 24.6000;
	points[24] = (-1635.3032, -13356.4170, 1830.7087);
	angles[24] = (0, -281.5889, 0);
	at[24] = 24.9000;
	points[25] = (-2462.2126, -13157.9531, 1830.7087);
	angles[25] = (0, -283.4956, 0);
	at[25] = 27.3000;
	points[26] = (-2563.3425, -13127.4805, 1830.7087);
	angles[26] = (0, -288.9586, 0);
	at[26] = 27.6000;
	points[27] = (-2655.8818, -13075.1582, 1830.7087);
	angles[27] = (0, -297.8936, 0);
	at[27] = 27.9000;
	points[28] = (-2748.4211, -13022.8740, 1830.7087);
	angles[28] = (0, -299.2384, 0);
	at[28] = 28.2000;
	points[29] = (-3488.7441, -12604.4102, 1830.7087);
	angles[29] = (0, -299.4758, 0);
	at[29] = 30.6000;
	points[30] = (-3572.3899, -12539.1729, 1830.7087);
	angles[30] = (0, -307.6872, 0);
	at[30] = 30.9000;
	points[31] = (-3654.3425, -12471.4570, 1830.7087);
	angles[31] = (0, -309.2786, 0);
	at[31] = 31.2000;
	points[32] = (-4391.9292, -11862.1660, 1830.7087);
	angles[32] = (0, -309.5598, 0);
	at[32] = 33.9000;
	points[33] = (-4453.7402, -11811.1035, 1830.7087);
	angles[33] = (0, -309.5598, 0);
	at[33] = 34.2000;
	points[34] = (-3552.2561, -12555.8271, 1830.7087);
	angles[34] = (0, -309.5598, 0);
	at[34] = 37.5000;
	points[35] = (-3466.0117, -12617.2842, 1830.7087);
	angles[35] = (0, -324.9250, 0);
	at[35] = 37.8000;
	points[36] = (-3373.4685, -12669.5674, 1830.7087);
	angles[36] = (0, -419.6557, 0);
	at[36] = 38.1000;
	points[37] = (-3280.9292, -12721.8896, 1830.7087);
	angles[37] = (0, -469.7492, 0);
	at[37] = 38.4000;
	points[38] = (-3188.3899, -12774.1729, 1830.7087);
	angles[38] = (0, -478.0131, 0);
	at[38] = 38.7000;
	points[39] = (-3095.8503, -12826.4961, 1830.7087);
	angles[39] = (0, -479.2563, 0);
	at[39] = 39;
	points[40] = (-2540.6064, -13140.3154, 1830.7087);
	angles[40] = (0, -477.8927, 0);
	at[40] = 40.8000;
	points[41] = (-2436.8188, -13164.0557, 1830.7087);
	angles[41] = (0, -465.6660, 0);
	at[41] = 41.1000;
	points[42] = (-2333.4526, -13188.8584, 1830.7087);
	angles[42] = (0, -463.8216, 0);
	at[42] = 41.4000;
	points[43] = (-1506.5433, -13387.3232, 1830.7087);
	angles[43] = (0, -463.4958, 0);
	at[43] = 43.8000;
	points[44] = (-1401.9606, -13370.7480, 1830.7087);
	angles[44] = (0, -443.4627, 0);
	at[44] = 44.1000;
	points[45] = (-1297.3190, -13352.0469, 1830.7087);
	angles[45] = (0, -440.4140, 0);
	at[45] = 44.4000;
	points[46] = (-355.5244, -13183.8975, 1830.7087);
	angles[46] = (0, -439.8755, 0);
	at[46] = 47.1000;
	points[47] = (-254.9260, -13150.4326, 1830.7087);
	angles[47] = (0, -431.5963, 0);
	at[47] = 47.4000;
	points[48] = (-155.3949, -13113.1104, 1830.7087);
	angles[48] = (0, -429.7669, 0);
	at[48] = 47.7000;
	points[49] = (640.8544, -12814.5283, 1830.7087);
	angles[49] = (0, -429.4439, 0);
	at[49] = 50.1000;
	points[50] = (721.3818, -12748.3467, 1830.7087);
	angles[50] = (0, -409.7812, 0);
	at[50] = 50.4000;
	points[51] = (795.0157, -12671.6533, 1830.7087);
	angles[51] = (0, -404.7376, 0);
	at[51] = 50.7000;
	points[52] = (868.6536, -12595, 1830.7087);
	angles[52] = (0, -403.9800, 0);
	at[52] = 51;
	points[53] = (1531.3779, -11905.0391, 1830.7087);
	angles[53] = (0, -403.8462, 0);
	at[53] = 53.7000;
	points[54] = (1592.7638, -11821.1807, 1830.7087);
	angles[54] = (0, -391.3814, 0);
	at[54] = 54;
	points[55] = (1623.6615, -11719.4883, 1830.7087);
	angles[55] = (0, -379.0818, 0);
	at[55] = 54.3000;
	points[56] = (1654.5631, -11617.7959, 1830.7087);
	angles[56] = (0, -377.2262, 0);
	at[56] = 54.6000;
	points[57] = (2025.3466, -10397.2441, 1830.7087);
	angles[57] = (0, -376.8985, 0);
	at[57] = 58.2000;
	points[58] = (2042.8112, -10293.3076, 1830.7087);
	angles[58] = (0, -367.3739, 0);
	at[58] = 58.5000;
	points[59] = (2051.1338, -10080.8652, 1830.7087);
	angles[59] = (0, -362.3589, 0);
	at[59] = 59.1000;
	points[60] = (2088.5789, -9124.8818, 1830.7087);
	angles[60] = (0, -362.2432, 0);
	at[60] = 61.8000;
	points[61] = (2073.6377, -9023.2676, 1830.7087);
	angles[61] = (0, -346.0772, 0);
	at[61] = 62.1000;
	points[62] = (2021.7362, -8930.4727, 1830.7087);
	angles[62] = (0, -333.0830, 0);
	at[62] = 62.4000;
	points[63] = (1969.8386, -8837.7168, 1830.7087);
	angles[63] = (0, -331.1214, 0);
	at[63] = 62.7000;
	points[64] = (1450.8425, -7910.0391, 1830.7087);
	angles[64] = (0, -330.7749, 0);
	at[64] = 65.7000;
	points[65] = (1401.5276, -7816.0234, 1830.7087);
	angles[65] = (0, -333.5446, 0);
	at[65] = 66;
	points[66] = (1360.9253, -7717.7954, 1830.7087);
	angles[66] = (0, -336.9442, 0);
	at[66] = 66.3000;
	points[67] = (1117.3110, -7128.3467, 1830.7087);
	angles[67] = (0, -337.5448, 0);
	at[67] = 68.1000;
	points[68] = (1086.6851, -7054.2520, 1830.7087);
	angles[68] = (0, -337.5448, 0);
	at[68] = 68.3667;
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
	points[0] = (3457.2402, 7837.5195, 1830.7087);
	angles[0] = (0, -50.9678, 0);
	at[0] = 0;
	points[1] = (3136.1260, 7577.2046, 1830.7087);
	angles[1] = (0, -51.0886, 0);
	at[1] = 1.1667;
	points[2] = (3007.6814, 7473.0708, 1830.7087);
	angles[2] = (0, -54.2410, 0);
	at[2] = 1.6333;
	points[3] = (2943.4568, 7420.9844, 1830.7087);
	angles[3] = (0, -67.8542, 0);
	at[3] = 1.8667;
	points[4] = (2879.2363, 7368.9375, 1830.7087);
	angles[4] = (0, -124.9224, 0);
	at[4] = 2.1000;
	points[5] = (2807.8977, 7328.0317, 1830.7087);
	angles[5] = (0, -204.4449, 0);
	at[5] = 2.3333;
	points[6] = (2733.5195, 7291.9292, 1830.7087);
	angles[6] = (0, -234.7315, 0);
	at[6] = 2.5667;
	points[7] = (2659.1416, 7255.8271, 1830.7087);
	angles[7] = (0, -241.9585, 0);
	at[7] = 2.8000;
	points[8] = (2584.7678, 7219.7246, 1830.7087);
	angles[8] = (0, -243.6156, 0);
	at[8] = 3.0333;
	points[9] = (2064.1221, 6967.0083, 1830.7087);
	angles[9] = (0, -244.1071, 0);
	at[9] = 4.6667;
	points[10] = (1988.1536, 6936.2202, 1830.7087);
	angles[10] = (0, -249.0338, 0);
	at[10] = 4.9000;
	points[11] = (1906.1930, 6925.3545, 1830.7087);
	angles[11] = (0, -259.3721, 0);
	at[11] = 5.1333;
	points[12] = (1824.2323, 6914.4883, 1830.7087);
	angles[12] = (0, -261.7483, 0);
	at[12] = 5.3667;
	points[13] = (1168.5433, 6827.5986, 1830.7087);
	angles[13] = (0, -262.4534, 0);
	at[13] = 7.2333;
	points[14] = (1087.5040, 6825.5903, 1830.7087);
	angles[14] = (0, -271.5999, 0);
	at[14] = 7.4667;
	points[15] = (1009.5787, 6853.1890, 1830.7087);
	angles[15] = (0, -285.3897, 0);
	at[15] = 7.7000;
	points[16] = (931.6497, 6880.8267, 1830.7087);
	angles[16] = (0, -288.5710, 0);
	at[16] = 7.9333;
	points[17] = (230.3000, 7129.3701, 1830.7087);
	angles[17] = (0, -291.1706, 0);
	at[17] = 10.0333;
	points[18] = (164.0996, 7179.1733, 1830.7087);
	angles[18] = (0, -302.7785, 0);
	at[18] = 10.2667;
	points[19] = (97.4185, 7228.0312, 1830.7087);
	angles[19] = (0, -305.4497, 0);
	at[19] = 10.5000;
	points[20] = (-769.4331, 7863.4644, 1830.7087);
	angles[20] = (0, -306.2423, 0);
	at[20] = 13.5333;
	points[21] = (-826.1614, 7922.4019, 1830.7087);
	angles[21] = (0, -316.5534, 0);
	at[21] = 13.7667;
	points[22] = (-925.3740, 8054.6855, 1830.7087);
	angles[22] = (0, -322.7856, 0);
	at[22] = 14.2333;
	points[23] = (-1570.2520, 8914.5273, 1830.7087);
	angles[23] = (0, -323.1301, 0);
	at[23] = 17.2667;
	points[24] = (-1608.6299, 8986.6924, 1830.7087);
	angles[24] = (0, -332.9627, 0);
	at[24] = 17.5000;
	points[25] = (-1636.2756, 9064.6064, 1830.7087);
	angles[25] = (0, -338.7455, 0);
	at[25] = 17.7333;
	points[26] = (-1912.7559, 9843.7793, 1830.7087);
	angles[26] = (0, -340.4633, 0);
	at[26] = 20.0667;
	points[27] = (-1912.1222, 9924.9219, 1830.7087);
	angles[27] = (0, -358.2341, 0);
	at[27] = 20.3000;
	points[28] = (-1902.7362, 10007.0869, 1830.7087);
	angles[28] = (0, -364.6217, 0);
	at[28] = 20.5333;
	points[29] = (-1808.8583, 10828.5039, 1830.7087);
	angles[29] = (0, -366.5198, 0);
	at[29] = 22.8667;
	points[30] = (-1791.3109, 10907.0479, 1830.7087);
	angles[30] = (0, -375.5398, 0);
	at[30] = 23.1000;
	points[31] = (-1737.1615, 10969.5283, 1830.7087);
	angles[31] = (0, -395.0325, 0);
	at[31] = 23.3333;
	points[32] = (-1683.0157, 11032.0088, 1830.7087);
	angles[32] = (0, -399.5679, 0);
	at[32] = 23.5667;
	points[33] = (-1033.2402, 11781.7715, 1830.7087);
	angles[33] = (0, -400.9143, 0);
	at[33] = 26.3667;
	points[34] = (-1791.5316, 10906.8105, 1830.7087);
	angles[34] = (0, -400.9143, 0);
	at[34] = 29.6333;
	points[35] = (-1808.8976, 10828.1494, 1830.7087);
	angles[35] = (0, -467.4929, 0);
	at[35] = 29.8667;
	points[36] = (-1818.2834, 10746.0244, 1830.7087);
	angles[36] = (0, -525.6787, 0);
	at[36] = 30.1000;
	points[37] = (-1827.6733, 10663.8984, 1830.7087);
	angles[37] = (0, -541.7095, 0);
	at[37] = 30.3333;
	points[38] = (-1846.4449, 10499.6064, 1830.7087);
	angles[38] = (0, -546.2679, 0);
	at[38] = 30.8000;
	points[39] = (-1912.1615, 9924.6064, 1830.7087);
	angles[39] = (0, -546.5198, 0);
	at[39] = 32.4333;
	points[40] = (-1912.6417, 9843.4648, 1830.7087);
	angles[40] = (0, -537.7017, 0);
	at[40] = 32.6667;
	points[41] = (-1884.9960, 9765.5508, 1830.7087);
	angles[41] = (0, -524.4308, 0);
	at[41] = 32.9000;
	points[42] = (-1857.3466, 9687.6377, 1830.7087);
	angles[42] = (0, -521.3713, 0);
	at[42] = 33.1333;
	points[43] = (-1608.5157, 8986.3779, 1830.7087);
	angles[43] = (0, -520.4633, 0);
	at[43] = 35.2333;
	points[44] = (-1570.0472, 8914.2520, 1830.7087);
	angles[44] = (0, -511.4619, 0);
	at[44] = 35.4667;
	points[45] = (-1520.4410, 8848.1104, 1830.7087);
	angles[45] = (0, -505.0388, 0);
	at[45] = 35.7000;
	points[46] = (-1470.8346, 8781.9688, 1830.7087);
	angles[46] = (0, -503.5668, 0);
	at[46] = 35.9333;
	points[47] = (-825.9567, 7922.1260, 1830.7087);
	angles[47] = (0, -503.1301, 0);
	at[47] = 38.9667;
	points[48] = (-769.1575, 7863.2681, 1830.7087);
	angles[48] = (0, -495.2567, 0);
	at[48] = 39.2000;
	points[49] = (-702.4764, 7814.4092, 1830.7087);
	angles[49] = (0, -488.3080, 0);
	at[49] = 39.4333;
	points[50] = (-635.7953, 7765.5122, 1830.7087);
	angles[50] = (0, -486.7150, 0);
	at[50] = 39.6667;
	points[51] = (231.0547, 7130.0791, 1830.7087);
	angles[51] = (0, -486.2424, 0);
	at[51] = 42.7000;
	points[52] = (308.5480, 7101.6538, 1830.7087);
	angles[52] = (0, -473.3636, 0);
	at[52] = 42.9333;
	points[53] = (386.4756, 7074.0156, 1830.7087);
	angles[53] = (0, -470.3958, 0);
	at[53] = 43.1667;
	points[54] = (1087.8268, 6825.4727, 1830.7087);
	angles[54] = (0, -469.5150, 0);
	at[54] = 45.2667;
	points[55] = (1168.8781, 6827.6772, 1830.7087);
	angles[55] = (0, -451.0678, 0);
	at[55] = 45.5000;
	points[56] = (1250.8425, 6838.5039, 1830.7087);
	angles[56] = (0, -444.4270, 0);
	at[56] = 45.7333;
	points[57] = (1988.4922, 6936.2598, 1830.7087);
	angles[57] = (0, -442.4532, 0);
	at[57] = 47.8333;
	points[58] = (2064.4292, 6967.1655, 1830.7087);
	angles[58] = (0, -429.3233, 0);
	at[58] = 48.0667;
	points[59] = (2138.8071, 7003.2676, 1830.7087);
	angles[59] = (0, -425.3011, 0);
	at[59] = 48.3000;
	points[60] = (2808.2048, 7328.1890, 1830.7087);
	angles[60] = (0, -424.1073, 0);
	at[60] = 50.4000;
	points[61] = (2879.5000, 7369.1338, 1830.7087);
	angles[61] = (0, -418.7452, 0);
	at[61] = 50.6333;
	points[62] = (2943.7205, 7421.2202, 1830.7087);
	angles[62] = (0, -412.7490, 0);
	at[62] = 50.8667;
	points[63] = (3007.9451, 7473.2676, 1830.7087);
	angles[63] = (0, -411.3752, 0);
	at[63] = 51.1000;
	points[64] = (3457.5042, 7837.7559, 1830.7087);
	angles[64] = (0, -410.9678, 0);
	at[64] = 52.7333;
	points[65] = (3457.2402, 7837.5195, 1830.7087);
	angles[65] = (0, -410.9678, 0);
	at[65] = 52.7667;
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
	points[0] = (-3590.8191, -2456.3542, 1830.7087);
	angles[0] = (0, -139.1061, 0);
	at[0] = 0;
	points[1] = (-3938.7795, -2054.5828, 1830.7087);
	angles[1] = (0, -140.6103, 0);
	at[1] = 1.5000;
	points[2] = (-3996.7717, -1987.6221, 1830.7087);
	angles[2] = (0, -147.8882, 0);
	at[2] = 1.7500;
	points[3] = (-4054.7637, -1920.6615, 1830.7087);
	angles[3] = (0, -187.0613, 0);
	at[3] = 2;
	points[4] = (-4104.2520, -1847.7638, 1830.7087);
	angles[4] = (0, -276.0103, 0);
	at[4] = 2.2500;
	points[5] = (-4147.0474, -1770.2205, 1830.7087);
	angles[5] = (0, -318.9810, 0);
	at[5] = 2.5000;
	points[6] = (-4189.8818, -1692.6771, 1830.7087);
	angles[6] = (0, -328.5903, 0);
	at[6] = 2.7500;
	points[7] = (-4404.0156, -1304.9529, 1830.7087);
	angles[7] = (0, -331.0902, 0);
	at[7] = 4;
	points[8] = (-4444.7642, -1226.7008, 1830.7087);
	angles[8] = (0, -334.8494, 0);
	at[8] = 4.2500;
	points[9] = (-4458.4253, -1139.1812, 1830.7087);
	angles[9] = (0, -347.7556, 0);
	at[9] = 4.5000;
	points[10] = (-4472.0869, -1051.6575, 1830.7087);
	angles[10] = (0, -350.4310, 0);
	at[10] = 4.7500;
	points[11] = (-4581.4170, -351.4803, 1830.7087);
	angles[11] = (0, -351.1249, 0);
	at[11] = 6.7500;
	points[12] = (-4590.6694, -263.7185, 1830.7087);
	angles[12] = (0, -355.0871, 0);
	at[12] = 7;
	points[13] = (-4586.5356, -175.2331, 1830.7087);
	angles[13] = (0, -361.1165, 0);
	at[13] = 7.2500;
	points[14] = (-4582.3623, -86.7472, 1830.7087);
	angles[14] = (0, -362.3597, 0);
	at[14] = 7.5000;
	points[15] = (-4540.9053, 798.1102, 1830.7087);
	angles[15] = (0, -362.6821, 0);
	at[15] = 10;
	points[16] = (-4525, 885, 1830.7087);
	angles[16] = (0, -369.8996, 0);
	at[16] = 10.2500;
	points[17] = (-4505.4331, 971.3976, 1830.7087);
	angles[17] = (0, -372.1617, 0);
	at[17] = 10.5000;
	points[18] = (-4309.9604, 1835.3898, 1830.7087);
	angles[18] = (0, -373.6251, 0);
	at[18] = 13;
	points[19] = (-4276.7324, 1917.5669, 1830.7087);
	angles[19] = (0, -379.9091, 0);
	at[19] = 13.2500;
	points[20] = (-4244.2129, 1999.9646, 1830.7087);
	angles[20] = (0, -381.2050, 0);
	at[20] = 13.5000;
	points[21] = (-3886.4409, 2906.3191, 1830.7087);
	angles[21] = (0, -381.5410, 0);
	at[21] = 16.2500;
	points[22] = (-3858.7324, 2990.2598, 1830.7087);
	angles[22] = (0, -377.6290, 0);
	at[22] = 16.5000;
	points[23] = (-3815.7639, 3162.1338, 1830.7087);
	angles[23] = (0, -374.1886, 0);
	at[23] = 17;
	points[24] = (-3643.8899, 3849.6379, 1830.7087);
	angles[24] = (0, -374.0363, 0);
	at[24] = 19;
	points[25] = (-3635.0513, 3936.6179, 1830.7087);
	angles[25] = (0, -364.3469, 0);
	at[25] = 19.2500;
	points[26] = (-3642.2087, 4024.9214, 1830.7087);
	angles[26] = (0, -357.2170, 0);
	at[26] = 19.5000;
	points[27] = (-3649.3662, 4113.1890, 1830.7087);
	angles[27] = (0, -355.7460, 0);
	at[27] = 19.7500;
	points[28] = (-3721.8899, 4995.9844, 1830.7087);
	angles[28] = (0, -353.6521, 0);
	at[28] = 22.2500;
	points[29] = (-3742.8269, 5082.0474, 1830.7087);
	angles[29] = (0, -347.8381, 0);
	at[29] = 22.5000;
	points[30] = (-3763.7639, 5168.1104, 1830.7087);
	angles[30] = (0, -346.6395, 0);
	at[30] = 22.7500;
	points[31] = (-3973.1104, 6028.8584, 1830.7087);
	angles[31] = (0, -346.3287, 0);
	at[31] = 25.2500;
	points[32] = (-3999.4094, 6113.1499, 1830.7087);
	angles[32] = (0, -341.7847, 0);
	at[32] = 25.5000;
	points[33] = (-4069.7246, 6275.7485, 1830.7087);
	angles[33] = (0, -336.8340, 0);
	at[33] = 26;
	points[34] = (-4456.4565, 7170.1182, 1830.7087);
	angles[34] = (0, -336.6148, 0);
	at[34] = 28.7500;
	points[35] = (-4425.8267, 7099.2915, 1830.7087);
	angles[35] = (0, -336.6148, 0);
	at[35] = 29;
	points[36] = (-4214.8818, 6611.4565, 1830.7087);
	angles[36] = (0, -338.7917, 0);
	at[36] = 30.5000;
	points[37] = (-4179.7246, 6530.1572, 1830.7087);
	angles[37] = (0, -349.2938, 0);
	at[37] = 30.7500;
	points[38] = (-4144.5669, 6448.8579, 1830.7087);
	angles[38] = (0, -401.6625, 0);
	at[38] = 31;
	points[39] = (-4109.4092, 6367.5586, 1830.7087);
	angles[39] = (0, -482.8122, 0);
	at[39] = 31.2500;
	points[40] = (-4074.2520, 6286.2603, 1830.7087);
	angles[40] = (0, -509.4869, 0);
	at[40] = 31.5000;
	points[41] = (-4039.0947, 6204.9609, 1830.7087);
	angles[41] = (0, -515.1458, 0);
	at[41] = 31.7500;
	points[42] = (-4003.9370, 6123.6221, 1830.7087);
	angles[42] = (0, -516.3124, 0);
	at[42] = 32;
	points[43] = (-3975.8269, 6039.9604, 1830.7087);
	angles[43] = (0, -522.0776, 0);
	at[43] = 32.2500;
	points[44] = (-3933.9568, 5867.8345, 1830.7087);
	angles[44] = (0, -526.1484, 0);
	at[44] = 32.7500;
	points[45] = (-3724.5906, 5007.0869, 1830.7087);
	angles[45] = (0, -526.3287, 0);
	at[45] = 35.2500;
	points[46] = (-3714.7205, 4919.2520, 1830.7087);
	angles[46] = (0, -533.0640, 0);
	at[46] = 35.5000;
	points[47] = (-3707.5630, 4830.9448, 1830.7087);
	angles[47] = (0, -534.8908, 0);
	at[47] = 35.7500;
	points[48] = (-3635.9724, 3948.0315, 1830.7087);
	angles[48] = (0, -535.3646, 0);
	at[48] = 38.2500;
	points[49] = (-3641.1143, 3860.7322, 1830.7087);
	angles[49] = (0, -545.0539, 0);
	at[49] = 38.5000;
	points[50] = (-3662.6023, 3774.7952, 1830.7087);
	angles[50] = (0, -552.1838, 0);
	at[50] = 38.7500;
	points[51] = (-3684.0867, 3688.8582, 1830.7087);
	angles[51] = (0, -553.6548, 0);
	at[51] = 39;
	points[52] = (-3855.9607, 3001.3542, 1830.7087);
	angles[52] = (0, -554.0362, 0);
	at[52] = 41;
	points[53] = (-3882.2441, 2916.9526, 1830.7087);
	angles[53] = (0, -557.9481, 0);
	at[53] = 41.2500;
	points[54] = (-3947.2837, 2752.1614, 1830.7087);
	angles[54] = (0, -561.3886, 0);
	at[54] = 41.7500;
	points[55] = (-4305.0786, 1845.8071, 1830.7087);
	angles[55] = (0, -561.5410, 0);
	at[55] = 44.5000;
	points[56] = (-4327.0078, 1760.1417, 1830.7087);
	angles[56] = (0, -554.9868, 0);
	at[56] = 44.7500;
	points[57] = (-4346.5356, 1673.7441, 1830.7087);
	angles[57] = (0, -553.2092, 0);
	at[57] = 45;
	points[58] = (-4522.4805, 896.1496, 1830.7087);
	angles[58] = (0, -552.7484, 0);
	at[58] = 47.2500;
	points[59] = (-4540.3936, 809.5315, 1830.7087);
	angles[59] = (0, -550.8418, 0);
	at[59] = 47.5000;
	points[60] = (-4544.5278, 721.0472, 1830.7087);
	angles[60] = (0, -544.3644, 0);
	at[60] = 47.7500;
	points[61] = (-4548.6616, 632.5630, 1830.7087);
	angles[61] = (0, -543.0284, 0);
	at[61] = 48;
	points[62] = (-4590.1182, -252.2965, 1830.7087);
	angles[62] = (0, -542.6821, 0);
	at[62] = 50.5000;
	points[63] = (-4583.1890, -340.1823, 1830.7087);
	angles[63] = (0, -535.1648, 0);
	at[63] = 50.7500;
	points[64] = (-4555.8662, -515.2244, 1830.7087);
	angles[64] = (0, -531.2963, 0);
	at[64] = 51.2500;
	points[65] = (-4446.5356, -1215.4055, 1830.7087);
	angles[65] = (0, -531.1249, 0);
	at[65] = 53.2500;
	points[66] = (-4409.5273, -1294.9449, 1830.7087);
	angles[66] = (0, -516.2248, 0);
	at[66] = 53.5000;
	points[67] = (-4323.8979, -1450.0315, 1830.7087);
	angles[67] = (0, -511.3089, 0);
	at[67] = 54;
	points[68] = (-4109.7637, -1837.7560, 1830.7087);
	angles[68] = (0, -511.0912, 0);
	at[68] = 55.2500;
	points[69] = (-4062.2441, -1912.0157, 1830.7087);
	angles[69] = (0, -506.1974, 0);
	at[69] = 55.5000;
	points[70] = (-4004.2520, -1978.9763, 1830.7087);
	angles[70] = (0, -500.5676, 0);
	at[70] = 55.7500;
	points[71] = (-3946.2600, -2045.9409, 1830.7087);
	angles[71] = (0, -499.4070, 0);
	at[71] = 56;
	points[72] = (-3598.3074, -2447.7087, 1830.7087);
	angles[72] = (0, -499.1061, 0);
	at[72] = 57.5000;
	points[73] = (-3590.8191, -2456.3542, 1830.7087);
	angles[73] = (0, -499.1061, 0);
	at[73] = 57.5667;
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
	points[0] = (-5696.7715, -8330.7090, 618.8976);
	angles[0] = (0, -62.2946, 0);
	at[0] = 0;
	points[1] = (-5474.3701, -8754.2129, 618.8976);
	angles[1] = (0, -62.2946, 0);
	at[1] = 1.8000;
	points[2] = (-5470.2363, -8762.0469, 618.8976);
	angles[2] = (0, 87.1999, 0);
	at[2] = 1.8500;
	points[3] = (-5470.2363, -8762.0469, 618.8976);
	angles[3] = (0, 87.1999, 0);
	at[3] = 2.5500;
	points[4] = (-5471.1025, -8752.7949, 618.8976);
	angles[4] = (0, 87.1999, 0);
	at[4] = 2.6000;
	points[5] = (-5442.5200, -8168.8193, 618.8976);
	angles[5] = (0, 87.1999, 0);
	at[5] = 4.8000;
	points[6] = (-5442.5200, -8168.8193, 618.8976);
	angles[6] = (0, 87.1999, 0);
	at[6] = 5.5500;
	points[7] = (-5471.1025, -8752.9922, 618.8976);
	angles[7] = (0, 87.1999, 0);
	at[7] = 7.7500;
	points[8] = (-5471.5356, -8761.8506, 618.8976);
	angles[8] = (0, -62.2946, 0);
	at[8] = 7.8000;
	points[9] = (-5471.5356, -8761.8506, 618.8976);
	angles[9] = (0, -62.2946, 0);
	at[9] = 8.5000;
	points[10] = (-5474.4487, -8754.0156, 618.8976);
	angles[10] = (0, -62.2946, 0);
	at[10] = 8.5500;
	points[11] = (-5696.8506, -8330.5117, 618.8976);
	angles[11] = (0, -62.2946, 0);
	at[11] = 10.3500;
	points[12] = (-5698.8975, -8326.5752, 618.8976);
	angles[12] = (0, -62.2946, 0);
	at[12] = 10.4000;
	points[13] = (-5698.8975, -8326.5752, 618.8976);
	angles[13] = (0, -62.2946, 0);
	at[13] = 11.8500;
	points[14] = (-5696.7715, -8330.7090, 618.8976);
	angles[14] = (0, -62.2946, 0);
	at[14] = 11.8833;
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
	points[0] = (-4751.0630, -10131.2988, 618.8976);
	angles[0] = (0, -49.3470, 0);
	at[0] = 0;
	points[1] = (-4534.6455, -10383.3467, 618.8976);
	angles[1] = (0, -49.3470, 0);
	at[1] = 1.2500;
	points[2] = (-4531.7720, -10386.6924, 618.8976);
	angles[2] = (0, 82.6782, 0);
	at[2] = 1.3000;
	points[3] = (-4531.7720, -10386.6924, 618.8976);
	angles[3] = (0, 82.6782, 0);
	at[3] = 2;
	points[4] = (-4532.5986, -10371.2598, 618.8976);
	angles[4] = (0, 82.6782, 0);
	at[4] = 2.0500;
	points[5] = (-4464.8818, -9844.0947, 618.8976);
	angles[5] = (0, 82.6782, 0);
	at[5] = 4.0500;
	points[6] = (-4464.8818, -9844.0947, 618.8976);
	angles[6] = (0, 82.6782, 0);
	at[6] = 4.1500;
	points[7] = (-4464.8818, -9844.0947, 618.8976);
	angles[7] = (0, 82.6782, 0);
	at[7] = 4.8000;
	points[8] = (-4532.8350, -10372.9131, 618.8976);
	angles[8] = (0, 82.6782, 0);
	at[8] = 6.8000;
	points[9] = (-4534.5278, -10386.1025, 618.8976);
	angles[9] = (0, -49.3470, 0);
	at[9] = 6.8500;
	points[10] = (-4534.5278, -10386.1025, 618.8976);
	angles[10] = (0, -49.3470, 0);
	at[10] = 7.6000;
	points[11] = (-4544.3701, -10372.0078, 618.8976);
	angles[11] = (0, -49.3470, 0);
	at[11] = 7.6500;
	points[12] = (-4752.1260, -10130.0781, 618.8976);
	angles[12] = (0, -49.3470, 0);
	at[12] = 8.8500;
	points[13] = (-4755, -10126.6924, 618.8976);
	angles[13] = (0, -49.3470, 0);
	at[13] = 8.9000;
	points[14] = (-4755, -10126.6924, 618.8976);
	angles[14] = (0, -49.3470, 0);
	at[14] = 10.3500;
	points[15] = (-4751.0630, -10131.2988, 618.8976);
	angles[15] = (0, -49.3470, 0);
	at[15] = 10.3833;
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
	points[0] = (6757.5200, -7587.4409, 618.8976);
	angles[0] = (0, 165.3185, 0);
	at[0] = 0;
	points[1] = (6093.4253, -7413.4648, 618.8976);
	angles[1] = (0, 165.3185, 0);
	at[1] = 2.5833;
	points[2] = (6089.1338, -7412.3623, 618.8976);
	angles[2] = (0, 10.9598, 0);
	at[2] = 2.6667;
	points[3] = (6089.1338, -7412.3623, 618.8976);
	angles[3] = (0, 10.9598, 0);
	at[3] = 3.3333;
	points[4] = (6108.7793, -7409.0552, 618.8976);
	angles[4] = (0, 10.9598, 0);
	at[4] = 3.4167;
	points[5] = (7217.6382, -7194.3306, 618.8976);
	angles[5] = (0, 10.9598, 0);
	at[5] = 7.6667;
	points[6] = (7235, -7190.9448, 618.8976);
	angles[6] = (0, 10.9598, 0);
	at[6] = 7.7500;
	points[7] = (7235, -7190.9448, 618.8976);
	angles[7] = (0, 10.9598, 0);
	at[7] = 8.4167;
	points[8] = (7226.5356, -7192.5986, 618.8976);
	angles[8] = (0, 10.9598, 0);
	at[8] = 8.5000;
	points[9] = (6095.9453, -7411.5356, 618.8976);
	angles[9] = (0, 10.9598, 0);
	at[9] = 12.8333;
	points[10] = (6087.2837, -7413.2285, 618.8976);
	angles[10] = (0, 165.3185, 0);
	at[10] = 12.9167;
	points[11] = (6087.2837, -7413.2285, 618.8976);
	angles[11] = (0, 165.3185, 0);
	at[11] = 13.5833;
	points[12] = (6106.0630, -7416.7720, 618.8976);
	angles[12] = (0, 165.3185, 0);
	at[12] = 13.6667;
	points[13] = (6748.7402, -7585.1572, 618.8976);
	angles[13] = (0, 165.3185, 0);
	at[13] = 16.1667;
	points[14] = (6765.8662, -7589.6455, 618.8976);
	angles[14] = (0, 165.3185, 0);
	at[14] = 16.2500;
	points[15] = (6765.8662, -7589.6455, 618.8976);
	angles[15] = (0, 165.3185, 0);
	at[15] = 17.6667;
	points[16] = (6757.5200, -7587.4409, 618.8976);
	angles[16] = (0, 165.3185, 0);
	at[16] = 17.7500;
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
	points[0] = (5192.8740, -1562.9883, 618.8976);
	angles[0] = (0, 153.5732, 0);
	at[0] = 0;
	points[1] = (4637.5986, -1287.0197, 618.8976);
	angles[1] = (0, 153.5732, 0);
	at[1] = 2.3333;
	points[2] = (4625.7085, -1281.1063, 618.8976);
	angles[2] = (0, 0.0143, 0);
	at[2] = 2.4167;
	points[3] = (4625.7085, -1281.1063, 618.8976);
	angles[3] = (0, 0.0143, 0);
	at[3] = 3.0833;
	points[4] = (4635, -1281.2126, 618.8976);
	angles[4] = (0, 0.0143, 0);
	at[4] = 3.1667;
	points[5] = (5653.7012, -1280.9568, 618.8976);
	angles[5] = (0, 0.0143, 0);
	at[5] = 7;
	points[6] = (5658.1494, -1280.9568, 618.8976);
	angles[6] = (0, 0.0143, 0);
	at[6] = 7.0833;
	points[7] = (5658.1494, -1280.9568, 618.8976);
	angles[7] = (0, 0.0143, 0);
	at[7] = 7.7500;
	points[8] = (5639.8037, -1280.9607, 618.8976);
	angles[8] = (0, 0.0143, 0);
	at[8] = 7.8333;
	points[9] = (4643.2681, -1281.2087, 618.8976);
	angles[9] = (0, 0.0143, 0);
	at[9] = 11.5833;
	points[10] = (4625.5513, -1281.2126, 618.8976);
	angles[10] = (0, 153.5732, 0);
	at[10] = 11.6667;
	points[11] = (4625.5513, -1281.2126, 618.8976);
	angles[11] = (0, 153.5732, 0);
	at[11] = 12.3333;
	points[12] = (4630.2363, -1283.3542, 618.8976);
	angles[12] = (0, 153.5732, 0);
	at[12] = 12.4167;
	points[13] = (5185.5122, -1559.3229, 618.8976);
	angles[13] = (0, 153.5732, 0);
	at[13] = 14.7500;
	points[14] = (5197.4019, -1565.2362, 618.8976);
	angles[14] = (0, 153.5732, 0);
	at[14] = 14.8333;
	points[15] = (5197.4019, -1565.2362, 618.8976);
	angles[15] = (0, 153.5732, 0);
	at[15] = 16.2500;
	points[16] = (5192.8740, -1562.9883, 618.8976);
	angles[16] = (0, 153.5732, 0);
	at[16] = 16.3167;
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
	points[0] = (-986.6890, 3876.0906, 618.8976);
	angles[0] = (0, -158.0098, 0);
	at[0] = 0;
	points[1] = (-1282.3859, 3756.6812, 618.8976);
	angles[1] = (0, -158.0098, 0);
	at[1] = 1.2000;
	points[2] = (-1290.6024, 3753.3662, 618.8976);
	angles[2] = (0, 1.7554, 0);
	at[2] = 1.2500;
	points[3] = (-1290.6024, 3753.3662, 618.8976);
	angles[3] = (0, 1.7554, 0);
	at[3] = 1.9500;
	points[4] = (-1285.4213, 3753.6577, 618.8976);
	angles[4] = (0, 1.7554, 0);
	at[4] = 2;
	points[5] = (-794.0197, 3768.7207, 618.8976);
	angles[5] = (0, 1.7554, 0);
	at[5] = 3.8500;
	points[6] = (-785.1653, 3768.9883, 618.8976);
	angles[6] = (0, 1.7554, 0);
	at[6] = 3.9000;
	points[7] = (-785.1653, 3768.9883, 618.8976);
	angles[7] = (0, 1.7554, 0);
	at[7] = 4.6000;
	points[8] = (-792.0394, 3768.7795, 618.8976);
	angles[8] = (0, 1.7554, 0);
	at[8] = 4.6500;
	points[9] = (-1283.4409, 3753.7205, 618.8976);
	angles[9] = (0, 1.7554, 0);
	at[9] = 6.5000;
	points[10] = (-1292.2953, 3753.4490, 618.8976);
	angles[10] = (0, -158.0098, 0);
	at[10] = 6.5500;
	points[11] = (-1292.2953, 3753.4490, 618.8976);
	angles[11] = (0, -158.0098, 0);
	at[11] = 7.2500;
	points[12] = (-1284.2284, 3755.9373, 618.8976);
	angles[12] = (0, -158.0098, 0);
	at[12] = 7.3000;
	points[13] = (-988.5276, 3875.3503, 618.8976);
	angles[13] = (0, -158.0098, 0);
	at[13] = 8.5000;
	points[14] = (-980.3149, 3878.6653, 618.8976);
	angles[14] = (0, -158.0098, 0);
	at[14] = 8.5500;
	points[15] = (-980.3149, 3878.6653, 618.8976);
	angles[15] = (0, -158.0098, 0);
	at[15] = 10;
	points[16] = (-986.6890, 3876.0906, 618.8976);
	angles[16] = (0, -158.0098, 0);
	at[16] = 10.0500;
	mover = getEnt("iz_obj_8", "targetname");
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
