main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_ds_delfino_square", 0);

	setExpFog(5905.5117, 20669.2891, 0.4353, 0.6941, 0.9059, 0);

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
	ambientPlay("iz_0_r_ds_town32", 2);
	iz_emitter("iz_1_se_cc_env_sea", (-8848.7881, 3264.0894, 1190.5511), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-11199.9590, 3266.0957, 1190.5511), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-13551.1279, 3268.1021, 1190.5511), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-12893.9482, 7683.5625, 1190.5511), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-11848.1250, 9309.4170, 1190.5511), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-10802.3008, 10935.2725, 1190.5511), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-8487.2227, 10939.1602, 1190.5511), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-6172.1440, 10943.0488, 1190.5511), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-3857.0657, 10946.9365, 1190.5511), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-1541.9872, 10950.8242, 1190.5511), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (773.0914, 10954.7129, 1190.5511), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (3088.1697, 10958.6006, 1190.5511), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (5403.2485, 10962.4883, 1190.5511), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (7718.3271, 10966.3770, 1190.5511), 0, 12.0104);
}

iz_emitter(alias, origin, interval, length)
{
	ent = spawn("script_origin", origin);
	if (interval <= 0)
		ent playLoopSound(alias);
	else
		ent thread iz_emitter_random(alias, interval, length);
}

// One play at a time: copies started over one another ran out the
// engine's 32 voices, and the sounds that lost theirs restarted.
iz_emitter_random(alias, interval, length)
{
	for (;;)
	{
		wait(randomFloatRange(interval * 0.25, interval));
		self playSound(alias);
		wait(length);
	}
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
	level.iz_route[level.iz_route.size] = (8917, 851, 1483);
	level.iz_route[level.iz_route.size] = (8916, -1052, 1826);
	level.iz_route[level.iz_route.size] = (8926, -2518, 2089);
	level.iz_route[level.iz_route.size] = (8917, -3891, 2319);
	level.iz_route[level.iz_route.size] = (8919, -5126, 2339);
	level.iz_route[level.iz_route.size] = (8932, -6056, 2339);
	level.iz_route[level.iz_route.size] = (9674, -6581, 2339);
	level.iz_route[level.iz_route.size] = (10142, -7287, 2339);
	level.iz_route[level.iz_route.size] = (10180, -8274, 2339);
	level.iz_route[level.iz_route.size] = (9442, -8888, 2339);
	level.iz_route[level.iz_route.size] = (8326, -8888, 2339);
	level.iz_route[level.iz_route.size] = (7456, -7923, 2339);
	level.iz_route[level.iz_route.size] = (5920, -7662, 2339);
	level.iz_route[level.iz_route.size] = (4821, -7669, 2339);
	level.iz_route[level.iz_route.size] = (3735, -7680, 2339);
	level.iz_route[level.iz_route.size] = (3189, -8242, 2339);
	level.iz_route[level.iz_route.size] = (3208, -9692, 2339);
	level.iz_route[level.iz_route.size] = (2961, -10312, 2339);
	level.iz_route[level.iz_route.size] = (2318, -10475, 2339);
	level.iz_route[level.iz_route.size] = (1104, -10470, 2339);
	level.iz_route[level.iz_route.size] = (-81, -10386, 2244);
	level.iz_route[level.iz_route.size] = (-951, -9986, 2098);
	level.iz_route[level.iz_route.size] = (-1496, -9321, 1982);
	level.iz_route[level.iz_route.size] = (-1731, -8654, 1884);
	level.iz_route[level.iz_route.size] = (-1876, -7975, 1792);
	level.iz_route[level.iz_route.size] = (-1878, -6655, 1786);
	level.iz_route[level.iz_route.size] = (-1890, -5418, 1786);
	level.iz_route[level.iz_route.size] = (-1889, -4299, 1615);
	level.iz_route[level.iz_route.size] = (-1889, -3380, 1406);
	level.iz_route[level.iz_route.size] = (-1884, -2322, 1403);
	level.iz_route[level.iz_route.size] = (-1989, -1711, 1403);
	level.iz_route[level.iz_route.size] = (-2529, -1472, 1403);
	level.iz_route[level.iz_route.size] = (-4047, -1477, 1403);
	level.iz_route[level.iz_route.size] = (-5185, -1279, 1403);
	level.iz_route[level.iz_route.size] = (-5706, -343, 1403);
	level.iz_route[level.iz_route.size] = (-5596, 551, 1367);
	level.iz_route[level.iz_route.size] = (-5418, 1447, 1329);
	level.iz_route[level.iz_route.size] = (-5279, 2083, 1318);
	level.iz_route[level.iz_route.size] = (-5062, 2998, 1318);
	level.iz_route[level.iz_route.size] = (-5062, 5167, 1191);
	level.iz_route[level.iz_route.size] = (-5610, 5610, 1191);
	level.iz_route[level.iz_route.size] = (-9596, 5610, 1191);
	level.iz_route[level.iz_route.size] = (-10482, 5610, 1191);
	level.iz_route[level.iz_route.size] = (-11811, 5610, 1191);
	level.iz_route[level.iz_route.size] = (-11814, 6461, 1191);
	level.iz_route[level.iz_route.size] = (-11690, 7592, 1191);
	level.iz_route[level.iz_route.size] = (-11191, 8554, 1191);
	level.iz_route[level.iz_route.size] = (-10445, 9217, 1191);
	level.iz_route[level.iz_route.size] = (-9311, 9608, 1191);
	level.iz_route[level.iz_route.size] = (-8415, 9596, 1191);
	level.iz_route[level.iz_route.size] = (-7677, 9596, 1171);
	level.iz_route[level.iz_route.size] = (-6644, 9596, 1083);
	level.iz_route[level.iz_route.size] = (-4776, 9043, 1063);
	level.iz_route[level.iz_route.size] = (-3425, 9006, 1063);
	level.iz_route[level.iz_route.size] = (-1875, 9006, 1063);
	level.iz_route[level.iz_route.size] = (-399, 9006, 1063);
	level.iz_route[level.iz_route.size] = (2167, 9003, 1063);
	level.iz_route[level.iz_route.size] = (3244, 7326, 1063);
	level.iz_route[level.iz_route.size] = (4862, 7318, 1063);
	level.iz_route[level.iz_route.size] = (5180, 7973, 1063);
	level.iz_route[level.iz_route.size] = (7232, 7965, 1318);
	level.iz_route[level.iz_route.size] = (8316, 7963, 1318);
	level.iz_route[level.iz_route.size] = (8924, 7051, 1318);
	level.iz_route[level.iz_route.size] = (8917, 3300, 1318);
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
	points[0] = (-5843.6616, 2570.1929, 1624.0157);
	angles[0] = (0, 51.7922, 0);
	at[0] = 0;
	points[1] = (-5860.6689, 2614.2637, 1624.0157);
	angles[1] = (0, 34.5462, 0);
	at[1] = 0.1333;
	points[2] = (-5886.2202, 2680.3662, 1624.0157);
	angles[2] = (0, 24.9279, 0);
	at[2] = 0.3333;
	points[3] = (-5996.8896, 2966.8188, 1624.0157);
	angles[3] = (0, 21.1391, 0);
	at[3] = 1.2000;
	points[4] = (-5999.7637, 2989.6731, 1624.0157);
	angles[4] = (0, 14.2920, 0);
	at[4] = 1.2667;
	points[5] = (-5994.0947, 3060.3152, 1624.0157);
	angles[5] = (0, 0.7842, 0);
	at[5] = 1.4667;
	points[6] = (-5984.6455, 3178.0471, 1624.0157);
	angles[6] = (0, -3.9318, 0);
	at[6] = 1.8000;
	points[7] = (-5965.7090, 3220.9568, 1624.0157);
	angles[7] = (0, -16.5522, 0);
	at[7] = 1.9333;
	points[8] = (-5944.8423, 3263.3347, 1624.0157);
	angles[8] = (0, -22.0621, 0);
	at[8] = 2.0667;
	points[9] = (-5861.2993, 3432.8386, 1624.0157);
	angles[9] = (0, -26.0953, 0);
	at[9] = 2.6000;
	points[10] = (-5846.6143, 3450.6614, 1624.0157);
	angles[10] = (0, -32.6797, 0);
	at[10] = 2.6667;
	points[11] = (-5791.7324, 3495.4883, 1624.0157);
	angles[11] = (0, -45.6202, 0);
	at[11] = 2.8667;
	points[12] = (-5608.7793, 3644.9175, 1624.0157);
	angles[12] = (0, -52.8279, 0);
	at[12] = 3.5333;
	points[13] = (-5563.0708, 3657.9055, 1624.0157);
	angles[13] = (0, -64.0227, 0);
	at[13] = 3.6667;
	points[14] = (-5517.9922, 3672.0432, 1624.0157);
	angles[14] = (0, -68.8953, 0);
	at[14] = 3.8000;
	points[15] = (-5292.5986, 3742.7361, 1624.0157);
	angles[15] = (0, -72.5317, 0);
	at[15] = 4.4667;
	points[16] = (-5270.0391, 3749.8071, 1624.0157);
	angles[16] = (0, -75.9185, 0);
	at[16] = 4.5333;
	points[17] = (-5225.1182, 3732.4526, 1624.0157);
	angles[17] = (0, -93.8717, 0);
	at[17] = 4.6667;
	points[18] = (-5180.1577, 3717.9448, 1624.0157);
	angles[18] = (0, -101.8299, 0);
	at[18] = 4.8000;
	points[19] = (-5112.7168, 3696.1851, 1624.0157);
	angles[19] = (0, -106.1709, 0);
	at[19] = 5;
	points[20] = (-4977.8345, 3652.6694, 1624.0157);
	angles[20] = (0, -107.7448, 0);
	at[20] = 5.4000;
	points[21] = (-4937.6377, 3628.1379, 1624.0157);
	angles[21] = (0, -116.4064, 0);
	at[21] = 5.5333;
	points[22] = (-4897.9922, 3602.4055, 1624.0157);
	angles[22] = (0, -120.1594, 0);
	at[22] = 5.6667;
	points[23] = (-4719.6851, 3486.6179, 1624.0157);
	angles[23] = (0, -122.9359, 0);
	at[23] = 6.2667;
	points[24] = (-4699.8818, 3473.7520, 1624.0157);
	angles[24] = (0, -126.7979, 0);
	at[24] = 6.3333;
	points[25] = (-4689.0942, 3426.6499, 1624.0157);
	angles[25] = (0, -147.5421, 0);
	at[25] = 6.4667;
	points[26] = (-4669.4883, 3358.5593, 1624.0157);
	angles[26] = (0, -159.2670, 0);
	at[26] = 6.6667;
	points[27] = (-4643.3071, 3267.7676, 1624.0157);
	angles[27] = (0, -163.0543, 0);
	at[27] = 6.9333;
	points[28] = (-4577.8350, 3040.7952, 1624.0157);
	angles[28] = (0, -163.9034, 0);
	at[28] = 7.6000;
	points[29] = (-4580.7876, 3018.2363, 1624.0157);
	angles[29] = (0, -172.7898, 0);
	at[29] = 7.6667;
	points[30] = (-4595.1968, 2973.2402, 1624.0157);
	angles[30] = (0, -186.8865, 0);
	at[30] = 7.8000;
	points[31] = (-4616.8110, 2905.7480, 1624.0157);
	angles[31] = (0, -194.6738, 0);
	at[31] = 8;
	points[32] = (-4703.2285, 2635.7756, 1624.0157);
	angles[32] = (0, -197.7292, 0);
	at[32] = 8.8000;
	points[33] = (-4736.5356, 2603.3975, 1624.0157);
	angles[33] = (0, -215.6654, 0);
	at[33] = 8.9333;
	points[34] = (-4772.5195, 2572.8152, 1624.0157);
	angles[34] = (0, -223.6156, 0);
	at[34] = 9.0667;
	points[35] = (-4934.5669, 2435.1968, 1624.0157);
	angles[35] = (0, -231.5961, 0);
	at[35] = 9.6667;
	points[36] = (-4979.9214, 2420.9133, 1624.0157);
	angles[36] = (0, -242.4382, 0);
	at[36] = 9.8000;
	points[37] = (-5024.5278, 2405.3188, 1624.0157);
	angles[37] = (0, -247.1541, 0);
	at[37] = 9.9333;
	points[38] = (-5269.8032, 2319.5474, 1624.0157);
	angles[38] = (0, -250.6913, 0);
	at[38] = 10.6667;
	points[39] = (-5292.3232, 2321.0786, 1624.0157);
	angles[39] = (0, -260.0954, 0);
	at[39] = 10.7333;
	points[40] = (-5337.5981, 2334.6182, 1624.0157);
	angles[40] = (0, -275.0785, 0);
	at[40] = 10.8667;
	points[41] = (-5382.8345, 2348.1575, 1624.0157);
	angles[41] = (0, -281.6595, 0);
	at[41] = 11;
	points[42] = (-5586.5352, 2409.0867, 1624.0157);
	angles[42] = (0, -286.5413, 0);
	at[42] = 11.6000;
	points[43] = (-5668.0708, 2456.2637, 1624.0157);
	angles[43] = (0, -298.4004, 0);
	at[43] = 11.8667;
	points[44] = (-5829.2124, 2554.9763, 1624.0157);
	angles[44] = (0, -301.3839, 0);
	at[44] = 12.4000;
	points[45] = (-5843.6616, 2570.1929, 1624.0157);
	angles[45] = (0, -308.2078, 0);
	at[45] = 12.4667;
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
	points[0] = (-10663.0713, 9730.9844, 1476.3779);
	angles[0] = (0, -47.6473, 0);
	at[0] = 0;
	points[1] = (-10557.0469, 9802.0078, 1476.3779);
	angles[1] = (0, -54.4246, 0);
	at[1] = 0.2667;
	points[2] = (-10345.5908, 9944.7637, 1476.3779);
	angles[2] = (0, -55.9158, 0);
	at[2] = 0.8000;
	points[3] = (-10316.9287, 9958.1104, 1476.3779);
	angles[3] = (0, -60.0426, 0);
	at[3] = 0.8667;
	points[4] = (-10256.5752, 9978.6221, 1476.3779);
	angles[4] = (0, -66.4015, 0);
	at[4] = 1;
	points[5] = (-10165.9844, 10009.4492, 1476.3779);
	angles[5] = (0, -69.8629, 0);
	at[5] = 1.2000;
	points[6] = (-9652.7168, 10183.8975, 1476.3779);
	angles[6] = (0, -71.2251, 0);
	at[6] = 2.3333;
	points[7] = (-9498.3076, 10223.7412, 1476.3779);
	angles[7] = (0, -75.0527, 0);
	at[7] = 2.6667;
	points[8] = (-8848.8584, 10387.0078, 1476.3779);
	angles[8] = (0, -76.1619, 0);
	at[8] = 4.0667;
	points[9] = (-8825.9453, 10407.5586, 1476.3779);
	angles[9] = (0, -64.0536, 0);
	at[9] = 4.1333;
	points[10] = (-8785.1182, 10456.5361, 1476.3779);
	angles[10] = (0, -50.3580, 0);
	at[10] = 4.2667;
	points[11] = (-8703.4258, 10554.5273, 1476.3779);
	angles[11] = (0, -41.7746, 0);
	at[11] = 4.5333;
	points[12] = (-8693.3066, 10579.4883, 1476.3779);
	angles[12] = (0, -29.6656, 0);
	at[12] = 4.6000;
	points[13] = (-8711.4180, 10605.7480, 1476.3779);
	angles[13] = (0, -9.8169, 0);
	at[13] = 4.6667;
	points[14] = (-8729.5273, 10632.0088, 1476.3779);
	angles[14] = (0, 4.7348, 0);
	at[14] = 4.7333;
	points[15] = (-8747.5986, 10658.2676, 1476.3779);
	angles[15] = (0, 14.7864, 0);
	at[15] = 4.8000;
	points[16] = (-8783.8184, 10710.7480, 1476.3779);
	angles[16] = (0, 26.0061, 0);
	at[16] = 4.9333;
	points[17] = (-8820.0400, 10763.2676, 1476.3779);
	angles[17] = (0, 30.8897, 0);
	at[17] = 5.0667;
	points[18] = (-8841.7324, 10782.4404, 1476.3779);
	angles[18] = (0, 41.6264, 0);
	at[18] = 5.1333;
	points[19] = (-8873.6221, 10781.8115, 1476.3779);
	angles[19] = (0, 57.6605, 0);
	at[19] = 5.2000;
	points[20] = (-8905.5117, 10781.1416, 1476.3779);
	angles[20] = (0, 68.8815, 0);
	at[20] = 5.2667;
	points[21] = (-8969.2920, 10779.8428, 1476.3779);
	angles[21] = (0, 81.4962, 0);
	at[21] = 5.4000;
	points[22] = (-9064.9209, 10777.8740, 1476.3779);
	angles[22] = (0, 88.4388, 0);
	at[22] = 5.6000;
	points[23] = (-9256.2207, 10773.9365, 1476.3779);
	angles[23] = (0, 90.9597, 0);
	at[23] = 6;
	points[24] = (-9318.6611, 10761.2998, 1476.3779);
	angles[24] = (0, 97.3109, 0);
	at[24] = 6.1333;
	points[25] = (-9412.2051, 10741.1807, 1476.3779);
	angles[25] = (0, 100.7680, 0);
	at[25] = 6.3333;
	points[26] = (-9879.6455, 10639.8037, 1476.3779);
	angles[26] = (0, 102.8084, 0);
	at[26] = 7.3333;
	points[27] = (-10401.5361, 10492.9531, 1476.3779);
	angles[27] = (0, 105.7144, 0);
	at[27] = 8.4667;
	points[28] = (-10431.2207, 10481.8506, 1476.3779);
	angles[28] = (0, 108.0810, 0);
	at[28] = 8.5333;
	points[29] = (-10543.6230, 10421.5352, 1476.3779);
	angles[29] = (0, 116.3455, 0);
	at[29] = 8.8000;
	points[30] = (-10852.6768, 10255.5908, 1476.3779);
	angles[30] = (0, 118.2119, 0);
	at[30] = 9.5333;
	points[31] = (-10879.5674, 10238.6621, 1476.3779);
	angles[31] = (0, 119.8212, 0);
	at[31] = 9.6000;
	points[32] = (-10956.2998, 10181.4961, 1476.3779);
	angles[32] = (0, 124.7455, 0);
	at[32] = 9.8000;
	points[33] = (-11186.4561, 10010.0400, 1476.3779);
	angles[33] = (0, 126.6425, 0);
	at[33] = 10.4000;
	points[34] = (-11210.1182, 9988.7012, 1476.3779);
	angles[34] = (0, 128.9000, 0);
	at[34] = 10.4667;
	points[35] = (-11303.1104, 9901.3779, 1476.3779);
	angles[35] = (0, 132.4141, 0);
	at[35] = 10.7333;
	points[36] = (-11489.0166, 9726.6934, 1476.3779);
	angles[36] = (0, 133.1863, 0);
	at[36] = 11.2667;
	points[37] = (-11509.2520, 9702.4414, 1476.3779);
	angles[37] = (0, 136.3263, 0);
	at[37] = 11.3333;
	points[38] = (-11541.2988, 9647.3232, 1476.3779);
	angles[38] = (0, 144.0012, 0);
	at[38] = 11.4667;
	points[39] = (-11573.3857, 9592.1660, 1476.3779);
	angles[39] = (0, 147.3220, 0);
	at[39] = 11.6000;
	points[40] = (-11749.6465, 9288.8975, 1476.3779);
	angles[40] = (0, 149.8103, 0);
	at[40] = 12.3333;
	points[41] = (-11752.9922, 9259.7637, 1476.3779);
	angles[41] = (0, 161.6144, 0);
	at[41] = 12.4000;
	points[42] = (-11735.3145, 9198.4648, 1476.3779);
	angles[42] = (0, 180.9363, 0);
	at[42] = 12.5333;
	points[43] = (-11717.6377, 9137.2051, 1476.3779);
	angles[43] = (0, 189.5435, 0);
	at[43] = 12.6667;
	points[44] = (-11699.9600, 9075.9053, 1476.3779);
	angles[44] = (0, 193.2726, 0);
	at[44] = 12.8000;
	points[45] = (-11677.5586, 9062.4014, 1476.3779);
	angles[45] = (0, 210.4377, 0);
	at[45] = 12.8667;
	points[46] = (-11645.7090, 9060.9053, 1476.3779);
	angles[46] = (0, 228.4498, 0);
	at[46] = 12.9333;
	points[47] = (-11613.8584, 9059.3701, 1476.3779);
	angles[47] = (0, 241.3266, 0);
	at[47] = 13;
	points[48] = (-11550.1572, 9056.3779, 1476.3779);
	angles[48] = (0, 255.9767, 0);
	at[48] = 13.1333;
	points[49] = (-11454.6064, 9051.8115, 1476.3779);
	angles[49] = (0, 264.0820, 0);
	at[49] = 13.3333;
	points[50] = (-11425.1182, 9059.7637, 1476.3779);
	angles[50] = (0, 273.9004, 0);
	at[50] = 13.4000;
	points[51] = (-11397.7168, 9076.1025, 1476.3779);
	angles[51] = (0, 282.9827, 0);
	at[51] = 13.4667;
	points[52] = (-11342.8740, 9108.7002, 1476.3779);
	angles[52] = (0, 293.0680, 0);
	at[52] = 13.6000;
	points[53] = (-11178.4648, 9206.5752, 1476.3779);
	angles[53] = (0, 301.9131, 0);
	at[53] = 14;
	points[54] = (-11116.1816, 9279.5273, 1476.3779);
	angles[54] = (0, 313.8782, 0);
	at[54] = 14.2000;
	points[55] = (-10989.7246, 9423.0703, 1476.3779);
	angles[55] = (0, 318.2453, 0);
	at[55] = 14.6000;
	points[56] = (-10897.0869, 9510.7480, 1476.3779);
	angles[56] = (0, 314.1834, 0);
	at[56] = 14.8667;
	points[57] = (-10688.0703, 9707.4414, 1476.3779);
	angles[57] = (0, 313.2798, 0);
	at[57] = 15.4667;
	points[58] = (-10663.0713, 9730.9844, 1476.3779);
	angles[58] = (0, 312.3527, 0);
	at[58] = 15.5333;
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
