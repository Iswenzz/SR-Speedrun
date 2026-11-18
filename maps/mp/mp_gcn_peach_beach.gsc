main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_gcn_peach_beach", 0);

	setExpFog(8858.2676, 23314.4688, 0.6039, 0.6824, 1, 0);

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
	ambientPlay("iz_0_r_gc_beach32", 2);
	iz_emitter("iz_1_se_cc_env_sea", (4429.1338, -10305.1182, 2997.0474), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (2214.5669, -10305.1182, 2997.0474), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (0, -10305.1182, 2997.0474), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-2214.5669, -10305.1182, 2997.0474), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-4429.1338, -10305.1182, 2997.0474), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-5019.6851, -8244.0947, 2997.0474), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-5610.2363, -6183.0713, 2997.0474), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-6200.7876, -4122.0474, 2997.0474), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-6791.3389, -2061.0237, 2997.0474), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-7381.8896, 0, 2997.0474), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-7234.2520, 1993.1102, 2997.0474), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-7086.6143, 3986.2205, 2997.0474), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-6938.9766, 5979.3306, 2997.0474), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-6791.3389, 7972.4409, 2997.0474), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-4650.5908, 8784.4492, 2997.0474), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-2509.8425, 9596.4570, 2997.0474), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (-369.0945, 10408.4648, 2997.0474), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_sea", (1771.6536, 11220.4727, 2997.0474), 0, 12.0104);
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
	level.iz_route[level.iz_route.size] = (3396, -2198, 4076);
	level.iz_route[level.iz_route.size] = (3302, -4316, 4022);
	level.iz_route[level.iz_route.size] = (3277, -6992, 3818);
	level.iz_route[level.iz_route.size] = (2997, -7883, 3707);
	level.iz_route[level.iz_route.size] = (2581, -8575, 3604);
	level.iz_route[level.iz_route.size] = (1853, -8912, 3562);
	level.iz_route[level.iz_route.size] = (1019, -9055, 3518);
	level.iz_route[level.iz_route.size] = (354, -8989, 3380);
	level.iz_route[level.iz_route.size] = (-351, -8761, 3233);
	level.iz_route[level.iz_route.size] = (-943, -7917, 3314);
	level.iz_route[level.iz_route.size] = (-1528, -6147, 3197);
	level.iz_route[level.iz_route.size] = (-917, -5026, 3063);
	level.iz_route[level.iz_route.size] = (-173, -4087, 3058);
	level.iz_route[level.iz_route.size] = (304, -3001, 3055);
	level.iz_route[level.iz_route.size] = (716, -1373, 3058);
	level.iz_route[level.iz_route.size] = (172, -65, 3054);
	level.iz_route[level.iz_route.size] = (-679, 846, 3049);
	level.iz_route[level.iz_route.size] = (-2492, 1763, 3029);
	level.iz_route[level.iz_route.size] = (-3820, 2414, 3015);
	level.iz_route[level.iz_route.size] = (-3790, 3526, 3090);
	level.iz_route[level.iz_route.size] = (-3899, 4607, 3090);
	level.iz_route[level.iz_route.size] = (-3384, 5656, 3073);
	level.iz_route[level.iz_route.size] = (-2322, 6478, 3057);
	level.iz_route[level.iz_route.size] = (-1081, 7002, 3064);
	level.iz_route[level.iz_route.size] = (-374, 8025, 3061);
	level.iz_route[level.iz_route.size] = (459, 8891, 3118);
	level.iz_route[level.iz_route.size] = (1653, 9083, 3118);
	level.iz_route[level.iz_route.size] = (2113, 9006, 3144);
	level.iz_route[level.iz_route.size] = (2534, 8797, 3170);
	level.iz_route[level.iz_route.size] = (2834, 8451, 3197);
	level.iz_route[level.iz_route.size] = (3011, 8040, 3228);
	level.iz_route[level.iz_route.size] = (3155, 7067, 3371);
	level.iz_route[level.iz_route.size] = (3245, 6007, 3534);
	level.iz_route[level.iz_route.size] = (3336, 4631, 3893);
	level.iz_route[level.iz_route.size] = (3372, 3515, 4072);
	level.iz_route[level.iz_route.size] = (3406, 2708, 4096);
	level.iz_route[level.iz_route.size] = (3363, 2017, 4096);
	level.iz_route[level.iz_route.size] = (3344, 816, 4096);
	level.iz_route[level.iz_route.size] = (3322, -96, 4096);
	level.iz_route[level.iz_route.size] = (3322, -812, 4093);
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
	points[0] = (686.6929, -10048.5830, 4200.9058);
	angles[0] = (0, 88.0017, 0);
	at[0] = 0;
	points[1] = (565.1102, -10043.2676, 4196.4565);
	angles[1] = (0, 87.6255, 0);
	at[1] = 0.2333;
	points[2] = (67.5957, -10016.3389, 4183.0708);
	angles[2] = (0, 86.3362, 0);
	at[2] = 1.1667;
	points[3] = (-181.2126, -9994.2129, 4175.9844);
	angles[3] = (0, 84.3878, 0);
	at[3] = 1.6333;
	points[4] = (-300.9512, -9975.5908, 4171.4570);
	angles[4] = (0, 81.1187, 0);
	at[4] = 1.8667;
	points[5] = (-419.2677, -9942.7559, 4165.4727);
	angles[5] = (0, 75.5239, 0);
	at[5] = 2.1000;
	points[6] = (-538.3543, -9903.4248, 4158.9370);
	angles[6] = (0, 72.3940, 0);
	at[6] = 2.3333;
	points[7] = (-771.0197, -9818.2285, 4145.0791);
	angles[7] = (0, 69.6105, 0);
	at[7] = 2.8000;
	points[8] = (-1001.7992, -9725.5518, 4129.3701);
	angles[8] = (0, 67.7888, 0);
	at[8] = 3.2667;
	points[9] = (-1115.0039, -9676.2207, 4120.3149);
	angles[9] = (0, 66.5601, 0);
	at[9] = 3.5000;
	points[10] = (-1221.7756, -9624.1338, 4109.4487);
	angles[10] = (0, 64.1220, 0);
	at[10] = 3.7333;
	points[11] = (-1331.4764, -9564.3311, 4095.5513);
	angles[11] = (0, 61.8634, 0);
	at[11] = 3.9667;
	points[12] = (-1545.8977, -9441.0625, 4065.9451);
	angles[12] = (0, 59.9163, 0);
	at[12] = 4.4333;
	points[13] = (-1862.2914, -9247.2051, 4018.6221);
	angles[13] = (0, 57.8658, 0);
	at[13] = 5.1333;
	points[14] = (-2066.9094, -9108.3467, 3984.4883);
	angles[14] = (0, 55.1175, 0);
	at[14] = 5.6000;
	points[15] = (-2161.0591, -9031.6543, 3965.6299);
	angles[15] = (0, 50.8524, 0);
	at[15] = 5.8333;
	points[16] = (-2235.6221, -8940.0791, 3942.1653);
	angles[16] = (0, 40.7376, 0);
	at[16] = 6.0667;
	points[17] = (-2301.3936, -8837.1660, 3914.9646);
	angles[17] = (0, 33.9923, 0);
	at[17] = 6.3000;
	points[18] = (-2361.2166, -8731.4570, 3887.0159);
	angles[18] = (0, 30.2590, 0);
	at[18] = 6.5333;
	points[19] = (-2417.0078, -8624.1738, 3858.9490);
	angles[19] = (0, 27.9066, 0);
	at[19] = 6.7667;
	points[20] = (-2519.7166, -8403.9375, 3803.5195);
	angles[20] = (0, 24.4210, 0);
	at[20] = 7.2333;
	points[21] = (-2565.1929, -8292.0078, 3777.8110);
	angles[21] = (0, 22.3173, 0);
	at[21] = 7.4667;
	points[22] = (-2600.7678, -8178.7793, 3757.2678);
	angles[22] = (0, 17.4800, 0);
	at[22] = 7.7000;
	points[23] = (-2622.7756, -8055.6304, 3741.8662);
	angles[23] = (0, 11.3533, 0);
	at[23] = 7.9333;
	points[24] = (-2653.2676, -7810.5908, 3715.9724);
	angles[24] = (0, 6.8661, 0);
	at[24] = 8.4000;
	points[25] = (-2704.2954, -7317.1655, 3666.1536);
	angles[25] = (0, 6.1910, 0);
	at[25] = 9.3333;
	points[26] = (-2720.9055, -7199.3701, 3651.4409);
	angles[26] = (0, 8.0732, 0);
	at[26] = 9.5667;
	points[27] = (-2767.7363, -6957.7954, 3610.1536);
	angles[27] = (0, 11.1210, 0);
	at[27] = 10.0333;
	points[28] = (-2871.8779, -6479.6064, 3523.0552);
	angles[28] = (0, 12.8270, 0);
	at[28] = 10.9667;
	points[29] = (-2901.2007, -6358.8979, 3503.1377);
	angles[29] = (0, 13.6074, 0);
	at[29] = 11.2000;
	points[30] = (-2933.6614, -6244.2124, 3488.5552);
	angles[30] = (0, 15.5906, 0);
	at[30] = 11.4333;
	points[31] = (-2970.6218, -6126.1812, 3476.0591);
	angles[31] = (0, 17.0726, 0);
	at[31] = 11.6667;
	points[32] = (-3166, -5537.0078, 3422.9292);
	angles[32] = (0, 18.5362, 0);
	at[32] = 12.8333;
	points[33] = (-3241.7363, -5306.3389, 3405.6851);
	angles[33] = (0, 18.0107, 0);
	at[33] = 13.3000;
	points[34] = (-3433.0552, -4714.5278, 3367.3699);
	angles[34] = (0, 18.1302, 0);
	at[34] = 14.4667;
	points[35] = (-3553.4211, -4362.9922, 3348.3545);
	angles[35] = (0, 19.4951, 0);
	at[35] = 15.1667;
	points[36] = (-3598.8149, -4250.3149, 3345.1182);
	angles[36] = (0, 22.0507, 0);
	at[36] = 15.4000;
	points[37] = (-3656.0276, -4137.8345, 3345.9211);
	angles[37] = (0, 26.1889, 0);
	at[37] = 15.6333;
	points[38] = (-3898.9214, -3704.3347, 3359.1182);
	angles[38] = (0, 29.0482, 0);
	at[38] = 16.5667;
	points[39] = (-3957.0474, -3594.1733, 3362.8662);
	angles[39] = (0, 27.8852, 0);
	at[39] = 16.8000;
	points[40] = (-4009.0945, -3482.7441, 3366.0552);
	angles[40] = (0, 25.1456, 0);
	at[40] = 17.0333;
	points[41] = (-4043.1104, -3366.5278, 3367.2913);
	angles[41] = (0, 16.5578, 0);
	at[41] = 17.2667;
	points[42] = (-4056.5750, -3241.9841, 3366.9172);
	angles[42] = (0, 7.9907, 0);
	at[42] = 17.5000;
	points[43] = (-4063.1104, -3118.1455, 3366.1025);
	angles[43] = (0, 3.9430, 0);
	at[43] = 17.7333;
	points[44] = (-4072.9136, -2496.6458, 3358.4568);
	angles[44] = (0, 1.1169, 0);
	at[44] = 18.9000;
	points[45] = (-4081.0234, -2376.1692, 3355.4685);
	angles[45] = (0, 3.8505, 0);
	at[45] = 19.1333;
	points[46] = (-4115.2363, -2128.8662, 3345.5671);
	angles[46] = (0, 8.0227, 0);
	at[46] = 19.6000;
	points[47] = (-4151.4565, -1882.6182, 3334.5708);
	angles[47] = (0, 8.2316, 0);
	at[47] = 20.0667;
	points[48] = (-4182.0078, -1635.5276, 3323.5039);
	angles[48] = (0, 6.5136, 0);
	at[48] = 20.5333;
	points[49] = (-4189.5669, -1511.9133, 3318.3701);
	angles[49] = (0, 3.5720, 0);
	at[49] = 20.7667;
	points[50] = (-4170.9844, -1392.5393, 3314.9211);
	angles[50] = (0, -8.1653, 0);
	at[50] = 21;
	points[51] = (-4126.5356, -1275.9449, 3312.8821);
	angles[51] = (0, -18.6951, 0);
	at[51] = 21.2333;
	points[52] = (-4072.9529, -1163.9724, 3311.4724);
	angles[52] = (0, -24.3936, 0);
	at[52] = 21.4667;
	points[53] = (-4013.3467, -1054.6417, 3310.4961);
	angles[53] = (0, -27.9725, 0);
	at[53] = 21.7000;
	points[54] = (-3948.6614, -949.1260, 3309.9961);
	angles[54] = (0, -31.0874, 0);
	at[54] = 21.9333;
	points[55] = (-3876.2283, -850.6614, 3310.3782);
	angles[55] = (0, -36.2875, 0);
	at[55] = 22.1667;
	points[56] = (-3786.1655, -764.6024, 3312.9136);
	angles[56] = (0, -44.6980, 0);
	at[56] = 22.4000;
	points[57] = (-3691.0081, -684.7007, 3316.1575);
	angles[57] = (0, -49.0298, 0);
	at[57] = 22.6333;
	points[58] = (-3492.9136, -533.5118, 3323.1931);
	angles[58] = (0, -53.1840, 0);
	at[58] = 23.1000;
	points[59] = (-3391.1890, -463.4882, 3326.6614);
	angles[59] = (0, -55.2448, 0);
	at[59] = 23.3333;
	points[60] = (-3284.1338, -400.8976, 3329.7756);
	angles[60] = (0, -59.7054, 0);
	at[60] = 23.5667;
	points[61] = (-3168.0474, -358.7579, 3331.8584);
	angles[61] = (0, -68.4188, 0);
	at[61] = 23.8000;
	points[62] = (-3049.3662, -325.0803, 3333.6223);
	angles[62] = (0, -73.1214, 0);
	at[62] = 24.0333;
	points[63] = (-2928.3545, -295.2669, 3335.2837);
	angles[63] = (0, -75.6695, 0);
	at[63] = 24.2667;
	points[64] = (-2806.6575, -269.0779, 3336.8584);
	angles[64] = (0, -77.5624, 0);
	at[64] = 24.5000;
	points[65] = (-2683.7717, -247.1114, 3338.3740);
	angles[65] = (0, -79.6309, 0);
	at[65] = 24.7333;
	points[66] = (-2559.7205, -233.0807, 3339.8110);
	angles[66] = (0, -83.3587, 0);
	at[66] = 24.9667;
	points[67] = (-2440, -240.9965, 3340.9644);
	angles[67] = (0, -92.5050, 0);
	at[67] = 25.2000;
	points[68] = (-2316.0513, -261.6110, 3341.9565);
	angles[68] = (0, -98.2055, 0);
	at[68] = 25.4333;
	points[69] = (-2194.7678, -287.2441, 3342.8623);
	angles[69] = (0, -101.3340, 0);
	at[69] = 25.6667;
	points[70] = (-2073.9880, -317.6102, 3343.7205);
	angles[70] = (0, -103.7513, 0);
	at[70] = 25.9000;
	points[71] = (-1955.4370, -353.3611, 3344.5234);
	angles[71] = (0, -106.4834, 0);
	at[71] = 26.1333;
	points[72] = (-1838.5433, -399.1929, 3345.2717);
	angles[72] = (0, -111.1286, 0);
	at[72] = 26.3667;
	points[73] = (-1742.9409, -471.8307, 3345.7598);
	angles[73] = (0, -127.0164, 0);
	at[73] = 26.6000;
	points[74] = (-1678.1654, -576.9764, 3345.8779);
	angles[74] = (0, -144.4491, 0);
	at[74] = 26.8333;
	points[75] = (-1622.9528, -689.4016, 3345.8818);
	angles[75] = (0, -152.0534, 0);
	at[75] = 27.0667;
	points[76] = (-1572.6063, -802.9488, 3345.8386);
	angles[76] = (0, -155.3377, 0);
	at[76] = 27.3000;
	points[77] = (-1427.8190, -1147.4921, 3345.6497);
	angles[77] = (0, -156.8326, 0);
	at[77] = 28;
	points[78] = (-1319.9882, -1367.1851, 3344.6025);
	angles[78] = (0, -153.6919, 0);
	at[78] = 28.4667;
	points[79] = (-1097.9489, -1813.3112, 3341.8977);
	angles[79] = (0, -153.7626, 0);
	at[79] = 29.4000;
	points[80] = (-990.1732, -2038.4803, 3342.6890);
	angles[80] = (0, -154.6760, 0);
	at[80] = 29.8667;
	points[81] = (-940.1890, -2151.6655, 3345.1890);
	angles[81] = (0, -156.1579, 0);
	at[81] = 30.1000;
	points[82] = (-897.2756, -2263.7009, 3352.9568);
	angles[82] = (0, -158.5379, 0);
	at[82] = 30.3333;
	points[83] = (-854.9371, -2380.8149, 3364.3503);
	angles[83] = (0, -159.8694, 0);
	at[83] = 30.5667;
	points[84] = (-776.4409, -2615.5828, 3389.8230);
	angles[84] = (0, -161.8702, 0);
	at[84] = 31.0333;
	points[85] = (-708.6456, -2854.0117, 3415.2441);
	angles[85] = (0, -164.8445, 0);
	at[85] = 31.5000;
	points[86] = (-683.3779, -2974.2520, 3426.1614);
	angles[86] = (0, -167.9317, 0);
	at[86] = 31.7333;
	points[87] = (-674.8544, -3094.3740, 3432.3030);
	angles[87] = (0, -175.5819, 0);
	at[87] = 31.9667;
	points[88] = (-683.9921, -3220.2246, 3432.5867);
	angles[88] = (0, -182.6493, 0);
	at[88] = 32.2000;
	points[89] = (-716.7244, -3466.0786, 3429.2913);
	angles[89] = (0, -187.9371, 0);
	at[89] = 32.6667;
	points[90] = (-758.9291, -3711.0159, 3425.9448);
	angles[90] = (0, -190.0628, 0);
	at[90] = 33.1333;
	points[91] = (-808.5000, -3954.2522, 3425.8860);
	angles[91] = (0, -191.8690, 0);
	at[91] = 33.6000;
	points[92] = (-837.1575, -4076.1023, 3428.9844);
	angles[92] = (0, -193.1121, 0);
	at[92] = 33.8333;
	points[93] = (-868.5197, -4188.4648, 3436.5474);
	angles[93] = (0, -195.5213, 0);
	at[93] = 34.0667;
	points[94] = (-909.0197, -4306.2598, 3448.8582);
	angles[94] = (0, -198.4186, 0);
	at[94] = 34.3000;
	points[95] = (-996.6496, -4540.7480, 3476.9688);
	angles[95] = (0, -200.6044, 0);
	at[95] = 34.7667;
	points[96] = (-1261.9606, -5232.3618, 3567.2441);
	angles[96] = (0, -200.6681, 0);
	at[96] = 36.1667;
	points[97] = (-1345.6497, -5463.0708, 3597.7561);
	angles[97] = (0, -199.6816, 0);
	at[97] = 36.6333;
	points[98] = (-1385.7166, -5582.1260, 3613.2441);
	angles[98] = (0, -198.6742, 0);
	at[98] = 36.8667;
	points[99] = (-1421.0867, -5701.4170, 3628.2559);
	angles[99] = (0, -196.6283, 0);
	at[99] = 37.1000;
	points[100] = (-1444.6732, -5813.8584, 3641.2954);
	angles[100] = (0, -192.4372, 0);
	at[100] = 37.3333;
	points[101] = (-1463.3307, -5936.1021, 3654.7480);
	angles[101] = (0, -189.3026, 0);
	at[101] = 37.5667;
	points[102] = (-1492.6418, -6183.6616, 3681.2717);
	angles[102] = (0, -186.4959, 0);
	at[102] = 38.0333;
	points[103] = (-1515.7205, -6429.5674, 3707.2991);
	angles[103] = (0, -185.1863, 0);
	at[103] = 38.5000;
	points[104] = (-1542.6261, -6800.6299, 3746.6968);
	angles[104] = (0, -183.7429, 0);
	at[104] = 39.2000;
	points[105] = (-1554.6299, -7046.2207, 3773.3584);
	angles[105] = (0, -182.5273, 0);
	at[105] = 39.6667;
	points[106] = (-1557.6615, -7170.6299, 3787.3938);
	angles[106] = (0, -181.4683, 0);
	at[106] = 39.9000;
	points[107] = (-1555.1968, -7290.7090, 3802.1025);
	angles[107] = (0, -178.7490, 0);
	at[107] = 40.1333;
	points[108] = (-1538.2874, -7411.9292, 3819.8621);
	angles[108] = (0, -172.8757, 0);
	at[108] = 40.3667;
	points[109] = (-1511.1102, -7532.3228, 3839.3545);
	angles[109] = (0, -168.1358, 0);
	at[109] = 40.6000;
	points[110] = (-1477.5631, -7650, 3859.5435);
	angles[110] = (0, -164.6858, 0);
	at[110] = 40.8333;
	points[111] = (-1438.3701, -7766.2598, 3880.3701);
	angles[111] = (0, -161.8094, 0);
	at[111] = 41.0667;
	points[112] = (-1393.5826, -7880.0396, 3901.5669);
	angles[112] = (0, -158.8929, 0);
	at[112] = 41.3000;
	points[113] = (-1341.1339, -7991.0635, 3923.2009);
	angles[113] = (0, -155.1006, 0);
	at[113] = 41.5333;
	points[114] = (-1276.6141, -8091.3779, 3944.3306);
	angles[114] = (0, -147.3966, 0);
	at[114] = 41.7667;
	points[115] = (-1188.4094, -8175.4727, 3965.6692);
	angles[115] = (0, -135.8620, 0);
	at[115] = 42;
	points[116] = (-1091.7401, -8252.7559, 3987.0474);
	angles[116] = (0, -129.9624, 0);
	at[116] = 42.2333;
	points[117] = (-993.2441, -8325.3545, 4007.9136);
	angles[117] = (0, -127.0078, 0);
	at[117] = 42.4667;
	points[118] = (-790.7007, -8462.7559, 4048.8584);
	angles[118] = (0, -123.7027, 0);
	at[118] = 42.9333;
	points[119] = (-686.7362, -8527.8350, 4068.8584);
	angles[119] = (0, -122.2400, 0);
	at[119] = 43.1667;
	points[120] = (-579.9095, -8590.0391, 4088.3467);
	angles[120] = (0, -120.3967, 0);
	at[120] = 43.4000;
	points[121] = (-469.4410, -8645.9443, 4106.5747);
	angles[121] = (0, -117.0249, 0);
	at[121] = 43.6333;
	points[122] = (-356.7579, -8683.0713, 4120.4727);
	angles[122] = (0, -109.2949, 0);
	at[122] = 43.8667;
	points[123] = (-236.4713, -8710.8271, 4132.6772);
	angles[123] = (0, -104.1111, 0);
	at[123] = 44.1000;
	points[124] = (-114.5441, -8734.6064, 4144.0947);
	angles[124] = (0, -101.5707, 0);
	at[124] = 44.3333;
	points[125] = (252.8461, -8794.0947, 4175.9844);
	angles[125] = (0, -98.6514, 0);
	at[125] = 45.0333;
	points[126] = (623.6732, -8842.5586, 4206.2993);
	angles[126] = (0, -96.8872, 0);
	at[126] = 45.7333;
	points[127] = (742.1024, -8850.9844, 4215.5117);
	angles[127] = (0, -94.1775, 0);
	at[127] = 45.9667;
	points[128] = (990.7717, -8851.2988, 4233.0312);
	angles[128] = (0, -89.7577, 0);
	at[128] = 46.4333;
	points[129] = (1363.8623, -8844.3701, 4257.2837);
	angles[129] = (0, -89.2550, 0);
	at[129] = 47.1333;
	points[130] = (1485.3976, -8850.0391, 4263.7007);
	angles[130] = (0, -92.8171, 0);
	at[130] = 47.3667;
	points[131] = (1607.8859, -8869.3311, 4266.6929);
	angles[131] = (0, -97.9568, 0);
	at[131] = 47.6000;
	points[132] = (1729.7677, -8894.2910, 4268.5039);
	angles[132] = (0, -100.9731, 0);
	at[132] = 47.8333;
	points[133] = (1850.9410, -8923.7012, 4270.9058);
	angles[133] = (0, -103.3325, 0);
	at[133] = 48.0667;
	points[134] = (1966.3112, -8964.0156, 4279.8032);
	angles[134] = (0, -108.9384, 0);
	at[134] = 48.3000;
	points[135] = (2078.3821, -9016.1416, 4294.3701);
	angles[135] = (0, -113.9650, 0);
	at[135] = 48.5333;
	points[136] = (2186.3191, -9076.2598, 4310.5513);
	angles[136] = (0, -118.6927, 0);
	at[136] = 48.7667;
	points[137] = (2264.0159, -9167.4023, 4330.0396);
	angles[137] = (0, -138.2381, 0);
	at[137] = 49;
	points[138] = (2314.1221, -9279.2129, 4351.1812);
	angles[138] = (0, -152.6425, 0);
	at[138] = 49.2333;
	points[139] = (2342.4805, -9397.5205, 4361.9688);
	angles[139] = (0, -166.2525, 0);
	at[139] = 49.4667;
	points[140] = (2324.0945, -9519.3311, 4344.8032);
	angles[140] = (0, -184.2812, 0);
	at[140] = 49.7000;
	points[141] = (2294.4844, -9638.5830, 4323.6221);
	angles[141] = (0, -192.2328, 0);
	at[141] = 49.9333;
	points[142] = (2246.1377, -9749.8428, 4304.4487);
	angles[142] = (0, -202.9613, 0);
	at[142] = 50.1667;
	points[143] = (2173.9409, -9849.3311, 4287.9136);
	angles[143] = (0, -214.0887, 0);
	at[143] = 50.4000;
	points[144] = (2080.4646, -9929.1738, 4274.4883);
	angles[144] = (0, -228.6327, 0);
	at[144] = 50.6333;
	points[145] = (1963.2362, -9963.4648, 4269.1338);
	angles[145] = (0, -249.0565, 0);
	at[145] = 50.8667;
	points[146] = (1840.7639, -9988.8584, 4265.4727);
	angles[146] = (0, -256.3900, 0);
	at[146] = 51.1000;
	points[147] = (1595.8859, -10031.2207, 4258.5435);
	angles[147] = (0, -260.4503, 0);
	at[147] = 51.5667;
	points[148] = (1473.5000, -10048.3467, 4254.4092);
	angles[148] = (0, -261.9012, 0);
	at[148] = 51.8000;
	points[149] = (1351.6260, -10057.2441, 4247.7559);
	angles[149] = (0, -265.5847, 0);
	at[149] = 52.0333;
	points[150] = (1226.7875, -10059.0947, 4238.7798);
	angles[150] = (0, -268.5140, 0);
	at[150] = 52.2667;
	points[151] = (979.1614, -10056.9688, 4220.2754);
	angles[151] = (0, -270.6443, 0);
	at[151] = 52.7333;
	points[152] = (686.6929, -10048.5830, 4200.9058);
	angles[152] = (0, -271.9983, 0);
	at[152] = 53.2833;
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
	points[0] = (-571.4764, 8902.2441, 3367.2520);
	angles[0] = (0, -51.4242, 0);
	at[0] = 0;
	points[1] = (-475.1457, 9002.2842, 3374.3779);
	angles[1] = (0, -44.7495, 0);
	at[1] = 0.2667;
	points[2] = (-288.1492, 9217.3623, 3389.7954);
	angles[2] = (0, -40.7580, 0);
	at[2] = 0.8000;
	points[3] = (80.2421, 9651.4170, 3421.5747);
	angles[3] = (0, -40.6489, 0);
	at[3] = 1.8667;
	points[4] = (174.7890, 9758.2285, 3429.7087);
	angles[4] = (0, -41.5245, 0);
	at[4] = 2.1333;
	points[5] = (271.5150, 9858.3076, 3437.7876);
	angles[5] = (0, -44.3071, 0);
	at[5] = 2.4000;
	points[6] = (323.3114, 9903.2285, 3441.8386);
	angles[6] = (0, -47.1836, 0);
	at[6] = 2.5333;
	points[7] = (434.4016, 9991.1025, 3450.2244);
	angles[7] = (0, -51.1351, 0);
	at[7] = 2.8000;
	points[8] = (548.4449, 10075.6299, 3458.6929);
	angles[8] = (0, -53.2046, 0);
	at[8] = 3.0667;
	points[9] = (723.2441, 10198.0312, 3471.6458);
	angles[9] = (0, -55.2084, 0);
	at[9] = 3.4667;
	points[10] = (841.9725, 10276.2998, 3480.5234);
	angles[10] = (0, -56.5504, 0);
	at[10] = 3.7333;
	points[11] = (961.8032, 10349.6846, 3489.6772);
	angles[11] = (0, -58.5031, 0);
	at[11] = 4;
	points[12] = (1024.7244, 10384.3311, 3494.6536);
	angles[12] = (0, -60.2518, 0);
	at[12] = 4.1333;
	points[13] = (1087.9725, 10412.5596, 3499.9763);
	angles[13] = (0, -64.2719, 0);
	at[13] = 4.2667;
	points[14] = (1156.1260, 10425.4727, 3506.7283);
	angles[14] = (0, -73.6716, 0);
	at[14] = 4.4000;
	points[15] = (1226.7599, 10427.7168, 3514.3779);
	angles[15] = (0, -82.3510, 0);
	at[15] = 4.5333;
	points[16] = (1297.4410, 10424.0547, 3522.3110);
	angles[16] = (0, -88.6675, 0);
	at[16] = 4.6667;
	points[17] = (1437.7086, 10405.2764, 3538.3621);
	angles[17] = (0, -96.6868, 0);
	at[17] = 4.9333;
	points[18] = (1575.6418, 10373.3066, 3553.9922);
	angles[18] = (0, -102.6846, 0);
	at[18] = 5.2000;
	points[19] = (1642.1732, 10350.5127, 3561.1025);
	angles[19] = (0, -106.6899, 0);
	at[19] = 5.3333;
	points[20] = (1700.3031, 10315.7871, 3566.0593);
	angles[20] = (0, -116.5176, 0);
	at[20] = 5.4667;
	points[21] = (1747.0118, 10260.6299, 3568.1577);
	angles[21] = (0, -130.3625, 0);
	at[21] = 5.6000;
	points[22] = (1786.5472, 10202.0469, 3569.2009);
	angles[22] = (0, -139.5199, 0);
	at[22] = 5.7333;
	points[23] = (1856.7206, 10078.3076, 3569.8384);
	angles[23] = (0, -149.0587, 0);
	at[23] = 6;
	points[24] = (1916.1693, 9948.8975, 3568.8464);
	angles[24] = (0, -154.9150, 0);
	at[24] = 6.2667;
	points[25] = (1939.5708, 9881.3389, 3567.4133);
	angles[25] = (0, -158.7601, 0);
	at[25] = 6.4000;
	points[26] = (1947.9016, 9814.3701, 3564.1892);
	angles[26] = (0, -168.8539, 0);
	at[26] = 6.5333;
	points[27] = (1926.7284, 9745.9062, 3556.7834);
	angles[27] = (0, -185.6931, 0);
	at[27] = 6.6667;
	points[28] = (1896.7125, 9682.7168, 3548.5159);
	angles[28] = (0, -197.2059, 0);
	at[28] = 6.8000;
	points[29] = (1861.8347, 9621.3779, 3539.8389);
	angles[29] = (0, -204.5227, 0);
	at[29] = 6.9333;
	points[30] = (1823.3622, 9562.1260, 3531.0195);
	angles[30] = (0, -209.5849, 0);
	at[30] = 7.0667;
	points[31] = (1781.4487, 9505.2363, 3522.2007);
	angles[31] = (0, -213.7218, 0);
	at[31] = 7.2000;
	points[32] = (1735.6063, 9451.5352, 3513.5276);
	angles[32] = (0, -217.9322, 0);
	at[32] = 7.3333;
	points[33] = (1684.6732, 9403.3857, 3505.3110);
	angles[33] = (0, -223.4956, 0);
	at[33] = 7.4667;
	points[34] = (1627.1890, 9368.7012, 3498.5710);
	angles[34] = (0, -233.8269, 0);
	at[34] = 7.6000;
	points[35] = (1558.8464, 9349.7637, 3492.9370);
	angles[35] = (0, -246.1601, 0);
	at[35] = 7.7333;
	points[36] = (1488.5709, 9336.4180, 3487.7402);
	angles[36] = (0, -253.8110, 0);
	at[36] = 7.8667;
	points[37] = (1347.9843, 9315.5908, 3478.0039);
	angles[37] = (0, -260.3759, 0);
	at[37] = 8.1333;
	points[38] = (925.3229, 9257.2051, 3450.8623);
	angles[38] = (0, -261.2926, 0);
	at[38] = 8.9333;
	points[39] = (787.5709, 9229.0166, 3442.4529);
	angles[39] = (0, -258.2898, 0);
	at[39] = 9.2000;
	points[40] = (719.4528, 9207.9131, 3438.4058);
	angles[40] = (0, -254.5753, 0);
	at[40] = 9.3333;
	points[41] = (658.2205, 9179.8818, 3435.0078);
	angles[41] = (0, -249.0575, 0);
	at[41] = 9.4667;
	points[42] = (596.0827, 9147.1260, 3431.7993);
	angles[42] = (0, -245.0099, 0);
	at[42] = 9.6000;
	points[43] = (471.9843, 9076.2207, 3425.6655);
	angles[43] = (0, -240.8848, 0);
	at[43] = 9.8667;
	points[44] = (289.5752, 8965.0400, 3416.9055);
	angles[44] = (0, -238.5527, 0);
	at[44] = 10.2667;
	points[45] = (-68.5496, 8732.5986, 3399.6062);
	angles[45] = (0, -236.4028, 0);
	at[45] = 11.0667;
	points[46] = (-243.8744, 8610.5117, 3390.3936);
	angles[46] = (0, -234.8352, 0);
	at[46] = 11.4667;
	points[47] = (-296.9110, 8570.1182, 3387.0789);
	angles[47] = (0, -233.3644, 0);
	at[47] = 11.6000;
	points[48] = (-350.1784, 8523.2676, 3382.7717);
	angles[48] = (0, -230.4124, 0);
	at[48] = 11.7333;
	points[49] = (-450.7244, 8423.1104, 3372.9724);
	angles[49] = (0, -225.6949, 0);
	at[49] = 12;
	points[50] = (-785.7953, 8058.3467, 3338.9490);
	angles[50] = (0, -222.6713, 0);
	at[50] = 12.9333;
	points[51] = (-885.5709, 7956.3779, 3332.1892);
	angles[51] = (0, -224.5068, 0);
	at[51] = 13.2000;
	points[52] = (-934.0276, 7911.7720, 3330.5354);
	angles[52] = (0, -226.2418, 0);
	at[52] = 13.3333;
	points[53] = (-1042.9489, 7815.7485, 3328.2756);
	angles[53] = (0, -228.2712, 0);
	at[53] = 13.6000;
	points[54] = (-1094.8779, 7770.6694, 3327.4763);
	angles[54] = (0, -228.7222, 0);
	at[54] = 13.7333;
	points[55] = (-1150.3347, 7722.7563, 3326.7402);
	angles[55] = (0, -228.9926, 0);
	at[55] = 13.8667;
	points[56] = (-1581.2087, 7352.5596, 3323.7444);
	angles[56] = (0, -229.2874, 0);
	at[56] = 14.9333;
	points[57] = (-1741.2677, 7213.7402, 3323.8701);
	angles[57] = (0, -229, 0);
	at[57] = 15.3333;
	points[58] = (-1901.7521, 7070.7876, 3325.4688);
	angles[58] = (0, -228.0698, 0);
	at[58] = 15.7333;
	points[59] = (-1947.7914, 7027.5986, 3326.6892);
	angles[59] = (0, -227.2723, 0);
	at[59] = 15.8667;
	points[60] = (-2001.4094, 6975.7085, 3328.6536);
	angles[60] = (0, -226.4722, 0);
	at[60] = 16;
	points[61] = (-2050.1931, 6927.7954, 3330.7009);
	angles[61] = (0, -225.9105, 0);
	at[61] = 16.1333;
	points[62] = (-2102.6338, 6875.8662, 3333.0710);
	angles[62] = (0, -225.5359, 0);
	at[62] = 16.2667;
	points[63] = (-2151.4685, 6827.2441, 3335.3860);
	angles[63] = (0, -225.2903, 0);
	at[63] = 16.4000;
	points[64] = (-2603.1497, 6373.5039, 3359.3896);
	angles[64] = (0, -224.8569, 0);
	at[64] = 17.6000;
	points[65] = (-2907.2676, 6072.0083, 3377.0789);
	angles[65] = (0, -225.6462, 0);
	at[65] = 18.4000;
	points[66] = (-2960.2402, 6021.8506, 3380.3188);
	angles[66] = (0, -226.2628, 0);
	at[66] = 18.5333;
	points[67] = (-3009.9802, 5979.0161, 3383.6064);
	angles[67] = (0, -228.2709, 0);
	at[67] = 18.6667;
	points[68] = (-3067.3582, 5938.5435, 3388.4094);
	angles[68] = (0, -232.4730, 0);
	at[68] = 18.8000;
	points[69] = (-3129.7441, 5905.8267, 3394.8938);
	angles[69] = (0, -238.7301, 0);
	at[69] = 18.9333;
	points[70] = (-3196.5986, 5884.0552, 3402.9841);
	angles[70] = (0, -247.0325, 0);
	at[70] = 19.0667;
	points[71] = (-3266.2441, 5874.8423, 3411.6890);
	angles[71] = (0, -256.4911, 0);
	at[71] = 19.2000;
	points[72] = (-3335.4172, 5876.8506, 3418.8701);
	angles[72] = (0, -265.8717, 0);
	at[72] = 19.3333;
	points[73] = (-3405.8347, 5887.7559, 3426.0356);
	angles[73] = (0, -273.4954, 0);
	at[73] = 19.4667;
	points[74] = (-3543.5198, 5920.2358, 3439.6182);
	angles[74] = (0, -282.2604, 0);
	at[74] = 19.7333;
	points[75] = (-3610.8779, 5943.3862, 3445.7361);
	angles[75] = (0, -286.5197, 0);
	at[75] = 19.8667;
	points[76] = (-3670.7678, 5979.4492, 3449.8110);
	angles[76] = (0, -297.0117, 0);
	at[76] = 20;
	points[77] = (-3691.9370, 6045.5903, 3446.3821);
	angles[77] = (0, -323.5119, 0);
	at[77] = 20.1333;
	points[78] = (-3699.6929, 6115.7090, 3440.9805);
	angles[78] = (0, -340.8102, 0);
	at[78] = 20.2667;
	points[79] = (-3703.0630, 6186.7715, 3435.0195);
	angles[79] = (0, -350.3403, 0);
	at[79] = 20.4000;
	points[80] = (-3703.6418, 6257.7168, 3428.7993);
	angles[80] = (0, -355.7125, 0);
	at[80] = 20.5333;
	points[81] = (-3696.3779, 6399.7637, 3415.8899);
	angles[81] = (0, -362.4357, 0);
	at[81] = 20.8000;
	points[82] = (-3684.2954, 6467.7563, 3409.2048);
	angles[82] = (0, -367.0453, 0);
	at[82] = 20.9333;
	points[83] = (-3666.5000, 6535.7876, 3401.7876);
	angles[83] = (0, -371.8861, 0);
	at[83] = 21.0667;
	points[84] = (-3639.0396, 6600.7090, 3394.5747);
	angles[84] = (0, -378.8872, 0);
	at[84] = 21.2000;
	points[85] = (-3600.0435, 6659.5273, 3388.1655);
	angles[85] = (0, -388.0521, 0);
	at[85] = 21.3333;
	points[86] = (-3550.1890, 6709.0156, 3383.0669);
	angles[86] = (0, -398.6523, 0);
	at[86] = 21.4667;
	points[87] = (-3493.9727, 6747.0078, 3379.2913);
	angles[87] = (0, -409.0059, 0);
	at[87] = 21.6000;
	points[88] = (-3432.8896, 6781.8506, 3375.6418);
	angles[88] = (0, -415.5812, 0);
	at[88] = 21.7333;
	points[89] = (-3306.6104, 6849.4883, 3368.4568);
	angles[89] = (0, -420.8184, 0);
	at[89] = 22;
	points[90] = (-2740.0828, 7146.1812, 3339.0432);
	angles[90] = (0, -421.8498, 0);
	at[90] = 23.2000;
	points[91] = (-2552.8936, 7251.7324, 3330.6416);
	angles[91] = (0, -420.2502, 0);
	at[91] = 23.6000;
	points[92] = (-2494.8386, 7287.1650, 3328.3582);
	angles[92] = (0, -419.1984, 0);
	at[92] = 23.7333;
	points[93] = (-2433.1968, 7327.9922, 3326.3032);
	angles[93] = (0, -417.3804, 0);
	at[93] = 23.8667;
	points[94] = (-2383.0630, 7366.4961, 3325.2129);
	angles[94] = (0, -414.2811, 0);
	at[94] = 24;
	points[95] = (-2326.9883, 7414.8032, 3324.5513);
	angles[95] = (0, -411.2599, 0);
	at[95] = 24.1333;
	points[96] = (-2172.5552, 7559.4097, 3324.0276);
	angles[96] = (0, -406.8224, 0);
	at[96] = 24.5333;
	points[97] = (-1969.4607, 7760.0391, 3324.6890);
	angles[97] = (0, -405.1691, 0);
	at[97] = 25.0667;
	points[98] = (-1567.9135, 8164.6851, 3328.3542);
	angles[98] = (0, -404.9128, 0);
	at[98] = 26.1333;
	points[99] = (-1519.3938, 8212.8350, 3328.9919);
	angles[99] = (0, -405.1136, 0);
	at[99] = 26.2667;
	points[100] = (-1466.1969, 8264.8818, 3329.7598);
	angles[100] = (0, -405.4474, 0);
	at[100] = 26.4000;
	points[101] = (-1363.8110, 8360.1182, 3331.5710);
	angles[101] = (0, -407.2420, 0);
	at[101] = 26.6667;
	points[102] = (-1310.9764, 8402.5596, 3332.9409);
	angles[102] = (0, -409.7418, 0);
	at[102] = 26.8000;
	points[103] = (-1194.7914, 8484.2129, 3336.9370);
	angles[103] = (0, -414.3870, 0);
	at[103] = 27.0667;
	points[104] = (-955.1968, 8636.8896, 3347.0945);
	angles[104] = (0, -417.6982, 0);
	at[104] = 27.6000;
	points[105] = (-716.6339, 8790.8662, 3358.8662);
	angles[105] = (0, -416.5355, 0);
	at[105] = 28.1333;
	points[106] = (-602.0355, 8875.6699, 3365.3269);
	angles[106] = (0, -413.3714, 0);
	at[106] = 28.4000;
	points[107] = (-571.4764, 8902.2441, 3367.2520);
	angles[107] = (0, -411.4241, 0);
	at[107] = 28.4833;
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
