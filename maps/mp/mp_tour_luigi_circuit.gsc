main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_tour_luigi_circuit", 0);

	setExpFog(0.0295, 12303.1758, 0.1490, 0.2196, 0.4667, 0);

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
	ambientPlay("iz_0_tlc", 2);
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
	level.iz_route[level.iz_route.size] = (5154, -70, 263);
	level.iz_route[level.iz_route.size] = (5160, -991, 262);
	level.iz_route[level.iz_route.size] = (4957, -1756, 262);
	level.iz_route[level.iz_route.size] = (4475, -2487, 262);
	level.iz_route[level.iz_route.size] = (3752, -3022, 262);
	level.iz_route[level.iz_route.size] = (3041, -3316, 262);
	level.iz_route[level.iz_route.size] = (2392, -3817, 262);
	level.iz_route[level.iz_route.size] = (1922, -4576, 264);
	level.iz_route[level.iz_route.size] = (1669, -5457, 281);
	level.iz_route[level.iz_route.size] = (1607, -6135, 300);
	level.iz_route[level.iz_route.size] = (1221, -6807, 313);
	level.iz_route[level.iz_route.size] = (527, -7091, 312);
	level.iz_route[level.iz_route.size] = (-221, -6785, 295);
	level.iz_route[level.iz_route.size] = (-567, -6110, 279);
	level.iz_route[level.iz_route.size] = (-592, -5278, 269);
	level.iz_route[level.iz_route.size] = (-592, -4621, 268);
	level.iz_route[level.iz_route.size] = (-740, -4001, 271);
	level.iz_route[level.iz_route.size] = (-1124, -3597, 270);
	level.iz_route[level.iz_route.size] = (-1677, -3457, 265);
	level.iz_route[level.iz_route.size] = (-2452, -3564, 263);
	level.iz_route[level.iz_route.size] = (-3340, -3706, 265);
	level.iz_route[level.iz_route.size] = (-4209, -3855, 267);
	level.iz_route[level.iz_route.size] = (-4932, -4000, 273);
	level.iz_route[level.iz_route.size] = (-5457, -4036, 277);
	level.iz_route[level.iz_route.size] = (-5911, -3780, 277);
	level.iz_route[level.iz_route.size] = (-6131, -3378, 275);
	level.iz_route[level.iz_route.size] = (-6054, -2959, 269);
	level.iz_route[level.iz_route.size] = (-5828, -2707, 265);
	level.iz_route[level.iz_route.size] = (-5287, -2346, 262);
	level.iz_route[level.iz_route.size] = (-4630, -1949, 265);
	level.iz_route[level.iz_route.size] = (-4012, -1533, 267);
	level.iz_route[level.iz_route.size] = (-3461, -1134, 268);
	level.iz_route[level.iz_route.size] = (-3105, -555, 271);
	level.iz_route[level.iz_route.size] = (-2988, 48, 279);
	level.iz_route[level.iz_route.size] = (-3163, 701, 293);
	level.iz_route[level.iz_route.size] = (-3495, 1126, 309);
	level.iz_route[level.iz_route.size] = (-3931, 1579, 335);
	level.iz_route[level.iz_route.size] = (-5189, 2884, 411);
	level.iz_route[level.iz_route.size] = (-6727, 4458, 567);
	level.iz_route[level.iz_route.size] = (-7630, 5414, 709);
	level.iz_route[level.iz_route.size] = (-7968, 5879, 803);
	level.iz_route[level.iz_route.size] = (-7972, 6345, 865);
	level.iz_route[level.iz_route.size] = (-7736, 6795, 894);
	level.iz_route[level.iz_route.size] = (-7314, 6994, 867);
	level.iz_route[level.iz_route.size] = (-6864, 6961, 810);
	level.iz_route[level.iz_route.size] = (-6522, 6814, 755);
	level.iz_route[level.iz_route.size] = (-5869, 6454, 644);
	level.iz_route[level.iz_route.size] = (-4972, 5934, 577);
	level.iz_route[level.iz_route.size] = (-3961, 5335, 524);
	level.iz_route[level.iz_route.size] = (-3206, 4888, 258);
	level.iz_route[level.iz_route.size] = (-2269, 4278, 258);
	level.iz_route[level.iz_route.size] = (-1391, 3715, 258);
	level.iz_route[level.iz_route.size] = (-565, 3426, 258);
	level.iz_route[level.iz_route.size] = (146, 3077, 258);
	level.iz_route[level.iz_route.size] = (736, 2459, 256);
	level.iz_route[level.iz_route.size] = (1129, 2105, 270);
	level.iz_route[level.iz_route.size] = (1610, 1861, 290);
	level.iz_route[level.iz_route.size] = (2052, 1889, 296);
	level.iz_route[level.iz_route.size] = (2458, 2164, 294);
	level.iz_route[level.iz_route.size] = (2703, 2507, 294);
	level.iz_route[level.iz_route.size] = (2802, 2940, 303);
	level.iz_route[level.iz_route.size] = (2809, 3564, 333);
	level.iz_route[level.iz_route.size] = (2812, 4306, 383);
	level.iz_route[level.iz_route.size] = (2820, 4894, 428);
	level.iz_route[level.iz_route.size] = (3016, 5442, 484);
	level.iz_route[level.iz_route.size] = (3394, 5796, 524);
	level.iz_route[level.iz_route.size] = (3907, 5972, 548);
	level.iz_route[level.iz_route.size] = (4450, 5883, 541);
	level.iz_route[level.iz_route.size] = (4882, 5571, 508);
	level.iz_route[level.iz_route.size] = (5097, 5090, 455);
	level.iz_route[level.iz_route.size] = (5151, 4279, 398);
	level.iz_route[level.iz_route.size] = (5148, 3351, 412);
	level.iz_route[level.iz_route.size] = (5137, 2309, 412);
	level.iz_route[level.iz_route.size] = (5149, 1216, 264);
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
	points[0] = (-10832.7168, -6921.8506, 4247.8345);
	angles[0] = (0, -145.9439, 0);
	at[0] = 0;
	points[1] = (-10710.2754, -7061.9683, 4247.8345);
	angles[1] = (0, -140.4651, 0);
	at[1] = 0.5000;
	points[2] = (-10588.1494, -7202.2837, 4247.8345);
	angles[2] = (0, -139.2875, 0);
	at[2] = 1;
	points[3] = (-9000.5117, -9026.4170, 4247.8345);
	angles[3] = (0, -138.9656, 0);
	at[3] = 7.5000;
	points[4] = (-8865.9844, -9152.9922, 4247.8345);
	angles[4] = (0, -132.1899, 0);
	at[4] = 8;
	points[5] = (-8713.6221, -9259.6855, 4247.8345);
	angles[5] = (0, -126.5395, 0);
	at[5] = 8.5000;
	points[6] = (-8561.2207, -9366.3389, 4247.8345);
	angles[6] = (0, -125.3248, 0);
	at[6] = 9;
	points[7] = (-7037.2441, -10433.1504, 4247.8345);
	angles[7] = (0, -124.9928, 0);
	at[7] = 14;
	points[8] = (-6882.6777, -10535.7090, 4247.8345);
	angles[8] = (0, -122.4317, 0);
	at[8] = 14.5000;
	points[9] = (-6709.0942, -10602.6387, 4247.8345);
	angles[9] = (0, -113.5336, 0);
	at[9] = 15;
	points[10] = (-6535.5513, -10669.6064, 4247.8345);
	angles[10] = (0, -111.6168, 0);
	at[10] = 15.5000;
	points[11] = (-4105.7090, -11606.8506, 4247.8345);
	angles[11] = (0, -111.0929, 0);
	at[11] = 22.5000;
	points[12] = (-3923.3503, -11635.7480, 4247.8345);
	angles[12] = (0, -99.9318, 0);
	at[12] = 23;
	points[13] = (-3738.0198, -11651.7324, 4247.8345);
	angles[13] = (0, -96.0115, 0);
	at[13] = 23.5000;
	points[14] = (-772.6890, -11908.0312, 4247.8345);
	angles[14] = (0, -94.3169, 0);
	at[14] = 31.5000;
	points[15] = (-588.3189, -11882.4805, 4247.8345);
	angles[15] = (0, -84.9700, 0);
	at[15] = 32;
	points[16] = (-403.9291, -11857.9141, 4247.8345);
	angles[16] = (0, -82.9558, 0);
	at[16] = 32.5000;
	points[17] = (2177.5474, -11513.7012, 4247.8345);
	angles[17] = (0, -82.4051, 0);
	at[17] = 39.5000;
	points[18] = (2358.5708, -11473.5820, 4247.8345);
	angles[18] = (0, -77.2152, 0);
	at[18] = 40;
	points[19] = (2714.5945, -11365.5908, 4247.8345);
	angles[19] = (0, -73.3118, 0);
	at[19] = 41;
	points[20] = (5740.8267, -10447.4805, 4247.8345);
	angles[20] = (0, -73.1232, 0);
	at[20] = 49.5000;
	points[21] = (5911.7324, -10379.2920, 4247.8345);
	angles[21] = (0, -66.6308, 0);
	at[21] = 50;
	points[22] = (6061.5356, -10269.0166, 4247.8345);
	angles[22] = (0, -56.4402, 0);
	at[22] = 50.5000;
	points[23] = (6211.3389, -10158.7412, 4247.8345);
	angles[23] = (0, -54.2424, 0);
	at[23] = 51;
	points[24] = (8758.0713, -8283.9766, 4247.8345);
	angles[24] = (0, -53.6417, 0);
	at[24] = 59.5000;
	points[25] = (8877.1260, -8143.1108, 4247.8345);
	angles[25] = (0, -41.4760, 0);
	at[25] = 60;
	points[26] = (8986.5352, -7992.6377, 4247.8345);
	angles[26] = (0, -37.1963, 0);
	at[26] = 60.5000;
	points[27] = (10408.8584, -6036.8115, 4247.8345);
	angles[27] = (0, -36.0257, 0);
	at[27] = 67;
	points[28] = (10487.7168, -5868.6221, 4247.8345);
	angles[28] = (0, -27.0148, 0);
	at[28] = 67.5000;
	points[29] = (10564.4893, -5699.1733, 4247.8345);
	angles[29] = (0, -24.9411, 0);
	at[29] = 68;
	points[30] = (11562.5195, -3496.3896, 4247.8345);
	angles[30] = (0, -24.3743, 0);
	at[30] = 74.5000;
	points[31] = (11622.9922, -3321, 4247.8345);
	angles[31] = (0, -18.9967, 0);
	at[31] = 75;
	points[32] = (11723.8584, -2962.8860, 4247.8345);
	angles[32] = (0, -15.8801, 0);
	at[32] = 76;
	points[33] = (12379.4482, -635.1496, 4247.8345);
	angles[33] = (0, -15.7296, 0);
	at[33] = 82.5000;
	points[34] = (12411.1807, -452.7008, 4247.8345);
	angles[34] = (0, -9.3967, 0);
	at[34] = 83;
	points[35] = (12442.5205, -81.9748, 4247.8345);
	angles[35] = (0, -5.0387, 0);
	at[35] = 84;
	points[36] = (12646.0625, 2327.7559, 4247.8345);
	angles[36] = (0, -4.4611, 0);
	at[36] = 90.5000;
	points[37] = (12637.7559, 2513.6025, 4247.8345);
	angles[37] = (0, 1.0266, 0);
	at[37] = 91;
	points[38] = (12629.5283, 2699.4451, 4247.8345);
	angles[38] = (0, 2.2061, 0);
	at[38] = 91.5000;
	points[39] = (12531.0635, 4929.5669, 4247.8345);
	angles[39] = (0, 2.5285, 0);
	at[39] = 97.5000;
	points[40] = (12516.6143, 5114.4883, 4247.8345);
	angles[40] = (0, 5.1574, 0);
	at[40] = 98;
	points[41] = (12470.9844, 5294.8423, 4247.8345);
	angles[41] = (0, 12.2561, 0);
	at[41] = 98.5000;
	points[42] = (12425.3545, 5475.1577, 4247.8345);
	angles[42] = (0, 13.7833, 0);
	at[42] = 99;
	points[43] = (11695.1973, 8360.6299, 4247.8345);
	angles[43] = (0, 14.2008, 0);
	at[43] = 107;
	points[44] = (11618.7803, 8526.8506, 4247.8345);
	angles[44] = (0, 25.8115, 0);
	at[44] = 107.5000;
	points[45] = (11511.8906, 8679.0947, 4247.8345);
	angles[45] = (0, 33.0833, 0);
	at[45] = 108;
	points[46] = (11404.9609, 8831.3389, 4247.8345);
	angles[46] = (0, 34.6478, 0);
	at[46] = 108.5000;
	points[47] = (10335.9844, 10353.7393, 4247.8345);
	angles[47] = (0, 35.0755, 0);
	at[47] = 113.5000;
	points[48] = (10185.5117, 10462.7959, 4247.8345);
	angles[48] = (0, 50.2036, 0);
	at[48] = 114;
	points[49] = (10034.2920, 10571.1416, 4247.8345);
	angles[49] = (0, 53.4852, 0);
	at[49] = 114.5000;
	points[50] = (7614.6851, 12304.4883, 4247.8345);
	angles[50] = (0, 55.0555, 0);
	at[50] = 122.5000;
	points[51] = (7441.9292, 12373.7002, 4247.8345);
	angles[51] = (0, 65.1716, 0);
	at[51] = 123;
	points[52] = (7269.5273, 12443.5439, 4247.8345);
	angles[52] = (0, 67.3533, 0);
	at[52] = 123.5000;
	points[53] = (4510.8662, 13560.9453, 4247.8345);
	angles[53] = (0, 67.9496, 0);
	at[53] = 131.5000;
	points[54] = (4334.1338, 13616.4961, 4247.8345);
	angles[54] = (0, 73.3525, 0);
	at[54] = 132;
	points[55] = (3969.5273, 13690.5508, 4247.8345);
	angles[55] = (0, 78.2774, 0);
	at[55] = 133;
	points[56] = (688.1693, 14357.2451, 4247.8345);
	angles[56] = (0, 78.5155, 0);
	at[56] = 142;
	points[57] = (502.7402, 14361.6543, 4247.8345);
	angles[57] = (0, 87.3394, 0);
	at[57] = 142.5000;
	points[58] = (316.7224, 14360, 4247.8345);
	angles[58] = (0, 89.8293, 0);
	at[58] = 143;
	points[59] = (-3217.6104, 14328.5439, 4247.8345);
	angles[59] = (0, 90.5102, 0);
	at[59] = 152.5000;
	points[60] = (-3401.3779, 14300.1182, 4247.8345);
	angles[60] = (0, 97.1437, 0);
	at[60] = 153;
	points[61] = (-3585.0669, 14270.7480, 4247.8345);
	angles[61] = (0, 98.6674, 0);
	at[61] = 153.5000;
	points[62] = (-6707.7954, 13771.4570, 4247.8345);
	angles[62] = (0, 99.0840, 0);
	at[62] = 162;
	points[63] = (-6885.7480, 13718.7402, 4247.8345);
	angles[63] = (0, 105.8114, 0);
	at[63] = 162.5000;
	points[64] = (-7062.0479, 13659.4102, 4247.8345);
	angles[64] = (0, 107.9963, 0);
	at[64] = 163;
	points[65] = (-9530.4336, 12829.0156, 4247.8345);
	angles[65] = (0, 108.5934, 0);
	at[65] = 170;
	points[66] = (-9700.8662, 12757.0469, 4247.8345);
	angles[66] = (0, 114.0151, 0);
	at[66] = 170.5000;
	points[67] = (-9859.9609, 12660.6689, 4247.8345);
	angles[67] = (0, 119.6631, 0);
	at[67] = 171;
	points[68] = (-10019.0547, 12564.2910, 4247.8345);
	angles[68] = (0, 120.8771, 0);
	at[68] = 171.5000;
	points[69] = (-11928.3076, 11407.5986, 4247.8345);
	angles[69] = (0, 121.2090, 0);
	at[69] = 177.5000;
	points[70] = (-12038.6221, 11259.8027, 4247.8345);
	angles[70] = (0, 139.5435, 0);
	at[70] = 178;
	points[71] = (-12143.2285, 11105.9844, 4247.8345);
	angles[71] = (0, 144.4378, 0);
	at[71] = 178.5000;
	points[72] = (-13503.3457, 9106.3779, 4247.8345);
	angles[72] = (0, 145.7767, 0);
	at[72] = 185;
	points[73] = (-13585.1572, 8941.5752, 4247.8345);
	angles[73] = (0, 154.3674, 0);
	at[73] = 185.5000;
	points[74] = (-13640.7090, 8764.0156, 4247.8345);
	angles[74] = (0, 160.8510, 0);
	at[74] = 186;
	points[75] = (-13696.2607, 8586.4961, 4247.8345);
	angles[75] = (0, 162.2453, 0);
	at[75] = 186.5000;
	points[76] = (-14362.7959, 6456.0630, 4247.8345);
	angles[76] = (0, 162.6264, 0);
	at[76] = 192.5000;
	points[77] = (-14399.7637, 6274.5278, 4247.8345);
	angles[77] = (0, 168.8195, 0);
	at[77] = 193;
	points[78] = (-14443.2686, 5905.0396, 4247.8345);
	angles[78] = (0, 173.0807, 0);
	at[78] = 194;
	points[79] = (-14747.7168, 3318.5906, 4247.8345);
	angles[79] = (0, 173.2866, 0);
	at[79] = 201;
	points[80] = (-14761.1426, 3133.6377, 4247.8345);
	angles[80] = (0, 176.8487, 0);
	at[80] = 201.5000;
	points[81] = (-14748.4648, 2948.0474, 4247.8345);
	angles[81] = (0, 182.3854, 0);
	at[81] = 202;
	points[82] = (-14735.8271, 2762.4526, 4247.8345);
	angles[82] = (0, 183.5755, 0);
	at[82] = 202.5000;
	points[83] = (-14571.2988, 349.7433, 4247.8345);
	angles[83] = (0, 183.9008, 0);
	at[83] = 209;
	points[84] = (-14538.8584, 167.6280, 4247.8345);
	angles[84] = (0, 190.6921, 0);
	at[84] = 209.5000;
	points[85] = (-14435.9854, -189.9032, 4247.8345);
	angles[85] = (0, 195.8104, 0);
	at[85] = 210.5000;
	points[86] = (-13818.5039, -2335.0828, 4247.8345);
	angles[86] = (0, 196.0577, 0);
	at[86] = 216.5000;
	points[87] = (-13740.1973, -2501.5828, 4247.8345);
	angles[87] = (0, 205.9076, 0);
	at[87] = 217;
	points[88] = (-13638.7412, -2657.5002, 4247.8345);
	angles[88] = (0, 211.5182, 0);
	at[88] = 217.5000;
	points[89] = (-13537.2832, -2813.4175, 4247.8345);
	angles[89] = (0, 212.7244, 0);
	at[89] = 218;
	points[90] = (-12218.2676, -4840.3149, 4247.8345);
	angles[90] = (0, 213.0540, 0);
	at[90] = 224.5000;
	points[91] = (-10832.7168, -6921.8506, 4247.8345);
	angles[91] = (0, 214.0561, 0);
	at[91] = 231.2170;
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
