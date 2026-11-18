main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_beta_donut_plains_2", 0);

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
	ambientPlay("iz_0_sfcdp2", 2);
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
	level.iz_route[level.iz_route.size] = (23, -346, 450);
	level.iz_route[level.iz_route.size] = (62, -1743, 449);
	level.iz_route[level.iz_route.size] = (103, -3398, 449);
	level.iz_route[level.iz_route.size] = (174, -4868, 449);
	level.iz_route[level.iz_route.size] = (326, -5472, 449);
	level.iz_route[level.iz_route.size] = (708, -6063, 449);
	level.iz_route[level.iz_route.size] = (1514, -6529, 449);
	level.iz_route[level.iz_route.size] = (2360, -6617, 449);
	level.iz_route[level.iz_route.size] = (3172, -6113, 448);
	level.iz_route[level.iz_route.size] = (4030, -5492, 434);
	level.iz_route[level.iz_route.size] = (4317, -4951, 422);
	level.iz_route[level.iz_route.size] = (4681, -3906, 393);
	level.iz_route[level.iz_route.size] = (4924, -3236, 397);
	level.iz_route[level.iz_route.size] = (5274, -2916, 402);
	level.iz_route[level.iz_route.size] = (5908, -2932, 396);
	level.iz_route[level.iz_route.size] = (6497, -2972, 432);
	level.iz_route[level.iz_route.size] = (7731, -2895, 439);
	level.iz_route[level.iz_route.size] = (8479, -2616, 447);
	level.iz_route[level.iz_route.size] = (8831, -2153, 449);
	level.iz_route[level.iz_route.size] = (8939, -1498, 449);
	level.iz_route[level.iz_route.size] = (8863, -793, 451);
	level.iz_route[level.iz_route.size] = (8741, -466, 456);
	level.iz_route[level.iz_route.size] = (7268, 223, 451);
	level.iz_route[level.iz_route.size] = (6765, 570, 450);
	level.iz_route[level.iz_route.size] = (6755, 944, 450);
	level.iz_route[level.iz_route.size] = (6962, 1350, 459);
	level.iz_route[level.iz_route.size] = (7522, 1835, 508);
	level.iz_route[level.iz_route.size] = (7761, 2398, 474);
	level.iz_route[level.iz_route.size] = (7569, 3070, 465);
	level.iz_route[level.iz_route.size] = (6948, 3502, 459);
	level.iz_route[level.iz_route.size] = (5838, 3663, 450);
	level.iz_route[level.iz_route.size] = (4484, 3105, 452);
	level.iz_route[level.iz_route.size] = (3545, 2457, 471);
	level.iz_route[level.iz_route.size] = (3057, 2324, 473);
	level.iz_route[level.iz_route.size] = (2537, 2366, 475);
	level.iz_route[level.iz_route.size] = (2029, 2601, 488);
	level.iz_route[level.iz_route.size] = (1268, 3325, 483);
	level.iz_route[level.iz_route.size] = (171, 3264, 482);
	level.iz_route[level.iz_route.size] = (-143, 2639, 492);
	level.iz_route[level.iz_route.size] = (-93, 1850, 478);
	level.iz_route[level.iz_route.size] = (-14, 856, 461);
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
	points[0] = (-140.0398, 3307.4646, 332.9768);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-95.1095, 3206.0867, 323.7807);
	angles[1] = (0, 0, 0);
	at[1] = 0.2500;
	points[2] = (-43.8453, 3109.4883, 315.1811);
	angles[2] = (0, 0, 0);
	at[2] = 0.5000;
	points[3] = (44.5264, 2990.9727, 305.2173);
	angles[3] = (0, 0, 0);
	at[3] = 0.8333;
	points[4] = (92.5721, 2934.8071, 300.5815);
	angles[4] = (0, 0, 0);
	at[4] = 1;
	points[5] = (144.1225, 2881.8464, 296.2433);
	angles[5] = (0, 0, 0);
	at[5] = 1.1667;
	points[6] = (172.0027, 2858.1772, 294.3217);
	angles[6] = (0, 0, 0);
	at[6] = 1.2500;
	points[7] = (231.8441, 2816.7954, 291.0079);
	angles[7] = (0, 0, 0);
	at[7] = 1.4167;
	points[8] = (420.8347, 2699.9763, 281.7559);
	angles[8] = (0, 0, 0);
	at[8] = 1.9167;
	points[9] = (551.1929, 2629.2402, 276.2197);
	angles[9] = (0, 0, 0);
	at[9] = 2.2500;
	points[10] = (618.0551, 2598.7837, 273.8772);
	angles[10] = (0, 0, 0);
	at[10] = 2.4167;
	points[11] = (653.4921, 2586.1968, 272.9386);
	angles[11] = (0, 0, 0);
	at[11] = 2.5000;
	points[12] = (659.0079, 2584.6418, 449.9921);
	angles[12] = (0, 0, 0);
	at[12] = 2.5833;
	points[13] = (659.0079, 2584.6418, 449.9921);
	angles[13] = (0, 0, 0);
	at[13] = 4.1667;
	points[14] = (659.0079, 2584.6418, 590.4410);
	angles[14] = (0, 0, 0);
	at[14] = 4.3333;
	points[15] = (659.0079, 2584.6418, 640.5630);
	angles[15] = (0, 0, 0);
	at[15] = 4.4167;
	points[16] = (659.0079, 2584.6418, 670.7559);
	angles[16] = (0, 0, 0);
	at[16] = 4.5000;
	points[17] = (659.0079, 2584.6418, 681.0157);
	angles[17] = (0, 0, 0);
	at[17] = 4.5833;
	points[18] = (659.0079, 2584.6418, 671.3465);
	angles[18] = (0, 0, 0);
	at[18] = 4.6667;
	points[19] = (659.0079, 2584.6418, 641.7441);
	angles[19] = (0, 0, 0);
	at[19] = 4.7500;
	points[20] = (659.0079, 2584.6418, 592.2126);
	angles[20] = (0, 0, 0);
	at[20] = 4.8333;
	points[21] = (659.0079, 2584.6418, 522.7480);
	angles[21] = (0, 0, 0);
	at[21] = 4.9167;
	points[22] = (659.0079, 2584.6418, 272.8272);
	angles[22] = (0, 0, 0);
	at[22] = 5;
	points[23] = (692.9173, 2577.8977, 272.3717);
	angles[23] = (0, 0, 0);
	at[23] = 5.0833;
	points[24] = (803.6142, 2567.1931, 271.7992);
	angles[24] = (0, 0, 0);
	at[24] = 5.3333;
	points[25] = (989.1575, 2561.3152, 271.8685);
	angles[25] = (0, 0, 0);
	at[25] = 5.7500;
	points[26] = (1174.7440, 2564.5315, 272.8162);
	angles[26] = (0, 0, 0);
	at[26] = 6.1667;
	points[27] = (1249.0237, 2569.4133, 273.5807);
	angles[27] = (0, 0, 0);
	at[27] = 6.3333;
	points[28] = (1320.0354, 2579.6731, 274.9437);
	angles[28] = (0, 0, 0);
	at[28] = 6.5000;
	points[29] = (1388.4213, 2606.4136, 278.1579);
	angles[29] = (0, 0, 0);
	at[29] = 6.6667;
	points[30] = (1485.5276, 2659.9646, 284.4480);
	angles[30] = (0, 0, 0);
	at[30] = 6.9167;
	points[31] = (1609.4252, 2740.9136, 293.8189);
	angles[31] = (0, 0, 0);
	at[31] = 7.2500;
	points[32] = (1727.6143, 2830.4646, 303.9150);
	angles[32] = (0, 0, 0);
	at[32] = 7.5833;
	points[33] = (1752.3622, 2854.8542, 306.5016);
	angles[33] = (0, 0, 0);
	at[33] = 7.6667;
	points[34] = (1796.7914, 2913.8662, 312.5736);
	angles[34] = (0, 0, 0);
	at[34] = 7.8333;
	points[35] = (1854.8740, 3008.0393, 322.0366);
	angles[35] = (0, 0, 0);
	at[35] = 8.0833;
	points[36] = (1906.9292, 3105.8662, 331.5169);
	angles[36] = (0, 0, 0);
	at[36] = 8.3333;
	points[37] = (1935.0040, 3173.0432, 337.4059);
	angles[37] = (0, 0, 0);
	at[37] = 8.5000;
	points[38] = (1954.8583, 3243.8818, 343.1059);
	angles[38] = (0, 0, 0);
	at[38] = 8.6667;
	points[39] = (1987.3544, 3387.9136, 353.9913);
	angles[39] = (0, 0, 0);
	at[39] = 9;
	points[40] = (2006.4883, 3497.3860, 360.9189);
	angles[40] = (0, 0, 0);
	at[40] = 9.2500;
	points[41] = (2011.7048, 3606.8110, 362.7815);
	angles[41] = (0, 0, 0);
	at[41] = 9.5000;
	points[42] = (2008.3228, 3792.0396, 362.8091);
	angles[42] = (0, 0, 0);
	at[42] = 9.9167;
	points[43] = (2001.7047, 3864.5630, 362.8807);
	angles[43] = (0, 0, 0);
	at[43] = 10.0833;
	points[44] = (1983.3740, 3936.3936, 363.6783);
	angles[44] = (0, 0, 0);
	at[44] = 10.2500;
	points[45] = (1959.9410, 4006.4568, 364.5779);
	angles[45] = (0, 0, 0);
	at[45] = 10.4167;
	points[46] = (1932.2638, 4075.1970, 365.3941);
	angles[46] = (0, 0, 0);
	at[46] = 10.5833;
	points[47] = (1916.1458, 4107.9922, 365.6834);
	angles[47] = (0, 0, 0);
	at[47] = 10.6667;
	points[48] = (1896.4646, 4137.9922, 365.7118);
	angles[48] = (0, 0, 0);
	at[48] = 10.7500;
	points[49] = (1797.4528, 4248.6221, 364.2705);
	angles[49] = (0, 0, 0);
	at[49] = 11.0833;
	points[50] = (1744.3977, 4300.5908, 363.5071);
	angles[50] = (0, 0, 0);
	at[50] = 11.2500;
	points[51] = (1688.0867, 4348.9761, 362.9472);
	angles[51] = (0, 0, 0);
	at[51] = 11.4167;
	points[52] = (1657.1456, 4369.1733, 362.9398);
	angles[52] = (0, 0, 0);
	at[52] = 11.5000;
	points[53] = (1622.9370, 4378.1104, 363.5882);
	angles[53] = (0, 0, 0);
	at[53] = 11.5833;
	points[54] = (1585.9685, 4380.1182, 364.6410);
	angles[54] = (0, 0, 0);
	at[54] = 11.6667;
	points[55] = (1511.9764, 4376.6538, 367.0485);
	angles[55] = (0, 0, 0);
	at[55] = 11.8333;
	points[56] = (1364.9960, 4361.2598, 371.8709);
	angles[56] = (0, 0, 0);
	at[56] = 12.1667;
	points[57] = (1335.5236, 4358.5435, 549.8622);
	angles[57] = (0, 0, 0);
	at[57] = 12.2500;
	points[58] = (1335.5236, 4358.5435, 549.8622);
	angles[58] = (0, 0, 0);
	at[58] = 13.8333;
	points[59] = (1335.5236, 4358.5435, 568.6536);
	angles[59] = (0, 0, 0);
	at[59] = 13.9167;
	points[60] = (1335.5236, 4358.5435, 650.6693);
	angles[60] = (0, 0, 0);
	at[60] = 14;
	points[61] = (1335.5236, 4358.5435, 712.7480);
	angles[61] = (0, 0, 0);
	at[61] = 14.0833;
	points[62] = (1335.5236, 4358.5435, 754.9016);
	angles[62] = (0, 0, 0);
	at[62] = 14.1667;
	points[63] = (1335.5236, 4358.5435, 777.1181);
	angles[63] = (0, 0, 0);
	at[63] = 14.2500;
	points[64] = (1335.5236, 4358.5435, 779.4095);
	angles[64] = (0, 0, 0);
	at[64] = 14.3333;
	points[65] = (1335.5236, 4358.5435, 761.7638);
	angles[65] = (0, 0, 0);
	at[65] = 14.4167;
	points[66] = (1335.5236, 4358.5435, 724.1929);
	angles[66] = (0, 0, 0);
	at[66] = 14.5000;
	points[67] = (1335.5236, 4358.5435, 666.6851);
	angles[67] = (0, 0, 0);
	at[67] = 14.5833;
	points[68] = (1335.5236, 4358.5435, 589.2520);
	angles[68] = (0, 0, 0);
	at[68] = 14.6667;
	points[69] = (1322.9528, 4357.5986, 373.0094);
	angles[69] = (0, 0, 0);
	at[69] = 14.7500;
	points[70] = (841.8701, 4316.6533, 383.7244);
	angles[70] = (0, 0, 0);
	at[70] = 15.8333;
	points[71] = (733.1733, 4302.9136, 386.2961);
	angles[71] = (0, 0, 0);
	at[71] = 16.0833;
	points[72] = (697.5512, 4294.2915, 387.3898);
	angles[72] = (0, 0, 0);
	at[72] = 16.1667;
	points[73] = (593.7598, 4255.5908, 391.4146);
	angles[73] = (0, 0, 0);
	at[73] = 16.4167;
	points[74] = (459.3543, 4194.1338, 396.1693);
	angles[74] = (0, 0, 0);
	at[74] = 16.7500;
	points[75] = (222.0784, 4092.3623, 399.5197);
	angles[75] = (0, 0, 0);
	at[75] = 17.3333;
	points[76] = (87.2784, 4030.2361, 400.5670);
	angles[76] = (0, 0, 0);
	at[76] = 17.6667;
	points[77] = (21.6439, 3994.6851, 400.3307);
	angles[77] = (0, 0, 0);
	at[77] = 17.8333;
	points[78] = (-5.4220, 3972.5984, 399.1929);
	angles[78] = (0, 0, 0);
	at[78] = 17.9167;
	points[79] = (-29.5881, 3944.8032, 396.9764);
	angles[79] = (0, 0, 0);
	at[79] = 18;
	points[80] = (-71.1921, 3883.9487, 391.2693);
	angles[80] = (0, 0, 0);
	at[80] = 18.1667;
	points[81] = (-123.5626, 3786.4646, 381.3272);
	angles[81] = (0, 0, 0);
	at[81] = 18.4167;
	points[82] = (-149.3236, 3718.9961, 374.4209);
	angles[82] = (0, 0, 0);
	at[82] = 18.5833;
	points[83] = (-162.2811, 3646.0906, 366.8878);
	angles[83] = (0, 0, 0);
	at[83] = 18.7500;
	points[84] = (-170.7110, 3573.0042, 359.2737);
	angles[84] = (0, 0, 0);
	at[84] = 18.9167;
	points[85] = (-175.9929, 3499.7048, 351.6555);
	angles[85] = (0, 0, 0);
	at[85] = 19.0833;
	points[86] = (-176.1067, 3425.5552, 344.0689);
	angles[86] = (0, 0, 0);
	at[86] = 19.2500;
	points[87] = (-169.6933, 3390.3464, 340.6547);
	angles[87] = (0, 0, 0);
	at[87] = 19.3333;
	points[88] = (-140.0398, 3307.4646, 332.9768);
	angles[88] = (0, 0, 0);
	at[88] = 19.5333;
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
	points[0] = (3419.0552, 2747.5669, 283.2098);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (3406.5078, 2629.7598, 285.9461);
	angles[1] = (0, 0, 0);
	at[1] = 0.2667;
	points[2] = (3404.9961, 2570.7246, 287.5634);
	angles[2] = (0, 0, 0);
	at[2] = 0.4000;
	points[3] = (3409.1968, 2511.3896, 289.6161);
	angles[3] = (0, 0, 0);
	at[3] = 0.5333;
	points[4] = (3416.4058, 2483.9922, 291.0618);
	angles[4] = (0, 0, 0);
	at[4] = 0.6000;
	points[5] = (3436.8347, 2428.4685, 294.9225);
	angles[5] = (0, 0, 0);
	at[5] = 0.7333;
	points[6] = (3473.0396, 2347.4646, 301.0118);
	angles[6] = (0, 0, 0);
	at[6] = 0.9333;
	points[7] = (3516.6733, 2270.1812, 306.8043);
	angles[7] = (0, 0, 0);
	at[7] = 1.1333;
	points[8] = (3553.3740, 2224.0471, 309.9701);
	angles[8] = (0, 0, 0);
	at[8] = 1.2667;
	points[9] = (3575.1418, 2207.1338, 310.8496);
	angles[9] = (0, 0, 0);
	at[9] = 1.3333;
	points[10] = (3602.0117, 2193.2834, 311.3024);
	angles[10] = (0, 0, 0);
	at[10] = 1.4000;
	points[11] = (3711.9805, 2150.0393, 312.0055);
	angles[11] = (0, 0, 0);
	at[11] = 1.6667;
	points[12] = (3910.1064, 2087.2598, 311.9429);
	angles[12] = (0, 0, 0);
	at[12] = 2.1333;
	points[13] = (4054.2913, 2051.1221, 311);
	angles[13] = (0, 0, 0);
	at[13] = 2.4667;
	points[14] = (4073.4250, 2047.8031, 487.8937);
	angles[14] = (0, 0, 0);
	at[14] = 2.5333;
	points[15] = (4073.4250, 2047.8031, 487.8937);
	angles[15] = (0, 0, 0);
	at[15] = 4.1333;
	points[16] = (4073.4250, 2047.8031, 506.6890);
	angles[16] = (0, 0, 0);
	at[16] = 4.2000;
	points[17] = (4073.4250, 2047.8031, 573.8937);
	angles[17] = (0, 0, 0);
	at[17] = 4.2667;
	points[18] = (4073.4250, 2047.8031, 628.3425);
	angles[18] = (0, 0, 0);
	at[18] = 4.3333;
	points[19] = (4073.4250, 2047.8031, 670.0355);
	angles[19] = (0, 0, 0);
	at[19] = 4.4000;
	points[20] = (4073.4250, 2047.8031, 698.9725);
	angles[20] = (0, 0, 0);
	at[20] = 4.4667;
	points[21] = (4073.4250, 2047.8031, 715.1536);
	angles[21] = (0, 0, 0);
	at[21] = 4.5333;
	points[22] = (4073.4250, 2047.8031, 718.5787);
	angles[22] = (0, 0, 0);
	at[22] = 4.6000;
	points[23] = (4073.4250, 2047.8031, 709.2480);
	angles[23] = (0, 0, 0);
	at[23] = 4.6667;
	points[24] = (4073.4250, 2047.8031, 687.1614);
	angles[24] = (0, 0, 0);
	at[24] = 4.7333;
	points[25] = (4073.4250, 2047.8031, 652.3188);
	angles[25] = (0, 0, 0);
	at[25] = 4.8000;
	points[26] = (4073.4250, 2047.8031, 604.7205);
	angles[26] = (0, 0, 0);
	at[26] = 4.8667;
	points[27] = (4073.4250, 2047.8031, 544.3661);
	angles[27] = (0, 0, 0);
	at[27] = 4.9333;
	points[28] = (4073.4250, 2047.8031, 310.7295);
	angles[28] = (0, 0, 0);
	at[28] = 5;
	points[29] = (4130.4727, 2042.1969, 309.3331);
	angles[29] = (0, 0, 0);
	at[29] = 5.1333;
	points[30] = (4219.8423, 2038.4135, 306.4276);
	angles[30] = (0, 0, 0);
	at[30] = 5.3333;
	points[31] = (4397.0474, 2040.6221, 299.9413);
	angles[31] = (0, 0, 0);
	at[31] = 5.7333;
	points[32] = (4514.8428, 2051.3740, 295.4779);
	angles[32] = (0, 0, 0);
	at[32] = 6;
	points[33] = (4573.5825, 2064.0396, 293.3193);
	angles[33] = (0, 0, 0);
	at[33] = 6.1333;
	points[34] = (4598.0317, 2074.5120, 292.4973);
	angles[34] = (0, 0, 0);
	at[34] = 6.2000;
	points[35] = (4647.3623, 2108.1260, 290.9870);
	angles[35] = (0, 0, 0);
	at[35] = 6.3333;
	points[36] = (4715, 2165.6772, 289.0130);
	angles[36] = (0, 0, 0);
	at[36] = 6.5333;
	points[37] = (4779.2124, 2227.3149, 287.1579);
	angles[37] = (0, 0, 0);
	at[37] = 6.7333;
	points[38] = (4860.3940, 2313.8818, 284.7622);
	angles[38] = (0, 0, 0);
	at[38] = 7;
	points[39] = (4933.1890, 2406.1260, 282.3799);
	angles[39] = (0, 0, 0);
	at[39] = 7.2667;
	points[40] = (4948.3862, 2432.2598, 281.7354);
	angles[40] = (0, 0, 0);
	at[40] = 7.3333;
	points[41] = (4957.5195, 2458.7283, 281.1146);
	angles[41] = (0, 0, 0);
	at[41] = 7.4000;
	points[42] = (4963.2285, 2487.4883, 280.4748);
	angles[42] = (0, 0, 0);
	at[42] = 7.4667;
	points[43] = (4970.8662, 2576.2480, 278.5961);
	angles[43] = (0, 0, 0);
	at[43] = 7.6667;
	points[44] = (4970.5513, 2694.9292, 276.2295);
	angles[44] = (0, 0, 0);
	at[44] = 7.9333;
	points[45] = (4962.4014, 2813.0081, 274.0705);
	angles[45] = (0, 0, 0);
	at[45] = 8.2000;
	points[46] = (4954.1733, 2872.2402, 273.1531);
	angles[46] = (0, 0, 0);
	at[46] = 8.3333;
	points[47] = (4947.9526, 2898.8857, 272.8677);
	angles[47] = (0, 0, 0);
	at[47] = 8.4000;
	points[48] = (4915.8267, 2981.7954, 272.7224);
	angles[48] = (0, 0, 0);
	at[48] = 8.6000;
	points[49] = (4876.6929, 3061.7637, 272.9323);
	angles[49] = (0, 0, 0);
	at[49] = 8.8000;
	points[50] = (4832.5200, 3139, 273.2693);
	angles[50] = (0, 0, 0);
	at[50] = 9;
	points[51] = (4781.3779, 3211.6458, 273.6575);
	angles[51] = (0, 0, 0);
	at[51] = 9.2000;
	points[52] = (4761.9688, 3233.1812, 273.7803);
	angles[52] = (0, 0, 0);
	at[52] = 9.2667;
	points[53] = (4739.3701, 3252.2283, 273.8874);
	angles[53] = (0, 0, 0);
	at[53] = 9.3333;
	points[54] = (4687.0869, 3275.9766, 274.0622);
	angles[54] = (0, 0, 0);
	at[54] = 9.4667;
	points[55] = (4630.3936, 3294.1497, 274.2453);
	angles[55] = (0, 0, 0);
	at[55] = 9.6000;
	points[56] = (4543.8188, 3317.0750, 274.5197);
	angles[56] = (0, 0, 0);
	at[56] = 9.8000;
	points[57] = (4428.3862, 3342.9136, 274.8787);
	angles[57] = (0, 0, 0);
	at[57] = 10.0667;
	points[58] = (4311.5356, 3364.9529, 275.2323);
	angles[58] = (0, 0, 0);
	at[58] = 10.3333;
	points[59] = (4223.0708, 3377.7991, 275.4846);
	angles[59] = (0, 0, 0);
	at[59] = 10.5333;
	points[60] = (4209.0947, 3379.1182, 452.6851);
	angles[60] = (0, 0, 0);
	at[60] = 10.6000;
	points[61] = (4209.0947, 3379.1182, 452.6851);
	angles[61] = (0, 0, 0);
	at[61] = 12.2000;
	points[62] = (4209.0947, 3379.1182, 489.4764);
	angles[62] = (0, 0, 0);
	at[62] = 12.2667;
	points[63] = (4209.0947, 3379.1182, 553.4921);
	angles[63] = (0, 0, 0);
	at[63] = 12.3333;
	points[64] = (4209.0947, 3379.1182, 604.7520);
	angles[64] = (0, 0, 0);
	at[64] = 12.4000;
	points[65] = (4209.0947, 3379.1182, 643.2559);
	angles[65] = (0, 0, 0);
	at[65] = 12.4667;
	points[66] = (4209.0947, 3379.1182, 669.0040);
	angles[66] = (0, 0, 0);
	at[66] = 12.5333;
	points[67] = (4209.0947, 3379.1182, 681.9961);
	angles[67] = (0, 0, 0);
	at[67] = 12.6000;
	points[68] = (4209.0947, 3379.1182, 682.2322);
	angles[68] = (0, 0, 0);
	at[68] = 12.6667;
	points[69] = (4209.0947, 3379.1182, 669.7126);
	angles[69] = (0, 0, 0);
	at[69] = 12.7333;
	points[70] = (4209.0947, 3379.1182, 644.4370);
	angles[70] = (0, 0, 0);
	at[70] = 12.8000;
	points[71] = (4209.0947, 3379.1182, 606.4055);
	angles[71] = (0, 0, 0);
	at[71] = 12.8667;
	points[72] = (4209.0947, 3379.1182, 555.6182);
	angles[72] = (0, 0, 0);
	at[72] = 12.9333;
	points[73] = (4209.0947, 3379.1182, 492.0748);
	angles[73] = (0, 0, 0);
	at[73] = 13;
	points[74] = (4202.9526, 3379.5474, 275.5362);
	angles[74] = (0, 0, 0);
	at[74] = 13.0667;
	points[75] = (4144.4883, 3378.8975, 275.6492);
	angles[75] = (0, 0, 0);
	at[75] = 13.2000;
	points[76] = (4055.8660, 3370.7561, 275.7803);
	angles[76] = (0, 0, 0);
	at[76] = 13.4000;
	points[77] = (3938.5828, 3353.4016, 275.9398);
	angles[77] = (0, 0, 0);
	at[77] = 13.6667;
	points[78] = (3851.3113, 3335.7168, 276.0732);
	angles[78] = (0, 0, 0);
	at[78] = 13.8667;
	points[79] = (3793.8899, 3319.5789, 276.1933);
	angles[79] = (0, 0, 0);
	at[79] = 14;
	points[80] = (3768.8623, 3308.2600, 276.2799);
	angles[80] = (0, 0, 0);
	at[80] = 14.0667;
	points[81] = (3720.8464, 3273.3857, 276.5059);
	angles[81] = (0, 0, 0);
	at[81] = 14.2000;
	points[82] = (3676.5945, 3233.5669, 276.7551);
	angles[82] = (0, 0, 0);
	at[82] = 14.3333;
	points[83] = (3614.5354, 3170.1101, 277.1732);
	angles[83] = (0, 0, 0);
	at[83] = 14.5333;
	points[84] = (3539.3269, 3078.8701, 277.9374);
	angles[84] = (0, 0, 0);
	at[84] = 14.8000;
	points[85] = (3512.6694, 3026.8191, 278.6374);
	angles[85] = (0, 0, 0);
	at[85] = 14.9333;
	points[86] = (3479.9766, 2944.4883, 279.8547);
	angles[86] = (0, 0, 0);
	at[86] = 15.1333;
	points[87] = (3441.6812, 2832.1143, 281.6378);
	angles[87] = (0, 0, 0);
	at[87] = 15.4000;
	points[88] = (3419.0552, 2747.5669, 283.2098);
	angles[88] = (0, 0, 0);
	at[88] = 15.6000;
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
	points[0] = (7009.7642, 4141.8506, 636.1614);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (7009.7642, 4141.8506, 682.2953);
	angles[1] = (0, 0, 0);
	at[1] = 0.0833;
	points[2] = (7009.7642, 4141.8506, 708.5040);
	angles[2] = (0, 0, 0);
	at[2] = 0.1667;
	points[3] = (7009.7642, 4141.8506, 714.7756);
	angles[3] = (0, 0, 0);
	at[3] = 0.2500;
	points[4] = (7009.7642, 4141.8506, 701.1221);
	angles[4] = (0, 0, 0);
	at[4] = 0.3333;
	points[5] = (7009.7642, 4141.8506, 667.5315);
	angles[5] = (0, 0, 0);
	at[5] = 0.4167;
	points[6] = (7009.7642, 4141.8506, 614.0157);
	angles[6] = (0, 0, 0);
	at[6] = 0.5000;
	points[7] = (7009.7642, 4141.8506, 540.5630);
	angles[7] = (0, 0, 0);
	at[7] = 0.5833;
	points[8] = (7003.7007, 4140.5513, 306.5394);
	angles[8] = (0, 0, 0);
	at[8] = 0.6667;
	points[9] = (6969.4492, 4127.8345, 304.3918);
	angles[9] = (0, 0, 0);
	at[9] = 0.7500;
	points[10] = (6936.4175, 4110.8267, 302.3516);
	angles[10] = (0, 0, 0);
	at[10] = 0.8333;
	points[11] = (6842.8745, 4051.1418, 296.6311);
	angles[11] = (0, 0, 0);
	at[11] = 1.0833;
	points[12] = (6754.0947, 3984.3704, 291.1996);
	angles[12] = (0, 0, 0);
	at[12] = 1.3333;
	points[13] = (6697.6377, 3935.9331, 287.6976);
	angles[13] = (0, 0, 0);
	at[13] = 1.5000;
	points[14] = (6671.5356, 3909.6025, 286.0205);
	angles[14] = (0, 0, 0);
	at[14] = 1.5833;
	points[15] = (6651.8896, 3880.2007, 284.6402);
	angles[15] = (0, 0, 0);
	at[15] = 1.6667;
	points[16] = (6636.5747, 3846.8149, 283.4760);
	angles[16] = (0, 0, 0);
	at[16] = 1.7500;
	points[17] = (6611.8501, 3776.9568, 281.4425);
	angles[17] = (0, 0, 0);
	at[17] = 1.9167;
	points[18] = (6584.2124, 3669.6064, 278.7669);
	angles[18] = (0, 0, 0);
	at[18] = 2.1667;
	points[19] = (6574.6851, 3595.5908, 277.1437);
	angles[19] = (0, 0, 0);
	at[19] = 2.3333;
	points[20] = (6584.8428, 3562.1497, 276.6366);
	angles[20] = (0, 0, 0);
	at[20] = 2.4167;
	points[21] = (6606.6929, 3531.8228, 276.4339);
	angles[21] = (0, 0, 0);
	at[21] = 2.5000;
	points[22] = (6657.7559, 3478.5000, 276.3291);
	angles[22] = (0, 0, 0);
	at[22] = 2.6667;
	points[23] = (6739.8032, 3404.1064, 276.3307);
	angles[23] = (0, 0, 0);
	at[23] = 2.9167;
	points[24] = (6824.1733, 3332.5393, 276.1098);
	angles[24] = (0, 0, 0);
	at[24] = 3.1667;
	points[25] = (6969.1343, 3217.5198, 275.9102);
	angles[25] = (0, 0, 0);
	at[25] = 3.5833;
	points[26] = (7181.7720, 3070.7798, 276.9646);
	angles[26] = (0, 0, 0);
	at[26] = 4.1667;
	points[27] = (7240.4727, 3026.9172, 277.3575);
	angles[27] = (0, 0, 0);
	at[27] = 4.3333;
	points[28] = (7266.2603, 3001.3228, 277.4921);
	angles[28] = (0, 0, 0);
	at[28] = 4.4167;
	points[29] = (7363.4253, 2889.3230, 277.9563);
	angles[29] = (0, 0, 0);
	at[29] = 4.7500;
	points[30] = (7414.7246, 2836.2837, 278.6118);
	angles[30] = (0, 0, 0);
	at[30] = 4.9167;
	points[31] = (7443.4253, 2812.5237, 279.2488);
	angles[31] = (0, 0, 0);
	at[31] = 5;
	points[32] = (7477.8740, 2793.4763, 280.4071);
	angles[32] = (0, 0, 0);
	at[32] = 5.0833;
	points[33] = (7582.0474, 2753.7874, 284.4685);
	angles[33] = (0, 0, 0);
	at[33] = 5.3333;
	points[34] = (7687.6772, 2719.5195, 288.9299);
	angles[34] = (0, 0, 0);
	at[34] = 5.5833;
	points[35] = (7794.2129, 2689.2009, 293.8661);
	angles[35] = (0, 0, 0);
	at[35] = 5.8333;
	points[36] = (7903.2676, 2665.2954, 299.9091);
	angles[36] = (0, 0, 0);
	at[36] = 6.0833;
	points[37] = (7917.4019, 2663.4370, 478.0433);
	angles[37] = (0, 0, 0);
	at[37] = 6.1667;
	points[38] = (7917.4019, 2663.4370, 478.0433);
	angles[38] = (0, 0, 0);
	at[38] = 7.7500;
	points[39] = (7917.4019, 2663.4370, 532.0354);
	angles[39] = (0, 0, 0);
	at[39] = 7.8333;
	points[40] = (7917.4019, 2663.4370, 606.0748);
	angles[40] = (0, 0, 0);
	at[40] = 7.9167;
	points[41] = (7917.4019, 2663.4370, 660.1851);
	angles[41] = (0, 0, 0);
	at[41] = 8;
	points[42] = (7917.4019, 2663.4370, 694.3622);
	angles[42] = (0, 0, 0);
	at[42] = 8.0833;
	points[43] = (7917.4019, 2663.4370, 708.6102);
	angles[43] = (0, 0, 0);
	at[43] = 8.1667;
	points[44] = (7917.4019, 2663.4370, 702.9252);
	angles[44] = (0, 0, 0);
	at[44] = 8.2500;
	points[45] = (7917.4019, 2663.4370, 677.3110);
	angles[45] = (0, 0, 0);
	at[45] = 8.3333;
	points[46] = (7917.4019, 2663.4370, 631.7638);
	angles[46] = (0, 0, 0);
	at[46] = 8.4167;
	points[47] = (7917.4019, 2663.4370, 566.2874);
	angles[47] = (0, 0, 0);
	at[47] = 8.5000;
	points[48] = (7917.4019, 2663.4370, 480.8780);
	angles[48] = (0, 0, 0);
	at[48] = 8.5833;
	points[49] = (7944.3306, 2661.8267, 303.0020);
	angles[49] = (0, 0, 0);
	at[49] = 8.6667;
	points[50] = (8018.9766, 2663.7754, 309.7094);
	angles[50] = (0, 0, 0);
	at[50] = 8.8333;
	points[51] = (8129.1733, 2672.1101, 320.3287);
	angles[51] = (0, 0, 0);
	at[51] = 9.0833;
	points[52] = (8459.4482, 2710.0825, 354.4598);
	angles[52] = (0, 0, 0);
	at[52] = 9.8333;
	points[53] = (8493.3066, 2714.9568, 358.4260);
	angles[53] = (0, 0, 0);
	at[53] = 9.9167;
	points[54] = (8638.1494, 2739.4211, 378.5417);
	angles[54] = (0, 0, 0);
	at[54] = 10.2500;
	points[55] = (8709.7637, 2755.2952, 389.2473);
	angles[55] = (0, 0, 0);
	at[55] = 10.4167;
	points[56] = (8779.8428, 2776.7600, 399.9961);
	angles[56] = (0, 0, 0);
	at[56] = 10.5833;
	points[57] = (8812.1650, 2792.4211, 405.0473);
	angles[57] = (0, 0, 0);
	at[57] = 10.6667;
	points[58] = (8840.6689, 2814.0471, 409.6299);
	angles[58] = (0, 0, 0);
	at[58] = 10.7500;
	points[59] = (8921.2598, 2889.5750, 423);
	angles[59] = (0, 0, 0);
	at[59] = 11;
	points[60] = (8996.0635, 2970.6575, 435.7677);
	angles[60] = (0, 0, 0);
	at[60] = 11.2500;
	points[61] = (9042.2832, 3028.6221, 443.9489);
	angles[61] = (0, 0, 0);
	at[61] = 11.4167;
	points[62] = (9062.8350, 3059.3779, 447.7795);
	angles[62] = (0, 0, 0);
	at[62] = 11.5000;
	points[63] = (9078.3857, 3092.4568, 451.0591);
	angles[63] = (0, 0, 0);
	at[63] = 11.5833;
	points[64] = (9078.5439, 3127.6064, 452.4528);
	angles[64] = (0, 0, 0);
	at[64] = 11.6667;
	points[65] = (9059.0557, 3199.2087, 452.7677);
	angles[65] = (0, 0, 0);
	at[65] = 11.8333;
	points[66] = (9032.0078, 3267.9214, 451.9922);
	angles[66] = (0, 0, 0);
	at[66] = 12;
	points[67] = (8983.3857, 3367.5947, 449.6220);
	angles[67] = (0, 0, 0);
	at[67] = 12.2500;
	points[68] = (8944.2910, 3430.4688, 446.9685);
	angles[68] = (0, 0, 0);
	at[68] = 12.4167;
	points[69] = (8919.1729, 3455.6694, 444.5748);
	angles[69] = (0, 0, 0);
	at[69] = 12.5000;
	points[70] = (8884.6064, 3469.4451, 440.2795);
	angles[70] = (0, 0, 0);
	at[70] = 12.5833;
	points[71] = (8812.6768, 3482.3269, 430.6299);
	angles[71] = (0, 0, 0);
	at[71] = 12.7500;
	points[72] = (8666.3779, 3491.0984, 410.6417);
	angles[72] = (0, 0, 0);
	at[72] = 13.0833;
	points[73] = (8558.1494, 3490.6104, 396.7402);
	angles[73] = (0, 0, 0);
	at[73] = 13.3333;
	points[74] = (8227.7168, 3466.1497, 355.9197);
	angles[74] = (0, 0, 0);
	at[74] = 14.0833;
	points[75] = (8153.4253, 3466.1536, 347.5555);
	angles[75] = (0, 0, 0);
	at[75] = 14.2500;
	points[76] = (8116.6143, 3469.4727, 343.8181);
	angles[76] = (0, 0, 0);
	at[76] = 14.3333;
	points[77] = (8083.8975, 3478.1025, 341.2016);
	angles[77] = (0, 0, 0);
	at[77] = 14.4167;
	points[78] = (8017.1655, 3511.4214, 337.9524);
	angles[78] = (0, 0, 0);
	at[78] = 14.5833;
	points[79] = (7923.1499, 3570.6694, 335);
	angles[79] = (0, 0, 0);
	at[79] = 14.8333;
	points[80] = (7802.4414, 3656.7283, 332.4008);
	angles[80] = (0, 0, 0);
	at[80] = 15.1667;
	points[81] = (7687.0864, 3749.4290, 330.7496);
	angles[81] = (0, 0, 0);
	at[81] = 15.5000;
	points[82] = (7663.0317, 3775.9922, 330.8248);
	angles[82] = (0, 0, 0);
	at[82] = 15.5833;
	points[83] = (7641.8506, 3806.2361, 331.3803);
	angles[83] = (0, 0, 0);
	at[83] = 15.6667;
	points[84] = (7547.6772, 3965.2756, 335.6059);
	angles[84] = (0, 0, 0);
	at[84] = 16.0833;
	points[85] = (7506.8110, 4026.4568, 336.8732);
	angles[85] = (0, 0, 0);
	at[85] = 16.2500;
	points[86] = (7482.4014, 4054.4883, 337.0146);
	angles[86] = (0, 0, 0);
	at[86] = 16.3333;
	points[87] = (7453.5039, 4074.1733, 336.1996);
	angles[87] = (0, 0, 0);
	at[87] = 16.4167;
	points[88] = (7382.7563, 4097.0474, 332.1496);
	angles[88] = (0, 0, 0);
	at[88] = 16.5833;
	points[89] = (7237.5591, 4126.2993, 322.5413);
	angles[89] = (0, 0, 0);
	at[89] = 16.9167;
	points[90] = (7090.6304, 4143.2285, 312.4118);
	angles[90] = (0, 0, 0);
	at[90] = 17.2500;
	points[91] = (7016.3384, 4142.7954, 307.3559);
	angles[91] = (0, 0, 0);
	at[91] = 17.4167;
	points[92] = (7009.7642, 4141.8506, 484.0945);
	angles[92] = (0, 0, 0);
	at[92] = 17.5000;
	points[93] = (7009.7642, 4141.8506, 484.0945);
	angles[93] = (0, 0, 0);
	at[93] = 19.0833;
	points[94] = (7009.7642, 4141.8506, 624.5394);
	angles[94] = (0, 0, 0);
	at[94] = 19.2500;
	points[95] = (7009.7642, 4141.8506, 636.1614);
	angles[95] = (0, 0, 0);
	at[95] = 19.2667;
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
