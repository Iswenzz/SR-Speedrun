main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_sw2_peach_stadium", 0);

	setExpFog(7381.8896, 29681.3477, 0.4627, 0.5725, 0.8118, 0);

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
	ambientPlay("iz_0_sw2ps", 2);
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
	level.iz_route[level.iz_route.size] = (832, 631, 1238);
	level.iz_route[level.iz_route.size] = (832, -489, 1238);
	level.iz_route[level.iz_route.size] = (844, -1694, 1104);
	level.iz_route[level.iz_route.size] = (867, -2834, 934);
	level.iz_route[level.iz_route.size] = (828, -4142, 767);
	level.iz_route[level.iz_route.size] = (577, -5216, 662);
	level.iz_route[level.iz_route.size] = (678, -6024, 608);
	level.iz_route[level.iz_route.size] = (1219, -6772, 578);
	level.iz_route[level.iz_route.size] = (1703, -7442, 563);
	level.iz_route[level.iz_route.size] = (1962, -8150, 557);
	level.iz_route[level.iz_route.size] = (1923, -8891, 561);
	level.iz_route[level.iz_route.size] = (1567, -9574, 580);
	level.iz_route[level.iz_route.size] = (991, -10007, 633);
	level.iz_route[level.iz_route.size] = (170, -10092, 782);
	level.iz_route[level.iz_route.size] = (-787, -9997, 1153);
	level.iz_route[level.iz_route.size] = (-1767, -9786, 1637);
	level.iz_route[level.iz_route.size] = (-2709, -9526, 2112);
	level.iz_route[level.iz_route.size] = (-3658, -9108, 2542);
	level.iz_route[level.iz_route.size] = (-4414, -8542, 2861);
	level.iz_route[level.iz_route.size] = (-5024, -7685, 3183);
	level.iz_route[level.iz_route.size] = (-5321, -6751, 3474);
	level.iz_route[level.iz_route.size] = (-5196, -5777, 3728);
	level.iz_route[level.iz_route.size] = (-4959, -4762, 3974);
	level.iz_route[level.iz_route.size] = (-4969, -3756, 4217);
	level.iz_route[level.iz_route.size] = (-5455, -2874, 4495);
	level.iz_route[level.iz_route.size] = (-6167, -2396, 4750);
	level.iz_route[level.iz_route.size] = (-6969, -1992, 5028);
	level.iz_route[level.iz_route.size] = (-7621, -1404, 5302);
	level.iz_route[level.iz_route.size] = (-7966, -634, 5533);
	level.iz_route[level.iz_route.size] = (-7923, 291, 5726);
	level.iz_route[level.iz_route.size] = (-7577, 1141, 5849);
	level.iz_route[level.iz_route.size] = (-7123, 1908, 5955);
	level.iz_route[level.iz_route.size] = (-6258, 2905, 5773);
	level.iz_route[level.iz_route.size] = (-5274, 3754, 5481);
	level.iz_route[level.iz_route.size] = (-4091, 4234, 5305);
	level.iz_route[level.iz_route.size] = (-2734, 4437, 5137);
	level.iz_route[level.iz_route.size] = (-1463, 4272, 5057);
	level.iz_route[level.iz_route.size] = (-403, 3893, 4998);
	level.iz_route[level.iz_route.size] = (947, 3274, 4576);
	level.iz_route[level.iz_route.size] = (1966, 2711, 4319);
	level.iz_route[level.iz_route.size] = (2813, 2027, 4114);
	level.iz_route[level.iz_route.size] = (3294, 1253, 3947);
	level.iz_route[level.iz_route.size] = (3533, 542, 3848);
	level.iz_route[level.iz_route.size] = (3966, 37, 3863);
	level.iz_route[level.iz_route.size] = (4920, -370, 3784);
	level.iz_route[level.iz_route.size] = (5953, -772, 3736);
	level.iz_route[level.iz_route.size] = (7170, -1239, 3701);
	level.iz_route[level.iz_route.size] = (7974, -1770, 3712);
	level.iz_route[level.iz_route.size] = (8351, -2433, 3678);
	level.iz_route[level.iz_route.size] = (8336, -3159, 3581);
	level.iz_route[level.iz_route.size] = (7994, -3751, 3484);
	level.iz_route[level.iz_route.size] = (7339, -4008, 3357);
	level.iz_route[level.iz_route.size] = (6659, -3849, 3229);
	level.iz_route[level.iz_route.size] = (6121, -3371, 3098);
	level.iz_route[level.iz_route.size] = (5930, -2657, 3012);
	level.iz_route[level.iz_route.size] = (6015, -1858, 2988);
	level.iz_route[level.iz_route.size] = (6191, -1121, 2981);
	level.iz_route[level.iz_route.size] = (6410, -201, 2991);
	level.iz_route[level.iz_route.size] = (6610, 665, 2985);
	level.iz_route[level.iz_route.size] = (6685, 1416, 2931);
	level.iz_route[level.iz_route.size] = (6681, 1950, 2872);
	level.iz_route[level.iz_route.size] = (6646, 2460, 2796);
	level.iz_route[level.iz_route.size] = (6544, 2923, 2715);
	level.iz_route[level.iz_route.size] = (6163, 3462, 2609);
	level.iz_route[level.iz_route.size] = (5524, 3956, 2500);
	level.iz_route[level.iz_route.size] = (4729, 4288, 2451);
	level.iz_route[level.iz_route.size] = (4069, 4531, 2421);
	level.iz_route[level.iz_route.size] = (3488, 4818, 2380);
	level.iz_route[level.iz_route.size] = (3106, 5295, 2334);
	level.iz_route[level.iz_route.size] = (2889, 5850, 2305);
	level.iz_route[level.iz_route.size] = (2866, 6416, 2293);
	level.iz_route[level.iz_route.size] = (2939, 7048, 2295);
	level.iz_route[level.iz_route.size] = (3056, 7757, 2305);
	level.iz_route[level.iz_route.size] = (3153, 8345, 2324);
	level.iz_route[level.iz_route.size] = (3152, 8850, 2342);
	level.iz_route[level.iz_route.size] = (3018, 9300, 2353);
	level.iz_route[level.iz_route.size] = (2834, 9674, 2364);
	level.iz_route[level.iz_route.size] = (2618, 9965, 2368);
	level.iz_route[level.iz_route.size] = (2098, 10435, 2368);
	level.iz_route[level.iz_route.size] = (1445, 10775, 2364);
	level.iz_route[level.iz_route.size] = (744, 10839, 2337);
	level.iz_route[level.iz_route.size] = (30, 10708, 2274);
	level.iz_route[level.iz_route.size] = (-627, 10411, 2152);
	level.iz_route[level.iz_route.size] = (-1151, 9962, 1992);
	level.iz_route[level.iz_route.size] = (-1515, 9376, 1826);
	level.iz_route[level.iz_route.size] = (-1586, 8698, 1648);
	level.iz_route[level.iz_route.size] = (-1442, 8013, 1492);
	level.iz_route[level.iz_route.size] = (-1125, 7320, 1346);
	level.iz_route[level.iz_route.size] = (-661, 6740, 1270);
	level.iz_route[level.iz_route.size] = (-156, 6154, 1235);
	level.iz_route[level.iz_route.size] = (497, 5444, 1235);
	level.iz_route[level.iz_route.size] = (851, 4463, 1235);
	level.iz_route[level.iz_route.size] = (888, 3265, 1236);
	level.iz_route[level.iz_route.size] = (866, 2107, 1238);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (799.3701, -14198.1494, 8562.9922);
	angles[0] = (0, 97.9400, 0);
	at[0] = 0;
	points[1] = (613.5472, -14189.5674, 8562.9922);
	angles[1] = (0, 89.6345, 0);
	at[1] = 0.5000;
	points[2] = (427.7205, -14180.9844, 8562.9922);
	angles[2] = (0, 87.8463, 0);
	at[2] = 1;
	points[3] = (-2173.8545, -14060.9062, 8562.9922);
	angles[3] = (0, 87.3575, 0);
	at[3] = 8;
	points[4] = (-2358.7795, -14041.8896, 8562.9922);
	angles[4] = (0, 84.2501, 0);
	at[4] = 8.5000;
	points[5] = (-5126.9292, -13690.3535, 8562.9922);
	angles[5] = (0, 82.7631, 0);
	at[5] = 16;
	points[6] = (-5298.7012, -13624.3701, 8562.9922);
	angles[6] = (0, 70.0076, 0);
	at[6] = 16.5000;
	points[7] = (-5632.5981, -13460.3154, 8562.9922);
	angles[7] = (0, 64.1230, 0);
	at[7] = 17.5000;
	points[8] = (-7803.1895, -12394.0547, 8562.9922);
	angles[8] = (0, 63.8384, 0);
	at[8] = 24;
	points[9] = (-7936.9297, -12268.6611, 8562.9922);
	angles[9] = (0, 48.2815, 0);
	at[9] = 24.5000;
	points[10] = (-8059.6064, -12128.8184, 8562.9922);
	angles[10] = (0, 42.7755, 0);
	at[10] = 25;
	points[11] = (-9777.4014, -10171.3379, 8562.9922);
	angles[11] = (0, 41.2686, 0);
	at[11] = 32;
	points[12] = (-9888.2676, -10023.2676, 8562.9922);
	angles[12] = (0, 35.7986, 0);
	at[12] = 32.5000;
	points[13] = (-9977.1260, -9859.8428, 8562.9922);
	angles[13] = (0, 30.0998, 0);
	at[13] = 33;
	points[14] = (-10066.0234, -9696.4180, 8562.9922);
	angles[14] = (0, 28.8748, 0);
	at[14] = 33.5000;
	points[15] = (-11310.2764, -7408.5435, 8562.9922);
	angles[15] = (0, 27.9965, 0);
	at[15] = 40.5000;
	points[16] = (-11365.6689, -7230.8662, 8562.9922);
	angles[16] = (0, 19.8468, 0);
	at[16] = 41;
	points[17] = (-11421.9688, -7053.5825, 8562.9922);
	angles[17] = (0, 18.0922, 0);
	at[17] = 41.5000;
	points[18] = (-12210, -4571.2993, 8562.9922);
	angles[18] = (0, 17.6127, 0);
	at[18] = 48.5000;
	points[19] = (-12254.1338, -4391.2598, 8562.9922);
	angles[19] = (0, 13.2044, 0);
	at[19] = 49;
	points[20] = (-12305.9453, -4022.8347, 8562.9922);
	angles[20] = (0, 8.2444, 0);
	at[20] = 50;
	points[21] = (-12642.7168, -1628.0709, 8562.9922);
	angles[21] = (0, 8.0047, 0);
	at[21] = 56.5000;
	points[22] = (-12666.1416, -1443.6300, 8562.9922);
	angles[22] = (0, 6.7750, 0);
	at[22] = 57;
	points[23] = (-12682.7959, -1071.9567, 8562.9922);
	angles[23] = (0, 2.7579, 0);
	at[23] = 58;
	points[24] = (-12799.2910, 1529.7756, 8562.9922);
	angles[24] = (0, 2.5638, 0);
	at[24] = 65;
	points[25] = (-12798.5439, 1715.1890, 8562.9922);
	angles[25] = (0, -1.2976, 0);
	at[25] = 65.5000;
	points[26] = (-12772.9141, 1899.4448, 8562.9922);
	angles[26] = (0, -6.4871, 0);
	at[26] = 66;
	points[27] = (-12747.3623, 2083.7007, 8562.9922);
	angles[27] = (0, -7.6023, 0);
	at[27] = 66.5000;
	points[28] = (-12337.8740, 5031.7715, 8562.9922);
	angles[28] = (0, -7.9071, 0);
	at[28] = 74.5000;
	points[29] = (-12281.9688, 5209.1338, 8562.9922);
	angles[29] = (0, -15.5813, 0);
	at[29] = 75;
	points[30] = (-12225.4727, 5386.3779, 8562.9922);
	angles[30] = (0, -17.2329, 0);
	at[30] = 75.5000;
	points[31] = (-11321.2998, 8222.0869, 8562.9922);
	angles[31] = (0, -17.6843, 0);
	at[31] = 83.5000;
	points[32] = (-11221.8506, 8376.9297, 8562.9922);
	angles[32] = (0, -31.2670, 0);
	at[32] = 84;
	points[33] = (-11108.9365, 8524.7637, 8562.9922);
	angles[33] = (0, -36.0564, 0);
	at[33] = 84.5000;
	points[34] = (-9415.4326, 10742.4805, 8562.9922);
	angles[34] = (0, -37.3667, 0);
	at[34] = 92;
	points[35] = (-9289.1738, 10876.5752, 8562.9922);
	angles[35] = (0, -44.5660, 0);
	at[35] = 92.5000;
	points[36] = (-9138.3857, 10985.5127, 8562.9922);
	angles[36] = (0, -52.0983, 0);
	at[36] = 93;
	points[37] = (-8987.5586, 11094.4102, 8562.9922);
	angles[37] = (0, -53.7194, 0);
	at[37] = 93.5000;
	points[38] = (-6876.2993, 12619.2129, 8562.9922);
	angles[38] = (0, -54.1623, 0);
	at[38] = 100.5000;
	points[39] = (-6710.9058, 12700.3545, 8562.9922);
	angles[39] = (0, -63.9542, 0);
	at[39] = 101;
	points[40] = (-6535.5903, 12762.5596, 8562.9922);
	angles[40] = (0, -69.0649, 0);
	at[40] = 101.5000;
	points[41] = (-6360.2754, 12824.7637, 8562.9922);
	angles[41] = (0, -70.1631, 0);
	at[41] = 102;
	points[42] = (-3905.5432, 13694.5674, 8562.9922);
	angles[42] = (0, -71.2295, 0);
	at[42] = 109;
	points[43] = (-3723.3584, 13732.1650, 8562.9922);
	angles[43] = (0, -76.8126, 0);
	at[43] = 109.5000;
	points[44] = (-3541.1733, 13769.7646, 8562.9922);
	angles[44] = (0, -78.0128, 0);
	at[44] = 110;
	points[45] = (-990.5670, 14296.0625, 8562.9922);
	angles[45] = (0, -78.3407, 0);
	at[45] = 117;
	points[46] = (-805.0906, 14303.6611, 8562.9922);
	angles[46] = (0, -86.2811, 0);
	at[46] = 117.5000;
	points[47] = (-619.0866, 14306.4971, 8562.9922);
	angles[47] = (0, -88.5199, 0);
	at[47] = 118;
	points[48] = (1984.9489, 14345.9443, 8562.9922);
	angles[48] = (0, -89.1319, 0);
	at[48] = 125;
	points[49] = (2169.9724, 14338.3867, 8562.9922);
	angles[49] = (0, -93.3312, 0);
	at[49] = 125.5000;
	points[50] = (2352.1575, 14300.7871, 8562.9922);
	angles[50] = (0, -99.8690, 0);
	at[50] = 126;
	points[51] = (2534.3425, 14263.1895, 8562.9922);
	angles[51] = (0, -101.2750, 0);
	at[51] = 126.5000;
	points[52] = (4902.7559, 13774.4883, 8562.9922);
	angles[52] = (0, -101.6592, 0);
	at[52] = 133;
	points[53] = (5083.5039, 13733.0312, 8562.9922);
	angles[53] = (0, -104.0891, 0);
	at[53] = 133.5000;
	points[54] = (5246.4175, 13643.1504, 8562.9922);
	angles[54] = (0, -115.6948, 0);
	at[54] = 134;
	points[55] = (5409.2910, 13553.3076, 8562.9922);
	angles[55] = (0, -118.2014, 0);
	at[55] = 134.5000;
	points[56] = (7689.5669, 12295.1973, 8562.9922);
	angles[56] = (0, -118.8865, 0);
	at[56] = 141.5000;
	points[57] = (7837.2441, 12185.9453, 8562.9922);
	angles[57] = (0, -127.8825, 0);
	at[57] = 142;
	points[58] = (7962.9131, 12048.8193, 8562.9922);
	angles[58] = (0, -135.4232, 0);
	at[58] = 142.5000;
	points[59] = (8088.6221, 11911.6934, 8562.9922);
	angles[59] = (0, -137.0460, 0);
	at[59] = 143;
	points[60] = (9848.4248, 9991.9287, 8562.9922);
	angles[60] = (0, -137.8324, 0);
	at[60] = 150;
	points[61] = (9956.3389, 9840.3545, 8562.9922);
	angles[61] = (0, -142.9577, 0);
	at[61] = 150.5000;
	points[62] = (10064.7246, 9689.1729, 8562.9922);
	angles[62] = (0, -144.0592, 0);
	at[62] = 151;
	points[63] = (11582.2441, 7572.6377, 8562.9922);
	angles[63] = (0, -144.3602, 0);
	at[63] = 158;
	points[64] = (11659.2520, 7405.5513, 8562.9922);
	angles[64] = (0, -155.2076, 0);
	at[64] = 158.5000;
	points[65] = (11717.2051, 7228.7793, 8562.9922);
	angles[65] = (0, -160.4208, 0);
	at[65] = 159;
	points[66] = (11775.1572, 7052.0078, 8562.9922);
	angles[66] = (0, -161.5410, 0);
	at[66] = 159.5000;
	points[67] = (12528.5830, 4754.0552, 8562.9922);
	angles[67] = (0, -161.8472, 0);
	at[67] = 166;
	points[68] = (12572.3232, 4573.8979, 8562.9922);
	angles[68] = (0, -166.9585, 0);
	at[68] = 166.5000;
	points[69] = (12628.0703, 4206.0630, 8562.9922);
	angles[69] = (0, -171.1804, 0);
	at[69] = 167.5000;
	points[70] = (13018.1885, 1631.1143, 8562.9922);
	angles[70] = (0, -171.3844, 0);
	at[70] = 174.5000;
	points[71] = (13025.1973, 1445.7755, 8562.9922);
	angles[71] = (0, -177.6410, 0);
	at[71] = 175;
	points[72] = (13019.4492, 1073.7716, 8562.9922);
	angles[72] = (0, -180.7321, 0);
	at[72] = 176;
	points[73] = (12982.2441, -1344.2521, 8562.9922);
	angles[73] = (0, -180.8813, 0);
	at[73] = 182.5000;
	points[74] = (12972.5986, -1529.7677, 8562.9922);
	angles[74] = (0, -183.4651, 0);
	at[74] = 183;
	points[75] = (12925.1582, -1898.7756, 8562.9922);
	angles[75] = (0, -187.1485, 0);
	at[75] = 184;
	points[76] = (12569.3301, -4666.3779, 8562.9922);
	angles[76] = (0, -187.3264, 0);
	at[76] = 191.5000;
	points[77] = (12521.6924, -4844.9214, 8562.9922);
	angles[77] = (0, -195.3444, 0);
	at[77] = 192;
	points[78] = (12390.4336, -5193.0317, 8562.9922);
	angles[78] = (0, -200.4139, 0);
	at[78] = 193;
	points[79] = (11537.2441, -7455.8271, 8562.9922);
	angles[79] = (0, -200.6589, 0);
	at[79] = 199.5000;
	points[80] = (11465.9844, -7627.0864, 8562.9922);
	angles[80] = (0, -203.6531, 0);
	at[80] = 200;
	points[81] = (11367.4014, -7784.8428, 8562.9922);
	angles[81] = (0, -210.2098, 0);
	at[81] = 200.5000;
	points[82] = (11268.8193, -7942.5986, 8562.9922);
	angles[82] = (0, -211.6199, 0);
	at[82] = 201;
	points[83] = (9888.5439, -10151.0635, 8562.9922);
	angles[83] = (0, -212.0053, 0);
	at[83] = 208;
	points[84] = (9768.6611, -10291.1416, 8562.9922);
	angles[84] = (0, -220.8974, 0);
	at[84] = 208.5000;
	points[85] = (9495.0791, -10543.2686, 8562.9922);
	angles[85] = (0, -227.0403, 0);
	at[85] = 209.5000;
	points[86] = (7579.9609, -12308.1885, 8562.9922);
	angles[86] = (0, -227.3374, 0);
	at[86] = 216.5000;
	points[87] = (7439.2124, -12427.9922, 8562.9922);
	angles[87] = (0, -231.1485, 0);
	at[87] = 217;
	points[88] = (7266.4961, -12497.0869, 8562.9922);
	angles[88] = (0, -244.5150, 0);
	at[88] = 217.5000;
	points[89] = (7093.7798, -12566.1816, 8562.9922);
	angles[89] = (0, -247.4077, 0);
	at[89] = 218;
	points[90] = (4675.7085, -13533.3857, 8562.9922);
	angles[90] = (0, -248.1986, 0);
	at[90] = 225;
	points[91] = (4493.9370, -13570.2754, 8562.9922);
	angles[91] = (0, -257.1089, 0);
	at[91] = 225.5000;
	points[92] = (4310.5513, -13601.5752, 8562.9922);
	angles[92] = (0, -259.6237, 0);
	at[92] = 226;
	points[93] = (826.5236, -14196.4170, 8562.9922);
	angles[93] = (0, -260.3112, 0);
	at[93] = 235.5000;
	points[94] = (799.3701, -14198.1494, 8562.9922);
	angles[94] = (0, -262.0600, 0);
	at[94] = 235.5830;
	mover = getEnt("iz_obj_0", "targetname");
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
