main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_snes_koopa_beach_2", 0);

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
	ambientPlay("iz_0_16", 2);
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
	level.iz_route[level.iz_route.size] = (-2908, -2592, 3248);
	level.iz_route[level.iz_route.size] = (-2749, -3463, 3248);
	level.iz_route[level.iz_route.size] = (-2194, -4386, 3248);
	level.iz_route[level.iz_route.size] = (-1417, -5053, 3248);
	level.iz_route[level.iz_route.size] = (-309, -5398, 3248);
	level.iz_route[level.iz_route.size] = (734, -5416, 3248);
	level.iz_route[level.iz_route.size] = (1787, -5307, 3243);
	level.iz_route[level.iz_route.size] = (2791, -5227, 3247);
	level.iz_route[level.iz_route.size] = (3820, -5344, 3248);
	level.iz_route[level.iz_route.size] = (4754, -5048, 3248);
	level.iz_route[level.iz_route.size] = (5416, -4233, 3248);
	level.iz_route[level.iz_route.size] = (5679, -3318, 3248);
	level.iz_route[level.iz_route.size] = (5733, -2351, 3233);
	level.iz_route[level.iz_route.size] = (5434, -1464, 3233);
	level.iz_route[level.iz_route.size] = (5232, -739, 3233);
	level.iz_route[level.iz_route.size] = (5387, -95, 3235);
	level.iz_route[level.iz_route.size] = (5743, 423, 3235);
	level.iz_route[level.iz_route.size] = (5897, 1043, 3236);
	level.iz_route[level.iz_route.size] = (5663, 1626, 3239);
	level.iz_route[level.iz_route.size] = (5696, 2367, 3237);
	level.iz_route[level.iz_route.size] = (5624, 3218, 3235);
	level.iz_route[level.iz_route.size] = (5552, 4173, 3248);
	level.iz_route[level.iz_route.size] = (5503, 5107, 3248);
	level.iz_route[level.iz_route.size] = (4854, 5588, 3245);
	level.iz_route[level.iz_route.size] = (4157, 5745, 3244);
	level.iz_route[level.iz_route.size] = (3522, 5828, 3248);
	level.iz_route[level.iz_route.size] = (2862, 5848, 3246);
	level.iz_route[level.iz_route.size] = (2202, 5984, 3248);
	level.iz_route[level.iz_route.size] = (1500, 6112, 3248);
	level.iz_route[level.iz_route.size] = (836, 5844, 3248);
	level.iz_route[level.iz_route.size] = (247, 5378, 3248);
	level.iz_route[level.iz_route.size] = (-297, 4924, 3246);
	level.iz_route[level.iz_route.size] = (-786, 4467, 3248);
	level.iz_route[level.iz_route.size] = (-1269, 4010, 3245);
	level.iz_route[level.iz_route.size] = (-1908, 3733, 3246);
	level.iz_route[level.iz_route.size] = (-2596, 3916, 3248);
	level.iz_route[level.iz_route.size] = (-3290, 4115, 3248);
	level.iz_route[level.iz_route.size] = (-3964, 4268, 3246);
	level.iz_route[level.iz_route.size] = (-4645, 4355, 3248);
	level.iz_route[level.iz_route.size] = (-5333, 4108, 3248);
	level.iz_route[level.iz_route.size] = (-5924, 3666, 3248);
	level.iz_route[level.iz_route.size] = (-6313, 3040, 3244);
	level.iz_route[level.iz_route.size] = (-6369, 2306, 3244);
	level.iz_route[level.iz_route.size] = (-6392, 1536, 3246);
	level.iz_route[level.iz_route.size] = (-6336, 746, 3248);
	level.iz_route[level.iz_route.size] = (-6101, -21, 3248);
	level.iz_route[level.iz_route.size] = (-5401, -595, 3248);
	level.iz_route[level.iz_route.size] = (-4596, -853, 3248);
	level.iz_route[level.iz_route.size] = (-3751, -1111, 3248);
	level.iz_route[level.iz_route.size] = (-3123, -1796, 3248);
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
	points[0] = (5287.9136, -1346.1141, 3233.4172);
	angles[0] = (0, 141.4982, 0);
	at[0] = 0;
	points[1] = (5179.7246, -1478.6456, 3233.4172);
	angles[1] = (0, 140.1724, 0);
	at[1] = 0.8000;
	points[2] = (5167.0869, -1493.5511, 3233.4172);
	angles[2] = (0, 139.5037, -0.0022);
	at[2] = 1;
	points[3] = (5046.3389, -1629.2126, 3233.3779);
	angles[3] = (0, 137.7556, -0.0088);
	at[3] = 4.4000;
	points[4] = (4944.2915, -1738.4213, 3233.4133);
	angles[4] = (0, 135.3118, 0.0658);
	at[4] = 7.2000;
	points[5] = (4843.5825, -1831.7008, 3233.7991);
	angles[5] = (0, 131.9774, 0.1883);
	at[5] = 9.8000;
	points[6] = (4714.0156, -1944.1300, 3234.3938);
	angles[6] = (0, 128.6980, 0.2076);
	at[6] = 13;
	points[7] = (4706.3389, -1949.9961, 3234.4292);
	angles[7] = (0, 126.9111, 0.2089);
	at[7] = 13.2000;
	points[8] = (4699.2520, -1953.2323, 3234.4604);
	angles[8] = (0, 65.4536, 0.1031);
	at[8] = 13.4000;
	points[9] = (4704.8818, -1943.8544, 3234.4211);
	angles[9] = (0, -25.1549, -0.1841);
	at[9] = 13.6000;
	points[10] = (4711.0239, -1935.2362, 3234.3857);
	angles[10] = (0, -34.9125, -0.1976);
	at[10] = 13.8000;
	points[11] = (4717.5986, -1926.3071, 3234.3464);
	angles[11] = (0, -36.4406, -0.1983);
	at[11] = 14;
	points[12] = (4897.1655, -1700.0236, 3233.4412);
	angles[12] = (0, -39.1255, -0.1237);
	at[12] = 19.4000;
	points[13] = (4909.2520, -1685.2834, 3233.4094);
	angles[13] = (0, -39.4803, -0.0721);
	at[13] = 19.8000;
	points[14] = (5131.0239, -1424.9213, 3233.4172);
	angles[14] = (0, -39.6475, 0.0058);
	at[14] = 26.2000;
	points[15] = (5143.1890, -1410, 3233.4172);
	angles[15] = (0, -38.8195, 0);
	at[15] = 26.6000;
	points[16] = (5360.1182, -1131.4764, 3233.4133);
	angles[16] = (0, -39.3215, 0);
	at[16] = 33.2000;
	points[17] = (5416.0630, -1069.3820, 3233.4133);
	angles[17] = (0, -43.1837, 0);
	at[17] = 34.8000;
	points[18] = (5513.3857, -970.4291, 3233.4133);
	angles[18] = (0, -46.4195, 0);
	at[18] = 37.4000;
	points[19] = (5529.3311, -955.9449, 3233.4133);
	angles[19] = (0, -48.7177, 0);
	at[19] = 37.8000;
	points[20] = (5537.3228, -949.6299, 3233.4133);
	angles[20] = (0, -53.1568, 0);
	at[20] = 38;
	points[21] = (5540.5513, -952.5157, 3233.4133);
	angles[21] = (0, -165.4608, 0);
	at[21] = 38.2000;
	points[22] = (5536.0239, -962.4174, 3233.4133);
	angles[22] = (0, -202.8076, 0);
	at[22] = 38.4000;
	points[23] = (5530.9448, -972.4291, 3233.4133);
	angles[23] = (0, -206.9579, 0);
	at[23] = 38.6000;
	points[24] = (5521.0630, -990.8780, 3233.4133);
	angles[24] = (0, -208.5116, 0);
	at[24] = 39;
	points[25] = (5446.1021, -1120.7834, 3233.4133);
	angles[25] = (0, -210.8169, 0);
	at[25] = 41.8000;
	points[26] = (5384.2915, -1220.3110, 3233.4133);
	angles[26] = (0, -213.8013, 0);
	at[26] = 44;
	points[27] = (5366.4565, -1245.1851, 3233.4172);
	angles[27] = (0, -215.7926, 0);
	at[27] = 44.2000;
	points[28] = (5287.9136, -1346.1141, 3233.4172);
	angles[28] = (0, -218.5019, 0);
	at[28] = 44.8000;
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
	points[0] = (5002.6772, 2609.5867, 3234.9014);
	angles[0] = (0, 114.9899, 0.0522);
	at[0] = 0;
	points[1] = (4793.5830, 2508.9607, 3235.0471);
	angles[1] = (0, 116.5794, 0);
	at[1] = 1.0833;
	points[2] = (4768.7798, 2495.9529, 3235.0198);
	angles[2] = (0, 118.3256, -0.0925);
	at[2] = 1.3000;
	points[3] = (4590.9844, 2387.7244, 3234.1772);
	angles[3] = (0, 122.7671, -0.2597);
	at[3] = 5.2000;
	points[4] = (4513.9766, 2336.4841, 3233.7991);
	angles[4] = (0, 124.7866, -0.1925);
	at[4] = 6.9333;
	points[5] = (4469.0947, 2302.6416, 3233.6851);
	angles[5] = (0, 128.4431, -0.0776);
	at[5] = 8.0167;
	points[6] = (4239.0552, 2108.4844, 3233.5552);
	angles[6] = (0, 131.2253, 0.0460);
	at[6] = 13.6500;
	points[7] = (4223.4648, 2094.6968, 3233.5828);
	angles[7] = (0, 131.6703, 0.1017);
	at[7] = 14.0833;
	points[8] = (3992.9919, 1881.8583, 3234.5396);
	angles[8] = (0, 134.6973, 0.2132);
	at[8] = 19.9333;
	points[9] = (3985.8660, 1874.5945, 3234.5828);
	angles[9] = (0, 136.0193, 0.2279);
	at[9] = 20.1500;
	points[10] = (3981.7324, 1868.1180, 3234.6260);
	angles[10] = (0, 205.0106, 0.6357);
	at[10] = 20.3667;
	points[11] = (3992.0474, 1874.0511, 3234.6143);
	angles[11] = (0, 295.1542, 0.0012);
	at[11] = 20.5833;
	points[12] = (4002.3623, 1880.7126, 3234.5984);
	angles[12] = (0, 302.6726, -0.0810);
	at[12] = 20.8000;
	points[13] = (4011.6140, 1886.8700, 3234.5789);
	angles[13] = (0, 303.6925, -0.0913);
	at[13] = 21.0167;
	points[14] = (4248.7402, 2054.0552, 3234.1143);
	angles[14] = (0, 305.8206, -0.0542);
	at[14] = 26.4333;
	points[15] = (4265.4727, 2066.2600, 3234.1064);
	angles[15] = (0, 306.3022, -0.0212);
	at[15] = 26.8667;
	points[16] = (4533.4253, 2269, 3234.2637);
	angles[16] = (0, 306.2246, 0.1091);
	at[16] = 33.1500;
	points[17] = (4569.7637, 2294.6377, 3234.4253);
	angles[17] = (0, 304.6947, 0.2712);
	at[17] = 34.0167;
	points[18] = (4800.4331, 2449.1458, 3235.8896);
	angles[18] = (0, 303.2801, 0.1454);
	at[18] = 39.2167;
	points[19] = (4817.8740, 2460.5120, 3235.9133);
	angles[19] = (0, 302.9082, 0.0084);
	at[19] = 39.6500;
	points[20] = (5073.5044, 2620.9094, 3235.1733);
	angles[20] = (0, 302.3257, -0.1817);
	at[20] = 45.2833;
	points[21] = (5141.9292, 2665.0671, 3234.8936);
	angles[21] = (0, 303.6628, -0.2124);
	at[21] = 46.8000;
	points[22] = (5160.9844, 2678.7717, 3234.7913);
	angles[22] = (0, 309.2859, -0.3047);
	at[22] = 47.2333;
	points[23] = (5132.4409, 2668.7559, 3234.7795);
	angles[23] = (0, 446.6045, -0.3938);
	at[23] = 47.4500;
	points[24] = (5089.2915, 2649.5630, 3234.8149);
	angles[24] = (0, 472.6661, 0.0226);
	at[24] = 47.6667;
	points[25] = (5002.6772, 2609.5867, 3234.9014);
	angles[25] = (0, 474.9899, 0.0522);
	at[25] = 48.1167;
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
	points[0] = (6201.0630, 3803.0552, 3233.2441);
	angles[0] = (0, 123.8131, -0.0172);
	at[0] = 0;
	points[1] = (6048.8975, 3697.5708, 3233.2522);
	angles[1] = (0, 125.5831, 0.0394);
	at[1] = 0.8667;
	points[2] = (6032.6382, 3685.6772, 3233.2795);
	angles[2] = (0, 126.4634, 0.0917);
	at[2] = 1.0833;
	points[3] = (5713.0708, 3436, 3234.3152);
	angles[3] = (0, 129.0084, 0.1114);
	at[3] = 8.6667;
	points[4] = (5697.1260, 3422.9370, 3234.3464);
	angles[4] = (0, 129.4834, 0.0714);
	at[4] = 9.1000;
	points[5] = (5467.8740, 3227.9763, 3234.3899);
	angles[5] = (0, 131.6960, -0.0056);
	at[5] = 14.7333;
	points[6] = (5433.3857, 3195.9646, 3234.3857);
	angles[6] = (0, 134.4962, 0);
	at[6] = 15.6000;
	points[7] = (5425.2759, 3187.0867, 3234.3899);
	angles[7] = (0, 139.3542, 0.0121);
	at[7] = 15.8167;
	points[8] = (5429.9609, 3185.7166, 3234.4016);
	angles[8] = (0, 256.9664, 0.1518);
	at[8] = 16.0333;
	points[9] = (5440.2363, 3190.0239, 3234.4172);
	angles[9] = (0, 291.6086, 0.0747);
	at[9] = 16.2500;
	points[10] = (5451.7324, 3195.4016, 3234.4292);
	angles[10] = (0, 295.2109, 0.0635);
	at[10] = 16.4667;
	points[11] = (5665.3940, 3310.6968, 3234.6023);
	angles[11] = (0, 299.6464, 0.0176);
	at[11] = 21.0167;
	points[12] = (5735.5908, 3351.8228, 3234.5945);
	angles[12] = (0, 301.3051, -0.0399);
	at[12] = 22.5333;
	points[13] = (5781.6929, 3382.5747, 3234.4727);
	angles[13] = (0, 305.2639, -0.1787);
	at[13] = 23.6167;
	points[14] = (6068.6226, 3598.3113, 3233.1143);
	angles[14] = (0, 306.8367, -0.1637);
	at[14] = 30.3333;
	points[15] = (6358.2280, 3806.6143, 3233.1299);
	angles[15] = (0, 307.1458, 0.0078);
	at[15] = 37.0500;
	points[16] = (6374.6855, 3819.4607, 3233.1260);
	angles[16] = (0, 308.4221, -0.0185);
	at[16] = 37.4833;
	points[17] = (6579.0156, 3991.0630, 3232.9487);
	angles[17] = (0, 311.7534, -0.0411);
	at[17] = 42.4667;
	points[18] = (6604.7241, 4015, 3232.9253);
	angles[18] = (0, 314.3807, -0.0375);
	at[18] = 43.1167;
	points[19] = (6612.6772, 4023.7009, 3232.9172);
	angles[19] = (0, 319.2180, -0.0293);
	at[19] = 43.3333;
	points[20] = (6607.5591, 4025.3938, 3232.9292);
	angles[20] = (0, 436.1447, 0.1066);
	at[20] = 43.5500;
	points[21] = (6597.4805, 4021.4963, 3232.9448);
	angles[21] = (0, 469.9044, 0.0761);
	at[21] = 43.7667;
	points[22] = (6585.7876, 4016.4565, 3232.9607);
	angles[22] = (0, 473.5694, 0.0707);
	at[22] = 43.9833;
	points[23] = (6554.6460, 4001.9292, 3233);
	angles[23] = (0, 475.5286, 0.0670);
	at[23] = 44.6333;
	points[24] = (6410.3940, 3928.9685, 3233.1772);
	angles[24] = (0, 477.6239, 0.0586);
	at[24] = 47.6667;
	points[25] = (6317.3232, 3878.3938, 3233.2678);
	angles[25] = (0, 480.1656, 0.0310);
	at[25] = 49.6167;
	points[26] = (6201.0630, 3803.0552, 3233.2441);
	angles[26] = (0, 483.8131, -0.0172);
	at[26] = 50.2667;
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
	points[0] = (-2239.1812, 4909.8818, 3232.0591);
	angles[0] = (0, -173.1945, 0.0770);
	at[0] = 0;
	points[1] = (-2226.5552, 4836.2993, 3232.1614);
	angles[1] = (0, -169.8744, 0.0807);
	at[1] = 0.3500;
	points[2] = (-2223.5945, 4820.4331, 3232.1853);
	angles[2] = (0, -169.2184, 0.0818);
	at[2] = 0.4667;
	points[3] = (-2185.9802, 4662.7163, 3232.4253);
	angles[3] = (0, -165.5952, 0.0854);
	at[3] = 3.5000;
	points[4] = (-2141.1851, 4501.6929, 3232.6694);
	angles[4] = (0, -162.2214, 0.0878);
	at[4] = 6.6500;
	points[5] = (-2130.6692, 4472.9136, 3232.7205);
	angles[5] = (0, -158.5700, 0.0989);
	at[5] = 7.2333;
	points[6] = (-2104.6418, 4409.8428, 3232.8425);
	angles[6] = (0, -157.0657, 0.1035);
	at[6] = 8.5167;
	points[7] = (-2058.5513, 4307.7168, 3233.0435);
	angles[7] = (0, -153.2516, 0.1048);
	at[7] = 10.6167;
	points[8] = (-2048.8425, 4291.0234, 3233.0789);
	angles[8] = (0, -146.3971, 0.1036);
	at[8] = 10.9667;
	points[9] = (-2045.4961, 4290.1182, 3233.0828);
	angles[9] = (0, -93.1650, 0.0457);
	at[9] = 11.0833;
	points[10] = (-2044.1851, 4296.4175, 3233.0750);
	angles[10] = (0, -28.6052, -0.0666);
	at[10] = 11.2000;
	points[11] = (-2043.7047, 4302.7559, 3233.0630);
	angles[11] = (0, -9.0636, -0.0901);
	at[11] = 11.3167;
	points[12] = (-2043.3779, 4315.0396, 3233.0435);
	angles[12] = (0, -1.2693, -0.0965);
	at[12] = 11.5500;
	points[13] = (-2052.2915, 4483.5830, 3232.7559);
	angles[13] = (0, 5.3511, -0.0899);
	at[13] = 14.7000;
	points[14] = (-2067.9448, 4580.7480, 3232.6262);
	angles[14] = (0, 10.4791, -0.0738);
	at[14] = 16.5667;
	points[15] = (-2097.0237, 4713.9370, 3232.4451);
	angles[15] = (0, 15.5917, -0.0780);
	at[15] = 19.1333;
	points[16] = (-2127.0354, 4808.8188, 3232.3110);
	angles[16] = (0, 19.7667, -0.0813);
	at[16] = 21;
	points[17] = (-2141.2441, 4842.4409, 3232.2559);
	angles[17] = (0, 27.0615, -0.0883);
	at[17] = 21.7000;
	points[18] = (-2154.1338, 4863.7402, 3232.2126);
	angles[18] = (0, 32.3105, -0.0935);
	at[18] = 22.1667;
	points[19] = (-2192.7205, 4920.4331, 3232.1023);
	angles[19] = (0, 35.4051, -0.0954);
	at[19] = 23.4500;
	points[20] = (-2222.4214, 4960.3149, 3232.0159);
	angles[20] = (0, 37.9858, -0.0961);
	at[20] = 24.3833;
	points[21] = (-2238.7913, 4979.4487, 3231.9766);
	angles[21] = (0, 43.2437, -0.0964);
	at[21] = 24.8500;
	points[22] = (-2243.7756, 4983.5435, 3231.9648);
	angles[22] = (0, 52.1224, -0.0949);
	at[22] = 24.9667;
	points[23] = (-2246.6299, 4969.6455, 3231.9766);
	angles[23] = (0, 125.2598, -0.0139);
	at[23] = 25.0833;
	points[24] = (-2244.2520, 4945.2759, 3232.0120);
	angles[24] = (0, 172.6363, 0.0605);
	at[24] = 25.2000;
	points[25] = (-2240.8071, 4920.4727, 3232.0435);
	angles[25] = (0, 184.9007, 0.0750);
	at[25] = 25.3167;
	points[26] = (-2239.1812, 4909.8818, 3232.0591);
	angles[26] = (0, 186.8055, 0.0770);
	at[26] = 25.3667;
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
