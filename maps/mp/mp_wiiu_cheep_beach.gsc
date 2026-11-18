main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_wiiu_cheep_beach", 0);

	setExpFog(14814.2422, 28492.3340, 0.2627, 0.8039, 0.6667, 0);

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
	ambientPlay("iz_0_uccb", 2);
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
	level.iz_route[level.iz_route.size] = (-1350, 3180, 11935);
	level.iz_route[level.iz_route.size] = (-1354, 4343, 11951);
	level.iz_route[level.iz_route.size] = (-1361, 6531, 11981);
	level.iz_route[level.iz_route.size] = (-1309, 7374, 11981);
	level.iz_route[level.iz_route.size] = (-1245, 8488, 11981);
	level.iz_route[level.iz_route.size] = (-647, 8968, 11980);
	level.iz_route[level.iz_route.size] = (276, 9101, 11980);
	level.iz_route[level.iz_route.size] = (1849, 9414, 11964);
	level.iz_route[level.iz_route.size] = (3956, 9443, 11950);
	level.iz_route[level.iz_route.size] = (5990, 9540, 11749);
	level.iz_route[level.iz_route.size] = (8008, 9773, 11836);
	level.iz_route[level.iz_route.size] = (10178, 9872, 11838);
	level.iz_route[level.iz_route.size] = (11526, 9329, 11836);
	level.iz_route[level.iz_route.size] = (12542, 8140, 11833);
	level.iz_route[level.iz_route.size] = (13162, 6908, 11838);
	level.iz_route[level.iz_route.size] = (12801, 5679, 11836);
	level.iz_route[level.iz_route.size] = (11988, 4427, 11836);
	level.iz_route[level.iz_route.size] = (10647, 2876, 11661);
	level.iz_route[level.iz_route.size] = (9830, 1875, 11760);
	level.iz_route[level.iz_route.size] = (8697, 511, 11800);
	level.iz_route[level.iz_route.size] = (8593, -773, 11799);
	level.iz_route[level.iz_route.size] = (9474, -2057, 11789);
	level.iz_route[level.iz_route.size] = (9446, -3316, 11759);
	level.iz_route[level.iz_route.size] = (8400, -4521, 11791);
	level.iz_route[level.iz_route.size] = (7322, -5163, 11796);
	level.iz_route[level.iz_route.size] = (5342, -6424, 11755);
	level.iz_route[level.iz_route.size] = (3375, -7644, 11785);
	level.iz_route[level.iz_route.size] = (1600, -8388, 11811);
	level.iz_route[level.iz_route.size] = (-441, -9176, 11795);
	level.iz_route[level.iz_route.size] = (-2392, -9565, 11781);
	level.iz_route[level.iz_route.size] = (-3328, -9396, 11739);
	level.iz_route[level.iz_route.size] = (-4299, -8963, 11790);
	level.iz_route[level.iz_route.size] = (-4972, -8309, 11821);
	level.iz_route[level.iz_route.size] = (-5264, -7475, 11828);
	level.iz_route[level.iz_route.size] = (-4824, -6583, 11865);
	level.iz_route[level.iz_route.size] = (-4296, -5738, 11852);
	level.iz_route[level.iz_route.size] = (-3662, -4694, 11860);
	level.iz_route[level.iz_route.size] = (-2830, -4016, 11944);
	level.iz_route[level.iz_route.size] = (-2061, -3621, 11965);
	level.iz_route[level.iz_route.size] = (-1371, -3083, 11966);
	level.iz_route[level.iz_route.size] = (-1292, -2001, 11966);
	level.iz_route[level.iz_route.size] = (-1321, -182, 11930);
	level.iz_route[level.iz_route.size] = (-1331, 1312, 11934);
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
	points[0] = (4758.2676, -3395.3857, 11616.2988);
	angles[0] = (0, 145.4835, 0);
	at[0] = 0;
	points[1] = (4753.5435, -3416.5591, 11616.2988);
	angles[1] = (0, 153.6634, 0);
	at[1] = 0.0500;
	points[2] = (4740.6299, -3457.0710, 11616.2988);
	angles[2] = (0, 160.0395, 0);
	at[2] = 0.1500;
	points[3] = (4676.0239, -3659.6143, 11616.2988);
	angles[3] = (0, 162.3056, 0);
	at[3] = 0.6500;
	points[4] = (4669.5669, -3679.8660, 11616.2988);
	angles[4] = (0, 166.0865, 0);
	at[4] = 0.7000;
	points[5] = (4670.9448, -3722.4292, 11616.2988);
	angles[5] = (0, 177.3531, 0);
	at[5] = 0.8000;
	points[6] = (4671.9688, -3764.9373, 11616.2988);
	angles[6] = (0, 180.3212, 0);
	at[6] = 0.9000;
	points[7] = (4678.1104, -4020, 11616.2988);
	angles[7] = (0, 181.3757, 0);
	at[7] = 1.5000;
	points[8] = (4695.4727, -4057.9526, 11616.2988);
	angles[8] = (0, 200.2100, 0);
	at[8] = 1.6000;
	points[9] = (4716.4565, -4094.9607, 11616.2988);
	angles[9] = (0, 207.1040, 0);
	at[9] = 1.7000;
	points[10] = (4905.2363, -4427.8350, 11616.2988);
	angles[10] = (0, 209.5580, 0);
	at[10] = 2.6000;
	points[11] = (4915.7480, -4446.2993, 11616.2988);
	angles[11] = (0, 214.8913, 0);
	at[11] = 2.6500;
	points[12] = (4935.5117, -4456.0630, 11616.2988);
	angles[12] = (0, 225.4756, 0);
	at[12] = 2.7000;
	points[13] = (4953.3071, -4467.7559, 11616.2988);
	angles[13] = (0, 230.9529, 0);
	at[13] = 2.7500;
	points[14] = (4988.8584, -4491.0630, 11616.2988);
	angles[14] = (0, 235.2061, 0);
	at[14] = 2.8500;
	points[15] = (5255.4336, -4666.0630, 11616.2988);
	angles[15] = (0, 236.7182, 0);
	at[15] = 3.6000;
	points[16] = (5276.2598, -4663.4253, 11616.2988);
	angles[16] = (0, 256.9770, 0);
	at[16] = 3.6500;
	points[17] = (5297.2441, -4660, 11616.2988);
	angles[17] = (0, 267.7919, 0);
	at[17] = 3.7000;
	points[18] = (5339.2124, -4653.1499, 11616.2988);
	angles[18] = (0, 276.2663, 0);
	at[18] = 3.8000;
	points[19] = (5632.9526, -4605.1182, 11616.2988);
	angles[19] = (0, 279.2852, 0);
	at[19] = 4.5000;
	points[20] = (5653.9370, -4601.6929, 11616.2988);
	angles[20] = (0, 284.1152, 0);
	at[20] = 4.5500;
	points[21] = (5670.6299, -4587.4805, 11616.2988);
	angles[21] = (0, 293.6703, 0);
	at[21] = 4.6000;
	points[22] = (5688.3071, -4575.6299, 11616.2988);
	angles[22] = (0, 298.6049, 0);
	at[22] = 4.6500;
	points[23] = (5723.6611, -4551.9688, 11616.2988);
	angles[23] = (0, 302.4346, 0);
	at[23] = 4.7500;
	points[24] = (5970.9839, -4386.4175, 11616.2988);
	angles[24] = (0, 303.7958, 0);
	at[24] = 5.4500;
	points[25] = (5983.0312, -4370.1968, 11616.2988);
	angles[25] = (0, 316.4922, 0);
	at[25] = 5.5000;
	points[26] = (5990.3545, -4350.2363, 11616.2988);
	angles[26] = (0, 327.8428, 0);
	at[26] = 5.5500;
	points[27] = (6004.9609, -4310.3149, 11616.2988);
	angles[27] = (0, 336.7484, 0);
	at[27] = 5.6500;
	points[28] = (6026.8506, -4250.3936, 11616.2988);
	angles[28] = (0, 339.4962, 0);
	at[28] = 5.8000;
	points[29] = (6099.8032, -4050.7087, 11616.2988);
	angles[29] = (0, 339.9217, 0);
	at[29] = 6.3000;
	points[30] = (6107.1260, -4030.7480, 11616.2988);
	angles[30] = (0, 345.0903, 0);
	at[30] = 6.3500;
	points[31] = (6102.9136, -4009.3701, 11616.2988);
	angles[31] = (0, 355.3362, 0);
	at[31] = 6.4000;
	points[32] = (6100.5908, -3988.2285, 11616.2988);
	angles[32] = (0, 360.6346, 0);
	at[32] = 6.4500;
	points[33] = (6095.9844, -3945.9841, 11616.2988);
	angles[33] = (0, 364.7482, 0);
	at[33] = 6.5500;
	points[34] = (6063.8188, -3650.0825, 11616.2988);
	angles[34] = (0, 366.2105, 0);
	at[34] = 7.2500;
	points[35] = (6053.7798, -3632.1614, 11616.2988);
	angles[35] = (0, 382.0055, 0);
	at[35] = 7.3000;
	points[36] = (6040.3936, -3615.6536, 11616.2988);
	angles[36] = (0, 390.2927, 0);
	at[36] = 7.3500;
	points[37] = (6013.6221, -3582.6340, 11616.2988);
	angles[37] = (0, 396.7537, 0);
	at[37] = 7.4500;
	points[38] = (5839.4883, -3368.0081, 11616.2988);
	angles[38] = (0, 399.0525, 0);
	at[38] = 8.1000;
	points[39] = (5826.1025, -3351.5000, 11616.2988);
	angles[39] = (0, 404.6725, 0);
	at[39] = 8.1500;
	points[40] = (5805.5513, -3344.6260, 11616.2988);
	angles[40] = (0, 415.8464, 0);
	at[40] = 8.2000;
	points[41] = (5785.8662, -3336.5710, 11616.2988);
	angles[41] = (0, 421.6362, 0);
	at[41] = 8.2500;
	points[42] = (5746.4961, -3320.4607, 11616.2988);
	angles[42] = (0, 426.1335, 0);
	at[42] = 8.3500;
	points[43] = (5392.3623, -3175.4529, 11616.2988);
	angles[43] = (0, 427.7326, 0);
	at[43] = 9.2500;
	points[44] = (5372.6772, -3167.3975, 11616.2988);
	angles[44] = (0, 432.7228, 0);
	at[44] = 9.3000;
	points[45] = (5351.2993, -3169.5120, 11616.2988);
	angles[45] = (0, 442.6044, 0);
	at[45] = 9.3500;
	points[46] = (5308.8584, -3171.7991, 11616.2988);
	angles[46] = (0, 450.3316, 0);
	at[46] = 9.4500;
	points[47] = (5054.0942, -3185.5237, 11616.2988);
	angles[47] = (0, 453.0825, 0);
	at[47] = 10.0500;
	points[48] = (5035.3149, -3195.2598, 11616.2988);
	angles[48] = (0, 465.5333, 0);
	at[48] = 10.1000;
	points[49] = (4998.0708, -3215.7598, 11616.2988);
	angles[49] = (0, 475.3297, 0);
	at[49] = 10.2000;
	points[50] = (4830.4331, -3308.0078, 11616.2988);
	angles[50] = (0, 478.8149, 0);
	at[50] = 10.6500;
	points[51] = (4801.9292, -3338.7166, 11616.2988);
	angles[51] = (0, 494.5931, 0);
	at[51] = 10.7500;
	points[52] = (4762.9922, -3389.2363, 11616.2988);
	angles[52] = (0, 501.3339, 0);
	at[52] = 10.9000;
	points[53] = (4758.2676, -3395.3857, 11616.2988);
	angles[53] = (0, 505.4835, 0);
	at[53] = 10.9167;
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
	points[0] = (5488.8584, -1316.7755, 11616.2988);
	angles[0] = (0, -74.0333, 0);
	at[0] = 0;
	points[1] = (5511.9683, -1323.4331, 11616.2988);
	angles[1] = (0, -97.8038, 0);
	at[1] = 0.0833;
	points[2] = (5532.8345, -1330.9094, 11616.2988);
	angles[2] = (0, -105.8175, 0);
	at[2] = 0.1667;
	points[3] = (5553.6616, -1338.3896, 11616.2988);
	angles[3] = (0, -108.4516, 0);
	at[3] = 0.2500;
	points[4] = (5928.8975, -1472.9961, 11616.2988);
	angles[4] = (0, -109.7357, 0);
	at[4] = 1.7500;
	points[5] = (5947.0469, -1484.8899, 11616.2988);
	angles[5] = (0, -120.8341, 0);
	at[5] = 1.8333;
	points[6] = (5963.3462, -1499.8898, 11616.2988);
	angles[6] = (0, -128.7614, 0);
	at[6] = 1.9167;
	points[7] = (5995.9058, -1529.8937, 11616.2988);
	angles[7] = (0, -132.2212, 0);
	at[7] = 2.0833;
	points[8] = (6452.0864, -1949.9055, 11616.2988);
	angles[8] = (0, -132.6374, 0);
	at[8] = 4.4167;
	points[9] = (6465.2759, -1967.4528, 11616.2988);
	angles[9] = (0, -142.1638, 0);
	at[9] = 4.5000;
	points[10] = (6488.1890, -2005.3425, 11616.2988);
	angles[10] = (0, -148.1000, 0);
	at[10] = 4.6667;
	points[11] = (6774.8818, -2478.9802, 11616.2988);
	angles[11] = (0, -148.8146, 0);
	at[11] = 6.7500;
	points[12] = (6779.2520, -2499.1062, 11616.2988);
	angles[12] = (0, -169.4976, 0);
	at[12] = 6.8333;
	points[13] = (6774.5273, -2520.7402, 11616.2988);
	angles[13] = (0, -184.7850, 0);
	at[13] = 6.9167;
	points[14] = (6769.8032, -2542.3779, 11616.2988);
	angles[14] = (0, -189.8520, 0);
	at[14] = 7;
	points[15] = (6717.7954, -2780.3662, 11616.2988);
	angles[15] = (0, -192.3247, 0);
	at[15] = 7.9167;
	points[16] = (6713.0708, -2802, 11616.2988);
	angles[16] = (0, -201.6933, 0);
	at[16] = 8;
	points[17] = (6691.4565, -2810.7639, 11616.2988);
	angles[17] = (0, -228.6613, 0);
	at[17] = 8.0833;
	points[18] = (6671.8501, -2821.0513, 11616.2988);
	angles[18] = (0, -237.8322, 0);
	at[18] = 8.1667;
	points[19] = (6652.2441, -2831.3386, 11616.2988);
	angles[19] = (0, -240.8497, 0);
	at[19] = 8.2500;
	points[20] = (6397.2832, -2965.0708, 11616.2988);
	angles[20] = (0, -242.3209, 0);
	at[20] = 9.3333;
	points[21] = (6376.8110, -2956.9370, 11616.2988);
	angles[21] = (0, -275.2651, 0);
	at[21] = 9.4167;
	points[22] = (6356.3389, -2948.5315, 11616.2988);
	angles[22] = (0, -286.6965, 0);
	at[22] = 9.5000;
	points[23] = (6335.8267, -2940.1260, 11616.2988);
	angles[23] = (0, -290.4661, 0);
	at[23] = 9.5833;
	points[24] = (6028.5039, -2814.0510, 11616.2988);
	angles[24] = (0, -292.3046, 0);
	at[24] = 10.8333;
	points[25] = (6011.3779, -2800.2441, 11616.2988);
	angles[25] = (0, -305.0464, 0);
	at[25] = 10.9167;
	points[26] = (5978.1099, -2771.0078, 11616.2988);
	angles[26] = (0, -310.6348, 0);
	at[26] = 11.0833;
	points[27] = (5628.7793, -2464.0198, 11616.2988);
	angles[27] = (0, -311.3076, 0);
	at[27] = 12.8333;
	points[28] = (5615.1577, -2446.6733, 11616.2988);
	angles[28] = (0, -319.4158, 0);
	at[28] = 12.9167;
	points[29] = (5589.8032, -2410.3662, 11616.2988);
	angles[29] = (0, -324.4597, 0);
	at[29] = 13.0833;
	points[30] = (5374.2520, -2101.7205, 11616.2988);
	angles[30] = (0, -325.0667, 0);
	at[30] = 14.5000;
	points[31] = (5361.5356, -2083.5669, 11616.2988);
	angles[31] = (0, -329.8556, 0);
	at[31] = 14.5833;
	points[32] = (5357.5195, -2061.7756, 11616.2988);
	angles[32] = (0, -342.9346, 0);
	at[32] = 14.6667;
	points[33] = (5349.3696, -2018.2441, 11616.2988);
	angles[33] = (0, -348.6733, 0);
	at[33] = 14.8333;
	points[34] = (5296.2207, -1735.2953, 11616.2988);
	angles[34] = (0, -349.3643, 0);
	at[34] = 15.9167;
	points[35] = (5301.1421, -1713.7521, 11616.2988);
	angles[35] = (0, -365.4902, 0);
	at[35] = 16;
	points[36] = (5311.4175, -1670.6771, 11616.2988);
	angles[36] = (0, -372.5982, 0);
	at[36] = 16.1667;
	points[37] = (5388.7397, -1347.6062, 11616.2988);
	angles[37] = (0, -373.4543, 0);
	at[37] = 17.4167;
	points[38] = (5407.8345, -1339.4882, 11616.2988);
	angles[38] = (0, -413.1534, 0);
	at[38] = 17.5000;
	points[39] = (5429.1338, -1333.5118, 11616.2988);
	angles[39] = (0, -427.3505, 0);
	at[39] = 17.5833;
	points[40] = (5450.4727, -1327.5354, 11616.2988);
	angles[40] = (0, -432.0487, 0);
	at[40] = 17.6667;
	points[41] = (5488.8584, -1316.7755, 11616.2988);
	angles[41] = (0, -434.0333, 0);
	at[41] = 17.8167;
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
	points[0] = (5386.1812, -3251.5630, 11616.2988);
	angles[0] = (0, 41.0111, 0);
	at[0] = 0;
	points[1] = (5353.7007, -3209.4883, 11616.2988);
	angles[1] = (0, 38.0177, 0);
	at[1] = 0.2000;
	points[2] = (5212.5591, -3027.4922, 11616.2988);
	angles[2] = (0, 37.7968, 0);
	at[2] = 1.0667;
	points[3] = (5201.6929, -3013.4922, 11616.2988);
	angles[3] = (0, 31.5278, 0);
	at[3] = 1.1333;
	points[4] = (5200.5908, -2995.6064, 11616.2988);
	angles[4] = (0, 16.3389, 0);
	at[4] = 1.2000;
	points[5] = (5197.1260, -2960.3428, 11616.2988);
	angles[5] = (0, 7.4290, 0);
	at[5] = 1.3333;
	points[6] = (5171.0630, -2695.8782, 11616.2988);
	angles[6] = (0, 5.6287, 0);
	at[6] = 2.3333;
	points[7] = (5176.4175, -2679.1221, 11616.2988);
	angles[7] = (0, -9.2166, 0);
	at[7] = 2.4000;
	points[8] = (5188.3462, -2645.7561, 11616.2988);
	angles[8] = (0, -17.9185, 0);
	at[8] = 2.5333;
	points[9] = (5283.8188, -2378.8425, 11616.2988);
	angles[9] = (0, -19.6766, 0);
	at[9] = 3.6000;
	points[10] = (5292.7954, -2364.6221, 11616.2988);
	angles[10] = (0, -33.4142, 0);
	at[10] = 3.6667;
	points[11] = (5307.9531, -2355.4844, 11616.2988);
	angles[11] = (0, -48.3898, 0);
	at[11] = 3.7333;
	points[12] = (5323.1494, -2346.3464, 11616.2988);
	angles[12] = (0, -54.6146, 0);
	at[12] = 3.8000;
	points[13] = (5368.6616, -2318.9253, 11616.2988);
	angles[13] = (0, -58.6471, 0);
	at[13] = 4;
	points[14] = (5505.2759, -2236.6733, 11616.2988);
	angles[14] = (0, -58.9447, 0);
	at[14] = 4.6000;
	points[15] = (5521.7324, -2235.3821, 11616.2988);
	angles[15] = (0, -79.5461, 0);
	at[15] = 4.6667;
	points[16] = (5539.0552, -2239.1455, 11616.2988);
	angles[16] = (0, -92.8956, 0);
	at[16] = 4.7333;
	points[17] = (5556.3779, -2242.9136, 11616.2988);
	angles[17] = (0, -98.4274, 0);
	at[17] = 4.8000;
	points[18] = (5608.3071, -2254.2126, 11616.2988);
	angles[18] = (0, -102.0087, 0);
	at[18] = 5;
	points[19] = (5833.3467, -2303.1692, 11616.2988);
	angles[19] = (0, -102.2732, 0);
	at[19] = 5.8667;
	points[20] = (5846.8501, -2313.6497, 11616.2988);
	angles[20] = (0, -118.7998, 0);
	at[20] = 5.9333;
	points[21] = (5859.0156, -2326.5396, 11616.2988);
	angles[21] = (0, -129.3277, 0);
	at[21] = 6;
	points[22] = (5883.3071, -2352.3230, 11616.2988);
	angles[22] = (0, -135.4520, 0);
	at[22] = 6.1333;
	points[23] = (6150.7085, -2635.9253, 11616.2988);
	angles[23] = (0, -136.6879, 0);
	at[23] = 7.6000;
	points[24] = (6159.9214, -2650.3899, 11616.2988);
	angles[24] = (0, -147.2590, 0);
	at[24] = 7.6667;
	points[25] = (6164.0552, -2667.6182, 11616.2988);
	angles[25] = (0, -158.5965, 0);
	at[25] = 7.7333;
	points[26] = (6172.3228, -2702.0786, 11616.2988);
	angles[26] = (0, -165.1998, 0);
	at[26] = 7.8667;
	points[27] = (6234.2124, -2960.5195, 11616.2988);
	angles[27] = (0, -166.5326, 0);
	at[27] = 8.8667;
	points[28] = (6227.4409, -2976.7246, 11616.2988);
	angles[28] = (0, -188.4532, 0);
	at[28] = 8.9333;
	points[29] = (6220.1968, -2992.8860, 11616.2988);
	angles[29] = (0, -197.7286, 0);
	at[29] = 9;
	points[30] = (6212.9136, -3009.0435, 11616.2988);
	angles[30] = (0, -201.5490, 0);
	at[30] = 9.0667;
	points[31] = (6096.6929, -3267.5947, 11616.2988);
	angles[31] = (0, -204.2020, 0);
	at[31] = 10.1333;
	points[32] = (6082.9922, -3278.2876, 11616.2988);
	angles[32] = (0, -222.8972, 0);
	at[32] = 10.2000;
	points[33] = (6068.2681, -3288.1458, 11616.2988);
	angles[33] = (0, -230.7350, 0);
	at[33] = 10.2667;
	points[34] = (6053.5430, -3298, 11616.2988);
	angles[34] = (0, -233.9580, 0);
	at[34] = 10.3333;
	points[35] = (5847.4409, -3435.9961, 11616.2988);
	angles[35] = (0, -236.1956, 0);
	at[35] = 11.2667;
	points[36] = (5831.1812, -3440.3030, 11616.2988);
	angles[36] = (0, -253.9492, 0);
	at[36] = 11.3333;
	points[37] = (5813.5039, -3439.2954, 11616.2988);
	angles[37] = (0, -265.3110, 0);
	at[37] = 11.4000;
	points[38] = (5778.1494, -3437.2795, 11616.2988);
	angles[38] = (0, -271.9286, 0);
	at[38] = 11.5333;
	points[39] = (5636.6143, -3429.2087, 11616.2988);
	angles[39] = (0, -273.2633, 0);
	at[39] = 12.0667;
	points[40] = (5620.8662, -3421.5039, 11616.2988);
	angles[40] = (0, -288.3218, 0);
	at[40] = 12.1333;
	points[41] = (5589.8818, -3404.3584, 11616.2988);
	angles[41] = (0, -297.1528, 0);
	at[41] = 12.2667;
	points[42] = (5465.8267, -3335.7834, 11616.2988);
	angles[42] = (0, -298.9355, 0);
	at[42] = 12.8000;
	points[43] = (5440.0786, -3312.0591, 11616.2988);
	angles[43] = (0, -313.1941, 0);
	at[43] = 12.9333;
	points[44] = (5386.1812, -3251.5630, 11616.2988);
	angles[44] = (0, -318.9889, 0);
	at[44] = 13.2333;
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
	points[0] = (2572.7283, -10058.9365, 11616.2988);
	angles[0] = (0, 86.3729, 0);
	at[0] = 0;
	points[1] = (2528.4961, -10061.6143, 11616.2988);
	angles[1] = (0, 92.3543, 0);
	at[1] = 0.1667;
	points[2] = (2484.2678, -10064.0166, 11616.2988);
	angles[2] = (0, 92.9971, 0);
	at[2] = 0.3333;
	points[3] = (1909.3109, -10094.8818, 11616.2988);
	angles[3] = (0, 93.0744, 0);
	at[3] = 2.5000;
	points[4] = (1865.5630, -10088.6621, 11616.2988);
	angles[4] = (0, 82.2150, 0);
	at[4] = 2.6667;
	points[5] = (1821.8740, -10081.3779, 11616.2988);
	angles[5] = (0, 80.7076, 0);
	at[5] = 2.8333;
	points[6] = (1210.2559, -9979.2910, 11616.2988);
	angles[6] = (0, 80.5264, 0);
	at[6] = 5.1667;
	points[7] = (1166.3503, -9983.5039, 11616.2988);
	angles[7] = (0, 95.0435, 0);
	at[7] = 5.3333;
	points[8] = (683.1024, -10045.4727, 11616.2988);
	angles[8] = (0, 97.3064, 0);
	at[8] = 7.1667;
	points[9] = (640.9055, -10055.3545, 11616.2988);
	angles[9] = (0, 107.9526, 0);
	at[9] = 7.3333;
	points[10] = (605.7087, -10082.2051, 11616.2988);
	angles[10] = (0, 125.2722, 0);
	at[10] = 7.5000;
	points[11] = (570.5079, -10109.0947, 11616.2988);
	angles[11] = (0, 127.1452, 0);
	at[11] = 7.6667;
	points[12] = (77.7130, -10485.4727, 11616.2988);
	angles[12] = (0, 127.3705, 0);
	at[12] = 10;
	points[13] = (-365.4579, -10853.0713, 11616.2988);
	angles[13] = (0, 129.7423, 0);
	at[13] = 12.1667;
	points[14] = (-403.6260, -10874.3311, 11616.2988);
	angles[14] = (0, 115.7957, 0);
	at[14] = 12.3333;
	points[15] = (-445.0315, -10890.0391, 11616.2988);
	angles[15] = (0, 111.3386, 0);
	at[15] = 12.5000;
	points[16] = (-1024.6890, -11110.2754, 11616.2988);
	angles[16] = (0, 110.8022, 0);
	at[16] = 14.8333;
	points[17] = (-1067.7756, -11120.2363, 11616.2988);
	angles[17] = (0, 103.0265, 0);
	at[17] = 15;
	points[18] = (-1111.1299, -11129.3311, 11616.2988);
	angles[18] = (0, 101.9489, 0);
	at[18] = 15.1667;
	points[19] = (-1544.6536, -11220.0400, 11616.2988);
	angles[19] = (0, 101.8192, 0);
	at[19] = 16.8333;
	points[20] = (-1578.6143, -11246.4170, 11616.2988);
	angles[20] = (0, 129.3891, 0);
	at[20] = 17;
	points[21] = (-1609.8937, -11277.7949, 11616.2988);
	angles[21] = (0, 134.4622, 0);
	at[21] = 17.1667;
	points[22] = (-1703.7323, -11371.8506, 11616.2988);
	angles[22] = (0, 135.0720, 0);
	at[22] = 17.6667;
	points[23] = (-1704.0117, -11402.4795, 11616.2988);
	angles[23] = (0, 192.2633, 0);
	at[23] = 17.8333;
	points[24] = (-1671.2795, -11432.3232, 11616.2988);
	angles[24] = (0, 223.7678, 0);
	at[24] = 18;
	points[25] = (-1638.5472, -11462.1660, 11616.2988);
	angles[25] = (0, 227.2331, 0);
	at[25] = 18.1667;
	points[26] = (-1573.0787, -11521.8506, 11616.2988);
	angles[26] = (0, 227.6451, 0);
	at[26] = 18.5000;
	points[27] = (-1533, -11527.3633, 11616.2988);
	angles[27] = (0, 267.5262, 0);
	at[27] = 18.6667;
	points[28] = (-1489.2205, -11520.6299, 11616.2988);
	angles[28] = (0, 277.5198, 0);
	at[28] = 18.8333;
	points[29] = (-1445.4409, -11513.9375, 11616.2988);
	angles[29] = (0, 278.5954, 0);
	at[29] = 19;
	points[30] = (-1007.7322, -11446.2988, 11616.2988);
	angles[30] = (0, 279.6226, 0);
	at[30] = 20.6667;
	points[31] = (-266.7846, -11312.3633, 11616.2988);
	angles[31] = (0, 280.2456, 0);
	at[31] = 23.5000;
	points[32] = (-224.6276, -11298.9756, 11616.2988);
	angles[32] = (0, 287.6022, 0);
	at[32] = 23.6667;
	points[33] = (-182.6854, -11284.7236, 11616.2988);
	angles[33] = (0, 288.6216, 0);
	at[33] = 23.8333;
	points[34] = (1704.7086, -10644.2529, 11616.2988);
	angles[34] = (0, 288.7442, 0);
	at[34] = 31.3333;
	points[35] = (1787.3976, -10612.5205, 11616.2988);
	angles[35] = (0, 291.5657, 0);
	at[35] = 31.6667;
	points[36] = (2240.2402, -10432.7959, 11616.2988);
	angles[36] = (0, 291.6473, 0);
	at[36] = 33.5000;
	points[37] = (2284.3032, -10430.5117, 11616.2988);
	angles[37] = (0, 273.8391, 0);
	at[37] = 33.6667;
	points[38] = (2638.4805, -10420.1182, 11616.2988);
	angles[38] = (0, 271.6807, 0);
	at[38] = 35;
	points[39] = (2679.1064, -10411.5752, 11616.2988);
	angles[39] = (0, 295.3142, 0);
	at[39] = 35.1667;
	points[40] = (2706.4568, -10376.7324, 11616.2988);
	angles[40] = (0, 318.9797, 0);
	at[40] = 35.3333;
	points[41] = (2788.5081, -10272.2441, 11616.2988);
	angles[41] = (0, 321.8613, 0);
	at[41] = 35.8333;
	points[42] = (2807.1458, -10237.2441, 11616.2988);
	angles[42] = (0, 345.7507, 0);
	at[42] = 36;
	points[43] = (2780.8347, -10201.6143, 11616.2988);
	angles[43] = (0, 390.7455, 0);
	at[43] = 36.1667;
	points[44] = (2754.5273, -10165.9844, 11616.2988);
	angles[44] = (0, 395.8287, 0);
	at[44] = 36.3333;
	points[45] = (2701.9097, -10094.7246, 11616.2988);
	angles[45] = (0, 396.4336, 0);
	at[45] = 36.6667;
	points[46] = (2670.8267, -10067.5986, 11616.2988);
	angles[46] = (0, 419.3375, 0);
	at[46] = 36.8333;
	points[47] = (2626.7087, -10063.7012, 11616.2988);
	angles[47] = (0, 442.1602, 0);
	at[47] = 37;
	points[48] = (2572.7283, -10058.9365, 11616.2988);
	angles[48] = (0, 446.3729, 0);
	at[48] = 37.2000;
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
	points[0] = (-1041.9725, -11093.0713, 11616.2988);
	angles[0] = (0, 136.2887, 0);
	at[0] = 0;
	points[1] = (-1051.7086, -11120.9443, 11616.2988);
	angles[1] = (0, 152.6584, 0);
	at[1] = 0.0833;
	points[2] = (-1061.4448, -11148.8184, 11616.2988);
	angles[2] = (0, 158.0934, 0);
	at[2] = 0.1667;
	points[3] = (-1119.8661, -11316.0635, 11616.2988);
	angles[3] = (0, 160.7429, 0);
	at[3] = 0.6667;
	points[4] = (-1108.6732, -11332.3623, 11616.2988);
	angles[4] = (0, 200.5834, 0);
	at[4] = 0.7500;
	points[5] = (-1079.8859, -11338.9375, 11616.2988);
	angles[5] = (0, 237.6380, 0);
	at[5] = 0.8333;
	points[6] = (-1051.0985, -11345.5117, 11616.2988);
	angles[6] = (0, 250.7200, 0);
	at[6] = 0.9167;
	points[7] = (-993.5236, -11358.6221, 11616.2988);
	angles[7] = (0, 256.4602, 0);
	at[7] = 1.0833;
	points[8] = (-792.0039, -11404.6064, 11616.2988);
	angles[8] = (0, 257.1510, 0);
	at[8] = 1.6667;
	points[9] = (-763.4095, -11399.9600, 11616.2988);
	angles[9] = (0, 273.3657, 0);
	at[9] = 1.7500;
	points[10] = (-734.8661, -11392.4023, 11616.2988);
	angles[10] = (0, 281.0633, 0);
	at[10] = 1.8333;
	points[11] = (-706.3189, -11384.8418, 11616.2988);
	angles[11] = (0, 283.5928, 0);
	at[11] = 1.9167;
	points[12] = (-192.5193, -11248.8584, 11616.2988);
	angles[12] = (0, 284.8260, 0);
	at[12] = 3.4167;
	points[13] = (-163.9748, -11241.2988, 11616.2988);
	angles[13] = (0, 291.3309, 0);
	at[13] = 3.5000;
	points[14] = (-145.5398, -11217.2842, 11616.2988);
	angles[14] = (0, 309.3484, 0);
	at[14] = 3.5833;
	points[15] = (-125.8882, -11195.2363, 11616.2988);
	angles[15] = (0, 315.3475, 0);
	at[15] = 3.6667;
	points[16] = (-106.2366, -11173.1895, 11616.2988);
	angles[16] = (0, 317.3167, 0);
	at[16] = 3.7500;
	points[17] = (461.2520, -10531.9688, 11616.2988);
	angles[17] = (0, 318.6416, 0);
	at[17] = 6.1667;
	points[18] = (485.8465, -10515.9844, 11616.2988);
	angles[18] = (0, 306.2902, 0);
	at[18] = 6.2500;
	points[19] = (511.3582, -10501.1025, 11616.2988);
	angles[19] = (0, 302.2126, 0);
	at[19] = 6.3333;
	points[20] = (894.0669, -10278.1494, 11616.2988);
	angles[20] = (0, 300.2238, 0);
	at[20] = 7.5833;
	points[21] = (920.4489, -10265.7090, 11616.2988);
	angles[21] = (0, 292.8489, 0);
	at[21] = 7.6667;
	points[22] = (949.5630, -10260.7871, 11616.2988);
	angles[22] = (0, 283.9400, 0);
	at[22] = 7.7500;
	points[23] = (1007.7953, -10250.9443, 11616.2988);
	angles[23] = (0, 280.0488, 0);
	at[23] = 7.9167;
	points[24] = (1473.6456, -10172.3232, 11616.2988);
	angles[24] = (0, 279.5807, 0);
	at[24] = 9.2500;
	points[25] = (1501.8740, -10175.8662, 11616.2988);
	angles[25] = (0, 264.6090, 0);
	at[25] = 9.3333;
	points[26] = (1529.3466, -10186.6934, 11616.2988);
	angles[26] = (0, 253.7988, 0);
	at[26] = 9.4167;
	points[27] = (1556.8229, -10197.5195, 11616.2988);
	angles[27] = (0, 250.2364, 0);
	at[27] = 9.5000;
	points[28] = (1831.5474, -10305.7480, 11616.2988);
	angles[28] = (0, 248.4991, 0);
	at[28] = 10.3333;
	points[29] = (1829.0630, -10331.6924, 11616.2988);
	angles[29] = (0, 195.9076, 0);
	at[29] = 10.4167;
	points[30] = (1821.4489, -10360.2363, 11616.2988);
	angles[30] = (0, 175.3129, 0);
	at[30] = 10.5000;
	points[31] = (1813.8308, -10388.7402, 11616.2988);
	angles[31] = (0, 168.4207, 0);
	at[31] = 10.5833;
	points[32] = (1806.2166, -10417.2832, 11616.2988);
	angles[32] = (0, 166.1570, 0);
	at[32] = 10.6667;
	points[33] = (1752.9055, -10616.9678, 11616.2988);
	angles[33] = (0, 165.0539, 0);
	at[33] = 11.2500;
	points[34] = (1738.7323, -10639.8037, 11616.2988);
	angles[34] = (0, 147.2122, 0);
	at[34] = 11.3333;
	points[35] = (1711.5157, -10651.2598, 11616.2988);
	angles[35] = (0, 124.3008, 0);
	at[35] = 11.4167;
	points[36] = (1684.2992, -10662.7168, 11616.2988);
	angles[36] = (0, 116.5930, 0);
	at[36] = 11.5000;
	points[37] = (1657.0867, -10674.1729, 11616.2988);
	angles[37] = (0, 114.0601, 0);
	at[37] = 11.5833;
	points[38] = (1276.0709, -10834.5273, 11616.2988);
	angles[38] = (0, 112.8252, 0);
	at[38] = 12.7500;
	points[39] = (1247.8977, -10842.1650, 11616.2988);
	angles[39] = (0, 104.3707, 0);
	at[39] = 12.8333;
	points[40] = (1218.5000, -10844.9609, 11616.2988);
	angles[40] = (0, 98.3637, 0);
	at[40] = 12.9167;
	points[41] = (1189.1063, -10847.7559, 11616.2988);
	angles[41] = (0, 96.3921, 0);
	at[41] = 13;
	points[42] = (571.8110, -10906.4561, 11616.2988);
	angles[42] = (0, 95.4308, 0);
	at[42] = 14.7500;
	points[43] = (543.5709, -10902.2041, 11616.2988);
	angles[43] = (0, 81.1749, 0);
	at[43] = 14.8333;
	points[44] = (516.6260, -10890.1572, 11616.2988);
	angles[44] = (0, 70.9047, 0);
	at[44] = 14.9167;
	points[45] = (489.6772, -10878.0713, 11616.2988);
	angles[45] = (0, 67.5221, 0);
	at[45] = 15;
	points[46] = (31.5603, -10672.8740, 11616.2988);
	angles[46] = (0, 65.8727, 0);
	at[46] = 16.4167;
	points[47] = (3.1476, -10678.0312, 11616.2988);
	angles[47] = (0, 91.4826, 0);
	at[47] = 16.5000;
	points[48] = (-25.4520, -10685.3936, 11616.2988);
	angles[48] = (0, 100.1582, 0);
	at[48] = 16.5833;
	points[49] = (-82.6512, -10700.0791, 11616.2988);
	angles[49] = (0, 103.9467, 0);
	at[49] = 16.7500;
	points[50] = (-368.6472, -10773.5039, 11616.2988);
	angles[50] = (0, 106.1003, 0);
	at[50] = 17.5833;
	points[51] = (-395.6299, -10785.6299, 11616.2988);
	angles[51] = (0, 110.6749, 0);
	at[51] = 17.6667;
	points[52] = (-450.0276, -10808.6221, 11616.2988);
	angles[52] = (0, 112.6671, 0);
	at[52] = 17.8333;
	points[53] = (-912.4094, -11004.0166, 11616.2988);
	angles[53] = (0, 112.9069, 0);
	at[53] = 19.2500;
	points[54] = (-937.4607, -11019.5674, 11616.2988);
	angles[54] = (0, 119.7672, 0);
	at[54] = 19.3333;
	points[55] = (-962.1890, -11035.6689, 11616.2988);
	angles[55] = (0, 122.0204, 0);
	at[55] = 19.4167;
	points[56] = (-1036.3820, -11084.0947, 11616.2988);
	angles[56] = (0, 123.0802, 0);
	at[56] = 19.6667;
	points[57] = (-1041.9725, -11093.0713, 11616.2988);
	angles[57] = (0, 136.2887, 0);
	at[57] = 19.7000;
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
	points[0] = (9024.4883, -1397.5198, 11796.4170);
	angles[0] = (0, 16.8172, 0);
	at[0] = 0;
	points[1] = (8727.7168, -1487.2087, 11791.2598);
	angles[1] = (0, 16.8172, 0);
	at[1] = 1.1667;
	points[2] = (8715, -1491.0511, 11791.0244);
	angles[2] = (0, 15.3720, 0);
	at[2] = 1.2500;
	points[3] = (8715, -1491.0511, 11791.0244);
	angles[3] = (0, 15.3720, 0);
	at[3] = 1.9167;
	points[4] = (8706.4570, -1493.3110, 11790.8271);
	angles[4] = (0, 15.3720, 0);
	at[4] = 2;
	points[5] = (8407.5596, -1575.4803, 11784.4492);
	angles[5] = (0, 15.3720, 0);
	at[5] = 3.1667;
	points[6] = (8390.4727, -1580.1772, 11784.0947);
	angles[6] = (0, 14.3994, 0);
	at[6] = 3.2500;
	points[7] = (8390.4727, -1580.1772, 11784.0947);
	angles[7] = (0, 14.3994, 0);
	at[7] = 3.9167;
	points[8] = (8386.1816, -1581.2402, 11783.8184);
	angles[8] = (0, 14.3994, 0);
	at[8] = 4;
	points[9] = (8107.7168, -1652.7362, 11768.7402);
	angles[9] = (0, 14.3994, 0);
	at[9] = 5.0833;
	points[10] = (8103.4648, -1653.8347, 11768.5049);
	angles[10] = (0, 13.2822, 0);
	at[10] = 5.1667;
	points[11] = (8103.4648, -1653.8347, 11768.5049);
	angles[11] = (0, 13.2822, 0);
	at[11] = 5.8333;
	points[12] = (8086.2603, -1657.8740, 11766.8506);
	angles[12] = (0, 13.2822, 0);
	at[12] = 5.9167;
	points[13] = (7828.7007, -1718.6771, 11742.7949);
	angles[13] = (0, 13.2822, 0);
	at[13] = 6.9167;
	points[14] = (7820.1182, -1720.7047, 11741.9688);
	angles[14] = (0, 13.2822, 0);
	at[14] = 7;
	points[15] = (7820.1182, -1720.7047, 11741.9688);
	angles[15] = (0, 13.2822, 0);
	at[15] = 8.4167;
	points[16] = (7834.9214, -1717.2047, 11743.3467);
	angles[16] = (0, 13.2822, 0);
	at[16] = 8.5000;
	points[17] = (8092.5200, -1656.4016, 11767.4414);
	angles[17] = (0, 13.2822, 0);
	at[17] = 9.5000;
	points[18] = (8105.3936, -1653.3622, 11768.6621);
	angles[18] = (0, 14.3994, 0);
	at[18] = 9.5833;
	points[19] = (8105.3936, -1653.3622, 11768.6621);
	angles[19] = (0, 14.3994, 0);
	at[19] = 10.2500;
	points[20] = (8113.9370, -1651.1378, 11769.0547);
	angles[20] = (0, 14.3994, 0);
	at[20] = 10.3333;
	points[21] = (8392.4414, -1579.6417, 11784.1338);
	angles[21] = (0, 14.3994, 0);
	at[21] = 11.4167;
	points[22] = (8396.6934, -1578.5433, 11784.3701);
	angles[22] = (0, 15.3720, 0);
	at[22] = 11.5000;
	points[23] = (8396.6934, -1578.5433, 11784.3701);
	angles[23] = (0, 15.3720, 0);
	at[23] = 12.1667;
	points[24] = (8413.7803, -1573.7756, 11784.6064);
	angles[24] = (0, 15.3720, 0);
	at[24] = 12.2500;
	points[25] = (8712.6377, -1491.6063, 11790.9443);
	angles[25] = (0, 15.3720, 0);
	at[25] = 13.4167;
	points[26] = (8721.1816, -1489.2559, 11791.1416);
	angles[26] = (0, 16.8172, 0);
	at[26] = 13.5000;
	points[27] = (8721.1816, -1489.2559, 11791.1416);
	angles[27] = (0, 16.8172, 0);
	at[27] = 14.1667;
	points[28] = (8733.8975, -1485.3464, 11791.3389);
	angles[28] = (0, 16.8172, 0);
	at[28] = 14.2500;
	points[29] = (9030.6299, -1395.6575, 11796.5352);
	angles[29] = (0, 16.8172, 0);
	at[29] = 15.4167;
	points[30] = (9030.6299, -1395.6575, 11796.5352);
	angles[30] = (0, 16.8172, 0);
	at[30] = 16.9167;
	points[31] = (9024.4883, -1397.5198, 11796.4170);
	angles[31] = (0, 16.8172, 0);
	at[31] = 16.9333;
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
	points[0] = (7421.3389, -3880.0435, 11748.1504);
	angles[0] = (0, -59.2586, 0);
	at[0] = 0;
	points[1] = (7773.9370, -4472.9526, 11787.4805);
	angles[1] = (0, -59.2586, 0);
	at[1] = 2.6000;
	points[2] = (7785.2363, -4491.9292, 11788.7402);
	angles[2] = (0, -62.6334, 0);
	at[2] = 2.7000;
	points[3] = (7785.2363, -4491.9292, 11788.7402);
	angles[3] = (0, -62.6334, 0);
	at[3] = 3.4000;
	points[4] = (7793.1895, -4507.7954, 11788.5830);
	angles[4] = (0, -62.6334, 0);
	at[4] = 3.5000;
	points[5] = (8159.6851, -5215.7876, 11789.7637);
	angles[5] = (0, -62.6334, 0);
	at[5] = 6.5000;
	points[6] = (8167.8345, -5231.5352, 11789.7637);
	angles[6] = (0, -63.0400, 0);
	at[6] = 6.6000;
	points[7] = (8167.8345, -5231.5352, 11789.7637);
	angles[7] = (0, -63.0400, 0);
	at[7] = 7.3000;
	points[8] = (8177.8345, -5251.2603, 11788.7793);
	angles[8] = (0, -63.0400, 0);
	at[8] = 7.4000;
	points[9] = (8430.6299, -5748.2285, 11765.5117);
	angles[9] = (0, -63.0400, 0);
	at[9] = 9.5000;
	points[10] = (8436.6533, -5760.0786, 11764.9600);
	angles[10] = (0, -63.0400, 0);
	at[10] = 9.6000;
	points[11] = (8436.6533, -5760.0786, 11764.9600);
	angles[11] = (0, -63.0400, 0);
	at[11] = 11;
	points[12] = (8429.6064, -5746.2202, 11765.5908);
	angles[12] = (0, -63.0400, 0);
	at[12] = 11.1000;
	points[13] = (8176.8110, -5249.2129, 11788.8584);
	angles[13] = (0, -63.0400, 0);
	at[13] = 13.2000;
	points[14] = (8166.7720, -5229.4883, 11789.8037);
	angles[14] = (0, -62.6334, 0);
	at[14] = 13.3000;
	points[15] = (8166.7720, -5229.4883, 11789.8037);
	angles[15] = (0, -62.6334, 0);
	at[15] = 14;
	points[16] = (8158.6221, -5213.7402, 11789.7637);
	angles[16] = (0, -62.6334, 0);
	at[16] = 14.1000;
	points[17] = (7792.1655, -4505.7480, 11788.5830);
	angles[17] = (0, -62.6334, 0);
	at[17] = 17.1000;
	points[18] = (7781.9688, -4486.0630, 11788.5430);
	angles[18] = (0, -59.2586, 0);
	at[18] = 17.2000;
	points[19] = (7781.9688, -4486.0630, 11788.5430);
	angles[19] = (0, -59.2586, 0);
	at[19] = 17.9000;
	points[20] = (7772.7559, -4470.9844, 11787.3623);
	angles[20] = (0, -59.2586, 0);
	at[20] = 18;
	points[21] = (7420.1577, -3878.0747, 11748.0312);
	angles[21] = (0, -59.2586, 0);
	at[21] = 20.6000;
	points[22] = (7417.8740, -3874.2717, 11747.7959);
	angles[22] = (0, -59.2586, 0);
	at[22] = 20.7000;
	points[23] = (7417.8740, -3874.2717, 11747.7959);
	angles[23] = (0, -59.2586, 0);
	at[23] = 22.1000;
	points[24] = (7421.3389, -3880.0435, 11748.1504);
	angles[24] = (0, -59.2586, 0);
	at[24] = 22.1333;
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
	points[0] = (332.1870, -9419.0557, 11699.0557);
	angles[0] = (0, -67.9811, 0);
	at[0] = 0;
	points[1] = (174.9461, -9030.2363, 11768.9766);
	angles[1] = (0, -67.9811, 0);
	at[1] = 1.6000;
	points[2] = (170.0323, -9018.0713, 11771.1816);
	angles[2] = (0, -66.7036, 0);
	at[2] = 1.6667;
	points[3] = (170.0323, -9018.0713, 11771.1816);
	angles[3] = (0, -66.7036, 0);
	at[3] = 2.4000;
	points[4] = (-11.9013, -8595.7090, 11797.2041);
	angles[4] = (0, -66.7036, 0);
	at[4] = 4.1333;
	points[5] = (-17.1478, -8583.5039, 11797.9531);
	angles[5] = (0, -66.8731, 0);
	at[5] = 4.2000;
	points[6] = (-17.1478, -8583.5039, 11797.9531);
	angles[6] = (0, -66.8731, 0);
	at[6] = 4.9333;
	points[7] = (-156.3154, -8257.6377, 11799.0166);
	angles[7] = (0, -66.8731, 0);
	at[7] = 6.2667;
	points[8] = (-158.0551, -8253.5830, 11799.0166);
	angles[8] = (0, -66.8731, 0);
	at[8] = 6.3333;
	points[9] = (-158.0551, -8253.5830, 11799.0166);
	angles[9] = (0, -66.8731, 0);
	at[9] = 7.7333;
	points[10] = (-156.2185, -8257.8740, 11799.0166);
	angles[10] = (0, -66.8731, 0);
	at[10] = 7.8000;
	points[11] = (-17.0488, -8583.7402, 11797.9131);
	angles[11] = (0, -66.8731, 0);
	at[11] = 9.1333;
	points[12] = (-15.3092, -8587.7959, 11797.9131);
	angles[12] = (0, -66.7036, 0);
	at[12] = 9.2000;
	points[13] = (-15.3092, -8587.7959, 11797.9131);
	angles[13] = (0, -66.7036, 0);
	at[13] = 9.8667;
	points[14] = (-11.8037, -8595.9053, 11797.2041);
	angles[14] = (0, -66.7036, 0);
	at[14] = 9.9333;
	points[15] = (170.0736, -9018.3076, 11770.9053);
	angles[15] = (0, -66.7036, 0);
	at[15] = 11.6667;
	points[16] = (171.8224, -9022.3623, 11770.6699);
	angles[16] = (0, -67.9811, 0);
	at[16] = 11.7333;
	points[17] = (171.8224, -9022.3623, 11770.6699);
	angles[17] = (0, -67.9811, 0);
	at[17] = 12.4000;
	points[18] = (175.0374, -9030.4727, 11768.9375);
	angles[18] = (0, -67.9811, 0);
	at[18] = 12.4667;
	points[19] = (332.2784, -9419.2910, 11699.0156);
	angles[19] = (0, -67.9811, 0);
	at[19] = 14.0667;
	points[20] = (333.9165, -9423.3076, 11698.3066);
	angles[20] = (0, -67.9811, 0);
	at[20] = 14.1333;
	points[21] = (333.9165, -9423.3076, 11698.3066);
	angles[21] = (0, -67.9811, 0);
	at[21] = 15.5333;
	points[22] = (332.1870, -9419.0557, 11699.0557);
	angles[22] = (0, -67.9811, 0);
	at[22] = 15.6000;
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
