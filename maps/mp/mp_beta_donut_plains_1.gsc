main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_beta_donut_plains_1", 0);

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
	ambientPlay("iz_0_sfcdp1", 2);
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
	level.iz_route[level.iz_route.size] = (-3, 35, 303);
	level.iz_route[level.iz_route.size] = (54, -842, 309);
	level.iz_route[level.iz_route.size] = (102, -1775, 321);
	level.iz_route[level.iz_route.size] = (129, -2349, 325);
	level.iz_route[level.iz_route.size] = (61, -2728, 327);
	level.iz_route[level.iz_route.size] = (-146, -3108, 330);
	level.iz_route[level.iz_route.size] = (-567, -3660, 329);
	level.iz_route[level.iz_route.size] = (-1109, -4140, 316);
	level.iz_route[level.iz_route.size] = (-1497, -4359, 308);
	level.iz_route[level.iz_route.size] = (-2010, -4544, 303);
	level.iz_route[level.iz_route.size] = (-2588, -4653, 302);
	level.iz_route[level.iz_route.size] = (-3184, -4682, 302);
	level.iz_route[level.iz_route.size] = (-4255, -4691, 302);
	level.iz_route[level.iz_route.size] = (-5238, -4697, 302);
	level.iz_route[level.iz_route.size] = (-6235, -4775, 302);
	level.iz_route[level.iz_route.size] = (-6857, -4804, 302);
	level.iz_route[level.iz_route.size] = (-7559, -4483, 302);
	level.iz_route[level.iz_route.size] = (-7915, -4113, 301);
	level.iz_route[level.iz_route.size] = (-8107, -3709, 299);
	level.iz_route[level.iz_route.size] = (-8164, -3343, 298);
	level.iz_route[level.iz_route.size] = (-8054, -2827, 294);
	level.iz_route[level.iz_route.size] = (-7807, -2315, 286);
	level.iz_route[level.iz_route.size] = (-7464, -1636, 255);
	level.iz_route[level.iz_route.size] = (-7155, -1178, 248);
	level.iz_route[level.iz_route.size] = (-6976, -820, 253);
	level.iz_route[level.iz_route.size] = (-6986, -472, 256);
	level.iz_route[level.iz_route.size] = (-7162, -6, 262);
	level.iz_route[level.iz_route.size] = (-7736, 760, 272);
	level.iz_route[level.iz_route.size] = (-8246, 1425, 288);
	level.iz_route[level.iz_route.size] = (-8277, 2169, 306);
	level.iz_route[level.iz_route.size] = (-8105, 3012, 322);
	level.iz_route[level.iz_route.size] = (-7770, 3208, 322);
	level.iz_route[level.iz_route.size] = (-7542, 3281, 323);
	level.iz_route[level.iz_route.size] = (-7025, 3378, 327);
	level.iz_route[level.iz_route.size] = (-6309, 3322, 327);
	level.iz_route[level.iz_route.size] = (-5634, 3458, 325);
	level.iz_route[level.iz_route.size] = (-4927, 3573, 317);
	level.iz_route[level.iz_route.size] = (-3940, 3731, 306);
	level.iz_route[level.iz_route.size] = (-2765, 3828, 302);
	level.iz_route[level.iz_route.size] = (-1874, 3501, 302);
	level.iz_route[level.iz_route.size] = (-1063, 3097, 302);
	level.iz_route[level.iz_route.size] = (-482, 2635, 302);
	level.iz_route[level.iz_route.size] = (-143, 1932, 302);
	level.iz_route[level.iz_route.size] = (-17, 982, 302);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-7654.8037, 3436.3938, 151.8114);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-7657.2046, 3362.7361, 149.4138);
	angles[1] = (0, 0, 0);
	at[1] = 0.1667;
	points[2] = (-7655.0786, 3325.2756, 148.1795);
	angles[2] = (0, 0, 0);
	at[2] = 0.2500;
	points[3] = (-7646.1025, 3290.8228, 147.0098);
	angles[3] = (0, 0, 0);
	at[3] = 0.3333;
	points[4] = (-7632.8345, 3255.9097, 145.8031);
	angles[4] = (0, 0, 0);
	at[4] = 0.4167;
	points[5] = (-7586.4565, 3155.0549, 142.2846);
	angles[5] = (0, 0, 0);
	at[5] = 0.6667;
	points[6] = (-7551.4570, 3089.9253, 140.0063);
	angles[6] = (0, 0, 0);
	at[6] = 0.8333;
	points[7] = (-7509.6455, 3030.1733, 137.8709);
	angles[7] = (0, 0, 0);
	at[7] = 1;
	points[8] = (-7462.9922, 2972.5042, 135.7760);
	angles[8] = (0, 0, 0);
	at[8] = 1.1667;
	points[9] = (-7387.2832, 2891.2600, 132.9673);
	angles[9] = (0, 0, 0);
	at[9] = 1.4167;
	points[10] = (-7329.8818, 2846.5984, 131.7728);
	angles[10] = (0, 0, 0);
	at[10] = 1.5833;
	points[11] = (-7141.0239, 2729.7637, 129.5843);
	angles[11] = (0, 0, 0);
	at[11] = 2.0833;
	points[12] = (-7042.9136, 2677.1023, 128.7681);
	angles[12] = (0, 0, 0);
	at[12] = 2.3333;
	points[13] = (-6975.1968, 2647.3032, 128.4279);
	angles[13] = (0, 0, 0);
	at[13] = 2.5000;
	points[14] = (-6951.0239, 2639.7717, 305.5744);
	angles[14] = (0, 0, 0);
	at[14] = 2.5833;
	points[15] = (-6951.0239, 2639.7717, 305.5744);
	angles[15] = (0, 0, 0);
	at[15] = 4.1667;
	points[16] = (-6951.0239, 2639.7717, 342.3658);
	angles[16] = (0, 0, 0);
	at[16] = 4.2500;
	points[17] = (-6951.0239, 2639.7717, 420.3937);
	angles[17] = (0, 0, 0);
	at[17] = 4.3333;
	points[18] = (-6951.0239, 2639.7717, 478.4882);
	angles[18] = (0, 0, 0);
	at[18] = 4.4167;
	points[19] = (-6951.0239, 2639.7717, 516.6536);
	angles[19] = (0, 0, 0);
	at[19] = 4.5000;
	points[20] = (-6951.0239, 2639.7717, 534.8858);
	angles[20] = (0, 0, 0);
	at[20] = 4.5833;
	points[21] = (-6951.0239, 2639.7717, 533.1890);
	angles[21] = (0, 0, 0);
	at[21] = 4.6667;
	points[22] = (-6951.0239, 2639.7717, 511.5591);
	angles[22] = (0, 0, 0);
	at[22] = 4.7500;
	points[23] = (-6951.0239, 2639.7717, 470);
	angles[23] = (0, 0, 0);
	at[23] = 4.8333;
	points[24] = (-6951.0239, 2639.7717, 408.5079);
	angles[24] = (0, 0, 0);
	at[24] = 4.9167;
	points[25] = (-6951.0239, 2639.7717, 327.0850);
	angles[25] = (0, 0, 0);
	at[25] = 5;
	points[26] = (-6931.0239, 2635.7993, 128.4744);
	angles[26] = (0, 0, 0);
	at[26] = 5.0833;
	points[27] = (-6819.6851, 2625.3896, 129.2976);
	angles[27] = (0, 0, 0);
	at[27] = 5.3333;
	points[28] = (-6671.5356, 2621.4133, 130.7331);
	angles[28] = (0, 0, 0);
	at[28] = 5.6667;
	points[29] = (-6523.0312, 2624.3782, 132.3260);
	angles[29] = (0, 0, 0);
	at[29] = 6;
	points[30] = (-6413.0708, 2635.3425, 133.5905);
	angles[30] = (0, 0, 0);
	at[30] = 6.2500;
	points[31] = (-6378.8193, 2646.3149, 134.0382);
	angles[31] = (0, 0, 0);
	at[31] = 6.3333;
	points[32] = (-6312.7954, 2678.7441, 135.0150);
	angles[32] = (0, 0, 0);
	at[32] = 6.5000;
	points[33] = (-6187.4805, 2757.4565, 137.0504);
	angles[33] = (0, 0, 0);
	at[33] = 6.8333;
	points[34] = (-6097.5596, 2823.5159, 138.6256);
	angles[34] = (0, 0, 0);
	at[34] = 7.0833;
	points[35] = (-6069.4878, 2847.1023, 139.1595);
	angles[35] = (0, 0, 0);
	at[35] = 7.1667;
	points[36] = (-6045.4722, 2873.4961, 139.7020);
	angles[36] = (0, 0, 0);
	at[36] = 7.2500;
	points[37] = (-5984.3706, 2966.2480, 141.4205);
	angles[37] = (0, 0, 0);
	at[37] = 7.5000;
	points[38] = (-5948.6221, 3030.9688, 142.5693);
	angles[38] = (0, 0, 0);
	at[38] = 7.6667;
	points[39] = (-5916.2207, 3097.9448, 143.7362);
	angles[39] = (0, 0, 0);
	at[39] = 7.8333;
	points[40] = (-5904.1733, 3131.4568, 144.3024);
	angles[40] = (0, 0, 0);
	at[40] = 7.9167;
	points[41] = (-5884.4097, 3202.9016, 145.4693);
	angles[41] = (0, 0, 0);
	at[41] = 8.0833;
	points[42] = (-5845.6304, 3384.0354, 148.4291);
	angles[42] = (0, 0, 0);
	at[42] = 8.5000;
	points[43] = (-5839.2520, 3456.6733, 149.7169);
	angles[43] = (0, 0, 0);
	at[43] = 8.6667;
	points[44] = (-5837.1655, 3530.7205, 151.0705);
	angles[44] = (0, 0, 0);
	at[44] = 8.8333;
	points[45] = (-5839.9609, 3678.4883, 153.8461);
	angles[45] = (0, 0, 0);
	at[45] = 9.1667;
	points[46] = (-5854.6064, 3750.2598, 155.3441);
	angles[46] = (0, 0, 0);
	at[46] = 9.3333;
	points[47] = (-5877.7954, 3820.6575, 156.9110);
	angles[47] = (0, 0, 0);
	at[47] = 9.5000;
	points[48] = (-5906.2993, 3889.0513, 158.5232);
	angles[48] = (0, 0, 0);
	at[48] = 9.6667;
	points[49] = (-5924.1343, 3919.9214, 159.3358);
	angles[49] = (0, 0, 0);
	at[49] = 9.7500;
	points[50] = (-5971.4175, 3977.4409, 161.1201);
	angles[50] = (0, 0, 0);
	at[50] = 9.9167;
	points[51] = (-6021.7720, 4031.6536, 162.8980);
	angles[51] = (0, 0, 0);
	at[51] = 10.0833;
	points[52] = (-6075.2363, 4083.1497, 164.6559);
	angles[52] = (0, 0, 0);
	at[52] = 10.2500;
	points[53] = (-6103.9370, 4106.5747, 165.5032);
	angles[53] = (0, 0, 0);
	at[53] = 10.3333;
	points[54] = (-6135.5117, 4122.8740, 166.2165);
	angles[54] = (0, 0, 0);
	at[54] = 10.4167;
	points[55] = (-6172.2837, 4127.0078, 166.7362);
	angles[55] = (0, 0, 0);
	at[55] = 10.5000;
	points[56] = (-6246.3784, 4123.8979, 167.5256);
	angles[56] = (0, 0, 0);
	at[56] = 10.6667;
	points[57] = (-6356.7720, 4112.1655, 168.4028);
	angles[57] = (0, 0, 0);
	at[57] = 10.9167;
	points[58] = (-6386.1416, 4109.3701, 345.7374);
	angles[58] = (0, 0, 0);
	at[58] = 11;
	points[59] = (-6386.1416, 4109.3701, 345.7374);
	angles[59] = (0, 0, 0);
	at[59] = 12.5833;
	points[60] = (-6386.1416, 4109.3701, 364.5315);
	angles[60] = (0, 0, 0);
	at[60] = 12.6667;
	points[61] = (-6386.1416, 4109.3701, 446.5433);
	angles[61] = (0, 0, 0);
	at[61] = 12.7500;
	points[62] = (-6386.1416, 4109.3701, 508.6260);
	angles[62] = (0, 0, 0);
	at[62] = 12.8333;
	points[63] = (-6386.1416, 4109.3701, 550.7756);
	angles[63] = (0, 0, 0);
	at[63] = 12.9167;
	points[64] = (-6386.1416, 4109.3701, 572.9961);
	angles[64] = (0, 0, 0);
	at[64] = 13;
	points[65] = (-6386.1416, 4109.3701, 575.2834);
	angles[65] = (0, 0, 0);
	at[65] = 13.0833;
	points[66] = (-6386.1416, 4109.3701, 557.6417);
	angles[66] = (0, 0, 0);
	at[66] = 13.1667;
	points[67] = (-6386.1416, 4109.3701, 520.0669);
	angles[67] = (0, 0, 0);
	at[67] = 13.2500;
	points[68] = (-6386.1416, 4109.3701, 462.5630);
	angles[68] = (0, 0, 0);
	at[68] = 13.3333;
	points[69] = (-6386.1416, 4109.3701, 385.1272);
	angles[69] = (0, 0, 0);
	at[69] = 13.4167;
	points[70] = (-6398.9375, 4108.3857, 168.6307);
	angles[70] = (0, 0, 0);
	at[70] = 13.5000;
	points[71] = (-6768.8188, 4077.2046, 169.5740);
	angles[71] = (0, 0, 0);
	at[71] = 14.3333;
	points[72] = (-6879.8032, 4064.1338, 169.6878);
	angles[72] = (0, 0, 0);
	at[72] = 14.5833;
	points[73] = (-6914.2129, 4056.2993, 169.5894);
	angles[73] = (0, 0, 0);
	at[73] = 14.6667;
	points[74] = (-7017.7563, 4016.8110, 168.7024);
	angles[74] = (0, 0, 0);
	at[74] = 14.9167;
	points[75] = (-7355.6694, 3868.1694, 164.8201);
	angles[75] = (0, 0, 0);
	at[75] = 15.7500;
	points[76] = (-7456.0234, 3819.5276, 163.5016);
	angles[76] = (0, 0, 0);
	at[76] = 16;
	points[77] = (-7486.6143, 3800.8152, 162.9799);
	angles[77] = (0, 0, 0);
	at[77] = 16.0833;
	points[78] = (-7513.1895, 3775.7402, 162.2571);
	angles[78] = (0, 0, 0);
	at[78] = 16.1667;
	points[79] = (-7537.0469, 3747.1223, 161.4209);
	angles[79] = (0, 0, 0);
	at[79] = 16.2500;
	points[80] = (-7579.3306, 3686.5039, 159.6319);
	angles[80] = (0, 0, 0);
	at[80] = 16.4167;
	points[81] = (-7616.3389, 3622.7285, 157.7260);
	angles[81] = (0, 0, 0);
	at[81] = 16.5833;
	points[82] = (-7632.0474, 3588.8228, 156.6929);
	angles[82] = (0, 0, 0);
	at[82] = 16.6667;
	points[83] = (-7641.1025, 3554.2598, 155.6031);
	angles[83] = (0, 0, 0);
	at[83] = 16.7500;
	points[84] = (-7654.8037, 3436.3938, 151.8114);
	angles[84] = (0, 0, 0);
	at[84] = 17.0167;
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
	points[0] = (-4835.5513, 3892.2009, 142.6295);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-4873.0317, 3779.5591, 141.8992);
	angles[1] = (0, 0, 0);
	at[1] = 0.2667;
	points[2] = (-4896.1025, 3693.5237, 141.2374);
	angles[2] = (0, 0, 0);
	at[2] = 0.4667;
	points[3] = (-4904.2520, 3635.9961, 140.6524);
	angles[3] = (0, 0, 0);
	at[3] = 0.6000;
	points[4] = (-4909.3306, 3547.2402, 139.6098);
	angles[4] = (0, 0, 0);
	at[4] = 0.8000;
	points[5] = (-4906.6533, 3488.4292, 138.8417);
	angles[5] = (0, 0, 0);
	at[5] = 0.9333;
	points[6] = (-4900, 3460.2874, 138.4142);
	angles[6] = (0, 0, 0);
	at[6] = 1;
	points[7] = (-4879.3306, 3404.5354, 137.4740);
	angles[7] = (0, 0, 0);
	at[7] = 1.1333;
	points[8] = (-4842.0474, 3324.0435, 136.0307);
	angles[8] = (0, 0, 0);
	at[8] = 1.3333;
	points[9] = (-4811.8506, 3273.0906, 135.0461);
	angles[9] = (0, 0, 0);
	at[9] = 1.4667;
	points[10] = (-4793.8584, 3249.7598, 134.5516);
	angles[10] = (0, 0, 0);
	at[10] = 1.5333;
	points[11] = (-4772.7163, 3230.8936, 134.0827);
	angles[11] = (0, 0, 0);
	at[11] = 1.6000;
	points[12] = (-4746.8110, 3216.6416, 133.6193);
	angles[12] = (0, 0, 0);
	at[12] = 1.6667;
	points[13] = (-4664.9604, 3181.8071, 132.2811);
	angles[13] = (0, 0, 0);
	at[13] = 1.8667;
	points[14] = (-4581.2207, 3151.3425, 130.9839);
	angles[14] = (0, 0, 0);
	at[14] = 2.0667;
	points[15] = (-4411.3384, 3100.0945, 128.5468);
	angles[15] = (0, 0, 0);
	at[15] = 2.4667;
	points[16] = (-4380.9448, 3093.8228, 305.3409);
	angles[16] = (0, 0, 0);
	at[16] = 2.5333;
	points[17] = (-4380.9448, 3093.8228, 305.3409);
	angles[17] = (0, 0, 0);
	at[17] = 4.2000;
	points[18] = (-4380.9448, 3093.8228, 375.7346);
	angles[18] = (0, 0, 0);
	at[18] = 4.2667;
	points[19] = (-4380.9448, 3093.8228, 433.3740);
	angles[19] = (0, 0, 0);
	at[19] = 4.3333;
	points[20] = (-4380.9448, 3093.8228, 478.2559);
	angles[20] = (0, 0, 0);
	at[20] = 4.4000;
	points[21] = (-4380.9448, 3093.8228, 510.3819);
	angles[21] = (0, 0, 0);
	at[21] = 4.4667;
	points[22] = (-4380.9448, 3093.8228, 529.7520);
	angles[22] = (0, 0, 0);
	at[22] = 4.5333;
	points[23] = (-4380.9448, 3093.8228, 536.3661);
	angles[23] = (0, 0, 0);
	at[23] = 4.6000;
	points[24] = (-4380.9448, 3093.8228, 530.2244);
	angles[24] = (0, 0, 0);
	at[24] = 4.6667;
	points[25] = (-4380.9448, 3093.8228, 511.3268);
	angles[25] = (0, 0, 0);
	at[25] = 4.7333;
	points[26] = (-4380.9448, 3093.8228, 479.6732);
	angles[26] = (0, 0, 0);
	at[26] = 4.8000;
	points[27] = (-4380.9448, 3093.8228, 435.2638);
	angles[27] = (0, 0, 0);
	at[27] = 4.8667;
	points[28] = (-4380.9448, 3093.8228, 378.0968);
	angles[28] = (0, 0, 0);
	at[28] = 4.9333;
	points[29] = (-4380.9448, 3093.8228, 308.1756);
	angles[29] = (0, 0, 0);
	at[29] = 5;
	points[30] = (-4360.5122, 3091.1812, 127.9665);
	angles[30] = (0, 0, 0);
	at[30] = 5.0667;
	points[31] = (-4241.8901, 3085.0549, 127);
	angles[31] = (0, 0, 0);
	at[31] = 5.3333;
	points[32] = (-4093.5039, 3088.2913, 125.9910);
	angles[32] = (0, 0, 0);
	at[32] = 5.6667;
	points[33] = (-4005.0393, 3098.3779, 125.4756);
	angles[33] = (0, 0, 0);
	at[33] = 5.8667;
	points[34] = (-3976.1023, 3105.1221, 125.3358);
	angles[34] = (0, 0, 0);
	at[34] = 5.9333;
	points[35] = (-3951.1025, 3115.4451, 125.2516);
	angles[35] = (0, 0, 0);
	at[35] = 6;
	points[36] = (-3878.4883, 3167.1497, 125.2319);
	angles[36] = (0, 0, 0);
	at[36] = 6.2000;
	points[37] = (-3768.1616, 3266.5239, 125.3961);
	angles[37] = (0, 0, 0);
	at[37] = 6.5333;
	points[38] = (-3686.5276, 3352.6143, 125.5886);
	angles[38] = (0, 0, 0);
	at[38] = 6.8000;
	points[39] = (-3649.9961, 3399.2480, 125.6976);
	angles[39] = (0, 0, 0);
	at[39] = 6.9333;
	points[40] = (-3636.5315, 3423.5906, 125.7512);
	angles[40] = (0, 0, 0);
	at[40] = 7;
	points[41] = (-3623.8503, 3481.6733, 125.8740);
	angles[41] = (0, 0, 0);
	at[41] = 7.1333;
	points[42] = (-3618.5669, 3570.2483, 126.0701);
	angles[42] = (0, 0, 0);
	at[42] = 7.3333;
	points[43] = (-3621.8740, 3688.6455, 126.3626);
	angles[43] = (0, 0, 0);
	at[43] = 7.6000;
	points[44] = (-3631.4688, 3777.2244, 126.6390);
	angles[44] = (0, 0, 0);
	at[44] = 7.8000;
	points[45] = (-3647.0984, 3832.4844, 126.9165);
	angles[45] = (0, 0, 0);
	at[45] = 7.9333;
	points[46] = (-3682.6733, 3914.2520, 127.4177);
	angles[46] = (0, 0, 0);
	at[46] = 8.1333;
	points[47] = (-3724.5906, 3992.4409, 127.9835);
	angles[47] = (0, 0, 0);
	at[47] = 8.3333;
	points[48] = (-3775.2795, 4065.7480, 128.6744);
	angles[48] = (0, 0, 0);
	at[48] = 8.5333;
	points[49] = (-3795.9883, 4086.9685, 128.9669);
	angles[49] = (0, 0, 0);
	at[49] = 8.6000;
	points[50] = (-3818.8425, 4101.6929, 129.3008);
	angles[50] = (0, 0, 0);
	at[50] = 8.6667;
	points[51] = (-3903.3662, 4130.6694, 130.5524);
	angles[51] = (0, 0, 0);
	at[51] = 8.8667;
	points[52] = (-4047.7954, 4164.7241, 132.7008);
	angles[52] = (0, 0, 0);
	at[52] = 9.2000;
	points[53] = (-4222.5986, 4194.7246, 135.3185);
	angles[53] = (0, 0, 0);
	at[53] = 9.6000;
	points[54] = (-4252.4019, 4197.7954, 312.9366);
	angles[54] = (0, 0, 0);
	at[54] = 9.6667;
	points[55] = (-4252.4019, 4197.7954, 312.9366);
	angles[55] = (0, 0, 0);
	at[55] = 11.3333;
	points[56] = (-4252.4019, 4197.7954, 383.3303);
	angles[56] = (0, 0, 0);
	at[56] = 11.4000;
	points[57] = (-4252.4019, 4197.7954, 440.9685);
	angles[57] = (0, 0, 0);
	at[57] = 11.4667;
	points[58] = (-4252.4019, 4197.7954, 485.8504);
	angles[58] = (0, 0, 0);
	at[58] = 11.5333;
	points[59] = (-4252.4019, 4197.7954, 517.9764);
	angles[59] = (0, 0, 0);
	at[59] = 11.6000;
	points[60] = (-4252.4019, 4197.7954, 537.3464);
	angles[60] = (0, 0, 0);
	at[60] = 11.6667;
	points[61] = (-4252.4019, 4197.7954, 543.9606);
	angles[61] = (0, 0, 0);
	at[61] = 11.7333;
	points[62] = (-4252.4019, 4197.7954, 537.8189);
	angles[62] = (0, 0, 0);
	at[62] = 11.8000;
	points[63] = (-4252.4019, 4197.7954, 518.9213);
	angles[63] = (0, 0, 0);
	at[63] = 11.8667;
	points[64] = (-4252.4019, 4197.7954, 487.2677);
	angles[64] = (0, 0, 0);
	at[64] = 11.9333;
	points[65] = (-4252.4019, 4197.7954, 442.8583);
	angles[65] = (0, 0, 0);
	at[65] = 12;
	points[66] = (-4252.4019, 4197.7954, 385.6925);
	angles[66] = (0, 0, 0);
	at[66] = 12.0667;
	points[67] = (-4252.4019, 4197.7954, 315.7713);
	angles[67] = (0, 0, 0);
	at[67] = 12.1333;
	points[68] = (-4272.8345, 4198.4644, 136.0882);
	angles[68] = (0, 0, 0);
	at[68] = 12.2000;
	points[69] = (-4361.9688, 4192.4014, 137.5224);
	angles[69] = (0, 0, 0);
	at[69] = 12.4000;
	points[70] = (-4479.0942, 4175.5903, 139.4244);
	angles[70] = (0, 0, 0);
	at[70] = 12.6667;
	points[71] = (-4565.7480, 4157.7954, 140.8008);
	angles[71] = (0, 0, 0);
	at[71] = 12.8667;
	points[72] = (-4621.3779, 4139.8428, 141.6059);
	angles[72] = (0, 0, 0);
	at[72] = 13;
	points[73] = (-4669.2915, 4105.3545, 142.0807);
	angles[73] = (0, 0, 0);
	at[73] = 13.1333;
	points[74] = (-4752.7559, 4021.1025, 142.6512);
	angles[74] = (0, 0, 0);
	at[74] = 13.4000;
	points[75] = (-4808.0317, 3951.3779, 142.8575);
	angles[75] = (0, 0, 0);
	at[75] = 13.6000;
	points[76] = (-4835.5513, 3892.2009, 142.6295);
	angles[76] = (0, 0, 0);
	at[76] = 13.7500;
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
	points[0] = (-1697.5394, 4131.1812, 302.0839);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-1697.5394, 4131.1812, 302.0839);
	angles[1] = (0, 0, 0);
	at[1] = 0.5833;
	points[2] = (-1697.5394, 4131.1812, 442.5315);
	angles[2] = (0, 0, 0);
	at[2] = 0.7500;
	points[3] = (-1697.5394, 4131.1812, 492.6536);
	angles[3] = (0, 0, 0);
	at[3] = 0.8333;
	points[4] = (-1697.5394, 4131.1812, 522.8465);
	angles[4] = (0, 0, 0);
	at[4] = 0.9167;
	points[5] = (-1697.5394, 4131.1812, 533.1063);
	angles[5] = (0, 0, 0);
	at[5] = 1;
	points[6] = (-1697.5394, 4131.1812, 523.4370);
	angles[6] = (0, 0, 0);
	at[6] = 1.0833;
	points[7] = (-1697.5394, 4131.1812, 493.8347);
	angles[7] = (0, 0, 0);
	at[7] = 1.1667;
	points[8] = (-1697.5394, 4131.1812, 444.3032);
	angles[8] = (0, 0, 0);
	at[8] = 1.2500;
	points[9] = (-1697.5394, 4131.1812, 374.8398);
	angles[9] = (0, 0, 0);
	at[9] = 1.3333;
	points[10] = (-1697.5394, 4131.1812, 124.9185);
	angles[10] = (0, 0, 0);
	at[10] = 1.4167;
	points[11] = (-1731.2166, 4119.2124, 124.9185);
	angles[11] = (0, 0, 0);
	at[11] = 1.5000;
	points[12] = (-1764, 4101.9292, 124.9185);
	angles[12] = (0, 0, 0);
	at[12] = 1.5833;
	points[13] = (-1856.8425, 4040.5117, 124.9185);
	angles[13] = (0, 0, 0);
	at[13] = 1.8333;
	points[14] = (-1943.3898, 3971.4568, 124.9185);
	angles[14] = (0, 0, 0);
	at[14] = 2.0833;
	points[15] = (-1970.7086, 3945.5120, 124.9185);
	angles[15] = (0, 0, 0);
	at[15] = 2.1667;
	points[16] = (-1991.8386, 3916.4688, 124.9189);
	angles[16] = (0, 0, 0);
	at[16] = 2.2500;
	points[17] = (-2006.9803, 3883.2363, 124.9189);
	angles[17] = (0, 0, 0);
	at[17] = 2.3333;
	points[18] = (-2030.7087, 3812.9607, 124.9185);
	angles[18] = (0, 0, 0);
	at[18] = 2.5000;
	points[19] = (-2054.6812, 3704.3503, 124.9185);
	angles[19] = (0, 0, 0);
	at[19] = 2.7500;
	points[20] = (-2055.0984, 3668.4841, 124.9185);
	angles[20] = (0, 0, 0);
	at[20] = 2.8333;
	points[21] = (-2037.2637, 3636.3347, 124.9185);
	angles[21] = (0, 0, 0);
	at[21] = 2.9167;
	points[22] = (-2012.9568, 3608.1970, 124.9189);
	angles[22] = (0, 0, 0);
	at[22] = 3;
	points[23] = (-1959.4921, 3557.0396, 124.9185);
	angles[23] = (0, 0, 0);
	at[23] = 3.1667;
	points[24] = (-1819.2245, 3437.3425, 124.9185);
	angles[24] = (0, 0, 0);
	at[24] = 3.5833;
	points[25] = (-1731.8503, 3368.4961, 124.9189);
	angles[25] = (0, 0, 0);
	at[25] = 3.8333;
	points[26] = (-1520.1929, 3221.0432, 124.9185);
	angles[26] = (0, 0, 0);
	at[26] = 4.4167;
	points[27] = (-1492.5906, 3196.9250, 124.9189);
	angles[27] = (0, 0, 0);
	at[27] = 4.5000;
	points[28] = (-1395.1378, 3085.7795, 124.9185);
	angles[28] = (0, 0, 0);
	at[28] = 4.8333;
	points[29] = (-1341.6772, 3035.0789, 124.9185);
	angles[29] = (0, 0, 0);
	at[29] = 5;
	points[30] = (-1306.3898, 3015.3818, 124.9185);
	angles[30] = (0, 0, 0);
	at[30] = 5.0833;
	points[31] = (-1271.6141, 3001.3701, 124.9189);
	angles[31] = (0, 0, 0);
	at[31] = 5.1667;
	points[32] = (-1167.1102, 2965.3582, 124.9185);
	angles[32] = (0, 0, 0);
	at[32] = 5.4167;
	points[33] = (-1024.4016, 2924.6653, 124.9185);
	angles[33] = (0, 0, 0);
	at[33] = 5.7500;
	points[34] = (-951.5984, 2910.0710, 124.9185);
	angles[34] = (0, 0, 0);
	at[34] = 5.9167;
	points[35] = (-944.8425, 2909.2874, 302.0839);
	angles[35] = (0, 0, 0);
	at[35] = 6;
	points[36] = (-944.8425, 2909.2874, 302.0839);
	angles[36] = (0, 0, 0);
	at[36] = 7.5833;
	points[37] = (-944.8425, 2909.2874, 442.5315);
	angles[37] = (0, 0, 0);
	at[37] = 7.7500;
	points[38] = (-944.8425, 2909.2874, 492.6536);
	angles[38] = (0, 0, 0);
	at[38] = 7.8333;
	points[39] = (-944.8425, 2909.2874, 522.8465);
	angles[39] = (0, 0, 0);
	at[39] = 7.9167;
	points[40] = (-944.8425, 2909.2874, 533.1063);
	angles[40] = (0, 0, 0);
	at[40] = 8;
	points[41] = (-944.8425, 2909.2874, 523.4370);
	angles[41] = (0, 0, 0);
	at[41] = 8.0833;
	points[42] = (-944.8425, 2909.2874, 493.8347);
	angles[42] = (0, 0, 0);
	at[42] = 8.1667;
	points[43] = (-944.8425, 2909.2874, 444.3032);
	angles[43] = (0, 0, 0);
	at[43] = 8.2500;
	points[44] = (-944.8425, 2909.2874, 374.8398);
	angles[44] = (0, 0, 0);
	at[44] = 8.3333;
	points[45] = (-944.8425, 2909.2874, 124.9185);
	angles[45] = (0, 0, 0);
	at[45] = 8.4167;
	points[46] = (-871.7480, 2909.2915, 124.9185);
	angles[46] = (0, 0, 0);
	at[46] = 8.5833;
	points[47] = (-798.3347, 2914.3269, 124.9185);
	angles[47] = (0, 0, 0);
	at[47] = 8.7500;
	points[48] = (-540.1181, 2942.5195, 124.9185);
	angles[48] = (0, 0, 0);
	at[48] = 9.3333;
	points[49] = (-358.7299, 2970.7795, 124.9185);
	angles[49] = (0, 0, 0);
	at[49] = 9.7500;
	points[50] = (-251.0496, 2997.0435, 124.9185);
	angles[50] = (0, 0, 0);
	at[50] = 10;
	points[51] = (-216.3988, 3010.8899, 124.9185);
	angles[51] = (0, 0, 0);
	at[51] = 10.0833;
	points[52] = (-186.8775, 3031.3110, 124.9185);
	angles[52] = (0, 0, 0);
	at[52] = 10.1667;
	points[53] = (-132.3236, 3081.1379, 124.9185);
	angles[53] = (0, 0, 0);
	at[53] = 10.3333;
	points[54] = (-80.8776, 3134.4841, 124.9185);
	angles[54] = (0, 0, 0);
	at[54] = 10.5000;
	points[55] = (-32.6941, 3190.7166, 124.9185);
	angles[55] = (0, 0, 0);
	at[55] = 10.6667;
	points[56] = (8.3364, 3252.3347, 124.9185);
	angles[56] = (0, 0, 0);
	at[56] = 10.8333;
	points[57] = (13.6738, 3287.6221, 124.9185);
	angles[57] = (0, 0, 0);
	at[57] = 10.9167;
	points[58] = (6.0064, 3323.3977, 124.9185);
	angles[58] = (0, 0, 0);
	at[58] = 11;
	points[59] = (-33.6463, 3427.2480, 124.9189);
	angles[59] = (0, 0, 0);
	at[59] = 11.2500;
	points[60] = (-85.6232, 3525.2954, 124.9185);
	angles[60] = (0, 0, 0);
	at[60] = 11.5000;
	points[61] = (-108.0146, 3555.4724, 124.9189);
	angles[61] = (0, 0, 0);
	at[61] = 11.5833;
	points[62] = (-138.4000, 3572.8818, 124.9185);
	angles[62] = (0, 0, 0);
	at[62] = 11.6667;
	points[63] = (-211.1764, 3586.7441, 124.9189);
	angles[63] = (0, 0, 0);
	at[63] = 11.8333;
	points[64] = (-359.2189, 3594.2559, 124.9189);
	angles[64] = (0, 0, 0);
	at[64] = 12.1667;
	points[65] = (-394.7559, 3594.3467, 124.9185);
	angles[65] = (0, 0, 0);
	at[65] = 12.2500;
	points[66] = (-690.3859, 3572.8857, 124.9185);
	angles[66] = (0, 0, 0);
	at[66] = 12.9167;
	points[67] = (-764.3661, 3573.6694, 124.9185);
	angles[67] = (0, 0, 0);
	at[67] = 13.0833;
	points[68] = (-799.8268, 3579.5237, 124.9185);
	angles[68] = (0, 0, 0);
	at[68] = 13.1667;
	points[69] = (-866.2244, 3611.4253, 124.9189);
	angles[69] = (0, 0, 0);
	at[69] = 13.3333;
	points[70] = (-929.1142, 3650.6812, 124.9189);
	angles[70] = (0, 0, 0);
	at[70] = 13.5000;
	points[71] = (-1049.8425, 3736.5120, 124.9185);
	angles[71] = (0, 0, 0);
	at[71] = 13.8333;
	points[72] = (-1136.4291, 3806.4290, 124.9185);
	angles[72] = (0, 0, 0);
	at[72] = 14.0833;
	points[73] = (-1160.0078, 3833.0315, 124.9189);
	angles[73] = (0, 0, 0);
	at[73] = 14.1667;
	points[74] = (-1180.6378, 3863.6455, 124.9189);
	angles[74] = (0, 0, 0);
	at[74] = 14.2500;
	points[75] = (-1276.2599, 4022.5195, 124.9185);
	angles[75] = (0, 0, 0);
	at[75] = 14.6667;
	points[76] = (-1299, 4051.6538, 124.9185);
	angles[76] = (0, 0, 0);
	at[76] = 14.7500;
	points[77] = (-1326.4803, 4073.6614, 124.9185);
	angles[77] = (0, 0, 0);
	at[77] = 14.8333;
	points[78] = (-1396.8977, 4096.3779, 124.9185);
	angles[78] = (0, 0, 0);
	at[78] = 15;
	points[79] = (-1506.1890, 4118.0708, 124.9189);
	angles[79] = (0, 0, 0);
	at[79] = 15.2500;
	points[80] = (-1616.7638, 4131.5356, 124.9185);
	angles[80] = (0, 0, 0);
	at[80] = 15.5000;
	points[81] = (-1690.9921, 4132.1655, 124.9185);
	angles[81] = (0, 0, 0);
	at[81] = 15.6667;
	points[82] = (-1697.5394, 4131.1812, 302.0839);
	angles[82] = (0, 0, 0);
	at[82] = 15.7500;
	points[83] = (-1697.5394, 4131.1812, 302.0839);
	angles[83] = (0, 0, 0);
	at[83] = 16.7500;
	mover = getEnt("iz_obj_2", "targetname");
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
