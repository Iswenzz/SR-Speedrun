main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_wii_grumble_volcano", 0);

	setExpFog(295.2756, 32375.7363, 0.3608, 0, 0.1294, 0);

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
	ambientPlay("iz_0_n_volcano32", 2);
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
	level.iz_route[level.iz_route.size] = (5415, 11021, 886);
	level.iz_route[level.iz_route.size] = (5488, 9320, 722);
	level.iz_route[level.iz_route.size] = (5562, 8777, 691);
	level.iz_route[level.iz_route.size] = (5606, 8266, 661);
	level.iz_route[level.iz_route.size] = (5664, 7355, 667);
	level.iz_route[level.iz_route.size] = (5503, 6439, 674);
	level.iz_route[level.iz_route.size] = (5408, 5641, 664);
	level.iz_route[level.iz_route.size] = (5465, 4940, 666);
	level.iz_route[level.iz_route.size] = (5490, 4300, 707);
	level.iz_route[level.iz_route.size] = (5345, 3501, 796);
	level.iz_route[level.iz_route.size] = (5509, 2794, 873);
	level.iz_route[level.iz_route.size] = (5959, 1936, 930);
	level.iz_route[level.iz_route.size] = (6159, 1273, 1099);
	level.iz_route[level.iz_route.size] = (6002, 494, 1170);
	level.iz_route[level.iz_route.size] = (5405, 65, 1147);
	level.iz_route[level.iz_route.size] = (4381, -177, 1035);
	level.iz_route[level.iz_route.size] = (3453, -252, 954);
	level.iz_route[level.iz_route.size] = (1305, -186, 700);
	level.iz_route[level.iz_route.size] = (641, -97, 694);
	level.iz_route[level.iz_route.size] = (82, 137, 744);
	level.iz_route[level.iz_route.size] = (-497, 469, 913);
	level.iz_route[level.iz_route.size] = (-987, 682, 1035);
	level.iz_route[level.iz_route.size] = (-1460, 770, 1102);
	level.iz_route[level.iz_route.size] = (-2046, 834, 1133);
	level.iz_route[level.iz_route.size] = (-2634, 898, 1152);
	level.iz_route[level.iz_route.size] = (-3285, 1081, 1166);
	level.iz_route[level.iz_route.size] = (-3732, 1320, 1213);
	level.iz_route[level.iz_route.size] = (-4141, 1732, 1237);
	level.iz_route[level.iz_route.size] = (-4382, 2385, 1258);
	level.iz_route[level.iz_route.size] = (-4344, 3023, 1317);
	level.iz_route[level.iz_route.size] = (-4091, 3593, 1360);
	level.iz_route[level.iz_route.size] = (-3678, 3941, 1369);
	level.iz_route[level.iz_route.size] = (-3087, 4076, 1370);
	level.iz_route[level.iz_route.size] = (-2452, 4111, 1429);
	level.iz_route[level.iz_route.size] = (-1480, 4172, 1492);
	level.iz_route[level.iz_route.size] = (-1054, 4388, 1548);
	level.iz_route[level.iz_route.size] = (-738, 4861, 1524);
	level.iz_route[level.iz_route.size] = (-675, 5345, 1366);
	level.iz_route[level.iz_route.size] = (-992, 6178, 1223);
	level.iz_route[level.iz_route.size] = (-1315, 6696, 1107);
	level.iz_route[level.iz_route.size] = (-1839, 7518, 1100);
	level.iz_route[level.iz_route.size] = (-2120, 8310, 1055);
	level.iz_route[level.iz_route.size] = (-2230, 9402, 856);
	level.iz_route[level.iz_route.size] = (-2229, 10709, 753);
	level.iz_route[level.iz_route.size] = (-2282, 12136, 635);
	level.iz_route[level.iz_route.size] = (-2308, 13647, 532);
	level.iz_route[level.iz_route.size] = (-1975, 14779, 525);
	level.iz_route[level.iz_route.size] = (-2046, 15610, 562);
	level.iz_route[level.iz_route.size] = (-2299, 16437, 660);
	level.iz_route[level.iz_route.size] = (-2686, 17070, 683);
	level.iz_route[level.iz_route.size] = (-3078, 17536, 743);
	level.iz_route[level.iz_route.size] = (-4151, 18053, 562);
	level.iz_route[level.iz_route.size] = (-4683, 18855, 670);
	level.iz_route[level.iz_route.size] = (-5137, 19888, 841);
	level.iz_route[level.iz_route.size] = (-5006, 20369, 860);
	level.iz_route[level.iz_route.size] = (-4928, 20856, 885);
	level.iz_route[level.iz_route.size] = (-4742, 21313, 894);
	level.iz_route[level.iz_route.size] = (-4544, 21705, 885);
	level.iz_route[level.iz_route.size] = (-4262, 22686, 898);
	level.iz_route[level.iz_route.size] = (-3366, 23204, 857);
	level.iz_route[level.iz_route.size] = (-2106, 23080, 859);
	level.iz_route[level.iz_route.size] = (-1140, 22460, 831);
	level.iz_route[level.iz_route.size] = (352, 20886, 718);
	level.iz_route[level.iz_route.size] = (836, 19987, 674);
	level.iz_route[level.iz_route.size] = (1127, 19128, 736);
	level.iz_route[level.iz_route.size] = (1103, 18293, 864);
	level.iz_route[level.iz_route.size] = (1148, 17468, 1000);
	level.iz_route[level.iz_route.size] = (1487, 17110, 1033);
	level.iz_route[level.iz_route.size] = (2005, 16961, 955);
	level.iz_route[level.iz_route.size] = (2671, 16906, 1038);
	level.iz_route[level.iz_route.size] = (3454, 16866, 898);
	level.iz_route[level.iz_route.size] = (4458, 16759, 1093);
	level.iz_route[level.iz_route.size] = (5081, 16402, 1121);
	level.iz_route[level.iz_route.size] = (5287, 15993, 1083);
	level.iz_route[level.iz_route.size] = (5391, 15502, 1038);
	level.iz_route[level.iz_route.size] = (5459, 14406, 1076);
	level.iz_route[level.iz_route.size] = (5493, 13297, 886);
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
	thread iz_obj_13();
	thread iz_obj_14();
	thread iz_obj_15();
	thread iz_obj_16();
	thread iz_obj_17();
	thread iz_obj_18();
	thread iz_obj_19();
	thread iz_obj_20();
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-3651.3071, 42655.1172, 6510.3936);
	angles[0] = (0, 175.5394, 0);
	at[0] = 0;
	points[1] = (-3651.3071, 42655.1172, 6510.3936);
	angles[1] = (0, 175.5394, 0);
	at[1] = 25.2000;
	points[2] = (-3661.5630, 42525.1992, 6705.3940);
	angles[2] = (0, 175.5883, 0);
	at[2] = 25.4000;
	points[3] = (-3682.1577, 42137.4023, 7207.1265);
	angles[3] = (0, 177.7437, 0);
	at[3] = 25.6000;
	points[4] = (-3697.3230, 41720.8633, 7551.1416);
	angles[4] = (0, 177.7871, 0);
	at[4] = 25.8000;
	points[5] = (-3712.2991, 41296.8477, 7756.9683);
	angles[5] = (0, 178.3039, 0);
	at[5] = 26;
	points[6] = (-3724.0276, 40892.5234, 7883.6221);
	angles[6] = (0, 178.1653, 0);
	at[6] = 26.2000;
	points[7] = (-3736.5630, 40497.6406, 7899.4883);
	angles[7] = (0, 178.2185, 0);
	at[7] = 26.4000;
	points[8] = (-3747.8464, 40098.0312, 7842.7168);
	angles[8] = (0, 178.7507, 0);
	at[8] = 26.6000;
	points[9] = (-3757.0356, 39681.8906, 7760.7480);
	angles[9] = (0, 178.5770, 0);
	at[9] = 26.8000;
	points[10] = (-3769.3782, 39251.5352, 7624.1338);
	angles[10] = (0, 178.3053, 0);
	at[10] = 27;
	points[11] = (-3783.2717, 38784.3320, 7466.3779);
	angles[11] = (0, 178.2926, 0);
	at[11] = 27.2000;
	points[12] = (-3798.0671, 38284.4492, 7298.9375);
	angles[12] = (0, 178.3106, 0);
	at[12] = 27.4000;
	points[13] = (-3813.9526, 37745.9062, 7119.7246);
	angles[13] = (0, 178.3106, 0);
	at[13] = 27.6000;
	points[14] = (-3830.9961, 37167.9922, 6927.3623);
	angles[14] = (0, 178.3105, 0);
	at[14] = 27.8000;
	points[15] = (-3849.0513, 36555.7891, 6723.6221);
	angles[15] = (0, 178.3106, 0);
	at[15] = 28;
	points[16] = (-3868.1418, 35908.5430, 6508.1890);
	angles[16] = (0, 178.3106, 0);
	at[16] = 28.2000;
	points[17] = (-3888.4883, 35218.7422, 6278.6226);
	angles[17] = (0, 178.3106, 0);
	at[17] = 28.4000;
	points[18] = (-3909.7915, 34496.3789, 6038.1890);
	angles[18] = (0, 178.3106, 0);
	at[18] = 28.6000;
	points[19] = (-3932.1575, 33738.1094, 5785.8271);
	angles[19] = (0, 178.3106, 0);
	at[19] = 28.8000;
	points[20] = (-3955.7480, 32937.8320, 5519.4888);
	angles[20] = (0, 178.3105, 0);
	at[20] = 29;
	points[21] = (-3980.3149, 32105.2754, 5242.4014);
	angles[21] = (0, 178.3105, 0);
	at[21] = 29.2000;
	points[22] = (-4005.9844, 31235.2363, 4952.8350);
	angles[22] = (0, 178.3106, 0);
	at[22] = 29.4000;
	points[23] = (-4032.7559, 30327.6387, 4650.7480);
	angles[23] = (0, 178.3106, 0);
	at[23] = 29.6000;
	points[24] = (-4060.5906, 29383.7812, 4336.6143);
	angles[24] = (0, 178.3106, 0);
	at[24] = 29.8000;
	points[25] = (-4089.6064, 28402.1270, 4010.2756);
	angles[25] = (0, 178.2991, 0);
	at[25] = 30;
	points[26] = (-4118.1104, 27385.0781, 3665.1536);
	angles[26] = (0, 178.4338, 0);
	at[26] = 30.2000;
	points[27] = (-4146.9688, 26333.1113, 3305.4055);
	angles[27] = (0, 178.4277, 0);
	at[27] = 30.4000;
	points[28] = (-4176.9688, 25240.4336, 2931.8860);
	angles[28] = (0, 178.4278, 0);
	at[28] = 30.6000;
	points[29] = (-4207.8740, 24114.4883, 2547);
	angles[29] = (0, 178.4277, 0);
	at[29] = 30.8000;
	points[30] = (-4239.8818, 22947.4414, 2148.0513);
	angles[30] = (0, 178.4277, 0);
	at[30] = 31;
	points[31] = (-4272.8740, 21746.4570, 1737.5118);
	angles[31] = (0, 178.4277, 0);
	at[31] = 31.2000;
	points[32] = (-4306.9292, 20504.3301, 1312.9133);
	angles[32] = (0, 178.4277, 0);
	at[32] = 31.4000;
	points[33] = (-4342.0869, 19223.8594, 875.1968);
	angles[33] = (0, 178.4277, 0);
	at[33] = 31.6000;
	points[34] = (-4354.0161, 18789.4102, 726.6851);
	angles[34] = (0, 178.4277, 0);
	at[34] = 31.8000;
	points[35] = (-4354.0161, 18789.4102, 726.6851);
	angles[35] = (0, 178.4277, 0);
	at[35] = 41.6833;
	points[36] = (-3651.3071, 42655.1172, 6510.3936);
	angles[36] = (0, 175.5394, 0);
	at[36] = 41.6833;
	points[37] = (-3651.3071, 42655.1172, 6510.3936);
	angles[37] = (0, 175.5394, 0);
	at[37] = 45;
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
	points[0] = (-4089.6064, 28402.1270, 4010.2756);
	angles[0] = (0, 178.2991, 0);
	at[0] = 0;
	points[1] = (-4118.1104, 27385.0781, 3665.1536);
	angles[1] = (0, 178.4338, 0);
	at[1] = 0.2000;
	points[2] = (-4146.9688, 26333.1113, 3305.4055);
	angles[2] = (0, 178.4277, 0);
	at[2] = 0.4000;
	points[3] = (-4176.9688, 25240.4336, 2931.8860);
	angles[3] = (0, 178.4278, 0);
	at[3] = 0.6000;
	points[4] = (-4207.8740, 24114.4883, 2547);
	angles[4] = (0, 178.4277, 0);
	at[4] = 0.8000;
	points[5] = (-4239.8818, 22947.4414, 2148.0513);
	angles[5] = (0, 178.4277, 0);
	at[5] = 1;
	points[6] = (-4272.8740, 21746.4570, 1737.5118);
	angles[6] = (0, 178.4277, 0);
	at[6] = 1.2000;
	points[7] = (-4306.9292, 20504.3301, 1312.9133);
	angles[7] = (0, 178.4277, 0);
	at[7] = 1.4000;
	points[8] = (-4342.0869, 19223.8594, 875.1968);
	angles[8] = (0, 178.4277, 0);
	at[8] = 1.6000;
	points[9] = (-4354.0161, 18789.4102, 726.6851);
	angles[9] = (0, 178.4277, 0);
	at[9] = 1.8000;
	points[10] = (-4354.0161, 18789.4102, 726.6851);
	angles[10] = (0, 178.4277, 0);
	at[10] = 11.6833;
	points[11] = (-3651.3071, 42655.1172, 6510.3936);
	angles[11] = (0, 175.5394, 0);
	at[11] = 11.6833;
	points[12] = (-3651.3071, 42655.1172, 6510.3936);
	angles[12] = (0, 175.5394, 0);
	at[12] = 40.2000;
	points[13] = (-3661.5630, 42525.1992, 6705.3940);
	angles[13] = (0, 175.5883, 0);
	at[13] = 40.4000;
	points[14] = (-3682.1577, 42137.4023, 7207.1265);
	angles[14] = (0, 177.7437, 0);
	at[14] = 40.6000;
	points[15] = (-3697.3230, 41720.8633, 7551.1416);
	angles[15] = (0, 177.7871, 0);
	at[15] = 40.8000;
	points[16] = (-3712.2991, 41296.8477, 7756.9683);
	angles[16] = (0, 178.3039, 0);
	at[16] = 41;
	points[17] = (-3724.0276, 40892.5234, 7883.6221);
	angles[17] = (0, 178.1653, 0);
	at[17] = 41.2000;
	points[18] = (-3736.5630, 40497.6406, 7899.4883);
	angles[18] = (0, 178.2185, 0);
	at[18] = 41.4000;
	points[19] = (-3747.8464, 40098.0312, 7842.7168);
	angles[19] = (0, 178.7507, 0);
	at[19] = 41.6000;
	points[20] = (-3757.0356, 39681.8906, 7760.7480);
	angles[20] = (0, 178.5770, 0);
	at[20] = 41.8000;
	points[21] = (-3769.3782, 39251.5352, 7624.1338);
	angles[21] = (0, 178.3053, 0);
	at[21] = 42;
	points[22] = (-3783.2717, 38784.3320, 7466.3779);
	angles[22] = (0, 178.2926, 0);
	at[22] = 42.2000;
	points[23] = (-3798.0671, 38284.4492, 7298.9375);
	angles[23] = (0, 178.3106, 0);
	at[23] = 42.4000;
	points[24] = (-3813.9526, 37745.9062, 7119.7246);
	angles[24] = (0, 178.3106, 0);
	at[24] = 42.6000;
	points[25] = (-3830.9961, 37167.9922, 6927.3623);
	angles[25] = (0, 178.3105, 0);
	at[25] = 42.8000;
	points[26] = (-3849.0513, 36555.7891, 6723.6221);
	angles[26] = (0, 178.3106, 0);
	at[26] = 43;
	points[27] = (-3868.1418, 35908.5430, 6508.1890);
	angles[27] = (0, 178.3106, 0);
	at[27] = 43.2000;
	points[28] = (-3888.4883, 35218.7422, 6278.6226);
	angles[28] = (0, 178.3106, 0);
	at[28] = 43.4000;
	points[29] = (-3909.7915, 34496.3789, 6038.1890);
	angles[29] = (0, 178.3106, 0);
	at[29] = 43.6000;
	points[30] = (-3932.1575, 33738.1094, 5785.8271);
	angles[30] = (0, 178.3106, 0);
	at[30] = 43.8000;
	points[31] = (-3955.7480, 32937.8320, 5519.4888);
	angles[31] = (0, 178.3105, 0);
	at[31] = 44;
	points[32] = (-3980.3149, 32105.2754, 5242.4014);
	angles[32] = (0, 178.3105, 0);
	at[32] = 44.2000;
	points[33] = (-4005.9844, 31235.2363, 4952.8350);
	angles[33] = (0, 178.3106, 0);
	at[33] = 44.4000;
	points[34] = (-4032.7559, 30327.6387, 4650.7480);
	angles[34] = (0, 178.3106, 0);
	at[34] = 44.6000;
	points[35] = (-4060.5906, 29383.7812, 4336.6143);
	angles[35] = (0, 178.3106, 0);
	at[35] = 44.8000;
	points[36] = (-4089.6064, 28402.1270, 4010.2756);
	angles[36] = (0, 178.2991, 0);
	at[36] = 45;
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
	points[0] = (-3651.3071, 42655.1172, 6510.3936);
	angles[0] = (0, 175.5394, 0);
	at[0] = 0;
	points[1] = (-3651.3071, 42655.1172, 6510.3936);
	angles[1] = (0, 175.5394, 0);
	at[1] = 10.2000;
	points[2] = (-3661.5630, 42525.1992, 6705.3940);
	angles[2] = (0, 175.5883, 0);
	at[2] = 10.4000;
	points[3] = (-3682.1577, 42137.4023, 7207.1265);
	angles[3] = (0, 177.7437, 0);
	at[3] = 10.6000;
	points[4] = (-3697.3230, 41720.8633, 7551.1416);
	angles[4] = (0, 177.7871, 0);
	at[4] = 10.8000;
	points[5] = (-3712.2991, 41296.8477, 7756.9683);
	angles[5] = (0, 178.3039, 0);
	at[5] = 11;
	points[6] = (-3724.0276, 40892.5234, 7883.6221);
	angles[6] = (0, 178.1653, 0);
	at[6] = 11.2000;
	points[7] = (-3736.5630, 40497.6406, 7899.4883);
	angles[7] = (0, 178.2185, 0);
	at[7] = 11.4000;
	points[8] = (-3747.8464, 40098.0312, 7842.7168);
	angles[8] = (0, 178.7507, 0);
	at[8] = 11.6000;
	points[9] = (-3757.0356, 39681.8906, 7760.7480);
	angles[9] = (0, 178.5770, 0);
	at[9] = 11.8000;
	points[10] = (-3769.3782, 39251.5352, 7624.1338);
	angles[10] = (0, 178.3053, 0);
	at[10] = 12;
	points[11] = (-3783.2717, 38784.3320, 7466.3779);
	angles[11] = (0, 178.2926, 0);
	at[11] = 12.2000;
	points[12] = (-3798.0671, 38284.4492, 7298.9375);
	angles[12] = (0, 178.3106, 0);
	at[12] = 12.4000;
	points[13] = (-3813.9526, 37745.9062, 7119.7246);
	angles[13] = (0, 178.3106, 0);
	at[13] = 12.6000;
	points[14] = (-3830.9961, 37167.9922, 6927.3623);
	angles[14] = (0, 178.3105, 0);
	at[14] = 12.8000;
	points[15] = (-3849.0513, 36555.7891, 6723.6221);
	angles[15] = (0, 178.3106, 0);
	at[15] = 13;
	points[16] = (-3868.1418, 35908.5430, 6508.1890);
	angles[16] = (0, 178.3106, 0);
	at[16] = 13.2000;
	points[17] = (-3888.4883, 35218.7422, 6278.6226);
	angles[17] = (0, 178.3106, 0);
	at[17] = 13.4000;
	points[18] = (-3909.7915, 34496.3789, 6038.1890);
	angles[18] = (0, 178.3106, 0);
	at[18] = 13.6000;
	points[19] = (-3932.1575, 33738.1094, 5785.8271);
	angles[19] = (0, 178.3106, 0);
	at[19] = 13.8000;
	points[20] = (-3955.7480, 32937.8320, 5519.4888);
	angles[20] = (0, 178.3105, 0);
	at[20] = 14;
	points[21] = (-3980.3149, 32105.2754, 5242.4014);
	angles[21] = (0, 178.3105, 0);
	at[21] = 14.2000;
	points[22] = (-4005.9844, 31235.2363, 4952.8350);
	angles[22] = (0, 178.3106, 0);
	at[22] = 14.4000;
	points[23] = (-4032.7559, 30327.6387, 4650.7480);
	angles[23] = (0, 178.3106, 0);
	at[23] = 14.6000;
	points[24] = (-4060.5906, 29383.7812, 4336.6143);
	angles[24] = (0, 178.3106, 0);
	at[24] = 14.8000;
	points[25] = (-4089.6064, 28402.1270, 4010.2756);
	angles[25] = (0, 178.2991, 0);
	at[25] = 15;
	points[26] = (-4118.1104, 27385.0781, 3665.1536);
	angles[26] = (0, 178.4338, 0);
	at[26] = 15.2000;
	points[27] = (-4146.9688, 26333.1113, 3305.4055);
	angles[27] = (0, 178.4277, 0);
	at[27] = 15.4000;
	points[28] = (-4176.9688, 25240.4336, 2931.8860);
	angles[28] = (0, 178.4278, 0);
	at[28] = 15.6000;
	points[29] = (-4207.8740, 24114.4883, 2547);
	angles[29] = (0, 178.4277, 0);
	at[29] = 15.8000;
	points[30] = (-4239.8818, 22947.4414, 2148.0513);
	angles[30] = (0, 178.4277, 0);
	at[30] = 16;
	points[31] = (-4272.8740, 21746.4570, 1737.5118);
	angles[31] = (0, 178.4277, 0);
	at[31] = 16.2000;
	points[32] = (-4306.9292, 20504.3301, 1312.9133);
	angles[32] = (0, 178.4277, 0);
	at[32] = 16.4000;
	points[33] = (-4342.0869, 19223.8594, 875.1968);
	angles[33] = (0, 178.4277, 0);
	at[33] = 16.6000;
	points[34] = (-4354.0161, 18789.4102, 726.6851);
	angles[34] = (0, 178.4277, 0);
	at[34] = 16.8000;
	points[35] = (-4354.0161, 18789.4102, 726.6851);
	angles[35] = (0, 178.4277, 0);
	at[35] = 26.6833;
	points[36] = (-3651.3071, 42655.1172, 6510.3936);
	angles[36] = (0, 175.5394, 0);
	at[36] = 26.6833;
	points[37] = (-3651.3071, 42655.1172, 6510.3936);
	angles[37] = (0, 175.5394, 0);
	at[37] = 45;
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
	points[0] = (-5478.8188, 21970.0391, 1343.4724);
	angles[0] = (0, 175.5580, 0);
	at[0] = 0;
	points[1] = (-5478.8188, 21970.0391, 1343.4724);
	angles[1] = (0, 175.5580, 0);
	at[1] = 1.1167;
	points[2] = (-3860.8662, 42728.3477, 6467.9922);
	angles[2] = (0, 171.7126, 0);
	at[2] = 1.1167;
	points[3] = (-3860.8662, 42728.3477, 6467.9922);
	angles[3] = (0, 171.7126, 0);
	at[3] = 30.2000;
	points[4] = (-3885.8464, 42559.8438, 6629.8032);
	angles[4] = (0, 171.6047, 0);
	at[4] = 30.4000;
	points[5] = (-3949.1338, 42043.7031, 7045.1182);
	angles[5] = (0, 173.7321, 0);
	at[5] = 30.6000;
	points[6] = (-4006.6929, 41501.9688, 7336.1812);
	angles[6] = (0, 174.1960, 0);
	at[6] = 30.8000;
	points[7] = (-4061.2205, 40962.5977, 7540.7085);
	angles[7] = (0, 174.2381, 0);
	at[7] = 31;
	points[8] = (-4116.2207, 40433.4648, 7690.9058);
	angles[8] = (0, 174.0101, 0);
	at[8] = 31.2000;
	points[9] = (-4164.9214, 39914.5664, 7791.4170);
	angles[9] = (0, 174.9057, 0);
	at[9] = 31.4000;
	points[10] = (-4213.9370, 39399.6055, 7819.2520);
	angles[10] = (0, 174.6028, 0);
	at[10] = 31.6000;
	points[11] = (-4251.2207, 38886.0234, 7756.7720);
	angles[11] = (0, 176.4542, 0);
	at[11] = 31.8000;
	points[12] = (-4282.9531, 38367.1641, 7636.1812);
	angles[12] = (0, 176.5419, 0);
	at[12] = 32;
	points[13] = (-4315.7480, 37837.5195, 7477.6382);
	angles[13] = (0, 176.1797, 0);
	at[13] = 32.2000;
	points[14] = (-4352.6772, 37295.3555, 7259.9209);
	angles[14] = (0, 176.0823, 0);
	at[14] = 32.4000;
	points[15] = (-4391.4565, 36724.1367, 7034.0161);
	angles[15] = (0, 176.1230, 0);
	at[15] = 32.6000;
	points[16] = (-4432.1655, 36123.6211, 6798.2676);
	angles[16] = (0, 176.1224, 0);
	at[16] = 32.8000;
	points[17] = (-4475, 35491.6133, 6550);
	angles[17] = (0, 176.1223, 0);
	at[17] = 33;
	points[18] = (-4519.6851, 34832.4805, 6291.0630);
	angles[18] = (0, 176.1225, 0);
	at[18] = 33.2000;
	points[19] = (-4566.3779, 34143.2695, 6020.3149);
	angles[19] = (0, 176.1223, 0);
	at[19] = 33.4000;
	points[20] = (-4615.0786, 33425.2773, 5738.2676);
	angles[20] = (0, 176.1224, 0);
	at[20] = 33.6000;
	points[21] = (-4665.7480, 32677.6777, 5444.5674);
	angles[21] = (0, 176.1225, 0);
	at[21] = 33.8000;
	points[22] = (-4718.3857, 31900.7090, 5139.3311);
	angles[22] = (0, 176.1224, 0);
	at[22] = 34;
	points[23] = (-4772.7954, 31093.8203, 4822.0078);
	angles[23] = (0, 176.1798, 0);
	at[23] = 34.2000;
	points[24] = (-4835.1182, 30255.5527, 4499.3306);
	angles[24] = (0, 175.5260, 0);
	at[24] = 34.4000;
	points[25] = (-4902.5591, 29388.7012, 4169.2915);
	angles[25] = (0, 175.5584, 0);
	at[25] = 34.6000;
	points[26] = (-4972.1655, 28492.9121, 3828.0828);
	angles[26] = (0, 175.5584, 0);
	at[26] = 34.8000;
	points[27] = (-5043.9766, 27568.1895, 3475.8503);
	angles[27] = (0, 175.5584, 0);
	at[27] = 35;
	points[28] = (-5118.0708, 26614.4082, 3112.5474);
	angles[28] = (0, 175.5584, 0);
	at[28] = 35.2000;
	points[29] = (-5194.1733, 25634.8438, 2739.4250);
	angles[29] = (0, 175.5584, 0);
	at[29] = 35.4000;
	points[30] = (-5272.7954, 24622.6777, 2353.8896);
	angles[30] = (0, 175.5585, 0);
	at[30] = 35.6000;
	points[31] = (-5353.6221, 23581.8887, 1957.4370);
	angles[31] = (0, 175.5584, 0);
	at[31] = 35.8000;
	points[32] = (-5436.4966, 22514.7637, 1550.9607);
	angles[32] = (0, 175.5582, 0);
	at[32] = 36;
	points[33] = (-5478.8188, 21970.0391, 1343.4724);
	angles[33] = (0, 175.5580, 0);
	at[33] = 36.2000;
	points[34] = (-5478.8188, 21970.0391, 1343.4724);
	angles[34] = (0, 175.5580, 0);
	at[34] = 45;
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
	points[0] = (-3860.8662, 42728.3477, 6467.9922);
	angles[0] = (0, 171.7126, 0);
	at[0] = 0;
	points[1] = (-3860.8662, 42728.3477, 6467.9922);
	angles[1] = (0, 171.7126, 0);
	at[1] = 0.2000;
	points[2] = (-3885.8464, 42559.8438, 6629.8032);
	angles[2] = (0, 171.6047, 0);
	at[2] = 0.4000;
	points[3] = (-3949.1338, 42043.7031, 7045.1182);
	angles[3] = (0, 173.7321, 0);
	at[3] = 0.6000;
	points[4] = (-4006.6929, 41501.9688, 7336.1812);
	angles[4] = (0, 174.1960, 0);
	at[4] = 0.8000;
	points[5] = (-4061.2205, 40962.5977, 7540.7085);
	angles[5] = (0, 174.2381, 0);
	at[5] = 1;
	points[6] = (-4116.2207, 40433.4648, 7690.9058);
	angles[6] = (0, 174.0101, 0);
	at[6] = 1.2000;
	points[7] = (-4164.9214, 39914.5664, 7791.4170);
	angles[7] = (0, 174.9057, 0);
	at[7] = 1.4000;
	points[8] = (-4213.9370, 39399.6055, 7819.2520);
	angles[8] = (0, 174.6028, 0);
	at[8] = 1.6000;
	points[9] = (-4251.2207, 38886.0234, 7756.7720);
	angles[9] = (0, 176.4542, 0);
	at[9] = 1.8000;
	points[10] = (-4282.9531, 38367.1641, 7636.1812);
	angles[10] = (0, 176.5419, 0);
	at[10] = 2;
	points[11] = (-4315.7480, 37837.5195, 7477.6382);
	angles[11] = (0, 176.1797, 0);
	at[11] = 2.2000;
	points[12] = (-4352.6772, 37295.3555, 7259.9209);
	angles[12] = (0, 176.0823, 0);
	at[12] = 2.4000;
	points[13] = (-4391.4565, 36724.1367, 7034.0161);
	angles[13] = (0, 176.1230, 0);
	at[13] = 2.6000;
	points[14] = (-4432.1655, 36123.6211, 6798.2676);
	angles[14] = (0, 176.1224, 0);
	at[14] = 2.8000;
	points[15] = (-4475, 35491.6133, 6550);
	angles[15] = (0, 176.1223, 0);
	at[15] = 3;
	points[16] = (-4519.6851, 34832.4805, 6291.0630);
	angles[16] = (0, 176.1225, 0);
	at[16] = 3.2000;
	points[17] = (-4566.3779, 34143.2695, 6020.3149);
	angles[17] = (0, 176.1223, 0);
	at[17] = 3.4000;
	points[18] = (-4615.0786, 33425.2773, 5738.2676);
	angles[18] = (0, 176.1224, 0);
	at[18] = 3.6000;
	points[19] = (-4665.7480, 32677.6777, 5444.5674);
	angles[19] = (0, 176.1225, 0);
	at[19] = 3.8000;
	points[20] = (-4718.3857, 31900.7090, 5139.3311);
	angles[20] = (0, 176.1224, 0);
	at[20] = 4;
	points[21] = (-4772.7954, 31093.8203, 4822.0078);
	angles[21] = (0, 176.1798, 0);
	at[21] = 4.2000;
	points[22] = (-4835.1182, 30255.5527, 4499.3306);
	angles[22] = (0, 175.5260, 0);
	at[22] = 4.4000;
	points[23] = (-4902.5591, 29388.7012, 4169.2915);
	angles[23] = (0, 175.5584, 0);
	at[23] = 4.6000;
	points[24] = (-4972.1655, 28492.9121, 3828.0828);
	angles[24] = (0, 175.5584, 0);
	at[24] = 4.8000;
	points[25] = (-5043.9766, 27568.1895, 3475.8503);
	angles[25] = (0, 175.5584, 0);
	at[25] = 5;
	points[26] = (-5118.0708, 26614.4082, 3112.5474);
	angles[26] = (0, 175.5584, 0);
	at[26] = 5.2000;
	points[27] = (-5194.1733, 25634.8438, 2739.4250);
	angles[27] = (0, 175.5584, 0);
	at[27] = 5.4000;
	points[28] = (-5272.7954, 24622.6777, 2353.8896);
	angles[28] = (0, 175.5585, 0);
	at[28] = 5.6000;
	points[29] = (-5353.6221, 23581.8887, 1957.4370);
	angles[29] = (0, 175.5584, 0);
	at[29] = 5.8000;
	points[30] = (-5436.4966, 22514.7637, 1550.9607);
	angles[30] = (0, 175.5582, 0);
	at[30] = 6;
	points[31] = (-5478.8188, 21970.0391, 1343.4724);
	angles[31] = (0, 175.5580, 0);
	at[31] = 6.2000;
	points[32] = (-5478.8188, 21970.0391, 1343.4724);
	angles[32] = (0, 175.5580, 0);
	at[32] = 16.1167;
	points[33] = (-3860.8662, 42728.3477, 6467.9922);
	angles[33] = (0, 171.7126, 0);
	at[33] = 16.1167;
	points[34] = (-3860.8662, 42728.3477, 6467.9922);
	angles[34] = (0, 171.7126, 0);
	at[34] = 45;
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
	points[0] = (-3860.8662, 42728.3477, 6467.9922);
	angles[0] = (0, 171.7126, 0);
	at[0] = 0;
	points[1] = (-3860.8662, 42728.3477, 6467.9922);
	angles[1] = (0, 171.7126, 0);
	at[1] = 15.2000;
	points[2] = (-3885.8464, 42559.8438, 6629.8032);
	angles[2] = (0, 171.6047, 0);
	at[2] = 15.4000;
	points[3] = (-3949.1338, 42043.7031, 7045.1182);
	angles[3] = (0, 173.7321, 0);
	at[3] = 15.6000;
	points[4] = (-4006.6929, 41501.9688, 7336.1812);
	angles[4] = (0, 174.1960, 0);
	at[4] = 15.8000;
	points[5] = (-4061.2205, 40962.5977, 7540.7085);
	angles[5] = (0, 174.2381, 0);
	at[5] = 16;
	points[6] = (-4116.2207, 40433.4648, 7690.9058);
	angles[6] = (0, 174.0101, 0);
	at[6] = 16.2000;
	points[7] = (-4164.9214, 39914.5664, 7791.4170);
	angles[7] = (0, 174.9057, 0);
	at[7] = 16.4000;
	points[8] = (-4213.9370, 39399.6055, 7819.2520);
	angles[8] = (0, 174.6028, 0);
	at[8] = 16.6000;
	points[9] = (-4251.2207, 38886.0234, 7756.7720);
	angles[9] = (0, 176.4542, 0);
	at[9] = 16.8000;
	points[10] = (-4282.9531, 38367.1641, 7636.1812);
	angles[10] = (0, 176.5419, 0);
	at[10] = 17;
	points[11] = (-4315.7480, 37837.5195, 7477.6382);
	angles[11] = (0, 176.1797, 0);
	at[11] = 17.2000;
	points[12] = (-4352.6772, 37295.3555, 7259.9209);
	angles[12] = (0, 176.0823, 0);
	at[12] = 17.4000;
	points[13] = (-4391.4565, 36724.1367, 7034.0161);
	angles[13] = (0, 176.1230, 0);
	at[13] = 17.6000;
	points[14] = (-4432.1655, 36123.6211, 6798.2676);
	angles[14] = (0, 176.1224, 0);
	at[14] = 17.8000;
	points[15] = (-4475, 35491.6133, 6550);
	angles[15] = (0, 176.1223, 0);
	at[15] = 18;
	points[16] = (-4519.6851, 34832.4805, 6291.0630);
	angles[16] = (0, 176.1225, 0);
	at[16] = 18.2000;
	points[17] = (-4566.3779, 34143.2695, 6020.3149);
	angles[17] = (0, 176.1223, 0);
	at[17] = 18.4000;
	points[18] = (-4615.0786, 33425.2773, 5738.2676);
	angles[18] = (0, 176.1224, 0);
	at[18] = 18.6000;
	points[19] = (-4665.7480, 32677.6777, 5444.5674);
	angles[19] = (0, 176.1225, 0);
	at[19] = 18.8000;
	points[20] = (-4718.3857, 31900.7090, 5139.3311);
	angles[20] = (0, 176.1224, 0);
	at[20] = 19;
	points[21] = (-4772.7954, 31093.8203, 4822.0078);
	angles[21] = (0, 176.1798, 0);
	at[21] = 19.2000;
	points[22] = (-4835.1182, 30255.5527, 4499.3306);
	angles[22] = (0, 175.5260, 0);
	at[22] = 19.4000;
	points[23] = (-4902.5591, 29388.7012, 4169.2915);
	angles[23] = (0, 175.5584, 0);
	at[23] = 19.6000;
	points[24] = (-4972.1655, 28492.9121, 3828.0828);
	angles[24] = (0, 175.5584, 0);
	at[24] = 19.8000;
	points[25] = (-5043.9766, 27568.1895, 3475.8503);
	angles[25] = (0, 175.5584, 0);
	at[25] = 20;
	points[26] = (-5118.0708, 26614.4082, 3112.5474);
	angles[26] = (0, 175.5584, 0);
	at[26] = 20.2000;
	points[27] = (-5194.1733, 25634.8438, 2739.4250);
	angles[27] = (0, 175.5584, 0);
	at[27] = 20.4000;
	points[28] = (-5272.7954, 24622.6777, 2353.8896);
	angles[28] = (0, 175.5585, 0);
	at[28] = 20.6000;
	points[29] = (-5353.6221, 23581.8887, 1957.4370);
	angles[29] = (0, 175.5584, 0);
	at[29] = 20.8000;
	points[30] = (-5436.4966, 22514.7637, 1550.9607);
	angles[30] = (0, 175.5582, 0);
	at[30] = 21;
	points[31] = (-5478.8188, 21970.0391, 1343.4724);
	angles[31] = (0, 175.5580, 0);
	at[31] = 21.2000;
	points[32] = (-5478.8188, 21970.0391, 1343.4724);
	angles[32] = (0, 175.5580, 0);
	at[32] = 31.1167;
	points[33] = (-3860.8662, 42728.3477, 6467.9922);
	angles[33] = (0, 171.7126, 0);
	at[33] = 31.1167;
	points[34] = (-3860.8662, 42728.3477, 6467.9922);
	angles[34] = (0, 171.7126, 0);
	at[34] = 45;
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
	points[0] = (-2092.6968, 23736.8906, 1012.8071);
	angles[0] = (0, 77.2204, 0);
	at[0] = 0;
	points[1] = (-2092.6968, 23736.8906, 1012.8071);
	angles[1] = (0, 77.2205, 0);
	at[1] = 3.5333;
	points[2] = (25566.3770, 17335.3945, 6050.2759);
	angles[2] = (0, 72.2302, 0);
	at[2] = 3.5333;
	points[3] = (25566.3770, 17335.3945, 6050.2759);
	angles[3] = (0, 72.2302, 0);
	at[3] = 29.8000;
	points[4] = (25113.9766, 17480.6699, 6388.2676);
	angles[4] = (0, 73.5951, 0);
	at[4] = 30;
	points[5] = (24565.5117, 17621.5762, 6737.5591);
	angles[5] = (0, 75.2921, 0);
	at[5] = 30.2000;
	points[6] = (24009.0156, 17765.7871, 7015.0396);
	angles[6] = (0, 76.3014, 0);
	at[6] = 30.4000;
	points[7] = (23440.8672, 17898.0312, 7210.9053);
	angles[7] = (0, 77.6973, 0);
	at[7] = 30.6000;
	points[8] = (22871.8887, 18022.4414, 7346.8110);
	angles[8] = (0, 77.6003, 0);
	at[8] = 30.8000;
	points[9] = (22304.0566, 18140.4727, 7432.9922);
	angles[9] = (0, 78.7013, 0);
	at[9] = 31;
	points[10] = (21738.9766, 18262.8750, 7467.2837);
	angles[10] = (0, 77.2081, 0);
	at[10] = 31.2000;
	points[11] = (21174.5273, 18384.7637, 7457.5986);
	angles[11] = (0, 78.8704, 0);
	at[11] = 31.4000;
	points[12] = (20608.3477, 18496.3398, 7400.5122);
	angles[12] = (0, 78.2814, 0);
	at[12] = 31.6000;
	points[13] = (20038.3867, 18617.2832, 7303.7402);
	angles[13] = (0, 77.7349, 0);
	at[13] = 31.8000;
	points[14] = (19476.0234, 18748.1504, 7144.6455);
	angles[14] = (0, 76.6264, 0);
	at[14] = 32;
	points[15] = (18901.4570, 18884.0156, 6970.1577);
	angles[15] = (0, 76.7319, 0);
	at[15] = 32.2000;
	points[16] = (18310.9453, 19023.2676, 6793.0317);
	angles[16] = (0, 76.7319, 0);
	at[16] = 32.4000;
	points[17] = (17701.4180, 19167.0078, 6610.1572);
	angles[17] = (0, 76.7321, 0);
	at[17] = 32.6000;
	points[18] = (17080.4336, 19313.4258, 6423.8584);
	angles[18] = (0, 76.7319, 0);
	at[18] = 32.8000;
	points[19] = (16444.4102, 19463.3867, 6233.0713);
	angles[19] = (0, 76.7319, 0);
	at[19] = 33;
	points[20] = (15787.6768, 19618.2676, 6036.0630);
	angles[20] = (0, 76.7314, 0);
	at[20] = 33.2000;
	points[21] = (15120.2754, 19775.6309, 5835.8267);
	angles[21] = (0, 76.7322, 0);
	at[21] = 33.4000;
	points[22] = (14432.4805, 19937.8340, 5629.4883);
	angles[22] = (0, 76.7324, 0);
	at[22] = 33.6000;
	points[23] = (13734.7246, 20102.3223, 5420.1572);
	angles[23] = (0, 76.7319, 0);
	at[23] = 33.8000;
	points[24] = (13020.2363, 20270.8281, 5205.8267);
	angles[24] = (0, 76.7321, 0);
	at[24] = 34;
	points[25] = (12288.5039, 20443.3457, 4986.2993);
	angles[25] = (0, 76.7321, 0);
	at[25] = 34.2000;
	points[26] = (11541.3779, 20619.5293, 4762.1655);
	angles[26] = (0, 76.7322, 0);
	at[26] = 34.4000;
	points[27] = (10781.4170, 20798.7422, 4534.2124);
	angles[27] = (0, 76.7322, 0);
	at[27] = 34.6000;
	points[28] = (10000.3936, 20982.9141, 4299.8818);
	angles[28] = (0, 76.7318, 0);
	at[28] = 34.8000;
	points[29] = (9210.1582, 21169.6074, 4061.4568);
	angles[29] = (0, 76.7182, 0);
	at[29] = 35;
	points[30] = (8398.4648, 21357.7168, 3829.4919);
	angles[30] = (0, 77.2356, 0);
	at[30] = 35.2000;
	points[31] = (7568.1499, 21545.5898, 3608.0237);
	angles[31] = (0, 77.2205, 0);
	at[31] = 35.4000;
	points[32] = (6721.6929, 21737.5996, 3380.6340);
	angles[32] = (0, 77.2203, 0);
	at[32] = 35.6000;
	points[33] = (5862.0474, 21932.5586, 3149.7087);
	angles[33] = (0, 77.2203, 0);
	at[33] = 35.8000;
	points[34] = (4990.2754, 22130.3145, 2915.5237);
	angles[34] = (0, 77.2203, 0);
	at[34] = 36;
	points[35] = (4102.8345, 22331.6152, 2677.1338);
	angles[35] = (0, 77.2205, 0);
	at[35] = 36.2000;
	points[36] = (3199.8503, 22536.4180, 2434.5552);
	angles[36] = (0, 77.2207, 0);
	at[36] = 36.4000;
	points[37] = (2285.0198, 22743.9375, 2188.8032);
	angles[37] = (0, 77.2205, 0);
	at[37] = 36.6000;
	points[38] = (1355.7126, 22954.6855, 1939.1614);
	angles[38] = (0, 77.2203, 0);
	at[38] = 36.8000;
	points[39] = (412.5118, 23168.6211, 1685.7875);
	angles[39] = (0, 77.2205, 0);
	at[39] = 37;
	points[40] = (-545.0827, 23385.8262, 1428.5433);
	angles[40] = (0, 77.2203, 0);
	at[40] = 37.2000;
	points[41] = (-1518.6497, 23606.6543, 1167.0118);
	angles[41] = (0, 77.2198, 0);
	at[41] = 37.4000;
	points[42] = (-2092.6968, 23736.8906, 1012.8071);
	angles[42] = (0, 77.2205, 0);
	at[42] = 37.6000;
	points[43] = (-2092.6968, 23736.8906, 1012.8071);
	angles[43] = (0, 77.2205, 0);
	at[43] = 45;
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
	points[0] = (25113.9766, 17480.6699, 6388.2676);
	angles[0] = (0, 73.5951, 0);
	at[0] = 0;
	points[1] = (24565.5117, 17621.5762, 6737.5591);
	angles[1] = (0, 75.2921, 0);
	at[1] = 0.2000;
	points[2] = (24009.0156, 17765.7871, 7015.0396);
	angles[2] = (0, 76.3014, 0);
	at[2] = 0.4000;
	points[3] = (23440.8672, 17898.0312, 7210.9053);
	angles[3] = (0, 77.6973, 0);
	at[3] = 0.6000;
	points[4] = (22871.8887, 18022.4414, 7346.8110);
	angles[4] = (0, 77.6003, 0);
	at[4] = 0.8000;
	points[5] = (22304.0566, 18140.4727, 7432.9922);
	angles[5] = (0, 78.7013, 0);
	at[5] = 1;
	points[6] = (21738.9766, 18262.8750, 7467.2837);
	angles[6] = (0, 77.2081, 0);
	at[6] = 1.2000;
	points[7] = (21174.5273, 18384.7637, 7457.5986);
	angles[7] = (0, 78.8704, 0);
	at[7] = 1.4000;
	points[8] = (20608.3477, 18496.3398, 7400.5122);
	angles[8] = (0, 78.2814, 0);
	at[8] = 1.6000;
	points[9] = (20038.3867, 18617.2832, 7303.7402);
	angles[9] = (0, 77.7349, 0);
	at[9] = 1.8000;
	points[10] = (19476.0234, 18748.1504, 7144.6455);
	angles[10] = (0, 76.6264, 0);
	at[10] = 2;
	points[11] = (18901.4570, 18884.0156, 6970.1577);
	angles[11] = (0, 76.7319, 0);
	at[11] = 2.2000;
	points[12] = (18310.9453, 19023.2676, 6793.0317);
	angles[12] = (0, 76.7319, 0);
	at[12] = 2.4000;
	points[13] = (17701.4180, 19167.0078, 6610.1572);
	angles[13] = (0, 76.7321, 0);
	at[13] = 2.6000;
	points[14] = (17080.4336, 19313.4258, 6423.8584);
	angles[14] = (0, 76.7319, 0);
	at[14] = 2.8000;
	points[15] = (16444.4102, 19463.3867, 6233.0713);
	angles[15] = (0, 76.7319, 0);
	at[15] = 3;
	points[16] = (15787.6768, 19618.2676, 6036.0630);
	angles[16] = (0, 76.7314, 0);
	at[16] = 3.2000;
	points[17] = (15120.2754, 19775.6309, 5835.8267);
	angles[17] = (0, 76.7322, 0);
	at[17] = 3.4000;
	points[18] = (14432.4805, 19937.8340, 5629.4883);
	angles[18] = (0, 76.7324, 0);
	at[18] = 3.6000;
	points[19] = (13734.7246, 20102.3223, 5420.1572);
	angles[19] = (0, 76.7319, 0);
	at[19] = 3.8000;
	points[20] = (13020.2363, 20270.8281, 5205.8267);
	angles[20] = (0, 76.7321, 0);
	at[20] = 4;
	points[21] = (12288.5039, 20443.3457, 4986.2993);
	angles[21] = (0, 76.7321, 0);
	at[21] = 4.2000;
	points[22] = (11541.3779, 20619.5293, 4762.1655);
	angles[22] = (0, 76.7322, 0);
	at[22] = 4.4000;
	points[23] = (10781.4170, 20798.7422, 4534.2124);
	angles[23] = (0, 76.7322, 0);
	at[23] = 4.6000;
	points[24] = (10000.3936, 20982.9141, 4299.8818);
	angles[24] = (0, 76.7318, 0);
	at[24] = 4.8000;
	points[25] = (9210.1582, 21169.6074, 4061.4568);
	angles[25] = (0, 76.7182, 0);
	at[25] = 5;
	points[26] = (8398.4648, 21357.7168, 3829.4919);
	angles[26] = (0, 77.2356, 0);
	at[26] = 5.2000;
	points[27] = (7568.1499, 21545.5898, 3608.0237);
	angles[27] = (0, 77.2205, 0);
	at[27] = 5.4000;
	points[28] = (6721.6929, 21737.5996, 3380.6340);
	angles[28] = (0, 77.2203, 0);
	at[28] = 5.6000;
	points[29] = (5862.0474, 21932.5586, 3149.7087);
	angles[29] = (0, 77.2203, 0);
	at[29] = 5.8000;
	points[30] = (4990.2754, 22130.3145, 2915.5237);
	angles[30] = (0, 77.2203, 0);
	at[30] = 6;
	points[31] = (4102.8345, 22331.6152, 2677.1338);
	angles[31] = (0, 77.2205, 0);
	at[31] = 6.2000;
	points[32] = (3199.8503, 22536.4180, 2434.5552);
	angles[32] = (0, 77.2207, 0);
	at[32] = 6.4000;
	points[33] = (2285.0198, 22743.9375, 2188.8032);
	angles[33] = (0, 77.2205, 0);
	at[33] = 6.6000;
	points[34] = (1355.7126, 22954.6855, 1939.1614);
	angles[34] = (0, 77.2203, 0);
	at[34] = 6.8000;
	points[35] = (412.5118, 23168.6211, 1685.7875);
	angles[35] = (0, 77.2205, 0);
	at[35] = 7;
	points[36] = (-545.0827, 23385.8262, 1428.5433);
	angles[36] = (0, 77.2203, 0);
	at[36] = 7.2000;
	points[37] = (-1518.6497, 23606.6543, 1167.0118);
	angles[37] = (0, 77.2198, 0);
	at[37] = 7.4000;
	points[38] = (-2092.6968, 23736.8906, 1012.8071);
	angles[38] = (0, 77.2205, 0);
	at[38] = 7.6000;
	points[39] = (-2092.6968, 23736.8906, 1012.8071);
	angles[39] = (0, 77.2205, 0);
	at[39] = 18.5333;
	points[40] = (25566.3770, 17335.3945, 6050.2759);
	angles[40] = (0, 72.2302, 0);
	at[40] = 18.5333;
	points[41] = (25566.3770, 17335.3945, 6050.2759);
	angles[41] = (0, 72.2302, 0);
	at[41] = 44.8000;
	points[42] = (25113.9766, 17480.6699, 6388.2676);
	angles[42] = (0, 73.5951, 0);
	at[42] = 45;
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
	points[0] = (25566.3770, 17335.3945, 6050.2759);
	angles[0] = (0, 72.2302, 0);
	at[0] = 0;
	points[1] = (25566.3770, 17335.3945, 6050.2759);
	angles[1] = (0, 72.2302, 0);
	at[1] = 14.8000;
	points[2] = (25113.9766, 17480.6699, 6388.2676);
	angles[2] = (0, 73.5951, 0);
	at[2] = 15;
	points[3] = (24565.5117, 17621.5762, 6737.5591);
	angles[3] = (0, 75.2921, 0);
	at[3] = 15.2000;
	points[4] = (24009.0156, 17765.7871, 7015.0396);
	angles[4] = (0, 76.3014, 0);
	at[4] = 15.4000;
	points[5] = (23440.8672, 17898.0312, 7210.9053);
	angles[5] = (0, 77.6973, 0);
	at[5] = 15.6000;
	points[6] = (22871.8887, 18022.4414, 7346.8110);
	angles[6] = (0, 77.6003, 0);
	at[6] = 15.8000;
	points[7] = (22304.0566, 18140.4727, 7432.9922);
	angles[7] = (0, 78.7013, 0);
	at[7] = 16;
	points[8] = (21738.9766, 18262.8750, 7467.2837);
	angles[8] = (0, 77.2081, 0);
	at[8] = 16.2000;
	points[9] = (21174.5273, 18384.7637, 7457.5986);
	angles[9] = (0, 78.8704, 0);
	at[9] = 16.4000;
	points[10] = (20608.3477, 18496.3398, 7400.5122);
	angles[10] = (0, 78.2814, 0);
	at[10] = 16.6000;
	points[11] = (20038.3867, 18617.2832, 7303.7402);
	angles[11] = (0, 77.7349, 0);
	at[11] = 16.8000;
	points[12] = (19476.0234, 18748.1504, 7144.6455);
	angles[12] = (0, 76.6264, 0);
	at[12] = 17;
	points[13] = (18901.4570, 18884.0156, 6970.1577);
	angles[13] = (0, 76.7319, 0);
	at[13] = 17.2000;
	points[14] = (18310.9453, 19023.2676, 6793.0317);
	angles[14] = (0, 76.7319, 0);
	at[14] = 17.4000;
	points[15] = (17701.4180, 19167.0078, 6610.1572);
	angles[15] = (0, 76.7321, 0);
	at[15] = 17.6000;
	points[16] = (17080.4336, 19313.4258, 6423.8584);
	angles[16] = (0, 76.7319, 0);
	at[16] = 17.8000;
	points[17] = (16444.4102, 19463.3867, 6233.0713);
	angles[17] = (0, 76.7319, 0);
	at[17] = 18;
	points[18] = (15787.6768, 19618.2676, 6036.0630);
	angles[18] = (0, 76.7314, 0);
	at[18] = 18.2000;
	points[19] = (15120.2754, 19775.6309, 5835.8267);
	angles[19] = (0, 76.7322, 0);
	at[19] = 18.4000;
	points[20] = (14432.4805, 19937.8340, 5629.4883);
	angles[20] = (0, 76.7324, 0);
	at[20] = 18.6000;
	points[21] = (13734.7246, 20102.3223, 5420.1572);
	angles[21] = (0, 76.7319, 0);
	at[21] = 18.8000;
	points[22] = (13020.2363, 20270.8281, 5205.8267);
	angles[22] = (0, 76.7321, 0);
	at[22] = 19;
	points[23] = (12288.5039, 20443.3457, 4986.2993);
	angles[23] = (0, 76.7321, 0);
	at[23] = 19.2000;
	points[24] = (11541.3779, 20619.5293, 4762.1655);
	angles[24] = (0, 76.7322, 0);
	at[24] = 19.4000;
	points[25] = (10781.4170, 20798.7422, 4534.2124);
	angles[25] = (0, 76.7322, 0);
	at[25] = 19.6000;
	points[26] = (10000.3936, 20982.9141, 4299.8818);
	angles[26] = (0, 76.7318, 0);
	at[26] = 19.8000;
	points[27] = (9210.1582, 21169.6074, 4061.4568);
	angles[27] = (0, 76.7182, 0);
	at[27] = 20;
	points[28] = (8398.4648, 21357.7168, 3829.4919);
	angles[28] = (0, 77.2356, 0);
	at[28] = 20.2000;
	points[29] = (7568.1499, 21545.5898, 3608.0237);
	angles[29] = (0, 77.2205, 0);
	at[29] = 20.4000;
	points[30] = (6721.6929, 21737.5996, 3380.6340);
	angles[30] = (0, 77.2203, 0);
	at[30] = 20.6000;
	points[31] = (5862.0474, 21932.5586, 3149.7087);
	angles[31] = (0, 77.2203, 0);
	at[31] = 20.8000;
	points[32] = (4990.2754, 22130.3145, 2915.5237);
	angles[32] = (0, 77.2203, 0);
	at[32] = 21;
	points[33] = (4102.8345, 22331.6152, 2677.1338);
	angles[33] = (0, 77.2205, 0);
	at[33] = 21.2000;
	points[34] = (3199.8503, 22536.4180, 2434.5552);
	angles[34] = (0, 77.2207, 0);
	at[34] = 21.4000;
	points[35] = (2285.0198, 22743.9375, 2188.8032);
	angles[35] = (0, 77.2205, 0);
	at[35] = 21.6000;
	points[36] = (1355.7126, 22954.6855, 1939.1614);
	angles[36] = (0, 77.2203, 0);
	at[36] = 21.8000;
	points[37] = (412.5118, 23168.6211, 1685.7875);
	angles[37] = (0, 77.2205, 0);
	at[37] = 22;
	points[38] = (-545.0827, 23385.8262, 1428.5433);
	angles[38] = (0, 77.2203, 0);
	at[38] = 22.2000;
	points[39] = (-1518.6497, 23606.6543, 1167.0118);
	angles[39] = (0, 77.2198, 0);
	at[39] = 22.4000;
	points[40] = (-2092.6968, 23736.8906, 1012.8071);
	angles[40] = (0, 77.2205, 0);
	at[40] = 22.6000;
	points[41] = (-2092.6968, 23736.8906, 1012.8071);
	angles[41] = (0, 77.2205, 0);
	at[41] = 33.5333;
	points[42] = (25566.3770, 17335.3945, 6050.2759);
	angles[42] = (0, 72.2302, 0);
	at[42] = 33.5333;
	points[43] = (25566.3770, 17335.3945, 6050.2759);
	angles[43] = (0, 72.2302, 0);
	at[43] = 45;
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
	points[0] = (-3838.9016, 42738.1914, 6392.7168);
	angles[0] = (0, 175.3341, 0);
	at[0] = 0;
	points[1] = (-3838.9016, 42738.1914, 6392.7168);
	angles[1] = (0, 175.3341, 0);
	at[1] = 20.2000;
	points[2] = (-3854.5552, 42550.3945, 6533.2681);
	angles[2] = (0, 175.2078, 0);
	at[2] = 20.4000;
	points[3] = (-3895.0237, 41984.2539, 6908.7798);
	angles[3] = (0, 177.1267, 0);
	at[3] = 20.6000;
	points[4] = (-3928.3896, 41396.8516, 7186.9683);
	angles[4] = (0, 176.3495, 0);
	at[4] = 20.8000;
	points[5] = (-3964.7639, 40823.2305, 7428.9766);
	angles[5] = (0, 176.5701, 0);
	at[5] = 21;
	points[6] = (-3994.8425, 40243.7031, 7593.2681);
	angles[6] = (0, 177.0732, 0);
	at[6] = 21.2000;
	points[7] = (-4024.5669, 39670.4727, 7703.3857);
	angles[7] = (0, 176.5175, 0);
	at[7] = 21.4000;
	points[8] = (-4061.3779, 39098.8984, 7759.9604);
	angles[8] = (0, 176.2919, 0);
	at[8] = 21.6000;
	points[9] = (-4098.2676, 38525.2773, 7776.6929);
	angles[9] = (0, 176.4349, 0);
	at[9] = 21.8000;
	points[10] = (-4129.5273, 37957.3242, 7707.8350);
	angles[10] = (0, 176.9494, 0);
	at[10] = 22;
	points[11] = (-4160.7876, 37395.9844, 7552.5195);
	angles[11] = (0, 176.7505, 0);
	at[11] = 22.2000;
	points[12] = (-4193.3857, 36830.1172, 7346.5356);
	angles[12] = (0, 176.6717, 0);
	at[12] = 22.4000;
	points[13] = (-4227.2837, 36247.4414, 7123.1494);
	angles[13] = (0, 176.6767, 0);
	at[13] = 22.6000;
	points[14] = (-4262.3228, 35643.4258, 6893.0312);
	angles[14] = (0, 176.6768, 0);
	at[14] = 22.8000;
	points[15] = (-4298.8188, 35015.1953, 6653.6616);
	angles[15] = (0, 176.6767, 0);
	at[15] = 23;
	points[16] = (-4336.3384, 34369.0156, 6407.4805);
	angles[16] = (0, 176.6766, 0);
	at[16] = 23.2000;
	points[17] = (-4375, 33703.4648, 6153.8979);
	angles[17] = (0, 176.6768, 0);
	at[17] = 23.4000;
	points[18] = (-4415.1973, 33011.3008, 5890.1968);
	angles[18] = (0, 176.6768, 0);
	at[18] = 23.6000;
	points[19] = (-4456.3779, 32302.0879, 5620);
	angles[19] = (0, 176.6767, 0);
	at[19] = 23.8000;
	points[20] = (-4498.7793, 31571.5352, 5341.6929);
	angles[20] = (0, 176.6767, 0);
	at[20] = 24;
	points[21] = (-4542.4014, 30820.4336, 5055.5122);
	angles[21] = (0, 176.6768, 0);
	at[21] = 24.2000;
	points[22] = (-4587.4409, 30044.4512, 4759.8818);
	angles[22] = (0, 176.6769, 0);
	at[22] = 24.4000;
	points[23] = (-4633.5039, 29251.7715, 4457.8740);
	angles[23] = (0, 176.6767, 0);
	at[23] = 24.6000;
	points[24] = (-4680.7480, 28438.0312, 4147.8350);
	angles[24] = (0, 176.6768, 0);
	at[24] = 24.8000;
	points[25] = (-4728.7402, 27602.4824, 3828.9568);
	angles[25] = (0, 176.7009, 0);
	at[25] = 25;
	points[26] = (-4786.9683, 26742.5586, 3510.4172);
	angles[26] = (0, 175.7887, 0);
	at[26] = 25.2000;
	points[27] = (-4851.0630, 25861.0234, 3188.6929);
	angles[27] = (0, 175.8588, 0);
	at[27] = 25.4000;
	points[28] = (-4916.1025, 24962.6387, 2860.5156);
	angles[28] = (0, 175.8589, 0);
	at[28] = 25.6000;
	points[29] = (-4982.8350, 24040.9453, 2523.8230);
	angles[29] = (0, 175.8590, 0);
	at[29] = 25.8000;
	points[30] = (-5051.0630, 23098.5059, 2179.5552);
	angles[30] = (0, 175.8592, 0);
	at[30] = 26;
	points[31] = (-5120.7871, 22135.7090, 1827.8464);
	angles[31] = (0, 175.8591, 0);
	at[31] = 26.2000;
	points[32] = (-5192.0078, 21152.1250, 1468.5552);
	angles[32] = (0, 175.8590, 0);
	at[32] = 26.4000;
	points[33] = (-5264.4487, 20151.3789, 1102.9843);
	angles[33] = (0, 175.8591, 0);
	at[33] = 26.6000;
	points[34] = (-5326.0630, 19300.2754, 792.0827);
	angles[34] = (0, 175.8592, 0);
	at[34] = 26.8000;
	points[35] = (-5326.0630, 19300.2754, 792.0827);
	angles[35] = (0, 175.8592, 0);
	at[35] = 36.7833;
	points[36] = (-3838.9016, 42738.1914, 6392.7168);
	angles[36] = (0, 175.3341, 0);
	at[36] = 36.7833;
	points[37] = (-3838.9016, 42738.1914, 6392.7168);
	angles[37] = (0, 175.3341, 0);
	at[37] = 45;
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
	points[0] = (-5326.0630, 19300.2754, 792.0827);
	angles[0] = (0, 175.8592, 0);
	at[0] = 0;
	points[1] = (-5326.0630, 19300.2754, 792.0827);
	angles[1] = (0, 175.8592, 0);
	at[1] = 6.7833;
	points[2] = (-3838.9016, 42738.1914, 6392.7168);
	angles[2] = (0, 175.3341, 0);
	at[2] = 6.7833;
	points[3] = (-3838.9016, 42738.1914, 6392.7168);
	angles[3] = (0, 175.3341, 0);
	at[3] = 35.2000;
	points[4] = (-3854.5552, 42550.3945, 6533.2681);
	angles[4] = (0, 175.2078, 0);
	at[4] = 35.4000;
	points[5] = (-3895.0237, 41984.2539, 6908.7798);
	angles[5] = (0, 177.1267, 0);
	at[5] = 35.6000;
	points[6] = (-3928.3896, 41396.8516, 7186.9683);
	angles[6] = (0, 176.3495, 0);
	at[6] = 35.8000;
	points[7] = (-3964.7639, 40823.2305, 7428.9766);
	angles[7] = (0, 176.5701, 0);
	at[7] = 36;
	points[8] = (-3994.8425, 40243.7031, 7593.2681);
	angles[8] = (0, 177.0732, 0);
	at[8] = 36.2000;
	points[9] = (-4024.5669, 39670.4727, 7703.3857);
	angles[9] = (0, 176.5175, 0);
	at[9] = 36.4000;
	points[10] = (-4061.3779, 39098.8984, 7759.9604);
	angles[10] = (0, 176.2919, 0);
	at[10] = 36.6000;
	points[11] = (-4098.2676, 38525.2773, 7776.6929);
	angles[11] = (0, 176.4349, 0);
	at[11] = 36.8000;
	points[12] = (-4129.5273, 37957.3242, 7707.8350);
	angles[12] = (0, 176.9494, 0);
	at[12] = 37;
	points[13] = (-4160.7876, 37395.9844, 7552.5195);
	angles[13] = (0, 176.7505, 0);
	at[13] = 37.2000;
	points[14] = (-4193.3857, 36830.1172, 7346.5356);
	angles[14] = (0, 176.6717, 0);
	at[14] = 37.4000;
	points[15] = (-4227.2837, 36247.4414, 7123.1494);
	angles[15] = (0, 176.6767, 0);
	at[15] = 37.6000;
	points[16] = (-4262.3228, 35643.4258, 6893.0312);
	angles[16] = (0, 176.6768, 0);
	at[16] = 37.8000;
	points[17] = (-4298.8188, 35015.1953, 6653.6616);
	angles[17] = (0, 176.6767, 0);
	at[17] = 38;
	points[18] = (-4336.3384, 34369.0156, 6407.4805);
	angles[18] = (0, 176.6766, 0);
	at[18] = 38.2000;
	points[19] = (-4375, 33703.4648, 6153.8979);
	angles[19] = (0, 176.6768, 0);
	at[19] = 38.4000;
	points[20] = (-4415.1973, 33011.3008, 5890.1968);
	angles[20] = (0, 176.6768, 0);
	at[20] = 38.6000;
	points[21] = (-4456.3779, 32302.0879, 5620);
	angles[21] = (0, 176.6767, 0);
	at[21] = 38.8000;
	points[22] = (-4498.7793, 31571.5352, 5341.6929);
	angles[22] = (0, 176.6767, 0);
	at[22] = 39;
	points[23] = (-4542.4014, 30820.4336, 5055.5122);
	angles[23] = (0, 176.6768, 0);
	at[23] = 39.2000;
	points[24] = (-4587.4409, 30044.4512, 4759.8818);
	angles[24] = (0, 176.6769, 0);
	at[24] = 39.4000;
	points[25] = (-4633.5039, 29251.7715, 4457.8740);
	angles[25] = (0, 176.6767, 0);
	at[25] = 39.6000;
	points[26] = (-4680.7480, 28438.0312, 4147.8350);
	angles[26] = (0, 176.6768, 0);
	at[26] = 39.8000;
	points[27] = (-4728.7402, 27602.4824, 3828.9568);
	angles[27] = (0, 176.7009, 0);
	at[27] = 40;
	points[28] = (-4786.9683, 26742.5586, 3510.4172);
	angles[28] = (0, 175.7887, 0);
	at[28] = 40.2000;
	points[29] = (-4851.0630, 25861.0234, 3188.6929);
	angles[29] = (0, 175.8588, 0);
	at[29] = 40.4000;
	points[30] = (-4916.1025, 24962.6387, 2860.5156);
	angles[30] = (0, 175.8589, 0);
	at[30] = 40.6000;
	points[31] = (-4982.8350, 24040.9453, 2523.8230);
	angles[31] = (0, 175.8590, 0);
	at[31] = 40.8000;
	points[32] = (-5051.0630, 23098.5059, 2179.5552);
	angles[32] = (0, 175.8592, 0);
	at[32] = 41;
	points[33] = (-5120.7871, 22135.7090, 1827.8464);
	angles[33] = (0, 175.8591, 0);
	at[33] = 41.2000;
	points[34] = (-5192.0078, 21152.1250, 1468.5552);
	angles[34] = (0, 175.8590, 0);
	at[34] = 41.4000;
	points[35] = (-5264.4487, 20151.3789, 1102.9843);
	angles[35] = (0, 175.8591, 0);
	at[35] = 41.6000;
	points[36] = (-5326.0630, 19300.2754, 792.0827);
	angles[36] = (0, 175.8592, 0);
	at[36] = 41.8000;
	points[37] = (-5326.0630, 19300.2754, 792.0827);
	angles[37] = (0, 175.8592, 0);
	at[37] = 45;
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
	points[0] = (-3838.9016, 42738.1914, 6392.7168);
	angles[0] = (0, 175.3341, 0);
	at[0] = 0;
	points[1] = (-3838.9016, 42738.1914, 6392.7168);
	angles[1] = (0, 175.3341, 0);
	at[1] = 5.2000;
	points[2] = (-3854.5552, 42550.3945, 6533.2681);
	angles[2] = (0, 175.2078, 0);
	at[2] = 5.4000;
	points[3] = (-3895.0237, 41984.2539, 6908.7798);
	angles[3] = (0, 177.1267, 0);
	at[3] = 5.6000;
	points[4] = (-3928.3896, 41396.8516, 7186.9683);
	angles[4] = (0, 176.3495, 0);
	at[4] = 5.8000;
	points[5] = (-3964.7639, 40823.2305, 7428.9766);
	angles[5] = (0, 176.5701, 0);
	at[5] = 6;
	points[6] = (-3994.8425, 40243.7031, 7593.2681);
	angles[6] = (0, 177.0732, 0);
	at[6] = 6.2000;
	points[7] = (-4024.5669, 39670.4727, 7703.3857);
	angles[7] = (0, 176.5175, 0);
	at[7] = 6.4000;
	points[8] = (-4061.3779, 39098.8984, 7759.9604);
	angles[8] = (0, 176.2919, 0);
	at[8] = 6.6000;
	points[9] = (-4098.2676, 38525.2773, 7776.6929);
	angles[9] = (0, 176.4349, 0);
	at[9] = 6.8000;
	points[10] = (-4129.5273, 37957.3242, 7707.8350);
	angles[10] = (0, 176.9494, 0);
	at[10] = 7;
	points[11] = (-4160.7876, 37395.9844, 7552.5195);
	angles[11] = (0, 176.7505, 0);
	at[11] = 7.2000;
	points[12] = (-4193.3857, 36830.1172, 7346.5356);
	angles[12] = (0, 176.6717, 0);
	at[12] = 7.4000;
	points[13] = (-4227.2837, 36247.4414, 7123.1494);
	angles[13] = (0, 176.6767, 0);
	at[13] = 7.6000;
	points[14] = (-4262.3228, 35643.4258, 6893.0312);
	angles[14] = (0, 176.6768, 0);
	at[14] = 7.8000;
	points[15] = (-4298.8188, 35015.1953, 6653.6616);
	angles[15] = (0, 176.6767, 0);
	at[15] = 8;
	points[16] = (-4336.3384, 34369.0156, 6407.4805);
	angles[16] = (0, 176.6766, 0);
	at[16] = 8.2000;
	points[17] = (-4375, 33703.4648, 6153.8979);
	angles[17] = (0, 176.6768, 0);
	at[17] = 8.4000;
	points[18] = (-4415.1973, 33011.3008, 5890.1968);
	angles[18] = (0, 176.6768, 0);
	at[18] = 8.6000;
	points[19] = (-4456.3779, 32302.0879, 5620);
	angles[19] = (0, 176.6767, 0);
	at[19] = 8.8000;
	points[20] = (-4498.7793, 31571.5352, 5341.6929);
	angles[20] = (0, 176.6767, 0);
	at[20] = 9;
	points[21] = (-4542.4014, 30820.4336, 5055.5122);
	angles[21] = (0, 176.6768, 0);
	at[21] = 9.2000;
	points[22] = (-4587.4409, 30044.4512, 4759.8818);
	angles[22] = (0, 176.6769, 0);
	at[22] = 9.4000;
	points[23] = (-4633.5039, 29251.7715, 4457.8740);
	angles[23] = (0, 176.6767, 0);
	at[23] = 9.6000;
	points[24] = (-4680.7480, 28438.0312, 4147.8350);
	angles[24] = (0, 176.6768, 0);
	at[24] = 9.8000;
	points[25] = (-4728.7402, 27602.4824, 3828.9568);
	angles[25] = (0, 176.7009, 0);
	at[25] = 10;
	points[26] = (-4786.9683, 26742.5586, 3510.4172);
	angles[26] = (0, 175.7887, 0);
	at[26] = 10.2000;
	points[27] = (-4851.0630, 25861.0234, 3188.6929);
	angles[27] = (0, 175.8588, 0);
	at[27] = 10.4000;
	points[28] = (-4916.1025, 24962.6387, 2860.5156);
	angles[28] = (0, 175.8589, 0);
	at[28] = 10.6000;
	points[29] = (-4982.8350, 24040.9453, 2523.8230);
	angles[29] = (0, 175.8590, 0);
	at[29] = 10.8000;
	points[30] = (-5051.0630, 23098.5059, 2179.5552);
	angles[30] = (0, 175.8592, 0);
	at[30] = 11;
	points[31] = (-5120.7871, 22135.7090, 1827.8464);
	angles[31] = (0, 175.8591, 0);
	at[31] = 11.2000;
	points[32] = (-5192.0078, 21152.1250, 1468.5552);
	angles[32] = (0, 175.8590, 0);
	at[32] = 11.4000;
	points[33] = (-5264.4487, 20151.3789, 1102.9843);
	angles[33] = (0, 175.8591, 0);
	at[33] = 11.6000;
	points[34] = (-5326.0630, 19300.2754, 792.0827);
	angles[34] = (0, 175.8592, 0);
	at[34] = 11.8000;
	points[35] = (-5326.0630, 19300.2754, 792.0827);
	angles[35] = (0, 175.8592, 0);
	at[35] = 21.7833;
	points[36] = (-3838.9016, 42738.1914, 6392.7168);
	angles[36] = (0, 175.3341, 0);
	at[36] = 21.7833;
	points[37] = (-3838.9016, 42738.1914, 6392.7168);
	angles[37] = (0, 175.3341, 0);
	at[37] = 45;
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
	points[0] = (25581.8496, 17164.1348, 6033.1499);
	angles[0] = (0, 75.4558, 0);
	at[0] = 0;
	points[1] = (25581.8496, 17164.1348, 6033.1499);
	angles[1] = (0, 75.4558, 0);
	at[1] = 4.8000;
	points[2] = (25113.9375, 17285.5117, 6357.0869);
	angles[2] = (0, 75.6160, 0);
	at[2] = 5;
	points[3] = (24563.4648, 17422.3242, 6716.1812);
	angles[3] = (0, 77.4539, 0);
	at[3] = 5.2000;
	points[4] = (23989.7656, 17548.5430, 6982.8745);
	angles[4] = (0, 77.5042, 0);
	at[4] = 5.4000;
	points[5] = (23414.0957, 17672.4023, 7189.8423);
	angles[5] = (0, 78.1573, 0);
	at[5] = 5.6000;
	points[6] = (22837.3613, 17789.2910, 7339.8428);
	angles[6] = (0, 78.5034, 0);
	at[6] = 5.8000;
	points[7] = (22261.8906, 17910.0391, 7420.7085);
	angles[7] = (0, 78.2928, 0);
	at[7] = 6;
	points[8] = (21682.0469, 18030.1191, 7453.4644);
	angles[8] = (0, 78.0460, 0);
	at[8] = 6.2000;
	points[9] = (21108.9375, 18156.3008, 7401.5747);
	angles[9] = (0, 77.5551, 0);
	at[9] = 6.4000;
	points[10] = (20535.9062, 18276.0234, 7294.6851);
	angles[10] = (0, 78.7058, 0);
	at[10] = 6.6000;
	points[11] = (19959.5664, 18392.2051, 7139.1733);
	angles[11] = (0, 78.4048, 0);
	at[11] = 6.8000;
	points[12] = (19376.4570, 18512.0469, 6959.2520);
	angles[12] = (0, 78.4011, 0);
	at[12] = 7;
	points[13] = (18775, 18635.4727, 6775.7871);
	angles[13] = (0, 78.4011, 0);
	at[13] = 7.2000;
	points[14] = (18162.3633, 18761.2207, 6588.8979);
	angles[14] = (0, 78.4014, 0);
	at[14] = 7.4000;
	points[15] = (17531.1406, 18890.7871, 6396.3384);
	angles[15] = (0, 78.4017, 0);
	at[15] = 7.6000;
	points[16] = (16888.7793, 19022.5996, 6200.3940);
	angles[16] = (0, 78.4016, 0);
	at[16] = 7.8000;
	points[17] = (16231.3789, 19157.5586, 5999.8423);
	angles[17] = (0, 78.4014, 0);
	at[17] = 8;
	points[18] = (15556.1025, 19296.1426, 5793.8188);
	angles[18] = (0, 78.4014, 0);
	at[18] = 8.2000;
	points[19] = (14869.4883, 19437.0469, 5584.3701);
	angles[19] = (0, 78.4014, 0);
	at[19] = 8.4000;
	points[20] = (14168.4648, 19580.9453, 5370.5117);
	angles[20] = (0, 78.4014, 0);
	at[20] = 8.6000;
	points[21] = (13449.3311, 19728.5449, 5151.1421);
	angles[21] = (0, 78.4011, 0);
	at[21] = 8.8000;
	points[22] = (12718.1494, 19878.6211, 4928.1104);
	angles[22] = (0, 78.4014, 0);
	at[22] = 9;
	points[23] = (11972.2842, 20031.6934, 4700.5513);
	angles[23] = (0, 78.4014, 0);
	at[23] = 9.2000;
	points[24] = (11209.1338, 20188.3457, 4467.7559);
	angles[24] = (0, 78.4016, 0);
	at[24] = 9.4000;
	points[25] = (10434.4092, 20347.3242, 4231.4175);
	angles[25] = (0, 78.4014, 0);
	at[25] = 9.6000;
	points[26] = (9639.7246, 20510.4336, 3989.0159);
	angles[26] = (0, 78.4011, 0);
	at[26] = 9.8000;
	points[27] = (8837.6777, 20675.2363, 3744.1575);
	angles[27] = (0, 78.5534, 0);
	at[27] = 10;
	points[28] = (8017.2837, 20834.3691, 3501.3662);
	angles[28] = (0, 79.0512, 0);
	at[28] = 10.2000;
	points[29] = (7174.5278, 20997.4004, 3252.2759);
	angles[29] = (0, 79.0511, 0);
	at[29] = 10.4000;
	points[30] = (6323.5435, 21162.0078, 3000.7715);
	angles[30] = (0, 79.0514, 0);
	at[30] = 10.6000;
	points[31] = (5456.5352, 21329.7637, 2744.5120);
	angles[31] = (0, 79.0512, 0);
	at[31] = 10.8000;
	points[32] = (4576.2207, 21500.0410, 2484.3267);
	angles[32] = (0, 79.0511, 0);
	at[32] = 11;
	points[33] = (3680.8582, 21673.2676, 2219.6968);
	angles[33] = (0, 79.0514, 0);
	at[33] = 11.2000;
	points[34] = (2771.8779, 21849.0938, 1951.0433);
	angles[34] = (0, 79.0508, 0);
	at[34] = 11.4000;
	points[35] = (1846.3583, 22028.1504, 1677.4960);
	angles[35] = (0, 79.0514, 0);
	at[35] = 11.6000;
	points[36] = (907.7441, 22209.7246, 1400.0826);
	angles[36] = (0, 79.0512, 0);
	at[36] = 11.8000;
	points[37] = (-46.2870, 22394.2910, 1118.1102);
	angles[37] = (0, 79.0515, 0);
	at[37] = 12;
	points[38] = (-931.8071, 22565.5918, 856.3858);
	angles[38] = (0, 79.0509, 0);
	at[38] = 12.2000;
	points[39] = (-931.8071, 22565.5918, 856.3858);
	angles[39] = (0, 79.0509, 0);
	at[39] = 23.2000;
	points[40] = (25581.8496, 17164.1348, 6033.1499);
	angles[40] = (0, 75.4558, 0);
	at[40] = 23.2000;
	points[41] = (25581.8496, 17164.1348, 6033.1499);
	angles[41] = (0, 75.4558, 0);
	at[41] = 45;
	mover = getEnt("iz_obj_12", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_13()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (25581.8496, 17164.1348, 6033.1499);
	angles[0] = (0, 75.4558, 0);
	at[0] = 0;
	points[1] = (25581.8496, 17164.1348, 6033.1499);
	angles[1] = (0, 75.4558, 0);
	at[1] = 19.8000;
	points[2] = (25113.9375, 17285.5117, 6357.0869);
	angles[2] = (0, 75.6160, 0);
	at[2] = 20;
	points[3] = (24563.4648, 17422.3242, 6716.1812);
	angles[3] = (0, 77.4539, 0);
	at[3] = 20.2000;
	points[4] = (23989.7656, 17548.5430, 6982.8745);
	angles[4] = (0, 77.5042, 0);
	at[4] = 20.4000;
	points[5] = (23414.0957, 17672.4023, 7189.8423);
	angles[5] = (0, 78.1573, 0);
	at[5] = 20.6000;
	points[6] = (22837.3613, 17789.2910, 7339.8428);
	angles[6] = (0, 78.5034, 0);
	at[6] = 20.8000;
	points[7] = (22261.8906, 17910.0391, 7420.7085);
	angles[7] = (0, 78.2928, 0);
	at[7] = 21;
	points[8] = (21682.0469, 18030.1191, 7453.4644);
	angles[8] = (0, 78.0460, 0);
	at[8] = 21.2000;
	points[9] = (21108.9375, 18156.3008, 7401.5747);
	angles[9] = (0, 77.5551, 0);
	at[9] = 21.4000;
	points[10] = (20535.9062, 18276.0234, 7294.6851);
	angles[10] = (0, 78.7058, 0);
	at[10] = 21.6000;
	points[11] = (19959.5664, 18392.2051, 7139.1733);
	angles[11] = (0, 78.4048, 0);
	at[11] = 21.8000;
	points[12] = (19376.4570, 18512.0469, 6959.2520);
	angles[12] = (0, 78.4011, 0);
	at[12] = 22;
	points[13] = (18775, 18635.4727, 6775.7871);
	angles[13] = (0, 78.4011, 0);
	at[13] = 22.2000;
	points[14] = (18162.3633, 18761.2207, 6588.8979);
	angles[14] = (0, 78.4014, 0);
	at[14] = 22.4000;
	points[15] = (17531.1406, 18890.7871, 6396.3384);
	angles[15] = (0, 78.4017, 0);
	at[15] = 22.6000;
	points[16] = (16888.7793, 19022.5996, 6200.3940);
	angles[16] = (0, 78.4016, 0);
	at[16] = 22.8000;
	points[17] = (16231.3789, 19157.5586, 5999.8423);
	angles[17] = (0, 78.4014, 0);
	at[17] = 23;
	points[18] = (15556.1025, 19296.1426, 5793.8188);
	angles[18] = (0, 78.4014, 0);
	at[18] = 23.2000;
	points[19] = (14869.4883, 19437.0469, 5584.3701);
	angles[19] = (0, 78.4014, 0);
	at[19] = 23.4000;
	points[20] = (14168.4648, 19580.9453, 5370.5117);
	angles[20] = (0, 78.4014, 0);
	at[20] = 23.6000;
	points[21] = (13449.3311, 19728.5449, 5151.1421);
	angles[21] = (0, 78.4011, 0);
	at[21] = 23.8000;
	points[22] = (12718.1494, 19878.6211, 4928.1104);
	angles[22] = (0, 78.4014, 0);
	at[22] = 24;
	points[23] = (11972.2842, 20031.6934, 4700.5513);
	angles[23] = (0, 78.4014, 0);
	at[23] = 24.2000;
	points[24] = (11209.1338, 20188.3457, 4467.7559);
	angles[24] = (0, 78.4016, 0);
	at[24] = 24.4000;
	points[25] = (10434.4092, 20347.3242, 4231.4175);
	angles[25] = (0, 78.4014, 0);
	at[25] = 24.6000;
	points[26] = (9639.7246, 20510.4336, 3989.0159);
	angles[26] = (0, 78.4011, 0);
	at[26] = 24.8000;
	points[27] = (8837.6777, 20675.2363, 3744.1575);
	angles[27] = (0, 78.5534, 0);
	at[27] = 25;
	points[28] = (8017.2837, 20834.3691, 3501.3662);
	angles[28] = (0, 79.0512, 0);
	at[28] = 25.2000;
	points[29] = (7174.5278, 20997.4004, 3252.2759);
	angles[29] = (0, 79.0511, 0);
	at[29] = 25.4000;
	points[30] = (6323.5435, 21162.0078, 3000.7715);
	angles[30] = (0, 79.0514, 0);
	at[30] = 25.6000;
	points[31] = (5456.5352, 21329.7637, 2744.5120);
	angles[31] = (0, 79.0512, 0);
	at[31] = 25.8000;
	points[32] = (4576.2207, 21500.0410, 2484.3267);
	angles[32] = (0, 79.0511, 0);
	at[32] = 26;
	points[33] = (3680.8582, 21673.2676, 2219.6968);
	angles[33] = (0, 79.0514, 0);
	at[33] = 26.2000;
	points[34] = (2771.8779, 21849.0938, 1951.0433);
	angles[34] = (0, 79.0508, 0);
	at[34] = 26.4000;
	points[35] = (1846.3583, 22028.1504, 1677.4960);
	angles[35] = (0, 79.0514, 0);
	at[35] = 26.6000;
	points[36] = (907.7441, 22209.7246, 1400.0826);
	angles[36] = (0, 79.0512, 0);
	at[36] = 26.8000;
	points[37] = (-46.2870, 22394.2910, 1118.1102);
	angles[37] = (0, 79.0515, 0);
	at[37] = 27;
	points[38] = (-931.8071, 22565.5918, 856.3858);
	angles[38] = (0, 79.0509, 0);
	at[38] = 27.2000;
	points[39] = (-931.8071, 22565.5918, 856.3858);
	angles[39] = (0, 79.0509, 0);
	at[39] = 38.2000;
	points[40] = (25581.8496, 17164.1348, 6033.1499);
	angles[40] = (0, 75.4558, 0);
	at[40] = 38.2000;
	points[41] = (25581.8496, 17164.1348, 6033.1499);
	angles[41] = (0, 75.4558, 0);
	at[41] = 45;
	mover = getEnt("iz_obj_13", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_14()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-931.8071, 22565.5918, 856.3858);
	angles[0] = (0, 79.0509, 0);
	at[0] = 0;
	points[1] = (-931.8071, 22565.5918, 856.3858);
	angles[1] = (0, 79.0509, 0);
	at[1] = 8.2000;
	points[2] = (25581.8496, 17164.1348, 6033.1499);
	angles[2] = (0, 75.4558, 0);
	at[2] = 8.2000;
	points[3] = (25581.8496, 17164.1348, 6033.1499);
	angles[3] = (0, 75.4558, 0);
	at[3] = 34.8000;
	points[4] = (25113.9375, 17285.5117, 6357.0869);
	angles[4] = (0, 75.6160, 0);
	at[4] = 35;
	points[5] = (24563.4648, 17422.3242, 6716.1812);
	angles[5] = (0, 77.4539, 0);
	at[5] = 35.2000;
	points[6] = (23989.7656, 17548.5430, 6982.8745);
	angles[6] = (0, 77.5042, 0);
	at[6] = 35.4000;
	points[7] = (23414.0957, 17672.4023, 7189.8423);
	angles[7] = (0, 78.1573, 0);
	at[7] = 35.6000;
	points[8] = (22837.3613, 17789.2910, 7339.8428);
	angles[8] = (0, 78.5034, 0);
	at[8] = 35.8000;
	points[9] = (22261.8906, 17910.0391, 7420.7085);
	angles[9] = (0, 78.2928, 0);
	at[9] = 36;
	points[10] = (21682.0469, 18030.1191, 7453.4644);
	angles[10] = (0, 78.0460, 0);
	at[10] = 36.2000;
	points[11] = (21108.9375, 18156.3008, 7401.5747);
	angles[11] = (0, 77.5551, 0);
	at[11] = 36.4000;
	points[12] = (20535.9062, 18276.0234, 7294.6851);
	angles[12] = (0, 78.7058, 0);
	at[12] = 36.6000;
	points[13] = (19959.5664, 18392.2051, 7139.1733);
	angles[13] = (0, 78.4048, 0);
	at[13] = 36.8000;
	points[14] = (19376.4570, 18512.0469, 6959.2520);
	angles[14] = (0, 78.4011, 0);
	at[14] = 37;
	points[15] = (18775, 18635.4727, 6775.7871);
	angles[15] = (0, 78.4011, 0);
	at[15] = 37.2000;
	points[16] = (18162.3633, 18761.2207, 6588.8979);
	angles[16] = (0, 78.4014, 0);
	at[16] = 37.4000;
	points[17] = (17531.1406, 18890.7871, 6396.3384);
	angles[17] = (0, 78.4017, 0);
	at[17] = 37.6000;
	points[18] = (16888.7793, 19022.5996, 6200.3940);
	angles[18] = (0, 78.4016, 0);
	at[18] = 37.8000;
	points[19] = (16231.3789, 19157.5586, 5999.8423);
	angles[19] = (0, 78.4014, 0);
	at[19] = 38;
	points[20] = (15556.1025, 19296.1426, 5793.8188);
	angles[20] = (0, 78.4014, 0);
	at[20] = 38.2000;
	points[21] = (14869.4883, 19437.0469, 5584.3701);
	angles[21] = (0, 78.4014, 0);
	at[21] = 38.4000;
	points[22] = (14168.4648, 19580.9453, 5370.5117);
	angles[22] = (0, 78.4014, 0);
	at[22] = 38.6000;
	points[23] = (13449.3311, 19728.5449, 5151.1421);
	angles[23] = (0, 78.4011, 0);
	at[23] = 38.8000;
	points[24] = (12718.1494, 19878.6211, 4928.1104);
	angles[24] = (0, 78.4014, 0);
	at[24] = 39;
	points[25] = (11972.2842, 20031.6934, 4700.5513);
	angles[25] = (0, 78.4014, 0);
	at[25] = 39.2000;
	points[26] = (11209.1338, 20188.3457, 4467.7559);
	angles[26] = (0, 78.4016, 0);
	at[26] = 39.4000;
	points[27] = (10434.4092, 20347.3242, 4231.4175);
	angles[27] = (0, 78.4014, 0);
	at[27] = 39.6000;
	points[28] = (9639.7246, 20510.4336, 3989.0159);
	angles[28] = (0, 78.4011, 0);
	at[28] = 39.8000;
	points[29] = (8837.6777, 20675.2363, 3744.1575);
	angles[29] = (0, 78.5534, 0);
	at[29] = 40;
	points[30] = (8017.2837, 20834.3691, 3501.3662);
	angles[30] = (0, 79.0512, 0);
	at[30] = 40.2000;
	points[31] = (7174.5278, 20997.4004, 3252.2759);
	angles[31] = (0, 79.0511, 0);
	at[31] = 40.4000;
	points[32] = (6323.5435, 21162.0078, 3000.7715);
	angles[32] = (0, 79.0514, 0);
	at[32] = 40.6000;
	points[33] = (5456.5352, 21329.7637, 2744.5120);
	angles[33] = (0, 79.0512, 0);
	at[33] = 40.8000;
	points[34] = (4576.2207, 21500.0410, 2484.3267);
	angles[34] = (0, 79.0511, 0);
	at[34] = 41;
	points[35] = (3680.8582, 21673.2676, 2219.6968);
	angles[35] = (0, 79.0514, 0);
	at[35] = 41.2000;
	points[36] = (2771.8779, 21849.0938, 1951.0433);
	angles[36] = (0, 79.0508, 0);
	at[36] = 41.4000;
	points[37] = (1846.3583, 22028.1504, 1677.4960);
	angles[37] = (0, 79.0514, 0);
	at[37] = 41.6000;
	points[38] = (907.7441, 22209.7246, 1400.0826);
	angles[38] = (0, 79.0512, 0);
	at[38] = 41.8000;
	points[39] = (-46.2870, 22394.2910, 1118.1102);
	angles[39] = (0, 79.0515, 0);
	at[39] = 42;
	points[40] = (-931.8071, 22565.5918, 856.3858);
	angles[40] = (0, 79.0509, 0);
	at[40] = 42.2000;
	points[41] = (-931.8071, 22565.5918, 856.3858);
	angles[41] = (0, 79.0509, 0);
	at[41] = 45;
	mover = getEnt("iz_obj_14", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_15()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (6122.7954, 8080.5513, -9.4189);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (6122.7954, 8080.5513, -503.2756);
	angles[1] = (0, 0, 0);
	at[1] = 1.8667;
	points[2] = (6122.7954, 8080.5513, -503.2756);
	angles[2] = (0, 0, 0);
	at[2] = 10.0667;
	points[3] = (6122.7954, 8080.5513, -421.0394);
	angles[3] = (0, 0, 0);
	at[3] = 10.1333;
	points[4] = (6122.7954, 8080.5513, -324.0315);
	angles[4] = (0, 0, 0);
	at[4] = 10.2000;
	points[5] = (6122.7954, 8080.5513, -234.0788);
	angles[5] = (0, 0, 0);
	at[5] = 10.2667;
	points[6] = (6122.7954, 8080.5513, -151.1811);
	angles[6] = (0, 0, 0);
	at[6] = 10.3333;
	points[7] = (6122.7954, 8080.5513, -75.3386);
	angles[7] = (0, 0, 0);
	at[7] = 10.4000;
	points[8] = (6122.7954, 8080.5513, -6.5511);
	angles[8] = (0, 0, 0);
	at[8] = 10.4667;
	points[9] = (6122.7954, 8080.5513, 55.1811);
	angles[9] = (0, 0, 0);
	at[9] = 10.5333;
	points[10] = (6122.7954, 8080.5513, 109.8583);
	angles[10] = (0, 0, 0);
	at[10] = 10.6000;
	points[11] = (6122.7954, 8080.5513, 157.4803);
	angles[11] = (0, 0, 0);
	at[11] = 10.6667;
	points[12] = (6122.7954, 8080.5513, 198.0472);
	angles[12] = (0, 0, 0);
	at[12] = 10.7333;
	points[13] = (6122.7954, 8080.5513, 231.5591);
	angles[13] = (0, 0, 0);
	at[13] = 10.8000;
	points[14] = (6122.7954, 8080.5513, 258.0157);
	angles[14] = (0, 0, 0);
	at[14] = 10.8667;
	points[15] = (6122.7954, 8080.5513, 277.4173);
	angles[15] = (0, 0, 0);
	at[15] = 10.9333;
	points[16] = (6122.7954, 8080.5513, 289.7638);
	angles[16] = (0, 0, 0);
	at[16] = 11;
	points[17] = (6122.7954, 8080.5513, 309.3169);
	angles[17] = (0, 0, 0);
	at[17] = 11.2000;
	points[18] = (6122.7954, 8080.5513, 308.0614);
	angles[18] = (0, 0, 0);
	at[18] = 11.2667;
	points[19] = (6122.7954, 8080.5513, 294.8331);
	angles[19] = (0, 0, 0);
	at[19] = 11.3333;
	points[20] = (6122.7954, 8080.5513, -9.4189);
	angles[20] = (0, 0, 0);
	at[20] = 12.4833;
	mover = getEnt("iz_obj_15", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_16()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (5056.8901, 7396.8506, -503.2756);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (5056.8901, 7396.8506, -503.2756);
	angles[1] = (0, 0, 0);
	at[1] = 3.4000;
	points[2] = (5056.8901, 7396.8506, -498.4252);
	angles[2] = (0, 0, 0);
	at[2] = 3.4667;
	points[3] = (5056.8901, 7396.8506, -396.1260);
	angles[3] = (0, 0, 0);
	at[3] = 3.5333;
	points[4] = (5056.8901, 7396.8506, -300.8819);
	angles[4] = (0, 0, 0);
	at[4] = 3.6000;
	points[5] = (5056.8901, 7396.8506, -212.6929);
	angles[5] = (0, 0, 0);
	at[5] = 3.6667;
	points[6] = (5056.8901, 7396.8506, -131.5591);
	angles[6] = (0, 0, 0);
	at[6] = 3.7333;
	points[7] = (5056.8901, 7396.8506, -57.4803);
	angles[7] = (0, 0, 0);
	at[7] = 3.8000;
	points[8] = (5056.8901, 7396.8506, 9.5433);
	angles[8] = (0, 0, 0);
	at[8] = 3.8667;
	points[9] = (5056.8901, 7396.8506, 69.5118);
	angles[9] = (0, 0, 0);
	at[9] = 3.9333;
	points[10] = (5056.8901, 7396.8506, 122.4252);
	angles[10] = (0, 0, 0);
	at[10] = 4;
	points[11] = (5056.8901, 7396.8506, 168.2835);
	angles[11] = (0, 0, 0);
	at[11] = 4.0667;
	points[12] = (5056.8901, 7396.8506, 207.0866);
	angles[12] = (0, 0, 0);
	at[12] = 4.1333;
	points[13] = (5056.8901, 7396.8506, 238.8347);
	angles[13] = (0, 0, 0);
	at[13] = 4.2000;
	points[14] = (5056.8901, 7396.8506, 263.5276);
	angles[14] = (0, 0, 0);
	at[14] = 4.2667;
	points[15] = (5056.8901, 7396.8506, 281.1654);
	angles[15] = (0, 0, 0);
	at[15] = 4.3333;
	points[16] = (5056.8901, 7396.8506, 291.7480);
	angles[16] = (0, 0, 0);
	at[16] = 4.4000;
	points[17] = (5056.8901, 7396.8506, 295.2756);
	angles[17] = (0, 0, 0);
	at[17] = 4.4667;
	points[18] = (5056.8901, 7396.8506, 309.9587);
	angles[18] = (0, 0, 0);
	at[18] = 4.6000;
	points[19] = (5056.8901, 7396.8506, 308.0614);
	angles[19] = (0, 0, 0);
	at[19] = 4.6667;
	points[20] = (5056.8901, 7396.8506, -503.2756);
	angles[20] = (0, 0, 0);
	at[20] = 7.7333;
	points[21] = (5056.8901, 7396.8506, -503.2756);
	angles[21] = (0, 0, 0);
	at[21] = 12.4833;
	mover = getEnt("iz_obj_16", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_17()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-147.6217, -321.9000, -735.0866);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-147.6217, -321.9000, -735.0866);
	angles[1] = (0, 0, 0);
	at[1] = 3.1333;
	points[2] = (-147.6217, -321.9000, -625.7008);
	angles[2] = (0, 0, 0);
	at[2] = 3.2000;
	points[3] = (-147.6217, -321.9000, -500.9764);
	angles[3] = (0, 0, 0);
	at[3] = 3.2667;
	points[4] = (-147.6217, -321.9000, -385.3228);
	angles[4] = (0, 0, 0);
	at[4] = 3.3333;
	points[5] = (-147.6217, -321.9000, -278.7401);
	angles[5] = (0, 0, 0);
	at[5] = 3.4000;
	points[6] = (-147.6217, -321.9000, -181.2283);
	angles[6] = (0, 0, 0);
	at[6] = 3.4667;
	points[7] = (-147.6217, -321.9000, -92.7874);
	angles[7] = (0, 0, 0);
	at[7] = 3.5333;
	points[8] = (-147.6217, -321.9000, -13.4173);
	angles[8] = (0, 0, 0);
	at[8] = 3.6000;
	points[9] = (-147.6217, -321.9000, 56.8819);
	angles[9] = (0, 0, 0);
	at[9] = 3.6667;
	points[10] = (-147.6217, -321.9000, 118.1102);
	angles[10] = (0, 0, 0);
	at[10] = 3.7333;
	points[11] = (-147.6217, -321.9000, 170.2677);
	angles[11] = (0, 0, 0);
	at[11] = 3.8000;
	points[12] = (-147.6217, -321.9000, 213.3543);
	angles[12] = (0, 0, 0);
	at[12] = 3.8667;
	points[13] = (-147.6217, -321.9000, 247.3701);
	angles[13] = (0, 0, 0);
	at[13] = 3.9333;
	points[14] = (-147.6217, -321.9000, 272.3150);
	angles[14] = (0, 0, 0);
	at[14] = 4;
	points[15] = (-147.6217, -321.9000, 288.1890);
	angles[15] = (0, 0, 0);
	at[15] = 4.0667;
	points[16] = (-147.6217, -321.9000, 309.3169);
	angles[16] = (0, 0, 0);
	at[16] = 4.2667;
	points[17] = (-147.6217, -321.9000, 308.0614);
	angles[17] = (0, 0, 0);
	at[17] = 4.3333;
	points[18] = (-147.6217, -321.9000, 286.5977);
	angles[18] = (0, 0, 0);
	at[18] = 4.4667;
	points[19] = (-147.6217, -321.9000, 280.5925);
	angles[19] = (0, 0, 0);
	at[19] = 4.5333;
	points[20] = (-147.6217, -321.9000, 284.3040);
	angles[20] = (0, 0, 0);
	at[20] = 4.6000;
	points[21] = (-147.6217, -321.9000, 306.2473);
	angles[21] = (0, 0, 0);
	at[21] = 4.7333;
	points[22] = (-147.6217, -321.9000, 309.9587);
	angles[22] = (0, 0, 0);
	at[22] = 4.8000;
	points[23] = (-147.6217, -321.9000, 303.9536);
	angles[23] = (0, 0, 0);
	at[23] = 4.8667;
	points[24] = (-147.6217, -321.9000, 282.4898);
	angles[24] = (0, 0, 0);
	at[24] = 5;
	points[25] = (-147.6217, -321.9000, 281.2343);
	angles[25] = (0, 0, 0);
	at[25] = 5.0667;
	points[26] = (-147.6217, -321.9000, 309.3169);
	angles[26] = (0, 0, 0);
	at[26] = 5.2667;
	points[27] = (-147.6217, -321.9000, 308.0614);
	angles[27] = (0, 0, 0);
	at[27] = 5.3333;
	points[28] = (-147.6217, -321.9000, 286.5977);
	angles[28] = (0, 0, 0);
	at[28] = 5.4667;
	points[29] = (-147.6217, -321.9000, 280.5925);
	angles[29] = (0, 0, 0);
	at[29] = 5.5333;
	points[30] = (-147.6217, -321.9000, 284.3040);
	angles[30] = (0, 0, 0);
	at[30] = 5.6000;
	points[31] = (-147.6217, -321.9000, 306.2473);
	angles[31] = (0, 0, 0);
	at[31] = 5.7333;
	points[32] = (-147.6217, -321.9000, 309.9587);
	angles[32] = (0, 0, 0);
	at[32] = 5.8000;
	points[33] = (-147.6217, -321.9000, 303.9536);
	angles[33] = (0, 0, 0);
	at[33] = 5.8667;
	points[34] = (-147.6217, -321.9000, 282.4898);
	angles[34] = (0, 0, 0);
	at[34] = 6;
	points[35] = (-147.6217, -321.9000, 281.2343);
	angles[35] = (0, 0, 0);
	at[35] = 6.0667;
	points[36] = (-147.6217, -321.9000, 309.3169);
	angles[36] = (0, 0, 0);
	at[36] = 6.2667;
	points[37] = (-147.6217, -321.9000, 308.0614);
	angles[37] = (0, 0, 0);
	at[37] = 6.3333;
	points[38] = (-147.6217, -321.9000, 286.5977);
	angles[38] = (0, 0, 0);
	at[38] = 6.4667;
	points[39] = (-147.6217, -321.9000, 280.5925);
	angles[39] = (0, 0, 0);
	at[39] = 6.5333;
	points[40] = (-147.6217, -321.9000, 284.3040);
	angles[40] = (0, 0, 0);
	at[40] = 6.6000;
	points[41] = (-147.6217, -321.9000, 306.2473);
	angles[41] = (0, 0, 0);
	at[41] = 6.7333;
	points[42] = (-147.6217, -321.9000, 309.9587);
	angles[42] = (0, 0, 0);
	at[42] = 6.8000;
	points[43] = (-147.6217, -321.9000, 303.9536);
	angles[43] = (0, 0, 0);
	at[43] = 6.8667;
	points[44] = (-147.6217, -321.9000, 282.4898);
	angles[44] = (0, 0, 0);
	at[44] = 7;
	points[45] = (-147.6217, -321.9000, 281.2343);
	angles[45] = (0, 0, 0);
	at[45] = 7.0667;
	points[46] = (-147.6217, -321.9000, 309.3169);
	angles[46] = (0, 0, 0);
	at[46] = 7.2667;
	points[47] = (-147.6217, -321.9000, 308.0614);
	angles[47] = (0, 0, 0);
	at[47] = 7.3333;
	points[48] = (-147.6217, -321.9000, 286.5977);
	angles[48] = (0, 0, 0);
	at[48] = 7.4667;
	points[49] = (-147.6217, -321.9000, 280.5925);
	angles[49] = (0, 0, 0);
	at[49] = 7.5333;
	points[50] = (-147.6217, -321.9000, 284.3040);
	angles[50] = (0, 0, 0);
	at[50] = 7.6000;
	points[51] = (-147.6217, -321.9000, 306.2473);
	angles[51] = (0, 0, 0);
	at[51] = 7.7333;
	points[52] = (-147.6217, -321.9000, 309.9587);
	angles[52] = (0, 0, 0);
	at[52] = 7.8000;
	points[53] = (-147.6217, -321.9000, 303.9536);
	angles[53] = (0, 0, 0);
	at[53] = 7.8667;
	points[54] = (-147.6217, -321.9000, 282.4898);
	angles[54] = (0, 0, 0);
	at[54] = 8;
	points[55] = (-147.6217, -321.9000, 281.2343);
	angles[55] = (0, 0, 0);
	at[55] = 8.0667;
	points[56] = (-147.6217, -321.9000, 309.3169);
	angles[56] = (0, 0, 0);
	at[56] = 8.2667;
	points[57] = (-147.6217, -321.9000, 308.0614);
	angles[57] = (0, 0, 0);
	at[57] = 8.3333;
	points[58] = (-147.6217, -321.9000, 286.5977);
	angles[58] = (0, 0, 0);
	at[58] = 8.4667;
	points[59] = (-147.6217, -321.9000, 280.5925);
	angles[59] = (0, 0, 0);
	at[59] = 8.5333;
	points[60] = (-147.6217, -321.9000, 284.3040);
	angles[60] = (0, 0, 0);
	at[60] = 8.6000;
	points[61] = (-147.6217, -321.9000, 306.2473);
	angles[61] = (0, 0, 0);
	at[61] = 8.7333;
	points[62] = (-147.6217, -321.9000, 309.9587);
	angles[62] = (0, 0, 0);
	at[62] = 8.8000;
	points[63] = (-147.6217, -321.9000, 303.9536);
	angles[63] = (0, 0, 0);
	at[63] = 8.8667;
	points[64] = (-147.6217, -321.9000, 282.4898);
	angles[64] = (0, 0, 0);
	at[64] = 9;
	points[65] = (-147.6217, -321.9000, 281.2343);
	angles[65] = (0, 0, 0);
	at[65] = 9.0667;
	points[66] = (-147.6217, -321.9000, 309.3169);
	angles[66] = (0, 0, 0);
	at[66] = 9.2667;
	points[67] = (-147.6217, -321.9000, 308.0614);
	angles[67] = (0, 0, 0);
	at[67] = 9.3333;
	points[68] = (-147.6217, -321.9000, 291.0535);
	angles[68] = (0, 0, 0);
	at[68] = 9.4000;
	points[69] = (-147.6217, -321.9000, -729.4174);
	angles[69] = (0, 0, 0);
	at[69] = 12.4000;
	points[70] = (-147.6217, -321.9000, -735.0866);
	angles[70] = (0, 0, 0);
	at[70] = 12.4667;
	points[71] = (-147.6217, -321.9000, -735.0866);
	angles[71] = (0, 0, 0);
	at[71] = 13.4833;
	mover = getEnt("iz_obj_17", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_18()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (9171.9688, 20360.9062, 4242.2832);
	angles[0] = (0, 78.4927, 0);
	at[0] = 0;
	points[1] = (8343.1494, 20528.8203, 4025.7087);
	angles[1] = (0, 78.7230, 0);
	at[1] = 0.2000;
	points[2] = (7501.9292, 20686.1406, 3803.8977);
	angles[2] = (0, 79.6214, 0);
	at[2] = 0.4000;
	points[3] = (6641.8506, 20844.8828, 3576.7837);
	angles[3] = (0, 79.5173, 0);
	at[3] = 0.6000;
	points[4] = (5765.8662, 21006.9297, 3345.5432);
	angles[4] = (0, 79.5175, 0);
	at[4] = 0.8000;
	points[5] = (4874.8032, 21171.8105, 3110.3110);
	angles[5] = (0, 79.5174, 0);
	at[5] = 1;
	points[6] = (3961.4961, 21340.7891, 2869.2087);
	angles[6] = (0, 79.5175, 0);
	at[6] = 1.2000;
	points[7] = (3038.3191, 21511.6152, 2625.5039);
	angles[7] = (0, 79.5172, 0);
	at[7] = 1.4000;
	points[8] = (2097.2205, 21685.7480, 2377.0669);
	angles[8] = (0, 79.5173, 0);
	at[8] = 1.6000;
	points[9] = (1140.0079, 21862.8750, 2124.3740);
	angles[9] = (0, 79.5174, 0);
	at[9] = 1.8000;
	points[10] = (164.8488, 22043.2676, 1866.9448);
	angles[10] = (0, 79.5173, 0);
	at[10] = 2;
	points[11] = (-828.0394, 22227.0078, 1604.8346);
	angles[11] = (0, 79.5175, 0);
	at[11] = 2.2000;
	points[12] = (-1836.1890, 22413.5449, 1338.6968);
	angles[12] = (0, 79.5179, 0);
	at[12] = 2.4000;
	points[13] = (-2859.7007, 22602.9141, 1068.5039);
	angles[13] = (0, 79.5178, 0);
	at[13] = 2.6000;
	points[14] = (-3204.7915, 22666.7324, 977.4055);
	angles[14] = (0, 79.5185, 0);
	at[14] = 2.8000;
	points[15] = (-3204.7915, 22666.7324, 977.4055);
	angles[15] = (0, 79.5185, 0);
	at[15] = 13.6833;
	points[16] = (25552.3633, 17021.7715, 5998.3071);
	angles[16] = (0, 74.7118, 0);
	at[16] = 13.6833;
	points[17] = (25552.3633, 17021.7715, 5998.3071);
	angles[17] = (0, 74.7118, 0);
	at[17] = 39.8000;
	points[18] = (25109.8828, 17140.4727, 6352.1655);
	angles[18] = (0, 76.0884, 0);
	at[18] = 40;
	points[19] = (24557.9141, 17271.6543, 6688.2681);
	angles[19] = (0, 77.2489, 0);
	at[19] = 40.2000;
	points[20] = (23997.6367, 17385.9453, 6945.1577);
	angles[20] = (0, 79.0649, 0);
	at[20] = 40.4000;
	points[21] = (23446.1035, 17505.4336, 7151.1421);
	angles[21] = (0, 77.5224, 0);
	at[21] = 40.6000;
	points[22] = (22893.2676, 17606.5742, 7287.7559);
	angles[22] = (0, 80.3629, 0);
	at[22] = 40.8000;
	points[23] = (22347.4805, 17711.1035, 7389.5674);
	angles[23] = (0, 78.6403, 0);
	at[23] = 41;
	points[24] = (21803.5820, 17811.4570, 7421.9688);
	angles[24] = (0, 79.8939, 0);
	at[24] = 41.2000;
	points[25] = (21261.4160, 17915.5508, 7375.9448);
	angles[25] = (0, 78.7572, 0);
	at[25] = 41.4000;
	points[26] = (20721.1816, 18024.0156, 7263.7397);
	angles[26] = (0, 78.5504, 0);
	at[26] = 41.6000;
	points[27] = (20173.1895, 18135, 7117.2441);
	angles[27] = (0, 78.5631, 0);
	at[27] = 41.8000;
	points[28] = (19605.1582, 18249.9219, 6968.7798);
	angles[28] = (0, 78.5631, 0);
	at[28] = 42;
	points[29] = (19022.9531, 18367.7168, 6816.6143);
	angles[29] = (0, 78.5631, 0);
	at[29] = 42.2000;
	points[30] = (18424.8027, 18488.7012, 6660.3149);
	angles[30] = (0, 78.5629, 0);
	at[30] = 42.4000;
	points[31] = (17812.4023, 18612.5996, 6500.2754);
	angles[31] = (0, 78.5631, 0);
	at[31] = 42.6000;
	points[32] = (17177.6387, 18741.0234, 6334.4092);
	angles[32] = (0, 78.5630, 0);
	at[32] = 42.8000;
	points[33] = (16531.5352, 18871.7324, 6165.5513);
	angles[33] = (0, 78.5629, 0);
	at[33] = 43;
	points[34] = (15868.3066, 19005.9062, 5992.2046);
	angles[34] = (0, 78.5627, 0);
	at[34] = 43.2000;
	points[35] = (15189.7246, 19143.1895, 5814.8818);
	angles[35] = (0, 78.5629, 0);
	at[35] = 43.4000;
	points[36] = (14495.3945, 19283.6621, 5633.4253);
	angles[36] = (0, 78.5631, 0);
	at[36] = 43.6000;
	points[37] = (13779.8428, 19428.4258, 5446.4175);
	angles[37] = (0, 78.5631, 0);
	at[37] = 43.8000;
	points[38] = (13053.3066, 19575.4336, 5256.5747);
	angles[38] = (0, 78.5627, 0);
	at[38] = 44;
	points[39] = (12309.4092, 19725.9062, 5062.1650);
	angles[39] = (0, 78.5631, 0);
	at[39] = 44.2000;
	points[40] = (11550.0400, 19879.5273, 4863.7007);
	angles[40] = (0, 78.5631, 0);
	at[40] = 44.4000;
	points[41] = (10770.1963, 20037.2832, 4659.9214);
	angles[41] = (0, 78.5629, 0);
	at[41] = 44.6000;
	points[42] = (9978.8193, 20197.4004, 4453.1104);
	angles[42] = (0, 78.5633, 0);
	at[42] = 44.8000;
	points[43] = (9171.9688, 20360.9062, 4242.2832);
	angles[43] = (0, 78.4927, 0);
	at[43] = 45;
	mover = getEnt("iz_obj_18", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_19()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (25552.3633, 17021.7715, 5998.3071);
	angles[0] = (0, 74.7118, 0);
	at[0] = 0;
	points[1] = (25552.3633, 17021.7715, 5998.3071);
	angles[1] = (0, 74.7118, 0);
	at[1] = 9.8000;
	points[2] = (25109.8828, 17140.4727, 6352.1655);
	angles[2] = (0, 76.0884, 0);
	at[2] = 10;
	points[3] = (24557.9141, 17271.6543, 6688.2681);
	angles[3] = (0, 77.2489, 0);
	at[3] = 10.2000;
	points[4] = (23997.6367, 17385.9453, 6945.1577);
	angles[4] = (0, 79.0649, 0);
	at[4] = 10.4000;
	points[5] = (23446.1035, 17505.4336, 7151.1421);
	angles[5] = (0, 77.5224, 0);
	at[5] = 10.6000;
	points[6] = (22893.2676, 17606.5742, 7287.7559);
	angles[6] = (0, 80.3629, 0);
	at[6] = 10.8000;
	points[7] = (22347.4805, 17711.1035, 7389.5674);
	angles[7] = (0, 78.6403, 0);
	at[7] = 11;
	points[8] = (21803.5820, 17811.4570, 7421.9688);
	angles[8] = (0, 79.8939, 0);
	at[8] = 11.2000;
	points[9] = (21261.4160, 17915.5508, 7375.9448);
	angles[9] = (0, 78.7572, 0);
	at[9] = 11.4000;
	points[10] = (20721.1816, 18024.0156, 7263.7397);
	angles[10] = (0, 78.5504, 0);
	at[10] = 11.6000;
	points[11] = (20173.1895, 18135, 7117.2441);
	angles[11] = (0, 78.5631, 0);
	at[11] = 11.8000;
	points[12] = (19605.1582, 18249.9219, 6968.7798);
	angles[12] = (0, 78.5631, 0);
	at[12] = 12;
	points[13] = (19022.9531, 18367.7168, 6816.6143);
	angles[13] = (0, 78.5631, 0);
	at[13] = 12.2000;
	points[14] = (18424.8027, 18488.7012, 6660.3149);
	angles[14] = (0, 78.5629, 0);
	at[14] = 12.4000;
	points[15] = (17812.4023, 18612.5996, 6500.2754);
	angles[15] = (0, 78.5631, 0);
	at[15] = 12.6000;
	points[16] = (17177.6387, 18741.0234, 6334.4092);
	angles[16] = (0, 78.5630, 0);
	at[16] = 12.8000;
	points[17] = (16531.5352, 18871.7324, 6165.5513);
	angles[17] = (0, 78.5629, 0);
	at[17] = 13;
	points[18] = (15868.3066, 19005.9062, 5992.2046);
	angles[18] = (0, 78.5627, 0);
	at[18] = 13.2000;
	points[19] = (15189.7246, 19143.1895, 5814.8818);
	angles[19] = (0, 78.5629, 0);
	at[19] = 13.4000;
	points[20] = (14495.3945, 19283.6621, 5633.4253);
	angles[20] = (0, 78.5631, 0);
	at[20] = 13.6000;
	points[21] = (13779.8428, 19428.4258, 5446.4175);
	angles[21] = (0, 78.5631, 0);
	at[21] = 13.8000;
	points[22] = (13053.3066, 19575.4336, 5256.5747);
	angles[22] = (0, 78.5627, 0);
	at[22] = 14;
	points[23] = (12309.4092, 19725.9062, 5062.1650);
	angles[23] = (0, 78.5631, 0);
	at[23] = 14.2000;
	points[24] = (11550.0400, 19879.5273, 4863.7007);
	angles[24] = (0, 78.5631, 0);
	at[24] = 14.4000;
	points[25] = (10770.1963, 20037.2832, 4659.9214);
	angles[25] = (0, 78.5629, 0);
	at[25] = 14.6000;
	points[26] = (9978.8193, 20197.4004, 4453.1104);
	angles[26] = (0, 78.5633, 0);
	at[26] = 14.8000;
	points[27] = (9171.9688, 20360.9062, 4242.2832);
	angles[27] = (0, 78.4927, 0);
	at[27] = 15;
	points[28] = (8343.1494, 20528.8203, 4025.7087);
	angles[28] = (0, 78.7230, 0);
	at[28] = 15.2000;
	points[29] = (7501.9292, 20686.1406, 3803.8977);
	angles[29] = (0, 79.6214, 0);
	at[29] = 15.4000;
	points[30] = (6641.8506, 20844.8828, 3576.7837);
	angles[30] = (0, 79.5173, 0);
	at[30] = 15.6000;
	points[31] = (5765.8662, 21006.9297, 3345.5432);
	angles[31] = (0, 79.5175, 0);
	at[31] = 15.8000;
	points[32] = (4874.8032, 21171.8105, 3110.3110);
	angles[32] = (0, 79.5174, 0);
	at[32] = 16;
	points[33] = (3961.4961, 21340.7891, 2869.2087);
	angles[33] = (0, 79.5175, 0);
	at[33] = 16.2000;
	points[34] = (3038.3191, 21511.6152, 2625.5039);
	angles[34] = (0, 79.5172, 0);
	at[34] = 16.4000;
	points[35] = (2097.2205, 21685.7480, 2377.0669);
	angles[35] = (0, 79.5173, 0);
	at[35] = 16.6000;
	points[36] = (1140.0079, 21862.8750, 2124.3740);
	angles[36] = (0, 79.5174, 0);
	at[36] = 16.8000;
	points[37] = (164.8488, 22043.2676, 1866.9448);
	angles[37] = (0, 79.5173, 0);
	at[37] = 17;
	points[38] = (-828.0394, 22227.0078, 1604.8346);
	angles[38] = (0, 79.5175, 0);
	at[38] = 17.2000;
	points[39] = (-1836.1890, 22413.5449, 1338.6968);
	angles[39] = (0, 79.5179, 0);
	at[39] = 17.4000;
	points[40] = (-2859.7007, 22602.9141, 1068.5039);
	angles[40] = (0, 79.5178, 0);
	at[40] = 17.6000;
	points[41] = (-3204.7915, 22666.7324, 977.4055);
	angles[41] = (0, 79.5185, 0);
	at[41] = 17.8000;
	points[42] = (-3204.7915, 22666.7324, 977.4055);
	angles[42] = (0, 79.5185, 0);
	at[42] = 28.6833;
	points[43] = (25552.3633, 17021.7715, 5998.3071);
	angles[43] = (0, 74.7118, 0);
	at[43] = 28.6833;
	points[44] = (25552.3633, 17021.7715, 5998.3071);
	angles[44] = (0, 74.7118, 0);
	at[44] = 45;
	mover = getEnt("iz_obj_19", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_20()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (25552.3633, 17021.7715, 5998.3071);
	angles[0] = (0, 74.7118, 0);
	at[0] = 0;
	points[1] = (25552.3633, 17021.7715, 5998.3071);
	angles[1] = (0, 74.7118, 0);
	at[1] = 24.8000;
	points[2] = (25109.8828, 17140.4727, 6352.1655);
	angles[2] = (0, 76.0884, 0);
	at[2] = 25;
	points[3] = (24557.9141, 17271.6543, 6688.2681);
	angles[3] = (0, 77.2489, 0);
	at[3] = 25.2000;
	points[4] = (23997.6367, 17385.9453, 6945.1577);
	angles[4] = (0, 79.0649, 0);
	at[4] = 25.4000;
	points[5] = (23446.1035, 17505.4336, 7151.1421);
	angles[5] = (0, 77.5224, 0);
	at[5] = 25.6000;
	points[6] = (22893.2676, 17606.5742, 7287.7559);
	angles[6] = (0, 80.3629, 0);
	at[6] = 25.8000;
	points[7] = (22347.4805, 17711.1035, 7389.5674);
	angles[7] = (0, 78.6403, 0);
	at[7] = 26;
	points[8] = (21803.5820, 17811.4570, 7421.9688);
	angles[8] = (0, 79.8939, 0);
	at[8] = 26.2000;
	points[9] = (21261.4160, 17915.5508, 7375.9448);
	angles[9] = (0, 78.7572, 0);
	at[9] = 26.4000;
	points[10] = (20721.1816, 18024.0156, 7263.7397);
	angles[10] = (0, 78.5504, 0);
	at[10] = 26.6000;
	points[11] = (20173.1895, 18135, 7117.2441);
	angles[11] = (0, 78.5631, 0);
	at[11] = 26.8000;
	points[12] = (19605.1582, 18249.9219, 6968.7798);
	angles[12] = (0, 78.5631, 0);
	at[12] = 27;
	points[13] = (19022.9531, 18367.7168, 6816.6143);
	angles[13] = (0, 78.5631, 0);
	at[13] = 27.2000;
	points[14] = (18424.8027, 18488.7012, 6660.3149);
	angles[14] = (0, 78.5629, 0);
	at[14] = 27.4000;
	points[15] = (17812.4023, 18612.5996, 6500.2754);
	angles[15] = (0, 78.5631, 0);
	at[15] = 27.6000;
	points[16] = (17177.6387, 18741.0234, 6334.4092);
	angles[16] = (0, 78.5630, 0);
	at[16] = 27.8000;
	points[17] = (16531.5352, 18871.7324, 6165.5513);
	angles[17] = (0, 78.5629, 0);
	at[17] = 28;
	points[18] = (15868.3066, 19005.9062, 5992.2046);
	angles[18] = (0, 78.5627, 0);
	at[18] = 28.2000;
	points[19] = (15189.7246, 19143.1895, 5814.8818);
	angles[19] = (0, 78.5629, 0);
	at[19] = 28.4000;
	points[20] = (14495.3945, 19283.6621, 5633.4253);
	angles[20] = (0, 78.5631, 0);
	at[20] = 28.6000;
	points[21] = (13779.8428, 19428.4258, 5446.4175);
	angles[21] = (0, 78.5631, 0);
	at[21] = 28.8000;
	points[22] = (13053.3066, 19575.4336, 5256.5747);
	angles[22] = (0, 78.5627, 0);
	at[22] = 29;
	points[23] = (12309.4092, 19725.9062, 5062.1650);
	angles[23] = (0, 78.5631, 0);
	at[23] = 29.2000;
	points[24] = (11550.0400, 19879.5273, 4863.7007);
	angles[24] = (0, 78.5631, 0);
	at[24] = 29.4000;
	points[25] = (10770.1963, 20037.2832, 4659.9214);
	angles[25] = (0, 78.5629, 0);
	at[25] = 29.6000;
	points[26] = (9978.8193, 20197.4004, 4453.1104);
	angles[26] = (0, 78.5633, 0);
	at[26] = 29.8000;
	points[27] = (9171.9688, 20360.9062, 4242.2832);
	angles[27] = (0, 78.4927, 0);
	at[27] = 30;
	points[28] = (8343.1494, 20528.8203, 4025.7087);
	angles[28] = (0, 78.7230, 0);
	at[28] = 30.2000;
	points[29] = (7501.9292, 20686.1406, 3803.8977);
	angles[29] = (0, 79.6214, 0);
	at[29] = 30.4000;
	points[30] = (6641.8506, 20844.8828, 3576.7837);
	angles[30] = (0, 79.5173, 0);
	at[30] = 30.6000;
	points[31] = (5765.8662, 21006.9297, 3345.5432);
	angles[31] = (0, 79.5175, 0);
	at[31] = 30.8000;
	points[32] = (4874.8032, 21171.8105, 3110.3110);
	angles[32] = (0, 79.5174, 0);
	at[32] = 31;
	points[33] = (3961.4961, 21340.7891, 2869.2087);
	angles[33] = (0, 79.5175, 0);
	at[33] = 31.2000;
	points[34] = (3038.3191, 21511.6152, 2625.5039);
	angles[34] = (0, 79.5172, 0);
	at[34] = 31.4000;
	points[35] = (2097.2205, 21685.7480, 2377.0669);
	angles[35] = (0, 79.5173, 0);
	at[35] = 31.6000;
	points[36] = (1140.0079, 21862.8750, 2124.3740);
	angles[36] = (0, 79.5174, 0);
	at[36] = 31.8000;
	points[37] = (164.8488, 22043.2676, 1866.9448);
	angles[37] = (0, 79.5173, 0);
	at[37] = 32;
	points[38] = (-828.0394, 22227.0078, 1604.8346);
	angles[38] = (0, 79.5175, 0);
	at[38] = 32.2000;
	points[39] = (-1836.1890, 22413.5449, 1338.6968);
	angles[39] = (0, 79.5179, 0);
	at[39] = 32.4000;
	points[40] = (-2859.7007, 22602.9141, 1068.5039);
	angles[40] = (0, 79.5178, 0);
	at[40] = 32.6000;
	points[41] = (-3204.7915, 22666.7324, 977.4055);
	angles[41] = (0, 79.5185, 0);
	at[41] = 32.8000;
	points[42] = (-3204.7915, 22666.7324, 977.4055);
	angles[42] = (0, 79.5185, 0);
	at[42] = 43.6833;
	points[43] = (25552.3633, 17021.7715, 5998.3071);
	angles[43] = (0, 74.7118, 0);
	at[43] = 43.6833;
	points[44] = (25552.3633, 17021.7715, 5998.3071);
	angles[44] = (0, 74.7118, 0);
	at[44] = 45;
	mover = getEnt("iz_obj_20", "targetname");
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
