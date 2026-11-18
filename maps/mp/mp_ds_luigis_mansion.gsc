main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_ds_luigis_mansion", 0);

	setExpFog(0, 15255.9043, 0, 0, 0, 0);

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
	ambientPlay("iz_0_75", 2);
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
	level.iz_route[level.iz_route.size] = (-7329, 3296, 1822);
	level.iz_route[level.iz_route.size] = (-7282, 2150, 1843);
	level.iz_route[level.iz_route.size] = (-6977, 1370, 1919);
	level.iz_route[level.iz_route.size] = (-6841, 845, 1968);
	level.iz_route[level.iz_route.size] = (-6986, 444, 1969);
	level.iz_route[level.iz_route.size] = (-7497, -195, 2014);
	level.iz_route[level.iz_route.size] = (-7882, -702, 2061);
	level.iz_route[level.iz_route.size] = (-7929, -1048, 2062);
	level.iz_route[level.iz_route.size] = (-7804, -1331, 2063);
	level.iz_route[level.iz_route.size] = (-7646, -1654, 2094);
	level.iz_route[level.iz_route.size] = (-7459, -2243, 2153);
	level.iz_route[level.iz_route.size] = (-7446, -2780, 2245);
	level.iz_route[level.iz_route.size] = (-7505, -3865, 2452);
	level.iz_route[level.iz_route.size] = (-7505, -5688, 2699);
	level.iz_route[level.iz_route.size] = (-7505, -5957, 2728);
	level.iz_route[level.iz_route.size] = (-7483, -6993, 3143);
	level.iz_route[level.iz_route.size] = (-7467, -7909, 3143);
	level.iz_route[level.iz_route.size] = (-7453, -8672, 3098);
	level.iz_route[level.iz_route.size] = (-7437, -9484, 2838);
	level.iz_route[level.iz_route.size] = (-7423, -10311, 2474);
	level.iz_route[level.iz_route.size] = (-7435, -11211, 2185);
	level.iz_route[level.iz_route.size] = (-7521, -12026, 2186);
	level.iz_route[level.iz_route.size] = (-7763, -12411, 2186);
	level.iz_route[level.iz_route.size] = (-8051, -12592, 2186);
	level.iz_route[level.iz_route.size] = (-8431, -12705, 2186);
	level.iz_route[level.iz_route.size] = (-8942, -12700, 2185);
	level.iz_route[level.iz_route.size] = (-9332, -12585, 2185);
	level.iz_route[level.iz_route.size] = (-9645, -12386, 2185);
	level.iz_route[level.iz_route.size] = (-9855, -12022, 2145);
	level.iz_route[level.iz_route.size] = (-9875, -11511, 1975);
	level.iz_route[level.iz_route.size] = (-9761, -10945, 1804);
	level.iz_route[level.iz_route.size] = (-9435, -10590, 1804);
	level.iz_route[level.iz_route.size] = (-9090, -10395, 1804);
	level.iz_route[level.iz_route.size] = (-8690, -10339, 1804);
	level.iz_route[level.iz_route.size] = (-8218, -10470, 1804);
	level.iz_route[level.iz_route.size] = (-7666, -10630, 1804);
	level.iz_route[level.iz_route.size] = (-7139, -10675, 1804);
	level.iz_route[level.iz_route.size] = (-6532, -10646, 1804);
	level.iz_route[level.iz_route.size] = (-5898, -10396, 1804);
	level.iz_route[level.iz_route.size] = (-5425, -10202, 1804);
	level.iz_route[level.iz_route.size] = (-4814, -10169, 1785);
	level.iz_route[level.iz_route.size] = (-4185, -10124, 1735);
	level.iz_route[level.iz_route.size] = (-3541, -10311, 1769);
	level.iz_route[level.iz_route.size] = (-2768, -10330, 1753);
	level.iz_route[level.iz_route.size] = (-1906, -10252, 1804);
	level.iz_route[level.iz_route.size] = (-497, -10277, 1817);
	level.iz_route[level.iz_route.size] = (-62, -10210, 1816);
	level.iz_route[level.iz_route.size] = (302, -9982, 1819);
	level.iz_route[level.iz_route.size] = (507, -9687, 1820);
	level.iz_route[level.iz_route.size] = (526, -9301, 1816);
	level.iz_route[level.iz_route.size] = (399, -8939, 1813);
	level.iz_route[level.iz_route.size] = (196, -8521, 1809);
	level.iz_route[level.iz_route.size] = (57, -8128, 1814);
	level.iz_route[level.iz_route.size] = (59, -8023, 1814);
	level.iz_route[level.iz_route.size] = (242, -7569, 1798);
	level.iz_route[level.iz_route.size] = (459, -7236, 1787);
	level.iz_route[level.iz_route.size] = (989, -6725, 1793);
	level.iz_route[level.iz_route.size] = (1449, -6200, 1807);
	level.iz_route[level.iz_route.size] = (1565, -5822, 1820);
	level.iz_route[level.iz_route.size] = (1606, -5445, 1820);
	level.iz_route[level.iz_route.size] = (1478, -4984, 1814);
	level.iz_route[level.iz_route.size] = (681, -3641, 1817);
	level.iz_route[level.iz_route.size] = (548, -2495, 1817);
	level.iz_route[level.iz_route.size] = (1031, -1267, 1817);
	level.iz_route[level.iz_route.size] = (2078, -526, 1817);
	level.iz_route[level.iz_route.size] = (2819, -486, 1817);
	level.iz_route[level.iz_route.size] = (3764, -142, 1817);
	level.iz_route[level.iz_route.size] = (4165, 99, 1817);
	level.iz_route[level.iz_route.size] = (4805, 923, 1817);
	level.iz_route[level.iz_route.size] = (5032, 1544, 1817);
	level.iz_route[level.iz_route.size] = (5134, 2247, 1817);
	level.iz_route[level.iz_route.size] = (4958, 3040, 1817);
	level.iz_route[level.iz_route.size] = (4943, 3138, 1817);
	level.iz_route[level.iz_route.size] = (4838, 3360, 1817);
	level.iz_route[level.iz_route.size] = (4781, 3446, 1817);
	level.iz_route[level.iz_route.size] = (3760, 3810, 1817);
	level.iz_route[level.iz_route.size] = (2581, 4036, 1817);
	level.iz_route[level.iz_route.size] = (1790, 3927, 1817);
	level.iz_route[level.iz_route.size] = (949, 3751, 1817);
	level.iz_route[level.iz_route.size] = (29, 3690, 1817);
	level.iz_route[level.iz_route.size] = (-601, 3814, 1817);
	level.iz_route[level.iz_route.size] = (-1407, 4499, 1817);
	level.iz_route[level.iz_route.size] = (-2362, 5981, 1817);
	level.iz_route[level.iz_route.size] = (-2974, 6727, 1817);
	level.iz_route[level.iz_route.size] = (-3635, 7332, 1817);
	level.iz_route[level.iz_route.size] = (-4348, 7498, 1817);
	level.iz_route[level.iz_route.size] = (-5269, 7491, 1817);
	level.iz_route[level.iz_route.size] = (-6258, 7117, 1817);
	level.iz_route[level.iz_route.size] = (-6902, 6468, 1817);
	level.iz_route[level.iz_route.size] = (-7319, 4869, 1817);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-1365.4449, 3386.5081, 1817.4213);
	angles[0] = (0, -166.4017, 0);
	at[0] = 0;
	points[1] = (-1357.2521, 3370.3938, 1817.4213);
	angles[1] = (0, -157.9924, 0);
	at[1] = 0.0667;
	points[2] = (-1339.0748, 3339.9568, 1817.4213);
	angles[2] = (0, -150.1700, 0);
	at[2] = 0.2000;
	points[3] = (-1278.1219, 3253.1733, 1817.4213);
	angles[3] = (0, -141.4788, 0);
	at[3] = 0.6000;
	points[4] = (-1191.7323, 3164.2954, 1817.4213);
	angles[4] = (0, -134.2128, 0);
	at[4] = 1.0667;
	points[5] = (-1125.6968, 3104.7600, 1817.4213);
	angles[5] = (0, -131.1183, 0);
	at[5] = 1.4000;
	points[6] = (-1097.8937, 3083.3267, 1817.4213);
	angles[6] = (0, -127.1089, 0);
	at[6] = 1.5333;
	points[7] = (-992.5867, 3017.4448, 1817.4213);
	angles[7] = (0, -120.2153, 0);
	at[7] = 2;
	points[8] = (-944.3583, 2995.3188, 1817.4213);
	angles[8] = (0, -113.8510, 0);
	at[8] = 2.2000;
	points[9] = (-878.3386, 2969.3228, 1817.4213);
	angles[9] = (0, -110.9975, 0);
	at[9] = 2.4667;
	points[10] = (-810.8149, 2948.8269, 1817.4213);
	angles[10] = (0, -104.3335, 0);
	at[10] = 2.7333;
	points[11] = (-740.9094, 2935.5315, 1817.4213);
	angles[11] = (0, -100.0959, 0);
	at[11] = 3;
	points[12] = (-688.6614, 2929.3506, 1817.4213);
	angles[12] = (0, -94.7428, 0);
	at[12] = 3.2000;
	points[13] = (-652.9960, 2931.2717, 1817.4213);
	angles[13] = (0, -87.4998, 0);
	at[13] = 3.3333;
	points[14] = (-599.9843, 2937.2993, 1817.4213);
	angles[14] = (0, -83.1326, 0);
	at[14] = 3.5333;
	points[15] = (-565.0079, 2943.1892, 1817.4213);
	angles[15] = (0, -80.1419, 0);
	at[15] = 3.6667;
	points[16] = (-548.2835, 2948.0867, 1817.4213);
	angles[16] = (0, -75.3997, 0);
	at[16] = 3.7333;
	points[17] = (-483.9843, 2978.2087, 1817.4213);
	angles[17] = (0, -63.2629, 0);
	at[17] = 4;
	points[18] = (-453.9095, 2996.7795, 1817.4213);
	angles[18] = (0, -57.4500, 0);
	at[18] = 4.1333;
	points[19] = (-441.0236, 3008.5195, 1817.4213);
	angles[19] = (0, -51.0534, 0);
	at[19] = 4.2000;
	points[20] = (-416.5157, 3034.3938, 1817.4213);
	angles[20] = (0, -44.2484, 0);
	at[20] = 4.3333;
	points[21] = (-370.6634, 3088.5078, 1817.4213);
	angles[21] = (0, -39.0986, 0);
	at[21] = 4.6000;
	points[22] = (-335.5862, 3149.9409, 1817.4213);
	angles[22] = (0, -27.6936, 0);
	at[22] = 4.8667;
	points[23] = (-308.6449, 3215.0356, 1817.4213);
	angles[23] = (0, -19.4154, 0);
	at[23] = 5.1333;
	points[24] = (-287.1268, 3301.4802, 1817.4213);
	angles[24] = (0, -12.7593, 0);
	at[24] = 5.4667;
	points[25] = (-282.0784, 3336.1616, 1817.4213);
	angles[25] = (0, -7.0173, 0);
	at[25] = 5.6000;
	points[26] = (-283.6083, 3371.6497, 1817.4213);
	angles[26] = (0, 1.7357, 0);
	at[26] = 5.7333;
	points[27] = (-293.5819, 3441.3188, 1817.4213);
	angles[27] = (0, 10.6314, 0);
	at[27] = 6;
	points[28] = (-320.3575, 3526.2915, 1817.4213);
	angles[28] = (0, 18.6804, 0);
	at[28] = 6.3333;
	points[29] = (-340.6292, 3575, 1817.4213);
	angles[29] = (0, 25.1987, 0);
	at[29] = 6.5333;
	points[30] = (-362.4161, 3603.0828, 1817.4213);
	angles[30] = (0, 36.9558, 0);
	at[30] = 6.6667;
	points[31] = (-386.3417, 3629.3821, 1817.4213);
	angles[31] = (0, 41.7688, 0);
	at[31] = 6.8000;
	points[32] = (-448.8032, 3692.0630, 1817.4213);
	angles[32] = (0, 45.7900, 0);
	at[32] = 7.1333;
	points[33] = (-514.5315, 3751.8032, 1817.4213);
	angles[33] = (0, 48.9185, 0);
	at[33] = 7.4667;
	points[34] = (-573.0945, 3791.0513, 1817.4213);
	angles[34] = (0, 58.2304, 0);
	at[34] = 7.7333;
	points[35] = (-666.2441, 3843.0432, 1817.4213);
	angles[35] = (0, 61.8283, 0);
	at[35] = 8.1333;
	points[36] = (-697.9803, 3857.9055, 1817.4213);
	angles[36] = (0, 65.5148, 0);
	at[36] = 8.2667;
	points[37] = (-748.1732, 3875.4412, 1817.4213);
	angles[37] = (0, 71.1692, 0);
	at[37] = 8.4667;
	points[38] = (-799.2756, 3890.1260, 1817.4213);
	angles[38] = (0, 74.6233, 0);
	at[38] = 8.6667;
	points[39] = (-834.0670, 3896.3977, 1817.4213);
	angles[39] = (0, 80.4779, 0);
	at[39] = 8.8000;
	points[40] = (-869.3701, 3898.8977, 1817.4213);
	angles[40] = (0, 85.3938, 0);
	at[40] = 8.9333;
	points[41] = (-976.1181, 3901.1299, 1817.4213);
	angles[41] = (0, 90.3129, 0);
	at[41] = 9.3333;
	points[42] = (-1010.6142, 3897.4490, 1817.4213);
	angles[42] = (0, 96.9560, 0);
	at[42] = 9.4667;
	points[43] = (-1062.4607, 3884.6062, 1817.4213);
	angles[43] = (0, 104.2727, 0);
	at[43] = 9.6667;
	points[44] = (-1129.8898, 3863.3464, 1817.4213);
	angles[44] = (0, 109.0730, 0);
	at[44] = 9.9333;
	points[45] = (-1161.9409, 3848.0867, 1817.4213);
	angles[45] = (0, 115.2026, 0);
	at[45] = 10.0667;
	points[46] = (-1222.5197, 3811.5552, 1817.4213);
	angles[46] = (0, 124.0272, 0);
	at[46] = 10.3333;
	points[47] = (-1248.2914, 3787.2324, 1817.4213);
	angles[47] = (0, 132.5785, 0);
	at[47] = 10.4667;
	points[48] = (-1296.4961, 3734.7876, 1817.4213);
	angles[48] = (0, 138.6158, 0);
	at[48] = 10.7333;
	points[49] = (-1315.3937, 3705.4290, 1817.4213);
	angles[49] = (0, 148.1200, 0);
	at[49] = 10.8667;
	points[50] = (-1343.2874, 3640, 1817.4213);
	angles[50] = (0, 158.3066, 0);
	at[50] = 11.1333;
	points[51] = (-1357.3542, 3589.0276, 1817.4213);
	angles[51] = (0, 165.3514, 0);
	at[51] = 11.3333;
	points[52] = (-1368.5709, 3536.7993, 1817.4213);
	angles[52] = (0, 168.2957, 0);
	at[52] = 11.5333;
	points[53] = (-1373.1969, 3501.9373, 1817.4213);
	angles[53] = (0, 173.2149, 0);
	at[53] = 11.6667;
	points[54] = (-1373.8268, 3448.7480, 1817.4213);
	angles[54] = (0, 179.8622, 0);
	at[54] = 11.8667;
	points[55] = (-1368.6299, 3395.6616, 1817.4213);
	angles[55] = (0, 188.1653, 0);
	at[55] = 12.0667;
	points[56] = (-1365.4449, 3386.5081, 1817.4213);
	angles[56] = (0, 193.5983, 0);
	at[56] = 12.1167;
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
	points[0] = (1645.5433, -8887.0078, 1902.2836);
	angles[0] = (0, -146.6139, 0);
	at[0] = 0;
	points[1] = (1653.1456, -8916.8506, 1902.2836);
	angles[1] = (0, -163.8417, 0);
	at[1] = 0.1167;
	points[2] = (1655.6104, -8948.0312, 1902.2836);
	angles[2] = (0, -173.9423, 0);
	at[2] = 0.2333;
	points[3] = (1654.2205, -9010.1182, 1902.2836);
	angles[3] = (0, -182.1639, 0);
	at[3] = 0.4667;
	points[4] = (1639.2482, -9165, 1902.2836);
	angles[4] = (0, -186.0608, 0);
	at[4] = 1.0500;
	points[5] = (1633.2166, -9258.3066, 1902.2836);
	angles[5] = (0, -181.0480, 0);
	at[5] = 1.4000;
	points[6] = (1640.4960, -9318.2285, 1902.2836);
	angles[6] = (0, -171.9982, 0);
	at[6] = 1.6333;
	points[7] = (1663.0984, -9440.8662, 1902.2836);
	angles[7] = (0, -169.2605, 0);
	at[7] = 2.1000;
	points[8] = (1689.4213, -9594.4092, 1902.2836);
	angles[8] = (0, -171.6284, 0);
	at[8] = 2.6833;
	points[9] = (1695.5945, -9655.6689, 1902.2836);
	angles[9] = (0, -175.4315, 0);
	at[9] = 2.9167;
	points[10] = (1695.5630, -9686.8115, 1902.2836);
	angles[10] = (0, -180.3290, 0);
	at[10] = 3.0333;
	points[11] = (1686.6023, -9746.6533, 1902.2836);
	angles[11] = (0, -189.3720, 0);
	at[11] = 3.2667;
	points[12] = (1666.7126, -9838.1895, 1902.2836);
	angles[12] = (0, -193.0709, 0);
	at[12] = 3.6167;
	points[13] = (1643.1141, -9928.6621, 1902.2836);
	angles[13] = (0, -195.3103, 0);
	at[13] = 3.9667;
	points[14] = (1615.5590, -10018.1494, 1902.2836);
	angles[14] = (0, -198.0706, 0);
	at[14] = 4.3167;
	points[15] = (1593.9370, -10076.3779, 1902.2836);
	angles[15] = (0, -201.2459, 0);
	at[15] = 4.5500;
	points[16] = (1565.6143, -10132.2832, 1902.2836);
	angles[16] = (0, -209.7156, 0);
	at[16] = 4.7833;
	points[17] = (1545.1024, -10152.0078, 1902.2836);
	angles[17] = (0, -226.9319, 0);
	at[17] = 4.9000;
	points[18] = (1516.0591, -10162.8740, 1902.2836);
	angles[18] = (0, -246.8824, 0);
	at[18] = 5.0167;
	points[19] = (1485.4331, -10168.7793, 1902.2836);
	angles[19] = (0, -257.4178, 0);
	at[19] = 5.1333;
	points[20] = (1423.1890, -10174.5283, 1902.2836);
	angles[20] = (0, -265.5477, 0);
	at[20] = 5.3667;
	points[21] = (1267.8701, -10179.7246, 1902.2836);
	angles[21] = (0, -267.8025, 0);
	at[21] = 5.9500;
	points[22] = (1205.3190, -10184.8828, 1902.2836);
	angles[22] = (0, -264.0188, 0);
	at[22] = 6.1833;
	points[23] = (1174.7047, -10190.9453, 1902.2836);
	angles[23] = (0, -258.6841, 0);
	at[23] = 6.3000;
	points[24] = (1148.5787, -10202.2441, 1902.2836);
	angles[24] = (0, -246.8900, 0);
	at[24] = 6.4167;
	points[25] = (1122.5551, -10219.6064, 1902.2836);
	angles[25] = (0, -237.6646, 0);
	at[25] = 6.5333;
	points[26] = (1073.5000, -10258.5049, 1902.2836);
	angles[26] = (0, -230.9980, 0);
	at[26] = 6.7667;
	points[27] = (907.7166, -10400, 1902.2836);
	angles[27] = (0, -230.7424, 0);
	at[27] = 7.5833;
	points[28] = (831.4567, -10453.6221, 1902.2836);
	angles[28] = (0, -238.2457, 0);
	at[28] = 7.9333;
	points[29] = (802.8780, -10465.9844, 1902.2836);
	angles[29] = (0, -247.1607, 0);
	at[29] = 8.0500;
	points[30] = (773.6221, -10468.8584, 1902.2836);
	angles[30] = (0, -262.6247, 0);
	at[30] = 8.1667;
	points[31] = (742.9528, -10466.9688, 1902.2836);
	angles[31] = (0, -272.0618, 0);
	at[31] = 8.2833;
	points[32] = (680.7244, -10457.2451, 1902.2836);
	angles[32] = (0, -279.7667, 0);
	at[32] = 8.5167;
	points[33] = (590.2835, -10435.9053, 1902.2836);
	angles[33] = (0, -284.4180, 0);
	at[33] = 8.8667;
	points[34] = (500.6772, -10409.0166, 1902.2836);
	angles[34] = (0, -287.7350, 0);
	at[34] = 9.2167;
	points[35] = (413.3898, -10376.2598, 1902.2836);
	angles[35] = (0, -292.1642, 0);
	at[35] = 9.5667;
	points[36] = (358.6559, -10347.6377, 1902.2836);
	angles[36] = (0, -300.6578, 0);
	at[36] = 9.8000;
	points[37] = (336.9666, -10326.4170, 1902.2836);
	angles[37] = (0, -313.4155, 0);
	at[37] = 9.9167;
	points[38] = (319.0890, -10301.7324, 1902.2836);
	angles[38] = (0, -322.6455, 0);
	at[38] = 10.0333;
	points[39] = (272.8905, -10220.5908, 1902.2836);
	angles[39] = (0, -331.8528, 0);
	at[39] = 10.3833;
	points[40] = (188.1614, -10053.8584, 1902.2836);
	angles[40] = (0, -332.0636, 0);
	at[40] = 11.0833;
	points[41] = (156.2591, -10000.8271, 1902.2836);
	angles[41] = (0, -327.4419, 0);
	at[41] = 11.3167;
	points[42] = (136.6146, -9976.7324, 1902.2836);
	angles[42] = (0, -320.3171, 0);
	at[42] = 11.4333;
	points[43] = (112.0823, -9959.6855, 1902.2836);
	angles[43] = (0, -306.0804, 0);
	at[43] = 11.5500;
	points[44] = (84.3563, -9946.6934, 1902.2836);
	angles[44] = (0, -296.6490, 0);
	at[44] = 11.6667;
	points[45] = (55.3823, -9935.4336, 1902.2836);
	angles[45] = (0, -291.9587, 0);
	at[45] = 11.7833;
	points[46] = (-93.0768, -9887.4014, 1902.2836);
	angles[46] = (0, -287.5419, 0);
	at[46] = 12.3667;
	points[47] = (-152.0571, -9867.5596, 1902.2836);
	angles[47] = (0, -289.1329, 0);
	at[47] = 12.6000;
	points[48] = (-209.5228, -9843.6221, 1902.2836);
	angles[48] = (0, -294.2673, 0);
	at[48] = 12.8333;
	points[49] = (-235.9315, -9827.5195, 1902.2836);
	angles[49] = (0, -301.7162, 0);
	at[49] = 12.9500;
	points[50] = (-252.6933, -9804.0947, 1902.2836);
	angles[50] = (0, -326.0074, 0);
	at[50] = 13.0667;
	points[51] = (-255.5945, -9773.2285, 1902.2836);
	angles[51] = (0, -350.8578, 0);
	at[51] = 13.1833;
	points[52] = (-253.3248, -9741.9688, 1902.2836);
	angles[52] = (0, -362.2101, 0);
	at[52] = 13.3000;
	points[53] = (-248.8114, -9710.5908, 1902.2836);
	angles[53] = (0, -367.3510, 0);
	at[53] = 13.4167;
	points[54] = (-236.9457, -9649.8027, 1902.2836);
	angles[54] = (0, -371.5015, 0);
	at[54] = 13.6500;
	points[55] = (-209.1087, -9528.3467, 1902.2836);
	angles[55] = (0, -372.9482, 0);
	at[55] = 14.1167;
	points[56] = (-191.1921, -9436.6934, 1902.2836);
	angles[56] = (0, -369.2820, 0);
	at[56] = 14.4667;
	points[57] = (-188.7008, -9405.5117, 1902.2836);
	angles[57] = (0, -364.2669, 0);
	at[57] = 14.5833;
	points[58] = (-192.4421, -9376.5742, 1902.2836);
	angles[58] = (0, -353.4639, 0);
	at[58] = 14.7000;
	points[59] = (-200.5567, -9346.7715, 1902.2836);
	angles[59] = (0, -345.9394, 0);
	at[59] = 14.8167;
	points[60] = (-231.9969, -9258.6221, 1902.2836);
	angles[60] = (0, -339.4831, 0);
	at[60] = 15.1667;
	points[61] = (-285.6528, -9112.4404, 1902.2836);
	angles[61] = (0, -341.4742, 0);
	at[61] = 15.7500;
	points[62] = (-301.2964, -9051.8115, 1902.2836);
	angles[62] = (0, -347.4628, 0);
	at[62] = 15.9833;
	points[63] = (-303.3780, -9020.7881, 1902.2836);
	angles[63] = (0, -356.5259, 0);
	at[63] = 16.1000;
	points[64] = (-292.1079, -8994.6455, 1902.2836);
	angles[64] = (0, -383.0358, 0);
	at[64] = 16.2167;
	points[65] = (-269.0114, -8973.8584, 1902.2836);
	angles[65] = (0, -404.4792, 0);
	at[65] = 16.3333;
	points[66] = (-243.3342, -8956.2998, 1902.2836);
	angles[66] = (0, -414.0068, 0);
	at[66] = 16.4500;
	points[67] = (-216.2504, -8940.0791, 1902.2836);
	angles[67] = (0, -418.3796, 0);
	at[67] = 16.5667;
	points[68] = (-133.8791, -8896.1416, 1902.2836);
	angles[68] = (0, -422.6004, 0);
	at[68] = 16.9167;
	points[69] = (-23.2133, -8838.5430, 1902.2836);
	angles[69] = (0, -421.6520, 0);
	at[69] = 17.3833;
	points[70] = (29.4932, -8806.4170, 1902.2836);
	angles[70] = (0, -417.0994, 0);
	at[70] = 17.6167;
	points[71] = (53.3772, -8786.6143, 1902.2836);
	angles[71] = (0, -409.7141, 0);
	at[71] = 17.7333;
	points[72] = (70.5083, -8761.6934, 1902.2836);
	angles[72] = (0, -395.9983, 0);
	at[72] = 17.8500;
	points[73] = (83.9244, -8734.3311, 1902.2836);
	angles[73] = (0, -387.5392, 0);
	at[73] = 17.9667;
	points[74] = (95.9287, -8705.7090, 1902.2836);
	angles[74] = (0, -383.4014, 0);
	at[74] = 18.0833;
	points[75] = (149.2484, -8559.0547, 1902.2836);
	angles[75] = (0, -379.7806, 0);
	at[75] = 18.6667;
	points[76] = (171.4748, -8500.8662, 1902.2836);
	angles[76] = (0, -381.4338, 0);
	at[76] = 18.9000;
	points[77] = (197.3551, -8444.7246, 1902.2836);
	angles[77] = (0, -386.3120, 0);
	at[77] = 19.1333;
	points[78] = (213.8575, -8418.8193, 1902.2836);
	angles[78] = (0, -392.8326, 0);
	at[78] = 19.2500;
	points[79] = (237.0051, -8400.0391, 1902.2836);
	angles[79] = (0, -413.3583, 0);
	at[79] = 19.3667;
	points[80] = (267.6138, -8396.6934, 1902.2836);
	angles[80] = (0, -440.0128, 0);
	at[80] = 19.4833;
	points[81] = (299.1012, -8399.4482, 1902.2836);
	angles[81] = (0, -452.7719, 0);
	at[81] = 19.6000;
	points[82] = (359.9276, -8410.8262, 1902.2836);
	angles[82] = (0, -461.3580, 0);
	at[82] = 19.8333;
	points[83] = (450.8228, -8433.5039, 1902.2836);
	angles[83] = (0, -464.5740, 0);
	at[83] = 20.1833;
	points[84] = (571.6260, -8464.8027, 1902.2836);
	angles[84] = (0, -463.8278, 0);
	at[84] = 20.6500;
	points[85] = (631.8228, -8476.7715, 1902.2836);
	angles[85] = (0, -459.8533, 0);
	at[85] = 20.8833;
	points[86] = (662.7048, -8478.7002, 1902.2836);
	angles[86] = (0, -452.8848, 0);
	at[86] = 21;
	points[87] = (692.9134, -8473.1494, 1902.2836);
	angles[87] = (0, -440.8942, 0);
	at[87] = 21.1167;
	points[88] = (722.2323, -8463.8584, 1902.2836);
	angles[88] = (0, -433.6376, 0);
	at[88] = 21.2333;
	points[89] = (780.0315, -8441.1816, 1902.2836);
	angles[89] = (0, -428.0411, 0);
	at[89] = 21.4667;
	points[90] = (865.7834, -8404.0156, 1902.2836);
	angles[90] = (0, -426.4590, 0);
	at[90] = 21.8167;
	points[91] = (981.1536, -8358.7012, 1902.2836);
	angles[91] = (0, -431.2455, 0);
	at[91] = 22.2833;
	points[92] = (1011.5001, -8351.1416, 1902.2836);
	angles[92] = (0, -436.3026, 0);
	at[92] = 22.4000;
	points[93] = (1041.4685, -8351.2598, 1902.2836);
	angles[93] = (0, -452.0370, 0);
	at[93] = 22.5167;
	points[94] = (1068.5511, -8365.6299, 1902.2836);
	angles[94] = (0, -475.0469, 0);
	at[94] = 22.6333;
	points[95] = (1092.7638, -8385.2754, 1902.2836);
	angles[95] = (0, -487.1223, 0);
	at[95] = 22.7500;
	points[96] = (1136.9606, -8429.6064, 1902.2836);
	angles[96] = (0, -495.9280, 0);
	at[96] = 22.9833;
	points[97] = (1238.7914, -8547.2441, 1902.2836);
	angles[97] = (0, -499.4637, 0);
	at[97] = 23.5667;
	points[98] = (1280.6024, -8593.4248, 1902.2836);
	angles[98] = (0, -496.8983, 0);
	at[98] = 23.8000;
	points[99] = (1301.8583, -8612.8740, 1902.2836);
	angles[99] = (0, -492.3095, 0);
	at[99] = 23.9167;
	points[100] = (1377.3584, -8668.3857, 1902.2836);
	angles[100] = (0, -485.5132, 0);
	at[100] = 24.2667;
	points[101] = (1554.1221, -8796.1816, 1902.2836);
	angles[101] = (0, -487.4736, 0);
	at[101] = 25.0833;
	points[102] = (1624.1456, -8857.5195, 1902.2836);
	angles[102] = (0, -494.2264, 0);
	at[102] = 25.4333;
	points[103] = (1645.5433, -8887.0078, 1902.2836);
	angles[103] = (0, -506.6139, 0);
	at[103] = 25.5833;
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
	points[0] = (-980.1182, -3553.6575, 1902.2836);
	angles[0] = (0, -41.9164, 0);
	at[0] = 0;
	points[1] = (-955.1929, -3546.7676, 1902.2836);
	angles[1] = (0, -68.7139, 0);
	at[1] = 0.1000;
	points[2] = (-928.1142, -3545.9883, 1902.2836);
	angles[2] = (0, -84.0312, 0);
	at[2] = 0.2000;
	points[3] = (-875.5906, -3550.0432, 1902.2836);
	angles[3] = (0, -94.7089, 0);
	at[3] = 0.4000;
	points[4] = (-796.0827, -3560.8779, 1902.2836);
	angles[4] = (0, -98.1864, 0);
	at[4] = 0.7000;
	points[5] = (-690.1260, -3575.4331, 1902.2836);
	angles[5] = (0, -96.8756, 0);
	at[5] = 1.1000;
	points[6] = (-637.2835, -3578.7324, 1902.2836);
	angles[6] = (0, -92.2347, 0);
	at[6] = 1.3000;
	points[7] = (-610.6575, -3576.4055, 1902.2836);
	angles[7] = (0, -85.0762, 0);
	at[7] = 1.4000;
	points[8] = (-587.0630, -3567.0747, 1902.2836);
	angles[8] = (0, -71.0594, 0);
	at[8] = 1.5000;
	points[9] = (-564.5748, -3553.5237, 1902.2836);
	angles[9] = (0, -61.4048, 0);
	at[9] = 1.6000;
	points[10] = (-500.1890, -3505.6770, 1902.2836);
	angles[10] = (0, -52.3068, 0);
	at[10] = 1.9000;
	points[11] = (-374.7425, -3406.5867, 1902.2836);
	angles[11] = (0, -53.1932, 0);
	at[11] = 2.5000;
	points[12] = (-329.0697, -3377.3857, 1902.2836);
	angles[12] = (0, -59.1705, 0);
	at[12] = 2.7000;
	points[13] = (-304.1559, -3368.3347, 1902.2836);
	angles[13] = (0, -69.9686, 0);
	at[13] = 2.8000;
	points[14] = (-280.2354, -3375.8584, 1902.2836);
	angles[14] = (0, -102.0310, 0);
	at[14] = 2.9000;
	points[15] = (-260.5103, -3393.4883, 1902.2836);
	angles[15] = (0, -125.1556, 0);
	at[15] = 3;
	points[16] = (-243.3453, -3413.1653, 1902.2836);
	angles[16] = (0, -135.8452, 0);
	at[16] = 3.1000;
	points[17] = (-226.9843, -3434.2207, 1902.2836);
	angles[17] = (0, -140.8257, 0);
	at[17] = 3.2000;
	points[18] = (-180.6752, -3499.7913, 1902.2836);
	angles[18] = (0, -145.2332, 0);
	at[18] = 3.5000;
	points[19] = (-118.5480, -3586.4883, 1902.2836);
	angles[19] = (0, -142.8117, 0);
	at[19] = 3.9000;
	points[20] = (-81.8244, -3625.7283, 1902.2836);
	angles[20] = (0, -134.2662, 0);
	at[20] = 4.1000;
	points[21] = (-60.8291, -3637.5750, 1902.2836);
	angles[21] = (0, -120.8406, 0);
	at[21] = 4.2000;
	points[22] = (-35.0658, -3645.2915, 1902.2836);
	angles[22] = (0, -109.4273, 0);
	at[22] = 4.3000;
	points[23] = (-8.2683, -3651.0237, 1902.2836);
	angles[23] = (0, -103.6118, 0);
	at[23] = 4.4000;
	points[24] = (70.4626, -3663.3623, 1902.2836);
	angles[24] = (0, -98.2829, 0);
	at[24] = 4.7000;
	points[25] = (228.4973, -3686.7993, 1902.2836);
	angles[25] = (0, -100.0691, 0);
	at[25] = 5.3000;
	points[26] = (281.1563, -3699.8152, 1902.2836);
	angles[26] = (0, -105.3727, 0);
	at[26] = 5.5000;
	points[27] = (305.4472, -3710.5198, 1902.2836);
	angles[27] = (0, -113.4402, 0);
	at[27] = 5.6000;
	points[28] = (319.5488, -3729.7717, 1902.2836);
	angles[28] = (0, -142.4071, 0);
	at[28] = 5.7000;
	points[29] = (320.0291, -3756.3267, 1902.2836);
	angles[29] = (0, -171.3777, 0);
	at[29] = 5.8000;
	points[30] = (315.8957, -3782.8308, 1902.2836);
	angles[30] = (0, -185.0507, 0);
	at[30] = 5.9000;
	points[31] = (309.7933, -3809.4805, 1902.2836);
	angles[31] = (0, -191.2076, 0);
	at[31] = 6;
	points[32] = (287.8106, -3886.0708, 1902.2836);
	angles[32] = (0, -196.6236, 0);
	at[32] = 6.3000;
	points[33] = (250.5575, -4014.5671, 1902.2836);
	angles[33] = (0, -194.4561, 0);
	at[33] = 6.8000;
	points[34] = (241.8122, -4066.2205, 1902.2836);
	angles[34] = (0, -187.5580, 0);
	at[34] = 7;
	points[35] = (243.6575, -4092.5195, 1902.2836);
	angles[35] = (0, -175.6540, 0);
	at[35] = 7.1000;
	points[36] = (255.6681, -4116.2598, 1902.2836);
	angles[36] = (0, -157.2621, 0);
	at[36] = 7.2000;
	points[37] = (271.1284, -4137.0869, 1902.2836);
	angles[37] = (0, -146.3796, 0);
	at[37] = 7.3000;
	points[38] = (288.4028, -4157.2837, 1902.2836);
	angles[38] = (0, -140.8703, 0);
	at[38] = 7.4000;
	points[39] = (325.1240, -4196.1416, 1902.2836);
	angles[39] = (0, -136.3920, 0);
	at[39] = 7.6000;
	points[40] = (400.8661, -4271.7324, 1902.2836);
	angles[40] = (0, -134.9385, 0);
	at[40] = 8;
	points[41] = (456.1851, -4329.8423, 1902.2836);
	angles[41] = (0, -137.4771, 0);
	at[41] = 8.3000;
	points[42] = (488.9488, -4372.0083, 1902.2836);
	angles[42] = (0, -144.0502, 0);
	at[42] = 8.5000;
	points[43] = (499.9882, -4396.1421, 1902.2836);
	angles[43] = (0, -155.3657, 0);
	at[43] = 8.6000;
	points[44] = (496.7520, -4420.9844, 1902.2836);
	angles[44] = (0, -182.4099, 0);
	at[44] = 8.7000;
	points[45] = (485.1654, -4444.5273, 1902.2836);
	angles[45] = (0, -201.1199, 0);
	at[45] = 8.8000;
	points[46] = (470.8268, -4466.8110, 1902.2836);
	angles[46] = (0, -210.3323, 0);
	at[46] = 8.9000;
	points[47] = (438.4370, -4509.4883, 1902.2836);
	angles[47] = (0, -217.6009, 0);
	at[47] = 9.1000;
	points[48] = (315.6713, -4650.5908, 1902.2836);
	angles[48] = (0, -221.1919, 0);
	at[48] = 9.8000;
	points[49] = (281.9421, -4691.7324, 1902.2836);
	angles[49] = (0, -218.4900, 0);
	at[49] = 10;
	points[50] = (268.0449, -4712.9526, 1902.2836);
	angles[50] = (0, -213.1399, 0);
	at[50] = 10.1000;
	points[51] = (248.4039, -4762.8345, 1902.2836);
	angles[51] = (0, -200.5374, 0);
	at[51] = 10.3000;
	points[52] = (218.0370, -4864.7642, 1902.2836);
	angles[52] = (0, -196.3398, 0);
	at[52] = 10.7000;
	points[53] = (183.4185, -4965.9058, 1902.2836);
	angles[53] = (0, -201.6108, 0);
	at[53] = 11.1000;
	points[54] = (171.4291, -4989.8032, 1902.2836);
	angles[54] = (0, -206.2627, 0);
	at[54] = 11.2000;
	points[55] = (155.1055, -5010.6694, 1902.2836);
	angles[55] = (0, -217.7243, 0);
	at[55] = 11.3000;
	points[56] = (131.4760, -5019.2124, 1902.2836);
	angles[56] = (0, -245.3448, 0);
	at[56] = 11.4000;
	points[57] = (105.1528, -5019.4492, 1902.2836);
	angles[57] = (0, -264.2275, 0);
	at[57] = 11.5000;
	points[58] = (78.8354, -5016.9688, 1902.2836);
	angles[58] = (0, -272.9282, 0);
	at[58] = 11.6000;
	points[59] = (52.0476, -5013.1890, 1902.2836);
	angles[59] = (0, -277.0179, 0);
	at[59] = 11.7000;
	points[60] = (-26.6894, -4998.7798, 1902.2836);
	angles[60] = (0, -280.7935, 0);
	at[60] = 12;
	points[61] = (-105.4295, -4983.7793, 1902.2836);
	angles[61] = (0, -280.4076, 0);
	at[61] = 12.3000;
	points[62] = (-157.9122, -4975.7876, 1902.2836);
	angles[62] = (0, -278.0053, 0);
	at[62] = 12.5000;
	points[63] = (-211.8154, -4973.7798, 1902.2836);
	angles[63] = (0, -269.5255, 0);
	at[63] = 12.7000;
	points[64] = (-234.9716, -4980.3545, 1902.2836);
	angles[64] = (0, -255.5007, 0);
	at[64] = 12.8000;
	points[65] = (-258.1843, -4993.8188, 1902.2836);
	angles[65] = (0, -242.8947, 0);
	at[65] = 12.9000;
	points[66] = (-280.4047, -5009.6460, 1902.2836);
	angles[66] = (0, -236.2643, 0);
	at[66] = 13;
	points[67] = (-342.2370, -5060.2363, 1902.2836);
	angles[67] = (0, -229.9163, 0);
	at[67] = 13.3000;
	points[68] = (-422.8740, -5129.8428, 1902.2836);
	angles[68] = (0, -229.4658, 0);
	at[68] = 13.7000;
	points[69] = (-485.7086, -5179.1729, 1902.2836);
	angles[69] = (0, -233.7372, 0);
	at[69] = 14;
	points[70] = (-508.9173, -5193.2285, 1902.2836);
	angles[70] = (0, -238.6649, 0);
	at[70] = 14.1000;
	points[71] = (-533.5236, -5199.6455, 1902.2836);
	angles[71] = (0, -257.0127, 0);
	at[71] = 14.2000;
	points[72] = (-554.7835, -5185.3540, 1902.2836);
	angles[72] = (0, -295.3615, 0);
	at[72] = 14.3000;
	points[73] = (-571.2874, -5164.1733, 1902.2836);
	angles[73] = (0, -316.1351, 0);
	at[73] = 14.4000;
	points[74] = (-585.7992, -5141.2207, 1902.2836);
	angles[74] = (0, -325.1263, 0);
	at[74] = 14.5000;
	points[75] = (-624.0591, -5071.1025, 1902.2836);
	angles[75] = (0, -331.9643, 0);
	at[75] = 14.8000;
	points[76] = (-675.5316, -4977.4019, 1902.2836);
	angles[76] = (0, -329.6562, 0);
	at[76] = 15.2000;
	points[77] = (-706.2598, -4934.7246, 1902.2836);
	angles[77] = (0, -321.9811, 0);
	at[77] = 15.4000;
	points[78] = (-726.2717, -4918.1890, 1902.2836);
	angles[78] = (0, -309.4463, 0);
	at[78] = 15.5000;
	points[79] = (-751.6890, -4909.5278, 1902.2836);
	angles[79] = (0, -292.7790, 0);
	at[79] = 15.6000;
	points[80] = (-777.0237, -4904.5669, 1902.2836);
	angles[80] = (0, -283.6488, 0);
	at[80] = 15.7000;
	points[81] = (-830.4291, -4897.8740, 1902.2836);
	angles[81] = (0, -276.8929, 0);
	at[81] = 15.9000;
	points[82] = (-883.5315, -4893.1890, 1902.2836);
	angles[82] = (0, -274.9265, 0);
	at[82] = 16.1000;
	points[83] = (-1016.6732, -4882.0078, 1902.2836);
	angles[83] = (0, -275.5193, 0);
	at[83] = 16.6000;
	points[84] = (-1095.1851, -4870.3545, 1902.2836);
	angles[84] = (0, -280.4802, 0);
	at[84] = 16.9000;
	points[85] = (-1121.3149, -4863.0317, 1902.2836);
	angles[85] = (0, -285.4113, 0);
	at[85] = 17;
	points[86] = (-1144.2599, -4850.1968, 1902.2836);
	angles[86] = (0, -299.8018, 0);
	at[86] = 17.1000;
	points[87] = (-1153.5906, -4826.2598, 1902.2836);
	angles[87] = (0, -331.8685, 0);
	at[87] = 17.2000;
	points[88] = (-1154.7599, -4800.1182, 1902.2836);
	angles[88] = (0, -351.7390, 0);
	at[88] = 17.3000;
	points[89] = (-1153.1023, -4773.9370, 1902.2836);
	angles[89] = (0, -361.0655, 0);
	at[89] = 17.4000;
	points[90] = (-1149.8859, -4746.8506, 1902.2836);
	angles[90] = (0, -365.6046, 0);
	at[90] = 17.5000;
	points[91] = (-1131.4370, -4641.8506, 1902.2836);
	angles[91] = (0, -370.7878, 0);
	at[91] = 17.9000;
	points[92] = (-1108.0039, -4510.7876, 1902.2836);
	angles[92] = (0, -368.5127, 0);
	at[92] = 18.4000;
	points[93] = (-1104.7914, -4456.6929, 1902.2836);
	angles[93] = (0, -361.0949, 0);
	at[93] = 18.6000;
	points[94] = (-1110.4882, -4433.2681, 1902.2836);
	angles[94] = (0, -347.1480, 0);
	at[94] = 18.7000;
	points[95] = (-1124.2914, -4410.3545, 1902.2836);
	angles[95] = (0, -332.2609, 0);
	at[95] = 18.8000;
	points[96] = (-1141.0433, -4389.0552, 1902.2836);
	angles[96] = (0, -323.9313, 0);
	at[96] = 18.9000;
	points[97] = (-1176.9370, -4349.8818, 1902.2836);
	angles[97] = (0, -317.1675, 0);
	at[97] = 19.1000;
	points[98] = (-1214.5945, -4311.9292, 1902.2836);
	angles[98] = (0, -315.1487, 0);
	at[98] = 19.3000;
	points[99] = (-1271.0865, -4254.8818, 1902.2836);
	angles[99] = (0, -315.8447, 0);
	at[99] = 19.6000;
	points[100] = (-1306.2048, -4215.0391, 1902.2836);
	angles[100] = (0, -319.6746, 0);
	at[100] = 19.8000;
	points[101] = (-1321.6732, -4192.9526, 1902.2836);
	angles[101] = (0, -324.7579, 0);
	at[101] = 19.9000;
	points[102] = (-1330.8701, -4168.5830, 1902.2836);
	angles[102] = (0, -339.5848, 0);
	at[102] = 20;
	points[103] = (-1324.0787, -4143.8188, 1902.2836);
	angles[103] = (0, -368.9029, 0);
	at[103] = 20.1000;
	points[104] = (-1310.2834, -4120.6694, 1902.2836);
	angles[104] = (0, -385.9534, 0);
	at[104] = 20.2000;
	points[105] = (-1294.9960, -4099.7246, 1902.2836);
	angles[105] = (0, -393.8949, 0);
	at[105] = 20.3000;
	points[106] = (-1260.6615, -4058.3464, 1902.2836);
	angles[106] = (0, -399.9978, 0);
	at[106] = 20.5000;
	points[107] = (-1188.8032, -3979.6064, 1902.2836);
	angles[107] = (0, -402.8144, 0);
	at[107] = 20.9000;
	points[108] = (-1135.1141, -3920.5630, 1902.2836);
	angles[108] = (0, -401.6632, 0);
	at[108] = 21.2000;
	points[109] = (-1102.1497, -3878.3467, 1902.2836);
	angles[109] = (0, -396.0399, 0);
	at[109] = 21.4000;
	points[110] = (-1082.0157, -3830.7915, 1902.2836);
	angles[110] = (0, -381.4398, 0);
	at[110] = 21.6000;
	points[111] = (-1074.0511, -3805.3149, 1902.2836);
	angles[111] = (0, -378.1943, 0);
	at[111] = 21.7000;
	points[112] = (-1045.1929, -3702.4331, 1902.2836);
	angles[112] = (0, -375.6357, 0);
	at[112] = 22.1000;
	points[113] = (-1011.5748, -3601.0078, 1902.2836);
	angles[113] = (0, -381.1004, 0);
	at[113] = 22.5000;
	points[114] = (-999.7323, -3576.9055, 1902.2836);
	angles[114] = (0, -385.8255, 0);
	at[114] = 22.6000;
	points[115] = (-980.1182, -3553.6575, 1902.2836);
	angles[115] = (0, -401.9165, 0);
	at[115] = 22.7167;
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
	points[0] = (2392.7676, -4285.6694, 1902.2836);
	angles[0] = (0, -118.3877, 0);
	at[0] = 0;
	points[1] = (2405.4412, -4308.6221, 1902.2836);
	angles[1] = (0, -145.0688, 0);
	at[1] = 0.1000;
	points[2] = (2413.0786, -4334.6064, 1902.2836);
	angles[2] = (0, -159.6201, 0);
	at[2] = 0.2000;
	points[3] = (2422.5591, -4386.6929, 1902.2836);
	angles[3] = (0, -170.0425, 0);
	at[3] = 0.4000;
	points[4] = (2431.8938, -4466.4175, 1902.2836);
	angles[4] = (0, -173.8750, 0);
	at[4] = 0.7000;
	points[5] = (2442.9883, -4572.7954, 1902.2836);
	angles[5] = (0, -173.4553, 0);
	at[5] = 1.1000;
	points[6] = (2451.3110, -4624.8818, 1902.2836);
	angles[6] = (0, -169.8145, 0);
	at[6] = 1.3000;
	points[7] = (2458.8110, -4650.3545, 1902.2836);
	angles[7] = (0, -163.4589, 0);
	at[7] = 1.4000;
	points[8] = (2472.3110, -4672.8350, 1902.2836);
	angles[8] = (0, -151.3993, 0);
	at[8] = 1.5000;
	points[9] = (2506.3779, -4712.9922, 1902.2836);
	angles[9] = (0, -139.1902, 0);
	at[9] = 1.7000;
	points[10] = (2599.6851, -4808.5435, 1902.2836);
	angles[10] = (0, -135.8209, 0);
	at[10] = 2.2000;
	points[11] = (2651.7913, -4868.9766, 1902.2836);
	angles[11] = (0, -141.8715, 0);
	at[11] = 2.5000;
	points[12] = (2665.2876, -4891.9683, 1902.2836);
	angles[12] = (0, -149.4638, 0);
	at[12] = 2.6000;
	points[13] = (2667.3267, -4916.6538, 1902.2836);
	angles[13] = (0, -174.9962, 0);
	at[13] = 2.7000;
	points[14] = (2654.5510, -4940, 1902.2836);
	angles[14] = (0, -201.7719, 0);
	at[14] = 2.8000;
	points[15] = (2638.0630, -4961.1025, 1902.2836);
	angles[15] = (0, -214.4597, 0);
	at[15] = 2.9000;
	points[16] = (2601.7129, -5000.5117, 1902.2836);
	angles[16] = (0, -222.9409, 0);
	at[16] = 3.1000;
	points[17] = (2544.8623, -5056.9688, 1902.2836);
	angles[17] = (0, -225.4018, 0);
	at[17] = 3.4000;
	points[18] = (2488.4844, -5114.1729, 1902.2836);
	angles[18] = (0, -223.7786, 0);
	at[18] = 3.7000;
	points[19] = (2454.6890, -5154.4492, 1902.2836);
	angles[19] = (0, -218.3949, 0);
	at[19] = 3.9000;
	points[20] = (2441.7480, -5177.3228, 1902.2836);
	angles[20] = (0, -209.2691, 0);
	at[20] = 4;
	points[21] = (2436.4766, -5203.3071, 1902.2836);
	angles[21] = (0, -194.6236, 0);
	at[21] = 4.1000;
	points[22] = (2434.8701, -5229.5278, 1902.2836);
	angles[22] = (0, -185.8697, 0);
	at[22] = 4.2000;
	points[23] = (2435.3977, -5283.0312, 1902.2836);
	angles[23] = (0, -179.1797, 0);
	at[23] = 4.4000;
	points[24] = (2437.7678, -5336.2598, 1902.2836);
	angles[24] = (0, -177.3894, 0);
	at[24] = 4.6000;
	points[25] = (2441.8191, -5443.1104, 1902.2836);
	angles[25] = (0, -178.8358, 0);
	at[25] = 5;
	points[26] = (2439.9685, -5495.9448, 1902.2836);
	angles[26] = (0, -183.2129, 0);
	at[26] = 5.2000;
	points[27] = (2435.6733, -5522.6377, 1902.2836);
	angles[27] = (0, -188.9216, 0);
	at[27] = 5.3000;
	points[28] = (2424.3938, -5545.8267, 1902.2836);
	angles[28] = (0, -206.6739, 0);
	at[28] = 5.4000;
	points[29] = (2400.6379, -5555.8662, 1902.2836);
	angles[29] = (0, -239.4626, 0);
	at[29] = 5.5000;
	points[30] = (2373.6931, -5559.4492, 1902.2836);
	angles[30] = (0, -257.2638, 0);
	at[30] = 5.6000;
	points[31] = (2347.9490, -5560.5513, 1902.2836);
	angles[31] = (0, -265.2093, 0);
	at[31] = 5.7000;
	points[32] = (2320.9763, -5560.5903, 1902.2836);
	angles[32] = (0, -269.0014, 0);
	at[32] = 5.8000;
	points[33] = (2214.2085, -5555.9448, 1902.2836);
	angles[33] = (0, -273.0481, 0);
	at[33] = 6.2000;
	points[34] = (2107.2678, -5551.6533, 1902.2836);
	angles[34] = (0, -271.2122, 0);
	at[34] = 6.6000;
	points[35] = (2054.7441, -5553.8979, 1902.2836);
	angles[35] = (0, -266.0070, 0);
	at[35] = 6.8000;
	points[36] = (2028.8149, -5559.8032, 1902.2836);
	angles[36] = (0, -256.8563, 0);
	at[36] = 6.9000;
	points[37] = (2007.2875, -5574.7246, 1902.2836);
	angles[37] = (0, -238.8202, 0);
	at[37] = 7;
	points[38] = (1989.2166, -5593.6611, 1902.2836);
	angles[38] = (0, -226.8763, 0);
	at[38] = 7.1000;
	points[39] = (1972.5787, -5614.1733, 1902.2836);
	angles[39] = (0, -220.6588, 0);
	at[39] = 7.2000;
	points[40] = (1941.1537, -5657.5986, 1902.2836);
	angles[40] = (0, -215.6380, 0);
	at[40] = 7.4000;
	points[41] = (1895.9055, -5723.7798, 1902.2836);
	angles[41] = (0, -214.4358, 0);
	at[41] = 7.7000;
	points[42] = (1847.9174, -5788.1494, 1902.2836);
	angles[42] = (0, -218.5355, 0);
	at[42] = 8;
	points[43] = (1829.4922, -5807.5986, 1902.2836);
	angles[43] = (0, -223.1142, 0);
	at[43] = 8.1000;
	points[44] = (1807.5709, -5822.3623, 1902.2836);
	angles[44] = (0, -235.8719, 0);
	at[44] = 8.2000;
	points[45] = (1783.1063, -5819.6060, 1902.2836);
	angles[45] = (0, -270.3508, 0);
	at[45] = 8.3000;
	points[46] = (1760.2716, -5806.6147, 1902.2836);
	angles[46] = (0, -293.0672, 0);
	at[46] = 8.4000;
	points[47] = (1738.7323, -5791.0630, 1902.2836);
	angles[47] = (0, -303.0324, 0);
	at[47] = 8.5000;
	points[48] = (1697.4528, -5756.9292, 1902.2836);
	angles[48] = (0, -309.8256, 0);
	at[48] = 8.7000;
	points[49] = (1618.1024, -5685.1973, 1902.2836);
	angles[49] = (0, -312.4861, 0);
	at[49] = 9.1000;
	points[50] = (1538.5552, -5614.6060, 1902.2836);
	angles[50] = (0, -310.3954, 0);
	at[50] = 9.5000;
	points[51] = (1494.4764, -5582.7559, 1902.2836);
	angles[51] = (0, -303.6848, 0);
	at[51] = 9.7000;
	points[52] = (1471.6575, -5574.6851, 1902.2836);
	angles[52] = (0, -290.6422, 0);
	at[52] = 9.8000;
	points[53] = (1445.0631, -5572.4805, 1902.2836);
	angles[53] = (0, -277.6965, 0);
	at[53] = 9.9000;
	points[54] = (1418.2244, -5573.1104, 1902.2836);
	angles[54] = (0, -270.4894, 0);
	at[54] = 10;
	points[55] = (1364.9882, -5577.7949, 1902.2836);
	angles[55] = (0, -264.6880, 0);
	at[55] = 10.2000;
	points[56] = (1311.9686, -5584.0557, 1902.2836);
	angles[56] = (0, -263.3099, 0);
	at[56] = 10.4000;
	points[57] = (1258.6654, -5589.7246, 1902.2836);
	angles[57] = (0, -264.3501, 0);
	at[57] = 10.6000;
	points[58] = (1205.7677, -5591.6538, 1902.2836);
	angles[58] = (0, -269.4269, 0);
	at[58] = 10.8000;
	points[59] = (1179.4489, -5588.2280, 1902.2836);
	angles[59] = (0, -277.3066, 0);
	at[59] = 10.9000;
	points[60] = (1159.0355, -5574.3701, 1902.2836);
	angles[60] = (0, -304.7510, 0);
	at[60] = 11;
	points[61] = (1151.5826, -5548.8979, 1902.2836);
	angles[61] = (0, -335.5731, 0);
	at[61] = 11.1000;
	points[62] = (1148.5787, -5521.9292, 1902.2836);
	angles[62] = (0, -349.6066, 0);
	at[62] = 11.2000;
	points[63] = (1147.3149, -5495.0396, 1902.2836);
	angles[63] = (0, -355.6053, 0);
	at[63] = 11.3000;
	points[64] = (1147.5000, -5415.2363, 1902.2836);
	angles[64] = (0, -360.7153, 0);
	at[64] = 11.6000;
	points[65] = (1149.4883, -5308.3467, 1902.2836);
	angles[65] = (0, -360.6542, 0);
	at[65] = 12;
	points[66] = (1146.6063, -5228.0317, 1902.2836);
	angles[66] = (0, -355.9407, 0);
	at[66] = 12.3000;
	points[67] = (1141.9803, -5201.5356, 1902.2836);
	angles[67] = (0, -350.3579, 0);
	at[67] = 12.4000;
	points[68] = (1131.3937, -5179.8032, 1902.2836);
	angles[68] = (0, -335.5359, 0);
	at[68] = 12.5000;
	points[69] = (1113.7834, -5159.7637, 1902.2836);
	angles[69] = (0, -321.9201, 0);
	at[69] = 12.6000;
	points[70] = (1093.9843, -5141.4570, 1902.2836);
	angles[70] = (0, -314.6213, 0);
	at[70] = 12.7000;
	points[71] = (1052.5787, -5107.8345, 1902.2836);
	angles[71] = (0, -308.7950, 0);
	at[71] = 12.9000;
	points[72] = (988.5472, -5059.3701, 1902.2836);
	angles[72] = (0, -307.0541, 0);
	at[72] = 13.2000;
	points[73] = (906.8150, -4991.4175, 1902.2836);
	angles[73] = (0, -313.0621, 0);
	at[73] = 13.6000;
	points[74] = (890.0157, -4970.8271, 1902.2836);
	angles[74] = (0, -320.7532, 0);
	at[74] = 13.7000;
	points[75] = (885.8505, -4946.6934, 1902.2836);
	angles[75] = (0, -350.4197, 0);
	at[75] = 13.8000;
	points[76] = (899.2637, -4923.7007, 1902.2836);
	angles[76] = (0, -381.8586, 0);
	at[76] = 13.9000;
	points[77] = (916.5906, -4903.2676, 1902.2836);
	angles[77] = (0, -396.1677, 0);
	at[77] = 14;
	points[78] = (935.5197, -4883.7007, 1902.2836);
	angles[78] = (0, -402.3489, 0);
	at[78] = 14.1000;
	points[79] = (974.1142, -4847.1650, 1902.2836);
	angles[79] = (0, -406.7275, 0);
	at[79] = 14.3000;
	points[80] = (1053.1851, -4775.1577, 1902.2836);
	angles[80] = (0, -407.3544, 0);
	at[80] = 14.7000;
	points[81] = (1109.4292, -4717.8740, 1902.2836);
	angles[81] = (0, -402.3201, 0);
	at[81] = 15;
	points[82] = (1125.2205, -4696.2202, 1902.2836);
	angles[82] = (0, -396.4068, 0);
	at[82] = 15.1000;
	points[83] = (1133.4252, -4673.5435, 1902.2836);
	angles[83] = (0, -381.4165, 0);
	at[83] = 15.2000;
	points[84] = (1135.7480, -4646.8896, 1902.2836);
	angles[84] = (0, -368.1608, 0);
	at[84] = 15.3000;
	points[85] = (1135.5118, -4619.7246, 1902.2836);
	angles[85] = (0, -361.2924, 0);
	at[85] = 15.4000;
	points[86] = (1131.9922, -4566.6533, 1902.2836);
	angles[86] = (0, -355.9633, 0);
	at[86] = 15.6000;
	points[87] = (1117.6260, -4407.1260, 1902.2836);
	angles[87] = (0, -356.1727, 0);
	at[87] = 16.2000;
	points[88] = (1117.7166, -4353.3462, 1902.2836);
	angles[88] = (0, -361.6746, 0);
	at[88] = 16.4000;
	points[89] = (1122.8937, -4327.2051, 1902.2836);
	angles[89] = (0, -370.9905, 0);
	at[89] = 16.5000;
	points[90] = (1140.5630, -4311.2598, 1902.2836);
	angles[90] = (0, -405.0094, 0);
	at[90] = 16.6000;
	points[91] = (1166.9135, -4307.7559, 1902.2836);
	angles[91] = (0, -434.2279, 0);
	at[91] = 16.7000;
	points[92] = (1193.5591, -4308.1499, 1902.2836);
	angles[92] = (0, -447.1534, 0);
	at[92] = 16.8000;
	points[93] = (1220.7362, -4310.1968, 1902.2836);
	angles[93] = (0, -452.7673, 0);
	at[93] = 16.9000;
	points[94] = (1300.0157, -4319.9214, 1902.2836);
	angles[94] = (0, -457.5056, 0);
	at[94] = 17.2000;
	points[95] = (1432.7874, -4335.9058, 1902.2836);
	angles[95] = (0, -455.1045, 0);
	at[95] = 17.7000;
	points[96] = (1485.6929, -4335.9448, 1902.2836);
	angles[96] = (0, -447.8878, 0);
	at[96] = 17.9000;
	points[97] = (1510.1024, -4329.2915, 1902.2836);
	angles[97] = (0, -434.4578, 0);
	at[97] = 18;
	points[98] = (1531.1062, -4312.8345, 1902.2836);
	angles[98] = (0, -416.0094, 0);
	at[98] = 18.1000;
	points[99] = (1549.3662, -4293.1494, 1902.2836);
	angles[99] = (0, -405.6668, 0);
	at[99] = 18.2000;
	points[100] = (1582.1732, -4251.2207, 1902.2836);
	angles[100] = (0, -397.7267, 0);
	at[100] = 18.4000;
	points[101] = (1628.2638, -4185.9053, 1902.2836);
	angles[101] = (0, -394.8519, 0);
	at[101] = 18.7000;
	points[102] = (1689.9174, -4099.1338, 1902.2836);
	angles[102] = (0, -396.4683, 0);
	at[102] = 19.1000;
	points[103] = (1725.0472, -4057.7954, 1902.2836);
	angles[103] = (0, -401.9815, 0);
	at[103] = 19.3000;
	points[104] = (1746.0787, -4041.5354, 1902.2836);
	angles[104] = (0, -412.2717, 0);
	at[104] = 19.4000;
	points[105] = (1770.6930, -4042.5198, 1902.2836);
	angles[105] = (0, -446.8080, 0);
	at[105] = 19.5000;
	points[106] = (1793.6458, -4055.8660, 1902.2836);
	angles[106] = (0, -472.6858, 0);
	at[106] = 19.6000;
	points[107] = (1814.2678, -4071.8899, 1902.2836);
	angles[107] = (0, -484.4324, 0);
	at[107] = 19.7000;
	points[108] = (1854.0591, -4107.9531, 1902.2836);
	angles[108] = (0, -492.4382, 0);
	at[108] = 19.9000;
	points[109] = (1910.9095, -4164.0156, 1902.2836);
	angles[109] = (0, -494.7742, 0);
	at[109] = 20.2000;
	points[110] = (1968.8188, -4219.3701, 1902.2836);
	angles[110] = (0, -492.6720, 0);
	at[110] = 20.5000;
	points[111] = (2011.5828, -4251.9688, 1902.2836);
	angles[111] = (0, -484.8959, 0);
	at[111] = 20.7000;
	points[112] = (2034.2874, -4260.4727, 1902.2836);
	angles[112] = (0, -471.8449, 0);
	at[112] = 20.8000;
	points[113] = (2060.8228, -4264.0947, 1902.2836);
	angles[113] = (0, -460.5384, 0);
	at[113] = 20.9000;
	points[114] = (2114.5591, -4266.0630, 1902.2836);
	angles[114] = (0, -451.7649, 0);
	at[114] = 21.1000;
	points[115] = (2168.0474, -4265.6299, 1902.2836);
	angles[115] = (0, -449.4289, 0);
	at[115] = 21.3000;
	points[116] = (2328.2402, -4266.8896, 1902.2836);
	angles[116] = (0, -453.3569, 0);
	at[116] = 21.9000;
	points[117] = (2354.8228, -4270.3149, 1902.2836);
	angles[117] = (0, -456.9543, 0);
	at[117] = 22;
	points[118] = (2380.4490, -4277.4805, 1902.2836);
	angles[118] = (0, -465.2135, 0);
	at[118] = 22.1000;
	points[119] = (2392.7676, -4285.6694, 1902.2836);
	angles[119] = (0, -478.3877, 0);
	at[119] = 22.1667;
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
	points[0] = (-169.2902, -6758.7012, 1902.2836);
	angles[0] = (0, -101.7451, 0);
	at[0] = 0;
	points[1] = (-155.4221, -6780.0396, 1902.2836);
	angles[1] = (0, -138.3521, 0);
	at[1] = 0.1000;
	points[2] = (-147.4232, -6805.5908, 1902.2836);
	angles[2] = (0, -157.1657, 0);
	at[2] = 0.2000;
	points[3] = (-141.5142, -6831.9297, 1902.2836);
	angles[3] = (0, -165.0841, 0);
	at[3] = 0.3000;
	points[4] = (-132.3858, -6884.3706, 1902.2836);
	angles[4] = (0, -170.2421, 0);
	at[4] = 0.5000;
	points[5] = (-115.4142, -6989.9604, 1902.2836);
	angles[5] = (0, -170.0832, 0);
	at[5] = 0.9000;
	points[6] = (-103.0894, -7041.4961, 1902.2836);
	angles[6] = (0, -164.9865, 0);
	at[6] = 1.1000;
	points[7] = (-92.4173, -7065.1968, 1902.2836);
	angles[7] = (0, -155.4390, 0);
	at[7] = 1.2000;
	points[8] = (-74.4260, -7084.3311, 1902.2836);
	angles[8] = (0, -140.1062, 0);
	at[8] = 1.3000;
	points[9] = (-53.4441, -7101.3384, 1902.2836);
	angles[9] = (0, -131.3743, 0);
	at[9] = 1.4000;
	points[10] = (-10.2076, -7131.8506, 1902.2836);
	angles[10] = (0, -125.0182, 0);
	at[10] = 1.6000;
	points[11] = (56.7217, -7176.1812, 1902.2836);
	angles[11] = (0, -123.5350, 0);
	at[11] = 1.9000;
	points[12] = (122.2346, -7222.5591, 1902.2836);
	angles[12] = (0, -126.7514, 0);
	at[12] = 2.2000;
	points[13] = (142.5063, -7239.9609, 1902.2836);
	angles[13] = (0, -130.3586, 0);
	at[13] = 2.3000;
	points[14] = (159.4063, -7260.5908, 1902.2836);
	angles[14] = (0, -140.6396, 0);
	at[14] = 2.4000;
	points[15] = (159.5244, -7285.4331, 1902.2836);
	angles[15] = (0, -174.3929, 0);
	at[15] = 2.5000;
	points[16] = (148.2260, -7309.3701, 1902.2836);
	angles[16] = (0, -198.3366, 0);
	at[16] = 2.6000;
	points[17] = (134.0284, -7332.0469, 1902.2836);
	angles[17] = (0, -208.9628, 0);
	at[17] = 2.7000;
	points[18] = (103.0032, -7375.0786, 1902.2836);
	angles[18] = (0, -215.9632, 0);
	at[18] = 2.9000;
	points[19] = (54.2717, -7438.8188, 1902.2836);
	angles[19] = (0, -217.2348, 0);
	at[19] = 3.2000;
	points[20] = (9.4903, -7504.9609, 1902.2836);
	angles[20] = (0, -211.3913, 0);
	at[20] = 3.5000;
	points[21] = (-0.4679, -7529.1733, 1902.2836);
	angles[21] = (0, -202.2282, 0);
	at[21] = 3.6000;
	points[22] = (-1.6677, -7555.1968, 1902.2836);
	angles[22] = (0, -186.0878, 0);
	at[22] = 3.7000;
	points[23] = (1.1004, -7581.8901, 1902.2836);
	angles[23] = (0, -176.6700, 0);
	at[23] = 3.8000;
	points[24] = (5.2331, -7607.7163, 1902.2836);
	angles[24] = (0, -172.1474, 0);
	at[24] = 3.9000;
	points[25] = (31.5162, -7738.6226, 1902.2836);
	angles[25] = (0, -168.7871, 0);
	at[25] = 4.4000;
	points[26] = (42.7528, -7817.5200, 1902.2836);
	angles[26] = (0, -174.3260, 0);
	at[26] = 4.7000;
	points[27] = (42.1020, -7844.0947, 1902.2836);
	angles[27] = (0, -181.3581, 0);
	at[27] = 4.8000;
	points[28] = (30.5949, -7866.1025, 1902.2836);
	angles[28] = (0, -208.2578, 0);
	at[28] = 4.9000;
	points[29] = (6.1790, -7876.7720, 1902.2836);
	angles[29] = (0, -238.5215, 0);
	at[29] = 5;
	points[30] = (-19.8369, -7882.9531, 1902.2836);
	angles[30] = (0, -252.5617, 0);
	at[30] = 5.1000;
	points[31] = (-72.9468, -7891.0239, 1902.2836);
	angles[31] = (0, -261.5870, 0);
	at[31] = 5.3000;
	points[32] = (-179.2012, -7902.4014, 1902.2836);
	angles[32] = (0, -263.9152, 0);
	at[32] = 5.7000;
	points[33] = (-258.6579, -7914.0552, 1902.2836);
	angles[33] = (0, -259.8365, 0);
	at[33] = 6;
	points[34] = (-284.3665, -7921.2207, 1902.2836);
	angles[34] = (0, -254.6846, 0);
	at[34] = 6.1000;
	points[35] = (-305.1480, -7934.0161, 1902.2836);
	angles[35] = (0, -239.1204, 0);
	at[35] = 6.2000;
	points[36] = (-322.1012, -7954.6851, 1902.2836);
	angles[36] = (0, -223.1636, 0);
	at[36] = 6.3000;
	points[37] = (-336.6429, -7977.2837, 1902.2836);
	angles[37] = (0, -214.9274, 0);
	at[37] = 6.4000;
	points[38] = (-350.1012, -8000.7480, 1902.2836);
	angles[38] = (0, -210.8979, 0);
	at[38] = 6.5000;
	points[39] = (-375.0307, -8047.7559, 1902.2836);
	angles[39] = (0, -207.8436, 0);
	at[39] = 6.7000;
	points[40] = (-412.4173, -8118.8188, 1902.2836);
	angles[40] = (0, -208.3300, 0);
	at[40] = 7;
	points[41] = (-440.0709, -8163.8979, 1902.2836);
	angles[41] = (0, -212.9156, 0);
	at[41] = 7.2000;
	points[42] = (-457.2756, -8183.8979, 1902.2836);
	angles[42] = (0, -220.7744, 0);
	at[42] = 7.3000;
	points[43] = (-480.6181, -8190.1973, 1902.2836);
	angles[43] = (0, -255.4582, 0);
	at[43] = 7.4000;
	points[44] = (-503.7244, -8176.6934, 1902.2836);
	angles[44] = (0, -290.2511, 0);
	at[44] = 7.5000;
	points[45] = (-524.3976, -8159.8032, 1902.2836);
	angles[45] = (0, -304.9011, 0);
	at[45] = 7.6000;
	points[46] = (-544.4055, -8141.4565, 1902.2836);
	angles[46] = (0, -310.8177, 0);
	at[46] = 7.7000;
	points[47] = (-601.1851, -8085, 1902.2836);
	angles[47] = (0, -315.2136, 0);
	at[47] = 8;
	points[48] = (-677.3898, -8009.9214, 1902.2836);
	angles[48] = (0, -313.4053, 0);
	at[48] = 8.4000;
	points[49] = (-718.5040, -7976.2598, 1902.2836);
	angles[49] = (0, -307.5770, 0);
	at[49] = 8.6000;
	points[50] = (-741.9489, -7964.2129, 1902.2836);
	angles[50] = (0, -296.8719, 0);
	at[50] = 8.7000;
	points[51] = (-767.7756, -7964.4487, 1902.2836);
	angles[51] = (0, -274.1450, 0);
	at[51] = 8.8000;
	points[52] = (-793.5000, -7970.8667, 1902.2836);
	angles[52] = (0, -259.9376, 0);
	at[52] = 8.9000;
	points[53] = (-818.3111, -7979.3311, 1902.2836);
	angles[53] = (0, -253.0458, 0);
	at[53] = 9;
	points[54] = (-868.1142, -7999.4097, 1902.2836);
	angles[54] = (0, -247.7919, 0);
	at[54] = 9.2000;
	points[55] = (-941.4725, -8031.4565, 1902.2836);
	angles[55] = (0, -246.4425, 0);
	at[55] = 9.5000;
	points[56] = (-1016, -8060.7876, 1902.2836);
	angles[56] = (0, -250.3053, 0);
	at[56] = 9.8000;
	points[57] = (-1042.0472, -8067.4409, 1902.2836);
	angles[57] = (0, -255.4872, 0);
	at[57] = 9.9000;
	points[58] = (-1066.8859, -8065.1973, 1902.2836);
	angles[58] = (0, -277.3560, 0);
	at[58] = 10;
	points[59] = (-1080.6182, -8043.3462, 1902.2836);
	angles[59] = (0, -317.7014, 0);
	at[59] = 10.1000;
	points[60] = (-1088.3818, -8017.6377, 1902.2836);
	angles[60] = (0, -337.4113, 0);
	at[60] = 10.2000;
	points[61] = (-1094.0513, -7991.1421, 1902.2836);
	angles[61] = (0, -345.5731, 0);
	at[61] = 10.3000;
	points[62] = (-1106.2953, -7912.0864, 1902.2836);
	angles[62] = (0, -351.7878, 0);
	at[62] = 10.6000;
	points[63] = (-1122.0197, -7806.3389, 1902.2836);
	angles[63] = (0, -350.4233, 0);
	at[63] = 11;
	points[64] = (-1135.2874, -7754.4883, 1902.2836);
	angles[64] = (0, -343.4414, 0);
	at[64] = 11.2000;
	points[65] = (-1148.1732, -7733.7012, 1902.2836);
	angles[65] = (0, -328.9035, 0);
	at[65] = 11.3000;
	points[66] = (-1168.4646, -7716.2993, 1902.2836);
	angles[66] = (0, -314.1610, 0);
	at[66] = 11.4000;
	points[67] = (-1190.5828, -7701.0630, 1902.2836);
	angles[67] = (0, -306.5401, 0);
	at[67] = 11.5000;
	points[68] = (-1236.3779, -7673.3862, 1902.2836);
	angles[68] = (0, -300.9653, 0);
	at[68] = 11.7000;
	points[69] = (-1351.1339, -7605.1182, 1902.2836);
	angles[69] = (0, -302.8154, 0);
	at[69] = 12.2000;
	points[70] = (-1372.2244, -7589.4883, 1902.2836);
	angles[70] = (0, -306.3557, 0);
	at[70] = 12.3000;
	points[71] = (-1391.0865, -7570.2363, 1902.2836);
	angles[71] = (0, -315.5457, 0);
	at[71] = 12.4000;
	points[72] = (-1394.5867, -7546.3779, 1902.2836);
	angles[72] = (0, -349.5918, 0);
	at[72] = 12.5000;
	points[73] = (-1382.4882, -7522.5200, 1902.2836);
	angles[73] = (0, -378.6280, 0);
	at[73] = 12.6000;
	points[74] = (-1367.3464, -7500.6304, 1902.2836);
	angles[74] = (0, -391.0464, 0);
	at[74] = 12.7000;
	points[75] = (-1350.7479, -7479.2129, 1902.2836);
	angles[75] = (0, -396.3007, 0);
	at[75] = 12.8000;
	points[76] = (-1299.1221, -7417.9927, 1902.2836);
	angles[76] = (0, -400.5783, 0);
	at[76] = 13.1000;
	points[77] = (-1230.0355, -7336.2993, 1902.2836);
	angles[77] = (0, -399.2632, 0);
	at[77] = 13.5000;
	points[78] = (-1198.9961, -7293.1890, 1902.2836);
	angles[78] = (0, -394.2471, 0);
	at[78] = 13.7000;
	points[79] = (-1187.7087, -7269.2915, 1902.2836);
	angles[79] = (0, -385.0691, 0);
	at[79] = 13.8000;
	points[80] = (-1187.4646, -7243.5039, 1902.2836);
	angles[80] = (0, -364.4990, 0);
	at[80] = 13.9000;
	points[81] = (-1193.2914, -7217.4805, 1902.2836);
	angles[81] = (0, -351.0379, 0);
	at[81] = 14;
	points[82] = (-1201.1456, -7192.5200, 1902.2836);
	angles[82] = (0, -344.3663, 0);
	at[82] = 14.1000;
	points[83] = (-1219.9528, -7142.2837, 1902.2836);
	angles[83] = (0, -339.2686, 0);
	at[83] = 14.3000;
	points[84] = (-1249.5394, -7068.1890, 1902.2836);
	angles[84] = (0, -338.4761, 0);
	at[84] = 14.6000;
	points[85] = (-1267.4646, -7017.2837, 1902.2836);
	angles[85] = (0, -341.5602, 0);
	at[85] = 14.8000;
	points[86] = (-1273.6575, -6991.2202, 1902.2836);
	angles[86] = (0, -346.3765, 0);
	at[86] = 14.9000;
	points[87] = (-1271.7834, -6965.6299, 1902.2836);
	angles[87] = (0, -365.5487, 0);
	at[87] = 15;
	points[88] = (-1249.6575, -6954.0552, 1902.2836);
	angles[88] = (0, -410.9756, 0);
	at[88] = 15.1000;
	points[89] = (-1223.0315, -6949.6064, 1902.2836);
	angles[89] = (0, -433.6075, 0);
	at[89] = 15.2000;
	points[90] = (-1196.2834, -6947.3623, 1902.2836);
	angles[90] = (0, -442.4837, 0);
	at[90] = 15.3000;
	points[91] = (-1116.4843, -6944.8032, 1902.2836);
	angles[91] = (0, -448.6706, 0);
	at[91] = 15.6000;
	points[92] = (-982.8858, -6940.1577, 1902.2836);
	angles[92] = (0, -446.1512, 0);
	at[92] = 16.1000;
	points[93] = (-930.0316, -6930.9058, 1902.2836);
	angles[93] = (0, -437.2097, 0);
	at[93] = 16.3000;
	points[94] = (-909.7953, -6917.7168, 1902.2836);
	angles[94] = (0, -418.2167, 0);
	at[94] = 16.4000;
	points[95] = (-894.3149, -6895.9448, 1902.2836);
	angles[95] = (0, -399.9307, 0);
	at[95] = 16.5000;
	points[96] = (-881.6182, -6872.2837, 1902.2836);
	angles[96] = (0, -390.6701, 0);
	at[96] = 16.6000;
	points[97] = (-849.5905, -6798.6616, 1902.2836);
	angles[97] = (0, -382.6222, 0);
	at[97] = 16.9000;
	points[98] = (-797.0826, -6675.6694, 1902.2836);
	angles[98] = (0, -385.5973, 0);
	at[98] = 17.4000;
	points[99] = (-783.4843, -6652.5195, 1902.2836);
	angles[99] = (0, -390.1648, 0);
	at[99] = 17.5000;
	points[100] = (-765.0079, -6634.2915, 1902.2836);
	angles[100] = (0, -406.0915, 0);
	at[100] = 17.6000;
	points[101] = (-740.1142, -6636.3779, 1902.2836);
	angles[101] = (0, -445.8830, 0);
	at[101] = 17.7000;
	points[102] = (-715.6063, -6647.4409, 1902.2836);
	angles[102] = (0, -467.7722, 0);
	at[102] = 17.8000;
	points[103] = (-692.4174, -6660.6299, 1902.2836);
	angles[103] = (0, -476.9458, 0);
	at[103] = 17.9000;
	points[104] = (-647.6417, -6689.5278, 1902.2836);
	angles[104] = (0, -483.0284, 0);
	at[104] = 18.1000;
	points[105] = (-559.7205, -6750.2759, 1902.2836);
	angles[105] = (0, -484.5697, 0);
	at[105] = 18.5000;
	points[106] = (-491.9213, -6793.0317, 1902.2836);
	angles[106] = (0, -480.3172, 0);
	at[106] = 18.8000;
	points[107] = (-467.5433, -6803.8579, 1902.2836);
	angles[107] = (0, -474.0052, 0);
	at[107] = 18.9000;
	points[108] = (-442.2716, -6806.2993, 1902.2836);
	angles[108] = (0, -458.1173, 0);
	at[108] = 19;
	points[109] = (-415.9685, -6803.2285, 1902.2836);
	angles[109] = (0, -446.4112, 0);
	at[109] = 19.1000;
	points[110] = (-390.0563, -6798.1104, 1902.2836);
	angles[110] = (0, -440.4202, 0);
	at[110] = 19.2000;
	points[111] = (-338.0913, -6785.1968, 1902.2836);
	angles[111] = (0, -435.8922, 0);
	at[111] = 19.4000;
	points[112] = (-260.5402, -6764.9609, 1902.2836);
	angles[112] = (0, -435.8960, 0);
	at[112] = 19.7000;
	points[113] = (-208.6795, -6755, 1902.2836);
	angles[113] = (0, -440.6005, 0);
	at[113] = 19.9000;
	points[114] = (-181.7425, -6754.5278, 1902.2836);
	angles[114] = (0, -449.0221, 0);
	at[114] = 20;
	points[115] = (-169.2902, -6758.7012, 1902.2836);
	angles[115] = (0, -461.7451, 0);
	at[115] = 20.0500;
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
	points[0] = (2774.6377, -607.8189, 1817.4213);
	angles[0] = (0, -82.0033, 0);
	at[0] = 0;
	points[1] = (2709.9409, -147.2827, 1817.4213);
	angles[1] = (0, -82.0033, 0);
	at[1] = 1.7500;
	points[2] = (2708.7087, -138.5106, 1817.4213);
	angles[2] = (0, -82.0033, 0);
	at[2] = 1.8000;
	points[3] = (2708.7087, -138.5106, 1817.4213);
	angles[3] = (0, -82.0033, 0);
	at[3] = 2.5000;
	points[4] = (2709.4292, -143.6323, 1817.4213);
	angles[4] = (0, -82.0033, 0);
	at[4] = 2.5500;
	points[5] = (2774.1260, -604.1693, 1817.4213);
	angles[5] = (0, -82.0033, 0);
	at[5] = 4.3000;
	points[6] = (2775.3584, -612.9409, 1817.4213);
	angles[6] = (0, -82.0033, 0);
	at[6] = 4.3500;
	points[7] = (2775.3584, -612.9409, 1817.4213);
	angles[7] = (0, -82.0033, 0);
	at[7] = 5.0500;
	points[8] = (2774.6377, -607.8189, 1817.4213);
	angles[8] = (0, -82.0033, 0);
	at[8] = 5.1000;
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
	points[0] = (2973.3306, 3787.5708, 1817.4213);
	angles[0] = (0, -115.9641, 0);
	at[0] = 0;
	points[1] = (3345.6418, 4552.1260, 1817.4213);
	angles[1] = (0, -115.9641, 0);
	at[1] = 3.2000;
	points[2] = (3345.6418, 4552.1260, 1817.4213);
	angles[2] = (0, -115.9641, 0);
	at[2] = 3.9500;
	points[3] = (2972.6853, 3786.2402, 1817.4213);
	angles[3] = (0, -115.9641, 0);
	at[3] = 7.1500;
	points[4] = (2970.7441, 3782.2598, 1817.4213);
	angles[4] = (0, -115.9641, 0);
	at[4] = 7.2000;
	points[5] = (2970.7441, 3782.2598, 1817.4213);
	angles[5] = (0, -115.9641, 0);
	at[5] = 7.9000;
	points[6] = (2973.3306, 3787.5708, 1817.4213);
	angles[6] = (0, -115.9641, 0);
	at[6] = 7.9333;
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
	points[0] = (-4652.8345, 6898.3857, 1817.4213);
	angles[0] = (0, -91.2274, 0);
	at[0] = 0;
	points[1] = (-4638.8979, 7549.3311, 1817.4213);
	angles[1] = (0, -91.2274, 0);
	at[1] = 2.4500;
	points[2] = (-4638.7793, 7553.7793, 1817.4213);
	angles[2] = (0, -91.2274, 0);
	at[2] = 2.5000;
	points[3] = (-4638.7793, 7553.7793, 1817.4213);
	angles[3] = (0, -91.2274, 0);
	at[3] = 3.2000;
	points[4] = (-4639.0552, 7541.6538, 1817.4213);
	angles[4] = (0, -91.2274, 0);
	at[4] = 3.2500;
	points[5] = (-4652.9922, 6890.7480, 1817.4213);
	angles[5] = (0, -91.2274, 0);
	at[5] = 5.7000;
	points[6] = (-4652.9922, 6890.7480, 1817.4213);
	angles[6] = (0, -91.2274, 0);
	at[6] = 6.4500;
	points[7] = (-4652.8345, 6898.3857, 1817.4213);
	angles[7] = (0, -91.2274, 0);
	at[7] = 6.4667;
	mover = getEnt("iz_obj_7", "targetname");
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
