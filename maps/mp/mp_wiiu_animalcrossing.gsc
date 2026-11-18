main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_wiiu_animalcrossing", 0);

	setExpFog(7381.8896, 21991.8789, 0.8039, 0.6000, 0.4510, 0);

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
	ambientPlay("iz_0_uac", 2);
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
	level.iz_route[level.iz_route.size] = (-5216, -2100, 2758);
	level.iz_route[level.iz_route.size] = (-6337, -2060, 2762);
	level.iz_route[level.iz_route.size] = (-7993, -2047, 2735);
	level.iz_route[level.iz_route.size] = (-8425, -2051, 2819);
	level.iz_route[level.iz_route.size] = (-8685, -2051, 2845);
	level.iz_route[level.iz_route.size] = (-9029, -2042, 2805);
	level.iz_route[level.iz_route.size] = (-10645, -2076, 2855);
	level.iz_route[level.iz_route.size] = (-12193, -2128, 3008);
	level.iz_route[level.iz_route.size] = (-12620, -2142, 3052);
	level.iz_route[level.iz_route.size] = (-13085, -2083, 3091);
	level.iz_route[level.iz_route.size] = (-13485, -1925, 3116);
	level.iz_route[level.iz_route.size] = (-13761, -1689, 3128);
	level.iz_route[level.iz_route.size] = (-13977, -1381, 3129);
	level.iz_route[level.iz_route.size] = (-14334, -510, 3126);
	level.iz_route[level.iz_route.size] = (-14590, 472, 3114);
	level.iz_route[level.iz_route.size] = (-14754, 825, 3120);
	level.iz_route[level.iz_route.size] = (-14896, 1089, 3124);
	level.iz_route[level.iz_route.size] = (-14959, 1350, 3124);
	level.iz_route[level.iz_route.size] = (-14963, 1652, 3122);
	level.iz_route[level.iz_route.size] = (-14800, 2009, 3115);
	level.iz_route[level.iz_route.size] = (-14661, 2353, 3114);
	level.iz_route[level.iz_route.size] = (-14628, 2642, 3119);
	level.iz_route[level.iz_route.size] = (-14561, 2933, 3124);
	level.iz_route[level.iz_route.size] = (-14584, 3356, 3148);
	level.iz_route[level.iz_route.size] = (-14527, 3728, 3182);
	level.iz_route[level.iz_route.size] = (-14312, 3916, 3191);
	level.iz_route[level.iz_route.size] = (-13985, 4127, 3205);
	level.iz_route[level.iz_route.size] = (-13593, 4130, 3208);
	level.iz_route[level.iz_route.size] = (-13198, 4041, 3203);
	level.iz_route[level.iz_route.size] = (-12895, 3788, 3183);
	level.iz_route[level.iz_route.size] = (-12591, 3351, 3159);
	level.iz_route[level.iz_route.size] = (-12263, 2631, 3150);
	level.iz_route[level.iz_route.size] = (-11894, 2147, 3138);
	level.iz_route[level.iz_route.size] = (-11445, 1795, 3119);
	level.iz_route[level.iz_route.size] = (-10940, 1658, 3086);
	level.iz_route[level.iz_route.size] = (-10306, 1507, 3050);
	level.iz_route[level.iz_route.size] = (-9651, 1476, 3063);
	level.iz_route[level.iz_route.size] = (-9098, 1480, 3190);
	level.iz_route[level.iz_route.size] = (-6516, 1430, 2783);
	level.iz_route[level.iz_route.size] = (-4956, 1415, 2707);
	level.iz_route[level.iz_route.size] = (-3477, 1420, 2657);
	level.iz_route[level.iz_route.size] = (-1784, 1425, 2544);
	level.iz_route[level.iz_route.size] = (922, 1394, 2280);
	level.iz_route[level.iz_route.size] = (2072, 1477, 2205);
	level.iz_route[level.iz_route.size] = (2557, 1559, 2194);
	level.iz_route[level.iz_route.size] = (2909, 1761, 2198);
	level.iz_route[level.iz_route.size] = (3110, 2082, 2191);
	level.iz_route[level.iz_route.size] = (3204, 2534, 2165);
	level.iz_route[level.iz_route.size] = (3250, 3163, 2136);
	level.iz_route[level.iz_route.size] = (3271, 3997, 2125);
	level.iz_route[level.iz_route.size] = (3260, 5052, 2129);
	level.iz_route[level.iz_route.size] = (3241, 5898, 2172);
	level.iz_route[level.iz_route.size] = (3122, 6532, 2187);
	level.iz_route[level.iz_route.size] = (2932, 7400, 2239);
	level.iz_route[level.iz_route.size] = (2636, 7997, 2281);
	level.iz_route[level.iz_route.size] = (2175, 8380, 2305);
	level.iz_route[level.iz_route.size] = (1522, 8523, 2380);
	level.iz_route[level.iz_route.size] = (894, 8463, 2478);
	level.iz_route[level.iz_route.size] = (328, 8253, 2576);
	level.iz_route[level.iz_route.size] = (90, 7763, 2629);
	level.iz_route[level.iz_route.size] = (16, 7243, 2680);
	level.iz_route[level.iz_route.size] = (-128, 5783, 2726);
	level.iz_route[level.iz_route.size] = (-163, 3533, 2733);
	level.iz_route[level.iz_route.size] = (-154, 2568, 2945);
	level.iz_route[level.iz_route.size] = (-49, -70, 2897);
	level.iz_route[level.iz_route.size] = (157, -1067, 2741);
	level.iz_route[level.iz_route.size] = (563, -1918, 2740);
	level.iz_route[level.iz_route.size] = (968, -2584, 2763);
	level.iz_route[level.iz_route.size] = (1268, -3287, 2818);
	level.iz_route[level.iz_route.size] = (1238, -3886, 2868);
	level.iz_route[level.iz_route.size] = (1049, -4288, 2898);
	level.iz_route[level.iz_route.size] = (735, -4507, 2903);
	level.iz_route[level.iz_route.size] = (322, -4656, 2904);
	level.iz_route[level.iz_route.size] = (-94, -4623, 2893);
	level.iz_route[level.iz_route.size] = (-510, -4341, 2861);
	level.iz_route[level.iz_route.size] = (-949, -3825, 2816);
	level.iz_route[level.iz_route.size] = (-1410, -3206, 2776);
	level.iz_route[level.iz_route.size] = (-1760, -2804, 2763);
	level.iz_route[level.iz_route.size] = (-2263, -2523, 2753);
	level.iz_route[level.iz_route.size] = (-2880, -2374, 2744);
	level.iz_route[level.iz_route.size] = (-3855, -2184, 2741);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (5439.2520, 2389.7322, 2226.9448);
	angles[0] = (0, -33.5568, 0.2449);
	at[0] = 0;
	points[1] = (5476.2598, 2450.2363, 2227.2363);
	angles[1] = (0, -30.2012, 0.2259);
	at[1] = 0.4000;
	points[2] = (5507.9922, 2514.0078, 2227.4922);
	angles[2] = (0, -23.9703, 0.1959);
	at[2] = 0.8000;
	points[3] = (5519.2520, 2546.4331, 2227.5984);
	angles[3] = (0, -17.6328, 0.1666);
	at[3] = 1;
	points[4] = (5531.9292, 2614.5591, 2227.7678);
	angles[4] = (0, -8.6936, 0.1358);
	at[4] = 1.4000;
	points[5] = (5547.0474, 2756.8506, 2228.0750);
	angles[5] = (0, -4.9150, 0.1151);
	at[5] = 2.2000;
	points[6] = (5558.9375, 2934.1416, 2228.3938);
	angles[6] = (0, -3.1795, 0.0931);
	at[6] = 3.2000;
	points[7] = (5566.5752, 3111.6455, 2228.6338);
	angles[7] = (0, -1.9341, 0.0615);
	at[7] = 4.2000;
	points[8] = (5569.8823, 3289.2559, 2228.7166);
	angles[8] = (0, -0.2030, -0.0125);
	at[8] = 5.2000;
	points[9] = (5569.6851, 3325.8743, 2228.6890);
	angles[9] = (0, 0.4580, -0.0468);
	at[9] = 5.4000;
	points[10] = (5567.5986, 3391.7874, 2228.5591);
	angles[10] = (0, 2.4933, -0.1375);
	at[10] = 5.8000;
	points[11] = (5565.5903, 3429.4685, 2228.4646);
	angles[11] = (0, 3.1071, -0.1475);
	at[11] = 6;
	points[12] = (5556.0630, 3569.9763, 2228.0552);
	angles[12] = (0, 4.3150, -0.1785);
	at[12] = 6.8000;
	points[13] = (5537.2441, 3782.8701, 2227.2756);
	angles[13] = (0, 5.6560, -0.2362);
	at[13] = 8;
	points[14] = (5517.2837, 3959.7639, 2226.4214);
	angles[14] = (0, 7.1215, -0.3120);
	at[14] = 9;
	points[15] = (5491.1421, 4134.4097, 2225.2244);
	angles[15] = (0, 9.9478, -0.4677);
	at[15] = 10;
	points[16] = (5484.1338, 4171.2202, 2224.8857);
	angles[16] = (0, 11.0226, -0.5279);
	at[16] = 10.2000;
	points[17] = (5467.7954, 4240.6299, 2224.0750);
	angles[17] = (0, 14.7063, -0.7341);
	at[17] = 10.6000;
	points[18] = (5444.9609, 4302.4805, 2222.8740);
	angles[18] = (0, 23.4378, -1.2235);
	at[18] = 11;
	points[19] = (5393.8979, 4398.1494, 2220.0671);
	angles[19] = (0, 29.9686, -1.5815);
	at[19] = 11.6000;
	points[20] = (5357.3232, 4458.1494, 2218.0432);
	angles[20] = (0, 31.9144, -1.6791);
	at[20] = 12;
	points[21] = (5298.7798, 4547.4409, 2214.7952);
	angles[21] = (0, 33.9985, -1.7754);
	at[21] = 12.6000;
	points[22] = (5216.4956, 4663.3857, 2210.2480);
	angles[22] = (0, 36.3388, -1.8698);
	at[22] = 13.4000;
	points[23] = (5151.4565, 4748.1494, 2206.6851);
	angles[23] = (0, 38.2986, -1.9377);
	at[23] = 14;
	points[24] = (5082.9922, 4830.0396, 2202.9802);
	angles[24] = (0, 41.1021, -2.0218);
	at[24] = 14.6000;
	points[25] = (5034.1733, 4882.1655, 2200.3938);
	angles[25] = (0, 44.3712, -2.1067);
	at[25] = 15;
	points[26] = (5009.5273, 4905.5117, 2199.1140);
	angles[26] = (0, 47.0793, -2.1693);
	at[26] = 15.2000;
	points[27] = (4980.9448, 4928.6616, 2197.6694);
	angles[27] = (0, 52.3917, -2.2746);
	at[27] = 15.4000;
	points[28] = (4953.8193, 4944.3701, 2196.3662);
	angles[28] = (0, 61.5344, -2.3917);
	at[28] = 15.6000;
	points[29] = (4919.6455, 4958.3071, 2194.8032);
	angles[29] = (0, 68.6628, -2.4290);
	at[29] = 15.8000;
	points[30] = (4851.7720, 4978.4648, 2191.7874);
	angles[30] = (0, 75.1235, -2.4396);
	at[30] = 16.2000;
	points[31] = (4747.8740, 5000.1968, 2187.2559);
	angles[31] = (0, 79.7478, -2.4470);
	at[31] = 16.8000;
	points[32] = (4642.1655, 5015.5117, 2182.6772);
	angles[32] = (0, 82.9498, -2.4622);
	at[32] = 17.4000;
	points[33] = (4536.1025, 5025.1577, 2178.0669);
	angles[33] = (0, 86.0636, -2.4891);
	at[33] = 18;
	points[34] = (4429.3701, 5028.0708, 2173.3779);
	angles[34] = (0, 90.1724, -2.5365);
	at[34] = 18.6000;
	points[35] = (4358.4648, 5024.2915, 2170.1851);
	angles[35] = (0, 94.8278, -2.5916);
	at[35] = 19;
	points[36] = (4322.9526, 5019.2915, 2168.5435);
	angles[36] = (0, 98.9627, -2.6333);
	at[36] = 19.2000;
	points[37] = (4287.9922, 5010.1182, 2166.8545);
	angles[37] = (0, 106.3854, -2.6811);
	at[37] = 19.4000;
	points[38] = (4260.5908, 4994.8818, 2165.3938);
	angles[38] = (0, 123.2606, -2.6351);
	at[38] = 19.6000;
	points[39] = (4235.8267, 4967.5591, 2163.8386);
	angles[39] = (0, 139.3503, -2.3798);
	at[39] = 19.8000;
	points[40] = (4216.8110, 4939.4097, 2162.5237);
	angles[40] = (0, 146.5337, -2.1996);
	at[40] = 20;
	points[41] = (4166.6929, 4843.8979, 2158.7205);
	angles[41] = (0, 154.6241, -1.9400);
	at[41] = 20.6000;
	points[42] = (4124.7637, 4746.3779, 2155.2795);
	angles[42] = (0, 157.7874, -1.8101);
	at[42] = 21.2000;
	points[43] = (4050.8267, 4545.9448, 2148.9331);
	angles[43] = (0, 160.9955, -1.6156);
	at[43] = 22.4000;
	points[44] = (3985.5513, 4342.1655, 2143.5315);
	angles[44] = (0, 163.2903, -1.2172);
	at[44] = 23.6000;
	points[45] = (3968.0317, 4276.6929, 2142.5630);
	angles[45] = (0, 166.7410, -0.5737);
	at[45] = 24;
	points[46] = (3949.9214, 4171.7324, 2142.2205);
	angles[46] = (0, 171.6151, -0.0217);
	at[46] = 24.6000;
	points[47] = (3922.4724, 3924.2678, 2143.4448);
	angles[47] = (0, 174.7179, 0.4930);
	at[47] = 26;
	points[48] = (3907.3503, 3747.0159, 2145.7283);
	angles[48] = (0, 175.2480, 0.9972);
	at[48] = 27;
	points[49] = (3898.8621, 3643.9448, 2148.3896);
	angles[49] = (0, 175.4997, 1.7257);
	at[49] = 27.6000;
	points[50] = (3871.7441, 3253.4370, 2162.1379);
	angles[50] = (0, 176.4515, 2.1412);
	at[50] = 29.8000;
	points[51] = (3858.1143, 2968.2795, 2173.3386);
	angles[51] = (0, 178.7502, 2.3991);
	at[51] = 31.4000;
	points[52] = (3858.0396, 2936.4805, 2174.7324);
	angles[52] = (0, 180.0899, 2.5521);
	at[52] = 31.6000;
	points[53] = (3860.6418, 2794.3860, 2181.9961);
	angles[53] = (0, 181.5864, 3.0685);
	at[53] = 32.4000;
	points[54] = (3871.7441, 2581.5471, 2193.8308);
	angles[54] = (0, 184.4408, 3.2306);
	at[54] = 33.6000;
	points[55] = (3888.7991, 2441.2756, 2201.8267);
	angles[55] = (0, 189.6304, 3.2232);
	at[55] = 34.4000;
	points[56] = (3907.7009, 2371.8230, 2205.7678);
	angles[56] = (0, 200.2366, 3.0194);
	at[56] = 34.8000;
	points[57] = (3926.0828, 2344.2205, 2207.2993);
	angles[57] = (0, 216.3579, 2.5666);
	at[57] = 35;
	points[58] = (3951.6931, 2319.8386, 2208.6733);
	angles[58] = (0, 227.4770, 2.1845);
	at[58] = 35.2000;
	points[59] = (3979.8425, 2298.2795, 2209.8977);
	angles[59] = (0, 233.2031, 1.9534);
	at[59] = 35.4000;
	points[60] = (4040.0393, 2259.8779, 2212.0945);
	angles[60] = (0, 239.0366, 1.6875);
	at[60] = 35.8000;
	points[61] = (4102.3228, 2225.8110, 2214.0393);
	angles[61] = (0, 242.2991, 1.5173);
	at[61] = 36.2000;
	points[62] = (4198.3857, 2179.8899, 2216.6182);
	angles[62] = (0, 245.6823, 1.3036);
	at[62] = 36.8000;
	points[63] = (4297.5591, 2139.2954, 2218.7363);
	angles[63] = (0, 249.2775, 0.9833);
	at[63] = 37.4000;
	points[64] = (4328.2681, 2128.7637, 2219.1772);
	angles[64] = (0, 251.7527, 0.7112);
	at[64] = 37.6000;
	points[65] = (4467.0078, 2094.8306, 2219.8308);
	angles[65] = (0, 257.6582, 0.1358);
	at[65] = 38.4000;
	points[66] = (4676.6538, 2053.6694, 2220.0630);
	angles[66] = (0, 259.7194, 0.0309);
	at[66] = 39.6000;
	points[67] = (4888.0312, 2020.5787, 2220.2244);
	angles[67] = (0, 262.8887, 0.0927);
	at[67] = 40.8000;
	points[68] = (4923.8979, 2017.0394, 2220.3188);
	angles[68] = (0, 264.8279, 0.1730);
	at[68] = 41;
	points[69] = (4956.6929, 2016.5630, 2220.5315);
	angles[69] = (0, 270.5297, 0.4287);
	at[69] = 41.2000;
	points[70] = (5026.8506, 2027.5315, 2221.4685);
	angles[70] = (0, 282.1974, 0.8665);
	at[70] = 41.6000;
	points[71] = (5094.5669, 2048.6101, 2222.6851);
	angles[71] = (0, 289.5785, 1.0154);
	at[71] = 42;
	points[72] = (5159.2915, 2077.5198, 2223.9490);
	angles[72] = (0, 296.4359, 1.0030);
	at[72] = 42.4000;
	points[73] = (5219.1338, 2115.9370, 2225.0198);
	angles[73] = (0, 306.7838, 0.7393);
	at[73] = 42.8000;
	points[74] = (5244.4092, 2139.9055, 2225.3230);
	angles[74] = (0, 314.4143, 0.4691);
	at[74] = 43;
	points[75] = (5314.5674, 2220.4880, 2225.9607);
	angles[75] = (0, 320.4493, 0.3080);
	at[75] = 43.6000;
	points[76] = (5379.9209, 2304.6694, 2226.4844);
	angles[76] = (0, 323.2404, 0.2703);
	at[76] = 44.2000;
	points[77] = (5439.2520, 2389.7322, 2226.9448);
	angles[77] = (0, 326.4432, 0.2449);
	at[77] = 44.7833;
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
	points[0] = (-10384.1338, -3406.3860, 2819.2520);
	angles[0] = (0, 89.9778, 0);
	at[0] = 0;
	points[1] = (-10451.3779, -3406.6182, 2825.5986);
	angles[1] = (0, 90.2947, 0);
	at[1] = 0.5000;
	points[2] = (-10542.2832, -3407.2559, 2834.2246);
	angles[2] = (0, 90.4430, 0);
	at[2] = 1;
	points[3] = (-10613.9365, -3407.8545, 2841.0354);
	angles[3] = (0, 90.4921, 0);
	at[3] = 1.5000;
	points[4] = (-10692.9141, -3408.5552, 2848.5513);
	angles[4] = (0, 90.5138, 0);
	at[4] = 2;
	points[5] = (-10779.4492, -3409.3386, 2856.7913);
	angles[5] = (0, 90.5203, 0);
	at[5] = 2.5000;
	points[6] = (-10932.8740, -3410.7166, 2871.4133);
	angles[6] = (0, 90.5064, 0);
	at[6] = 3.5000;
	points[7] = (-11097.9922, -3412.1221, 2887.1536);
	angles[7] = (0, 90.4708, 0);
	at[7] = 4.5000;
	points[8] = (-11252.9922, -3413.3230, 2901.9292);
	angles[8] = (0, 90.4235, 0);
	at[8] = 5.5000;
	points[9] = (-11494.5674, -3414.8977, 2924.9529);
	angles[9] = (0, 90.3275, 0);
	at[9] = 7;
	points[10] = (-12209.6064, -3416.2717, 2992.9724);
	angles[10] = (0, 89.8449, 0);
	at[10] = 11.5000;
	points[11] = (-12371.9297, -3415.5549, 3008.3701);
	angles[11] = (0, 89.6660, 0);
	at[11] = 12.5000;
	points[12] = (-12608.4648, -3413.4250, 3030.7561);
	angles[12] = (0, 89.3117, 0);
	at[12] = 14;
	points[13] = (-12771.4180, -3410.9250, 3046.1340);
	angles[13] = (0, 88.9554, 0);
	at[13] = 15;
	points[14] = (-12927.4014, -3407.3542, 3060.7954);
	angles[14] = (0, 88.4591, 0);
	at[14] = 16;
	points[15] = (-13012.0078, -3404.7246, 3068.7166);
	angles[15] = (0, 88.0657, 0);
	at[15] = 16.5000;
	points[16] = (-13164.8428, -3397.9487, 3082.9290);
	angles[16] = (0, 86.8867, 0);
	at[16] = 17.5000;
	points[17] = (-13252.6377, -3391.9214, 3090.9883);
	angles[17] = (0, 85.4459, 0);
	at[17] = 18;
	points[18] = (-13320.0400, -3384.8269, 3097.0591);
	angles[18] = (0, 82.7826, 0);
	at[18] = 18.5000;
	points[19] = (-13397.7168, -3371.3977, 3103.9058);
	angles[19] = (0, 78.7295, 0);
	at[19] = 19;
	points[20] = (-13475.1182, -3352.7207, 3110.6418);
	angles[20] = (0, 75.1800, 0);
	at[20] = 19.5000;
	points[21] = (-13551.3779, -3329.7637, 3117.1890);
	angles[21] = (0, 72.1909, 0);
	at[21] = 20;
	points[22] = (-13700.3154, -3273.7402, 3129.6692);
	angles[22] = (0, 67.4676, 0);
	at[22] = 21;
	points[23] = (-13845, -3207.5237, 3141.3149);
	angles[23] = (0, 63.9921, 0);
	at[23] = 22;
	points[24] = (-13986.3389, -3133.8464, 3152.0984);
	angles[24] = (0, 61.4200, 0);
	at[24] = 23;
	points[25] = (-14193.2676, -3014.0630, 3166.3977);
	angles[25] = (0, 58.9362, 0);
	at[25] = 24.5000;
	points[26] = (-14397.4014, -2888.5747, 3177.6143);
	angles[26] = (0, 58.3806, 0);
	at[26] = 26;
	points[27] = (-14462.2051, -2849.1929, 3180.1143);
	angles[27] = (0, 58.9729, 0);
	at[27] = 26.5000;
	points[28] = (-14597.5205, -2768.5117, 3183.1062);
	angles[28] = (0, 59.2120, 0);
	at[28] = 27.5000;
	points[29] = (-14803.3867, -2644.9014, 3185.6851);
	angles[29] = (0, 58.8019, 0);
	at[29] = 29;
	points[30] = (-14874.2129, -2601.8032, 3186.3347);
	angles[30] = (0, 58.6028, 0);
	at[30] = 29.5000;
	points[31] = (-14940.4727, -2561.1497, 3186.8701);
	angles[31] = (0, 58.3938, 0);
	at[31] = 30;
	points[32] = (-15346.2207, -2302.9724, 3189.1692);
	angles[32] = (0, 56.5668, 0);
	at[32] = 33;
	points[33] = (-15545.1572, -2167.7676, 3189.8701);
	angles[33] = (0, 55.0561, 0);
	at[33] = 34.5000;
	points[34] = (-15674.5273, -2074.6929, 3190.2126);
	angles[34] = (0, 53.5945, 0);
	at[34] = 35.5000;
	points[35] = (-15739.2920, -2025.8544, 3190.3503);
	angles[35] = (0, 52.5978, 0);
	at[35] = 36;
	points[36] = (-15800.0781, -1978.1260, 3190.4604);
	angles[36] = (0, 51.4005, 0);
	at[36] = 36.5000;
	points[37] = (-15864.1738, -1925.1102, 3190.5591);
	angles[37] = (0, 49.7337, 0);
	at[37] = 37;
	points[38] = (-15922.5596, -1873.2440, 3190.6221);
	angles[38] = (0, 47.4929, 0);
	at[38] = 37.5000;
	points[39] = (-15981.1416, -1815.4646, 3190.6614);
	angles[39] = (0, 43.9545, 0);
	at[39] = 38;
	points[40] = (-16030.3545, -1757.7480, 3190.6653);
	angles[40] = (0, 37.8745, 0);
	at[40] = 38.5000;
	points[41] = (-16069.8428, -1697.3464, 3190.5828);
	angles[41] = (0, 31.0547, 0);
	at[41] = 39;
	points[42] = (-16110.2373, -1622.3071, 3190.3545);
	angles[42] = (0, 26.9620, 0);
	at[42] = 39.5000;
	points[43] = (-16142.7559, -1554.0945, 3190.0867);
	angles[43] = (0, 24.8045, 0);
	at[43] = 40;
	points[44] = (-16176.2207, -1478.0511, 3189.7480);
	angles[44] = (0, 23.2080, 0);
	at[44] = 40.5000;
	points[45] = (-16235.2764, -1331.6812, 3189.0198);
	angles[45] = (0, 21.1885, 0);
	at[45] = 41.5000;
	points[46] = (-16264.5674, -1254.1890, 3188.6064);
	angles[46] = (0, 20.4453, 0);
	at[46] = 42;
	points[47] = (-16344.5273, -1028.9133, 3187.3308);
	angles[47] = (0, 18.8912, 0);
	at[47] = 43.5000;
	points[48] = (-16443.9766, -725.0157, 3185.4805);
	angles[48] = (0, 17.5301, 0);
	at[48] = 45.5000;
	points[49] = (-16537.5977, -418.2599, 3183.5117);
	angles[49] = (0, 16.5237, 0);
	at[49] = 47.5000;
	points[50] = (-16581.7324, -267.0213, 3182.5081);
	angles[50] = (0, 16.0791, 0);
	at[50] = 48.5000;
	points[51] = (-16604.5273, -187.1543, 3181.9724);
	angles[51] = (0, 15.8462, 0);
	at[51] = 49;
	points[52] = (-16646.8906, -35.2491, 3180.9292);
	angles[52] = (0, 15.3743, 0);
	at[52] = 50;
	points[53] = (-16668.7402, 45.1787, 3180.3662);
	angles[53] = (0, 15.0840, 0);
	at[53] = 50.5000;
	points[54] = (-16688.1094, 118.0280, 3179.8464);
	angles[54] = (0, 14.7657, 0);
	at[54] = 51;
	points[55] = (-16709.5273, 200.9315, 3179.2402);
	angles[55] = (0, 14.2808, 0);
	at[55] = 51.5000;
	points[56] = (-16726.6133, 270.3945, 3178.7129);
	angles[56] = (0, 13.4237, 0);
	at[56] = 52;
	points[57] = (-16757.4414, 425.7323, 3176.9136);
	angles[57] = (0, 9.9261, 0);
	at[57] = 53;
	points[58] = (-16782.0469, 583.8307, 3174.5750);
	angles[58] = (0, 8.1563, 0);
	at[58] = 54;
	points[59] = (-16829.2520, 981.1417, 3168.3464);
	angles[59] = (0, 5.7702, 0);
	at[59] = 56.5000;
	points[60] = (-16850.9844, 1220.0276, 3165.0471);
	angles[60] = (0, 4.7287, 0);
	at[60] = 58;
	points[61] = (-16868.2676, 1459.8031, 3162.7166);
	angles[61] = (0, 3.5866, 0);
	at[61] = 59.5000;
	points[62] = (-16879.4492, 1700.2480, 3162.7363);
	angles[62] = (0, 1.6245, 0);
	at[62] = 61;
	points[63] = (-16880.5117, 1773.7795, 3163.9292);
	angles[63] = (0, 0.2538, 0);
	at[63] = 61.5000;
	points[64] = (-16877.7559, 1932.1182, 3169.0510);
	angles[64] = (0, -1.6308, 0);
	at[64] = 62.5000;
	points[65] = (-16874.9609, 2014.5906, 3172.3230);
	angles[65] = (0, -2.0944, 0);
	at[65] = 63;
	points[66] = (-16859.6855, 2332.2717, 3186.5356);
	angles[66] = (0, -3.2369, 0);
	at[66] = 65;
	points[67] = (-16838.8594, 2651.8467, 3202.1221);
	angles[67] = (0, -4.1695, 0);
	at[67] = 67;
	points[68] = (-16812.3613, 2969.9604, 3218.2637);
	angles[68] = (0, -5.3621, 0);
	at[68] = 69;
	points[69] = (-16786.7715, 3208.2715, 3230.5435);
	angles[69] = (0, -6.9277, 0);
	at[69] = 70.5000;
	points[70] = (-16764.2520, 3367.4922, 3238.7166);
	angles[70] = (0, -9.1835, 0);
	at[70] = 71.5000;
	points[71] = (-16749.8809, 3444.1143, 3242.5747);
	angles[71] = (0, -11.6900, 0);
	at[71] = 72;
	points[72] = (-16732.8750, 3515.2717, 3246.1221);
	angles[72] = (0, -14.1544, 0);
	at[72] = 72.5000;
	points[73] = (-16711.5352, 3594.5354, 3250.1575);
	angles[73] = (0, -15.5016, 0);
	at[73] = 73;
	points[74] = (-16617.9141, 3900.9133, 3266.0708);
	angles[74] = (0, -17.9909, 0);
	at[74] = 75;
	points[75] = (-16487.3242, 4277.5591, 3285.8584);
	angles[75] = (0, -20.1606, 0);
	at[75] = 77.5000;
	points[76] = (-16370.9844, 4575.7480, 3301.5315);
	angles[76] = (0, -22.5024, 0);
	at[76] = 79.5000;
	points[77] = (-16306.9297, 4722.9136, 3309.2244);
	angles[77] = (0, -24.4246, 0);
	at[77] = 80.5000;
	points[78] = (-16273.8584, 4793.0713, 3312.8660);
	angles[78] = (0, -25.7875, 0);
	at[78] = 81;
	points[79] = (-16236.2598, 4866.6929, 3316.6616);
	angles[79] = (0, -27.9013, 0);
	at[79] = 81.5000;
	points[80] = (-16196.7725, 4935.4727, 3320.1575);
	angles[80] = (0, -31.2138, 0);
	at[80] = 82;
	points[81] = (-16152.7168, 4997.9922, 3323.2402);
	angles[81] = (0, -38.4529, 0);
	at[81] = 82.5000;
	points[82] = (-16098.2285, 5052.3228, 3325.7598);
	angles[82] = (0, -48.0762, 0);
	at[82] = 83;
	points[83] = (-16036.1016, 5101.4961, 3327.9292);
	angles[83] = (0, -53.2842, 0);
	at[83] = 83.5000;
	points[84] = (-15968.5039, 5148.1099, 3329.9136);
	angles[84] = (0, -56.4393, 0);
	at[84] = 84;
	points[85] = (-15832.4023, 5230.9058, 3333.2993);
	angles[85] = (0, -60.1018, 0);
	at[85] = 85;
	points[86] = (-15691.9678, 5307.3228, 3336.2834);
	angles[86] = (0, -62.3579, 0);
	at[86] = 86;
	points[87] = (-15549.2520, 5379.0156, 3338.9844);
	angles[87] = (0, -63.9917, 0);
	at[87] = 87;
	points[88] = (-15331.2598, 5480.2759, 3342.6140);
	angles[88] = (0, -65.9476, 0);
	at[88] = 88.5000;
	points[89] = (-15112.1260, 5573.4644, 3345.7322);
	angles[89] = (0, -67.8649, 0);
	at[89] = 90;
	points[90] = (-14960.3545, 5632.0864, 3347.4844);
	angles[90] = (0, -69.8419, 0);
	at[90] = 91;
	points[91] = (-14890.0791, 5656.3389, 3348.0786);
	angles[91] = (0, -71.8761, 0);
	at[91] = 91.5000;
	points[92] = (-14737.4805, 5698.8188, 3348.6377);
	angles[92] = (0, -75.7592, 0);
	at[92] = 92.5000;
	points[93] = (-14502.4805, 5752.3623, 3348.7046);
	angles[93] = (0, -78.1086, 0);
	at[93] = 94;
	points[94] = (-14267.0078, 5797.9922, 3348.2520);
	angles[94] = (0, -79.8041, 0);
	at[94] = 95.5000;
	points[95] = (-14030.1182, 5836.4170, 3347.3503);
	angles[95] = (0, -81.6653, 0);
	at[95] = 97;
	points[96] = (-13791.3779, 5865.4727, 3345.8857);
	angles[96] = (0, -84.4763, 0);
	at[96] = 98.5000;
	points[97] = (-13632.5195, 5875.8271, 3344.4055);
	angles[97] = (0, -88.0463, 0);
	at[97] = 99.5000;
	points[98] = (-13550.8662, 5875.7085, 3343.3464);
	angles[98] = (0, -91.5506, 0);
	at[98] = 100;
	points[99] = (-13478.9365, 5869.4092, 3342.0710);
	angles[99] = (0, -97.1681, 0);
	at[99] = 100.5000;
	points[100] = (-13396.8506, 5855.2754, 3340.2598);
	angles[100] = (0, -100.8848, 0);
	at[100] = 101;
	points[101] = (-13322.0479, 5839.1733, 3338.4412);
	angles[101] = (0, -102.7318, 0);
	at[101] = 101.5000;
	points[102] = (-13087.5195, 5778.4253, 3332.1970);
	angles[102] = (0, -105.6467, 0);
	at[102] = 103;
	points[103] = (-12934.6465, 5733.7007, 3327.8308);
	angles[103] = (0, -106.7651, 0);
	at[103] = 104;
	points[104] = (-12706.1016, 5661.6138, 3320.9802);
	angles[104] = (0, -108.0905, 0);
	at[104] = 105.5000;
	points[105] = (-12478.8594, 5584.4487, 3313.7954);
	angles[105] = (0, -109.3247, 0);
	at[105] = 107;
	points[106] = (-12253.2676, 5501.9688, 3306.2166);
	angles[106] = (0, -110.7898, 0);
	at[106] = 108.5000;
	points[107] = (-12180.7090, 5473.8584, 3303.6494);
	angles[107] = (0, -111.4026, 0);
	at[107] = 109;
	points[108] = (-12104.0947, 5443.0708, 3300.8503);
	angles[108] = (0, -112.1952, 0);
	at[108] = 109.5000;
	points[109] = (-12033.4248, 5413.3857, 3298.1536);
	angles[109] = (0, -113.1693, 0);
	at[109] = 110;
	points[110] = (-11957.1660, 5379.3306, 3295.0710);
	angles[110] = (0, -114.6807, 0);
	at[110] = 110.5000;
	points[111] = (-11893.1895, 5348.1104, 3292.2441);
	angles[111] = (0, -117.0111, 0);
	at[111] = 111;
	points[112] = (-11824.3701, 5310.6694, 3288.8149);
	angles[112] = (0, -119.2266, 0);
	at[112] = 111.5000;
	points[113] = (-11753.5820, 5269.7246, 3285.0396);
	angles[113] = (0, -120.4530, 0);
	at[113] = 112;
	points[114] = (-11686.8115, 5229.7246, 3281.3464);
	angles[114] = (0, -121.1523, 0);
	at[114] = 112.5000;
	points[115] = (-11614.3701, 5185.3149, 3277.2400);
	angles[115] = (0, -121.6834, 0);
	at[115] = 113;
	points[116] = (-11549.7246, 5145.0396, 3273.5198);
	angles[116] = (0, -122.0471, 0);
	at[116] = 113.5000;
	points[117] = (-11412.2441, 5057.9131, 3265.4802);
	angles[117] = (0, -122.5818, 0);
	at[117] = 114.5000;
	points[118] = (-11280.1572, 4972.7954, 3257.6497);
	angles[118] = (0, -122.9335, 0);
	at[118] = 115.5000;
	points[119] = (-10479.5674, 4443.6616, 3210.1101);
	angles[119] = (0, -123.6950, 0);
	at[119] = 121.5000;
	points[120] = (-10210.8662, 4265, 3195.1614);
	angles[120] = (0, -123.4618, 0);
	at[120] = 123.5000;
	points[121] = (-10148.6611, 4224.0947, 3191.9805);
	angles[121] = (0, -123.2719, 0);
	at[121] = 124;
	points[122] = (-10076.2207, 4176.9688, 3188.5903);
	angles[122] = (0, -122.8112, 0);
	at[122] = 124.5000;
	points[123] = (-10016.6143, 4139.4097, 3186.3857);
	angles[123] = (0, -121.7644, 0);
	at[123] = 125;
	points[124] = (-9879.1338, 4058.2678, 3184.0276);
	angles[124] = (0, -119.8898, 0);
	at[124] = 126;
	points[125] = (-9320.5518, 3744.7795, 3187.8347);
	angles[125] = (0, -120.0226, 0);
	at[125] = 130;
	points[126] = (-9182.9521, 3662.2444, 3189.7598);
	angles[126] = (0, -121.9467, 0);
	at[126] = 131;
	points[127] = (-9115.7090, 3618.2322, 3190.5552);
	angles[127] = (0, -124.1259, 0);
	at[127] = 131.5000;
	points[128] = (-9051.6924, 3569.7324, 3190.8860);
	angles[128] = (0, -129.7594, 0);
	at[128] = 132;
	points[129] = (-9004.8428, 3510.1733, 3189.6536);
	angles[129] = (0, -149.9153, 0);
	at[129] = 132.5000;
	points[130] = (-8977.2832, 3436.0117, 3187.1694);
	angles[130] = (0, -163.7922, 0);
	at[130] = 133;
	points[131] = (-8961.8115, 3357.6338, 3184.1299);
	angles[131] = (0, -171.2746, 0);
	at[131] = 133.5000;
	points[132] = (-8954.3701, 3277.9724, 3180.7402);
	angles[132] = (0, -176.4661, 0);
	at[132] = 134;
	points[133] = (-8953.3857, 3198.1338, 3177.0632);
	angles[133] = (0, -180.8829, 0);
	at[133] = 134.5000;
	points[134] = (-8958.6621, 3118.6143, 3173.0510);
	angles[134] = (0, -185.6021, 0);
	at[134] = 135;
	points[135] = (-8972.5195, 3039.1416, 3168.4487);
	angles[135] = (0, -193.1219, 0);
	at[135] = 135.5000;
	points[136] = (-9007.8350, 2972.4880, 3162.5986);
	angles[136] = (0, -222.9044, 0);
	at[136] = 136;
	points[137] = (-9074.3311, 2928.5708, 3155.0867);
	angles[137] = (0, -240.4471, 0);
	at[137] = 136.5000;
	points[138] = (-9145.8662, 2893.4805, 3147.6260);
	angles[138] = (0, -245.3993, 0);
	at[138] = 137;
	points[139] = (-9219.6064, 2862.7285, 3140.2952);
	angles[139] = (0, -248.3622, 0);
	at[139] = 137.5000;
	points[140] = (-9370.5117, 2811.1023, 3126.3149);
	angles[140] = (0, -253.2685, 0);
	at[140] = 138.5000;
	points[141] = (-9447.0479, 2790.9331, 3119.9448);
	angles[141] = (0, -256.5978, 0);
	at[141] = 139;
	points[142] = (-9527.2051, 2777.5156, 3114.4014);
	angles[142] = (0, -263.8493, 0);
	at[142] = 139.5000;
	points[143] = (-9603.3066, 2784.2361, 3112.1458);
	angles[143] = (0, -280.0780, 0);
	at[143] = 140;
	points[144] = (-9680.7480, 2803.0630, 3111.5867);
	angles[144] = (0, -285.0687, 0);
	at[144] = 140.5000;
	points[145] = (-9757.5986, 2826.0750, 3111.6143);
	angles[145] = (0, -287.4535, 0);
	at[145] = 141;
	points[146] = (-9909.0156, 2879.1143, 3112.5906);
	angles[146] = (0, -290.5973, 0);
	at[146] = 142;
	points[147] = (-10057.2051, 2940.2678, 3114.4331);
	angles[147] = (0, -294.0463, 0);
	at[147] = 143;
	points[148] = (-10129.4883, 2975.3542, 3115.7244);
	angles[148] = (0, -297.2759, 0);
	at[148] = 143.5000;
	points[149] = (-10194.6455, 3016.7717, 3117.4922);
	angles[149] = (0, -308.1556, 0);
	at[149] = 144;
	points[150] = (-10245.1191, 3078.8623, 3120.8110);
	angles[150] = (0, -325.6446, 0);
	at[150] = 144.5000;
	points[151] = (-10285, 3147.2598, 3124.7559);
	angles[151] = (0, -331.3824, 0);
	at[151] = 145;
	points[152] = (-10390.4326, 3362.1694, 3137.7285);
	angles[152] = (0, -334.0517, 0);
	at[152] = 146.5000;
	points[153] = (-10426.6143, 3433.5159, 3142.1536);
	angles[153] = (0, -332.3849, 0);
	at[153] = 147;
	points[154] = (-10466.3389, 3502.9487, 3146.5159);
	angles[154] = (0, -328.5429, 0);
	at[154] = 147.5000;
	points[155] = (-10553.8584, 3631.5591, 3154.5747);
	angles[155] = (0, -325.4833, 0);
	at[155] = 148.5000;
	points[156] = (-10646.1025, 3764.6653, 3162.8506);
	angles[156] = (0, -325.1246, 0);
	at[156] = 149.5000;
	points[157] = (-10830.6299, 4024.6851, 3179.2441);
	angles[157] = (0, -324.1249, 0);
	at[157] = 151.5000;
	points[158] = (-11022.7158, 4280.9448, 3196.1262);
	angles[158] = (0, -321.9325, 0);
	at[158] = 153.5000;
	points[159] = (-11122.8740, 4402.1260, 3204.8149);
	angles[159] = (0, -318.7457, 0);
	at[159] = 154.5000;
	points[160] = (-11178.1494, 4459.5278, 3209.5317);
	angles[160] = (0, -313.5742, 0);
	at[160] = 155;
	points[161] = (-11239.4883, 4509.2915, 3214.8071);
	angles[161] = (0, -307.1120, 0);
	at[161] = 155.5000;
	points[162] = (-11304.6455, 4554.8818, 3220.4961);
	angles[162] = (0, -304.0394, 0);
	at[162] = 156;
	points[163] = (-11438.9375, 4639.0947, 3232.2285);
	angles[163] = (0, -300.9620, 0);
	at[163] = 157;
	points[164] = (-11577.3232, 4718.8188, 3244.1458);
	angles[164] = (0, -299.2835, 0);
	at[164] = 158;
	points[165] = (-11787.7158, 4832.3623, 3261.5906);
	angles[165] = (0, -297.6631, 0);
	at[165] = 159.5000;
	points[166] = (-12000.9053, 4940.7090, 3277.5474);
	angles[166] = (0, -296.3394, 0);
	at[166] = 161;
	points[167] = (-12212.0869, 5041.2202, 3289.0474);
	angles[167] = (0, -294.8851, 0);
	at[167] = 162.5000;
	points[168] = (-12287.7568, 5076.1421, 3292.5710);
	angles[168] = (0, -294.6673, 0);
	at[168] = 163;
	points[169] = (-12357.9531, 5108.1890, 3295.7520);
	angles[169] = (0, -294.4991, 0);
	at[169] = 163.5000;
	points[170] = (-12433.1494, 5142.3232, 3299.0906);
	angles[170] = (0, -294.3378, 0);
	at[170] = 164;
	points[171] = (-12723.9365, 5271.8115, 3311.5591);
	angles[171] = (0, -293.7086, 0);
	at[171] = 166;
	points[172] = (-13018.5830, 5398.5039, 3323.6614);
	angles[172] = (0, -292.8077, 0);
	at[172] = 168;
	points[173] = (-13315.8662, 5517.9531, 3335.2954);
	angles[173] = (0, -290.6911, 0);
	at[173] = 170;
	points[174] = (-13389.4102, 5544.5669, 3338.0195);
	angles[174] = (0, -289.3769, 0);
	at[174] = 170.5000;
	points[175] = (-13468.0703, 5569.8037, 3340.7795);
	angles[175] = (0, -286.3696, 0);
	at[175] = 171;
	points[176] = (-13539.9609, 5585.2754, 3342.9292);
	angles[176] = (0, -279.6454, 0);
	at[176] = 171.5000;
	points[177] = (-13619.4102, 5593.8979, 3344.8503);
	angles[177] = (0, -274.5386, 0);
	at[177] = 172;
	points[178] = (-13779.4482, 5596.6533, 3347.8899);
	angles[178] = (0, -268.8087, 0);
	at[178] = 173;
	points[179] = (-13938.9756, 5587.5591, 3350.2324);
	angles[179] = (0, -265.3240, 0);
	at[179] = 174;
	points[180] = (-14177.1260, 5558.5830, 3352.7913);
	angles[180] = (0, -261.2249, 0);
	at[180] = 175.5000;
	points[181] = (-14333.8584, 5529.3701, 3353.7876);
	angles[181] = (0, -257.8416, 0);
	at[181] = 176.5000;
	points[182] = (-14407.5986, 5511.1421, 3353.9211);
	angles[182] = (0, -254.8044, 0);
	at[182] = 177;
	points[183] = (-14484.9609, 5487.6377, 3353.7085);
	angles[183] = (0, -252.4311, 0);
	at[183] = 177.5000;
	points[184] = (-14786.5752, 5381.8506, 3351.8110);
	angles[184] = (0, -249.5803, 0);
	at[184] = 179.5000;
	points[185] = (-15010.8271, 5294.6455, 3349.8584);
	angles[185] = (0, -248.0067, 0);
	at[185] = 181;
	points[186] = (-15158.6611, 5232.7163, 3348.3347);
	angles[186] = (0, -246.6553, 0);
	at[186] = 182;
	points[187] = (-15304.8037, 5166.3389, 3346.5669);
	angles[187] = (0, -244.5609, 0);
	at[187] = 183;
	points[188] = (-15375.4717, 5131.1416, 3345.5671);
	angles[188] = (0, -242.8857, 0);
	at[188] = 183.5000;
	points[189] = (-15445.2363, 5092.8350, 3344.4094);
	angles[189] = (0, -240.0029, 0);
	at[189] = 184;
	points[190] = (-15512.3623, 5048.2676, 3342.9331);
	angles[190] = (0, -233.2256, 0);
	at[190] = 184.5000;
	points[191] = (-15566.4961, 4994.2520, 3340.9883);
	angles[191] = (0, -221.2728, 0);
	at[191] = 185;
	points[192] = (-15614.2910, 4931.1025, 3338.6890);
	angles[192] = (0, -215.3666, 0);
	at[192] = 185.5000;
	points[193] = (-15657.8740, 4864.4883, 3336.2283);
	angles[193] = (0, -212.1663, 0);
	at[193] = 186;
	points[194] = (-15738.1104, 4725.3149, 3330.9685);
	angles[194] = (0, -208.6371, 0);
	at[194] = 187;
	points[195] = (-15846.9287, 4512.0474, 3322.4802);
	angles[195] = (0, -205.9656, 0);
	at[195] = 188.5000;
	points[196] = (-16014.9609, 4148.2285, 3305.3740);
	angles[196] = (0, -204.2318, 0);
	at[196] = 191;
	points[197] = (-16045.3154, 4081.1812, 3300.9097);
	angles[197] = (0, -204.3860, 0);
	at[197] = 191.5000;
	points[198] = (-16078.3477, 4007.9922, 3295.0276);
	angles[198] = (0, -204.2126, 0);
	at[198] = 192;
	points[199] = (-16237.1260, 3641.7085, 3262.1182);
	angles[199] = (0, -202.5845, 0);
	at[199] = 194.5000;
	points[200] = (-16353.8184, 3344.6851, 3235.7600);
	angles[200] = (0, -200.2115, 0);
	at[200] = 196.5000;
	points[201] = (-16405.9062, 3194.2717, 3223.4844);
	angles[201] = (0, -198.0889, 0);
	at[201] = 197.5000;
	points[202] = (-16450.0391, 3041.2795, 3212.6143);
	angles[202] = (0, -194.1222, 0);
	at[202] = 198.5000;
	points[203] = (-16466.2988, 2963.4565, 3208.2837);
	angles[203] = (0, -190.0988, 0);
	at[203] = 199;
	points[204] = (-16475.6289, 2891.0354, 3205.3267);
	angles[204] = (0, -186.2542, 0);
	at[204] = 199.5000;
	points[205] = (-16482.7949, 2809.2363, 3202.5198);
	angles[205] = (0, -184.4534, 0);
	at[205] = 200;
	points[206] = (-16495.9453, 2570.5120, 3195.5750);
	angles[206] = (0, -182.3839, 0);
	at[206] = 201.5000;
	points[207] = (-16499.0156, 2487.8308, 3193.4136);
	angles[207] = (0, -181.9861, 0);
	at[207] = 202;
	points[208] = (-16501.4160, 2410.0471, 3191.4607);
	angles[208] = (0, -181.6689, 0);
	at[208] = 202.5000;
	points[209] = (-16507.6387, 2089.5786, 3184.0867);
	angles[209] = (0, -180.6665, 0);
	at[209] = 204.5000;
	points[210] = (-16507.3242, 1610.8346, 3174.9370);
	angles[210] = (0, -179.2521, 0);
	at[210] = 207.5000;
	points[211] = (-16505.9453, 1528.3190, 3173.6338);
	angles[211] = (0, -178.9294, 0);
	at[211] = 208;
	points[212] = (-16498.5039, 1288.8859, 3170.6379);
	angles[212] = (0, -177.4515, 0);
	at[212] = 209.5000;
	points[213] = (-16494.0957, 1207.9803, 3170.0669);
	angles[213] = (0, -176.4933, 0);
	at[213] = 210;
	points[214] = (-16488.0703, 1131.6141, 3169.9607);
	angles[214] = (0, -174.7183, 0);
	at[214] = 210.5000;
	points[215] = (-16479.2520, 1058.2677, 3170.6733);
	angles[215] = (0, -172.3652, 0);
	at[215] = 211;
	points[216] = (-16466.9688, 977.3425, 3172.2129);
	angles[216] = (0, -170.8710, 0);
	at[216] = 211.5000;
	points[217] = (-16423.7402, 742.1653, 3178.7439);
	angles[217] = (0, -168.7800, 0);
	at[217] = 213;
	points[218] = (-16374.1348, 506.4882, 3186.7717);
	angles[218] = (0, -167.6240, 0);
	at[218] = 214.5000;
	points[219] = (-16302.0088, 194.9760, 3198.4094);
	angles[219] = (0, -166.4064, 0);
	at[219] = 216.5000;
	points[220] = (-16243.5830, -37.2095, 3207.4016);
	angles[220] = (0, -165.3846, 0);
	at[220] = 218;
	points[221] = (-16179.6064, -269.2437, 3216.2717);
	angles[221] = (0, -163.7457, 0);
	at[221] = 219.5000;
	points[222] = (-16130.9453, -423.1024, 3221.6536);
	angles[222] = (0, -161.0247, 0);
	at[222] = 220.5000;
	points[223] = (-16104.9609, -490.7323, 3223.5432);
	angles[223] = (0, -157.4015, 0);
	at[223] = 221;
	points[224] = (-16070.5127, -564.4016, 3225.3071);
	angles[224] = (0, -153.7938, 0);
	at[224] = 221.5000;
	points[225] = (-15995.1182, -703.9843, 3228.3032);
	angles[225] = (0, -150.3777, 0);
	at[225] = 222.5000;
	points[226] = (-15913.3467, -841.5551, 3230.9568);
	angles[226] = (0, -148.5440, 0);
	at[226] = 223.5000;
	points[227] = (-15784.3701, -1044.2402, 3234.4526);
	angles[227] = (0, -146.7854, 0);
	at[227] = 225;
	points[228] = (-15695.4727, -1177.3229, 3236.4763);
	angles[228] = (0, -145.8660, 0);
	at[228] = 226;
	points[229] = (-15558.8984, -1373.2284, 3238.9097);
	angles[229] = (0, -144.4591, 0);
	at[229] = 227.5000;
	points[230] = (-15462.9531, -1503.7992, 3239.8582);
	angles[230] = (0, -142.9380, 0);
	at[230] = 228.5000;
	points[231] = (-15418.3467, -1561.1456, 3239.8464);
	angles[231] = (0, -141.6012, 0);
	at[231] = 229;
	points[232] = (-15315.9844, -1686.0198, 3239.0237);
	angles[232] = (0, -140.1636, 0);
	at[232] = 230;
	points[233] = (-15107.3623, -1929.1851, 3236.2441);
	angles[233] = (0, -138.7515, 0);
	at[233] = 232;
	points[234] = (-14838.5830, -2225.5237, 3231.4136);
	angles[234] = (0, -136.7727, 0);
	at[234] = 234.5000;
	points[235] = (-14727.4805, -2340.8464, 3228.9646);
	angles[235] = (0, -135.4490, 0);
	at[235] = 235.5000;
	points[236] = (-14612.3232, -2453.0435, 3225.9922);
	angles[236] = (0, -133.0938, 0);
	at[236] = 236.5000;
	points[237] = (-14554.7646, -2504.5393, 3224.2480);
	angles[237] = (0, -130.9466, 0);
	at[237] = 237;
	points[238] = (-14491.3379, -2554.8269, 3221.9607);
	angles[238] = (0, -126.2529, 0);
	at[238] = 237.5000;
	points[239] = (-14427.3623, -2595.1221, 3219.1260);
	angles[239] = (0, -120.5034, 0);
	at[239] = 238;
	points[240] = (-14284.8428, -2668.6968, 3212.1182);
	angles[240] = (0, -115.5497, 0);
	at[240] = 239;
	points[241] = (-14065, -2764.3743, 3200.3506);
	angles[241] = (0, -112.1117, 0);
	at[241] = 240.5000;
	points[242] = (-13841.3389, -2848.9922, 3187.4370);
	angles[242] = (0, -109.5955, 0);
	at[242] = 242;
	points[243] = (-13613.8584, -2923.5906, 3173.1733);
	angles[243] = (0, -106.8445, 0);
	at[243] = 243.5000;
	points[244] = (-13459.5283, -2966.2246, 3162.5630);
	angles[244] = (0, -104.2101, 0);
	at[244] = 244.5000;
	points[245] = (-13383.7402, -2983.8069, 3156.9250);
	angles[245] = (0, -102.3150, 0);
	at[245] = 245;
	points[246] = (-13303.7012, -2998.8071, 3150.4883);
	angles[246] = (0, -99.4118, 0);
	at[246] = 245.5000;
	points[247] = (-13233.3857, -3007.3308, 3144.2126);
	angles[247] = (0, -95.4548, 0);
	at[247] = 246;
	points[248] = (-13148.3457, -3012.8896, 3136.0396);
	angles[248] = (0, -93.0039, 0);
	at[248] = 246.5000;
	points[249] = (-13073.6221, -3015.8071, 3128.6262);
	angles[249] = (0, -91.8864, 0);
	at[249] = 247;
	points[250] = (-12989.9609, -3017.8110, 3120.1653);
	angles[250] = (0, -91.1144, 0);
	at[250] = 247.5000;
	points[251] = (-12913.2285, -3018.8467, 3112.3108);
	angles[251] = (0, -90.6006, 0);
	at[251] = 248;
	points[252] = (-12513.6221, -3017.2402, 3070.6182);
	angles[252] = (0, -89.2287, 0);
	at[252] = 250.5000;
	points[253] = (-11799.4883, -3000.3860, 2994.7207);
	angles[253] = (0, -88.2308, 0);
	at[253] = 255;
	points[254] = (-11717.2051, -2997.7756, 2985.9451);
	angles[254] = (0, -88.1530, 0);
	at[254] = 255.5000;
	points[255] = (-11478.1885, -2989.5789, 2960.4802);
	angles[255] = (0, -87.9397, 0);
	at[255] = 257;
	points[256] = (-11401.2207, -2986.7522, 2952.3267);
	angles[256] = (0, -87.8727, 0);
	at[256] = 257.5000;
	points[257] = (-11319.1729, -2983.6340, 2943.6929);
	angles[257] = (0, -87.7953, 0);
	at[257] = 258;
	points[258] = (-11248.8193, -2980.5747, 2936.3977);
	angles[258] = (0, -87.1079, 0);
	at[258] = 258.5000;
	points[259] = (-11166.6533, -2975.3623, 2927.9370);
	angles[259] = (0, -86.0282, 0);
	at[259] = 259;
	points[260] = (-11089.7236, -2969.4802, 2920.0432);
	angles[260] = (0, -85.4379, 0);
	at[260] = 259.5000;
	points[261] = (-11008.9766, -2962.6616, 2911.7756);
	angles[261] = (0, -85.0407, 0);
	at[261] = 260;
	points[262] = (-10217.6768, -2887.4883, 2830.9763);
	angles[262] = (0, -84.9734, 0);
	at[262] = 265;
	points[263] = (-10136.4971, -2880.6809, 2822.6577);
	angles[263] = (0, -85.3710, 0);
	at[263] = 265.5000;
	points[264] = (-10059.5674, -2874.9487, 2814.7520);
	angles[264] = (0, -85.9913, 0);
	at[264] = 266;
	points[265] = (-9898.5439, -2869.0198, 2798.0198);
	angles[265] = (0, -90.9666, 0);
	at[265] = 267;
	points[266] = (-9823.6611, -2880.5630, 2789.8149);
	angles[266] = (0, -103.7305, 0);
	at[266] = 267.5000;
	points[267] = (-9749.9609, -2909.6655, 2781.2324);
	angles[267] = (0, -115.6477, 0);
	at[267] = 268;
	points[268] = (-9682.3623, -2951.3428, 2772.9133);
	angles[268] = (0, -124.8243, 0);
	at[268] = 268.5000;
	points[269] = (-9621.4961, -3001.8977, 2765.0159);
	angles[269] = (0, -132.4373, 0);
	at[269] = 269;
	points[270] = (-9567.5986, -3060.1851, 2757.5513);
	angles[270] = (0, -140.3496, 0);
	at[270] = 269.5000;
	points[271] = (-9533.5430, -3129.6770, 2751.4568);
	angles[271] = (0, -170.3773, 0);
	at[271] = 270;
	points[272] = (-9543.0713, -3208.9136, 2749.1653);
	angles[272] = (0, -192.1165, 0);
	at[272] = 270.5000;
	points[273] = (-9568.8584, -3284.5237, 2748.5867);
	angles[273] = (0, -202.7098, 0);
	at[273] = 271;
	points[274] = (-9610.5518, -3352.4331, 2749.7993);
	angles[274] = (0, -218.1884, 0);
	at[274] = 271.5000;
	points[275] = (-9677.1660, -3390.9016, 2754.4487);
	angles[275] = (0, -254.4212, 0);
	at[275] = 272;
	points[276] = (-9755.6299, -3400.9724, 2761.2402);
	angles[276] = (0, -265.0421, 0);
	at[276] = 272.5000;
	points[277] = (-9915.4336, -3406.8230, 2775.6692);
	angles[277] = (0, -269.1370, 0);
	at[277] = 273.5000;
	points[278] = (-10384.1338, -3406.3860, 2819.2520);
	angles[278] = (0, -270.0222, 0);
	at[278] = 276.4500;
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
	points[0] = (-2171.3584, 538.0197, 2581.1770);
	angles[0] = (0, 80.3880, 0);
	at[0] = 0;
	points[1] = (-2259.2441, 542.5787, 2587.3269);
	angles[1] = (0, 87.5277, 0);
	at[1] = 0.5000;
	points[2] = (-3058.4373, 568.3464, 2641.9370);
	angles[2] = (0, 88.3153, 0);
	at[2] = 5;
	points[3] = (-3142.2798, 570.7992, 2646.6260);
	angles[3] = (0, 88.3622, 0);
	at[3] = 5.5000;
	points[4] = (-4120.5513, 595.0945, 2689.5239);
	angles[4] = (0, 88.4260, 0);
	at[4] = 11;
	points[5] = (-4384.7637, 603.5433, 2699.1062);
	angles[5] = (0, 87.7379, 0);
	at[5] = 12.5000;
	points[6] = (-4558.5039, 612.1102, 2703.3743);
	angles[6] = (0, 86.9401, 0);
	at[6] = 13.5000;
	points[7] = (-5625.6304, 673.7520, 2721.2717);
	angles[7] = (0, 86.9628, 0);
	at[7] = 19.5000;
	points[8] = (-5708.1099, 677.6968, 2722.3896);
	angles[8] = (0, 87.4746, 0);
	at[8] = 20;
	points[9] = (-6598.8579, 707.2008, 2729.6851);
	angles[9] = (0, 88.0541, 0);
	at[9] = 25;
	points[10] = (-6683.9761, 710.2480, 2730.5432);
	angles[10] = (0, 88.0012, 0);
	at[10] = 25.5000;
	points[11] = (-6949.8818, 720.5748, 2733.8584);
	angles[11] = (0, 87.1453, 0);
	at[11] = 27;
	points[12] = (-7039.1733, 726.8859, 2735.2439);
	angles[12] = (0, 84.6343, 0);
	at[12] = 27.5000;
	points[13] = (-7125.5908, 740.8386, 2737.5278);
	angles[13] = (0, 79.4391, 0);
	at[13] = 28;
	points[14] = (-7212.0078, 760.4961, 2740.3503);
	angles[14] = (0, 75.6628, 0);
	at[14] = 28.5000;
	points[15] = (-7295.5908, 790.7283, 2743.0356);
	angles[15] = (0, 64.0855, 0);
	at[15] = 29;
	points[16] = (-7353.4648, 855.8622, 2744.1458);
	angles[16] = (0, 35.4313, 0);
	at[16] = 29.5000;
	points[17] = (-7399.8423, 931.5748, 2744.6692);
	angles[17] = (0, 29.6995, 0);
	at[17] = 30;
	points[18] = (-7438.6616, 1011.2126, 2744.5354);
	angles[18] = (0, 22.8572, 0);
	at[18] = 30.5000;
	points[19] = (-7454.3306, 1097.3898, 2741.8896);
	angles[19] = (0, 5.4089, 0);
	at[19] = 31;
	points[20] = (-7459.6064, 1275.1300, 2734.2993);
	angles[20] = (0, -0.2210, 0);
	at[20] = 32;
	points[21] = (-7456.1021, 1362.4883, 2731.0039);
	angles[21] = (0, -4.3469, 0);
	at[21] = 32.5000;
	points[22] = (-7445.8267, 1450.9016, 2728.6614);
	angles[22] = (0, -7.3772, 0);
	at[22] = 33;
	points[23] = (-7416.2598, 1626.0393, 2724.7915);
	angles[23] = (0, -11.7742, 0);
	at[23] = 34;
	points[24] = (-7392.7559, 1711.6417, 2723.5828);
	angles[24] = (0, -18.6749, 0);
	at[24] = 34.5000;
	points[25] = (-7365.0396, 1794.6890, 2725.2954);
	angles[25] = (0, -13.2580, 0);
	at[25] = 35;
	points[26] = (-7341.4570, 1879.9370, 2729.0393);
	angles[26] = (0, -19.1125, 0);
	at[26] = 35.5000;
	points[27] = (-7297.6377, 1956.3149, 2732.4841);
	angles[27] = (0, -37.2423, 0);
	at[27] = 36;
	points[28] = (-7228.8975, 2011.8032, 2734.5591);
	angles[28] = (0, -58.7798, 0);
	at[28] = 36.5000;
	points[29] = (-7147.0078, 2042.1102, 2735.0317);
	angles[29] = (0, -75.0811, 0);
	at[29] = 37;
	points[30] = (-7065.3545, 2054.0630, 2734.4451);
	angles[30] = (0, -84.9012, 0);
	at[30] = 37.5000;
	points[31] = (-6973.5039, 2058.6731, 2733.4055);
	angles[31] = (0, -87.8443, 0);
	at[31] = 38;
	points[32] = (-6888.7402, 2060.8503, 2732.3779);
	angles[32] = (0, -88.8092, 0);
	at[32] = 38.5000;
	points[33] = (-6707.1655, 2062.8899, 2730.0828);
	angles[33] = (0, -89.6694, 0);
	at[33] = 39.5000;
	points[34] = (-6621.3779, 2063.1653, 2728.9688);
	angles[34] = (0, -89.8934, 0);
	at[34] = 40;
	points[35] = (-6439.8818, 2062.8821, 2726.5630);
	angles[35] = (0, -90.2174, 0);
	at[35] = 41;
	points[36] = (-6353.3066, 2062.4448, 2725.3975);
	angles[36] = (0, -90.3270, 0);
	at[36] = 41.5000;
	points[37] = (-6172.4019, 2061.0828, 2722.9175);
	angles[37] = (0, -90.5024, 0);
	at[37] = 42.5000;
	points[38] = (-5996.7715, 2059.3149, 2720.4646);
	angles[38] = (0, -90.6266, 0);
	at[38] = 43.5000;
	points[39] = (-5372.4414, 2050.9292, 2711.2991);
	angles[39] = (0, -90.8615, 0);
	at[39] = 47;
	points[40] = (-5197.4409, 2048.2520, 2708.5669);
	angles[40] = (0, -90.8851, 0);
	at[40] = 48;
	points[41] = (-5015.7480, 2045.4330, 2705.6182);
	angles[41] = (0, -90.8860, 0);
	at[41] = 49;
	points[42] = (-4929.8428, 2044.1143, 2704.1692);
	angles[42] = (0, -90.8748, 0);
	at[42] = 49.5000;
	points[43] = (-4747.8740, 2041.4370, 2700.9331);
	angles[43] = (0, -90.8075, 0);
	at[43] = 50.5000;
	points[44] = (-4665.4331, 2040.3347, 2699.3542);
	angles[44] = (0, -90.7383, 0);
	at[44] = 51;
	points[45] = (-4568.3857, 2039.2283, 2697.3347);
	angles[45] = (0, -90.5854, 0);
	at[45] = 51.5000;
	points[46] = (-4489.4097, 2038.6575, 2695.4451);
	angles[46] = (0, -90.2673, 0);
	at[46] = 52;
	points[47] = (-4404.3311, 2038.3505, 2692.9568);
	angles[47] = (0, -90.2093, 0);
	at[47] = 52.5000;
	points[48] = (-4225.9448, 2037.7008, 2686.7205);
	angles[48] = (0, -90.2072, 0);
	at[48] = 53.5000;
	points[49] = (-3159.2046, 2035.4528, 2638.9448);
	angles[49] = (0, -89.9458, 0);
	at[49] = 59.5000;
	points[50] = (-3073.4331, 2035.6024, 2634.6062);
	angles[50] = (0, -89.8705, 0);
	at[50] = 60;
	points[51] = (-2892.0042, 2036.5275, 2625.0435);
	angles[51] = (0, -89.5146, 0);
	at[51] = 61;
	points[52] = (-2810.5552, 2037.6339, 2620.3267);
	angles[52] = (0, -89.0456, 0);
	at[52] = 61.5000;
	points[53] = (-2278.4805, 2052.5708, 2579.5552);
	angles[53] = (0, -87.9047, 0);
	at[53] = 64.5000;
	points[54] = (-1923.1299, 2069.7717, 2549.4568);
	angles[54] = (0, -86.1363, 0);
	at[54] = 66.5000;
	points[55] = (-1836.6575, 2077.9214, 2542.1536);
	angles[55] = (0, -82.7540, 0);
	at[55] = 67;
	points[56] = (-1759.3071, 2114.2874, 2535.6377);
	angles[56] = (0, -48.7325, 0);
	at[56] = 67.5000;
	points[57] = (-1729.1063, 2196.1812, 2532.3782);
	angles[57] = (0, -10.4996, 0);
	at[57] = 68;
	points[58] = (-1705.8622, 2281.2244, 2529.6379);
	angles[58] = (0, -13.0195, 0);
	at[58] = 68.5000;
	points[59] = (-1692.5237, 2369.1692, 2527.6497);
	angles[59] = (0, -5.1205, 0);
	at[59] = 69;
	points[60] = (-1736.8859, 2438.9880, 2530.4211);
	angles[60] = (0, 55.6664, 0);
	at[60] = 69.5000;
	points[61] = (-1821.8937, 2455.4253, 2537.1143);
	angles[61] = (0, 86.5198, 0);
	at[61] = 70;
	points[62] = (-2264.7520, 2458.2756, 2572.5708);
	angles[62] = (0, 90.0114, 0);
	at[62] = 72.5000;
	points[63] = (-2348.4094, 2458.3821, 2578.1812);
	angles[63] = (0, 89.8723, 0);
	at[63] = 73;
	points[64] = (-2794.7639, 2459.5789, 2608.2639);
	angles[64] = (0, 89.8886, 0);
	at[64] = 75.5000;
	points[65] = (-3414.8662, 2459.1929, 2646.7876);
	angles[65] = (0, 90.2306, 0);
	at[65] = 79;
	points[66] = (-3768.9451, 2456.1377, 2664.2600);
	angles[66] = (0, 90.8447, 0);
	at[66] = 81;
	points[67] = (-3845.9529, 2454.8149, 2666.9646);
	angles[67] = (0, 91.0390, 0);
	at[67] = 81.5000;
	points[68] = (-3941.8899, 2452.9724, 2669.9292);
	angles[68] = (0, 91.1252, 0);
	at[68] = 82;
	points[69] = (-4026.0630, 2451.2756, 2672.3582);
	angles[69] = (0, 91.1696, 0);
	at[69] = 82.5000;
	points[70] = (-4114.7246, 2449.4331, 2674.8071);
	angles[70] = (0, 91.1999, 0);
	at[70] = 83;
	points[71] = (-4209.4487, 2447.4214, 2677.3425);
	angles[71] = (0, 91.2248, 0);
	at[71] = 83.5000;
	points[72] = (-4293.5825, 2445.6064, 2679.5396);
	angles[72] = (0, 91.2428, 0);
	at[72] = 84;
	points[73] = (-4382.0078, 2443.6733, 2681.8069);
	angles[73] = (0, 91.2587, 0);
	at[73] = 84.5000;
	points[74] = (-4474.2124, 2441.6299, 2684.1301);
	angles[74] = (0, 91.2736, 0);
	at[74] = 85;
	points[75] = (-4649.5278, 2437.6890, 2688.4646);
	angles[75] = (0, 91.2985, 0);
	at[75] = 86;
	points[76] = (-4829.7642, 2433.5630, 2692.8267);
	angles[76] = (0, 91.3218, 0);
	at[76] = 87;
	points[77] = (-5538.2676, 2416.6260, 2709.3149);
	angles[77] = (0, 91.4191, 0);
	at[77] = 91;
	points[78] = (-5719.0156, 2412.0867, 2713.3857);
	angles[78] = (0, 91.4531, 0);
	at[78] = 92;
	points[79] = (-5894.2524, 2407.5710, 2717.2795);
	angles[79] = (0, 91.4951, 0);
	at[79] = 93;
	points[80] = (-5986.6143, 2405.1340, 2719.3113);
	angles[80] = (0, 91.5233, 0);
	at[80] = 93.5000;
	points[81] = (-6074.6064, 2402.7639, 2721.2285);
	angles[81] = (0, 91.5562, 0);
	at[81] = 94;
	points[82] = (-6158.2285, 2400.4568, 2723.0393);
	angles[82] = (0, 91.5951, 0);
	at[82] = 94.5000;
	points[83] = (-6254.4492, 2397.7166, 2725.0945);
	angles[83] = (0, 91.6541, 0);
	at[83] = 95;
	points[84] = (-6518.6616, 2389.1968, 2730.5159);
	angles[84] = (0, 92.1663, 0);
	at[84] = 96.5000;
	points[85] = (-6600.2759, 2385.6655, 2731.9451);
	angles[85] = (0, 92.6194, 0);
	at[85] = 97;
	points[86] = (-6954.4492, 2364.1260, 2735.0234);
	angles[86] = (0, 94.3174, 0);
	at[86] = 99;
	points[87] = (-7131.6143, 2348.5710, 2734.9880);
	angles[87] = (0, 95.6571, 0);
	at[87] = 100;
	points[88] = (-7307.3623, 2326.8662, 2733.8662);
	angles[88] = (0, 98.5548, 0);
	at[88] = 101;
	points[89] = (-7395.1968, 2309.7717, 2732.6299);
	angles[89] = (0, 103.1924, 0);
	at[89] = 101.5000;
	points[90] = (-7472.7954, 2273.0393, 2728.8308);
	angles[90] = (0, 124.1954, 0);
	at[90] = 102;
	points[91] = (-7534.8032, 2210.3230, 2720.8425);
	angles[91] = (0, 140.3903, 0);
	at[91] = 102.5000;
	points[92] = (-7583.1099, 2136.5828, 2712.0159);
	angles[92] = (0, 149.9186, 0);
	at[92] = 103;
	points[93] = (-7620.9844, 2056.5354, 2704.5786);
	angles[93] = (0, 157.3783, 0);
	at[93] = 103.5000;
	points[94] = (-7645.4331, 1972.3622, 2702.5039);
	angles[94] = (0, 168.5118, 0);
	at[94] = 104;
	points[95] = (-7666.9292, 1796.6930, 2706.0198);
	angles[95] = (0, 174.4844, 0);
	at[95] = 105;
	points[96] = (-7681.1416, 1619.5432, 2710.8779);
	angles[96] = (0, 176.0011, 0);
	at[96] = 106;
	points[97] = (-7691.1812, 1441.6458, 2716.1455);
	angles[97] = (0, 177.4912, 0);
	at[97] = 107;
	points[98] = (-7693.5039, 1356.0748, 2718.6260);
	angles[98] = (0, 178.6907, 0);
	at[98] = 107.5000;
	points[99] = (-7698.6221, 1177.8977, 2724.1812);
	angles[99] = (0, 178.8983, 0);
	at[99] = 108.5000;
	points[100] = (-7696.2988, 1000.2559, 2729.9016);
	angles[100] = (0, 182.7491, 0);
	at[100] = 109.5000;
	points[101] = (-7687.9922, 911.2244, 2732.7639);
	angles[101] = (0, 187.2342, 0);
	at[101] = 110;
	points[102] = (-7667.3228, 825.6299, 2735.4565);
	angles[102] = (0, 199.2547, 0);
	at[102] = 110.5000;
	points[103] = (-7609.2915, 763.5906, 2737.2126);
	angles[103] = (0, 235.4997, 0);
	at[103] = 111;
	points[104] = (-7530.9058, 722.3543, 2738.2520);
	angles[104] = (0, 244.4989, 0);
	at[104] = 111.5000;
	points[105] = (-7448.9370, 687.0118, 2739.0906);
	angles[105] = (0, 247.6198, 0);
	at[105] = 112;
	points[106] = (-7282.4019, 624.2520, 2740.4604);
	angles[106] = (0, 250.2898, 0);
	at[106] = 113;
	points[107] = (-7029.6064, 536.7677, 2741.9607);
	angles[107] = (0, 250.6314, 0);
	at[107] = 114.5000;
	points[108] = (-6701.1021, 409.2283, 2741.5156);
	angles[108] = (0, 249.3696, 0);
	at[108] = 116.5000;
	points[109] = (-6533.3071, 350.3791, 2740.6416);
	angles[109] = (0, 252.0382, 0);
	at[109] = 117.5000;
	points[110] = (-6447.7559, 325.5146, 2739.9961);
	angles[110] = (0, 255.1022, 0);
	at[110] = 118;
	points[111] = (-6363.5039, 309.6925, 2739.0591);
	angles[111] = (0, 263.1993, 0);
	at[111] = 118.5000;
	points[112] = (-6274.7246, 306.5988, 2737.6458);
	angles[112] = (0, 269.6292, 0);
	at[112] = 119;
	points[113] = (-6096.7720, 311.9091, 2734.4136);
	angles[113] = (0, 272.6402, 0);
	at[113] = 120;
	points[114] = (-5564.3306, 340.0449, 2723.5474);
	angles[114] = (0, 271.8504, 0);
	at[114] = 123;
	points[115] = (-5482.6382, 341.5209, 2721.7244);
	angles[115] = (0, 270.6958, 0);
	at[115] = 123.5000;
	points[116] = (-5123.7007, 344.0555, 2714.0393);
	angles[116] = (0, 270.2981, 0);
	at[116] = 125.5000;
	points[117] = (-4234.6455, 346.9941, 2693.5789);
	angles[117] = (0, 270.0984, 0);
	at[117] = 130.5000;
	points[118] = (-4147.8740, 347.1197, 2691.2834);
	angles[118] = (0, 270.0732, 0);
	at[118] = 131;
	points[119] = (-4056.2598, 347.2035, 2688.7207);
	angles[119] = (0, 270.0388, 0);
	at[119] = 131.5000;
	points[120] = (-3880.2129, 347.1213, 2683.0237);
	angles[120] = (0, 269.8955, 0);
	at[120] = 132.5000;
	points[121] = (-3799.2952, 346.7787, 2679.5669);
	angles[121] = (0, 269.6721, 0);
	at[121] = 133;
	points[122] = (-3619.3545, 345.2819, 2670.5002);
	angles[122] = (0, 269.4519, 0);
	at[122] = 134;
	points[123] = (-2463.4841, 332.7787, 2603.1614);
	angles[123] = (0, 269.5637, 0);
	at[123] = 140.5000;
	points[124] = (-2290.0630, 333.0626, 2592.7600);
	angles[124] = (0, 271.3491, 0);
	at[124] = 141.5000;
	points[125] = (-2203.1931, 343.2669, 2586.7285);
	angles[125] = (0, 284.4366, 0);
	at[125] = 142;
	points[126] = (-2139.8071, 401.1024, 2580.1140);
	angles[126] = (0, 316.5145, 0);
	at[126] = 142.5000;
	points[127] = (-2137.5000, 486.4095, 2579.0786);
	angles[127] = (0, 369.9591, 0);
	at[127] = 143;
	points[128] = (-2162.2046, 537.1575, 2580.5549);
	angles[128] = (0, 436.1294, 0);
	at[128] = 143.5000;
	points[129] = (-2171.3584, 538.0197, 2581.1770);
	angles[129] = (0, 440.3881, 0);
	at[129] = 143.5500;
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
	points[0] = (395.6850, -460.0906, 2568.8030);
	angles[0] = (0, 7.8530, 0);
	at[0] = 0;
	points[1] = (395.6850, -460.0906, 2745.9685);
	angles[1] = (0, 7.8530, 0);
	at[1] = 0.0500;
	points[2] = (395.6850, -460.0906, 2745.9685);
	angles[2] = (0, 7.8530, 0);
	at[2] = 1.6500;
	points[3] = (395.6850, -460.0906, 2764.7637);
	angles[3] = (0, 7.8530, 0);
	at[3] = 1.7000;
	points[4] = (395.6850, -460.0906, 2816.3623);
	angles[4] = (0, 7.8530, 0);
	at[4] = 1.7500;
	points[5] = (395.6850, -460.0906, 2860.7837);
	angles[5] = (0, 7.8530, 0);
	at[5] = 1.8000;
	points[6] = (395.6850, -460.0906, 2898.0354);
	angles[6] = (0, 7.8530, 0);
	at[6] = 1.8500;
	points[7] = (395.6850, -460.0906, 2928.1064);
	angles[7] = (0, 7.8530, 0);
	at[7] = 1.9000;
	points[8] = (395.6850, -460.0906, 2951.0078);
	angles[8] = (0, 7.8530, 0);
	at[8] = 1.9500;
	points[9] = (395.6850, -460.0906, 2966.7283);
	angles[9] = (0, 7.8530, 0);
	at[9] = 2;
	points[10] = (395.6850, -460.0906, 2975.2795);
	angles[10] = (0, 7.8530, 0);
	at[10] = 2.0500;
	points[11] = (395.6850, -460.0906, 2976.6497);
	angles[11] = (0, 7.8530, 0);
	at[11] = 2.1000;
	points[12] = (395.6850, -460.0906, 2970.8506);
	angles[12] = (0, 7.8530, 0);
	at[12] = 2.1500;
	points[13] = (395.6850, -460.0906, 2957.8701);
	angles[13] = (0, 7.8530, 0);
	at[13] = 2.2000;
	points[14] = (395.6850, -460.0906, 2937.7207);
	angles[14] = (0, 7.8530, 0);
	at[14] = 2.2500;
	points[15] = (395.6850, -460.0906, 2910.3896);
	angles[15] = (0, 7.8530, 0);
	at[15] = 2.3000;
	points[16] = (395.6850, -460.0906, 2875.8899);
	angles[16] = (0, 7.8530, 0);
	at[16] = 2.3500;
	points[17] = (395.6850, -460.0906, 2834.2126);
	angles[17] = (0, 7.8530, 0);
	at[17] = 2.4000;
	points[18] = (395.6850, -460.0906, 2785.3584);
	angles[18] = (0, 7.8530, 0);
	at[18] = 2.4500;
	points[19] = (395.6850, -460.0906, 2568.8030);
	angles[19] = (0, 7.8530, 0);
	at[19] = 2.5000;
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
	points[0] = (55.3106, -2043.5670, 2558.6143);
	angles[0] = (0, 5.1940, 0);
	at[0] = 0;
	points[1] = (55.3106, -2043.5670, 2735.7795);
	angles[1] = (0, 5.1940, 0);
	at[1] = 0.0500;
	points[2] = (55.3106, -2043.5670, 2735.7795);
	angles[2] = (0, 5.1940, 0);
	at[2] = 1.6500;
	points[3] = (55.3106, -2043.5670, 2754.5750);
	angles[3] = (0, 5.1940, 0);
	at[3] = 1.7000;
	points[4] = (55.3106, -2043.5670, 2806.1733);
	angles[4] = (0, 5.1940, 0);
	at[4] = 1.7500;
	points[5] = (55.3106, -2043.5670, 2850.5984);
	angles[5] = (0, 5.1940, 0);
	at[5] = 1.8000;
	points[6] = (55.3106, -2043.5670, 2887.8467);
	angles[6] = (0, 5.1940, 0);
	at[6] = 1.8500;
	points[7] = (55.3106, -2043.5670, 2917.9211);
	angles[7] = (0, 5.1940, 0);
	at[7] = 1.9000;
	points[8] = (55.3106, -2043.5670, 2940.8188);
	angles[8] = (0, 5.1940, 0);
	at[8] = 1.9500;
	points[9] = (55.3106, -2043.5670, 2956.5432);
	angles[9] = (0, 5.1940, 0);
	at[9] = 2;
	points[10] = (55.3106, -2043.5670, 2965.0906);
	angles[10] = (0, 5.1940, 0);
	at[10] = 2.0500;
	points[11] = (55.3106, -2043.5670, 2966.4646);
	angles[11] = (0, 5.1940, 0);
	at[11] = 2.1000;
	points[12] = (55.3106, -2043.5670, 2960.6614);
	angles[12] = (0, 5.1940, 0);
	at[12] = 2.1500;
	points[13] = (55.3106, -2043.5670, 2947.6851);
	angles[13] = (0, 5.1940, 0);
	at[13] = 2.2000;
	points[14] = (55.3106, -2043.5670, 2927.5315);
	angles[14] = (0, 5.1940, 0);
	at[14] = 2.2500;
	points[15] = (55.3106, -2043.5670, 2900.2048);
	angles[15] = (0, 5.1940, 0);
	at[15] = 2.3000;
	points[16] = (55.3106, -2043.5670, 2865.7009);
	angles[16] = (0, 5.1940, 0);
	at[16] = 2.3500;
	points[17] = (55.3106, -2043.5670, 2824.0237);
	angles[17] = (0, 5.1940, 0);
	at[17] = 2.4000;
	points[18] = (55.3106, -2043.5670, 2775.1694);
	angles[18] = (0, 5.1940, 0);
	at[18] = 2.4500;
	points[19] = (55.3106, -2043.5670, 2558.6143);
	angles[19] = (0, 5.1940, 0);
	at[19] = 2.5000;
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
	points[0] = (-1335.7795, -4130.1968, 2658.3899);
	angles[0] = (0, -138.0590, 0);
	at[0] = 0;
	points[1] = (-1335.7795, -4130.1968, 2835.5552);
	angles[1] = (0, -138.0590, 0);
	at[1] = 0.0500;
	points[2] = (-1335.7795, -4130.1968, 2835.5552);
	angles[2] = (0, -138.0590, 0);
	at[2] = 1.6500;
	points[3] = (-1335.7795, -4130.1968, 2854.3464);
	angles[3] = (0, -138.0590, 0);
	at[3] = 1.7000;
	points[4] = (-1335.7795, -4130.1968, 2905.9487);
	angles[4] = (0, -138.0590, 0);
	at[4] = 1.7500;
	points[5] = (-1335.7795, -4130.1968, 2950.3701);
	angles[5] = (0, -138.0590, 0);
	at[5] = 1.8000;
	points[6] = (-1335.7795, -4130.1968, 2987.6221);
	angles[6] = (0, -138.0590, 0);
	at[6] = 1.8500;
	points[7] = (-1335.7795, -4130.1968, 3017.6929);
	angles[7] = (0, -138.0590, 0);
	at[7] = 1.9000;
	points[8] = (-1335.7795, -4130.1968, 3040.5945);
	angles[8] = (0, -138.0590, 0);
	at[8] = 1.9500;
	points[9] = (-1335.7795, -4130.1968, 3056.3149);
	angles[9] = (0, -138.0590, 0);
	at[9] = 2;
	points[10] = (-1335.7795, -4130.1968, 3064.8662);
	angles[10] = (0, -138.0590, 0);
	at[10] = 2.0500;
	points[11] = (-1335.7795, -4130.1968, 3066.2363);
	angles[11] = (0, -138.0590, 0);
	at[11] = 2.1000;
	points[12] = (-1335.7795, -4130.1968, 3060.4370);
	angles[12] = (0, -138.0590, 0);
	at[12] = 2.1500;
	points[13] = (-1335.7795, -4130.1968, 3047.4568);
	angles[13] = (0, -138.0590, 0);
	at[13] = 2.2000;
	points[14] = (-1335.7795, -4130.1968, 3027.3071);
	angles[14] = (0, -138.0590, 0);
	at[14] = 2.2500;
	points[15] = (-1335.7795, -4130.1968, 2999.9766);
	angles[15] = (0, -138.0590, 0);
	at[15] = 2.3000;
	points[16] = (-1335.7795, -4130.1968, 2965.4763);
	angles[16] = (0, -138.0590, 0);
	at[16] = 2.3500;
	points[17] = (-1335.7795, -4130.1968, 2923.7952);
	angles[17] = (0, -138.0590, 0);
	at[17] = 2.4000;
	points[18] = (-1335.7795, -4130.1968, 2874.9448);
	angles[18] = (0, -138.0590, 0);
	at[18] = 2.4500;
	points[19] = (-1335.7795, -4130.1968, 2658.3899);
	angles[19] = (0, -138.0590, 0);
	at[19] = 2.5000;
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
	points[0] = (-2342.1023, -2221.1497, 2573.3542);
	angles[0] = (0, -129.0460, 0);
	at[0] = 0;
	points[1] = (-2342.1023, -2221.1497, 2750.5195);
	angles[1] = (0, -129.0460, 0);
	at[1] = 0.0500;
	points[2] = (-2342.1023, -2221.1497, 2750.5195);
	angles[2] = (0, -129.0460, 0);
	at[2] = 1.6500;
	points[3] = (-2342.1023, -2221.1497, 2769.3110);
	angles[3] = (0, -129.0460, 0);
	at[3] = 1.7000;
	points[4] = (-2342.1023, -2221.1497, 2820.9133);
	angles[4] = (0, -129.0460, 0);
	at[4] = 1.7500;
	points[5] = (-2342.1023, -2221.1497, 2865.3347);
	angles[5] = (0, -129.0460, 0);
	at[5] = 1.8000;
	points[6] = (-2342.1023, -2221.1497, 2902.5828);
	angles[6] = (0, -129.0460, 0);
	at[6] = 1.8500;
	points[7] = (-2342.1023, -2221.1497, 2932.6575);
	angles[7] = (0, -129.0460, 0);
	at[7] = 1.9000;
	points[8] = (-2342.1023, -2221.1497, 2955.5591);
	angles[8] = (0, -129.0460, 0);
	at[8] = 1.9500;
	points[9] = (-2342.1023, -2221.1497, 2971.2795);
	angles[9] = (0, -129.0460, 0);
	at[9] = 2;
	points[10] = (-2342.1023, -2221.1497, 2979.8267);
	angles[10] = (0, -129.0460, 0);
	at[10] = 2.0500;
	points[11] = (-2342.1023, -2221.1497, 2981.2009);
	angles[11] = (0, -129.0460, 0);
	at[11] = 2.1000;
	points[12] = (-2342.1023, -2221.1497, 2975.3977);
	angles[12] = (0, -129.0460, 0);
	at[12] = 2.1500;
	points[13] = (-2342.1023, -2221.1497, 2962.4211);
	angles[13] = (0, -129.0460, 0);
	at[13] = 2.2000;
	points[14] = (-2342.1023, -2221.1497, 2942.2676);
	angles[14] = (0, -129.0460, 0);
	at[14] = 2.2500;
	points[15] = (-2342.1023, -2221.1497, 2914.9409);
	angles[15] = (0, -129.0460, 0);
	at[15] = 2.3000;
	points[16] = (-2342.1023, -2221.1497, 2880.4370);
	angles[16] = (0, -129.0460, 0);
	at[16] = 2.3500;
	points[17] = (-2342.1023, -2221.1497, 2838.7598);
	angles[17] = (0, -129.0460, 0);
	at[17] = 2.4000;
	points[18] = (-2342.1023, -2221.1497, 2789.9055);
	angles[18] = (0, -129.0460, 0);
	at[18] = 2.4500;
	points[19] = (-2342.1023, -2221.1497, 2573.3542);
	angles[19] = (0, -129.0460, 0);
	at[19] = 2.5000;
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
	points[0] = (-14136.7725, -386.0598, 2924.5828);
	angles[0] = (0, -173.5260, 0);
	at[0] = 0;
	points[1] = (-14136.7725, -386.0598, 3101.7480);
	angles[1] = (0, -173.5260, 0);
	at[1] = 0.0500;
	points[2] = (-14136.7725, -386.0598, 3101.7480);
	angles[2] = (0, -173.5260, 0);
	at[2] = 1.6500;
	points[3] = (-14136.7725, -386.0598, 3120.5435);
	angles[3] = (0, -173.5260, 0);
	at[3] = 1.7000;
	points[4] = (-14136.7725, -386.0598, 3172.1418);
	angles[4] = (0, -173.5260, 0);
	at[4] = 1.7500;
	points[5] = (-14136.7725, -386.0598, 3216.5669);
	angles[5] = (0, -173.5260, 0);
	at[5] = 1.8000;
	points[6] = (-14136.7725, -386.0598, 3253.8149);
	angles[6] = (0, -173.5260, 0);
	at[6] = 1.8500;
	points[7] = (-14136.7725, -386.0598, 3283.8896);
	angles[7] = (0, -173.5260, 0);
	at[7] = 1.9000;
	points[8] = (-14136.7725, -386.0598, 3306.7876);
	angles[8] = (0, -173.5260, 0);
	at[8] = 1.9500;
	points[9] = (-14136.7725, -386.0598, 3322.5120);
	angles[9] = (0, -173.5260, 0);
	at[9] = 2;
	points[10] = (-14136.7725, -386.0598, 3331.0591);
	angles[10] = (0, -173.5260, 0);
	at[10] = 2.0500;
	points[11] = (-14136.7725, -386.0598, 3332.4331);
	angles[11] = (0, -173.5260, 0);
	at[11] = 2.1000;
	points[12] = (-14136.7725, -386.0598, 3326.6299);
	angles[12] = (0, -173.5260, 0);
	at[12] = 2.1500;
	points[13] = (-14136.7725, -386.0598, 3313.6536);
	angles[13] = (0, -173.5260, 0);
	at[13] = 2.2000;
	points[14] = (-14136.7725, -386.0598, 3293.5000);
	angles[14] = (0, -173.5260, 0);
	at[14] = 2.2500;
	points[15] = (-14136.7725, -386.0598, 3266.1733);
	angles[15] = (0, -173.5260, 0);
	at[15] = 2.3000;
	points[16] = (-14136.7725, -386.0598, 3231.6692);
	angles[16] = (0, -173.5260, 0);
	at[16] = 2.3500;
	points[17] = (-14136.7725, -386.0598, 3189.9922);
	angles[17] = (0, -173.5260, 0);
	at[17] = 2.4000;
	points[18] = (-14136.7725, -386.0598, 3141.1377);
	angles[18] = (0, -173.5260, 0);
	at[18] = 2.4500;
	points[19] = (-14136.7725, -386.0598, 2924.5828);
	angles[19] = (0, -173.5260, 0);
	at[19] = 2.5000;
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
	points[0] = (-15424.2520, 1641.3859, 2961.3267);
	angles[0] = (0, -161.4930, 0);
	at[0] = 0;
	points[1] = (-15424.2520, 1641.3859, 3138.4919);
	angles[1] = (0, -161.4930, 0);
	at[1] = 0.0500;
	points[2] = (-15424.2520, 1641.3859, 3138.4919);
	angles[2] = (0, -161.4930, 0);
	at[2] = 1.6500;
	points[3] = (-15424.2520, 1641.3859, 3157.2874);
	angles[3] = (0, -161.4930, 0);
	at[3] = 1.7000;
	points[4] = (-15424.2520, 1641.3859, 3208.8857);
	angles[4] = (0, -161.4930, 0);
	at[4] = 1.7500;
	points[5] = (-15424.2520, 1641.3859, 3253.3110);
	angles[5] = (0, -161.4930, 0);
	at[5] = 1.8000;
	points[6] = (-15424.2520, 1641.3859, 3290.5591);
	angles[6] = (0, -161.4930, 0);
	at[6] = 1.8500;
	points[7] = (-15424.2520, 1641.3859, 3320.6340);
	angles[7] = (0, -161.4930, 0);
	at[7] = 1.9000;
	points[8] = (-15424.2520, 1641.3859, 3343.5315);
	angles[8] = (0, -161.4930, 0);
	at[8] = 1.9500;
	points[9] = (-15424.2520, 1641.3859, 3359.2561);
	angles[9] = (0, -161.4930, 0);
	at[9] = 2;
	points[10] = (-15424.2520, 1641.3859, 3367.8032);
	angles[10] = (0, -161.4930, 0);
	at[10] = 2.0500;
	points[11] = (-15424.2520, 1641.3859, 3369.1772);
	angles[11] = (0, -161.4930, 0);
	at[11] = 2.1000;
	points[12] = (-15424.2520, 1641.3859, 3363.3743);
	angles[12] = (0, -161.4930, 0);
	at[12] = 2.1500;
	points[13] = (-15424.2520, 1641.3859, 3350.3977);
	angles[13] = (0, -161.4930, 0);
	at[13] = 2.2000;
	points[14] = (-15424.2520, 1641.3859, 3330.2444);
	angles[14] = (0, -161.4930, 0);
	at[14] = 2.2500;
	points[15] = (-15424.2520, 1641.3859, 3302.9172);
	angles[15] = (0, -161.4930, 0);
	at[15] = 2.3000;
	points[16] = (-15424.2520, 1641.3859, 3268.4133);
	angles[16] = (0, -161.4930, 0);
	at[16] = 2.3500;
	points[17] = (-15424.2520, 1641.3859, 3226.7363);
	angles[17] = (0, -161.4930, 0);
	at[17] = 2.4000;
	points[18] = (-15424.2520, 1641.3859, 3177.8818);
	angles[18] = (0, -161.4930, 0);
	at[18] = 2.4500;
	points[19] = (-15424.2520, 1641.3859, 2961.3267);
	angles[19] = (0, -161.4930, 0);
	at[19] = 2.5000;
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
	points[0] = (-14639.9219, 3757.6223, 3015.0867);
	angles[0] = (0, -178.9440, 0);
	at[0] = 0;
	points[1] = (-14639.9219, 3757.6223, 3192.2520);
	angles[1] = (0, -178.9440, 0);
	at[1] = 0.0500;
	points[2] = (-14639.9219, 3757.6223, 3192.2520);
	angles[2] = (0, -178.9440, 0);
	at[2] = 1.6500;
	points[3] = (-14639.9219, 3757.6223, 3211.0435);
	angles[3] = (0, -178.9440, 0);
	at[3] = 1.7000;
	points[4] = (-14639.9219, 3757.6223, 3262.6458);
	angles[4] = (0, -178.9440, 0);
	at[4] = 1.7500;
	points[5] = (-14639.9219, 3757.6223, 3307.0669);
	angles[5] = (0, -178.9440, 0);
	at[5] = 1.8000;
	points[6] = (-14639.9219, 3757.6223, 3344.3191);
	angles[6] = (0, -178.9440, 0);
	at[6] = 1.8500;
	points[7] = (-14639.9219, 3757.6223, 3374.3899);
	angles[7] = (0, -178.9440, 0);
	at[7] = 1.9000;
	points[8] = (-14639.9219, 3757.6223, 3397.2913);
	angles[8] = (0, -178.9440, 0);
	at[8] = 1.9500;
	points[9] = (-14639.9219, 3757.6223, 3413.0156);
	angles[9] = (0, -178.9440, 0);
	at[9] = 2;
	points[10] = (-14639.9219, 3757.6223, 3421.5630);
	angles[10] = (0, -178.9440, 0);
	at[10] = 2.0500;
	points[11] = (-14639.9219, 3757.6223, 3422.9370);
	angles[11] = (0, -178.9440, 0);
	at[11] = 2.1000;
	points[12] = (-14639.9219, 3757.6223, 3417.1338);
	angles[12] = (0, -178.9440, 0);
	at[12] = 2.1500;
	points[13] = (-14639.9219, 3757.6223, 3404.1575);
	angles[13] = (0, -178.9440, 0);
	at[13] = 2.2000;
	points[14] = (-14639.9219, 3757.6223, 3384.0039);
	angles[14] = (0, -178.9440, 0);
	at[14] = 2.2500;
	points[15] = (-14639.9219, 3757.6223, 3356.6731);
	angles[15] = (0, -178.9440, 0);
	at[15] = 2.3000;
	points[16] = (-14639.9219, 3757.6223, 3322.1733);
	angles[16] = (0, -178.9440, 0);
	at[16] = 2.3500;
	points[17] = (-14639.9219, 3757.6223, 3280.4922);
	angles[17] = (0, -178.9440, 0);
	at[17] = 2.4000;
	points[18] = (-14639.9219, 3757.6223, 3231.6418);
	angles[18] = (0, -178.9440, 0);
	at[18] = 2.4500;
	points[19] = (-14639.9219, 3757.6223, 3015.0867);
	angles[19] = (0, -178.9440, 0);
	at[19] = 2.5000;
	mover = getEnt("iz_obj_9", "targetname");
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
