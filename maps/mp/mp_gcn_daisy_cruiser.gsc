main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_gcn_daisy_cruiser", 0);

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
	ambientPlay("iz_0_62", 2);
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
	level.iz_route[level.iz_route.size] = (-741, 1410, 2699);
	level.iz_route[level.iz_route.size] = (-1449, 432, 2740);
	level.iz_route[level.iz_route.size] = (-1765, -399, 2799);
	level.iz_route[level.iz_route.size] = (-1761, -1322, 2799);
	level.iz_route[level.iz_route.size] = (-1714, -2891, 2799);
	level.iz_route[level.iz_route.size] = (-1728, -3751, 2799);
	level.iz_route[level.iz_route.size] = (-1613, -4319, 2787);
	level.iz_route[level.iz_route.size] = (-899, -4847, 2533);
	level.iz_route[level.iz_route.size] = (-280, -5088, 2533);
	level.iz_route[level.iz_route.size] = (95, -5202, 2533);
	level.iz_route[level.iz_route.size] = (107, -5739, 2533);
	level.iz_route[level.iz_route.size] = (550, -6026, 2533);
	level.iz_route[level.iz_route.size] = (1008, -6681, 2533);
	level.iz_route[level.iz_route.size] = (1015, -7397, 2533);
	level.iz_route[level.iz_route.size] = (637, -8148, 2533);
	level.iz_route[level.iz_route.size] = (-288, -8658, 2533);
	level.iz_route[level.iz_route.size] = (-1019, -8782, 2533);
	level.iz_route[level.iz_route.size] = (-1386, -8941, 2533);
	level.iz_route[level.iz_route.size] = (-1533, -9740, 2442);
	level.iz_route[level.iz_route.size] = (-1307, -10447, 2299);
	level.iz_route[level.iz_route.size] = (-928, -11107, 2153);
	level.iz_route[level.iz_route.size] = (-192, -11595, 1983);
	level.iz_route[level.iz_route.size] = (868, -11636, 1868);
	level.iz_route[level.iz_route.size] = (1433, -11164, 1868);
	level.iz_route[level.iz_route.size] = (1711, -10318, 1868);
	level.iz_route[level.iz_route.size] = (1821, -9275, 1876);
	level.iz_route[level.iz_route.size] = (1840, -7477, 1868);
	level.iz_route[level.iz_route.size] = (1830, -6052, 1868);
	level.iz_route[level.iz_route.size] = (1454, -4928, 1862);
	level.iz_route[level.iz_route.size] = (290, -3683, 1862);
	level.iz_route[level.iz_route.size] = (-250, -2316, 1862);
	level.iz_route[level.iz_route.size] = (-1159, -1299, 1862);
	level.iz_route[level.iz_route.size] = (-1386, -479, 1864);
	level.iz_route[level.iz_route.size] = (-1381, -127, 1866);
	level.iz_route[level.iz_route.size] = (-1314, 121, 1867);
	level.iz_route[level.iz_route.size] = (-1099, 238, 1868);
	level.iz_route[level.iz_route.size] = (-632, 246, 1868);
	level.iz_route[level.iz_route.size] = (400, 278, 1868);
	level.iz_route[level.iz_route.size] = (847, 461, 1868);
	level.iz_route[level.iz_route.size] = (963, 868, 1868);
	level.iz_route[level.iz_route.size] = (959, 1661, 1868);
	level.iz_route[level.iz_route.size] = (787, 3208, 1868);
	level.iz_route[level.iz_route.size] = (848, 3761, 1868);
	level.iz_route[level.iz_route.size] = (626, 3942, 1868);
	level.iz_route[level.iz_route.size] = (312, 4068, 1868);
	level.iz_route[level.iz_route.size] = (-276, 3985, 1868);
	level.iz_route[level.iz_route.size] = (-964, 4028, 1868);
	level.iz_route[level.iz_route.size] = (-1323, 4178, 1868);
	level.iz_route[level.iz_route.size] = (-1423, 4505, 1896);
	level.iz_route[level.iz_route.size] = (-1423, 5209, 1964);
	level.iz_route[level.iz_route.size] = (-1505, 6499, 2118);
	level.iz_route[level.iz_route.size] = (-1864, 6546, 2118);
	level.iz_route[level.iz_route.size] = (-2017, 6975, 2125);
	level.iz_route[level.iz_route.size] = (-2106, 8515, 2118);
	level.iz_route[level.iz_route.size] = (-1644, 9292, 2118);
	level.iz_route[level.iz_route.size] = (-1358, 11211, 2118);
	level.iz_route[level.iz_route.size] = (-919, 12103, 2118);
	level.iz_route[level.iz_route.size] = (-266, 12402, 2118);
	level.iz_route[level.iz_route.size] = (282, 12389, 2118);
	level.iz_route[level.iz_route.size] = (1016, 11985, 2118);
	level.iz_route[level.iz_route.size] = (1422, 11131, 2118);
	level.iz_route[level.iz_route.size] = (1368, 9901, 2118);
	level.iz_route[level.iz_route.size] = (1344, 8927, 2320);
	level.iz_route[level.iz_route.size] = (1344, 7288, 2699);
	level.iz_route[level.iz_route.size] = (1240, 6152, 2699);
	level.iz_route[level.iz_route.size] = (924, 5538, 2699);
	level.iz_route[level.iz_route.size] = (351, 5311, 2699);
	level.iz_route[level.iz_route.size] = (4, 4164, 2699);
	level.iz_route[level.iz_route.size] = (-21, 4027, 2699);
	level.iz_route[level.iz_route.size] = (-11, 3675, 2706);
	level.iz_route[level.iz_route.size] = (-14, 2923, 2703);
	level.iz_route[level.iz_route.size] = (-18, 2042, 2699);
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
	points[0] = (502.8662, 3254.8821, 1009.8425);
	angles[0] = (0, 88.3597, 0);
	at[0] = 0;
	points[1] = (593.2480, 3247.2322, 1009.8425);
	angles[1] = (0, 104.2299, 0);
	at[1] = 0.2333;
	points[2] = (683.5670, 3256.7561, 1009.8425);
	angles[2] = (0, 138.8659, 0);
	at[2] = 0.4667;
	points[3] = (768.4213, 3289.5354, 1009.8425);
	angles[3] = (0, 214.7968, 0);
	at[3] = 0.7000;
	points[4] = (842.7796, 3341.5393, 1009.8425);
	angles[4] = (0, 281.6703, 0);
	at[4] = 0.9333;
	points[5] = (891.6457, 3417.3071, 1009.8425);
	angles[5] = (0, 318.8872, 0);
	at[5] = 1.1667;
	points[6] = (917.9094, 3504.1692, 1009.8425);
	angles[6] = (0, 338.6479, 0);
	at[6] = 1.4000;
	points[7] = (932.6772, 3593.6182, 1009.8425);
	angles[7] = (0, 349.1432, 0);
	at[7] = 1.6333;
	points[8] = (936.7363, 3684.3701, 1009.8425);
	angles[8] = (0, 356.3323, 0);
	at[8] = 1.8667;
	points[9] = (929.3544, 3775.2363, 1009.8425);
	angles[9] = (0, 363.2821, 0);
	at[9] = 2.1000;
	points[10] = (913.1535, 3864.0908, 1009.8425);
	angles[10] = (0, 369.2600, 0);
	at[10] = 2.3333;
	points[11] = (872.6221, 4042.4412, 1009.8425);
	angles[11] = (0, 373.1133, 0);
	at[11] = 2.8000;
	points[12] = (845.7914, 4128.4644, 1009.8425);
	angles[12] = (0, 377.0721, 0);
	at[12] = 3.0333;
	points[13] = (779.2205, 4298.0708, 1009.8425);
	angles[13] = (0, 381.9691, 0);
	at[13] = 3.5000;
	points[14] = (737.9922, 4378.6221, 1009.8425);
	angles[14] = (0, 386.9014, 0);
	at[14] = 3.7333;
	points[15] = (639.9095, 4532.4019, 1009.8425);
	angles[15] = (0, 392.9943, 0);
	at[15] = 4.2000;
	points[16] = (585.3425, 4604.1733, 1009.8425);
	angles[16] = (0, 397.4584, 0);
	at[16] = 4.4333;
	points[17] = (519.2362, 4667.3232, 1009.8425);
	angles[17] = (0, 404.7717, 0);
	at[17] = 4.6667;
	points[18] = (450.1378, 4726.6538, 1009.8425);
	angles[18] = (0, 408.6063, 0);
	at[18] = 4.9000;
	points[19] = (376.5665, 4779.1338, 1009.8425);
	angles[19] = (0, 414.7560, 0);
	at[19] = 5.1333;
	points[20] = (292.5036, 4814.3306, 1009.8425);
	angles[20] = (0, 424.9897, 0);
	at[20] = 5.3667;
	points[21] = (120.3976, 4873.1104, 1009.8425);
	angles[21] = (0, 431.9316, 0);
	at[21] = 5.8333;
	points[22] = (31.6990, 4894.4883, 1009.8425);
	angles[22] = (0, 435.9739, 0);
	at[22] = 6.0667;
	points[23] = (-58.5469, 4903.7798, 1009.8425);
	angles[23] = (0, 442.7612, 0);
	at[23] = 6.3000;
	points[24] = (-149.2496, 4907.1655, 1009.8425);
	angles[24] = (0, 447.2916, 0);
	at[24] = 6.5333;
	points[25] = (-239.9098, 4904.3306, 1009.8425);
	angles[25] = (0, 451.4957, 0);
	at[25] = 6.7667;
	points[26] = (-330.5295, 4892.2046, 1009.8425);
	angles[26] = (0, 456.6406, 0);
	at[26] = 7;
	points[27] = (-417.8622, 4867.6772, 1009.8425);
	angles[27] = (0, 464.4342, 0);
	at[27] = 7.2333;
	points[28] = (-500.5197, 4830.5513, 1009.8425);
	angles[28] = (0, 473.3728, 0);
	at[28] = 7.4667;
	points[29] = (-575.7598, 4780.0396, 1009.8425);
	angles[29] = (0, 483.3414, 0);
	at[29] = 7.7000;
	points[30] = (-635.1732, 4712.1260, 1009.8425);
	angles[30] = (0, 498.3604, 0);
	at[30] = 7.9333;
	points[31] = (-655.1260, 4623.5435, 1009.8425);
	angles[31] = (0, 522.1965, 0);
	at[31] = 8.1667;
	points[32] = (-638.0039, 4535.6299, 1009.8425);
	angles[32] = (0, 547.6927, 0);
	at[32] = 8.4000;
	points[33] = (-629.9094, 4512.0474, 1009.8425);
	angles[33] = (0, 555.9192, 0);
	at[33] = 8.6333;
	points[34] = (-566.1339, 4447.5200, 1009.8425);
	angles[34] = (0, 578.0347, 0);
	at[34] = 8.8667;
	points[35] = (-503.5905, 4384.7637, 1009.8425);
	angles[35] = (0, 583.3425, 0);
	at[35] = 9.1000;
	points[36] = (-372.6276, 4253.6616, 1009.8425);
	angles[36] = (0, 584.8893, 0);
	at[36] = 9.5667;
	points[37] = (208.9976, 3671.6377, 1009.8425);
	angles[37] = (0, 584.9447, 0);
	at[37] = 11.6667;
	points[38] = (270.9169, 3609.5276, 1009.8425);
	angles[38] = (0, 584.9145, 0);
	at[38] = 11.9000;
	points[39] = (337.8445, 3542.2598, 1009.8425);
	angles[39] = (0, 584.8569, 0);
	at[39] = 12.1333;
	points[40] = (402.1339, 3477.2639, 1009.8425);
	angles[40] = (0, 584.6801, 0);
	at[40] = 12.3667;
	points[41] = (461.7795, 3413.5198, 1009.8425);
	angles[41] = (0, 582.9850, 0);
	at[41] = 12.6000;
	points[42] = (478.5591, 3339.5396, 1009.8425);
	angles[42] = (0, 560.7777, 0);
	at[42] = 12.8333;
	points[43] = (485.4764, 3249.2166, 1009.8425);
	angles[43] = (0, 546.1908, 0);
	at[43] = 13.0667;
	points[44] = (463.3859, 3161.4568, 1009.8425);
	angles[44] = (0, 528.4220, 0);
	at[44] = 13.3000;
	points[45] = (409.3583, 3089.6221, 1009.8425);
	angles[45] = (0, 505.4872, 0);
	at[45] = 13.5333;
	points[46] = (327.8417, 3051.5317, 1009.8425);
	angles[46] = (0, 479.1107, 0);
	at[46] = 13.7667;
	points[47] = (238.4965, 3035.7520, 1009.8425);
	angles[47] = (0, 463.3297, 0);
	at[47] = 14;
	points[48] = (147.9252, 3034.2952, 1009.8425);
	angles[48] = (0, 452.7614, 0);
	at[48] = 14.2333;
	points[49] = (56.7295, 3038.8149, 1009.8425);
	angles[49] = (0, 448.2784, 0);
	at[49] = 14.4667;
	points[50] = (-33.0585, 3047.6929, 1009.8425);
	angles[50] = (0, 444.6278, 0);
	at[50] = 14.7000;
	points[51] = (-213.6343, 3076.0750, 1009.8425);
	angles[51] = (0, 440.8951, 0);
	at[51] = 15.1667;
	points[52] = (-303.5449, 3093.2363, 1009.8425);
	angles[52] = (0, 439.2314, 0);
	at[52] = 15.4000;
	points[53] = (-389.7165, 3119.2363, 1009.8425);
	angles[53] = (0, 434.0276, 0);
	at[53] = 15.6333;
	points[54] = (-475.4370, 3149.8545, 1009.8425);
	angles[54] = (0, 430.9716, 0);
	at[54] = 15.8667;
	points[55] = (-560.1496, 3183.8545, 1009.8425);
	angles[55] = (0, 428.3859, 0);
	at[55] = 16.1000;
	points[56] = (-638.8544, 3227.3623, 1009.8425);
	angles[56] = (0, 421.8020, 0);
	at[56] = 16.3333;
	points[57] = (-791.1024, 3328.5825, 1009.8425);
	angles[57] = (0, 416.0698, 0);
	at[57] = 16.8000;
	points[58] = (-863.2874, 3382.9490, 1009.8425);
	angles[58] = (0, 412.9110, 0);
	at[58] = 17.0333;
	points[59] = (-929.2875, 3445.5750, 1009.8425);
	angles[59] = (0, 407.5610, 0);
	at[59] = 17.2667;
	points[60] = (-992.1890, 3511.7361, 1009.8425);
	angles[60] = (0, 404.0936, 0);
	at[60] = 17.5000;
	points[61] = (-1044.7520, 3584.8936, 1009.8425);
	angles[61] = (0, 395.9543, 0);
	at[61] = 17.7333;
	points[62] = (-1087.0394, 3665.8113, 1009.8425);
	angles[62] = (0, 389.1367, 0);
	at[62] = 17.9667;
	points[63] = (-1124.6143, 3749.2085, 1009.8425);
	angles[63] = (0, 384.7636, 0);
	at[63] = 18.2000;
	points[64] = (-1146.4135, 3836.5630, 1009.8425);
	angles[64] = (0, 375.5895, 0);
	at[64] = 18.4333;
	points[65] = (-1162.5236, 3926.4055, 1009.8425);
	angles[65] = (0, 371.1931, 0);
	at[65] = 18.6667;
	points[66] = (-1173.5787, 4016.4172, 1009.8425);
	angles[66] = (0, 367.0049, 0);
	at[66] = 18.9000;
	points[67] = (-1173.3701, 4107.4409, 1009.8425);
	angles[67] = (0, 361.1040, 0);
	at[67] = 19.1333;
	points[68] = (-1168.6221, 4197.9136, 1009.8425);
	angles[68] = (0, 357.6239, 0);
	at[68] = 19.3667;
	points[69] = (-1161.1693, 4289.0552, 1009.8425);
	angles[69] = (0, 355.7027, 0);
	at[69] = 19.6000;
	points[70] = (-1146.4882, 4378.2676, 1009.8425);
	angles[70] = (0, 349.8828, 0);
	at[70] = 19.8333;
	points[71] = (-1107.4764, 4460.5117, 1009.8425);
	angles[71] = (0, 337.0812, 0);
	at[71] = 20.0667;
	points[72] = (-1052.9253, 4533.1104, 1009.8425);
	angles[72] = (0, 325.2969, 0);
	at[72] = 20.3000;
	points[73] = (-984.7480, 4592.2832, 1009.8425);
	angles[73] = (0, 311.9618, 0);
	at[73] = 20.5333;
	points[74] = (-904.0040, 4632.8740, 1009.8425);
	angles[74] = (0, 297.9934, 0);
	at[74] = 20.7667;
	points[75] = (-815.3543, 4655.3940, 1009.8425);
	angles[75] = (0, 286.8110, 0);
	at[75] = 21;
	points[76] = (-724.7559, 4660.5903, 1009.8425);
	angles[76] = (0, 275.4263, 0);
	at[76] = 21.2333;
	points[77] = (-690.8307, 4684.0942, 1009.8425);
	angles[77] = (0, 301.4656, 0);
	at[77] = 21.4667;
	points[78] = (-643.0354, 4636.9688, 1009.8425);
	angles[78] = (0, 247.5504, 0);
	at[78] = 21.7000;
	points[79] = (-584.4685, 4565.5513, 1009.8425);
	angles[79] = (0, 225.8729, 0);
	at[79] = 21.9333;
	points[80] = (-529.5236, 4498.0708, 1009.8425);
	angles[80] = (0, 220.6960, 0);
	at[80] = 22.1667;
	points[81] = (391.9240, 3361.9058, 1009.8425);
	angles[81] = (0, 219.0354, 0);
	at[81] = 25.9000;
	points[82] = (448.0709, 3292.6890, 1009.8425);
	angles[82] = (0, 219.0477, 0);
	at[82] = 26.1333;
	points[83] = (414.8661, 3333.6179, 1009.8425);
	angles[83] = (0, 219.0330, 0);
	at[83] = 26.3667;
	points[84] = (355.3154, 3407.0552, 1009.8425);
	angles[84] = (0, 218.9984, 0);
	at[84] = 26.6000;
	points[85] = (299.4697, 3475.9412, 1009.8425);
	angles[85] = (0, 218.8575, 0);
	at[85] = 26.8333;
	points[86] = (240.5579, 3548.6221, 1009.8425);
	angles[86] = (0, 218.1466, 0);
	at[86] = 27.0667;
	points[87] = (184.2307, 3618.1221, 1009.8425);
	angles[87] = (0, 214.4640, 0);
	at[87] = 27.3000;
	points[88] = (125.7902, 3690.2324, 1009.8425);
	angles[88] = (0, 195.6834, 0);
	at[88] = 27.5333;
	points[89] = (68.9469, 3760.3740, 1009.8425);
	angles[89] = (0, 127.2230, 0);
	at[89] = 27.7667;
	points[90] = (11.4072, 3831.3704, 1009.8425);
	angles[90] = (0, 63.2467, 0);
	at[90] = 28;
	points[91] = (-46.2457, 3902.5039, 1009.8425);
	angles[91] = (0, 44.6330, 0);
	at[91] = 28.2333;
	points[92] = (-160.9500, 4044.0159, 1009.8425);
	angles[92] = (0, 39.3243, 0);
	at[92] = 28.7000;
	points[93] = (-390.4913, 4326.9688, 1009.8425);
	angles[93] = (0, 39.0614, 0);
	at[93] = 29.6333;
	points[94] = (-449.6614, 4399.8423, 1009.8425);
	angles[94] = (0, 39.0762, 0);
	at[94] = 29.8667;
	points[95] = (-504.5630, 4467.4019, 1009.8425);
	angles[95] = (0, 39.0991, 0);
	at[95] = 30.1000;
	points[96] = (-623.0709, 4612.7559, 1009.8425);
	angles[96] = (0, 39.2471, 0);
	at[96] = 30.5667;
	points[97] = (-678.8110, 4678.9370, 1009.8425);
	angles[97] = (0, 40.1740, 0);
	at[97] = 30.8000;
	points[98] = (-689.9095, 4655.9058, 1009.8425);
	angles[98] = (0, 66.5035, 0);
	at[98] = 31.0333;
	points[99] = (-780.4803, 4659.0552, 1009.8425);
	angles[99] = (0, 84.7483, 0);
	at[99] = 31.2667;
	points[100] = (-869.6299, 4642.4805, 1009.8425);
	angles[100] = (0, 98.2411, 0);
	at[100] = 31.5000;
	points[101] = (-954.4134, 4610.9053, 1009.8425);
	angles[101] = (0, 109.8130, 0);
	at[101] = 31.7333;
	points[102] = (-1029.0511, 4559.5669, 1009.8425);
	angles[102] = (0, 122.8141, 0);
	at[102] = 31.9667;
	points[103] = (-1087.8307, 4489.6460, 1009.8425);
	angles[103] = (0, 136.7635, 0);
	at[103] = 32.2000;
	points[104] = (-1132.8031, 4411.0630, 1009.8425);
	angles[104] = (0, 148.5274, 0);
	at[104] = 32.4333;
	points[105] = (-1157.5472, 4324.3701, 1009.8425);
	angles[105] = (0, 163.0013, 0);
	at[105] = 32.6667;
	points[106] = (-1165.9291, 4233.5435, 1009.8425);
	angles[106] = (0, 172.2428, 0);
	at[106] = 32.9000;
	points[107] = (-1172.0591, 4143.1890, 1009.8425);
	angles[107] = (0, 175.4599, 0);
	at[107] = 33.1333;
	points[108] = (-1174.1851, 4051.9292, 1009.8425);
	angles[108] = (0, 178.2473, 0);
	at[108] = 33.3667;
	points[109] = (-1168.0709, 3961.8503, 1009.8425);
	angles[109] = (0, 183.7582, 0);
	at[109] = 33.6000;
	points[110] = (-1134.5670, 3782.0552, 1009.8425);
	angles[110] = (0, 191.3351, 0);
	at[110] = 34.0667;
	points[111] = (-1102.3505, 3697.8267, 1009.8425);
	angles[111] = (0, 199.9609, 0);
	at[111] = 34.3000;
	points[112] = (-1061.7795, 3616.1455, 1009.8425);
	angles[112] = (0, 205.2697, 0);
	at[112] = 34.5333;
	points[113] = (-1015.3622, 3538.9880, 1009.8425);
	angles[113] = (0, 211.0396, 0);
	at[113] = 34.7667;
	points[114] = (-954.2322, 3471.0039, 1009.8425);
	angles[114] = (0, 220.0220, 0);
	at[114] = 35;
	points[115] = (-889.3504, 3406.7126, 1009.8425);
	angles[115] = (0, 224.3921, 0);
	at[115] = 35.2333;
	points[116] = (-820.2795, 3349.3149, 1009.8425);
	angles[116] = (0, 229.9275, 0);
	at[116] = 35.4667;
	points[117] = (-668.9724, 3246.5159, 1009.8425);
	angles[117] = (0, 236.1057, 0);
	at[117] = 35.9333;
	points[118] = (-590.8898, 3198.7441, 1009.8425);
	angles[118] = (0, 238.4681, 0);
	at[118] = 36.1667;
	points[119] = (-508.6496, 3162.5864, 1009.8425);
	angles[119] = (0, 245.1516, 0);
	at[119] = 36.4000;
	points[120] = (-336.8792, 3102.1890, 1009.8425);
	angles[120] = (0, 251.3282, 0);
	at[120] = 36.8667;
	points[121] = (-248.7917, 3082.3152, 1009.8425);
	angles[121] = (0, 256.6424, 0);
	at[121] = 37.1000;
	points[122] = (-68.2079, 3052.8110, 1009.8425);
	angles[122] = (0, 260.8785, 0);
	at[122] = 37.5667;
	points[123] = (21.1002, 3041.3740, 1009.8425);
	angles[123] = (0, 262.7870, 0);
	at[123] = 37.8000;
	points[124] = (112.3185, 3035.8108, 1009.8425);
	angles[124] = (0, 265.8813, 0);
	at[124] = 38.0333;
	points[125] = (203.0445, 3033.2087, 1009.8425);
	angles[125] = (0, 268.3261, 0);
	at[125] = 38.2667;
	points[126] = (293.2980, 3043.7439, 1009.8425);
	angles[126] = (0, 275.8359, 0);
	at[126] = 38.5000;
	points[127] = (380.2850, 3069.0120, 1009.8425);
	angles[127] = (0, 285.8398, 0);
	at[127] = 38.7333;
	points[128] = (446.1929, 3130.5513, 1009.8425);
	angles[128] = (0, 309.9373, 0);
	at[128] = 38.9667;
	points[129] = (480.2126, 3214.1892, 1009.8425);
	angles[129] = (0, 333.9528, 0);
	at[129] = 39.2000;
	points[130] = (485.1103, 3304.7600, 1009.8425);
	angles[130] = (0, 353.4946, 0);
	at[130] = 39.4333;
	points[131] = (465.5709, 3391.9568, 1009.8425);
	angles[131] = (0, 363.6819, 0);
	at[131] = 39.6667;
	points[132] = (424.6929, 3454.0159, 1009.8425);
	angles[132] = (0, 389.6759, 0);
	at[132] = 39.9000;
	points[133] = (360.3914, 3519.5356, 1009.8425);
	angles[133] = (0, 401.1468, 0);
	at[133] = 40.1333;
	points[134] = (234.0563, 3646.5117, 1009.8425);
	angles[134] = (0, 404.6926, 0);
	at[134] = 40.6000;
	points[135] = (167.8091, 3712.9133, 1009.8425);
	angles[135] = (0, 404.8809, 0);
	at[135] = 40.8333;
	points[136] = (104.6520, 3776.1694, 1009.8425);
	angles[136] = (0, 404.9408, 0);
	at[136] = 41.0667;
	points[137] = (-413.7953, 4294.8818, 1009.8425);
	angles[137] = (0, 404.9816, 0);
	at[137] = 42.9333;
	points[138] = (-475.5473, 4356.6929, 1009.8425);
	angles[138] = (0, 404.9664, 0);
	at[138] = 43.1667;
	points[139] = (-542.5709, 4423.8584, 1009.8425);
	angles[139] = (0, 404.9336, 0);
	at[139] = 43.4000;
	points[140] = (-606.4528, 4488.1499, 1009.8425);
	angles[140] = (0, 404.8168, 0);
	at[140] = 43.6333;
	points[141] = (-663.0984, 4549.8818, 1009.8425);
	angles[141] = (0, 401.2489, 0);
	at[141] = 43.8667;
	points[142] = (-655.6575, 4588.4253, 1009.8425);
	angles[142] = (0, 383.4655, 0);
	at[142] = 44.1000;
	points[143] = (-645.6929, 4678.1104, 1009.8425);
	angles[143] = (0, 358.5013, 0);
	at[143] = 44.3333;
	points[144] = (-601.4252, 4755.3940, 1009.8425);
	angles[144] = (0, 332.5363, 0);
	at[144] = 44.5667;
	points[145] = (-531.3779, 4812.7954, 1009.8425);
	angles[145] = (0, 312.7391, 0);
	at[145] = 44.8000;
	points[146] = (-451.4764, 4855.6299, 1009.8425);
	angles[146] = (0, 300.5654, 0);
	at[146] = 45.0333;
	points[147] = (-364.7118, 4884.1733, 1009.8425);
	angles[147] = (0, 290.4732, 0);
	at[147] = 45.2667;
	points[148] = (-275.3764, 4900.1968, 1009.8425);
	angles[148] = (0, 281.5876, 0);
	at[148] = 45.5000;
	points[149] = (-184.8740, 4906.8506, 1009.8425);
	angles[149] = (0, 275.0196, 0);
	at[149] = 45.7333;
	points[150] = (-93.9181, 4906.1416, 1009.8425);
	angles[150] = (0, 270.3047, 0);
	at[150] = 45.9667;
	points[151] = (-3.0431, 4899.0156, 1009.8425);
	angles[151] = (0, 266.3226, 0);
	at[151] = 46.2000;
	points[152] = (86.0012, 4882.1655, 1009.8425);
	angles[152] = (0, 259.8906, 0);
	at[152] = 46.4333;
	points[153] = (172.9780, 4856.8110, 1009.8425);
	angles[153] = (0, 254.5045, 0);
	at[153] = 46.6667;
	points[154] = (344.3469, 4793.7798, 1009.8425);
	angles[154] = (0, 249.1129, 0);
	at[154] = 47.1333;
	points[155] = (422.2756, 4748.8188, 1009.8425);
	angles[155] = (0, 240.0995, 0);
	at[155] = 47.3667;
	points[156] = (492.5945, 4690.8271, 1009.8425);
	angles[156] = (0, 232.3144, 0);
	at[156] = 47.6000;
	points[157] = (560.1024, 4629.4487, 1009.8425);
	angles[157] = (0, 228.4243, 0);
	at[157] = 47.8333;
	points[158] = (619.3740, 4561.7720, 1009.8425);
	angles[158] = (0, 221.4385, 0);
	at[158] = 48.0667;
	points[159] = (719.4803, 4409.2520, 1009.8425);
	angles[159] = (0, 212.9125, 0);
	at[159] = 48.5333;
	points[160] = (764.2952, 4331.0239, 1009.8425);
	angles[160] = (0, 209.7756, 0);
	at[160] = 48.7667;
	points[161] = (800.5079, 4246.9292, 1009.8425);
	angles[161] = (0, 204.4012, 0);
	at[161] = 49;
	points[162] = (863.3465, 4076.7717, 1009.8425);
	angles[162] = (0, 199.4001, 0);
	at[162] = 49.4667;
	points[163] = (885.6811, 3988.2678, 1009.8425);
	angles[163] = (0, 195.0386, 0);
	at[163] = 49.7000;
	points[164] = (924.1457, 3810.0591, 1009.8425);
	angles[164] = (0, 191.8441, 0);
	at[164] = 50.1667;
	points[165] = (934.6969, 3719.8782, 1009.8425);
	angles[165] = (0, 187.2077, 0);
	at[165] = 50.4000;
	points[166] = (935.1733, 3629.1418, 1009.8425);
	angles[166] = (0, 180.8539, 0);
	at[166] = 50.6333;
	points[167] = (925.8149, 3539.0042, 1009.8425);
	angles[167] = (0, 174.5787, 0);
	at[167] = 50.8667;
	points[168] = (903.9016, 3450.1970, 1009.8425);
	angles[168] = (0, 167.6229, 0);
	at[168] = 51.1000;
	points[169] = (866.3150, 3367.9172, 1009.8425);
	angles[169] = (0, 156.7141, 0);
	at[169] = 51.3333;
	points[170] = (798.7795, 3308.0078, 1009.8425);
	angles[170] = (0, 134.8917, 0);
	at[170] = 51.5667;
	points[171] = (717.4921, 3267.7834, 1009.8425);
	angles[171] = (0, 118.8691, 0);
	at[171] = 51.8000;
	points[172] = (628.7717, 3249.7837, 1009.8425);
	angles[172] = (0, 103.5096, 0);
	at[172] = 52.0333;
	points[173] = (538.1260, 3250.9253, 1009.8425);
	angles[173] = (0, 90.8993, 0);
	at[173] = 52.2667;
	points[174] = (502.8662, 3254.8821, 1009.8425);
	angles[174] = (0, 88.3597, 0);
	at[174] = 52.3667;
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
	points[0] = (831.4528, 4095.3152, 1286.2205);
	angles[0] = (0, -178.4689, 0);
	at[0] = 0;
	points[1] = (821.4213, 3953.2678, 1286.2205);
	angles[1] = (0, -184.8242, 0);
	at[1] = 0.2667;
	points[2] = (810.9252, 3883.5786, 1286.2205);
	angles[2] = (0, -189.1125, 0);
	at[2] = 0.4000;
	points[3] = (777.0157, 3745.6338, 1286.2205);
	angles[3] = (0, -194.6995, 0);
	at[3] = 0.6667;
	points[4] = (726.4095, 3613.4805, 1286.2205);
	angles[4] = (0, -202.1091, 0);
	at[4] = 0.9333;
	points[5] = (697.3228, 3549.5396, 1286.2205);
	angles[5] = (0, -204.9463, 0);
	at[5] = 1.0667;
	points[6] = (679.8701, 3518.4961, 1286.2205);
	angles[6] = (0, -207.7894, 0);
	at[6] = 1.1333;
	points[7] = (604.3701, 3397.7007, 1286.2205);
	angles[7] = (0, -213.0216, 0);
	at[7] = 1.4000;
	points[8] = (538.0354, 3315.2480, 1286.2205);
	angles[8] = (0, -219.3145, 0);
	at[8] = 1.6000;
	points[9] = (466.5827, 3236.7837, 1286.2205);
	angles[9] = (0, -223.6600, 0);
	at[9] = 1.8000;
	points[10] = (358.9917, 3144.0081, 1286.2205);
	angles[10] = (0, -230, 0);
	at[10] = 2.0667;
	points[11] = (302.0961, 3102.5435, 1286.2205);
	angles[11] = (0, -234.3764, 0);
	at[11] = 2.2000;
	points[12] = (180.7638, 3028.8032, 1286.2205);
	angles[12] = (0, -239.6380, 0);
	at[12] = 2.4667;
	points[13] = (51.1669, 2971.4172, 1286.2205);
	angles[13] = (0, -247.2415, 0);
	at[13] = 2.7333;
	points[14] = (-48.9894, 2937.4094, 1286.2205);
	angles[14] = (0, -252.8513, 0);
	at[14] = 2.9333;
	points[15] = (-187.7417, 2905.2874, 1286.2205);
	angles[15] = (0, -258.1554, 0);
	at[15] = 3.2000;
	points[16] = (-293.0386, 2894.4448, 1286.2205);
	angles[16] = (0, -264.5116, 0);
	at[16] = 3.4000;
	points[17] = (-398.9922, 2889.9214, 1286.2205);
	angles[17] = (0, -268.9290, 0);
	at[17] = 3.6000;
	points[18] = (-540.6890, 2900.3464, 1286.2205);
	angles[18] = (0, -274.9675, 0);
	at[18] = 3.8667;
	points[19] = (-610.2087, 2911.4055, 1286.2205);
	angles[19] = (0, -279.5112, 0);
	at[19] = 4;
	points[20] = (-748.1693, 2945.7166, 1286.2205);
	angles[20] = (0, -284.9437, 0);
	at[20] = 4.2667;
	points[21] = (-847.3386, 2983.2087, 1286.2205);
	angles[21] = (0, -291.2704, 0);
	at[21] = 4.4667;
	points[22] = (-943.9331, 3026.5906, 1286.2205);
	angles[22] = (0, -295.4600, 0);
	at[22] = 4.6667;
	points[23] = (-1065.7598, 3100.2520, 1286.2205);
	angles[23] = (0, -301.9366, 0);
	at[23] = 4.9333;
	points[24] = (-1122.9646, 3141.4019, 1286.2205);
	angles[24] = (0, -306.2201, 0);
	at[24] = 5.0667;
	points[25] = (-1230.7362, 3233.9448, 1286.2205);
	angles[25] = (0, -311.5435, 0);
	at[25] = 5.3333;
	points[26] = (-1302.4133, 3311.9487, 1286.2205);
	angles[26] = (0, -318.1493, 0);
	at[26] = 5.5333;
	points[27] = (-1369.0865, 3394.1458, 1286.2205);
	angles[27] = (0, -322.0037, 0);
	at[27] = 5.7333;
	points[28] = (-1444.8662, 3514.7402, 1286.2205);
	angles[28] = (0, -328.6593, 0);
	at[28] = 6;
	points[29] = (-1462.4843, 3545.7324, 1286.2205);
	angles[29] = (0, -329.9255, 0);
	at[29] = 6.0667;
	points[30] = (-1491.9015, 3609.4805, 1286.2205);
	angles[30] = (0, -335.0154, 0);
	at[30] = 6.2000;
	points[31] = (-1543.0748, 3741.7009, 1286.2205);
	angles[31] = (0, -340.6669, 0);
	at[31] = 6.4667;
	points[32] = (-1577.2480, 3879.4763, 1286.2205);
	angles[32] = (0, -346.8702, 0);
	at[32] = 6.7333;
	points[33] = (-1588.1693, 3949.0159, 1286.2205);
	angles[33] = (0, -351.5183, 0);
	at[33] = 6.8667;
	points[34] = (-1598.5000, 4090.6299, 1286.2205);
	angles[34] = (0, -356.7429, 0);
	at[34] = 7.1333;
	points[35] = (-1593.8268, 4196.7324, 1286.2205);
	angles[35] = (0, -363.1682, 0);
	at[35] = 7.3333;
	points[36] = (-1582.8584, 4301.9683, 1286.2205);
	angles[36] = (0, -367.0734, 0);
	at[36] = 7.5333;
	points[37] = (-1550.5826, 4440.7480, 1286.2205);
	angles[37] = (0, -373.9188, 0);
	at[37] = 7.8000;
	points[38] = (-1516.4172, 4540.8267, 1286.2205);
	angles[38] = (0, -380.1396, 0);
	at[38] = 8;
	points[39] = (-1458.9528, 4670.2759, 1286.2205);
	angles[39] = (0, -385.9468, 0);
	at[39] = 8.2667;
	points[40] = (-1385.1102, 4791.5747, 1286.2205);
	angles[40] = (0, -392.1003, 0);
	at[40] = 8.5333;
	points[41] = (-1343.5159, 4848.4253, 1286.2205);
	angles[41] = (0, -396.6088, 0);
	at[41] = 8.6667;
	points[42] = (-1250.5354, 4956.1025, 1286.2205);
	angles[42] = (0, -401.8015, 0);
	at[42] = 8.9333;
	points[43] = (-1172.0708, 5027.3228, 1286.2205);
	angles[43] = (0, -408.3400, 0);
	at[43] = 9.1333;
	points[44] = (-1089.4607, 5093.5825, 1286.2205);
	angles[44] = (0, -412.5008, 0);
	at[44] = 9.3333;
	points[45] = (-968.6811, 5168.8975, 1286.2205);
	angles[45] = (0, -418.8273, 0);
	at[45] = 9.6000;
	points[46] = (-937.6771, 5186.2603, 1286.2205);
	angles[46] = (0, -420.2949, 0);
	at[46] = 9.6667;
	points[47] = (-873.5866, 5215.3149, 1286.2205);
	angles[47] = (0, -425.2807, 0);
	at[47] = 9.8000;
	points[48] = (-741.4606, 5265.7480, 1286.2205);
	angles[48] = (0, -431.1298, 0);
	at[48] = 10.0667;
	points[49] = (-603.3347, 5299.6064, 1286.2205);
	angles[49] = (0, -437.0477, 0);
	at[49] = 10.3333;
	points[50] = (-533.7244, 5309.9209, 1286.2205);
	angles[50] = (0, -441.8927, 0);
	at[50] = 10.4667;
	points[51] = (-391.5866, 5319.8423, 1286.2205);
	angles[51] = (0, -447.0303, 0);
	at[51] = 10.7333;
	points[52] = (-285.9331, 5314.5674, 1286.2205);
	angles[52] = (0, -453.3502, 0);
	at[52] = 10.9333;
	points[53] = (-180.5634, 5302.9531, 1286.2205);
	angles[53] = (0, -457.5876, 0);
	at[53] = 11.1333;
	points[54] = (-42.1933, 5270.3149, 1286.2205);
	angles[54] = (0, -464.0827, 0);
	at[54] = 11.4000;
	points[55] = (57.8358, 5235.4331, 1286.2205);
	angles[55] = (0, -470.3959, 0);
	at[55] = 11.6000;
	points[56] = (155.6177, 5193.5830, 1286.2205);
	angles[56] = (0, -473.6992, 0);
	at[56] = 11.8000;
	points[57] = (186.6669, 5177.4014, 1286.2205);
	angles[57] = (0, -476.4297, 0);
	at[57] = 11.8667;
	points[58] = (308.0858, 5103.1104, 1286.2205);
	angles[58] = (0, -482.2682, 0);
	at[58] = 12.1333;
	points[59] = (364.4748, 5061.1025, 1286.2205);
	angles[59] = (0, -486.9634, 0);
	at[59] = 12.2667;
	points[60] = (472, 4967.5986, 1286.2205);
	angles[60] = (0, -492.1276, 0);
	at[60] = 12.5333;
	points[61] = (542.6614, 4888.8584, 1286.2205);
	angles[61] = (0, -498.5226, 0);
	at[61] = 12.7333;
	points[62] = (608.5040, 4805.7876, 1286.2205);
	angles[62] = (0, -502.9766, 0);
	at[62] = 12.9333;
	points[63] = (700.2008, 4654.4097, 1286.2205);
	angles[63] = (0, -510.7560, 0);
	at[63] = 13.2667;
	points[64] = (742.7402, 4556.6143, 1286.2205);
	angles[64] = (0, -516.7960, 0);
	at[64] = 13.4667;
	points[65] = (779.1024, 4457.1655, 1286.2205);
	angles[65] = (0, -521.3088, 0);
	at[65] = 13.6667;
	points[66] = (813.4252, 4319.1733, 1286.2205);
	angles[66] = (0, -527.1049, 0);
	at[66] = 13.9333;
	points[67] = (822.3977, 4249.1733, 1286.2205);
	angles[67] = (0, -532.6219, 0);
	at[67] = 14.0667;
	points[68] = (830.2362, 4142.8345, 1286.2205);
	angles[68] = (0, -536.0538, 0);
	at[68] = 14.2667;
	points[69] = (831.4528, 4095.3152, 1286.2205);
	angles[69] = (0, -538.4689, 0);
	at[69] = 14.3667;
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
