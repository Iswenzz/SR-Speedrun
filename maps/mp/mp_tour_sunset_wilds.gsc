main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_tour_sunset_wilds", 0);

	setExpFog(4429.1338, 64099.4023, 0.6784, 0.6431, 0.0627, 0);

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
	ambientPlay("iz_0_trsw", 2);
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
	level.iz_route[level.iz_route.size] = (-7204, 256, 1063);
	level.iz_route[level.iz_route.size] = (-7227, -770, 1063);
	level.iz_route[level.iz_route.size] = (-7240, -2210, 1063);
	level.iz_route[level.iz_route.size] = (-7239, -3775, 1063);
	level.iz_route[level.iz_route.size] = (-7018, -4760, 1074);
	level.iz_route[level.iz_route.size] = (-6549, -5379, 1102);
	level.iz_route[level.iz_route.size] = (-5868, -5699, 1114);
	level.iz_route[level.iz_route.size] = (-5122, -5706, 1103);
	level.iz_route[level.iz_route.size] = (-4509, -5364, 1082);
	level.iz_route[level.iz_route.size] = (-4016, -4975, 1070);
	level.iz_route[level.iz_route.size] = (-3589, -4561, 1065);
	level.iz_route[level.iz_route.size] = (-3067, -4078, 1064);
	level.iz_route[level.iz_route.size] = (-2514, -3745, 1074);
	level.iz_route[level.iz_route.size] = (-2065, -3663, 1094);
	level.iz_route[level.iz_route.size] = (-1470, -3785, 1117);
	level.iz_route[level.iz_route.size] = (-836, -4116, 1108);
	level.iz_route[level.iz_route.size] = (327, -4785, 1083);
	level.iz_route[level.iz_route.size] = (1434, -5496, 1065);
	level.iz_route[level.iz_route.size] = (2161, -6079, 1066);
	level.iz_route[level.iz_route.size] = (3076, -6671, 1071);
	level.iz_route[level.iz_route.size] = (4017, -6841, 1085);
	level.iz_route[level.iz_route.size] = (4838, -6637, 1100);
	level.iz_route[level.iz_route.size] = (5437, -6193, 1104);
	level.iz_route[level.iz_route.size] = (5603, -5501, 1091);
	level.iz_route[level.iz_route.size] = (5597, -4909, 1083);
	level.iz_route[level.iz_route.size] = (5149, -4353, 1077);
	level.iz_route[level.iz_route.size] = (4584, -3954, 1074);
	level.iz_route[level.iz_route.size] = (3927, -3571, 1067);
	level.iz_route[level.iz_route.size] = (2902, -3145, 1060);
	level.iz_route[level.iz_route.size] = (2036, -2752, 1055);
	level.iz_route[level.iz_route.size] = (879, -2209, 1055);
	level.iz_route[level.iz_route.size] = (-190, -1574, 1053);
	level.iz_route[level.iz_route.size] = (-1145, -1149, 1061);
	level.iz_route[level.iz_route.size] = (-2870, 295, 1065);
	level.iz_route[level.iz_route.size] = (-3005, 562, 1065);
	level.iz_route[level.iz_route.size] = (-2914, 844, 1066);
	level.iz_route[level.iz_route.size] = (-2621, 1041, 1065);
	level.iz_route[level.iz_route.size] = (-2040, 1155, 1068);
	level.iz_route[level.iz_route.size] = (-890, 1233, 1073);
	level.iz_route[level.iz_route.size] = (-158, 1263, 1090);
	level.iz_route[level.iz_route.size] = (420, 1488, 1099);
	level.iz_route[level.iz_route.size] = (855, 1890, 1090);
	level.iz_route[level.iz_route.size] = (1321, 2458, 1076);
	level.iz_route[level.iz_route.size] = (1969, 3246, 1064);
	level.iz_route[level.iz_route.size] = (2479, 3697, 1062);
	level.iz_route[level.iz_route.size] = (2884, 3869, 1062);
	level.iz_route[level.iz_route.size] = (3612, 4007, 1061);
	level.iz_route[level.iz_route.size] = (4844, 4183, 1065);
	level.iz_route[level.iz_route.size] = (5686, 4337, 1076);
	level.iz_route[level.iz_route.size] = (6251, 4703, 1099);
	level.iz_route[level.iz_route.size] = (6541, 5194, 1121);
	level.iz_route[level.iz_route.size] = (6613, 5754, 1137);
	level.iz_route[level.iz_route.size] = (6382, 6358, 1132);
	level.iz_route[level.iz_route.size] = (5923, 6767, 1112);
	level.iz_route[level.iz_route.size] = (5248, 6938, 1082);
	level.iz_route[level.iz_route.size] = (4490, 6968, 1066);
	level.iz_route[level.iz_route.size] = (3731, 6871, 1065);
	level.iz_route[level.iz_route.size] = (2334, 6620, 1063);
	level.iz_route[level.iz_route.size] = (255, 6256, 1196);
	level.iz_route[level.iz_route.size] = (-234, 6143, 1221);
	level.iz_route[level.iz_route.size] = (-2391, 5686, 1262);
	level.iz_route[level.iz_route.size] = (-3135, 5535, 1279);
	level.iz_route[level.iz_route.size] = (-3761, 5442, 1286);
	level.iz_route[level.iz_route.size] = (-4669, 5382, 1309);
	level.iz_route[level.iz_route.size] = (-5434, 5347, 1392);
	level.iz_route[level.iz_route.size] = (-6073, 5239, 1473);
	level.iz_route[level.iz_route.size] = (-6587, 4903, 1483);
	level.iz_route[level.iz_route.size] = (-7004, 4369, 1414);
	level.iz_route[level.iz_route.size] = (-7199, 3673, 1261);
	level.iz_route[level.iz_route.size] = (-7250, 2771, 1107);
	level.iz_route[level.iz_route.size] = (-7214, 1571, 1065);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-9044.7246, -12022.9531, 1564.9607);
	angles[0] = (0, -31.3035, 0);
	at[0] = 0;
	points[1] = (-9011.6934, -11969.6455, 1564.9607);
	angles[1] = (0, -32.1797, 0);
	at[1] = 0.0667;
	points[2] = (-8622.5986, -11367.5586, 1564.9607);
	angles[2] = (0, -31.9797, 0);
	at[2] = 0.8000;
	points[3] = (-8520.9844, -11199.4092, 1564.9607);
	angles[3] = (0, -30.0615, 0);
	at[3] = 1;
	points[4] = (-8458.0312, -11085.3145, 1564.9607);
	angles[4] = (0, -27.3577, 0);
	at[4] = 1.1333;
	points[5] = (-8429.2520, -11026.7324, 1564.9607);
	angles[5] = (0, -24.7915, 0);
	at[5] = 1.2000;
	points[6] = (-8405.3145, -10969.7246, 1564.9607);
	angles[6] = (0, -20.3488, 0);
	at[6] = 1.2667;
	points[7] = (-8384.8818, -10909.4893, 1564.9607);
	angles[7] = (0, -17.4546, 0);
	at[7] = 1.3333;
	points[8] = (-8348.7402, -10782.6377, 1564.9607);
	angles[8] = (0, -14.7328, 0);
	at[8] = 1.4667;
	points[9] = (-8303.0703, -10594.4092, 1564.9607);
	angles[9] = (0, -12.7318, 0);
	at[9] = 1.6667;
	points[10] = (-8237.5986, -10274.9609, 1564.9607);
	angles[10] = (0, -10.5143, 0);
	at[10] = 2;
	points[11] = (-8193.9766, -10017.8740, 1564.9607);
	angles[11] = (0, -8.6681, 0);
	at[11] = 2.2667;
	points[12] = (-8167.6377, -9823.8975, 1564.9607);
	angles[12] = (0, -6.6207, 0);
	at[12] = 2.4667;
	points[13] = (-8155.0396, -9694.1338, 1564.9607);
	angles[13] = (0, -4.2394, 0);
	at[13] = 2.6000;
	points[14] = (-8151.5352, -9636.4570, 1564.9607);
	angles[14] = (0, -2.6817, 0);
	at[14] = 2.6667;
	points[15] = (-8149.1733, -9572.9922, 1564.9607);
	angles[15] = (0, -1.7417, 0);
	at[15] = 2.7333;
	points[16] = (-8147.4414, -9504.0156, 1564.9607);
	angles[16] = (0, -1.1721, 0);
	at[16] = 2.8000;
	points[17] = (-8146.3779, -9442.5195, 1564.9607);
	angles[17] = (0, -0.8292, 0);
	at[17] = 2.8667;
	points[18] = (-8145.0786, -9308.5039, 1564.9607);
	angles[18] = (0, -0.3232, 0);
	at[18] = 3;
	points[19] = (-8144.8037, -9245.9053, 1564.9607);
	angles[19] = (0, -0.1472, 0);
	at[19] = 3.0667;
	points[20] = (-8144.8428, -9112.5986, 1564.9607);
	angles[20] = (0, 0.1612, 0);
	at[20] = 3.2000;
	points[21] = (-8146.0234, -8919.0947, 1564.9607);
	angles[21] = (0, 0.5227, 0);
	at[21] = 3.4000;
	points[22] = (-8153.1895, -8461.8506, 1564.9607);
	angles[22] = (0, 1.2744, 0);
	at[22] = 3.8667;
	points[23] = (-8164.4097, -8071.4966, 1564.9607);
	angles[23] = (0, 2.0712, 0);
	at[23] = 4.2667;
	points[24] = (-8172.5200, -7874.4878, 1564.9607);
	angles[24] = (0, 2.6764, 0);
	at[24] = 4.4667;
	points[25] = (-8175.5908, -7811.8110, 1564.9607);
	angles[25] = (0, 2.9305, 0);
	at[25] = 4.5333;
	points[26] = (-8183.2285, -7678.0708, 1564.9607);
	angles[26] = (0, 3.6601, 0);
	at[26] = 4.6667;
	points[27] = (-8187.4409, -7615.7480, 1564.9607);
	angles[27] = (0, 4.1477, 0);
	at[27] = 4.7333;
	points[28] = (-8198.9375, -7482.7168, 1564.9607);
	angles[28] = (0, 5.9721, 0);
	at[28] = 4.8667;
	points[29] = (-8205.6299, -7425.8267, 1564.9607);
	angles[29] = (0, 7.5939, 0);
	at[29] = 4.9333;
	points[30] = (-8214.5664, -7365.2759, 1564.9607);
	angles[30] = (0, 9.0704, 0);
	at[30] = 5;
	points[31] = (-8226.1025, -7297.2446, 1564.9607);
	angles[31] = (0, 10.1561, 0);
	at[31] = 5.0667;
	points[32] = (-8237.5195, -7235.8267, 1564.9607);
	angles[32] = (0, 10.8616, 0);
	at[32] = 5.1333;
	points[33] = (-8263.8975, -7105.3940, 1564.9607);
	angles[33] = (0, 11.9066, 0);
	at[33] = 5.2667;
	points[34] = (-8277.0078, -7044.0947, 1564.9607);
	angles[34] = (0, 12.2724, 0);
	at[34] = 5.3333;
	points[35] = (-8350.3545, -6726.0239, 1564.9607);
	angles[35] = (0, 13.5766, 0);
	at[35] = 5.6667;
	points[36] = (-8445.7871, -6346.6143, 1564.9607);
	angles[36] = (0, 14.6104, 0);
	at[36] = 6.0667;
	points[37] = (-8547.5195, -5969.2124, 1564.9607);
	angles[37] = (0, 15.5910, 0);
	at[37] = 6.4667;
	points[38] = (-8619.8428, -5717.2832, 1564.9607);
	angles[38] = (0, 16.5230, 0);
	at[38] = 6.7333;
	points[39] = (-8637.9531, -5656.8896, 1564.9607);
	angles[39] = (0, 16.8524, 0);
	at[39] = 6.8000;
	points[40] = (-8677.2832, -5530.7085, 1564.9607);
	angles[40] = (0, 17.9169, 0);
	at[40] = 6.9333;
	points[41] = (-8695.3545, -5476.1416, 1564.9607);
	angles[41] = (0, 18.7125, 0);
	at[41] = 7;
	points[42] = (-8715.5117, -5417.7954, 1564.9607);
	angles[42] = (0, 19.3462, 0);
	at[42] = 7.0667;
	points[43] = (-8739.3311, -5350.8267, 1564.9607);
	angles[43] = (0, 19.8094, 0);
	at[43] = 7.1333;
	points[44] = (-8760.1182, -5293.6616, 1564.9607);
	angles[44] = (0, 20.0961, 0);
	at[44] = 7.2000;
	points[45] = (-8782.4805, -5232.8740, 1564.9607);
	angles[45] = (0, 20.3388, 0);
	at[45] = 7.2667;
	points[46] = (-8806.5752, -5168.3071, 1564.9607);
	angles[46] = (0, 20.5521, 0);
	at[46] = 7.3333;
	points[47] = (-8851.4961, -5049.4883, 1564.9607);
	angles[47] = (0, 20.8728, 0);
	at[47] = 7.4667;
	points[48] = (-8899.1738, -4925.3940, 1564.9607);
	angles[48] = (0, 21.1517, 0);
	at[48] = 7.6000;
	points[49] = (-9066.4180, -4502.2837, 1564.9607);
	angles[49] = (0, 21.9755, 0);
	at[49] = 8.0667;
	points[50] = (-9241.0234, -4079.5278, 1564.9607);
	angles[50] = (0, 22.9731, 0);
	at[50] = 8.5333;
	points[51] = (-9291.2988, -3962.0081, 1564.9607);
	angles[51] = (0, 23.3671, 0);
	at[51] = 8.6667;
	points[52] = (-9344.7637, -3839.7441, 1564.9607);
	angles[52] = (0, 23.8956, 0);
	at[52] = 8.8000;
	points[53] = (-9370.5117, -3782.0708, 1564.9607);
	angles[53] = (0, 24.2111, 0);
	at[53] = 8.8667;
	points[54] = (-9426.0244, -3660.9448, 1564.9607);
	angles[54] = (0, 25.1184, 0);
	at[54] = 9;
	points[55] = (-9452.9922, -3604.2363, 1564.9607);
	angles[55] = (0, 25.7410, 0);
	at[55] = 9.0667;
	points[56] = (-9512.8350, -3485.4802, 1564.9607);
	angles[56] = (0, 28.1211, 0);
	at[56] = 9.2000;
	points[57] = (-9540.6689, -3435.5513, 1564.9607);
	angles[57] = (0, 30.2974, 0);
	at[57] = 9.2667;
	points[58] = (-9572.9922, -3382.4412, 1564.9607);
	angles[58] = (0, 32.2438, 0);
	at[58] = 9.3333;
	points[59] = (-9610.5908, -3324.5591, 1564.9607);
	angles[59] = (0, 33.6551, 0);
	at[59] = 9.4000;
	points[60] = (-9645.3545, -3273.2954, 1564.9607);
	angles[60] = (0, 34.5703, 0);
	at[60] = 9.4667;
	points[61] = (-9759.3311, -3114.0474, 1564.9607);
	angles[61] = (0, 36.4404, 0);
	at[61] = 9.6667;
	points[62] = (-9917.4805, -2906.0039, 1564.9607);
	angles[62] = (0, 37.9365, 0);
	at[62] = 9.9333;
	points[63] = (-10079.8428, -2701.9097, 1564.9607);
	angles[63] = (0, 39.0354, 0);
	at[63] = 10.2000;
	points[64] = (-10288.3867, -2450.5000, 1564.9607);
	angles[64] = (0, 40.3312, 0);
	at[64] = 10.5333;
	points[65] = (-10458.7012, -2254.2559, 1564.9607);
	angles[65] = (0, 41.6750, 0);
	at[65] = 10.8000;
	points[66] = (-10547.2832, -2156.4646, 1564.9607);
	angles[66] = (0, 42.7538, 0);
	at[66] = 10.9333;
	points[67] = (-10589.1338, -2111.7598, 1564.9607);
	angles[67] = (0, 43.4917, 0);
	at[67] = 11;
	points[68] = (-10637.7168, -2061.5630, 1564.9607);
	angles[68] = (0, 44.7527, 0);
	at[68] = 11.0667;
	points[69] = (-10725.7090, -1978.4448, 1564.9607);
	angles[69] = (0, 48.4212, 0);
	at[69] = 11.2000;
	points[70] = (-10776.6934, -1934.2323, 1564.9607);
	angles[70] = (0, 49.6448, 0);
	at[70] = 11.2667;
	points[71] = (-10825.1182, -1893.6891, 1564.9607);
	angles[71] = (0, 50.4656, 0);
	at[71] = 11.3333;
	points[72] = (-10877.8350, -1850.7560, 1564.9607);
	angles[72] = (0, 51.1553, 0);
	at[72] = 11.4000;
	points[73] = (-10978.5439, -1771.1417, 1564.9607);
	angles[73] = (0, 52.1595, 0);
	at[73] = 11.5333;
	points[74] = (-11292.2842, -1537.4449, 1564.9607);
	angles[74] = (0, 54.3785, 0);
	at[74] = 11.9333;
	points[75] = (-11452.1260, -1425.1378, 1564.9607);
	angles[75] = (0, 55.4585, 0);
	at[75] = 12.1333;
	points[76] = (-11614.0938, -1316.2205, 1564.9607);
	angles[76] = (0, 56.7640, 0);
	at[76] = 12.3333;
	points[77] = (-11778.3076, -1212.1417, 1564.9607);
	angles[77] = (0, 58.6470, 0);
	at[77] = 12.5333;
	points[78] = (-11836.5361, -1177.2874, 1564.9607);
	angles[78] = (0, 59.5980, 0);
	at[78] = 12.6000;
	points[79] = (-11891.5361, -1145.7205, 1564.9607);
	angles[79] = (0, 60.7530, 0);
	at[79] = 12.6667;
	points[80] = (-11950.5518, -1113.7599, 1564.9607);
	angles[80] = (0, 62.4583, 0);
	at[80] = 12.7333;
	points[81] = (-12006.9297, -1085.7638, 1564.9607);
	angles[81] = (0, 64.9484, 0);
	at[81] = 12.8000;
	points[82] = (-12060.4727, -1062.5709, 1564.9607);
	angles[82] = (0, 68.0306, 0);
	at[82] = 12.8667;
	points[83] = (-12124.2520, -1038.3070, 1564.9607);
	angles[83] = (0, 70.1252, 0);
	at[83] = 12.9333;
	points[84] = (-12183.7793, -1017.5512, 1564.9607);
	angles[84] = (0, 71.3435, 0);
	at[84] = 13;
	points[85] = (-12310.0791, -977.0237, 1564.9607);
	angles[85] = (0, 72.9182, 0);
	at[85] = 13.1333;
	points[86] = (-12370.2363, -958.8386, 1564.9607);
	angles[86] = (0, 73.4155, 0);
	at[86] = 13.2000;
	points[87] = (-12497.4414, -921.9331, 1564.9607);
	angles[87] = (0, 74.1839, 0);
	at[87] = 13.3333;
	points[88] = (-12621.3779, -887.4645, 1564.9607);
	angles[88] = (0, 74.7017, 0);
	at[88] = 13.4667;
	points[89] = (-12937.0859, -803.6890, 1564.9607);
	angles[89] = (0, 75.4746, 0);
	at[89] = 13.8000;
	points[90] = (-13567.1650, -643.3898, 1564.9607);
	angles[90] = (0, 75.7132, 0);
	at[90] = 14.4667;
	points[91] = (-13695.5518, -610.4803, 1564.9607);
	angles[91] = (0, 75.5094, 0);
	at[91] = 14.6000;
	points[92] = (-13756.2598, -594.7008, 1564.9607);
	angles[92] = (0, 75.3511, 0);
	at[92] = 14.6667;
	points[93] = (-13884.5273, -560.5787, 1564.9607);
	angles[93] = (0, 74.7779, 0);
	at[93] = 14.8000;
	points[94] = (-13913.9766, -552.5079, 1564.9607);
	angles[94] = (0, 74.5690, 0);
	at[94] = 14.8500;
	points[95] = (-9044.7246, -12022.9531, 1564.9607);
	angles[95] = (0, -31.3035, 0);
	at[95] = 14.8500;
	points[96] = (-9044.7246, -12022.9531, 1564.9607);
	angles[96] = (0, -31.3035, 0);
	at[96] = 14.8667;
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
	points[0] = (-15602.5586, 8256.1816, 2362.2048);
	angles[0] = (0, -124.7200, 0);
	at[0] = 0;
	points[1] = (-15500.2754, 8183.8193, 2354.3977);
	angles[1] = (0, -125.7377, 0);
	at[1] = 0.1333;
	points[2] = (-14559.8828, 7484.5669, 2279.9568);
	angles[2] = (0, -126.1923, 0);
	at[2] = 1.3333;
	points[3] = (-14349.1729, 7332.5591, 2263.6458);
	angles[3] = (0, -125.3580, 0);
	at[3] = 1.6000;
	points[4] = (-14135.5117, 7184.4878, 2247.5906);
	angles[4] = (0, -123.9752, 0);
	at[4] = 1.8667;
	points[5] = (-13916.1025, 7042.7949, 2231.9253);
	angles[5] = (0, -121.4344, 0);
	at[5] = 2.1333;
	points[6] = (-13805.7480, 6978.0317, 2224.5630);
	angles[6] = (0, -119.2231, 0);
	at[6] = 2.2667;
	points[7] = (-13687.5986, 6916.7324, 2217.3188);
	angles[7] = (0, -115.1715, 0);
	at[7] = 2.4000;
	points[8] = (-13579.0947, 6872.5591, 2211.6418);
	angles[8] = (0, -109.2519, 0);
	at[8] = 2.5333;
	points[9] = (-13450.0781, 6832.2832, 2205.9250);
	angles[9] = (0, -105.8654, 0);
	at[9] = 2.6667;
	points[10] = (-13327.7959, 6799.6455, 2200.9685);
	angles[10] = (0, -104.1739, 0);
	at[10] = 2.8000;
	points[11] = (-13198.7793, 6768.5039, 2196.0198);
	angles[11] = (0, -103.0182, 0);
	at[11] = 2.9333;
	points[12] = (-13073.3076, 6740.4722, 2191.3860);
	angles[12] = (0, -102.2144, 0);
	at[12] = 3.0667;
	points[13] = (-12943.4648, 6713.1499, 2186.7244);
	angles[13] = (0, -101.5783, 0);
	at[13] = 3.2000;
	points[14] = (-12560.5908, 6639.4883, 2173.5078);
	angles[14] = (0, -100.3099, 0);
	at[14] = 3.6000;
	points[15] = (-12047.7559, 6551.4565, 2156.5000);
	angles[15] = (0, -99.2426, 0);
	at[15] = 4.1333;
	points[16] = (-11658.7012, 6490.3940, 2143.8228);
	angles[16] = (0, -98.5970, 0);
	at[16] = 4.5333;
	points[17] = (-11532.3223, 6471.5356, 2139.7048);
	angles[17] = (0, -98.3823, 0);
	at[17] = 4.6667;
	points[18] = (-11399.7246, 6452.2837, 2135.3503);
	angles[18] = (0, -98.1317, 0);
	at[18] = 4.8000;
	points[19] = (-11276.8115, 6435.0396, 2131.2520);
	angles[19] = (0, -97.8388, 0);
	at[19] = 4.9333;
	points[20] = (-11144.4492, 6417.3628, 2126.6812);
	angles[20] = (0, -97.2917, 0);
	at[20] = 5.0667;
	points[21] = (-11021.1025, 6404.6455, 2121.9685);
	angles[21] = (0, -94.3589, 0);
	at[21] = 5.2000;
	points[22] = (-10891.5352, 6397.3623, 2116.5867);
	angles[22] = (0, -92.2514, 0);
	at[22] = 5.3333;
	points[23] = (-10631.2998, 6392.7954, 2105.2244);
	angles[23] = (0, -90.0697, 0);
	at[23] = 5.6000;
	points[24] = (-9851.0625, 6398.7007, 2073.3582);
	angles[24] = (0, -90.6870, 0);
	at[24] = 6.4000;
	points[25] = (-9721.6934, 6395.5903, 2069.5039);
	angles[25] = (0, -92.2081, 0);
	at[25] = 6.5333;
	points[26] = (-9594.0156, 6387.8350, 2066.8228);
	angles[26] = (0, -95.0639, 0);
	at[26] = 6.6667;
	points[27] = (-9464.2520, 6373.8979, 2065.9094);
	angles[27] = (0, -96.8022, 0);
	at[27] = 6.8000;
	points[28] = (-9339.4092, 6358.2676, 2065.8896);
	angles[28] = (0, -97.4238, 0);
	at[28] = 6.9333;
	points[29] = (-8045.9453, 6176.6143, 2072.1458);
	angles[29] = (0, -97.7827, 0);
	at[29] = 8.2667;
	points[30] = (-7528.3467, 6110.8662, 2070.9685);
	angles[30] = (0, -96.3639, 0);
	at[30] = 8.8000;
	points[31] = (-7397.0869, 6097.2441, 2069.2322);
	angles[31] = (0, -95.3893, 0);
	at[31] = 8.9333;
	points[32] = (-7277.4409, 6087.5986, 2066.3623);
	angles[32] = (0, -93.6572, 0);
	at[32] = 9.0667;
	points[33] = (-7020.7090, 6075.9448, 2056.0513);
	angles[33] = (0, -91.9604, 0);
	at[33] = 9.3333;
	points[34] = (-6887.2832, 6071.8110, 2049.8149);
	angles[34] = (0, -91.6200, 0);
	at[34] = 9.4667;
	points[35] = (-6368.1104, 6060.4727, 2023.2914);
	angles[35] = (0, -90.9868, 0);
	at[35] = 10;
	points[36] = (-5324.3701, 6047.2046, 1964.9448);
	angles[36] = (0, -90.5569, 0);
	at[36] = 11.0667;
	points[37] = (-5196.6143, 6045.9839, 1957.5000);
	angles[37] = (0, -90.5351, 0);
	at[37] = 11.2000;
	points[38] = (-5062.5591, 6044.7642, 1949.6182);
	angles[38] = (0, -90.5200, 0);
	at[38] = 11.3333;
	points[39] = (-4938.7007, 6043.6616, 1942.2638);
	angles[39] = (0, -90.5165, 0);
	at[39] = 11.4667;
	points[40] = (-4801.2202, 6042.4019, 1933.9961);
	angles[40] = (0, -90.5341, 0);
	at[40] = 11.6000;
	points[41] = (-4672.1260, 6041.1421, 1926.0906);
	angles[41] = (0, -90.6040, 0);
	at[41] = 11.7333;
	points[42] = (-4549.6851, 6039.6064, 1918.3031);
	angles[42] = (0, -90.8299, 0);
	at[42] = 11.8667;
	points[43] = (-4290.2754, 6036.8115, 1898.8583);
	angles[43] = (0, -90.4262, 0);
	at[43] = 12.1333;
	points[44] = (-4031.4175, 6035.5508, 1874.7677);
	angles[44] = (0, -90.1611, 0);
	at[44] = 12.4000;
	points[45] = (-3772.8896, 6035.0391, 1844.4133);
	angles[45] = (0, -90.1325, 0);
	at[45] = 12.6667;
	points[46] = (-3648.1418, 6034.4487, 1825.1693);
	angles[46] = (0, -90.5455, 0);
	at[46] = 12.8000;
	points[47] = (-3519.0315, 6032.8345, 1798.1300);
	angles[47] = (0, -90.8019, 0);
	at[47] = 12.9333;
	points[48] = (-3011.6692, 6027.0078, 1680.2560);
	angles[48] = (0, -90.2656, 0);
	at[48] = 13.4667;
	points[49] = (-2884.9607, 6026.9292, 1652.4370);
	angles[49] = (0, -89.7426, 0);
	at[49] = 13.6000;
	points[50] = (-2755.3860, 6028.7793, 1627.6300);
	angles[50] = (0, -88.3118, 0);
	at[50] = 13.7333;
	points[51] = (-2630.9961, 6034.5273, 1612.1536);
	angles[51] = (0, -86.8746, 0);
	at[51] = 13.8667;
	points[52] = (-2371.4607, 6050.7090, 1588.9764);
	angles[52] = (0, -86.0741, 0);
	at[52] = 14.1333;
	points[53] = (-2112.0354, 6070.0396, 1570.4370);
	angles[53] = (0, -85.3580, 0);
	at[53] = 14.4000;
	points[54] = (-1853.5906, 6093.5039, 1555.9489);
	angles[54] = (0, -84.1010, 0);
	at[54] = 14.6667;
	points[55] = (-1722.6653, 6108.5435, 1551.1104);
	angles[55] = (0, -82.5179, 0);
	at[55] = 14.8000;
	points[56] = (-1598.9253, 6128.2681, 1550.8898);
	angles[56] = (0, -79.7212, 0);
	at[56] = 14.9333;
	points[57] = (-1342.5630, 6178.4644, 1560.1929);
	angles[57] = (0, -78.4038, 0);
	at[57] = 15.2000;
	points[58] = (-833.6299, 6288.7012, 1586.2834);
	angles[58] = (0, -77.1504, 0);
	at[58] = 15.7333;
	points[59] = (-581.9685, 6348.3467, 1600.1141);
	angles[59] = (0, -75.9979, 0);
	at[59] = 16;
	points[60] = (-453.2047, 6382.1650, 1606.8859);
	angles[60] = (0, -74.1645, 0);
	at[60] = 16.1333;
	points[61] = (-333.9854, 6422.8745, 1611.5237);
	angles[61] = (0, -68.1968, 0);
	at[61] = 16.2667;
	points[62] = (-214.8716, 6475.4331, 1614.2441);
	angles[62] = (0, -64.4133, 0);
	at[62] = 16.4000;
	points[63] = (-99.1831, 6534.9214, 1616.2520);
	angles[63] = (0, -61.1439, 0);
	at[63] = 16.5333;
	points[64] = (12.8694, 6601.6538, 1618.2401);
	angles[64] = (0, -57.0436, 0);
	at[64] = 16.6667;
	points[65] = (117.8740, 6678.8188, 1621.0591);
	angles[65] = (0, -49.0694, 0);
	at[65] = 16.8000;
	points[66] = (194.9709, 6779.6851, 1627.3190);
	angles[66] = (0, -24.3916, 0);
	at[66] = 16.9333;
	points[67] = (239.7594, 6900.9448, 1636.2164);
	angles[67] = (0, -17.6324, 0);
	at[67] = 17.0667;
	points[68] = (276.0264, 7025.8267, 1645.6260);
	angles[68] = (0, -15.0234, 0);
	at[68] = 17.2000;
	points[69] = (336.1429, 7278.2676, 1665.3623);
	angles[69] = (0, -11.9119, 0);
	at[69] = 17.4667;
	points[70] = (361.2366, 7406.8896, 1676.0591);
	angles[70] = (0, -9.9742, 0);
	at[70] = 17.6000;
	points[71] = (377.5657, 7533.3467, 1688.7323);
	angles[71] = (0, -3.5887, 0);
	at[71] = 17.7333;
	points[72] = (380.4445, 7661.6929, 1706.5826);
	angles[72] = (0, 0.3809, 0);
	at[72] = 17.8667;
	points[73] = (377.3847, 7790.3545, 1725.1102);
	angles[73] = (0, 2.1498, 0);
	at[73] = 18;
	points[74] = (363.6634, 8048.0713, 1757.0474);
	angles[74] = (0, 3.6649, 0);
	at[74] = 18.2667;
	points[75] = (355.0382, 8177.1265, 1768.4213);
	angles[75] = (0, 3.9444, 0);
	at[75] = 18.4000;
	points[76] = (347.5721, 8301.1025, 1775.7913);
	angles[76] = (0, 2.5300, 0);
	at[76] = 18.5333;
	points[77] = (334.3087, 8694.4883, 1794.4370);
	angles[77] = (0, 1.8991, 0);
	at[77] = 18.9333;
	points[78] = (319.0925, 9082.7959, 1811.0355);
	angles[78] = (0, 2.6848, 0);
	at[78] = 19.3333;
	points[79] = (296.5240, 9473.6611, 1826.6141);
	angles[79] = (0, 4.0189, 0);
	at[79] = 19.7333;
	points[80] = (275.6146, 9732.5195, 1836.3071);
	angles[80] = (0, 5.2795, 0);
	at[80] = 20;
	points[81] = (247.9937, 9991.0234, 1845.3977);
	angles[81] = (0, 7.0206, 0);
	at[81] = 20.2667;
	points[82] = (230.6028, 10121.6533, 1849.7166);
	angles[82] = (0, 8.1873, 0);
	at[82] = 20.4000;
	points[83] = (210.8795, 10248.0703, 1853.6772);
	angles[83] = (0, 9.5994, 0);
	at[83] = 20.5333;
	points[84] = (186.6697, 10378.6621, 1857.4843);
	angles[84] = (0, 11.4947, 0);
	at[84] = 20.6667;
	points[85] = (160.2453, 10497.0479, 1860.6024);
	angles[85] = (0, 13.5902, 0);
	at[85] = 20.8000;
	points[86] = (132.7421, 10608.5439, 1863.1417);
	angles[86] = (0, 14.0593, 0);
	at[86] = 20.9333;
	points[87] = (97.0748, 10749.2129, 1866.0394);
	angles[87] = (0, 14.3684, 0);
	at[87] = 21.0667;
	points[88] = (34.4491, 10990.6299, 1870.6418);
	angles[88] = (0, 14.6933, 0);
	at[88] = 21.3333;
	points[89] = (-34.9850, 11252.9531, 1875.3859);
	angles[89] = (0, 14.9470, 0);
	at[89] = 21.6000;
	points[90] = (-67.0594, 11372.6768, 1877.4961);
	angles[90] = (0, 15.0485, 0);
	at[90] = 21.7333;
	points[91] = (-100.7028, 11497.3623, 1879.6693);
	angles[91] = (0, 15.1493, 0);
	at[91] = 21.8667;
	points[92] = (-171.6374, 11757.5596, 1884.1417);
	angles[92] = (0, 15.3514, 0);
	at[92] = 22.1333;
	points[93] = (-239.3752, 12002.7158, 1888.3071);
	angles[93] = (0, 15.5400, 0);
	at[93] = 22.4000;
	points[94] = (-346.3150, 12383.3857, 1894.7205);
	angles[94] = (0, 15.8459, 0);
	at[94] = 22.8000;
	points[95] = (-453.6339, 12757.4414, 1901.0078);
	angles[95] = (0, 16.1802, 0);
	at[95] = 23.2000;
	points[96] = (-601.8937, 13259.8418, 1909.4961);
	angles[96] = (0, 16.7258, 0);
	at[96] = 23.7333;
	points[97] = (-715.3780, 13631.5352, 1915.8661);
	angles[97] = (0, 17.2511, 0);
	at[97] = 24.1333;
	points[98] = (-795.1181, 13884.9219, 1920.2834);
	angles[98] = (0, 17.7083, 0);
	at[98] = 24.4000;
	points[99] = (-873.5354, 14126.6143, 1924.5826);
	angles[99] = (0, 18.2641, 0);
	at[99] = 24.6667;
	points[100] = (-959.7363, 14382.1660, 1929.2560);
	angles[100] = (0, 19.0592, 0);
	at[100] = 24.9333;
	points[101] = (-1002.4213, 14504.0557, 1931.5513);
	angles[101] = (0, 19.5590, 0);
	at[101] = 25.0667;
	points[102] = (-1044.0591, 14619.4492, 1933.7795);
	angles[102] = (0, 20.1444, 0);
	at[102] = 25.2000;
	points[103] = (-1141.9646, 14874.0156, 1938.9568);
	angles[103] = (0, 22.1473, 0);
	at[103] = 25.4667;
	points[104] = (-1189.2953, 14986.2598, 1941.4252);
	angles[104] = (0, 23.6859, 0);
	at[104] = 25.6000;
	points[105] = (-1247.4961, 15110.9844, 1944.4331);
	angles[105] = (0, 26.6977, 0);
	at[105] = 25.7333;
	points[106] = (-1310.4843, 15222.3232, 1947.6299);
	angles[106] = (0, 33.5762, 0);
	at[106] = 25.8667;
	points[107] = (-1388.3190, 15308.7412, 1951.4371);
	angles[107] = (0, 51.5982, 0);
	at[107] = 26;
	points[108] = (-1500.9921, 15369.4492, 1956.6495);
	angles[108] = (0, 70.9275, 0);
	at[108] = 26.1333;
	points[109] = (-1629.8070, 15396.2207, 1962.3976);
	angles[109] = (0, 84.5835, 0);
	at[109] = 26.2667;
	points[110] = (-1756.7402, 15398.2285, 1967.9489);
	angles[110] = (0, 92.9850, 0);
	at[110] = 26.4000;
	points[111] = (-1887.2954, 15384.4102, 1973.5787);
	angles[111] = (0, 98.7088, 0);
	at[111] = 26.5333;
	points[112] = (-2014.8898, 15360.1582, 1979.0276);
	angles[112] = (0, 102.5968, 0);
	at[112] = 26.6667;
	points[113] = (-2141.2205, 15328.5039, 1984.3859);
	angles[113] = (0, 105.3768, 0);
	at[113] = 26.8000;
	points[114] = (-2266.3896, 15291.5752, 1989.6653);
	angles[114] = (0, 107.4000, 0);
	at[114] = 26.9333;
	points[115] = (-2512.9607, 15207.6768, 2000.0157);
	angles[115] = (0, 109.8902, 0);
	at[115] = 27.2000;
	points[116] = (-3000.3149, 15024.8428, 2020.3938);
	angles[116] = (0, 110.1562, 0);
	at[116] = 27.7333;
	points[117] = (-3125.4211, 14980.3154, 2025.6378);
	angles[117] = (0, 108.8630, 0);
	at[117] = 27.8667;
	points[118] = (-3246.8267, 14941.3389, 2030.7440);
	angles[118] = (0, 106.4786, 0);
	at[118] = 28;
	points[119] = (-3374.1890, 14908.8584, 2036.1458);
	angles[119] = (0, 101.5046, 0);
	at[119] = 28.1333;
	points[120] = (-3388.7439, 14905.9844, 2036.7638);
	angles[120] = (0, 100.6386, 0);
	at[120] = 28.1667;
	points[121] = (-15602.5586, 8256.1816, 2362.2048);
	angles[121] = (0, 235.2799, 0);
	at[121] = 28.1667;
	points[122] = (-15602.5586, 8256.1816, 2362.2048);
	angles[122] = (0, 235.2799, 0);
	at[122] = 28.1833;
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
	points[0] = (2020.1614, 2686.1299, 1067.0394);
	angles[0] = (0, 32.9134, 0);
	at[0] = 0;
	points[1] = (2022.8937, 2685.4331, 1067.0472);
	angles[1] = (0, -89.6368, 0);
	at[1] = 0.1833;
	points[2] = (2025.9646, 2684.3230, 1067.0591);
	angles[2] = (0, -106.5884, 0);
	at[2] = 0.3667;
	points[3] = (2028.5433, 2685.6418, 1067.0552);
	angles[3] = (0, -52.1140, 0);
	at[3] = 0.5500;
	points[4] = (2030.0748, 2688.5237, 1067.0394);
	angles[4] = (0, -26.7870, 0);
	at[4] = 0.7333;
	points[5] = (2032.6733, 2688.0591, 1067.0433);
	angles[5] = (0, -100.5452, 0);
	at[5] = 0.9167;
	points[6] = (2035.6143, 2686.5906, 1067.0591);
	angles[6] = (0, -115.3347, 0);
	at[6] = 1.1000;
	points[7] = (2038.5276, 2685.1299, 1067.0708);
	angles[7] = (0, -116.2389, 0);
	at[7] = 1.2833;
	points[8] = (2035.7441, 2687.3386, 1067.0552);
	angles[8] = (0, 48.1662, 0);
	at[8] = 1.6500;
	points[9] = (2032.8584, 2689.1340, 1067.0394);
	angles[9] = (0, 57.3793, 0);
	at[9] = 1.8333;
	points[10] = (2030.2717, 2690.7244, 1067.0237);
	angles[10] = (0, 58.3713, 0);
	at[10] = 2.0167;
	points[11] = (1756.9725, 2855.3110, 1065.5984);
	angles[11] = (0, 60.1660, 0);
	at[11] = 19.9833;
	points[12] = (1751.4961, 2858.2754, 1065.5709);
	angles[12] = (0, 62.7950, 0);
	at[12] = 20.3500;
	points[13] = (1749.4844, 2858.4883, 1065.5669);
	angles[13] = (0, 109.9449, 0);
	at[13] = 20.5333;
	points[14] = (1751.9921, 2856.2205, 1065.5826);
	angles[14] = (0, 215.1470, 0);
	at[14] = 20.7167;
	points[15] = (1754.5316, 2854.1497, 1065.5984);
	angles[15] = (0, 229.5930, 0);
	at[15] = 20.9000;
	points[16] = (1757.1221, 2852.0396, 1065.6182);
	angles[16] = (0, 230.4528, 0);
	at[16] = 21.0833;
	points[17] = (1757.4883, 2849.5474, 1065.6339);
	angles[17] = (0, 176.2355, 0);
	at[17] = 21.2667;
	points[18] = (1755.8149, 2848.9646, 1065.6339);
	angles[18] = (0, 98.1801, 0);
	at[18] = 21.4500;
	points[19] = (1752.9568, 2850.6497, 1065.6182);
	angles[19] = (0, 62.7333, 0);
	at[19] = 21.6333;
	points[20] = (1750.1497, 2852.3267, 1065.6063);
	angles[20] = (0, 59.4217, 0);
	at[20] = 21.8167;
	points[21] = (1750.6458, 2851.9253, 1065.6102);
	angles[21] = (0, 79.3634, 0);
	at[21] = 22;
	points[22] = (1753.2836, 2850.2520, 1065.6221);
	angles[22] = (0, 203.1562, 0);
	at[22] = 22.1833;
	points[23] = (1756.0748, 2848.4844, 1065.6378);
	angles[23] = (0, 234.6865, 0);
	at[23] = 22.3667;
	points[24] = (1758.7363, 2846.8032, 1065.6536);
	angles[24] = (0, 237.4868, 0);
	at[24] = 22.5500;
	points[25] = (2006.8898, 2690.8584, 1066.9882);
	angles[25] = (0, 238.3519, 0);
	at[25] = 39.0500;
	points[26] = (2015.0354, 2685.9841, 1067.0315);
	angles[26] = (0, 239.8050, 0);
	at[26] = 39.6000;
	points[27] = (2020.7834, 2682.9370, 1067.0591);
	angles[27] = (0, 244.1821, 0);
	at[27] = 39.9667;
	points[28] = (2022.5237, 2683.3230, 1067.0591);
	angles[28] = (0, 313.1097, 0);
	at[28] = 40.1500;
	points[29] = (2020.3464, 2685.8938, 1067.0394);
	angles[29] = (0, 392.0295, 0);
	at[29] = 40.3333;
	points[30] = (2020.1614, 2686.1299, 1067.0394);
	angles[30] = (0, 392.9135, 0);
	at[30] = 40.3500;
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
	points[0] = (5421.6538, 3883.4136, 1074.6300);
	angles[0] = (0, 9.7629, 0);
	at[0] = 0;
	points[1] = (5377.2832, 4137.8345, 1071.4882);
	angles[1] = (0, 12.0693, 0);
	at[1] = 14.5167;
	points[2] = (5375.5903, 4144.6460, 1071.3937);
	angles[2] = (0, 15.8053, 0);
	at[2] = 14.9500;
	points[3] = (5372.7949, 4151.5747, 1071.2756);
	angles[3] = (0, 26.9032, 0);
	at[3] = 15.3833;
	points[4] = (5370.4727, 4154.5669, 1071.2047);
	angles[4] = (0, 41.7605, 0);
	at[4] = 15.6000;
	points[5] = (5363.3857, 4154.8818, 1071.0552);
	angles[5] = (0, 111.6909, 0);
	at[5] = 16.0333;
	points[6] = (5360.1572, 4152.7559, 1071.0079);
	angles[6] = (0, 123.7984, 0);
	at[6] = 16.2500;
	points[7] = (5356.7324, 4151.4565, 1070.9489);
	angles[7] = (0, 100.1096, 0);
	at[7] = 16.4667;
	points[8] = (5352.9136, 4150.8662, 1070.8779);
	angles[8] = (0, 101.5838, 0);
	at[8] = 16.6833;
	points[9] = (5338.7007, 4145.0391, 1070.6417);
	angles[9] = (0, 121.0308, 0);
	at[9] = 17.5500;
	points[10] = (5331.6929, 4145.0791, 1070.4961);
	angles[10] = (0, 71.8667, 0);
	at[10] = 17.9833;
	points[11] = (5327.9131, 4145.3545, 1070.4174);
	angles[11] = (0, 94.2497, 0);
	at[11] = 18.2000;
	points[12] = (5325.4727, 4142.6772, 1070.3937);
	angles[12] = (0, 145.8233, 0);
	at[12] = 18.4167;
	points[13] = (5324.6460, 4139.0552, 1070.4094);
	angles[13] = (0, 169.3560, 0);
	at[13] = 18.6333;
	points[14] = (5324.4487, 4135.2759, 1070.4370);
	angles[14] = (0, 178.1953, 0);
	at[14] = 18.8500;
	points[15] = (5324.5669, 4131.2598, 1070.4764);
	angles[15] = (0, 182.4959, 0);
	at[15] = 19.0667;
	points[16] = (5325.8657, 4119.9609, 1070.6024);
	angles[16] = (0, 188.3035, 0);
	at[16] = 19.7167;
	points[17] = (5394.5669, 3761.0513, 1075.1575);
	angles[17] = (0, 192.3268, 0);
	at[17] = 40.3000;
	points[18] = (5397.2441, 3750.3110, 1075.3032);
	angles[18] = (0, 195.5598, 0);
	at[18] = 40.9500;
	points[19] = (5399.8818, 3742.9016, 1075.4252);
	angles[19] = (0, 203.6632, 0);
	at[19] = 41.3833;
	points[20] = (5402.1650, 3740.0828, 1075.4961);
	angles[20] = (0, 228.2782, 0);
	at[20] = 41.6000;
	points[21] = (5405.0791, 3742.0159, 1075.5354);
	angles[21] = (0, 313.4030, 0);
	at[21] = 41.8167;
	points[22] = (5406.8506, 3745.4526, 1075.5433);
	angles[22] = (0, 331.8954, 0);
	at[22] = 42.0333;
	points[23] = (5409.3701, 3747.9805, 1075.5709);
	angles[23] = (0, 295.1872, 0);
	at[23] = 42.2500;
	points[24] = (5413.2285, 3747.8938, 1075.6497);
	angles[24] = (0, 272.8203, 0);
	at[24] = 42.4667;
	points[25] = (5428.3857, 3750.5081, 1075.9370);
	angles[25] = (0, 285.2907, 0);
	at[25] = 43.3333;
	points[26] = (5434.2915, 3755.0471, 1076.0157);
	angles[26] = (0, 320.4263, 0);
	at[26] = 43.7667;
	points[27] = (5439.7637, 3765.1694, 1076.0394);
	angles[27] = (0, 338.5391, 0);
	at[27] = 44.4167;
	points[28] = (5440.3940, 3768.8936, 1076.0197);
	angles[28] = (0, 354.9585, 0);
	at[28] = 44.6333;
	points[29] = (5440.0786, 3772.7246, 1075.9803);
	angles[29] = (0, 365.4108, 0);
	at[29] = 44.8500;
	points[30] = (5439.5278, 3776.4958, 1075.9331);
	angles[30] = (0, 368.6786, 0);
	at[30] = 45.0667;
	points[31] = (5421.6538, 3883.4136, 1074.6300);
	angles[31] = (0, 369.7629, 0);
	at[31] = 51.1833;
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
	points[0] = (2565.5906, 3706.6104, 1062.2599);
	angles[0] = (0, -113.4758, -0.1136);
	at[0] = 0;
	points[1] = (2574.3584, 3690.8386, 1062.2441);
	angles[1] = (0, -113.4758, -0.1136);
	at[1] = 1;
	points[2] = (2580.6104, 3689.9607, 1062.2284);
	angles[2] = (0, -113.4758, -0.1136);
	at[2] = 1.5000;
	points[3] = (2583.0315, 3699.0198, 1062.2205);
	angles[3] = (0, -70.4150, -0.1156);
	at[3] = 2;
	points[4] = (2592.4802, 3701.1418, 1062.2008);
	angles[4] = (0, -70.4150, -0.1156);
	at[4] = 2.5000;
	points[5] = (2601.3779, 3705.6101, 1062.1851);
	angles[5] = (0, -9.3644, -0.0182);
	at[5] = 3;
	points[6] = (2610.4961, 3701.5159, 1062.1693);
	angles[6] = (0, -9.3644, -0.0182);
	at[6] = 3.5000;
	points[7] = (2605.9412, 3721.1892, 1062.1732);
	angles[7] = (0, -9.3644, -0.0182);
	at[7] = 4.5000;
	points[8] = (2602.6851, 3729.7639, 1062.1812);
	angles[8] = (0, 22.2555, 0.0326);
	at[8] = 5;
	points[9] = (2583.4880, 3777.9766, 1062.2087);
	angles[9] = (0, 22.2555, 0.0326);
	at[9] = 7.5000;
	points[10] = (2565.6101, 3822.2913, 1062.2362);
	angles[10] = (0, 22.2555, 0.0326);
	at[10] = 10;
	points[11] = (2545.1812, 3872.6692, 1062.2638);
	angles[11] = (0, 22.2555, 0.0326);
	at[11] = 13;
	points[12] = (2522.8740, 3927.4253, 1062.2993);
	angles[12] = (0, 22.2555, 0.0326);
	at[12] = 16.5000;
	points[13] = (2496.6023, 3991.5750, 1062.3386);
	angles[13] = (0, 22.2555, 0.0326);
	at[13] = 21;
	points[14] = (2478.1653, 4036.2993, 1062.3662);
	angles[14] = (0, 22.2555, 0.0326);
	at[14] = 24.5000;
	points[15] = (2461.4253, 4076.4961, 1062.3898);
	angles[15] = (0, 22.2555, 0.0326);
	at[15] = 28;
	points[16] = (2446.5117, 4111.4565, 1062.4135);
	angles[16] = (0, 22.2555, 0.0326);
	at[16] = 31.5000;
	points[17] = (2445, 4114.8423, 1062.4174);
	angles[17] = (0, 52.3487, 0.1150);
	at[17] = 32;
	points[18] = (2433.5156, 4135.0396, 1062.4409);
	angles[18] = (0, 52.3487, 0.1150);
	at[18] = 34.5000;
	points[19] = (2424.6694, 4140.5117, 1062.4646);
	angles[19] = (0, 52.3487, 0.1150);
	at[19] = 36;
	points[20] = (2416.7993, 4136.5747, 1062.4882);
	angles[20] = (0, 52.3487, 0.1150);
	at[20] = 38.5000;
	points[21] = (2416.4724, 4136.6533, 1062.4882);
	angles[21] = (0, 115.2368, 0.1606);
	at[21] = 39;
	points[22] = (2410.7087, 4135.7876, 1062.5078);
	angles[22] = (0, 115.2368, 0.1606);
	at[22] = 49.5000;
	points[23] = (2397.1260, 4127.5591, 1062.5511);
	angles[23] = (0, 115.2368, 0.1606);
	at[23] = 78;
	points[24] = (2396.9766, 4127.3623, 1062.5511);
	angles[24] = (0, 164.7027, 0.0689);
	at[24] = 78.5000;
	points[25] = (2391.1931, 4106.1416, 1062.5748);
	angles[25] = (0, 164.7027, 0.0689);
	at[25] = 118;
	points[26] = (2391.1338, 4105.7480, 1062.5787);
	angles[26] = (0, 193.4412, -0.0137);
	at[26] = 118.5000;
	points[27] = (2386.9802, 4107.9922, 1062.5867);
	angles[27] = (0, 193.4412, -0.0137);
	at[27] = 131.5000;
	points[28] = (2396.0315, 4085.7087, 1062.5709);
	angles[28] = (0, 193.4412, -0.0137);
	at[28] = 174;
	points[29] = (2396.1299, 4085.5120, 1062.5709);
	angles[29] = (0, 204.0970, -0.0430);
	at[29] = 174.5000;
	points[30] = (2441.6733, 3982.5591, 1062.4882);
	angles[30] = (0, 204.0970, -0.0430);
	at[30] = 375;
	points[31] = (2445.4253, 3974.1340, 1062.4803);
	angles[31] = (0, 204.0970, -0.0430);
	at[31] = 379;
	points[32] = (2452.5986, 3957.9919, 1062.4685);
	angles[32] = (0, 204.0970, -0.0430);
	at[32] = 383;
	points[33] = (2463.1772, 3934.2126, 1062.4489);
	angles[33] = (0, 204.0970, -0.0430);
	at[33] = 387;
	points[34] = (2477.0237, 3903.1221, 1062.4213);
	angles[34] = (0, 204.0970, -0.0430);
	at[34] = 391;
	points[35] = (2496.7007, 3859.0195, 1062.3859);
	angles[35] = (0, 204.0970, -0.0430);
	at[35] = 395.5000;
	points[36] = (2517.8542, 3811.7363, 1062.3464);
	angles[36] = (0, 204.0970, -0.0430);
	at[36] = 399.5000;
	points[37] = (2542.1458, 3757.7283, 1062.3032);
	angles[37] = (0, 204.0970, -0.0430);
	at[37] = 403.5000;
	points[38] = (2563.6812, 3710.6182, 1062.2638);
	angles[38] = (0, 204.0970, -0.0430);
	at[38] = 406.5000;
	points[39] = (2565.5906, 3706.6104, 1062.2599);
	angles[39] = (0, 246.5242, -0.1136);
	at[39] = 406.8500;
	mover = getEnt("iz_obj_4", "targetname");
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
