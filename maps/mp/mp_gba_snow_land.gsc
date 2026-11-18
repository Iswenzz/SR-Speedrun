main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_gba_snow_land", 0);

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
	ambientPlay("iz_0_48", 2);
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
	level.iz_route[level.iz_route.size] = (7102, 813, 1113);
	level.iz_route[level.iz_route.size] = (7048, -1308, 1113);
	level.iz_route[level.iz_route.size] = (6680, -2199, 1113);
	level.iz_route[level.iz_route.size] = (5205, -2982, 1113);
	level.iz_route[level.iz_route.size] = (3080, -3796, 1113);
	level.iz_route[level.iz_route.size] = (2163, -4488, 1113);
	level.iz_route[level.iz_route.size] = (2042, -5813, 1113);
	level.iz_route[level.iz_route.size] = (1741, -7228, 1113);
	level.iz_route[level.iz_route.size] = (767, -7846, 1113);
	level.iz_route[level.iz_route.size] = (-161, -7851, 1113);
	level.iz_route[level.iz_route.size] = (-1257, -7299, 1113);
	level.iz_route[level.iz_route.size] = (-2563, -6884, 1113);
	level.iz_route[level.iz_route.size] = (-4360, -6084, 1113);
	level.iz_route[level.iz_route.size] = (-6632, -4924, 1113);
	level.iz_route[level.iz_route.size] = (-7295, -3855, 1113);
	level.iz_route[level.iz_route.size] = (-7488, -3012, 1113);
	level.iz_route[level.iz_route.size] = (-7368, -2156, 1113);
	level.iz_route[level.iz_route.size] = (-7360, -1516, 1113);
	level.iz_route[level.iz_route.size] = (-7139, -865, 1113);
	level.iz_route[level.iz_route.size] = (-6490, -522, 1113);
	level.iz_route[level.iz_route.size] = (-3674, -385, 1113);
	level.iz_route[level.iz_route.size] = (-3022, -577, 1113);
	level.iz_route[level.iz_route.size] = (-2283, -1290, 1113);
	level.iz_route[level.iz_route.size] = (-1534, -2291, 1113);
	level.iz_route[level.iz_route.size] = (-488, -2801, 1113);
	level.iz_route[level.iz_route.size] = (837, -2409, 1113);
	level.iz_route[level.iz_route.size] = (1410, -1446, 1113);
	level.iz_route[level.iz_route.size] = (1380, -90, 1113);
	level.iz_route[level.iz_route.size] = (807, 1416, 1113);
	level.iz_route[level.iz_route.size] = (-337, 2650, 1113);
	level.iz_route[level.iz_route.size] = (-2205, 3042, 1113);
	level.iz_route[level.iz_route.size] = (-5470, 2976, 1113);
	level.iz_route[level.iz_route.size] = (-6259, 3180, 1113);
	level.iz_route[level.iz_route.size] = (-6672, 3837, 1113);
	level.iz_route[level.iz_route.size] = (-6963, 5120, 1113);
	level.iz_route[level.iz_route.size] = (-6853, 6252, 1113);
	level.iz_route[level.iz_route.size] = (-6326, 7404, 1103);
	level.iz_route[level.iz_route.size] = (-5528, 8012, 1112);
	level.iz_route[level.iz_route.size] = (-1645, 8118, 1113);
	level.iz_route[level.iz_route.size] = (-654, 7716, 1109);
	level.iz_route[level.iz_route.size] = (54, 6442, 1107);
	level.iz_route[level.iz_route.size] = (661, 5532, 1113);
	level.iz_route[level.iz_route.size] = (1421, 5247, 1113);
	level.iz_route[level.iz_route.size] = (2209, 5474, 1113);
	level.iz_route[level.iz_route.size] = (2716, 5998, 1113);
	level.iz_route[level.iz_route.size] = (3390, 6969, 1113);
	level.iz_route[level.iz_route.size] = (4121, 7370, 1113);
	level.iz_route[level.iz_route.size] = (6167, 7407, 1113);
	level.iz_route[level.iz_route.size] = (6915, 6777, 1113);
	level.iz_route[level.iz_route.size] = (7050, 5530, 1113);
	level.iz_route[level.iz_route.size] = (7067, 4054, 1113);
	level.iz_route[level.iz_route.size] = (7088, 2375, 1113);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-3260.2915, 8930.0791, 1133.7245);
	angles[0] = (0, -179.7821, 0.0052);
	at[0] = 0;
	points[1] = (-3257.8584, 8865.3154, 1133.6929);
	angles[1] = (0, -175.7149, -0.0656);
	at[1] = 0.7333;
	points[2] = (-3247.8267, 8818.3467, 1133.6221);
	angles[2] = (0, -162.8765, -0.0180);
	at[2] = 1.2833;
	points[3] = (-3211.6458, 8727.4014, 1133.5394);
	angles[3] = (0, -156.2931, -0.1595);
	at[3] = 2.3833;
	points[4] = (-3162.0198, 8625.0400, 1132.0748);
	angles[4] = (0, -151.6999, -1.8100);
	at[4] = 3.6667;
	points[5] = (-3093.9331, 8515, 1124.0511);
	angles[5] = (0, -147.0900, -3.8942);
	at[5] = 5.1333;
	points[6] = (-3011.3071, 8393.8193, 1114.4567);
	angles[6] = (0, -143.8533, -3.3199);
	at[6] = 6.7833;
	points[7] = (-2981.4963, 8357.0869, 1112.5118);
	angles[7] = (0, -138.5251, -1.3909);
	at[7] = 7.3333;
	points[8] = (-2913.2795, 8286.6924, 1112.0236);
	angles[8] = (0, -134.4299, 0.0853);
	at[8] = 8.4333;
	points[9] = (-2853.3188, 8231.4961, 1112.3662);
	angles[9] = (0, -130.9664, 0.3176);
	at[9] = 9.3500;
	points[10] = (-2815.4214, 8201.2207, 1112.6495);
	angles[10] = (0, -126.7917, 0.3303);
	at[10] = 9.9000;
	points[11] = (-2787.5828, 8183.3071, 1112.8031);
	angles[11] = (0, -119.9372, 0.2132);
	at[11] = 10.2667;
	points[12] = (-2773.9331, 8177.4014, 1112.8229);
	angles[12] = (0, -111.8664, 0.0397);
	at[12] = 10.4500;
	points[13] = (-2742.4253, 8169.9604, 1112.8190);
	angles[13] = (0, -101, -0.0013);
	at[13] = 10.8167;
	points[14] = (-2644.9607, 8159.4888, 1112.8190);
	angles[14] = (0, -93.7674, 0);
	at[14] = 11.9167;
	points[15] = (-2547.3818, 8156.9683, 1112.8190);
	angles[15] = (0, -89.5193, 0);
	at[15] = 13.0167;
	points[16] = (-2482.4685, 8160.8271, 1112.8190);
	angles[16] = (0, -83.5929, 0);
	at[16] = 13.7500;
	points[17] = (-2465.9802, 8163.6221, 1112.8190);
	angles[17] = (0, -79.3658, 0);
	at[17] = 13.9333;
	points[18] = (-2436.5393, 8174.2524, 1112.7520);
	angles[18] = (0, -66.9587, -0.1945);
	at[18] = 14.3000;
	points[19] = (-2393.0828, 8196.8896, 1112.5276);
	angles[19] = (0, -60.7244, -0.2785);
	at[19] = 14.8500;
	points[20] = (-2310.3662, 8248.9365, 1112.1339);
	angles[20] = (0, -56.0510, -0.1577);
	at[20] = 15.9500;
	points[21] = (-2231.2559, 8306.7324, 1112.2560);
	angles[21] = (0, -51.7173, 0.3708);
	at[21] = 17.0500;
	points[22] = (-2206.4685, 8327.8340, 1112.6851);
	angles[22] = (0, -48.1812, 1.0245);
	at[22] = 17.4167;
	points[23] = (-2185.2009, 8350.9453, 1113.7638);
	angles[23] = (0, -40.3279, 2.2904);
	at[23] = 17.7833;
	points[24] = (-2109.4607, 8456.5752, 1120.3701);
	angles[24] = (0, -33.9135, 3.1096);
	at[24] = 19.2500;
	points[25] = (-2020.7245, 8593.7012, 1129.1732);
	angles[25] = (0, -32.3723, 2.7886);
	at[25] = 21.0833;
	points[26] = (-1980.2323, 8662.6768, 1131.7126);
	angles[26] = (0, -28.9100, 1.3936);
	at[26] = 22;
	points[27] = (-1906.3268, 8806.9688, 1133.8268);
	angles[27] = (0, -26.2627, 0.0611);
	at[27] = 23.8333;
	points[28] = (-1851.7520, 8925.4326, 1133.6969);
	angles[28] = (0, -22.3070, -0.0930);
	at[28] = 25.3000;
	points[29] = (-1840.8071, 8956.4170, 1133.6536);
	angles[29] = (0, -17.2661, -0.0581);
	at[29] = 25.6667;
	points[30] = (-1837.7834, 8971.1807, 1133.6536);
	angles[30] = (0, -10.6946, -0.0075);
	at[30] = 25.8500;
	points[31] = (-1834.4095, 9003.7402, 1133.6536);
	angles[31] = (0, -4.6250, 0);
	at[31] = 26.2167;
	points[32] = (-1832.6771, 9068.9375, 1133.6536);
	angles[32] = (0, 0.3925, 0);
	at[32] = 26.9500;
	points[33] = (-1837.0985, 9133.8184, 1133.6536);
	angles[33] = (0, 7.1476, 0);
	at[33] = 27.6833;
	points[34] = (-1844.3071, 9165.7480, 1133.6536);
	angles[34] = (0, 16.8125, 0);
	at[34] = 28.0500;
	points[35] = (-1856.0945, 9188.5830, 1133.6536);
	angles[35] = (0, 27.8688, 0);
	at[35] = 28.2333;
	points[36] = (-1873.9922, 9215.6299, 1133.6536);
	angles[36] = (0, 33.7156, 0);
	at[36] = 28.4167;
	points[37] = (-1933.8149, 9293.2285, 1133.6536);
	angles[37] = (0, 39.2958, 0);
	at[37] = 28.9667;
	points[38] = (-2000.0906, 9365.1572, 1133.6536);
	angles[38] = (0, 45.7226, 0);
	at[38] = 29.5167;
	points[39] = (-2024.5906, 9384.4883, 1133.6536);
	angles[39] = (0, 54.0639, 0);
	at[39] = 29.7000;
	points[40] = (-2053.7283, 9399.2520, 1133.6536);
	angles[40] = (0, 63.5961, 0);
	at[40] = 29.8833;
	points[41] = (-2083.9055, 9411.9297, 1133.6536);
	angles[41] = (0, 67.4326, 0);
	at[41] = 30.0667;
	points[42] = (-2238.5195, 9464.0156, 1133.6536);
	angles[42] = (0, 73.4729, 0);
	at[42] = 30.9833;
	points[43] = (-2300.8032, 9479.9609, 1133.6536);
	angles[43] = (0, 77.5968, 0);
	at[43] = 31.3500;
	points[44] = (-2332.7087, 9483.7402, 1133.6536);
	angles[44] = (0, 83.8629, 0);
	at[44] = 31.5333;
	points[45] = (-2463.0828, 9487.0469, 1133.6536);
	angles[45] = (0, 89.8172, 0);
	at[45] = 32.2667;
	points[46] = (-2560.9922, 9487.2441, 1133.6536);
	angles[46] = (0, 89.2974, 0);
	at[46] = 32.8167;
	points[47] = (-2625.0198, 9490.4336, 1133.6536);
	angles[47] = (0, 86.7414, 0);
	at[47] = 33.1833;
	points[48] = (-2755.3032, 9496.7715, 1133.6536);
	angles[48] = (0, 88.1852, 0);
	at[48] = 33.9167;
	points[49] = (-2820.8191, 9495.9053, 1133.6536);
	angles[49] = (0, 93.0381, 0);
	at[49] = 34.2833;
	points[50] = (-2851.6182, 9490.1963, 1133.6536);
	angles[50] = (0, 101.5673, 0);
	at[50] = 34.4667;
	points[51] = (-2882.8977, 9481.4180, 1133.6536);
	angles[51] = (0, 105.8646, 0);
	at[51] = 34.6500;
	points[52] = (-2975.4961, 9449.6855, 1133.6536);
	angles[52] = (0, 110.2058, 0);
	at[52] = 35.2000;
	points[53] = (-3036.1182, 9425.2363, 1133.6536);
	angles[53] = (0, 113.0295, 0);
	at[53] = 35.5667;
	points[54] = (-3064.7007, 9411.1816, 1133.6536);
	angles[54] = (0, 117.6588, 0);
	at[54] = 35.7500;
	points[55] = (-3090.7441, 9391.7324, 1133.6536);
	angles[55] = (0, 127.6222, 0);
	at[55] = 35.9333;
	points[56] = (-3137.8660, 9346.8506, 1133.6536);
	angles[56] = (0, 135.2574, 0);
	at[56] = 36.3000;
	points[57] = (-3181.0356, 9297.9141, 1133.6536);
	angles[57] = (0, 140.5034, 0);
	at[57] = 36.6667;
	points[58] = (-3196.7678, 9274.5674, 1133.6536);
	angles[58] = (0, 148.2895, 0);
	at[58] = 36.8500;
	points[59] = (-3206.6970, 9253.8584, 1133.6536);
	angles[59] = (0, 154.7231, 0);
	at[59] = 37.0333;
	points[60] = (-3231.1340, 9190.0400, 1133.6536);
	angles[60] = (0, 160.7889, 0);
	at[60] = 37.5833;
	points[61] = (-3250.0945, 9124.4883, 1133.6536);
	angles[61] = (0, 166.4355, 0);
	at[61] = 38.1333;
	points[62] = (-3253.5078, 9105.0400, 1133.6536);
	angles[62] = (0, 171.1727, 0.0038);
	at[62] = 38.3167;
	points[63] = (-3256.3584, 9072.2051, 1133.6653);
	angles[63] = (0, 175.8680, 0.0285);
	at[63] = 38.6833;
	points[64] = (-3260.2915, 8930.0791, 1133.7245);
	angles[64] = (0, 180.2179, 0.0052);
	at[64] = 40.2833;
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
	points[0] = (-3537.3860, 4741.4961, 1133.6536);
	angles[0] = (0, -98.3176, 0);
	at[0] = 0;
	points[1] = (-3413.5002, 4728.3467, 1133.6536);
	angles[1] = (0, -94.8615, 0);
	at[1] = 0.7000;
	points[2] = (-3290.2834, 4722.8345, 1133.6536);
	angles[2] = (0, -89.5309, 0);
	at[2] = 1.4000;
	points[3] = (-3166.3464, 4731.4565, 1133.6536);
	angles[3] = (0, -84.7526, 0);
	at[3] = 2.1000;
	points[4] = (-3042.9607, 4746.2598, 1133.6536);
	angles[4] = (0, -81.7765, 0);
	at[4] = 2.8000;
	points[5] = (-3001.6418, 4753.5039, 1133.6536);
	angles[5] = (0, -79.3676, 0);
	at[5] = 3.0333;
	points[6] = (-2923.9016, 4777.3228, 1133.6536);
	angles[6] = (0, -70.7695, 0);
	at[6] = 3.5000;
	points[7] = (-2731.4016, 4855.3149, 1133.6536);
	angles[7] = (0, -65.9022, 0);
	at[7] = 4.6667;
	points[8] = (-2694.4922, 4872.8740, 1133.6536);
	angles[8] = (0, -63.9685, 0);
	at[8] = 4.9000;
	points[9] = (-2659.2363, 4893.5825, 1133.6536);
	angles[9] = (0, -57.5724, 0);
	at[9] = 5.1333;
	points[10] = (-2626.1772, 4918.3467, 1133.6536);
	angles[10] = (0, -52.5110, 0);
	at[10] = 5.3667;
	points[11] = (-2531.9805, 4999.7642, 1133.6536);
	angles[11] = (0, -47.5149, 0);
	at[11] = 6.0667;
	points[12] = (-2473.0237, 5057.9526, 1133.6536);
	angles[12] = (0, -43.6410, 0);
	at[12] = 6.5333;
	points[13] = (-2447.7915, 5089.8032, 1133.6614);
	angles[13] = (0, -36.4795, 0.0207);
	at[13] = 6.7667;
	points[14] = (-2404.1338, 5160.3545, 1133.7166);
	angles[14] = (0, -30.4533, 0.0378);
	at[14] = 7.2333;
	points[15] = (-2326.7756, 5306.7720, 1133.6575);
	angles[15] = (0, -25.1338, -0.1423);
	at[15] = 8.1667;
	points[16] = (-2305.4370, 5360.7876, 1133.3976);
	angles[16] = (0, -20.5204, -0.2778);
	at[16] = 8.6333;
	points[17] = (-2276.5198, 5443.0708, 1132.9094);
	angles[17] = (0, -18.7576, -0.3534);
	at[17] = 9.3333;
	points[18] = (-2234.1260, 5582.1655, 1131.6141);
	angles[18] = (0, -14.1629, -0.7914);
	at[18] = 10.5000;
	points[19] = (-2226.3582, 5623.8579, 1130.6969);
	angles[19] = (0, -9.3466, -1.4082);
	at[19] = 10.9667;
	points[20] = (-2213.0906, 5726.8110, 1127.7756);
	angles[20] = (0, -6.0556, -1.7003);
	at[20] = 12.1333;
	points[21] = (-2206.0630, 5850.7876, 1123.9489);
	angles[21] = (0, 0.8458, -1.8020);
	at[21] = 13.5333;
	points[22] = (-2210.9487, 5891.2998, 1122.6339);
	angles[22] = (0, 10.0350, -1.9003);
	at[22] = 14;
	points[23] = (-2230.0276, 5971.5747, 1119.8032);
	angles[23] = (0, 14.8714, -1.9717);
	at[23] = 14.9333;
	points[24] = (-2253.4802, 6051.1812, 1116.9843);
	angles[24] = (0, 17.6197, -1.9142);
	at[24] = 15.8667;
	points[25] = (-2281.8857, 6129.2915, 1114.3505);
	angles[25] = (0, 22.5072, -1.6968);
	at[25] = 16.8000;
	points[26] = (-2300.5393, 6165.5122, 1113.3268);
	angles[26] = (0, 31.9750, -1.1672);
	at[26] = 17.2667;
	points[27] = (-2313.8071, 6181.2993, 1113.0787);
	angles[27] = (0, 41.5525, -0.5936);
	at[27] = 17.5000;
	points[28] = (-2328.3230, 6195.4331, 1112.9567);
	angles[28] = (0, 46.4598, -0.2989);
	at[28] = 17.7333;
	points[29] = (-2360.0315, 6222.3623, 1112.8740);
	angles[29] = (0, 50.8945, -0.0438);
	at[29] = 18.2000;
	points[30] = (-2426.5078, 6271.8896, 1112.9843);
	angles[30] = (0, 54.7167, 0.1347);
	at[30] = 19.1333;
	points[31] = (-2495.2126, 6317.8740, 1113.2205);
	angles[31] = (0, 57.3505, 0.1663);
	at[31] = 20.0667;
	points[32] = (-2547.7048, 6348.9370, 1113.3229);
	angles[32] = (0, 61.7590, 0.0068);
	at[32] = 20.7667;
	points[33] = (-2604.0156, 6376.0239, 1113.3229);
	angles[33] = (0, 65.3316, 0);
	at[33] = 21.4667;
	points[34] = (-2718.5945, 6424.6064, 1113.3229);
	angles[34] = (0, 68.3927, 0);
	at[34] = 22.8667;
	points[35] = (-2796.9802, 6452.8345, 1113.3229);
	angles[35] = (0, 72.1427, 0);
	at[35] = 23.8000;
	points[36] = (-2836.2283, 6462.8740, 1113.3229);
	angles[36] = (0, 79.0683, 0);
	at[36] = 24.2667;
	points[37] = (-2856.8860, 6464.8818, 1113.3229);
	angles[37] = (0, 85.3987, 0);
	at[37] = 24.5000;
	points[38] = (-2897.8071, 6465.4331, 1113.3229);
	angles[38] = (0, 90.5478, 0);
	at[38] = 24.9667;
	points[39] = (-3022.1338, 6458.3071, 1113.3229);
	angles[39] = (0, 94.6707, 0);
	at[39] = 26.3667;
	points[40] = (-3165.1458, 6443.7402, 1113.3229);
	angles[40] = (0, 97.4240, 0);
	at[40] = 28;
	points[41] = (-3288.2126, 6423.1890, 1113.3229);
	angles[41] = (0, 100.0898, 0);
	at[41] = 29.4000;
	points[42] = (-3472.4370, 6390.8267, 1113.3229);
	angles[42] = (0, 99.0099, 0);
	at[42] = 31.5000;
	points[43] = (-3574.0710, 6378.6616, 1113.3229);
	angles[43] = (0, 96.1181, 0);
	at[43] = 32.6667;
	points[44] = (-3800.8113, 6354.0552, 1113.3229);
	angles[44] = (0, 97.1681, 0);
	at[44] = 35.2333;
	points[45] = (-3984.3704, 6328.5430, 1113.3229);
	angles[45] = (0, 98.5450, 0);
	at[45] = 37.3333;
	points[46] = (-4086.6931, 6310.7090, 1113.3229);
	angles[46] = (0, 101.4282, 0);
	at[46] = 38.5000;
	points[47] = (-4147.0474, 6295.0396, 1113.3229);
	angles[47] = (0, 108.1260, 0);
	at[47] = 39.2000;
	points[48] = (-4164.6455, 6287.1260, 1113.3188);
	angles[48] = (0, 117.0965, -0.0153);
	at[48] = 39.4333;
	points[49] = (-4181.6143, 6275.0786, 1113.2834);
	angles[49] = (0, 126.9126, -0.1192);
	at[49] = 39.6667;
	points[50] = (-4197.4014, 6261.2598, 1113.2244);
	angles[50] = (0, 131.9776, -0.1669);
	at[50] = 39.9000;
	points[51] = (-4266.5356, 6184.3696, 1112.9292);
	angles[51] = (0, 141.1547, -0.1212);
	at[51] = 41.0667;
	points[52] = (-4326.8110, 6100.1973, 1113.0552);
	angles[52] = (0, 147.7096, 0.3628);
	at[52] = 42.2333;
	points[53] = (-4345.2363, 6063.6616, 1113.7677);
	angles[53] = (0, 157.4855, 1.4396);
	at[53] = 42.7000;
	points[54] = (-4358.1890, 6024.8032, 1115.0433);
	angles[54] = (0, 162.8764, 1.8898);
	at[54] = 43.1667;
	points[55] = (-4379.0156, 5944.4097, 1118.0433);
	angles[55] = (0, 167.1273, 2.1643);
	at[55] = 44.1000;
	points[56] = (-4396.4175, 5842.2832, 1122.1851);
	angles[56] = (0, 174.1443, 2.3993);
	at[56] = 45.2667;
	points[57] = (-4397.4019, 5821.5356, 1123.0787);
	angles[57] = (0, 178.7209, 2.4890);
	at[57] = 45.5000;
	points[58] = (-4394.4492, 5795.9844, 1124.3229);
	angles[58] = (0, 188.2026, 2.8609);
	at[58] = 45.7333;
	points[59] = (-4388.1104, 5767.8740, 1125.8623);
	angles[59] = (0, 193.3338, 3.0749);
	at[59] = 45.9667;
	points[60] = (-4353.8975, 5657.1260, 1132.1141);
	angles[60] = (0, 198.8398, 2.9907);
	at[60] = 46.9000;
	points[61] = (-4313.3857, 5548.4248, 1137.1024);
	angles[61] = (0, 201.9388, 1.5501);
	at[61] = 47.8333;
	points[62] = (-4297.6382, 5513.3071, 1137.2953);
	angles[62] = (0, 204.6587, 0.0694);
	at[62] = 48.0667;
	points[63] = (-4260.7876, 5438.5825, 1136.4489);
	angles[63] = (0, 206.7651, -0.7479);
	at[63] = 48.5333;
	points[64] = (-4163.1104, 5257.5596, 1133.6102);
	angles[64] = (0, 210.5638, -0.3484);
	at[64] = 49.7000;
	points[65] = (-4052.5591, 5081.7324, 1133.5551);
	angles[65] = (0, 213.6338, 0.0446);
	at[65] = 50.8667;
	points[66] = (-4004.3701, 5013.9370, 1133.6260);
	angles[66] = (0, 216.8268, 0.0486);
	at[66] = 51.3333;
	points[67] = (-3977.6770, 4982.1260, 1133.6497);
	angles[67] = (0, 221.4644, 0.0270);
	at[67] = 51.5667;
	points[68] = (-3947.8347, 4955.5908, 1133.6536);
	angles[68] = (0, 229.6018, 0.0013);
	at[68] = 51.8000;
	points[69] = (-3881.3818, 4905.9844, 1133.6536);
	angles[69] = (0, 234.3484, 0);
	at[69] = 52.2667;
	points[70] = (-3778.0945, 4836.6929, 1133.6536);
	angles[70] = (0, 237.2830, 0);
	at[70] = 52.9667;
	points[71] = (-3707.2048, 4793.7402, 1133.6536);
	angles[71] = (0, 239.8651, 0);
	at[71] = 53.4333;
	points[72] = (-3670.5120, 4774.0947, 1133.6536);
	angles[72] = (0, 242.6354, 0);
	at[72] = 53.6667;
	points[73] = (-3633.4763, 4759.5669, 1133.6536);
	angles[73] = (0, 251.2059, 0);
	at[73] = 53.9000;
	points[74] = (-3592.6853, 4750.3149, 1133.6536);
	angles[74] = (0, 258.0917, 0);
	at[74] = 54.1333;
	points[75] = (-3537.3860, 4741.4961, 1133.6536);
	angles[75] = (0, 261.6824, 0);
	at[75] = 54.4500;
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
	points[0] = (-545.9173, 7819.6460, 1111.8701);
	angles[0] = (0, 95.2897, 0.0577);
	at[0] = 0;
	points[1] = (-607.9685, 7815.1577, 1111.9409);
	angles[1] = (0, 92.9700, 0.0598);
	at[1] = 0.7000;
	points[2] = (-648.7283, 7815.6299, 1111.9567);
	angles[2] = (0, 86.5283, 0.0143);
	at[2] = 1.1667;
	points[3] = (-751.2638, 7828.9370, 1112.0118);
	angles[3] = (0, 80.9561, 0.0358);
	at[3] = 2.3333;
	points[4] = (-852.8110, 7848.4253, 1112.0748);
	angles[4] = (0, 77.0868, 0.0285);
	at[4] = 3.5000;
	points[5] = (-891.9882, 7859.9609, 1112.0867);
	angles[5] = (0, 71.3610, 0.0075);
	at[5] = 3.9667;
	points[6] = (-950.1653, 7881.8896, 1112.0867);
	angles[6] = (0, 68.5453, 0);
	at[6] = 4.6667;
	points[7] = (-1102.5591, 7948.4648, 1112.0828);
	angles[7] = (0, 63.2474, -0.0027);
	at[7] = 6.5333;
	points[8] = (-1136.8662, 7969.3701, 1112.0787);
	angles[8] = (0, 56.5475, -0.0034);
	at[8] = 7;
	points[9] = (-1204.0748, 8018.1494, 1112.0748);
	angles[9] = (0, 52.8037, -0.0045);
	at[9] = 7.9333;
	points[10] = (-1268.8818, 8069.9214, 1112.0669);
	angles[10] = (0, 50.0889, -0.0052);
	at[10] = 8.8667;
	points[11] = (-1298.7953, 8097.1265, 1112.0591);
	angles[11] = (0, 45.2777, -0.0373);
	at[11] = 9.3333;
	points[12] = (-1326.6221, 8128.0713, 1111.9685);
	angles[12] = (0, 40.9588, -0.1445);
	at[12] = 9.8000;
	points[13] = (-1379.3740, 8192.2832, 1111.7834);
	angles[13] = (0, 38.5261, -0.0877);
	at[13] = 10.7333;
	points[14] = (-1440.5000, 8274.7637, 1112.1102);
	angles[14] = (0, 33.0396, 0.7666);
	at[14] = 11.9000;
	points[15] = (-1500.4724, 8383.9766, 1114.9685);
	angles[15] = (0, 27.1025, 1.5589);
	at[15] = 13.3000;
	points[16] = (-1527.6615, 8439.8428, 1116.8859);
	angles[16] = (0, 24.9152, 1.9649);
	at[16] = 14;
	points[17] = (-1543.0236, 8477.1660, 1118.6497);
	angles[17] = (0, 19.9922, 3.0937);
	at[17] = 14.4667;
	points[18] = (-1566.8701, 8556.7324, 1124.8544);
	angles[18] = (0, 15.4103, 4.5383);
	at[18] = 15.4000;
	points[19] = (-1591.1024, 8657.3232, 1132.8464);
	angles[19] = (0, 11.6156, 4.1166);
	at[19] = 16.5667;
	points[20] = (-1597.7482, 8698.1895, 1135.4331);
	angles[20] = (0, 7.2759, 3.0964);
	at[20] = 17.0333;
	points[21] = (-1598.0079, 8738.3076, 1136.2836);
	angles[21] = (0, -2.5514, 0.3765);
	at[21] = 17.5000;
	points[22] = (-1580.9606, 8882.6768, 1134.9253);
	angles[22] = (0, -9.1287, -0.8142);
	at[22] = 19.1333;
	points[23] = (-1569.1615, 8943.8584, 1134.0355);
	angles[23] = (0, -12.5326, -0.7828);
	at[23] = 19.8333;
	points[24] = (-1557.1102, 8983.5039, 1133.6339);
	angles[24] = (0, -21.2585, -0.3108);
	at[24] = 20.3000;
	points[25] = (-1528.8071, 9034.3701, 1133.5551);
	angles[25] = (0, -31.4091, -0.0288);
	at[25] = 20.7667;
	points[26] = (-1479.5039, 9106.1807, 1133.5787);
	angles[26] = (0, -36.2563, 0.0358);
	at[26] = 21.4667;
	points[27] = (-1423.8583, 9172.8740, 1133.6456);
	angles[27] = (0, -43.6189, 0.0377);
	at[27] = 22.1667;
	points[28] = (-1399.3032, 9192.7559, 1133.6536);
	angles[28] = (0, -53.8112, 0.0060);
	at[28] = 22.4000;
	points[29] = (-1362.6929, 9212.3232, 1133.6536);
	angles[29] = (0, -62.8781, 0);
	at[29] = 22.6333;
	points[30] = (-1324.7284, 9229.4092, 1133.6536);
	angles[30] = (0, -66.3055, 0);
	at[30] = 22.8667;
	points[31] = (-1207.9055, 9272.0869, 1133.6536);
	angles[31] = (0, -72.4151, 0);
	at[31] = 23.5667;
	points[32] = (-1167.7126, 9282.8740, 1133.6536);
	angles[32] = (0, -75.9852, 0);
	at[32] = 23.8000;
	points[33] = (-1127.5865, 9288.5430, 1133.6536);
	angles[33] = (0, -83.5881, 0);
	at[33] = 24.0333;
	points[34] = (-1045.1221, 9292.2441, 1133.6536);
	angles[34] = (0, -88.3743, 0);
	at[34] = 24.5000;
	points[35] = (-837.8071, 9292.4414, 1133.6536);
	angles[35] = (0, -90.8826, 0);
	at[35] = 25.6667;
	points[36] = (-714.3189, 9286.2988, 1133.6536);
	angles[36] = (0, -94.9479, 0);
	at[36] = 26.3667;
	points[37] = (-262.3575, 9235.3936, 1133.6536);
	angles[37] = (0, -96.7196, 0);
	at[37] = 28.9333;
	points[38] = (-180.1504, 9223.2676, 1133.6536);
	angles[38] = (0, -99.7805, 0);
	at[38] = 29.4000;
	points[39] = (-140.2587, 9214.2129, 1133.6536);
	angles[39] = (0, -104.1122, 0);
	at[39] = 29.6333;
	points[40] = (-102.7094, 9197.5195, 1133.6536);
	angles[40] = (0, -117.5336, 0);
	at[40] = 29.8667;
	points[41] = (-68.8685, 9174.5674, 1133.6536);
	angles[41] = (0, -124.9686, 0);
	at[41] = 30.1000;
	points[42] = (-35.8740, 9149.2910, 1133.6536);
	angles[42] = (0, -127.8950, 0);
	at[42] = 30.3333;
	points[43] = (58.1965, 9067.9531, 1133.6536);
	angles[43] = (0, -132.6772, 0);
	at[43] = 31.0333;
	points[44] = (115.1016, 9008.7793, 1133.6536);
	angles[44] = (0, -140.0161, 0);
	at[44] = 31.5000;
	points[45] = (136.6161, 8973.4648, 1133.6536);
	angles[45] = (0, -150.0407, 0);
	at[45] = 31.7333;
	points[46] = (190.1969, 8861.1025, 1133.6536);
	angles[46] = (0, -155.5744, 0);
	at[46] = 32.4333;
	points[47] = (243.7110, 8748.4258, 1133.6536);
	angles[47] = (0, -152.1154, 0);
	at[47] = 33.1333;
	points[48] = (266.3378, 8715.4326, 1133.6536);
	angles[48] = (0, -144.0240, 0);
	at[48] = 33.3667;
	points[49] = (319.5083, 8651.6143, 1133.6536);
	angles[49] = (0, -139.0875, 0);
	at[49] = 33.8333;
	points[50] = (404.1614, 8560.7480, 1133.6536);
	angles[50] = (0, -135.2607, 0);
	at[50] = 34.5333;
	points[51] = (435.0394, 8534.2520, 1133.6536);
	angles[51] = (0, -128.3901, 0);
	at[51] = 34.7667;
	points[52] = (504.0276, 8487.9521, 1133.6536);
	angles[52] = (0, -123.2422, 0);
	at[52] = 35.2333;
	points[53] = (572.5118, 8441.4570, 1133.6536);
	angles[53] = (0, -125.3762, 0);
	at[53] = 35.7000;
	points[54] = (605.1851, 8415.3145, 1133.6536);
	angles[54] = (0, -130.2936, 0);
	at[54] = 35.9333;
	points[55] = (625.8740, 8386.2988, 1133.6536);
	angles[55] = (0, -152.4981, 0);
	at[55] = 36.1667;
	points[56] = (633.7126, 8358.4258, 1133.6536);
	angles[56] = (0, -165.6463, 0);
	at[56] = 36.4000;
	points[57] = (638.8780, 8329.8818, 1133.6536);
	angles[57] = (0, -170.4474, 0);
	at[57] = 36.6333;
	points[58] = (645.1024, 8272.0479, 1133.6536);
	angles[58] = (0, -175.4170, 0);
	at[58] = 37.1000;
	points[59] = (646.9173, 8213.9375, 1133.6536);
	angles[59] = (0, -179.9881, 0);
	at[59] = 37.5667;
	points[60] = (645.4174, 8185.2363, 1133.6536);
	angles[60] = (0, -184.2188, 0);
	at[60] = 37.8000;
	points[61] = (640.2008, 8161.1416, 1133.6536);
	angles[61] = (0, -196.1100, 0);
	at[61] = 38.0333;
	points[62] = (632.2244, 8141.8501, 1133.6536);
	angles[62] = (0, -203.3647, 0);
	at[62] = 38.2667;
	points[63] = (623.1260, 8123.2676, 1133.6536);
	angles[63] = (0, -206.5954, 0);
	at[63] = 38.5000;
	points[64] = (569.0039, 8034.6851, 1133.6536);
	angles[64] = (0, -214.9093, 0);
	at[64] = 39.6667;
	points[65] = (543.4921, 8001.9287, 1133.6536);
	angles[65] = (0, -220.1266, 0);
	at[65] = 40.1333;
	points[66] = (528.8701, 7987.0474, 1133.6536);
	angles[66] = (0, -226.2353, 0);
	at[66] = 40.3667;
	points[67] = (512.3701, 7976.7319, 1133.6536);
	angles[67] = (0, -241.9388, 0);
	at[67] = 40.6000;
	points[68] = (492.7166, 7969.8032, 1133.6536);
	angles[68] = (0, -251.7851, 0);
	at[68] = 40.8333;
	points[69] = (452.4449, 7960.0791, 1133.6536);
	angles[69] = (0, -257.9602, 0);
	at[69] = 41.3000;
	points[70] = (288.3846, 7936.5356, 1133.6536);
	angles[70] = (0, -263.9369, 0);
	at[70] = 43.1667;
	points[71] = (247.4968, 7934.9609, 1133.8544);
	angles[71] = (0, -269.4333, 0.3907);
	at[71] = 43.6333;
	points[72] = (185.2669, 7935.8662, 1134.2756);
	angles[72] = (0, -271.2908, 0.3247);
	at[72] = 44.3333;
	points[73] = (123.0047, 7937.1260, 1134.3386);
	angles[73] = (0, -270.7419, -0.2242);
	at[73] = 45.0333;
	points[74] = (82.1551, 7936.3384, 1133.6024);
	angles[74] = (0, -266.8382, -1.9181);
	at[74] = 45.5000;
	points[75] = (41.2598, 7932.0474, 1130.8110);
	angles[75] = (0, -263.2826, -4.4222);
	at[75] = 45.9667;
	points[76] = (-20.2942, 7923.8584, 1125.5472);
	angles[76] = (0, -262.0026, -4.9702);
	at[76] = 46.6667;
	points[77] = (-102.1138, 7911.1416, 1118.6221);
	angles[77] = (0, -260.3270, -4.3794);
	at[77] = 47.6000;
	points[78] = (-141.7764, 7903.0713, 1116.3661);
	angles[78] = (0, -256.6905, -2.2686);
	at[78] = 48.0667;
	points[79] = (-241.5413, 7874.9609, 1113.9528);
	angles[79] = (0, -253.8180, -1.0459);
	at[79] = 49.2333;
	points[80] = (-361.8736, 7842.5195, 1112.1378);
	angles[80] = (0, -257.5795, -0.6404);
	at[80] = 50.6333;
	points[81] = (-401.4173, 7836.1416, 1111.8977);
	angles[81] = (0, -261.7540, -0.2026);
	at[81] = 51.1000;
	points[82] = (-545.9173, 7819.6460, 1111.8701);
	angles[82] = (0, -264.7103, 0.0577);
	at[82] = 52.7333;
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
	points[0] = (-6654.8818, 3838.7717, 1114.0511);
	angles[0] = (0, -97.7499, 0.0172);
	at[0] = 0;
	points[1] = (-6579.1338, 3824.3818, 1114.0748);
	angles[1] = (0, -104.5969, 0.0124);
	at[1] = 0.8667;
	points[2] = (-6544.7241, 3809.8030, 1114.0748);
	angles[2] = (0, -117.0087, 0);
	at[2] = 1.3000;
	points[3] = (-6447.2837, 3748.0552, 1114.0748);
	angles[3] = (0, -124.5651, 0);
	at[3] = 2.6000;
	points[4] = (-6339.5669, 3666.9607, 1114.0748);
	angles[4] = (0, -129.8704, 0);
	at[4] = 4.1167;
	points[5] = (-6312.7168, 3640.9253, 1114.0748);
	angles[5] = (0, -137.8167, 0);
	at[5] = 4.5500;
	points[6] = (-6267.5200, 3578.4961, 1114.0748);
	angles[6] = (0, -146.4529, 0);
	at[6] = 5.4167;
	points[7] = (-6217.4014, 3496.4805, 1114.0748);
	angles[7] = (0, -150.0812, 0);
	at[7] = 6.5000;
	points[8] = (-6182.6377, 3428.9409, 1114.0748);
	angles[8] = (0, -156.8251, 0);
	at[8] = 7.3667;
	points[9] = (-6169.6855, 3392.2834, 1114.0748);
	angles[9] = (0, -161.6458, 0);
	at[9] = 7.8000;
	points[10] = (-6137.2046, 3281.5120, 1114.0748);
	angles[10] = (0, -164.6271, 0);
	at[10] = 9.1000;
	points[11] = (-6096.5356, 3113.8386, 1113.9016);
	angles[11] = (0, -168.5134, -0.1777);
	at[11] = 11.0500;
	points[12] = (-6069.0947, 2962.5513, 1113.8820);
	angles[12] = (0, -171.2495, 0.3842);
	at[12] = 12.7833;
	points[13] = (-6051.5752, 2790.7954, 1118.5276);
	angles[13] = (0, -175.7214, 1.8677);
	at[13] = 14.7333;
	points[14] = (-6048.1499, 2713.6616, 1121.1851);
	angles[14] = (0, -179.4683, 2.0631);
	at[14] = 15.6000;
	points[15] = (-6048.6616, 2694.4331, 1121.9016);
	angles[15] = (0, -182.2739, 2.1653);
	at[15] = 15.8167;
	points[16] = (-6050.9844, 2676.6182, 1122.6417);
	angles[16] = (0, -189.2799, 2.4479);
	at[16] = 16.0333;
	points[17] = (-6055.7876, 2657.9490, 1123.5826);
	angles[17] = (0, -195.1690, 2.8434);
	at[17] = 16.2500;
	points[18] = (-6075.1182, 2603.4292, 1126.6851);
	angles[18] = (0, -201.4256, 3.1262);
	at[18] = 16.9000;
	points[19] = (-6115.4331, 2516.0867, 1131.7795);
	angles[19] = (0, -207.6909, 2.8325);
	at[19] = 17.9833;
	points[20] = (-6135.3154, 2483.0237, 1133.4370);
	angles[20] = (0, -213.6666, 2.1308);
	at[20] = 18.4167;
	points[21] = (-6146.8110, 2469.2322, 1133.8505);
	angles[21] = (0, -221.5195, 1.1111);
	at[21] = 18.6333;
	points[22] = (-6175.2363, 2443.0984, 1134.1221);
	angles[22] = (0, -229.0331, 0.2165);
	at[22] = 19.0667;
	points[23] = (-6251.2598, 2383.8071, 1134.0079);
	angles[23] = (0, -233.7410, -0.1877);
	at[23] = 20.1500;
	points[24] = (-6331.5356, 2330.1025, 1133.6575);
	angles[24] = (0, -239.3917, -0.1351);
	at[24] = 21.2333;
	points[25] = (-6351.4961, 2320.2600, 1133.6536);
	angles[25] = (0, -244.8897, -0.0125);
	at[25] = 21.4500;
	points[26] = (-6402.2441, 2301.8032, 1133.6536);
	angles[26] = (0, -251.3396, 0);
	at[26] = 21.8833;
	points[27] = (-6584.3311, 2247.3977, 1133.6536);
	angles[27] = (0, -253.1048, 0);
	at[27] = 23.4000;
	points[28] = (-6768.6611, 2191.1575, 1133.6536);
	angles[28] = (0, -253.9431, 0);
	at[28] = 24.4833;
	points[29] = (-6842.6772, 2172.9568, 1133.6536);
	angles[29] = (0, -258.8820, 0);
	at[29] = 24.9167;
	points[30] = (-6881.1421, 2168.2598, 1133.6536);
	angles[30] = (0, -263.5068, 0);
	at[30] = 25.1333;
	points[31] = (-6957.7163, 2162.2598, 1133.6536);
	angles[31] = (0, -266.1340, 0);
	at[31] = 25.5667;
	points[32] = (-7111.1812, 2156.5552, 1133.6536);
	angles[32] = (0, -269.9979, 0);
	at[32] = 26.4333;
	points[33] = (-7264.5273, 2165.7166, 1133.6536);
	angles[33] = (0, -274.8334, 0);
	at[33] = 27.3000;
	points[34] = (-7378.9761, 2181.1221, 1133.6536);
	angles[34] = (0, -281.4963, 0);
	at[34] = 27.9500;
	points[35] = (-7414.6060, 2191.8860, 1133.6536);
	angles[35] = (0, -287.4067, 0);
	at[35] = 28.1667;
	points[36] = (-7522.9922, 2232.7166, 1133.6536);
	angles[36] = (0, -292.1228, 0);
	at[36] = 28.8167;
	points[37] = (-7627.6382, 2282.3386, 1133.6536);
	angles[37] = (0, -298.8269, 0);
	at[37] = 29.4667;
	points[38] = (-7657.4805, 2304.1890, 1133.6536);
	angles[38] = (0, -310.3353, 0);
	at[38] = 29.6833;
	points[39] = (-7680.1577, 2335.8386, 1133.6536);
	angles[39] = (0, -325.9810, 0);
	at[39] = 29.9000;
	points[40] = (-7698.6221, 2369.2126, 1133.6536);
	angles[40] = (0, -331.5914, 0);
	at[40] = 30.1167;
	points[41] = (-7746.2603, 2474.4490, 1133.6536);
	angles[41] = (0, -337.5239, 0);
	at[41] = 30.7667;
	points[42] = (-7772.7954, 2546.4451, 1133.6536);
	angles[42] = (0, -341.6030, 0);
	at[42] = 31.2000;
	points[43] = (-7789.9214, 2620.9331, 1133.6536);
	angles[43] = (0, -348.7967, 0);
	at[43] = 31.6333;
	points[44] = (-7801.9297, 2696.9805, 1133.6536);
	angles[44] = (0, -352.1686, 0);
	at[44] = 32.0667;
	points[45] = (-7808.1494, 2773.8545, 1133.6536);
	angles[45] = (0, -357.8318, 0);
	at[45] = 32.5000;
	points[46] = (-7805.5117, 2810.5750, 1133.6536);
	angles[46] = (0, -366.8270, 0);
	at[46] = 32.7167;
	points[47] = (-7796.2598, 2848.5906, 1133.6536);
	angles[47] = (0, -374.3282, 0);
	at[47] = 32.9333;
	points[48] = (-7785.2759, 2885.6575, 1133.6536);
	angles[48] = (0, -376.7655, 0);
	at[48] = 33.1500;
	points[49] = (-7709.8032, 3103.5828, 1133.6536);
	angles[49] = (0, -380.1315, 0);
	at[49] = 34.4500;
	points[50] = (-7653.0312, 3245.9214, 1133.6536);
	angles[50] = (0, -382.8884, 0);
	at[50] = 35.3167;
	points[51] = (-7605.4727, 3351.0750, 1133.6536);
	angles[51] = (0, -385.8789, 0);
	at[51] = 35.9667;
	points[52] = (-7589.5669, 3380.0198, 1133.6653);
	angles[52] = (0, -390.1633, 0.0480);
	at[52] = 36.1833;
	points[53] = (-7574.8818, 3402.9133, 1133.7245);
	angles[53] = (0, -393.0172, 0.1391);
	at[53] = 36.4000;
	points[54] = (-7448.9761, 3577.7480, 1133.8583);
	angles[54] = (0, -397.2514, -0.3603);
	at[54] = 38.1333;
	points[55] = (-7434.4097, 3596.4490, 1133.5354);
	angles[55] = (0, -398.1165, -0.9915);
	at[55] = 38.3500;
	points[56] = (-7361.6929, 3686.4490, 1129.8188);
	angles[56] = (0, -399.8442, -2.0919);
	at[56] = 39.6500;
	points[57] = (-7310.7480, 3744.3621, 1126.8740);
	angles[57] = (0, -402.9199, -2.2428);
	at[57] = 40.5167;
	points[58] = (-7283.4648, 3771.1182, 1125.3505);
	angles[58] = (0, -407.6320, -2.2943);
	at[58] = 40.9500;
	points[59] = (-7251.7324, 3791.1140, 1123.7914);
	angles[59] = (0, -423.4988, -2.4691);
	at[59] = 41.3833;
	points[60] = (-7197.8740, 3811.9568, 1121.2284);
	angles[60] = (0, -430.8511, -2.5475);
	at[60] = 42.0333;
	points[61] = (-7068.4648, 3848.6733, 1115.6063);
	angles[61] = (0, -436.9478, -2.0565);
	at[61] = 43.5500;
	points[62] = (-6992.5986, 3857.3977, 1114.3859);
	angles[62] = (0, -447.0749, -0.3719);
	at[62] = 44.4167;
	points[63] = (-6839.3701, 3856.8308, 1114.0670);
	angles[63] = (0, -453.4992, -0.0981);
	at[63] = 46.1500;
	points[64] = (-6654.8818, 3838.7717, 1114.0511);
	angles[64] = (0, -457.7499, 0.0172);
	at[64] = 48.2333;
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
	points[0] = (-9551.1816, 3280.8386, 1133.9449);
	angles[0] = (0, 96.8135, 0);
	at[0] = 0;
	points[1] = (-9598.0713, 3284.5632, 1133.9449);
	angles[1] = (0, 83.1231, 0);
	at[1] = 0.2667;
	points[2] = (-9690.7480, 3305.2520, 1133.9449);
	angles[2] = (0, 75.4346, 0);
	at[2] = 0.8000;
	points[3] = (-9781.6143, 3332.3743, 1133.9449);
	angles[3] = (0, 72.3416, 0);
	at[3] = 1.3333;
	points[4] = (-9870.8662, 3363.8425, 1133.9489);
	angles[4] = (0, 69.2943, 0);
	at[4] = 1.8667;
	points[5] = (-9913.0312, 3382.2717, 1133.9449);
	angles[5] = (0, 64.6334, 0);
	at[5] = 2.1333;
	points[6] = (-9994.9609, 3430.2795, 1133.9489);
	angles[6] = (0, 58.0828, 0);
	at[6] = 2.6667;
	points[7] = (-10074.0947, 3482.5708, 1133.9449);
	angles[7] = (0, 55.7106, 0);
	at[7] = 3.2000;
	points[8] = (-10151.0635, 3538.4961, 1133.9449);
	angles[8] = (0, 52.6259, 0);
	at[8] = 3.7333;
	points[9] = (-10185.7480, 3568.2480, 1133.9449);
	angles[9] = (0, 47.3079, 0);
	at[9] = 4;
	points[10] = (-10247.9531, 3639.9685, 1133.9449);
	angles[10] = (0, 39.0722, 0);
	at[10] = 4.5333;
	points[11] = (-10305.1973, 3715.5435, 1133.9449);
	angles[11] = (0, 36.0030, 0);
	at[11] = 5.0667;
	points[12] = (-10357.1650, 3794.9172, 1133.9449);
	angles[12] = (0, 30.6555, 0);
	at[12] = 5.6000;
	points[13] = (-10375.4717, 3837.5828, 1133.9449);
	angles[13] = (0, 19.5039, 0);
	at[13] = 5.8667;
	points[14] = (-10386.2998, 3883.3306, 1133.9489);
	angles[14] = (0, 12.2875, 0);
	at[14] = 6.1333;
	points[15] = (-10401.0635, 3977.1653, 1133.9489);
	angles[15] = (0, 7.4530, 0);
	at[15] = 6.6667;
	points[16] = (-10409.4883, 4071.3782, 1133.9489);
	angles[16] = (0, 3.4780, 0);
	at[16] = 7.2000;
	points[17] = (-10410.1182, 4119.1733, 1133.9489);
	angles[17] = (0, -0.5999, 0);
	at[17] = 7.4667;
	points[18] = (-10404.9609, 4164.5273, 1133.9489);
	angles[18] = (0, -7.9240, 0);
	at[18] = 7.7333;
	points[19] = (-10396.6143, 4211.1812, 1133.9489);
	angles[19] = (0, -10.5736, 0);
	at[19] = 8;
	points[20] = (-10365.7480, 4350.3545, 1133.9449);
	angles[20] = (0, -13.5991, 0);
	at[20] = 8.8000;
	points[21] = (-10341.4170, 4442.2046, 1133.9449);
	angles[21] = (0, -15.7763, 0);
	at[21] = 9.3333;
	points[22] = (-10327.4023, 4487.2441, 1133.9489);
	angles[22] = (0, -17.9529, 0);
	at[22] = 9.6000;
	points[23] = (-10310.1191, 4529.5278, 1133.9449);
	angles[23] = (0, -24.9750, 0);
	at[23] = 9.8667;
	points[24] = (-10285.2754, 4570.7480, 1133.9489);
	angles[24] = (0, -32.2090, 0);
	at[24] = 10.1333;
	points[25] = (-10202.0869, 4685.6299, 1133.9489);
	angles[25] = (0, -37.3247, 0);
	at[25] = 10.9333;
	points[26] = (-10085.0791, 4833.3857, 1133.9449);
	angles[26] = (0, -38.9623, 0);
	at[26] = 12;
	points[27] = (-9931.9688, 5014.2520, 1133.9489);
	angles[27] = (0, -40.9881, 0);
	at[27] = 13.3333;
	points[28] = (-9837.1650, 5117.8740, 1133.9449);
	angles[28] = (0, -45.1298, 0);
	at[28] = 14.1333;
	points[29] = (-9765.9443, 5180.9844, 1133.9449);
	angles[29] = (0, -49.3701, 0);
	at[29] = 14.6667;
	points[30] = (-9583.3857, 5332.7168, 1133.9449);
	angles[30] = (0, -50.2487, 0);
	at[30] = 16;
	points[31] = (-9472.6777, 5419.6064, 1133.9449);
	angles[31] = (0, -52.2974, 0);
	at[31] = 16.8000;
	points[32] = (-9398.5830, 5478.7793, 1133.9489);
	angles[32] = (0, -50.5473, 0);
	at[32] = 17.3333;
	points[33] = (-9329.0547, 5543.3462, 1133.9449);
	angles[33] = (0, -43.4738, 0);
	at[33] = 17.8667;
	points[34] = (-9302.5195, 5580.8662, 1133.9449);
	angles[34] = (0, -33.1045, 0);
	at[34] = 18.1333;
	points[35] = (-9279.0557, 5621.6533, 1133.9449);
	angles[35] = (0, -29.3728, 0);
	at[35] = 18.4000;
	points[36] = (-9214.4883, 5748.6616, 1133.9449);
	angles[36] = (0, -25.6310, 0);
	at[36] = 19.2000;
	points[37] = (-9175.4336, 5835.2759, 1133.9489);
	angles[37] = (0, -23.3204, 0);
	at[37] = 19.7333;
	points[38] = (-9143.7402, 5922.7949, 1133.9489);
	angles[38] = (0, -15.6420, 0);
	at[38] = 20.2667;
	points[39] = (-9136.1416, 5969.4097, 1133.9449);
	angles[39] = (0, -7.9759, 0);
	at[39] = 20.5333;
	points[40] = (-9131.4961, 6016.8506, 1133.9449);
	angles[40] = (0, -5.0979, 0);
	at[40] = 20.8000;
	points[41] = (-9122.0469, 6206.0234, 1133.9489);
	angles[41] = (0, -1.9650, 0);
	at[41] = 21.8667;
	points[42] = (-9105.7480, 6583.5830, 1133.9489);
	angles[42] = (0, -2.1547, 0);
	at[42] = 24;
	points[43] = (-9103.1104, 6725.8662, 1133.9449);
	angles[43] = (0, 0.2880, 0);
	at[43] = 24.8000;
	points[44] = (-9105.1182, 6771.4961, 1133.9489);
	angles[44] = (0, 3.8632, 0);
	at[44] = 25.0667;
	points[45] = (-9117.0469, 6865.5513, 1133.9489);
	angles[45] = (0, 8.2256, 0);
	at[45] = 25.6000;
	points[46] = (-9140.9443, 7005.9453, 1133.9449);
	angles[46] = (0, 10.6623, 0);
	at[46] = 26.4000;
	points[47] = (-9172.5596, 7144.7642, 1133.9449);
	angles[47] = (0, 15.2733, 0);
	at[47] = 27.2000;
	points[48] = (-9187.7168, 7187.7954, 1133.9489);
	angles[48] = (0, 22.1125, 0);
	at[48] = 27.4667;
	points[49] = (-9210.9053, 7229.0947, 1133.9449);
	angles[49] = (0, 30.7318, 0);
	at[49] = 27.7333;
	points[50] = (-9264.7637, 7307.4805, 1133.9489);
	angles[50] = (0, 35.8624, 0);
	at[50] = 28.2667;
	points[51] = (-9351.8105, 7419.6060, 1133.9489);
	angles[51] = (0, 39.0315, 0);
	at[51] = 29.0667;
	points[52] = (-9413.3857, 7491.1812, 1133.9449);
	angles[52] = (0, 42.4144, 0);
	at[52] = 29.6000;
	points[53] = (-9516.1426, 7588.4253, 1133.9449);
	angles[53] = (0, 48.3760, 0);
	at[53] = 30.4000;
	points[54] = (-9627.4014, 7676.8896, 1133.9449);
	angles[54] = (0, 54.8117, 0);
	at[54] = 31.2000;
	points[55] = (-9668.2676, 7701.1416, 1133.9449);
	angles[55] = (0, 61.6375, 0);
	at[55] = 31.4667;
	points[56] = (-9712.5195, 7712.9136, 1133.9449);
	angles[56] = (0, 79.3758, 0);
	at[56] = 31.7333;
	points[57] = (-9759.4492, 7716.6929, 1133.9489);
	angles[57] = (0, 86.4140, 0);
	at[57] = 32;
	points[58] = (-9806.9688, 7717.7563, 1133.9449);
	angles[58] = (0, 89.2806, 0);
	at[58] = 32.2667;
	points[59] = (-9949.3311, 7711.8115, 1133.9449);
	angles[59] = (0, 94.4969, 0);
	at[59] = 33.0667;
	points[60] = (-10043.3467, 7698.5435, 1133.9489);
	angles[60] = (0, 101.5444, 0);
	at[60] = 33.6000;
	points[61] = (-10085.1572, 7680.2754, 1133.9449);
	angles[61] = (0, 118.6125, 0);
	at[61] = 33.8667;
	points[62] = (-10123.2285, 7652.1655, 1133.9449);
	angles[62] = (0, 127.8651, 0);
	at[62] = 34.1333;
	points[63] = (-10193.3076, 7588.1895, 1133.9449);
	angles[63] = (0, 134.3174, 0);
	at[63] = 34.6667;
	points[64] = (-10257.6377, 7518.9370, 1133.9489);
	angles[64] = (0, 138.9970, 0);
	at[64] = 35.2000;
	points[65] = (-10286.7324, 7481.1812, 1133.9449);
	angles[65] = (0, 144.3370, 0);
	at[65] = 35.4667;
	points[66] = (-10307.2432, 7439.6064, 1133.9449);
	angles[66] = (0, 155.9208, 0);
	at[66] = 35.7333;
	points[67] = (-10323.6221, 7395.2754, 1133.9449);
	angles[67] = (0, 160.5369, 0);
	at[67] = 36;
	points[68] = (-10350.3154, 7304.2915, 1133.9449);
	angles[68] = (0, 165.2972, 0);
	at[68] = 36.5333;
	points[69] = (-10368.2676, 7211.1025, 1133.9449);
	angles[69] = (0, 172.5560, 0);
	at[69] = 37.0667;
	points[70] = (-10367.5596, 7165.1572, 1133.9489);
	angles[70] = (0, 183.5847, 0);
	at[70] = 37.3333;
	points[71] = (-10361.4961, 7118.3066, 1133.9449);
	angles[71] = (0, 188, 0);
	at[71] = 37.6000;
	points[72] = (-10335.7871, 6978.1890, 1133.9489);
	angles[72] = (0, 191.5047, 0);
	at[72] = 38.4000;
	points[73] = (-10303.7803, 6839.2129, 1133.9489);
	angles[73] = (0, 194.5787, 0);
	at[73] = 39.2000;
	points[74] = (-10289.7246, 6795.7876, 1133.9449);
	angles[74] = (0, 198.9955, 0);
	at[74] = 39.4667;
	points[75] = (-10255.0391, 6707.3623, 1133.9449);
	angles[75] = (0, 202.2405, 0);
	at[75] = 40;
	points[76] = (-10159.5273, 6491.8506, 1133.9489);
	angles[76] = (0, 205.7429, 0);
	at[76] = 41.3333;
	points[77] = (-10010.1182, 6196.3779, 1133.9489);
	angles[77] = (0, 208.0773, 0);
	at[77] = 43.2000;
	points[78] = (-9894.7637, 5990.0396, 1133.9449);
	angles[78] = (0, 208.7981, 0);
	at[78] = 44.5333;
	points[79] = (-9833.2676, 5862.5591, 1133.9489);
	angles[79] = (0, 204.8838, 0);
	at[79] = 45.3333;
	points[80] = (-9771.4170, 5734.2520, 1133.9449);
	angles[80] = (0, 207.0026, 0);
	at[80] = 46.1333;
	points[81] = (-9748.7402, 5693.3462, 1133.9449);
	angles[81] = (0, 210.0695, 0);
	at[81] = 46.4000;
	points[82] = (-9719.6855, 5656.8896, 1133.9449);
	angles[82] = (0, 222.6676, 0);
	at[82] = 46.6667;
	points[83] = (-9683.9375, 5625.5908, 1133.9489);
	angles[83] = (0, 229.8055, 0);
	at[83] = 46.9333;
	points[84] = (-9646.7715, 5596.3779, 1133.9449);
	angles[84] = (0, 232.2624, 0);
	at[84] = 47.2000;
	points[85] = (-9533.2285, 5510.6299, 1133.9449);
	angles[85] = (0, 231.6552, 0);
	at[85] = 48;
	points[86] = (-9464.8818, 5446.2993, 1133.9449);
	angles[86] = (0, 225.5899, 0);
	at[86] = 48.5333;
	points[87] = (-9331.7324, 5311.4961, 1133.9449);
	angles[87] = (0, 223.8959, 0);
	at[87] = 49.6000;
	points[88] = (-9235.2754, 5208.3071, 1133.9449);
	angles[88] = (0, 222.6785, 0);
	at[88] = 50.4000;
	points[89] = (-9141.2988, 5101.3389, 1133.9449);
	angles[89] = (0, 219.5655, 0);
	at[89] = 51.2000;
	points[90] = (-9114.2920, 5064.2124, 1133.9449);
	angles[90] = (0, 213.5866, 0);
	at[90] = 51.4667;
	points[91] = (-9092.0078, 5022.1260, 1133.9449);
	angles[91] = (0, 206.9297, 0);
	at[91] = 51.7333;
	points[92] = (-9034.0156, 4892.1655, 1133.9449);
	angles[92] = (0, 202.9516, 0);
	at[92] = 52.5333;
	points[93] = (-8948.7793, 4672.2441, 1133.9449);
	angles[93] = (0, 199.7218, 0);
	at[93] = 53.8667;
	points[94] = (-8906.4180, 4536.5352, 1133.9489);
	angles[94] = (0, 194.2007, 0);
	at[94] = 54.6667;
	points[95] = (-8899.4883, 4490.6694, 1133.9449);
	angles[95] = (0, 186.6476, 0);
	at[95] = 54.9333;
	points[96] = (-8896.2207, 4443.7798, 1133.9449);
	angles[96] = (0, 183.5637, 0);
	at[96] = 55.2000;
	points[97] = (-8890.3936, 4254.0161, 1133.9449);
	angles[97] = (0, 180.9890, 0);
	at[97] = 56.2667;
	points[98] = (-8886.4570, 3875.9763, 1133.9449);
	angles[98] = (0, 178.4818, 0);
	at[98] = 58.4000;
	points[99] = (-8894.8428, 3781.9290, 1133.9449);
	angles[99] = (0, 171.3792, 0);
	at[99] = 58.9333;
	points[100] = (-8908.8975, 3738.6772, 1133.9489);
	angles[100] = (0, 156.9627, 0);
	at[100] = 59.2000;
	points[101] = (-8934.0557, 3697.5000, 1133.9489);
	angles[101] = (0, 147.2371, 0);
	at[101] = 59.4667;
	points[102] = (-8990.6299, 3621.6064, 1133.9489);
	angles[102] = (0, 141.7861, 0);
	at[102] = 60;
	points[103] = (-9051.4570, 3549.1655, 1133.9449);
	angles[103] = (0, 138.9747, 0);
	at[103] = 60.5333;
	points[104] = (-9115.9844, 3479.6497, 1133.9449);
	angles[104] = (0, 135.8244, 0);
	at[104] = 61.0667;
	points[105] = (-9149.8027, 3447.2046, 1133.9449);
	angles[105] = (0, 132.8631, 0);
	at[105] = 61.3333;
	points[106] = (-9186.4570, 3419.3149, 1133.9449);
	angles[106] = (0, 124.2586, 0);
	at[106] = 61.6000;
	points[107] = (-9271.2988, 3375.7561, 1133.9449);
	angles[107] = (0, 115.0304, 0);
	at[107] = 62.1333;
	points[108] = (-9402.5986, 3322.0708, 1133.9449);
	angles[108] = (0, 110.4560, 0);
	at[108] = 62.9333;
	points[109] = (-9492.7559, 3292.5078, 1133.9449);
	angles[109] = (0, 106.3294, 0);
	at[109] = 63.4667;
	points[110] = (-9539.5273, 3282, 1133.9449);
	angles[110] = (0, 100.6327, 0);
	at[110] = 63.7333;
	points[111] = (-9551.1816, 3280.8386, 1133.9449);
	angles[111] = (0, 96.8134, 0);
	at[111] = 63.8167;
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
	points[0] = (-10179.5674, 10452.7168, 1133.9449);
	angles[0] = (0, -157.4083, 0);
	at[0] = 0;
	points[1] = (-10144.2520, 10403.1494, 1133.9449);
	angles[1] = (0, -140.7418, 0);
	at[1] = 0.3500;
	points[2] = (-10101.0244, 10358.1104, 1133.9449);
	angles[2] = (0, -134.7327, 0);
	at[2] = 0.7000;
	points[3] = (-10055.1572, 10316.2988, 1133.9449);
	angles[3] = (0, -131.4746, 0);
	at[3] = 1.0500;
	points[4] = (-9957.7168, 10238.8574, 1133.9449);
	angles[4] = (0, -126.4565, 0);
	at[4] = 1.7500;
	points[5] = (-9906.7324, 10203.9365, 1133.9449);
	angles[5] = (0, -123.2823, 0);
	at[5] = 2.1000;
	points[6] = (-9851.9688, 10172.9932, 1133.9449);
	angles[6] = (0, -116.9590, 0);
	at[6] = 2.4500;
	points[7] = (-9795.3545, 10153.8584, 1133.9449);
	angles[7] = (0, -106.0732, 0);
	at[7] = 2.8000;
	points[8] = (-9734.8428, 10139.5283, 1133.9449);
	angles[8] = (0, -102.5358, 0);
	at[8] = 3.1500;
	points[9] = (-9612.1660, 10116.6143, 1133.9449);
	angles[9] = (0, -99.5189, 0);
	at[9] = 3.8500;
	points[10] = (-9488.8193, 10098.9375, 1133.9449);
	angles[10] = (0, -97.1927, 0);
	at[10] = 4.5500;
	points[11] = (-9364.6855, 10087.5596, 1133.9449);
	angles[11] = (0, -93.4768, 0);
	at[11] = 5.2500;
	points[12] = (-9302.2051, 10087.1650, 1133.9489);
	angles[12] = (0, -88.1676, 0);
	at[12] = 5.6000;
	points[13] = (-9243.8584, 10098.8193, 1133.9449);
	angles[13] = (0, -75.0927, 0);
	at[13] = 5.9500;
	points[14] = (-9127.4014, 10142.4414, 1133.9489);
	angles[14] = (0, -67.3816, 0);
	at[14] = 6.6500;
	points[15] = (-9013.5830, 10193.3076, 1133.9449);
	angles[15] = (0, -65.2127, 0);
	at[15] = 7.3500;
	points[16] = (-8789.9609, 10297.0078, 1133.9489);
	angles[16] = (0, -67.0430, 0);
	at[16] = 8.7500;
	points[17] = (-8445.1582, 10441.9297, 1133.9449);
	angles[17] = (0, -66.5700, 0);
	at[17] = 10.8500;
	points[18] = (-8333.3857, 10492.9922, 1133.9449);
	angles[18] = (0, -63.8700, 0);
	at[18] = 11.5500;
	points[19] = (-8171.0630, 10584.0947, 1133.9449);
	angles[19] = (0, -59.8534, 0);
	at[19] = 12.6000;
	points[20] = (-7955.9844, 10709.7246, 1133.9489);
	angles[20] = (0, -59.9206, 0);
	at[20] = 14;
	points[21] = (-7849.4883, 10768.9766, 1133.9449);
	angles[21] = (0, -62.1308, 0);
	at[21] = 14.7000;
	points[22] = (-7571.6929, 10910.0791, 1133.9449);
	angles[22] = (0, -63.8411, 0);
	at[22] = 16.4500;
	points[23] = (-7402.8345, 10988.6611, 1133.9449);
	angles[23] = (0, -66.6349, 0);
	at[23] = 17.5000;
	points[24] = (-7347.0864, 11010.2363, 1133.9489);
	angles[24] = (0, -70.0843, 0);
	at[24] = 17.8500;
	points[25] = (-7168.6221, 11067.0078, 1133.9489);
	angles[25] = (0, -73.2126, 0);
	at[25] = 18.9000;
	points[26] = (-6868.6221, 11150.7881, 1133.9449);
	angles[26] = (0, -75.6508, 0);
	at[26] = 20.6500;
	points[27] = (-6748.4644, 11177.8740, 1133.9449);
	angles[27] = (0, -79.3935, 0);
	at[27] = 21.3500;
	points[28] = (-6626.0630, 11191.1416, 1133.9489);
	angles[28] = (0, -85.3807, 0);
	at[28] = 22.0500;
	points[29] = (-6128.4644, 11217.4014, 1133.9489);
	angles[29] = (0, -86.5505, 0);
	at[29] = 24.8500;
	points[30] = (-5883.2285, 11236.5352, 1133.9449);
	angles[30] = (0, -85.3807, 0);
	at[30] = 26.2500;
	points[31] = (-5448.1104, 11270.1572, 1133.9449);
	angles[31] = (0, -86.2080, 0);
	at[31] = 28.7000;
	points[32] = (-5326.4175, 11275.8672, 1133.9489);
	angles[32] = (0, -87.8476, 0);
	at[32] = 29.4000;
	points[33] = (-4891.1812, 11285.5908, 1133.9449);
	angles[33] = (0, -89.6156, 0);
	at[33] = 31.8500;
	points[34] = (-4769.4487, 11285.4326, 1133.9489);
	angles[34] = (0, -89.8630, 0);
	at[34] = 32.5500;
	points[35] = (-4519.9604, 11284.6465, 1133.9449);
	angles[35] = (0, -90.8769, 0);
	at[35] = 33.9500;
	points[36] = (-4333.0312, 11276.7715, 1133.9449);
	angles[36] = (0, -94.2276, 0);
	at[36] = 35;
	points[37] = (-4271.1812, 11270.0400, 1133.9449);
	angles[37] = (0, -97.4340, 0);
	at[37] = 35.3500;
	points[38] = (-4213.0317, 11256.2598, 1133.9449);
	angles[38] = (0, -108.3601, 0);
	at[38] = 35.7000;
	points[39] = (-4158.3071, 11227.2041, 1133.9489);
	angles[39] = (0, -120.5819, 0);
	at[39] = 36.0500;
	points[40] = (-4106.4565, 11192.0479, 1133.9449);
	angles[40] = (0, -125.3603, 0);
	at[40] = 36.4000;
	points[41] = (-4009.6458, 11114.2520, 1133.9449);
	angles[41] = (0, -130.8258, 0);
	at[41] = 37.1000;
	points[42] = (-3920.2007, 11027.6377, 1133.9449);
	angles[42] = (0, -136.7072, 0);
	at[42] = 37.8000;
	points[43] = (-3880.2129, 10979.4102, 1133.9449);
	angles[43] = (0, -142.5003, 0);
	at[43] = 38.1500;
	points[44] = (-3853.7048, 10926.6924, 1133.9449);
	angles[44] = (0, -162.6684, 0);
	at[44] = 38.5000;
	points[45] = (-3851.9607, 10863.7402, 1133.9449);
	angles[45] = (0, -181.8810, 0);
	at[45] = 38.8500;
	points[46] = (-3868.6416, 10740.5908, 1133.9449);
	angles[46] = (0, -190.1817, 0);
	at[46] = 39.5500;
	points[47] = (-3895.9922, 10619.4873, 1133.9449);
	angles[47] = (0, -194.3690, 0);
	at[47] = 40.2500;
	points[48] = (-3933.2166, 10500.4336, 1133.9489);
	angles[48] = (0, -200.0083, 0);
	at[48] = 40.9500;
	points[49] = (-3959.5669, 10443.8574, 1133.9449);
	angles[49] = (0, -208.7950, 0);
	at[49] = 41.3000;
	points[50] = (-4000.8662, 10400.9844, 1133.9449);
	angles[50] = (0, -228.7657, 0);
	at[50] = 41.6500;
	points[51] = (-4051.7717, 10364.3701, 1133.9449);
	angles[51] = (0, -235.8768, 0);
	at[51] = 42;
	points[52] = (-4104.8032, 10331.7715, 1133.9449);
	angles[52] = (0, -239.3751, 0);
	at[52] = 42.3500;
	points[53] = (-4214.7637, 10273.8584, 1133.9449);
	angles[53] = (0, -243.9790, 0);
	at[53] = 43.0500;
	points[54] = (-4329.3701, 10225.0400, 1133.9449);
	angles[54] = (0, -249.4181, 0);
	at[54] = 43.7500;
	points[55] = (-4386.7720, 10207.8740, 1133.9489);
	angles[55] = (0, -256.1705, 0);
	at[55] = 44.1000;
	points[56] = (-4447.7559, 10199.2520, 1133.9489);
	angles[56] = (0, -263.4887, 0);
	at[56] = 44.4500;
	points[57] = (-4634.8818, 10187.8740, 1133.9449);
	angles[57] = (0, -267.7610, 0);
	at[57] = 45.5000;
	points[58] = (-5008.7007, 10182.1260, 1133.9449);
	angles[58] = (0, -270.1396, 0);
	at[58] = 47.6000;
	points[59] = (-5067.5591, 10182.9131, 1133.9449);
	angles[59] = (0, -271.3531, 0);
	at[59] = 47.9500;
	points[60] = (-5316.5352, 10196.8906, 1133.9449);
	angles[60] = (0, -273.8757, 0);
	at[60] = 49.3500;
	points[61] = (-5627.0474, 10220.1582, 1133.9449);
	angles[61] = (0, -274.5594, 0);
	at[61] = 51.1000;
	points[62] = (-5686.6143, 10225.1182, 1133.9449);
	angles[62] = (0, -274.9966, 0);
	at[62] = 51.4500;
	points[63] = (-6182.5195, 10275.2363, 1133.9449);
	angles[63] = (0, -275.3123, 0);
	at[63] = 54.2500;
	points[64] = (-6366.4565, 10285.3936, 1133.9449);
	angles[64] = (0, -272.5045, 0);
	at[64] = 55.3000;
	points[65] = (-6614.6455, 10298.7412, 1133.9449);
	angles[65] = (0, -274.1213, 0);
	at[65] = 56.7000;
	points[66] = (-6739.2910, 10312.3232, 1133.9489);
	angles[66] = (0, -278.7162, 0);
	at[66] = 57.4000;
	points[67] = (-6797.7168, 10327.2832, 1133.9449);
	angles[67] = (0, -286.8391, 0);
	at[67] = 57.7500;
	points[68] = (-6913.5039, 10371.1416, 1133.9449);
	angles[68] = (0, -292.1533, 0);
	at[68] = 58.4500;
	points[69] = (-7027.8350, 10420.3945, 1133.9449);
	angles[69] = (0, -293.9585, 0);
	at[69] = 59.1500;
	points[70] = (-7252.4014, 10528.1885, 1133.9449);
	angles[70] = (0, -297.8236, 0);
	at[70] = 60.5500;
	points[71] = (-7303.5039, 10559.4883, 1133.9449);
	angles[71] = (0, -303.0624, 0);
	at[71] = 60.9000;
	points[72] = (-7405.0396, 10632.1660, 1133.9449);
	angles[72] = (0, -306.4944, 0);
	at[72] = 61.6000;
	points[73] = (-7554.4097, 10744.0166, 1133.9489);
	angles[73] = (0, -306.5063, 0);
	at[73] = 62.6500;
	points[74] = (-7655.0396, 10812.7168, 1133.9489);
	angles[74] = (0, -301.6835, 0);
	at[74] = 63.3500;
	points[75] = (-7871.1421, 10937.4414, 1133.9449);
	angles[75] = (0, -299.3242, 0);
	at[75] = 64.7500;
	points[76] = (-8090, 11055.4727, 1133.9449);
	angles[76] = (0, -296.8974, 0);
	at[76] = 66.1500;
	points[77] = (-8144.6851, 11081.0244, 1133.9489);
	angles[77] = (0, -294.0948, 0);
	at[77] = 66.5000;
	points[78] = (-8317.7168, 11151.7324, 1133.9449);
	angles[78] = (0, -291.2491, 0);
	at[78] = 67.5500;
	points[79] = (-8434.4883, 11195, 1133.9449);
	angles[79] = (0, -289.6155, 0);
	at[79] = 68.2500;
	points[80] = (-8553.1494, 11233.1895, 1133.9489);
	angles[80] = (0, -286.0762, 0);
	at[80] = 68.9500;
	points[81] = (-8611.7324, 11246.1426, 1133.9489);
	angles[81] = (0, -279.5929, 0);
	at[81] = 69.3000;
	points[82] = (-8673.7012, 11250.1182, 1133.9449);
	angles[82] = (0, -272.0685, 0);
	at[82] = 69.6500;
	points[83] = (-8736.3389, 11250.1973, 1133.9449);
	angles[83] = (0, -269.4611, 0);
	at[83] = 70;
	points[84] = (-9109.4092, 11232.4805, 1133.9489);
	angles[84] = (0, -267.2445, 0);
	at[84] = 72.1000;
	points[85] = (-9542.1660, 11225.3145, 1133.9449);
	angles[85] = (0, -268.3408, 0);
	at[85] = 74.5500;
	points[86] = (-9729.2910, 11214.3701, 1133.9489);
	angles[86] = (0, -264.3653, 0);
	at[86] = 75.6000;
	points[87] = (-9788.9766, 11204.7246, 1133.9449);
	angles[87] = (0, -257.9011, 0);
	at[87] = 75.9500;
	points[88] = (-9846.7715, 11185.3945, 1133.9489);
	angles[88] = (0, -249.7206, 0);
	at[88] = 76.3000;
	points[89] = (-9960.7480, 11134.6855, 1133.9449);
	angles[89] = (0, -244.1534, 0);
	at[89] = 77;
	points[90] = (-10070.6299, 11075.8662, 1133.9449);
	angles[90] = (0, -240.2112, 0);
	at[90] = 77.7000;
	points[91] = (-10123.7803, 11043.3076, 1133.9449);
	angles[91] = (0, -237.6563, 0);
	at[91] = 78.0500;
	points[92] = (-10174.6455, 11007.8350, 1133.9449);
	angles[92] = (0, -233.6395, 0);
	at[92] = 78.4000;
	points[93] = (-10221.0625, 10965.9053, 1133.9449);
	angles[93] = (0, -223.9163, 0);
	at[93] = 78.7500;
	points[94] = (-10242.9922, 10911.1025, 1133.9449);
	angles[94] = (0, -192.0161, 0);
	at[94] = 79.1000;
	points[95] = (-10246.2998, 10849.2910, 1133.9449);
	angles[95] = (0, -180.8199, 0);
	at[95] = 79.4500;
	points[96] = (-10243.7402, 10786.9297, 1133.9489);
	angles[96] = (0, -176.5704, 0);
	at[96] = 79.8000;
	points[97] = (-10237.9531, 10724.8037, 1133.9449);
	angles[97] = (0, -173.9429, 0);
	at[97] = 80.1500;
	points[98] = (-10219.4893, 10601.4570, 1133.9449);
	angles[98] = (0, -169.8495, 0);
	at[98] = 80.8500;
	points[99] = (-10206.7725, 10540.4727, 1133.9449);
	angles[99] = (0, -167.4088, 0);
	at[99] = 81.2000;
	points[100] = (-10190.6689, 10481.2598, 1133.9449);
	angles[100] = (0, -163.0866, 0);
	at[100] = 81.5500;
	points[101] = (-10179.5674, 10452.7168, 1133.9449);
	angles[101] = (0, -157.4083, 0);
	at[101] = 81.7167;
	mover = getEnt("iz_obj_5", "targetname");
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
