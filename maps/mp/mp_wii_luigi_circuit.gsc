main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_wii_luigi_circuit", 0);

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
	ambientPlay("iz_0_n_circuit32", 2);
	iz_emitter("iz_1_se_cc_env_audience_m", (5006.1274, 7388.9102, 287.2903), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_audience_m", (5018.1440, 5466.3418, 324.1656), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_audience_m", (-122.0823, 52.1761, 839.8158), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_audience_m", (-1679.3627, -966.7850, 1009.8208), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_audience_m", (2119.1511, 7707.0420, 297.4893), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_audience_m", (2242.1958, 8785.6025, 286.4275), 0, 12.0104);
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
	level.iz_route[level.iz_route.size] = (5891, 6291, 156);
	level.iz_route[level.iz_route.size] = (5891, 4315, 211);
	level.iz_route[level.iz_route.size] = (5891, 2698, 261);
	level.iz_route[level.iz_route.size] = (5762, 1359, 308);
	level.iz_route[level.iz_route.size] = (4524, 517, 364);
	level.iz_route[level.iz_route.size] = (2722, 189, 486);
	level.iz_route[level.iz_route.size] = (1189, -90, 601);
	level.iz_route[level.iz_route.size] = (-35, -930, 742);
	level.iz_route[level.iz_route.size] = (-1186, -1796, 875);
	level.iz_route[level.iz_route.size] = (-2751, -1779, 975);
	level.iz_route[level.iz_route.size] = (-3805, -792, 977);
	level.iz_route[level.iz_route.size] = (-4559, 404, 951);
	level.iz_route[level.iz_route.size] = (-4157, 1800, 835);
	level.iz_route[level.iz_route.size] = (-2904, 3176, 667);
	level.iz_route[level.iz_route.size] = (-1573, 4622, 489);
	level.iz_route[level.iz_route.size] = (-360, 6049, 325);
	level.iz_route[level.iz_route.size] = (848, 7343, 188);
	level.iz_route[level.iz_route.size] = (1398, 9002, 138);
	level.iz_route[level.iz_route.size] = (1395, 10274, 139);
	level.iz_route[level.iz_route.size] = (1392, 11549, 154);
	level.iz_route[level.iz_route.size] = (1391, 12810, 207);
	level.iz_route[level.iz_route.size] = (2068, 14148, 192);
	level.iz_route[level.iz_route.size] = (2930, 14761, 204);
	level.iz_route[level.iz_route.size] = (4473, 14751, 206);
	level.iz_route[level.iz_route.size] = (5657, 13728, 201);
	level.iz_route[level.iz_route.size] = (5903, 12354, 178);
	level.iz_route[level.iz_route.size] = (5891, 10724, 147);
	level.iz_route[level.iz_route.size] = (5891, 8656, 142);
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
	points[0] = (243.1020, 2424.6929, 1579.7245);
	angles[0] = (0, -144.3782, 0);
	at[0] = 0;
	points[1] = (195.0807, 2085.1458, 1579.7245);
	angles[1] = (0, -184.5049, 0);
	at[1] = 0.5000;
	points[2] = (54.5516, 1932.2482, 1801.7520);
	angles[2] = (0, -208.2244, 0);
	at[2] = 1;
	points[3] = (-49.1083, 1836.9606, 2126.9016);
	angles[3] = (0, -220.5452, 0);
	at[3] = 1.5000;
	points[4] = (-185.2744, 1739.7521, 2439.1772);
	angles[4] = (0, -231.5365, 0);
	at[4] = 2;
	points[5] = (-322.6555, 1642.4763, 2750.9688);
	angles[5] = (0, -234.0203, 0);
	at[5] = 2.5000;
	points[6] = (-623.1142, 1532.2795, 2827.8071);
	angles[6] = (0, -248.2924, 0);
	at[6] = 3;
	points[7] = (-1962.0513, 1080.6182, 2937.6338);
	angles[7] = (0, -251.3532, 0);
	at[7] = 5;
	points[8] = (-2292.4175, 955.0237, 2952.7559);
	angles[8] = (0, -248.8808, 0);
	at[8] = 5.5000;
	points[9] = (-3592.4604, 390.4965, 2952.7559);
	angles[9] = (0, -246.5326, 0);
	at[9] = 7.5000;
	points[10] = (-3880.0630, 188.4618, 2952.7559);
	angles[10] = (0, -235.6187, 0);
	at[10] = 8;
	points[11] = (-4152.9136, -37.6020, 2952.7559);
	angles[11] = (0, -231.4871, 0);
	at[11] = 8.5000;
	points[12] = (-4399.3701, -281.8591, 2952.7559);
	angles[12] = (0, -223.7087, 0);
	at[12] = 9;
	points[13] = (-4513.8975, -617.1772, 2952.7559);
	angles[13] = (0, -204.2638, 0);
	at[13] = 9.5000;
	points[14] = (-4621.7324, -953.4803, 2952.7559);
	angles[14] = (0, -198.0239, 0);
	at[14] = 10;
	points[15] = (-4609.2910, -1307.5945, 2952.7559);
	angles[15] = (0, -182.3270, 0);
	at[15] = 10.5000;
	points[16] = (-4596.8506, -1661.7047, 2952.7559);
	angles[16] = (0, -178.9193, 0);
	at[16] = 11;
	points[17] = (-4507.6772, -2001.2874, 2952.7559);
	angles[17] = (0, -166.4487, 0);
	at[17] = 11.5000;
	points[18] = (-4272.0078, -2669.6101, 2952.7559);
	angles[18] = (0, -160.8459, 0);
	at[18] = 12.5000;
	points[19] = (-4083.7007, -2955.9685, 2952.7559);
	angles[19] = (0, -145.0461, 0);
	at[19] = 13;
	points[20] = (-3816.7363, -3188.9607, 2952.7559);
	angles[20] = (0, -134.1174, 0);
	at[20] = 13.5000;
	points[21] = (-3549.7834, -3421.9529, 2952.7559);
	angles[21] = (0, -131.7587, 0);
	at[21] = 14;
	points[22] = (-3276.2600, -3645.9253, 2952.7559);
	angles[22] = (0, -128.5795, 0);
	at[22] = 14.5000;
	points[23] = (-2972.5120, -3828.3740, 2952.7559);
	angles[23] = (0, -122.6224, 0);
	at[23] = 15;
	points[24] = (-2365.0159, -4193.2681, 2952.7559);
	angles[24] = (0, -121.0667, 0);
	at[24] = 16;
	points[25] = (-2035.6339, -4299.4097, 2952.7559);
	angles[25] = (0, -107.2251, 0);
	at[25] = 16.5000;
	points[26] = (-1683.3386, -4337.3228, 2952.7559);
	angles[26] = (0, -98.5274, 0);
	at[26] = 17;
	points[27] = (-1331.0393, -4375.2363, 2952.7559);
	angles[27] = (0, -96.6541, 0);
	at[27] = 17.5000;
	points[28] = (430.4488, -4564.7637, 2952.7559);
	angles[28] = (0, -96.1423, 0);
	at[28] = 20;
	points[29] = (783.9882, -4579.9609, 2952.7559);
	angles[29] = (0, -92.3983, 0);
	at[29] = 20.5000;
	points[30] = (2555.6340, -4583.8975, 2952.7559);
	angles[30] = (0, -90.1277, 0);
	at[30] = 23;
	points[31] = (2904.3386, -4545.9448, 2952.7559);
	angles[31] = (0, -82.4516, 0);
	at[31] = 23.5000;
	points[32] = (3243.7874, -4444.3701, 2952.7559);
	angles[32] = (0, -75.2956, 0);
	at[32] = 24;
	points[33] = (3583.2361, -4342.7559, 2952.7559);
	angles[33] = (0, -73.7561, 0);
	at[33] = 24.5000;
	points[34] = (4941.0234, -3936.2913, 2952.7559);
	angles[34] = (0, -73.3361, 0);
	at[34] = 26.5000;
	points[35] = (5236.2603, -3743.3782, 2952.7559);
	angles[35] = (0, -59.5936, 0);
	at[35] = 27;
	points[36] = (5526.3389, -3539.9292, 2952.7559);
	angles[36] = (0, -55.9536, 0);
	at[36] = 27.5000;
	points[37] = (6396.6538, -2929.5906, 2952.7559);
	angles[37] = (0, -54.9681, 0);
	at[37] = 29;
	points[38] = (6666.1025, -2707.4922, 2965.9841);
	angles[38] = (0, -48.7625, 0);
	at[38] = 29.5000;
	points[39] = (6860.7876, -2417.8149, 3027.1338);
	angles[39] = (0, -37.1494, 0);
	at[39] = 30;
	points[40] = (7444.8037, -1548.7874, 3210.5864);
	angles[40] = (0, -33.9350, 0);
	at[40] = 31.5000;
	points[41] = (7590.1968, -1237.9331, 3267.1853);
	angles[41] = (0, -23.5019, 0);
	at[41] = 32;
	points[42] = (7657.7163, -893.6221, 3316.5984);
	angles[42] = (0, -13.7603, 0);
	at[42] = 32.5000;
	points[43] = (7725.2358, -549.3110, 3366.0117);
	angles[43] = (0, -11.6669, 0);
	at[43] = 33;
	points[44] = (8130.3545, 1516.5552, 3662.4961);
	angles[44] = (0, -11.0952, 0);
	at[44] = 36;
	points[45] = (8180.3545, 1864.5315, 3698.1497);
	angles[45] = (0, -7.7552, 0);
	at[45] = 36.5000;
	points[46] = (8232.8740, 2570.4292, 3732.1104);
	angles[46] = (0, -4.4145, 0);
	at[46] = 37.5000;
	points[47] = (8390.3936, 4688.1104, 3833.9961);
	angles[47] = (0, -4.2536, 0);
	at[47] = 40.5000;
	points[48] = (8397.5986, 5041.7720, 3826.3306);
	angles[48] = (0, -1.3964, 0);
	at[48] = 41;
	points[49] = (8398.9365, 7873.2285, 3692.0671);
	angles[49] = (0, -0.0271, 0);
	at[49] = 45;
	points[50] = (8299.6064, 8212.2832, 3690.9448);
	angles[50] = (0, 13.2904, 0);
	at[50] = 45.5000;
	points[51] = (8193.1885, 8550.2363, 3690.9448);
	angles[51] = (0, 16.5806, 0);
	at[51] = 46;
	points[52] = (7767.4805, 9902.1260, 3690.9448);
	angles[52] = (0, 17.4783, 0);
	at[52] = 48;
	points[53] = (7554.1338, 10145.3535, 3667.7007);
	angles[53] = (0, 42.7778, 0);
	at[53] = 48.5000;
	points[54] = (7237.0083, 10296.5361, 3621.8662);
	angles[54] = (0, 59.7758, 0);
	at[54] = 49;
	points[55] = (6919.8428, 10447.7559, 3576.0354);
	angles[55] = (0, 63.4943, 0);
	at[55] = 49.5000;
	points[56] = (5968.3462, 10901.3389, 3438.5354);
	angles[56] = (0, 64.5025, 0);
	at[56] = 51;
	points[57] = (5649.0547, 11042.2832, 3392.1379);
	angles[57] = (0, 67.0216, 0);
	at[57] = 51.5000;
	points[58] = (5299.0156, 11035.5117, 3337.5630);
	angles[58] = (0, 85.8593, 0);
	at[58] = 52;
	points[59] = (4949.0161, 11028.7402, 3282.9844);
	angles[59] = (0, 89.9801, 0);
	at[59] = 52.5000;
	points[60] = (2848.7717, 10988.1494, 2955.5273);
	angles[60] = (0, 91.1074, 0);
	at[60] = 55.5000;
	points[61] = (2545.3977, 10810.1582, 2952.7559);
	angles[61] = (0, 114.8225, 0);
	at[61] = 56;
	points[62] = (2244.5237, 10623.0322, 2952.7559);
	angles[62] = (0, 120.3654, 0);
	at[62] = 56.5000;
	points[63] = (439.2677, 9500.1572, 2952.7559);
	angles[63] = (0, 121.8817, 0);
	at[63] = 59.5000;
	points[64] = (274.6414, 9189.0947, 2952.7559);
	angles[64] = (0, 146.2342, 0);
	at[64] = 60;
	points[65] = (116.8413, 8871.8506, 2952.7559);
	angles[65] = (0, 151.9814, 0);
	at[65] = 60.5000;
	points[66] = (-514.3622, 7602.8350, 2952.7559);
	angles[66] = (0, 153.5511, 0);
	at[66] = 62.5000;
	points[67] = (-1237.9449, 5985.7090, 2952.7559);
	angles[67] = (0, 155.9463, 0);
	at[67] = 65;
	points[68] = (-1388.5511, 5665.1182, 2952.7559);
	angles[68] = (0, 154.5726, 0);
	at[68] = 65.5000;
	points[69] = (-3164.8347, 2195.7993, 2952.7559);
	angles[69] = (0, 152.5159, 0);
	at[69] = 71;
	points[70] = (-4168.1890, 321.4784, 2952.7559);
	angles[70] = (0, 152.5016, 0);
	at[70] = 74;
	points[71] = (-4257.6377, -21.5164, 2952.7559);
	angles[71] = (0, 162.4607, 0);
	at[71] = 74.5000;
	points[72] = (-4438.7402, -706.6496, 2952.7559);
	angles[72] = (0, 165.0691, 0);
	at[72] = 75.5000;
	points[73] = (-4500.2363, -1052.1260, 2952.7559);
	angles[73] = (0, 171.2346, 0);
	at[73] = 76;
	points[74] = (-4479.3701, -1405.8386, 2952.7559);
	angles[74] = (0, 180.7614, 0);
	at[74] = 76.5000;
	points[75] = (-4458.5039, -1759.5552, 2952.7559);
	angles[75] = (0, 183.4911, 0);
	at[75] = 77;
	points[76] = (-4354.0552, -2098.2283, 2952.7559);
	angles[76] = (0, 194.1100, 0);
	at[76] = 77.5000;
	points[77] = (-4146.5356, -2775.8267, 2952.7559);
	angles[77] = (0, 196.8929, 0);
	at[77] = 78.5000;
	points[78] = (-3904.9172, -3022.6694, 2952.7559);
	angles[78] = (0, 220.8692, 0);
	at[78] = 79;
	points[79] = (-3631.9724, -3248.6143, 2952.7559);
	angles[79] = (0, 228.3360, 0);
	at[79] = 79.5000;
	points[80] = (-3359.0276, -3474.5591, 2952.7559);
	angles[80] = (0, 229.9428, 0);
	at[80] = 80;
	points[81] = (-3073.7756, -3682.7915, 2952.7559);
	angles[81] = (0, 234.4387, 0);
	at[81] = 80.5000;
	points[82] = (-2459.8818, -4036.8113, 2952.7559);
	angles[82] = (0, 239.7705, 0);
	at[82] = 81.5000;
	points[83] = (-2149.4961, -4203.4253, 2952.7559);
	angles[83] = (0, 243.2415, 0);
	at[83] = 82;
	points[84] = (-1797.4961, -4243.9761, 2952.7559);
	angles[84] = (0, 259.0554, 0);
	at[84] = 82.5000;
	points[85] = (-1445.4922, -4284.5278, 2952.7559);
	angles[85] = (0, 262.4892, 0);
	at[85] = 83;
	points[86] = (314.5252, -4487.2832, 2952.7559);
	angles[86] = (0, 263.4278, 0);
	at[86] = 85.5000;
	points[87] = (667.1772, -4517.2441, 2952.7559);
	angles[87] = (0, 265.6981, 0);
	at[87] = 86;
	points[88] = (1021.4960, -4519.8818, 2952.7559);
	angles[88] = (0, 268.7411, 0);
	at[88] = 86.5000;
	points[89] = (2438.7834, -4530.4722, 2952.7559);
	angles[89] = (0, 269.5713, 0);
	at[89] = 88.5000;
	points[90] = (2792.0474, -4525.8662, 2952.7559);
	angles[90] = (0, 272.0362, 0);
	at[90] = 89;
	points[91] = (3130.8149, -4422.0078, 2952.7559);
	angles[91] = (0, 283.8071, 0);
	at[91] = 89.5000;
	points[92] = (3469.5786, -4318.1104, 2952.7559);
	angles[92] = (0, 286.3499, 0);
	at[92] = 90;
	points[93] = (4824.6455, -3902.6812, 2952.7559);
	angles[93] = (0, 287.0435, 0);
	at[93] = 92;
	points[94] = (5132.7954, -3736.4646, 2952.7559);
	angles[94] = (0, 298.3323, 0);
	at[94] = 92.5000;
	points[95] = (5422.1655, -3531.9763, 2952.7559);
	angles[95] = (0, 303.7617, 0);
	at[95] = 93;
	points[96] = (6290.2754, -2918.5120, 2952.7559);
	angles[96] = (0, 305.2329, 0);
	at[96] = 94.5000;
	points[97] = (6566.3389, -2703.2834, 2952.7559);
	angles[97] = (0, 309.5975, 0);
	at[97] = 95;
	points[98] = (6705, -2377.2166, 2952.7559);
	angles[98] = (0, 330.9863, 0);
	at[98] = 95.5000;
	points[99] = (6843.7012, -2051.1536, 2952.7559);
	angles[99] = (0, 335.6764, 0);
	at[99] = 96;
	points[100] = (6952.0474, -1721.0630, 2952.7559);
	angles[100] = (0, 343.4634, 0);
	at[100] = 96.5000;
	points[101] = (6903.2280, -1370.1141, 2952.7559);
	angles[101] = (0, 362.5997, 0);
	at[101] = 97;
	points[102] = (6854.4097, -1019.1614, 2952.7559);
	angles[102] = (0, 366.7777, 0);
	at[102] = 97.5000;
	points[103] = (6690.2754, -715.7480, 2952.7559);
	angles[103] = (0, 387.0897, 0);
	at[103] = 98;
	points[104] = (6477.5986, -432.3583, 2952.7559);
	angles[104] = (0, 394.7819, 0);
	at[104] = 98.5000;
	points[105] = (5839.4883, 417.8150, 2952.7559);
	angles[105] = (0, 396.8692, 0);
	at[105] = 100;
	points[106] = (5592.0869, 668.5355, 2952.7559);
	angles[106] = (0, 404.7944, 0);
	at[106] = 100.5000;
	points[107] = (5322.1655, 898.1024, 2952.7559);
	angles[107] = (0, 408.5815, 0);
	at[107] = 101;
	points[108] = (4242.5591, 1816.3740, 2952.7559);
	angles[108] = (0, 409.6150, 0);
	at[108] = 103;
	points[109] = (3917.0747, 1949.0670, 2952.7559);
	angles[109] = (0, 425.0979, 0);
	at[109] = 103.5000;
	points[110] = (3248.1929, 2183.1497, 2952.7559);
	angles[110] = (0, 430.4531, 0);
	at[110] = 104.5000;
	points[111] = (2955.0078, 2367.4292, 2952.7559);
	angles[111] = (0, 417.0658, 0);
	at[111] = 105;
	points[112] = (2699.1809, 2612.5867, 2952.7559);
	angles[112] = (0, 408.5540, 0);
	at[112] = 105.5000;
	points[113] = (2504.2756, 2888.7559, 2952.7559);
	angles[113] = (0, 393.0428, 0);
	at[113] = 106;
	points[114] = (2456.5747, 3239.8623, 2952.7559);
	angles[114] = (0, 373.2477, 0);
	at[114] = 106.5000;
	points[115] = (2408.8740, 3590.9685, 2952.7559);
	angles[115] = (0, 368.9205, 0);
	at[115] = 107;
	points[116] = (2560.4451, 3907.9922, 2952.7559);
	angles[116] = (0, 341.2324, 0);
	at[116] = 107.5000;
	points[117] = (2739.9409, 4202.6772, 2952.7559);
	angles[117] = (0, 327.1303, 0);
	at[117] = 108;
	points[118] = (3075.2678, 4317.1655, 2952.7559);
	angles[118] = (0, 297.3476, 0);
	at[118] = 108.5000;
	points[119] = (3410.5234, 4431.8506, 2952.7559);
	angles[119] = (0, 290.7454, 0);
	at[119] = 109;
	points[120] = (5413.9766, 5143.2285, 2952.7559);
	angles[120] = (0, 289.5487, 0);
	at[120] = 112;
	points[121] = (5722.6377, 5304.3306, 2952.7559);
	angles[121] = (0, 299.0459, 0);
	at[121] = 112.5000;
	points[122] = (5986.7324, 5540.5513, 2952.7559);
	angles[122] = (0, 309.0575, 0);
	at[122] = 113;
	points[123] = (6514.9604, 6012.9531, 2952.7559);
	angles[123] = (0, 311.6798, 0);
	at[123] = 114;
	points[124] = (6740.1572, 6279.6851, 2952.7559);
	angles[124] = (0, 320.9846, 0);
	at[124] = 114.5000;
	points[125] = (6906.5352, 6592.5195, 2952.7559);
	angles[125] = (0, 329.6267, 0);
	at[125] = 115;
	points[126] = (7072.8740, 6905.3545, 2952.7559);
	angles[126] = (0, 331.4880, 0);
	at[126] = 115.5000;
	points[127] = (7184.5674, 7233.9375, 2952.7559);
	angles[127] = (0, 342.7469, 0);
	at[127] = 116;
	points[128] = (7209.9214, 7587.3623, 2952.7559);
	angles[128] = (0, 353.0648, 0);
	at[128] = 116.5000;
	points[129] = (7235.2759, 7940.7876, 2952.7559);
	angles[129] = (0, 355.2903, 0);
	at[129] = 117;
	points[130] = (7221.6533, 8292.4805, 2952.7559);
	angles[130] = (0, 362.9030, 0);
	at[130] = 117.5000;
	points[131] = (7164.8027, 8642.2041, 2952.7559);
	angles[131] = (0, 367.8730, 0);
	at[131] = 118;
	points[132] = (7051.1025, 9341.6934, 2952.7559);
	angles[132] = (0, 369.8774, 0);
	at[132] = 119;
	points[133] = (6907.2837, 9665.8662, 2952.7559);
	angles[133] = (0, 380.5687, 0);
	at[133] = 119.5000;
	points[134] = (6624.6064, 10315.7480, 2952.7559);
	angles[134] = (0, 383.3708, 0);
	at[134] = 120.5000;
	points[135] = (6451.9292, 10625.1182, 2952.7559);
	angles[135] = (0, 387.9514, 0);
	at[135] = 121;
	points[136] = (6106.1416, 11243.7012, 2952.7559);
	angles[136] = (0, 389.1468, 0);
	at[136] = 122;
	points[137] = (5926.1421, 11548.6221, 2952.7559);
	angles[137] = (0, 391.0353, 0);
	at[137] = 122.5000;
	points[138] = (5527.9131, 12134.7637, 2952.7559);
	angles[138] = (0, 394.0469, 0);
	at[138] = 123.5000;
	points[139] = (5320.9448, 12421.7324, 2952.7559);
	angles[139] = (0, 396.5102, 0);
	at[139] = 124;
	points[140] = (5083.8975, 12685.0781, 2952.7559);
	angles[140] = (0, 400.8151, 0);
	at[140] = 124.5000;
	points[141] = (4609.7637, 13211.7725, 2952.7559);
	angles[141] = (0, 402.5070, 0);
	at[141] = 125.5000;
	points[142] = (4324.2520, 13421.8115, 2952.7559);
	angles[142] = (0, 411.0803, 0);
	at[142] = 126;
	points[143] = (4021.2205, 13596.8115, 2952.7559);
	angles[143] = (0, 421.0652, 0);
	at[143] = 126.5000;
	points[144] = (3683.3386, 13703.5439, 2952.7559);
	angles[144] = (0, 430.0167, 0);
	at[144] = 127;
	points[145] = (3343.1812, 13672.4414, 2952.7559);
	angles[145] = (0, 453.5082, 0);
	at[145] = 127.5000;
	points[146] = (3001.9568, 13576.9297, 2952.7559);
	angles[146] = (0, 463.0217, 0);
	at[146] = 128;
	points[147] = (2721.0945, 13361.6533, 2952.7559);
	angles[147] = (0, 482.4470, 0);
	at[147] = 128.5000;
	points[148] = (2461.4646, 13122.4414, 2952.7559);
	angles[148] = (0, 491.9368, 0);
	at[148] = 129;
	points[149] = (2222.7952, 12860.5508, 2952.7559);
	angles[149] = (0, 496.4274, 0);
	at[149] = 129.5000;
	points[150] = (1745.4528, 12336.7715, 2952.7559);
	angles[150] = (0, 497.5992, 0);
	at[150] = 130.5000;
	points[151] = (1515.7048, 12067.5586, 2952.7559);
	angles[151] = (0, 500.0651, 0);
	at[151] = 131;
	points[152] = (1096.1221, 11496.4961, 2952.7559);
	angles[152] = (0, 503.5281, 0);
	at[152] = 132;
	points[153] = (47.1681, 10068.7402, 2952.7559);
	angles[153] = (0, 503.6954, 0);
	at[153] = 134.5000;
	points[154] = (-128.7469, 9762.2441, 2952.7559);
	angles[154] = (0, 509.8835, 0);
	at[154] = 135;
	points[155] = (-1098.8544, 7870.5117, 2952.7559);
	angles[155] = (0, 512.8505, 0);
	at[155] = 138;
	points[156] = (-1253.7677, 7551.8896, 2952.7559);
	angles[156] = (0, 514.1245, 0);
	at[156] = 138.5000;
	points[157] = (-2003.5117, 5946.6934, 2952.7559);
	angles[157] = (0, 515.4182, 0);
	at[157] = 141;
	points[158] = (-2100.4568, 5605.8667, 2952.7559);
	angles[158] = (0, 522.2250, 0);
	at[158] = 141.5000;
	points[159] = (-2197.5906, 5265.1177, 2952.7559);
	angles[159] = (0, 523.6891, 0);
	at[159] = 142;
	points[160] = (-2217.4607, 4914.8818, 2952.7559);
	angles[160] = (0, 536.0211, 0);
	at[160] = 142.5000;
	points[161] = (-2205.6221, 4560.7480, 2952.7559);
	angles[161] = (0, 540.6486, 0);
	at[161] = 143;
	points[162] = (-2154.1575, 4216.4565, 2952.7559);
	angles[162] = (0, 550.4128, 0);
	at[162] = 143.5000;
	points[163] = (-1998.8818, 3897.9529, 2952.7559);
	angles[163] = (0, 562.6286, 0);
	at[163] = 144;
	points[164] = (-1770.7244, 3640.6577, 2952.7559);
	angles[164] = (0, 581.3781, 0);
	at[164] = 144.5000;
	points[165] = (-1477.6615, 3442.3896, 2952.7559);
	angles[165] = (0, 593.8311, 0);
	at[165] = 145;
	points[166] = (-1164.6182, 3277.4688, 2952.7559);
	angles[166] = (0, 601.2250, 0);
	at[166] = 145.5000;
	points[167] = (-833.4803, 3151.3857, 2952.7559);
	angles[167] = (0, 607.4508, 0);
	at[167] = 146;
	points[168] = (-516.8071, 3009.1101, 2891.6064);
	angles[168] = (0, 605.7672, 0);
	at[168] = 146.5000;
	points[169] = (-204.5476, 2861.8860, 2811.7876);
	angles[169] = (0, 604.9766, 0);
	at[169] = 147;
	points[170] = (-96.9382, 2779.9451, 2498.6101);
	angles[170] = (0, 597.6841, 0);
	at[170] = 147.5000;
	points[171] = (78.4602, 2630.1064, 1828.5552);
	angles[171] = (0, 590.1365, 0);
	at[171] = 148.5000;
	points[172] = (206.8740, 2510.0435, 1579.7245);
	angles[172] = (0, 585.2574, 0);
	at[172] = 149;
	points[173] = (243.1020, 2424.6929, 1579.7245);
	angles[173] = (0, 575.6218, 0);
	at[173] = 149.1330;
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
