main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_3ds_sherbet_rink", 0);

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
	ambientPlay("iz_0_3dssr", 2);
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
	level.iz_route[level.iz_route.size] = (255, -176, 409);
	level.iz_route[level.iz_route.size] = (536, 834, 409);
	level.iz_route[level.iz_route.size] = (742, 1891, 409);
	level.iz_route[level.iz_route.size] = (323, 2486, 409);
	level.iz_route[level.iz_route.size] = (-430, 3352, 482);
	level.iz_route[level.iz_route.size] = (-1384, 3324, 478);
	level.iz_route[level.iz_route.size] = (-3235, 3024, 476);
	level.iz_route[level.iz_route.size] = (-4384, 2290, 499);
	level.iz_route[level.iz_route.size] = (-4993, 992, 490);
	level.iz_route[level.iz_route.size] = (-4977, -431, 476);
	level.iz_route[level.iz_route.size] = (-4557, -1245, 455);
	level.iz_route[level.iz_route.size] = (-3990, -1526, 415);
	level.iz_route[level.iz_route.size] = (-3195, -1699, 409);
	level.iz_route[level.iz_route.size] = (-1977, -2176, 409);
	level.iz_route[level.iz_route.size] = (-1227, -2944, 425);
	level.iz_route[level.iz_route.size] = (-282, -3380, 485);
	level.iz_route[level.iz_route.size] = (1150, -3420, 491);
	level.iz_route[level.iz_route.size] = (2582, -3417, 491);
	level.iz_route[level.iz_route.size] = (3871, -2771, 497);
	level.iz_route[level.iz_route.size] = (4697, -1927, 506);
	level.iz_route[level.iz_route.size] = (5142, -350, 493);
	level.iz_route[level.iz_route.size] = (4752, 1242, 475);
	level.iz_route[level.iz_route.size] = (3496, 2774, 468);
	level.iz_route[level.iz_route.size] = (2069, 3425, 492);
	level.iz_route[level.iz_route.size] = (569, 3480, 499);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (398.9922, 503.6811, 408.6496);
	angles[0] = (0, 156.9088, 0);
	at[0] = 0;
	points[1] = (367.9390, 414.8071, 408.6496);
	angles[1] = (0, 162.5667, 0);
	at[1] = 0.2667;
	points[2] = (304.8898, 186.7319, 408.6496);
	angles[2] = (0, 164.8730, 0);
	at[2] = 0.9333;
	points[3] = (270.1339, 49.1350, 408.6496);
	angles[3] = (0, 166.5858, 0);
	at[3] = 1.3333;
	points[4] = (260.2599, 1.9348, 408.6496);
	angles[4] = (0, 168.3795, 0);
	at[4] = 1.4667;
	points[5] = (254.4169, -43.6701, 408.6496);
	angles[5] = (0, 172.7224, 0);
	at[5] = 1.6000;
	points[6] = (245.0752, -232.5421, 408.6496);
	angles[6] = (0, 178.4729, 0);
	at[6] = 2.1333;
	points[7] = (246.2307, -374.9472, 408.6496);
	angles[7] = (0, 181.8861, 0);
	at[7] = 2.5333;
	points[8] = (250.1244, -420.9764, 408.6496);
	angles[8] = (0, 185.2787, 0);
	at[8] = 2.6667;
	points[9] = (258.5323, -466.6339, 408.6496);
	angles[9] = (0, 190.1523, 0);
	at[9] = 2.8000;
	points[10] = (292.3705, -605.2362, 408.6496);
	angles[10] = (0, 194.5217, 0);
	at[10] = 3.2000;
	points[11] = (344.4212, -787.7717, 408.6496);
	angles[11] = (0, 196.7949, 0);
	at[11] = 3.7333;
	points[12] = (374.3528, -875.9725, 408.6496);
	angles[12] = (0, 200.2628, 0);
	at[12] = 4;
	points[13] = (439.5905, -1002.3897, 408.6496);
	angles[13] = (0, 208.9722, 0);
	at[13] = 4.4000;
	points[14] = (607.3779, -1287.2479, 408.6496);
	angles[14] = (0, 210.5733, 0);
	at[14] = 5.3333;
	points[15] = (705.2677, -1449.1534, 408.6496);
	angles[15] = (0, 211.6911, 0);
	at[15] = 5.8667;
	points[16] = (757.2363, -1529.0552, 408.6496);
	angles[16] = (0, 213.9246, 0);
	at[16] = 6.1333;
	points[17] = (784.7914, -1565.4135, 408.6496);
	angles[17] = (0, 217.0829, 0);
	at[17] = 6.2667;
	points[18] = (875.6024, -1674.9448, 408.6496);
	angles[18] = (0, 220.2081, 0);
	at[18] = 6.6667;
	points[19] = (1031.8898, -1851.6339, 408.6496);
	angles[19] = (0, 223.0084, 0);
	at[19] = 7.3333;
	points[20] = (1202.2521, -2016.3347, 408.6496);
	angles[20] = (0, 227.5804, 0);
	at[20] = 8;
	points[21] = (1275.2245, -2076.8347, 408.6496);
	angles[21] = (0, 232.0661, 0);
	at[21] = 8.2667;
	points[22] = (1315.3937, -2099.3149, 408.6496);
	angles[22] = (0, 241.2637, 0);
	at[22] = 8.4000;
	points[23] = (1359.3740, -2116.7756, 408.6496);
	angles[23] = (0, 247.7573, 0);
	at[23] = 8.5333;
	points[24] = (1449.5157, -2146.4409, 408.6496);
	angles[24] = (0, 252.4581, 0);
	at[24] = 8.8000;
	points[25] = (1586.9725, -2183.8701, 408.6496);
	angles[25] = (0, 256.0240, 0);
	at[25] = 9.2000;
	points[26] = (1678.7362, -2200.6418, 408.6496);
	angles[26] = (0, 260.4297, 0);
	at[26] = 9.4667;
	points[27] = (1866.9174, -2225.6929, 408.6496);
	angles[27] = (0, 263.5140, 0);
	at[27] = 10;
	points[28] = (1959.7402, -2231.6497, 408.6496);
	angles[28] = (0, 268.4276, 0);
	at[28] = 10.2667;
	points[29] = (2054.7087, -2226.7048, 408.6496);
	angles[29] = (0, 273.6714, 0);
	at[29] = 10.5333;
	points[30] = (2196.1023, -2211.9448, 408.6496);
	angles[30] = (0, 277.1531, 0);
	at[30] = 10.9333;
	points[31] = (2289.0435, -2194.1458, 408.6496);
	angles[31] = (0, 283.4120, 0);
	at[31] = 11.2000;
	points[32] = (2375.1772, -2156.9253, 408.6496);
	angles[32] = (0, 294.8555, 0);
	at[32] = 11.4667;
	points[33] = (2459.1890, -2113.1458, 408.6496);
	angles[33] = (0, 298.1044, 0);
	at[33] = 11.7333;
	points[34] = (2581.5315, -2040.2048, 408.6496);
	angles[34] = (0, 302.6504, 0);
	at[34] = 12.1333;
	points[35] = (2617.8977, -2012.7953, 408.6496);
	angles[35] = (0, 307.8005, 0);
	at[35] = 12.2667;
	points[36] = (2683.4448, -1943.7087, 408.6496);
	angles[36] = (0, 317.7636, 0);
	at[36] = 12.5333;
	points[37] = (2744.1104, -1871.0276, 408.6496);
	angles[37] = (0, 320.6750, 0);
	at[37] = 12.8000;
	points[38] = (2829.8110, -1757.3859, 408.6496);
	angles[38] = (0, 324.4873, 0);
	at[38] = 13.2000;
	points[39] = (2854.0117, -1718.8032, 408.6496);
	angles[39] = (0, 328.4405, 0);
	at[39] = 13.3333;
	points[40] = (2913.9526, -1589.4331, 408.6496);
	angles[40] = (0, 336.6815, 0);
	at[40] = 13.7333;
	points[41] = (2964.7007, -1456.4448, 408.6496);
	angles[41] = (0, 340.5268, 0);
	at[41] = 14.1333;
	points[42] = (2978.7361, -1411.2245, 408.6496);
	angles[42] = (0, 342.9230, 0);
	at[42] = 14.2667;
	points[43] = (2988.1260, -1366.8032, 408.6496);
	angles[43] = (0, 348.9000, 0);
	at[43] = 14.4000;
	points[44] = (2991.3506, -1319.2441, 408.6496);
	angles[44] = (0, 355.6125, 0);
	at[44] = 14.5333;
	points[45] = (2988.7087, -1129.4489, 408.6496);
	angles[45] = (0, 362.3497, 0);
	at[45] = 15.0667;
	points[46] = (2977.2283, -987.7953, 408.6496);
	angles[46] = (0, 366.3453, 0);
	at[46] = 15.4667;
	points[47] = (2968.4526, -942.8347, 408.6496);
	angles[47] = (0, 371.9612, 0);
	at[47] = 15.6000;
	points[48] = (2952.1851, -897.7480, 408.6496);
	angles[48] = (0, 379.4020, 0);
	at[48] = 15.7333;
	points[49] = (2912.8896, -811.7913, 408.6496);
	angles[49] = (0, 385.4260, 0);
	at[49] = 16;
	points[50] = (2845.9451, -686.4292, 408.6496);
	angles[50] = (0, 389.3093, 0);
	at[50] = 16.4000;
	points[51] = (2795.0630, -608.2756, 408.6496);
	angles[51] = (0, 395.1873, 0);
	at[51] = 16.6667;
	points[52] = (2705.9451, -497.0709, 408.6496);
	angles[52] = (0, 399.4432, 0);
	at[52] = 17.0667;
	points[53] = (2582.4055, -352.6414, 408.6496);
	angles[53] = (0, 401.2291, 0);
	at[53] = 17.6000;
	points[54] = (2482.8347, -253.8067, 408.6496);
	angles[54] = (0, 406.3677, 0);
	at[54] = 18;
	points[55] = (2380.1497, -155.2811, 408.6496);
	angles[55] = (0, 405.6681, 0);
	at[55] = 18.4000;
	points[56] = (2314.5000, -86.5043, 408.6496);
	angles[56] = (0, 402.5033, 0);
	at[56] = 18.6667;
	points[57] = (2285.7874, -49.0346, 408.6496);
	angles[57] = (0, 396.5040, 0);
	at[57] = 18.8000;
	points[58] = (2268.6536, -6.7187, 408.6496);
	angles[58] = (0, 382.4634, 0);
	at[58] = 18.9333;
	points[59] = (2248.3740, 86.1972, 408.6496);
	angles[59] = (0, 370.8701, 0);
	at[59] = 19.2000;
	points[60] = (2235.9016, 180.2165, 408.6496);
	angles[60] = (0, 366.7174, 0);
	at[60] = 19.4667;
	points[61] = (2229.7639, 274.8941, 408.6496);
	angles[61] = (0, 362.2842, 0);
	at[61] = 19.7333;
	points[62] = (2234.2795, 320.5626, 408.6496);
	angles[62] = (0, 353.5109, 0);
	at[62] = 19.8667;
	points[63] = (2246.2009, 366.6744, 408.6496);
	angles[63] = (0, 346.1617, 0);
	at[63] = 20;
	points[64] = (2275.2756, 456.7638, 408.6496);
	angles[64] = (0, 341.7045, 0);
	at[64] = 20.2667;
	points[65] = (2304.9253, 547, 408.6496);
	angles[65] = (0, 342.4258, 0);
	at[65] = 20.5333;
	points[66] = (2325.8032, 638.5040, 408.6496);
	angles[66] = (0, 348.1155, 0);
	at[66] = 20.8000;
	points[67] = (2351.5630, 777.9882, 408.6496);
	angles[67] = (0, 350.2526, 0);
	at[67] = 21.2000;
	points[68] = (2364.7244, 872.0433, 408.6496);
	angles[68] = (0, 352.9022, 0);
	at[68] = 21.4667;
	points[69] = (2368.2639, 918.8898, 408.6496);
	angles[69] = (0, 355.9659, 0);
	at[69] = 21.6000;
	points[70] = (2365.3032, 964.5197, 408.6496);
	angles[70] = (0, 364.7173, 0);
	at[70] = 21.7333;
	points[71] = (2354.4529, 1011.5787, 408.6496);
	angles[71] = (0, 372.2877, 0);
	at[71] = 21.8667;
	points[72] = (2327.2480, 1102.0591, 408.6496);
	angles[72] = (0, 377.4378, 0);
	at[72] = 22.1333;
	points[73] = (2295.9133, 1191.3740, 408.6496);
	angles[73] = (0, 379.9005, 0);
	at[73] = 22.4000;
	points[74] = (2260.1379, 1279.5787, 408.6496);
	angles[74] = (0, 383.0823, 0);
	at[74] = 22.6667;
	points[75] = (2238.8425, 1321.3740, 408.6496);
	angles[75] = (0, 387.7601, 0);
	at[75] = 22.8000;
	points[76] = (2209.4292, 1357.1102, 408.6496);
	angles[76] = (0, 399.2075, 0);
	at[76] = 22.9333;
	points[77] = (2138.7834, 1420.2992, 408.6496);
	angles[77] = (0, 409.6479, 0);
	at[77] = 23.2000;
	points[78] = (2062.6694, 1476.9253, 408.6496);
	angles[78] = (0, 414.4848, 0);
	at[78] = 23.4667;
	points[79] = (2022.9174, 1502.3622, 408.6496);
	angles[79] = (0, 417.5726, 0);
	at[79] = 23.6000;
	points[80] = (1980.7362, 1522.4253, 408.6496);
	angles[80] = (0, 425.2980, 0);
	at[80] = 23.7333;
	points[81] = (1936.0472, 1536.5079, 408.6496);
	angles[81] = (0, 431.8840, 0);
	at[81] = 23.8667;
	points[82] = (1797.6732, 1569.8622, 408.6496);
	angles[82] = (0, 437.6920, 0);
	at[82] = 24.2667;
	points[83] = (1704.1890, 1586.9133, 408.6496);
	angles[83] = (0, 440.5467, 0);
	at[83] = 24.5333;
	points[84] = (1658.7756, 1591.5315, 408.6496);
	angles[84] = (0, 444.7897, 0);
	at[84] = 24.6667;
	points[85] = (1610.8781, 1591.6182, 408.6496);
	angles[85] = (0, 449.5402, 0);
	at[85] = 24.8000;
	points[86] = (1468.9409, 1584.1023, 408.6457);
	angles[86] = (0, 453.9944, 0);
	at[86] = 25.2000;
	points[87] = (1328.2441, 1567.9370, 408.6496);
	angles[87] = (0, 459.1441, 0);
	at[87] = 25.6000;
	points[88] = (1282.8859, 1555.6890, 408.6457);
	angles[88] = (0, 464.8658, 0);
	at[88] = 25.7333;
	points[89] = (1193.5000, 1524.6693, 408.6457);
	angles[89] = (0, 469.9257, 0);
	at[89] = 26;
	points[90] = (1105.7441, 1488.4568, 408.6496);
	angles[90] = (0, 473.4016, 0);
	at[90] = 26.2667;
	points[91] = (1063.2362, 1467.2126, 408.6496);
	angles[91] = (0, 476.9059, 0);
	at[91] = 26.4000;
	points[92] = (1026.0276, 1440.5276, 408.6457);
	angles[92] = (0, 485.7809, 0);
	at[92] = 26.5333;
	points[93] = (955.9095, 1376.3583, 408.6457);
	angles[93] = (0, 493.2637, 0);
	at[93] = 26.8000;
	points[94] = (824.3465, 1240.2716, 408.6496);
	angles[94] = (0, 497.6063, 0);
	at[94] = 27.3333;
	points[95] = (705.1418, 1093.9331, 408.6496);
	angles[95] = (0, 501.8883, 0);
	at[95] = 27.8667;
	points[96] = (621.0197, 979.3189, 408.6496);
	angles[96] = (0, 505.1473, 0);
	at[96] = 28.2667;
	points[97] = (597.2480, 940.7992, 408.6496);
	angles[97] = (0, 508.7955, 0);
	at[97] = 28.4000;
	points[98] = (555.1457, 855.5394, 408.6496);
	angles[98] = (0, 514.3111, 0);
	at[98] = 28.6667;
	points[99] = (398.9922, 503.6811, 408.6496);
	angles[99] = (0, 516.9088, 0);
	at[99] = 29.7500;
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
	points[0] = (239.2587, 58.1319, 408.6496);
	angles[0] = (0, -178.7528, 0);
	at[0] = 0;
	points[1] = (235.3807, -82.7587, 408.6496);
	angles[1] = (0, -182.4851, 0);
	at[1] = 0.4000;
	points[2] = (214.2000, -415.9016, 408.6496);
	angles[2] = (0, -182.8012, 0);
	at[2] = 1.3333;
	points[3] = (212.2933, -510.7874, 408.6496);
	angles[3] = (0, -180.1523, 0);
	at[3] = 1.6000;
	points[4] = (215.7441, -556.3425, 408.6496);
	angles[4] = (0, -175.1449, 0);
	at[4] = 1.7333;
	points[5] = (233.0941, -650.2598, 408.6496);
	angles[5] = (0, -168.7245, 0);
	at[5] = 2;
	points[6] = (265.9299, -788.2638, 408.6496);
	angles[6] = (0, -165.8311, 0);
	at[6] = 2.4000;
	points[7] = (291.1681, -879.6653, 408.6496);
	angles[7] = (0, -164.0537, 0);
	at[7] = 2.6667;
	points[8] = (321.2957, -967.4134, 408.6496);
	angles[8] = (0, -158.9233, 0);
	at[8] = 2.9333;
	points[9] = (363.4583, -1052.8937, 408.6496);
	angles[9] = (0, -152.9672, 0);
	at[9] = 3.2000;
	points[10] = (408.6142, -1136.1810, 408.6496);
	angles[10] = (0, -151.2476, 0);
	at[10] = 3.4667;
	points[11] = (527.5590, -1341.7244, 408.6496);
	angles[11] = (0, -149.0385, 0);
	at[11] = 4.1333;
	points[12] = (654.7598, -1539.2401, 408.6496);
	angles[12] = (0, -146.5341, 0);
	at[12] = 4.8000;
	points[13] = (789.9882, -1733.3898, 408.6496);
	angles[13] = (0, -143.4772, 0);
	at[13] = 5.4667;
	points[14] = (850.6299, -1804.0591, 408.6496);
	angles[14] = (0, -137.9702, 0);
	at[14] = 5.7333;
	points[15] = (984.1693, -1939.2284, 408.6496);
	angles[15] = (0, -134.2638, 0);
	at[15] = 6.2667;
	points[16] = (1089.3268, -2035.4647, 408.6496);
	angles[16] = (0, -131.2642, 0);
	at[16] = 6.6667;
	points[17] = (1164.5472, -2092.5552, 408.6496);
	angles[17] = (0, -124.4361, 0);
	at[17] = 6.9333;
	points[18] = (1206.0984, -2111.5198, 408.6496);
	angles[18] = (0, -114.7704, 0);
	at[18] = 7.0667;
	points[19] = (1250.9489, -2126.5669, 408.6496);
	angles[19] = (0, -108.9989, 0);
	at[19] = 7.2000;
	points[20] = (1342.7245, -2151, 408.6496);
	angles[20] = (0, -104.1053, 0);
	at[20] = 7.4667;
	points[21] = (1481.8859, -2179.2637, 408.6496);
	angles[21] = (0, -100.2777, 0);
	at[21] = 7.8667;
	points[22] = (1576.3307, -2192.2717, 408.6496);
	angles[22] = (0, -96.6518, 0);
	at[22] = 8.1333;
	points[23] = (1621.5432, -2194.0198, 408.6496);
	angles[23] = (0, -91.9883, 0);
	at[23] = 8.2667;
	points[24] = (1669.3898, -2192.3936, 408.6496);
	angles[24] = (0, -88.3447, 0);
	at[24] = 8.4000;
	points[25] = (1858.0472, -2175.6851, 408.6496);
	angles[25] = (0, -83.6740, 0);
	at[25] = 8.9333;
	points[26] = (1998.6417, -2155.5195, 408.6496);
	angles[26] = (0, -80.6564, 0);
	at[26] = 9.3333;
	points[27] = (2089.1260, -2133.9685, 408.6496);
	angles[27] = (0, -73.6036, 0);
	at[27] = 9.6000;
	points[28] = (2174.8896, -2093.8857, 408.6496);
	angles[28] = (0, -63.5195, 0);
	at[28] = 9.8667;
	points[29] = (2257.9883, -2047.7047, 408.6496);
	angles[29] = (0, -60.4011, 0);
	at[29] = 10.1333;
	points[30] = (2379.3977, -1973.7560, 408.6496);
	angles[30] = (0, -57.8687, 0);
	at[30] = 10.5333;
	points[31] = (2495.7954, -1894.0394, 408.6496);
	angles[31] = (0, -53.5604, 0);
	at[31] = 10.9333;
	points[32] = (2602.5237, -1800.7599, 408.6496);
	angles[32] = (0, -47.6925, 0);
	at[32] = 11.3333;
	points[33] = (2738.5315, -1668.5669, 408.6496);
	angles[33] = (0, -44.6563, 0);
	at[33] = 11.8667;
	points[34] = (2833.1733, -1562.8110, 408.6496);
	angles[34] = (0, -39.4240, 0);
	at[34] = 12.2667;
	points[35] = (2857.9490, -1524.9253, 408.6496);
	angles[35] = (0, -32.4083, 0);
	at[35] = 12.4000;
	points[36] = (2895.8071, -1437.6497, 408.6496);
	angles[36] = (0, -22.0507, 0);
	at[36] = 12.6667;
	points[37] = (2941.4648, -1302.7756, 408.6496);
	angles[37] = (0, -17.5509, 0);
	at[37] = 13.0667;
	points[38] = (2979.0710, -1166.0276, 408.6496);
	angles[38] = (0, -14.1174, 0);
	at[38] = 13.4667;
	points[39] = (2995.5710, -1074.6653, 408.6496);
	angles[39] = (0, -7.5536, 0);
	at[39] = 13.7333;
	points[40] = (2997.4685, -979.6063, 408.6496);
	angles[40] = (0, -0.1088, 0);
	at[40] = 14;
	points[41] = (2991.3821, -837.2323, 408.6496);
	angles[41] = (0, 3.3965, 0);
	at[41] = 14.4000;
	points[42] = (2977.9290, -695.4330, 408.6496);
	angles[42] = (0, 6.6574, 0);
	at[42] = 14.8000;
	points[43] = (2960.7915, -602.9528, 408.6496);
	angles[43] = (0, 13.0766, 0);
	at[43] = 15.0667;
	points[44] = (2943.4370, -560.3425, 408.6496);
	angles[44] = (0, 21.9642, 0);
	at[44] = 15.2000;
	points[45] = (2921.4763, -518.3465, 408.6496);
	angles[45] = (0, 27.1824, 0);
	at[45] = 15.3333;
	points[46] = (2847.8506, -396.4764, 408.6496);
	angles[46] = (0, 32.1069, 0);
	at[46] = 15.7333;
	points[47] = (2744.4922, -237.1894, 408.6496);
	angles[47] = (0, 32.9327, 0);
	at[47] = 16.2667;
	points[48] = (2569.7678, 42.7236, 408.6496);
	angles[48] = (0, 31.6581, 0);
	at[48] = 17.2000;
	points[49] = (2521.0906, 124.2831, 408.6496);
	angles[49] = (0, 30.4324, 0);
	at[49] = 17.4667;
	points[50] = (2476.3149, 208.2563, 408.6496);
	angles[50] = (0, 26.6124, 0);
	at[50] = 17.7333;
	points[51] = (2460.5750, 250.8807, 408.6496);
	angles[51] = (0, 20.0479, 0);
	at[51] = 17.8667;
	points[52] = (2448.5354, 296.8508, 408.6496);
	angles[52] = (0, 15.0911, 0);
	at[52] = 18;
	points[53] = (2420.2795, 435.7795, 408.6496);
	angles[53] = (0, 10.7159, 0);
	at[53] = 18.4000;
	points[54] = (2376.5984, 668.9449, 408.6496);
	angles[54] = (0, 11.9851, 0);
	at[54] = 19.0667;
	points[55] = (2317.8071, 896.5670, 408.6496);
	angles[55] = (0, 14.9006, 0);
	at[55] = 19.7333;
	points[56] = (2253.4763, 1125.0669, 408.6496);
	angles[56] = (0, 16.5971, 0);
	at[56] = 20.4000;
	points[57] = (2224.1655, 1212.3820, 408.6496);
	angles[57] = (0, 19.4912, 0);
	at[57] = 20.6667;
	points[58] = (2139.3110, 1434.2756, 408.6496);
	angles[58] = (0, 22.1519, 0);
	at[58] = 21.3333;
	points[59] = (2101.1143, 1521.2914, 408.6496);
	angles[59] = (0, 24.3633, 0);
	at[59] = 21.6000;
	points[60] = (2057.7322, 1605.1221, 408.6496);
	angles[60] = (0, 28.8232, 0);
	at[60] = 21.8667;
	points[61] = (2031.5157, 1644.8110, 408.6496);
	angles[61] = (0, 33.8794, 0);
	at[61] = 22;
	points[62] = (1999.9487, 1676.3937, 408.6496);
	angles[62] = (0, 46.1325, 0);
	at[62] = 22.1333;
	points[63] = (1959.8898, 1702.0552, 408.6496);
	angles[63] = (0, 56.5623, 0);
	at[63] = 22.2667;
	points[64] = (1831.5236, 1764.6221, 408.6496);
	angles[64] = (0, 65.8593, 0);
	at[64] = 22.6667;
	points[65] = (1654.4016, 1832.6654, 408.6496);
	angles[65] = (0, 70.7331, 0);
	at[65] = 23.2000;
	points[66] = (1564.4094, 1860.3464, 408.6496);
	angles[66] = (0, 73.8162, 0);
	at[66] = 23.4667;
	points[67] = (1518.3583, 1871.6102, 408.6496);
	angles[67] = (0, 76.4449, 0);
	at[67] = 23.6000;
	points[68] = (1472.3505, 1878.7166, 408.6496);
	angles[68] = (0, 81.9616, 0);
	at[68] = 23.7333;
	points[69] = (1425.4252, 1878.8464, 408.6496);
	angles[69] = (0, 89.4305, 0);
	at[69] = 23.8667;
	points[70] = (1331.6024, 1870.8544, 408.6457);
	angles[70] = (0, 95.7570, 0);
	at[70] = 24.1333;
	points[71] = (1143.8898, 1841.4095, 408.6457);
	angles[71] = (0, 100.4472, 0);
	at[71] = 24.6667;
	points[72] = (1050.9607, 1821.5985, 408.6457);
	angles[72] = (0, 102.6135, 0);
	at[72] = 24.9333;
	points[73] = (959.5984, 1797.4292, 408.6457);
	angles[73] = (0, 105.7675, 0);
	at[73] = 25.2000;
	points[74] = (914.0394, 1782.3505, 408.6457);
	angles[74] = (0, 108.4696, 0);
	at[74] = 25.3333;
	points[75] = (870.3228, 1763.5787, 408.6457);
	angles[75] = (0, 113.7174, 0);
	at[75] = 25.4667;
	points[76] = (834.2441, 1738.2323, 408.6457);
	angles[76] = (0, 125.3101, 0);
	at[76] = 25.6000;
	points[77] = (800.6142, 1704.9803, 408.6457);
	angles[77] = (0, 134.0276, 0);
	at[77] = 25.7333;
	points[78] = (769.3190, 1669.2638, 408.6457);
	angles[78] = (0, 138.4715, 0);
	at[78] = 25.8667;
	points[79] = (710.6378, 1594.3818, 408.6457);
	angles[79] = (0, 142.6442, 0);
	at[79] = 26.1333;
	points[80] = (655.3622, 1517.2126, 408.6457);
	angles[80] = (0, 144.8470, 0);
	at[80] = 26.4000;
	points[81] = (551.3544, 1358.2795, 408.6457);
	angles[81] = (0, 147.9064, 0);
	at[81] = 26.9333;
	points[82] = (502.8307, 1276.3701, 408.6457);
	angles[82] = (0, 150.0138, 0);
	at[82] = 27.2000;
	points[83] = (482.6102, 1237.1851, 408.6457);
	angles[83] = (0, 153.1581, 0);
	at[83] = 27.3333;
	points[84] = (448.7756, 1148.2756, 408.6457);
	angles[84] = (0, 160.3155, 0);
	at[84] = 27.6000;
	points[85] = (393.5138, 966.5512, 408.6457);
	angles[85] = (0, 164.0190, 0);
	at[85] = 28.1333;
	points[86] = (319.5370, 693.8662, 408.6496);
	angles[86] = (0, 164.9833, 0);
	at[86] = 28.9333;
	points[87] = (273.3098, 509.7087, 408.6496);
	angles[87] = (0, 166.4412, 0);
	at[87] = 29.4667;
	points[88] = (243.1965, 370.7327, 408.6496);
	angles[88] = (0, 169.0029, 0);
	at[88] = 29.8667;
	points[89] = (237.7437, 324.6441, 408.6496);
	angles[89] = (0, 173.6741, 0);
	at[89] = 30;
	points[90] = (236.1567, 277.7457, 408.6496);
	angles[90] = (0, 177.7180, 0);
	at[90] = 30.1333;
	points[91] = (239.2587, 58.1319, 408.6496);
	angles[91] = (0, 181.2472, 0);
	at[91] = 30.7500;
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
	points[0] = (250.2398, -286.9102, 408.6496);
	angles[0] = (0, 179.1628, 0);
	at[0] = 0;
	points[1] = (252.7744, -334.0492, 408.6496);
	angles[1] = (0, 183.2097, 0);
	at[1] = 0.1333;
	points[2] = (265.6657, -426.1418, 408.6496);
	angles[2] = (0, 188.6242, 0);
	at[2] = 0.4000;
	points[3] = (294.8425, -612.9213, 408.6496);
	angles[3] = (0, 189.1775, 0);
	at[3] = 0.9333;
	points[4] = (319.8390, -753.3268, 408.6496);
	angles[4] = (0, 190.7767, 0);
	at[4] = 1.3333;
	points[5] = (341.6181, -844.7638, 408.6496);
	angles[5] = (0, 195.3592, 0);
	at[5] = 1.6000;
	points[6] = (378.0047, -930.9606, 408.6496);
	angles[6] = (0, 204.0968, 0);
	at[6] = 1.8667;
	points[7] = (463.4410, -1100.6023, 408.6496);
	angles[7] = (0, 207.6009, 0);
	at[7] = 2.4000;
	points[8] = (531.4055, -1225.1851, 408.6496);
	angles[8] = (0, 209.2956, 0);
	at[8] = 2.8000;
	points[9] = (605.6063, -1344.8307, 408.6496);
	angles[9] = (0, 212.4847, 0);
	at[9] = 3.2000;
	points[10] = (735.8976, -1542.4015, 408.6496);
	angles[10] = (0, 213.9874, 0);
	at[10] = 3.8667;
	points[11] = (845.1575, -1696.1260, 408.6496);
	angles[11] = (0, 215.9879, 0);
	at[11] = 4.4000;
	points[12] = (959.3976, -1847.5669, 408.6496);
	angles[12] = (0, 217.9157, 0);
	at[12] = 4.9333;
	points[13] = (1019.9725, -1920.6929, 408.6496);
	angles[13] = (0, 220.5104, 0);
	at[13] = 5.2000;
	points[14] = (1052.7953, -1955.0946, 408.6496);
	angles[14] = (0, 224.0394, 0);
	at[14] = 5.3333;
	points[15] = (1088.6969, -1983.3268, 408.6496);
	angles[15] = (0, 231.7322, 0);
	at[15] = 5.4667;
	points[16] = (1128.1260, -2009.0631, 408.6496);
	angles[16] = (0, 236.4547, 0);
	at[16] = 5.6000;
	points[17] = (1210.0157, -2057.0513, 408.6496);
	angles[17] = (0, 240.2174, 0);
	at[17] = 5.8667;
	points[18] = (1378.1732, -2144.3230, 408.6496);
	angles[18] = (0, 243.9576, 0);
	at[18] = 6.4000;
	points[19] = (1463.5394, -2180.9646, 408.6496);
	angles[19] = (0, 248.5905, 0);
	at[19] = 6.6667;
	points[20] = (1600.0197, -2222.5393, 408.6496);
	angles[20] = (0, 254.3414, 0);
	at[20] = 7.0667;
	points[21] = (1738.4606, -2254.8938, 408.6496);
	angles[21] = (0, 258.3324, 0);
	at[21] = 7.4667;
	points[22] = (1832.1456, -2267.9292, 408.6496);
	angles[22] = (0, 264.0176, 0);
	at[22] = 7.7333;
	points[23] = (1877.6456, -2267.2795, 408.6496);
	angles[23] = (0, 271.7664, 0);
	at[23] = 7.8667;
	points[24] = (1923.9802, -2258.7087, 408.6496);
	angles[24] = (0, 279.8680, 0);
	at[24] = 8;
	points[25] = (1970.3307, -2247.2639, 408.6496);
	angles[25] = (0, 283.5481, 0);
	at[25] = 8.1333;
	points[26] = (2106.8308, -2206.8503, 408.6496);
	angles[26] = (0, 287.3916, 0);
	at[26] = 8.5333;
	points[27] = (2241.7205, -2160.7954, 408.6496);
	angles[27] = (0, 289.5761, 0);
	at[27] = 8.9333;
	points[28] = (2373.0315, -2108.5789, 408.6496);
	angles[28] = (0, 293.3185, 0);
	at[28] = 9.3333;
	points[29] = (2413.9844, -2087.6101, 408.6496);
	angles[29] = (0, 297.8167, 0);
	at[29] = 9.4667;
	points[30] = (2453.1101, -2061.0786, 408.6496);
	angles[30] = (0, 303.8774, 0);
	at[30] = 9.6000;
	points[31] = (2527.5789, -2001.9133, 408.6496);
	angles[31] = (0, 309.2901, 0);
	at[31] = 9.8667;
	points[32] = (2668.2993, -1874.5472, 408.6496);
	angles[32] = (0, 313.5699, 0);
	at[32] = 10.4000;
	points[33] = (2766.6809, -1771.5198, 408.6496);
	angles[33] = (0, 318.6202, 0);
	at[33] = 10.8000;
	points[34] = (2793.5474, -1734.4803, 408.6496);
	angles[34] = (0, 324.0265, 0);
	at[34] = 10.9333;
	points[35] = (2842.2559, -1653.5040, 408.6496);
	angles[35] = (0, 329.7999, 0);
	at[35] = 11.2000;
	points[36] = (2908.1538, -1527.6851, 408.6496);
	angles[36] = (0, 333.4611, 0);
	at[36] = 11.6000;
	points[37] = (2947.7087, -1441.2716, 408.6496);
	angles[37] = (0, 336.1991, 0);
	at[37] = 11.8667;
	points[38] = (2979.1299, -1352.6063, 408.6496);
	angles[38] = (0, 343.2209, 0);
	at[38] = 12.1333;
	points[39] = (2986.3191, -1307.1221, 408.6496);
	angles[39] = (0, 350.6479, 0);
	at[39] = 12.2667;
	points[40] = (2993.2361, -1212.2048, 408.6496);
	angles[40] = (0, 356.6085, 0);
	at[40] = 12.5333;
	points[41] = (2995.9133, -1070.2008, 408.6496);
	angles[41] = (0, 359.8453, 0);
	at[41] = 12.9333;
	points[42] = (2993.7795, -975.7480, 408.6496);
	angles[42] = (0, 361.8431, 0);
	at[42] = 13.2000;
	points[43] = (2986.7915, -880.8661, 408.6496);
	angles[43] = (0, 365.4160, 0);
	at[43] = 13.4667;
	points[44] = (2978.8857, -835.5591, 408.6496);
	angles[44] = (0, 370.7635, 0);
	at[44] = 13.6000;
	points[45] = (2962.3149, -791.8937, 408.6496);
	angles[45] = (0, 380.4764, 0);
	at[45] = 13.7333;
	points[46] = (2941.2126, -749.3583, 408.6496);
	angles[46] = (0, 385.9565, 0);
	at[46] = 13.8667;
	points[47] = (2894.1812, -666.7598, 408.6496);
	angles[47] = (0, 390.2966, 0);
	at[47] = 14.1333;
	points[48] = (2819.3152, -545.9921, 408.6496);
	angles[48] = (0, 392.1596, 0);
	at[48] = 14.5333;
	points[49] = (2746.3782, -426.0118, 408.6496);
	angles[49] = (0, 389.6655, 0);
	at[49] = 14.9333;
	points[50] = (2437.3701, 159.9599, 408.6496);
	angles[50] = (0, 387.6152, 0);
	at[50] = 16.8000;
	points[51] = (2375.1418, 287.3559, 408.6496);
	angles[51] = (0, 384.6794, 0);
	at[51] = 17.2000;
	points[52] = (2357.2361, 332.0823, 408.6496);
	angles[52] = (0, 381.4761, 0);
	at[52] = 17.3333;
	points[53] = (2345.9172, 376.7543, 408.6496);
	angles[53] = (0, 374.2025, 0);
	at[53] = 17.4667;
	points[54] = (2338.2637, 423.0118, 408.6496);
	angles[54] = (0, 369.8209, 0);
	at[54] = 17.6000;
	points[55] = (2322.0984, 564.3701, 408.6496);
	angles[55] = (0, 365.5451, 0);
	at[55] = 18;
	points[56] = (2315.2441, 658.5591, 408.6496);
	angles[56] = (0, 363.6438, 0);
	at[56] = 18.2667;
	points[57] = (2313.4844, 754.2914, 408.6496);
	angles[57] = (0, 359.4774, 0);
	at[57] = 18.5333;
	points[58] = (2321.2205, 798.9921, 408.6457);
	angles[58] = (0, 349.4790, 0);
	at[58] = 18.6667;
	points[59] = (2336.8149, 843.6496, 408.6496);
	angles[59] = (0, 341.4421, 0);
	at[59] = 18.8000;
	points[60] = (2373.8071, 931.0669, 408.6496);
	angles[60] = (0, 336.7113, 0);
	at[60] = 19.0667;
	points[61] = (2410.2874, 1018.7244, 408.6496);
	angles[61] = (0, 338.3234, 0);
	at[61] = 19.3333;
	points[62] = (2424.6733, 1063.2440, 408.6496);
	angles[62] = (0, 342.6246, 0);
	at[62] = 19.4667;
	points[63] = (2429.7402, 1109.2441, 408.6496);
	angles[63] = (0, 354.2950, 0);
	at[63] = 19.6000;
	points[64] = (2428.2402, 1156.9409, 408.6496);
	angles[64] = (0, 361.0486, 0);
	at[64] = 19.7333;
	points[65] = (2414.4253, 1298.3385, 408.6496);
	angles[65] = (0, 366.9833, 0);
	at[65] = 20.1333;
	points[66] = (2399.0669, 1391.5945, 408.6496);
	angles[66] = (0, 370.3287, 0);
	at[66] = 20.4000;
	points[67] = (2388.3740, 1437.9922, 408.6496);
	angles[67] = (0, 373.1567, 0);
	at[67] = 20.5333;
	points[68] = (2373.0276, 1483.4331, 408.6496);
	angles[68] = (0, 379.4011, 0);
	at[68] = 20.6667;
	points[69] = (2346.9961, 1520.5078, 408.6496);
	angles[69] = (0, 395.0612, 0);
	at[69] = 20.8000;
	points[70] = (2313.5510, 1553.7402, 408.6496);
	angles[70] = (0, 404.2869, 0);
	at[70] = 20.9333;
	points[71] = (2277.8191, 1585.0511, 408.6496);
	angles[71] = (0, 408.4436, 0);
	at[71] = 21.0667;
	points[72] = (2165.1655, 1672.1221, 408.6496);
	angles[72] = (0, 413.6460, 0);
	at[72] = 21.4667;
	points[73] = (2086.6772, 1725.6458, 408.6496);
	angles[73] = (0, 416.5393, 0);
	at[73] = 21.7333;
	points[74] = (2045.7205, 1750.0078, 408.6496);
	angles[74] = (0, 419.6060, 0);
	at[74] = 21.8667;
	points[75] = (2003.5787, 1766.9370, 408.6496);
	angles[75] = (0, 428.2853, 0);
	at[75] = 22;
	points[76] = (1957.5748, 1779.3701, 408.6496);
	angles[76] = (0, 434.4204, 0);
	at[76] = 22.1333;
	points[77] = (1864.6141, 1797.5787, 408.6496);
	angles[77] = (0, 439.8248, 0);
	at[77] = 22.4000;
	points[78] = (1723.1771, 1814.0432, 408.6457);
	angles[78] = (0, 445.5474, 0);
	at[78] = 22.8000;
	points[79] = (1630.2560, 1811.1536, 408.6496);
	angles[79] = (0, 453.1053, 0);
	at[79] = 23.0667;
	points[80] = (1488.3701, 1797.6693, 408.6496);
	angles[80] = (0, 456.1893, 0);
	at[80] = 23.4667;
	points[81] = (1347.2323, 1777.7638, 408.6496);
	angles[81] = (0, 459.3585, 0);
	at[81] = 23.8667;
	points[82] = (1302.4489, 1767.8386, 408.6496);
	angles[82] = (0, 463.0952, 0);
	at[82] = 24;
	points[83] = (1213.6772, 1734.6300, 408.6457);
	angles[83] = (0, 471.7405, 0);
	at[83] = 24.2667;
	points[84] = (1127.3781, 1695.8466, 408.6457);
	angles[84] = (0, 474.8031, 0);
	at[84] = 24.5333;
	points[85] = (1042.6378, 1653.0867, 408.6457);
	angles[85] = (0, 477.5365, 0);
	at[85] = 24.8000;
	points[86] = (1001.3819, 1629.6339, 408.6457);
	angles[86] = (0, 479.7484, 0);
	at[86] = 24.9333;
	points[87] = (963.6929, 1604.0474, 408.6457);
	angles[87] = (0, 484.8894, 0);
	at[87] = 25.0667;
	points[88] = (894.1811, 1539.2836, 408.6457);
	angles[88] = (0, 494.1001, 0);
	at[88] = 25.3333;
	points[89] = (764.8347, 1400.4292, 408.6457);
	angles[89] = (0, 498.2634, 0);
	at[89] = 25.8667;
	points[90] = (703.5866, 1327.9409, 408.6496);
	angles[90] = (0, 500.5231, 0);
	at[90] = 26.1333;
	points[91] = (676.0945, 1291.3188, 408.6496);
	angles[91] = (0, 503.5469, 0);
	at[91] = 26.2667;
	points[92] = (628.2874, 1209.8149, 408.6457);
	angles[92] = (0, 510.6096, 0);
	at[92] = 26.5333;
	points[93] = (562.9016, 1083.2441, 408.6496);
	angles[93] = (0, 513.3207, 0);
	at[93] = 26.9333;
	points[94] = (482.3661, 911.3976, 408.6496);
	angles[94] = (0, 516.3085, 0);
	at[94] = 27.4667;
	points[95] = (450.5315, 824.1102, 408.6457);
	angles[95] = (0, 520.7719, 0);
	at[95] = 27.7333;
	points[96] = (393.2547, 643.2283, 408.6496);
	angles[96] = (0, 523.0076, 0);
	at[96] = 28.2667;
	points[97] = (342.2181, 461.6851, 408.6496);
	angles[97] = (0, 525.9089, 0);
	at[97] = 28.8000;
	points[98] = (302.7941, 276.5169, 408.6496);
	angles[98] = (0, 528.6312, 0);
	at[98] = 29.3333;
	points[99] = (277.2563, 137.2091, 408.6496);
	angles[99] = (0, 530.3676, 0);
	at[99] = 29.7333;
	points[100] = (263.5287, -3.5687, 408.6496);
	angles[100] = (0, 535.8178, 0);
	at[100] = 30.1333;
	points[101] = (250.2398, -286.9102, 408.6496);
	angles[101] = (0, 539.1628, 0);
	at[101] = 30.9333;
	mover = getEnt("iz_obj_2", "targetname");
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
