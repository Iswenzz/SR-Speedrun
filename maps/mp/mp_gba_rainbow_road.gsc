main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_gba_rainbow_road", 0);

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
	ambientPlay("iz_0_55", 2);
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
	level.iz_route[level.iz_route.size] = (8954, 1339, 427);
	level.iz_route[level.iz_route.size] = (8946, -11, 427);
	level.iz_route[level.iz_route.size] = (8845, -771, 427);
	level.iz_route[level.iz_route.size] = (8552, -1230, 427);
	level.iz_route[level.iz_route.size] = (7962, -1433, 427);
	level.iz_route[level.iz_route.size] = (6742, -1595, 427);
	level.iz_route[level.iz_route.size] = (6252, -1814, 427);
	level.iz_route[level.iz_route.size] = (6044, -2213, 427);
	level.iz_route[level.iz_route.size] = (5906, -2845, 427);
	level.iz_route[level.iz_route.size] = (5903, -3896, 427);
	level.iz_route[level.iz_route.size] = (5887, -5390, 427);
	level.iz_route[level.iz_route.size] = (5627, -5964, 427);
	level.iz_route[level.iz_route.size] = (5173, -6218, 427);
	level.iz_route[level.iz_route.size] = (4554, -6263, 427);
	level.iz_route[level.iz_route.size] = (4083, -6104, 427);
	level.iz_route[level.iz_route.size] = (3706, -5790, 427);
	level.iz_route[level.iz_route.size] = (3375, -5383, 427);
	level.iz_route[level.iz_route.size] = (3259, -4848, 427);
	level.iz_route[level.iz_route.size] = (3248, -3549, 427);
	level.iz_route[level.iz_route.size] = (3253, -2004, 427);
	level.iz_route[level.iz_route.size] = (3233, 4, 427);
	level.iz_route[level.iz_route.size] = (3249, 1449, 427);
	level.iz_route[level.iz_route.size] = (3298, 2473, 427);
	level.iz_route[level.iz_route.size] = (3220, 2822, 427);
	level.iz_route[level.iz_route.size] = (2979, 2948, 427);
	level.iz_route[level.iz_route.size] = (2663, 2944, 427);
	level.iz_route[level.iz_route.size] = (2418, 2833, 427);
	level.iz_route[level.iz_route.size] = (2188, 2599, 427);
	level.iz_route[level.iz_route.size] = (1570, 1898, 427);
	level.iz_route[level.iz_route.size] = (1125, 1385, 427);
	level.iz_route[level.iz_route.size] = (808, 1202, 427);
	level.iz_route[level.iz_route.size] = (170, 1125, 427);
	level.iz_route[level.iz_route.size] = (-616, 1096, 427);
	level.iz_route[level.iz_route.size] = (-1004, 888, 427);
	level.iz_route[level.iz_route.size] = (-2266, -254, 427);
	level.iz_route[level.iz_route.size] = (-3197, -1322, 427);
	level.iz_route[level.iz_route.size] = (-3338, -2064, 427);
	level.iz_route[level.iz_route.size] = (-3189, -2515, 427);
	level.iz_route[level.iz_route.size] = (-2493, -3155, 427);
	level.iz_route[level.iz_route.size] = (-2129, -3479, 427);
	level.iz_route[level.iz_route.size] = (-1644, -3649, 427);
	level.iz_route[level.iz_route.size] = (-1238, -3846, 427);
	level.iz_route[level.iz_route.size] = (-920, -4219, 427);
	level.iz_route[level.iz_route.size] = (-752, -4750, 427);
	level.iz_route[level.iz_route.size] = (-718, -5357, 427);
	level.iz_route[level.iz_route.size] = (-924, -5815, 427);
	level.iz_route[level.iz_route.size] = (-1591, -5984, 427);
	level.iz_route[level.iz_route.size] = (-2108, -5793, 427);
	level.iz_route[level.iz_route.size] = (-2589, -5616, 427);
	level.iz_route[level.iz_route.size] = (-3283, -5657, 427);
	level.iz_route[level.iz_route.size] = (-3718, -5981, 427);
	level.iz_route[level.iz_route.size] = (-3938, -6448, 427);
	level.iz_route[level.iz_route.size] = (-3968, -6958, 427);
	level.iz_route[level.iz_route.size] = (-4081, -7359, 427);
	level.iz_route[level.iz_route.size] = (-4301, -7585, 427);
	level.iz_route[level.iz_route.size] = (-4809, -7674, 427);
	level.iz_route[level.iz_route.size] = (-5793, -7653, 427);
	level.iz_route[level.iz_route.size] = (-6529, -7553, 427);
	level.iz_route[level.iz_route.size] = (-6853, -7242, 427);
	level.iz_route[level.iz_route.size] = (-7029, -6636, 427);
	level.iz_route[level.iz_route.size] = (-7046, -6111, 427);
	level.iz_route[level.iz_route.size] = (-7037, -5595, 427);
	level.iz_route[level.iz_route.size] = (-7012, -4491, 427);
	level.iz_route[level.iz_route.size] = (-6748, -3968, 427);
	level.iz_route[level.iz_route.size] = (-6287, -3450, 427);
	level.iz_route[level.iz_route.size] = (-6041, -2952, 427);
	level.iz_route[level.iz_route.size] = (-6005, -2345, 427);
	level.iz_route[level.iz_route.size] = (-6036, -1068, 427);
	level.iz_route[level.iz_route.size] = (-6073, 535, 427);
	level.iz_route[level.iz_route.size] = (-6061, 2093, 427);
	level.iz_route[level.iz_route.size] = (-6267, 2630, 427);
	level.iz_route[level.iz_route.size] = (-7030, 3467, 427);
	level.iz_route[level.iz_route.size] = (-8233, 4497, 427);
	level.iz_route[level.iz_route.size] = (-8770, 5129, 427);
	level.iz_route[level.iz_route.size] = (-8987, 5633, 427);
	level.iz_route[level.iz_route.size] = (-9001, 6301, 427);
	level.iz_route[level.iz_route.size] = (-8753, 6868, 427);
	level.iz_route[level.iz_route.size] = (-7417, 7119, 427);
	level.iz_route[level.iz_route.size] = (-5396, 7090, 427);
	level.iz_route[level.iz_route.size] = (-4061, 7096, 473);
	level.iz_route[level.iz_route.size] = (-1666, 7102, 427);
	level.iz_route[level.iz_route.size] = (1268, 7122, 427);
	level.iz_route[level.iz_route.size] = (2326, 7094, 427);
	level.iz_route[level.iz_route.size] = (3655, 7077, 471);
	level.iz_route[level.iz_route.size] = (5479, 7074, 427);
	level.iz_route[level.iz_route.size] = (7808, 7075, 427);
	level.iz_route[level.iz_route.size] = (8241, 6880, 427);
	level.iz_route[level.iz_route.size] = (8605, 6505, 427);
	level.iz_route[level.iz_route.size] = (8849, 6102, 427);
	level.iz_route[level.iz_route.size] = (8891, 5694, 427);
	level.iz_route[level.iz_route.size] = (8902, 4655, 427);
	level.iz_route[level.iz_route.size] = (8951, 2694, 427);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (1366.5669, 1610.6141, 4987.8350);
	angles[0] = (0, -154.0234, 0);
	at[0] = 0;
	points[1] = (1366.5669, 1610.6141, 4987.8350);
	angles[1] = (0, -154.0234, 0);
	at[1] = 0.1000;
	points[2] = (1476.4174, 1385.1536, 4689.2520);
	angles[2] = (0, -154.0234, 0);
	at[2] = 0.7000;
	points[3] = (1566.4607, 1200.3425, 4444.5273);
	angles[3] = (0, -154.0234, 0);
	at[3] = 1.2000;
	points[4] = (1672.7166, 982.2637, 4155.7480);
	angles[4] = (0, -154.0234, 0);
	at[4] = 1.8000;
	points[5] = (1777.0079, 768.2126, 3872.2915);
	angles[5] = (0, -154.0234, 0);
	at[5] = 2.4000;
	points[6] = (1879.3386, 558.1851, 3594.1655);
	angles[6] = (0, -154.0234, 0);
	at[6] = 3;
	points[7] = (1979.7086, 352.1831, 3321.3740);
	angles[7] = (0, -154.0234, 0);
	at[7] = 3.6000;
	points[8] = (2078.1143, 150.2083, 3053.9133);
	angles[8] = (0, -154.0234, 0);
	at[8] = 4.2000;
	points[9] = (2174.5630, -47.7402, 2791.7834);
	angles[9] = (0, -154.0234, 0);
	at[9] = 4.8000;
	points[10] = (2253.4370, -209.6217, 2577.4175);
	angles[10] = (0, -154.0234, 0);
	at[10] = 5.3000;
	points[11] = (2330.9451, -368.7067, 2366.7520);
	angles[11] = (0, -154.0234, 0);
	at[11] = 5.8000;
	points[12] = (2407.0945, -524.9961, 2159.7874);
	angles[12] = (0, -154.0234, 0);
	at[12] = 6.3000;
	points[13] = (2481.8818, -678.4882, 1956.5276);
	angles[13] = (0, -154.0234, 0);
	at[13] = 6.8000;
	points[14] = (2555.3032, -829.1851, 1756.9725);
	angles[14] = (0, -154.0234, 0);
	at[14] = 7.3000;
	points[15] = (2627.3662, -977.0867, 1561.1182);
	angles[15] = (0, -154.0234, 0);
	at[15] = 7.8000;
	points[16] = (2698.0630, -1122.1930, 1368.9646);
	angles[16] = (0, -154.0234, 0);
	at[16] = 8.3000;
	points[17] = (2781.1062, -1292.6260, 1143.2717);
	angles[17] = (0, -154.0234, 0);
	at[17] = 8.9000;
	points[18] = (2848.8071, -1431.5787, 959.2637);
	angles[18] = (0, -154.0234, 0);
	at[18] = 9.4000;
	points[19] = (2915.1458, -1567.7362, 778.9607);
	angles[19] = (0, -154.0234, 0);
	at[19] = 9.9000;
	points[20] = (2980.1221, -1701.0946, 602.3622);
	angles[20] = (0, -154.0234, 0);
	at[20] = 10.4000;
	points[21] = (3043.7361, -1831.6615, 429.4646);
	angles[21] = (0, -154.0234, 0);
	at[21] = 10.9000;
	points[22] = (3043.7361, -1831.6615, 429.4646);
	angles[22] = (0, -154.0234, 0);
	at[22] = 12.2500;
	points[23] = (1366.5669, 1610.6141, 4987.8350);
	angles[23] = (0, -154.0234, 0);
	at[23] = 12.2500;
	points[24] = (1366.5669, 1610.6141, 4987.8350);
	angles[24] = (0, -154.0234, 0);
	at[24] = 23.7333;
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
	points[0] = (1366.5669, 1610.6141, 4987.8350);
	angles[0] = (0, -154.0234, 0);
	at[0] = 0;
	points[1] = (1366.5669, 1610.6141, 4987.8350);
	angles[1] = (0, -154.0234, 0);
	at[1] = 6;
	points[2] = (1378.8701, 1585.3661, 4954.3701);
	angles[2] = (0, -154.0234, 0);
	at[2] = 6.1000;
	points[3] = (1488.5000, 1360.3503, 4656.4175);
	angles[3] = (0, -154.0234, 0);
	at[3] = 6.7000;
	points[4] = (1596.1733, 1139.3622, 4363.7793);
	angles[4] = (0, -154.0234, 0);
	at[4] = 7.3000;
	points[5] = (1701.8818, 922.4016, 4076.4568);
	angles[5] = (0, -154.0234, 0);
	at[5] = 7.9000;
	points[6] = (1805.6299, 709.4645, 3794.5002);
	angles[6] = (0, -154.0234, 0);
	at[6] = 8.5000;
	points[7] = (1890.5867, 535.0945, 3563.5945);
	angles[7] = (0, -154.0234, 0);
	at[7] = 9;
	points[8] = (1974.1851, 363.5217, 3336.3899);
	angles[8] = (0, -154.0234, 0);
	at[8] = 9.5000;
	points[9] = (2056.4175, 194.7433, 3112.8896);
	angles[9] = (0, -154.0234, 0);
	at[9] = 10;
	points[10] = (2137.2876, 28.7613, 2893.0906);
	angles[10] = (0, -154.0234, 0);
	at[10] = 10.5000;
	points[11] = (2232.5356, -166.7268, 2634.2207);
	angles[11] = (0, -154.0234, 0);
	at[11] = 11.1000;
	points[12] = (2310.4094, -326.5575, 2422.5669);
	angles[12] = (0, -154.0234, 0);
	at[12] = 11.6000;
	points[13] = (2386.9214, -483.5906, 2214.6182);
	angles[13] = (0, -154.0234, 0);
	at[13] = 12.1000;
	points[14] = (2462.0708, -637.8307, 2010.3701);
	angles[14] = (0, -154.0234, 0);
	at[14] = 12.6000;
	points[15] = (2535.8582, -789.2717, 1809.8229);
	angles[15] = (0, -154.0234, 0);
	at[15] = 13.1000;
	points[16] = (2622.6023, -967.3149, 1574.0590);
	angles[16] = (0, -154.0234, 0);
	at[16] = 13.7000;
	points[17] = (2693.3938, -1112.6063, 1381.6615);
	angles[17] = (0, -154.0234, 0);
	at[17] = 14.2000;
	points[18] = (2762.8228, -1255.0984, 1192.9646);
	angles[18] = (0, -154.0234, 0);
	at[18] = 14.7000;
	points[19] = (2830.8860, -1394.7992, 1007.9725);
	angles[19] = (0, -154.0234, 0);
	at[19] = 15.2000;
	points[20] = (2910.7678, -1558.7440, 790.8661);
	angles[20] = (0, -154.0234, 0);
	at[20] = 15.8000;
	points[21] = (2975.8345, -1692.2914, 614.0197);
	angles[21] = (0, -154.0234, 0);
	at[21] = 16.3000;
	points[22] = (3039.5393, -1823.0433, 440.8740);
	angles[22] = (0, -154.0234, 0);
	at[22] = 16.8000;
	points[23] = (3043.7361, -1831.6615, 429.4646);
	angles[23] = (0, -154.0234, 0);
	at[23] = 16.9000;
	points[24] = (3043.7361, -1831.6615, 429.4646);
	angles[24] = (0, -154.0234, 0);
	at[24] = 18.1833;
	points[25] = (1366.5669, 1610.6141, 4987.8350);
	angles[25] = (0, -154.0234, 0);
	at[25] = 18.1833;
	points[26] = (1366.5669, 1610.6141, 4987.8350);
	angles[26] = (0, -154.0234, 0);
	at[26] = 23.7333;
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
	points[0] = (3043.7361, -1831.6615, 429.4646);
	angles[0] = (0, -154.0234, 0);
	at[0] = 0;
	points[1] = (3043.7361, -1831.6615, 429.4646);
	angles[1] = (0, -154.0234, 0);
	at[1] = 0.3833;
	points[2] = (1366.5669, 1610.6141, 4987.8350);
	angles[2] = (0, -154.0234, 0);
	at[2] = 0.3833;
	points[3] = (1366.5669, 1610.6141, 4987.8350);
	angles[3] = (0, -154.0234, 0);
	at[3] = 11.9000;
	points[4] = (1372.7205, 1597.9843, 4971.1025);
	angles[4] = (0, -154.0234, 0);
	at[4] = 12;
	points[5] = (1464.3071, 1410.0039, 4722.1655);
	angles[5] = (0, -154.0234, 0);
	at[5] = 12.5000;
	points[6] = (1554.5315, 1224.8229, 4476.9683);
	angles[6] = (0, -154.0234, 0);
	at[6] = 13;
	points[7] = (1713.5079, 898.5433, 4044.8818);
	angles[7] = (0, -154.0234, 0);
	at[7] = 13.9000;
	points[8] = (1799.9174, 721.1890, 3810.0234);
	angles[8] = (0, -154.0234, 0);
	at[8] = 14.4000;
	points[9] = (1884.9685, 546.6339, 3578.8740);
	angles[9] = (0, -154.0234, 0);
	at[9] = 14.9000;
	points[10] = (1968.6536, 374.8732, 3351.4211);
	angles[10] = (0, -154.0234, 0);
	at[10] = 15.4000;
	points[11] = (2050.9763, 205.9083, 3127.6733);
	angles[11] = (0, -154.0234, 0);
	at[11] = 15.9000;
	points[12] = (2131.9409, 39.7398, 2907.6299);
	angles[12] = (0, -154.0234, 0);
	at[12] = 16.4000;
	points[13] = (2211.5393, -123.6331, 2691.2834);
	angles[13] = (0, -154.0234, 0);
	at[13] = 16.9000;
	points[14] = (2351.3860, -410.6575, 2311.2007);
	angles[14] = (0, -154.0234, 0);
	at[14] = 17.8000;
	points[15] = (2427.1694, -566.2008, 2105.2244);
	angles[15] = (0, -154.0234, 0);
	at[15] = 18.3000;
	points[16] = (2501.5945, -718.9488, 1902.9528);
	angles[16] = (0, -154.0234, 0);
	at[16] = 18.8000;
	points[17] = (2632.1223, -986.8465, 1548.1930);
	angles[17] = (0, -154.0234, 0);
	at[17] = 19.7000;
	points[18] = (2730.5906, -1188.9489, 1280.5591);
	angles[18] = (0, -154.0234, 0);
	at[18] = 20.4000;
	points[19] = (2839.8584, -1413.2126, 983.5867);
	angles[19] = (0, -154.0234, 0);
	at[19] = 21.2000;
	points[20] = (2945.6377, -1630.3188, 696.0866);
	angles[20] = (0, -154.0234, 0);
	at[20] = 22;
	points[21] = (3035.3347, -1814.4135, 452.3031);
	angles[21] = (0, -154.0234, 0);
	at[21] = 22.7000;
	points[22] = (3043.7361, -1831.6615, 429.4646);
	angles[22] = (0, -154.0234, 0);
	at[22] = 22.8000;
	points[23] = (3043.7361, -1831.6615, 429.4646);
	angles[23] = (0, -154.0234, 0);
	at[23] = 23.7333;
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
	points[0] = (2351.3860, -410.6575, 2311.2007);
	angles[0] = (0, -154.0234, 0);
	at[0] = 0;
	points[1] = (2442.1653, -596.9725, 2064.4724);
	angles[1] = (0, -154.0234, 0);
	at[1] = 0.6000;
	points[2] = (2530.9805, -779.2638, 1823.0787);
	angles[2] = (0, -154.0234, 0);
	at[2] = 1.2000;
	points[3] = (2632.1223, -986.8465, 1548.1930);
	angles[3] = (0, -154.0234, 0);
	at[3] = 1.9000;
	points[4] = (2716.6890, -1160.4135, 1318.3503);
	angles[4] = (0, -154.0234, 0);
	at[4] = 2.5000;
	points[5] = (2799.2913, -1329.9528, 1093.8386);
	angles[5] = (0, -154.0234, 0);
	at[5] = 3.1000;
	points[6] = (2879.9331, -1495.4645, 874.6614);
	angles[6] = (0, -154.0234, 0);
	at[6] = 3.7000;
	points[7] = (2958.6143, -1656.9529, 660.8189);
	angles[7] = (0, -154.0234, 0);
	at[7] = 4.3000;
	points[8] = (3035.3347, -1814.4135, 452.3031);
	angles[8] = (0, -154.0234, 0);
	at[8] = 4.9000;
	points[9] = (3043.7361, -1831.6615, 429.4646);
	angles[9] = (0, -154.0234, 0);
	at[9] = 5;
	points[10] = (3043.7361, -1831.6615, 429.4646);
	angles[10] = (0, -154.0234, 0);
	at[10] = 6.3167;
	points[11] = (1366.5669, 1610.6141, 4987.8350);
	angles[11] = (0, -154.0234, 0);
	at[11] = 6.3167;
	points[12] = (1366.5669, 1610.6141, 4987.8350);
	angles[12] = (0, -154.0234, 0);
	at[12] = 17.9000;
	points[13] = (1494.5355, 1347.9685, 4640.0396);
	angles[13] = (0, -154.0234, 0);
	at[13] = 18.6000;
	points[14] = (1619.8346, 1090.8031, 4299.4883);
	angles[14] = (0, -154.0234, 0);
	at[14] = 19.3000;
	points[15] = (1759.7639, 803.6063, 3919.1653);
	angles[15] = (0, -154.0234, 0);
	at[15] = 20.1000;
	points[16] = (1879.3386, 558.1851, 3594.1655);
	angles[16] = (0, -154.0234, 0);
	at[16] = 20.8000;
	points[17] = (2012.7283, 284.4106, 3231.6299);
	angles[17] = (0, -154.0234, 0);
	at[17] = 21.6000;
	points[18] = (2126.5828, 50.7307, 2922.1809);
	angles[18] = (0, -154.0234, 0);
	at[18] = 22.3000;
	points[19] = (2237.7676, -177.4689, 2619.9922);
	angles[19] = (0, -154.0234, 0);
	at[19] = 23;
	points[20] = (2351.3860, -410.6575, 2311.2007);
	angles[20] = (0, -154.0234, 0);
	at[20] = 23.7333;
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
	points[0] = (4607.5591, 2372.8228, 6255.8662);
	angles[0] = (0, 155.9245, 0);
	at[0] = 0;
	points[1] = (4607.5591, 2372.8228, 6255.8662);
	angles[1] = (0, 155.9245, 0);
	at[1] = 0.2333;
	points[2] = (4598.3462, 2352.2046, 6206.2207);
	angles[2] = (0, 155.9245, 0);
	at[2] = 0.3500;
	points[3] = (4534.6851, 2209.7756, 5863.1890);
	angles[3] = (0, 155.9245, 0);
	at[3] = 0.9333;
	points[4] = (4472.5591, 2070.6812, 5528.1890);
	angles[4] = (0, 155.9245, 0);
	at[4] = 1.5167;
	points[5] = (4399.9214, 1908.1654, 5136.7715);
	angles[5] = (0, 155.9245, 0);
	at[5] = 2.2167;
	points[6] = (4341.0630, 1776.4016, 4819.4097);
	angles[6] = (0, 155.9245, 0);
	at[6] = 2.8000;
	points[7] = (4283.6616, 1647.9725, 4510.0786);
	angles[7] = (0, 155.9245, 0);
	at[7] = 3.3833;
	points[8] = (4227.7954, 1522.8740, 4208.8188);
	angles[8] = (0, 155.9245, 0);
	at[8] = 3.9667;
	points[9] = (4162.6772, 1377.1534, 3857.8467);
	angles[9] = (0, 155.9245, 0);
	at[9] = 4.6667;
	points[10] = (4110.0791, 1259.3898, 3574.2129);
	angles[10] = (0, 155.9245, 0);
	at[10] = 5.2500;
	points[11] = (4069.0549, 1167.5787, 3353.0869);
	angles[11] = (0, 155.9245, 0);
	at[11] = 5.7167;
	points[12] = (4028.9763, 1077.8976, 3137.0984);
	angles[12] = (0, 155.9245, 0);
	at[12] = 6.1833;
	points[13] = (3989.8428, 990.3544, 2926.2480);
	angles[13] = (0, 155.9245, 0);
	at[13] = 6.6500;
	points[14] = (3951.6931, 904.9410, 2720.5315);
	angles[14] = (0, 155.9245, 0);
	at[14] = 7.1167;
	points[15] = (3923.6929, 842.2795, 2569.6182);
	angles[15] = (0, 155.9245, 0);
	at[15] = 7.4667;
	points[16] = (3887.1970, 760.6024, 2372.8977);
	angles[16] = (0, 155.9245, 0);
	at[16] = 7.9333;
	points[17] = (3851.6536, 681.0551, 2181.3110);
	angles[17] = (0, 155.9245, 0);
	at[17] = 8.4000;
	points[18] = (3817.0669, 603.6418, 1994.8662);
	angles[18] = (0, 155.9245, 0);
	at[18] = 8.8667;
	points[19] = (3775.1692, 509.8740, 1769.0315);
	angles[19] = (0, 155.9245, 0);
	at[19] = 9.4500;
	points[20] = (3734.7637, 419.4409, 1551.2284);
	angles[20] = (0, 155.9245, 0);
	at[20] = 10.0333;
	points[21] = (3695.8464, 332.3417, 1341.4489);
	angles[21] = (0, 155.9245, 0);
	at[21] = 10.6167;
	points[22] = (3658.4211, 248.5756, 1139.7008);
	angles[22] = (0, 155.9245, 0);
	at[22] = 11.2000;
	points[23] = (3629.5510, 183.9626, 984.0866);
	angles[23] = (0, 155.9245, 0);
	at[23] = 11.6667;
	points[24] = (3594.8032, 106.1969, 796.7874);
	angles[24] = (0, 155.9245, 0);
	at[24] = 12.2500;
	points[25] = (3561.5474, 31.7650, 617.5236);
	angles[25] = (0, 155.9245, 0);
	at[25] = 12.8333;
	points[26] = (3529.7798, -39.3330, 446.2835);
	angles[26] = (0, 155.9245, 0);
	at[26] = 13.4167;
	points[27] = (3526.2439, -47.2465, 427.2244);
	angles[27] = (0, 155.9245, 0);
	at[27] = 13.5333;
	points[28] = (3526.2439, -47.2465, 427.2244);
	angles[28] = (0, 155.9245, 0);
	at[28] = 14.8333;
	points[29] = (4607.5591, 2372.8228, 6255.8662);
	angles[29] = (0, 155.9245, 0);
	at[29] = 14.8333;
	points[30] = (4607.5591, 2372.8228, 6255.8662);
	angles[30] = (0, 155.9245, 0);
	at[30] = 26.8000;
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
	points[0] = (4607.5591, 2372.8228, 6255.8662);
	angles[0] = (0, 155.9245, 0);
	at[0] = 0;
	points[1] = (4607.5591, 2372.8228, 6255.8662);
	angles[1] = (0, 155.9245, 0);
	at[1] = 9.1000;
	points[2] = (4605.7090, 2368.6929, 6245.9453);
	angles[2] = (0, 155.9245, 0);
	at[2] = 9.2167;
	points[3] = (4541.8896, 2225.8857, 5901.9688);
	angles[3] = (0, 155.9245, 0);
	at[3] = 9.8000;
	points[4] = (4491.9292, 2114.0354, 5632.5981);
	angles[4] = (0, 155.9245, 0);
	at[4] = 10.2667;
	points[5] = (4442.9136, 2004.3229, 5368.3467);
	angles[5] = (0, 155.9245, 0);
	at[5] = 10.7333;
	points[6] = (4394.8423, 1896.7402, 5109.2520);
	angles[6] = (0, 155.9245, 0);
	at[6] = 11.2000;
	points[7] = (4347.7168, 1791.2913, 4855.2754);
	angles[7] = (0, 155.9245, 0);
	at[7] = 11.6667;
	points[8] = (4290.1577, 1662.4803, 4545.0396);
	angles[8] = (0, 155.9245, 0);
	at[8] = 12.2500;
	points[9] = (4245.1968, 1561.8308, 4302.6382);
	angles[9] = (0, 155.9245, 0);
	at[9] = 12.7167;
	points[10] = (4190.3149, 1439.0198, 4006.8506);
	angles[10] = (0, 155.9245, 0);
	at[10] = 13.3000;
	points[11] = (4136.9292, 1319.5394, 3719.0789);
	angles[11] = (0, 155.9245, 0);
	at[11] = 13.8833;
	points[12] = (4095.3152, 1226.3544, 3494.6497);
	angles[12] = (0, 155.9245, 0);
	at[12] = 14.3500;
	points[13] = (4054.6064, 1135.3032, 3275.3584);
	angles[13] = (0, 155.9245, 0);
	at[13] = 14.8167;
	points[14] = (4005.1184, 1024.4922, 3008.4685);
	angles[14] = (0, 155.9245, 0);
	at[14] = 15.4000;
	points[15] = (3966.5750, 938.2402, 2800.7363);
	angles[15] = (0, 155.9245, 0);
	at[15] = 15.8667;
	points[16] = (3919.7363, 833.4252, 2548.2954);
	angles[16] = (0, 155.9245, 0);
	at[16] = 16.4500;
	points[17] = (3883.3425, 751.9764, 2352.1221);
	angles[17] = (0, 155.9245, 0);
	at[17] = 16.9167;
	points[18] = (3839.1931, 653.1614, 2114.1340);
	angles[18] = (0, 155.9245, 0);
	at[18] = 17.5000;
	points[19] = (3796.5315, 557.6811, 1884.1733);
	angles[19] = (0, 155.9245, 0);
	at[19] = 18.0833;
	points[20] = (3755.3584, 465.5315, 1662.2362);
	angles[20] = (0, 155.9245, 0);
	at[20] = 18.6667;
	points[21] = (3715.6731, 376.7193, 1448.3308);
	angles[21] = (0, 155.9245, 0);
	at[21] = 19.2500;
	points[22] = (3670.0198, 274.5429, 1202.2441);
	angles[22] = (0, 155.9245, 0);
	at[22] = 19.9500;
	points[23] = (3633.6143, 193.0626, 1006);
	angles[23] = (0, 155.9245, 0);
	at[23] = 20.5333;
	points[24] = (3591.8938, 99.6862, 781.1103);
	angles[24] = (0, 155.9245, 0);
	at[24] = 21.2333;
	points[25] = (3558.7639, 25.5402, 602.5315);
	angles[25] = (0, 155.9245, 0);
	at[25] = 21.8167;
	points[26] = (3527.1260, -45.2720, 431.9803);
	angles[26] = (0, 155.9245, 0);
	at[26] = 22.4000;
	points[27] = (3526.2439, -47.2465, 427.2244);
	angles[27] = (0, 155.9245, 0);
	at[27] = 22.5167;
	points[28] = (3526.2439, -47.2465, 427.2244);
	angles[28] = (0, 155.9245, 0);
	at[28] = 23.7667;
	points[29] = (4607.5591, 2372.8228, 6255.8662);
	angles[29] = (0, 155.9245, 0);
	at[29] = 23.7667;
	points[30] = (4607.5591, 2372.8228, 6255.8662);
	angles[30] = (0, 155.9245, 0);
	at[30] = 26.8000;
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
	points[0] = (3812.2009, 592.7559, 1968.6497);
	angles[0] = (0, 155.9245, 0);
	at[0] = 0;
	points[1] = (3770.4766, 499.3701, 1743.7322);
	angles[1] = (0, 155.9245, 0);
	at[1] = 0.5833;
	points[2] = (3730.2402, 409.3189, 1526.8464);
	angles[2] = (0, 155.9245, 0);
	at[2] = 1.1667;
	points[3] = (3691.4922, 322.5996, 1317.9882);
	angles[3] = (0, 155.9245, 0);
	at[3] = 1.7500;
	points[4] = (3654.2361, 239.2146, 1117.1575);
	angles[4] = (0, 155.9245, 0);
	at[4] = 2.3333;
	points[5] = (3618.4688, 159.1626, 924.3543);
	angles[5] = (0, 155.9245, 0);
	at[5] = 2.9167;
	points[6] = (3590.9253, 97.5217, 775.8937);
	angles[6] = (0, 155.9245, 0);
	at[6] = 3.3833;
	points[7] = (3557.8425, 23.4707, 597.5472);
	angles[7] = (0, 155.9245, 0);
	at[7] = 3.9667;
	points[8] = (3526.2439, -47.2465, 427.2244);
	angles[8] = (0, 155.9245, 0);
	at[8] = 4.5500;
	points[9] = (3526.2439, -47.2465, 427.2244);
	angles[9] = (0, 155.9245, 0);
	at[9] = 5.9000;
	points[10] = (4607.5591, 2372.8228, 6255.8662);
	angles[10] = (0, 155.9245, 0);
	at[10] = 5.9000;
	points[11] = (4607.5591, 2372.8228, 6255.8662);
	angles[11] = (0, 155.9245, 0);
	at[11] = 18.0833;
	points[12] = (4600.1968, 2356.3230, 6216.1416);
	angles[12] = (0, 155.9245, 0);
	at[12] = 18.2000;
	points[13] = (4536.4961, 2213.7993, 5872.8745);
	angles[13] = (0, 155.9245, 0);
	at[13] = 18.7833;
	points[14] = (4474.2915, 2074.6062, 5537.6382);
	angles[14] = (0, 155.9245, 0);
	at[14] = 19.3667;
	points[15] = (4413.5830, 1938.7521, 5210.4331);
	angles[15] = (0, 155.9245, 0);
	at[15] = 19.9500;
	points[16] = (4342.7168, 1780.1182, 4828.3857);
	angles[16] = (0, 155.9245, 0);
	at[16] = 20.6500;
	points[17] = (4296.6538, 1677.0315, 4580.0786);
	angles[17] = (0, 155.9245, 0);
	at[17] = 21.1167;
	points[18] = (4251.5747, 1576.0787, 4336.9292);
	angles[18] = (0, 155.9245, 0);
	at[18] = 21.5833;
	points[19] = (4207.4014, 1477.2560, 4098.9370);
	angles[19] = (0, 155.9245, 0);
	at[19] = 22.0500;
	points[20] = (4153.5435, 1356.7323, 3808.6536);
	angles[20] = (0, 155.9245, 0);
	at[20] = 22.6333;
	points[21] = (4101.1812, 1239.5354, 3526.3977);
	angles[21] = (0, 155.9245, 0);
	at[21] = 23.2167;
	points[22] = (4060.3545, 1148.1810, 3306.3699);
	angles[22] = (0, 155.9245, 0);
	at[22] = 23.6833;
	points[23] = (4020.5120, 1058.9607, 3091.4841);
	angles[23] = (0, 155.9245, 0);
	at[23] = 24.1500;
	points[24] = (3972.0078, 950.4331, 2830.0984);
	angles[24] = (0, 155.9245, 0);
	at[24] = 24.7333;
	points[25] = (3934.2952, 866.0079, 2626.7678);
	angles[25] = (0, 155.9245, 0);
	at[25] = 25.2000;
	points[26] = (3888.4844, 763.4803, 2379.8347);
	angles[26] = (0, 155.9245, 0);
	at[26] = 25.7833;
	points[27] = (3852.9055, 683.8583, 2188.0669);
	angles[27] = (0, 155.9245, 0);
	at[27] = 26.2500;
	points[28] = (3812.2009, 592.7559, 1968.6497);
	angles[28] = (0, 155.9245, 0);
	at[28] = 26.8000;
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
	points[0] = (-5176.2993, -2683.1653, 8283.5430);
	angles[0] = (0, 17.2315, 0);
	at[0] = 0;
	points[1] = (-5176.2993, -2683.1653, 8283.5430);
	angles[1] = (0, 17.2315, 0);
	at[1] = 0.2000;
	points[2] = (-5187.2051, -2647.9448, 8188.8188);
	angles[2] = (0, 17.2315, 0);
	at[2] = 0.3000;
	points[3] = (-5213.1890, -2564.1299, 7963.3467);
	angles[3] = (0, 17.2315, 0);
	at[3] = 0.5000;
	points[4] = (-5251.6143, -2440.3071, 7630.2759);
	angles[4] = (0, 17.2315, 0);
	at[4] = 0.8000;
	points[5] = (-5301.7324, -2278.7520, 7195.6694);
	angles[5] = (0, 17.2315, 0);
	at[5] = 1.2000;
	points[6] = (-5326.2988, -2199.4922, 6982.4805);
	angles[6] = (0, 17.2315, 0);
	at[6] = 1.4000;
	points[7] = (-5362.5986, -2082.5039, 6667.7954);
	angles[7] = (0, 17.2315, 0);
	at[7] = 1.7000;
	points[8] = (-5409.8818, -1930.0590, 6257.7168);
	angles[8] = (0, 17.2315, 0);
	at[8] = 2.1000;
	points[9] = (-5455.9058, -1781.6615, 5858.5039);
	angles[9] = (0, 17.2315, 0);
	at[9] = 2.5000;
	points[10] = (-5489.6064, -1673.0198, 5566.2598);
	angles[10] = (0, 17.2315, 0);
	at[10] = 2.8000;
	points[11] = (-5511.6538, -1601.8583, 5374.8423);
	angles[11] = (0, 17.2315, 0);
	at[11] = 3;
	points[12] = (-5533.4253, -1531.7086, 5186.1416);
	angles[12] = (0, 17.2315, 0);
	at[12] = 3.2000;
	points[13] = (-5565.4727, -1428.3818, 4908.1890);
	angles[13] = (0, 17.2315, 0);
	at[13] = 3.5000;
	points[14] = (-5607.0864, -1294.1576, 4547.1260);
	angles[14] = (0, 17.2315, 0);
	at[14] = 3.9000;
	points[15] = (-5637.4805, -1196.1456, 4283.5039);
	angles[15] = (0, 17.2315, 0);
	at[15] = 4.2000;
	points[16] = (-5676.9292, -1069.0039, 3941.4961);
	angles[16] = (0, 17.2315, 0);
	at[16] = 4.6000;
	points[17] = (-5705.6694, -976.3071, 3692.1299);
	angles[17] = (0, 17.2315, 0);
	at[17] = 4.9000;
	points[18] = (-5742.9131, -856.2520, 3369.1851);
	angles[18] = (0, 17.2315, 0);
	at[18] = 5.3000;
	points[19] = (-5778.8975, -740.2480, 3057.1338);
	angles[19] = (0, 17.2315, 0);
	at[19] = 5.7000;
	points[20] = (-5805.0396, -655.9016, 2830.2402);
	angles[20] = (0, 17.2315, 0);
	at[20] = 6;
	points[21] = (-5830.5117, -573.8307, 2609.4763);
	angles[21] = (0, 17.2315, 0);
	at[21] = 6.3000;
	points[22] = (-5863.3467, -467.9488, 2324.6575);
	angles[22] = (0, 17.2315, 0);
	at[22] = 6.7000;
	points[23] = (-5894.9214, -366.1173, 2050.7285);
	angles[23] = (0, 17.2315, 0);
	at[23] = 7.1000;
	points[24] = (-5925.2363, -268.3347, 1787.6969);
	angles[24] = (0, 17.2315, 0);
	at[24] = 7.5000;
	points[25] = (-5954.3311, -174.6020, 1535.5591);
	angles[25] = (0, 17.2315, 0);
	at[25] = 7.9000;
	points[26] = (-5982.1260, -84.9193, 1294.3110);
	angles[26] = (0, 17.2315, 0);
	at[26] = 8.3000;
	points[27] = (-6008.7012, 0.7134, 1063.9606);
	angles[27] = (0, 17.2315, 0);
	at[27] = 8.7000;
	points[28] = (-6034.0161, 82.2957, 844.5079);
	angles[28] = (0, 17.2315, 0);
	at[28] = 9.1000;
	points[29] = (-6058.0312, 159.8268, 635.9488);
	angles[29] = (0, 17.2315, 0);
	at[29] = 9.5000;
	points[30] = (-6080.8271, 233.3079, 438.2874);
	angles[30] = (0, 17.2315, 0);
	at[30] = 9.9000;
	points[31] = (-6081.7720, 236.2815, 430.2874);
	angles[31] = (0, 17.2315, 0);
	at[31] = 10;
	points[32] = (-6081.7720, 236.2815, 430.2874);
	angles[32] = (0, 17.2315, 0);
	at[32] = 11.2667;
	points[33] = (-5176.2993, -2683.1653, 8283.5430);
	angles[33] = (0, 17.2315, 0);
	at[33] = 11.2667;
	points[34] = (-5176.2993, -2683.1653, 8283.5430);
	angles[34] = (0, 17.2315, 0);
	at[34] = 20.3000;
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
	points[0] = (-5176.2993, -2683.1653, 8283.5430);
	angles[0] = (0, 17.2315, 0);
	at[0] = 0;
	points[1] = (-5176.2993, -2683.1653, 8283.5430);
	angles[1] = (0, 17.2315, 0);
	at[1] = 6.9000;
	points[2] = (-5178.4648, -2676.1062, 8264.5674);
	angles[2] = (0, 17.2315, 0);
	at[2] = 7;
	points[3] = (-5230.3545, -2508.8149, 7814.5674);
	angles[3] = (0, 17.2315, 0);
	at[3] = 7.4000;
	points[4] = (-5280.9839, -2345.5747, 7375.4331);
	angles[4] = (0, 17.2315, 0);
	at[4] = 7.8000;
	points[5] = (-5330.3545, -2186.3818, 6947.2046);
	angles[5] = (0, 17.2315, 0);
	at[5] = 8.2000;
	points[6] = (-5378.5039, -2031.2401, 6529.8818);
	angles[6] = (0, 17.2315, 0);
	at[6] = 8.6000;
	points[7] = (-5425.3545, -1880.1417, 6123.4253);
	angles[7] = (0, 17.2315, 0);
	at[7] = 9;
	points[8] = (-5470.9453, -1733.0945, 5727.8745);
	angles[8] = (0, 17.2315, 0);
	at[8] = 9.4000;
	points[9] = (-5515.3154, -1590.0985, 5343.2285);
	angles[9] = (0, 17.2315, 0);
	at[9] = 9.8000;
	points[10] = (-5558.3857, -1451.1497, 4969.4487);
	angles[10] = (0, 17.2315, 0);
	at[10] = 10.2000;
	points[11] = (-5600.2363, -1316.2480, 4606.5752);
	angles[11] = (0, 17.2315, 0);
	at[11] = 10.6000;
	points[12] = (-5640.8267, -1185.3977, 4254.5669);
	angles[12] = (0, 17.2315, 0);
	at[12] = 11;
	points[13] = (-5680.1577, -1058.5945, 3913.4763);
	angles[13] = (0, 17.2315, 0);
	at[13] = 11.4000;
	points[14] = (-5718.2280, -935.8386, 3583.2717);
	angles[14] = (0, 17.2315, 0);
	at[14] = 11.8000;
	points[15] = (-5745.9453, -846.4291, 3342.7637);
	angles[15] = (0, 17.2315, 0);
	at[15] = 12.1000;
	points[16] = (-5781.8501, -730.7638, 3031.6221);
	angles[16] = (0, 17.2315, 0);
	at[16] = 12.5000;
	points[17] = (-5816.4570, -619.1457, 2731.3662);
	angles[17] = (0, 17.2315, 0);
	at[17] = 12.9000;
	points[18] = (-5849.8037, -511.5748, 2442.0078);
	angles[18] = (0, 17.2315, 0);
	at[18] = 13.3000;
	points[19] = (-5881.9292, -408.0551, 2163.5432);
	angles[19] = (0, 17.2315, 0);
	at[19] = 13.7000;
	points[20] = (-5912.7563, -308.5851, 1895.9685);
	angles[20] = (0, 17.2315, 0);
	at[20] = 14.1000;
	points[21] = (-5942.3623, -213.1650, 1639.2914);
	angles[21] = (0, 17.2315, 0);
	at[21] = 14.5000;
	points[22] = (-5963.7402, -144.2575, 1453.9331);
	angles[22] = (0, 17.2315, 0);
	at[22] = 14.8000;
	points[23] = (-5977.5981, -99.5850, 1333.7639);
	angles[23] = (0, 17.2315, 0);
	at[23] = 15;
	points[24] = (-6004.3701, -13.2775, 1101.5985);
	angles[24] = (0, 17.2315, 0);
	at[24] = 15.4000;
	points[25] = (-6029.8818, 68.9795, 880.3268);
	angles[25] = (0, 17.2315, 0);
	at[25] = 15.8000;
	points[26] = (-6054.1338, 147.1862, 669.9528);
	angles[26] = (0, 17.2315, 0);
	at[26] = 16.2000;
	points[27] = (-6077.1260, 221.3421, 470.4724);
	angles[27] = (0, 17.2315, 0);
	at[27] = 16.6000;
	points[28] = (-6081.7720, 236.2815, 430.2874);
	angles[28] = (0, 17.2315, 0);
	at[28] = 16.7000;
	points[29] = (-6081.7720, 236.2815, 430.2874);
	angles[29] = (0, 17.2315, 0);
	at[29] = 18.0333;
	points[30] = (-5176.2993, -2683.1653, 8283.5430);
	angles[30] = (0, 17.2315, 0);
	at[30] = 18.0333;
	points[31] = (-5176.2993, -2683.1653, 8283.5430);
	angles[31] = (0, 17.2315, 0);
	at[31] = 20.3000;
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
	points[0] = (-5868.7012, -450.6968, 2278.2480);
	angles[0] = (0, 17.2315, 0);
	at[0] = 0;
	points[1] = (-5900.0786, -349.5390, 2006.1338);
	angles[1] = (0, 17.2315, 0);
	at[1] = 0.4000;
	points[2] = (-5930.1968, -252.4311, 1744.9174);
	angles[2] = (0, 17.2315, 0);
	at[2] = 0.8000;
	points[3] = (-5959.0552, -159.3736, 1494.5945);
	angles[3] = (0, 17.2315, 0);
	at[3] = 1.2000;
	points[4] = (-5986.6538, -70.3657, 1255.1654);
	angles[4] = (0, 17.2315, 0);
	at[4] = 1.6000;
	points[5] = (-6012.9922, 14.5917, 1026.6300);
	angles[5] = (0, 17.2315, 0);
	at[5] = 2;
	points[6] = (-6038.1104, 95.4988, 808.9922);
	angles[6] = (0, 17.2315, 0);
	at[6] = 2.4000;
	points[7] = (-6056.1025, 153.5209, 652.9134);
	angles[7] = (0, 17.2315, 0);
	at[7] = 2.7000;
	points[8] = (-6078.9766, 227.3390, 454.3425);
	angles[8] = (0, 17.2315, 0);
	at[8] = 3.1000;
	points[9] = (-6081.7720, 236.2815, 430.2874);
	angles[9] = (0, 17.2315, 0);
	at[9] = 3.2000;
	points[10] = (-6081.7720, 236.2815, 430.2874);
	angles[10] = (0, 17.2315, 0);
	at[10] = 4.5000;
	points[11] = (-5176.2993, -2683.1653, 8283.5430);
	angles[11] = (0, 17.2315, 0);
	at[11] = 4.5000;
	points[12] = (-5176.2993, -2683.1653, 8283.5430);
	angles[12] = (0, 17.2315, 0);
	at[12] = 13.7000;
	points[13] = (-5182.8345, -2662.0117, 8226.6533);
	angles[13] = (0, 17.2315, 0);
	at[13] = 13.8000;
	points[14] = (-5234.6460, -2495.0591, 7777.5591);
	angles[14] = (0, 17.2315, 0);
	at[14] = 14.2000;
	points[15] = (-5260.0391, -2413.0986, 7557.0864);
	angles[15] = (0, 17.2315, 0);
	at[15] = 14.4000;
	points[16] = (-5297.5986, -2292.0630, 7231.4961);
	angles[16] = (0, 17.2315, 0);
	at[16] = 14.7000;
	points[17] = (-5346.5356, -2134.2166, 6806.8901);
	angles[17] = (0, 17.2315, 0);
	at[17] = 15.1000;
	points[18] = (-5370.5513, -2056.8149, 6598.6616);
	angles[18] = (0, 17.2315, 0);
	at[18] = 15.3000;
	points[19] = (-5405.9844, -1942.6063, 6291.4565);
	angles[19] = (0, 17.2315, 0);
	at[19] = 15.6000;
	points[20] = (-5452.0869, -1793.8740, 5891.3784);
	angles[20] = (0, 17.2315, 0);
	at[20] = 16;
	points[21] = (-5496.9688, -1649.1890, 5502.1655);
	angles[21] = (0, 17.2315, 0);
	at[21] = 16.4000;
	points[22] = (-5529.8032, -1543.3307, 5217.4019);
	angles[22] = (0, 17.2315, 0);
	at[22] = 16.7000;
	points[23] = (-5572.4805, -1405.7323, 4847.2837);
	angles[23] = (0, 17.2315, 0);
	at[23] = 17.1000;
	points[24] = (-5613.8979, -1272.1812, 4488.0317);
	angles[24] = (0, 17.2315, 0);
	at[24] = 17.5000;
	points[25] = (-5654.0557, -1142.6772, 4139.6851);
	angles[25] = (0, 17.2315, 0);
	at[25] = 17.9000;
	points[26] = (-5692.9922, -1017.2244, 3802.1968);
	angles[26] = (0, 17.2315, 0);
	at[26] = 18.3000;
	points[27] = (-5730.6299, -895.8189, 3475.6221);
	angles[27] = (0, 17.2315, 0);
	at[27] = 18.7000;
	points[28] = (-5767.0474, -778.4646, 3159.9409);
	angles[28] = (0, 17.2315, 0);
	at[28] = 19.1000;
	points[29] = (-5802.1655, -665.1614, 2855.1497);
	angles[29] = (0, 17.2315, 0);
	at[29] = 19.5000;
	points[30] = (-5836.0630, -555.9016, 2561.2520);
	angles[30] = (0, 17.2315, 0);
	at[30] = 19.9000;
	points[31] = (-5868.7012, -450.6968, 2278.2480);
	angles[31] = (0, 17.2315, 0);
	at[31] = 20.3000;
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
	points[0] = (-941.2875, 9316.4570, 5733.9766);
	angles[0] = (0, -159.0998, 0);
	at[0] = 0;
	points[1] = (-941.2875, 9316.4570, 5733.9766);
	angles[1] = (0, -159.0998, 0);
	at[1] = 0.2333;
	points[2] = (-933.8150, 9296.8896, 5691.6929);
	angles[2] = (0, -159.0998, 0);
	at[2] = 0.3500;
	points[3] = (-871.9135, 9134.7637, 5341.4961);
	angles[3] = (0, -159.0998, 0);
	at[3] = 1.0500;
	points[4] = (-821.5197, 9002.7959, 5056.3784);
	angles[4] = (0, -159.0998, 0);
	at[4] = 1.6333;
	points[5] = (-762.4882, 8848.2285, 4722.4014);
	angles[5] = (0, -159.0998, 0);
	at[5] = 2.3333;
	points[6] = (-714.4882, 8722.5195, 4450.8662);
	angles[6] = (0, -159.0998, 0);
	at[6] = 2.9167;
	points[7] = (-658.3228, 8575.4326, 4133.1104);
	angles[7] = (0, -159.0998, 0);
	at[7] = 3.6167;
	points[8] = (-612.7166, 8456.0234, 3875.0867);
	angles[8] = (0, -159.0998, 0);
	at[8] = 4.2000;
	points[9] = (-568.1969, 8339.4092, 3623.2126);
	angles[9] = (0, -159.0998, 0);
	at[9] = 4.7833;
	points[10] = (-516.2047, 8203.2686, 3329.0789);
	angles[10] = (0, -159.0998, 0);
	at[10] = 5.4833;
	points[11] = (-482.4134, 8114.8032, 3137.9136);
	angles[11] = (0, -159.0998, 0);
	at[11] = 5.9500;
	points[12] = (-449.3189, 8028.1104, 2950.6814);
	angles[12] = (0, -159.0998, 0);
	at[12] = 6.4167;
	points[13] = (-416.9213, 7943.2681, 2767.3818);
	angles[13] = (0, -159.0998, 0);
	at[13] = 6.8833;
	points[14] = (-377.4016, 7839.8032, 2543.7993);
	angles[14] = (0, -159.0998, 0);
	at[14] = 7.4667;
	points[15] = (-346.5681, 7759.0552, 2369.3584);
	angles[15] = (0, -159.0998, 0);
	at[15] = 7.9333;
	points[16] = (-316.4303, 7680.1182, 2198.8584);
	angles[16] = (0, -159.0998, 0);
	at[16] = 8.4000;
	points[17] = (-286.9886, 7603.0317, 2032.2914);
	angles[17] = (0, -159.0998, 0);
	at[17] = 8.8667;
	points[18] = (-251.1646, 7509.2124, 1829.6141);
	angles[18] = (0, -159.0998, 0);
	at[18] = 9.4500;
	points[19] = (-216.4276, 7418.2285, 1633.0945);
	angles[19] = (0, -159.0998, 0);
	at[19] = 10.0333;
	points[20] = (-182.7780, 7330.1182, 1442.7205);
	angles[20] = (0, -159.0998, 0);
	at[20] = 10.6167;
	points[21] = (-150.2154, 7244.8423, 1258.5000);
	angles[21] = (0, -159.0998, 0);
	at[21] = 11.2000;
	points[22] = (-118.7398, 7162.4409, 1080.4291);
	angles[22] = (0, -159.0998, 0);
	at[22] = 11.7833;
	points[23] = (-88.3520, 7082.8350, 908.5079);
	angles[23] = (0, -159.0998, 0);
	at[23] = 12.3667;
	points[24] = (-59.0508, 7006.1416, 742.7402);
	angles[24] = (0, -159.0998, 0);
	at[24] = 12.9500;
	points[25] = (-30.8373, 6932.2441, 583.1221);
	angles[25] = (0, -159.0998, 0);
	at[25] = 13.5333;
	points[26] = (-3.7110, 6861.2202, 429.6536);
	angles[26] = (0, -159.0998, 0);
	at[26] = 14.1167;
	points[27] = (-3.7110, 6861.2202, 429.6536);
	angles[27] = (0, -159.0998, 0);
	at[27] = 15.4667;
	points[28] = (-941.2875, 9316.4570, 5733.9766);
	angles[28] = (0, -159.0998, 0);
	at[28] = 15.4667;
	points[29] = (-941.2875, 9316.4570, 5733.9766);
	angles[29] = (0, -159.0998, 0);
	at[29] = 26.8000;
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
	points[0] = (-941.2875, 9316.4570, 5733.9766);
	angles[0] = (0, -159.0998, 0);
	at[0] = 0;
	points[1] = (-941.2875, 9316.4570, 5733.9766);
	angles[1] = (0, -159.0998, 0);
	at[1] = 9.1000;
	points[2] = (-939.7914, 9312.5195, 5725.5117);
	angles[2] = (0, -159.0998, 0);
	at[2] = 9.2167;
	points[3] = (-898.2520, 9203.7402, 5490.4722);
	angles[3] = (0, -159.0998, 0);
	at[3] = 9.6833;
	points[4] = (-847.2993, 9070.3154, 5202.2441);
	angles[4] = (0, -159.0998, 0);
	at[4] = 10.2667;
	points[5] = (-797.4370, 8939.7246, 4920.1577);
	angles[5] = (0, -159.0998, 0);
	at[5] = 10.8500;
	points[6] = (-748.6614, 8812.0078, 4644.2124);
	angles[6] = (0, -159.0998, 0);
	at[6] = 11.4333;
	points[7] = (-710.4252, 8711.8896, 4427.8740);
	angles[7] = (0, -159.0998, 0);
	at[7] = 11.9000;
	points[8] = (-663.6063, 8589.2910, 4162.9922);
	angles[8] = (0, -159.0998, 0);
	at[8] = 12.4833;
	points[9] = (-617.8740, 8469.5283, 3904.2637);
	angles[9] = (0, -159.0998, 0);
	at[9] = 13.0667;
	points[10] = (-573.2284, 8352.5986, 3651.6851);
	angles[10] = (0, -159.0998, 0);
	at[10] = 13.6500;
	points[11] = (-538.2953, 8261.1416, 3454.0513);
	angles[11] = (0, -159.0998, 0);
	at[11] = 14.1167;
	points[12] = (-495.6063, 8149.3306, 3212.5435);
	angles[12] = (0, -159.0998, 0);
	at[12] = 14.7000;
	points[13] = (-454.0039, 8040.3936, 2977.1851);
	angles[13] = (0, -159.0998, 0);
	at[13] = 15.2833;
	points[14] = (-421.5079, 7955.2754, 2793.3269);
	angles[14] = (0, -159.0998, 0);
	at[14] = 15.7500;
	points[15] = (-389.7051, 7872.0083, 2613.4055);
	angles[15] = (0, -159.0998, 0);
	at[15] = 16.2167;
	points[16] = (-350.9303, 7770.4722, 2394.0396);
	angles[16] = (0, -159.0998, 0);
	at[16] = 16.8000;
	points[17] = (-313.2425, 7671.7720, 2180.8228);
	angles[17] = (0, -159.0998, 0);
	at[17] = 17.3833;
	points[18] = (-276.6421, 7575.9448, 1973.7560);
	angles[18] = (0, -159.0998, 0);
	at[18] = 17.9667;
	points[19] = (-241.1287, 7482.9131, 1772.8386);
	angles[19] = (0, -159.0998, 0);
	at[19] = 18.5500;
	points[20] = (-206.7024, 7392.7949, 1578.0748);
	angles[20] = (0, -159.0998, 0);
	at[20] = 19.1333;
	points[21] = (-166.8260, 7288.3462, 1352.4724);
	angles[21] = (0, -159.0998, 0);
	at[21] = 19.8333;
	points[22] = (-134.7914, 7204.4487, 1171.2402);
	angles[22] = (0, -159.0998, 0);
	at[22] = 20.4167;
	points[23] = (-97.7850, 7107.5591, 961.8779);
	angles[23] = (0, -159.0998, 0);
	at[23] = 21.1167;
	points[24] = (-68.1425, 7029.9214, 794.1733);
	angles[24] = (0, -159.0998, 0);
	at[24] = 21.7000;
	points[25] = (-39.5874, 6955.1572, 632.6221);
	angles[25] = (0, -159.0998, 0);
	at[25] = 22.2833;
	points[26] = (-6.7561, 6869.1733, 446.8819);
	angles[26] = (0, -159.0998, 0);
	at[26] = 22.9833;
	points[27] = (-3.7110, 6861.2202, 429.6536);
	angles[27] = (0, -159.0998, 0);
	at[27] = 23.1000;
	points[28] = (-3.7110, 6861.2202, 429.6536);
	angles[28] = (0, -159.0998, 0);
	at[28] = 24.4000;
	points[29] = (-941.2875, 9316.4570, 5733.9766);
	angles[29] = (0, -159.0998, 0);
	at[29] = 24.4000;
	points[30] = (-941.2875, 9316.4570, 5733.9766);
	angles[30] = (0, -159.0998, 0);
	at[30] = 26.8000;
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
	points[0] = (-282.8394, 7592.1655, 2008.8149);
	angles[0] = (0, -159.0998, 0);
	at[0] = 0;
	points[1] = (-247.1394, 7498.6616, 1806.8466);
	angles[1] = (0, -159.0998, 0);
	at[1] = 0.5833;
	points[2] = (-205.7346, 7390.2363, 1572.5985);
	angles[2] = (0, -159.0998, 0);
	at[2] = 1.2833;
	points[3] = (-165.8957, 7285.9053, 1347.2087);
	angles[3] = (0, -159.0998, 0);
	at[3] = 1.9833;
	points[4] = (-133.8921, 7202.1265, 1166.1495);
	angles[4] = (0, -159.0998, 0);
	at[4] = 2.5667;
	points[5] = (-96.9232, 7105.3154, 957);
	angles[5] = (0, -159.0998, 0);
	at[5] = 3.2667;
	points[6] = (-67.3118, 7027.7563, 789.4725);
	angles[6] = (0, -159.0998, 0);
	at[6] = 3.8500;
	points[7] = (-33.2130, 6938.4648, 596.5591);
	angles[7] = (0, -159.0998, 0);
	at[7] = 4.5500;
	points[8] = (-5.9935, 6867.1650, 442.5670);
	angles[8] = (0, -159.0998, 0);
	at[8] = 5.1333;
	points[9] = (-3.7110, 6861.2202, 429.6536);
	angles[9] = (0, -159.0998, 0);
	at[9] = 5.2500;
	points[10] = (-3.7110, 6861.2202, 429.6536);
	angles[10] = (0, -159.0998, 0);
	at[10] = 6.5333;
	points[11] = (-941.2875, 9316.4570, 5733.9766);
	angles[11] = (0, -159.0998, 0);
	at[11] = 6.5333;
	points[12] = (-941.2875, 9316.4570, 5733.9766);
	angles[12] = (0, -159.0998, 0);
	at[12] = 18.0833;
	points[13] = (-935.3071, 9300.7881, 5700.1572);
	angles[13] = (0, -159.0998, 0);
	at[13] = 18.2000;
	points[14] = (-883.5827, 9165.3145, 5407.5195);
	angles[14] = (0, -159.0998, 0);
	at[14] = 18.7833;
	points[15] = (-832.9449, 9032.7168, 5121.0239);
	angles[15] = (0, -159.0998, 0);
	at[15] = 19.3667;
	points[16] = (-783.3898, 8902.9531, 4840.6694);
	angles[16] = (0, -159.0998, 0);
	at[16] = 19.9500;
	points[17] = (-725.3622, 8750.9844, 4512.4014);
	angles[17] = (0, -159.0998, 0);
	at[17] = 20.6500;
	points[18] = (-687.5472, 8651.9688, 4298.4648);
	angles[18] = (0, -159.0998, 0);
	at[18] = 21.1167;
	points[19] = (-650.4292, 8554.7637, 4088.4253);
	angles[19] = (0, -159.0998, 0);
	at[19] = 21.5833;
	points[20] = (-614.0040, 8459.3701, 3882.3740);
	angles[20] = (0, -159.0998, 0);
	at[20] = 22.0500;
	points[21] = (-569.4528, 8342.7168, 3630.3228);
	angles[21] = (0, -159.0998, 0);
	at[21] = 22.6333;
	points[22] = (-525.9882, 8228.8984, 3384.4214);
	angles[22] = (0, -159.0998, 0);
	at[22] = 23.2167;
	points[23] = (-492, 8139.8823, 3192.1299);
	angles[23] = (0, -159.0998, 0);
	at[23] = 23.6833;
	points[24] = (-458.7047, 8052.7168, 3003.7717);
	angles[24] = (0, -159.0998, 0);
	at[24] = 24.1500;
	points[25] = (-418.0670, 7946.2993, 2773.8623);
	angles[25] = (0, -159.0998, 0);
	at[25] = 24.7333;
	points[26] = (-386.3390, 7863.1895, 2594.3621);
	angles[26] = (0, -159.0998, 0);
	at[26] = 25.2000;
	points[27] = (-347.6571, 7761.8896, 2375.5237);
	angles[27] = (0, -159.0998, 0);
	at[27] = 25.7833;
	points[28] = (-317.4945, 7682.9131, 2204.8779);
	angles[28] = (0, -159.0998, 0);
	at[28] = 26.2500;
	points[29] = (-282.8394, 7592.1655, 2008.8149);
	angles[29] = (0, -159.0998, 0);
	at[29] = 26.8000;
	mover = getEnt("iz_obj_12", "targetname");
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
