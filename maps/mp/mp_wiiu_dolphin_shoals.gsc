main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_wiiu_dolphin_shoals", 0);

	setExpFog(0, 61515.7461, 1, 1, 1, 0);

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
	ambientPlay("iz_0_uds", 2);
	iz_emitter("iz_1_se_cc_env_water_fall", (1713.0105, 5651.8789, 1237.2805), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (1755.9330, 7429.0273, 1328.7402), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (2434.2490, 8293.0215, 1771.6536), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (3365.2708, 8487.6934, 1771.6536), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (4472.9409, 8290.6387, 1771.6536), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (5210.5688, 7688.2910, 1771.6536), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (5266.7485, 6091.3555, 1771.6536), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (4272.0972, 5501.6016, 1771.6536), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (2772.6697, 4829.6514, 1919.2914), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (1337.0613, 4253.0874, 2214.5669), 0, 12.0104);
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
	level.iz_route[level.iz_route.size] = (-3944, -6159, 1714);
	level.iz_route[level.iz_route.size] = (-3936, -8060, 1767);
	level.iz_route[level.iz_route.size] = (-3921, -9513, 1817);
	level.iz_route[level.iz_route.size] = (-3689, -10459, 1869);
	level.iz_route[level.iz_route.size] = (-2959, -11212, 1933);
	level.iz_route[level.iz_route.size] = (-1756, -12075, 2028);
	level.iz_route[level.iz_route.size] = (-248, -13147, 1836);
	level.iz_route[level.iz_route.size] = (2272, -14878, 1869);
	level.iz_route[level.iz_route.size] = (4138, -16202, 1825);
	level.iz_route[level.iz_route.size] = (5290, -17019, 1724);
	level.iz_route[level.iz_route.size] = (6329, -17702, 1678);
	level.iz_route[level.iz_route.size] = (7582, -18111, 1638);
	level.iz_route[level.iz_route.size] = (8547, -17826, 1568);
	level.iz_route[level.iz_route.size] = (9107, -17239, 1510);
	level.iz_route[level.iz_route.size] = (9370, -16383, 1427);
	level.iz_route[level.iz_route.size] = (8797, -15078, 1281);
	level.iz_route[level.iz_route.size] = (7428, -13972, 1069);
	level.iz_route[level.iz_route.size] = (6848, -13468, 1070);
	level.iz_route[level.iz_route.size] = (5439, -12111, 844);
	level.iz_route[level.iz_route.size] = (3770, -10677, 875);
	level.iz_route[level.iz_route.size] = (2369, -9020, 850);
	level.iz_route[level.iz_route.size] = (1517, -8273, 834);
	level.iz_route[level.iz_route.size] = (1312, -5991, 747);
	level.iz_route[level.iz_route.size] = (1421, -4544, 1284);
	level.iz_route[level.iz_route.size] = (1451, -3286, 1284);
	level.iz_route[level.iz_route.size] = (1436, -1540, 1284);
	level.iz_route[level.iz_route.size] = (1451, -16, 1284);
	level.iz_route[level.iz_route.size] = (1465, 1376, 1284);
	level.iz_route[level.iz_route.size] = (1614, 3071, 1174);
	level.iz_route[level.iz_route.size] = (1693, 5331, 1392);
	level.iz_route[level.iz_route.size] = (1686, 6627, 1764);
	level.iz_route[level.iz_route.size] = (1810, 7444, 2101);
	level.iz_route[level.iz_route.size] = (2307, 8134, 2474);
	level.iz_route[level.iz_route.size] = (2847, 8531, 2738);
	level.iz_route[level.iz_route.size] = (3401, 8784, 2970);
	level.iz_route[level.iz_route.size] = (4197, 8871, 3231);
	level.iz_route[level.iz_route.size] = (4873, 8641, 3381);
	level.iz_route[level.iz_route.size] = (5325, 8247, 3410);
	level.iz_route[level.iz_route.size] = (5693, 7686, 3389);
	level.iz_route[level.iz_route.size] = (5830, 7255, 3356);
	level.iz_route[level.iz_route.size] = (5839, 6816, 3302);
	level.iz_route[level.iz_route.size] = (5548, 6208, 3138);
	level.iz_route[level.iz_route.size] = (5141, 5857, 3020);
	level.iz_route[level.iz_route.size] = (3983, 5323, 2862);
	level.iz_route[level.iz_route.size] = (3368, 5083, 2836);
	level.iz_route[level.iz_route.size] = (2405, 4684, 2500);
	level.iz_route[level.iz_route.size] = (1702, 4418, 2591);
	level.iz_route[level.iz_route.size] = (1150, 4199, 2675);
	level.iz_route[level.iz_route.size] = (-881, 3329, 2378);
	level.iz_route[level.iz_route.size] = (-1542, 3020, 2470);
	level.iz_route[level.iz_route.size] = (-2269, 2674, 2538);
	level.iz_route[level.iz_route.size] = (-3247, 2007, 2558);
	level.iz_route[level.iz_route.size] = (-3669, 1414, 2504);
	level.iz_route[level.iz_route.size] = (-3700, 894, 2432);
	level.iz_route[level.iz_route.size] = (-3203, 123, 2250);
	level.iz_route[level.iz_route.size] = (-2907, -240, 2158);
	level.iz_route[level.iz_route.size] = (-2758, -622, 2071);
	level.iz_route[level.iz_route.size] = (-2821, -1036, 2001);
	level.iz_route[level.iz_route.size] = (-3419, -1797, 1918);
	level.iz_route[level.iz_route.size] = (-3928, -2650, 1803);
	level.iz_route[level.iz_route.size] = (-3997, -3205, 1730);
	level.iz_route[level.iz_route.size] = (-3957, -4773, 1712);
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
	points[0] = (461.2205, -14482.1270, 2125.4133);
	angles[0] = (0, -114.7740, -8.7568);
	at[0] = 0;
	points[1] = (504.9370, -14500.7881, 2102.5630);
	angles[1] = (0, -113.4480, -21.7582);
	at[1] = 0.1000;
	points[2] = (592.3937, -14537.4414, 2053.0708);
	angles[2] = (0, -112.8400, -27.1769);
	at[2] = 0.3000;
	points[3] = (701.5984, -14584.6846, 1993.1615);
	angles[3] = (0, -113.6952, -26.2195);
	at[3] = 0.5500;
	points[4] = (767.9882, -14615.1582, 1959.8347);
	angles[4] = (0, -114.7658, -24.2892);
	at[4] = 0.7000;
	points[5] = (834.6575, -14648.3857, 1931.4056);
	angles[5] = (0, -116.7802, -20.3061);
	at[5] = 0.8500;
	points[6] = (878.5197, -14673.5439, 1919.0631);
	angles[6] = (0, -119.7459, -13.8894);
	at[6] = 0.9500;
	points[7] = (898.9409, -14686.8506, 1916.7479);
	angles[7] = (0, -121.5009, -9.3996);
	at[7] = 1;
	points[8] = (922.3661, -14702.6377, 1915.5394);
	angles[8] = (0, -122.7953, -5.7828);
	at[8] = 1.0500;
	points[9] = (987.5787, -14747.9922, 1915.5708);
	angles[9] = (0, -124.6940, -0.3349);
	at[9] = 1.2000;
	points[10] = (1246.2362, -14936.3779, 1930.5394);
	angles[10] = (0, -126.6688, 3.4026);
	at[10] = 1.8000;
	points[11] = (1435.9764, -15083.8193, 1945.7559);
	angles[11] = (0, -128.9279, 3.5199);
	at[11] = 2.2500;
	points[12] = (1476.2480, -15118.8193, 1948.5040);
	angles[12] = (0, -130.9871, 2.9227);
	at[12] = 2.3500;
	points[13] = (1510.0275, -15156.5742, 1949.6221);
	angles[13] = (0, -137.4551, 1.5542);
	at[13] = 2.4500;
	points[14] = (1540.1968, -15200.2764, 1950.0592);
	angles[14] = (0, -144.0191, 0.6889);
	at[14] = 2.5500;
	points[15] = (1567.1456, -15246.2998, 1950.1182);
	angles[15] = (0, -148.6474, 0.1843);
	at[15] = 2.6500;
	points[16] = (1614.1536, -15342.0088, 1949.6102);
	angles[16] = (0, -154.5502, -0.3101);
	at[16] = 2.8500;
	points[17] = (1652.5039, -15441.8506, 1948.8386);
	angles[17] = (0, -160.3342, -0.3549);
	at[17] = 3.0500;
	points[18] = (1660.2756, -15493.1494, 1948.8190);
	angles[18] = (0, -170.3158, -0.0974);
	at[18] = 3.1500;
	points[19] = (1659.5472, -15546.3389, 1948.8190);
	angles[19] = (0, -178.7955, -0.0257);
	at[19] = 3.2500;
	points[20] = (1654.3898, -15599.4102, 1948.8190);
	angles[20] = (0, -184.3705, -0.0068);
	at[20] = 3.3500;
	points[21] = (1637.7520, -15677.6777, 1948.8190);
	angles[21] = (0, -193.0292, 0);
	at[21] = 3.5000;
	points[22] = (1627.3583, -15701.2207, 1948.8190);
	angles[22] = (0, -199.9154, 0);
	at[22] = 3.5500;
	points[23] = (1611.1495, -15721.7725, 1948.8190);
	angles[23] = (0, -209.6905, 0);
	at[23] = 3.6000;
	points[24] = (1573.1300, -15759.6064, 1948.8190);
	angles[24] = (0, -221.7850, 0);
	at[24] = 3.7000;
	points[25] = (1532.8938, -15794.5273, 1948.8190);
	angles[25] = (0, -227.5511, 0);
	at[25] = 3.8000;
	points[26] = (1446.7834, -15857.4023, 1948.8190);
	angles[26] = (0, -235.2936, 0);
	at[26] = 4;
	points[27] = (1423.4686, -15870.3936, 1948.8190);
	angles[27] = (0, -238.6130, 0);
	at[27] = 4.0500;
	points[28] = (1399.2717, -15879.1729, 1948.8190);
	angles[28] = (0, -246.2025, 0);
	at[28] = 4.1000;
	points[29] = (1373.0079, -15880.0391, 1948.8190);
	angles[29] = (0, -258.0208, 0);
	at[29] = 4.1500;
	points[30] = (1320, -15872.8740, 1948.8190);
	angles[30] = (0, -273.4476, 0);
	at[30] = 4.2500;
	points[31] = (1242.0906, -15854.7637, 1948.8190);
	angles[31] = (0, -282.5215, 0);
	at[31] = 4.4000;
	points[32] = (1114.7126, -15815, 1948.8190);
	angles[32] = (0, -288.5400, 0);
	at[32] = 4.6500;
	points[33] = (1018.8976, -15772.2441, 1948.8190);
	angles[33] = (0, -294.5447, 0);
	at[33] = 4.8500;
	points[34] = (709.0039, -15615.7871, 1948.8190);
	angles[34] = (0, -297.4798, 0);
	at[34] = 5.5000;
	points[35] = (524.4213, -15512.0859, 1948.8190);
	angles[35] = (0, -299.9733, 0);
	at[35] = 5.9000;
	points[36] = (389.5421, -15428.8584, 1948.8190);
	angles[36] = (0, -303.0042, 0);
	at[36] = 6.2000;
	points[37] = (107.4075, -15228.7002, 1948.8190);
	angles[37] = (0, -306.7200, 0);
	at[37] = 6.8500;
	points[38] = (5.0781, -15143.3467, 1948.8190);
	angles[38] = (0, -310.3040, 0);
	at[38] = 7.1000;
	points[39] = (-255.3244, -14915.8662, 1949.4646);
	angles[39] = (0, -312.0505, 0.0276);
	at[39] = 7.7500;
	points[40] = (-311.2284, -14859.5283, 1948.8229);
	angles[40] = (0, -316.6231, -0.6823);
	at[40] = 7.9000;
	points[41] = (-340.3685, -14815.5518, 1946.4607);
	angles[41] = (0, -324.7720, -2.2651);
	at[41] = 8;
	points[42] = (-388.7362, -14720.7490, 1939.8071);
	angles[42] = (0, -334.0515, -3.6250);
	at[42] = 8.2000;
	points[43] = (-407.0472, -14670.7480, 1936.1890);
	angles[43] = (0, -339.4387, -3.8308);
	at[43] = 8.3000;
	points[44] = (-412.3032, -14644.6064, 1934.4055);
	angles[44] = (0, -345.1509, -3.8172);
	at[44] = 8.3500;
	points[45] = (-410.2914, -14618.9375, 1932.9606);
	angles[45] = (0, -355.8313, -3.5155);
	at[45] = 8.4000;
	points[46] = (-397.2480, -14567.3623, 1930.4725);
	angles[46] = (0, -370.1378, -2.9014);
	at[46] = 8.5000;
	points[47] = (-371.2343, -14491.9297, 1926.8662);
	angles[47] = (0, -378.5867, -2.6479);
	at[47] = 8.6500;
	points[48] = (-339.3177, -14418.4648, 1922.9133);
	angles[48] = (0, -383.8730, -2.8989);
	at[48] = 8.8000;
	points[49] = (-311.0544, -14374.0947, 1919.4016);
	angles[49] = (0, -393.3123, -3.9608);
	at[49] = 8.9000;
	points[50] = (-288.8457, -14361.8115, 1915.9449);
	angles[50] = (0, -408.6539, -6.3267);
	at[50] = 8.9500;
	points[51] = (-263.5087, -14354.5283, 1911.6378);
	angles[51] = (0, -421.5422, -8.0127);
	at[51] = 9;
	points[52] = (-237.6248, -14349.4883, 1907.2560);
	angles[52] = (0, -430.3808, -8.8015);
	at[52] = 9.0500;
	points[53] = (-185.2272, -14342.9131, 1898.9055);
	angles[53] = (0, -440.0790, -8.8429);
	at[53] = 9.1500;
	points[54] = (-132.4362, -14339.0557, 1891.9567);
	angles[54] = (0, -444.6401, -7.5121);
	at[54] = 9.2500;
	points[55] = (-79.0878, -14337.1660, 1889.3151);
	angles[55] = (0, -447.4025, -2.5261);
	at[55] = 9.3500;
	points[56] = (-28.8254, -14340.1973, 1902.2638);
	angles[56] = (0, -452.6566, 11.5552);
	at[56] = 9.4500;
	points[57] = (20.6775, -14346.5361, 1921.2953);
	angles[57] = (0, -456.3242, 18.8373);
	at[57] = 9.5500;
	points[58] = (117.0236, -14362.7959, 1964.4646);
	angles[58] = (0, -459.9572, 24.1781);
	at[58] = 9.7500;
	points[59] = (162.5311, -14373.3076, 1988.4803);
	angles[59] = (0, -462.8927, 27.1537);
	at[59] = 9.8500;
	points[60] = (249.0913, -14400.0791, 2044.2480);
	angles[60] = (0, -467.2769, 31.6375);
	at[60] = 10.0500;
	points[61] = (378.5823, -14443.6230, 2126.6812);
	angles[61] = (0, -469.0917, 28.8343);
	at[61] = 10.3500;
	points[62] = (401.1496, -14452.8340, 2137.0354);
	angles[62] = (0, -471.2280, 25.1155);
	at[62] = 10.4000;
	points[63] = (424.5079, -14464.5273, 2138.1890);
	angles[63] = (0, -474.0627, 11.4118);
	at[63] = 10.4500;
	points[64] = (461.2205, -14482.1270, 2125.4133);
	angles[64] = (0, -474.7740, -8.7568);
	at[64] = 10.5333;
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
	points[0] = (1980.6339, -12859.8037, 1948.8190);
	angles[0] = (0, 51.6625, 0);
	at[0] = 0;
	points[1] = (1665.0433, -12616.2598, 1948.8190);
	angles[1] = (0, 52.3454, 0);
	at[1] = 0.7500;
	points[2] = (1408.2755, -12427.1650, 1948.8190);
	angles[2] = (0, 53.6775, 0);
	at[2] = 1.3500;
	points[3] = (1382.8347, -12420.3545, 1947.7520);
	angles[3] = (0, 65.1745, -1.2703);
	at[3] = 1.4000;
	points[4] = (1331.0078, -12408.7803, 1945.3740);
	angles[4] = (0, 74.2070, -2.2343);
	at[4] = 1.5000;
	points[5] = (1097.8031, -12356.7715, 1934.6692);
	angles[5] = (0, 77.4213, -2.5649);
	at[5] = 1.9500;
	points[6] = (1075.7677, -12363.3076, 1933.3937);
	angles[6] = (0, 97.5662, -3.0687);
	at[6] = 2;
	points[7] = (1057.8425, -12382.8740, 1932.0276);
	angles[7] = (0, 116.6447, -3.2005);
	at[7] = 2.0500;
	points[8] = (1039.9213, -12402.4414, 1930.6653);
	angles[8] = (0, 126.7762, -3.1273);
	at[8] = 2.1000;
	points[9] = (1022, -12422.0088, 1929.2992);
	angles[9] = (0, 132.0134, -3.0509);
	at[9] = 2.1500;
	points[10] = (986.1575, -12461.1816, 1926.5708);
	angles[10] = (0, 136.0786, -2.9741);
	at[10] = 2.2500;
	points[11] = (896.5473, -12559.0156, 1919.7480);
	angles[11] = (0, 137.4727, -2.9443);
	at[11] = 2.5000;
	points[12] = (892.0512, -12583.1104, 1917.4883);
	angles[12] = (0, 153.8056, -4.3000);
	at[12] = 2.5500;
	points[13] = (894.3189, -12609.4492, 1914.7795);
	angles[13] = (0, 168.7770, -5.2390);
	at[13] = 2.6000;
	points[14] = (898.8583, -12662.1270, 1909.3622);
	angles[14] = (0, 180.6718, -5.7337);
	at[14] = 2.7000;
	points[15] = (914.7480, -12846.4961, 1890.3937);
	angles[15] = (0, 184.8862, -5.8509);
	at[15] = 3.0500;
	points[16] = (924.1378, -12869.6064, 1896.7795);
	angles[16] = (0, 195.4637, 6.7672);
	at[16] = 3.1000;
	points[17] = (935.6929, -12891.6934, 1905.9291);
	angles[17] = (0, 201.1838, 13.3357);
	at[17] = 3.1500;
	points[18] = (958.7993, -12935.9453, 1924.2245);
	angles[18] = (0, 205.8575, 18.3701);
	at[18] = 3.2500;
	points[19] = (1028.1182, -13068.6221, 1979.1104);
	angles[19] = (0, 209.7749, 21.5145);
	at[19] = 3.5500;
	points[20] = (1043.3859, -13086.6934, 1991.3701);
	angles[20] = (0, 214.2737, 24.2044);
	at[20] = 3.6000;
	points[21] = (1073.3544, -13123.4248, 2015.4016);
	angles[21] = (0, 217.8943, 26.1981);
	at[21] = 3.7000;
	points[22] = (1208.2126, -13288.7002, 2123.5591);
	angles[22] = (0, 219.2073, 26.8833);
	at[22] = 4.1500;
	points[23] = (1224.5906, -13308.8975, 2125.9844);
	angles[23] = (0, 219.1123, 13.8906);
	at[23] = 4.2000;
	points[24] = (1258.0551, -13350.1572, 2125.9844);
	angles[24] = (0, 219.0451, 3.6525);
	at[24] = 4.3000;
	points[25] = (1291.5197, -13391.4570, 2125.9844);
	angles[25] = (0, 219.0280, 0.9577);
	at[25] = 4.4000;
	points[26] = (1307.7914, -13410.1182, 2119.5591);
	angles[26] = (0, 220.6016, -10.5845);
	at[26] = 4.4500;
	points[27] = (1323.5394, -13426.4570, 2105.7361);
	angles[27] = (0, 222.0995, -20.6653);
	at[27] = 4.5000;
	points[28] = (1339.2834, -13442.7949, 2091.9094);
	angles[28] = (0, 222.9490, -25.8726);
	at[28] = 4.5500;
	points[29] = (1386.5198, -13491.8506, 2050.4370);
	angles[29] = (0, 223.7904, -30.6119);
	at[29] = 4.7000;
	points[30] = (1528.2284, -13638.9365, 1926.0157);
	angles[30] = (0, 223.9278, -31.3448);
	at[30] = 5.1500;
	points[31] = (1547.1851, -13654.5664, 1919.7520);
	angles[31] = (0, 228.6342, -19.7141);
	at[31] = 5.2000;
	points[32] = (1569.1812, -13669.4492, 1920.6497);
	angles[32] = (0, 232.2731, -9.2410);
	at[32] = 5.2500;
	points[33] = (1591.1772, -13684.3311, 1921.5433);
	angles[33] = (0, 234.0587, -3.7998);
	at[33] = 5.3000;
	points[34] = (1657.1692, -13728.9766, 1924.2323);
	angles[34] = (0, 235.6657, 1.1631);
	at[34] = 5.4500;
	points[35] = (2251.0867, -14130.8672, 1948.4370);
	angles[35] = (0, 235.9150, 1.9331);
	at[35] = 6.8000;
	points[36] = (2275.2520, -14140.9053, 1948.8190);
	angles[36] = (0, 243.0504, 1.2571);
	at[36] = 6.8500;
	points[37] = (2301.0198, -14147.4014, 1948.8190);
	angles[37] = (0, 249.2940, 0.6490);
	at[37] = 6.9000;
	points[38] = (2352.5630, -14160.3945, 1948.8190);
	angles[38] = (0, 254.1459, 0.1706);
	at[38] = 7;
	points[39] = (2636.0432, -14231.7324, 1948.8190);
	angles[39] = (0, 255.8701, 0);
	at[39] = 7.5500;
	points[40] = (2661.2915, -14227.2051, 1948.8190);
	angles[40] = (0, 272.0522, 0);
	at[40] = 7.6000;
	points[41] = (2686.3386, -14218.3066, 1948.8190);
	angles[41] = (0, 280.5535, 0);
	at[41] = 7.6500;
	points[42] = (2711.3821, -14209.4102, 1948.8190);
	angles[42] = (0, 284.9359, 0);
	at[42] = 7.7000;
	points[43] = (2786.5117, -14182.7559, 1948.8190);
	angles[43] = (0, 288.9248, 0);
	at[43] = 7.8500;
	points[44] = (2936.7756, -14129.4092, 1948.8190);
	angles[44] = (0, 289.5321, 0);
	at[44] = 8.1500;
	points[45] = (2954.7678, -14113.1104, 1948.8190);
	angles[45] = (0, 306.0435, 0);
	at[45] = 8.2000;
	points[46] = (2964.9644, -14088.5430, 1948.8190);
	angles[46] = (0, 321.1599, 0);
	at[46] = 8.2500;
	points[47] = (2975.1614, -14064.0166, 1948.8190);
	angles[47] = (0, 329.0740, 0);
	at[47] = 8.3000;
	points[48] = (3005.7559, -13990.3936, 1948.8190);
	angles[48] = (0, 336.3108, 0);
	at[48] = 8.4500;
	points[49] = (3056.7439, -13867.6777, 1948.8190);
	angles[49] = (0, 337.3947, 0);
	at[49] = 8.7000;
	points[50] = (3046.2087, -13843.3867, 1948.8190);
	angles[50] = (0, 359.4023, 0);
	at[50] = 8.7500;
	points[51] = (3035.4529, -13819.0947, 1948.8190);
	angles[51] = (0, 371.2500, 0);
	at[51] = 8.8000;
	points[52] = (3024.6970, -13794.8037, 1948.8190);
	angles[52] = (0, 377.3981, 0);
	at[52] = 8.8500;
	points[53] = (2992.4292, -13721.8906, 1948.8190);
	angles[53] = (0, 383.0050, 0);
	at[53] = 9;
	points[54] = (2938.6497, -13600.3945, 1948.8190);
	angles[54] = (0, 383.8442, 0);
	at[54] = 9.2500;
	points[55] = (2923.2993, -13579.6855, 1948.8190);
	angles[55] = (0, 394.0043, 0);
	at[55] = 9.3000;
	points[56] = (2902.2244, -13563.5039, 1948.8190);
	angles[56] = (0, 402.9792, 0);
	at[56] = 9.3500;
	points[57] = (2860.0669, -13531.1426, 1948.8190);
	angles[57] = (0, 409.9850, 0);
	at[57] = 9.4500;
	points[58] = (2817.9133, -13498.7793, 1948.8190);
	angles[58] = (0, 411.8251, 0);
	at[58] = 9.5500;
	points[59] = (2627.9016, -13353.5039, 1948.8190);
	angles[59] = (0, 413.1750, 0);
	at[59] = 10;
	points[60] = (2346.9409, -13152.4805, 1948.8190);
	angles[60] = (0, 414.4169, 0);
	at[60] = 10.6500;
	points[61] = (2263.6536, -13086.4570, 1948.8190);
	angles[61] = (0, 411.5480, 0);
	at[61] = 10.8500;
	points[62] = (1980.6339, -12859.8037, 1948.8190);
	angles[62] = (0, 411.6625, 0);
	at[62] = 11.5333;
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
