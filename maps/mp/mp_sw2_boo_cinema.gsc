main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_sw2_boo_cinema", 0);

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
	ambientPlay("iz_0_sw2booc", 2);
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
	level.iz_route[level.iz_route.size] = (15, -5, 2403);
	level.iz_route[level.iz_route.size] = (19, -1090, 2403);
	level.iz_route[level.iz_route.size] = (27, -1822, 2405);
	level.iz_route[level.iz_route.size] = (88, -2318, 2410);
	level.iz_route[level.iz_route.size] = (237, -2768, 2417);
	level.iz_route[level.iz_route.size] = (520, -3367, 2443);
	level.iz_route[level.iz_route.size] = (762, -4127, 2507);
	level.iz_route[level.iz_route.size] = (820, -4762, 2576);
	level.iz_route[level.iz_route.size] = (723, -5155, 2612);
	level.iz_route[level.iz_route.size] = (437, -5547, 2634);
	level.iz_route[level.iz_route.size] = (60, -6026, 2665);
	level.iz_route[level.iz_route.size] = (-460, -6525, 2685);
	level.iz_route[level.iz_route.size] = (-1066, -6848, 2677);
	level.iz_route[level.iz_route.size] = (-1537, -6950, 2670);
	level.iz_route[level.iz_route.size] = (-1838, -6896, 2661);
	level.iz_route[level.iz_route.size] = (-2178, -6787, 2665);
	level.iz_route[level.iz_route.size] = (-2539, -6542, 2676);
	level.iz_route[level.iz_route.size] = (-2954, -6084, 2694);
	level.iz_route[level.iz_route.size] = (-3118, -5891, 2677);
	level.iz_route[level.iz_route.size] = (-3706, -5251, 2507);
	level.iz_route[level.iz_route.size] = (-4747, -4167, 2292);
	level.iz_route[level.iz_route.size] = (-5528, -3043, 2221);
	level.iz_route[level.iz_route.size] = (-5458, -2594, 2199);
	level.iz_route[level.iz_route.size] = (-5082, -1346, 2132);
	level.iz_route[level.iz_route.size] = (-4790, -76, 2059);
	level.iz_route[level.iz_route.size] = (-4776, 116, 2044);
	level.iz_route[level.iz_route.size] = (-4839, 307, 2028);
	level.iz_route[level.iz_route.size] = (-4954, 447, 2016);
	level.iz_route[level.iz_route.size] = (-5170, 610, 1999);
	level.iz_route[level.iz_route.size] = (-6258, 1134, 1930);
	level.iz_route[level.iz_route.size] = (-7785, 1713, 1870);
	level.iz_route[level.iz_route.size] = (-8437, 1975, 1930);
	level.iz_route[level.iz_route.size] = (-9462, 2423, 1817);
	level.iz_route[level.iz_route.size] = (-10759, 2691, 1901);
	level.iz_route[level.iz_route.size] = (-11741, 2944, 1954);
	level.iz_route[level.iz_route.size] = (-12385, 3312, 1968);
	level.iz_route[level.iz_route.size] = (-12563, 3856, 1910);
	level.iz_route[level.iz_route.size] = (-12904, 5152, 1764);
	level.iz_route[level.iz_route.size] = (-13324, 6026, 1717);
	level.iz_route[level.iz_route.size] = (-13810, 6444, 1716);
	level.iz_route[level.iz_route.size] = (-14699, 6639, 1730);
	level.iz_route[level.iz_route.size] = (-15494, 6421, 1790);
	level.iz_route[level.iz_route.size] = (-16082, 5850, 1843);
	level.iz_route[level.iz_route.size] = (-16259, 5137, 1849);
	level.iz_route[level.iz_route.size] = (-16294, 4447, 1889);
	level.iz_route[level.iz_route.size] = (-16233, 3920, 1923);
	level.iz_route[level.iz_route.size] = (-16129, 3011, 1734);
	level.iz_route[level.iz_route.size] = (-15997, 1368, 1648);
	level.iz_route[level.iz_route.size] = (-15883, 68, 1643);
	level.iz_route[level.iz_route.size] = (-15810, -851, 1654);
	level.iz_route[level.iz_route.size] = (-15719, -1200, 1669);
	level.iz_route[level.iz_route.size] = (-15518, -1602, 1739);
	level.iz_route[level.iz_route.size] = (-15257, -1971, 1794);
	level.iz_route[level.iz_route.size] = (-14930, -2188, 1817);
	level.iz_route[level.iz_route.size] = (-14438, -2340, 1846);
	level.iz_route[level.iz_route.size] = (-13931, -2303, 1875);
	level.iz_route[level.iz_route.size] = (-13502, -2096, 1907);
	level.iz_route[level.iz_route.size] = (-13195, -1812, 1940);
	level.iz_route[level.iz_route.size] = (-12896, -1437, 1975);
	level.iz_route[level.iz_route.size] = (-12839, -811, 1962);
	level.iz_route[level.iz_route.size] = (-12964, -278, 1974);
	level.iz_route[level.iz_route.size] = (-13113, 347, 2029);
	level.iz_route[level.iz_route.size] = (-13087, 748, 2072);
	level.iz_route[level.iz_route.size] = (-12853, 1156, 2124);
	level.iz_route[level.iz_route.size] = (-12532, 1455, 2179);
	level.iz_route[level.iz_route.size] = (-11864, 1753, 2261);
	level.iz_route[level.iz_route.size] = (-11443, 1940, 2316);
	level.iz_route[level.iz_route.size] = (-7759, 3403, 1978);
	level.iz_route[level.iz_route.size] = (-5180, 4324, 2335);
	level.iz_route[level.iz_route.size] = (-4205, 4560, 2416);
	level.iz_route[level.iz_route.size] = (-2780, 4608, 2449);
	level.iz_route[level.iz_route.size] = (-2482, 4396, 2451);
	level.iz_route[level.iz_route.size] = (-1540, 4252, 2459);
	level.iz_route[level.iz_route.size] = (-871, 4118, 2462);
	level.iz_route[level.iz_route.size] = (-320, 3895, 2464);
	level.iz_route[level.iz_route.size] = (10, 3329, 2460);
	level.iz_route[level.iz_route.size] = (47, 2882, 2444);
	level.iz_route[level.iz_route.size] = (40, 2325, 2420);
	level.iz_route[level.iz_route.size] = (97, 1340, 2404);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (7173.5825, 4329.4487, 4855.7085);
	angles[0] = (0, 86.2847, 0);
	at[0] = 0;
	points[1] = (7164.3306, 4330.0396, 4812.9526);
	angles[1] = (0, 86.2088, 0);
	at[1] = 0.0500;
	points[2] = (7144.8032, 4331.3779, 4720.3545);
	angles[2] = (0, 86.0849, 0);
	at[2] = 0.1500;
	points[3] = (7123.9370, 4332.7954, 4619.0552);
	angles[3] = (0, 85.9907, 0);
	at[3] = 0.2500;
	points[4] = (7086.2598, 4335.4727, 4431.8110);
	angles[4] = (0, 85.8819, 0);
	at[4] = 0.4500;
	points[5] = (7056.8896, 4337.5986, 4283.3857);
	angles[5] = (0, 85.8327, 0);
	at[5] = 0.6000;
	points[6] = (7029.3306, 4339.6455, 4143.1104);
	angles[6] = (0, 85.8063, 0);
	at[6] = 0.7500;
	points[7] = (6991.2603, 4342.4409, 3948.3071);
	angles[7] = (0, 85.7933, 0);
	at[7] = 0.9500;
	points[8] = (6954.1733, 4345.1572, 3758.5237);
	angles[8] = (0, 85.8021, 0);
	at[8] = 1.1500;
	points[9] = (6810.6694, 4355.4722, 3037.7205);
	angles[9] = (0, 86.0064, 0);
	at[9] = 1.9000;
	points[10] = (6771.6538, 4358.1890, 2849.2007);
	angles[10] = (0, 86.1152, 0);
	at[10] = 2.1000;
	points[11] = (6740.4331, 4360.2754, 2701.9097);
	angles[11] = (0, 86.2249, 0);
	at[11] = 2.2500;
	points[12] = (6699.4092, 4362.9136, 2515.0078);
	angles[12] = (0, 86.4091, 0);
	at[12] = 2.4500;
	points[13] = (6676.5752, 4364.3306, 2414.8662);
	angles[13] = (0, 86.5379, 0);
	at[13] = 2.5500;
	points[14] = (6643.6221, 4366.2598, 2276.5276);
	angles[14] = (0, 86.7703, 0);
	at[14] = 2.7000;
	points[15] = (6605.5513, 4368.2681, 2128.7915);
	angles[15] = (0, 87.1407, 0);
	at[15] = 2.8500;
	points[16] = (6580.8667, 4369.4487, 2042.6143);
	angles[16] = (0, 87.4751, 0);
	at[16] = 2.9500;
	points[17] = (6563.8188, 4370.1577, 1988.7953);
	angles[17] = (0, 87.7770, 0);
	at[17] = 3;
	points[18] = (6546.8896, 4370.7480, 1941.6653);
	angles[18] = (0, 88.1635, 0);
	at[18] = 3.0500;
	points[19] = (6531.1812, 4371.1812, 1905.2480);
	angles[19] = (0, 88.6424, 0);
	at[19] = 3.1000;
	points[20] = (6505.1968, 4371.6143, 1862.8503);
	angles[20] = (0, 89.3992, 0);
	at[20] = 3.1500;
	points[21] = (6472.4409, 4371.8110, 1829.0039);
	angles[21] = (0, 89.8826, 0);
	at[21] = 3.2000;
	points[22] = (6431.0630, 4371.7715, 1803.0078);
	angles[22] = (0, 90.2229, 0);
	at[22] = 3.2500;
	points[23] = (6385.5117, 4371.4961, 1787.2402);
	angles[23] = (0, 90.4495, 0);
	at[23] = 3.3000;
	points[24] = (6337.0083, 4371.0239, 1780.0157);
	angles[24] = (0, 90.6063, 0);
	at[24] = 3.3500;
	points[25] = (6288.7397, 4370.4727, 1779.6063);
	angles[25] = (0, 90.7134, 0);
	at[25] = 3.4000;
	points[26] = (6239.5273, 4369.8428, 1784.2914);
	angles[26] = (0, 90.7902, 0);
	at[26] = 3.4500;
	points[27] = (6143.9370, 4368.4253, 1803.7008);
	angles[27] = (0, 90.8775, 0);
	at[27] = 3.5500;
	points[28] = (6050.3545, 4366.9683, 1831.4213);
	angles[28] = (0, 90.9050, 0);
	at[28] = 3.6500;
	points[29] = (5818.5435, 4363.5825, 1912.3583);
	angles[29] = (0, 90.6604, 0);
	at[29] = 3.9000;
	points[30] = (5772.5981, 4363.1104, 1925.4764);
	angles[30] = (0, 90.4741, 0);
	at[30] = 3.9500;
	points[31] = (5724.6851, 4362.8740, 1933.9330);
	angles[31] = (0, 90.0725, 0);
	at[31] = 4;
	points[32] = (5679.2524, 4363.0317, 1936.2834);
	angles[32] = (0, 89.5769, 0);
	at[32] = 4.0500;
	points[33] = (4994.5278, 4372.0083, 1974.8898);
	angles[33] = (0, 89.5964, 0);
	at[33] = 4.7500;
	points[34] = (4800.0396, 4371.4570, 1986.0355);
	angles[34] = (0, 91.3367, 0);
	at[34] = 4.9500;
	points[35] = (4755.1182, 4369.9214, 1988.5670);
	angles[35] = (0, 92.4058, 0);
	at[35] = 5;
	points[36] = (4608.3857, 4362.0078, 1996.9489);
	angles[36] = (0, 93.5067, 0);
	at[36] = 5.1500;
	points[37] = (3925.8110, 4313.5435, 2034.9883);
	angles[37] = (0, 94.1230, 0);
	at[37] = 5.8500;
	points[38] = (3880.6101, 4310.4727, 2037.0432);
	angles[38] = (0, 93.7093, 0);
	at[38] = 5.9000;
	points[39] = (3392.2598, 4278.1499, 2054.3857);
	angles[39] = (0, 95.0329, 0);
	at[39] = 6.4000;
	points[40] = (3295.6143, 4267.9136, 2057.1851);
	angles[40] = (0, 97.7081, 0);
	at[40] = 6.5000;
	points[41] = (3249.4448, 4259.8032, 2058.2363);
	angles[41] = (0, 102.8279, 0);
	at[41] = 6.5500;
	points[42] = (3109.0354, 4216.9688, 2058.9802);
	angles[42] = (0, 109.6161, 0);
	at[42] = 6.7000;
	points[43] = (2972.5669, 4162.9136, 2058.5078);
	angles[43] = (0, 113.8223, 0);
	at[43] = 6.8500;
	points[44] = (2885.6143, 4119.8032, 2058.0552);
	angles[44] = (0, 120.3976, 0);
	at[44] = 6.9500;
	points[45] = (2847.2559, 4091.3386, 2057.9922);
	angles[45] = (0, 134.6534, 0);
	at[45] = 7;
	points[46] = (2815.0159, 4054.3308, 2057.9922);
	angles[46] = (0, 141.9295, 0);
	at[46] = 7.0500;
	points[47] = (2758.7246, 3974.5671, 2057.9922);
	angles[47] = (0, 146.7649, 0);
	at[47] = 7.1500;
	points[48] = (2681.6104, 3849.8584, 2057.9922);
	angles[48] = (0, 149.3019, 0);
	at[48] = 7.3000;
	points[49] = (2608.5159, 3723.7993, 2057.9922);
	angles[49] = (0, 150.9879, 0);
	at[49] = 7.4500;
	points[50] = (2515.9136, 3552.1143, 2057.9922);
	angles[50] = (0, 152.1903, 0);
	at[50] = 7.6500;
	points[51] = (2426.7166, 3377.5867, 2057.9922);
	angles[51] = (0, 154.2649, 0);
	at[51] = 7.8500;
	points[52] = (2407.5117, 3336.0552, 2054.4055);
	angles[52] = (0, 156.0251, 0);
	at[52] = 7.9000;
	points[53] = (2388.8269, 3293.2087, 2039.7717);
	angles[53] = (0, 156.7418, 0);
	at[53] = 7.9500;
	points[54] = (2335.5354, 3166.5903, 1986.4922);
	angles[54] = (0, 157.4620, 0);
	at[54] = 8.1000;
	points[55] = (2299.8857, 3080.1968, 1957.7323);
	angles[55] = (0, 157.6752, 0);
	at[55] = 8.2000;
	points[56] = (2281.7991, 3036.0591, 1948.5787);
	angles[56] = (0, 157.7540, 0);
	at[56] = 8.2500;
	points[57] = (2263.2756, 2990.7007, 1944.9371);
	angles[57] = (0, 157.8218, 0);
	at[57] = 8.3000;
	points[58] = (2245.0315, 2945.8821, 1949.2521);
	angles[58] = (0, 157.8790, 0);
	at[58] = 8.3500;
	points[59] = (2227.7087, 2903.2048, 1963.9056);
	angles[59] = (0, 157.9262, 0);
	at[59] = 8.4000;
	points[60] = (2212.3071, 2865.1970, 1990.2480);
	angles[60] = (0, 157.9626, 0);
	at[60] = 8.4500;
	points[61] = (2200.3228, 2835.5708, 2025.0394);
	angles[61] = (0, 157.9860, 0);
	at[61] = 8.5000;
	points[62] = (2191.2756, 2813.1851, 2065.7991);
	angles[62] = (0, 158.0306, 0);
	at[62] = 8.5500;
	points[63] = (2184.8464, 2797.2007, 2104.7480);
	angles[63] = (0, 158.1407, 0);
	at[63] = 8.6000;
	points[64] = (2177.5747, 2779.0317, 2155.3386);
	angles[64] = (0, 158.2200, 0);
	at[64] = 8.6500;
	points[65] = (2166.1182, 2750.2991, 2243.9370);
	angles[65] = (0, 158.2996, 0);
	at[65] = 8.7500;
	points[66] = (2154.4214, 2720.8623, 2341.8110);
	angles[66] = (0, 158.3522, 0);
	at[66] = 8.8500;
	points[67] = (2139.0432, 2682.0669, 2477.9805);
	angles[67] = (0, 158.3990, 0);
	at[67] = 9;
	points[68] = (2128.4526, 2655.2993, 2575.3384);
	angles[68] = (0, 158.4224, 0);
	at[68] = 9.1000;
	points[69] = (2108.8860, 2605.7795, 2760.6458);
	angles[69] = (0, 158.4544, 0);
	at[69] = 9.3000;
	points[70] = (2094.0708, 2568.2441, 2904.4844);
	angles[70] = (0, 158.4719, 0);
	at[70] = 9.4500;
	points[71] = (2079.9331, 2532.3899, 3043.8896);
	angles[71] = (0, 158.4849, 0);
	at[71] = 9.6000;
	points[72] = (1986.5709, 2295.3032, 3990.0789);
	angles[72] = (0, 158.5124, 0);
	at[72] = 10.6000;
	points[73] = (1972.9292, 2260.6575, 4128.8979);
	angles[73] = (0, 158.5078, 0);
	at[73] = 10.7500;
	points[74] = (1958.5709, 2224.1968, 4274.0942);
	angles[74] = (0, 158.4991, 0);
	at[74] = 10.9000;
	points[75] = (1949.5315, 2201.2520, 4364.7246);
	angles[75] = (0, 158.4904, 0);
	at[75] = 11;
	points[76] = (1934.7401, 2163.7402, 4510.8267);
	angles[76] = (0, 158.4678, 0);
	at[76] = 11.1500;
	points[77] = (1930.0867, 2151.9487, 4555.9844);
	angles[77] = (0, 158.4572, 0);
	at[77] = 11.2000;
	points[78] = (1927.1064, 2144.3977, 4584.6064);
	angles[78] = (0, 158.4490, 0);
	at[78] = 11.2500;
	points[79] = (7173.5825, 4329.4487, 4855.7085);
	angles[79] = (0, 86.2847, 0);
	at[79] = 11.2500;
	points[80] = (7173.5825, 4329.4487, 4855.7085);
	angles[80] = (0, 86.2847, 0);
	at[80] = 11.2667;
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
	points[0] = (2995.4409, 20789.7637, 4007.0078);
	angles[0] = (0, 179.3377, 0);
	at[0] = 0;
	points[1] = (2994.7639, 20734.8027, 3933.4526);
	angles[1] = (0, 179.2571, 0);
	at[1] = 0.1000;
	points[2] = (2993.9568, 20674.8828, 3850.5276);
	angles[2] = (0, 179.2004, 0);
	at[2] = 0.2000;
	points[3] = (2992.7676, 20592.5605, 3733.7678);
	angles[3] = (0, 179.1528, 0);
	at[3] = 0.3500;
	points[4] = (2991.9055, 20534.8438, 3650.6929);
	angles[4] = (0, 179.1327, 0);
	at[4] = 0.4500;
	points[5] = (2990.6575, 20453.2676, 3532.2834);
	angles[5] = (0, 179.1170, 0);
	at[5] = 0.6000;
	points[6] = (2985.5552, 20119.9609, 3048.3899);
	angles[6] = (0, 179.1521, 0);
	at[6] = 1.2000;
	points[7] = (2982.3860, 19893.7793, 2731.0354);
	angles[7] = (0, 179.2548, 0);
	at[7] = 1.6000;
	points[8] = (2981.2798, 19804.8418, 2611.4097);
	angles[8] = (0, 179.3188, 0);
	at[8] = 1.7500;
	points[9] = (2980.6143, 19746.7715, 2535.5356);
	angles[9] = (0, 179.3708, 0);
	at[9] = 1.8500;
	points[10] = (2979.9685, 19684.8828, 2457.0435);
	angles[10] = (0, 179.4381, 0);
	at[10] = 1.9500;
	points[11] = (2979.1692, 19593.1484, 2346.5945);
	angles[11] = (0, 179.5687, 0);
	at[11] = 2.1000;
	points[12] = (2978.7322, 19525.1582, 2270.5747);
	angles[12] = (0, 179.7017, 0);
	at[12] = 2.2000;
	points[13] = (2978.4844, 19459.9609, 2204.2520);
	angles[13] = (0, 179.8768, 0);
	at[13] = 2.3000;
	points[14] = (2978.4490, 19420.8672, 2168.5708);
	angles[14] = (0, 180.0175, 0);
	at[14] = 2.3500;
	points[15] = (2978.5156, 19382.1270, 2137.3032);
	angles[15] = (0, 180.1989, 0);
	at[15] = 2.4000;
	points[16] = (2978.7087, 19346.3789, 2113.1731);
	angles[16] = (0, 180.4250, 0);
	at[16] = 2.4500;
	points[17] = (2979.0945, 19306.7715, 2093.1221);
	angles[17] = (0, 180.6703, 0);
	at[17] = 2.5000;
	points[18] = (2979.7087, 19260.4727, 2076.0513);
	angles[18] = (0, 180.8409, 0);
	at[18] = 2.5500;
	points[19] = (2980.4844, 19211.3789, 2062.6299);
	angles[19] = (0, 180.9588, 0);
	at[19] = 2.6000;
	points[20] = (2981.2759, 19166.0625, 2053.1694);
	angles[20] = (0, 181.0370, 0);
	at[20] = 2.6500;
	points[21] = (2983.1970, 19066.0234, 2039.0513);
	angles[21] = (0, 181.1547, 0);
	at[21] = 2.7500;
	points[22] = (2985.1614, 18971.6934, 2031.5865);
	angles[22] = (0, 181.2281, 0);
	at[22] = 2.8500;
	points[23] = (2987.3621, 18871.4961, 2027.9055);
	angles[23] = (0, 181.2846, 0);
	at[23] = 2.9500;
	points[24] = (2990.6890, 18726.6543, 2028.0709);
	angles[24] = (0, 181.3437, 0);
	at[24] = 3.1000;
	points[25] = (2996.5747, 18482.1660, 2038.1536);
	angles[25] = (0, 181.4099, 0);
	at[25] = 3.3500;
	points[26] = (3002.6614, 18238.8984, 2055.8308);
	angles[26] = (0, 181.4526, 0);
	at[26] = 3.6000;
	points[27] = (3012.6772, 17849.6855, 2091.0789);
	angles[27] = (0, 181.4895, 0);
	at[27] = 4;
	points[28] = (3015.2795, 17749.6465, 2099.7915);
	angles[28] = (0, 181.4910, 0);
	at[28] = 4.1000;
	points[29] = (3017.7444, 17654.8438, 2106.8230);
	angles[29] = (0, 181.4850, 0);
	at[29] = 4.2000;
	points[30] = (3019.0945, 17602.6387, 2109.6458);
	angles[30] = (0, 181.4750, 0);
	at[30] = 4.2500;
	points[31] = (3021.3779, 17513.9375, 2110.9844);
	angles[31] = (0, 181.5215, 0);
	at[31] = 4.3500;
	points[32] = (3058.2600, 16242.0869, 2111.3701);
	angles[32] = (0, 181.3928, 0);
	at[32] = 5.6500;
	points[33] = (3060.4409, 16146.5742, 2111.3662);
	angles[33] = (0, 181.2078, 0);
	at[33] = 5.7500;
	points[34] = (3061.4646, 16094.6846, 2111.3542);
	angles[34] = (0, 181.0426, 0);
	at[34] = 5.8000;
	points[35] = (3062.7324, 16005.4326, 2111.3032);
	angles[35] = (0, 180.5781, 0);
	at[35] = 5.9000;
	points[36] = (3064.2991, 15611.3398, 2110.8740);
	angles[36] = (0, 180.0528, 0);
	at[36] = 6.3000;
	points[37] = (3063.2639, 14780.2764, 2109.6614);
	angles[37] = (0, 179.8500, 0);
	at[37] = 7.1500;
	points[38] = (3063.0039, 14685.0391, 2109.4961);
	angles[38] = (0, 179.8391, 0);
	at[38] = 7.2500;
	points[39] = (3062.8545, 14633.2285, 2109.4016);
	angles[39] = (0, 179.8339, 0);
	at[39] = 7.3000;
	points[40] = (3062.5708, 14537.4814, 2109.2166);
	angles[40] = (0, 179.8269, 0);
	at[40] = 7.4000;
	points[41] = (3062.4175, 14485.8662, 2109.1064);
	angles[41] = (0, 179.8259, 0);
	at[41] = 7.4500;
	points[42] = (3062.2834, 14442.4805, 2108.9880);
	angles[42] = (0, 179.8131, 0);
	at[42] = 7.5000;
	points[43] = (3062.0750, 14395.9844, 2107.2678);
	angles[43] = (0, 179.6813, 0);
	at[43] = 7.5500;
	points[44] = (3061.7480, 14345.1582, 2103.2874);
	angles[44] = (0, 179.5925, 0);
	at[44] = 7.6000;
	points[45] = (3061.3938, 14298.3857, 2098.4370);
	angles[45] = (0, 179.5380, 0);
	at[45] = 7.6500;
	points[46] = (3057.6733, 13909.8428, 2047.8740);
	angles[46] = (0, 179.4283, 0);
	at[46] = 8.0500;
	points[47] = (3055.8032, 13715.3545, 2029.6261);
	angles[47] = (0, 179.4825, 0);
	at[47] = 8.2500;
	points[48] = (3054.9646, 13617.2051, 2025.6141);
	angles[48] = (0, 179.5394, 0);
	at[48] = 8.3500;
	points[49] = (3054.2483, 13519.6455, 2027.1693);
	angles[49] = (0, 179.6276, 0);
	at[49] = 8.4500;
	points[50] = (3053.7322, 13423.4648, 2036.9055);
	angles[50] = (0, 179.7698, 0);
	at[50] = 8.5500;
	points[51] = (3053.5786, 13374.2520, 2046.6300);
	angles[51] = (0, 179.8819, 0);
	at[51] = 8.6000;
	points[52] = (3053.5393, 13329.0166, 2059.7954);
	angles[52] = (0, 180.0291, 0);
	at[52] = 8.6500;
	points[53] = (3053.6497, 13282.7949, 2079.4409);
	angles[53] = (0, 180.2629, 0);
	at[53] = 8.7000;
	points[54] = (3053.9448, 13242.9131, 2104.5747);
	angles[54] = (0, 180.6159, 0);
	at[54] = 8.7500;
	points[55] = (3054.3662, 13211.1416, 2132.6143);
	angles[55] = (0, 180.8930, 0);
	at[55] = 8.8000;
	points[56] = (3054.9922, 13175.5508, 2170.4646);
	angles[56] = (0, 181.0977, 0);
	at[56] = 8.8500;
	points[57] = (3055.6260, 13144.2529, 2207.6458);
	angles[57] = (0, 181.2272, 0);
	at[57] = 8.9000;
	points[58] = (3056.2678, 13115.4326, 2244.2915);
	angles[58] = (0, 181.3203, 0);
	at[58] = 8.9500;
	points[59] = (3057.7402, 13055.1182, 2326.6497);
	angles[59] = (0, 181.4648, 0);
	at[59] = 9.0500;
	points[60] = (3058.4250, 13028.8193, 2364.4016);
	angles[60] = (0, 181.5132, 0);
	at[60] = 9.1000;
	points[61] = (3060.7085, 12945.7480, 2489.0671);
	angles[61] = (0, 181.6300, 0);
	at[61] = 9.2500;
	points[62] = (3062.1814, 12894.8428, 2568.6970);
	angles[62] = (0, 181.6827, 0);
	at[62] = 9.3500;
	points[63] = (3064.5356, 12816.2207, 2695.1023);
	angles[63] = (0, 181.7454, 0);
	at[63] = 9.5000;
	points[64] = (3066.8584, 12741.0625, 2818.9883);
	angles[64] = (0, 181.7897, 0);
	at[64] = 9.6500;
	points[65] = (3081.1812, 12296.8506, 3577.8152);
	angles[65] = (0, 181.8477, 0);
	at[65] = 10.5500;
	points[66] = (3082.8110, 12245.9844, 3664.3545);
	angles[66] = (0, 181.8276, 0);
	at[66] = 10.6500;
	points[67] = (3084.3347, 12197.8740, 3745.3269);
	angles[67] = (0, 181.7978, 0);
	at[67] = 10.7500;
	points[68] = (3085.9724, 12145.0400, 3832.6221);
	angles[68] = (0, 181.7464, 0);
	at[68] = 10.8500;
	points[69] = (3086.7246, 12120.1191, 3873);
	angles[69] = (0, 181.7114, 0);
	at[69] = 10.9000;
	points[70] = (3086.9646, 12112.0869, 3885.8188);
	angles[70] = (0, 181.6981, 0);
	at[70] = 10.9333;
	points[71] = (2995.4409, 20789.7637, 4007.0078);
	angles[71] = (0, 179.3376, 0);
	at[71] = 10.9333;
	points[72] = (2995.4409, 20789.7637, 4007.0078);
	angles[72] = (0, 179.3376, 0);
	at[72] = 10.9500;
	mover = getEnt("iz_obj_1", "targetname");
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
