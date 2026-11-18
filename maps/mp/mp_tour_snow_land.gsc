main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_tour_snow_land", 0);

	setExpFog(1594.4882, 16807.3320, 0.7843, 0.7843, 0.7843, 0);

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
	ambientPlay("iz_0_trsl", 2);
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
	level.iz_route[level.iz_route.size] = (4001, 1557, 821);
	level.iz_route[level.iz_route.size] = (3993, 122, 820);
	level.iz_route[level.iz_route.size] = (3989, -1647, 817);
	level.iz_route[level.iz_route.size] = (3947, -2241, 817);
	level.iz_route[level.iz_route.size] = (3866, -2511, 816);
	level.iz_route[level.iz_route.size] = (3718, -2731, 817);
	level.iz_route[level.iz_route.size] = (3306, -2897, 803);
	level.iz_route[level.iz_route.size] = (2226, -3119, 794);
	level.iz_route[level.iz_route.size] = (1690, -3421, 818);
	level.iz_route[level.iz_route.size] = (1448, -3747, 846);
	level.iz_route[level.iz_route.size] = (1151, -4363, 924);
	level.iz_route[level.iz_route.size] = (991, -4997, 1033);
	level.iz_route[level.iz_route.size] = (876, -5506, 1143);
	level.iz_route[level.iz_route.size] = (673, -5848, 1212);
	level.iz_route[level.iz_route.size] = (237, -6067, 1251);
	level.iz_route[level.iz_route.size] = (-181, -6132, 1265);
	level.iz_route[level.iz_route.size] = (-671, -6069, 1253);
	level.iz_route[level.iz_route.size] = (-1369, -5698, 1192);
	level.iz_route[level.iz_route.size] = (-1880, -5247, 1134);
	level.iz_route[level.iz_route.size] = (-3116, -3994, 994);
	level.iz_route[level.iz_route.size] = (-4037, -2965, 918);
	level.iz_route[level.iz_route.size] = (-5022, -2025, 931);
	level.iz_route[level.iz_route.size] = (-5323, -1384, 922);
	level.iz_route[level.iz_route.size] = (-5290, -790, 886);
	level.iz_route[level.iz_route.size] = (-4917, -310, 794);
	level.iz_route[level.iz_route.size] = (-4175, -63, 634);
	level.iz_route[level.iz_route.size] = (-3268, -35, 470);
	level.iz_route[level.iz_route.size] = (-1843, -161, 307);
	level.iz_route[level.iz_route.size] = (-1001, -624, 272);
	level.iz_route[level.iz_route.size] = (-342, -1314, 271);
	level.iz_route[level.iz_route.size] = (496, -1421, 271);
	level.iz_route[level.iz_route.size] = (1073, -1119, 271);
	level.iz_route[level.iz_route.size] = (1366, -533, 271);
	level.iz_route[level.iz_route.size] = (1321, 75, 271);
	level.iz_route[level.iz_route.size] = (1026, 708, 271);
	level.iz_route[level.iz_route.size] = (487, 1046, 272);
	level.iz_route[level.iz_route.size] = (-339, 1183, 271);
	level.iz_route[level.iz_route.size] = (-1366, 1221, 268);
	level.iz_route[level.iz_route.size] = (-3999, 1199, 691);
	level.iz_route[level.iz_route.size] = (-5233, 1280, 929);
	level.iz_route[level.iz_route.size] = (-6025, 1305, 1145);
	level.iz_route[level.iz_route.size] = (-6731, 1559, 1306);
	level.iz_route[level.iz_route.size] = (-7063, 2131, 1345);
	level.iz_route[level.iz_route.size] = (-7367, 2904, 1379);
	level.iz_route[level.iz_route.size] = (-7589, 3508, 1416);
	level.iz_route[level.iz_route.size] = (-7602, 3920, 1420);
	level.iz_route[level.iz_route.size] = (-7372, 4336, 1411);
	level.iz_route[level.iz_route.size] = (-6555, 4568, 1342);
	level.iz_route[level.iz_route.size] = (-4564, 4525, 1163);
	level.iz_route[level.iz_route.size] = (-3434, 4456, 1065);
	level.iz_route[level.iz_route.size] = (-2395, 3774, 955);
	level.iz_route[level.iz_route.size] = (-1707, 3520, 924);
	level.iz_route[level.iz_route.size] = (-935, 3397, 917);
	level.iz_route[level.iz_route.size] = (-312, 3558, 906);
	level.iz_route[level.iz_route.size] = (86, 4051, 875);
	level.iz_route[level.iz_route.size] = (746, 4731, 845);
	level.iz_route[level.iz_route.size] = (1503, 5061, 832);
	level.iz_route[level.iz_route.size] = (2650, 5103, 843);
	level.iz_route[level.iz_route.size] = (3360, 4942, 849);
	level.iz_route[level.iz_route.size] = (3787, 4598, 855);
	level.iz_route[level.iz_route.size] = (3988, 4078, 849);
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
	points[0] = (-580.9331, -1607.7087, 271.2504);
	angles[0] = (0, -132.1969, 0);
	at[0] = 0;
	points[1] = (-539.2087, -1638.1890, 271.2551);
	angles[1] = (0, -125.4900, 0);
	at[1] = 0.2000;
	points[2] = (-479.3425, -1676.4803, 271.2598);
	angles[2] = (0, -122.0665, 0);
	at[2] = 0.4667;
	points[3] = (-324.7961, -1765.2599, 271.2701);
	angles[3] = (0, -118.6869, 0);
	at[3] = 1.1333;
	points[4] = (-230.5598, -1814.0906, 271.2752);
	angles[4] = (0, -116.6325, 0);
	at[4] = 1.5333;
	points[5] = (-165.2406, -1844.4961, 271.2787);
	angles[5] = (0, -114.1973, 0);
	at[5] = 1.8000;
	points[6] = (-115.2244, -1863.4607, 271.2811);
	angles[6] = (0, -109.4151, 0);
	at[6] = 2;
	points[7] = (-100.1512, -1867.1221, 271.2819);
	angles[7] = (0, -105.2399, 0);
	at[7] = 2.0667;
	points[8] = (-64.8701, -1869.7520, 271.2839);
	angles[8] = (0, -94.5467, 0);
	at[8] = 2.2000;
	points[9] = (-29.2092, -1868.2008, 271.2850);
	angles[9] = (0, -87.9375, 0);
	at[9] = 2.3333;
	points[10] = (58.9142, -1856.3464, 271.2886);
	angles[10] = (0, -80.9076, 0);
	at[10] = 2.6667;
	points[11] = (163.5496, -1834.9685, 271.2921);
	angles[11] = (0, -77.5559, 0);
	at[11] = 3.0667;
	points[12] = (317.5468, -1796.6024, 271.2976);
	angles[12] = (0, -74.5226, 0);
	at[12] = 3.6667;
	points[13] = (435.1811, -1756.4685, 271.3020);
	angles[13] = (0, -69.4682, 0);
	at[13] = 4.1333;
	points[14] = (515.8032, -1718.9528, 271.3063);
	angles[14] = (0, -61.3631, 0);
	at[14] = 4.4667;
	points[15] = (542.6378, -1697.5787, 271.3091);
	angles[15] = (0, -51.8609, 0);
	at[15] = 4.6000;
	points[16] = (568.6536, -1672.9763, 271.3122);
	angles[16] = (0, -47.0352, 0);
	at[16] = 4.7333;
	points[17] = (629.5906, -1608.2008, 271.3205);
	angles[17] = (0, -42.0877, 0);
	at[17] = 5.0667;
	points[18] = (674.4134, -1553.3190, 271.3275);
	angles[18] = (0, -37.9298, 0);
	at[18] = 5.3333;
	points[19] = (694.1693, -1523.1221, 271.3319);
	angles[19] = (0, -32.4707, 0);
	at[19] = 5.4667;
	points[20] = (700.3071, -1508.0354, 271.3343);
	angles[20] = (0, -25.1950, 0);
	at[20] = 5.5333;
	points[21] = (704.5984, -1490.7440, 271.3370);
	angles[21] = (0, -17.9476, 0);
	at[21] = 5.6000;
	points[22] = (710.0827, -1455.2638, 271.3429);
	angles[22] = (0, -9.5518, 0);
	at[22] = 5.7333;
	points[23] = (714.9567, -1348.8740, 271.3610);
	angles[23] = (0, -0.1489, 0);
	at[23] = 6.1333;
	points[24] = (707.6732, -1278.3149, 271.3736);
	angles[24] = (0, 9.8213, 0);
	at[24] = 6.4000;
	points[25] = (687.7166, -1229.9489, 271.3839);
	angles[25] = (0, 23.1709, 0);
	at[25] = 6.6000;
	points[26] = (635.0236, -1137.1378, 271.4051);
	angles[26] = (0, 32.3893, 0);
	at[26] = 7;
	points[27] = (590.4055, -1082.2166, 271.4185);
	angles[27] = (0, 42.5616, 0);
	at[27] = 7.2667;
	points[28] = (561.0472, -1061.9016, 271.4236);
	angles[28] = (0, 57.0077, 0);
	at[28] = 7.4000;
	points[29] = (545.5748, -1058.9331, 271.4252);
	angles[29] = (0, 72.6836, 0);
	at[29] = 7.4667;
	points[30] = (526.6929, -1060.9528, 271.4256);
	angles[30] = (0, 87.3719, 0);
	at[30] = 7.5333;
	points[31] = (510.5237, -1064.3938, 271.4256);
	angles[31] = (0, 96.3531, 0);
	at[31] = 7.6000;
	points[32] = (476.0079, -1074.0157, 271.4252);
	angles[32] = (0, 104.5947, 0);
	at[32] = 7.7333;
	points[33] = (441.6536, -1085.1458, 271.4248);
	angles[33] = (0, 107.6453, 0);
	at[33] = 7.8667;
	points[34] = (324.4839, -1127.0709, 271.4221);
	angles[34] = (0, 110.0186, 0);
	at[34] = 8.3333;
	points[35] = (190.3169, -1172.9922, 271.4185);
	angles[35] = (0, 107.2441, 0);
	at[35] = 8.8667;
	points[36] = (137.1898, -1185.1930, 271.4173);
	angles[36] = (0, 101.0138, 0);
	at[36] = 9.0667;
	points[37] = (103.9165, -1183.4921, 271.4177);
	angles[37] = (0, 86.6680, 0);
	at[37] = 9.2000;
	points[38] = (53.0370, -1168.4922, 271.4189);
	angles[38] = (0, 72.6068, 0);
	at[38] = 9.4000;
	points[39] = (-12.6331, -1140.7874, 271.4209);
	angles[39] = (0, 66.0810, 0);
	at[39] = 9.6667;
	points[40] = (-92.1976, -1100.9213, 271.4240);
	angles[40] = (0, 62.5214, 0);
	at[40] = 10;
	points[41] = (-185.2075, -1048.4370, 271.4260);
	angles[41] = (0, 59.5592, 0);
	at[41] = 10.4000;
	points[42] = (-212.8531, -1028.4213, 271.4252);
	angles[42] = (0, 53.4395, 0);
	at[42] = 10.5333;
	points[43] = (-251.8953, -992.0118, 271.4232);
	angles[43] = (0, 46.6627, 0);
	at[43] = 10.7333;
	points[44] = (-327.8626, -917.1811, 271.4177);
	angles[44] = (0, 46.0749, 0);
	at[44] = 11.1333;
	points[45] = (-367.8846, -881.8504, 271.4142);
	angles[45] = (0, 49.4424, 0);
	at[45] = 11.3333;
	points[46] = (-396.9055, -861.0394, 271.4110);
	angles[46] = (0, 54.8206, 0);
	at[46] = 11.4667;
	points[47] = (-412.2087, -852.9370, 271.4095);
	angles[47] = (0, 60.0261, 0);
	at[47] = 11.5333;
	points[48] = (-429.1063, -847.8819, 271.4071);
	angles[48] = (0, 69.9749, 0);
	at[48] = 11.6000;
	points[49] = (-463.2756, -850.3898, 271.4024);
	angles[49] = (0, 92.3251, 0);
	at[49] = 11.7333;
	points[50] = (-498.1693, -858.1457, 271.3972);
	angles[50] = (0, 101.5162, 0);
	at[50] = 11.8667;
	points[51] = (-583.3740, -884.2363, 271.3842);
	angles[51] = (0, 108.2331, 0);
	at[51] = 12.2000;
	points[52] = (-666.5630, -915.1890, 271.3705);
	angles[52] = (0, 111.2441, 0);
	at[52] = 12.5333;
	points[53] = (-748.1378, -950.6536, 271.3543);
	angles[53] = (0, 114.7258, 0);
	at[53] = 12.8667;
	points[54] = (-795.6732, -976.6182, 271.3409);
	angles[54] = (0, 120.3056, 0);
	at[54] = 13.0667;
	points[55] = (-807.9173, -986.5079, 271.3351);
	angles[55] = (0, 126.6642, 0);
	at[55] = 13.1333;
	points[56] = (-829.6693, -1014.8307, 271.3134);
	angles[56] = (0, 141.8346, 0);
	at[56] = 13.2667;
	points[57] = (-846.6378, -1045.9764, 271.2882);
	angles[57] = (0, 150.8313, 0);
	at[57] = 13.4000;
	points[58] = (-866.6496, -1095.3149, 271.2488);
	angles[58] = (0, 158.9593, 0);
	at[58] = 13.6000;
	points[59] = (-880.6024, -1146.7914, 271.2106);
	angles[59] = (0, 166.1106, 0);
	at[59] = 13.8000;
	points[60] = (-885.4922, -1181.8347, 271.1882);
	angles[60] = (0, 172.3148, 0);
	at[60] = 13.9333;
	points[61] = (-884.3465, -1217.4448, 271.1709);
	angles[61] = (0, 182.5900, 0);
	at[61] = 14.0667;
	points[62] = (-880.0079, -1233.5591, 271.1673);
	angles[62] = (0, 191.4859, 0);
	at[62] = 14.1333;
	points[63] = (-863.7401, -1264.4646, 271.1681);
	angles[63] = (0, 206.3512, 0);
	at[63] = 14.2667;
	points[64] = (-844.2166, -1294.7323, 271.1729);
	angles[64] = (0, 212.1934, 0);
	at[64] = 14.4000;
	points[65] = (-748.3859, -1422.8427, 271.2024);
	angles[65] = (0, 218.3521, 0);
	at[65] = 15;
	points[66] = (-656.3701, -1531.6261, 271.2315);
	angles[66] = (0, 221.4816, 0);
	at[66] = 15.5333;
	points[67] = (-580.9331, -1607.7087, 271.2504);
	angles[67] = (0, 227.8031, 0);
	at[67] = 15.9333;
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
	points[0] = (1338.4883, -809.5472, 271.3535);
	angles[0] = (0, -96.4888, 0);
	at[0] = 0;
	points[1] = (1390.4645, -803.4882, 271.3398);
	angles[1] = (0, -81.8934, 0);
	at[1] = 0.2000;
	points[2] = (1476.6693, -781.2598, 271.3122);
	angles[2] = (0, -74.1077, 0);
	at[2] = 0.5333;
	points[3] = (1577.9252, -747.3032, 271.2846);
	angles[3] = (0, -70.3425, 0);
	at[3] = 0.9333;
	points[4] = (1676.4487, -707.3976, 271.2744);
	angles[4] = (0, -66.4954, 0);
	at[4] = 1.3333;
	points[5] = (1724.9686, -683.1142, 271.2886);
	angles[5] = (0, -62.3380, 0);
	at[5] = 1.5333;
	points[6] = (1752.2086, -664.2402, 271.3197);
	angles[6] = (0, -54.8413, 0);
	at[6] = 1.6667;
	points[7] = (1778.7086, -640.3268, 271.3697);
	angles[7] = (0, -48.3753, 0);
	at[7] = 1.8000;
	points[8] = (1828.0237, -588.9016, 271.4862);
	angles[8] = (0, -42.9496, 0);
	at[8] = 2.0667;
	points[9] = (1930.0197, -465.3898, 271.7964);
	angles[9] = (0, -37.6329, 0);
	at[9] = 2.6667;
	points[10] = (1971.3427, -407.3858, 271.9622);
	angles[10] = (0, -34.5200, 0);
	at[10] = 2.9333;
	points[11] = (1997.5867, -362.1209, 272.1150);
	angles[11] = (0, -28.0768, 0);
	at[11] = 3.1333;
	points[12] = (2013.0985, -311.8712, 272.3673);
	angles[12] = (0, -15.9099, 0);
	at[12] = 3.3333;
	points[13] = (2029.0354, -224.2587, 272.8732);
	angles[13] = (0, -8.9905, 0);
	at[13] = 3.6667;
	points[14] = (2040.9172, -118.2614, 273.4748);
	angles[14] = (0, -5.2372, 0);
	at[14] = 4.0667;
	points[15] = (2045.0867, -29.3173, 273.8953);
	angles[15] = (0, -1.1933, 0);
	at[15] = 4.4000;
	points[16] = (2043.5276, 5.5167, 273.9799);
	angles[16] = (0, 3.1352, 0);
	at[16] = 4.5333;
	points[17] = (2033.8464, 57.3087, 273.8409);
	angles[17] = (0, 11.2913, 0);
	at[17] = 4.7333;
	points[18] = (1997.6732, 176.0780, 273.1551);
	angles[18] = (0, 19.6032, 0);
	at[18] = 5.2000;
	points[19] = (1960.8662, 256.9563, 272.6169);
	angles[19] = (0, 27.1433, 0);
	at[19] = 5.5333;
	points[20] = (1941.9449, 287.0480, 272.4217);
	angles[20] = (0, 32.4120, 0);
	at[20] = 5.6667;
	points[21] = (1918.8623, 313.8197, 272.2657);
	angles[21] = (0, 41.3907, 0);
	at[21] = 5.8000;
	points[22] = (1891.9803, 333.7863, 272.1787);
	angles[22] = (0, 52.6484, 0);
	at[22] = 5.9333;
	points[23] = (1845.8151, 361.5382, 272.0775);
	angles[23] = (0, 59.2476, 0);
	at[23] = 6.1333;
	points[24] = (1736.0079, 419.5906, 271.8878);
	angles[24] = (0, 63.1103, 0);
	at[24] = 6.6000;
	points[25] = (1607.1299, 480.6181, 271.6984);
	angles[25] = (0, 65.5779, 0);
	at[25] = 7.1333;
	points[26] = (1509.4528, 521.9921, 271.5685);
	angles[26] = (0, 67.9208, 0);
	at[26] = 7.5333;
	points[27] = (1442.4685, 546.6378, 271.4862);
	angles[27] = (0, 70.6527, 0);
	at[27] = 7.8000;
	points[28] = (1390.9489, 561.4252, 271.4279);
	angles[28] = (0, 75.1333, 0);
	at[28] = 8;
	points[29] = (1372.4607, 564.7874, 271.4091);
	angles[29] = (0, 78.4806, 0);
	at[29] = 8.0667;
	points[30] = (1357.2678, 565.7205, 271.3953);
	angles[30] = (0, 84.3173, 0);
	at[30] = 8.1333;
	points[31] = (1305.9685, 554.6653, 271.3728);
	angles[31] = (0, 104.3114, 0);
	at[31] = 8.3333;
	points[32] = (1224.5394, 518.4134, 271.3705);
	angles[32] = (0, 116.3368, 0);
	at[32] = 8.6667;
	points[33] = (1132.4685, 464.1851, 271.3866);
	angles[33] = (0, 122.1833, 0);
	at[33] = 9.0667;
	points[34] = (1045.4922, 402.3740, 271.4114);
	angles[34] = (0, 127.1364, 0);
	at[34] = 9.4667;
	points[35] = (991.9567, 355.8063, 271.4283);
	angles[35] = (0, 132.9564, 0);
	at[35] = 9.7333;
	points[36] = (969.7756, 329.1984, 271.4339);
	angles[36] = (0, 141.6664, 0);
	at[36] = 9.8667;
	points[37] = (958.3188, 296.4311, 271.4359);
	angles[37] = (0, 160.3983, 0);
	at[37] = 10;
	points[38] = (953.6772, 261.1752, 271.4370);
	angles[38] = (0, 171.6081, 0);
	at[38] = 10.1333;
	points[39] = (952.1378, 207.8803, 271.4386);
	angles[39] = (0, 178.9091, 0);
	at[39] = 10.3333;
	points[40] = (955.9133, 118.9571, 271.4409);
	angles[40] = (0, 183.3218, 0);
	at[40] = 10.6667;
	points[41] = (965.4449, -5.2163, 271.4425);
	angles[41] = (0, 184.3571, 0);
	at[41] = 11.1333;
	points[42] = (968.5079, -74.0921, 271.4425);
	angles[42] = (0, 181.1519, 0);
	at[42] = 11.4000;
	points[43] = (964.3661, -198.4421, 271.4406);
	angles[43] = (0, 177.7219, 0);
	at[43] = 11.8667;
	points[44] = (958.4528, -376.6394, 271.4366);
	angles[44] = (0, 178.6382, 0);
	at[44] = 12.5333;
	points[45] = (958.1417, -500.8228, 271.4327);
	angles[45] = (0, 180.8016, 0);
	at[45] = 13;
	points[46] = (963.4095, -590.6181, 271.4291);
	angles[46] = (0, 185.0477, 0);
	at[46] = 13.3333;
	points[47] = (969.1182, -625.5276, 271.4268);
	angles[47] = (0, 189.6314, 0);
	at[47] = 13.4667;
	points[48] = (974.1378, -642.1535, 271.4256);
	angles[48] = (0, 195.0155, 0);
	at[48] = 13.5333;
	points[49] = (981.7362, -655.8268, 271.4236);
	angles[49] = (0, 204.7056, 0);
	at[49] = 13.6000;
	points[50] = (993.8858, -669.8229, 271.4209);
	angles[50] = (0, 215.2938, 0);
	at[50] = 13.6667;
	points[51] = (1021.3583, -692.2717, 271.4153);
	angles[51] = (0, 229.5649, 0);
	at[51] = 13.8000;
	points[52] = (1051.1063, -711.0827, 271.4091);
	angles[52] = (0, 237.1227, 0);
	at[52] = 13.9333;
	points[53] = (1098.5511, -735.6575, 271.3996);
	angles[53] = (0, 243.2562, 0);
	at[53] = 14.1333;
	points[54] = (1163.9174, -763.3150, 271.3862);
	angles[54] = (0, 248.0894, 0);
	at[54] = 14.4000;
	points[55] = (1230.9016, -786.3819, 271.3732);
	angles[55] = (0, 251.9633, 0);
	at[55] = 14.6667;
	points[56] = (1300.1890, -804.3701, 271.3602);
	angles[56] = (0, 256.9726, 0);
	at[56] = 14.9333;
	points[57] = (1338.4883, -809.5472, 271.3535);
	angles[57] = (0, 263.5112, 0);
	at[57] = 15.0833;
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
	points[0] = (182.5028, 632.4607, 271.4626);
	angles[0] = (0, -110.4693, 0);
	at[0] = 0;
	points[1] = (225.1429, 622.5748, 271.4823);
	angles[1] = (0, -102.3799, 0);
	at[1] = 0.1667;
	points[2] = (269.2256, 616.5866, 271.4925);
	angles[2] = (0, -97.5783, 0);
	at[2] = 0.3333;
	points[3] = (380.1980, 609.0118, 271.5008);
	angles[3] = (0, -92.6869, 0);
	at[3] = 0.7500;
	points[4] = (557.9016, 607.4685, 271.4949);
	angles[4] = (0, -89.2243, 0);
	at[4] = 1.4167;
	points[5] = (667.6260, 615.0984, 271.4941);
	angles[5] = (0, -84.3416, 0);
	at[5] = 1.8333;
	points[6] = (799.7086, 632.8859, 271.4890);
	angles[6] = (0, -81.2505, 0);
	at[6] = 2.3333;
	points[7] = (886.4724, 649.6299, 271.4850);
	angles[7] = (0, -77.6021, 0);
	at[7] = 2.6667;
	points[8] = (948.7166, 670.3858, 271.4815);
	angles[8] = (0, -69.9064, 0);
	at[8] = 2.9167;
	points[9] = (1070.9646, 724.2323, 271.4709);
	angles[9] = (0, -64.6564, 0);
	at[9] = 3.4167;
	points[10] = (1130.1812, 754.8347, 271.4673);
	angles[10] = (0, -61.9206, 0);
	at[10] = 3.6667;
	points[11] = (1186.8898, 790.0984, 271.4685);
	angles[11] = (0, -56.2821, 0);
	at[11] = 3.9167;
	points[12] = (1204.2953, 804.2284, 271.4713);
	angles[12] = (0, -51.8300, 0);
	at[12] = 4;
	points[13] = (1217.6417, 819.1063, 271.4768);
	angles[13] = (0, -44.0183, 0);
	at[13] = 4.0833;
	points[14] = (1243.2047, 856.3898, 271.4921);
	angles[14] = (0, -34.4722, 0);
	at[14] = 4.2500;
	points[15] = (1296.8938, 953.4567, 271.5370);
	angles[15] = (0, -27.0040, 0);
	at[15] = 4.6667;
	points[16] = (1339.6221, 1055.8740, 271.5937);
	angles[16] = (0, -19.7814, 0);
	at[16] = 5.0833;
	points[17] = (1354.3268, 1121.1615, 271.6406);
	angles[17] = (0, -9.1515, 0);
	at[17] = 5.3333;
	points[18] = (1353.8740, 1143.4135, 271.6618);
	angles[18] = (0, -0.6388, 0);
	at[18] = 5.4167;
	points[19] = (1347.5118, 1162.1536, 271.6854);
	angles[19] = (0, 15.1923, 0);
	at[19] = 5.5000;
	points[20] = (1334.2874, 1181.5079, 271.7205);
	angles[20] = (0, 28.9981, 0);
	at[20] = 5.5833;
	points[21] = (1304.9213, 1214.5709, 271.7910);
	angles[21] = (0, 41.2750, 0);
	at[21] = 5.7500;
	points[22] = (1240.6929, 1274.9292, 271.9327);
	angles[22] = (0, 48.0206, 0);
	at[22] = 6.0833;
	points[23] = (1172.1024, 1332.0946, 272.0705);
	angles[23] = (0, 50.9705, 0);
	at[23] = 6.4167;
	points[24] = (1101.4213, 1386.0118, 272.1961);
	angles[24] = (0, 53.3818, 0);
	at[24] = 6.7500;
	points[25] = (1028.3425, 1436.6182, 272.3020);
	angles[25] = (0, 56.2439, 0);
	at[25] = 7.0833;
	points[26] = (971.8307, 1470.9646, 272.3567);
	angles[26] = (0, 59.7424, 0);
	at[26] = 7.3333;
	points[27] = (932.1141, 1490.6812, 272.3665);
	angles[27] = (0, 64.5525, 0);
	at[27] = 7.5000;
	points[28] = (914.0157, 1497.6141, 272.3567);
	angles[28] = (0, 67.9335, 0);
	at[28] = 7.5833;
	points[29] = (850.0236, 1517.4174, 272.2890);
	angles[29] = (0, 73.5391, 0);
	at[29] = 7.8333;
	points[30] = (654.5906, 1564.4568, 272.0028);
	angles[30] = (0, 77.7807, 0);
	at[30] = 8.5833;
	points[31] = (480.3661, 1597.7047, 271.7185);
	angles[31] = (0, 80.1917, 0);
	at[31] = 9.2500;
	points[32] = (326.4996, 1619.1222, 271.4618);
	angles[32] = (0, 83.6584, 0);
	at[32] = 9.8333;
	points[33] = (260.1161, 1623.8188, 271.3528);
	angles[33] = (0, 87.0073, 0);
	at[33] = 10.0833;
	points[34] = (214.9878, 1622.8740, 271.2827);
	angles[34] = (0, 92.3837, 0);
	at[34] = 10.2500;
	points[35] = (174.1921, 1614.3505, 271.2240);
	angles[35] = (0, 102.5950, 0);
	at[35] = 10.4167;
	points[36] = (91.1287, 1582.7047, 271.1083);
	angles[36] = (0, 112.8246, 0);
	at[36] = 10.7500;
	points[37] = (-8.7849, 1533.6732, 270.9709);
	angles[37] = (0, 117.4193, 0);
	at[37] = 11.1667;
	points[38] = (-124.8000, 1467.5433, 270.8146);
	angles[38] = (0, 120.9042, 0);
	at[38] = 11.6667;
	points[39] = (-236.6287, 1394.1732, 270.6677);
	angles[39] = (0, 124.8899, 0);
	at[39] = 12.1667;
	points[40] = (-305.2217, 1339.5039, 270.5827);
	angles[40] = (0, 131.0693, 0);
	at[40] = 12.5000;
	points[41] = (-321.5240, 1322.5000, 270.5650);
	angles[41] = (0, 135.5561, 0);
	at[41] = 12.5833;
	points[42] = (-332.0618, 1306.2164, 270.5567);
	angles[42] = (0, 145.0496, 0);
	at[42] = 12.6667;
	points[43] = (-339.6189, 1284.7167, 270.5567);
	angles[43] = (0, 156.8124, 0);
	at[43] = 12.7500;
	points[44] = (-346.3709, 1241.1458, 270.5728);
	angles[44] = (0, 171.4734, 0);
	at[44] = 12.9167;
	points[45] = (-346.8906, 1174.6221, 270.6130);
	angles[45] = (0, 181.0482, 0);
	at[45] = 13.1667;
	points[46] = (-340.8311, 1108.0826, 270.6638);
	angles[46] = (0, 186.2306, 0);
	at[46] = 13.4167;
	points[47] = (-325.1756, 1020.4882, 270.7410);
	angles[47] = (0, 191.8013, 0);
	at[47] = 13.7500;
	points[48] = (-299.4004, 935.2598, 270.8264);
	angles[48] = (0, 199.7209, 0);
	at[48] = 14.0833;
	points[49] = (-279.2228, 896.9213, 270.8712);
	angles[49] = (0, 210.0752, 0);
	at[49] = 14.2500;
	points[50] = (-248.1685, 866.9961, 270.9205);
	angles[50] = (0, 226.6427, 0);
	at[50] = 14.4167;
	points[51] = (-230.5295, 853.5157, 270.9465);
	angles[51] = (0, 230.9537, 0);
	at[51] = 14.5000;
	points[52] = (-174.5760, 815.8464, 271.0256);
	angles[52] = (0, 236.8102, 0);
	at[52] = 14.7500;
	points[53] = (-98.6787, 770.5316, 271.1288);
	angles[53] = (0, 239.8827, 0);
	at[53] = 15.0833;
	points[54] = (78.8650, 677.3189, 271.3543);
	angles[54] = (0, 243.9009, 0);
	at[54] = 15.8333;
	points[55] = (160.1591, 640.7520, 271.4437);
	angles[55] = (0, 246.9744, 0);
	at[55] = 16.1667;
	points[56] = (182.5028, 632.4607, 271.4626);
	angles[56] = (0, 249.5307, 0);
	at[56] = 16.2667;
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
	points[0] = (-1777.5591, 1599.1339, 288.9579);
	angles[0] = (0, -125.3293, 0);
	at[0] = 0;
	points[1] = (-1759.9645, 1590.7992, 287.8819);
	angles[1] = (0, -117.8089, 0);
	at[1] = 0.0833;
	points[2] = (-1737.3898, 1582.6733, 286.7390);
	angles[2] = (0, -111.9517, 0);
	at[2] = 0.1667;
	points[3] = (-1695.9094, 1570.9764, 284.9374);
	angles[3] = (0, -105.7334, 0);
	at[3] = 0.3333;
	points[4] = (-1608.0117, 1552.3149, 281.6850);
	angles[4] = (0, -101, 0);
	at[4] = 0.6667;
	points[5] = (-1477.0236, 1531.7953, 277.5130);
	angles[5] = (0, -97.9557, 0);
	at[5] = 1.1667;
	points[6] = (-1344.6260, 1516.4371, 273.7957);
	angles[6] = (0, -95.8826, 0);
	at[6] = 1.6667;
	points[7] = (-1233.5826, 1507.2245, 271.0213);
	angles[7] = (0, -94.1154, 0);
	at[7] = 2.0833;
	points[8] = (-1101.5040, 1502.0669, 268.2673);
	angles[8] = (0, -90.7891, 0);
	at[8] = 2.5833;
	points[9] = (-1055.7599, 1502.9449, 267.5654);
	angles[9] = (0, -88.4988, 0);
	at[9] = 2.7500;
	points[10] = (-1016.6063, 1506.0787, 267.2063);
	angles[10] = (0, -85.0805, 0);
	at[10] = 2.9167;
	points[11] = (-970.1968, 1511.9724, 267.0437);
	angles[11] = (0, -82.6654, 0);
	at[11] = 3.0833;
	points[12] = (-927.9528, 1518.3031, 267.0095);
	angles[12] = (0, -81.4397, 0);
	at[12] = 3.2500;
	points[13] = (-642.5709, 1571.2441, 267.8185);
	angles[13] = (0, -78.4727, 0);
	at[13] = 4.3333;
	points[14] = (-381.7067, 1629.5040, 269.2272);
	angles[14] = (0, -76.4932, 0);
	at[14] = 5.3333;
	points[15] = (-318.5087, 1645.3110, 269.6272);
	angles[15] = (0, -75.7718, 0);
	at[15] = 5.5833;
	points[16] = (-187.8039, 1682.1023, 270.5327);
	angles[16] = (0, -73.0351, 0);
	at[16] = 6.0833;
	points[17] = (-148.6256, 1695.3818, 270.8339);
	angles[17] = (0, -70.9185, 0);
	at[17] = 6.2500;
	points[18] = (-124.5744, 1704.9094, 271.0327);
	angles[18] = (0, -68.7334, 0);
	at[18] = 6.3333;
	points[19] = (-106.9039, 1713.5828, 271.1937);
	angles[19] = (0, -64.5032, 0);
	at[19] = 6.4167;
	points[20] = (-90.4079, 1726, 271.3945);
	angles[20] = (0, -55.2133, 0);
	at[20] = 6.5000;
	points[21] = (-76.2748, 1743.1300, 271.6630);
	angles[21] = (0, -43.1277, 0);
	at[21] = 6.5833;
	points[22] = (-65.6512, 1762.4449, 271.9610);
	angles[22] = (0, -32.4274, 0);
	at[22] = 6.6667;
	points[23] = (-51.9933, 1804.6929, 272.6055);
	angles[23] = (0, -17.2173, 0);
	at[23] = 6.8333;
	points[24] = (-44.2409, 1870.7795, 273.6075);
	angles[24] = (0, -4.4391, 0);
	at[24] = 7.0833;
	points[25] = (-46.4630, 1937.3938, 274.6193);
	angles[25] = (0, 3.5534, 0);
	at[25] = 7.3333;
	points[26] = (-56.7346, 2003.1654, 275.6288);
	angles[26] = (0, 10.5358, 0);
	at[26] = 7.5833;
	points[27] = (-68.6563, 2046.1575, 276.3028);
	angles[27] = (0, 16.2577, 0);
	at[27] = 7.7500;
	points[28] = (-87.3091, 2086.7520, 276.9677);
	angles[28] = (0, 26.6152, 0);
	at[28] = 7.9167;
	points[29] = (-99.8795, 2101.7915, 277.2346);
	angles[29] = (0, 37.3120, 0);
	at[29] = 8;
	points[30] = (-117.9217, 2116.4529, 277.4886);
	angles[30] = (0, 47.2845, 0);
	at[30] = 8.0833;
	points[31] = (-155.1543, 2140.3977, 277.8945);
	angles[31] = (0, 57.1726, 0);
	at[31] = 8.2500;
	points[32] = (-253.8972, 2191.1062, 278.7795);
	angles[32] = (0, 64.4880, 0);
	at[32] = 8.6667;
	points[33] = (-376.4957, 2242.7559, 279.8055);
	angles[33] = (0, 68.5320, 0);
	at[33] = 9.1667;
	points[34] = (-502.3819, 2285.9409, 280.9279);
	angles[34] = (0, 72.7304, 0);
	at[34] = 9.6667;
	points[35] = (-588.9094, 2307.8032, 281.8351);
	angles[35] = (0, 77.5730, 0);
	at[35] = 10;
	points[36] = (-627.7598, 2314.0315, 282.3031);
	angles[36] = (0, 81.2206, 0);
	at[36] = 10.1667;
	points[37] = (-674.9055, 2319.5435, 282.8413);
	angles[37] = (0, 83.3843, 0);
	at[37] = 10.3333;
	points[38] = (-716.6575, 2323.6733, 283.3059);
	angles[38] = (0, 84.3715, 0);
	at[38] = 10.5000;
	points[39] = (-763.8386, 2327.8503, 283.8272);
	angles[39] = (0, 84.9732, 0);
	at[39] = 10.6667;
	points[40] = (-827.9685, 2332.9646, 284.5358);
	angles[40] = (0, 85.5480, 0);
	at[40] = 10.9167;
	points[41] = (-1094.9961, 2349.7913, 287.5878);
	angles[41] = (0, 86.9479, 0);
	at[41] = 11.9167;
	points[42] = (-1362.2284, 2360.4922, 290.9980);
	angles[42] = (0, 88.3861, 0);
	at[42] = 12.9167;
	points[43] = (-1516.3662, 2362.5039, 293.3339);
	angles[43] = (0, 89.9707, 0);
	at[43] = 13.5000;
	points[44] = (-1629.2755, 2359.1929, 295.5331);
	angles[44] = (0, 93.0401, 0);
	at[44] = 13.9167;
	points[45] = (-1652.5709, 2357.1497, 296.1311);
	angles[45] = (0, 94.6768, 0);
	at[45] = 14;
	points[46] = (-1691.3898, 2350.0276, 297.5618);
	angles[46] = (0, 101.6072, 0);
	at[46] = 14.1667;
	points[47] = (-1733.1772, 2334.9490, 300.1421);
	angles[47] = (0, 110.5497, 0);
	at[47] = 14.3333;
	points[48] = (-1773.0237, 2315.0435, 303.3610);
	angles[48] = (0, 116.9504, 0);
	at[48] = 14.5000;
	points[49] = (-1829.1180, 2279.7678, 308.7921);
	angles[49] = (0, 123.4321, 0);
	at[49] = 14.7500;
	points[50] = (-1882.0511, 2239.6377, 314.6319);
	angles[50] = (0, 128.1777, 0);
	at[50] = 15;
	points[51] = (-1931.9174, 2195.6851, 320.6039);
	angles[51] = (0, 132.3516, 0);
	at[51] = 15.2500;
	points[52] = (-1978.2440, 2148.1851, 326.4425);
	angles[52] = (0, 136.8466, 0);
	at[52] = 15.5000;
	points[53] = (-2019.3898, 2096.4448, 331.7016);
	angles[53] = (0, 143.3827, 0);
	at[53] = 15.7500;
	points[54] = (-2041.1299, 2057.0984, 334.2315);
	angles[54] = (0, 152.9309, 0);
	at[54] = 15.9167;
	points[55] = (-2045.7401, 2037.6182, 334.3988);
	angles[55] = (0, 164.8126, 0);
	at[55] = 16;
	points[56] = (-2043.6495, 2015.1851, 333.3689);
	angles[56] = (0, 179.9144, 0);
	at[56] = 16.0833;
	points[57] = (-2038.5513, 1994.6417, 331.9445);
	angles[57] = (0, 189.9827, 0);
	at[57] = 16.1667;
	points[58] = (-2031.1930, 1972.3544, 330.1343);
	angles[58] = (0, 195.9604, 0);
	at[58] = 16.2500;
	points[59] = (-1995.9883, 1892.1300, 322.4776);
	angles[59] = (0, 205.4701, 0);
	at[59] = 16.5833;
	points[60] = (-1941.9843, 1795.1810, 312.0390);
	angles[60] = (0, 210.7540, 0);
	at[60] = 17;
	points[61] = (-1893.1339, 1721.2756, 303.5965);
	angles[61] = (0, 214.7105, 0);
	at[61] = 17.3333;
	points[62] = (-1852.6062, 1668.6929, 297.4000);
	angles[62] = (0, 218.7010, 0);
	at[62] = 17.5833;
	points[63] = (-1807.4489, 1621.2520, 291.6799);
	angles[63] = (0, 225.7887, 0);
	at[63] = 17.8333;
	points[64] = (-1777.5591, 1599.1339, 288.9579);
	angles[64] = (0, 234.6707, 0);
	at[64] = 17.9667;
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
	points[0] = (2136.7561, 771.2678, 277.8842);
	angles[0] = (0, -112, 0);
	at[0] = 0;
	points[1] = (2287.6812, 721.5984, 280.1000);
	angles[1] = (0, -106.5575, 0);
	at[1] = 0.6000;
	points[2] = (2468.3228, 674.7834, 283.2106);
	angles[2] = (0, -103.1709, 0);
	at[2] = 1.3000;
	points[3] = (2599.0906, 649.0039, 285.5638);
	angles[3] = (0, -99.6517, 0);
	at[3] = 1.8000;
	points[4] = (2678.8464, 640.0276, 287);
	angles[4] = (0, -94.5529, 0);
	at[4] = 2.1000;
	points[5] = (2703.8069, 639.9213, 287.4386);
	angles[5] = (0, -90.5162, 0);
	at[5] = 2.2000;
	points[6] = (2755.7048, 646.4606, 288.3461);
	angles[6] = (0, -81.9693, 0);
	at[6] = 2.4000;
	points[7] = (2833.9526, 663.1812, 289.7264);
	angles[7] = (0, -77.0093, 0);
	at[7] = 2.7000;
	points[8] = (3013.6221, 715.2913, 292.9209);
	angles[8] = (0, -71.9547, 0);
	at[8] = 3.4000;
	points[9] = (3089.1104, 742.2480, 294.2721);
	angles[9] = (0, -69.6465, 0);
	at[9] = 3.7000;
	points[10] = (3162.2166, 773.0079, 295.5898);
	angles[10] = (0, -65.9026, 0);
	at[10] = 4;
	points[11] = (3209.1262, 798.2205, 296.4457);
	angles[11] = (0, -60.2252, 0);
	at[11] = 4.2000;
	points[12] = (3230.4094, 814.5748, 296.8433);
	angles[12] = (0, -52.4280, 0);
	at[12] = 4.3000;
	points[13] = (3244.5945, 835.2559, 297.1280);
	angles[13] = (0, -37.0403, 0);
	at[13] = 4.4000;
	points[14] = (3254.2913, 859.7166, 297.3441);
	angles[14] = (0, -24.5093, 0);
	at[14] = 4.5000;
	points[15] = (3261.3938, 885.9095, 297.5193);
	angles[15] = (0, -16.9402, 0);
	at[15] = 4.6000;
	points[16] = (3273.6575, 964.8504, 297.8902);
	angles[16] = (0, -7.0729, 0);
	at[16] = 4.9000;
	points[17] = (3278.8662, 1044.7520, 298.1394);
	angles[17] = (0, -2.7330, 0);
	at[17] = 5.2000;
	points[18] = (3279.5356, 1124.7520, 298.3063);
	angles[18] = (0, 0.3268, 0);
	at[18] = 5.5000;
	points[19] = (3275.9253, 1205.0394, 298.3914);
	angles[19] = (0, 3.5593, 0);
	at[19] = 5.8000;
	points[20] = (3269.8936, 1257.6024, 298.3709);
	angles[20] = (0, 7.5961, 0);
	at[20] = 6;
	points[21] = (3264.8464, 1281.6456, 298.3102);
	angles[21] = (0, 11.1784, 0);
	at[21] = 6.1000;
	points[22] = (3242.7639, 1358.7284, 297.9724);
	angles[22] = (0, 17.0498, 0);
	at[22] = 6.4000;
	points[23] = (3186.5356, 1508.8229, 297.0535);
	angles[23] = (0, 22.6776, 0);
	at[23] = 7;
	points[24] = (3152.5632, 1581.2126, 296.4992);
	angles[24] = (0, 26.2630, 0);
	at[24] = 7.3000;
	points[25] = (3126.5945, 1627.8347, 296.0819);
	angles[25] = (0, 29.8653, 0);
	at[25] = 7.5000;
	points[26] = (3096.5117, 1671.5472, 295.6083);
	angles[26] = (0, 35.9418, 0);
	at[26] = 7.7000;
	points[27] = (3078.4055, 1691.8071, 295.3299);
	angles[27] = (0, 41.2325, 0);
	at[27] = 7.8000;
	points[28] = (3059.9568, 1707.0906, 295.0520);
	angles[28] = (0, 49.5133, 0);
	at[28] = 7.9000;
	points[29] = (3013.6772, 1732.9882, 294.3543);
	angles[29] = (0, 61.6474, 0);
	at[29] = 8.1000;
	points[30] = (2940.5591, 1765.2992, 293.2496);
	angles[30] = (0, 67.0790, 0);
	at[30] = 8.4000;
	points[31] = (2840.5000, 1803.7284, 291.7421);
	angles[31] = (0, 69.6900, 0);
	at[31] = 8.8000;
	points[32] = (2612.4766, 1879.9409, 288.3469);
	angles[32] = (0, 72.6806, 0);
	at[32] = 9.7000;
	points[33] = (2484.8938, 1917.1537, 286.4965);
	angles[33] = (0, 74.4639, 0);
	at[33] = 10.2000;
	points[34] = (2406.0591, 1936.9645, 285.4031);
	angles[34] = (0, 76.6897, 0);
	at[34] = 10.5000;
	points[35] = (2357.6182, 1945.6851, 284.7972);
	angles[35] = (0, 80.6871, 0);
	at[35] = 10.7000;
	points[36] = (2276.8149, 1953.7086, 283.9099);
	angles[36] = (0, 85.2111, 0);
	at[36] = 11;
	points[37] = (2197.4805, 1958.0787, 283.0945);
	angles[37] = (0, 87.3375, 0);
	at[37] = 11.3000;
	points[38] = (2037.4645, 1960.3071, 281.5205);
	angles[38] = (0, 90.3452, 0);
	at[38] = 11.9000;
	points[39] = (1904.0828, 1955.1104, 280.2433);
	angles[39] = (0, 93.5527, 0);
	at[39] = 12.4000;
	points[40] = (1824.5591, 1946.6693, 279.4862);
	angles[40] = (0, 97.3953, 0);
	at[40] = 12.7000;
	points[41] = (1773.2716, 1935.6654, 278.9929);
	angles[41] = (0, 103.9632, 0);
	at[41] = 12.9000;
	points[42] = (1750.5432, 1926.9095, 278.7740);
	angles[42] = (0, 109.9728, 0);
	at[42] = 13;
	points[43] = (1679.1221, 1888.6378, 278.1169);
	angles[43] = (0, 119.8404, 0);
	at[43] = 13.3000;
	points[44] = (1567.8818, 1815.3109, 277.1161);
	angles[44] = (0, 124.8278, 0);
	at[44] = 13.8000;
	points[45] = (1440.3071, 1718.6143, 275.9516);
	angles[45] = (0, 128.6598, 0);
	at[45] = 14.4000;
	points[46] = (1360.4055, 1649.2048, 275.1783);
	angles[46] = (0, 132.5118, 0);
	at[46] = 14.8000;
	points[47] = (1323.0828, 1610.8937, 274.7752);
	angles[47] = (0, 136.9023, 0);
	at[47] = 15;
	points[48] = (1306.6023, 1589.3425, 274.5606);
	angles[48] = (0, 142.5598, 0);
	at[48] = 15.1000;
	points[49] = (1296, 1567.0276, 274.3496);
	angles[49] = (0, 152.8037, 0);
	at[49] = 15.2000;
	points[50] = (1288.3151, 1541.5867, 274.1130);
	angles[50] = (0, 161.3632, 0);
	at[50] = 15.3000;
	points[51] = (1279.1141, 1488.8584, 273.6362);
	angles[51] = (0, 171.0565, 0);
	at[51] = 15.5000;
	points[52] = (1275.3583, 1435.5394, 273.1768);
	angles[52] = (0, 176.7207, 0);
	at[52] = 15.7000;
	points[53] = (1277.7560, 1355.6692, 272.5437);
	angles[53] = (0, 183.5975, 0);
	at[53] = 16;
	points[54] = (1290.4331, 1276.9016, 272.0185);
	angles[54] = (0, 191.6115, 0);
	at[54] = 16.3000;
	points[55] = (1306.9055, 1226.0630, 271.7744);
	angles[55] = (0, 199.6148, 0);
	at[55] = 16.5000;
	points[56] = (1333.6851, 1180.2166, 271.7036);
	angles[56] = (0, 213.4233, 0);
	at[56] = 16.7000;
	points[57] = (1350.2284, 1163.7520, 271.7657);
	angles[57] = (0, 223.6847, 0);
	at[57] = 16.8000;
	points[58] = (1372.1732, 1147.3583, 271.8878);
	angles[58] = (0, 231.3111, 0);
	at[58] = 16.9000;
	points[59] = (1416.4764, 1119.1536, 272.1665);
	angles[59] = (0, 237.8549, 0);
	at[59] = 17.1000;
	points[60] = (1441.3503, 1104.5709, 272.3319);
	angles[60] = (0, 239.2942, 0);
	at[60] = 17.2000;
	points[61] = (1486.3110, 1079.4331, 272.6402);
	angles[61] = (0, 240.9524, 0);
	at[61] = 17.4000;
	points[62] = (1629.3110, 1005.0355, 273.6685);
	angles[62] = (0, 243.2177, 0);
	at[62] = 18;
	points[63] = (1893.8268, 878.0945, 275.7079);
	angles[63] = (0, 245.1147, 0);
	at[63] = 19.1000;
	points[64] = (2087.7402, 791.4646, 277.3795);
	angles[64] = (0, 246.7217, 0);
	at[64] = 19.9000;
	points[65] = (2114.6575, 780.1733, 277.6457);
	angles[65] = (0, 247.2096, 0);
	at[65] = 20;
	points[66] = (2136.7561, 771.2678, 277.8842);
	angles[66] = (0, 248, 0);
	at[66] = 20.1000;
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
	points[0] = (-2255.7834, -2414.3071, 299.4252);
	angles[0] = (0, -101.3054, 0);
	at[0] = 0;
	points[1] = (-2124.7598, -2427.6733, 298.7417);
	angles[1] = (0, -94.4327, 0);
	at[1] = 0.5000;
	points[2] = (-1884.5433, -2439.0630, 297.0673);
	angles[2] = (0, -91.6180, 0);
	at[2] = 1.4000;
	points[3] = (-1697.1732, -2438.7087, 295.5213);
	angles[3] = (0, -88.1477, 0);
	at[3] = 2.1000;
	points[4] = (-1643.7166, -2434.7991, 294.9914);
	angles[4] = (0, -85.0348, 0);
	at[4] = 2.3000;
	points[5] = (-1620.3229, -2431.1418, 294.7146);
	angles[5] = (0, -81.3933, 0);
	at[5] = 2.4000;
	points[6] = (-1569.1929, -2417.4214, 293.9524);
	angles[6] = (0, -74.2224, 0);
	at[6] = 2.6000;
	points[7] = (-1493.1969, -2390.5750, 292.6425);
	angles[7] = (0, -69.6295, 0);
	at[7] = 2.9000;
	points[8] = (-1346.3544, -2327.3110, 289.8488);
	angles[8] = (0, -65.0438, 0);
	at[8] = 3.5000;
	points[9] = (-1228.8188, -2265.3701, 287.4331);
	angles[9] = (0, -59.9817, 0);
	at[9] = 4;
	points[10] = (-1184.1575, -2235.2363, 286.4425);
	angles[10] = (0, -54.5463, 0);
	at[10] = 4.2000;
	points[11] = (-1165.9882, -2217.9409, 285.9925);
	angles[11] = (0, -46.4069, 0);
	at[11] = 4.3000;
	points[12] = (-1152.4528, -2195, 285.5563);
	angles[12] = (0, -32.9727, 0);
	at[12] = 4.4000;
	points[13] = (-1142.9331, -2170.0513, 285.1575);
	angles[13] = (0, -23.2133, 0);
	at[13] = 4.5000;
	points[14] = (-1130.1378, -2118.6458, 284.4323);
	angles[14] = (0, -13.1716, 0);
	at[14] = 4.7000;
	points[15] = (-1121.8937, -2065.9802, 283.7563);
	angles[15] = (0, -8.3581, 0);
	at[15] = 4.9000;
	points[16] = (-1112.8779, -1932.8149, 282.1878);
	angles[16] = (0, -1.7020, 0);
	at[16] = 5.4000;
	points[17] = (-1114.6968, -1853.0787, 281.3028);
	angles[17] = (0, 2.8948, 0);
	at[17] = 5.7000;
	points[18] = (-1117.4016, -1828.7756, 281.0366);
	angles[18] = (0, 5.8684, 0);
	at[18] = 5.8000;
	points[19] = (-1153.8071, -1644.9135, 279.0732);
	angles[19] = (0, 12.7882, 0);
	at[19] = 6.5000;
	points[20] = (-1201.4882, -1464.4094, 277.3083);
	angles[20] = (0, 16.5244, 0);
	at[20] = 7.2000;
	points[21] = (-1218.2638, -1413.6378, 276.8835);
	angles[21] = (0, 18.7865, 0);
	at[21] = 7.4000;
	points[22] = (-1239.2834, -1363.9922, 276.5764);
	angles[22] = (0, 24.6326, 0);
	at[22] = 7.6000;
	points[23] = (-1252.9292, -1343.8466, 276.5646);
	angles[23] = (0, 33.1273, 0);
	at[23] = 7.7000;
	points[24] = (-1271.2677, -1324.5513, 276.6311);
	angles[24] = (0, 41.8192, 0);
	at[24] = 7.8000;
	points[25] = (-1335.2205, -1276.6534, 277.1098);
	angles[25] = (0, 55.8935, 0);
	at[25] = 8.1000;
	points[26] = (-1405.1536, -1238.1339, 277.9287);
	angles[26] = (0, 62.8073, 0);
	at[26] = 8.4000;
	points[27] = (-1503.6536, -1197.7087, 279.6193);
	angles[27] = (0, 70.1269, 0);
	at[27] = 8.8000;
	points[28] = (-1554.7047, -1182.6732, 280.8268);
	angles[28] = (0, 74.3932, 0);
	at[28] = 9;
	points[29] = (-1577.5826, -1177.4882, 281.4685);
	angles[29] = (0, 76.8534, 0);
	at[29] = 9.1000;
	points[30] = (-1789.9055, -1143.2834, 288.0327);
	angles[30] = (0, 81.7931, 0);
	at[30] = 9.9000;
	points[31] = (-2053.8977, -1109.1497, 296.5693);
	angles[31] = (0, 83.2473, 0);
	at[31] = 10.9000;
	points[32] = (-2266.7244, -1087.2716, 303.7295);
	angles[32] = (0, 84.9459, 0);
	at[32] = 11.7000;
	points[33] = (-2317.9133, -1083.2914, 305.5169);
	angles[33] = (0, 85.7084, 0);
	at[33] = 11.9000;
	points[34] = (-2346.6497, -1081.4370, 306.5398);
	angles[34] = (0, 86.2466, 0);
	at[34] = 12;
	points[35] = (-2397.6458, -1079.1969, 308.4095);
	angles[35] = (0, 87.8578, 0);
	at[35] = 12.2000;
	points[36] = (-2427.2993, -1078.9448, 309.5512);
	angles[36] = (0, 89.4188, 0);
	at[36] = 12.3000;
	points[37] = (-2475.7480, -1082.9370, 311.6917);
	angles[37] = (0, 96.2648, 0);
	at[37] = 12.5000;
	points[38] = (-2554.2993, -1101.2836, 316.2220);
	angles[38] = (0, 104.9275, 0);
	at[38] = 12.8000;
	points[39] = (-2629.7166, -1126.0906, 321.1315);
	angles[39] = (0, 109.1828, 0);
	at[39] = 13.1000;
	points[40] = (-2728.4961, -1165.5708, 327.8658);
	angles[40] = (0, 112.9620, 0);
	at[40] = 13.5000;
	points[41] = (-2824.9844, -1211.2008, 334.4019);
	angles[41] = (0, 116.5620, 0);
	at[41] = 13.9000;
	points[42] = (-2893.9175, -1249.6693, 338.7138);
	angles[42] = (0, 120.4458, 0);
	at[42] = 14.2000;
	points[43] = (-2938.6338, -1280.2914, 340.9370);
	angles[43] = (0, 125.7332, 0);
	at[43] = 14.4000;
	points[44] = (-2957.3896, -1297.3268, 341.3622);
	angles[44] = (0, 132.0495, 0);
	at[44] = 14.5000;
	points[45] = (-2972.9214, -1318.2598, 340.8445);
	angles[45] = (0, 141.6025, 0);
	at[45] = 14.6000;
	points[46] = (-2997.6694, -1365.5355, 338.3170);
	angles[46] = (0, 153.2807, 0);
	at[46] = 14.8000;
	points[47] = (-3026.2874, -1439.7086, 333.2299);
	angles[47] = (0, 160.3554, 0);
	at[47] = 15.1000;
	points[48] = (-3055.2441, -1542.2362, 325.5134);
	angles[48] = (0, 166.0238, 0);
	at[48] = 15.5000;
	points[49] = (-3070.1221, -1620.1969, 319.5815);
	angles[49] = (0, 170.5866, 0);
	at[49] = 15.8000;
	points[50] = (-3075.6179, -1673.1143, 315.7083);
	angles[50] = (0, 175.0203, 0);
	at[50] = 16;
	points[51] = (-3074.3938, -1726.9568, 312.1622);
	angles[51] = (0, 183.3386, 0);
	at[51] = 16.2000;
	points[52] = (-3069.0276, -1750.9487, 310.9201);
	angles[52] = (0, 192.0392, 0);
	at[52] = 16.3000;
	points[53] = (-3045.5513, -1797.7559, 309.1649);
	angles[53] = (0, 207.8204, 0);
	at[53] = 16.5000;
	points[54] = (-2984.9763, -1887.0157, 306.4598);
	angles[54] = (0, 215.6989, 0);
	at[54] = 16.9000;
	points[55] = (-2869.6890, -2033.1812, 302.6417);
	angles[55] = (0, 219.5419, 0);
	at[55] = 17.6000;
	points[56] = (-2764.4607, -2154.2834, 299.7839);
	angles[56] = (0, 221.9737, 0);
	at[56] = 18.2000;
	points[57] = (-2671.1218, -2249.3425, 297.7650);
	angles[57] = (0, 227.2072, 0);
	at[57] = 18.7000;
	points[58] = (-2652.1104, -2264.2441, 297.5358);
	angles[58] = (0, 231.4034, 0);
	at[58] = 18.8000;
	points[59] = (-2606.2559, -2292.1497, 297.4335);
	angles[59] = (0, 239.6342, 0);
	at[59] = 19;
	points[60] = (-2509.5906, -2336.7717, 297.9201);
	angles[60] = (0, 247.1091, 0);
	at[60] = 19.4000;
	points[61] = (-2384.2283, -2381.4961, 298.8862);
	angles[61] = (0, 252.0594, 0);
	at[61] = 19.9000;
	points[62] = (-2307.0591, -2403.2834, 299.3579);
	angles[62] = (0, 255.2011, 0);
	at[62] = 20.2000;
	points[63] = (-2255.7834, -2414.3071, 299.4252);
	angles[63] = (0, 258.6946, 0);
	at[63] = 20.4000;
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
	points[0] = (-7643.8975, 4172.2046, 1450.6615);
	angles[0] = (0, -94.7682, 0);
	at[0] = 0;
	points[1] = (-7590.6299, 4174.7246, 1440.8859);
	angles[1] = (0, -86.1960, 0);
	at[1] = 0.2000;
	points[2] = (-7537.9922, 4181.2993, 1432.1614);
	angles[2] = (0, -82.6524, 0);
	at[2] = 0.4000;
	points[3] = (-7331.2207, 4218.4648, 1400.6732);
	angles[3] = (0, -78.5642, 0);
	at[3] = 1.2000;
	points[4] = (-7099.0947, 4271.8501, 1368.9802);
	angles[4] = (0, -75.8294, 0);
	at[4] = 2.1000;
	points[5] = (-6947.2837, 4315.8662, 1351.9331);
	angles[5] = (0, -71.8246, 0);
	at[5] = 2.7000;
	points[6] = (-6925.9453, 4323.4648, 1350.1929);
	angles[6] = (0, -70.7067, 0);
	at[6] = 2.8000;
	points[7] = (-6873.8579, 4342.8740, 1346.6733);
	angles[7] = (0, -69.4268, 0);
	at[7] = 3;
	points[8] = (-6726.6143, 4400.8267, 1338.6182);
	angles[8] = (0, -68.1414, 0);
	at[8] = 3.6000;
	points[9] = (-6357.4414, 4556.6929, 1321.9214);
	angles[9] = (0, -66.1794, 0);
	at[9] = 5.1000;
	points[10] = (-6163.0713, 4646.6538, 1313.8584);
	angles[10] = (0, -64.2021, 0);
	at[10] = 5.9000;
	points[11] = (-6116.9688, 4669.6460, 1311.9725);
	angles[11] = (0, -63.2919, 0);
	at[11] = 6.1000;
	points[12] = (-6067.7949, 4695.6299, 1309.9528);
	angles[12] = (0, -61.8478, 0);
	at[12] = 6.3000;
	points[13] = (-5999.4092, 4737.4019, 1307.0787);
	angles[13] = (0, -56.3695, 0);
	at[13] = 6.6000;
	points[14] = (-5981.9688, 4751.7715, 1306.2795);
	angles[14] = (0, -50.9308, 0);
	at[14] = 6.7000;
	points[15] = (-5964.4097, 4771.4565, 1305.4528);
	angles[15] = (0, -43.0322, 0);
	at[15] = 6.8000;
	points[16] = (-5936.4565, 4816.8506, 1304.1143);
	angles[16] = (0, -30.0282, 0);
	at[16] = 7;
	points[17] = (-5915.8662, 4865.9058, 1303.1182);
	angles[17] = (0, -21.7583, 0);
	at[17] = 7.2000;
	points[18] = (-5894.3701, 4942.9136, 1302.0709);
	angles[18] = (0, -13.6236, 0);
	at[18] = 7.5000;
	points[19] = (-5881.7720, 5021.8896, 1301.4646);
	angles[19] = (0, -7.4174, 0);
	at[19] = 7.8000;
	points[20] = (-5877.5591, 5101.4175, 1301.2993);
	angles[20] = (0, -1.2102, 0);
	at[20] = 8.1000;
	points[21] = (-5884.1729, 5181.6143, 1301.7362);
	angles[21] = (0, 7.6145, 0);
	at[21] = 8.4000;
	points[22] = (-5899.3701, 5232.0474, 1302.6534);
	angles[22] = (0, 19.8344, 0);
	at[22] = 8.6000;
	points[23] = (-5911.6143, 5252.0078, 1303.3741);
	angles[23] = (0, 29.6675, 0);
	at[23] = 8.7000;
	points[24] = (-5946.1025, 5293.0312, 1305.3346);
	angles[24] = (0, 40.8136, 0);
	at[24] = 8.9000;
	points[25] = (-6023.5039, 5368.7402, 1309.6812);
	angles[25] = (0, 47.0407, 0);
	at[25] = 9.3000;
	points[26] = (-6123.8188, 5455.1182, 1315.3149);
	angles[26] = (0, 50.3201, 0);
	at[26] = 9.8000;
	points[27] = (-6207.6377, 5521.2207, 1320.0591);
	angles[27] = (0, 52.4516, 0);
	at[27] = 10.2000;
	points[28] = (-6293.8979, 5583.8975, 1324.9922);
	angles[28] = (0, 54.8544, 0);
	at[28] = 10.6000;
	points[29] = (-6382.5195, 5641.3779, 1330.1575);
	angles[29] = (0, 58.3882, 0);
	at[29] = 11;
	points[30] = (-6430, 5667.9922, 1332.9922);
	angles[30] = (0, 61.4182, 0);
	at[30] = 11.2000;
	points[31] = (-6479.0161, 5690.1973, 1336.0079);
	angles[31] = (0, 66.9529, 0);
	at[31] = 11.4000;
	points[32] = (-6501.3389, 5697.2446, 1337.4371);
	angles[32] = (0, 71.9221, 0);
	at[32] = 11.5000;
	points[33] = (-6525.5908, 5702.4409, 1338.9882);
	angles[33] = (0, 76.8604, 0);
	at[33] = 11.6000;
	points[34] = (-6554.4878, 5706.8501, 1340.8229);
	angles[34] = (0, 80.4949, 0);
	at[34] = 11.7000;
	points[35] = (-6578.8584, 5709.6851, 1342.3662);
	angles[35] = (0, 82.8367, 0);
	at[35] = 11.8000;
	points[36] = (-6685.1968, 5716.6538, 1349.0985);
	angles[36] = (0, 87.4050, 0);
	at[36] = 12.2000;
	points[37] = (-6818.9761, 5718.3857, 1357.6653);
	angles[37] = (0, 90.1478, 0);
	at[37] = 12.7000;
	points[38] = (-7031.5752, 5710.8267, 1371.6851);
	angles[38] = (0, 93.3563, 0);
	at[38] = 13.5000;
	points[39] = (-7217.5591, 5693.4253, 1384.7362);
	angles[39] = (0, 96.9587, 0);
	at[39] = 14.2000;
	points[40] = (-7322.0869, 5676.2202, 1392.7914);
	angles[40] = (0, 100.9367, 0);
	at[40] = 14.6000;
	points[41] = (-7374.6455, 5663.0317, 1397.3268);
	angles[41] = (0, 105.0355, 0);
	at[41] = 14.8000;
	points[42] = (-7418.7793, 5645.9058, 1401.8032);
	angles[42] = (0, 112.8196, 0);
	at[42] = 15;
	points[43] = (-7466.8896, 5620.1187, 1407.3937);
	angles[43] = (0, 118.8108, 0);
	at[43] = 15.2000;
	points[44] = (-7534.9609, 5577.5986, 1415.8779);
	angles[44] = (0, 122.7706, 0);
	at[44] = 15.5000;
	points[45] = (-7577.5981, 5548.8188, 1421.4016);
	angles[45] = (0, 124.2589, 0);
	at[45] = 15.7000;
	points[46] = (-7706.8115, 5454.3306, 1438.8307);
	angles[46] = (0, 127.1803, 0);
	at[46] = 16.3000;
	points[47] = (-7871.6143, 5321.2202, 1462.2440);
	angles[47] = (0, 130.1748, 0);
	at[47] = 17.1000;
	points[48] = (-8009.8032, 5196.2598, 1483.0984);
	angles[48] = (0, 133.7333, 0);
	at[48] = 17.8000;
	points[49] = (-8046.0630, 5159.9609, 1488.8898);
	angles[49] = (0, 135.3817, 0);
	at[49] = 18;
	points[50] = (-8083.3467, 5119.4883, 1495.1299);
	angles[50] = (0, 137.9326, 0);
	at[50] = 18.2000;
	points[51] = (-8099.1729, 5100.6299, 1497.9292);
	angles[51] = (0, 139.7602, 0);
	at[51] = 18.3000;
	points[52] = (-8116.4175, 5077.8350, 1501.1812);
	angles[52] = (0, 142.5628, 0);
	at[52] = 18.4000;
	points[53] = (-8129.9609, 5056.3389, 1504.0590);
	angles[53] = (0, 147.4367, 0);
	at[53] = 18.5000;
	points[54] = (-8138.9761, 5035.3545, 1506.6024);
	angles[54] = (0, 155.7678, 0);
	at[54] = 18.6000;
	points[55] = (-8145.1968, 5009.0156, 1509.5787);
	angles[55] = (0, 164.8758, 0);
	at[55] = 18.7000;
	points[56] = (-8149.6851, 4956.7720, 1515.1063);
	angles[56] = (0, 176.1060, 0);
	at[56] = 18.9000;
	points[57] = (-8148.6616, 4903.5435, 1520.4528);
	angles[57] = (0, 181.7456, 0);
	at[57] = 19.1000;
	points[58] = (-8141.2598, 4823.9766, 1528.0709);
	angles[58] = (0, 186.3731, 0);
	at[58] = 19.4000;
	points[59] = (-8114.4097, 4666.6143, 1542.0394);
	angles[59] = (0, 191.3732, 0);
	at[59] = 20;
	points[60] = (-8069.7241, 4485.7480, 1555.8623);
	angles[60] = (0, 195.5814, 0);
	at[60] = 20.7000;
	points[61] = (-8027.3623, 4358.9370, 1561.9843);
	angles[61] = (0, 201.0071, 0);
	at[61] = 21.2000;
	points[62] = (-8016.5752, 4335.4727, 1561.7559);
	angles[62] = (0, 204.6227, 0);
	at[62] = 21.3000;
	points[63] = (-8002.7954, 4315, 1559.4763);
	angles[63] = (0, 212.9858, 0);
	at[63] = 21.4000;
	points[64] = (-7984.5278, 4296.2993, 1554.8977);
	angles[64] = (0, 222.5186, 0);
	at[64] = 21.5000;
	points[65] = (-7942.6772, 4265.7085, 1542.3779);
	angles[65] = (0, 235.1982, 0);
	at[65] = 21.7000;
	points[66] = (-7897.4800, 4241.2202, 1527.7560);
	angles[66] = (0, 242.3875, 0);
	at[66] = 21.9000;
	points[67] = (-7850.7090, 4220.9448, 1512.2756);
	angles[67] = (0, 247.2251, 0);
	at[67] = 22.1000;
	points[68] = (-7778.3071, 4196.5747, 1488.6141);
	angles[68] = (0, 252.8589, 0);
	at[68] = 22.4000;
	points[69] = (-7703.7007, 4179.1338, 1465.8701);
	angles[69] = (0, 258.5240, 0);
	at[69] = 22.7000;
	points[70] = (-7643.8975, 4172.2046, 1450.6615);
	angles[70] = (0, 265.2318, 0);
	at[70] = 22.9333;
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
	points[0] = (-7320.7485, 1154.1654, 1430.3032);
	angles[0] = (0, -44.9171, 0);
	at[0] = 0;
	points[1] = (-7244.8423, 1233.9646, 1432.2836);
	angles[1] = (0, -42.6356, 0);
	at[1] = 0.4167;
	points[2] = (-7187.1655, 1301.5748, 1431.3071);
	angles[2] = (0, -39.2718, 0);
	at[2] = 0.7500;
	points[3] = (-7148.3462, 1355.6299, 1429.4409);
	angles[3] = (0, -34.0640, 0);
	at[3] = 1;
	points[4] = (-7128.2285, 1395.0354, 1427.2599);
	angles[4] = (0, -25.1590, 0);
	at[4] = 1.1667;
	points[5] = (-7118.1890, 1436.5591, 1423.2795);
	angles[5] = (0, -13.4817, 0);
	at[5] = 1.3333;
	points[6] = (-7103.3071, 1546.3190, 1410.1299);
	angles[6] = (0, -6.2795, 0);
	at[6] = 1.7500;
	points[7] = (-7095.5117, 1656.1851, 1396.9883);
	angles[7] = (0, -2.9222, 0);
	at[7] = 2.1667;
	points[8] = (-7094.7637, 1744.7245, 1387.5984);
	angles[8] = (0, 0.8515, 0);
	at[8] = 2.5000;
	points[9] = (-7100.8662, 1811.3308, 1382.6497);
	angles[9] = (0, 7.3729, 0);
	at[9] = 2.7500;
	points[10] = (-7105.5513, 1830.9370, 1382.2126);
	angles[10] = (0, 12.4004, 0);
	at[10] = 2.8333;
	points[11] = (-7121.0630, 1872.0472, 1383.2324);
	angles[11] = (0, 20.8370, 0);
	at[11] = 3;
	points[12] = (-7148.9766, 1932.4883, 1386.3503);
	angles[12] = (0, 25.3922, 0);
	at[12] = 3.2500;
	points[13] = (-7200.5513, 2031.1024, 1393.2205);
	angles[13] = (0, 28.5226, 0);
	at[13] = 3.6667;
	points[14] = (-7256.1416, 2126.7285, 1401.3229);
	angles[14] = (0, 31.0813, 0);
	at[14] = 4.0833;
	points[15] = (-7317.2441, 2219.2834, 1410.7874);
	angles[15] = (0, 35.0359, 0);
	at[15] = 4.5000;
	points[16] = (-7359.2910, 2271.1418, 1417.6968);
	angles[16] = (0, 40.9875, 0);
	at[16] = 4.7500;
	points[17] = (-7391.5352, 2296.7166, 1423.5551);
	angles[17] = (0, 54.1093, 0);
	at[17] = 4.9167;
	points[18] = (-7411.6533, 2306.6851, 1427.7755);
	angles[18] = (0, 61.1708, 0);
	at[18] = 5;
	points[19] = (-7452.3228, 2322.2244, 1436.7953);
	angles[19] = (0, 69.2341, 0);
	at[19] = 5.1667;
	points[20] = (-7535.7876, 2345.5669, 1455.7756);
	angles[20] = (0, 75.7885, 0);
	at[20] = 5.5000;
	points[21] = (-7620.9058, 2363.2087, 1474.7756);
	angles[21] = (0, 79.1966, 0);
	at[21] = 5.8333;
	points[22] = (-7706.7715, 2376.5198, 1492.7756);
	angles[22] = (0, 82.0585, 0);
	at[22] = 6.1667;
	points[23] = (-7771.8506, 2383.3899, 1504.8110);
	angles[23] = (0, 84.6684, 0);
	at[23] = 6.4167;
	points[24] = (-7838.3857, 2385.5867, 1513.5865);
	angles[24] = (0, 89.8044, 0);
	at[24] = 6.6667;
	points[25] = (-7857.7168, 2384.1260, 1514.3466);
	angles[25] = (0, 93.4014, 0);
	at[25] = 6.7500;
	points[26] = (-7945.5903, 2367.9133, 1510.2875);
	angles[26] = (0, 101.9507, 0);
	at[26] = 7.0833;
	points[27] = (-8116.6533, 2322.1182, 1493.7166);
	angles[27] = (0, 106.5526, 0);
	at[27] = 7.7500;
	points[28] = (-8263.2285, 2271.7834, 1476.3977);
	angles[28] = (0, 110.8647, 0);
	at[28] = 8.3333;
	points[29] = (-8324.0947, 2244.9568, 1468.7047);
	angles[29] = (0, 115.0842, 0);
	at[29] = 8.5833;
	points[30] = (-8361.6143, 2222.2166, 1463.8386);
	angles[30] = (0, 123.0490, 0);
	at[30] = 8.7500;
	points[31] = (-8375.3545, 2208.1260, 1461.9685);
	angles[31] = (0, 133.1468, 0);
	at[31] = 8.8333;
	points[32] = (-8387.6377, 2189.1772, 1460.0236);
	angles[32] = (0, 143.5085, 0);
	at[32] = 8.9167;
	points[33] = (-8397.4805, 2169.5669, 1458.2598);
	angles[33] = (0, 150.6761, 0);
	at[33] = 9;
	points[34] = (-8413.6611, 2128.2480, 1454.9331);
	angles[34] = (0, 158.8161, 0);
	at[34] = 9.1667;
	points[35] = (-8442.4805, 2021.1615, 1447.3071);
	angles[35] = (0, 167.0392, 0);
	at[35] = 9.5833;
	points[36] = (-8461.3389, 1912.0552, 1440.0984);
	angles[36] = (0, 171.7381, 0);
	at[36] = 10;
	points[37] = (-8469.1338, 1823.5354, 1434.2875);
	angles[37] = (0, 176.8399, 0);
	at[37] = 10.3333;
	points[38] = (-8467.3623, 1781.5985, 1431.3544);
	angles[38] = (0, 183.8168, 0);
	at[38] = 10.5000;
	points[39] = (-8459.4883, 1737.6576, 1428.2245);
	angles[39] = (0, 190.2946, 0);
	at[39] = 10.6667;
	points[40] = (-8437.9531, 1651.4685, 1422.1023);
	angles[40] = (0, 194.9926, 0);
	at[40] = 11;
	points[41] = (-8405.7480, 1545.1576, 1414.5945);
	angles[41] = (0, 197.6707, 0);
	at[41] = 11.4167;
	points[42] = (-8369.1338, 1440.5315, 1407.2834);
	angles[42] = (0, 200.2086, 0);
	at[42] = 11.8333;
	points[43] = (-8344.0947, 1378.4214, 1403.0197);
	angles[43] = (0, 202.6820, 0);
	at[43] = 12.0833;
	points[44] = (-8324.9219, 1338.3818, 1400.3466);
	angles[44] = (0, 206.2184, 0);
	at[44] = 12.2500;
	points[45] = (-8314.9219, 1321.5433, 1399.2756);
	angles[45] = (0, 209.8662, 0);
	at[45] = 12.3333;
	points[46] = (-8274.2520, 1267.7953, 1396.0237);
	angles[46] = (0, 218.2538, 0);
	at[46] = 12.5833;
	points[47] = (-8185.7876, 1168.7875, 1390.3229);
	angles[47] = (0, 223.0882, 0);
	at[47] = 13.0833;
	points[48] = (-8107.6382, 1089.7598, 1385.9803);
	angles[48] = (0, 225.5153, 0);
	at[48] = 13.5000;
	points[49] = (-8025.1577, 1014.7992, 1382.1653);
	angles[49] = (0, 229.2982, 0);
	at[49] = 13.9167;
	points[50] = (-7989.8428, 987.8819, 1381.0355);
	angles[50] = (0, 233.5685, 0);
	at[50] = 14.0833;
	points[51] = (-7972.6772, 977.9252, 1380.7874);
	angles[51] = (0, 238.6524, 0);
	at[51] = 14.1667;
	points[52] = (-7931.3779, 960.7402, 1380.7953);
	angles[52] = (0, 247.7522, 0);
	at[52] = 14.3333;
	points[53] = (-7867.6772, 941.1693, 1381.4331);
	angles[53] = (0, 253.8778, 0);
	at[53] = 14.5833;
	points[54] = (-7737.0474, 913.8622, 1384.0118);
	angles[54] = (0, 260.5441, 0);
	at[54] = 15.0833;
	points[55] = (-7671.2603, 906.7007, 1386.0315);
	angles[55] = (0, 265.1158, 0);
	at[55] = 15.3333;
	points[56] = (-7626.1812, 907.1220, 1388.0435);
	angles[56] = (0, 271.8934, 0);
	at[56] = 15.5000;
	points[57] = (-7606.4565, 911.3543, 1389.4172);
	angles[57] = (0, 280.6649, 0);
	at[57] = 15.5833;
	points[58] = (-7586.0635, 921.0394, 1391.5709);
	angles[58] = (0, 291.6779, 0);
	at[58] = 15.6667;
	points[59] = (-7567.5591, 932.5433, 1393.9055);
	angles[59] = (0, 298.9828, 0);
	at[59] = 15.7500;
	points[60] = (-7531.6929, 958.8110, 1398.9529);
	angles[60] = (0, 306.2479, 0);
	at[60] = 15.9167;
	points[61] = (-7431.9688, 1045.6378, 1414.4055);
	angles[61] = (0, 312.5833, 0);
	at[61] = 16.4167;
	points[62] = (-7320.7485, 1154.1654, 1430.3032);
	angles[62] = (0, 315.0829, 0);
	at[62] = 17;
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
	points[0] = (370.7535, 4492.1655, 861.3740);
	angles[0] = (0, -99.8569, 0);
	at[0] = 0;
	points[1] = (389.8732, 4490.9058, 860.4016);
	angles[1] = (0, -95.3773, 0);
	at[1] = 0.0833;
	points[2] = (414.2284, 4490.4727, 859.0709);
	angles[2] = (0, -92.2264, 0);
	at[2] = 0.1667;
	points[3] = (456.9882, 4491.1416, 856.6299);
	angles[3] = (0, -89.1311, 0);
	at[3] = 0.3333;
	points[4] = (569.2126, 4496.6929, 850.0039);
	angles[4] = (0, -86.5225, 0);
	at[4] = 0.7500;
	points[5] = (701.3307, 4507.0078, 842.1024);
	angles[5] = (0, -85.0435, 0);
	at[5] = 1.2500;
	points[6] = (900.4252, 4528.3862, 830.3583);
	angles[6] = (0, -82.9821, 0);
	at[6] = 2;
	points[7] = (1054.6378, 4551.9688, 821.8032);
	angles[7] = (0, -79.7953, 0);
	at[7] = 2.5833;
	points[8] = (1119.6732, 4567.1260, 818.7322);
	angles[8] = (0, -75.3721, 0);
	at[8] = 2.8333;
	points[9] = (1157.3622, 4582.4805, 817.6811);
	angles[9] = (0, -66.6882, 0);
	at[9] = 3;
	points[10] = (1214.4567, 4617.9526, 817.4094);
	angles[10] = (0, -56.4964, 0);
	at[10] = 3.2500;
	points[11] = (1266.9921, 4658.4253, 817.9528);
	angles[11] = (0, -51.5033, 0);
	at[11] = 3.5000;
	points[12] = (1365.4094, 4748.3467, 820.2480);
	angles[12] = (0, -45.6437, 0);
	at[12] = 4;
	points[13] = (1440.8781, 4830.0396, 822.8976);
	angles[13] = (0, -41.0830, 0);
	at[13] = 4.4167;
	points[14] = (1494.2520, 4901.1416, 825.3779);
	angles[14] = (0, -34.2641, 0);
	at[14] = 4.7500;
	points[15] = (1512.8662, 4937.9922, 826.6693);
	angles[15] = (0, -25.5561, 0);
	at[15] = 4.9167;
	points[16] = (1521.0474, 4959.8428, 827.4921);
	angles[16] = (0, -21.8298, 0);
	at[16] = 5;
	points[17] = (1540.5474, 5022.9526, 829.9843);
	angles[17] = (0, -16.4116, 0);
	at[17] = 5.2500;
	points[18] = (1561.8937, 5109.4097, 833.5158);
	angles[18] = (0, -12.9663, 0);
	at[18] = 5.5833;
	points[19] = (1578.7797, 5196.6929, 837.1496);
	angles[19] = (0, -10.0578, 0);
	at[19] = 5.9167;
	points[20] = (1590.6693, 5284.9609, 840.8701);
	angles[20] = (0, -6.5043, 0);
	at[20] = 6.2500;
	points[21] = (1594.8229, 5351.6143, 843.7126);
	angles[21] = (0, -2.4556, 0);
	at[21] = 6.5000;
	points[22] = (1591.4370, 5418.1104, 846.5709);
	angles[22] = (0, 5.2965, 0);
	at[22] = 6.7500;
	points[23] = (1579.6458, 5460.5513, 848.4291);
	angles[23] = (0, 18.0747, 0);
	at[23] = 6.9167;
	points[24] = (1569.3031, 5476.4570, 849.1299);
	angles[24] = (0, 29.8033, 0);
	at[24] = 7;
	points[25] = (1537.2755, 5507.8350, 850.4843);
	angles[25] = (0, 45.7510, 0);
	at[25] = 7.1667;
	points[26] = (1501.3188, 5536.0630, 851.6850);
	angles[26] = (0, 51.9257, 0);
	at[26] = 7.3333;
	points[27] = (1391.0708, 5608.8584, 854.7914);
	angles[27] = (0, 58.2111, 0);
	at[27] = 7.8333;
	points[28] = (1255.3308, 5685.7480, 858.2087);
	angles[28] = (0, 61.7415, 0);
	at[28] = 8.4167;
	points[29] = (1155.8818, 5735.7871, 860.6024);
	angles[29] = (0, 64.1220, 0);
	at[29] = 8.8333;
	points[30] = (1054.8229, 5780.4727, 863.0197);
	angles[30] = (0, 67.4454, 0);
	at[30] = 9.2500;
	points[31] = (970.0236, 5809.7637, 865.0984);
	angles[31] = (0, 73.1437, 0);
	at[31] = 9.5833;
	points[32] = (948.0827, 5814.8032, 865.6693);
	angles[32] = (0, 76.3428, 0);
	at[32] = 9.6667;
	points[33] = (929.1890, 5817.3623, 866.1811);
	angles[33] = (0, 81.2416, 0);
	at[33] = 9.7500;
	points[34] = (863.5316, 5814.4883, 867.9882);
	angles[34] = (0, 94.5953, 0);
	at[34] = 10;
	points[35] = (775.7795, 5799.6851, 870.4095);
	angles[35] = (0, 100.9030, 0);
	at[35] = 10.3333;
	points[36] = (667.0984, 5773.8188, 873.4134);
	angles[36] = (0, 104.4161, 0);
	at[36] = 10.7500;
	points[37] = (539.1378, 5736.5747, 876.9685);
	angles[37] = (0, 107.1898, 0);
	at[37] = 11.2500;
	points[38] = (413.5040, 5693.6221, 880.5000);
	angles[38] = (0, 109.9185, 0);
	at[38] = 11.7500;
	points[39] = (309.4355, 5651.3779, 883.4803);
	angles[39] = (0, 113.5518, 0);
	at[39] = 12.1667;
	points[40] = (250.1917, 5620.9053, 885.2441);
	angles[40] = (0, 119.0829, 0);
	at[40] = 12.4167;
	points[41] = (218.0197, 5595.9448, 886.3307);
	angles[41] = (0, 129.0826, 0);
	at[41] = 12.5833;
	points[42] = (159.7150, 5528.5039, 888.7480);
	angles[42] = (0, 141.5839, 0);
	at[42] = 12.9167;
	points[43] = (96.5866, 5436.8501, 891.6536);
	angles[43] = (0, 146.8792, 0);
	at[43] = 13.3333;
	points[44] = (28.4874, 5322.2837, 894.8543);
	angles[44] = (0, 150.5052, 0);
	at[44] = 13.8333;
	points[45] = (-32.7178, 5203.5435, 897.5040);
	angles[45] = (0, 154.2144, 0);
	at[45] = 14.3333;
	points[46] = (-66.8689, 5120.8267, 898.3859);
	angles[46] = (0, 159.8724, 0);
	at[46] = 14.6667;
	points[47] = (-72.0610, 5101.7324, 898.2205);
	angles[47] = (0, 164.0978, 0);
	at[47] = 14.7500;
	points[48] = (-75.2366, 5058.0317, 896.7126);
	angles[48] = (0, 176.7530, 0);
	at[48] = 14.9167;
	points[49] = (-69.5996, 4991.4565, 893.1418);
	angles[49] = (0, 186.2412, 0);
	at[49] = 15.1667;
	points[50] = (-53.4866, 4904.2915, 887.5551);
	angles[50] = (0, 191.8411, 0);
	at[50] = 15.5000;
	points[51] = (-24.5617, 4797.1260, 880.0591);
	angles[51] = (0, 196.7721, 0);
	at[51] = 15.9167;
	points[52] = (6.5019, 4713.9370, 874.0984);
	angles[52] = (0, 202.6848, 0);
	at[52] = 16.2500;
	points[53] = (27.5857, 4676.8110, 871.6339);
	angles[53] = (0, 211.9244, 0);
	at[53] = 16.4167;
	points[54] = (58.6571, 4645.5117, 870.1299);
	angles[54] = (0, 225.3871, 0);
	at[54] = 16.5833;
	points[55] = (93.8279, 4617.9922, 869.0630);
	angles[55] = (0, 232.1443, 0);
	at[55] = 16.7500;
	points[56] = (187.9339, 4559.2915, 866.8701);
	angles[56] = (0, 240.4705, 0);
	at[56] = 17.1667;
	points[57] = (288.7587, 4513.1104, 864.3662);
	angles[57] = (0, 248.3036, 0);
	at[57] = 17.5833;
	points[58] = (330.9850, 4499.7246, 863.0118);
	angles[58] = (0, 253.1130, 0);
	at[58] = 17.7500;
	points[59] = (370.7535, 4492.1655, 861.3740);
	angles[59] = (0, 260.1431, 0);
	at[59] = 17.9000;
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
	points[0] = (-4109.1733, 2123.8110, 380.6122);
	angles[0] = (0, -106.3451, 0);
	at[0] = 0;
	points[1] = (-4044.9211, 2110.6299, 383.1964);
	angles[1] = (0, -100.5592, 0);
	at[1] = 0.2500;
	points[2] = (-3912.5474, 2093.4646, 388.9492);
	angles[2] = (0, -96.1742, 0);
	at[2] = 0.7500;
	points[3] = (-3779.5669, 2082.7402, 394.6614);
	angles[3] = (0, -93.7512, 0);
	at[3] = 1.2500;
	points[4] = (-3646.4370, 2078.1536, 399.7953);
	angles[4] = (0, -90.6744, 0);
	at[4] = 1.7500;
	points[5] = (-3579.8071, 2080.1812, 401.6890);
	angles[5] = (0, -87.1131, 0);
	at[5] = 2;
	points[6] = (-3538.1536, 2086.8347, 401.8701);
	angles[6] = (0, -79.1526, 0);
	at[6] = 2.1667;
	points[7] = (-3496.0393, 2101.7048, 400.5906);
	angles[7] = (0, -70.1750, 0);
	at[7] = 2.3333;
	points[8] = (-3455.5198, 2120.0474, 398.6732);
	angles[8] = (0, -65.4644, 0);
	at[8] = 2.5000;
	points[9] = (-3377.2717, 2162.1418, 393.9528);
	angles[9] = (0, -60.4909, 0);
	at[9] = 2.8333;
	points[10] = (-3301.9883, 2209.4409, 388.5721);
	angles[10] = (0, -56.7121, 0);
	at[10] = 3.1667;
	points[11] = (-3231.0039, 2263, 382.7716);
	angles[11] = (0, -50.6521, 0);
	at[11] = 3.5000;
	points[12] = (-3215.0042, 2278.2756, 381.2847);
	angles[12] = (0, -47.1110, 0);
	at[12] = 3.5833;
	points[13] = (-3202.4607, 2294.4922, 379.9197);
	angles[13] = (0, -38.8868, 0);
	at[13] = 3.6667;
	points[14] = (-3187.1023, 2336.3386, 376.9441);
	angles[14] = (0, -19.3999, 0);
	at[14] = 3.8333;
	points[15] = (-3176.9370, 2401.8386, 372.6429);
	angles[15] = (0, -7.0596, 0);
	at[15] = 4.0833;
	points[16] = (-3175.7598, 2490.3267, 367.1847);
	angles[16] = (0, 1.6799, 0);
	at[16] = 4.4167;
	points[17] = (-3184.0120, 2556.2876, 363.3980);
	angles[17] = (0, 9.1347, 0);
	at[17] = 4.6667;
	points[18] = (-3196.3428, 2598.8899, 361.1815);
	angles[18] = (0, 17.4850, 0);
	at[18] = 4.8333;
	points[19] = (-3204.5630, 2616.7322, 360.3630);
	angles[19] = (0, 22.8896, 0);
	at[19] = 4.9167;
	points[20] = (-3215.5000, 2638.0750, 359.4575);
	angles[20] = (0, 25.8954, 0);
	at[20] = 5;
	points[21] = (-3236.3267, 2676.3384, 357.9102);
	angles[21] = (0, 28.5351, 0);
	at[21] = 5.1667;
	points[22] = (-3304.6853, 2790.7637, 353.5165);
	angles[22] = (0, 31.9797, 0);
	at[22] = 5.6667;
	points[23] = (-3379.4331, 2901.0945, 349.4657);
	angles[23] = (0, 35.5036, 0);
	at[23] = 6.1667;
	points[24] = (-3433.8506, 2971.3425, 346.9788);
	angles[24] = (0, 38.9027, 0);
	at[24] = 6.5000;
	points[25] = (-3493.3779, 3036.3542, 344.7780);
	angles[25] = (0, 44.4512, 0);
	at[25] = 6.8333;
	points[26] = (-3544.5945, 3079.3464, 343.4409);
	angles[26] = (0, 52.3709, 0);
	at[26] = 7.0833;
	points[27] = (-3583.0828, 3100.7483, 342.9000);
	angles[27] = (0, 62.7783, 0);
	at[27] = 7.2500;
	points[28] = (-3600.4727, 3106.7009, 342.8185);
	angles[28] = (0, 68.9637, 0);
	at[28] = 7.3333;
	points[29] = (-3646.7876, 3117.7954, 342.8343);
	angles[29] = (0, 76.5997, 0);
	at[29] = 7.5000;
	points[30] = (-3687.5159, 3125.1025, 342.9666);
	angles[30] = (0, 79.8488, 0);
	at[30] = 7.6667;
	points[31] = (-3734.3623, 3132.0710, 343.1862);
	angles[31] = (0, 81.6270, 0);
	at[31] = 7.8333;
	points[32] = (-3776.2676, 3137.4412, 343.4229);
	angles[32] = (0, 82.7546, 0);
	at[32] = 8;
	points[33] = (-3976.8506, 3156.5356, 344.8374);
	angles[33] = (0, 85.5171, 0);
	at[33] = 8.7500;
	points[34] = (-4131.7715, 3166.3306, 346.1150);
	angles[34] = (0, 86.8929, 0);
	at[34] = 9.3333;
	points[35] = (-4375.1968, 3174.1616, 348.3217);
	angles[35] = (0, 89.2438, 0);
	at[35] = 10.2500;
	points[36] = (-4421.6929, 3174.3306, 348.7677);
	angles[36] = (0, 89.8771, 0);
	at[36] = 10.4167;
	points[37] = (-4486.1025, 3173.4607, 349.4008);
	angles[37] = (0, 91.1013, 0);
	at[37] = 10.6667;
	points[38] = (-4510.5908, 3172.6772, 349.6465);
	angles[38] = (0, 91.6854, 0);
	at[38] = 10.7500;
	points[39] = (-4575.3149, 3168.5984, 350.3162);
	angles[39] = (0, 94.4409, 0);
	at[39] = 11;
	points[40] = (-4600.3936, 3165.5984, 350.5878);
	angles[40] = (0, 96.4519, 0);
	at[40] = 11.0833;
	points[41] = (-4638.7402, 3155.6536, 351.0504);
	angles[41] = (0, 106.9663, 0);
	at[41] = 11.2500;
	points[42] = (-4658.2285, 3144.4685, 351.3630);
	angles[42] = (0, 116.9254, 0);
	at[42] = 11.3333;
	points[43] = (-4690.7085, 3114.5669, 352.0402);
	angles[43] = (0, 133.4653, 0);
	at[43] = 11.5000;
	points[44] = (-4717.1260, 3079.2009, 352.7410);
	angles[44] = (0, 143.7353, 0);
	at[44] = 11.6667;
	points[45] = (-4739.4092, 3040.8506, 353.4460);
	angles[45] = (0, 150.1863, 0);
	at[45] = 11.8333;
	points[46] = (-4767.4805, 2980.2837, 354.4929);
	angles[46] = (0, 156.2914, 0);
	at[46] = 12.0833;
	points[47] = (-4790.8267, 2917.8506, 355.5126);
	angles[47] = (0, 160.3212, 0);
	at[47] = 12.3333;
	points[48] = (-4827.5986, 2789.0708, 357.4366);
	angles[48] = (0, 166.0161, 0);
	at[48] = 12.8333;
	points[49] = (-4840.1577, 2725.8779, 358.1465);
	angles[49] = (0, 170.4835, 0);
	at[49] = 13.0833;
	points[50] = (-4842.4409, 2680.9133, 358.1398);
	angles[50] = (0, 177.6489, 0);
	at[50] = 13.2500;
	points[51] = (-4840.6694, 2636.8464, 357.9429);
	angles[51] = (0, 182.6116, 0);
	at[51] = 13.4167;
	points[52] = (-4827.9136, 2548.9724, 357.4681);
	angles[52] = (0, 190.6611, 0);
	at[52] = 13.7500;
	points[53] = (-4816.5352, 2506.0354, 357.3300);
	angles[53] = (0, 195.4671, 0);
	at[53] = 13.9167;
	points[54] = (-4800.5903, 2464.7441, 357.3677);
	angles[54] = (0, 202.0565, 0);
	at[54] = 14.0833;
	points[55] = (-4777.7954, 2426.7717, 357.7382);
	angles[55] = (0, 212.5955, 0);
	at[55] = 14.2500;
	points[56] = (-4762.7954, 2410.5786, 358.1366);
	angles[56] = (0, 220.8316, 0);
	at[56] = 14.3333;
	points[57] = (-4747.3623, 2398.8545, 358.6240);
	angles[57] = (0, 229.6880, 0);
	at[57] = 14.4167;
	points[58] = (-4726.6143, 2385.8623, 359.3036);
	angles[58] = (0, 235.6525, 0);
	at[58] = 14.5000;
	points[59] = (-4649.4883, 2344.9487, 361.8886);
	angles[59] = (0, 243.0803, 0);
	at[59] = 14.8333;
	points[60] = (-4527.9531, 2288.1182, 366.0299);
	angles[60] = (0, 245.6834, 0);
	at[60] = 15.3333;
	points[61] = (-4343.9370, 2209.7166, 372.3693);
	angles[61] = (0, 247.7030, 0);
	at[61] = 16.0833;
	points[62] = (-4220.6694, 2161.4607, 376.6602);
	angles[62] = (0, 249.2580, 0);
	at[62] = 16.5833;
	points[63] = (-4135.0786, 2131.4175, 379.6811);
	angles[63] = (0, 251.5855, 0);
	at[63] = 16.9167;
	points[64] = (-4109.1733, 2123.8110, 380.6122);
	angles[64] = (0, 253.6549, 0);
	at[64] = 17.0333;
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
