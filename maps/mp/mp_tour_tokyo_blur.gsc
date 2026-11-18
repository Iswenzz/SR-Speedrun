main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_tour_tokyo_blur", 0);

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
	ambientPlay("iz_0_ttb", 2);
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
	level.iz_route[level.iz_route.size] = (1327, -474, 2429);
	level.iz_route[level.iz_route.size] = (3065, -466, 2429);
	level.iz_route[level.iz_route.size] = (4463, -527, 2440);
	level.iz_route[level.iz_route.size] = (5086, -880, 2462);
	level.iz_route[level.iz_route.size] = (5533, -1514, 2454);
	level.iz_route[level.iz_route.size] = (5640, -2139, 2436);
	level.iz_route[level.iz_route.size] = (5627, -3263, 2265);
	level.iz_route[level.iz_route.size] = (5648, -4470, 2044);
	level.iz_route[level.iz_route.size] = (5611, -5432, 2008);
	level.iz_route[level.iz_route.size] = (5492, -6093, 2008);
	level.iz_route[level.iz_route.size] = (5097, -6623, 2008);
	level.iz_route[level.iz_route.size] = (4222, -7510, 2008);
	level.iz_route[level.iz_route.size] = (2983, -8756, 2008);
	level.iz_route[level.iz_route.size] = (2765, -9205, 2008);
	level.iz_route[level.iz_route.size] = (2749, -9728, 2011);
	level.iz_route[level.iz_route.size] = (2582, -10398, 2034);
	level.iz_route[level.iz_route.size] = (2073, -10929, 2053);
	level.iz_route[level.iz_route.size] = (1413, -11084, 2047);
	level.iz_route[level.iz_route.size] = (629, -11084, 2047);
	level.iz_route[level.iz_route.size] = (-318, -11089, 2047);
	level.iz_route[level.iz_route.size] = (-1060, -11018, 2065);
	level.iz_route[level.iz_route.size] = (-1397, -10644, 2094);
	level.iz_route[level.iz_route.size] = (-1527, -10077, 2091);
	level.iz_route[level.iz_route.size] = (-1503, -9206, 2038);
	level.iz_route[level.iz_route.size] = (-1504, -8310, 1989);
	level.iz_route[level.iz_route.size] = (-1496, -7285, 1959);
	level.iz_route[level.iz_route.size] = (-1567, -6767, 1959);
	level.iz_route[level.iz_route.size] = (-2566, -6554, 1959);
	level.iz_route[level.iz_route.size] = (-3487, -6542, 1959);
	level.iz_route[level.iz_route.size] = (-4073, -6370, 1975);
	level.iz_route[level.iz_route.size] = (-4362, -6000, 1970);
	level.iz_route[level.iz_route.size] = (-4436, -5135, 1959);
	level.iz_route[level.iz_route.size] = (-4450, -4378, 1959);
	level.iz_route[level.iz_route.size] = (-4440, -3335, 2004);
	level.iz_route[level.iz_route.size] = (-4436, -2375, 2122);
	level.iz_route[level.iz_route.size] = (-4397, -1700, 2206);
	level.iz_route[level.iz_route.size] = (-4120, -1142, 2279);
	level.iz_route[level.iz_route.size] = (-3616, -671, 2352);
	level.iz_route[level.iz_route.size] = (-2918, -480, 2402);
	level.iz_route[level.iz_route.size] = (-2224, -473, 2428);
	level.iz_route[level.iz_route.size] = (-1015, -474, 2429);
	level.iz_route[level.iz_route.size] = (35, -480, 2429);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (5907.3232, 18416.7715, 4231.0630);
	angles[0] = (0, -166.0793, 0);
	at[0] = 0;
	points[1] = (6315.8267, 17605.5117, 4384.9604);
	angles[1] = (0, -156.0416, 0);
	at[1] = 0.5000;
	points[2] = (6724.3701, 16794.2520, 4538.8979);
	angles[2] = (0, -153.8665, 0);
	at[2] = 1;
	points[3] = (12443.7012, 5436.7324, 6693.7012);
	angles[3] = (0, -153.2714, 0);
	at[3] = 8;
	points[4] = (12479.2520, 4536.3384, 6763.1494);
	angles[4] = (0, -174.3704, 0);
	at[4] = 8.5000;
	points[5] = (12437.6768, 3617.4766, 6815.1182);
	angles[5] = (0, -180.8277, 0);
	at[5] = 9;
	points[6] = (12396.0625, 2698.6260, 6867.0864);
	angles[6] = (0, -182.2132, 0);
	at[6] = 9.5000;
	points[7] = (11855.3545, -9246.4570, 7542.8745);
	angles[7] = (0, -182.5917, 0);
	at[7] = 16;
	points[8] = (11631.4570, -10128.9766, 7508.4253);
	angles[8] = (0, -193.6005, 0);
	at[8] = 16.5000;
	points[9] = (11326.9678, -10995.4326, 7435.7876);
	angles[9] = (0, -198.1215, 0);
	at[9] = 17;
	points[10] = (10718.0322, -12728.3457, 7290.5508);
	angles[10] = (0, -199.3046, 0);
	at[10] = 18;
	points[11] = (-2069.7954, -49118.5039, 4240.3149);
	angles[11] = (0, -199.3618, 0);
	at[11] = 39;
	points[12] = (-2496.9646, -49923.2305, 4125.6299);
	angles[12] = (0, -207.1946, 0);
	at[12] = 39.5000;
	points[13] = (-3884.6733, -52282.6758, 3745.1653);
	angles[13] = (0, -210.4272, 0);
	at[13] = 41;
	points[14] = (-16836.4961, -74305.9062, 194.2075);
	angles[14] = (0, -210.4597, 0);
	at[14] = 55;
	points[15] = (-17446.5352, -74605.5156, 154.4791);
	angles[15] = (0, -245.7413, 0);
	at[15] = 55.5000;
	points[16] = (-18269.7637, -74200.7891, 240.5921);
	angles[16] = (0, -284.6208, 0);
	at[16] = 56;
	points[17] = (-19092.9531, -73796.4609, 326.7051);
	angles[17] = (0, -293.6793, 0);
	at[17] = 56.5000;
	points[18] = (-29794.4492, -68537.3984, 1446.1693);
	angles[18] = (0, -296.1708, 0);
	at[18] = 63;
	points[19] = (-30428.7402, -68141.7344, 1857.4685);
	angles[19] = (0, -302.2444, 0);
	at[19] = 63.5000;
	points[20] = (-30901.8906, -67753.9375, 2546.2009);
	angles[20] = (0, -307.4515, 0);
	at[20] = 64;
	points[21] = (-31848.1875, -66977.9531, 3923.6733);
	angles[21] = (0, -309.2546, 0);
	at[21] = 65;
	points[22] = (-45096.4570, -56115.7461, 23208.2285);
	angles[22] = (0, -309.3484, 0);
	at[22] = 79;
	points[23] = (-45560.2344, -55474.4102, 23271.9668);
	angles[23] = (0, -323.0353, 0);
	at[23] = 79.5000;
	points[24] = (-46019.6875, -54711.4180, 23036.0234);
	angles[24] = (0, -327.6216, 0);
	at[24] = 80;
	points[25] = (-46938.1875, -53185.8281, 22564.0566);
	angles[25] = (0, -328.8840, 0);
	at[25] = 81;
	points[26] = (-59800.7852, -31824.2910, 15956.6924);
	angles[26] = (0, -328.9463, 0);
	at[26] = 95;
	points[27] = (-60180.3125, -31062.6387, 15642.1260);
	angles[27] = (0, -334.5120, 0);
	at[27] = 95.5000;
	points[28] = (-60397.6367, -30303.6211, 15167.3623);
	angles[28] = (0, -341.8352, 0);
	at[28] = 96;
	points[29] = (-60832.2852, -28785.5898, 14217.8740);
	angles[29] = (0, -343.9215, 0);
	at[29] = 97;
	points[30] = (-66482.2891, -9050.7480, 1874.1614);
	angles[30] = (0, -344.0244, 0);
	at[30] = 110;
	points[31] = (-66510.2344, -8282.7168, 1442.6812);
	angles[31] = (0, -361.0913, 0);
	at[31] = 110.5000;
	points[32] = (-66177.9531, -7497.5981, 1093.6417);
	angles[32] = (0, -378.4097, 0);
	at[32] = 111;
	points[33] = (-65512.9922, -5927.3228, 395.5630);
	angles[33] = (0, -382.7365, 0);
	at[33] = 112;
	points[34] = (-56207.4844, 16056.6533, -9377.6377);
	angles[34] = (0, -382.9429, 0);
	at[34] = 126;
	points[35] = (-55792.1250, 16779.4492, -9718.6621);
	angles[35] = (0, -392.2292, 0);
	at[35] = 126.5000;
	points[36] = (-55089.3711, 17286.4961, -10032.0078);
	angles[36] = (0, -409.4848, 0);
	at[36] = 127;
	points[37] = (-53684.6445, 18300.6309, -10658.6621);
	angles[37] = (0, -413.9617, 0);
	at[37] = 128;
	points[38] = (-23479.2930, 40103.9375, -24131.6133);
	angles[38] = (0, -414.1769, 0);
	at[38] = 149.5000;
	points[39] = (-22821.6934, 40507.4805, -24046.2207);
	angles[39] = (0, -418.9344, 0);
	at[39] = 150;
	points[40] = (-22228.3867, 40762.2031, -23389.1738);
	angles[40] = (0, -424.4449, 0);
	at[40] = 150.5000;
	points[41] = (-21041.8105, 41272.4375, -22075.1562);
	angles[41] = (0, -426.6170, 0);
	at[41] = 151.5000;
	points[42] = (-1463.5237, 49689.7656, -393.8622);
	angles[42] = (0, -426.7362, 0);
	at[42] = 168;
	points[43] = (-1025.2638, 49494.0977, 52.1579);
	angles[43] = (0, -474.8167, 0);
	at[43] = 168.5000;
	points[44] = (-826.6732, 48602.7578, 171.9882);
	angles[44] = (0, -517.7737, 0);
	at[44] = 169;
	points[45] = (-628.0827, 47711.0234, 291.8185);
	angles[45] = (0, -525.4143, 0);
	at[45] = 169.5000;
	points[46] = (-429.4921, 46819.6836, 411.6496);
	angles[46] = (0, -527.0093, 0);
	at[46] = 170;
	points[47] = (5726.8506, 19180.3945, 4126.3779);
	angles[47] = (0, -527.4429, 0);
	at[47] = 185.5000;
	points[48] = (5907.3232, 18416.7715, 4231.0630);
	angles[48] = (0, -526.0793, 0);
	at[48] = 185.9330;
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
	points[0] = (-60118.8984, -31277.9141, 15776.7725);
	angles[0] = (0, 29.7493, 0);
	at[0] = 0;
	points[1] = (-60336.2227, -30518.8984, 15302.0078);
	angles[1] = (0, 19.2420, 0);
	at[1] = 0.5000;
	points[2] = (-60770.8633, -29000.8672, 14352.5195);
	angles[2] = (0, 16.1305, 0);
	at[2] = 1.5000;
	points[3] = (-66420.4688, -9266.0234, 2008.8071);
	angles[3] = (0, 15.9756, 0);
	at[3] = 14.5000;
	points[4] = (-66604.3281, -8505.3936, 1541.6732);
	angles[4] = (0, 12.1478, 0);
	at[4] = 15;
	points[5] = (-66272.0469, -7720.2759, 1192.6339);
	angles[5] = (0, -15.7029, 0);
	at[5] = 15.5000;
	points[6] = (-65939.7656, -6935.1177, 843.5906);
	angles[6] = (0, -21.4110, 0);
	at[6] = 16;
	points[7] = (-65607.4844, -6150, 494.5512);
	angles[7] = (0, -22.6152, 0);
	at[7] = 16.5000;
	points[8] = (-55969.2930, 16619.1348, -9627.6777);
	angles[8] = (0, -22.9429, 0);
	at[8] = 31;
	points[9] = (-55288.5820, 17142.7168, -9943.1494);
	angles[9] = (0, -47.0921, 0);
	at[9] = 31.5000;
	points[10] = (-54586.2227, 17649.7637, -10256.4570);
	angles[10] = (0, -52.6631, 0);
	at[10] = 32;
	points[11] = (-53883.8594, 18156.8125, -10569.8027);
	angles[11] = (0, -53.8525, 0);
	at[11] = 32.5000;
	points[12] = (-23678.5059, 39959.8438, -24042.7559);
	angles[12] = (0, -54.1770, 0);
	at[12] = 54;
	points[13] = (-22989.9609, 40435.0430, -24232.5605);
	angles[13] = (0, -55.9248, 0);
	at[13] = 54.5000;
	points[14] = (-22396.6543, 40690.1602, -23575.5117);
	angles[14] = (0, -63.3283, 0);
	at[14] = 55;
	points[15] = (-21210.0801, 41200, -22261.4961);
	angles[15] = (0, -66.5478, 0);
	at[15] = 56;
	points[16] = (-1631.7795, 49617.3242, -580.1929);
	angles[16] = (0, -66.7362, 0);
	at[16] = 72.5000;
	points[17] = (-1081.5867, 49747.2422, 18.1732);
	angles[17] = (0, -83.9792, 0);
	at[17] = 73;
	points[18] = (-882.9961, 48855.5156, 138.0032);
	angles[18] = (0, -152.6031, 0);
	at[18] = 73.5000;
	points[19] = (-684.4055, 47963.7812, 257.8335);
	angles[19] = (0, -164.3767, 0);
	at[19] = 74;
	points[20] = (-485.8110, 47072.4414, 377.6642);
	angles[20] = (0, -166.7890, 0);
	at[20] = 74.5000;
	points[21] = (5869.1343, 18541.6543, 4212.2441);
	angles[21] = (0, -167.4429, 0);
	at[21] = 90.5000;
	points[22] = (6256.9292, 17722.4805, 4362.7954);
	angles[22] = (0, -156.6713, 0);
	at[22] = 91;
	points[23] = (7073.9766, 16099.9609, 4670.6299);
	angles[23] = (0, -153.4282, 0);
	at[23] = 92;
	points[24] = (12384.8037, 5553.7007, 6671.4961);
	angles[24] = (0, -153.2714, 0);
	at[24] = 98.5000;
	points[25] = (12485.2363, 4668.8188, 6755.6299);
	angles[25] = (0, -172.5003, 0);
	at[25] = 99;
	points[26] = (12443.6611, 3749.9529, 6807.6377);
	angles[26] = (0, -180.4258, 0);
	at[26] = 99.5000;
	points[27] = (12402.0869, 2831.0984, 6859.6060);
	angles[27] = (0, -182.1270, 0);
	at[27] = 100;
	points[28] = (11861.3779, -9113.9766, 7535.3940);
	angles[28] = (0, -182.5918, 0);
	at[28] = 106.5000;
	points[29] = (11675.3535, -10004.0547, 7518.8975);
	angles[29] = (0, -192.2951, 0);
	at[29] = 107;
	points[30] = (11370.8662, -10870.5117, 7446.2598);
	angles[30] = (0, -197.8391, 0);
	at[30] = 107.5000;
	points[31] = (10761.9287, -12603.4258, 7301.0234);
	angles[31] = (0, -199.2917, 0);
	at[31] = 108.5000;
	points[32] = (-2025.8977, -48993.6992, 4250.7876);
	angles[32] = (0, -199.3618, 0);
	at[32] = 129.5000;
	points[33] = (-2430.2717, -49809.8438, 4143.8975);
	angles[33] = (0, -206.2434, 0);
	at[33] = 130;
	points[34] = (-3817.9844, -52169.2891, 3763.4487);
	angles[34] = (0, -210.4179, 0);
	at[34] = 131.5000;
	points[35] = (-16769.8027, -74192.5234, 212.4913);
	angles[35] = (0, -210.4597, 0);
	at[35] = 145.5000;
	points[36] = (-17327.8730, -74663.7812, 142.0642);
	angles[36] = (0, -233.3957, 0);
	at[36] = 146;
	points[37] = (-18151.0625, -74259.0547, 228.1772);
	angles[37] = (0, -281.2853, 0);
	at[37] = 146.5000;
	points[38] = (-18974.2520, -73854.7266, 314.2902);
	angles[38] = (0, -292.9518, 0);
	at[38] = 147;
	points[39] = (-20620.6289, -73045.6719, 486.5157);
	angles[39] = (0, -296.0223, 0);
	at[39] = 148;
	points[40] = (-29675.7480, -68595.6719, 1433.7521);
	angles[40] = (0, -296.1707, 0);
	at[40] = 153.5000;
	points[41] = (-30360.5117, -68197.6406, 1758.1732);
	angles[41] = (0, -300.7451, 0);
	at[41] = 154;
	points[42] = (-30833.6621, -67809.8438, 2446.9055);
	angles[42] = (0, -306.9462, 0);
	at[42] = 154.5000;
	points[43] = (-31779.9609, -67033.8594, 3824.3740);
	angles[43] = (0, -309.2274, 0);
	at[43] = 155.5000;
	points[44] = (-45027.9531, -56171.6562, 23108.9355);
	angles[44] = (0, -309.3484, 0);
	at[44] = 169.5000;
	points[45] = (-45494.0977, -55584.2500, 23306.0254);
	angles[45] = (0, -321.3260, 0);
	at[45] = 170;
	points[46] = (-45953.1484, -54821.2578, 23070.0391);
	angles[46] = (0, -327.2438, 0);
	at[46] = 170.5000;
	points[47] = (-46872.0508, -53295.6680, 22598.0723);
	angles[47] = (0, -328.8658, 0);
	at[47] = 171.5000;
	points[48] = (-59734.6484, -31934.2520, 15990.7090);
	angles[48] = (0, -328.9463, 0);
	at[48] = 185.5000;
	points[49] = (-60118.8984, -31277.9141, 15776.7725);
	angles[49] = (0, -330.2508, 0);
	at[49] = 185.9330;
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
	points[0] = (4438.7007, -7007.3228, 2008.3071);
	angles[0] = (0, -45, 0);
	at[0] = 0;
	points[1] = (4438.7007, -7007.3228, 2008.3071);
	angles[1] = (0, -45, 0);
	at[1] = 0.5000;
	points[2] = (4438.7007, -7007.3228, 2014.2126);
	angles[2] = (0, -45, 0);
	at[2] = 0.5500;
	points[3] = (4438.7007, -7007.3228, 2333.1104);
	angles[3] = (0, -45, 0);
	at[3] = 2.3500;
	points[4] = (4438.7007, -7007.3228, 2339.0159);
	angles[4] = (0, -45, 0);
	at[4] = 2.4000;
	points[5] = (4438.7007, -7007.3228, 2339.0159);
	angles[5] = (0, -45, 0);
	at[5] = 3.4500;
	points[6] = (4438.7007, -7007.3228, 2346.6851);
	angles[6] = (0, -45, 0);
	at[6] = 3.5000;
	points[7] = (4438.7007, -7007.3228, 2343.4448);
	angles[7] = (0, -45, 0);
	at[7] = 3.5500;
	points[8] = (4438.7007, -7007.3228, 2331.3425);
	angles[8] = (0, -45, 0);
	at[8] = 3.6000;
	points[9] = (4438.7007, -7007.3228, 2334.5867);
	angles[9] = (0, -45, 0);
	at[9] = 3.6500;
	points[10] = (4438.7007, -7007.3228, 2346.6851);
	angles[10] = (0, -45, 0);
	at[10] = 3.7000;
	points[11] = (4438.7007, -7007.3228, 2343.4448);
	angles[11] = (0, -45, 0);
	at[11] = 3.7500;
	points[12] = (4438.7007, -7007.3228, 2331.3425);
	angles[12] = (0, -45, 0);
	at[12] = 3.8000;
	points[13] = (4438.7007, -7007.3228, 2334.5867);
	angles[13] = (0, -45, 0);
	at[13] = 3.8500;
	points[14] = (4438.7007, -7007.3228, 2346.6851);
	angles[14] = (0, -45, 0);
	at[14] = 3.9000;
	points[15] = (4438.7007, -7007.3228, 2343.4448);
	angles[15] = (0, -45, 0);
	at[15] = 3.9500;
	points[16] = (4438.7007, -7007.3228, 2349.3503);
	angles[16] = (0, -45, 0);
	at[16] = 4;
	points[17] = (4438.7007, -7007.3228, 2482.2244);
	angles[17] = (0, -45, 0);
	at[17] = 4.1500;
	points[18] = (4438.7007, -7007.3228, 2452.1064);
	angles[18] = (0, -45, 0);
	at[18] = 4.2000;
	points[19] = (4438.7007, -7007.3228, 2376.8110);
	angles[19] = (0, -45, 0);
	at[19] = 4.2500;
	points[20] = (4438.7007, -7007.3228, 2256.3386);
	angles[20] = (0, -45, 0);
	at[20] = 4.3000;
	points[21] = (4438.7007, -7007.3228, 2090.6890);
	angles[21] = (0, -45, 0);
	at[21] = 4.3500;
	points[22] = (4438.7007, -7007.3228, 2008.3071);
	angles[22] = (0, -45, 0);
	at[22] = 4.4000;
	points[23] = (4438.7007, -7007.3228, 2008.3071);
	angles[23] = (0, -45, 0);
	at[23] = 4.8667;
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
	points[0] = (3795.5828, -8302.2842, 2339.0159);
	angles[0] = (0, -45, 0);
	at[0] = 0;
	points[1] = (3795.5828, -8302.2842, 2339.0159);
	angles[1] = (0, -45, 0);
	at[1] = 0.5500;
	points[2] = (3795.5828, -8302.2842, 2347.8740);
	angles[2] = (0, -45, 0);
	at[2] = 0.6000;
	points[3] = (3795.5828, -8302.2842, 2330.1575);
	angles[3] = (0, -45, 0);
	at[3] = 0.7000;
	points[4] = (3795.5828, -8302.2842, 2347.8740);
	angles[4] = (0, -45, 0);
	at[4] = 0.8000;
	points[5] = (3795.5828, -8302.2842, 2330.1575);
	angles[5] = (0, -45, 0);
	at[5] = 0.9000;
	points[6] = (3795.5828, -8302.2842, 2347.8740);
	angles[6] = (0, -45, 0);
	at[6] = 1;
	points[7] = (3795.5828, -8302.2842, 2339.0159);
	angles[7] = (0, -45, 0);
	at[7] = 1.0500;
	points[8] = (3795.5828, -8302.2842, 2364.1143);
	angles[8] = (0, -45, 0);
	at[8] = 1.1000;
	points[9] = (3795.5828, -8302.2842, 2452.6968);
	angles[9] = (0, -45, 0);
	at[9] = 1.2000;
	points[10] = (3795.5828, -8302.2842, 2477.2048);
	angles[10] = (0, -45, 0);
	at[10] = 1.2500;
	points[11] = (3795.5828, -8302.2842, 2432.0276);
	angles[11] = (0, -45, 0);
	at[11] = 1.3000;
	points[12] = (3795.5828, -8302.2842, 2341.6733);
	angles[12] = (0, -45, 0);
	at[12] = 1.3500;
	points[13] = (3795.5828, -8302.2842, 2206.1418);
	angles[13] = (0, -45, 0);
	at[13] = 1.4000;
	points[14] = (3795.5828, -8302.2842, 2025.4331);
	angles[14] = (0, -45, 0);
	at[14] = 1.4500;
	points[15] = (3795.5828, -8302.2842, 2008.3071);
	angles[15] = (0, -45, 0);
	at[15] = 1.5000;
	points[16] = (3795.5828, -8302.2842, 2008.3071);
	angles[16] = (0, -45, 0);
	at[16] = 2.4500;
	points[17] = (3795.5828, -8302.2842, 2014.2126);
	angles[17] = (0, -45, 0);
	at[17] = 2.5000;
	points[18] = (3795.5828, -8302.2842, 2333.1104);
	angles[18] = (0, -45, 0);
	at[18] = 4.3000;
	points[19] = (3795.5828, -8302.2842, 2339.0159);
	angles[19] = (0, -45, 0);
	at[19] = 4.3500;
	points[20] = (3795.5828, -8302.2842, 2339.0159);
	angles[20] = (0, -45, 0);
	at[20] = 4.8833;
	mover = getEnt("iz_obj_3", "targetname");
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
