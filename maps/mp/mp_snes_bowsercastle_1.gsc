main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_snes_bowsercastle_1", 0);

	setExpFog(5905.5117, 64960.6250, 1, 0.4314, 0, 0);

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
	ambientPlay("iz_0_3", 2);
	level thread iz_music("iz_7_se_cr_gbk_env");
}

iz_music(alias)
{
	for (;;)
	{
		level waittill("connected", player);
		player thread iz_music_player(alias);
	}
}

iz_music_player(alias)
{
	self endon("disconnect");
	self waittill("spawned_player");
	self playLocalSound(alias);
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
	level.iz_route[level.iz_route.size] = (-4774, 3576, 849);
	level.iz_route[level.iz_route.size] = (-4783, 1195, 849);
	level.iz_route[level.iz_route.size] = (-4793, -1839, 849);
	level.iz_route[level.iz_route.size] = (-4801, -5052, 849);
	level.iz_route[level.iz_route.size] = (-4704, -5722, 849);
	level.iz_route[level.iz_route.size] = (-4321, -6026, 849);
	level.iz_route[level.iz_route.size] = (-3658, -6230, 849);
	level.iz_route[level.iz_route.size] = (-2326, -6384, 849);
	level.iz_route[level.iz_route.size] = (-595, -6370, 849);
	level.iz_route[level.iz_route.size] = (-64, -6052, 849);
	level.iz_route[level.iz_route.size] = (213, -5859, 849);
	level.iz_route[level.iz_route.size] = (655, -5715, 849);
	level.iz_route[level.iz_route.size] = (1238, -5737, 849);
	level.iz_route[level.iz_route.size] = (1644, -5852, 849);
	level.iz_route[level.iz_route.size] = (2046, -6103, 849);
	level.iz_route[level.iz_route.size] = (2390, -6132, 849);
	level.iz_route[level.iz_route.size] = (3270, -6139, 849);
	level.iz_route[level.iz_route.size] = (4234, -6084, 849);
	level.iz_route[level.iz_route.size] = (4624, -5839, 849);
	level.iz_route[level.iz_route.size] = (4866, -5567, 849);
	level.iz_route[level.iz_route.size] = (5098, -5229, 849);
	level.iz_route[level.iz_route.size] = (5250, -4802, 849);
	level.iz_route[level.iz_route.size] = (5292, -4218, 849);
	level.iz_route[level.iz_route.size] = (4749, -3196, 849);
	level.iz_route[level.iz_route.size] = (4649, -1304, 849);
	level.iz_route[level.iz_route.size] = (4623, 2144, 849);
	level.iz_route[level.iz_route.size] = (5273, 3800, 849);
	level.iz_route[level.iz_route.size] = (5196, 4835, 849);
	level.iz_route[level.iz_route.size] = (4915, 5214, 849);
	level.iz_route[level.iz_route.size] = (4262, 5341, 849);
	level.iz_route[level.iz_route.size] = (3436, 5359, 849);
	level.iz_route[level.iz_route.size] = (2454, 5293, 849);
	level.iz_route[level.iz_route.size] = (1930, 5110, 849);
	level.iz_route[level.iz_route.size] = (1699, 4837, 849);
	level.iz_route[level.iz_route.size] = (1556, 4521, 849);
	level.iz_route[level.iz_route.size] = (1483, 4145, 879);
	level.iz_route[level.iz_route.size] = (1440, 3573, 930);
	level.iz_route[level.iz_route.size] = (1428, 3035, 857);
	level.iz_route[level.iz_route.size] = (1428, 1225, 930);
	level.iz_route[level.iz_route.size] = (1419, 368, 865);
	level.iz_route[level.iz_route.size] = (1436, -1280, 932);
	level.iz_route[level.iz_route.size] = (1427, -2283, 849);
	level.iz_route[level.iz_route.size] = (1385, -2804, 849);
	level.iz_route[level.iz_route.size] = (1105, -3149, 849);
	level.iz_route[level.iz_route.size] = (722, -3394, 849);
	level.iz_route[level.iz_route.size] = (27, -3518, 849);
	level.iz_route[level.iz_route.size] = (-612, -3527, 849);
	level.iz_route[level.iz_route.size] = (-1134, -3473, 849);
	level.iz_route[level.iz_route.size] = (-1503, -3275, 849);
	level.iz_route[level.iz_route.size] = (-1767, -2956, 849);
	level.iz_route[level.iz_route.size] = (-1952, -2497, 874);
	level.iz_route[level.iz_route.size] = (-1972, -2071, 905);
	level.iz_route[level.iz_route.size] = (-1956, -557, 876);
	level.iz_route[level.iz_route.size] = (-1964, 591, 924);
	level.iz_route[level.iz_route.size] = (-1953, 1630, 870);
	level.iz_route[level.iz_route.size] = (-1963, 2924, 924);
	level.iz_route[level.iz_route.size] = (-1977, 3846, 849);
	level.iz_route[level.iz_route.size] = (-1988, 4950, 849);
	level.iz_route[level.iz_route.size] = (-1982, 5458, 849);
	level.iz_route[level.iz_route.size] = (-2137, 5928, 849);
	level.iz_route[level.iz_route.size] = (-2453, 6060, 849);
	level.iz_route[level.iz_route.size] = (-3185, 6082, 849);
	level.iz_route[level.iz_route.size] = (-4172, 6045, 849);
	level.iz_route[level.iz_route.size] = (-4569, 5765, 849);
	level.iz_route[level.iz_route.size] = (-4744, 5325, 849);
	level.iz_route[level.iz_route.size] = (-4787, 4730, 849);
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
	thread iz_obj_10();
	thread iz_obj_11();
	thread iz_obj_12();
	thread iz_obj_13();
	thread iz_obj_14();
	thread iz_obj_15();
	thread iz_obj_16();
	thread iz_obj_17();
	thread iz_obj_18();
	thread iz_obj_19();
	thread iz_obj_20();
	thread iz_obj_21();
	thread iz_obj_22();
	thread iz_obj_23();
	thread iz_obj_24();
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (5343.3462, 6862.8345, 1456.0709);
	angles[0] = (0, -180, 80.1092);
	at[0] = 0;
	points[1] = (5343.3462, 6862.8345, 1456.0709);
	angles[1] = (0, -180, 80.1092);
	at[1] = 0.1500;
	points[2] = (5146.4961, 7125.1577, 1446.6221);
	angles[2] = (0, -180, 213.1019);
	at[2] = 0.2000;
	points[3] = (5146.4961, 6776.1025, 1414.7323);
	angles[3] = (0, -180, 222.1020);
	at[3] = 0.2500;
	points[4] = (5146.4961, 6427.0469, 1377.5276);
	angles[4] = (0, -180, 231.1021);
	at[4] = 0.3000;
	points[5] = (5146.4961, 6077.9922, 1335.0078);
	angles[5] = (0, -180, 240.1023);
	at[5] = 0.3500;
	points[6] = (5146.4961, 5728.9370, 1287.1732);
	angles[6] = (0, -180, 249.1023);
	at[6] = 0.4000;
	points[7] = (5146.4961, 5379.8818, 1234.0237);
	angles[7] = (0, -180, 258.1024);
	at[7] = 0.4500;
	points[8] = (5146.4961, 5030.8267, 1175.5591);
	angles[8] = (0, -180, 267.1026);
	at[8] = 0.5000;
	points[9] = (5146.4961, 4681.7715, 1151.7480);
	angles[9] = (0, -180, 290.1027);
	at[9] = 0.5500;
	points[10] = (5146.4961, 4332.7168, 1171.9449);
	angles[10] = (0, -180, 320.1029);
	at[10] = 0.6000;
	points[11] = (5146.4961, 3983.6614, 1186.8268);
	angles[11] = (0, -180, 350.1030);
	at[11] = 0.6500;
	points[12] = (5146.4961, 3634.6064, 1210.9213);
	angles[12] = (0, -180, 380.1032);
	at[12] = 0.7000;
	points[13] = (5146.4961, 3516.3503, 1258.7560);
	angles[13] = (0, -180, 410.1034);
	at[13] = 0.7500;
	points[14] = (5146.4961, 3398.2402, 1301.2755);
	angles[14] = (0, -180, 440.1035);
	at[14] = 0.8000;
	points[15] = (5146.4961, 3280.1299, 1338.4802);
	angles[15] = (0, -180, 470.1038);
	at[15] = 0.8500;
	points[16] = (5146.4961, 3162.0198, 1370.3701);
	angles[16] = (0, -180, 500.1038);
	at[16] = 0.9000;
	points[17] = (5146.4961, 3043.9094, 1396.9448);
	angles[17] = (0, -180, 530.1040);
	at[17] = 0.9500;
	points[18] = (5146.4961, 2925.7993, 1418.2047);
	angles[18] = (0, -180, 560.1041);
	at[18] = 1;
	points[19] = (5146.4961, 2807.6890, 1434.1495);
	angles[19] = (0, -180, 590.1042);
	at[19] = 1.0500;
	points[20] = (5146.4961, 2689.5789, 1444.7795);
	angles[20] = (0, -180, 620.1045);
	at[20] = 1.1000;
	points[21] = (5146.4961, 2571.4685, 1450.0946);
	angles[21] = (0, -180, 650.1047);
	at[21] = 1.1500;
	points[22] = (5146.4961, 2453.3584, 1450.0946);
	angles[22] = (0, -180, 680.1047);
	at[22] = 1.2000;
	points[23] = (5146.4961, 2335.2480, 1444.7795);
	angles[23] = (0, -180, 710.1049);
	at[23] = 1.2500;
	points[24] = (5146.4961, 2217.1379, 1434.1495);
	angles[24] = (0, -180, 740.1050);
	at[24] = 1.3000;
	points[25] = (5146.4961, 2099.0276, 1418.2047);
	angles[25] = (0, -180, 770.1052);
	at[25] = 1.3500;
	points[26] = (5146.4961, 1980.9174, 1396.9448);
	angles[26] = (0, -180, 800.1052);
	at[26] = 1.4000;
	points[27] = (5146.4961, 1862.8071, 1370.3701);
	angles[27] = (0, -180, 830.1055);
	at[27] = 1.4500;
	points[28] = (5146.4961, 1744.6969, 1338.4802);
	angles[28] = (0, -180, 860.1055);
	at[28] = 1.5000;
	points[29] = (5146.4961, 1626.5867, 1301.2755);
	angles[29] = (0, -180, 890.1057);
	at[29] = 1.5500;
	points[30] = (5146.4961, 1508.4764, 1258.7560);
	angles[30] = (0, -180, 920.1060);
	at[30] = 1.6000;
	points[31] = (5146.4961, 1390.3662, 1210.9213);
	angles[31] = (0, -180, 950.1061);
	at[31] = 1.6500;
	points[32] = (5146.4961, 1272.2559, 1157.7717);
	angles[32] = (0, -180, 980.1063);
	at[32] = 1.7000;
	points[33] = (5146.4961, 1154.1456, 1157.1812);
	angles[33] = (0, -180, 1010.1063);
	at[33] = 1.7500;
	points[34] = (5146.4961, 1036.0354, 1172.7717);
	angles[34] = (0, -180, 1040.1066);
	at[34] = 1.8000;
	points[35] = (5146.4961, 917.9252, 1183.0472);
	angles[35] = (0, -180, 1070.1067);
	at[35] = 1.8500;
	points[36] = (5146.4961, 799.8149, 1188.0079);
	angles[36] = (0, -180, 1100.1069);
	at[36] = 1.9000;
	points[37] = (5146.4961, 681.7047, 1187.6536);
	angles[37] = (0, -180, 1130.1071);
	at[37] = 1.9500;
	points[38] = (5146.4961, 563.5945, 1181.9843);
	angles[38] = (0, -180, 1160.1072);
	at[38] = 2;
	points[39] = (5146.4961, 445.4843, 1171);
	angles[39] = (0, -180, 1190.1073);
	at[39] = 2.0500;
	points[40] = (5146.4961, 327.3744, 1154.7008);
	angles[40] = (0, -180, 1220.1075);
	at[40] = 2.1000;
	points[41] = (5146.4961, 209.2642, 1146.1260);
	angles[41] = (0, -180, 1250.1077);
	at[41] = 2.1500;
	points[42] = (5146.4961, 91.1539, 1149.4567);
	angles[42] = (0, -180, 1280.1079);
	at[42] = 2.2000;
	points[43] = (5146.4961, -263.1764, 1143.8347);
	angles[43] = (0, -180, 1370.1083);
	at[43] = 2.3500;
	points[44] = (5146.4961, -735.6181, 1143.8347);
	angles[44] = (0, -180, 1490.1090);
	at[44] = 2.5500;
	points[45] = (5146.4961, -814.3583, 1143.8347);
	angles[45] = (0, -180, 1510.1091);
	at[45] = 2.6000;
	points[46] = (5343.3462, 6862.8345, 1456.0709);
	angles[46] = (0, -180, 1520.1091);
	at[46] = 2.6000;
	points[47] = (5343.3462, 6862.8345, 1456.0709);
	angles[47] = (0, -180, 1520.1091);
	at[47] = 3.5167;
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
	points[0] = (934.4843, -5472.7954, 948.9528);
	angles[0] = (0, 90, 0);
	at[0] = 0;
	points[1] = (934.4843, -5472.7954, 1028.6772);
	angles[1] = (0, 90, 0);
	at[1] = 0.4500;
	points[2] = (934.4843, -5472.7954, 1033.4646);
	angles[2] = (0, 90, 0);
	at[2] = 0.5000;
	points[3] = (934.4843, -5472.7954, 1033.4646);
	angles[3] = (0, 90, 0);
	at[3] = 1.9500;
	points[4] = (934.4843, -5472.7954, 1041.1378);
	angles[4] = (0, 90, 0);
	at[4] = 2;
	points[5] = (934.4843, -5472.7954, 1037.8937);
	angles[5] = (0, 90, 0);
	at[5] = 2.0500;
	points[6] = (934.4843, -5472.7954, 1025.7914);
	angles[6] = (0, 90, 0);
	at[6] = 2.1000;
	points[7] = (934.4843, -5472.7954, 1029.0355);
	angles[7] = (0, 90, 0);
	at[7] = 2.1500;
	points[8] = (934.4843, -5472.7954, 1041.1378);
	angles[8] = (0, 90, 0);
	at[8] = 2.2000;
	points[9] = (934.4843, -5472.7954, 1037.8937);
	angles[9] = (0, 90, 0);
	at[9] = 2.2500;
	points[10] = (934.4843, -5472.7954, 1025.7914);
	angles[10] = (0, 90, 0);
	at[10] = 2.3000;
	points[11] = (934.4843, -5472.7954, 1029.0355);
	angles[11] = (0, 90, 0);
	at[11] = 2.3500;
	points[12] = (934.4843, -5472.7954, 1041.1378);
	angles[12] = (0, 90, 0);
	at[12] = 2.4000;
	points[13] = (934.4843, -5472.7954, 1037.8937);
	angles[13] = (0, 90, 0);
	at[13] = 2.4500;
	points[14] = (934.4843, -5472.7954, 1043.7992);
	angles[14] = (0, 90, 0);
	at[14] = 2.5000;
	points[15] = (934.4843, -5472.7954, 1176.6732);
	angles[15] = (0, 90, 0);
	at[15] = 2.6500;
	points[16] = (934.4843, -5472.7954, 1146.5551);
	angles[16] = (0, 90, 0);
	at[16] = 2.7000;
	points[17] = (934.4843, -5472.7954, 1071.2598);
	angles[17] = (0, 90, 0);
	at[17] = 2.7500;
	points[18] = (934.4843, -5472.7954, 950.7874);
	angles[18] = (0, 90, 0);
	at[18] = 2.8000;
	points[19] = (934.4843, -5472.7954, 848.5591);
	angles[19] = (0, 90, 0);
	at[19] = 2.8500;
	points[20] = (934.4843, -5472.7954, 848.5591);
	angles[20] = (0, 90, 0);
	at[20] = 3.8000;
	points[21] = (934.4843, -5472.7954, 851.5118);
	angles[21] = (0, 90, 0);
	at[21] = 3.8500;
	points[22] = (934.4843, -5472.7954, 948.9528);
	angles[22] = (0, 90, 0);
	at[22] = 4.4000;
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
	points[0] = (2495.4172, -6389.1733, 948.9528);
	angles[0] = (0, 90, 0);
	at[0] = 0;
	points[1] = (2495.4172, -6389.1733, 1028.6772);
	angles[1] = (0, 90, 0);
	at[1] = 0.4500;
	points[2] = (2495.4172, -6389.1733, 1033.4646);
	angles[2] = (0, 90, 0);
	at[2] = 0.5000;
	points[3] = (2495.4172, -6389.1733, 1033.4646);
	angles[3] = (0, 90, 0);
	at[3] = 1.9500;
	points[4] = (2495.4172, -6389.1733, 1041.1378);
	angles[4] = (0, 90, 0);
	at[4] = 2;
	points[5] = (2495.4172, -6389.1733, 1037.8937);
	angles[5] = (0, 90, 0);
	at[5] = 2.0500;
	points[6] = (2495.4172, -6389.1733, 1025.7914);
	angles[6] = (0, 90, 0);
	at[6] = 2.1000;
	points[7] = (2495.4172, -6389.1733, 1029.0355);
	angles[7] = (0, 90, 0);
	at[7] = 2.1500;
	points[8] = (2495.4172, -6389.1733, 1041.1378);
	angles[8] = (0, 90, 0);
	at[8] = 2.2000;
	points[9] = (2495.4172, -6389.1733, 1037.8937);
	angles[9] = (0, 90, 0);
	at[9] = 2.2500;
	points[10] = (2495.4172, -6389.1733, 1025.7914);
	angles[10] = (0, 90, 0);
	at[10] = 2.3000;
	points[11] = (2495.4172, -6389.1733, 1029.0355);
	angles[11] = (0, 90, 0);
	at[11] = 2.3500;
	points[12] = (2495.4172, -6389.1733, 1041.1378);
	angles[12] = (0, 90, 0);
	at[12] = 2.4000;
	points[13] = (2495.4172, -6389.1733, 1037.8937);
	angles[13] = (0, 90, 0);
	at[13] = 2.4500;
	points[14] = (2495.4172, -6389.1733, 1043.7992);
	angles[14] = (0, 90, 0);
	at[14] = 2.5000;
	points[15] = (2495.4172, -6389.1733, 1176.6732);
	angles[15] = (0, 90, 0);
	at[15] = 2.6500;
	points[16] = (2495.4172, -6389.1733, 1146.5551);
	angles[16] = (0, 90, 0);
	at[16] = 2.7000;
	points[17] = (2495.4172, -6389.1733, 1071.2598);
	angles[17] = (0, 90, 0);
	at[17] = 2.7500;
	points[18] = (2495.4172, -6389.1733, 950.7874);
	angles[18] = (0, 90, 0);
	at[18] = 2.8000;
	points[19] = (2495.4172, -6389.1733, 848.5591);
	angles[19] = (0, 90, 0);
	at[19] = 2.8500;
	points[20] = (2495.4172, -6389.1733, 848.5591);
	angles[20] = (0, 90, 0);
	at[20] = 3.8000;
	points[21] = (2495.4172, -6389.1733, 851.5118);
	angles[21] = (0, 90, 0);
	at[21] = 3.8500;
	points[22] = (2495.4172, -6389.1733, 948.9528);
	angles[22] = (0, 90, 0);
	at[22] = 4.4000;
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
	points[0] = (-675.0906, -6452.0864, 948.9528);
	angles[0] = (0, 90, 0);
	at[0] = 0;
	points[1] = (-675.0906, -6452.0864, 1028.6772);
	angles[1] = (0, 90, 0);
	at[1] = 0.4500;
	points[2] = (-675.0906, -6452.0864, 1033.4646);
	angles[2] = (0, 90, 0);
	at[2] = 0.5000;
	points[3] = (-675.0906, -6452.0864, 1033.4646);
	angles[3] = (0, 90, 0);
	at[3] = 1.9500;
	points[4] = (-675.0906, -6452.0864, 1041.1378);
	angles[4] = (0, 90, 0);
	at[4] = 2;
	points[5] = (-675.0906, -6452.0864, 1037.8937);
	angles[5] = (0, 90, 0);
	at[5] = 2.0500;
	points[6] = (-675.0906, -6452.0864, 1025.7914);
	angles[6] = (0, 90, 0);
	at[6] = 2.1000;
	points[7] = (-675.0906, -6452.0864, 1029.0355);
	angles[7] = (0, 90, 0);
	at[7] = 2.1500;
	points[8] = (-675.0906, -6452.0864, 1041.1378);
	angles[8] = (0, 90, 0);
	at[8] = 2.2000;
	points[9] = (-675.0906, -6452.0864, 1037.8937);
	angles[9] = (0, 90, 0);
	at[9] = 2.2500;
	points[10] = (-675.0906, -6452.0864, 1025.7914);
	angles[10] = (0, 90, 0);
	at[10] = 2.3000;
	points[11] = (-675.0906, -6452.0864, 1029.0355);
	angles[11] = (0, 90, 0);
	at[11] = 2.3500;
	points[12] = (-675.0906, -6452.0864, 1041.1378);
	angles[12] = (0, 90, 0);
	at[12] = 2.4000;
	points[13] = (-675.0906, -6452.0864, 1037.8937);
	angles[13] = (0, 90, 0);
	at[13] = 2.4500;
	points[14] = (-675.0906, -6452.0864, 1043.7992);
	angles[14] = (0, 90, 0);
	at[14] = 2.5000;
	points[15] = (-675.0906, -6452.0864, 1176.6732);
	angles[15] = (0, 90, 0);
	at[15] = 2.6500;
	points[16] = (-675.0906, -6452.0864, 1146.5551);
	angles[16] = (0, 90, 0);
	at[16] = 2.7000;
	points[17] = (-675.0906, -6452.0864, 1071.2598);
	angles[17] = (0, 90, 0);
	at[17] = 2.7500;
	points[18] = (-675.0906, -6452.0864, 950.7874);
	angles[18] = (0, 90, 0);
	at[18] = 2.8000;
	points[19] = (-675.0906, -6452.0864, 848.5591);
	angles[19] = (0, 90, 0);
	at[19] = 2.8500;
	points[20] = (-675.0906, -6452.0864, 848.5591);
	angles[20] = (0, 90, 0);
	at[20] = 3.8000;
	points[21] = (-675.0906, -6452.0864, 851.5118);
	angles[21] = (0, 90, 0);
	at[21] = 3.8500;
	points[22] = (-675.0906, -6452.0864, 948.9528);
	angles[22] = (0, 90, 0);
	at[22] = 4.4000;
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
	points[0] = (94.0850, -3904.1497, 948.9528);
	angles[0] = (0, -90, 0);
	at[0] = 0;
	points[1] = (94.0850, -3904.1497, 1028.6772);
	angles[1] = (0, -90, 0);
	at[1] = 0.4500;
	points[2] = (94.0850, -3904.1497, 1033.4646);
	angles[2] = (0, -90, 0);
	at[2] = 0.5000;
	points[3] = (94.0850, -3904.1497, 1033.4646);
	angles[3] = (0, -90, 0);
	at[3] = 1.9500;
	points[4] = (94.0850, -3904.1497, 1041.1378);
	angles[4] = (0, -90, 0);
	at[4] = 2;
	points[5] = (94.0850, -3904.1497, 1037.8937);
	angles[5] = (0, -90, 0);
	at[5] = 2.0500;
	points[6] = (94.0850, -3904.1497, 1025.7914);
	angles[6] = (0, -90, 0);
	at[6] = 2.1000;
	points[7] = (94.0850, -3904.1497, 1029.0355);
	angles[7] = (0, -90, 0);
	at[7] = 2.1500;
	points[8] = (94.0850, -3904.1497, 1041.1378);
	angles[8] = (0, -90, 0);
	at[8] = 2.2000;
	points[9] = (94.0850, -3904.1497, 1037.8937);
	angles[9] = (0, -90, 0);
	at[9] = 2.2500;
	points[10] = (94.0850, -3904.1497, 1025.7914);
	angles[10] = (0, -90, 0);
	at[10] = 2.3000;
	points[11] = (94.0850, -3904.1497, 1029.0355);
	angles[11] = (0, -90, 0);
	at[11] = 2.3500;
	points[12] = (94.0850, -3904.1497, 1041.1378);
	angles[12] = (0, -90, 0);
	at[12] = 2.4000;
	points[13] = (94.0850, -3904.1497, 1037.8937);
	angles[13] = (0, -90, 0);
	at[13] = 2.4500;
	points[14] = (94.0850, -3904.1497, 1043.7992);
	angles[14] = (0, -90, 0);
	at[14] = 2.5000;
	points[15] = (94.0850, -3904.1497, 1176.6732);
	angles[15] = (0, -90, 0);
	at[15] = 2.6500;
	points[16] = (94.0850, -3904.1497, 1146.5551);
	angles[16] = (0, -90, 0);
	at[16] = 2.7000;
	points[17] = (94.0850, -3904.1497, 1071.2598);
	angles[17] = (0, -90, 0);
	at[17] = 2.7500;
	points[18] = (94.0850, -3904.1497, 950.7874);
	angles[18] = (0, -90, 0);
	at[18] = 2.8000;
	points[19] = (94.0850, -3904.1497, 848.5591);
	angles[19] = (0, -90, 0);
	at[19] = 2.8500;
	points[20] = (94.0850, -3904.1497, 848.5591);
	angles[20] = (0, -90, 0);
	at[20] = 3.8000;
	points[21] = (94.0850, -3904.1497, 851.5118);
	angles[21] = (0, -90, 0);
	at[21] = 3.8500;
	points[22] = (94.0850, -3904.1497, 948.9528);
	angles[22] = (0, -90, 0);
	at[22] = 4.4000;
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
	points[0] = (-1144.4448, -3341.7087, 948.9528);
	angles[0] = (0, -90, 0);
	at[0] = 0;
	points[1] = (-1144.4448, -3341.7087, 1028.6772);
	angles[1] = (0, -90, 0);
	at[1] = 0.4500;
	points[2] = (-1144.4448, -3341.7087, 1033.4646);
	angles[2] = (0, -90, 0);
	at[2] = 0.5000;
	points[3] = (-1144.4448, -3341.7087, 1033.4646);
	angles[3] = (0, -90, 0);
	at[3] = 1.9500;
	points[4] = (-1144.4448, -3341.7087, 1041.1378);
	angles[4] = (0, -90, 0);
	at[4] = 2;
	points[5] = (-1144.4448, -3341.7087, 1037.8937);
	angles[5] = (0, -90, 0);
	at[5] = 2.0500;
	points[6] = (-1144.4448, -3341.7087, 1025.7914);
	angles[6] = (0, -90, 0);
	at[6] = 2.1000;
	points[7] = (-1144.4448, -3341.7087, 1029.0355);
	angles[7] = (0, -90, 0);
	at[7] = 2.1500;
	points[8] = (-1144.4448, -3341.7087, 1041.1378);
	angles[8] = (0, -90, 0);
	at[8] = 2.2000;
	points[9] = (-1144.4448, -3341.7087, 1037.8937);
	angles[9] = (0, -90, 0);
	at[9] = 2.2500;
	points[10] = (-1144.4448, -3341.7087, 1025.7914);
	angles[10] = (0, -90, 0);
	at[10] = 2.3000;
	points[11] = (-1144.4448, -3341.7087, 1029.0355);
	angles[11] = (0, -90, 0);
	at[11] = 2.3500;
	points[12] = (-1144.4448, -3341.7087, 1041.1378);
	angles[12] = (0, -90, 0);
	at[12] = 2.4000;
	points[13] = (-1144.4448, -3341.7087, 1037.8937);
	angles[13] = (0, -90, 0);
	at[13] = 2.4500;
	points[14] = (-1144.4448, -3341.7087, 1043.7992);
	angles[14] = (0, -90, 0);
	at[14] = 2.5000;
	points[15] = (-1144.4448, -3341.7087, 1176.6732);
	angles[15] = (0, -90, 0);
	at[15] = 2.6500;
	points[16] = (-1144.4448, -3341.7087, 1146.5551);
	angles[16] = (0, -90, 0);
	at[16] = 2.7000;
	points[17] = (-1144.4448, -3341.7087, 1071.2598);
	angles[17] = (0, -90, 0);
	at[17] = 2.7500;
	points[18] = (-1144.4448, -3341.7087, 950.7874);
	angles[18] = (0, -90, 0);
	at[18] = 2.8000;
	points[19] = (-1144.4448, -3341.7087, 848.5591);
	angles[19] = (0, -90, 0);
	at[19] = 2.8500;
	points[20] = (-1144.4448, -3341.7087, 848.5591);
	angles[20] = (0, -90, 0);
	at[20] = 3.8000;
	points[21] = (-1144.4448, -3341.7087, 851.5118);
	angles[21] = (0, -90, 0);
	at[21] = 3.8500;
	points[22] = (-1144.4448, -3341.7087, 948.9528);
	angles[22] = (0, -90, 0);
	at[22] = 4.4000;
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
	points[0] = (-4473.1494, -4439.5669, 948.9528);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-4473.1494, -4439.5669, 1028.6772);
	angles[1] = (0, 0, 0);
	at[1] = 0.4500;
	points[2] = (-4473.1494, -4439.5669, 1033.4646);
	angles[2] = (0, 0, 0);
	at[2] = 0.5000;
	points[3] = (-4473.1494, -4439.5669, 1033.4646);
	angles[3] = (0, 0, 0);
	at[3] = 1.9500;
	points[4] = (-4473.1494, -4439.5669, 1041.1378);
	angles[4] = (0, 0, 0);
	at[4] = 2;
	points[5] = (-4473.1494, -4439.5669, 1037.8937);
	angles[5] = (0, 0, 0);
	at[5] = 2.0500;
	points[6] = (-4473.1494, -4439.5669, 1025.7914);
	angles[6] = (0, 0, 0);
	at[6] = 2.1000;
	points[7] = (-4473.1494, -4439.5669, 1029.0355);
	angles[7] = (0, 0, 0);
	at[7] = 2.1500;
	points[8] = (-4473.1494, -4439.5669, 1041.1378);
	angles[8] = (0, 0, 0);
	at[8] = 2.2000;
	points[9] = (-4473.1494, -4439.5669, 1037.8937);
	angles[9] = (0, 0, 0);
	at[9] = 2.2500;
	points[10] = (-4473.1494, -4439.5669, 1025.7914);
	angles[10] = (0, 0, 0);
	at[10] = 2.3000;
	points[11] = (-4473.1494, -4439.5669, 1029.0355);
	angles[11] = (0, 0, 0);
	at[11] = 2.3500;
	points[12] = (-4473.1494, -4439.5669, 1041.1378);
	angles[12] = (0, 0, 0);
	at[12] = 2.4000;
	points[13] = (-4473.1494, -4439.5669, 1037.8937);
	angles[13] = (0, 0, 0);
	at[13] = 2.4500;
	points[14] = (-4473.1494, -4439.5669, 1043.7992);
	angles[14] = (0, 0, 0);
	at[14] = 2.5000;
	points[15] = (-4473.1494, -4439.5669, 1176.6732);
	angles[15] = (0, 0, 0);
	at[15] = 2.6500;
	points[16] = (-4473.1494, -4439.5669, 1146.5551);
	angles[16] = (0, 0, 0);
	at[16] = 2.7000;
	points[17] = (-4473.1494, -4439.5669, 1071.2598);
	angles[17] = (0, 0, 0);
	at[17] = 2.7500;
	points[18] = (-4473.1494, -4439.5669, 950.7874);
	angles[18] = (0, 0, 0);
	at[18] = 2.8000;
	points[19] = (-4473.1494, -4439.5669, 848.5591);
	angles[19] = (0, 0, 0);
	at[19] = 2.8500;
	points[20] = (-4473.1494, -4439.5669, 848.5591);
	angles[20] = (0, 0, 0);
	at[20] = 3.8000;
	points[21] = (-4473.1494, -4439.5669, 851.5118);
	angles[21] = (0, 0, 0);
	at[21] = 3.8500;
	points[22] = (-4473.1494, -4439.5669, 948.9528);
	angles[22] = (0, 0, 0);
	at[22] = 4.4000;
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
	points[0] = (-5252.1265, -4444.7246, 948.9528);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-5252.1265, -4444.7246, 1028.6772);
	angles[1] = (0, 0, 0);
	at[1] = 0.4500;
	points[2] = (-5252.1265, -4444.7246, 1033.4646);
	angles[2] = (0, 0, 0);
	at[2] = 0.5000;
	points[3] = (-5252.1265, -4444.7246, 1033.4646);
	angles[3] = (0, 0, 0);
	at[3] = 1.9500;
	points[4] = (-5252.1265, -4444.7246, 1041.1378);
	angles[4] = (0, 0, 0);
	at[4] = 2;
	points[5] = (-5252.1265, -4444.7246, 1037.8937);
	angles[5] = (0, 0, 0);
	at[5] = 2.0500;
	points[6] = (-5252.1265, -4444.7246, 1025.7914);
	angles[6] = (0, 0, 0);
	at[6] = 2.1000;
	points[7] = (-5252.1265, -4444.7246, 1029.0355);
	angles[7] = (0, 0, 0);
	at[7] = 2.1500;
	points[8] = (-5252.1265, -4444.7246, 1041.1378);
	angles[8] = (0, 0, 0);
	at[8] = 2.2000;
	points[9] = (-5252.1265, -4444.7246, 1037.8937);
	angles[9] = (0, 0, 0);
	at[9] = 2.2500;
	points[10] = (-5252.1265, -4444.7246, 1025.7914);
	angles[10] = (0, 0, 0);
	at[10] = 2.3000;
	points[11] = (-5252.1265, -4444.7246, 1029.0355);
	angles[11] = (0, 0, 0);
	at[11] = 2.3500;
	points[12] = (-5252.1265, -4444.7246, 1041.1378);
	angles[12] = (0, 0, 0);
	at[12] = 2.4000;
	points[13] = (-5252.1265, -4444.7246, 1037.8937);
	angles[13] = (0, 0, 0);
	at[13] = 2.4500;
	points[14] = (-5252.1265, -4444.7246, 1043.7992);
	angles[14] = (0, 0, 0);
	at[14] = 2.5000;
	points[15] = (-5252.1265, -4444.7246, 1176.6732);
	angles[15] = (0, 0, 0);
	at[15] = 2.6500;
	points[16] = (-5252.1265, -4444.7246, 1146.5551);
	angles[16] = (0, 0, 0);
	at[16] = 2.7000;
	points[17] = (-5252.1265, -4444.7246, 1071.2598);
	angles[17] = (0, 0, 0);
	at[17] = 2.7500;
	points[18] = (-5252.1265, -4444.7246, 950.7874);
	angles[18] = (0, 0, 0);
	at[18] = 2.8000;
	points[19] = (-5252.1265, -4444.7246, 848.5591);
	angles[19] = (0, 0, 0);
	at[19] = 2.8500;
	points[20] = (-5252.1265, -4444.7246, 848.5591);
	angles[20] = (0, 0, 0);
	at[20] = 3.8000;
	points[21] = (-5252.1265, -4444.7246, 851.5118);
	angles[21] = (0, 0, 0);
	at[21] = 3.8500;
	points[22] = (-5252.1265, -4444.7246, 948.9528);
	angles[22] = (0, 0, 0);
	at[22] = 4.4000;
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
	points[0] = (5778.4644, -89.0866, 948.9528);
	angles[0] = (0, -180, 0);
	at[0] = 0;
	points[1] = (5778.4644, -89.0866, 1028.6772);
	angles[1] = (0, -180, 0);
	at[1] = 0.4500;
	points[2] = (5778.4644, -89.0866, 1033.4646);
	angles[2] = (0, -180, 0);
	at[2] = 0.5000;
	points[3] = (5778.4644, -89.0866, 1033.4646);
	angles[3] = (0, -180, 0);
	at[3] = 1.9500;
	points[4] = (5778.4644, -89.0866, 1041.1378);
	angles[4] = (0, -180, 0);
	at[4] = 2;
	points[5] = (5778.4644, -89.0866, 1037.8937);
	angles[5] = (0, -180, 0);
	at[5] = 2.0500;
	points[6] = (5778.4644, -89.0866, 1025.7914);
	angles[6] = (0, -180, 0);
	at[6] = 2.1000;
	points[7] = (5778.4644, -89.0866, 1029.0355);
	angles[7] = (0, -180, 0);
	at[7] = 2.1500;
	points[8] = (5778.4644, -89.0866, 1041.1378);
	angles[8] = (0, -180, 0);
	at[8] = 2.2000;
	points[9] = (5778.4644, -89.0866, 1037.8937);
	angles[9] = (0, -180, 0);
	at[9] = 2.2500;
	points[10] = (5778.4644, -89.0866, 1025.7914);
	angles[10] = (0, -180, 0);
	at[10] = 2.3000;
	points[11] = (5778.4644, -89.0866, 1029.0355);
	angles[11] = (0, -180, 0);
	at[11] = 2.3500;
	points[12] = (5778.4644, -89.0866, 1041.1378);
	angles[12] = (0, -180, 0);
	at[12] = 2.4000;
	points[13] = (5778.4644, -89.0866, 1037.8937);
	angles[13] = (0, -180, 0);
	at[13] = 2.4500;
	points[14] = (5778.4644, -89.0866, 1043.7992);
	angles[14] = (0, -180, 0);
	at[14] = 2.5000;
	points[15] = (5778.4644, -89.0866, 1176.6732);
	angles[15] = (0, -180, 0);
	at[15] = 2.6500;
	points[16] = (5778.4644, -89.0866, 1146.5551);
	angles[16] = (0, -180, 0);
	at[16] = 2.7000;
	points[17] = (5778.4644, -89.0866, 1071.2598);
	angles[17] = (0, -180, 0);
	at[17] = 2.7500;
	points[18] = (5778.4644, -89.0866, 950.7874);
	angles[18] = (0, -180, 0);
	at[18] = 2.8000;
	points[19] = (5778.4644, -89.0866, 848.5591);
	angles[19] = (0, -180, 0);
	at[19] = 2.8500;
	points[20] = (5778.4644, -89.0866, 848.5591);
	angles[20] = (0, -180, 0);
	at[20] = 3.8000;
	points[21] = (5778.4644, -89.0866, 851.5118);
	angles[21] = (0, -180, 0);
	at[21] = 3.8500;
	points[22] = (5778.4644, -89.0866, 948.9528);
	angles[22] = (0, -180, 0);
	at[22] = 4.4000;
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
	points[0] = (4744.8818, -93.4217, 948.9528);
	angles[0] = (0, -180, 0);
	at[0] = 0;
	points[1] = (4744.8818, -93.4217, 1028.6772);
	angles[1] = (0, -180, 0);
	at[1] = 0.4500;
	points[2] = (4744.8818, -93.4217, 1033.4646);
	angles[2] = (0, -180, 0);
	at[2] = 0.5000;
	points[3] = (4744.8818, -93.4217, 1033.4646);
	angles[3] = (0, -180, 0);
	at[3] = 1.9500;
	points[4] = (4744.8818, -93.4217, 1041.1378);
	angles[4] = (0, -180, 0);
	at[4] = 2;
	points[5] = (4744.8818, -93.4217, 1037.8937);
	angles[5] = (0, -180, 0);
	at[5] = 2.0500;
	points[6] = (4744.8818, -93.4217, 1025.7914);
	angles[6] = (0, -180, 0);
	at[6] = 2.1000;
	points[7] = (4744.8818, -93.4217, 1029.0355);
	angles[7] = (0, -180, 0);
	at[7] = 2.1500;
	points[8] = (4744.8818, -93.4217, 1041.1378);
	angles[8] = (0, -180, 0);
	at[8] = 2.2000;
	points[9] = (4744.8818, -93.4217, 1037.8937);
	angles[9] = (0, -180, 0);
	at[9] = 2.2500;
	points[10] = (4744.8818, -93.4217, 1025.7914);
	angles[10] = (0, -180, 0);
	at[10] = 2.3000;
	points[11] = (4744.8818, -93.4217, 1029.0355);
	angles[11] = (0, -180, 0);
	at[11] = 2.3500;
	points[12] = (4744.8818, -93.4217, 1041.1378);
	angles[12] = (0, -180, 0);
	at[12] = 2.4000;
	points[13] = (4744.8818, -93.4217, 1037.8937);
	angles[13] = (0, -180, 0);
	at[13] = 2.4500;
	points[14] = (4744.8818, -93.4217, 1043.7992);
	angles[14] = (0, -180, 0);
	at[14] = 2.5000;
	points[15] = (4744.8818, -93.4217, 1176.6732);
	angles[15] = (0, -180, 0);
	at[15] = 2.6500;
	points[16] = (4744.8818, -93.4217, 1146.5551);
	angles[16] = (0, -180, 0);
	at[16] = 2.7000;
	points[17] = (4744.8818, -93.4217, 1071.2598);
	angles[17] = (0, -180, 0);
	at[17] = 2.7500;
	points[18] = (4744.8818, -93.4217, 950.7874);
	angles[18] = (0, -180, 0);
	at[18] = 2.8000;
	points[19] = (4744.8818, -93.4217, 848.5591);
	angles[19] = (0, -180, 0);
	at[19] = 2.8500;
	points[20] = (4744.8818, -93.4217, 848.5591);
	angles[20] = (0, -180, 0);
	at[20] = 3.8000;
	points[21] = (4744.8818, -93.4217, 851.5118);
	angles[21] = (0, -180, 0);
	at[21] = 3.8500;
	points[22] = (4744.8818, -93.4217, 948.9528);
	angles[22] = (0, -180, 0);
	at[22] = 4.4000;
	mover = getEnt("iz_obj_9", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_10()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (3299.2322, 5311.4565, 948.9528);
	angles[0] = (0, -90, 0);
	at[0] = 0;
	points[1] = (3299.2322, 5311.4565, 1028.6772);
	angles[1] = (0, -90, 0);
	at[1] = 0.4500;
	points[2] = (3299.2322, 5311.4565, 1033.4646);
	angles[2] = (0, -90, 0);
	at[2] = 0.5000;
	points[3] = (3299.2322, 5311.4565, 1033.4646);
	angles[3] = (0, -90, 0);
	at[3] = 1.9500;
	points[4] = (3299.2322, 5311.4565, 1041.1378);
	angles[4] = (0, -90, 0);
	at[4] = 2;
	points[5] = (3299.2322, 5311.4565, 1037.8937);
	angles[5] = (0, -90, 0);
	at[5] = 2.0500;
	points[6] = (3299.2322, 5311.4565, 1025.7914);
	angles[6] = (0, -90, 0);
	at[6] = 2.1000;
	points[7] = (3299.2322, 5311.4565, 1029.0355);
	angles[7] = (0, -90, 0);
	at[7] = 2.1500;
	points[8] = (3299.2322, 5311.4565, 1041.1378);
	angles[8] = (0, -90, 0);
	at[8] = 2.2000;
	points[9] = (3299.2322, 5311.4565, 1037.8937);
	angles[9] = (0, -90, 0);
	at[9] = 2.2500;
	points[10] = (3299.2322, 5311.4565, 1025.7914);
	angles[10] = (0, -90, 0);
	at[10] = 2.3000;
	points[11] = (3299.2322, 5311.4565, 1029.0355);
	angles[11] = (0, -90, 0);
	at[11] = 2.3500;
	points[12] = (3299.2322, 5311.4565, 1041.1378);
	angles[12] = (0, -90, 0);
	at[12] = 2.4000;
	points[13] = (3299.2322, 5311.4565, 1037.8937);
	angles[13] = (0, -90, 0);
	at[13] = 2.4500;
	points[14] = (3299.2322, 5311.4565, 1043.7992);
	angles[14] = (0, -90, 0);
	at[14] = 2.5000;
	points[15] = (3299.2322, 5311.4565, 1176.6732);
	angles[15] = (0, -90, 0);
	at[15] = 2.6500;
	points[16] = (3299.2322, 5311.4565, 1146.5551);
	angles[16] = (0, -90, 0);
	at[16] = 2.7000;
	points[17] = (3299.2322, 5311.4565, 1071.2598);
	angles[17] = (0, -90, 0);
	at[17] = 2.7500;
	points[18] = (3299.2322, 5311.4565, 950.7874);
	angles[18] = (0, -90, 0);
	at[18] = 2.8000;
	points[19] = (3299.2322, 5311.4565, 848.5591);
	angles[19] = (0, -90, 0);
	at[19] = 2.8500;
	points[20] = (3299.2322, 5311.4565, 848.5591);
	angles[20] = (0, -90, 0);
	at[20] = 3.8000;
	points[21] = (3299.2322, 5311.4565, 851.5118);
	angles[21] = (0, -90, 0);
	at[21] = 3.8500;
	points[22] = (3299.2322, 5311.4565, 948.9528);
	angles[22] = (0, -90, 0);
	at[22] = 4.4000;
	mover = getEnt("iz_obj_10", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_11()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (1459.3308, 970.7677, 1033.4646);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (1459.3308, 970.7677, 1033.4646);
	angles[1] = (-90, 0, 0);
	at[1] = 4.5000;
	points[2] = (1459.3308, 970.7677, 1033.4646);
	angles[2] = (-180, 0, 0);
	at[2] = 9;
	points[3] = (1459.3308, 970.7677, 1033.4646);
	angles[3] = (-360, 0, 0);
	at[3] = 18;
	mover = getEnt("iz_obj_11", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_12()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (1396.9961, -1546.7164, 1033.4646);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (1396.9961, -1546.7164, 1033.4646);
	angles[1] = (-90, 0, 0);
	at[1] = 4.5000;
	points[2] = (1396.9961, -1546.7164, 1033.4646);
	angles[2] = (-180, 0, 0);
	at[2] = 9;
	points[3] = (1396.9961, -1546.7164, 1033.4646);
	angles[3] = (-360, 0, 0);
	at[3] = 18;
	mover = getEnt("iz_obj_12", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_13()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-1928.1575, 943.8898, 1033.4646);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-1928.1575, 943.8898, 1033.4646);
	angles[1] = (90, 0, 0);
	at[1] = 4.5000;
	points[2] = (-1928.1575, 943.8898, 1033.4646);
	angles[2] = (180, 0, 0);
	at[2] = 9;
	points[3] = (-1928.1575, 943.8898, 1033.4646);
	angles[3] = (0, 0, 0);
	at[3] = 18;
	mover = getEnt("iz_obj_13", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_14()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-1943.4055, 3353.3152, 1033.4646);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-1943.4055, 3353.3152, 1033.4646);
	angles[1] = (90, 0, 0);
	at[1] = 4.5000;
	points[2] = (-1943.4055, 3353.3152, 1033.4646);
	angles[2] = (180, 0, 0);
	at[2] = 9;
	points[3] = (-1943.4055, 3353.3152, 1033.4646);
	angles[3] = (0, 0, 0);
	at[3] = 18;
	mover = getEnt("iz_obj_14", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_15()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (5245.5908, -3040.7756, 1468.6377);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (5245.5908, -3040.7756, 1468.6377);
	angles[1] = (90, 0, 0);
	at[1] = 4.5000;
	points[2] = (5245.5908, -3040.7756, 1468.6377);
	angles[2] = (180, 0, 0);
	at[2] = 9;
	points[3] = (5245.5908, -3040.7756, 1468.6377);
	angles[3] = (0, 0, 0);
	at[3] = 18;
	mover = getEnt("iz_obj_15", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_16()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (5312.7163, 1342.2480, 1468.6377);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (5312.7163, 1342.2480, 1468.6377);
	angles[1] = (90, 0, 0);
	at[1] = 4.5000;
	points[2] = (5312.7163, 1342.2480, 1468.6377);
	angles[2] = (180, 0, 0);
	at[2] = 9;
	points[3] = (5312.7163, 1342.2480, 1468.6377);
	angles[3] = (0, 0, 0);
	at[3] = 18;
	mover = getEnt("iz_obj_16", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_17()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (1116.3307, -6416.8506, 183.3417);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (1116.3307, -6416.8506, 183.3417);
	angles[1] = (0, 0, 0);
	at[1] = 3.3500;
	points[2] = (1116.3307, -6416.8506, 223.8441);
	angles[2] = (0, 0, 0);
	at[2] = 3.4000;
	points[3] = (1116.3307, -6416.8506, 277.2299);
	angles[3] = (0, 0, 0);
	at[3] = 3.4500;
	points[4] = (1116.3307, -6416.8506, 375.4976);
	angles[4] = (0, 0, 0);
	at[4] = 3.5500;
	points[5] = (1116.3307, -6416.8506, 462.4252);
	angles[5] = (0, 0, 0);
	at[5] = 3.6500;
	points[6] = (1116.3307, -6416.8506, 538.0157);
	angles[6] = (0, 0, 0);
	at[6] = 3.7500;
	points[7] = (1116.3307, -6416.8506, 571.5591);
	angles[7] = (0, 0, 0);
	at[7] = 3.8000;
	points[8] = (1116.3307, -6416.8506, 630.1417);
	angles[8] = (0, 0, 0);
	at[8] = 3.9000;
	points[9] = (1116.3307, -6416.8506, 655.1811);
	angles[9] = (0, 0, 0);
	at[9] = 3.9500;
	points[10] = (1116.3307, -6416.8506, 696.7559);
	angles[10] = (0, 0, 0);
	at[10] = 4.0500;
	points[11] = (1116.3307, -6416.8506, 726.9921);
	angles[11] = (0, 0, 0);
	at[11] = 4.1500;
	points[12] = (1116.3307, -6416.8506, 745.8898);
	angles[12] = (0, 0, 0);
	at[12] = 4.2500;
	points[13] = (1116.3307, -6416.8506, 756.6772);
	angles[13] = (0, 0, 0);
	at[13] = 4.4000;
	points[14] = (1116.3307, -6416.8506, 764.5787);
	angles[14] = (0, 0, 0);
	at[14] = 4.4500;
	points[15] = (1116.3307, -6416.8506, 768.2914);
	angles[15] = (0, 0, 0);
	at[15] = 4.5000;
	points[16] = (1116.3307, -6416.8506, 766.3937);
	angles[16] = (0, 0, 0);
	at[16] = 4.5500;
	points[17] = (1116.3307, -6416.8506, 742.6378);
	angles[17] = (0, 0, 0);
	at[17] = 4.7000;
	points[18] = (1116.3307, -6416.8506, 738.9252);
	angles[18] = (0, 0, 0);
	at[18] = 4.7500;
	points[19] = (1116.3307, -6416.8506, 740.8229);
	angles[19] = (0, 0, 0);
	at[19] = 4.8000;
	points[20] = (1116.3307, -6416.8506, 764.5787);
	angles[20] = (0, 0, 0);
	at[20] = 4.9500;
	points[21] = (1116.3307, -6416.8506, 768.2914);
	angles[21] = (0, 0, 0);
	at[21] = 5;
	points[22] = (1116.3307, -6416.8506, 766.3937);
	angles[22] = (0, 0, 0);
	at[22] = 5.0500;
	points[23] = (1116.3307, -6416.8506, 742.6378);
	angles[23] = (0, 0, 0);
	at[23] = 5.2000;
	points[24] = (1116.3307, -6416.8506, 738.9252);
	angles[24] = (0, 0, 0);
	at[24] = 5.2500;
	points[25] = (1116.3307, -6416.8506, 740.8229);
	angles[25] = (0, 0, 0);
	at[25] = 5.3000;
	points[26] = (1116.3307, -6416.8506, 764.5787);
	angles[26] = (0, 0, 0);
	at[26] = 5.4500;
	points[27] = (1116.3307, -6416.8506, 768.2914);
	angles[27] = (0, 0, 0);
	at[27] = 5.5000;
	points[28] = (1116.3307, -6416.8506, 766.3937);
	angles[28] = (0, 0, 0);
	at[28] = 5.5500;
	points[29] = (1116.3307, -6416.8506, 742.6378);
	angles[29] = (0, 0, 0);
	at[29] = 5.7000;
	points[30] = (1116.3307, -6416.8506, 738.9252);
	angles[30] = (0, 0, 0);
	at[30] = 5.7500;
	points[31] = (1116.3307, -6416.8506, 740.8229);
	angles[31] = (0, 0, 0);
	at[31] = 5.8000;
	points[32] = (1116.3307, -6416.8506, 764.5787);
	angles[32] = (0, 0, 0);
	at[32] = 5.9500;
	points[33] = (1116.3307, -6416.8506, 768.2914);
	angles[33] = (0, 0, 0);
	at[33] = 6;
	points[34] = (1116.3307, -6416.8506, 766.3937);
	angles[34] = (0, 0, 0);
	at[34] = 6.0500;
	points[35] = (1116.3307, -6416.8506, 742.6378);
	angles[35] = (0, 0, 0);
	at[35] = 6.2000;
	points[36] = (1116.3307, -6416.8506, 737.6733);
	angles[36] = (0, 0, 0);
	at[36] = 6.2500;
	points[37] = (1116.3307, -6416.8506, 189.6410);
	angles[37] = (0, 0, 0);
	at[37] = 9.1500;
	points[38] = (1116.3307, -6416.8506, 183.3417);
	angles[38] = (0, 0, 0);
	at[38] = 9.2000;
	points[39] = (1116.3307, -6416.8506, 183.3417);
	angles[39] = (0, 0, 0);
	at[39] = 10.0333;
	mover = getEnt("iz_obj_17", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_18()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (2649.0198, -5489.4097, 495.1535);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (2649.0198, -5489.4097, 183.3417);
	angles[1] = (0, 0, 0);
	at[1] = 1.6500;
	points[2] = (2649.0198, -5489.4097, 183.3417);
	angles[2] = (0, 0, 0);
	at[2] = 5.8500;
	points[3] = (2649.0198, -5489.4097, 223.8441);
	angles[3] = (0, 0, 0);
	at[3] = 5.9000;
	points[4] = (2649.0198, -5489.4097, 277.2299);
	angles[4] = (0, 0, 0);
	at[4] = 5.9500;
	points[5] = (2649.0198, -5489.4097, 375.4976);
	angles[5] = (0, 0, 0);
	at[5] = 6.0500;
	points[6] = (2649.0198, -5489.4097, 462.4252);
	angles[6] = (0, 0, 0);
	at[6] = 6.1500;
	points[7] = (2649.0198, -5489.4097, 538.0157);
	angles[7] = (0, 0, 0);
	at[7] = 6.2500;
	points[8] = (2649.0198, -5489.4097, 571.5591);
	angles[8] = (0, 0, 0);
	at[8] = 6.3000;
	points[9] = (2649.0198, -5489.4097, 630.1417);
	angles[9] = (0, 0, 0);
	at[9] = 6.4000;
	points[10] = (2649.0198, -5489.4097, 655.1811);
	angles[10] = (0, 0, 0);
	at[10] = 6.4500;
	points[11] = (2649.0198, -5489.4097, 696.7559);
	angles[11] = (0, 0, 0);
	at[11] = 6.5500;
	points[12] = (2649.0198, -5489.4097, 726.9921);
	angles[12] = (0, 0, 0);
	at[12] = 6.6500;
	points[13] = (2649.0198, -5489.4097, 745.8898);
	angles[13] = (0, 0, 0);
	at[13] = 6.7500;
	points[14] = (2649.0198, -5489.4097, 756.6772);
	angles[14] = (0, 0, 0);
	at[14] = 6.9000;
	points[15] = (2649.0198, -5489.4097, 764.5787);
	angles[15] = (0, 0, 0);
	at[15] = 6.9500;
	points[16] = (2649.0198, -5489.4097, 768.2914);
	angles[16] = (0, 0, 0);
	at[16] = 7;
	points[17] = (2649.0198, -5489.4097, 766.3937);
	angles[17] = (0, 0, 0);
	at[17] = 7.0500;
	points[18] = (2649.0198, -5489.4097, 742.6378);
	angles[18] = (0, 0, 0);
	at[18] = 7.2000;
	points[19] = (2649.0198, -5489.4097, 738.9252);
	angles[19] = (0, 0, 0);
	at[19] = 7.2500;
	points[20] = (2649.0198, -5489.4097, 740.8229);
	angles[20] = (0, 0, 0);
	at[20] = 7.3000;
	points[21] = (2649.0198, -5489.4097, 764.5787);
	angles[21] = (0, 0, 0);
	at[21] = 7.4500;
	points[22] = (2649.0198, -5489.4097, 768.2914);
	angles[22] = (0, 0, 0);
	at[22] = 7.5000;
	points[23] = (2649.0198, -5489.4097, 766.3937);
	angles[23] = (0, 0, 0);
	at[23] = 7.5500;
	points[24] = (2649.0198, -5489.4097, 742.6378);
	angles[24] = (0, 0, 0);
	at[24] = 7.7000;
	points[25] = (2649.0198, -5489.4097, 738.9252);
	angles[25] = (0, 0, 0);
	at[25] = 7.7500;
	points[26] = (2649.0198, -5489.4097, 740.8229);
	angles[26] = (0, 0, 0);
	at[26] = 7.8000;
	points[27] = (2649.0198, -5489.4097, 764.5787);
	angles[27] = (0, 0, 0);
	at[27] = 7.9500;
	points[28] = (2649.0198, -5489.4097, 768.2914);
	angles[28] = (0, 0, 0);
	at[28] = 8;
	points[29] = (2649.0198, -5489.4097, 766.3937);
	angles[29] = (0, 0, 0);
	at[29] = 8.0500;
	points[30] = (2649.0198, -5489.4097, 742.6378);
	angles[30] = (0, 0, 0);
	at[30] = 8.2000;
	points[31] = (2649.0198, -5489.4097, 738.9252);
	angles[31] = (0, 0, 0);
	at[31] = 8.2500;
	points[32] = (2649.0198, -5489.4097, 740.8229);
	angles[32] = (0, 0, 0);
	at[32] = 8.3000;
	points[33] = (2649.0198, -5489.4097, 764.5787);
	angles[33] = (0, 0, 0);
	at[33] = 8.4500;
	points[34] = (2649.0198, -5489.4097, 768.2914);
	angles[34] = (0, 0, 0);
	at[34] = 8.5000;
	points[35] = (2649.0198, -5489.4097, 766.3937);
	angles[35] = (0, 0, 0);
	at[35] = 8.5500;
	points[36] = (2649.0198, -5489.4097, 742.6378);
	angles[36] = (0, 0, 0);
	at[36] = 8.7000;
	points[37] = (2649.0198, -5489.4097, 737.6733);
	angles[37] = (0, 0, 0);
	at[37] = 8.7500;
	points[38] = (2649.0198, -5489.4097, 495.1535);
	angles[38] = (0, 0, 0);
	at[38] = 10.0333;
	mover = getEnt("iz_obj_18", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_19()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-703.0709, -5572.1260, 183.3417);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-703.0709, -5572.1260, 183.3417);
	angles[1] = (0, 0, 0);
	at[1] = 0.8500;
	points[2] = (-703.0709, -5572.1260, 223.8441);
	angles[2] = (0, 0, 0);
	at[2] = 0.9000;
	points[3] = (-703.0709, -5572.1260, 277.2299);
	angles[3] = (0, 0, 0);
	at[3] = 0.9500;
	points[4] = (-703.0709, -5572.1260, 375.4976);
	angles[4] = (0, 0, 0);
	at[4] = 1.0500;
	points[5] = (-703.0709, -5572.1260, 462.4252);
	angles[5] = (0, 0, 0);
	at[5] = 1.1500;
	points[6] = (-703.0709, -5572.1260, 538.0157);
	angles[6] = (0, 0, 0);
	at[6] = 1.2500;
	points[7] = (-703.0709, -5572.1260, 571.5591);
	angles[7] = (0, 0, 0);
	at[7] = 1.3000;
	points[8] = (-703.0709, -5572.1260, 630.1417);
	angles[8] = (0, 0, 0);
	at[8] = 1.4000;
	points[9] = (-703.0709, -5572.1260, 655.1811);
	angles[9] = (0, 0, 0);
	at[9] = 1.4500;
	points[10] = (-703.0709, -5572.1260, 696.7559);
	angles[10] = (0, 0, 0);
	at[10] = 1.5500;
	points[11] = (-703.0709, -5572.1260, 726.9921);
	angles[11] = (0, 0, 0);
	at[11] = 1.6500;
	points[12] = (-703.0709, -5572.1260, 745.8898);
	angles[12] = (0, 0, 0);
	at[12] = 1.7500;
	points[13] = (-703.0709, -5572.1260, 756.6772);
	angles[13] = (0, 0, 0);
	at[13] = 1.9000;
	points[14] = (-703.0709, -5572.1260, 764.5787);
	angles[14] = (0, 0, 0);
	at[14] = 1.9500;
	points[15] = (-703.0709, -5572.1260, 768.2914);
	angles[15] = (0, 0, 0);
	at[15] = 2;
	points[16] = (-703.0709, -5572.1260, 766.3937);
	angles[16] = (0, 0, 0);
	at[16] = 2.0500;
	points[17] = (-703.0709, -5572.1260, 742.6378);
	angles[17] = (0, 0, 0);
	at[17] = 2.2000;
	points[18] = (-703.0709, -5572.1260, 738.9252);
	angles[18] = (0, 0, 0);
	at[18] = 2.2500;
	points[19] = (-703.0709, -5572.1260, 740.8229);
	angles[19] = (0, 0, 0);
	at[19] = 2.3000;
	points[20] = (-703.0709, -5572.1260, 764.5787);
	angles[20] = (0, 0, 0);
	at[20] = 2.4500;
	points[21] = (-703.0709, -5572.1260, 768.2914);
	angles[21] = (0, 0, 0);
	at[21] = 2.5000;
	points[22] = (-703.0709, -5572.1260, 766.3937);
	angles[22] = (0, 0, 0);
	at[22] = 2.5500;
	points[23] = (-703.0709, -5572.1260, 742.6378);
	angles[23] = (0, 0, 0);
	at[23] = 2.7000;
	points[24] = (-703.0709, -5572.1260, 738.9252);
	angles[24] = (0, 0, 0);
	at[24] = 2.7500;
	points[25] = (-703.0709, -5572.1260, 740.8229);
	angles[25] = (0, 0, 0);
	at[25] = 2.8000;
	points[26] = (-703.0709, -5572.1260, 764.5787);
	angles[26] = (0, 0, 0);
	at[26] = 2.9500;
	points[27] = (-703.0709, -5572.1260, 768.2914);
	angles[27] = (0, 0, 0);
	at[27] = 3;
	points[28] = (-703.0709, -5572.1260, 766.3937);
	angles[28] = (0, 0, 0);
	at[28] = 3.0500;
	points[29] = (-703.0709, -5572.1260, 742.6378);
	angles[29] = (0, 0, 0);
	at[29] = 3.2000;
	points[30] = (-703.0709, -5572.1260, 738.9252);
	angles[30] = (0, 0, 0);
	at[30] = 3.2500;
	points[31] = (-703.0709, -5572.1260, 740.8229);
	angles[31] = (0, 0, 0);
	at[31] = 3.3000;
	points[32] = (-703.0709, -5572.1260, 764.5787);
	angles[32] = (0, 0, 0);
	at[32] = 3.4500;
	points[33] = (-703.0709, -5572.1260, 768.2914);
	angles[33] = (0, 0, 0);
	at[33] = 3.5000;
	points[34] = (-703.0709, -5572.1260, 766.3937);
	angles[34] = (0, 0, 0);
	at[34] = 3.5500;
	points[35] = (-703.0709, -5572.1260, 742.6378);
	angles[35] = (0, 0, 0);
	at[35] = 3.7000;
	points[36] = (-703.0709, -5572.1260, 737.6733);
	angles[36] = (0, 0, 0);
	at[36] = 3.7500;
	points[37] = (-703.0709, -5572.1260, 189.6410);
	angles[37] = (0, 0, 0);
	at[37] = 6.6500;
	points[38] = (-703.0709, -5572.1260, 183.3417);
	angles[38] = (0, 0, 0);
	at[38] = 6.7000;
	points[39] = (-703.0709, -5572.1260, 183.3417);
	angles[39] = (0, 0, 0);
	at[39] = 10.0333;
	mover = getEnt("iz_obj_19", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_20()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (3917.1023, -3719.5630, 183.3417);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (3917.1023, -3719.5630, 183.3417);
	angles[1] = (0, 0, 0);
	at[1] = 0.8500;
	points[2] = (3917.1023, -3719.5630, 223.8441);
	angles[2] = (0, 0, 0);
	at[2] = 0.9000;
	points[3] = (3917.1023, -3719.5630, 277.2299);
	angles[3] = (0, 0, 0);
	at[3] = 0.9500;
	points[4] = (3917.1023, -3719.5630, 375.4976);
	angles[4] = (0, 0, 0);
	at[4] = 1.0500;
	points[5] = (3917.1023, -3719.5630, 462.4252);
	angles[5] = (0, 0, 0);
	at[5] = 1.1500;
	points[6] = (3917.1023, -3719.5630, 538.0157);
	angles[6] = (0, 0, 0);
	at[6] = 1.2500;
	points[7] = (3917.1023, -3719.5630, 571.5591);
	angles[7] = (0, 0, 0);
	at[7] = 1.3000;
	points[8] = (3917.1023, -3719.5630, 630.1417);
	angles[8] = (0, 0, 0);
	at[8] = 1.4000;
	points[9] = (3917.1023, -3719.5630, 655.1811);
	angles[9] = (0, 0, 0);
	at[9] = 1.4500;
	points[10] = (3917.1023, -3719.5630, 696.7559);
	angles[10] = (0, 0, 0);
	at[10] = 1.5500;
	points[11] = (3917.1023, -3719.5630, 726.9921);
	angles[11] = (0, 0, 0);
	at[11] = 1.6500;
	points[12] = (3917.1023, -3719.5630, 745.8898);
	angles[12] = (0, 0, 0);
	at[12] = 1.7500;
	points[13] = (3917.1023, -3719.5630, 756.6772);
	angles[13] = (0, 0, 0);
	at[13] = 1.9000;
	points[14] = (3917.1023, -3719.5630, 764.5787);
	angles[14] = (0, 0, 0);
	at[14] = 1.9500;
	points[15] = (3917.1023, -3719.5630, 768.2914);
	angles[15] = (0, 0, 0);
	at[15] = 2;
	points[16] = (3917.1023, -3719.5630, 766.3937);
	angles[16] = (0, 0, 0);
	at[16] = 2.0500;
	points[17] = (3917.1023, -3719.5630, 742.6378);
	angles[17] = (0, 0, 0);
	at[17] = 2.2000;
	points[18] = (3917.1023, -3719.5630, 738.9252);
	angles[18] = (0, 0, 0);
	at[18] = 2.2500;
	points[19] = (3917.1023, -3719.5630, 740.8229);
	angles[19] = (0, 0, 0);
	at[19] = 2.3000;
	points[20] = (3917.1023, -3719.5630, 764.5787);
	angles[20] = (0, 0, 0);
	at[20] = 2.4500;
	points[21] = (3917.1023, -3719.5630, 768.2914);
	angles[21] = (0, 0, 0);
	at[21] = 2.5000;
	points[22] = (3917.1023, -3719.5630, 766.3937);
	angles[22] = (0, 0, 0);
	at[22] = 2.5500;
	points[23] = (3917.1023, -3719.5630, 742.6378);
	angles[23] = (0, 0, 0);
	at[23] = 2.7000;
	points[24] = (3917.1023, -3719.5630, 738.9252);
	angles[24] = (0, 0, 0);
	at[24] = 2.7500;
	points[25] = (3917.1023, -3719.5630, 740.8229);
	angles[25] = (0, 0, 0);
	at[25] = 2.8000;
	points[26] = (3917.1023, -3719.5630, 764.5787);
	angles[26] = (0, 0, 0);
	at[26] = 2.9500;
	points[27] = (3917.1023, -3719.5630, 768.2914);
	angles[27] = (0, 0, 0);
	at[27] = 3;
	points[28] = (3917.1023, -3719.5630, 766.3937);
	angles[28] = (0, 0, 0);
	at[28] = 3.0500;
	points[29] = (3917.1023, -3719.5630, 742.6378);
	angles[29] = (0, 0, 0);
	at[29] = 3.2000;
	points[30] = (3917.1023, -3719.5630, 738.9252);
	angles[30] = (0, 0, 0);
	at[30] = 3.2500;
	points[31] = (3917.1023, -3719.5630, 740.8229);
	angles[31] = (0, 0, 0);
	at[31] = 3.3000;
	points[32] = (3917.1023, -3719.5630, 764.5787);
	angles[32] = (0, 0, 0);
	at[32] = 3.4500;
	points[33] = (3917.1023, -3719.5630, 768.2914);
	angles[33] = (0, 0, 0);
	at[33] = 3.5000;
	points[34] = (3917.1023, -3719.5630, 766.3937);
	angles[34] = (0, 0, 0);
	at[34] = 3.5500;
	points[35] = (3917.1023, -3719.5630, 742.6378);
	angles[35] = (0, 0, 0);
	at[35] = 3.7000;
	points[36] = (3917.1023, -3719.5630, 737.6733);
	angles[36] = (0, 0, 0);
	at[36] = 3.7500;
	points[37] = (3917.1023, -3719.5630, 189.6410);
	angles[37] = (0, 0, 0);
	at[37] = 6.6500;
	points[38] = (3917.1023, -3719.5630, 183.3417);
	angles[38] = (0, 0, 0);
	at[38] = 6.7000;
	points[39] = (3917.1023, -3719.5630, 183.3417);
	angles[39] = (0, 0, 0);
	at[39] = 10.0333;
	mover = getEnt("iz_obj_20", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_21()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (6548.3071, -2189.6299, 183.3417);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (6548.3071, -2189.6299, 183.3417);
	angles[1] = (0, 0, 0);
	at[1] = 0.8500;
	points[2] = (6548.3071, -2189.6299, 223.8441);
	angles[2] = (0, 0, 0);
	at[2] = 0.9000;
	points[3] = (6548.3071, -2189.6299, 277.2299);
	angles[3] = (0, 0, 0);
	at[3] = 0.9500;
	points[4] = (6548.3071, -2189.6299, 375.4976);
	angles[4] = (0, 0, 0);
	at[4] = 1.0500;
	points[5] = (6548.3071, -2189.6299, 462.4252);
	angles[5] = (0, 0, 0);
	at[5] = 1.1500;
	points[6] = (6548.3071, -2189.6299, 538.0157);
	angles[6] = (0, 0, 0);
	at[6] = 1.2500;
	points[7] = (6548.3071, -2189.6299, 571.5591);
	angles[7] = (0, 0, 0);
	at[7] = 1.3000;
	points[8] = (6548.3071, -2189.6299, 630.1417);
	angles[8] = (0, 0, 0);
	at[8] = 1.4000;
	points[9] = (6548.3071, -2189.6299, 655.1811);
	angles[9] = (0, 0, 0);
	at[9] = 1.4500;
	points[10] = (6548.3071, -2189.6299, 696.7559);
	angles[10] = (0, 0, 0);
	at[10] = 1.5500;
	points[11] = (6548.3071, -2189.6299, 726.9921);
	angles[11] = (0, 0, 0);
	at[11] = 1.6500;
	points[12] = (6548.3071, -2189.6299, 745.8898);
	angles[12] = (0, 0, 0);
	at[12] = 1.7500;
	points[13] = (6548.3071, -2189.6299, 756.6772);
	angles[13] = (0, 0, 0);
	at[13] = 1.9000;
	points[14] = (6548.3071, -2189.6299, 764.5787);
	angles[14] = (0, 0, 0);
	at[14] = 1.9500;
	points[15] = (6548.3071, -2189.6299, 768.2914);
	angles[15] = (0, 0, 0);
	at[15] = 2;
	points[16] = (6548.3071, -2189.6299, 766.3937);
	angles[16] = (0, 0, 0);
	at[16] = 2.0500;
	points[17] = (6548.3071, -2189.6299, 742.6378);
	angles[17] = (0, 0, 0);
	at[17] = 2.2000;
	points[18] = (6548.3071, -2189.6299, 738.9252);
	angles[18] = (0, 0, 0);
	at[18] = 2.2500;
	points[19] = (6548.3071, -2189.6299, 740.8229);
	angles[19] = (0, 0, 0);
	at[19] = 2.3000;
	points[20] = (6548.3071, -2189.6299, 764.5787);
	angles[20] = (0, 0, 0);
	at[20] = 2.4500;
	points[21] = (6548.3071, -2189.6299, 768.2914);
	angles[21] = (0, 0, 0);
	at[21] = 2.5000;
	points[22] = (6548.3071, -2189.6299, 766.3937);
	angles[22] = (0, 0, 0);
	at[22] = 2.5500;
	points[23] = (6548.3071, -2189.6299, 742.6378);
	angles[23] = (0, 0, 0);
	at[23] = 2.7000;
	points[24] = (6548.3071, -2189.6299, 738.9252);
	angles[24] = (0, 0, 0);
	at[24] = 2.7500;
	points[25] = (6548.3071, -2189.6299, 740.8229);
	angles[25] = (0, 0, 0);
	at[25] = 2.8000;
	points[26] = (6548.3071, -2189.6299, 764.5787);
	angles[26] = (0, 0, 0);
	at[26] = 2.9500;
	points[27] = (6548.3071, -2189.6299, 768.2914);
	angles[27] = (0, 0, 0);
	at[27] = 3;
	points[28] = (6548.3071, -2189.6299, 766.3937);
	angles[28] = (0, 0, 0);
	at[28] = 3.0500;
	points[29] = (6548.3071, -2189.6299, 742.6378);
	angles[29] = (0, 0, 0);
	at[29] = 3.2000;
	points[30] = (6548.3071, -2189.6299, 738.9252);
	angles[30] = (0, 0, 0);
	at[30] = 3.2500;
	points[31] = (6548.3071, -2189.6299, 740.8229);
	angles[31] = (0, 0, 0);
	at[31] = 3.3000;
	points[32] = (6548.3071, -2189.6299, 764.5787);
	angles[32] = (0, 0, 0);
	at[32] = 3.4500;
	points[33] = (6548.3071, -2189.6299, 768.2914);
	angles[33] = (0, 0, 0);
	at[33] = 3.5000;
	points[34] = (6548.3071, -2189.6299, 766.3937);
	angles[34] = (0, 0, 0);
	at[34] = 3.5500;
	points[35] = (6548.3071, -2189.6299, 742.6378);
	angles[35] = (0, 0, 0);
	at[35] = 3.7000;
	points[36] = (6548.3071, -2189.6299, 737.6733);
	angles[36] = (0, 0, 0);
	at[36] = 3.7500;
	points[37] = (6548.3071, -2189.6299, 189.6410);
	angles[37] = (0, 0, 0);
	at[37] = 6.6500;
	points[38] = (6548.3071, -2189.6299, 183.3417);
	angles[38] = (0, 0, 0);
	at[38] = 6.7000;
	points[39] = (6548.3071, -2189.6299, 183.3417);
	angles[39] = (0, 0, 0);
	at[39] = 10.0333;
	mover = getEnt("iz_obj_21", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_22()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (3948.7400, -734.0670, 183.3417);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (3948.7400, -734.0670, 183.3417);
	angles[1] = (0, 0, 0);
	at[1] = 0.8500;
	points[2] = (3948.7400, -734.0670, 223.8441);
	angles[2] = (0, 0, 0);
	at[2] = 0.9000;
	points[3] = (3948.7400, -734.0670, 277.2299);
	angles[3] = (0, 0, 0);
	at[3] = 0.9500;
	points[4] = (3948.7400, -734.0670, 375.4976);
	angles[4] = (0, 0, 0);
	at[4] = 1.0500;
	points[5] = (3948.7400, -734.0670, 462.4252);
	angles[5] = (0, 0, 0);
	at[5] = 1.1500;
	points[6] = (3948.7400, -734.0670, 538.0157);
	angles[6] = (0, 0, 0);
	at[6] = 1.2500;
	points[7] = (3948.7400, -734.0670, 571.5591);
	angles[7] = (0, 0, 0);
	at[7] = 1.3000;
	points[8] = (3948.7400, -734.0670, 630.1417);
	angles[8] = (0, 0, 0);
	at[8] = 1.4000;
	points[9] = (3948.7400, -734.0670, 655.1811);
	angles[9] = (0, 0, 0);
	at[9] = 1.4500;
	points[10] = (3948.7400, -734.0670, 696.7559);
	angles[10] = (0, 0, 0);
	at[10] = 1.5500;
	points[11] = (3948.7400, -734.0670, 726.9921);
	angles[11] = (0, 0, 0);
	at[11] = 1.6500;
	points[12] = (3948.7400, -734.0670, 745.8898);
	angles[12] = (0, 0, 0);
	at[12] = 1.7500;
	points[13] = (3948.7400, -734.0670, 756.6772);
	angles[13] = (0, 0, 0);
	at[13] = 1.9000;
	points[14] = (3948.7400, -734.0670, 764.5787);
	angles[14] = (0, 0, 0);
	at[14] = 1.9500;
	points[15] = (3948.7400, -734.0670, 768.2914);
	angles[15] = (0, 0, 0);
	at[15] = 2;
	points[16] = (3948.7400, -734.0670, 766.3937);
	angles[16] = (0, 0, 0);
	at[16] = 2.0500;
	points[17] = (3948.7400, -734.0670, 742.6378);
	angles[17] = (0, 0, 0);
	at[17] = 2.2000;
	points[18] = (3948.7400, -734.0670, 738.9252);
	angles[18] = (0, 0, 0);
	at[18] = 2.2500;
	points[19] = (3948.7400, -734.0670, 740.8229);
	angles[19] = (0, 0, 0);
	at[19] = 2.3000;
	points[20] = (3948.7400, -734.0670, 764.5787);
	angles[20] = (0, 0, 0);
	at[20] = 2.4500;
	points[21] = (3948.7400, -734.0670, 768.2914);
	angles[21] = (0, 0, 0);
	at[21] = 2.5000;
	points[22] = (3948.7400, -734.0670, 766.3937);
	angles[22] = (0, 0, 0);
	at[22] = 2.5500;
	points[23] = (3948.7400, -734.0670, 742.6378);
	angles[23] = (0, 0, 0);
	at[23] = 2.7000;
	points[24] = (3948.7400, -734.0670, 738.9252);
	angles[24] = (0, 0, 0);
	at[24] = 2.7500;
	points[25] = (3948.7400, -734.0670, 740.8229);
	angles[25] = (0, 0, 0);
	at[25] = 2.8000;
	points[26] = (3948.7400, -734.0670, 764.5787);
	angles[26] = (0, 0, 0);
	at[26] = 2.9500;
	points[27] = (3948.7400, -734.0670, 768.2914);
	angles[27] = (0, 0, 0);
	at[27] = 3;
	points[28] = (3948.7400, -734.0670, 766.3937);
	angles[28] = (0, 0, 0);
	at[28] = 3.0500;
	points[29] = (3948.7400, -734.0670, 742.6378);
	angles[29] = (0, 0, 0);
	at[29] = 3.2000;
	points[30] = (3948.7400, -734.0670, 738.9252);
	angles[30] = (0, 0, 0);
	at[30] = 3.2500;
	points[31] = (3948.7400, -734.0670, 740.8229);
	angles[31] = (0, 0, 0);
	at[31] = 3.3000;
	points[32] = (3948.7400, -734.0670, 764.5787);
	angles[32] = (0, 0, 0);
	at[32] = 3.4500;
	points[33] = (3948.7400, -734.0670, 768.2914);
	angles[33] = (0, 0, 0);
	at[33] = 3.5000;
	points[34] = (3948.7400, -734.0670, 766.3937);
	angles[34] = (0, 0, 0);
	at[34] = 3.5500;
	points[35] = (3948.7400, -734.0670, 742.6378);
	angles[35] = (0, 0, 0);
	at[35] = 3.7000;
	points[36] = (3948.7400, -734.0670, 737.6733);
	angles[36] = (0, 0, 0);
	at[36] = 3.7500;
	points[37] = (3948.7400, -734.0670, 189.6410);
	angles[37] = (0, 0, 0);
	at[37] = 6.6500;
	points[38] = (3948.7400, -734.0670, 183.3417);
	angles[38] = (0, 0, 0);
	at[38] = 6.7000;
	points[39] = (3948.7400, -734.0670, 183.3417);
	angles[39] = (0, 0, 0);
	at[39] = 10.0333;
	mover = getEnt("iz_obj_22", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_23()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (6536.8901, 579.7559, 183.3417);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (6536.8901, 579.7559, 183.3417);
	angles[1] = (0, 0, 0);
	at[1] = 0.8500;
	points[2] = (6536.8901, 579.7559, 223.8441);
	angles[2] = (0, 0, 0);
	at[2] = 0.9000;
	points[3] = (6536.8901, 579.7559, 277.2299);
	angles[3] = (0, 0, 0);
	at[3] = 0.9500;
	points[4] = (6536.8901, 579.7559, 375.4976);
	angles[4] = (0, 0, 0);
	at[4] = 1.0500;
	points[5] = (6536.8901, 579.7559, 462.4252);
	angles[5] = (0, 0, 0);
	at[5] = 1.1500;
	points[6] = (6536.8901, 579.7559, 538.0157);
	angles[6] = (0, 0, 0);
	at[6] = 1.2500;
	points[7] = (6536.8901, 579.7559, 571.5591);
	angles[7] = (0, 0, 0);
	at[7] = 1.3000;
	points[8] = (6536.8901, 579.7559, 630.1417);
	angles[8] = (0, 0, 0);
	at[8] = 1.4000;
	points[9] = (6536.8901, 579.7559, 655.1811);
	angles[9] = (0, 0, 0);
	at[9] = 1.4500;
	points[10] = (6536.8901, 579.7559, 696.7559);
	angles[10] = (0, 0, 0);
	at[10] = 1.5500;
	points[11] = (6536.8901, 579.7559, 726.9921);
	angles[11] = (0, 0, 0);
	at[11] = 1.6500;
	points[12] = (6536.8901, 579.7559, 745.8898);
	angles[12] = (0, 0, 0);
	at[12] = 1.7500;
	points[13] = (6536.8901, 579.7559, 756.6772);
	angles[13] = (0, 0, 0);
	at[13] = 1.9000;
	points[14] = (6536.8901, 579.7559, 764.5787);
	angles[14] = (0, 0, 0);
	at[14] = 1.9500;
	points[15] = (6536.8901, 579.7559, 768.2914);
	angles[15] = (0, 0, 0);
	at[15] = 2;
	points[16] = (6536.8901, 579.7559, 766.3937);
	angles[16] = (0, 0, 0);
	at[16] = 2.0500;
	points[17] = (6536.8901, 579.7559, 742.6378);
	angles[17] = (0, 0, 0);
	at[17] = 2.2000;
	points[18] = (6536.8901, 579.7559, 738.9252);
	angles[18] = (0, 0, 0);
	at[18] = 2.2500;
	points[19] = (6536.8901, 579.7559, 740.8229);
	angles[19] = (0, 0, 0);
	at[19] = 2.3000;
	points[20] = (6536.8901, 579.7559, 764.5787);
	angles[20] = (0, 0, 0);
	at[20] = 2.4500;
	points[21] = (6536.8901, 579.7559, 768.2914);
	angles[21] = (0, 0, 0);
	at[21] = 2.5000;
	points[22] = (6536.8901, 579.7559, 766.3937);
	angles[22] = (0, 0, 0);
	at[22] = 2.5500;
	points[23] = (6536.8901, 579.7559, 742.6378);
	angles[23] = (0, 0, 0);
	at[23] = 2.7000;
	points[24] = (6536.8901, 579.7559, 738.9252);
	angles[24] = (0, 0, 0);
	at[24] = 2.7500;
	points[25] = (6536.8901, 579.7559, 740.8229);
	angles[25] = (0, 0, 0);
	at[25] = 2.8000;
	points[26] = (6536.8901, 579.7559, 764.5787);
	angles[26] = (0, 0, 0);
	at[26] = 2.9500;
	points[27] = (6536.8901, 579.7559, 768.2914);
	angles[27] = (0, 0, 0);
	at[27] = 3;
	points[28] = (6536.8901, 579.7559, 766.3937);
	angles[28] = (0, 0, 0);
	at[28] = 3.0500;
	points[29] = (6536.8901, 579.7559, 742.6378);
	angles[29] = (0, 0, 0);
	at[29] = 3.2000;
	points[30] = (6536.8901, 579.7559, 738.9252);
	angles[30] = (0, 0, 0);
	at[30] = 3.2500;
	points[31] = (6536.8901, 579.7559, 740.8229);
	angles[31] = (0, 0, 0);
	at[31] = 3.3000;
	points[32] = (6536.8901, 579.7559, 764.5787);
	angles[32] = (0, 0, 0);
	at[32] = 3.4500;
	points[33] = (6536.8901, 579.7559, 768.2914);
	angles[33] = (0, 0, 0);
	at[33] = 3.5000;
	points[34] = (6536.8901, 579.7559, 766.3937);
	angles[34] = (0, 0, 0);
	at[34] = 3.5500;
	points[35] = (6536.8901, 579.7559, 742.6378);
	angles[35] = (0, 0, 0);
	at[35] = 3.7000;
	points[36] = (6536.8901, 579.7559, 737.6733);
	angles[36] = (0, 0, 0);
	at[36] = 3.7500;
	points[37] = (6536.8901, 579.7559, 189.6410);
	angles[37] = (0, 0, 0);
	at[37] = 6.6500;
	points[38] = (6536.8901, 579.7559, 183.3417);
	angles[38] = (0, 0, 0);
	at[38] = 6.7000;
	points[39] = (6536.8901, 579.7559, 183.3417);
	angles[39] = (0, 0, 0);
	at[39] = 10.0333;
	mover = getEnt("iz_obj_23", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_24()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (3957.2834, 2126.1497, 183.3417);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (3957.2834, 2126.1497, 183.3417);
	angles[1] = (0, 0, 0);
	at[1] = 0.8500;
	points[2] = (3957.2834, 2126.1497, 223.8441);
	angles[2] = (0, 0, 0);
	at[2] = 0.9000;
	points[3] = (3957.2834, 2126.1497, 277.2299);
	angles[3] = (0, 0, 0);
	at[3] = 0.9500;
	points[4] = (3957.2834, 2126.1497, 375.4976);
	angles[4] = (0, 0, 0);
	at[4] = 1.0500;
	points[5] = (3957.2834, 2126.1497, 462.4252);
	angles[5] = (0, 0, 0);
	at[5] = 1.1500;
	points[6] = (3957.2834, 2126.1497, 538.0157);
	angles[6] = (0, 0, 0);
	at[6] = 1.2500;
	points[7] = (3957.2834, 2126.1497, 571.5591);
	angles[7] = (0, 0, 0);
	at[7] = 1.3000;
	points[8] = (3957.2834, 2126.1497, 630.1417);
	angles[8] = (0, 0, 0);
	at[8] = 1.4000;
	points[9] = (3957.2834, 2126.1497, 655.1811);
	angles[9] = (0, 0, 0);
	at[9] = 1.4500;
	points[10] = (3957.2834, 2126.1497, 696.7559);
	angles[10] = (0, 0, 0);
	at[10] = 1.5500;
	points[11] = (3957.2834, 2126.1497, 726.9921);
	angles[11] = (0, 0, 0);
	at[11] = 1.6500;
	points[12] = (3957.2834, 2126.1497, 745.8898);
	angles[12] = (0, 0, 0);
	at[12] = 1.7500;
	points[13] = (3957.2834, 2126.1497, 756.6772);
	angles[13] = (0, 0, 0);
	at[13] = 1.9000;
	points[14] = (3957.2834, 2126.1497, 764.5787);
	angles[14] = (0, 0, 0);
	at[14] = 1.9500;
	points[15] = (3957.2834, 2126.1497, 768.2914);
	angles[15] = (0, 0, 0);
	at[15] = 2;
	points[16] = (3957.2834, 2126.1497, 766.3937);
	angles[16] = (0, 0, 0);
	at[16] = 2.0500;
	points[17] = (3957.2834, 2126.1497, 742.6378);
	angles[17] = (0, 0, 0);
	at[17] = 2.2000;
	points[18] = (3957.2834, 2126.1497, 738.9252);
	angles[18] = (0, 0, 0);
	at[18] = 2.2500;
	points[19] = (3957.2834, 2126.1497, 740.8229);
	angles[19] = (0, 0, 0);
	at[19] = 2.3000;
	points[20] = (3957.2834, 2126.1497, 764.5787);
	angles[20] = (0, 0, 0);
	at[20] = 2.4500;
	points[21] = (3957.2834, 2126.1497, 768.2914);
	angles[21] = (0, 0, 0);
	at[21] = 2.5000;
	points[22] = (3957.2834, 2126.1497, 766.3937);
	angles[22] = (0, 0, 0);
	at[22] = 2.5500;
	points[23] = (3957.2834, 2126.1497, 742.6378);
	angles[23] = (0, 0, 0);
	at[23] = 2.7000;
	points[24] = (3957.2834, 2126.1497, 738.9252);
	angles[24] = (0, 0, 0);
	at[24] = 2.7500;
	points[25] = (3957.2834, 2126.1497, 740.8229);
	angles[25] = (0, 0, 0);
	at[25] = 2.8000;
	points[26] = (3957.2834, 2126.1497, 764.5787);
	angles[26] = (0, 0, 0);
	at[26] = 2.9500;
	points[27] = (3957.2834, 2126.1497, 768.2914);
	angles[27] = (0, 0, 0);
	at[27] = 3;
	points[28] = (3957.2834, 2126.1497, 766.3937);
	angles[28] = (0, 0, 0);
	at[28] = 3.0500;
	points[29] = (3957.2834, 2126.1497, 742.6378);
	angles[29] = (0, 0, 0);
	at[29] = 3.2000;
	points[30] = (3957.2834, 2126.1497, 738.9252);
	angles[30] = (0, 0, 0);
	at[30] = 3.2500;
	points[31] = (3957.2834, 2126.1497, 740.8229);
	angles[31] = (0, 0, 0);
	at[31] = 3.3000;
	points[32] = (3957.2834, 2126.1497, 764.5787);
	angles[32] = (0, 0, 0);
	at[32] = 3.4500;
	points[33] = (3957.2834, 2126.1497, 768.2914);
	angles[33] = (0, 0, 0);
	at[33] = 3.5000;
	points[34] = (3957.2834, 2126.1497, 766.3937);
	angles[34] = (0, 0, 0);
	at[34] = 3.5500;
	points[35] = (3957.2834, 2126.1497, 742.6378);
	angles[35] = (0, 0, 0);
	at[35] = 3.7000;
	points[36] = (3957.2834, 2126.1497, 737.6733);
	angles[36] = (0, 0, 0);
	at[36] = 3.7500;
	points[37] = (3957.2834, 2126.1497, 189.6410);
	angles[37] = (0, 0, 0);
	at[37] = 6.6500;
	points[38] = (3957.2834, 2126.1497, 183.3417);
	angles[38] = (0, 0, 0);
	at[38] = 6.7000;
	points[39] = (3957.2834, 2126.1497, 183.3417);
	angles[39] = (0, 0, 0);
	at[39] = 10.0333;
	mover = getEnt("iz_obj_24", "targetname");
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
