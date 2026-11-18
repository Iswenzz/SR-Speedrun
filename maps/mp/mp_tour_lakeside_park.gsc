main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_tour_lakeside_park", 0);

	setExpFog(8858.2676, 49751.9609, 1, 1, 1, 0);

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
	ambientPlay("iz_0_trlp", 2);
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
	level.iz_route[level.iz_route.size] = (5110, -1781, 2097);
	level.iz_route[level.iz_route.size] = (5122, -3070, 2098);
	level.iz_route[level.iz_route.size] = (4997, -3687, 2102);
	level.iz_route[level.iz_route.size] = (4654, -4356, 2109);
	level.iz_route[level.iz_route.size] = (4388, -4748, 2115);
	level.iz_route[level.iz_route.size] = (3861, -5080, 2118);
	level.iz_route[level.iz_route.size] = (3285, -5218, 2116);
	level.iz_route[level.iz_route.size] = (2781, -5265, 2115);
	level.iz_route[level.iz_route.size] = (2233, -5234, 2118);
	level.iz_route[level.iz_route.size] = (1825, -4993, 2121);
	level.iz_route[level.iz_route.size] = (1596, -4632, 2123);
	level.iz_route[level.iz_route.size] = (1380, -4033, 2123);
	level.iz_route[level.iz_route.size] = (1221, -3544, 2121);
	level.iz_route[level.iz_route.size] = (1174, -2917, 2117);
	level.iz_route[level.iz_route.size] = (1255, -2227, 2116);
	level.iz_route[level.iz_route.size] = (1197, -1649, 2118);
	level.iz_route[level.iz_route.size] = (683, -1222, 2115);
	level.iz_route[level.iz_route.size] = (-385, -1088, 2085);
	level.iz_route[level.iz_route.size] = (-2145, -1068, 2088);
	level.iz_route[level.iz_route.size] = (-2812, -1089, 2095);
	level.iz_route[level.iz_route.size] = (-3718, -1363, 2098);
	level.iz_route[level.iz_route.size] = (-4394, -1443, 2105);
	level.iz_route[level.iz_route.size] = (-5038, -1282, 2114);
	level.iz_route[level.iz_route.size] = (-5780, -801, 2134);
	level.iz_route[level.iz_route.size] = (-6006, -219, 2151);
	level.iz_route[level.iz_route.size] = (-6074, 366, 2173);
	level.iz_route[level.iz_route.size] = (-5929, 1063, 2204);
	level.iz_route[level.iz_route.size] = (-5396, 1568, 2220);
	level.iz_route[level.iz_route.size] = (-4105, 2127, 2238);
	level.iz_route[level.iz_route.size] = (-2523, 2720, 2287);
	level.iz_route[level.iz_route.size] = (-1090, 3078, 2327);
	level.iz_route[level.iz_route.size] = (542, 3640, 2411);
	level.iz_route[level.iz_route.size] = (718, 3885, 2426);
	level.iz_route[level.iz_route.size] = (745, 4216, 2444);
	level.iz_route[level.iz_route.size] = (817, 5084, 2556);
	level.iz_route[level.iz_route.size] = (922, 6534, 2870);
	level.iz_route[level.iz_route.size] = (865, 7643, 3247);
	level.iz_route[level.iz_route.size] = (460, 8032, 3359);
	level.iz_route[level.iz_route.size] = (-139, 8126, 3363);
	level.iz_route[level.iz_route.size] = (-628, 7862, 3306);
	level.iz_route[level.iz_route.size] = (-1172, 7285, 3207);
	level.iz_route[level.iz_route.size] = (-1655, 6903, 3147);
	level.iz_route[level.iz_route.size] = (-2242, 6700, 3122);
	level.iz_route[level.iz_route.size] = (-2901, 6702, 3133);
	level.iz_route[level.iz_route.size] = (-3562, 6683, 3149);
	level.iz_route[level.iz_route.size] = (-4280, 6513, 3160);
	level.iz_route[level.iz_route.size] = (-4774, 6272, 3156);
	level.iz_route[level.iz_route.size] = (-5061, 5748, 3106);
	level.iz_route[level.iz_route.size] = (-5047, 5206, 3034);
	level.iz_route[level.iz_route.size] = (-4892, 4667, 2948);
	level.iz_route[level.iz_route.size] = (-4231, 4412, 2871);
	level.iz_route[level.iz_route.size] = (-3589, 4381, 2815);
	level.iz_route[level.iz_route.size] = (-2865, 4536, 2756);
	level.iz_route[level.iz_route.size] = (-1986, 4693, 2687);
	level.iz_route[level.iz_route.size] = (-814, 4893, 2735);
	level.iz_route[level.iz_route.size] = (139, 4866, 2939);
	level.iz_route[level.iz_route.size] = (1988, 4920, 2799);
	level.iz_route[level.iz_route.size] = (2740, 4962, 2892);
	level.iz_route[level.iz_route.size] = (3333, 5150, 2972);
	level.iz_route[level.iz_route.size] = (3998, 5576, 3012);
	level.iz_route[level.iz_route.size] = (4724, 6020, 3020);
	level.iz_route[level.iz_route.size] = (5468, 6247, 3020);
	level.iz_route[level.iz_route.size] = (6317, 6207, 3040);
	level.iz_route[level.iz_route.size] = (7029, 5948, 3055);
	level.iz_route[level.iz_route.size] = (7508, 5390, 3022);
	level.iz_route[level.iz_route.size] = (7607, 4700, 2938);
	level.iz_route[level.iz_route.size] = (7500, 3857, 2809);
	level.iz_route[level.iz_route.size] = (6862, 3310, 2622);
	level.iz_route[level.iz_route.size] = (5689, 2822, 2391);
	level.iz_route[level.iz_route.size] = (5221, 2542, 2289);
	level.iz_route[level.iz_route.size] = (5094, 2345, 2245);
	level.iz_route[level.iz_route.size] = (5028, 2084, 2202);
	level.iz_route[level.iz_route.size] = (5023, 1789, 2163);
	level.iz_route[level.iz_route.size] = (5075, -298, 2097);
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
	points[0] = (-4335.5513, 7855.7876, 4475.8267);
	angles[0] = (0, -173.1440, 69.5172);
	at[0] = 0;
	points[1] = (-4335.5513, 7855.7876, 4475.8267);
	angles[1] = (0, -173.1440, 69.5172);
	at[1] = 8.3333;
	points[2] = (-4333.1890, 7842.1260, 4543.1499);
	angles[2] = (0, -170.2325, 160.8006);
	at[2] = 8.4000;
	points[3] = (-4328.4648, 7814.7246, 4624.6460);
	angles[3] = (0, -170.2325, 148.8005);
	at[3] = 8.4667;
	points[4] = (-4323.7402, 7787.3623, 4696.6929);
	angles[4] = (0, -170.2325, 136.8004);
	at[4] = 8.5333;
	points[5] = (-4319.0552, 7760, 4759.2915);
	angles[5] = (0, -170.2325, 124.8002);
	at[5] = 8.6000;
	points[6] = (-4314.3306, 7732.5986, 4812.4409);
	angles[6] = (0, -170.2325, 112.8000);
	at[6] = 8.6667;
	points[7] = (-4309.6064, 7705.2363, 4856.1416);
	angles[7] = (0, -170.2324, 100.7999);
	at[7] = 8.7333;
	points[8] = (-4304.9214, 7677.8745, 4890.3940);
	angles[8] = (0, -170.2325, 88.7998);
	at[8] = 8.8000;
	points[9] = (-4300.1968, 7650.4727, 4915.1968);
	angles[9] = (0, -170.2325, 76.7996);
	at[9] = 8.8667;
	points[10] = (-4295.4727, 7623.1104, 4930.5513);
	angles[10] = (0, -170.2325, 64.7994);
	at[10] = 8.9333;
	points[11] = (-4290.7480, 7595.7485, 4936.4570);
	angles[11] = (0, -170.2325, 52.7993);
	at[11] = 9;
	points[12] = (-4286.0630, 7568.3462, 4932.9136);
	angles[12] = (0, -170.2325, 40.7991);
	at[12] = 9.0667;
	points[13] = (-4281.3389, 7540.9844, 4919.9214);
	angles[13] = (0, -170.2325, 28.7989);
	at[13] = 9.1333;
	points[14] = (-4276.6143, 7513.6221, 4897.4805);
	angles[14] = (0, -170.2325, 16.7989);
	at[14] = 9.2000;
	points[15] = (-4271.9292, 7486.2202, 4865.5903);
	angles[15] = (0, -170.2325, 4.7987);
	at[15] = 9.2667;
	points[16] = (-4267.2046, 7458.8584, 4824.2520);
	angles[16] = (0, -170.2325, -7.2015);
	at[16] = 9.3333;
	points[17] = (-4262.4805, 7431.4961, 4773.4648);
	angles[17] = (0, -170.2325, -19.2016);
	at[17] = 9.4000;
	points[18] = (-4257.7954, 7404.1343, 4713.2285);
	angles[18] = (0, -170.2325, -31.2017);
	at[18] = 9.4667;
	points[19] = (-4253.0708, 7376.7324, 4643.5435);
	angles[19] = (0, -170.2325, -43.2020);
	at[19] = 9.5333;
	points[20] = (-4248.3462, 7349.3701, 4564.4092);
	angles[20] = (0, -170.2325, -55.2021);
	at[20] = 9.6000;
	points[21] = (-4243.6616, 7322.0083, 4475.8267);
	angles[21] = (0, -170.2325, -67.2021);
	at[21] = 9.6667;
	points[22] = (-4238.9370, 7294.6064, 4377.7954);
	angles[22] = (0, -170.2325, -79.2024);
	at[22] = 9.7333;
	points[23] = (-4234.2129, 7267.2441, 4270.3149);
	angles[23] = (0, -170.2325, -91.2025);
	at[23] = 9.8000;
	points[24] = (-4229.4883, 7239.8823, 4153.3857);
	angles[24] = (0, -170.2325, -103.2027);
	at[24] = 9.8667;
	points[25] = (-4224.8032, 7212.4805, 4027.0081);
	angles[25] = (0, -170.2325, -115.2029);
	at[25] = 9.9333;
	points[26] = (-4220.0791, 7185.1182, 3891.1931);
	angles[26] = (0, -170.2325, -127.2029);
	at[26] = 10;
	points[27] = (-4215.3545, 7157.7563, 3745.9175);
	angles[27] = (0, -170.2325, -139.2032);
	at[27] = 10.0667;
	points[28] = (-4210.6694, 7130.3540, 3591.1931);
	angles[28] = (0, -170.2325, -151.2033);
	at[28] = 10.1333;
	points[29] = (-4205.9448, 7102.9922, 3427.0198);
	angles[29] = (0, -170.2325, -163.2034);
	at[29] = 10.2000;
	points[30] = (-4201.2207, 7075.6299, 3369.3701);
	angles[30] = (0, -170.2325, -185.3020);
	at[30] = 10.2667;
	points[31] = (-4196.5356, 7048.2280, 3410.4724);
	angles[31] = (0, -170.2325, -210.7667);
	at[31] = 10.3333;
	points[32] = (-4191.8110, 7020.8662, 3442.1260);
	angles[32] = (0, -170.2325, -236.2313);
	at[32] = 10.4000;
	points[33] = (-4187.0864, 6993.5039, 3464.3308);
	angles[33] = (0, -170.2325, -261.6960);
	at[33] = 10.4667;
	points[34] = (-4182.3623, 6966.1021, 3477.0867);
	angles[34] = (0, -170.2325, -287.1608);
	at[34] = 10.5333;
	points[35] = (-4177.6377, 6925.8267, 3480.3938);
	angles[35] = (0, -174.1321, -312.6254);
	at[35] = 10.6000;
	points[36] = (-4172.8740, 6879.4097, 3474.2522);
	angles[36] = (0, -174.1321, -338.0901);
	at[36] = 10.6667;
	points[37] = (-4168.0713, 6832.9922, 3458.6614);
	angles[37] = (0, -174.1321, -363.5548);
	at[37] = 10.7333;
	points[38] = (-4163.3071, 6786.5747, 3433.6221);
	angles[38] = (0, -174.1321, -389.0196);
	at[38] = 10.8000;
	points[39] = (-4158.5435, 6740.1572, 3399.1338);
	angles[39] = (0, -174.1321, -414.4843);
	at[39] = 10.8667;
	points[40] = (-4153.7793, 6693.7402, 3355.1968);
	angles[40] = (0, -174.1321, -439.9489);
	at[40] = 10.9333;
	points[41] = (-4149.0161, 6647.3228, 3301.8110);
	angles[41] = (0, -174.1321, -465.4136);
	at[41] = 11;
	points[42] = (-4144.2520, 6600.9053, 3282.6143);
	angles[42] = (0, -174.1321, -493.8782);
	at[42] = 11.0667;
	points[43] = (-4139.4487, 6554.4878, 3290.4805);
	angles[43] = (0, -174.1321, -523.3425);
	at[43] = 11.1333;
	points[44] = (-4134.6851, 6508.0317, 3288.8977);
	angles[44] = (0, -174.1321, -552.8071);
	at[44] = 11.2000;
	points[45] = (-4129.9214, 6461.6143, 3277.8660);
	angles[45] = (0, -174.1321, -582.2715);
	at[45] = 11.2667;
	points[46] = (-4119.2124, 6369.2915, 3237.7952);
	angles[46] = (0, -173.1440, -643.2006);
	at[46] = 11.4000;
	points[47] = (-4113.6616, 6323.1890, 3238.8582);
	angles[47] = (0, -173.1440, -676.6657);
	at[47] = 11.4667;
	points[48] = (-4108.1499, 6277.1260, 3230.4763);
	angles[48] = (0, -173.1440, -710.1309);
	at[48] = 11.5333;
	points[49] = (-4102.5986, 6231.0239, 3212.6455);
	angles[49] = (0, -173.1440, -743.5960);
	at[49] = 11.6000;
	points[50] = (-4097.0474, 6184.9609, 3211.3582);
	angles[50] = (0, -173.1440, -781.0609);
	at[50] = 11.6667;
	points[51] = (-4091.4963, 6138.8584, 3205.4883);
	angles[51] = (0, -173.1440, -818.5256);
	at[51] = 11.7333;
	points[52] = (-4085.9841, 6092.7559, 3190.1692);
	angles[52] = (0, -173.1440, -855.9905);
	at[52] = 11.8000;
	points[53] = (-4074.8818, 6000.5903, 3179.2244);
	angles[53] = (0, -173.1440, -937.9197);
	at[53] = 11.9333;
	points[54] = (-4069.3308, 5954.5273, 3166.2244);
	angles[54] = (0, -173.1440, -979.3843);
	at[54] = 12;
	points[55] = (-4065.1968, 5919.9609, 3150.2717);
	angles[55] = (0, -173.1440, -1010.4828);
	at[55] = 12.0667;
	points[56] = (-4335.5513, 7855.7876, 4475.8267);
	angles[56] = (0, -173.1440, -1010.4828);
	at[56] = 12.0667;
	points[57] = (-4335.5513, 7855.7876, 4475.8267);
	angles[57] = (0, -173.1440, -1010.4828);
	at[57] = 13.3500;
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
	points[0] = (-504.9055, 7409.2524, -8486.2207);
	angles[0] = (0, 179.1464, -147.0199);
	at[0] = 0;
	points[1] = (-505.4213, 7374.6851, -8872.4414);
	angles[1] = (0, 179.1464, -156.0201);
	at[1] = 0.0500;
	points[2] = (-505.9370, 7340.1182, -9263.9766);
	angles[2] = (0, 179.1464, -165.0202);
	at[2] = 0.1000;
	points[3] = (-506.4488, 7305.5513, -9660.8271);
	angles[3] = (0, 179.1464, -174.0203);
	at[3] = 0.1500;
	points[4] = (-506.9646, 7270.9844, -10062.9922);
	angles[4] = (0, 179.1464, -183.0204);
	at[4] = 0.2000;
	points[5] = (-507.4803, 7236.4170, -10470.4727);
	angles[5] = (0, 179.1464, -192.0204);
	at[5] = 0.2500;
	points[6] = (-507.9961, 7201.8506, -10883.2676);
	angles[6] = (0, 179.1464, -201.0206);
	at[6] = 0.3000;
	points[7] = (-508.0866, 7167.4805, -11301.3779);
	angles[7] = (0, 180.2234, -210.0207);
	at[7] = 0.3500;
	points[8] = (-507.9528, 7133.1890, -11724.8027);
	angles[8] = (0, 180.2234, -219.0209);
	at[8] = 0.4000;
	points[9] = (-507.8189, 7098.8975, -12153.5439);
	angles[9] = (0, 180.2234, -228.0210);
	at[9] = 0.4500;
	points[10] = (-507.6850, 7064.5669, -12587.5986);
	angles[10] = (0, 180.2234, -237.0210);
	at[10] = 0.5000;
	points[11] = (-507.5512, 7030.2759, -13026.9688);
	angles[11] = (0, 180.2234, -246.0212);
	at[11] = 0.5500;
	points[12] = (-507.4173, 6995.9844, -13471.6533);
	angles[12] = (0, 180.2234, -255.0212);
	at[12] = 0.6000;
	points[13] = (-507.2835, 6961.6929, -13921.6533);
	angles[13] = (0, 180.2234, -264.0213);
	at[13] = 0.6500;
	points[14] = (-507.1496, 6927.4014, -14376.9678);
	angles[14] = (0, 180.2234, -273.0215);
	at[14] = 0.7000;
	points[15] = (-507.0157, 6893.1104, -14837.5986);
	angles[15] = (0, 180.2234, -282.0215);
	at[15] = 0.7500;
	points[16] = (-506.8819, 6858.8193, -15303.5430);
	angles[16] = (0, 180.2234, -291.0217);
	at[16] = 0.8000;
	points[17] = (-506.7480, 6824.4883, -15774.8027);
	angles[17] = (0, 180.2234, -300.0219);
	at[17] = 0.8500;
	points[18] = (-506.6142, 6790.1968, -16251.3779);
	angles[18] = (0, 180.2234, -309.0220);
	at[18] = 0.9000;
	points[19] = (-506.4803, 6755.9058, -16733.2676);
	angles[19] = (0, 180.2234, -318.0221);
	at[19] = 0.9500;
	points[20] = (-506.3465, 6721.6143, -17220.4727);
	angles[20] = (0, 180.2234, -327.0222);
	at[20] = 1;
	points[21] = (-506.3032, 6710.1968, -17384.0547);
	angles[21] = (0, 180.2234, -330.0222);
	at[21] = 1.0333;
	points[22] = (-488.3780, 9582.7949, 4893.3071);
	angles[22] = (0, 180.2234, -330.0222);
	at[22] = 1.0333;
	points[23] = (-488.3780, 9582.7949, 4893.3071);
	angles[23] = (0, 180.2234, -330.0222);
	at[23] = 1.0500;
	points[24] = (-488.0315, 9571.6533, 4960.6299);
	angles[24] = (0, 181.7792, -468.0104);
	at[24] = 1.1000;
	points[25] = (-487.5118, 9554.9609, 5022.6377);
	angles[25] = (0, 181.7792, -477.0105);
	at[25] = 1.1500;
	points[26] = (-486.9961, 9538.2285, 5079.3306);
	angles[26] = (0, 181.7792, -486.0106);
	at[26] = 1.2000;
	points[27] = (-486.4764, 9521.5352, 5130.7090);
	angles[27] = (0, 181.7792, -495.0107);
	at[27] = 1.2500;
	points[28] = (-485.9567, 9504.8428, 5176.7720);
	angles[28] = (0, 181.7792, -504.0108);
	at[28] = 1.3000;
	points[29] = (-485.4370, 9488.1494, 5217.5195);
	angles[29] = (0, 181.7792, -513.0110);
	at[29] = 1.3500;
	points[30] = (-484.9173, 9471.4570, 5252.9531);
	angles[30] = (0, 181.7792, -522.0111);
	at[30] = 1.4000;
	points[31] = (-484.4016, 9454.7246, 5283.0708);
	angles[31] = (0, 181.7792, -531.0112);
	at[31] = 1.4500;
	points[32] = (-483.8819, 9438.0312, 5307.8745);
	angles[32] = (0, 181.7792, -540.0113);
	at[32] = 1.5000;
	points[33] = (-483.3622, 9421.3389, 5327.3623);
	angles[33] = (0, 181.7792, -549.0114);
	at[33] = 1.5500;
	points[34] = (-482.8425, 9404.6465, 5341.5356);
	angles[34] = (0, 181.7792, -558.0115);
	at[34] = 1.6000;
	points[35] = (-482.3268, 9387.9141, 5350.3936);
	angles[35] = (0, 181.7792, -567.0117);
	at[35] = 1.6500;
	points[36] = (-481.8071, 9371.2207, 5353.9375);
	angles[36] = (0, 181.7792, -576.0118);
	at[36] = 1.7000;
	points[37] = (-481.2874, 9354.5273, 5352.1655);
	angles[37] = (0, 181.7792, -585.0118);
	at[37] = 1.7500;
	points[38] = (-480.7677, 9337.8350, 5345.0786);
	angles[38] = (0, 181.7792, -594.0120);
	at[38] = 1.8000;
	points[39] = (-480.2520, 9321.1416, 5332.6772);
	angles[39] = (0, 181.7792, -603.0121);
	at[39] = 1.8500;
	points[40] = (-479.7323, 9304.4092, 5314.9609);
	angles[40] = (0, 181.7792, -612.0122);
	at[40] = 1.9000;
	points[41] = (-479.2126, 9287.7168, 5291.9287);
	angles[41] = (0, 181.7792, -621.0122);
	at[41] = 1.9500;
	points[42] = (-478.6929, 9271.0234, 5263.5830);
	angles[42] = (0, 181.7792, -630.0124);
	at[42] = 2;
	points[43] = (-478.1732, 9254.3311, 5229.9214);
	angles[43] = (0, 181.7792, -639.0125);
	at[43] = 2.0500;
	points[44] = (-477.6575, 9237.5986, 5190.9453);
	angles[44] = (0, 181.7792, -648.0126);
	at[44] = 2.1000;
	points[45] = (-477.1378, 9220.9053, 5146.6538);
	angles[45] = (0, 181.7792, -657.0127);
	at[45] = 2.1500;
	points[46] = (-476.6181, 9204.2129, 5097.0474);
	angles[46] = (0, 181.7792, -666.0128);
	at[46] = 2.2000;
	points[47] = (-476.0984, 9187.5205, 5042.1265);
	angles[47] = (0, 181.7792, -675.0129);
	at[47] = 2.2500;
	points[48] = (-475.5827, 9170.8271, 4981.8896);
	angles[48] = (0, 181.7792, -684.0131);
	at[48] = 2.3000;
	points[49] = (-475.0630, 9154.0947, 4916.3389);
	angles[49] = (0, 181.7792, -693.0132);
	at[49] = 2.3500;
	points[50] = (-474.5433, 9137.4014, 4845.4722);
	angles[50] = (0, 181.7792, -702.0133);
	at[50] = 2.4000;
	points[51] = (-474.0237, 9120.7090, 4769.2915);
	angles[51] = (0, 181.7792, -711.0134);
	at[51] = 2.4500;
	points[52] = (-473.5040, 9104.0156, 4687.7954);
	angles[52] = (0, 181.7792, -720.0135);
	at[52] = 2.5000;
	points[53] = (-472.9882, 9087.3223, 4600.9844);
	angles[53] = (0, 181.7792, -729.0137);
	at[53] = 2.5500;
	points[54] = (-472.4685, 9070.5908, 4508.8584);
	angles[54] = (0, 181.7792, -738.0137);
	at[54] = 2.6000;
	points[55] = (-471.9488, 9053.8975, 4411.4175);
	angles[55] = (0, 181.7792, -747.0139);
	at[55] = 2.6500;
	points[56] = (-471.4292, 9037.2051, 4308.6616);
	angles[56] = (0, 181.7792, -756.0140);
	at[56] = 2.7000;
	points[57] = (-470.9134, 9020.5117, 4200.5908);
	angles[57] = (0, 181.7792, -765.0141);
	at[57] = 2.7500;
	points[58] = (-470.3937, 9003.7793, 4087.2048);
	angles[58] = (0, 181.7792, -774.0142);
	at[58] = 2.8000;
	points[59] = (-469.8740, 8987.0869, 3968.5042);
	angles[59] = (0, 181.7792, -783.0143);
	at[59] = 2.8500;
	points[60] = (-469.3543, 8970.3945, 3844.4805);
	angles[60] = (0, 181.7792, -792.0144);
	at[60] = 2.9000;
	points[61] = (-468.8386, 8953.7012, 3715.1497);
	angles[61] = (0, 181.7792, -801.0146);
	at[61] = 2.9500;
	points[62] = (-468.3189, 8937.0078, 3580.5042);
	angles[62] = (0, 181.7792, -810.0146);
	at[62] = 3;
	points[63] = (-467.7992, 8920.2754, 3440.5435);
	angles[63] = (0, 181.7792, -819.0148);
	at[63] = 3.0500;
	points[64] = (-467.2795, 8903.5830, 3295.2678);
	angles[64] = (0, 181.7792, -828.0149);
	at[64] = 3.1000;
	points[65] = (-466.7598, 8886.8896, 3144.6772);
	angles[65] = (0, 181.7792, -837.0150);
	at[65] = 3.1500;
	points[66] = (-467.1929, 8862.2051, 2988.7717);
	angles[66] = (0, 177.4189, -846.0151);
	at[66] = 3.2000;
	points[67] = (-468.7205, 8828.3076, 2827.5513);
	angles[67] = (0, 177.4189, -855.0153);
	at[67] = 3.2500;
	points[68] = (-470.2520, 8794.3701, 2661.0156);
	angles[68] = (0, 177.4189, -864.0154);
	at[68] = 3.3000;
	points[69] = (-471.7795, 8760.4727, 2489.1653);
	angles[69] = (0, 177.4189, -873.0155);
	at[69] = 3.3500;
	points[70] = (-473.3071, 8726.5752, 2312);
	angles[70] = (0, 177.4189, -882.0156);
	at[70] = 3.4000;
	points[71] = (-474.8346, 8692.6777, 2129.5198);
	angles[71] = (0, 177.4189, -891.0157);
	at[71] = 3.4500;
	points[72] = (-476.3622, 8658.7402, 1941.7245);
	angles[72] = (0, 177.4189, -900.0158);
	at[72] = 3.5000;
	points[73] = (-477.8937, 8624.8428, 1748.6141);
	angles[73] = (0, 177.4189, -909.0159);
	at[73] = 3.5500;
	points[74] = (-479.4213, 8590.9453, 1550.1891);
	angles[74] = (0, 177.4189, -918.0161);
	at[74] = 3.6000;
	points[75] = (-480.9488, 8557.0469, 1346.4487);
	angles[75] = (0, 177.4189, -927.0162);
	at[75] = 3.6500;
	points[76] = (-482.4764, 8523.1104, 1137.3937);
	angles[76] = (0, 177.4189, -936.0163);
	at[76] = 3.7000;
	points[77] = (-484.0079, 8489.2129, 923.0236);
	angles[77] = (0, 177.4189, -945.0164);
	at[77] = 3.7500;
	points[78] = (-485.5354, 8455.3154, 703.3386);
	angles[78] = (0, 177.4189, -954.0165);
	at[78] = 3.8000;
	points[79] = (-487.0630, 8421.4180, 478.3386);
	angles[79] = (0, 177.4189, -963.0167);
	at[79] = 3.8500;
	points[80] = (-488.5906, 8387.4805, 248.0244);
	angles[80] = (0, 177.4189, -972.0167);
	at[80] = 3.9000;
	points[81] = (-490.1220, 8353.5830, 12.3946);
	angles[81] = (0, 177.4189, -981.0168);
	at[81] = 3.9500;
	points[82] = (-491.6496, 8319.6855, -228.5504);
	angles[82] = (0, 179.1464, -990.0169);
	at[82] = 4;
	points[83] = (-491.8583, 8284.9209, -474.8110);
	angles[83] = (0, 179.1464, -999.0170);
	at[83] = 4.0500;
	points[84] = (-492.3740, 8250.3545, -726.3858);
	angles[84] = (0, 179.1464, -1008.0172);
	at[84] = 4.1000;
	points[85] = (-492.8898, 8215.7871, -983.2756);
	angles[85] = (0, 179.1464, -1017.0174);
	at[85] = 4.1500;
	points[86] = (-493.4016, 8181.2202, -1245.4803);
	angles[86] = (0, 179.1464, -1026.0173);
	at[86] = 4.2000;
	points[87] = (-493.9173, 8146.6538, -1513);
	angles[87] = (0, 179.1464, -1035.0175);
	at[87] = 4.2500;
	points[88] = (-494.4331, 8112.0864, -1785.8346);
	angles[88] = (0, 179.1464, -1044.0176);
	at[88] = 4.3000;
	points[89] = (-494.9488, 8077.5200, -2063.9844);
	angles[89] = (0, 179.1464, -1053.0178);
	at[89] = 4.3500;
	points[90] = (-495.4646, 8042.9526, -2347.4487);
	angles[90] = (0, 179.1464, -1062.0179);
	at[90] = 4.4000;
	points[91] = (-495.9803, 8008.3857, -2636.2283);
	angles[91] = (0, 179.1464, -1071.0179);
	at[91] = 4.4500;
	points[92] = (-496.4921, 7973.8193, -2930.3228);
	angles[92] = (0, 179.1464, -1080.0181);
	at[92] = 4.5000;
	points[93] = (-497.0079, 7939.2520, -3229.7324);
	angles[93] = (0, 179.1464, -1089.0182);
	at[93] = 4.5500;
	points[94] = (-497.5237, 7904.6855, -3534.4568);
	angles[94] = (0, 179.1464, -1098.0183);
	at[94] = 4.6000;
	points[95] = (-498.0394, 7870.1182, -3844.4961);
	angles[95] = (0, 179.1464, -1107.0184);
	at[95] = 4.6500;
	points[96] = (-498.5551, 7835.5513, -4159.8428);
	angles[96] = (0, 179.1464, -1116.0186);
	at[96] = 4.7000;
	points[97] = (-499.0669, 7800.9844, -4480.5117);
	angles[97] = (0, 179.1464, -1125.0187);
	at[97] = 4.7500;
	points[98] = (-499.5827, 7766.4175, -4806.4961);
	angles[98] = (0, 179.1464, -1134.0188);
	at[98] = 4.8000;
	points[99] = (-500.0984, 7731.8506, -5137.7954);
	angles[99] = (0, 179.1464, -1143.0188);
	at[99] = 4.8500;
	points[100] = (-500.6142, 7697.2837, -5474.4097);
	angles[100] = (0, 179.1464, -1152.0190);
	at[100] = 4.9000;
	points[101] = (-501.1299, 7662.7163, -5816.3389);
	angles[101] = (0, 179.1464, -1161.0192);
	at[101] = 4.9500;
	points[102] = (-501.6418, 7628.1499, -6163.5825);
	angles[102] = (0, 179.1464, -1170.0193);
	at[102] = 5;
	points[103] = (-502.1575, 7593.6226, -6516.1416);
	angles[103] = (0, 179.1464, -1179.0193);
	at[103] = 5.0500;
	points[104] = (-502.6732, 7559.0552, -6874.0161);
	angles[104] = (0, 179.1464, -1188.0194);
	at[104] = 5.1000;
	points[105] = (-503.1890, 7524.4883, -7237.2046);
	angles[105] = (0, 179.1464, -1197.0195);
	at[105] = 5.1500;
	points[106] = (-503.7047, 7489.9214, -7605.7085);
	angles[106] = (0, 179.1464, -1206.0197);
	at[106] = 5.2000;
	points[107] = (-504.2205, 7455.3545, -7979.5273);
	angles[107] = (0, 179.1464, -1215.0198);
	at[107] = 5.2500;
	points[108] = (-504.9055, 7409.2524, -8486.2207);
	angles[108] = (0, 179.1464, -1227.0199);
	at[108] = 5.3167;
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
