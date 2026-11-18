main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_snes_donut_plains_2", 0);

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
	ambientPlay("iz_0_7", 2);
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
	level.iz_route[level.iz_route.size] = (31, -802, 2923);
	level.iz_route[level.iz_route.size] = (-62, -2462, 2923);
	level.iz_route[level.iz_route.size] = (-60, -4793, 2923);
	level.iz_route[level.iz_route.size] = (87, -5643, 2923);
	level.iz_route[level.iz_route.size] = (415, -6330, 2923);
	level.iz_route[level.iz_route.size] = (1193, -6797, 2923);
	level.iz_route[level.iz_route.size] = (2146, -6996, 2921);
	level.iz_route[level.iz_route.size] = (2922, -7036, 2911);
	level.iz_route[level.iz_route.size] = (3748, -7080, 2902);
	level.iz_route[level.iz_route.size] = (4835, -7137, 2913);
	level.iz_route[level.iz_route.size] = (5419, -7093, 2921);
	level.iz_route[level.iz_route.size] = (6258, -6895, 2923);
	level.iz_route[level.iz_route.size] = (7473, -6483, 2923);
	level.iz_route[level.iz_route.size] = (8447, -6098, 2923);
	level.iz_route[level.iz_route.size] = (8697, -5875, 2923);
	level.iz_route[level.iz_route.size] = (8816, -5607, 2923);
	level.iz_route[level.iz_route.size] = (8869, -5255, 2923);
	level.iz_route[level.iz_route.size] = (8815, -4792, 2923);
	level.iz_route[level.iz_route.size] = (8750, -4234, 2923);
	level.iz_route[level.iz_route.size] = (8772, -3976, 2923);
	level.iz_route[level.iz_route.size] = (8960, -3801, 2923);
	level.iz_route[level.iz_route.size] = (9522, -3531, 2923);
	level.iz_route[level.iz_route.size] = (10060, -3261, 2923);
	level.iz_route[level.iz_route.size] = (10312, -3034, 2923);
	level.iz_route[level.iz_route.size] = (10455, -2767, 2923);
	level.iz_route[level.iz_route.size] = (10509, -2501, 2923);
	level.iz_route[level.iz_route.size] = (10520, -1962, 2923);
	level.iz_route[level.iz_route.size] = (10471, -1449, 2923);
	level.iz_route[level.iz_route.size] = (10307, -997, 2923);
	level.iz_route[level.iz_route.size] = (10088, -742, 2923);
	level.iz_route[level.iz_route.size] = (9629, -534, 2923);
	level.iz_route[level.iz_route.size] = (8180, 9, 2923);
	level.iz_route[level.iz_route.size] = (7593, 233, 2923);
	level.iz_route[level.iz_route.size] = (7379, 496, 2923);
	level.iz_route[level.iz_route.size] = (7267, 767, 2923);
	level.iz_route[level.iz_route.size] = (7252, 988, 2923);
	level.iz_route[level.iz_route.size] = (7302, 1207, 2923);
	level.iz_route[level.iz_route.size] = (7505, 1419, 2923);
	level.iz_route[level.iz_route.size] = (8440, 1938, 2927);
	level.iz_route[level.iz_route.size] = (9144, 2473, 2937);
	level.iz_route[level.iz_route.size] = (9355, 3003, 2946);
	level.iz_route[level.iz_route.size] = (9314, 3531, 2948);
	level.iz_route[level.iz_route.size] = (8947, 3998, 2939);
	level.iz_route[level.iz_route.size] = (8131, 4195, 2930);
	level.iz_route[level.iz_route.size] = (7320, 4206, 2925);
	level.iz_route[level.iz_route.size] = (6480, 3984, 2923);
	level.iz_route[level.iz_route.size] = (5610, 3460, 2923);
	level.iz_route[level.iz_route.size] = (5236, 2880, 2923);
	level.iz_route[level.iz_route.size] = (4887, 2020, 2923);
	level.iz_route[level.iz_route.size] = (4411, 579, 2923);
	level.iz_route[level.iz_route.size] = (4122, -552, 2923);
	level.iz_route[level.iz_route.size] = (4082, -1136, 2923);
	level.iz_route[level.iz_route.size] = (4175, -1668, 2923);
	level.iz_route[level.iz_route.size] = (4475, -2224, 2923);
	level.iz_route[level.iz_route.size] = (4916, -2698, 2923);
	level.iz_route[level.iz_route.size] = (5091, -3430, 2923);
	level.iz_route[level.iz_route.size] = (4947, -4139, 2926);
	level.iz_route[level.iz_route.size] = (4542, -4603, 2938);
	level.iz_route[level.iz_route.size] = (3838, -4769, 2948);
	level.iz_route[level.iz_route.size] = (3107, -4702, 2955);
	level.iz_route[level.iz_route.size] = (2435, -4219, 2947);
	level.iz_route[level.iz_route.size] = (2149, -3632, 2933);
	level.iz_route[level.iz_route.size] = (2111, -3173, 2925);
	level.iz_route[level.iz_route.size] = (2122, -2657, 2923);
	level.iz_route[level.iz_route.size] = (2291, -1748, 2923);
	level.iz_route[level.iz_route.size] = (2433, -298, 2923);
	level.iz_route[level.iz_route.size] = (2496, 936, 2923);
	level.iz_route[level.iz_route.size] = (2425, 1866, 2925);
	level.iz_route[level.iz_route.size] = (2154, 2787, 2933);
	level.iz_route[level.iz_route.size] = (1651, 3573, 2956);
	level.iz_route[level.iz_route.size] = (917, 3807, 2965);
	level.iz_route[level.iz_route.size] = (309, 3678, 2957);
	level.iz_route[level.iz_route.size] = (-138, 3256, 2939);
	level.iz_route[level.iz_route.size] = (-196, 2532, 2927);
	level.iz_route[level.iz_route.size] = (-123, 1413, 2923);
	level.iz_route[level.iz_route.size] = (11, 446, 2923);
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
	points[0] = (4399.2124, 2937.0156, 2746.0786);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (4399.0947, 2863.4094, 2746.0708);
	angles[1] = (0, 0, 0);
	at[1] = 0.1667;
	points[2] = (4405.6299, 2827.1968, 2746.0669);
	angles[2] = (0, 0, 0);
	at[2] = 0.2500;
	points[3] = (4447.3228, 2724.7283, 2746.0474);
	angles[3] = (0, 0, 0);
	at[3] = 0.5000;
	points[4] = (4480.1182, 2658.2480, 2746.0354);
	angles[4] = (0, 0, 0);
	at[4] = 0.6667;
	points[5] = (4516.4961, 2595.1653, 2746.0276);
	angles[5] = (0, 0, 0);
	at[5] = 0.8333;
	points[6] = (4608.5039, 2478.9016, 2746.0474);
	angles[6] = (0, 0, 0);
	at[6] = 1.1667;
	points[7] = (4686.6143, 2399.8977, 2746.0630);
	angles[7] = (0, 0, 0);
	at[7] = 1.4167;
	points[8] = (4745.8267, 2358.1299, 2746.0669);
	angles[8] = (0, 0, 0);
	at[8] = 1.5833;
	points[9] = (4935.8271, 2242.7363, 2746.0747);
	angles[9] = (0, 0, 0);
	at[9] = 2.0833;
	points[10] = (5001.4570, 2207.6890, 2746.0708);
	angles[10] = (0, 0, 0);
	at[10] = 2.2500;
	points[11] = (5068.2676, 2176.9175, 2746.0708);
	angles[11] = (0, 0, 0);
	at[11] = 2.4167;
	points[12] = (5099.5278, 2166.1104, 2923.2322);
	angles[12] = (0, 0, 0);
	at[12] = 2.5000;
	points[13] = (5099.5278, 2166.1104, 2923.2322);
	angles[13] = (0, 0, 0);
	at[13] = 4.1667;
	points[14] = (5099.5278, 2166.1104, 3009.2285);
	angles[14] = (0, 0, 0);
	at[14] = 4.2500;
	points[15] = (5099.5278, 2166.1104, 3075.2993);
	angles[15] = (0, 0, 0);
	at[15] = 4.3333;
	points[16] = (5099.5278, 2166.1104, 3121.4331);
	angles[16] = (0, 0, 0);
	at[16] = 4.4167;
	points[17] = (5099.5278, 2166.1104, 3147.6418);
	angles[17] = (0, 0, 0);
	at[17] = 4.5000;
	points[18] = (5099.5278, 2166.1104, 3153.9133);
	angles[18] = (0, 0, 0);
	at[18] = 4.5833;
	points[19] = (5099.5278, 2166.1104, 3140.2600);
	angles[19] = (0, 0, 0);
	at[19] = 4.6667;
	points[20] = (5099.5278, 2166.1104, 3106.6694);
	angles[20] = (0, 0, 0);
	at[20] = 4.7500;
	points[21] = (5099.5278, 2166.1104, 3053.1536);
	angles[21] = (0, 0, 0);
	at[21] = 4.8333;
	points[22] = (5099.5278, 2166.1104, 2979.7009);
	angles[22] = (0, 0, 0);
	at[22] = 4.9167;
	points[23] = (5105.7085, 2164.5156, 2746.0630);
	angles[23] = (0, 0, 0);
	at[23] = 5;
	points[24] = (5214.8428, 2151.6851, 2746.0393);
	angles[24] = (0, 0, 0);
	at[24] = 5.2500;
	points[25] = (5363.2681, 2146.6221, 2745.9922);
	angles[25] = (0, 0, 0);
	at[25] = 5.5833;
	points[26] = (5511.1421, 2148.5198, 2745.9451);
	angles[26] = (0, 0, 0);
	at[26] = 5.9167;
	points[27] = (5622.7168, 2157.0276, 2745.9094);
	angles[27] = (0, 0, 0);
	at[27] = 6.1667;
	points[28] = (5656.5352, 2164.1458, 2745.8975);
	angles[28] = (0, 0, 0);
	at[28] = 6.2500;
	points[29] = (5724.4487, 2193.9844, 2745.8662);
	angles[29] = (0, 0, 0);
	at[29] = 6.4167;
	points[30] = (5820.1182, 2250.6458, 2745.8228);
	angles[30] = (0, 0, 0);
	at[30] = 6.6667;
	points[31] = (5911.5356, 2313.4370, 2745.7795);
	angles[31] = (0, 0, 0);
	at[31] = 6.9167;
	points[32] = (5970, 2358.4568, 2745.7522);
	angles[32] = (0, 0, 0);
	at[32] = 7.0833;
	points[33] = (5996.6143, 2382.8545, 2745.7441);
	angles[33] = (0, 0, 0);
	at[33] = 7.1667;
	points[34] = (6020.0791, 2412, 2745.7363);
	angles[34] = (0, 0, 0);
	at[34] = 7.2500;
	points[35] = (6060.6299, 2473.7795, 2745.7324);
	angles[35] = (0, 0, 0);
	at[35] = 7.4167;
	points[36] = (6097.2837, 2538.1536, 2745.7285);
	angles[36] = (0, 0, 0);
	at[36] = 7.5833;
	points[37] = (6144.6851, 2636.9685, 2745.7246);
	angles[37] = (0, 0, 0);
	at[37] = 7.8333;
	points[38] = (6183.5830, 2780.2283, 2745.7007);
	angles[38] = (0, 0, 0);
	at[38] = 8.1667;
	points[39] = (6212.0869, 2925.1655, 2745.7085);
	angles[39] = (0, 0, 0);
	at[39] = 8.5000;
	points[40] = (6218.4253, 3072.4526, 2745.8818);
	angles[40] = (0, 0, 0);
	at[40] = 8.8333;
	points[41] = (6213.7012, 3220.2600, 2746.0630);
	angles[41] = (0, 0, 0);
	at[41] = 9.1667;
	points[42] = (6206.1421, 3255.7993, 2746.0786);
	angles[42] = (0, 0, 0);
	at[42] = 9.2500;
	points[43] = (6184.4492, 3326.5669, 2746.0786);
	angles[43] = (0, 0, 0);
	at[43] = 9.4167;
	points[44] = (6157.5986, 3395.6892, 2746.0708);
	angles[44] = (0, 0, 0);
	at[44] = 9.5833;
	points[45] = (6141.4175, 3428.8701, 2746.0669);
	angles[45] = (0, 0, 0);
	at[45] = 9.6667;
	points[46] = (6120.9053, 3458.6812, 2746.0669);
	angles[46] = (0, 0, 0);
	at[46] = 9.7500;
	points[47] = (6072.9136, 3514.8503, 2746.0630);
	angles[47] = (0, 0, 0);
	at[47] = 9.9167;
	points[48] = (6021.8110, 3568.6929, 2746.0669);
	angles[48] = (0, 0, 0);
	at[48] = 10.0833;
	points[49] = (5967.6772, 3618.9097, 2746.0630);
	angles[49] = (0, 0, 0);
	at[49] = 10.2500;
	points[50] = (5937.2441, 3640.9961, 2746.0669);
	angles[50] = (0, 0, 0);
	at[50] = 10.3333;
	points[51] = (5903.3071, 3650.7522, 2746.0630);
	angles[51] = (0, 0, 0);
	at[51] = 10.4167;
	points[52] = (5829.2520, 3650.5234, 2746.0630);
	angles[52] = (0, 0, 0);
	at[52] = 10.5833;
	points[53] = (5681.8506, 3635.5474, 2746.0669);
	angles[53] = (0, 0, 0);
	at[53] = 10.9167;
	points[54] = (5667.3623, 3634.2874, 2923.2322);
	angles[54] = (0, 0, 0);
	at[54] = 11;
	points[55] = (5667.3623, 3634.2874, 2923.2322);
	angles[55] = (0, 0, 0);
	at[55] = 12.5833;
	points[56] = (5667.3623, 3634.2874, 2977.2205);
	angles[56] = (0, 0, 0);
	at[56] = 12.6667;
	points[57] = (5667.3623, 3634.2874, 3051.2598);
	angles[57] = (0, 0, 0);
	at[57] = 12.7500;
	points[58] = (5667.3623, 3634.2874, 3105.3704);
	angles[58] = (0, 0, 0);
	at[58] = 12.8333;
	points[59] = (5667.3623, 3634.2874, 3139.5474);
	angles[59] = (0, 0, 0);
	at[59] = 12.9167;
	points[60] = (5667.3623, 3634.2874, 3153.7954);
	angles[60] = (0, 0, 0);
	at[60] = 13;
	points[61] = (5667.3623, 3634.2874, 3148.1101);
	angles[61] = (0, 0, 0);
	at[61] = 13.0833;
	points[62] = (5667.3623, 3634.2874, 3122.4961);
	angles[62] = (0, 0, 0);
	at[62] = 13.1667;
	points[63] = (5667.3623, 3634.2874, 3076.9490);
	angles[63] = (0, 0, 0);
	at[63] = 13.2500;
	points[64] = (5667.3623, 3634.2874, 3011.4727);
	angles[64] = (0, 0, 0);
	at[64] = 13.3333;
	points[65] = (5667.3623, 3634.2874, 2926.0630);
	angles[65] = (0, 0, 0);
	at[65] = 13.4167;
	points[66] = (5638.7012, 3632.1260, 2746.0669);
	angles[66] = (0, 0, 0);
	at[66] = 13.5000;
	points[67] = (5232.7949, 3596.6455, 2746.0669);
	angles[67] = (0, 0, 0);
	at[67] = 14.4167;
	points[68] = (5160.7476, 3586.3386, 2746.0669);
	angles[68] = (0, 0, 0);
	at[68] = 14.5833;
	points[69] = (5125.0391, 3576.4331, 2746.0630);
	angles[69] = (0, 0, 0);
	at[69] = 14.6667;
	points[70] = (5056.1025, 3549.9568, 2746.0591);
	angles[70] = (0, 0, 0);
	at[70] = 14.8333;
	points[71] = (4922.7168, 3489.5986, 2746.0552);
	angles[71] = (0, 0, 0);
	at[71] = 15.1667;
	points[72] = (4718.0312, 3401.4880, 2746.0630);
	angles[72] = (0, 0, 0);
	at[72] = 15.6667;
	points[73] = (4584.7246, 3336.3188, 2746.0669);
	angles[73] = (0, 0, 0);
	at[73] = 16;
	points[74] = (4556.1812, 3315.1101, 2746.0669);
	angles[74] = (0, 0, 0);
	at[74] = 16.0833;
	points[75] = (4508.3071, 3258.8425, 2746.0747);
	angles[75] = (0, 0, 0);
	at[75] = 16.2500;
	points[76] = (4467.1655, 3197.3188, 2746.0828);
	angles[76] = (0, 0, 0);
	at[76] = 16.4167;
	points[77] = (4431.3779, 3132.3110, 2746.0867);
	angles[77] = (0, 0, 0);
	at[77] = 16.5833;
	points[78] = (4418.6221, 3098.9370, 2746.0867);
	angles[78] = (0, 0, 0);
	at[78] = 16.6667;
	points[79] = (4411.3384, 3062.3975, 2746.0867);
	angles[79] = (0, 0, 0);
	at[79] = 16.7500;
	points[80] = (4399.2124, 2937.0156, 2746.0786);
	angles[80] = (0, 0, 0);
	at[80] = 17.0333;
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
	points[0] = (3613.2007, -225.8036, 2745.9961);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (3575.7600, -338.4654, 2746.0120);
	angles[1] = (0, 0, 0);
	at[1] = 0.2667;
	points[2] = (3552.7324, -424.4646, 2746.0198);
	angles[2] = (0, 0, 0);
	at[2] = 0.4667;
	points[3] = (3544.6101, -482.0591, 2746.0159);
	angles[3] = (0, 0, 0);
	at[3] = 0.6000;
	points[4] = (3539.5828, -570.8189, 2746.0078);
	angles[4] = (0, 0, 0);
	at[4] = 0.8000;
	points[5] = (3542.3582, -629.6851, 2746);
	angles[5] = (0, 0, 0);
	at[5] = 0.9333;
	points[6] = (3549.1104, -657.7992, 2746.0039);
	angles[6] = (0, 0, 0);
	at[6] = 1;
	points[7] = (3569.8113, -713.4686, 2746.0159);
	angles[7] = (0, 0, 0);
	at[7] = 1.1333;
	points[8] = (3607.1577, -793.9606, 2746.0354);
	angles[8] = (0, 0, 0);
	at[8] = 1.3333;
	points[9] = (3637.4331, -844.8701, 2746.0474);
	angles[9] = (0, 0, 0);
	at[9] = 1.4667;
	points[10] = (3655.4529, -868.1456, 2746.0552);
	angles[10] = (0, 0, 0);
	at[10] = 1.5333;
	points[11] = (3676.6812, -886.8779, 2746.0591);
	angles[11] = (0, 0, 0);
	at[11] = 1.6000;
	points[12] = (3702.6536, -901.0945, 2746.0591);
	angles[12] = (0, 0, 0);
	at[12] = 1.6667;
	points[13] = (3784.5630, -935.8937, 2746.0630);
	angles[13] = (0, 0, 0);
	at[13] = 1.8667;
	points[14] = (3868.3269, -966.3425, 2746.0630);
	angles[14] = (0, 0, 0);
	at[14] = 2.0667;
	points[15] = (4038.1497, -1017.5197, 2746.0630);
	angles[15] = (0, 0, 0);
	at[15] = 2.4667;
	points[16] = (4068.3857, -1023.7166, 2923.2283);
	angles[16] = (0, 0, 0);
	at[16] = 2.5333;
	points[17] = (4068.3857, -1023.7166, 2923.2283);
	angles[17] = (0, 0, 0);
	at[17] = 4.2000;
	points[18] = (4068.3857, -1023.7166, 2993.6221);
	angles[18] = (0, 0, 0);
	at[18] = 4.2667;
	points[19] = (4068.3857, -1023.7166, 3051.2598);
	angles[19] = (0, 0, 0);
	at[19] = 4.3333;
	points[20] = (4068.3857, -1023.7166, 3096.1416);
	angles[20] = (0, 0, 0);
	at[20] = 4.4000;
	points[21] = (4068.3857, -1023.7166, 3128.2678);
	angles[21] = (0, 0, 0);
	at[21] = 4.4667;
	points[22] = (4068.3857, -1023.7166, 3147.6377);
	angles[22] = (0, 0, 0);
	at[22] = 4.5333;
	points[23] = (4068.3857, -1023.7166, 3154.2520);
	angles[23] = (0, 0, 0);
	at[23] = 4.6000;
	points[24] = (4068.3857, -1023.7166, 3148.1101);
	angles[24] = (0, 0, 0);
	at[24] = 4.6667;
	points[25] = (4068.3857, -1023.7166, 3129.2126);
	angles[25] = (0, 0, 0);
	at[25] = 4.7333;
	points[26] = (4068.3857, -1023.7166, 3097.5591);
	angles[26] = (0, 0, 0);
	at[26] = 4.8000;
	points[27] = (4068.3857, -1023.7166, 3053.1497);
	angles[27] = (0, 0, 0);
	at[27] = 4.8667;
	points[28] = (4068.3857, -1023.7166, 2995.9844);
	angles[28] = (0, 0, 0);
	at[28] = 4.9333;
	points[29] = (4068.3857, -1023.7166, 2926.0630);
	angles[29] = (0, 0, 0);
	at[29] = 5;
	points[30] = (4088.8977, -1026.3425, 2746.0630);
	angles[30] = (0, 0, 0);
	at[30] = 5.0667;
	points[31] = (4207.4805, -1032.4291, 2746.0669);
	angles[31] = (0, 0, 0);
	at[31] = 5.3333;
	points[32] = (4355.8662, -1029.1575, 2746.0669);
	angles[32] = (0, 0, 0);
	at[32] = 5.6667;
	points[33] = (4444.3701, -1019.0197, 2746.0669);
	angles[33] = (0, 0, 0);
	at[33] = 5.8667;
	points[34] = (4473.2681, -1012.2205, 2746.0669);
	angles[34] = (0, 0, 0);
	at[34] = 5.9333;
	points[35] = (4498.2285, -1001.8229, 2746.0630);
	angles[35] = (0, 0, 0);
	at[35] = 6;
	points[36] = (4570.7876, -950.0394, 2746.0513);
	angles[36] = (0, 0, 0);
	at[36] = 6.2000;
	points[37] = (4681.1025, -850.6378, 2746.0276);
	angles[37] = (0, 0, 0);
	at[37] = 6.5333;
	points[38] = (4742.7954, -786.9724, 2746.0120);
	angles[38] = (0, 0, 0);
	at[38] = 6.7333;
	points[39] = (4781.7720, -741.4843, 2746.0039);
	angles[39] = (0, 0, 0);
	at[39] = 6.8667;
	points[40] = (4799.2129, -717.8150, 2746);
	angles[40] = (0, 0, 0);
	at[40] = 6.9333;
	points[41] = (4812.5591, -693.5001, 2745.9961);
	angles[41] = (0, 0, 0);
	at[41] = 7;
	points[42] = (4825.1572, -635.3819, 2745.9961);
	angles[42] = (0, 0, 0);
	at[42] = 7.1333;
	points[43] = (4830.3940, -546.7834, 2745.9922);
	angles[43] = (0, 0, 0);
	at[43] = 7.3333;
	points[44] = (4827.0474, -428.3937, 2745.9922);
	angles[44] = (0, 0, 0);
	at[44] = 7.6000;
	points[45] = (4817.4019, -339.7705, 2745.9922);
	angles[45] = (0, 0, 0);
	at[45] = 7.8000;
	points[46] = (4801.6929, -284.5748, 2746);
	angles[46] = (0, 0, 0);
	at[46] = 7.9333;
	points[47] = (4766.0630, -202.8118, 2746.0198);
	angles[47] = (0, 0, 0);
	at[47] = 8.1333;
	points[48] = (4724.0942, -124.6492, 2746.0393);
	angles[48] = (0, 0, 0);
	at[48] = 8.3333;
	points[49] = (4691.6538, -74.7595, 2746.0513);
	angles[49] = (0, 0, 0);
	at[49] = 8.4667;
	points[50] = (4652.5986, -30.1944, 2746.0630);
	angles[50] = (0, 0, 0);
	at[50] = 8.6000;
	points[51] = (4629.6851, -15.5934, 2746.0669);
	angles[51] = (0, 0, 0);
	at[51] = 8.6667;
	points[52] = (4602.0474, -4.3809, 2746.0669);
	angles[52] = (0, 0, 0);
	at[52] = 8.7333;
	points[53] = (4516.4570, 20.9528, 2746.0669);
	angles[53] = (0, 0, 0);
	at[53] = 8.9333;
	points[54] = (4429.7637, 41.2453, 2746.0669);
	angles[54] = (0, 0, 0);
	at[54] = 9.1333;
	points[55] = (4313.7798, 63.8551, 2746.0669);
	angles[55] = (0, 0, 0);
	at[55] = 9.4000;
	points[56] = (4225.9053, 77.3213, 2746.0630);
	angles[56] = (0, 0, 0);
	at[56] = 9.6000;
	points[57] = (4196.1025, 80.3528, 2923.2283);
	angles[57] = (0, 0, 0);
	at[57] = 9.6667;
	points[58] = (4196.1025, 80.3528, 2923.2283);
	angles[58] = (0, 0, 0);
	at[58] = 11.3333;
	points[59] = (4196.1025, 80.3528, 2993.6221);
	angles[59] = (0, 0, 0);
	at[59] = 11.4000;
	points[60] = (4196.1025, 80.3528, 3051.2598);
	angles[60] = (0, 0, 0);
	at[60] = 11.4667;
	points[61] = (4196.1025, 80.3528, 3096.1416);
	angles[61] = (0, 0, 0);
	at[61] = 11.5333;
	points[62] = (4196.1025, 80.3528, 3128.2678);
	angles[62] = (0, 0, 0);
	at[62] = 11.6000;
	points[63] = (4196.1025, 80.3528, 3147.6377);
	angles[63] = (0, 0, 0);
	at[63] = 11.6667;
	points[64] = (4196.1025, 80.3528, 3154.2520);
	angles[64] = (0, 0, 0);
	at[64] = 11.7333;
	points[65] = (4196.1025, 80.3528, 3148.1101);
	angles[65] = (0, 0, 0);
	at[65] = 11.8000;
	points[66] = (4196.1025, 80.3528, 3129.2126);
	angles[66] = (0, 0, 0);
	at[66] = 11.8667;
	points[67] = (4196.1025, 80.3528, 3097.5591);
	angles[67] = (0, 0, 0);
	at[67] = 11.9333;
	points[68] = (4196.1025, 80.3528, 3053.1497);
	angles[68] = (0, 0, 0);
	at[68] = 12;
	points[69] = (4196.1025, 80.3528, 2995.9844);
	angles[69] = (0, 0, 0);
	at[69] = 12.0667;
	points[70] = (4196.1025, 80.3528, 2926.0630);
	angles[70] = (0, 0, 0);
	at[70] = 12.1333;
	points[71] = (4175.5903, 80.9795, 2746.0630);
	angles[71] = (0, 0, 0);
	at[71] = 12.2000;
	points[72] = (4086.4565, 74.8665, 2746.0669);
	angles[72] = (0, 0, 0);
	at[72] = 12.4000;
	points[73] = (3969.3308, 58.0217, 2746.0669);
	angles[73] = (0, 0, 0);
	at[73] = 12.6667;
	points[74] = (3882.6968, 40.1874, 2746.0630);
	angles[74] = (0, 0, 0);
	at[74] = 12.8667;
	points[75] = (3827.0906, 22.1406, 2746.0591);
	angles[75] = (0, 0, 0);
	at[75] = 13;
	points[76] = (3779.2402, -12.5048, 2746.0474);
	angles[76] = (0, 0, 0);
	at[76] = 13.1333;
	points[77] = (3695.8152, -96.8079, 2746.0159);
	angles[77] = (0, 0, 0);
	at[77] = 13.4000;
	points[78] = (3640.6299, -166.5307, 2745.9961);
	angles[78] = (0, 0, 0);
	at[78] = 13.6000;
	points[79] = (3613.2007, -225.8036, 2745.9961);
	angles[79] = (0, 0, 0);
	at[79] = 13.7500;
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
	points[0] = (4157.4014, -1604.8268, 2923.2283);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (4157.4014, -1604.8268, 2923.2283);
	angles[1] = (0, 0, 0);
	at[1] = 0.5833;
	points[2] = (4157.4014, -1604.8268, 3063.6772);
	angles[2] = (0, 0, 0);
	at[2] = 0.7500;
	points[3] = (4157.4014, -1604.8268, 3113.7993);
	angles[3] = (0, 0, 0);
	at[3] = 0.8333;
	points[4] = (4157.4014, -1604.8268, 3143.9922);
	angles[4] = (0, 0, 0);
	at[4] = 0.9167;
	points[5] = (4157.4014, -1604.8268, 3154.2520);
	angles[5] = (0, 0, 0);
	at[5] = 1;
	points[6] = (4157.4014, -1604.8268, 3144.5828);
	angles[6] = (0, 0, 0);
	at[6] = 1.0833;
	points[7] = (4157.4014, -1604.8268, 3114.9802);
	angles[7] = (0, 0, 0);
	at[7] = 1.1667;
	points[8] = (4157.4014, -1604.8268, 3065.4487);
	angles[8] = (0, 0, 0);
	at[8] = 1.2500;
	points[9] = (4157.4014, -1604.8268, 2995.9844);
	angles[9] = (0, 0, 0);
	at[9] = 1.3333;
	points[10] = (4157.4014, -1604.8268, 2746.0630);
	angles[10] = (0, 0, 0);
	at[10] = 1.4167;
	points[11] = (4123.7402, -1616.7756, 2746.0669);
	angles[11] = (0, 0, 0);
	at[11] = 1.5000;
	points[12] = (4090.9451, -1634.0591, 2746.0669);
	angles[12] = (0, 0, 0);
	at[12] = 1.5833;
	points[13] = (3998.1104, -1695.4843, 2746.0708);
	angles[13] = (0, 0, 0);
	at[13] = 1.8333;
	points[14] = (3911.5591, -1764.5315, 2746.0708);
	angles[14] = (0, 0, 0);
	at[14] = 2.0833;
	points[15] = (3884.2402, -1790.4764, 2746.0669);
	angles[15] = (0, 0, 0);
	at[15] = 2.1667;
	points[16] = (3863.1104, -1819.5355, 2746.0513);
	angles[16] = (0, 0, 0);
	at[16] = 2.2500;
	points[17] = (3847.9688, -1852.7638, 2746.0315);
	angles[17] = (0, 0, 0);
	at[17] = 2.3333;
	points[18] = (3824.2400, -1923.0394, 2745.9766);
	angles[18] = (0, 0, 0);
	at[18] = 2.5000;
	points[19] = (3800.2678, -2031.6497, 2745.8896);
	angles[19] = (0, 0, 0);
	at[19] = 2.7500;
	points[20] = (3799.8464, -2067.5198, 2745.8662);
	angles[20] = (0, 0, 0);
	at[20] = 2.8333;
	points[21] = (3817.6812, -2099.6655, 2745.8464);
	angles[21] = (0, 0, 0);
	at[21] = 2.9167;
	points[22] = (3841.9883, -2127.8032, 2745.8347);
	angles[22] = (0, 0, 0);
	at[22] = 3;
	points[23] = (3895.4529, -2178.9607, 2745.8188);
	angles[23] = (0, 0, 0);
	at[23] = 3.1667;
	points[24] = (4035.7087, -2298.6575, 2745.8936);
	angles[24] = (0, 0, 0);
	at[24] = 3.5833;
	points[25] = (4123.1104, -2367.5078, 2745.9646);
	angles[25] = (0, 0, 0);
	at[25] = 3.8333;
	points[26] = (4334.7637, -2514.9568, 2746.0591);
	angles[26] = (0, 0, 0);
	at[26] = 4.4167;
	points[27] = (4362.3623, -2539.0750, 2746.0669);
	angles[27] = (0, 0, 0);
	at[27] = 4.5000;
	points[28] = (4459.8032, -2650.2205, 2746.0669);
	angles[28] = (0, 0, 0);
	at[28] = 4.8333;
	points[29] = (4513.2676, -2700.9214, 2746.0630);
	angles[29] = (0, 0, 0);
	at[29] = 5;
	points[30] = (4548.5435, -2720.6182, 2746.0630);
	angles[30] = (0, 0, 0);
	at[30] = 5.0833;
	points[31] = (4583.3467, -2734.6340, 2746.0630);
	angles[31] = (0, 0, 0);
	at[31] = 5.1667;
	points[32] = (4687.8345, -2770.6455, 2746.0591);
	angles[32] = (0, 0, 0);
	at[32] = 5.4167;
	points[33] = (4830.5513, -2811.3386, 2746.0591);
	angles[33] = (0, 0, 0);
	at[33] = 5.7500;
	points[34] = (4903.3467, -2825.9331, 2746.0630);
	angles[34] = (0, 0, 0);
	at[34] = 5.9167;
	points[35] = (4910.1182, -2826.7166, 2923.2283);
	angles[35] = (0, 0, 0);
	at[35] = 6;
	points[36] = (4910.1182, -2826.7166, 2923.2283);
	angles[36] = (0, 0, 0);
	at[36] = 7.5833;
	points[37] = (4910.1182, -2826.7166, 3063.6772);
	angles[37] = (0, 0, 0);
	at[37] = 7.7500;
	points[38] = (4910.1182, -2826.7166, 3113.7993);
	angles[38] = (0, 0, 0);
	at[38] = 7.8333;
	points[39] = (4910.1182, -2826.7166, 3143.9922);
	angles[39] = (0, 0, 0);
	at[39] = 7.9167;
	points[40] = (4910.1182, -2826.7166, 3154.2520);
	angles[40] = (0, 0, 0);
	at[40] = 8;
	points[41] = (4910.1182, -2826.7166, 3144.5828);
	angles[41] = (0, 0, 0);
	at[41] = 8.0833;
	points[42] = (4910.1182, -2826.7166, 3114.9802);
	angles[42] = (0, 0, 0);
	at[42] = 8.1667;
	points[43] = (4910.1182, -2826.7166, 3065.4487);
	angles[43] = (0, 0, 0);
	at[43] = 8.2500;
	points[44] = (4910.1182, -2826.7166, 2995.9844);
	angles[44] = (0, 0, 0);
	at[44] = 8.3333;
	points[45] = (4910.1182, -2826.7166, 2746.0630);
	angles[45] = (0, 0, 0);
	at[45] = 8.4167;
	points[46] = (4983.1890, -2826.7126, 2746.0708);
	angles[46] = (0, 0, 0);
	at[46] = 8.5833;
	points[47] = (5056.6143, -2821.6772, 2746.0828);
	angles[47] = (0, 0, 0);
	at[47] = 8.7500;
	points[48] = (5314.8423, -2793.4841, 2746.1340);
	angles[48] = (0, 0, 0);
	at[48] = 9.3333;
	points[49] = (5496.2207, -2765.2246, 2746.2244);
	angles[49] = (0, 0, 0);
	at[49] = 9.7500;
	points[50] = (5603.8979, -2738.9607, 2746.2952);
	angles[50] = (0, 0, 0);
	at[50] = 10;
	points[51] = (5638.5430, -2725.1143, 2746.3110);
	angles[51] = (0, 0, 0);
	at[51] = 10.0833;
	points[52] = (5668.0708, -2704.6931, 2746.2991);
	angles[52] = (0, 0, 0);
	at[52] = 10.1667;
	points[53] = (5722.6377, -2654.8701, 2746.2520);
	angles[53] = (0, 0, 0);
	at[53] = 10.3333;
	points[54] = (5774.0552, -2601.5195, 2746.1970);
	angles[54] = (0, 0, 0);
	at[54] = 10.5000;
	points[55] = (5822.2441, -2545.2913, 2746.1379);
	angles[55] = (0, 0, 0);
	at[55] = 10.6667;
	points[56] = (5863.2681, -2483.6733, 2746.0786);
	angles[56] = (0, 0, 0);
	at[56] = 10.8333;
	points[57] = (5868.6221, -2448.3857, 2746.0591);
	angles[57] = (0, 0, 0);
	at[57] = 10.9167;
	points[58] = (5860.9448, -2412.6104, 2746.0513);
	angles[58] = (0, 0, 0);
	at[58] = 11;
	points[59] = (5821.2988, -2308.7600, 2746.0354);
	angles[59] = (0, 0, 0);
	at[59] = 11.2500;
	points[60] = (5769.3306, -2210.7126, 2746.0276);
	angles[60] = (0, 0, 0);
	at[60] = 11.5000;
	points[61] = (5746.9292, -2180.5354, 2746.0315);
	angles[61] = (0, 0, 0);
	at[61] = 11.5833;
	points[62] = (5716.5352, -2163.1221, 2746.0393);
	angles[62] = (0, 0, 0);
	at[62] = 11.6667;
	points[63] = (5643.7798, -2149.2600, 2746.0669);
	angles[63] = (0, 0, 0);
	at[63] = 11.8333;
	points[64] = (5495.7480, -2141.7520, 2746.1379);
	angles[64] = (0, 0, 0);
	at[64] = 12.1667;
	points[65] = (5460.1968, -2141.6614, 2746.1655);
	angles[65] = (0, 0, 0);
	at[65] = 12.2500;
	points[66] = (5164.5669, -2163.1221, 2746.4292);
	angles[66] = (0, 0, 0);
	at[66] = 12.9167;
	points[67] = (5090.5903, -2162.3386, 2746.4802);
	angles[67] = (0, 0, 0);
	at[67] = 13.0833;
	points[68] = (5055.1182, -2156.4844, 2746.4883);
	angles[68] = (0, 0, 0);
	at[68] = 13.1667;
	points[69] = (4988.7402, -2124.5828, 2746.4448);
	angles[69] = (0, 0, 0);
	at[69] = 13.3333;
	points[70] = (4925.8267, -2085.3230, 2746.3782);
	angles[70] = (0, 0, 0);
	at[70] = 13.5000;
	points[71] = (4805.1182, -1999.4922, 2746.2285);
	angles[71] = (0, 0, 0);
	at[71] = 13.8333;
	points[72] = (4718.5039, -1929.5787, 2746.1262);
	angles[72] = (0, 0, 0);
	at[72] = 14.0833;
	points[73] = (4694.9604, -1902.9764, 2746.1062);
	angles[73] = (0, 0, 0);
	at[73] = 14.1667;
	points[74] = (4674.2915, -1872.3622, 2746.0945);
	angles[74] = (0, 0, 0);
	at[74] = 14.2500;
	points[75] = (4578.7012, -1713.4764, 2746.0708);
	angles[75] = (0, 0, 0);
	at[75] = 14.6667;
	points[76] = (4555.9448, -1684.3464, 2746.0669);
	angles[76] = (0, 0, 0);
	at[76] = 14.7500;
	points[77] = (4528.4648, -1662.3347, 2746.0630);
	angles[77] = (0, 0, 0);
	at[77] = 14.8333;
	points[78] = (4458.0708, -1639.6102, 2746.0630);
	angles[78] = (0, 0, 0);
	at[78] = 15;
	points[79] = (4348.7798, -1617.9331, 2746.0630);
	angles[79] = (0, 0, 0);
	at[79] = 15.2500;
	points[80] = (4238.1890, -1604.4646, 2746.0630);
	angles[80] = (0, 0, 0);
	at[80] = 15.5000;
	points[81] = (4163.9766, -1603.8466, 2746.0630);
	angles[81] = (0, 0, 0);
	at[81] = 15.6667;
	points[82] = (4157.4014, -1604.8268, 2923.2283);
	angles[82] = (0, 0, 0);
	at[82] = 15.7500;
	points[83] = (4157.4014, -1604.8268, 2923.2283);
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
