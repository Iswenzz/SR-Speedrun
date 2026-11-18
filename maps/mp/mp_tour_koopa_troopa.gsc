main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_tour_koopa_troopa", 0);

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
	ambientPlay("iz_0_r_gc_beach32", 2);
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
	level.iz_route[level.iz_route.size] = (-2612, -3719, 1666);
	level.iz_route[level.iz_route.size] = (-2611, -4126, 1663);
	level.iz_route[level.iz_route.size] = (-2628, -4563, 1663);
	level.iz_route[level.iz_route.size] = (-2679, -4939, 1663);
	level.iz_route[level.iz_route.size] = (-2769, -5274, 1663);
	level.iz_route[level.iz_route.size] = (-2923, -5584, 1663);
	level.iz_route[level.iz_route.size] = (-3121, -5863, 1650);
	level.iz_route[level.iz_route.size] = (-3306, -6090, 1653);
	level.iz_route[level.iz_route.size] = (-3542, -6313, 1660);
	level.iz_route[level.iz_route.size] = (-3711, -6497, 1663);
	level.iz_route[level.iz_route.size] = (-3842, -6694, 1663);
	level.iz_route[level.iz_route.size] = (-3944, -6917, 1663);
	level.iz_route[level.iz_route.size] = (-4023, -7173, 1663);
	level.iz_route[level.iz_route.size] = (-4076, -7440, 1656);
	level.iz_route[level.iz_route.size] = (-4097, -7706, 1652);
	level.iz_route[level.iz_route.size] = (-4081, -7962, 1649);
	level.iz_route[level.iz_route.size] = (-3978, -8271, 1645);
	level.iz_route[level.iz_route.size] = (-3761, -8672, 1640);
	level.iz_route[level.iz_route.size] = (-3495, -9066, 1639);
	level.iz_route[level.iz_route.size] = (-3179, -9406, 1653);
	level.iz_route[level.iz_route.size] = (-2756, -9715, 1663);
	level.iz_route[level.iz_route.size] = (-2394, -9902, 1663);
	level.iz_route[level.iz_route.size] = (-2047, -10002, 1663);
	level.iz_route[level.iz_route.size] = (-2043, -10353, 1663);
	level.iz_route[level.iz_route.size] = (-1988, -10722, 1663);
	level.iz_route[level.iz_route.size] = (-1860, -11143, 1663);
	level.iz_route[level.iz_route.size] = (-1705, -11546, 1663);
	level.iz_route[level.iz_route.size] = (-1490, -11946, 1663);
	level.iz_route[level.iz_route.size] = (-1129, -12299, 1663);
	level.iz_route[level.iz_route.size] = (-644, -12563, 1663);
	level.iz_route[level.iz_route.size] = (-192, -12658, 1662);
	level.iz_route[level.iz_route.size] = (127, -12623, 1657);
	level.iz_route[level.iz_route.size] = (464, -12537, 1663);
	level.iz_route[level.iz_route.size] = (739, -12442, 1663);
	level.iz_route[level.iz_route.size] = (1017, -12301, 1663);
	level.iz_route[level.iz_route.size] = (1326, -12101, 1663);
	level.iz_route[level.iz_route.size] = (1635, -11871, 1663);
	level.iz_route[level.iz_route.size] = (1880, -11648, 1663);
	level.iz_route[level.iz_route.size] = (2168, -11383, 1663);
	level.iz_route[level.iz_route.size] = (2939, -11386, 1663);
	level.iz_route[level.iz_route.size] = (3664, -11344, 1663);
	level.iz_route[level.iz_route.size] = (4840, -11084, 1649);
	level.iz_route[level.iz_route.size] = (5310, -10765, 1649);
	level.iz_route[level.iz_route.size] = (5661, -10310, 1644);
	level.iz_route[level.iz_route.size] = (6002, -9750, 1626);
	level.iz_route[level.iz_route.size] = (6433, -9023, 1629);
	level.iz_route[level.iz_route.size] = (6736, -8468, 1621);
	level.iz_route[level.iz_route.size] = (6984, -8003, 1613);
	level.iz_route[level.iz_route.size] = (7173, -7564, 1615);
	level.iz_route[level.iz_route.size] = (7369, -7059, 1612);
	level.iz_route[level.iz_route.size] = (7557, -6444, 1602);
	level.iz_route[level.iz_route.size] = (7614, -6098, 1598);
	level.iz_route[level.iz_route.size] = (7628, -5608, 1613);
	level.iz_route[level.iz_route.size] = (7576, -5038, 1636);
	level.iz_route[level.iz_route.size] = (7484, -4703, 1649);
	level.iz_route[level.iz_route.size] = (7293, -4331, 1663);
	level.iz_route[level.iz_route.size] = (7151, -4051, 1663);
	level.iz_route[level.iz_route.size] = (7026, -3854, 1703);
	level.iz_route[level.iz_route.size] = (6936, -3686, 1762);
	level.iz_route[level.iz_route.size] = (6550, -2835, 1663);
	level.iz_route[level.iz_route.size] = (6215, -1976, 1663);
	level.iz_route[level.iz_route.size] = (5934, -1292, 1663);
	level.iz_route[level.iz_route.size] = (5611, -459, 1663);
	level.iz_route[level.iz_route.size] = (5312, 313, 1663);
	level.iz_route[level.iz_route.size] = (5124, 744, 1663);
	level.iz_route[level.iz_route.size] = (4591, 1192, 1663);
	level.iz_route[level.iz_route.size] = (4255, 1489, 1663);
	level.iz_route[level.iz_route.size] = (3991, 1727, 1663);
	level.iz_route[level.iz_route.size] = (3735, 1970, 1663);
	level.iz_route[level.iz_route.size] = (3340, 2193, 1664);
	level.iz_route[level.iz_route.size] = (2405, 2715, 1663);
	level.iz_route[level.iz_route.size] = (1967, 2974, 1663);
	level.iz_route[level.iz_route.size] = (1588, 3287, 1663);
	level.iz_route[level.iz_route.size] = (1319, 3675, 1663);
	level.iz_route[level.iz_route.size] = (1208, 4163, 1663);
	level.iz_route[level.iz_route.size] = (1320, 4796, 1663);
	level.iz_route[level.iz_route.size] = (1635, 5691, 1663);
	level.iz_route[level.iz_route.size] = (2011, 6499, 1663);
	level.iz_route[level.iz_route.size] = (2491, 7181, 1663);
	level.iz_route[level.iz_route.size] = (2828, 7563, 1663);
	level.iz_route[level.iz_route.size] = (3379, 7925, 1663);
	level.iz_route[level.iz_route.size] = (3890, 8189, 1663);
	level.iz_route[level.iz_route.size] = (4282, 8319, 1663);
	level.iz_route[level.iz_route.size] = (4718, 8414, 1664);
	level.iz_route[level.iz_route.size] = (4982, 8784, 1664);
	level.iz_route[level.iz_route.size] = (5171, 9602, 1664);
	level.iz_route[level.iz_route.size] = (5120, 10376, 1663);
	level.iz_route[level.iz_route.size] = (4943, 10910, 1663);
	level.iz_route[level.iz_route.size] = (4630, 11403, 1661);
	level.iz_route[level.iz_route.size] = (4217, 11815, 1649);
	level.iz_route[level.iz_route.size] = (3735, 12206, 1643);
	level.iz_route[level.iz_route.size] = (3099, 12645, 1641);
	level.iz_route[level.iz_route.size] = (2472, 12975, 1650);
	level.iz_route[level.iz_route.size] = (1997, 13209, 1648);
	level.iz_route[level.iz_route.size] = (1530, 13370, 1648);
	level.iz_route[level.iz_route.size] = (970, 13467, 1650);
	level.iz_route[level.iz_route.size] = (484, 13375, 1653);
	level.iz_route[level.iz_route.size] = (60, 13280, 1660);
	level.iz_route[level.iz_route.size] = (-413, 13167, 1663);
	level.iz_route[level.iz_route.size] = (-1041, 12956, 1663);
	level.iz_route[level.iz_route.size] = (-1613, 12695, 1663);
	level.iz_route[level.iz_route.size] = (-2072, 12457, 1663);
	level.iz_route[level.iz_route.size] = (-2369, 12201, 1663);
	level.iz_route[level.iz_route.size] = (-2632, 11873, 1663);
	level.iz_route[level.iz_route.size] = (-2817, 11528, 1696);
	level.iz_route[level.iz_route.size] = (-3029, 11201, 1830);
	level.iz_route[level.iz_route.size] = (-3178, 10948, 1930);
	level.iz_route[level.iz_route.size] = (-3303, 10755, 2008);
	level.iz_route[level.iz_route.size] = (-3409, 10578, 2078);
	level.iz_route[level.iz_route.size] = (-3786, 9969, 2197);
	level.iz_route[level.iz_route.size] = (-4031, 9565, 2096);
	level.iz_route[level.iz_route.size] = (-4353, 9049, 1663);
	level.iz_route[level.iz_route.size] = (-4775, 8386, 1663);
	level.iz_route[level.iz_route.size] = (-5147, 7804, 1663);
	level.iz_route[level.iz_route.size] = (-5572, 7060, 1663);
	level.iz_route[level.iz_route.size] = (-5975, 6302, 1663);
	level.iz_route[level.iz_route.size] = (-6202, 5558, 1663);
	level.iz_route[level.iz_route.size] = (-6159, 4832, 1663);
	level.iz_route[level.iz_route.size] = (-6002, 4219, 1663);
	level.iz_route[level.iz_route.size] = (-5813, 3703, 1654);
	level.iz_route[level.iz_route.size] = (-5580, 3194, 1619);
	level.iz_route[level.iz_route.size] = (-5209, 2708, 1593);
	level.iz_route[level.iz_route.size] = (-4786, 2263, 1585);
	level.iz_route[level.iz_route.size] = (-4245, 1747, 1596);
	level.iz_route[level.iz_route.size] = (-3768, 1321, 1641);
	level.iz_route[level.iz_route.size] = (-3351, 945, 1663);
	level.iz_route[level.iz_route.size] = (-2945, 525, 1663);
	level.iz_route[level.iz_route.size] = (-2742, 185, 1663);
	level.iz_route[level.iz_route.size] = (-2726, -187, 1672);
	level.iz_route[level.iz_route.size] = (-2728, -484, 1794);
	level.iz_route[level.iz_route.size] = (-2732, -1039, 1663);
	level.iz_route[level.iz_route.size] = (-2704, -1723, 1663);
	level.iz_route[level.iz_route.size] = (-2672, -2576, 1663);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-7817.9531, -11844.0547, -2952.7559);
	angles[0] = (0, -27.0395, 0);
	at[0] = 0;
	points[1] = (-6397.4019, -12568.1885, -2952.7559);
	angles[1] = (0, -27.0396, 0);
	at[1] = 3;
	points[2] = (-4434.8032, -13385.4326, -2952.7559);
	angles[2] = (0, -27.0396, 0);
	at[2] = 7;
	points[3] = (-3199.3152, -13874.4883, -2952.7559);
	angles[3] = (0, -27.0396, 0);
	at[3] = 9.5000;
	points[4] = (-2947.7166, -13957.5195, -2952.7559);
	angles[4] = (0, -27.0396, 0);
	at[4] = 10;
	points[5] = (-1390.2362, -14299.0947, -2952.7559);
	angles[5] = (0, -27.0396, 0);
	at[5] = 13;
	points[6] = (-1125.4843, -14316.6143, -2952.7559);
	angles[6] = (0, -27.0396, 0);
	at[6] = 13.5000;
	points[7] = (467.3858, -14388.4648, -2952.7559);
	angles[7] = (0, -27.0396, 0);
	at[7] = 16.5000;
	points[8] = (732.4961, -14383.3867, -2952.7559);
	angles[8] = (0, -27.0396, 0);
	at[8] = 17;
	points[9] = (2585.4292, -14218.6611, -2952.7559);
	angles[9] = (0, -27.0396, 0);
	at[9] = 20.5000;
	points[10] = (4420.0786, -13911.4961, -2952.7559);
	angles[10] = (0, -27.0396, 0);
	at[10] = 24;
	points[11] = (4671.1025, -13825.3145, -2952.7559);
	angles[11] = (0, -27.0396, 0);
	at[11] = 24.5000;
	points[12] = (5670.7085, -13463.7402, -2952.7559);
	angles[12] = (0, -27.0396, 0);
	at[12] = 26.5000;
	points[13] = (5919.7241, -13370.9453, -2952.7559);
	angles[13] = (0, -27.0396, 0);
	at[13] = 27;
	points[14] = (6909.0942, -12982.2441, -2952.7559);
	angles[14] = (0, -27.0396, 0);
	at[14] = 29;
	points[15] = (7147.7954, -12868.3857, -2952.7559);
	angles[15] = (0, -27.0396, 0);
	at[15] = 29.5000;
	points[16] = (8036.1416, -12284.6455, -2952.7559);
	angles[16] = (0, -27.0396, 0);
	at[16] = 31.5000;
	points[17] = (9137.7168, -11541.6152, -2952.7559);
	angles[17] = (0, -27.0396, 0);
	at[17] = 34;
	points[18] = (9340.7871, -11371.0244, -2952.7559);
	angles[18] = (0, -27.0396, 0);
	at[18] = 34.5000;
	points[19] = (10127.3232, -10655.9834, -2952.7559);
	angles[19] = (0, -27.0396, 0);
	at[19] = 36.5000;
	points[20] = (10297.7168, -10452.9932, -2952.7559);
	angles[20] = (0, -27.0396, 0);
	at[20] = 37;
	points[21] = (11110.9062, -9402.1260, -2952.7559);
	angles[21] = (0, -27.0396, 0);
	at[21] = 39.5000;
	points[22] = (11917.2041, -8345.9844, -2952.7559);
	angles[22] = (0, -27.0396, 0);
	at[22] = 42;
	points[23] = (12067.5986, -8127.2046, -2952.7559);
	angles[23] = (0, -27.0396, 0);
	at[23] = 42.5000;
	points[24] = (12777.1260, -7003.7793, -2952.7559);
	angles[24] = (0, -27.0396, 0);
	at[24] = 45;
	points[25] = (12903.8584, -6771.4961, -2952.7559);
	angles[25] = (0, -27.0396, 0);
	at[25] = 45.5000;
	points[26] = (14125.7881, -3540.1182, -2952.7559);
	angles[26] = (0, -27.0396, 0);
	at[26] = 52;
	points[27] = (14205.2363, -3288.5000, -2952.7559);
	angles[27] = (0, -27.0396, 0);
	at[27] = 52.5000;
	points[28] = (14314.0947, -1165.3071, -2952.7559);
	angles[28] = (0, -27.0396, 0);
	at[28] = 56.5000;
	points[29] = (14319.7246, -899.7362, -2952.7559);
	angles[29] = (0, -27.0396, 0);
	at[29] = 57;
	points[30] = (14306.2207, 694.6968, -2952.7559);
	angles[30] = (0, -27.0396, 0);
	at[30] = 60;
	points[31] = (14262.1660, 2554.4097, -2952.7559);
	angles[31] = (0, -27.0396, 0);
	at[31] = 63.5000;
	points[32] = (14116.9297, 4408.9370, -2952.7559);
	angles[32] = (0, -27.0396, 0);
	at[32] = 67;
	points[33] = (14054.7246, 4666.8110, -2952.7559);
	angles[33] = (0, -27.0396, 0);
	at[33] = 67.5000;
	points[34] = (13643.8975, 6207.4414, -2952.7559);
	angles[34] = (0, -27.0396, 0);
	at[34] = 70.5000;
	points[35] = (12977.9531, 7656.1025, -2952.7559);
	angles[35] = (0, -27.0396, 0);
	at[35] = 73.5000;
	points[36] = (12843.8193, 7884.9209, -2952.7559);
	angles[36] = (0, -27.0396, 0);
	at[36] = 74;
	points[37] = (12130.4336, 9005.9453, -2952.7559);
	angles[37] = (0, -27.0396, 0);
	at[37] = 76.5000;
	points[38] = (11983.7793, 9227.3623, -2952.7559);
	angles[38] = (0, -27.0396, 0);
	at[38] = 77;
	points[39] = (11013.6221, 10492.7559, -2952.7559);
	angles[39] = (0, -27.0396, 0);
	at[39] = 80;
	points[40] = (10824.2920, 10678.8584, -2952.7559);
	angles[40] = (0, -27.0396, 0);
	at[40] = 80.5000;
	points[41] = (10055.8662, 11413.3457, -2952.7559);
	angles[41] = (0, -27.0396, 0);
	at[41] = 82.5000;
	points[42] = (9846.2598, 11575.6299, -2952.7559);
	angles[42] = (0, -27.0396, 0);
	at[42] = 83;
	points[43] = (8975.4326, 12185.1973, -2952.7559);
	angles[43] = (0, -27.0396, 0);
	at[43] = 85;
	points[44] = (8752.4404, 12328.7002, -2952.7559);
	angles[44] = (0, -27.0396, 0);
	at[44] = 85.5000;
	points[45] = (7323.4648, 13036.1025, -2952.7559);
	angles[45] = (0, -27.0396, 0);
	at[45] = 88.5000;
	points[46] = (4520, 13864.2129, -2952.7559);
	angles[46] = (0, -27.0396, 0);
	at[46] = 94;
	points[47] = (4256.9292, 13895.2754, -2952.7559);
	angles[47] = (0, -27.0396, 0);
	at[47] = 94.5000;
	points[48] = (1872.7756, 14085.4727, -2952.7559);
	angles[48] = (0, -27.0396, 0);
	at[48] = 99;
	points[49] = (-781.4961, 14216.1416, -2952.7559);
	angles[49] = (0, -27.0396, 0);
	at[49] = 104;
	points[50] = (-1046.8307, 14210.1572, -2952.7559);
	angles[50] = (0, -27.0396, 0);
	at[50] = 104.5000;
	points[51] = (-3965, 14038.0703, -2952.7559);
	angles[51] = (0, -27.0396, 0);
	at[51] = 110;
	points[52] = (-4218.8584, 13972.5986, -2952.7559);
	angles[52] = (0, -27.0396, 0);
	at[52] = 110.5000;
	points[53] = (-8394.4092, 12247.9131, -2952.7559);
	angles[53] = (0, -27.0396, 0);
	at[53] = 119;
	points[54] = (-8621.0635, 12117.9521, -2952.7559);
	angles[54] = (0, -27.0396, 0);
	at[54] = 119.5000;
	points[55] = (-11447.3223, 9306.8896, -2952.7559);
	angles[55] = (0, -27.0396, 0);
	at[55] = 127;
	points[56] = (-11610.6299, 9102.4404, -2952.7559);
	angles[56] = (0, -27.0396, 0);
	at[56] = 127.5000;
	points[57] = (-12448.1104, 7148.3462, -2952.7559);
	angles[57] = (0, -27.0396, 0);
	at[57] = 131.5000;
	points[58] = (-13177.3232, 5437.0083, -2952.7559);
	angles[58] = (0, -27.0396, 0);
	at[58] = 135;
	points[59] = (-13258.1494, 5186.7324, -2952.7559);
	angles[59] = (0, -27.0396, 0);
	at[59] = 135.5000;
	points[60] = (-13651.4961, 419.4803, -2952.7559);
	angles[60] = (0, -27.0396, 0);
	at[60] = 144.5000;
	points[61] = (-13633.1104, 155.6594, -2952.7559);
	angles[61] = (0, -27.0396, 0);
	at[61] = 145;
	points[62] = (-12996.9297, -4585.3149, -2952.7559);
	angles[62] = (0, -27.0396, 0);
	at[62] = 154;
	points[63] = (-12930.3545, -4839.5278, -2952.7559);
	angles[63] = (0, -27.0396, 0);
	at[63] = 154.5000;
	points[64] = (-11017.3232, -8932.2051, -2952.7559);
	angles[64] = (0, -27.0396, 0);
	at[64] = 163;
	points[65] = (-10837.1260, -9122.9131, -2952.7559);
	angles[65] = (0, -27.0396, 0);
	at[65] = 163.5000;
	points[66] = (-7877.9922, -11793.7402, -2952.7559);
	angles[66] = (0, -27.0396, 0);
	at[66] = 171;
	points[67] = (-7817.9531, -11844.0547, -2952.7559);
	angles[67] = (0, -27.0396, 0);
	at[67] = 171.1500;
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
	points[0] = (-2623.3899, -3714.4568, 2214.5669);
	angles[0] = (0, -176.8539, 0);
	at[0] = 0;
	points[1] = (-2607.4331, -3926.3821, 2214.5669);
	angles[1] = (0, -175.7941, 0);
	at[1] = 0.3333;
	points[2] = (-2604.0278, -4132.2441, 2214.5669);
	angles[2] = (0, -180.0799, 0);
	at[2] = 0.6667;
	points[3] = (-2621.1143, -4339.0942, 2214.5669);
	angles[3] = (0, -184.8361, 0);
	at[3] = 1;
	points[4] = (-2667.5117, -4538.7007, 2214.5669);
	angles[4] = (0, -193.8123, 0);
	at[4] = 1.3333;
	points[5] = (-2731.6221, -4736.3779, 2214.5669);
	angles[5] = (0, -197.7539, 0);
	at[5] = 1.6667;
	points[6] = (-2803.0669, -4930.5117, 2214.5669);
	angles[6] = (0, -200.5262, 0);
	at[6] = 2;
	points[7] = (-2900.5708, -5111.4961, 2214.5669);
	angles[7] = (0, -208.6544, 0);
	at[7] = 2.3333;
	points[8] = (-3123.1692, -5461.9683, 2214.5669);
	angles[8] = (0, -212.8146, 0);
	at[8] = 3;
	points[9] = (-3238.0156, -5631.6143, 2214.5669);
	angles[9] = (0, -214.4150, 0);
	at[9] = 3.3333;
	points[10] = (-3478.1064, -5969.6064, 2214.5669);
	angles[10] = (0, -214.9474, 0);
	at[10] = 4;
	points[11] = (-3584.6023, -6143.8188, 2214.5669);
	angles[11] = (0, -210.6899, 0);
	at[11] = 4.3333;
	points[12] = (-3773.5828, -6513.4648, 2214.5669);
	angles[12] = (0, -206.6652, 0);
	at[12] = 5;
	points[13] = (-3864.6104, -6700.8271, 2214.5669);
	angles[13] = (0, -205.8444, 0);
	at[13] = 5.3333;
	points[14] = (-3947.2837, -6886.8110, 2214.5669);
	angles[14] = (0, -203.7096, 0);
	at[14] = 5.6667;
	points[15] = (-4101.0239, -7272.7168, 2214.5669);
	angles[15] = (0, -201.1784, 0);
	at[15] = 6.3333;
	points[16] = (-4170.6299, -7468.0708, 2214.5669);
	angles[16] = (0, -199.3506, 0);
	at[16] = 6.6667;
	points[17] = (-4219.5669, -7667.4414, 2214.5669);
	angles[17] = (0, -193.3463, 0);
	at[17] = 7;
	points[18] = (-4255.5908, -7870.7876, 2214.5669);
	angles[18] = (0, -190.1610, 0);
	at[18] = 7.3333;
	points[19] = (-4285.7876, -8076.1812, 2214.5669);
	angles[19] = (0, -188.2772, 0);
	at[19] = 7.6667;
	points[20] = (-4306.5356, -8282.1660, 2214.5669);
	angles[20] = (0, -185.3279, 0);
	at[20] = 8;
	points[21] = (-4289.6455, -8485.7871, 2214.5669);
	angles[21] = (0, -174.2541, 0);
	at[21] = 8.3333;
	points[22] = (-4245.7876, -8688.2686, 2214.5669);
	angles[22] = (0, -168.0171, 0);
	at[22] = 8.6667;
	points[23] = (-4191.8896, -8888.1104, 2214.5669);
	angles[23] = (0, -164.8237, 0);
	at[23] = 9;
	points[24] = (-4124.4487, -9084.0156, 2214.5669);
	angles[24] = (0, -160.2937, 0);
	at[24] = 9.3333;
	points[25] = (-4028.8977, -9264.5674, 2214.5669);
	angles[25] = (0, -152.3315, 0);
	at[25] = 9.6667;
	points[26] = (-3922.8110, -9443.5830, 2214.5669);
	angles[26] = (0, -149.4607, 0);
	at[26] = 10;
	points[27] = (-3812.7795, -9619.6455, 2214.5669);
	angles[27] = (0, -147.9575, 0);
	at[27] = 10.3333;
	points[28] = (-3697.6182, -9792.6377, 2214.5669);
	angles[28] = (0, -146.1510, 0);
	at[28] = 10.6667;
	points[29] = (-3563.3345, -9945.3145, 2214.5669);
	angles[29] = (0, -136.5025, 0);
	at[29] = 11;
	points[30] = (-3393, -10063.4648, 2214.5669);
	angles[30] = (0, -125.0122, 0);
	at[30] = 11.3333;
	points[31] = (-3212.0906, -10164.3701, 2214.5669);
	angles[31] = (0, -119.0440, 0);
	at[31] = 11.6667;
	points[32] = (-3019.7952, -10234.8027, 2214.5669);
	angles[32] = (0, -108.9204, 0);
	at[32] = 12;
	points[33] = (-2817.3818, -10280.6689, 2214.5669);
	angles[33] = (0, -103.1553, 0);
	at[33] = 12.3333;
	points[34] = (-2614.0276, -10321.3779, 2214.5669);
	angles[34] = (0, -101.4079, 0);
	at[34] = 12.6667;
	points[35] = (-2413.6536, -10360.8271, 2210.0393);
	angles[35] = (0, -101.3296, 0);
	at[35] = 13;
	points[36] = (-2210.6772, -10402.1650, 2188.6340);
	angles[36] = (0, -101.4029, 0);
	at[36] = 13.3333;
	points[37] = (-2007.3701, -10440.1172, 2175.4331);
	angles[37] = (0, -100.4311, 0);
	at[37] = 13.6667;
	points[38] = (-1804.4292, -10468.8975, 2192.8191);
	angles[38] = (0, -97.5894, 0);
	at[38] = 14;
	points[39] = (-1636.1654, -10467.5596, 2302.1260);
	angles[39] = (0, -89.2776, 0);
	at[39] = 14.3333;
	points[40] = (-1488.5432, -10453.9375, 2449.4922);
	angles[40] = (0, -85.1169, 0);
	at[40] = 14.6667;
	points[41] = (-1205.5276, -10420.5117, 2751.0867);
	angles[41] = (0, -82.9379, 0);
	at[41] = 15.3333;
	points[42] = (-1062.6929, -10401.5752, 2900.3267);
	angles[42] = (0, -82.4424, 0);
	at[42] = 15.6667;
	points[43] = (-912.7914, -10380.5127, 3043.0474);
	angles[43] = (0, -81.9528, 0);
	at[43] = 16;
	points[44] = (-735.6732, -10349.5674, 3129.0906);
	angles[44] = (0, -79.4997, 0);
	at[44] = 16.3333;
	points[45] = (-533.6654, -10302.7959, 3139.3030);
	angles[45] = (0, -77.1100, 0);
	at[45] = 16.6667;
	points[46] = (-331.9972, -10255.7090, 3127.6497);
	angles[46] = (0, -76.9977, 0);
	at[46] = 17;
	points[47] = (-130.4622, -10214.4102, 3108.7168);
	angles[47] = (0, -78.7756, 0);
	at[47] = 17.3333;
	points[48] = (73.1689, -10207.7959, 3104.3779);
	angles[48] = (0, -90.5980, 0);
	at[48] = 17.6667;
	points[49] = (275.0536, -10252.0479, 3123.6929);
	angles[49] = (0, -101.8750, 0);
	at[49] = 18;
	points[50] = (473.4016, -10310.7090, 3133.1338);
	angles[50] = (0, -106.4066, 0);
	at[50] = 18.3333;
	points[51] = (666.5315, -10378.8193, 3106.2007);
	angles[51] = (0, -109.6104, 0);
	at[51] = 18.6667;
	points[52] = (829.9843, -10451.4570, 3006.7244);
	angles[52] = (0, -113.8630, 0);
	at[52] = 19;
	points[53] = (983.5984, -10525.3545, 2891.2639);
	angles[53] = (0, -115.5682, 0);
	at[53] = 19.3333;
	points[54] = (1288.9921, -10676.2598, 2653.5356);
	angles[54] = (0, -116.4103, 0);
	at[54] = 20;
	points[55] = (1442.1851, -10752.7158, 2537.9016);
	angles[55] = (0, -116.5195, 0);
	at[55] = 20.3333;
	points[56] = (1601.9133, -10832.4023, 2427.2166);
	angles[56] = (0, -116.4901, 0);
	at[56] = 20.6667;
	points[57] = (1767.0198, -10913.6611, 2350.3938);
	angles[57] = (0, -116.2096, 0);
	at[57] = 21;
	points[58] = (1951.5552, -11006.8115, 2330.9529);
	angles[58] = (0, -116.7852, 0);
	at[58] = 21.3333;
	points[59] = (2137.3308, -11101.0234, 2330.5552);
	angles[59] = (0, -116.8518, 0);
	at[59] = 21.6667;
	points[60] = (2322.5237, -11193.7412, 2337.8542);
	angles[60] = (0, -116.5429, 0);
	at[60] = 22;
	points[61] = (2508.1812, -11283.9375, 2348.7048);
	angles[61] = (0, -115.8318, 0);
	at[61] = 22.3333;
	points[62] = (2696.9646, -11369.4883, 2359.6614);
	angles[62] = (0, -114.1130, 0);
	at[62] = 22.6667;
	points[63] = (2889.3425, -11435.0400, 2362.2048);
	angles[63] = (0, -108.1100, 0);
	at[63] = 23;
	points[64] = (3091.4646, -11485.7480, 2362.2048);
	angles[64] = (0, -104.2429, 0);
	at[64] = 23.3333;
	points[65] = (3293.3228, -11530.5117, 2362.2048);
	angles[65] = (0, -102.5060, 0);
	at[65] = 23.6667;
	points[66] = (3496.7480, -11571.0635, 2362.2048);
	angles[66] = (0, -101.2163, 0);
	at[66] = 24;
	points[67] = (3701.1379, -11606.1807, 2362.2048);
	angles[67] = (0, -99.5940, 0);
	at[67] = 24.3333;
	points[68] = (3903.9961, -11627.1270, 2362.2048);
	angles[68] = (0, -94.7837, 0);
	at[68] = 24.6667;
	points[69] = (4110.7876, -11612.1660, 2362.2048);
	angles[69] = (0, -85.9013, 0);
	at[69] = 25;
	points[70] = (4315.5513, -11580.1572, 2362.2048);
	angles[70] = (0, -81.0841, 0);
	at[70] = 25.3333;
	points[71] = (4517.1655, -11534.2129, 2362.2048);
	angles[71] = (0, -76.8695, 0);
	at[71] = 25.6667;
	points[72] = (4713.2681, -11464.4482, 2362.2048);
	angles[72] = (0, -69.3474, 0);
	at[72] = 26;
	points[73] = (4877.8740, -11345.1973, 2362.2048);
	angles[73] = (0, -54.0118, 0);
	at[73] = 26.3333;
	points[74] = (5030.7876, -11206.5752, 2362.2048);
	angles[74] = (0, -48.1524, 0);
	at[74] = 26.6667;
	points[75] = (5180.1968, -11061.8896, 2362.2048);
	angles[75] = (0, -45.9585, 0);
	at[75] = 27;
	points[76] = (5326.1812, -10914.3701, 2362.2048);
	angles[76] = (0, -44.6755, 0);
	at[76] = 27.3333;
	points[77] = (5469.2915, -10764.0938, 2362.2048);
	angles[77] = (0, -43.5434, 0);
	at[77] = 27.6667;
	points[78] = (5609.1338, -10609.4102, 2362.2048);
	angles[78] = (0, -41.9382, 0);
	at[78] = 28;
	points[79] = (5734.2915, -10453.4648, 2362.2048);
	angles[79] = (0, -38.5827, 0);
	at[79] = 28.3333;
	points[80] = (5858.8975, -10286.2998, 2362.2048);
	angles[80] = (0, -36.7515, 0);
	at[80] = 28.6667;
	points[81] = (5980.9448, -10117.5195, 2362.2048);
	angles[81] = (0, -35.8808, 0);
	at[81] = 29;
	points[82] = (6218.7397, -9778.3467, 2362.2048);
	angles[82] = (0, -34.7370, 0);
	at[82] = 29.6667;
	points[83] = (6448.7402, -9433.0713, 2362.2048);
	angles[83] = (0, -33.0933, 0);
	at[83] = 30.3333;
	points[84] = (6551.6538, -9262.2832, 2362.2048);
	angles[84] = (0, -30.7070, 0);
	at[84] = 30.6667;
	points[85] = (6652.3228, -9077.3232, 2362.2048);
	angles[85] = (0, -28.6191, 0);
	at[85] = 31;
	points[86] = (6842.5986, -8709.4883, 2362.2048);
	angles[86] = (0, -27.0399, 0);
	at[86] = 31.6667;
	points[87] = (7025.6304, -8338.2285, 2362.2048);
	angles[87] = (0, -25.9223, 0);
	at[87] = 32.3333;
	points[88] = (7199.5273, -7961.2202, 2362.2048);
	angles[88] = (0, -24.1705, 0);
	at[88] = 33;
	points[89] = (7279.2915, -7767.9131, 2362.2048);
	angles[89] = (0, -22.1666, 0);
	at[89] = 33.3333;
	points[90] = (7342.6772, -7576.6143, 2362.2048);
	angles[90] = (0, -18.2184, 0);
	at[90] = 33.6667;
	points[91] = (7399.2915, -7378.9761, 2362.2048);
	angles[91] = (0, -16.0572, 0);
	at[91] = 34;
	points[92] = (7453.1104, -7178.4253, 2362.2048);
	angles[92] = (0, -15.0307, 0);
	at[92] = 34.3333;
	points[93] = (7554.1738, -6777.2441, 2362.2048);
	angles[93] = (0, -13.8630, 0);
	at[93] = 35;
	points[94] = (7648.7007, -6372.5596, 2362.2048);
	angles[94] = (0, -12.8656, 0);
	at[94] = 35.6667;
	points[95] = (7692.9131, -6169.6855, 2362.2048);
	angles[95] = (0, -12.2538, 0);
	at[95] = 36;
	points[96] = (7734.2520, -5966.1812, 2362.2048);
	angles[96] = (0, -11.4037, 0);
	at[96] = 36.3333;
	points[97] = (7770.6299, -5760.7480, 2362.2048);
	angles[97] = (0, -9.8765, 0);
	at[97] = 36.6667;
	points[98] = (7794.4492, -5564.8823, 2362.2048);
	angles[98] = (0, -6.7562, 0);
	at[98] = 37;
	points[99] = (7811.4961, -5357.1655, 2362.2048);
	angles[99] = (0, -4.7402, 0);
	at[99] = 37.3333;
	points[100] = (7824.8818, -5151.2993, 2362.2048);
	angles[100] = (0, -3.7251, 0);
	at[100] = 37.6667;
	points[101] = (7845.3149, -4736.7720, 2362.2048);
	angles[101] = (0, -2.5417, 0);
	at[101] = 38.3333;
	points[102] = (7858.5830, -4322.4805, 2362.2048);
	angles[102] = (0, -1.5581, 0);
	at[102] = 39;
	points[103] = (7862.3232, -4114.2915, 2362.2048);
	angles[103] = (0, -0.9923, 0);
	at[103] = 39.3333;
	points[104] = (7861.1812, -3698.1733, 2362.2048);
	angles[104] = (0, 0.7344, 0);
	at[104] = 40;
	points[105] = (7852.5195, -3490.1182, 2362.2048);
	angles[105] = (0, 2.5949, 0);
	at[105] = 40.3333;
	points[106] = (7830.0791, -3295.9058, 2362.2048);
	angles[106] = (0, 6.9778, 0);
	at[106] = 40.6667;
	points[107] = (7792.3232, -3091.4763, 2362.2048);
	angles[107] = (0, 10.3952, 0);
	at[107] = 41;
	points[108] = (7749.2520, -2889.1260, 2362.2048);
	angles[108] = (0, 11.9929, 0);
	at[108] = 41.3333;
	points[109] = (7654.8428, -2483.3308, 2362.2048);
	angles[109] = (0, 13.3508, 0);
	at[109] = 42;
	points[110] = (7456.4175, -1679.9489, 2362.2048);
	angles[110] = (0, 13.9577, 0);
	at[110] = 43.3333;
	points[111] = (7358.4258, -1275.0946, 2362.2048);
	angles[111] = (0, 13.3232, 0);
	at[111] = 44;
	points[112] = (7316.1421, -1077.7756, 2362.2048);
	angles[112] = (0, 11.7830, 0);
	at[112] = 44.3333;
	points[113] = (7244.8423, -671.5118, 2362.2048);
	angles[113] = (0, 9.6745, 0);
	at[113] = 45;
	points[114] = (7179.3306, -261.2630, 2362.2048);
	angles[114] = (0, 8.8611, 0);
	at[114] = 45.6667;
	points[115] = (7120, 149.9063, 2362.2048);
	angles[115] = (0, 7.9181, 0);
	at[115] = 46.3333;
	points[116] = (7093.8188, 356.0134, 2362.2048);
	angles[116] = (0, 7.1775, 0);
	at[116] = 46.6667;
	points[117] = (7072.1260, 561.6221, 2362.2048);
	angles[117] = (0, 5.8714, 0);
	at[117] = 47;
	points[118] = (7062.9531, 761.2362, 2362.2048);
	angles[118] = (0, 1.7161, 0);
	at[118] = 47.3333;
	points[119] = (7084.2520, 970.1103, 2362.2048);
	angles[119] = (0, -5.8055, 0);
	at[119] = 47.6667;
	points[120] = (7154.3311, 1377.6653, 2362.2048);
	angles[120] = (0, -10.2023, 0);
	at[120] = 48.3333;
	points[121] = (7225.5518, 1786.7284, 2362.2048);
	angles[121] = (0, -9.3074, 0);
	at[121] = 49;
	points[122] = (7251.7720, 1991.3740, 2362.2048);
	angles[122] = (0, -6.9908, 0);
	at[122] = 49.3333;
	points[123] = (7257.7954, 2200.5825, 2362.2048);
	angles[123] = (0, -0.6410, 0);
	at[123] = 49.6667;
	points[124] = (7211.2202, 2394.3071, 2358.5513);
	angles[124] = (0, 13.7250, 0);
	at[124] = 50;
	points[125] = (7139.4097, 2588.2363, 2349.4529);
	angles[125] = (0, 20.0682, 0);
	at[125] = 50.3333;
	points[126] = (7058.1104, 2779.4883, 2339.8506);
	angles[126] = (0, 23.0475, 0);
	at[126] = 50.6667;
	points[127] = (6969.8823, 2967.4727, 2331.3582);
	angles[127] = (0, 25.2257, 0);
	at[127] = 51;
	points[128] = (6874.7642, 3152.0552, 2325.1614);
	angles[128] = (0, 27.3942, 0);
	at[128] = 51.3333;
	points[129] = (6771.4961, 3332.0354, 2322.8503);
	angles[129] = (0, 30.0609, 0);
	at[129] = 51.6667;
	points[130] = (6657.1260, 3503.5669, 2327.4133);
	angles[130] = (0, 34.1184, 0);
	at[130] = 52;
	points[131] = (6518.4648, 3659.0315, 2348.0945);
	angles[131] = (0, 43.0241, 0);
	at[131] = 52.3333;
	points[132] = (6346.3779, 3736.1968, 2411.2244);
	angles[132] = (0, 67.0306, 0);
	at[132] = 52.6667;
	points[133] = (6162.2441, 3764.7007, 2497.9529);
	angles[133] = (0, 80.4055, 0);
	at[133] = 53;
	points[134] = (5975.9053, 3778.9448, 2589.9409);
	angles[134] = (0, 85.4554, 0);
	at[134] = 53.3333;
	points[135] = (5790.1968, 3785.7046, 2682.9016);
	angles[135] = (0, 87.8915, 0);
	at[135] = 53.6667;
	points[136] = (5605.8267, 3787.7441, 2775.1812);
	angles[136] = (0, 89.3791, 0);
	at[136] = 54;
	points[137] = (5232.5591, 3782.5947, 2958.3896);
	angles[137] = (0, 91.2014, 0);
	at[137] = 54.6667;
	points[138] = (5045.7871, 3776.7363, 3046.1890);
	angles[138] = (0, 91.8135, 0);
	at[138] = 55;
	points[139] = (4858.1104, 3769.2559, 3129.5354);
	angles[139] = (0, 92.2987, 0);
	at[139] = 55.3333;
	points[140] = (4665.6299, 3760.3701, 3205.7361);
	angles[140] = (0, 92.6501, 0);
	at[140] = 55.6667;
	points[141] = (4472.6382, 3750.6614, 3257.7244);
	angles[141] = (0, 92.9885, 0);
	at[141] = 56;
	points[142] = (4266.3779, 3734.3899, 3278.1379);
	angles[142] = (0, 94.5671, 0);
	at[142] = 56.3333;
	points[143] = (4059.5669, 3714.4688, 3285.8149);
	angles[143] = (0, 95.4984, 0);
	at[143] = 56.6667;
	points[144] = (3852.8110, 3692.6221, 3287.3584);
	angles[144] = (0, 96.0375, 0);
	at[144] = 57;
	points[145] = (3646, 3669.4136, 3285.1931);
	angles[145] = (0, 96.4133, 0);
	at[145] = 57.3333;
	points[146] = (3234.7717, 3620.0198, 3274.3623);
	angles[146] = (0, 97.0044, 0);
	at[146] = 58;
	points[147] = (2616.6733, 3536.6023, 3252.0432);
	angles[147] = (0, 98.1912, 0);
	at[147] = 59;
	points[148] = (2417.4409, 3504.4055, 3248.0315);
	angles[148] = (0, 99.3891, 0);
	at[148] = 59.3333;
	points[149] = (2217.6616, 3465.2639, 3248.0315);
	angles[149] = (0, 101.0842, 0);
	at[149] = 59.6667;
	points[150] = (2014.3859, 3421.9607, 3248.0315);
	angles[150] = (0, 102.0268, 0);
	at[150] = 60;
	points[151] = (1609.3190, 3328.9880, 3248.0315);
	angles[151] = (0, 103.2374, 0);
	at[151] = 60.6667;
	points[152] = (1206.3818, 3227.1338, 3248.0315);
	angles[152] = (0, 104.6158, 0);
	at[152] = 61.3333;
	points[153] = (1006.2678, 3171.1731, 3248.0315);
	angles[153] = (0, 105.7242, 0);
	at[153] = 61.6667;
	points[154] = (809.8701, 3109.1338, 3248.0315);
	angles[154] = (0, 107.7950, 0);
	at[154] = 62;
	points[155] = (625.6693, 3028.1890, 3248.0315);
	angles[155] = (0, 115.2324, 0);
	at[155] = 62.3333;
	points[156] = (456.3032, 2907.6418, 3248.0315);
	angles[156] = (0, 125.3344, 0);
	at[156] = 62.6667;
	points[157] = (297.4917, 2774.3977, 3248.0315);
	angles[157] = (0, 129.8660, 0);
	at[157] = 63;
	points[158] = (-163.0464, 2355.1143, 3248.0315);
	angles[158] = (0, 132.2753, 0);
	at[158] = 64;
	points[159] = (-321.6669, 2220.4607, 3248.0315);
	angles[159] = (0, 129.8761, 0);
	at[159] = 64.3333;
	points[160] = (-489.2480, 2110.7637, 3249.4409);
	angles[160] = (0, 123.0137, 0);
	at[160] = 64.6667;
	points[161] = (-851.7520, 1906.1693, 3256.7126);
	angles[161] = (0, 118.9803, 0);
	at[161] = 65.3333;
	points[162] = (-1217.5748, 1709.8268, 3261.1301);
	angles[162] = (0, 118.0266, 0);
	at[162] = 66;
	points[163] = (-1400.0630, 1613.9252, 3259.6890);
	angles[163] = (0, 117.7086, 0);
	at[163] = 66.3333;
	points[164] = (-1584.3269, 1518.5630, 3249.2285);
	angles[164] = (0, 117.3159, 0);
	at[164] = 66.6667;
	points[165] = (-1762.4646, 1436.7047, 3195.3662);
	angles[165] = (0, 114.4007, 0);
	at[165] = 67;
	points[166] = (-1938.7047, 1363.9764, 3114);
	angles[166] = (0, 112.5479, 0);
	at[166] = 67.3333;
	points[167] = (-2112.1458, 1292.2953, 3025.5630);
	angles[167] = (0, 112.6464, 0);
	at[167] = 67.6667;
	points[168] = (-2281.1299, 1212.0354, 2946.9883);
	angles[168] = (0, 116.2148, 0);
	at[168] = 68;
	points[169] = (-2452.0159, 1113.2520, 2882.0198);
	angles[169] = (0, 119.8090, 0);
	at[169] = 68.3333;
	points[170] = (-2790.3228, 906.7323, 2758.5198);
	angles[170] = (0, 121.8294, 0);
	at[170] = 69;
	points[171] = (-2958.3269, 798.1929, 2701.1301);
	angles[171] = (0, 122.9920, 0);
	at[171] = 69.3333;
	points[172] = (-3118.7676, 681.9685, 2655.5354);
	angles[172] = (0, 126.8557, 0);
	at[172] = 69.6667;
	points[173] = (-3266.8464, 537.2166, 2644.6731);
	angles[173] = (0, 134.2142, 0);
	at[173] = 70;
	points[174] = (-3407.6458, 384.7146, 2645.8464);
	angles[174] = (0, 137.2081, 0);
	at[174] = 70.3333;
	points[175] = (-3543.9883, 228.1854, 2651.0789);
	angles[175] = (0, 139.0097, 0);
	at[175] = 70.6667;
	points[176] = (-3673.8701, 65.4728, 2657.1182);
	angles[176] = (0, 141.8531, 0);
	at[176] = 71;
	points[177] = (-3758.0513, -119.1933, 2657.4805);
	angles[177] = (0, 156.7222, 0);
	at[177] = 71.3333;
	points[178] = (-3805.1416, -320.9441, 2657.4805);
	angles[178] = (0, 166.7345, 0);
	at[178] = 71.6667;
	points[179] = (-3827.6772, -523.9252, 2659.9253);
	angles[179] = (0, 173.9967, 0);
	at[179] = 72;
	points[180] = (-3835.7205, -732.1024, 2670.3110);
	angles[180] = (0, 177.6579, 0);
	at[180] = 72.3333;
	points[181] = (-3836.1772, -938.9567, 2676.8503);
	angles[181] = (0, 180.0012, 0);
	at[181] = 72.6667;
	points[182] = (-3824.5081, -1146.2953, 2672.0159);
	angles[182] = (0, 183.6729, 0);
	at[182] = 73;
	points[183] = (-3779.7126, -1338.8583, 2630.2439);
	angles[183] = (0, 194.2854, 0);
	at[183] = 73.3333;
	points[184] = (-3710.1772, -1520.7834, 2558.8584);
	angles[184] = (0, 200.4547, 0);
	at[184] = 73.6667;
	points[185] = (-3560.0276, -1876.5748, 2406.3542);
	angles[185] = (0, 203.2785, 0);
	at[185] = 74.3333;
	points[186] = (-3482.0552, -2052.7205, 2330.2993);
	angles[186] = (0, 203.8994, 0);
	at[186] = 74.6667;
	points[187] = (-3400.8425, -2230.8503, 2256.4646);
	angles[187] = (0, 204.5617, 0);
	at[187] = 75;
	points[188] = (-3313.6692, -2406.0393, 2203.7126);
	angles[188] = (0, 207.0985, 0);
	at[188] = 75.3333;
	points[189] = (-3204.8503, -2581.1104, 2195.0198);
	angles[189] = (0, 211.8252, 0);
	at[189] = 75.6667;
	points[190] = (-3089.1338, -2752.9370, 2202.3899);
	angles[190] = (0, 213.8795, 0);
	at[190] = 76;
	points[191] = (-2972.0864, -2923.8228, 2213.7480);
	angles[191] = (0, 214.2377, 0);
	at[191] = 76.3333;
	points[192] = (-2745.6851, -3268.5747, 2214.5669);
	angles[192] = (0, 213.1035, 0);
	at[192] = 77;
	points[193] = (-2642.5825, -3446.8152, 2214.5669);
	angles[193] = (0, 208.3722, 0);
	at[193] = 77.3333;
	points[194] = (-2623.4568, -3652.2520, 2214.5669);
	angles[194] = (0, 185.6300, 0);
	at[194] = 77.6667;
	points[195] = (-2623.3899, -3714.4568, 2214.5669);
	angles[195] = (0, 183.1461, 0);
	at[195] = 77.7667;
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
	points[0] = (4378.5830, 1015.3149, 1919.2914);
	angles[0] = (0, 50, 0);
	at[0] = 0;
	points[1] = (4272.8345, 1155.7992, 1919.2914);
	angles[1] = (0, 39.4541, 0);
	at[1] = 0.2833;
	points[2] = (4166.2993, 1295.4921, 1919.2914);
	angles[2] = (0, 37.6883, 0);
	at[2] = 0.5667;
	points[3] = (4068.8584, 1441.1693, 1919.2914);
	angles[3] = (0, 32.8817, 0);
	at[3] = 0.8500;
	points[4] = (3896.3188, 1747.2795, 1919.2914);
	angles[4] = (0, 29.5020, 0);
	at[4] = 1.4167;
	points[5] = (3857.8740, 1917.0906, 1919.2914);
	angles[5] = (0, 13.8879, 0);
	at[5] = 1.7000;
	points[6] = (3829.7441, 2090.5117, 1919.2914);
	angles[6] = (0, 9.9934, 0);
	at[6] = 1.9833;
	points[7] = (3784.0828, 2438.8860, 1919.2914);
	angles[7] = (0, 7.0558, 0);
	at[7] = 2.5500;
	points[8] = (3765.1812, 2613.5552, 1919.2914);
	angles[8] = (0, 6.3227, 0);
	at[8] = 2.8333;
	points[9] = (3735.2324, 2786.6301, 1919.2914);
	angles[9] = (0, 9.5159, 0);
	at[9] = 3.1167;
	points[10] = (3710.2283, 2958.2993, 1941.9960);
	angles[10] = (0, 8.0760, 0);
	at[10] = 3.4000;
	points[11] = (3555.1892, 4156.1421, 2173.6104);
	angles[11] = (0, 7.3750, 0);
	at[11] = 5.3833;
	points[12] = (3528.0471, 4328.5825, 2185.0393);
	angles[12] = (0, 9.0909, 0);
	at[12] = 5.6667;
	points[13] = (3408.9370, 5021.1421, 2185.0393);
	angles[13] = (0, 9.7576, 0);
	at[13] = 6.8000;
	points[14] = (3237.0789, 5882.5986, 2185.0393);
	angles[14] = (0, 11.3388, 0);
	at[14] = 8.2167;
	points[15] = (3187.2952, 6230.4336, 2185.0393);
	angles[15] = (0, 8.1250, 0);
	at[15] = 8.7833;
	points[16] = (3157.5237, 6403.1895, 2190.7795);
	angles[16] = (0, 10.4130, 0);
	at[16] = 9.0667;
	points[17] = (2738.0237, 8282.5596, 2354.5195);
	angles[17] = (0, 12.5829, 0);
	at[17] = 12.1833;
	points[18] = (2691.2522, 8451.3389, 2362.2048);
	angles[18] = (0, 16.2601, 0);
	at[18] = 12.4667;
	points[19] = (2635.2637, 8617.8740, 2362.2048);
	angles[19] = (0, 18.1948, 0);
	at[19] = 12.7500;
	points[20] = (2444.3149, 9109.0947, 2362.2048);
	angles[20] = (0, 21.0794, 0);
	at[20] = 13.6000;
	points[21] = (2209.6025, 9771.4961, 2362.2048);
	angles[21] = (0, 19.5123, 0);
	at[21] = 14.7333;
	points[22] = (2130.3308, 9927.8350, 2362.2048);
	angles[22] = (0, 26.6519, 0);
	at[22] = 15.0167;
	points[23] = (1961.1891, 10235.8262, 2362.2048);
	angles[23] = (0, 28.7157, 0);
	at[23] = 15.5833;
	points[24] = (1872.7717, 10387.4805, 2362.2048);
	angles[24] = (0, 30.9650, 0);
	at[24] = 15.8667;
	points[25] = (1675.5159, 10678.2676, 2362.2048);
	angles[25] = (0, 34.0618, 0);
	at[25] = 16.4333;
	points[26] = (1580.0393, 10825.7080, 2362.2048);
	angles[26] = (0, 32.5934, 0);
	at[26] = 16.7167;
	points[27] = (1487.8976, 10975.2754, 2362.2048);
	angles[27] = (0, 31.7927, 0);
	at[27] = 17;
	points[28] = (1393.4489, 11122.9531, 2362.2048);
	angles[28] = (0, 34.6179, 0);
	at[28] = 17.2833;
	points[29] = (1264.2795, 11242.0479, 2362.2048);
	angles[29] = (0, 45.1986, 0);
	at[29] = 17.5667;
	points[30] = (1136.0079, 11361.7715, 2359.6536);
	angles[30] = (0, 46.2775, 0);
	at[30] = 17.8500;
	points[31] = (536.6181, 11990.1973, 2227.3662);
	angles[31] = (0, 43.6463, 0);
	at[31] = 19.2667;
	points[32] = (402.1299, 12099.7246, 2214.5669);
	angles[32] = (0, 52.1418, 0);
	at[32] = 19.5500;
	points[33] = (253.9559, 12194.1338, 2214.5669);
	angles[33] = (0, 56.6066, 0);
	at[33] = 19.8333;
	points[34] = (-190.5677, 12477.3232, 2214.5669);
	angles[34] = (0, 57.4957, 0);
	at[34] = 20.6833;
	points[35] = (-346.4232, 12553.0312, 2214.5669);
	angles[35] = (0, 66.9521, 0);
	at[35] = 20.9667;
	points[36] = (-518.1575, 12590.0791, 2214.5669);
	angles[36] = (0, 76.0042, 0);
	at[36] = 21.2500;
	points[37] = (-1376.8346, 12775.3936, 2214.5669);
	angles[37] = (0, 77.8212, 0);
	at[37] = 22.6667;
	points[38] = (-1540.1890, 12762.8740, 2214.5669);
	angles[38] = (0, 99.8558, 0);
	at[38] = 22.9500;
	points[39] = (-1690.2205, 12671.4570, 2214.5669);
	angles[39] = (0, 117.7359, 0);
	at[39] = 23.2333;
	points[40] = (-1840.2479, 12580.0391, 2214.5669);
	angles[40] = (0, 120.7525, 0);
	at[40] = 23.5167;
	points[41] = (-2440.3623, 12214.3301, 2214.5669);
	angles[41] = (0, 121.3561, 0);
	at[41] = 24.6500;
	points[42] = (-2537.7520, 12073.1494, 2242.9016);
	angles[42] = (0, 142.8317, 0);
	at[42] = 24.9333;
	points[43] = (-2629.5747, 11926.6543, 2274.2322);
	angles[43] = (0, 147.0642, 0);
	at[43] = 25.2167;
	points[44] = (-3088.6851, 11194.2910, 2430.8857);
	angles[44] = (0, 147.9165, 0);
	at[44] = 26.6333;
	points[45] = (-3178.1418, 11045.2363, 2450.7874);
	angles[45] = (0, 149.5020, 0);
	at[45] = 26.9167;
	points[46] = (-3434.1692, 10584.5273, 2450.7874);
	angles[46] = (0, 150.9311, 0);
	at[46] = 27.7667;
	points[47] = (-3537.4175, 10442.8340, 2450.7874);
	angles[47] = (0, 144.0018, 0);
	at[47] = 28.0500;
	points[48] = (-3645.7246, 10304.5273, 2450.7874);
	angles[48] = (0, 142.2850, 0);
	at[48] = 28.3333;
	points[49] = (-4512.4409, 9198.0322, 2450.7874);
	angles[49] = (0, 141.7990, 0);
	at[49] = 30.6000;
	points[50] = (-5711.8501, 7682.7168, 2450.7874);
	angles[50] = (0, 141.6376, 0);
	at[50] = 33.7167;
	points[51] = (-5816.8896, 7542.2441, 2451.7322);
	angles[51] = (0, 144.5609, 0);
	at[51] = 34;
	points[52] = (-5991.6929, 7237.5986, 2461.9844);
	angles[52] = (0, 150, 0);
	at[52] = 34.5667;
	points[53] = (-6778.2676, 5866.6934, 2508.1221);
	angles[53] = (0, 150.1549, 0);
	at[53] = 37.1167;
	points[54] = (-6806.3784, 5698.8584, 2509.8425);
	angles[54] = (0, 171.8418, 0);
	at[54] = 37.4000;
	points[55] = (-6804.5278, 5523.1890, 2509.8425);
	angles[55] = (0, 179.1362, 0);
	at[55] = 37.6833;
	points[56] = (-6793.5039, 4469.0947, 2509.8425);
	angles[56] = (0, 180.5988, 0);
	at[56] = 39.3833;
	points[57] = (-6706.4175, 4322.3623, 2509.8425);
	angles[57] = (0, 208.3405, 0);
	at[57] = 39.6667;
	points[58] = (-6600.9839, 4181.8110, 2509.8425);
	angles[58] = (0, 215.4427, 0);
	at[58] = 39.9500;
	points[59] = (-5546.9292, 2776.2283, 2509.8425);
	angles[59] = (0, 216.8668, 0);
	at[59] = 42.7833;
	points[60] = (-5426.2598, 2651.4175, 2509.8425);
	angles[60] = (0, 226.2080, 0);
	at[60] = 43.0667;
	points[61] = (-5282.5981, 2550.2952, 2509.8425);
	angles[61] = (0, 233.4156, 0);
	at[61] = 43.3500;
	points[62] = (-5138.9375, 2449.1772, 2509.8425);
	angles[62] = (0, 234.6198, 0);
	at[62] = 43.6333;
	points[63] = (-3989.5669, 1640.2126, 2509.8425);
	angles[63] = (0, 236.4467, 0);
	at[63] = 45.9000;
	points[64] = (-3831.5786, 1590.9607, 2571.6064);
	angles[64] = (0, 249.0346, 0);
	at[64] = 46.1833;
	points[65] = (-3674.3071, 1539.1653, 2630.3386);
	angles[65] = (0, 251.3080, 0);
	at[65] = 46.4667;
	points[66] = (-2101.5945, 1021.1969, 3217.6692);
	angles[66] = (0, 251.7708, 0);
	at[66] = 49.3000;
	points[67] = (-1937.8070, 974.4646, 3248.0315);
	angles[67] = (0, 254.6541, 0);
	at[67] = 49.5833;
	points[68] = (-1084.4567, 766.3622, 3248.0315);
	angles[68] = (0, 255.2150, 0);
	at[68] = 51;
	points[69] = (-919.2047, 706.7166, 3248.0315);
	angles[69] = (0, 250.9977, 0);
	at[69] = 51.2833;
	points[70] = (-92.9346, 408.4764, 3248.0315);
	angles[70] = (0, 250.1533, 0);
	at[70] = 52.7000;
	points[71] = (75.1484, 358.1107, 3248.0315);
	angles[71] = (0, 253.9212, 0);
	at[71] = 52.9833;
	points[72] = (756.8505, 187.3878, 3248.0315);
	angles[72] = (0, 255.9387, 0);
	at[72] = 54.1167;
	points[73] = (926.4528, 141.6303, 3248.0315);
	angles[73] = (0, 254.6700, 0);
	at[73] = 54.4000;
	points[74] = (1940.0433, -147.8543, 3248.0315);
	angles[74] = (0, 254.5937, 0);
	at[74] = 56.1000;
	points[75] = (2790.3660, -368.3378, 3248.0315);
	angles[75] = (0, 255.4636, 0);
	at[75] = 57.5167;
	points[76] = (3464.4883, -566.8661, 3248.0315);
	angles[76] = (0, 253.5428, 0);
	at[76] = 58.6500;
	points[77] = (3634.1616, -610.5826, 3248.0315);
	angles[77] = (0, 257.2557, 0);
	at[77] = 58.9333;
	points[78] = (3809, -627.8149, 3248.0315);
	angles[78] = (0, 263.1834, 0);
	at[78] = 59.2167;
	points[79] = (4158.7007, -662.2795, 3248.0315);
	angles[79] = (0, 264.3383, 0);
	at[79] = 59.7833;
	points[80] = (4324.1733, -671.8307, 3231.2402);
	angles[80] = (0, 269.7672, 0);
	at[80] = 60.0667;
	points[81] = (4421.8896, -625.7048, 3092.7009);
	angles[81] = (0, 288.6642, 0);
	at[81] = 60.3500;
	points[82] = (4519.6064, -579.5787, 2954.1614);
	angles[82] = (0, 294.0475, 0);
	at[82] = 60.6333;
	points[83] = (4910.3936, -395.0709, 2400.0120);
	angles[83] = (0, 295.2711, 0);
	at[83] = 61.7667;
	points[84] = (5020.3545, -285.6331, 2362.2048);
	angles[84] = (0, 314.6155, 0);
	at[84] = 62.0500;
	points[85] = (5249.4883, -19.2285, 2362.2048);
	angles[85] = (0, 319.1749, 0);
	at[85] = 62.6167;
	points[86] = (5313.4648, 126.4811, 2362.2048);
	angles[86] = (0, 343.0663, 0);
	at[86] = 62.9000;
	points[87] = (5274.2124, 297.7303, 2362.2048);
	angles[87] = (0, 367.8370, 0);
	at[87] = 63.1833;
	points[88] = (5207.7954, 424.6457, 2306.0747);
	angles[88] = (0, 390.1910, 0);
	at[88] = 63.4667;
	points[89] = (5107.9922, 497.0512, 2180.9409);
	angles[89] = (0, 409.0778, 0);
	at[89] = 63.7500;
	points[90] = (4908.3462, 641.8622, 1930.6653);
	angles[90] = (0, 413.9004, 0);
	at[90] = 64.3167;
	points[91] = (4766.1812, 736.7677, 1919.2914);
	angles[91] = (0, 416.0438, 0);
	at[91] = 64.6000;
	points[92] = (4619.8032, 833.9213, 1919.2914);
	angles[92] = (0, 416.3638, 0);
	at[92] = 64.8833;
	points[93] = (4475.6694, 934.1024, 1919.2914);
	angles[93] = (0, 414.2410, 0);
	at[93] = 65.1667;
	points[94] = (4378.5830, 1015.3149, 1919.2914);
	angles[94] = (0, 410, 0);
	at[94] = 65.3667;
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
	points[0] = (5268.6221, -8668.2676, 1663.4409);
	angles[0] = (0, -32.4872, 0);
	at[0] = 0;
	points[1] = (5592.4014, -8874.4492, 1663.4409);
	angles[1] = (0, -32.4872, 0);
	at[1] = 1.0833;
	points[2] = (5612.3623, -8887.1260, 1663.4409);
	angles[2] = (0, -31.7728, 0);
	at[2] = 1.1667;
	points[3] = (5612.3623, -8887.1260, 1663.4409);
	angles[3] = (0, -31.7728, 0);
	at[3] = 1.5000;
	points[4] = (5617.3623, -8890.2363, 1663.3740);
	angles[4] = (0, -31.7728, 0);
	at[4] = 1.5833;
	points[5] = (6018.9766, -9139.0156, 1658.0355);
	angles[5] = (0, -31.7728, 0);
	at[5] = 2.9167;
	points[6] = (6039.0552, -9151.4170, 1657.7677);
	angles[6] = (0, -30.7032, 0);
	at[6] = 3;
	points[7] = (6039.0552, -9151.4170, 1657.7677);
	angles[7] = (0, -30.7032, 0);
	at[7] = 3.3333;
	points[8] = (6044.0947, -9154.3701, 1656.7953);
	angles[8] = (0, -30.7032, 0);
	at[8] = 3.4167;
	points[9] = (6371.7720, -9348.9375, 1610.6576);
	angles[9] = (0, -30.7032, 0);
	at[9] = 4.5000;
	points[10] = (6386.8901, -9357.9531, 1608.5276);
	angles[10] = (0, -30.2995, 0);
	at[10] = 4.5833;
	points[11] = (6386.8901, -9357.9531, 1608.5276);
	angles[11] = (0, -30.2995, 0);
	at[11] = 4.9167;
	points[12] = (6396.9292, -9363.7402, 1606.2125);
	angles[12] = (0, -30.2995, 0);
	at[12] = 5;
	points[13] = (6723.4248, -9554.5273, 1540.2638);
	angles[13] = (0, -30.2995, 0);
	at[13] = 6.0833;
	points[14] = (6728.4248, -9557.4805, 1539.2480);
	angles[14] = (0, -30.8696, 0);
	at[14] = 6.1667;
	points[15] = (6728.4248, -9557.4805, 1539.2480);
	angles[15] = (0, -30.8696, 0);
	at[15] = 6.5000;
	points[16] = (6748.1099, -9569.2520, 1533.4882);
	angles[16] = (0, -30.8696, 0);
	at[16] = 6.5833;
	points[17] = (7068.3071, -9760.6699, 1443.1733);
	angles[17] = (0, -30.8696, 0);
	at[17] = 7.6667;
	points[18] = (7078.1890, -9766.5752, 1440.3937);
	angles[18] = (0, -30.8696, 0);
	at[18] = 7.7500;
	points[19] = (7078.1890, -9766.5752, 1440.3937);
	angles[19] = (0, -30.8696, 0);
	at[19] = 8.0833;
	points[20] = (7061.2603, -9756.4570, 1445.1692);
	angles[20] = (0, -30.8696, 0);
	at[20] = 8.1667;
	points[21] = (6741.0239, -9565.0391, 1535.4843);
	angles[21] = (0, -30.8696, 0);
	at[21] = 9.2500;
	points[22] = (6721.2988, -9553.2285, 1541.0435);
	angles[22] = (0, -30.2995, 0);
	at[22] = 9.3333;
	points[23] = (6721.2988, -9553.2285, 1541.0435);
	angles[23] = (0, -30.2995, 0);
	at[23] = 9.6667;
	points[24] = (6716.1812, -9550.3154, 1541.7245);
	angles[24] = (0, -30.2995, 0);
	at[24] = 9.7500;
	points[25] = (6389.6851, -9359.5273, 1607.6693);
	angles[25] = (0, -30.2995, 0);
	at[25] = 10.8333;
	points[26] = (6379.6455, -9353.6611, 1609.6968);
	angles[26] = (0, -30.7032, 0);
	at[26] = 10.9167;
	points[27] = (6379.6455, -9353.6611, 1609.6968);
	angles[27] = (0, -30.7032, 0);
	at[27] = 11.2500;
	points[28] = (6364.5273, -9344.6455, 1611.6771);
	angles[28] = (0, -30.7032, 0);
	at[28] = 11.3333;
	points[29] = (6036.8506, -9150.0791, 1657.8151);
	angles[29] = (0, -31.7728, 0);
	at[29] = 12.4167;
	points[30] = (6036.8506, -9150.0791, 1657.8151);
	angles[30] = (0, -31.7728, 0);
	at[30] = 12.8333;
	points[31] = (5610.1577, -8885.7881, 1663.4686);
	angles[31] = (0, -32.4872, 0);
	at[31] = 14.2500;
	points[32] = (5610.1577, -8885.7881, 1663.4686);
	angles[32] = (0, -32.4872, 0);
	at[32] = 14.6667;
	points[33] = (5261.4570, -8663.7012, 1663.4409);
	angles[33] = (0, -32.4872, 0);
	at[33] = 15.8333;
	points[34] = (5261.4570, -8663.7012, 1663.4409);
	angles[34] = (0, -32.4872, 0);
	at[34] = 16.2500;
	points[35] = (5268.6221, -8668.2676, 1663.4409);
	angles[35] = (0, -32.4872, 0);
	at[35] = 16.2667;
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
	points[0] = (-3269.7795, -2512.3977, 1646.4606);
	angles[0] = (0, 159.3877, 0);
	at[0] = 0;
	points[1] = (-3685.7915, -2355.9253, 1584.0906);
	angles[1] = (0, 158.6411, 0);
	at[1] = 1.2667;
	points[2] = (-3685.7915, -2355.9253, 1584.0906);
	angles[2] = (0, 158.6411, 0);
	at[2] = 1.6667;
	points[3] = (-3702.0237, -2349.5315, 1580.9922);
	angles[3] = (0, 158.6411, 0);
	at[3] = 1.7333;
	points[4] = (-3983.8977, -2239.3032, 1529.0079);
	angles[4] = (0, 158.6411, 0);
	at[4] = 2.6000;
	points[5] = (-4000.1575, -2232.9448, 1526.0079);
	angles[5] = (0, 160.7867, 0);
	at[5] = 2.6667;
	points[6] = (-4000.1575, -2232.9448, 1526.0079);
	angles[6] = (0, 160.7867, 0);
	at[6] = 3.0667;
	points[7] = (-4304.8428, -2126.8149, 1453.4409);
	angles[7] = (0, 160.7867, 0);
	at[7] = 4;
	points[8] = (-4310.2759, -2124.9214, 1452.1456);
	angles[8] = (0, 159.9416, 0);
	at[8] = 4.0667;
	points[9] = (-4310.2759, -2124.9214, 1452.1456);
	angles[9] = (0, 159.9416, 0);
	at[9] = 4.4000;
	points[10] = (-4321.3779, -2120.7874, 1451.2244);
	angles[10] = (0, 159.9416, 0);
	at[10] = 4.4667;
	points[11] = (-4717.6382, -1976.0906, 1398.2441);
	angles[11] = (0, 158.5891, 0);
	at[11] = 5.6667;
	points[12] = (-4717.6382, -1976.0906, 1398.2441);
	angles[12] = (0, 158.5891, 0);
	at[12] = 6.0667;
	points[13] = (-4734.1338, -1969.5039, 1398.8505);
	angles[13] = (0, 158.5891, 0);
	at[13] = 6.1333;
	points[14] = (-5086.0234, -1831.5315, 1398.9409);
	angles[14] = (0, 158.5891, 0);
	at[14] = 7.2000;
	points[15] = (-5091.4961, -1829.3740, 1398.9409);
	angles[15] = (0, 158.5891, 0);
	at[15] = 7.2667;
	points[16] = (-5091.4961, -1829.3740, 1398.9409);
	angles[16] = (0, 158.5891, 0);
	at[16] = 7.6000;
	points[17] = (-5076.6143, -1835.2164, 1398.9409);
	angles[17] = (0, 158.5891, 0);
	at[17] = 7.6667;
	points[18] = (-4724.7642, -1973.1890, 1398.8505);
	angles[18] = (0, 158.5891, 0);
	at[18] = 8.7333;
	points[19] = (-4708.2676, -1979.6536, 1398.8427);
	angles[19] = (0, 159.9416, 0);
	at[19] = 8.8000;
	points[20] = (-4708.2676, -1979.6536, 1398.8427);
	angles[20] = (0, 159.9416, 0);
	at[20] = 9.2000;
	points[21] = (-4311.9688, -2124.2205, 1452.4843);
	angles[21] = (0, 159.9416, 0);
	at[21] = 10.4000;
	points[22] = (-4300.9448, -2128.2402, 1453.9567);
	angles[22] = (0, 160.7867, 0);
	at[22] = 10.4667;
	points[23] = (-4300.9448, -2128.2402, 1453.9567);
	angles[23] = (0, 160.7867, 0);
	at[23] = 10.8000;
	points[24] = (-4295.5513, -2130.0552, 1455.6534);
	angles[24] = (0, 160.7867, 0);
	at[24] = 10.8667;
	points[25] = (-4012.6377, -2228.6536, 1522.9685);
	angles[25] = (0, 160.7867, 0);
	at[25] = 11.7333;
	points[26] = (-3996.2991, -2234.3425, 1526.8505);
	angles[26] = (0, 158.6411, 0);
	at[26] = 11.8000;
	points[27] = (-3996.2991, -2234.3425, 1526.8505);
	angles[27] = (0, 158.6411, 0);
	at[27] = 12.2000;
	points[28] = (-3692.7598, -2353.1536, 1582.7008);
	angles[28] = (0, 158.6411, 0);
	at[28] = 13.1333;
	points[29] = (-3681.9211, -2357.3938, 1584.7008);
	angles[29] = (0, 159.3877, 0);
	at[29] = 13.2000;
	points[30] = (-3681.9211, -2357.3938, 1584.7008);
	angles[30] = (0, 159.3877, 0);
	at[30] = 13.5333;
	points[31] = (-3676.4370, -2359.4451, 1585.4961);
	angles[31] = (0, 159.3877, 0);
	at[31] = 13.6000;
	points[32] = (-3260.4250, -2515.9136, 1647.8623);
	angles[32] = (0, 159.3877, 0);
	at[32] = 14.8667;
	points[33] = (-3260.4250, -2515.9136, 1647.8623);
	angles[33] = (0, 159.3877, 0);
	at[33] = 15.2667;
	points[34] = (-3269.7795, -2512.3977, 1646.4606);
	angles[34] = (0, 159.3877, 0);
	at[34] = 15.3000;
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
	points[0] = (-5813.9766, -1112.5630, 1399.0670);
	angles[0] = (0, 2.0221, 0);
	at[0] = 0;
	points[1] = (-4397.5195, -1062.5551, 1399.0631);
	angles[1] = (0, 2.0221, 0);
	at[1] = 4;
	points[2] = (-4385.7090, -1062.1378, 1399.0631);
	angles[2] = (0, 5.0556, 0);
	at[2] = 4.1000;
	points[3] = (-4385.7090, -1062.1378, 1399.0631);
	angles[3] = (0, 5.0556, 0);
	at[3] = 4.4000;
	points[4] = (-4368.5435, -1060.5315, 1403.2126);
	angles[4] = (0, 5.0556, 0);
	at[4] = 4.5000;
	points[5] = (-4161.6929, -1042.2362, 1448.9055);
	angles[5] = (0, 5.0556, 0);
	at[5] = 5.1000;
	points[6] = (-4150.1968, -1041.2166, 1451.4448);
	angles[6] = (0, 4.3220, 0);
	at[6] = 5.2000;
	points[7] = (-4150.1968, -1041.2166, 1451.4448);
	angles[7] = (0, 4.3220, 0);
	at[7] = 5.5000;
	points[8] = (-4133.0713, -1039.9489, 1455.7992);
	angles[8] = (0, 4.3220, 0);
	at[8] = 5.6000;
	points[9] = (-3927.4175, -1024.4055, 1507.3308);
	angles[9] = (0, 4.3220, 0);
	at[9] = 6.2000;
	points[10] = (-3898.8503, -1022.2480, 1514.4882);
	angles[10] = (0, 3.3525, 0);
	at[10] = 6.3000;
	points[11] = (-3898.8503, -1022.2480, 1514.4882);
	angles[11] = (0, 3.3525, 0);
	at[11] = 6.7000;
	points[12] = (-3516.1499, -999.8898, 1584.9291);
	angles[12] = (0, 3.3525, 0);
	at[12] = 7.8000;
	points[13] = (-3481.3621, -997.8504, 1591.3503);
	angles[13] = (0, 0.9396, 0);
	at[13] = 7.9000;
	points[14] = (-3481.3621, -997.8504, 1591.3503);
	angles[14] = (0, 0.9396, 0);
	at[14] = 8.3000;
	points[15] = (-3452.0671, -997.4449, 1595.0472);
	angles[15] = (0, 0.9396, 0);
	at[15] = 8.4000;
	points[16] = (-2995.3071, -989.9528, 1654.1693);
	angles[16] = (0, 0.9396, 0);
	at[16] = 9.7000;
	points[17] = (-2983.5947, -989.7599, 1655.6851);
	angles[17] = (0, 0.9396, 0);
	at[17] = 9.8000;
	points[18] = (-2983.5947, -989.7599, 1655.6851);
	angles[18] = (0, 0.9396, 0);
	at[18] = 10.1000;
	points[19] = (-3005.1023, -990.1141, 1652.9016);
	angles[19] = (0, 0.9396, 0);
	at[19] = 10.2000;
	points[20] = (-3461.8582, -997.6063, 1593.7795);
	angles[20] = (0, 0.9396, 0);
	at[20] = 11.5000;
	points[21] = (-3485.2834, -997.9882, 1590.7480);
	angles[21] = (0, 3.3525, 0);
	at[21] = 11.6000;
	points[22] = (-3485.2834, -997.9882, 1590.7480);
	angles[22] = (0, 3.3525, 0);
	at[22] = 11.9000;
	points[23] = (-3491.0591, -998.4174, 1589.5591);
	angles[23] = (0, 3.3525, 0);
	at[23] = 12;
	points[24] = (-3873.7085, -1020.8347, 1518.9016);
	angles[24] = (0, 3.3525, 0);
	at[24] = 13.1000;
	points[25] = (-3902.6970, -1022.5315, 1513.5472);
	angles[25] = (0, 4.3220, 0);
	at[25] = 13.2000;
	points[26] = (-3902.6970, -1022.5315, 1513.5472);
	angles[26] = (0, 4.3220, 0);
	at[26] = 13.6000;
	points[27] = (-4142.6377, -1040.6732, 1453.4055);
	angles[27] = (0, 4.3220, 0);
	at[27] = 14.3000;
	points[28] = (-4154.0552, -1041.5354, 1450.5394);
	angles[28] = (0, 5.0556, 0);
	at[28] = 14.4000;
	points[29] = (-4154.0552, -1041.5354, 1450.5394);
	angles[29] = (0, 5.0556, 0);
	at[29] = 14.7000;
	points[30] = (-4171.2993, -1043.0867, 1446.7834);
	angles[30] = (0, 5.0556, 0);
	at[30] = 14.8000;
	points[31] = (-4378.1499, -1061.3820, 1401.0906);
	angles[31] = (0, 5.0556, 0);
	at[31] = 15.4000;
	points[32] = (-4389.6064, -1062.3976, 1398.5513);
	angles[32] = (0, 2.0221, 0);
	at[32] = 15.5000;
	points[33] = (-4389.6064, -1062.3976, 1398.5513);
	angles[33] = (0, 2.0221, 0);
	at[33] = 15.8000;
	points[34] = (-4407.4014, -1062.9016, 1399.0631);
	angles[34] = (0, 2.0221, 0);
	at[34] = 15.9000;
	points[35] = (-5823.8188, -1112.9133, 1399.0670);
	angles[35] = (0, 2.0221, 0);
	at[35] = 19.9000;
	points[36] = (-5823.8188, -1112.9133, 1399.0670);
	angles[36] = (0, 2.0221, 0);
	at[36] = 20.3000;
	points[37] = (-5813.9766, -1112.5630, 1399.0670);
	angles[37] = (0, 2.0221, 0);
	at[37] = 20.3333;
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
	points[0] = (-3619.2915, 1387.7324, 1656.1219);
	angles[0] = (0, -168.1410, 0);
	at[0] = 0;
	points[1] = (-4100.7480, 1286.6300, 1592.5906);
	angles[1] = (0, -168.1410, 0);
	at[1] = 1.4000;
	points[2] = (-4129.4097, 1280.6102, 1588.8110);
	angles[2] = (0, -167.4747, 0);
	at[2] = 1.5000;
	points[3] = (-4129.4097, 1280.6102, 1588.8110);
	angles[3] = (0, -167.4747, 0);
	at[3] = 1.9000;
	points[4] = (-4469.5278, 1205.0355, 1524.3071);
	angles[4] = (0, -167.4747, 0);
	at[4] = 2.9000;
	points[5] = (-4475.1968, 1203.7755, 1523.2363);
	angles[5] = (0, -168.2328, 0);
	at[5] = 3;
	points[6] = (-4475.1968, 1203.7755, 1523.2363);
	angles[6] = (0, -168.2328, 0);
	at[6] = 3.3000;
	points[7] = (-4497.5986, 1199.1260, 1517.2639);
	angles[7] = (0, -168.2328, 0);
	at[7] = 3.4000;
	points[8] = (-4867.0869, 1122.1575, 1419.9843);
	angles[8] = (0, -168.2328, 0);
	at[8] = 4.5000;
	points[9] = (-4889.4883, 1117.4922, 1414.0867);
	angles[9] = (0, -165.6219, 0);
	at[9] = 4.6000;
	points[10] = (-4889.4883, 1117.4922, 1414.0867);
	angles[10] = (0, -165.6219, 0);
	at[10] = 4.9000;
	points[11] = (-4895.2363, 1115.8466, 1414.2717);
	angles[11] = (0, -165.6219, 0);
	at[11] = 5;
	points[12] = (-5100.6299, 1063.2047, 1398.3347);
	angles[12] = (0, -164.7267, 0);
	at[12] = 5.6000;
	points[13] = (-5100.6299, 1063.2047, 1398.3347);
	angles[13] = (0, -164.7267, 0);
	at[13] = 6;
	points[14] = (-5129.0947, 1055.4016, 1398.4685);
	angles[14] = (0, -164.7267, 0);
	at[14] = 6.1000;
	points[15] = (-5505.0786, 952.7284, 1398.7401);
	angles[15] = (0, -164.7267, 0);
	at[15] = 7.2000;
	points[16] = (-5522.1655, 948.0630, 1398.7521);
	angles[16] = (0, -167.7260, 0);
	at[16] = 7.3000;
	points[17] = (-5522.1655, 948.0630, 1398.7521);
	angles[17] = (0, -167.7260, 0);
	at[17] = 7.6000;
	points[18] = (-5533.7407, 945.6850, 1398.7560);
	angles[18] = (0, -167.7260, 0);
	at[18] = 7.7000;
	points[19] = (-5810.7480, 885.4213, 1398.8701);
	angles[19] = (0, -167.7260, 0);
	at[19] = 8.5000;
	points[20] = (-5833.8188, 880.4016, 1398.8781);
	angles[20] = (0, -170.8437, 0);
	at[20] = 8.6000;
	points[21] = (-5833.8188, 880.4016, 1398.8781);
	angles[21] = (0, -170.8437, 0);
	at[21] = 8.9000;
	points[22] = (-5839.6851, 879.5748, 1398.8820);
	angles[22] = (0, -170.8437, 0);
	at[22] = 9;
	points[23] = (-6224.4883, 817.5512, 1399.0631);
	angles[23] = (0, -170.8437, 0);
	at[23] = 10.1000;
	points[24] = (-6241.9688, 814.7323, 1399.0709);
	angles[24] = (0, -170.8437, 0);
	at[24] = 10.2000;
	points[25] = (-6241.9688, 814.7323, 1399.0709);
	angles[25] = (0, -170.8437, 0);
	at[25] = 10.5000;
	points[26] = (-6227.9131, 817, 1399.0631);
	angles[26] = (0, -170.8437, 0);
	at[26] = 10.6000;
	points[27] = (-5843.1099, 879.0197, 1398.8820);
	angles[27] = (0, -170.8437, 0);
	at[27] = 11.7000;
	points[28] = (-5831.4570, 880.9016, 1398.8781);
	angles[28] = (0, -167.7260, 0);
	at[28] = 11.8000;
	points[29] = (-5831.4570, 880.9016, 1398.8781);
	angles[29] = (0, -167.7260, 0);
	at[29] = 12.1000;
	points[30] = (-5814.1338, 884.6851, 1398.8701);
	angles[30] = (0, -167.7260, 0);
	at[30] = 12.2000;
	points[31] = (-5537.1655, 944.9449, 1398.7560);
	angles[31] = (0, -167.7260, 0);
	at[31] = 13;
	points[32] = (-5514.0557, 949.9646, 1398.7479);
	angles[32] = (0, -164.7267, 0);
	at[32] = 13.1000;
	points[33] = (-5514.0557, 949.9646, 1398.7479);
	angles[33] = (0, -164.7267, 0);
	at[33] = 13.4000;
	points[34] = (-5508.4644, 951.8149, 1398.7401);
	angles[34] = (0, -164.7267, 0);
	at[34] = 13.5000;
	points[35] = (-5098.2681, 1063.8228, 1398.4449);
	angles[35] = (0, -165.6219, 0);
	at[35] = 14.7000;
	points[36] = (-5098.2681, 1063.8228, 1398.4449);
	angles[36] = (0, -165.6219, 0);
	at[36] = 15.1000;
	points[37] = (-5069.7241, 1071.1182, 1400.7324);
	angles[37] = (0, -165.6219, 0);
	at[37] = 15.2000;
	points[38] = (-4898.6221, 1114.9882, 1414.0118);
	angles[38] = (0, -165.6219, 0);
	at[38] = 15.7000;
	points[39] = (-4881.4961, 1119.3740, 1415.3425);
	angles[39] = (0, -168.2328, 0);
	at[39] = 15.8000;
	points[40] = (-4881.4961, 1119.3740, 1415.3425);
	angles[40] = (0, -168.2328, 0);
	at[40] = 16.1000;
	points[41] = (-4870.3936, 1121.4685, 1419.1143);
	angles[41] = (0, -168.2328, 0);
	at[41] = 16.2000;
	points[42] = (-4500.9053, 1198.4409, 1516.3976);
	angles[42] = (0, -168.2328, 0);
	at[42] = 17.3000;
	points[43] = (-4472.9136, 1204.2716, 1523.7678);
	angles[43] = (0, -167.4747, 0);
	at[43] = 17.4000;
	points[44] = (-4472.9136, 1204.2716, 1523.7678);
	angles[44] = (0, -167.4747, 0);
	at[44] = 17.8000;
	points[45] = (-4132.7559, 1279.8544, 1588.0984);
	angles[45] = (0, -167.4747, 0);
	at[45] = 18.8000;
	points[46] = (-4127.0869, 1281.1141, 1589.1693);
	angles[46] = (0, -168.1410, 0);
	at[46] = 18.9000;
	points[47] = (-4127.0869, 1281.1141, 1589.1693);
	angles[47] = (0, -168.1410, 0);
	at[47] = 19.2000;
	points[48] = (-4104.1338, 1285.9213, 1592.1456);
	angles[48] = (0, -168.1410, 0);
	at[48] = 19.3000;
	points[49] = (-3622.6655, 1387.0237, 1655.6771);
	angles[49] = (0, -168.1410, 0);
	at[49] = 20.7000;
	points[50] = (-3611.2009, 1389.4292, 1657.1891);
	angles[50] = (0, -168.1410, 0);
	at[50] = 20.8000;
	points[51] = (-3611.2009, 1389.4292, 1657.1891);
	angles[51] = (0, -168.1410, 0);
	at[51] = 21.1000;
	points[52] = (-3619.2915, 1387.7324, 1656.1219);
	angles[52] = (0, -168.1410, 0);
	at[52] = 21.1667;
	mover = getEnt("iz_obj_6", "targetname");
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
