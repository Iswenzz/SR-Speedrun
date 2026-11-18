main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_gp_bananan_ruins", 0);

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
	ambientPlay("iz_0_gpbr", 2);
	iz_emitter("iz_1_se_cc_env_river", (9595.7363, -5831.3394, 267.4353), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (8816.1299, -5291.8296, 267.4353), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (8036.5225, -4752.3198, 267.4353), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (7256.9155, -4212.8101, 267.4353), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (6477.3091, -3673.3000, 267.4353), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_river", (5697.7026, -3133.7903, 267.4353), 0, 12.0104);
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
	level.iz_route[level.iz_route.size] = (805, 1099, 382);
	level.iz_route[level.iz_route.size] = (803, 11, 374);
	level.iz_route[level.iz_route.size] = (883, -1014, 374);
	level.iz_route[level.iz_route.size] = (1241, -1993, 374);
	level.iz_route[level.iz_route.size] = (1749, -2575, 374);
	level.iz_route[level.iz_route.size] = (2479, -3060, 412);
	level.iz_route[level.iz_route.size] = (3490, -3473, 417);
	level.iz_route[level.iz_route.size] = (4564, -3890, 417);
	level.iz_route[level.iz_route.size] = (5516, -4274, 417);
	level.iz_route[level.iz_route.size] = (6177, -4595, 417);
	level.iz_route[level.iz_route.size] = (6632, -5134, 417);
	level.iz_route[level.iz_route.size] = (7112, -5905, 417);
	level.iz_route[level.iz_route.size] = (7599, -6825, 417);
	level.iz_route[level.iz_route.size] = (8173, -7380, 417);
	level.iz_route[level.iz_route.size] = (9081, -7789, 417);
	level.iz_route[level.iz_route.size] = (10102, -8190, 417);
	level.iz_route[level.iz_route.size] = (10903, -8504, 417);
	level.iz_route[level.iz_route.size] = (11515, -8763, 442);
	level.iz_route[level.iz_route.size] = (12572, -9220, 797);
	level.iz_route[level.iz_route.size] = (13624, -9628, 800);
	level.iz_route[level.iz_route.size] = (14547, -9953, 800);
	level.iz_route[level.iz_route.size] = (15490, -9963, 800);
	level.iz_route[level.iz_route.size] = (16481, -9608, 800);
	level.iz_route[level.iz_route.size] = (17192, -8843, 800);
	level.iz_route[level.iz_route.size] = (17477, -8138, 800);
	level.iz_route[level.iz_route.size] = (17313, -7423, 800);
	level.iz_route[level.iz_route.size] = (16838, -6942, 800);
	level.iz_route[level.iz_route.size] = (16044, -6574, 800);
	level.iz_route[level.iz_route.size] = (15122, -6211, 800);
	level.iz_route[level.iz_route.size] = (13845, -5724, 800);
	level.iz_route[level.iz_route.size] = (12679, -5273, 800);
	level.iz_route[level.iz_route.size] = (11385, -4740, 800);
	level.iz_route[level.iz_route.size] = (10784, -4495, 776);
	level.iz_route[level.iz_route.size] = (10351, -4326, 724);
	level.iz_route[level.iz_route.size] = (9444, -3951, 689);
	level.iz_route[level.iz_route.size] = (8708, -3654, 726);
	level.iz_route[level.iz_route.size] = (7879, -3322, 722);
	level.iz_route[level.iz_route.size] = (7084, -2997, 678);
	level.iz_route[level.iz_route.size] = (6259, -2664, 677);
	level.iz_route[level.iz_route.size] = (5476, -2355, 699);
	level.iz_route[level.iz_route.size] = (5196, -2246, 659);
	level.iz_route[level.iz_route.size] = (4212, -1849, 319);
	level.iz_route[level.iz_route.size] = (3640, -1636, 197);
	level.iz_route[level.iz_route.size] = (2883, -1335, 123);
	level.iz_route[level.iz_route.size] = (1981, -959, 63);
	level.iz_route[level.iz_route.size] = (1702, -843, 53);
	level.iz_route[level.iz_route.size] = (1328, -683, 54);
	level.iz_route[level.iz_route.size] = (514, -343, 81);
	level.iz_route[level.iz_route.size] = (-605, 337, 253);
	level.iz_route[level.iz_route.size] = (-1048, 721, 321);
	level.iz_route[level.iz_route.size] = (-1490, 1296, 370);
	level.iz_route[level.iz_route.size] = (-1971, 1974, 397);
	level.iz_route[level.iz_route.size] = (-2139, 2867, 401);
	level.iz_route[level.iz_route.size] = (-2226, 3831, 402);
	level.iz_route[level.iz_route.size] = (-2215, 4786, 413);
	level.iz_route[level.iz_route.size] = (-2063, 5518, 419);
	level.iz_route[level.iz_route.size] = (-1666, 6084, 421);
	level.iz_route[level.iz_route.size] = (-1111, 6365, 419);
	level.iz_route[level.iz_route.size] = (-502, 6418, 421);
	level.iz_route[level.iz_route.size] = (88, 6133, 417);
	level.iz_route[level.iz_route.size] = (597, 5580, 422);
	level.iz_route[level.iz_route.size] = (797, 4840, 421);
	level.iz_route[level.iz_route.size] = (800, 4000, 408);
	level.iz_route[level.iz_route.size] = (785, 3198, 393);
	level.iz_route[level.iz_route.size] = (794, 2153, 380);
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
	points[0] = (13298.0312, -3776.5513, 270.2244);
	angles[0] = (0, 53.7132, 0);
	at[0] = 0;
	points[1] = (13184.8418, -3697.3662, 270.3150);
	angles[1] = (0, 54.2480, 0);
	at[1] = 0.1667;
	points[2] = (12833.9766, -3453.9727, 270.4142);
	angles[2] = (0, 55.0560, 0);
	at[2] = 0.6667;
	points[3] = (12129.7246, -2968.6653, 270.3874);
	angles[3] = (0, 55.4595, 0);
	at[3] = 1.6667;
	points[4] = (12014.2520, -2889.5396, 270.3583);
	angles[4] = (0, 55.5100, 0);
	at[4] = 1.8333;
	points[5] = (11776.0635, -2727.2715, 270.2504);
	angles[5] = (0, 55.6774, 0);
	at[5] = 2.1667;
	points[6] = (11667.0469, -2654.1890, 270.1398);
	angles[6] = (0, 55.8891, 0);
	at[6] = 2.3333;
	points[7] = (11308.3066, -2418.1260, 269.5264);
	angles[7] = (0, 56.5267, 0);
	at[7] = 2.8333;
	points[8] = (10356.9297, -1795.6614, 267.7473);
	angles[8] = (0, 56.7493, 0);
	at[8] = 4.1667;
	points[9] = (10117.4805, -1637.0079, 267.4547);
	angles[9] = (0, 56.5374, 0);
	at[9] = 4.5000;
	points[10] = (10008.7402, -1563.2126, 267.4579);
	angles[10] = (0, 56.2390, 0);
	at[10] = 4.6667;
	points[11] = (9306.9688, -1074.2205, 268.8173);
	angles[11] = (0, 55.0357, 0);
	at[11] = 5.6667;
	points[12] = (8727.1260, -659.0276, 270.1606);
	angles[12] = (0, 54.2017, 0);
	at[12] = 6.5000;
	points[13] = (8620.0400, -575.5472, 270.2843);
	angles[13] = (0, 53.2462, 0);
	at[13] = 6.6667;
	points[14] = (8512.1650, -483.3425, 270.3327);
	angles[14] = (0, 51.6770, 0);
	at[14] = 6.8333;
	points[15] = (8194.2910, -199.1047, 270.3185);
	angles[15] = (0, 48.9058, 0);
	at[15] = 7.3333;
	points[16] = (7979.1733, -12.5777, 270.2583);
	angles[16] = (0, 49.1663, 0);
	at[16] = 7.6667;
	points[17] = (7868.8975, 73.6665, 270.2295);
	angles[17] = (0, 50.4451, 0);
	at[17] = 7.8333;
	points[18] = (7747.4414, 143.9559, 270.2216);
	angles[18] = (0, 54.7082, 0);
	at[18] = 8;
	points[19] = (7616.1812, 196.5516, 270.2220);
	angles[19] = (0, 60.2301, 0);
	at[19] = 8.1667;
	points[20] = (7481.5356, 242.8787, 270.2220);
	angles[20] = (0, 64.6211, 0);
	at[20] = 8.3333;
	points[21] = (7209.1338, 323.8492, 270.2220);
	angles[21] = (0, 70.4803, 0);
	at[21] = 8.6667;
	points[22] = (7070.3936, 359.1866, 270.2220);
	angles[22] = (0, 72.6436, 0);
	at[22] = 8.8333;
	points[23] = (6931.7319, 388.3091, 270.2220);
	angles[23] = (0, 74.9854, 0);
	at[23] = 9;
	points[24] = (6792.9927, 393.9055, 270.2220);
	angles[24] = (0, 80.7174, 0);
	at[24] = 9.1667;
	points[25] = (6653.7793, 365.2287, 270.2216);
	angles[25] = (0, 89.3038, 0);
	at[25] = 9.3333;
	points[26] = (6517.9927, 322.8468, 270.2220);
	angles[26] = (0, 96.6446, 0);
	at[26] = 9.5000;
	points[27] = (6386.1025, 270.7102, 270.2220);
	angles[27] = (0, 102.7694, 0);
	at[27] = 9.6667;
	points[28] = (6259.8027, 203.5508, 270.2220);
	angles[28] = (0, 109.2560, 0);
	at[28] = 9.8333;
	points[29] = (6168.1499, 99.8122, 270.2220);
	angles[29] = (0, 121.3278, 0);
	at[29] = 10;
	points[30] = (6092.0078, -20.6503, 270.2220);
	angles[30] = (0, 131.8991, 0);
	at[30] = 10.1667;
	points[31] = (6023.7793, -145.0811, 270.2220);
	angles[31] = (0, 139.7161, 0);
	at[31] = 10.3333;
	points[32] = (5963.2676, -273.5095, 270.2220);
	angles[32] = (0, 145.9022, 0);
	at[32] = 10.5000;
	points[33] = (5929.2520, -409.5276, 270.2220);
	angles[33] = (0, 154.7810, 0);
	at[33] = 10.6667;
	points[34] = (5949.6460, -549.1811, 270.2220);
	angles[34] = (0, 168.2194, 0);
	at[34] = 10.8333;
	points[35] = (5986.0635, -686.7520, 270.2220);
	angles[35] = (0, 178.8889, 0);
	at[35] = 11;
	points[36] = (6032.5591, -820.8189, 270.2220);
	angles[36] = (0, 187.1099, 0);
	at[36] = 11.1667;
	points[37] = (6099.3311, -943.8150, 270.2220);
	angles[37] = (0, 196.2339, 0);
	at[37] = 11.3333;
	points[38] = (6193.4644, -1050.1182, 270.2216);
	angles[38] = (0, 206.3875, 0);
	at[38] = 11.5000;
	points[39] = (6291.9683, -1152.8818, 270.2216);
	angles[39] = (0, 213.3522, 0);
	at[39] = 11.6667;
	points[40] = (6390.3936, -1255.4922, 270.2216);
	angles[40] = (0, 217.5056, 0);
	at[40] = 11.8333;
	points[41] = (6484.4878, -1361.5197, 270.2216);
	angles[41] = (0, 218.9558, 0);
	at[41] = 12;
	points[42] = (6552.9136, -1483.8544, 270.2457);
	angles[42] = (0, 214.4862, 0);
	at[42] = 12.1667;
	points[43] = (6603.4644, -1616.7677, 270.3035);
	angles[43] = (0, 208.8972, 0);
	at[43] = 12.3333;
	points[44] = (6647.3228, -1751.6732, 270.3429);
	angles[44] = (0, 204.4561, 0);
	at[44] = 12.5000;
	points[45] = (6685, -1889.3032, 270.3197);
	angles[45] = (0, 200.6609, 0);
	at[45] = 12.6667;
	points[46] = (6701.4565, -2027.2913, 269.9862);
	angles[46] = (0, 194.5538, 0);
	at[46] = 12.8333;
	points[47] = (6691.7324, -2169.6023, 269.2595);
	angles[47] = (0, 187.0497, 0);
	at[47] = 13;
	points[48] = (6658.1499, -2452.1575, 267.7469);
	angles[48] = (0, 178.1005, 0);
	at[48] = 13.3333;
	points[49] = (6642.4800, -2590.9841, 267.3484);
	angles[49] = (0, 176.3112, 0);
	at[49] = 13.5000;
	points[50] = (6595.1577, -3015.8032, 267.4146);
	angles[50] = (0, 174.4247, 0);
	at[50] = 14;
	points[51] = (6594.5669, -3156.1262, 267.4161);
	angles[51] = (0, 176.9133, 0);
	at[51] = 14.1667;
	points[52] = (6610.2759, -3297.2324, 267.3618);
	angles[52] = (0, 180.8494, 0);
	at[52] = 14.3333;
	points[53] = (6640.0396, -3435.7324, 267.3882);
	angles[53] = (0, 185.7221, 0);
	at[53] = 14.5000;
	points[54] = (6711.3389, -3556.8384, 267.8480);
	angles[54] = (0, 196.0963, 0);
	at[54] = 14.6667;
	points[55] = (6799.0947, -3668.5828, 268.4689);
	angles[55] = (0, 204.9536, 0);
	at[55] = 14.8333;
	points[56] = (6891.6929, -3776.0432, 269.0366);
	angles[56] = (0, 211.3516, 0);
	at[56] = 15;
	points[57] = (6991.3779, -3875.1104, 269.3240);
	angles[57] = (0, 217.1495, 0);
	at[57] = 15.1667;
	points[58] = (7211.1416, -4055.3938, 269.3469);
	angles[58] = (0, 225.8904, 0);
	at[58] = 15.5000;
	points[59] = (7431.1812, -4235.5117, 269.2906);
	angles[59] = (0, 228.8629, 0);
	at[59] = 15.8333;
	points[60] = (7532.9136, -4331.8896, 269.2744);
	angles[60] = (0, 227.5755, 0);
	at[60] = 16;
	points[61] = (7620.3936, -4443.8188, 269.2744);
	angles[61] = (0, 223.5912, 0);
	at[61] = 16.1667;
	points[62] = (7786.4170, -4674.6455, 269.2744);
	angles[62] = (0, 218.5585, 0);
	at[62] = 16.5000;
	points[63] = (7875.4727, -4783.3467, 269.2811);
	angles[63] = (0, 219.1368, 0);
	at[63] = 16.6667;
	points[64] = (7973.5039, -4886.2207, 269.3244);
	angles[64] = (0, 220.9974, 0);
	at[64] = 16.8333;
	points[65] = (8074.8037, -4986.0630, 269.3551);
	angles[65] = (0, 222.8512, 0);
	at[65] = 17;
	points[66] = (8181.4570, -5079.4883, 269.3224);
	angles[66] = (0, 225.4556, 0);
	at[66] = 17.1667;
	points[67] = (8305.4326, -5144.7642, 268.9665);
	angles[67] = (0, 232.6779, 0);
	at[67] = 17.3333;
	points[68] = (8439.0156, -5193.9370, 268.4240);
	angles[68] = (0, 239.6230, 0);
	at[68] = 17.5000;
	points[69] = (8574.4883, -5236.1416, 267.8752);
	angles[69] = (0, 244.9579, 0);
	at[69] = 17.6667;
	points[70] = (8712.1260, -5266.4570, 267.4283);
	angles[70] = (0, 250.4364, 0);
	at[70] = 17.8333;
	points[71] = (8853.9766, -5263.5039, 267.3154);
	angles[71] = (0, 258.9653, 0);
	at[71] = 18;
	points[72] = (8995.3936, -5248.7798, 267.2992);
	angles[72] = (0, 265.8484, 0);
	at[72] = 18.1667;
	points[73] = (9135.2754, -5225.7876, 267.3484);
	angles[73] = (0, 271.4010, 0);
	at[73] = 18.3333;
	points[74] = (9268.0322, -5181.8506, 267.5851);
	angles[74] = (0, 278.6986, 0);
	at[74] = 18.5000;
	points[75] = (9394.0156, -5115.3149, 268.0839);
	angles[75] = (0, 286.4474, 0);
	at[75] = 18.6667;
	points[76] = (9516.6934, -5043.1104, 268.6004);
	angles[76] = (0, 292.1278, 0);
	at[76] = 18.8333;
	points[77] = (9636.3389, -4966.1416, 269.0606);
	angles[77] = (0, 296.4861, 0);
	at[77] = 19;
	points[78] = (9745.8662, -4880.9844, 269.2587);
	angles[78] = (0, 301.4535, 0);
	at[78] = 19.1667;
	points[79] = (9843.2285, -4776.2207, 268.9173);
	angles[79] = (0, 307.8505, 0);
	at[79] = 19.3333;
	points[80] = (10025.5117, -4557.5986, 268.0087);
	angles[80] = (0, 315.9270, 0);
	at[80] = 19.6667;
	points[81] = (10112.4404, -4445.7871, 267.5976);
	angles[81] = (0, 318.4779, 0);
	at[81] = 19.8333;
	points[82] = (10191.1807, -4328.8979, 267.5071);
	angles[82] = (0, 321.8946, 0);
	at[82] = 20;
	points[83] = (10246.2207, -4198.1499, 268.3028);
	angles[83] = (0, 328.2291, 0);
	at[83] = 20.1667;
	points[84] = (10339.1729, -3929.6143, 270.1197);
	angles[84] = (0, 336.3293, 0);
	at[84] = 20.5000;
	points[85] = (10490.6699, -3532.9805, 270.3284);
	angles[85] = (0, 338.4717, 0);
	at[85] = 21;
	points[86] = (10597.3232, -3269.4409, 270.2527);
	angles[86] = (0, 337.9982, 0);
	at[86] = 21.3333;
	points[87] = (10657.8350, -3140.6812, 270.2220);
	angles[87] = (0, 336.5201, 0);
	at[87] = 21.5000;
	points[88] = (10729.5674, -3020.4448, 270.2220);
	angles[88] = (0, 333.4884, 0);
	at[88] = 21.6667;
	points[89] = (10885.7871, -2783.5315, 270.2220);
	angles[89] = (0, 328.8653, 0);
	at[89] = 22;
	points[90] = (10969.4482, -2668.2285, 270.2220);
	angles[90] = (0, 326.8441, 0);
	at[90] = 22.1667;
	points[91] = (11058.5830, -2557.8425, 270.2220);
	angles[91] = (0, 324.3831, 0);
	at[91] = 22.3333;
	points[92] = (11161.0234, -2460.1221, 270.2220);
	angles[92] = (0, 319.5086, 0);
	at[92] = 22.5000;
	points[93] = (11289.8818, -2405.8860, 270.2220);
	angles[93] = (0, 308.5482, 0);
	at[93] = 22.6667;
	points[94] = (11426.2598, -2368.2480, 270.2220);
	angles[94] = (0, 299.2567, 0);
	at[94] = 22.8333;
	points[95] = (11565.1582, -2336.7324, 270.2220);
	angles[95] = (0, 292.6163, 0);
	at[95] = 23;
	points[96] = (11845.4326, -2285.0789, 270.2220);
	angles[96] = (0, 284.6272, 0);
	at[96] = 23.3333;
	points[97] = (11985.2754, -2265.2048, 270.2220);
	angles[97] = (0, 281.9174, 0);
	at[97] = 23.5000;
	points[98] = (12125.0400, -2261.9055, 270.2220);
	angles[98] = (0, 277.1977, 0);
	at[98] = 23.6667;
	points[99] = (12265.6699, -2284.3347, 270.2220);
	angles[99] = (0, 270.4956, 0);
	at[99] = 23.8333;
	points[100] = (12403.8193, -2317.9451, 270.2220);
	angles[100] = (0, 264.6972, 0);
	at[100] = 24;
	points[101] = (12538.2285, -2361.5906, 270.2220);
	angles[101] = (0, 259.3918, 0);
	at[101] = 24.1667;
	points[102] = (12655, -2440.0276, 270.2220);
	angles[102] = (0, 249.4648, 0);
	at[102] = 24.3333;
	points[103] = (12754.4102, -2541.1616, 270.2220);
	angles[103] = (0, 239.3775, 0);
	at[103] = 24.5000;
	points[104] = (12842.1660, -2653.5002, 270.2220);
	angles[104] = (0, 230.5432, 0);
	at[104] = 24.6667;
	points[105] = (12891.6934, -2784.5984, 270.2220);
	angles[105] = (0, 218.3744, 0);
	at[105] = 24.8333;
	points[106] = (12960.4336, -3060.7876, 270.2220);
	angles[106] = (0, 202.6358, 0);
	at[106] = 25.1667;
	points[107] = (12990, -3198.0591, 270.2220);
	angles[107] = (0, 198.3579, 0);
	at[107] = 25.3333;
	points[108] = (13041.6533, -3477.9370, 270.2220);
	angles[108] = (0, 193.3073, 0);
	at[108] = 25.6667;
	points[109] = (13074.2129, -3614.5669, 270.2220);
	angles[109] = (0, 193.6113, 0);
	at[109] = 25.8333;
	points[110] = (13120.0791, -3749.1772, 270.2220);
	angles[110] = (0, 195.8027, 0);
	at[110] = 26;
	points[111] = (13175.6689, -3878.7444, 270.2268);
	angles[111] = (0, 199.1837, 0);
	at[111] = 26.1667;
	points[112] = (13256.5361, -3995.6692, 270.3362);
	angles[112] = (0, 205.5728, 0);
	at[112] = 26.3333;
	points[113] = (13347.5596, -4103.6221, 270.1512);
	angles[113] = (0, 211.6600, 0);
	at[113] = 26.5000;
	points[114] = (13447.2441, -4204.1733, 268.7020);
	angles[114] = (0, 217.1120, 0);
	at[114] = 26.6667;
	points[115] = (13560, -4289.5278, 267.6906);
	angles[115] = (0, 223.7155, 0);
	at[115] = 26.8333;
	points[116] = (13677.4414, -4357.3623, 267.3909);
	angles[116] = (0, 230.3766, 0);
	at[116] = 27;
	points[117] = (14054.8428, -4562.8350, 267.3114);
	angles[117] = (0, 239.1159, 0);
	at[117] = 27.5000;
	points[118] = (14181.6533, -4630.5903, 267.3154);
	angles[118] = (0, 240.2355, 0);
	at[118] = 27.6667;
	points[119] = (14559.2520, -4826.4175, 267.3551);
	angles[119] = (0, 242.2268, 0);
	at[119] = 28.1667;
	points[120] = (14817.6768, -4951.8110, 267.3945);
	angles[120] = (0, 243.5726, 0);
	at[120] = 28.5000;
	points[121] = (14947.8340, -5009.4097, 267.4149);
	angles[121] = (0, 244.6677, 0);
	at[121] = 28.6667;
	points[122] = (15082.9131, -5059.1733, 267.4327);
	angles[122] = (0, 246.9339, 0);
	at[122] = 28.8333;
	points[123] = (15215.3945, -5060.3545, 267.4354);
	angles[123] = (0, 256.8401, 0);
	at[123] = 29;
	points[124] = (15343.2275, -4997.9526, 267.4354);
	angles[124] = (0, 272.5240, 0);
	at[124] = 29.1667;
	points[125] = (15456.7715, -4913.6616, 267.4354);
	angles[125] = (0, 286.0422, 0);
	at[125] = 29.3333;
	points[126] = (15564.4492, -4820.9453, 267.4354);
	angles[126] = (0, 295.8893, 0);
	at[126] = 29.5000;
	points[127] = (15671.4961, -4726.4570, 267.4354);
	angles[127] = (0, 302.0574, 0);
	at[127] = 29.6667;
	points[128] = (15783.7412, -4639.4883, 267.4354);
	angles[128] = (0, 304.0559, 0);
	at[128] = 29.8333;
	points[129] = (15908.5830, -4579.8818, 267.4354);
	angles[129] = (0, 300.3076, 0);
	at[129] = 30;
	points[130] = (16039.7246, -4526.9688, 267.4354);
	angles[130] = (0, 296.9293, 0);
	at[130] = 30.1667;
	points[131] = (16306.5752, -4425.6694, 267.4354);
	angles[131] = (0, 292.8959, 0);
	at[131] = 30.5000;
	points[132] = (16575.7871, -4330.9053, 267.4354);
	angles[132] = (0, 290.5316, 0);
	at[132] = 30.8333;
	points[133] = (16711.4180, -4287.5986, 267.4354);
	angles[133] = (0, 289.3389, 0);
	at[133] = 31;
	points[134] = (16849.8027, -4251.6143, 267.4354);
	angles[134] = (0, 287.2085, 0);
	at[134] = 31.1667;
	points[135] = (16972.7949, -4294.0156, 267.4354);
	angles[135] = (0, 271.7561, 0);
	at[135] = 31.3333;
	points[136] = (17047.2441, -4414.9214, 267.4354);
	angles[136] = (0, 249.1736, 0);
	at[136] = 31.5000;
	points[137] = (17090.4727, -4549.6064, 267.4354);
	angles[137] = (0, 229.4066, 0);
	at[137] = 31.6667;
	points[138] = (17038.3086, -4666.8110, 267.4354);
	angles[138] = (0, 203.5143, 0);
	at[138] = 31.8333;
	points[139] = (16915.4727, -4738.4648, 267.4354);
	angles[139] = (0, 175.6802, 0);
	at[139] = 32;
	points[140] = (16786.1816, -4798.0708, 267.4354);
	angles[140] = (0, 153.2559, 0);
	at[140] = 32.1667;
	points[141] = (16655.3164, -4846.5352, 267.4354);
	angles[141] = (0, 136.6377, 0);
	at[141] = 32.3333;
	points[142] = (16520.0781, -4892.1655, 267.4354);
	angles[142] = (0, 125.5739, 0);
	at[142] = 32.5000;
	points[143] = (16248.3867, -4975.9058, 267.4354);
	angles[143] = (0, 113.6198, 0);
	at[143] = 32.8333;
	points[144] = (16111.1016, -5012.3232, 267.4354);
	angles[144] = (0, 110.0316, 0);
	at[144] = 33;
	points[145] = (15971.2988, -5041.8110, 267.4354);
	angles[145] = (0, 106.6183, 0);
	at[145] = 33.1667;
	points[146] = (15834.3301, -5050.8267, 267.4354);
	angles[146] = (0, 100.7890, 0);
	at[146] = 33.3333;
	points[147] = (15694.7246, -5018.4253, 267.4354);
	angles[147] = (0, 91.0375, 0);
	at[147] = 33.5000;
	points[148] = (15559.7246, -4974.6851, 267.4354);
	angles[148] = (0, 83.3901, 0);
	at[148] = 33.6667;
	points[149] = (15292.8340, -4875.9448, 267.4354);
	angles[149] = (0, 74.4878, 0);
	at[149] = 34;
	points[150] = (14894.7246, -4717.7559, 267.4354);
	angles[150] = (0, 69.6355, 0);
	at[150] = 34.5000;
	points[151] = (14765, -4670.0396, 267.4354);
	angles[151] = (0, 69.7212, 0);
	at[151] = 34.6667;
	points[152] = (14632.6777, -4619.0552, 267.4354);
	angles[152] = (0, 69.3428, 0);
	at[152] = 34.8333;
	points[153] = (14373.3467, -4505.1968, 267.4354);
	angles[153] = (0, 67.2262, 0);
	at[153] = 35.1667;
	points[154] = (14245.1973, -4442.9526, 267.4354);
	angles[154] = (0, 65.8472, 0);
	at[154] = 35.3333;
	points[155] = (14125.0400, -4370.5908, 267.3894);
	angles[155] = (0, 62.9481, 0);
	at[155] = 35.5000;
	points[156] = (14005.2363, -4293.6221, 267.3291);
	angles[156] = (0, 60.6483, 0);
	at[156] = 35.6667;
	points[157] = (13770.6299, -4136.1416, 267.4799);
	angles[157] = (0, 57.5596, 0);
	at[157] = 36;
	points[158] = (13433.7012, -3875.6616, 269.7839);
	angles[158] = (0, 53.4547, 0);
	at[158] = 36.5000;
	points[159] = (13298.0312, -3776.5513, 270.2244);
	angles[159] = (0, 53.7132, 0);
	at[159] = 36.7000;
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
	points[0] = (804.2716, 2850.1182, 890.6733);
	angles[0] = (0, 179.6768, 0);
	at[0] = 0;
	points[1] = (802.4095, 2676.5789, 890.6733);
	angles[1] = (0, 179.3797, 0);
	at[1] = 0.2833;
	points[2] = (782.4803, 1441.3190, 890.6733);
	angles[2] = (0, 179.1659, 0);
	at[2] = 2.2667;
	points[3] = (778.9803, 1088.9528, 890.6733);
	angles[3] = (0, 179.5744, 0);
	at[3] = 2.8333;
	points[4] = (779.2047, 920.6890, 890.6733);
	angles[4] = (0, 180.0163, 0);
	at[4] = 3.1167;
	points[5] = (774.0118, 213.6409, 890.6733);
	angles[5] = (0, 179.8127, 0);
	at[5] = 4.2500;
	points[6] = (777.4567, -138.7295, 890.6733);
	angles[6] = (0, 180.8808, 0);
	at[6] = 4.8167;
	points[7] = (782.9528, -313.8130, 890.6733);
	angles[7] = (0, 181.8123, 0);
	at[7] = 5.1000;
	points[8] = (792.9409, -489.5827, 890.6733);
	angles[8] = (0, 183.3007, 0);
	at[8] = 5.3833;
	points[9] = (811.5118, -665.8779, 890.6733);
	angles[9] = (0, 186.1705, 0);
	at[9] = 5.6667;
	points[10] = (850.6693, -830.2402, 890.4645);
	angles[10] = (0, 193.8695, 0);
	at[10] = 5.9500;
	points[11] = (915.5906, -996.2362, 888.9685);
	angles[11] = (0, 200.7015, 0);
	at[11] = 6.2333;
	points[12] = (988.3426, -1156.8583, 887.0945);
	angles[12] = (0, 204.0450, 0);
	at[12] = 6.5167;
	points[13] = (1065.7559, -1314.8386, 885.2284);
	angles[13] = (0, 205.9654, 0);
	at[13] = 6.8000;
	points[14] = (1231.5985, -1626.5197, 882.2717);
	angles[14] = (0, 208.5674, 0);
	at[14] = 7.3667;
	points[15] = (1319.4882, -1779.7953, 881.5866);
	angles[15] = (0, 209.8026, 0);
	at[15] = 7.6500;
	points[16] = (1411.1929, -1930.7087, 881.8583);
	angles[16] = (0, 211.2722, 0);
	at[16] = 7.9333;
	points[17] = (1508.5828, -2078.4487, 883.8268);
	angles[17] = (0, 213.4240, 0);
	at[17] = 8.2167;
	points[18] = (1615.3781, -2216.0828, 889.7835);
	angles[18] = (0, 218.2206, 0);
	at[18] = 8.5000;
	points[19] = (1745.5039, -2324.3506, 906.0906);
	angles[19] = (0, 229.8049, 0);
	at[19] = 8.7833;
	points[20] = (1893.7245, -2417.7363, 928.5945);
	angles[20] = (0, 237.0576, 0);
	at[20] = 9.0667;
	points[21] = (2046.6260, -2502.6379, 953.2087);
	angles[21] = (0, 240.6220, 0);
	at[21] = 9.3500;
	points[22] = (2201.6812, -2582.5474, 978.8347);
	angles[22] = (0, 242.5744, 0);
	at[22] = 9.6333;
	points[23] = (2515.4253, -2734.1770, 1031.3425);
	angles[23] = (0, 244.5023, 0);
	at[23] = 10.2000;
	points[24] = (2831.2400, -2882.1616, 1082.9882);
	angles[24] = (0, 244.7961, 0);
	at[24] = 10.7667;
	points[25] = (2981.2874, -2954.7009, 1105.2914);
	angles[25] = (0, 244.3353, 0);
	at[25] = 11.0500;
	points[26] = (3141.4685, -3028.5435, 1127.9292);
	angles[26] = (0, 245.2171, 0);
	at[26] = 11.3333;
	points[27] = (3940.7480, -3386.2207, 1238.0157);
	angles[27] = (0, 245.7987, 0);
	at[27] = 12.7500;
	points[28] = (4259.6455, -3532.2756, 1281.0590);
	angles[28] = (0, 245.2062, 0);
	at[28] = 13.3167;
	points[29] = (4417.1260, -3607.0120, 1302.0316);
	angles[29] = (0, 244.5956, 0);
	at[29] = 13.6000;
	points[30] = (4574.5669, -3685.7639, 1322.6537);
	angles[30] = (0, 243.3756, 0);
	at[30] = 13.8833;
	points[31] = (4718.9766, -3768.3230, 1340.4645);
	angles[31] = (0, 240.0492, 0);
	at[31] = 14.1667;
	points[32] = (4866.8501, -3865.4370, 1356.1968);
	angles[32] = (0, 236.9793, 0);
	at[32] = 14.4500;
	points[33] = (5011.3389, -3965.6299, 1370.5276);
	angles[33] = (0, 235.4021, 0);
	at[33] = 14.7333;
	points[34] = (5296.3384, -4171.7324, 1397.9803);
	angles[34] = (0, 233.8667, 0);
	at[34] = 15.3000;
	points[35] = (5716.8501, -4490.1182, 1440.5079);
	angles[35] = (0, 232.4015, 0);
	at[35] = 16.1500;
	points[36] = (5855.1572, -4599.0161, 1456.5394);
	angles[36] = (0, 231.7777, 0);
	at[36] = 16.4333;
	points[37] = (5991.8110, -4710.8662, 1475.6576);
	angles[37] = (0, 230.6540, 0);
	at[37] = 16.7167;
	points[38] = (6112.9922, -4825.8267, 1502.5157);
	angles[38] = (0, 226.2851, 0);
	at[38] = 17;
	points[39] = (6227.9131, -4953.9370, 1536.6930);
	angles[39] = (0, 222.3015, 0);
	at[39] = 17.2833;
	points[40] = (6560.9058, -5349.0552, 1650.8583);
	angles[40] = (0, 220.2112, 0);
	at[40] = 18.1333;
	points[41] = (6673.4644, -5477.9136, 1690.1694);
	angles[41] = (0, 221.2022, 0);
	at[41] = 18.4167;
	points[42] = (6792.0864, -5603.6221, 1729.8938);
	angles[42] = (0, 223.4525, 0);
	at[42] = 18.7000;
	points[43] = (6921.2993, -5716.4961, 1768.1851);
	angles[43] = (0, 229.3827, 0);
	at[43] = 18.9833;
	points[44] = (7064.0942, -5802.6772, 1801.1260);
	angles[44] = (0, 237.9396, 0);
	at[44] = 19.2667;
	points[45] = (7217.1260, -5884.5273, 1833.5078);
	angles[45] = (0, 241.4730, 0);
	at[45] = 19.5500;
	points[46] = (7372.7954, -5962.1650, 1865.4292);
	angles[46] = (0, 243.3675, 0);
	at[46] = 19.8333;
	points[47] = (7530.3545, -6035.9053, 1897.2047);
	angles[47] = (0, 244.8751, 0);
	at[47] = 20.1167;
	points[48] = (7689.6460, -6105.3149, 1929);
	angles[48] = (0, 246.4214, 0);
	at[48] = 20.4000;
	points[49] = (7850.6694, -6169.4487, 1960.9567);
	angles[49] = (0, 248.2750, 0);
	at[49] = 20.6833;
	points[50] = (8014.1733, -6226.3779, 1993.3188);
	angles[50] = (0, 250.8223, 0);
	at[50] = 20.9667;
	points[51] = (8182.0864, -6271.6538, 2026.6456);
	angles[51] = (0, 255.0213, 0);
	at[51] = 21.2500;
	points[52] = (8354.0156, -6288.8188, 2061.2285);
	angles[52] = (0, 265.1107, 0);
	at[52] = 21.5333;
	points[53] = (8510.5127, -6237.2837, 2095.2126);
	angles[53] = (0, 286.8048, 0);
	at[53] = 21.8167;
	points[54] = (8661.3779, -6153.6221, 2129.8740);
	angles[54] = (0, 297.7122, 0);
	at[54] = 22.1000;
	points[55] = (8807.4014, -6059.0947, 2163.8032);
	angles[55] = (0, 302.4471, 0);
	at[55] = 22.3833;
	points[56] = (8949.3701, -5958.5435, 2196.7324);
	angles[56] = (0, 305.1049, 0);
	at[56] = 22.6667;
	points[57] = (9086.8105, -5854.4883, 2228.2834);
	angles[57] = (0, 307.0297, 0);
	at[57] = 22.9500;
	points[58] = (9222.4805, -5745.5513, 2258.8977);
	angles[58] = (0, 308.7054, 0);
	at[58] = 23.2333;
	points[59] = (9355.2363, -5632.4805, 2288.0315);
	angles[59] = (0, 310.3759, 0);
	at[59] = 23.5167;
	points[60] = (9483.7793, -5515.5513, 2315.0042);
	angles[60] = (0, 312.2714, 0);
	at[60] = 23.8000;
	points[61] = (9606.9297, -5393.3862, 2338.8623);
	angles[61] = (0, 314.7828, 0);
	at[61] = 24.0833;
	points[62] = (9722.9922, -5260.6694, 2357.3860);
	angles[62] = (0, 319.0056, 0);
	at[62] = 24.3667;
	points[63] = (9808.5039, -5118.8193, 2360.5276);
	angles[63] = (0, 329.7755, 0);
	at[63] = 24.6500;
	points[64] = (9864.8818, -4951.4565, 2346.1379);
	angles[64] = (0, 340.3667, 0);
	at[64] = 24.9333;
	points[65] = (9908.3076, -4780.9448, 2326.0396);
	angles[65] = (0, 345.2188, 0);
	at[65] = 25.2167;
	points[66] = (9945.3945, -4608.3467, 2303.0750);
	angles[66] = (0, 347.6763, 0);
	at[66] = 25.5000;
	points[67] = (10006.9287, -4265, 2252.9448);
	angles[67] = (0, 350.3162, 0);
	at[67] = 26.0667;
	points[68] = (10057.2441, -3920.5984, 2198.7717);
	angles[68] = (0, 352.0785, 0);
	at[68] = 26.6333;
	points[69] = (10078.8193, -3746.3308, 2170.1851);
	angles[69] = (0, 352.9226, 0);
	at[69] = 26.9167;
	points[70] = (10097.4414, -3572.3701, 2140.8701);
	angles[70] = (0, 353.8684, 0);
	at[70] = 27.2000;
	points[71] = (10112.2051, -3399.2600, 2110.7915);
	angles[71] = (0, 355.1296, 0);
	at[71] = 27.4833;
	points[72] = (10120.0400, -3224.0552, 2078.8662);
	angles[72] = (0, 357.5534, 0);
	at[72] = 27.7667;
	points[73] = (10099.0166, -3062.0356, 2043.3385);
	angles[73] = (0, 368.1783, 0);
	at[73] = 28.0500;
	points[74] = (10034.2520, -2905.6101, 1998.2677);
	angles[74] = (0, 381.4987, 0);
	at[74] = 28.3333;
	points[75] = (9948.9375, -2758.8662, 1950.0551);
	angles[75] = (0, 389.4893, 0);
	at[75] = 28.6167;
	points[76] = (9852.9922, -2619.5549, 1900.8070);
	angles[76] = (0, 394.1749, 0);
	at[76] = 28.9000;
	points[77] = (9750.9844, -2485.6929, 1851.3820);
	angles[77] = (0, 397.0935, 0);
	at[77] = 29.1833;
	points[78] = (9643.8584, -2353.2637, 1801.5511);
	angles[78] = (0, 398.8029, 0);
	at[78] = 29.4667;
	points[79] = (9539.0557, -2225.2678, 1754.8820);
	angles[79] = (0, 399.3729, 0);
	at[79] = 29.7500;
	points[80] = (9426.0244, -2098.6851, 1709.0670);
	angles[80] = (0, 401.6464, 0);
	at[80] = 30.0333;
	points[81] = (9189.6855, -1852.4056, 1617.8307);
	angles[81] = (0, 404.3226, 0);
	at[81] = 30.6000;
	points[82] = (9067.9131, -1732.8976, 1572.1102);
	angles[82] = (0, 405.5175, 0);
	at[82] = 30.8833;
	points[83] = (8943.9365, -1617.9844, 1526.3938);
	angles[83] = (0, 407.2208, 0);
	at[83] = 31.1667;
	points[84] = (8811.6533, -1510.6653, 1479.1615);
	angles[84] = (0, 411.4048, 0);
	at[84] = 31.4500;
	points[85] = (8664.8818, -1432.3032, 1431.6969);
	angles[85] = (0, 421.2431, 0);
	at[85] = 31.7333;
	points[86] = (8509.6455, -1365.7125, 1383.8307);
	angles[86] = (0, 426.2244, 0);
	at[86] = 32.0167;
	points[87] = (8351.2998, -1304.3308, 1335.6063);
	angles[87] = (0, 428.6001, 0);
	at[87] = 32.3000;
	points[88] = (8191.6533, -1246.9607, 1287.0118);
	angles[88] = (0, 430.1497, 0);
	at[88] = 32.5833;
	points[89] = (8030.7480, -1193.5984, 1237.5354);
	angles[89] = (0, 431.6341, 0);
	at[89] = 32.8667;
	points[90] = (7868.5039, -1147.4252, 1185.6378);
	angles[90] = (0, 434.3463, 0);
	at[90] = 33.1500;
	points[91] = (7712.1655, -1124.4410, 1117.1969);
	angles[91] = (0, 441.3566, 0);
	at[91] = 33.4333;
	points[92] = (7555.0391, -1116.4567, 1038.0630);
	angles[92] = (0, 446.6839, 0);
	at[92] = 33.7167;
	points[93] = (7394.9209, -1118.5748, 964.8662);
	angles[93] = (0, 450.5743, 0);
	at[93] = 34;
	points[94] = (7228.8975, -1130.8622, 908.1968);
	angles[94] = (0, 454.1647, 0);
	at[94] = 34.2833;
	points[95] = (7064.7246, -1154.6141, 884.0472);
	angles[95] = (0, 458.3204, 0);
	at[95] = 34.5667;
	points[96] = (6891.4175, -1190.9961, 882.7953);
	angles[96] = (0, 461.4850, 0);
	at[96] = 34.8500;
	points[97] = (6545.2759, -1270.2166, 891.3582);
	angles[97] = (0, 463.0079, 0);
	at[97] = 35.4167;
	points[98] = (6202.1655, -1351.1141, 905.5079);
	angles[98] = (0, 463.3009, 0);
	at[98] = 35.9833;
	points[99] = (5687.2051, -1473.1812, 934.0355);
	angles[99] = (0, 463.3026, 0);
	at[99] = 36.8333;
	points[100] = (5342.3623, -1553.3308, 959.7677);
	angles[100] = (0, 462.9597, 0);
	at[100] = 37.4000;
	points[101] = (5169.6851, -1591.1024, 977.9331);
	angles[101] = (0, 462.2784, 0);
	at[101] = 37.6833;
	points[102] = (5009.4487, -1623.9330, 1014.5315);
	angles[102] = (0, 461.9618, 0);
	at[102] = 37.9667;
	points[103] = (4851.5752, -1659.8701, 1082.1890);
	angles[103] = (0, 462.5737, 0);
	at[103] = 38.2500;
	points[104] = (4699.2520, -1687.3662, 1165.2323);
	angles[104] = (0, 459.9583, 0);
	at[104] = 38.5333;
	points[105] = (4546.3779, -1697.6693, 1250.9370);
	angles[105] = (0, 453.7465, 0);
	at[105] = 38.8167;
	points[106] = (4389.2520, -1684.1810, 1328.2716);
	angles[106] = (0, 445.1768, 0);
	at[106] = 39.1000;
	points[107] = (4238.6616, -1647.7047, 1386.7677);
	angles[107] = (0, 436.7368, 0);
	at[107] = 39.3833;
	points[108] = (4078.8582, -1596.8151, 1445.6693);
	angles[108] = (0, 432.8303, 0);
	at[108] = 39.6667;
	points[109] = (3760.0474, -1487.2795, 1562.3544);
	angles[109] = (0, 430.8319, 0);
	at[109] = 40.2333;
	points[110] = (3604.2639, -1431.8662, 1618.8031);
	angles[110] = (0, 430.4437, 0);
	at[110] = 40.5167;
	points[111] = (3444.5315, -1374.1615, 1676.2166);
	angles[111] = (0, 430.1520, 0);
	at[111] = 40.8000;
	points[112] = (2974.5276, -1199.9843, 1841.6890);
	angles[112] = (0, 429.4476, 0);
	at[112] = 41.6500;
	points[113] = (2503.2087, -1018.4134, 1999.6576);
	angles[113] = (0, 428.6475, 0);
	at[113] = 42.5000;
	points[114] = (2345.9883, -955.7205, 2049.2756);
	angles[114] = (0, 428.2578, 0);
	at[114] = 42.7833;
	points[115] = (2186.1340, -890.2205, 2096.9292);
	angles[115] = (0, 427.7152, 0);
	at[115] = 43.0667;
	points[116] = (2029.7164, -823.2677, 2138.7795);
	angles[116] = (0, 426.8140, 0);
	at[116] = 43.3500;
	points[117] = (1882.8661, -754.1102, 2167.3977);
	angles[117] = (0, 424.5453, 0);
	at[117] = 43.6333;
	points[118] = (1728.9529, -668.3976, 2179.2678);
	angles[118] = (0, 421.0767, 0);
	at[118] = 43.9167;
	points[119] = (1576.6221, -576.2008, 2181.6101);
	angles[119] = (0, 419.0021, 0);
	at[119] = 44.2000;
	points[120] = (1428.6378, -482.7914, 2178.6536);
	angles[120] = (0, 417.8409, 0);
	at[120] = 44.4833;
	points[121] = (1133.5826, -290.0185, 2162.6890);
	angles[121] = (0, 416.6445, 0);
	at[121] = 45.0500;
	points[122] = (987.5670, -192.6087, 2151.0120);
	angles[122] = (0, 416.3140, 0);
	at[122] = 45.3333;
	points[123] = (695.6929, 4.2242, 2121.2913);
	angles[123] = (0, 415.9509, 0);
	at[123] = 45.9000;
	points[124] = (552.2559, 101.3587, 2103.4961);
	angles[124] = (0, 415.9061, 0);
	at[124] = 46.1833;
	points[125] = (405.5000, 200.4409, 2082.6731);
	angles[125] = (0, 415.9893, 0);
	at[125] = 46.4667;
	points[126] = (259.3918, 297.9012, 2058.2205);
	angles[126] = (0, 416.3249, 0);
	at[126] = 46.7500;
	points[127] = (117.4193, 388.5555, 2026.9016);
	angles[127] = (0, 417.6472, 0);
	at[127] = 47.0333;
	points[128] = (-26.9123, 461.5787, 1963.2284);
	angles[128] = (0, 423.1514, 0);
	at[128] = 47.3167;
	points[129] = (-167.7598, 518.4725, 1872.8466);
	angles[129] = (0, 427.4958, 0);
	at[129] = 47.6000;
	points[130] = (-302.6673, 569.2402, 1772.6063);
	angles[130] = (0, 429.0474, 0);
	at[130] = 47.8833;
	points[131] = (-434.6221, 621.4488, 1668.2794);
	angles[131] = (0, 428.2187, 0);
	at[131] = 48.1667;
	points[132] = (-563.7756, 680.9764, 1565.3464);
	angles[132] = (0, 425.1038, 0);
	at[132] = 48.4500;
	points[133] = (-691.1653, 756.4724, 1469.1339);
	angles[133] = (0, 419.1647, 0);
	at[133] = 48.7333;
	points[134] = (-810.8898, 858.8386, 1393.7638);
	angles[134] = (0, 409.1747, 0);
	at[134] = 49.0167;
	points[135] = (-917.4291, 985.8937, 1345.8662);
	angles[135] = (0, 400.9920, 0);
	at[135] = 49.3000;
	points[136] = (-1022.8859, 1121.6024, 1303.2716);
	angles[136] = (0, 398.2159, 0);
	at[136] = 49.5833;
	points[137] = (-1123.7520, 1255.8386, 1264.2755);
	angles[137] = (0, 397.0374, 0);
	at[137] = 49.8667;
	points[138] = (-1327.4802, 1536.2047, 1188.2362);
	angles[138] = (0, 395.7566, 0);
	at[138] = 50.4333;
	points[139] = (-1622.5394, 1962.2363, 1081.6575);
	angles[139] = (0, 394.1870, 0);
	at[139] = 51.2833;
	points[140] = (-1812.2717, 2252.1062, 1014.4528);
	angles[140] = (0, 392.8514, 0);
	at[140] = 51.8500;
	points[141] = (-1904.5394, 2400.1536, 982.0355);
	angles[141] = (0, 391.9395, 0);
	at[141] = 52.1333;
	points[142] = (-1991.0197, 2545.7876, 951.7756);
	angles[142] = (0, 390.6902, 0);
	at[142] = 52.4167;
	points[143] = (-2076.6536, 2701.6182, 921.8858);
	angles[143] = (0, 388.7127, 0);
	at[143] = 52.7000;
	points[144] = (-2150.8779, 2860.9685, 895.9488);
	angles[144] = (0, 384.7275, 0);
	at[144] = 52.9833;
	points[145] = (-2195.0906, 3018.0789, 880.9094);
	angles[145] = (0, 375.9296, 0);
	at[145] = 53.2667;
	points[146] = (-2221.7913, 3191.5591, 873.4291);
	angles[146] = (0, 369.3473, 0);
	at[146] = 53.5500;
	points[147] = (-2239.1023, 3367.5156, 869.8425);
	angles[147] = (0, 365.9078, 0);
	at[147] = 53.8333;
	points[148] = (-2250.8188, 3545.6143, 868.5118);
	angles[148] = (0, 363.9104, 0);
	at[148] = 54.1167;
	points[149] = (-2258.4211, 3720.5396, 868.6812);
	angles[149] = (0, 362.5763, 0);
	at[149] = 54.4000;
	points[150] = (-2263.1104, 3897.1653, 869.9134);
	angles[150] = (0, 361.5724, 0);
	at[150] = 54.6833;
	points[151] = (-2265.4331, 4250.1968, 874.5709);
	angles[151] = (0, 360.0594, 0);
	at[151] = 55.2500;
	points[152] = (-2259.8032, 4600.7480, 881.0118);
	angles[152] = (0, 358.7778, 0);
	at[152] = 55.8167;
	points[153] = (-2245.0435, 4957.4409, 888.0906);
	angles[153] = (0, 357.1816, 0);
	at[153] = 56.3833;
	points[154] = (-2231.4646, 5132.4019, 890.5827);
	angles[154] = (0, 355.4355, 0);
	at[154] = 56.6667;
	points[155] = (-2198.7952, 5297.7163, 890.6733);
	angles[155] = (0, 348.5997, 0);
	at[155] = 56.9500;
	points[156] = (-2140.8623, 5464.3311, 890.6733);
	angles[156] = (0, 341.2816, 0);
	at[156] = 57.2333;
	points[157] = (-2068.7244, 5624.9604, 890.6733);
	angles[157] = (0, 336.1392, 0);
	at[157] = 57.5167;
	points[158] = (-1986.0198, 5780.3154, 890.6733);
	angles[158] = (0, 332.1517, 0);
	at[158] = 57.8000;
	points[159] = (-1892.9448, 5930.5117, 890.6733);
	angles[159] = (0, 328.2858, 0);
	at[159] = 58.0833;
	points[160] = (-1786.0079, 6070.9058, 890.6733);
	angles[160] = (0, 322.4692, 0);
	at[160] = 58.3667;
	points[161] = (-1648.6102, 6172.7559, 890.6733);
	angles[161] = (0, 306.7448, 0);
	at[161] = 58.6500;
	points[162] = (-1490.4725, 6250.2363, 890.6733);
	angles[162] = (0, 297.1864, 0);
	at[162] = 58.9333;
	points[163] = (-1327.0867, 6317.4019, 890.6733);
	angles[163] = (0, 292.7441, 0);
	at[163] = 59.2167;
	points[164] = (-1160.7323, 6376.8506, 890.6733);
	angles[164] = (0, 289.8136, 0);
	at[164] = 59.5000;
	points[165] = (-992.5236, 6427.4014, 890.6733);
	angles[165] = (0, 286.7115, 0);
	at[165] = 59.7833;
	points[166] = (-823.5276, 6457.2046, 890.6733);
	angles[166] = (0, 278.9390, 0);
	at[166] = 60.0667;
	points[167] = (-647.0433, 6446.1025, 890.6733);
	angles[167] = (0, 267.5030, 0);
	at[167] = 60.3500;
	points[168] = (-471.6418, 6420.9058, 890.6733);
	angles[168] = (0, 262.3532, 0);
	at[168] = 60.6333;
	points[169] = (-298.5949, 6387.8740, 890.6733);
	angles[169] = (0, 259.3732, 0);
	at[169] = 60.9167;
	points[170] = (-127.6429, 6346.9292, 890.6733);
	angles[170] = (0, 256.5564, 0);
	at[170] = 61.2000;
	points[171] = (39.1621, 6292.8745, 890.6733);
	angles[171] = (0, 251.7122, 0);
	at[171] = 61.4833;
	points[172] = (179.5339, 6193.4253, 890.6733);
	angles[172] = (0, 233.9307, 0);
	at[172] = 61.7667;
	points[173] = (293.8106, 6058.7402, 890.6733);
	angles[173] = (0, 221.7599, 0);
	at[173] = 62.0500;
	points[174] = (397.6929, 5915.8662, 890.6733);
	angles[174] = (0, 216.5334, 0);
	at[174] = 62.3333;
	points[175] = (494.1851, 5768.3467, 890.6733);
	angles[175] = (0, 213.3642, 0);
	at[175] = 62.6167;
	points[176] = (582.8937, 5615.3149, 890.6733);
	angles[176] = (0, 210.0817, 0);
	at[176] = 62.9000;
	points[177] = (648.7362, 5455.7085, 890.6733);
	angles[177] = (0, 201.8294, 0);
	at[177] = 63.1833;
	points[178] = (689.6536, 5284.0552, 890.6733);
	angles[178] = (0, 194.2629, 0);
	at[178] = 63.4667;
	points[179] = (721.9055, 5111.8896, 890.6733);
	angles[179] = (0, 190.9590, 0);
	at[179] = 63.7500;
	points[180] = (749.5512, 4937.7954, 890.6733);
	angles[180] = (0, 189.1501, 0);
	at[180] = 64.0333;
	points[181] = (773.1890, 4762.7954, 890.6733);
	angles[181] = (0, 187.7434, 0);
	at[181] = 64.3167;
	points[182] = (792.0276, 4587.5591, 890.6733);
	angles[182] = (0, 186.1291, 0);
	at[182] = 64.6000;
	points[183] = (801.8504, 4414.7246, 890.6733);
	angles[183] = (0, 183.2661, 0);
	at[183] = 64.8833;
	points[184] = (805.4567, 4240.5117, 890.6733);
	angles[184] = (0, 181.4103, 0);
	at[184] = 65.1667;
	points[185] = (807.9330, 3887.2795, 890.6733);
	angles[185] = (0, 180.2736, 0);
	at[185] = 65.7333;
	points[186] = (805.1654, 3006.3896, 890.6733);
	angles[186] = (0, 179.6713, 0);
	at[186] = 67.1500;
	points[187] = (804.2716, 2850.1182, 890.6733);
	angles[187] = (0, 179.6768, 0);
	at[187] = 67.4167;
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
