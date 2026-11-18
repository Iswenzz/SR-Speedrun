main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_snes_vanilla_lake_2", 0);

	setExpFog(1594.4882, 16807.3320, 0.7843, 0.7843, 0.7843, 0);

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
	ambientPlay("iz_0_18", 2);
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
	level.iz_route[level.iz_route.size] = (-5259, -37, 1678);
	level.iz_route[level.iz_route.size] = (-5223, -991, 1678);
	level.iz_route[level.iz_route.size] = (-5051, -2164, 1678);
	level.iz_route[level.iz_route.size] = (-4607, -3327, 1678);
	level.iz_route[level.iz_route.size] = (-4334, -3596, 1678);
	level.iz_route[level.iz_route.size] = (-4020, -3821, 1678);
	level.iz_route[level.iz_route.size] = (-3328, -4378, 1678);
	level.iz_route[level.iz_route.size] = (-2835, -4628, 1678);
	level.iz_route[level.iz_route.size] = (-2280, -4718, 1678);
	level.iz_route[level.iz_route.size] = (-1643, -4691, 1678);
	level.iz_route[level.iz_route.size] = (-1031, -4533, 1678);
	level.iz_route[level.iz_route.size] = (-284, -4256, 1677);
	level.iz_route[level.iz_route.size] = (820, -3976, 1678);
	level.iz_route[level.iz_route.size] = (2380, -3822, 1678);
	level.iz_route[level.iz_route.size] = (3251, -3647, 1678);
	level.iz_route[level.iz_route.size] = (3465, -3535, 1678);
	level.iz_route[level.iz_route.size] = (3615, -3353, 1678);
	level.iz_route[level.iz_route.size] = (3777, -3068, 1678);
	level.iz_route[level.iz_route.size] = (3952, -2532, 1678);
	level.iz_route[level.iz_route.size] = (4112, -1948, 1678);
	level.iz_route[level.iz_route.size] = (4412, -1527, 1678);
	level.iz_route[level.iz_route.size] = (4861, -1038, 1678);
	level.iz_route[level.iz_route.size] = (5158, -664, 1678);
	level.iz_route[level.iz_route.size] = (5297, -134, 1678);
	level.iz_route[level.iz_route.size] = (5273, 1044, 1678);
	level.iz_route[level.iz_route.size] = (5221, 2350, 1678);
	level.iz_route[level.iz_route.size] = (5316, 2887, 1678);
	level.iz_route[level.iz_route.size] = (5511, 3663, 1678);
	level.iz_route[level.iz_route.size] = (5650, 4510, 1678);
	level.iz_route[level.iz_route.size] = (5505, 5078, 1678);
	level.iz_route[level.iz_route.size] = (5161, 5314, 1678);
	level.iz_route[level.iz_route.size] = (4451, 5337, 1678);
	level.iz_route[level.iz_route.size] = (3887, 5089, 1678);
	level.iz_route[level.iz_route.size] = (3274, 4919, 1678);
	level.iz_route[level.iz_route.size] = (2640, 4940, 1678);
	level.iz_route[level.iz_route.size] = (2142, 5097, 1678);
	level.iz_route[level.iz_route.size] = (1580, 5217, 1678);
	level.iz_route[level.iz_route.size] = (1007, 5129, 1678);
	level.iz_route[level.iz_route.size] = (720, 5072, 1678);
	level.iz_route[level.iz_route.size] = (-94, 4722, 1678);
	level.iz_route[level.iz_route.size] = (-523, 4529, 1665);
	level.iz_route[level.iz_route.size] = (-1059, 4395, 1678);
	level.iz_route[level.iz_route.size] = (-1630, 4395, 1678);
	level.iz_route[level.iz_route.size] = (-2720, 4470, 1678);
	level.iz_route[level.iz_route.size] = (-3393, 4335, 1678);
	level.iz_route[level.iz_route.size] = (-3817, 4081, 1678);
	level.iz_route[level.iz_route.size] = (-4536, 3378, 1678);
	level.iz_route[level.iz_route.size] = (-5218, 2617, 1678);
	level.iz_route[level.iz_route.size] = (-5338, 2229, 1678);
	level.iz_route[level.iz_route.size] = (-5345, 1467, 1678);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-4494.4092, -2470.6458, 1678.1575);
	angles[0] = (0, -83.6874, 0);
	at[0] = 0;
	points[1] = (-4445.6694, -2465.1299, 1678.1575);
	angles[1] = (0, -83.4036, 0);
	at[1] = 1.3000;
	points[2] = (-4403.6221, -2460.1062, 1678.1575);
	angles[2] = (0, -82.9718, 0);
	at[2] = 2.6000;
	points[3] = (-4368.3071, -2455.5117, 1678.1575);
	angles[3] = (0, -82.1875, 0);
	at[3] = 3.4667;
	points[4] = (-4342.9922, -2451.6536, 1678.1575);
	angles[4] = (0, -80.3783, 0);
	at[4] = 4.3333;
	points[5] = (-4297.6772, -2440.6182, 1678.1575);
	angles[5] = (0, -72.2414, 0);
	at[5] = 5.6333;
	points[6] = (-4256.5352, -2421.0354, 1678.1575);
	angles[6] = (0, -56.7028, 0);
	at[6] = 6.9333;
	points[7] = (-4234.3701, -2400.3818, 1678.1575);
	angles[7] = (0, -39.1041, 0);
	at[7] = 7.8000;
	points[8] = (-4226.0630, -2387.4607, 1678.1575);
	angles[8] = (0, -29.4109, 0);
	at[8] = 8.2333;
	points[9] = (-4219.7246, -2373.3821, 1678.1575);
	angles[9] = (0, -21.9762, 0);
	at[9] = 8.6667;
	points[10] = (-4214.3701, -2358.9529, 1678.1575);
	angles[10] = (0, -20.7862, 0);
	at[10] = 9.1000;
	points[11] = (-4207.4014, -2345.7046, 1678.1575);
	angles[11] = (0, -32.9849, 0);
	at[11] = 9.5333;
	points[12] = (-4194.5278, -2317.8623, 1678.1575);
	angles[12] = (0, -20.5945, 0);
	at[12] = 10.4000;
	points[13] = (-4181.2993, -2273.5000, 1678.1575);
	angles[13] = (0, -13.8955, 0);
	at[13] = 11.7000;
	points[14] = (-4173.1890, -2227.9331, 1678.1575);
	angles[14] = (0, -5.7661, 0);
	at[14] = 13;
	points[15] = (-4172.9526, -2212.6968, 1678.1575);
	angles[15] = (0, 3.1453, 0);
	at[15] = 13.4333;
	points[16] = (-4181.8506, -2167.8740, 1678.1575);
	angles[16] = (0, 15.5877, 0);
	at[16] = 14.7333;
	points[17] = (-4199.6064, -2125.4133, 1678.1575);
	angles[17] = (0, 29.3236, 0);
	at[17] = 16.0333;
	points[18] = (-4228.8979, -2090.0828, 1678.1575);
	angles[18] = (0, 48.9754, 0);
	at[18] = 17.3333;
	points[19] = (-4252.8740, -2074.2756, 1678.1575);
	angles[19] = (0, 60.5033, 0);
	at[19] = 18.2000;
	points[20] = (-4405.8267, -1998.3977, 1678.1575);
	angles[20] = (0, 64.9895, 0);
	at[20] = 22.9667;
	points[21] = (-4546.6143, -1935.9528, 1678.1575);
	angles[21] = (0, 67.2698, 0);
	at[21] = 27.3000;
	points[22] = (-4661.9292, -1891.6182, 1678.1575);
	angles[22] = (0, 71.2190, 0);
	at[22] = 30.7667;
	points[23] = (-4706.2598, -1878.1891, 1678.1575);
	angles[23] = (0, 75.2071, 0);
	at[23] = 32.0667;
	points[24] = (-4734.5669, -1872.3779, 1678.1575);
	angles[24] = (0, 81.5979, 0);
	at[24] = 32.9333;
	points[25] = (-4780.1182, -1868.9094, 1678.1575);
	angles[25] = (0, 87.7725, 0);
	at[25] = 34.2333;
	points[26] = (-4841.5356, -1868.4174, 1678.1575);
	angles[26] = (0, 90.7204, 0);
	at[26] = 35.9667;
	points[27] = (-5011.0234, -1876.9724, 1678.1575);
	angles[27] = (0, 94.5909, 0);
	at[27] = 40.7333;
	points[28] = (-5164.2520, -1893.8622, 1678.1575);
	angles[28] = (0, 98.2130, 0);
	at[28] = 45.0667;
	points[29] = (-5270.4331, -1914.7560, 1678.1575);
	angles[29] = (0, 105.5822, 0);
	at[29] = 48.1000;
	points[30] = (-5297.5591, -1924.4016, 1678.1575);
	angles[30] = (0, 113.9868, 0);
	at[30] = 48.9667;
	points[31] = (-5324.4487, -1940.2914, 1678.1575);
	angles[31] = (0, 124.0253, 0);
	at[31] = 49.8333;
	points[32] = (-5395, -1999.1732, 1678.1575);
	angles[32] = (0, 133.0928, 0);
	at[32] = 52.4333;
	points[33] = (-5502.2441, -2109.6890, 1678.1575);
	angles[33] = (0, 137.7573, 0);
	at[33] = 56.7667;
	points[34] = (-5612.8345, -2238.1575, 1678.1575);
	angles[34] = (0, 140.7818, 0);
	at[34] = 61.5333;
	points[35] = (-5639.7241, -2274.3032, 1678.1575);
	angles[35] = (0, 147.6860, 0);
	at[35] = 62.8333;
	points[36] = (-5667.2051, -2329.2598, 1678.1575);
	angles[36] = (0, 157.3664, 0);
	at[36] = 64.5667;
	points[37] = (-5690.9839, -2402.4763, 1678.1575);
	angles[37] = (0, 166.5686, 0);
	at[37] = 66.7333;
	points[38] = (-5694.0161, -2417.5945, 1678.1575);
	angles[38] = (0, 169.8231, 0);
	at[38] = 67.1667;
	points[39] = (-5695.6694, -2432.5237, 1678.1575);
	angles[39] = (0, 177.1622, 0);
	at[39] = 67.6000;
	points[40] = (-5693.3462, -2447.3701, 1678.1575);
	angles[40] = (0, 193.7461, 0);
	at[40] = 68.0333;
	points[41] = (-5688.3462, -2461.9568, 1678.1575);
	angles[41] = (0, 200.9464, 0);
	at[41] = 68.4667;
	points[42] = (-5667.5986, -2503.3347, 1678.1575);
	angles[42] = (0, 210.1699, 0);
	at[42] = 69.7667;
	points[43] = (-5641.3384, -2541.4763, 1678.1575);
	angles[43] = (0, 219.2795, 0);
	at[43] = 71.0667;
	points[44] = (-5630.6694, -2552.1025, 1678.1575);
	angles[44] = (0, 230.5916, 0);
	at[44] = 71.5000;
	points[45] = (-5619.8818, -2562.9094, 1678.1575);
	angles[45] = (0, 222.3692, 0);
	at[45] = 71.9333;
	points[46] = (-5606.6533, -2569.6299, 1678.1575);
	angles[46] = (0, 253.8383, 0);
	at[46] = 72.3667;
	points[47] = (-5591.7324, -2571.5315, 1678.1575);
	angles[47] = (0, 265.5607, 0);
	at[47] = 72.8000;
	points[48] = (-5560.9448, -2571.6653, 1678.1575);
	angles[48] = (0, 271.6158, 0);
	at[48] = 73.6667;
	points[49] = (-5515.2754, -2569.1025, 1678.1575);
	angles[49] = (0, 274.0978, 0);
	at[49] = 74.9667;
	points[50] = (-5488.8975, -2567.0198, 1678.1575);
	angles[50] = (0, 274.7302, 0);
	at[50] = 75.8333;
	points[51] = (-5439.2520, -2562.7400, 1678.1575);
	angles[51] = (0, 275.0268, 0);
	at[51] = 77.1333;
	points[52] = (-5396.3779, -2558.9250, 1678.1575);
	angles[52] = (0, 275.1274, 0);
	at[52] = 78.4333;
	points[53] = (-5346.5356, -2554.4136, 1678.1575);
	angles[53] = (0, 275.2021, 0);
	at[53] = 79.7333;
	points[54] = (-5288.2285, -2549.0669, 1678.1575);
	angles[54] = (0, 275.2661, 0);
	at[54] = 81.4667;
	points[55] = (-5224.3306, -2543.1458, 1678.1575);
	angles[55] = (0, 275.3226, 0);
	at[55] = 83.2000;
	points[56] = (-4628.1499, -2484.9331, 1678.1575);
	angles[56] = (0, 275.9216, 0);
	at[56] = 100.1000;
	points[57] = (-4564.2124, -2478.2166, 1678.1575);
	angles[57] = (0, 276.0692, 0);
	at[57] = 101.8330;
	points[58] = (-4494.4092, -2470.6458, 1678.1575);
	angles[58] = (0, 276.3126, 0);
	at[58] = 103.8670;
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
	points[0] = (-4107.0078, -3811.0593, 1678.1575);
	angles[0] = (0, 105.9553, 0);
	at[0] = 0;
	points[1] = (-4156.8506, -3824.6062, 1678.1575);
	angles[1] = (0, 104.4163, 0);
	at[1] = 1.5000;
	points[2] = (-4193.4648, -3833.2126, 1678.1575);
	angles[2] = (0, 101.9692, 0);
	at[2] = 2.5000;
	points[3] = (-4224.8032, -3838.4016, 1678.1575);
	angles[3] = (0, 97.3221, 0);
	at[3] = 3.5000;
	points[4] = (-4278.0317, -3842.5669, 1678.1575);
	angles[4] = (0, 92.6497, 0);
	at[4] = 5;
	points[5] = (-4438.4253, -3841.1575, 1678.1575);
	angles[5] = (0, 87.4944, 0);
	at[5] = 9.5000;
	points[6] = (-4633.0317, -3827.7283, 1678.1575);
	angles[6] = (0, 84.9283, 0);
	at[6] = 15;
	points[7] = (-4775.2363, -3813.2598, 1678.1575);
	angles[7] = (0, 83.4566, 0);
	at[7] = 19;
	points[8] = (-4824.4097, -3807.1536, 1678.1575);
	angles[8] = (0, 82.3508, 0);
	at[8] = 20.5000;
	points[9] = (-5088.9761, -3765.6458, 1678.1575);
	angles[9] = (0, 80.2861, 0);
	at[9] = 28;
	points[10] = (-5315.7480, -3723.5474, 1678.1575);
	angles[10] = (0, 78.4406, 0);
	at[10] = 34.5000;
	points[11] = (-5421.2598, -3699.8701, 1678.1575);
	angles[11] = (0, 75.8559, 0);
	at[11] = 37.5000;
	points[12] = (-5472.4409, -3684.9292, 1678.1575);
	angles[12] = (0, 70.6839, 0);
	at[12] = 39;
	points[13] = (-5486.5747, -3679.0906, 1678.1575);
	angles[13] = (0, 65.4275, 0);
	at[13] = 39.5000;
	points[14] = (-5516.7720, -3660.6812, 1678.1575);
	angles[14] = (0, 54.2075, 0);
	at[14] = 40.5000;
	points[15] = (-5543.9370, -3637.8071, 1678.1575);
	angles[15] = (0, 46.9965, 0);
	at[15] = 41.5000;
	points[16] = (-5580.1182, -3598.6497, 1678.1575);
	angles[16] = (0, 39.6094, 0);
	at[16] = 43;
	points[17] = (-5630.4727, -3525.4451, 1678.1575);
	angles[17] = (0, 30, 0);
	at[17] = 45.5000;
	points[18] = (-5659.8032, -3461.2046, 1678.1575);
	angles[18] = (0, 17.8492, 0);
	at[18] = 47.5000;
	points[19] = (-5665.1182, -3427.5120, 1678.1575);
	angles[19] = (0, 1.9678, 0);
	at[19] = 48.5000;
	points[20] = (-5660.6694, -3355.9370, 1678.1575);
	angles[20] = (0, -7.0304, 0);
	at[20] = 50.5000;
	points[21] = (-5647.6772, -3286.2993, 1678.1575);
	angles[21] = (0, -13.7991, 0);
	at[21] = 52.5000;
	points[22] = (-5631.9292, -3235.3977, 1678.1575);
	angles[22] = (0, -20.3574, 0);
	at[22] = 54;
	points[23] = (-5609.2124, -3187.1655, 1678.1575);
	angles[23] = (0, -29.9348, 0);
	at[23] = 55.5000;
	points[24] = (-5576.7324, -3145.1731, 1678.1575);
	angles[24] = (0, -45.4518, 0);
	at[24] = 57;
	points[25] = (-5548.3462, -3124.3308, 1678.1575);
	angles[25] = (0, -60.6395, 0);
	at[25] = 58;
	points[26] = (-5532.7559, -3117.4133, 1678.1575);
	angles[26] = (0, -69.3311, 0);
	at[26] = 58.5000;
	points[27] = (-5501.1025, -3108.5317, 1678.1575);
	angles[27] = (0, -76.5560, 0);
	at[27] = 59.5000;
	points[28] = (-5480.9053, -3104.1301, 1678.1575);
	angles[28] = (0, -78.2647, 0);
	at[28] = 60;
	points[29] = (-5448.9370, -3098.0435, 1678.1575);
	angles[29] = (0, -79.8219, 0);
	at[29] = 61;
	points[30] = (-5306.1807, -3076.7087, 1678.1575);
	angles[30] = (0, -82.5343, 0);
	at[30] = 65;
	points[31] = (-4988.3857, -3041.7285, 1678.1575);
	angles[31] = (0, -84.5954, 0);
	at[31] = 74;
	points[32] = (-4794.3701, -3025.0198, 1678.1575);
	angles[32] = (0, -85.5636, 0);
	at[32] = 79.5000;
	points[33] = (-4632.5195, -3014.0984, 1678.1575);
	angles[33] = (0, -86.8406, 0);
	at[33] = 84;
	points[34] = (-4581.5747, -3011.6416, 1678.1575);
	angles[34] = (0, -87.6271, 0);
	at[34] = 85.5000;
	points[35] = (-4543.1890, -3010.4133, 1678.1575);
	angles[35] = (0, -88.6901, 0);
	at[35] = 86.5000;
	points[36] = (-4477.7168, -3011.3779, 1678.1575);
	angles[36] = (0, -92.8527, 0);
	at[36] = 88.5000;
	points[37] = (-4318.0317, -3026.5195, 1678.1575);
	angles[37] = (0, -96.9795, 0);
	at[37] = 93;
	points[38] = (-4124.3311, -3054.1299, 1678.1575);
	angles[38] = (0, -99.0203, 0);
	at[38] = 98.5000;
	points[39] = (-3896.1062, -3094.5945, 1678.1575);
	angles[39] = (0, -101.1994, 0);
	at[39] = 105;
	points[40] = (-3758.7166, -3125.9766, 1678.1575);
	angles[40] = (0, -106.2927, 0);
	at[40] = 109;
	points[41] = (-3726.3503, -3137.5708, 1678.1575);
	angles[41] = (0, -112.0825, 0);
	at[41] = 110;
	points[42] = (-3678.1377, -3160.2993, 1678.1575);
	angles[42] = (0, -117.3897, 0);
	at[42] = 111.5000;
	points[43] = (-3586.5276, -3214.6694, 1678.1575);
	angles[43] = (0, -123.2247, 0);
	at[43] = 114.5000;
	points[44] = (-3486.0984, -3288.1418, 1678.1575);
	angles[44] = (0, -129.3528, 0);
	at[44] = 118;
	points[45] = (-3446.7676, -3323.6694, 1678.1575);
	angles[45] = (0, -135.4188, 0);
	at[45] = 119.5000;
	points[46] = (-3434.6733, -3337.4292, 1678.1575);
	angles[46] = (0, -141.4245, 0);
	at[46] = 120;
	points[47] = (-3426.3425, -3351.2915, 1678.1575);
	angles[47] = (0, -153.1868, 0);
	at[47] = 120.5000;
	points[48] = (-3415.1577, -3385.1497, 1678.1575);
	angles[48] = (0, -166.6250, 0);
	at[48] = 121.5000;
	points[49] = (-3409.8032, -3420.2126, 1678.1575);
	angles[49] = (0, -174.6471, 0);
	at[49] = 122.5000;
	points[50] = (-3409.0828, -3455.7834, 1678.1575);
	angles[50] = (0, -182.0948, 0);
	at[50] = 123.5000;
	points[51] = (-3413.2522, -3491.0195, 1678.1575);
	angles[51] = (0, -190.5668, 0);
	at[51] = 124.5000;
	points[52] = (-3423.3386, -3525.0354, 1678.1575);
	angles[52] = (0, -201.5554, 0);
	at[52] = 125.5000;
	points[53] = (-3440.8503, -3555.7283, 1678.1575);
	angles[53] = (0, -216.6483, 0);
	at[53] = 126.5000;
	points[54] = (-3452.7480, -3568.7402, 1678.1575);
	angles[54] = (0, -225.9101, 0);
	at[54] = 127;
	points[55] = (-3466.8149, -3579.6260, 1678.1575);
	angles[55] = (0, -235.9904, 0);
	at[55] = 127.5000;
	points[56] = (-3479.5276, -3586.8860, 1678.1575);
	angles[56] = (0, -241.7879, 0);
	at[56] = 128;
	points[57] = (-3528.2795, -3609.5039, 1678.1575);
	angles[57] = (0, -246.6802, 0);
	at[57] = 129.5000;
	points[58] = (-3645.3506, -3656.0750, 1678.1575);
	angles[58] = (0, -249.2989, 0);
	at[58] = 133;
	points[59] = (-3812.4214, -3716.3782, 1678.1575);
	angles[59] = (0, -250.8447, 0);
	at[59] = 138;
	points[60] = (-3997.5986, -3777.9529, 1678.1575);
	angles[60] = (0, -252.4148, 0);
	at[60] = 143.5000;
	points[61] = (-4107.0078, -3811.0593, 1678.1575);
	angles[61] = (0, -254.0447, 0);
	at[61] = 146.6830;
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
	points[0] = (864.1890, -4465, 1678.3662);
	angles[0] = (0, -29.0604, -0.1256);
	at[0] = 0;
	points[1] = (915.9410, -4363.2280, 1678.1575);
	angles[1] = (0, -24.1192, -0.0450);
	at[1] = 1.6000;
	points[2] = (922.2363, -4347.8740, 1678.1575);
	angles[2] = (0, -21.5260, -0.0024);
	at[2] = 1.8667;
	points[3] = (945.1182, -4274.9604, 1678.1575);
	angles[3] = (0, -15.6647, 0);
	at[3] = 2.9333;
	points[4] = (973.0157, -4164.7241, 1678.1575);
	angles[4] = (0, -13.2700, 0);
	at[4] = 4.5333;
	points[5] = (1001.3583, -4034.8425, 1678.1575);
	angles[5] = (0, -11.4913, 0);
	at[5] = 6.4000;
	points[6] = (1024.5118, -3904.1772, 1678.1575);
	angles[6] = (0, -7.9729, 0);
	at[6] = 8.2667;
	points[7] = (1027.7717, -3868.2759, 1678.1575);
	angles[7] = (0, -2.6557, 0.0096);
	at[7] = 8.8000;
	points[8] = (1026.2323, -3811.1929, 1678.1851);
	angles[8] = (0, 3.5780, 0.0344);
	at[8] = 9.6000;
	points[9] = (1016.0906, -3716.9294, 1678.2441);
	angles[9] = (0, 7.8718, 0.0297);
	at[9] = 10.9333;
	points[10] = (999.7126, -3623.4016, 1678.2599);
	angles[10] = (0, 11.8923, -0.0137);
	at[10] = 12.2667;
	points[11] = (985.1378, -3568.2520, 1678.1969);
	angles[11] = (0, 18.0488, -0.1257);
	at[11] = 13.0667;
	points[12] = (968.7362, -3535.6577, 1677.9882);
	angles[12] = (0, 31.7343, -0.4604);
	at[12] = 13.6000;
	points[13] = (946.2953, -3505.0393, 1677.6143);
	angles[13] = (0, 38.2577, -0.5980);
	at[13] = 14.1333;
	points[14] = (881.4370, -3436.1262, 1676.5748);
	angles[14] = (0, 46.9539, -0.6188);
	at[14] = 15.4667;
	points[15] = (837.7205, -3399.9016, 1676.0157);
	angles[15] = (0, 53.2405, -0.5033);
	at[15] = 16.2667;
	points[16] = (805.5867, -3379.6614, 1675.7599);
	angles[16] = (0, 61.3978, -0.2799);
	at[16] = 16.8000;
	points[17] = (771.7126, -3365.2715, 1675.7047);
	angles[17] = (0, 68.6232, -0.0206);
	at[17] = 17.3333;
	points[18] = (699.8740, -3339.9646, 1675.7599);
	angles[18] = (0, 71.6954, 0.0637);
	at[18] = 18.4000;
	points[19] = (609.5433, -3312.5198, 1675.8898);
	angles[19] = (0, 74.2526, 0.0887);
	at[19] = 19.7333;
	points[20] = (517.3819, -3289.4922, 1676.0433);
	angles[20] = (0, 77.6310, 0.0919);
	at[20] = 21.0667;
	points[21] = (442.9095, -3276.6062, 1676.1576);
	angles[21] = (0, 82.7535, 0.0779);
	at[21] = 22.1333;
	points[22] = (385.6024, -3274.4685, 1676.2126);
	angles[22] = (0, 93.3563, 0.0320);
	at[22] = 22.9333;
	points[23] = (351.2445, -3281.8110, 1676.2166);
	angles[23] = (0, 105.8622, 0.0046);
	at[23] = 23.4667;
	points[24] = (315.4488, -3294.1338, 1676.2205);
	angles[24] = (0, 110.3091, 0.0065);
	at[24] = 24;
	points[25] = (227.4913, -3331.4094, 1676.2244);
	angles[25] = (0, 114.5674, -0.0011);
	at[25] = 25.3333;
	points[26] = (108.6240, -3390.5276, 1676.1969);
	angles[26] = (0, 117.9748, -0.0230);
	at[26] = 27.2000;
	points[27] = (25.8011, -3437.1733, 1676.1377);
	angles[27] = (0, 120.6704, -0.0512);
	at[27] = 28.5333;
	points[28] = (-38.2915, -3477.8386, 1676.0394);
	angles[28] = (0, 124.0126, -0.0931);
	at[28] = 29.6000;
	points[29] = (-83.9965, -3511.7087, 1675.9133);
	angles[29] = (0, 128.9097, -0.1595);
	at[29] = 30.4000;
	points[30] = (-111.8906, -3537.8740, 1675.7677);
	angles[30] = (0, 136.8179, -0.2687);
	at[30] = 30.9333;
	points[31] = (-130.7587, -3566.9097, 1675.5276);
	angles[31] = (0, 152.4845, -0.4577);
	at[31] = 31.4667;
	points[32] = (-145.1197, -3601.9844, 1675.1930);
	angles[32] = (0, 159.9503, -0.5307);
	at[32] = 32;
	points[33] = (-166.6559, -3675.3701, 1674.4370);
	angles[33] = (0, 165.7187, -0.5811);
	at[33] = 33.0667;
	points[34] = (-186.7728, -3768.0747, 1673.4489);
	angles[34] = (0, 169.1374, -0.6081);
	at[34] = 34.4000;
	points[35] = (-205.1236, -3880.2717, 1672.2205);
	angles[35] = (0, 171.9751, -0.6290);
	at[35] = 36;
	points[36] = (-216.1961, -3974.9211, 1671.1575);
	angles[36] = (0, 174.5580, -0.6466);
	at[36] = 37.3333;
	points[37] = (-221.0402, -4069.4094, 1670.0631);
	angles[37] = (0, 180.2231, -0.6806);
	at[37] = 38.6667;
	points[38] = (-220.1209, -4088.7400, 1669.8307);
	angles[38] = (0, 183.9402, -0.6993);
	at[38] = 38.9333;
	points[39] = (-217.3921, -4105.2363, 1669.6180);
	angles[39] = (0, 191.8573, -0.7470);
	at[39] = 39.2000;
	points[40] = (-210.9795, -4123.6611, 1669.3466);
	angles[40] = (0, 201.2047, -0.8050);
	at[40] = 39.4667;
	points[41] = (-193.2193, -4156.8110, 1668.8032);
	angles[41] = (0, 211.2566, -0.8355);
	at[41] = 40;
	points[42] = (-136.0437, -4232.0474, 1667.4410);
	angles[42] = (0, 220.3980, -0.8038);
	at[42] = 41.3333;
	points[43] = (-46.2720, -4330.0396, 1665.7244);
	angles[43] = (0, 223.1496, -0.6585);
	at[43] = 43.2000;
	points[44] = (3.8250, -4386.5747, 1665.0433);
	angles[44] = (0, 218.6009, -0.3258);
	at[44] = 44.2667;
	points[45] = (45.7638, -4448.6616, 1664.9370);
	angles[45] = (0, 212.7697, 0.0043);
	at[45] = 45.3333;
	points[46] = (149.1500, -4607.2051, 1665.3228);
	angles[46] = (0, 214.5322, 0.2106);
	at[46] = 48;
	points[47] = (205.9201, -4683.1499, 1665.8071);
	angles[47] = (0, 219.5236, 0.3838);
	at[47] = 49.3333;
	points[48] = (246.2547, -4723.9370, 1666.3425);
	angles[48] = (0, 230.6628, 0.7041);
	at[48] = 50.1333;
	points[49] = (260.7728, -4732.8740, 1666.6143);
	angles[49] = (0, 241.9095, 1.0030);
	at[49] = 50.4000;
	points[50] = (278.4460, -4739.4092, 1667.0316);
	angles[50] = (0, 251.4605, 1.3257);
	at[50] = 50.6667;
	points[51] = (296.4634, -4744.0947, 1667.5039);
	angles[51] = (0, 256.4052, 1.4826);
	at[51] = 50.9333;
	points[52] = (352.8453, -4753.3071, 1669.0984);
	angles[52] = (0, 262.9400, 1.6490);
	at[52] = 51.7333;
	points[53] = (428.5551, -4759.2129, 1671.3386);
	angles[53] = (0, 267.2820, 1.7072);
	at[53] = 52.8000;
	points[54] = (561.0157, -4757.6377, 1675.2677);
	angles[54] = (0, 273.9807, 1.6630);
	at[54] = 54.6667;
	points[55] = (617.8268, -4750.9453, 1676.8700);
	angles[55] = (0, 279.1876, 1.5482);
	at[55] = 55.4667;
	points[56] = (654.9252, -4742.0078, 1677.8190);
	angles[56] = (0, 287.1138, 1.3147);
	at[56] = 56;
	points[57] = (671.5040, -4734.7246, 1678.1654);
	angles[57] = (0, 296.9174, 0.9738);
	at[57] = 56.2667;
	points[58] = (685.9488, -4724.1338, 1678.3662);
	angles[58] = (0, 308.5674, 0.5659);
	at[58] = 56.5333;
	points[59] = (699.7480, -4710.9053, 1678.4961);
	angles[59] = (0, 315.0477, 0.3366);
	at[59] = 56.8000;
	points[60] = (724.7244, -4682.1260, 1678.6260);
	angles[60] = (0, 320.8478, 0.1334);
	at[60] = 57.3333;
	points[61] = (790.2520, -4589.1733, 1678.6338);
	angles[61] = (0, 327.0983, -0.0635);
	at[61] = 58.9333;
	points[62] = (864.1890, -4465, 1678.3662);
	angles[62] = (0, 330.9396, -0.1256);
	at[62] = 60.9667;
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
	points[0] = (1851.4409, -3899.6575, 1678.1575);
	angles[0] = (0, -4.9255, 0);
	at[0] = 0;
	points[1] = (1875.4843, -3655.1577, 1678.1575);
	angles[1] = (0, -6.6167, 0);
	at[1] = 3.4667;
	points[2] = (1885.7834, -3578.8188, 1678.1575);
	angles[2] = (0, -8.9000, 0);
	at[2] = 4.5500;
	points[3] = (1895.0157, -3533.2244, 1678.1575);
	angles[3] = (0, -14.4187, 0);
	at[3] = 5.2000;
	points[4] = (1912.4961, -3491.6733, 1678.1575);
	angles[4] = (0, -26.1628, 0);
	at[4] = 5.8500;
	points[5] = (1950.7954, -3425.0945, 1678.1575);
	angles[5] = (0, -32.2980, 0);
	at[5] = 6.9333;
	points[6] = (1995.9961, -3362.7837, 1678.1575);
	angles[6] = (0, -39.8901, 0);
	at[6] = 8.0167;
	points[7] = (2018.0354, -3340.9250, 1678.1575);
	angles[7] = (0, -49.6429, 0);
	at[7] = 8.4500;
	points[8] = (2045.2284, -3329.9763, 1678.1575);
	angles[8] = (0, -76.1693, 0);
	at[8] = 8.8833;
	points[9] = (2091.2441, -3324.7795, 1678.1575);
	angles[9] = (0, -86.2939, 0);
	at[9] = 9.5333;
	points[10] = (2183.7874, -3324.1377, 1678.1575);
	angles[10] = (0, -91.3786, 0);
	at[10] = 10.8333;
	points[11] = (2321.5042, -3330.8308, 1678.1575);
	angles[11] = (0, -93.8229, 0);
	at[11] = 12.7833;
	points[12] = (2398.0591, -3338.2085, 1678.1575);
	angles[12] = (0, -97.2178, 0);
	at[12] = 13.8667;
	points[13] = (2458.7559, -3349.5396, 1678.1575);
	angles[13] = (0, -104.1302, 0);
	at[13] = 14.7333;
	points[14] = (2487.4370, -3359.9880, 1678.1575);
	angles[14] = (0, -114.7189, 0);
	at[14] = 15.1667;
	points[15] = (2512.2048, -3376.5039, 1678.1575);
	angles[15] = (0, -126.2272, 0);
	at[15] = 15.6000;
	points[16] = (2571.3188, -3425.9724, 1678.1575);
	angles[16] = (0, -131.6514, 0);
	at[16] = 16.6833;
	points[17] = (2638.6262, -3489.4685, 1678.1575);
	angles[17] = (0, -134.6342, 0);
	at[17] = 17.9833;
	points[18] = (2691.7048, -3545.0510, 1678.1575);
	angles[18] = (0, -138.0079, 0);
	at[18] = 19.0667;
	points[19] = (2721.3308, -3581.3821, 1678.1575);
	angles[19] = (0, -143.6891, 0);
	at[19] = 19.7167;
	points[20] = (2735.9490, -3607.0432, 1678.1575);
	angles[20] = (0, -153.4064, 0);
	at[20] = 20.1500;
	points[21] = (2748.1731, -3635.3936, 1678.1575);
	angles[21] = (0, -157.8298, 0);
	at[21] = 20.5833;
	points[22] = (2773.7715, -3707.7046, 1678.1575);
	angles[22] = (0, -161.9835, 0);
	at[22] = 21.6667;
	points[23] = (2799.9646, -3796.3975, 1678.1575);
	angles[23] = (0, -164.7450, 0);
	at[23] = 22.9667;
	points[24] = (2821.2402, -3886.6025, 1678.1575);
	angles[24] = (0, -169.1703, 0);
	at[24] = 24.2667;
	points[25] = (2825.3110, -3915.3149, 1678.1575);
	angles[25] = (0, -173.3390, 0);
	at[25] = 24.7000;
	points[26] = (2832.3071, -4023.1892, 1678.1575);
	angles[26] = (0, -177.8058, 0);
	at[26] = 26.2167;
	points[27] = (2833.3938, -4131.1812, 1678.1575);
	angles[27] = (0, -181.0040, 0);
	at[27] = 27.7333;
	points[28] = (2826.6733, -4222.7559, 1678.1575);
	angles[28] = (0, -188.6381, 0);
	at[28] = 29.0333;
	points[29] = (2818.9292, -4251.5356, 1678.1575);
	angles[29] = (0, -200.7509, 0);
	at[29] = 29.4667;
	points[30] = (2811.7085, -4265.9844, 1678.1575);
	angles[30] = (0, -207.4438, 0);
	at[30] = 29.6833;
	points[31] = (2795.5159, -4291.9688, 1678.1575);
	angles[31] = (0, -213.4982, 0);
	at[31] = 30.1167;
	points[32] = (2749.1379, -4353.1494, 1678.1575);
	angles[32] = (0, -219.2002, 0);
	at[32] = 31.2000;
	points[33] = (2698.4883, -4411.1416, 1678.1575);
	angles[33] = (0, -222.5862, 0);
	at[33] = 32.2833;
	points[34] = (2632.8110, -4475.4727, 1678.1575);
	angles[34] = (0, -229.4902, 0);
	at[34] = 33.5833;
	points[35] = (2620.0708, -4485.2759, 1678.1575);
	angles[35] = (0, -233.5708, 0);
	at[35] = 33.8000;
	points[36] = (2593.4883, -4497.9922, 1678.1575);
	angles[36] = (0, -249.3734, 0);
	at[36] = 34.2333;
	points[37] = (2548.6182, -4509.5669, 1678.1575);
	angles[37] = (0, -258.1539, 0);
	at[37] = 34.8833;
	points[38] = (2487.7913, -4519.2520, 1678.1575);
	angles[38] = (0, -262.5486, 0);
	at[38] = 35.7500;
	points[39] = (2350.2363, -4530.0791, 1678.1575);
	angles[39] = (0, -268.5611, 0);
	at[39] = 37.7000;
	points[40] = (2242.7126, -4528.8975, 1678.1575);
	angles[40] = (0, -271.9580, 0);
	at[40] = 39.2167;
	points[41] = (2150.2993, -4522.6772, 1678.1575);
	angles[41] = (0, -276.0327, 0);
	at[41] = 40.5167;
	points[42] = (2119.9370, -4518.3467, 1678.1575);
	angles[42] = (0, -279.6655, 0);
	at[42] = 40.9500;
	points[43] = (2091.5354, -4510.1968, 1678.1575);
	angles[43] = (0, -291.4597, 0);
	at[43] = 41.3833;
	points[44] = (2077.5159, -4503.2681, 1678.1575);
	angles[44] = (0, -297.1809, 0);
	at[44] = 41.6000;
	points[45] = (2051.1377, -4487.5591, 1678.1575);
	angles[45] = (0, -302.1137, 0);
	at[45] = 42.0333;
	points[46] = (1964.2874, -4423.5039, 1678.1575);
	angles[46] = (0, -309.4489, 0);
	at[46] = 43.5500;
	points[47] = (1908.5157, -4370.6299, 1678.1575);
	angles[47] = (0, -318.5314, 0);
	at[47] = 44.6333;
	points[48] = (1892.6458, -4345.1968, 1678.1575);
	angles[48] = (0, -334.4041, 0);
	at[48] = 45.0667;
	points[49] = (1882.3503, -4316.1812, 1678.1575);
	angles[49] = (0, -342.3852, 0);
	at[49] = 45.5000;
	points[50] = (1863.8228, -4241.4570, 1678.1575);
	angles[50] = (0, -347.9627, 0);
	at[50] = 46.5833;
	points[51] = (1841.7323, -4104.4883, 1678.1575);
	angles[51] = (0, -354.2847, 0);
	at[51] = 48.5333;
	points[52] = (1841.4685, -4043.9373, 1678.1575);
	angles[52] = (0, -362.0335, 0);
	at[52] = 49.4000;
	points[53] = (1851.4409, -3899.6575, 1678.1575);
	angles[53] = (0, -364.9254, 0);
	at[53] = 51.4333;
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
	points[0] = (4359.1733, -2210.7600, 1678.1575);
	angles[0] = (0, 92.8640, 0);
	at[0] = 0;
	points[1] = (4187.2837, -2214.6062, 1678.1575);
	angles[1] = (0, 88.5667, 0);
	at[1] = 2.4000;
	points[2] = (4153.6221, -2212.5276, 1678.1575);
	angles[2] = (0, 85.1606, 0);
	at[2] = 2.9333;
	points[3] = (4040.1970, -2197.3701, 1678.1575);
	angles[3] = (0, 81.0121, 0);
	at[3] = 4.5333;
	points[4] = (3871.9961, -2167.1338, 1678.1575);
	angles[4] = (0, 78.9277, 0);
	at[4] = 6.9333;
	points[5] = (3704.7205, -2131.5984, 1678.1575);
	angles[5] = (0, 77.0789, 0);
	at[5] = 9.3333;
	points[6] = (3557.9016, -2092.8347, 1678.1575);
	angles[6] = (0, 72.0507, 0);
	at[6] = 11.4667;
	points[7] = (3540.0315, -2086.3149, 1678.1575);
	angles[7] = (0, 68.8585, 0);
	at[7] = 11.7333;
	points[8] = (3524.7322, -2078.6575, 1678.1575);
	angles[8] = (0, 60.9886, 0);
	at[8] = 12;
	points[9] = (3496.4604, -2053.6416, 1678.1575);
	angles[9] = (0, 42.1078, 0);
	at[9] = 12.5333;
	points[10] = (3475.1655, -2022.4844, 1678.1575);
	angles[10] = (0, 30.4858, 0);
	at[10] = 13.0667;
	points[11] = (3451.9448, -1970.6221, 1678.1575);
	angles[11] = (0, 20.4304, 0);
	at[11] = 13.8667;
	points[12] = (3431.2837, -1897.6812, 1678.1575);
	angles[12] = (0, 12.8574, 0);
	at[12] = 14.9333;
	points[13] = (3421.9802, -1842.5552, 1678.1575);
	angles[13] = (0, 5.4316, 0);
	at[13] = 15.7333;
	points[14] = (3421.2085, -1785.5630, 1678.1575);
	angles[14] = (0, -2.1781, 0);
	at[14] = 16.5333;
	points[15] = (3428.1616, -1729.1615, 1678.1575);
	angles[15] = (0, -11.2349, 0);
	at[15] = 17.3333;
	points[16] = (3439.8977, -1693.1497, 1678.1575);
	angles[16] = (0, -23.4242, 0);
	at[16] = 17.8667;
	points[17] = (3449.8584, -1677.1260, 1678.1575);
	angles[17] = (0, -35.4443, 0);
	at[17] = 18.1333;
	points[18] = (3462.6929, -1665.3820, 1678.1575);
	angles[18] = (0, -50.6906, 0);
	at[18] = 18.4000;
	points[19] = (3478.5945, -1654.5079, 1678.1575);
	angles[19] = (0, -56.6052, 0);
	at[19] = 18.6667;
	points[20] = (3561.8032, -1608.5748, 1678.1575);
	angles[20] = (0, -63.2440, 0);
	at[20] = 20;
	points[21] = (3665.1653, -1561.0789, 1678.1575);
	angles[21] = (0, -67.0450, 0);
	at[21] = 21.6000;
	points[22] = (3753.8740, -1527.4172, 1678.1575);
	angles[22] = (0, -71.4039, 0);
	at[22] = 22.9333;
	points[23] = (3808.5039, -1512.0078, 1678.1575);
	angles[23] = (0, -76.9558, 0);
	at[23] = 23.7333;
	points[24] = (3824.6221, -1508.9016, 1678.1575);
	angles[24] = (0, -79.8210, 0);
	at[24] = 24;
	points[25] = (3995.5513, -1490.7362, 1678.1575);
	angles[25] = (0, -85.3168, 0);
	at[25] = 26.4000;
	points[26] = (4298.1104, -1471.1693, 1678.1575);
	angles[26] = (0, -87.0647, 0);
	at[26] = 30.6667;
	points[27] = (4507.4805, -1463.6143, 1678.1575);
	angles[27] = (0, -89.4141, 0);
	at[27] = 33.6000;
	points[28] = (4541.6538, -1463.9214, 1678.1575);
	angles[28] = (0, -91.2436, 0);
	at[28] = 34.1333;
	points[29] = (4636.6929, -1468.5670, 1678.1575);
	angles[29] = (0, -93.7037, 0);
	at[29] = 35.4667;
	points[30] = (4769.0161, -1479.6418, 1678.1575);
	angles[30] = (0, -95.6912, 0);
	at[30] = 37.3333;
	points[31] = (4900.8662, -1495.7638, 1678.1575);
	angles[31] = (0, -98.3406, 0);
	at[31] = 39.2000;
	points[32] = (5011.8506, -1517.5985, 1678.1575);
	angles[32] = (0, -105.1567, 0);
	at[32] = 40.8000;
	points[33] = (5046.0630, -1530.5433, 1678.1575);
	angles[33] = (0, -116.2506, 0);
	at[33] = 41.3333;
	points[34] = (5062.6382, -1540.8110, 1678.1575);
	angles[34] = (0, -123.2030, 0);
	at[34] = 41.6000;
	points[35] = (5092.5200, -1564.2164, 1678.1575);
	angles[35] = (0, -130.1274, 0);
	at[35] = 42.1333;
	points[36] = (5159.9609, -1630.4646, 1678.1575);
	angles[36] = (0, -137.0783, 0);
	at[36] = 43.4667;
	points[37] = (5233.4644, -1717.4449, 1678.1575);
	angles[37] = (0, -142.0386, 0);
	at[37] = 45.0667;
	points[38] = (5287.0078, -1795.3938, 1678.1575);
	angles[38] = (0, -150.2291, 0);
	at[38] = 46.4000;
	points[39] = (5294.7241, -1811.8898, 1678.1575);
	angles[39] = (0, -157.8240, 0);
	at[39] = 46.6667;
	points[40] = (5298.3467, -1830.4449, 1678.1575);
	angles[40] = (0, -172.0940, 0);
	at[40] = 46.9333;
	points[41] = (5298.7012, -1849.0945, 1678.1575);
	angles[41] = (0, -180.5234, 0);
	at[41] = 47.2000;
	points[42] = (5294.4492, -1886.7323, 1678.1575);
	angles[42] = (0, -189.1673, 0);
	at[42] = 47.7333;
	points[43] = (5280.9839, -1941.9921, 1678.1575);
	angles[43] = (0, -196.5476, 0);
	at[43] = 48.5333;
	points[44] = (5261.1416, -1995.1141, 1678.1575);
	angles[44] = (0, -203.5345, 0);
	at[44] = 49.3333;
	points[45] = (5243.3066, -2028.9174, 1678.1575);
	angles[45] = (0, -211.0948, 0);
	at[45] = 49.8667;
	points[46] = (5232.0869, -2044.2401, 1678.1575);
	angles[46] = (0, -218.3097, 0);
	at[46] = 50.1333;
	points[47] = (5219.2520, -2055.8977, 1678.1575);
	angles[47] = (0, -231.5190, 0);
	at[47] = 50.4000;
	points[48] = (5202.8345, -2065.9253, 1678.1575);
	angles[48] = (0, -240.0578, 0);
	at[48] = 50.6667;
	points[49] = (5150.9053, -2089.8386, 1678.1575);
	angles[49] = (0, -247.5607, 0);
	at[49] = 51.4667;
	points[50] = (5061.9688, -2121.7795, 1678.1575);
	angles[50] = (0, -251.9731, 0);
	at[50] = 52.8000;
	points[51] = (4970.9058, -2148.2480, 1678.1575);
	angles[51] = (0, -255.3495, 0);
	at[51] = 54.1333;
	points[52] = (4896.7715, -2164.7756, 1678.1575);
	angles[52] = (0, -259.4846, 0);
	at[52] = 55.2000;
	points[53] = (4862.0869, -2169.9883, 1678.1575);
	angles[53] = (0, -262.4261, 0);
	at[53] = 55.7333;
	points[54] = (4840.9448, -2172.5747, 1678.1575);
	angles[54] = (0, -263.1805, 0);
	at[54] = 56;
	points[55] = (4672.5591, -2189.0510, 1678.1575);
	angles[55] = (0, -265.0645, 0);
	at[55] = 58.4000;
	points[56] = (4359.1733, -2210.7600, 1678.1575);
	angles[56] = (0, -267.1360, 0);
	at[56] = 62.8167;
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
	points[0] = (5386.1416, -885.9449, 1678.1575);
	angles[0] = (0, -90.5312, 0);
	at[0] = 0;
	points[1] = (5466.4570, -885.7599, 1678.1575);
	angles[1] = (0, -89.2303, 0);
	at[1] = 1.1333;
	points[2] = (5568.9370, -880.8032, 1678.1575);
	angles[2] = (0, -84.2889, 0);
	at[2] = 2.5500;
	points[3] = (5604.8428, -874.8701, 1678.1575);
	angles[3] = (0, -78.4880, 0);
	at[3] = 3.1167;
	points[4] = (5663.7397, -859.5670, 1678.1575);
	angles[4] = (0, -73.8321, 0);
	at[4] = 3.9667;
	points[5] = (5778.4644, -821.1457, 1678.1575);
	angles[5] = (0, -69.9306, 0);
	at[5] = 5.6667;
	points[6] = (5909.7241, -768.9330, 1678.1575);
	angles[6] = (0, -66.9031, 0);
	at[6] = 7.6500;
	points[7] = (6019.6851, -718.0237, 1678.1575);
	angles[7] = (0, -63.2793, 0);
	at[7] = 9.3500;
	points[8] = (6089.8428, -677.5551, 1678.1575);
	angles[8] = (0, -55.6874, 0);
	at[8] = 10.4833;
	points[9] = (6116.9688, -651.2480, 1678.1575);
	angles[9] = (0, -38.6560, 0);
	at[9] = 11.0500;
	points[10] = (6137.7163, -616.4410, 1678.1575);
	angles[10] = (0, -27.2280, 0);
	at[10] = 11.6167;
	points[11] = (6160.1968, -560.8071, 1678.1575);
	angles[11] = (0, -18.9771, 0);
	at[11] = 12.4667;
	points[12] = (6176.5747, -502.5394, 1678.1575);
	angles[12] = (0, -13.4416, 0);
	at[12] = 13.3167;
	points[13] = (6187.5195, -443.0512, 1678.1575);
	angles[13] = (0, -8.1760, 0);
	at[13] = 14.1667;
	points[14] = (6192.1260, -383.1744, 1678.1575);
	angles[14] = (0, -1.1483, 0);
	at[14] = 15.0167;
	points[15] = (6189.5278, -342.6106, 1678.1575);
	angles[15] = (0, 7.4649, 0);
	at[15] = 15.5833;
	points[16] = (6178.7402, -306.4988, 1678.1575);
	angles[16] = (0, 21.5996, 0);
	at[16] = 16.1500;
	points[17] = (6151.8506, -250.7205, 1678.1575);
	angles[17] = (0, 27.5545, 0);
	at[17] = 17;
	points[18] = (6091.4570, -146.4382, 1678.1575);
	angles[18] = (0, 31.8776, 0);
	at[18] = 18.7000;
	points[19] = (6035.9053, -62.6780, 1678.1575);
	angles[19] = (0, 34.9875, 0);
	at[19] = 20.1167;
	points[20] = (5987.6772, 2.0370, 1678.1575);
	angles[20] = (0, 38.2010, 0);
	at[20] = 21.2500;
	points[21] = (5935.2754, 62.7677, 1678.1575);
	angles[21] = (0, 43.3163, 0);
	at[21] = 22.3833;
	points[22] = (5891.2998, 103.5291, 1678.1575);
	angles[22] = (0, 50.8262, 0);
	at[22] = 23.2333;
	points[23] = (5857.3618, 125.7311, 1678.1575);
	angles[23] = (0, 61.9432, 0);
	at[23] = 23.8000;
	points[24] = (5822.2051, 138.1618, 1678.1575);
	angles[24] = (0, 74.0187, 0);
	at[24] = 24.3667;
	points[25] = (5801.0630, 143.3063, 1678.1575);
	angles[25] = (0, 77.0084, 0);
	at[25] = 24.6500;
	points[26] = (5702.9922, 159.7177, 1678.1575);
	angles[26] = (0, 82.3676, 0);
	at[26] = 26.0667;
	points[27] = (5521.8896, 177.8713, 1678.1575);
	angles[27] = (0, 85.5056, 0);
	at[27] = 28.6167;
	points[28] = (5240.8271, 193.8421, 1678.1575);
	angles[28] = (0, 87.7455, 0);
	at[28] = 32.5833;
	points[29] = (5038.2285, 198.3449, 1678.1575);
	angles[29] = (0, 90.3303, 0);
	at[29] = 35.4167;
	points[30] = (5020.8267, 198.0315, 1678.1575);
	angles[30] = (0, 91.3062, 0);
	at[30] = 35.7000;
	points[31] = (4900.2363, 189.6102, 1678.1575);
	angles[31] = (0, 95.8002, 0);
	at[31] = 37.4000;
	points[32] = (4760.5117, 169.6658, 1678.1575);
	angles[32] = (0, 100.4393, 0);
	at[32] = 39.3833;
	points[33] = (4701.3389, 156.8965, 1678.1575);
	angles[33] = (0, 103.6493, 0);
	at[33] = 40.2333;
	points[34] = (4643.7798, 139.6563, 1678.1575);
	angles[34] = (0, 109.5563, 0);
	at[34] = 41.0833;
	points[35] = (4607.4805, 123.1512, 1678.1575);
	angles[35] = (0, 118.7478, 0);
	at[35] = 41.6500;
	points[36] = (4590.6694, 110.9323, 1678.1575);
	angles[36] = (0, 129.8341, 0);
	at[36] = 41.9333;
	points[37] = (4580.2754, 96.6236, 1678.1575);
	angles[37] = (0, 149.6099, 0);
	at[37] = 42.2167;
	points[38] = (4573.1890, 76.7543, 1678.1575);
	angles[38] = (0, 163.0605, 0);
	at[38] = 42.5000;
	points[39] = (4565.9058, 37.0613, 1678.1575);
	angles[39] = (0, 172.2383, 0);
	at[39] = 43.0667;
	points[40] = (4560.0786, -63.3933, 1678.1575);
	angles[40] = (0, 179.0328, 0);
	at[40] = 44.4833;
	points[41] = (4562.5195, -204.3878, 1678.1575);
	angles[41] = (0, 182.2049, 0);
	at[41] = 46.4667;
	points[42] = (4574.6851, -444.4173, 1678.1575);
	angles[42] = (0, 183.5478, 0);
	at[42] = 49.8667;
	points[43] = (4587.5986, -584.7284, 1678.1575);
	angles[43] = (0, 187.1529, 0);
	at[43] = 51.8500;
	points[44] = (4597.0078, -644.6693, 1678.1575);
	angles[44] = (0, 190.6789, 0);
	at[44] = 52.7000;
	points[45] = (4606.4961, -683.3425, 1678.1575);
	angles[45] = (0, 196.5532, 0);
	at[45] = 53.2667;
	points[46] = (4614.0156, -702.1181, 1678.1575);
	angles[46] = (0, 204.9237, 0);
	at[46] = 53.5500;
	points[47] = (4624.8818, -718.3583, 1678.1575);
	angles[47] = (0, 215.8928, 0);
	at[47] = 53.8333;
	points[48] = (4666.8506, -761.2795, 1678.1575);
	angles[48] = (0, 228.5581, 0);
	at[48] = 54.6833;
	points[49] = (4731.9292, -808.6536, 1678.1575);
	angles[49] = (0, 238.0021, 0);
	at[49] = 55.8167;
	points[50] = (4785.2754, -836.6299, 1678.1575);
	angles[50] = (0, 245.7742, 0);
	at[50] = 56.6667;
	points[51] = (4842.5195, -855.4252, 1678.1575);
	angles[51] = (0, 257, 0);
	at[51] = 57.5167;
	points[52] = (4900.9844, -863.2402, 1678.1575);
	angles[52] = (0, 264.1895, 0);
	at[52] = 58.3667;
	points[53] = (5061.7319, -874.9174, 1678.1575);
	angles[53] = (0, 266.7404, 0);
	at[53] = 60.6333;
	points[54] = (5386.1416, -885.9449, 1678.1575);
	angles[54] = (0, 269.4688, 0);
	at[54] = 65.2000;
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
	points[0] = (5201.3384, 1280.0748, 1678.1575);
	angles[0] = (0, 89.5426, 0);
	at[0] = 0;
	points[1] = (5068.3071, 1284.4961, 1678.1575);
	angles[1] = (0, 86.2333, 0);
	at[1] = 1.8667;
	points[2] = (5033.8584, 1287.6654, 1678.1575);
	angles[2] = (0, 83.8859, 0);
	at[2] = 2.4000;
	points[3] = (4939.0947, 1300.4016, 1678.1575);
	angles[3] = (0, 81.5686, 0);
	at[3] = 3.7333;
	points[4] = (4677.1260, 1345.0630, 1678.1575);
	angles[4] = (0, 79.3095, 0);
	at[4] = 7.4667;
	points[5] = (4472.5591, 1388.6456, 1678.1575);
	angles[5] = (0, 75.9474, 0);
	at[5] = 10.4000;
	points[6] = (4435.5908, 1398.7362, 1678.1575);
	angles[6] = (0, 73.7642, 0);
	at[6] = 10.9333;
	points[7] = (4402.9526, 1410.1930, 1678.1575);
	angles[7] = (0, 68.3677, 0);
	at[7] = 11.4667;
	points[8] = (4351.1812, 1434.5669, 1678.1575);
	angles[8] = (0, 62.9513, 0);
	at[8] = 12.2667;
	points[9] = (4268.7012, 1481.2834, 1678.1575);
	angles[9] = (0, 58.8098, 0);
	at[9] = 13.6000;
	points[10] = (4173.6221, 1543.8464, 1678.1575);
	angles[10] = (0, 54.6978, 0);
	at[10] = 15.2000;
	points[11] = (4113.1494, 1590.2560, 1678.1575);
	angles[11] = (0, 50.3325, 0);
	at[11] = 16.2667;
	points[12] = (4072.6379, 1628.9922, 1678.1575);
	angles[12] = (0, 41.9153, 0);
	at[12] = 17.0667;
	points[13] = (4060.9451, 1644.9135, 1678.1575);
	angles[13] = (0, 33.2002, 0);
	at[13] = 17.3333;
	points[14] = (4055.1182, 1660.7244, 1678.1575);
	angles[14] = (0, 15.6830, 0);
	at[14] = 17.6000;
	points[15] = (4053.1890, 1679.8109, 1678.1575);
	angles[15] = (0, 3.4057, 0);
	at[15] = 17.8667;
	points[16] = (4053.7007, 1699.0985, 1678.1575);
	angles[16] = (0, -2.7141, 0);
	at[16] = 18.1333;
	points[17] = (4058.5432, 1736.7913, 1678.1575);
	angles[17] = (0, -9.4079, 0);
	at[17] = 18.6667;
	points[18] = (4071.2600, 1791.9252, 1678.1575);
	angles[18] = (0, -15.2055, 0);
	at[18] = 19.4667;
	points[19] = (4095.5513, 1863.7480, 1678.1575);
	angles[19] = (0, -21.3855, 0);
	at[19] = 20.5333;
	points[20] = (4128.2681, 1932.0354, 1678.1575);
	angles[20] = (0, -29.5905, 0);
	at[20] = 21.6000;
	points[21] = (4149.3306, 1963.3859, 1678.1575);
	angles[21] = (0, -37.0650, 0);
	at[21] = 22.1333;
	points[22] = (4175.2759, 1988.8544, 1678.1575);
	angles[22] = (0, -52.6800, 0);
	at[22] = 22.6667;
	points[23] = (4207.9922, 2008.0787, 1678.1575);
	angles[23] = (0, -61.9643, 0);
	at[23] = 23.2000;
	points[24] = (4329.1733, 2061.5669, 1678.1575);
	angles[24] = (0, -68.3445, 0);
	at[24] = 25.0667;
	points[25] = (4472.0474, 2113.4370, 1678.1575);
	angles[25] = (0, -71.4333, 0);
	at[25] = 27.2000;
	points[26] = (4617.5591, 2157.4292, 1678.1575);
	angles[26] = (0, -75.0080, 0);
	at[26] = 29.3333;
	points[27] = (4729.1733, 2181.2756, 1678.1575);
	angles[27] = (0, -81.7746, 0);
	at[27] = 30.9333;
	points[28] = (4781.8110, 2184.7205, 1678.1575);
	angles[28] = (0, -88.7701, 0);
	at[28] = 31.7333;
	points[29] = (4953.8979, 2178.7441, 1678.1575);
	angles[29] = (0, -93.6309, 0);
	at[29] = 34.1333;
	points[30] = (5142.2446, 2162.6377, 1678.1575);
	angles[30] = (0, -95.9632, 0);
	at[30] = 36.8000;
	points[31] = (5330, 2138.3938, 1678.1575);
	angles[31] = (0, -98.8963, 0);
	at[31] = 39.4667;
	points[32] = (5461.4565, 2112.5867, 1678.1575);
	angles[32] = (0, -103.9468, 0);
	at[32] = 41.3333;
	points[33] = (5515.9058, 2095.5078, 1678.1575);
	angles[33] = (0, -111.1812, 0);
	at[33] = 42.1333;
	points[34] = (5545.5122, 2079.3347, 1678.1575);
	angles[34] = (0, -123.4427, 0);
	at[34] = 42.6667;
	points[35] = (5588.7798, 2042.1693, 1678.1575);
	angles[35] = (0, -134.2273, 0);
	at[35] = 43.4667;
	points[36] = (5652.1260, 1970.5552, 1678.1575);
	angles[36] = (0, -141.1109, 0);
	at[36] = 44.8000;
	points[37] = (5708.7012, 1894.7875, 1678.1575);
	angles[37] = (0, -144.7864, 0);
	at[37] = 46.1333;
	points[38] = (5761.2207, 1815.6851, 1678.1575);
	angles[38] = (0, -147.7245, 0);
	at[38] = 47.4667;
	points[39] = (5809.0942, 1734.6497, 1678.1575);
	angles[39] = (0, -150.9859, 0);
	at[39] = 48.8000;
	points[40] = (5843.8188, 1665.7953, 1678.1575);
	angles[40] = (0, -155.5536, 0);
	at[40] = 49.8667;
	points[41] = (5857.5591, 1630.8820, 1678.1575);
	angles[41] = (0, -160.8006, 0);
	at[41] = 50.4000;
	points[42] = (5862.4014, 1612.3308, 1678.1575);
	angles[42] = (0, -167.7688, 0);
	at[42] = 50.6667;
	points[43] = (5862.7949, 1595.7875, 1678.1575);
	angles[43] = (0, -182.7876, 0);
	at[43] = 50.9333;
	points[44] = (5858.1104, 1576.8977, 1678.1575);
	angles[44] = (0, -196.9161, 0);
	at[44] = 51.2000;
	points[45] = (5841.6538, 1542.9607, 1678.1575);
	angles[45] = (0, -209.6871, 0);
	at[45] = 51.7333;
	points[46] = (5797.0474, 1481.6890, 1678.1575);
	angles[46] = (0, -219.6584, 0);
	at[46] = 52.8000;
	points[47] = (5731.9292, 1412.9055, 1678.1575);
	angles[47] = (0, -226.1379, 0);
	at[47] = 54.1333;
	points[48] = (5659.8423, 1351.1614, 1678.1575);
	angles[48] = (0, -232.4187, 0);
	at[48] = 55.4667;
	points[49] = (5612.6772, 1319.3425, 1678.1575);
	angles[49] = (0, -239.3644, 0);
	at[49] = 56.2667;
	points[50] = (5595.8662, 1310.7047, 1678.1575);
	angles[50] = (0, -244.3749, 0);
	at[50] = 56.5333;
	points[51] = (5559.7642, 1299.9685, 1678.1575);
	angles[51] = (0, -257.3375, 0);
	at[51] = 57.0667;
	points[52] = (5542.4409, 1296.7875, 1678.1575);
	angles[52] = (0, -260.1113, 0);
	at[52] = 57.3333;
	points[53] = (5447.7163, 1286.5237, 1678.1575);
	angles[53] = (0, -265.7690, 0);
	at[53] = 58.6667;
	points[54] = (5333.9370, 1281.2008, 1678.1575);
	angles[54] = (0, -268.3854, 0);
	at[54] = 60.2667;
	points[55] = (5201.3384, 1280.0748, 1678.1575);
	angles[55] = (0, -270.4573, 0);
	at[55] = 62.1333;
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
	points[0] = (-723.2008, 3852.0708, 1678.1575);
	angles[0] = (0, -12.7454, 0);
	at[0] = 0;
	points[1] = (-701.2913, 3974.6458, 1678.1575);
	angles[1] = (0, -6.3116, 0);
	at[1] = 1.7333;
	points[2] = (-700.1182, 4002.3623, 1678.1575);
	angles[2] = (0, 0.3200, 0);
	at[2] = 2.1667;
	points[3] = (-706.9528, 4064.3308, 1678.1575);
	angles[3] = (0, 9.0129, 0);
	at[3] = 3.0333;
	points[4] = (-729.5157, 4169.6064, 1678.1575);
	angles[4] = (0, 14.0567, 0);
	at[4] = 4.5500;
	points[5] = (-759.0354, 4272.9922, 1678.1575);
	angles[5] = (0, 17.5294, 0);
	at[5] = 6.0667;
	points[6] = (-790.1812, 4360.1182, 1678.1575);
	angles[6] = (0, 21.9077, 0);
	at[6] = 7.3667;
	points[7] = (-817.4764, 4416.1025, 1678.1575);
	angles[7] = (0, 31.0337, 0);
	at[7] = 8.2333;
	points[8] = (-825.4764, 4426.9688, 1678.1575);
	angles[8] = (0, 38.1774, 0);
	at[8] = 8.4500;
	points[9] = (-848.3465, 4447.2441, 1678.1575);
	angles[9] = (0, 52.3357, 0);
	at[9] = 8.8833;
	points[10] = (-914.7323, 4486.2993, 1678.1575);
	angles[10] = (0, 63.1202, 0);
	at[10] = 9.9667;
	points[11] = (-1013.7205, 4529.1733, 1678.1575);
	angles[11] = (0, 68.9902, 0);
	at[11] = 11.4833;
	points[12] = (-1116.5709, 4562.7559, 1678.1575);
	angles[12] = (0, 75.0333, 0);
	at[12] = 13;
	points[13] = (-1160.1575, 4571.1025, 1678.1575);
	angles[13] = (0, 83.8055, 0);
	at[13] = 13.6500;
	points[14] = (-1190.8898, 4571.8110, 1678.1575);
	angles[14] = (0, 90.4348, 0);
	at[14] = 14.0833;
	points[15] = (-1313.7717, 4560.2363, 1678.1536);
	angles[15] = (0, 98.3870, 0);
	at[15] = 15.8167;
	points[16] = (-1374.3820, 4549.4487, 1678.1536);
	angles[16] = (0, 101.4680, 0);
	at[16] = 16.6833;
	points[17] = (-1434.4685, 4534.6064, 1678.1536);
	angles[17] = (0, 106, 0);
	at[17] = 17.5500;
	points[18] = (-1477.4487, 4519.2915, 1678.1536);
	angles[18] = (0, 112.8832, 0);
	at[18] = 18.2000;
	points[19] = (-1503.4646, 4504.5669, 1678.1536);
	angles[19] = (0, 124.9081, 0);
	at[19] = 18.6333;
	points[20] = (-1526.0828, 4483.7798, 1678.1536);
	angles[20] = (0, 135.1024, 0);
	at[20] = 19.0667;
	points[21] = (-1547.1023, 4460.6694, 1678.1536);
	angles[21] = (0, 138.7282, 0);
	at[21] = 19.5000;
	points[22] = (-1594.9094, 4401.0630, 1678.1536);
	angles[22] = (0, 142.7036, 0);
	at[22] = 20.5833;
	points[23] = (-1657.7284, 4313.1104, 1678.1536);
	angles[23] = (0, 145.8292, 0);
	at[23] = 22.1000;
	points[24] = (-1730.8898, 4195, 1678.1536);
	angles[24] = (0, 151.0413, 0);
	at[24] = 24.0500;
	points[25] = (-1751.4724, 4153.2676, 1678.1536);
	angles[25] = (0, 156.3313, 0);
	at[25] = 24.7000;
	points[26] = (-1760.1182, 4126.5747, 1678.1536);
	angles[26] = (0, 165.3416, 0);
	at[26] = 25.1333;
	points[27] = (-1768.0787, 4080.4724, 1678.1536);
	angles[27] = (0, 172.2410, 0);
	at[27] = 25.7833;
	points[28] = (-1774.0709, 4019.0552, 1678.1536);
	angles[28] = (0, 175.6524, 0);
	at[28] = 26.6500;
	points[29] = (-1779.2205, 3865.1890, 1678.1575);
	angles[29] = (0, 179.9541, 0);
	at[29] = 28.8167;
	points[30] = (-1774.0787, 3742.5117, 1678.1575);
	angles[30] = (0, 186.0261, 0);
	at[30] = 30.5500;
	points[31] = (-1771.6732, 3726.1809, 1678.1575);
	angles[31] = (0, 189.3717, 0);
	at[31] = 30.7667;
	points[32] = (-1761.2638, 3699.0120, 1678.1575);
	angles[32] = (0, 207.8763, 0);
	at[32] = 31.2000;
	points[33] = (-1742.6102, 3674.6379, 1678.1575);
	angles[33] = (0, 221.3338, 0);
	at[33] = 31.6333;
	points[34] = (-1696.1141, 3634.4214, 1678.1575);
	angles[34] = (0, 233.1453, 0);
	at[34] = 32.5000;
	points[35] = (-1645.1104, 3600.1614, 1678.1575);
	angles[35] = (0, 237.6154, 0);
	at[35] = 33.3667;
	points[36] = (-1541.5630, 3535.4727, 1678.1575);
	angles[36] = (0, 238.5131, 0);
	at[36] = 35.1000;
	points[37] = (-1448.3818, 3480.5234, 1678.1575);
	angles[37] = (0, 240.4084, 0);
	at[37] = 36.6167;
	points[38] = (-1367.0040, 3437.0039, 1678.1575);
	angles[38] = (0, 243.3843, 0);
	at[38] = 37.9167;
	points[39] = (-1296.3229, 3406.2048, 1678.1575);
	angles[39] = (0, 250.1509, 0);
	at[39] = 39;
	points[40] = (-1266.7795, 3398.3386, 1678.1575);
	angles[40] = (0, 259.1713, 0);
	at[40] = 39.4333;
	points[41] = (-1236.5552, 3396.4526, 1678.1575);
	angles[41] = (0, 268.5520, 0);
	at[41] = 39.8667;
	points[42] = (-1206.4685, 3396.9766, 1678.1575);
	angles[42] = (0, 271.9079, 0);
	at[42] = 40.3000;
	points[43] = (-1129.7166, 3403.0042, 1678.1575);
	angles[43] = (0, 276.1143, 0);
	at[43] = 41.3833;
	points[44] = (-1038, 3416.2678, 1678.1575);
	angles[44] = (0, 279.9893, 0);
	at[44] = 42.6833;
	points[45] = (-932.8464, 3441.1140, 1678.1575);
	angles[45] = (0, 286.9029, 0);
	at[45] = 44.2000;
	points[46] = (-889.4488, 3457.3230, 1678.1575);
	angles[46] = (0, 293.5105, 0);
	at[46] = 44.8500;
	points[47] = (-862.5354, 3472.3464, 1678.1575);
	angles[47] = (0, 303.1393, 0);
	at[47] = 45.2833;
	points[48] = (-843.4016, 3491.8821, 1678.1575);
	angles[48] = (0, 322.6663, 0);
	at[48] = 45.7167;
	points[49] = (-834.5552, 3506.1970, 1678.1575);
	angles[49] = (0, 329.1350, 0);
	at[49] = 45.9333;
	points[50] = (-814.5630, 3547.9961, 1678.1575);
	angles[50] = (0, 336.6032, 0);
	at[50] = 46.5833;
	points[51] = (-768.9567, 3678.1892, 1678.1575);
	angles[51] = (0, 343.0175, 0);
	at[51] = 48.5333;
	points[52] = (-723.2008, 3852.0708, 1678.1575);
	angles[52] = (0, 347.2546, 0);
	at[52] = 51.0667;
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
	points[0] = (-3035.2246, 3983.0708, 1678.1536);
	angles[0] = (0, -39.0776, 0);
	at[0] = 0;
	points[1] = (-2986.4841, 4041.2993, 1678.1536);
	angles[1] = (0, -41.1627, 0);
	at[1] = 1.0667;
	points[2] = (-2961.8347, 4067.2441, 1678.1536);
	angles[2] = (0, -45.4692, 0);
	at[2] = 1.6000;
	points[3] = (-2918.9136, 4106.3389, 1678.1536);
	angles[3] = (0, -48.4437, 0);
	at[3] = 2.4000;
	points[4] = (-2805.0630, 4205.8271, 1678.1536);
	angles[4] = (0, -48.6184, 0);
	at[4] = 4.5333;
	points[5] = (-2721.0984, 4282.2832, 1678.1536);
	angles[5] = (0, -46.4949, 0);
	at[5] = 6.1333;
	points[6] = (-2667.5356, 4336.9683, 1678.1536);
	angles[6] = (0, -42.0112, 0);
	at[6] = 7.2000;
	points[7] = (-2644.1653, 4366.6538, 1678.1536);
	angles[7] = (0, -34.6794, 0);
	at[7] = 7.7333;
	points[8] = (-2636.0591, 4381.3389, 1678.1536);
	angles[8] = (0, -27.0300, 0);
	at[8] = 8;
	points[9] = (-2622.5159, 4416.7715, 1678.1536);
	angles[9] = (0, -18.4506, 0);
	at[9] = 8.5333;
	points[10] = (-2612.0198, 4453.3462, 1678.1536);
	angles[10] = (0, -14.8415, 0);
	at[10] = 9.0667;
	points[11] = (-2592.0669, 4546.2598, 1678.1536);
	angles[11] = (0, -10.3784, 0);
	at[11] = 10.4000;
	points[12] = (-2575.5117, 4658.7798, 1678.1536);
	angles[12] = (0, -6.6304, 0);
	at[12] = 12;
	points[13] = (-2569.1614, 4753.9370, 1678.1536);
	angles[13] = (0, -0.0480, 0);
	at[13] = 13.3333;
	points[14] = (-2573.1064, 4789.9214, 1678.1536);
	angles[14] = (0, 10.1689, 0);
	at[14] = 13.8667;
	points[15] = (-2587.5396, 4844.6460, 1678.1536);
	angles[15] = (0, 16.9819, 0);
	at[15] = 14.6667;
	points[16] = (-2606.2559, 4898.5830, 1678.1536);
	angles[16] = (0, 20.5133, 0);
	at[16] = 15.4667;
	points[17] = (-2635.7363, 4968.2285, 1678.1536);
	angles[17] = (0, 24.9743, 0);
	at[17] = 16.5333;
	points[18] = (-2662.3740, 5018.8979, 1678.1536);
	angles[18] = (0, 30.1661, 0);
	at[18] = 17.3333;
	points[19] = (-2683.5708, 5050.1968, 1678.1536);
	angles[19] = (0, 37.2851, 0);
	at[19] = 17.8667;
	points[20] = (-2696.5474, 5064.3311, 1678.1536);
	angles[20] = (0, 44.9800, 0);
	at[20] = 18.1333;
	points[21] = (-2710.5513, 5073.9375, 1678.1536);
	angles[21] = (0, 59.6999, 0);
	at[21] = 18.4000;
	points[22] = (-2728.6379, 5081.1812, 1678.1536);
	angles[22] = (0, 70.0187, 0);
	at[22] = 18.6667;
	points[23] = (-2746.5471, 5086.4175, 1678.1536);
	angles[23] = (0, 74.6236, 0);
	at[23] = 18.9333;
	points[24] = (-2821.1299, 5100.2754, 1678.1536);
	angles[24] = (0, 81.9353, 0);
	at[24] = 20;
	points[25] = (-2934.5276, 5110.8271, 1678.1536);
	angles[25] = (0, 86.7195, 0);
	at[25] = 21.6000;
	points[26] = (-3029.4880, 5112.6772, 1678.1536);
	angles[26] = (0, 90.9612, 0);
	at[26] = 22.9333;
	points[27] = (-3067.5120, 5110.8271, 1678.1536);
	angles[27] = (0, 94.1349, 0);
	at[27] = 23.4667;
	points[28] = (-3102.3032, 5106.1816, 1678.1536);
	angles[28] = (0, 99.7748, 0);
	at[28] = 24;
	points[29] = (-3250.4607, 5070.7090, 1678.1536);
	angles[29] = (0, 105.1431, 0);
	at[29] = 26.1333;
	points[30] = (-3432.3545, 5015.5513, 1678.1536);
	angles[30] = (0, 108.6376, 0);
	at[30] = 28.8000;
	points[31] = (-3556.2363, 4967.4014, 1678.1536);
	angles[31] = (0, 114.8246, 0);
	at[31] = 30.6667;
	points[32] = (-3589.9055, 4949.4092, 1678.1536);
	angles[32] = (0, 120.9387, 0);
	at[32] = 31.2000;
	points[33] = (-3603.3860, 4939.7637, 1678.1536);
	angles[33] = (0, 127.5747, 0);
	at[33] = 31.4667;
	points[34] = (-3617.0474, 4927.0474, 1678.1536);
	angles[34] = (0, 134.4002, 0);
	at[34] = 31.7333;
	points[35] = (-3641.7324, 4898.3467, 1678.1536);
	angles[35] = (0, 141.3785, 0);
	at[35] = 32.2667;
	points[36] = (-3715.5750, 4787.6382, 1678.1536);
	angles[36] = (0, 148.9043, 0);
	at[36] = 34.1333;
	points[37] = (-3781.0908, 4672.0474, 1678.1575);
	angles[37] = (0, 151.5125, 0);
	at[37] = 36;
	points[38] = (-3885.5474, 4471.6143, 1678.1575);
	angles[38] = (0, 153.1551, 0);
	at[38] = 39.2000;
	points[39] = (-3934.7085, 4369.1733, 1678.1575);
	angles[39] = (0, 155.6316, 0);
	at[39] = 40.8000;
	points[40] = (-3970.5906, 4281.7720, 1678.1536);
	angles[40] = (0, 159.8725, 0);
	at[40] = 42.1333;
	points[41] = (-3991.2205, 4208.7402, 1678.1536);
	angles[41] = (0, 169.3468, 0);
	at[41] = 43.2000;
	points[42] = (-3992.9919, 4173.1104, 1678.1536);
	angles[42] = (0, 182.8235, 0);
	at[42] = 43.7333;
	points[43] = (-3984.6458, 4115.7876, 1678.1536);
	angles[43] = (0, 190.4028, 0);
	at[43] = 44.5333;
	points[44] = (-3959.1733, 4004.9211, 1678.1536);
	angles[44] = (0, 194.5274, 0);
	at[44] = 46.1333;
	points[45] = (-3927.7283, 3895.7483, 1678.1536);
	angles[45] = (0, 197.4348, 0);
	at[45] = 47.7333;
	points[46] = (-3896.2441, 3805.7402, 1678.1536);
	angles[46] = (0, 201.2162, 0);
	at[46] = 49.0667;
	points[47] = (-3873.2795, 3754.2244, 1678.1536);
	angles[47] = (0, 206.9705, 0);
	at[47] = 49.8667;
	points[48] = (-3863.2322, 3737.1104, 1678.1536);
	angles[48] = (0, 212.0590, 0);
	at[48] = 50.1333;
	points[49] = (-3852.3899, 3724.3152, 1678.1536);
	angles[49] = (0, 224.6700, 0);
	at[49] = 50.4000;
	points[50] = (-3835.9331, 3714.1536, 1678.1536);
	angles[50] = (0, 241.7214, 0);
	at[50] = 50.6667;
	points[51] = (-3818.9016, 3707.7085, 1678.1536);
	angles[51] = (0, 250.9409, 0);
	at[51] = 50.9333;
	points[52] = (-3781.7876, 3699.2639, 1678.1536);
	angles[52] = (0, 259.8995, 0);
	at[52] = 51.4667;
	points[53] = (-3706.2522, 3692.0552, 1678.1536);
	angles[53] = (0, 267.1500, 0);
	at[53] = 52.5333;
	points[54] = (-3611.4646, 3691.4763, 1678.1575);
	angles[54] = (0, 271.3161, 0);
	at[54] = 53.8667;
	points[55] = (-3516.6536, 3696.3503, 1678.1575);
	angles[55] = (0, 274.3297, 0);
	at[55] = 55.2000;
	points[56] = (-3480.3623, 3700.8030, 1678.1575);
	angles[56] = (0, 278.5663, 0);
	at[56] = 55.7333;
	points[57] = (-3405.7717, 3715.3464, 1678.1536);
	angles[57] = (0, 282.5086, 0);
	at[57] = 56.8000;
	points[58] = (-3277.7874, 3750.9766, 1678.1536);
	angles[58] = (0, 288.9402, 0);
	at[58] = 58.6667;
	points[59] = (-3225.3230, 3773.1577, 1678.1536);
	angles[59] = (0, 297.2520, 0);
	at[59] = 59.4667;
	points[60] = (-3195.7993, 3795.2048, 1678.1536);
	angles[60] = (0, 311.7659, 0);
	at[60] = 60;
	points[61] = (-3144.2244, 3850.3230, 1678.1536);
	angles[61] = (0, 318.9912, 0);
	at[61] = 61.0667;
	points[62] = (-3035.2246, 3983.0708, 1678.1536);
	angles[62] = (0, 320.9224, 0);
	at[62] = 63.4833;
	mover = getEnt("iz_obj_8", "targetname");
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
