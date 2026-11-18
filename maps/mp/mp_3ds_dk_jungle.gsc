main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_3ds_dk_jungle", 0);

	setExpFog(5905.5117, 14517.7158, 1, 0.7765, 0.2706, 0);

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
	ambientPlay("iz_0_116", 2);
	iz_emitter("iz_1_se_cc_env_water_fall", (13806.9092, -4801.8750, 1660.9252), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (13533.7793, -4131.9272, 1660.9252), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (13453.9580, -6722.5601, 1660.9252), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (13890.3750, -5739.7617, 1660.9252), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (11017.7178, -7907.4272, 1660.9252), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (11992.3135, -7503.1533, 1660.9252), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (12966.9092, -7098.8794, 1660.9252), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (3478.7246, -7831.2515, 1660.9252), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (4513.2734, -7847.7388, 1660.9252), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (5547.8223, -7864.2261, 1660.9252), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (6582.3716, -7880.7139, 1660.9252), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (7616.9204, -7897.2012, 1660.9252), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (8280.4658, -6518.8701, 1660.9252), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (9311.3887, -6433.5225, 1660.9252), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (10342.3125, -6348.1753, 1660.9252), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (11373.2363, -6262.8276, 1660.9252), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (12299.9326, -5639.5864, 1660.9252), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (12402.0029, -4464.0176, 1660.9252), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (11767.7012, -3787.5286, 1660.9252), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (11133.4014, -3111.0398, 1660.9252), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_water_fall", (10499.0996, -2434.5510, 1660.9252), 0, 12.0104);
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
	level.iz_route[level.iz_route.size] = (-7470, -3314, 2954);
	level.iz_route[level.iz_route.size] = (-6845, -3315, 2955);
	level.iz_route[level.iz_route.size] = (-5753, -3315, 2979);
	level.iz_route[level.iz_route.size] = (-4898, -3315, 2988);
	level.iz_route[level.iz_route.size] = (-4059, -3403, 3033);
	level.iz_route[level.iz_route.size] = (-3530, -3889, 3033);
	level.iz_route[level.iz_route.size] = (-3174, -4524, 2977);
	level.iz_route[level.iz_route.size] = (-2910, -5270, 2886);
	level.iz_route[level.iz_route.size] = (-2423, -6378, 2830);
	level.iz_route[level.iz_route.size] = (-1907, -6885, 2797);
	level.iz_route[level.iz_route.size] = (-1215, -7034, 2748);
	level.iz_route[level.iz_route.size] = (-185, -7015, 2735);
	level.iz_route[level.iz_route.size] = (233, -7317, 2730);
	level.iz_route[level.iz_route.size] = (1055, -7698, 2731);
	level.iz_route[level.iz_route.size] = (2048, -7677, 2731);
	level.iz_route[level.iz_route.size] = (2762, -7260, 2731);
	level.iz_route[level.iz_route.size] = (3300, -7030, 2731);
	level.iz_route[level.iz_route.size] = (4016, -7030, 2897);
	level.iz_route[level.iz_route.size] = (5103, -7030, 2968);
	level.iz_route[level.iz_route.size] = (6184, -7030, 2995);
	level.iz_route[level.iz_route.size] = (6969, -7030, 3002);
	level.iz_route[level.iz_route.size] = (9256, -7030, 2727);
	level.iz_route[level.iz_route.size] = (10786, -6982, 2439);
	level.iz_route[level.iz_route.size] = (11750, -6885, 2246);
	level.iz_route[level.iz_route.size] = (12479, -6508, 2094);
	level.iz_route[level.iz_route.size] = (13025, -5944, 1986);
	level.iz_route[level.iz_route.size] = (13117, -5062, 1869);
	level.iz_route[level.iz_route.size] = (12779, -4273, 1782);
	level.iz_route[level.iz_route.size] = (11911, -3406, 1644);
	level.iz_route[level.iz_route.size] = (10652, -2147, 1569);
	level.iz_route[level.iz_route.size] = (9759, -1297, 1708);
	level.iz_route[level.iz_route.size] = (9096, -400, 1814);
	level.iz_route[level.iz_route.size] = (8983, 371, 1781);
	level.iz_route[level.iz_route.size] = (9382, 1003, 1605);
	level.iz_route[level.iz_route.size] = (10269, 1828, 1354);
	level.iz_route[level.iz_route.size] = (10776, 2452, 1258);
	level.iz_route[level.iz_route.size] = (11154, 3254, 1183);
	level.iz_route[level.iz_route.size] = (11125, 4039, 1146);
	level.iz_route[level.iz_route.size] = (10721, 4809, 1118);
	level.iz_route[level.iz_route.size] = (9926, 5157, 1099);
	level.iz_route[level.iz_route.size] = (9137, 5097, 1108);
	level.iz_route[level.iz_route.size] = (8073, 4723, 1156);
	level.iz_route[level.iz_route.size] = (6861, 4272, 1304);
	level.iz_route[level.iz_route.size] = (6063, 4300, 1452);
	level.iz_route[level.iz_route.size] = (5115, 4727, 1667);
	level.iz_route[level.iz_route.size] = (4333, 5271, 1886);
	level.iz_route[level.iz_route.size] = (3578, 5578, 1930);
	level.iz_route[level.iz_route.size] = (2560, 6481, 2248);
	level.iz_route[level.iz_route.size] = (1419, 7145, 2344);
	level.iz_route[level.iz_route.size] = (389, 7578, 2647);
	level.iz_route[level.iz_route.size] = (-380, 7969, 2586);
	level.iz_route[level.iz_route.size] = (-1992, 8905, 2586);
	level.iz_route[level.iz_route.size] = (-2594, 9213, 2586);
	level.iz_route[level.iz_route.size] = (-2985, 9720, 2586);
	level.iz_route[level.iz_route.size] = (-2891, 10559, 2639);
	level.iz_route[level.iz_route.size] = (-2709, 11606, 2714);
	level.iz_route[level.iz_route.size] = (-2586, 12669, 2768);
	level.iz_route[level.iz_route.size] = (-3127, 13020, 2792);
	level.iz_route[level.iz_route.size] = (-3815, 13406, 2846);
	level.iz_route[level.iz_route.size] = (-4661, 13825, 2879);
	level.iz_route[level.iz_route.size] = (-5108, 13260, 2899);
	level.iz_route[level.iz_route.size] = (-5574, 12436, 3000);
	level.iz_route[level.iz_route.size] = (-5635, 11576, 3110);
	level.iz_route[level.iz_route.size] = (-6172, 10686, 3259);
	level.iz_route[level.iz_route.size] = (-7157, 9707, 3324);
	level.iz_route[level.iz_route.size] = (-8322, 7692, 3338);
	level.iz_route[level.iz_route.size] = (-9413, 5912, 1975);
	level.iz_route[level.iz_route.size] = (-9589, 4896, 2002);
	level.iz_route[level.iz_route.size] = (-10410, 4291, 2008);
	level.iz_route[level.iz_route.size] = (-11363, 3158, 1989);
	level.iz_route[level.iz_route.size] = (-11495, 2348, 1969);
	level.iz_route[level.iz_route.size] = (-12055, 1112, 2344);
	level.iz_route[level.iz_route.size] = (-12657, 176, 2563);
	level.iz_route[level.iz_route.size] = (-13314, -941, 2702);
	level.iz_route[level.iz_route.size] = (-13701, -1644, 2775);
	level.iz_route[level.iz_route.size] = (-13937, -2103, 2824);
	level.iz_route[level.iz_route.size] = (-13910, -2483, 2854);
	level.iz_route[level.iz_route.size] = (-13785, -2857, 2902);
	level.iz_route[level.iz_route.size] = (-13512, -3082, 2895);
	level.iz_route[level.iz_route.size] = (-12973, -3208, 2823);
	level.iz_route[level.iz_route.size] = (-12356, -3132, 2816);
	level.iz_route[level.iz_route.size] = (-11746, -3180, 2828);
	level.iz_route[level.iz_route.size] = (-11112, -3236, 2956);
	level.iz_route[level.iz_route.size] = (-10675, -3261, 3045);
	level.iz_route[level.iz_route.size] = (-10037, -3324, 2953);
	level.iz_route[level.iz_route.size] = (-9934, -3325, 2953);
	level.iz_route[level.iz_route.size] = (-8770, -3322, 2953);
	level.iz_route[level.iz_route.size] = (-8092, -3320, 2953);
	level.iz_route[level.iz_route.size] = (-7842, -3320, 2953);
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
	points[0] = (5808.0317, 11926.2207, -2347.3230);
	angles[0] = (0, -24.8123, 0);
	at[0] = 0;
	points[1] = (5845.0396, 12293.2275, -1707.7836);
	angles[1] = (0, -18.7624, 0);
	at[1] = 0.2167;
	points[2] = (5753.6221, 12422.9922, -945.5157);
	angles[2] = (0, -9.5132, 0);
	at[2] = 0.4333;
	points[3] = (5615.8662, 12482.3623, -190.8933);
	angles[3] = (0, 7.6094, 0);
	at[3] = 0.6500;
	points[4] = (5446.6538, 12519.8027, 557.4843);
	angles[4] = (0, 34.5329, 0);
	at[4] = 0.8667;
	points[5] = (5247.9136, 12558.1895, 1301.1930);
	angles[5] = (0, 57.6122, 0);
	at[5] = 1.0833;
	points[6] = (5016.7324, 12617.1260, 2035.8347);
	angles[6] = (0, 67.5009, 0);
	at[6] = 1.3000;
	points[7] = (4744.5669, 12722.9922, 2749.9766);
	angles[7] = (0, 67.7531, 0);
	at[7] = 1.5167;
	points[8] = (4413.7798, 12925.8271, 3409.3857);
	angles[8] = (0, 61.5064, 0);
	at[8] = 1.7333;
	points[9] = (4016.5750, 13314.5674, 3877.5276);
	angles[9] = (0, 50.4902, 0);
	at[9] = 1.9500;
	points[10] = (3573.3071, 13906.4170, 4119.0947);
	angles[10] = (0, 42.3758, 0);
	at[10] = 2.1667;
	points[11] = (3147.5198, 14510.3545, 4289.3306);
	angles[11] = (0, 38.5548, 0);
	at[11] = 2.3833;
	points[12] = (2718.3623, 15128.7793, 4435.3149);
	angles[12] = (0, 36.6278, 0);
	at[12] = 2.6000;
	points[13] = (2278.1101, 15765.7090, 4568.9370);
	angles[13] = (0, 35.6499, 0);
	at[13] = 2.8167;
	points[14] = (1849.7441, 16384.1738, 4688.0713);
	angles[14] = (0, 35.1928, 0);
	at[14] = 3.0333;
	points[15] = (1410.9921, 17013.9375, 4801.5356);
	angles[15] = (0, 35.0422, 0);
	at[15] = 3.2500;
	points[16] = (971.0945, 17639.6055, 4908.3857);
	angles[16] = (0, 35.0886, 0);
	at[16] = 3.4667;
	points[17] = (529.0827, 18260.8652, 5009.7637);
	angles[17] = (0, 35.2724, 0);
	at[17] = 3.6833;
	points[18] = (79.1421, 18883.7793, 5107.5986);
	angles[18] = (0, 35.5701, 0);
	at[18] = 3.9000;
	points[19] = (-375.2134, 19501.1426, 5201.4570);
	angles[19] = (0, 35.9775, 0);
	at[19] = 4.1167;
	points[20] = (-830.7363, 20105.9062, 5290.8662);
	angles[20] = (0, 36.5020, 0);
	at[20] = 4.3333;
	points[21] = (-1309.3662, 20722.7949, 5379.9209);
	angles[21] = (0, 37.1817, 0);
	at[21] = 4.5500;
	points[22] = (-1777.3425, 21303.3867, 5462.1265);
	angles[22] = (0, 38.0617, 0);
	at[22] = 4.7667;
	points[23] = (-2291.0513, 21907.9512, 5546.5747);
	angles[23] = (0, 39.2643, 0);
	at[23] = 4.9833;
	points[24] = (-2791.0906, 22452.8359, 5622.2437);
	angles[24] = (0, 40.9814, 0);
	at[24] = 5.2000;
	points[25] = (-3362.5117, 22998.9766, 5699.0552);
	angles[25] = (0, 43.8552, 0);
	at[25] = 5.4167;
	points[26] = (-3999.9214, 23440.9062, 5766.6538);
	angles[26] = (0, 50.0564, 0);
	at[26] = 5.6333;
	points[27] = (-4692.2441, 23447.0879, 5795.7085);
	angles[27] = (0, 69.9092, 0);
	at[27] = 5.8500;
	points[28] = (-5329.4097, 23039.2910, 5783.6616);
	angles[28] = (0, 94.8499, 0);
	at[28] = 6.0667;
	points[29] = (-5897.4805, 22522.0469, 5755.9053);
	angles[29] = (0, 112.8673, 0);
	at[29] = 6.2833;
	points[30] = (-6447.5195, 21952.0879, 5719.1343);
	angles[30] = (0, 124.1157, 0);
	at[30] = 6.5000;
	points[31] = (-6956.4966, 21396.1406, 5679.0156);
	angles[31] = (0, 130.6491, 0);
	at[31] = 6.7167;
	points[32] = (-7479.0942, 20817.7168, 5633.1890);
	angles[32] = (0, 134.1714, 0);
	at[32] = 6.9333;
	points[33] = (-7995.3545, 20253.6230, 5584.5278);
	angles[33] = (0, 135.7760, 0);
	at[33] = 7.1500;
	points[34] = (-8527.4414, 19692.2051, 5531.6143);
	angles[34] = (0, 136.0848, 0);
	at[34] = 7.3667;
	points[35] = (-9071.3389, 19150.1582, 5475.3545);
	angles[35] = (0, 135.4182, 0);
	at[35] = 7.5833;
	points[36] = (-9638.3857, 18629.8418, 5415.0396);
	angles[36] = (0, 133.8946, 0);
	at[36] = 7.8000;
	points[37] = (-10233.2676, 18143.9766, 5350.5117);
	angles[37] = (0, 131.4490, 0);
	at[37] = 8.0167;
	points[38] = (-10865.5127, 17707.0469, 5281.1421);
	angles[38] = (0, 127.9138, 0);
	at[38] = 8.2333;
	points[39] = (-11535.1182, 17347.6387, 5207.4019);
	angles[39] = (0, 122.8470, 0);
	at[39] = 8.4500;
	points[40] = (-12260.9834, 17096.1816, 5127.8740);
	angles[40] = (0, 115.7155, 0);
	at[40] = 8.6667;
	points[41] = (-13008.2676, 17009.3691, 5047.2441);
	angles[41] = (0, 105.8555, 0);
	at[41] = 8.8833;
	points[42] = (-13758.8193, 17123.6621, 4968.2676);
	angles[42] = (0, 93.3842, 0);
	at[42] = 9.1000;
	points[43] = (-14361.2598, 17381.6934, 4905.7480);
	angles[43] = (0, 79.8673, 0);
	at[43] = 9.3167;
	points[44] = (-14976.8896, 17764.0547, 4837.2441);
	angles[44] = (0, 69.2180, 0);
	at[44] = 9.5333;
	points[45] = (-15728.7012, 18303.5430, 4750.1182);
	angles[45] = (0, 61.9000, 0);
	at[45] = 9.7500;
	points[46] = (-16257.9131, 18710.3926, 4687.5591);
	angles[46] = (0, 57.2549, 0);
	at[46] = 9.9667;
	points[47] = (-16826.9688, 19164.4102, 4619.5669);
	angles[47] = (0, 54.3776, 0);
	at[47] = 10.1833;
	points[48] = (-17437.4805, 19665.3945, 4546.0630);
	angles[48] = (0, 52.5228, 0);
	at[48] = 10.4000;
	points[49] = (-18086.6543, 20210.0410, 4467.4805);
	angles[49] = (0, 51.2749, 0);
	at[49] = 10.6167;
	points[50] = (-18653.5430, 20693.2676, 4398.6221);
	angles[50] = (0, 50.4167, 0);
	at[50] = 10.8333;
	points[51] = (-19203.4648, 21167.5215, 4331.6538);
	angles[51] = (0, 49.8251, 0);
	at[51] = 11.0500;
	points[52] = (-19772.4023, 21662.7148, 4262.3228);
	angles[52] = (0, 49.3962, 0);
	at[52] = 11.2667;
	points[53] = (-20359.0176, 22177.2051, 4190.7480);
	angles[53] = (0, 49.0717, 0);
	at[53] = 11.4833;
	points[54] = (-20962.0078, 22709.4082, 4117.2051);
	angles[54] = (0, 48.8193, 0);
	at[54] = 11.7000;
	points[55] = (-21556.7324, 23236.9688, 4044.6851);
	angles[55] = (0, 48.6205, 0);
	at[55] = 11.9167;
	points[56] = (-22106.4961, 23726.5352, 3977.7166);
	angles[56] = (0, 48.4680, 0);
	at[56] = 12.1333;
	points[57] = (-22665.9844, 24226.1797, 3909.6260);
	angles[57] = (0, 48.3507, 0);
	at[57] = 12.3500;
	points[58] = (-23234.2910, 24734.8438, 3840.5708);
	angles[58] = (0, 48.2610, 0);
	at[58] = 12.5667;
	points[59] = (-23810.6699, 25251.4961, 3770.6694);
	angles[59] = (0, 48.1939, 0);
	at[59] = 12.7833;
	points[60] = (-24394.1738, 25775.0801, 3700.0591);
	angles[60] = (0, 48.1467, 0);
	at[60] = 13;
	points[61] = (-24983.1094, 26303.7402, 3628.9727);
	angles[61] = (0, 48.1173, 0);
	at[61] = 13.2167;
	points[62] = (-25544.5664, 26807.6758, 3561.3936);
	angles[62] = (0, 48.1046, 0);
	at[62] = 13.4333;
	points[63] = (-26110.1582, 27315.0391, 3493.5117);
	angles[63] = (0, 48.1068, 0);
	at[63] = 13.6500;
	points[64] = (-27251.0625, 28336.6152, 3357.3069);
	angles[64] = (0, 48.1533, 0);
	at[64] = 14.0833;
	points[65] = (-28400.0410, 29361.3398, 3221.2244);
	angles[65] = (0, 48.2535, 0);
	at[65] = 14.5167;
	points[66] = (-30136.8906, 30898.3848, 3018.0159);
	angles[66] = (0, 48.5072, 0);
	at[66] = 15.1667;
	points[67] = (-30714.6074, 31405.3945, 2951.1970);
	angles[67] = (0, 48.6208, 0);
	at[67] = 15.3833;
	points[68] = (-31290, 31907.8340, 2885.0786);
	angles[68] = (0, 48.7500, 0);
	at[68] = 15.6000;
	points[69] = (-31862.4023, 32404.8438, 2819.7678);
	angles[69] = (0, 48.8955, 0);
	at[69] = 15.8167;
	points[70] = (-32431.0234, 32895.4727, 2755.3782);
	angles[70] = (0, 49.0583, 0);
	at[70] = 16.0333;
	points[71] = (-33631.8906, 33919.8047, 2621.2046);
	angles[71] = (0, 49.4544, 0);
	at[71] = 16.4667;
	points[72] = (-34226.7344, 34420.3555, 2555.7637);
	angles[72] = (0, 49.6934, 0);
	at[72] = 16.6833;
	points[73] = (-34813.6211, 34909.1367, 2491.9370);
	angles[73] = (0, 49.9610, 0);
	at[73] = 16.9000;
	points[74] = (-35391.6914, 35384.9609, 2429.8701);
	angles[74] = (0, 50.2594, 0);
	at[74] = 17.1167;
	points[75] = (-35960, 35846.7344, 2369.6968);
	angles[75] = (0, 50.5918, 0);
	at[75] = 17.3333;
	points[76] = (-36582.2852, 36344.6055, 2304.8860);
	angles[76] = (0, 50.9733, 0);
	at[76] = 17.5500;
	points[77] = (-37218.9375, 36844.4492, 2239.8899);
	angles[77] = (0, 51.4331, 0);
	at[77] = 17.7667;
	points[78] = (-37838.1094, 37320, 2178.1221);
	angles[78] = (0, 51.9717, 0);
	at[78] = 17.9833;
	points[79] = (-38438.3477, 37769.3711, 2119.8071);
	angles[79] = (0, 52.5955, 0);
	at[79] = 18.2000;
	points[80] = (-39018.1914, 38190.7461, 2065.1692);
	angles[80] = (0, 53.3168, 0);
	at[80] = 18.4167;
	points[81] = (-39659.0586, 38639.2109, 2007.0789);
	angles[81] = (0, 54.1804, 0);
	at[81] = 18.6333;
	points[82] = (-40358.6602, 39103.4258, 1947);
	angles[82] = (0, 55.3599, 0);
	at[82] = 18.8500;
	points[83] = (-41013.3867, 39507.0859, 1894.7795);
	angles[83] = (0, 56.9122, 0);
	at[83] = 19.0667;
	points[84] = (-41619.6875, 39846.4570, 1850.9449);
	angles[84] = (0, 58.9314, 0);
	at[84] = 19.2833;
	points[85] = (-42358.6641, 40195.6680, 1805.8149);
	angles[85] = (0, 61.8733, 0);
	at[85] = 19.5000;
	points[86] = (-43125.1992, 40436.2188, 1774.6969);
	angles[86] = (0, 67.7284, 0);
	at[86] = 19.7167;
	points[87] = (-43735.0391, 40446.0625, 1773.2875);
	angles[87] = (0, 79.1807, 0);
	at[87] = 19.9333;
	points[88] = (-44373.2266, 40151.5742, 1812.4725);
	angles[88] = (0, 96.7715, 0);
	at[88] = 20.1500;
	points[89] = (-45022.8320, 39583.4648, 1888.8032);
	angles[89] = (0, 113.5937, 0);
	at[89] = 20.3667;
	points[90] = (-45466.9297, 39071.4180, 1957.7992);
	angles[90] = (0, 126.0255, 0);
	at[90] = 20.5833;
	points[91] = (-45921.6562, 38458.2695, 2040.4724);
	angles[91] = (0, 134.5819, 0);
	at[91] = 20.8000;
	points[92] = (-46386.2188, 37752.0469, 2135.7559);
	angles[92] = (0, 140.5608, 0);
	at[92] = 21.0167;
	points[93] = (-46762.2070, 37127.2852, 2220.0750);
	angles[93] = (0, 144.7362, 0);
	at[93] = 21.2333;
	points[94] = (-47122.0469, 36489.0547, 2306.2324);
	angles[94] = (0, 147.6437, 0);
	at[94] = 21.4500;
	points[95] = (-47484.6445, 35809.0977, 2398.0354);
	angles[95] = (0, 149.7829, 0);
	at[95] = 21.6667;
	points[96] = (-47849.2148, 35090.7109, 2495.0237);
	angles[96] = (0, 151.4373, 0);
	at[96] = 21.8833;
	points[97] = (-48188.5820, 34392.6016, 2589.2874);
	angles[97] = (0, 152.7597, 0);
	at[97] = 22.1000;
	points[98] = (-48501.1836, 33727.0469, 2679.1536);
	angles[98] = (0, 153.8111, 0);
	at[98] = 22.3167;
	points[99] = (-48813.3867, 33040.3945, 2771.8582);
	angles[99] = (0, 154.6807, 0);
	at[99] = 22.5333;
	points[100] = (-49125.1992, 32334.8047, 2867.1221);
	angles[100] = (0, 155.4262, 0);
	at[100] = 22.7500;
	points[101] = (-49436.2227, 31612.2852, 2964.6575);
	angles[101] = (0, 156.0812, 0);
	at[101] = 22.9667;
	points[102] = (-49736.6172, 30896.5762, 3061.2678);
	angles[102] = (0, 156.6646, 0);
	at[102] = 23.1833;
	points[103] = (-50021.6562, 30202.2461, 3154.9763);
	angles[103] = (0, 157.1793, 0);
	at[103] = 23.4000;
	points[104] = (-50304.3320, 29498.6230, 3249.9331);
	angles[104] = (0, 157.6413, 0);
	at[104] = 23.6167;
	points[105] = (-50585.0391, 28787.3223, 3345.9055);
	angles[105] = (0, 158.0627, 0);
	at[105] = 23.8333;
	points[106] = (-50862.9961, 28070.0781, 3442.6655);
	angles[106] = (0, 158.4515, 0);
	at[106] = 24.0500;
	points[107] = (-51137.4023, 27348.4648, 3539.9922);
	angles[107] = (0, 158.8127, 0);
	at[107] = 24.2667;
	points[108] = (-51406.6914, 26629.3691, 3636.9685);
	angles[108] = (0, 159.1498, 0);
	at[108] = 24.4833;
	points[109] = (-51671.6523, 25909.8047, 3733.9805);
	angles[109] = (0, 159.4657, 0);
	at[109] = 24.7000;
	points[110] = (-51932.6758, 25190.8672, 3830.8857);
	angles[110] = (0, 159.7633, 0);
	at[110] = 24.9167;
	points[111] = (-52188.9766, 24474.1719, 3927.4568);
	angles[111] = (0, 160.0449, 0);
	at[111] = 25.1333;
	points[112] = (-52440.5508, 23761.3789, 4023.4646);
	angles[112] = (0, 160.3123, 0);
	at[112] = 25.3500;
	points[113] = (-52692.1250, 23038.3066, 4120.8662);
	angles[113] = (0, 160.5681, 0);
	at[113] = 25.5667;
	points[114] = (-52946.8516, 22295.4336, 4220.8267);
	angles[114] = (0, 160.8185, 0);
	at[114] = 25.7833;
	points[115] = (-53195.2773, 21562.5996, 4319.4487);
	angles[115] = (0, 161.0627, 0);
	at[115] = 26;
	points[116] = (-53435.8281, 20841.7324, 4416.4175);
	angles[116] = (0, 161.3002, 0);
	at[116] = 26.2167;
	points[117] = (-53898.8203, 19428.3066, 4606.3384);
	angles[117] = (0, 161.7567, 0);
	at[117] = 26.6500;
	points[118] = (-54146.8477, 18654.6855, 4710.1968);
	angles[118] = (0, 161.9892, 0);
	at[118] = 26.8667;
	points[119] = (-54383.0703, 17907.7559, 4810.3545);
	angles[119] = (0, 162.2287, 0);
	at[119] = 27.0833;
	points[120] = (-54606.6953, 17190.3926, 4906.4961);
	angles[120] = (0, 162.4722, 0);
	at[120] = 27.3000;
	points[121] = (-54816.5352, 16505.6309, 4998.1104);
	angles[121] = (0, 162.7198, 0);
	at[121] = 27.5167;
	points[122] = (-55047.6367, 15738.0713, 5100.7085);
	angles[122] = (0, 162.9839, 0);
	at[122] = 27.7333;
	points[123] = (-55277.1680, 14959.5273, 5204.5278);
	angles[123] = (0, 163.2941, 0);
	at[123] = 27.9500;
	points[124] = (-55479.5312, 14254.0938, 5298.3071);
	angles[124] = (0, 163.6495, 0);
	at[124] = 28.1667;
	points[125] = (-55670.0820, 13567.9932, 5389.1729);
	angles[125] = (0, 164.0661, 0);
	at[125] = 28.3833;
	points[126] = (-55891.3398, 12723.4248, 5500.0786);
	angles[126] = (0, 164.7598, 0);
	at[126] = 28.6000;
	points[127] = (-56028.3477, 12112.2842, 5578.5825);
	angles[127] = (0, 166.1626, 0);
	at[127] = 28.8167;
	points[128] = (-56126.7734, 11353.1895, 5676.2598);
	angles[128] = (0, 169.7698, 0);
	at[128] = 29.0333;
	points[129] = (-55828.3477, 10735.2754, 5757.2051);
	angles[129] = (0, 189.4601, 0);
	at[129] = 29.2500;
	points[130] = (-55053.5430, 10722.5986, 5747.9917);
	angles[130] = (0, 223.9572, 0);
	at[130] = 29.4667;
	points[131] = (-54294.8828, 10801.8115, 5718.8975);
	angles[131] = (0, 247.9382, 0);
	at[131] = 29.6833;
	points[132] = (-53527.9531, 10850.7871, 5688.0312);
	angles[132] = (0, 260.1631, 0);
	at[132] = 29.9000;
	points[133] = (-52777.5625, 10850.1572, 5659.8818);
	angles[133] = (0, 264.7501, 0);
	at[133] = 30.1167;
	points[134] = (-52014.5703, 10796.9688, 5634.5669);
	angles[134] = (0, 265.1629, 0);
	at[134] = 30.3333;
	points[135] = (-51237.4062, 10689.2520, 5612.4805);
	angles[135] = (0, 263.5195, 0);
	at[135] = 30.5500;
	points[136] = (-50509.0586, 10541.2207, 5595.3540);
	angles[136] = (0, 260.9305, 0);
	at[136] = 30.7667;
	points[137] = (-49741.3398, 10338.2686, 5580.9058);
	angles[137] = (0, 258.0027, 0);
	at[137] = 30.9833;
	points[138] = (-49170.0820, 10166.4170, 5571.8110);
	angles[138] = (0, 255.6794, 0);
	at[138] = 31.2000;
	points[139] = (-48469.2930, 9954.0547, 5560.7090);
	angles[139] = (0, 254.4392, 0);
	at[139] = 31.4167;
	points[140] = (-47620.8633, 9695.8662, 5547.2441);
	angles[140] = (0, 253.7765, 0);
	at[140] = 31.6333;
	points[141] = (-46862.9922, 9464.9209, 5535.2363);
	angles[141] = (0, 253.4214, 0);
	at[141] = 31.8500;
	points[142] = (-46201.1836, 9262.9922, 5524.7246);
	angles[142] = (0, 253.2318, 0);
	at[142] = 32.0667;
	points[143] = (-45491.3398, 9046.2998, 5513.4253);
	angles[143] = (0, 253.1293, 0);
	at[143] = 32.2833;
	points[144] = (-44735.8281, 8815.5908, 5501.3779);
	angles[144] = (0, 253.0730, 0);
	at[144] = 32.5000;
	points[145] = (-43142.9141, 8328.7402, 5475.9453);
	angles[145] = (0, 253.0235, 0);
	at[145] = 32.9333;
	points[146] = (-42463.7773, 8121.1025, 5465.0391);
	angles[146] = (0, 253.0133, 0);
	at[146] = 33.1500;
	points[147] = (-41762.2070, 7906.6533, 5453.7397);
	angles[147] = (0, 253.0077, 0);
	at[147] = 33.3667;
	points[148] = (-41039.7656, 7685.8271, 5442.1260);
	angles[148] = (0, 253.0048, 0);
	at[148] = 33.5833;
	points[149] = (-40297.6367, 7458.9370, 5430.1182);
	angles[149] = (0, 253.0036, 0);
	at[149] = 33.8000;
	points[150] = (-39536.6133, 7226.3779, 5417.7954);
	angles[150] = (0, 253.0036, 0);
	at[150] = 34.0167;
	points[151] = (-38758.3867, 6988.4648, 5405.1577);
	angles[151] = (0, 253.0046, 0);
	at[151] = 34.2333;
	points[152] = (-38001.8516, 6757.3228, 5392.8345);
	angles[152] = (0, 253.0063, 0);
	at[152] = 34.4500;
	points[153] = (-37296.4180, 6541.7715, 5381.3389);
	angles[153] = (0, 253.0085, 0);
	at[153] = 34.6667;
	points[154] = (-36580.1562, 6322.9922, 5369.6064);
	angles[154] = (0, 253.0111, 0);
	at[154] = 34.8833;
	points[155] = (-35853.8594, 6101.1416, 5357.7163);
	angles[155] = (0, 253.0141, 0);
	at[155] = 35.1000;
	points[156] = (-35118.2266, 5876.5356, 5345.5908);
	angles[156] = (0, 253.0175, 0);
	at[156] = 35.3167;
	points[157] = (-34374.0547, 5649.3701, 5333.3071);
	angles[157] = (0, 253.0214, 0);
	at[157] = 35.5333;
	points[158] = (-33622.1641, 5419.9214, 5320.8657);
	angles[158] = (0, 253.0256, 0);
	at[158] = 35.7500;
	points[159] = (-32863.2695, 5188.4253, 5308.2681);
	angles[159] = (0, 253.0302, 0);
	at[159] = 35.9667;
	points[160] = (-32121.2988, 4962.1260, 5295.9058);
	angles[160] = (0, 253.0352, 0);
	at[160] = 36.1833;
	points[161] = (-31396.2207, 4741.1025, 5283.7793);
	angles[161] = (0, 253.0404, 0);
	at[161] = 36.4000;
	points[162] = (-30666.9688, 4518.8188, 5271.5356);
	angles[162] = (0, 253.0460, 0);
	at[162] = 36.6167;
	points[163] = (-29198.3477, 4071.5354, 5246.7720);
	angles[163] = (0, 253.0581, 0);
	at[163] = 37.0500;
	points[164] = (-27720.5918, 3621.8662, 5221.6929);
	angles[164] = (0, 253.0718, 0);
	at[164] = 37.4833;
	points[165] = (-24754.3691, 2720.6260, 5170.6694);
	angles[165] = (0, 253.1045, 0);
	at[165] = 38.3500;
	points[166] = (-23276.4980, 2272.4016, 5144.8818);
	angles[166] = (0, 253.1237, 0);
	at[166] = 38.7833;
	points[167] = (-21810.1582, 1828.2756, 5119.0156);
	angles[167] = (0, 253.1451, 0);
	at[167] = 39.2167;
	points[168] = (-21082.8750, 1608.2599, 5106.1025);
	angles[168] = (0, 253.1568, 0);
	at[168] = 39.4333;
	points[169] = (-20360.4336, 1389.8779, 5093.1895);
	angles[169] = (0, 253.1692, 0);
	at[169] = 39.6500;
	points[170] = (-18844.3301, 932.2205, 5065.8267);
	angles[170] = (0, 253.1968, 0);
	at[170] = 40.0833;
	points[171] = (-18093.5430, 705.9252, 5052.1265);
	angles[171] = (0, 253.2124, 0);
	at[171] = 40.3000;
	points[172] = (-17351.2988, 482.4646, 5038.5039);
	angles[172] = (0, 253.2289, 0);
	at[172] = 40.5167;
	points[173] = (-16618.4258, 262.0890, 5024.9214);
	angles[173] = (0, 253.2468, 0);
	at[173] = 40.7333;
	points[174] = (-15895.7490, 45.0468, 5011.4175);
	angles[174] = (0, 253.2658, 0);
	at[174] = 40.9500;
	points[175] = (-15183.9766, -168.4165, 4997.9922);
	angles[175] = (0, 253.2861, 0);
	at[175] = 41.1667;
	points[176] = (-14480.2764, -379.1614, 4984.6064);
	angles[176] = (0, 253.3078, 0);
	at[176] = 41.3833;
	points[177] = (-13688.1494, -615.9764, 4969.3701);
	angles[177] = (0, 253.3324, 0);
	at[177] = 41.6000;
	points[178] = (-12913.8975, -846.9803, 4954.2915);
	angles[178] = (0, 253.3604, 0);
	at[178] = 41.8167;
	points[179] = (-12158.7803, -1071.7914, 4939.3701);
	angles[179] = (0, 253.3915, 0);
	at[179] = 42.0333;
	points[180] = (-11423.9375, -1290.0354, 4924.6455);
	angles[180] = (0, 253.4258, 0);
	at[180] = 42.2500;
	points[181] = (-10710.6689, -1501.3307, 4910.1577);
	angles[181] = (0, 253.4637, 0);
	at[181] = 42.4667;
	points[182] = (-10020.1182, -1705.2914, 4895.8662);
	angles[182] = (0, 253.5055, 0);
	at[182] = 42.6833;
	points[183] = (-9299.7637, -1917.3346, 4880.6694);
	angles[183] = (0, 253.5524, 0);
	at[183] = 42.9000;
	points[184] = (-8475.0791, -2159.0159, 4862.8345);
	angles[184] = (0, 253.6115, 0);
	at[184] = 43.1167;
	points[185] = (-7695.5908, -2386.1812, 4845.4722);
	angles[185] = (0, 253.6844, 0);
	at[185] = 43.3333;
	points[186] = (-6963.9370, -2598.0042, 4828.6221);
	angles[186] = (0, 253.7722, 0);
	at[186] = 43.5500;
	points[187] = (-6282.7949, -2793.6418, 4812.3228);
	angles[187] = (0, 253.8776, 0);
	at[187] = 43.7667;
	points[188] = (-5627.7563, -2979.8977, 4795.9058);
	angles[188] = (0, 254.0054, 0);
	at[188] = 43.9833;
	points[189] = (-4716.6538, -3234.5002, 4771.2993);
	angles[189] = (0, 254.2114, 0);
	at[189] = 44.2000;
	points[190] = (-3970.5906, -3436.3821, 4748.5039);
	angles[190] = (0, 254.5602, 0);
	at[190] = 44.4167;
	points[191] = (-3401.4724, -3581.7798, 4727.7168);
	angles[191] = (0, 255.1665, 0);
	at[191] = 44.6333;
	points[192] = (-2616.7009, -3752.6025, 4690.4727);
	angles[192] = (0, 256.5507, 0);
	at[192] = 44.8500;
	points[193] = (-1877.3977, -3860.1104, 4642.7559);
	angles[193] = (0, 259.2502, 0);
	at[193] = 45.0667;
	points[194] = (-1123.0433, -3846.6023, 4562.5591);
	angles[194] = (0, 265.5984, 0);
	at[194] = 45.2833;
	points[195] = (-635.4449, -3400.8662, 4384.0947);
	angles[195] = (0, 288.9600, 0);
	at[195] = 45.5000;
	points[196] = (-825.4173, -2687.4565, 4166.3779);
	angles[196] = (0, 324.8309, 0);
	at[196] = 45.7167;
	points[197] = (-1139.2166, -2022.4883, 3929.0828);
	angles[197] = (0, 352.2380, 0);
	at[197] = 45.9333;
	points[198] = (-1249.0237, -1375.6810, 3559.0354);
	angles[198] = (0, 358.0602, 0);
	at[198] = 46.1500;
	points[199] = (-987.2874, -930.3307, 3024.5237);
	angles[199] = (0, 346.3912, 0);
	at[199] = 46.3667;
	points[200] = (-753.0709, -496.2047, 2428.8347);
	angles[200] = (0, 340.1583, 0);
	at[200] = 46.5833;
	points[201] = (-308.5205, 364.9488, 1219.7047);
	angles[201] = (0, 334.9632, 0);
	at[201] = 47.0167;
	points[202] = (-89.5236, 797.8110, 621.8780);
	angles[202] = (0, 334.1105, 0);
	at[202] = 47.2333;
	points[203] = (132.0169, 1238.3937, 30.0884);
	angles[203] = (0, 333.7230, 0);
	at[203] = 47.4500;
	points[204] = (359.6291, 1692.1772, -553.9882);
	angles[204] = (0, 333.5458, 0);
	at[204] = 47.6667;
	points[205] = (595.1968, 2161.2795, -1119.7283);
	angles[205] = (0, 333.4377, 0);
	at[205] = 47.8833;
	points[206] = (844.6968, 2655.2246, -1654.7637);
	angles[206] = (0, 333.3080, 0);
	at[206] = 48.1000;
	points[207] = (1124.2047, 3200.4526, -2128.4016);
	angles[207] = (0, 333.0497, 0);
	at[207] = 48.3167;
	points[208] = (1435.9607, 3784.6455, -2392.1458);
	angles[208] = (0, 332.3710, 0);
	at[208] = 48.5333;
	points[209] = (1805.3544, 4450.4727, -2529.2402);
	angles[209] = (0, 331.6279, 0);
	at[209] = 48.7500;
	points[210] = (2181.4055, 5121.8896, -2617.9016);
	angles[210] = (0, 331.1820, 0);
	at[210] = 48.9667;
	points[211] = (2563.0591, 5801.8896, -2680.3938);
	angles[211] = (0, 330.9426, 0);
	at[211] = 49.1833;
	points[212] = (2936.4133, 6467.7563, -2722.8938);
	angles[212] = (0, 330.8362, 0);
	at[212] = 49.4000;
	points[213] = (3313.3308, 7141.9688, -2750.6260);
	angles[213] = (0, 330.8202, 0);
	at[213] = 49.6167;
	points[214] = (3687.7166, 7815, -2764.4607);
	angles[214] = (0, 330.8720, 0);
	at[214] = 49.8333;
	points[215] = (4062.0081, 8492.5596, -2764.6418);
	angles[215] = (0, 330.9845, 0);
	at[215] = 50.0500;
	points[216] = (4432.4019, 9169.7637, -2750.0315);
	angles[216] = (0, 331.1623, 0);
	at[216] = 50.2667;
	points[217] = (4793.7402, 9840.0391, -2718.4016);
	angles[217] = (0, 331.4299, 0);
	at[217] = 50.4833;
	points[218] = (5158.1104, 10531.6533, -2661.8306);
	angles[218] = (0, 331.8481, 0);
	at[218] = 50.7000;
	points[219] = (5505.3545, 11220.9053, -2565.8660);
	angles[219] = (0, 332.5956, 0);
	at[219] = 50.9167;
	points[220] = (5795.9448, 11887.3223, -2369.5789);
	angles[220] = (0, 334.7750, 0);
	at[220] = 51.1333;
	points[221] = (5808.0317, 11926.2207, -2347.3230);
	angles[221] = (0, 335.1877, 0);
	at[221] = 51.1500;
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
	points[0] = (8167.7168, 4519.9604, 1147.8937);
	angles[0] = (0, -60, 0);
	at[0] = 0;
	points[1] = (8167.7559, 4518.8975, 1147.8898);
	angles[1] = (0, -60, 0);
	at[1] = 0.6667;
	points[2] = (8168.5825, 4504.1338, 1147.8503);
	angles[2] = (0, -60, 0);
	at[2] = 0.8333;
	points[3] = (8167.9531, 4515, 1147.8820);
	angles[3] = (0, -60, 0);
	at[3] = 1;
	points[4] = (8167.9531, 4515, 1147.8820);
	angles[4] = (0, -60, 0);
	at[4] = 2.1667;
	points[5] = (8167.5591, 4522.4019, 1147.9016);
	angles[5] = (0, -60, 0);
	at[5] = 2.3333;
	points[6] = (8165.9058, 4551.2993, 1147.9764);
	angles[6] = (0, -60, 0);
	at[6] = 2.5000;
	points[7] = (8165.3149, 4562.1655, 1148.0039);
	angles[7] = (0, -60, 0);
	at[7] = 2.6667;
	points[8] = (8165.3149, 4562.1655, 1148.0039);
	angles[8] = (0, -60, 0);
	at[8] = 3.8333;
	points[9] = (8164.8818, 4569.6064, 1148.0236);
	angles[9] = (0, -60, 0);
	at[9] = 4;
	points[10] = (8163.2676, 4598.4648, 1148.0984);
	angles[10] = (0, -60, 0);
	at[10] = 4.1667;
	points[11] = (8162.6377, 4609.3311, 1148.1497);
	angles[11] = (0, -60, 0);
	at[11] = 4.3333;
	points[12] = (8162.6377, 4609.3311, 1148.1497);
	angles[12] = (0, -60, 0);
	at[12] = 5.5000;
	points[13] = (8162.0869, 4619.2520, 1148.2362);
	angles[13] = (0, -60, 0);
	at[13] = 5.6667;
	points[14] = (8160.4331, 4648.5825, 1148.5040);
	angles[14] = (0, -60, 0);
	at[14] = 5.8333;
	points[15] = (8159.8032, 4659.4487, 1148.6024);
	angles[15] = (0, -60, 0);
	at[15] = 6;
	points[16] = (8159.8032, 4659.4487, 1148.6024);
	angles[16] = (0, -60, 0);
	at[16] = 7.1667;
	points[17] = (8159.2520, 4669.3306, 1148.6929);
	angles[17] = (0, -60, 0);
	at[17] = 7.3333;
	points[18] = (8157.5986, 4698.7007, 1148.9567);
	angles[18] = (0, -60, 0);
	at[18] = 7.5000;
	points[19] = (8157.0083, 4709.5669, 1149.0552);
	angles[19] = (0, -60, 0);
	at[19] = 7.6667;
	points[20] = (8157.0083, 4709.5669, 1149.0552);
	angles[20] = (0, -60, 0);
	at[20] = 8.8333;
	points[21] = (8156.4565, 4719.4487, 1149.1456);
	angles[21] = (0, -60, 0);
	at[21] = 9;
	points[22] = (8154.8032, 4748.8188, 1149.4094);
	angles[22] = (0, -60, 0);
	at[22] = 9.1667;
	points[23] = (8154.1733, 4759.6851, 1149.4646);
	angles[23] = (0, -60, 0);
	at[23] = 9.3333;
	points[24] = (8154.1733, 4759.6851, 1149.4646);
	angles[24] = (0, -60, 0);
	at[24] = 10.5000;
	points[25] = (8153.6226, 4769.5669, 1149.4922);
	angles[25] = (0, -60, 0);
	at[25] = 10.6667;
	points[26] = (8151.9688, 4798.9370, 1149.5826);
	angles[26] = (0, -60, 0);
	at[26] = 10.8333;
	points[27] = (8151.3389, 4809.8032, 1149.6141);
	angles[27] = (0, -60, 0);
	at[27] = 11;
	points[28] = (8151.3389, 4809.8032, 1149.6141);
	angles[28] = (0, -60, 0);
	at[28] = 12.1667;
	points[29] = (8150.7876, 4819.6851, 1149.6458);
	angles[29] = (0, -60, 0);
	at[29] = 12.3333;
	points[30] = (8149.0947, 4849.0552, 1149.7362);
	angles[30] = (0, -60, 0);
	at[30] = 12.5000;
	points[31] = (8148.4644, 4859.9214, 1149.7677);
	angles[31] = (0, -60, 0);
	at[31] = 12.6667;
	points[32] = (8148.4644, 4859.9214, 1149.7677);
	angles[32] = (0, -60, 0);
	at[32] = 13.8333;
	points[33] = (8147.9136, 4869.8032, 1149.8268);
	angles[33] = (0, -60, 0);
	at[33] = 14;
	points[34] = (8146.2207, 4899.1733, 1150.0984);
	angles[34] = (0, -60, 0);
	at[34] = 14.1667;
	points[35] = (8145.6299, 4910.0391, 1150.2008);
	angles[35] = (0, -60, 0);
	at[35] = 14.3333;
	points[36] = (8145.6299, 4910.0391, 1150.2008);
	angles[36] = (0, -60, 0);
	at[36] = 15.5000;
	points[37] = (8145.0396, 4919.9214, 1150.2914);
	angles[37] = (0, -60, 0);
	at[37] = 15.6667;
	points[38] = (8143.3857, 4949.2915, 1150.5433);
	angles[38] = (0, -60, 0);
	at[38] = 15.8333;
	points[39] = (8142.7563, 4960.1182, 1150.5787);
	angles[39] = (0, -60, 0);
	at[39] = 16;
	points[40] = (8142.7563, 4960.1182, 1150.5787);
	angles[40] = (0, -60, 0);
	at[40] = 17.1667;
	points[41] = (8142.2046, 4970.0396, 1150.6102);
	angles[41] = (0, -60, 0);
	at[41] = 17.3333;
	points[42] = (8140.5117, 4999.4097, 1150.7087);
	angles[42] = (0, -60, 0);
	at[42] = 17.5000;
	points[43] = (8139.8823, 5010.2363, 1150.7441);
	angles[43] = (0, -60, 0);
	at[43] = 17.6667;
	points[44] = (8139.8823, 5010.2363, 1150.7441);
	angles[44] = (0, -60, 0);
	at[44] = 18.8333;
	points[45] = (8139.3306, 5020.1577, 1150.7756);
	angles[45] = (0, -60, 0);
	at[45] = 19;
	points[46] = (8137.6377, 5049.5273, 1150.8701);
	angles[46] = (0, -60, 0);
	at[46] = 19.1667;
	points[47] = (8137.0078, 5060.3545, 1150.9489);
	angles[47] = (0, -60, 0);
	at[47] = 19.3333;
	points[48] = (8137.0078, 5060.3545, 1150.9489);
	angles[48] = (0, -60, 0);
	at[48] = 20.5000;
	points[49] = (8136.4570, 5070.2759, 1151.0433);
	angles[49] = (0, -60, 0);
	at[49] = 20.6667;
	points[50] = (8136.2993, 5073.2285, 1151.0709);
	angles[50] = (0, -60, 0);
	at[50] = 20.8333;
	points[51] = (8136.9292, 5062.4019, 1150.9685);
	angles[51] = (0, -60, 0);
	at[51] = 21;
	points[52] = (8136.9292, 5062.4019, 1150.9685);
	angles[52] = (0, -60, 0);
	at[52] = 22.1667;
	points[53] = (8137.5195, 5052.4800, 1150.8779);
	angles[53] = (0, -60, 0);
	at[53] = 22.3333;
	points[54] = (8139.2520, 5023.1104, 1150.7795);
	angles[54] = (0, -60, 0);
	at[54] = 22.5000;
	points[55] = (8139.8823, 5012.2832, 1150.7441);
	angles[55] = (0, -60, 0);
	at[55] = 22.6667;
	points[56] = (8139.8823, 5012.2832, 1150.7441);
	angles[56] = (0, -60, 0);
	at[56] = 23.8333;
	points[57] = (8140.4727, 5002.3623, 1150.7126);
	angles[57] = (0, -60, 0);
	at[57] = 24;
	points[58] = (8142.1655, 4973.0317, 1150.6141);
	angles[58] = (0, -60, 0);
	at[58] = 24.1667;
	points[59] = (8142.8350, 4962.1655, 1150.5787);
	angles[59] = (0, -60, 0);
	at[59] = 24.3333;
	points[60] = (8142.8350, 4962.1655, 1150.5787);
	angles[60] = (0, -60, 0);
	at[60] = 25.5000;
	points[61] = (8143.3857, 4952.2837, 1150.5433);
	angles[61] = (0, -60, 0);
	at[61] = 25.6667;
	points[62] = (8145.1182, 4922.9136, 1150.3071);
	angles[62] = (0, -60, 0);
	at[62] = 25.8333;
	points[63] = (8145.7480, 4912.0474, 1150.2047);
	angles[63] = (0, -60, 0);
	at[63] = 26;
	points[64] = (8145.7480, 4912.0474, 1150.2047);
	angles[64] = (0, -60, 0);
	at[64] = 27.1667;
	points[65] = (8146.3389, 4902.1655, 1150.1141);
	angles[65] = (0, -60, 0);
	at[65] = 27.3333;
	points[66] = (8148.0708, 4872.7954, 1149.8386);
	angles[66] = (0, -60, 0);
	at[66] = 27.5000;
	points[67] = (8148.7012, 4861.9292, 1149.7599);
	angles[67] = (0, -60, 0);
	at[67] = 27.6667;
	points[68] = (8148.7012, 4861.9292, 1149.7599);
	angles[68] = (0, -60, 0);
	at[68] = 28.8333;
	points[69] = (8149.2915, 4852.0474, 1149.7284);
	angles[69] = (0, -60, 0);
	at[69] = 29;
	points[70] = (8150.9844, 4822.6772, 1149.6378);
	angles[70] = (0, -60, 0);
	at[70] = 29.1667;
	points[71] = (8151.6143, 4811.8506, 1149.6024);
	angles[71] = (0, -60, 0);
	at[71] = 29.3333;
	points[72] = (8151.6143, 4811.8506, 1149.6024);
	angles[72] = (0, -60, 0);
	at[72] = 30.5000;
	points[73] = (8152.2046, 4801.9292, 1149.5709);
	angles[73] = (0, -60, 0);
	at[73] = 30.6667;
	points[74] = (8153.8188, 4772.5591, 1149.4843);
	angles[74] = (0, -60, 0);
	at[74] = 30.8333;
	points[75] = (8154.4092, 4761.7324, 1149.4528);
	angles[75] = (0, -60, 0);
	at[75] = 31;
	points[76] = (8154.4092, 4761.7324, 1149.4528);
	angles[76] = (0, -60, 0);
	at[76] = 32.1667;
	points[77] = (8154.9609, 4751.8110, 1149.4213);
	angles[77] = (0, -60, 0);
	at[77] = 32.3333;
	points[78] = (8156.5752, 4722.4409, 1149.1575);
	angles[78] = (0, -60, 0);
	at[78] = 32.5000;
	points[79] = (8157.1655, 4711.6143, 1149.0591);
	angles[79] = (0, -60, 0);
	at[79] = 32.6667;
	points[80] = (8157.1655, 4711.6143, 1149.0591);
	angles[80] = (0, -60, 0);
	at[80] = 33.8333;
	points[81] = (8157.7163, 4701.6929, 1148.9685);
	angles[81] = (0, -60, 0);
	at[81] = 34;
	points[82] = (8159.3306, 4672.3228, 1148.7047);
	angles[82] = (0, -60, 0);
	at[82] = 34.1667;
	points[83] = (8159.9209, 4661.4961, 1148.6102);
	angles[83] = (0, -60, 0);
	at[83] = 34.3333;
	points[84] = (8159.9209, 4661.4961, 1148.6102);
	angles[84] = (0, -60, 0);
	at[84] = 35.5000;
	points[85] = (8160.3540, 4654.0552, 1148.5433);
	angles[85] = (0, -60, 0);
	at[85] = 35.6667;
	points[86] = (8161.9292, 4625.1572, 1148.2836);
	angles[86] = (0, -60, 0);
	at[86] = 35.8333;
	points[87] = (8162.5200, 4614.2915, 1148.1851);
	angles[87] = (0, -60, 0);
	at[87] = 36;
	points[88] = (8162.5200, 4614.2915, 1148.1851);
	angles[88] = (0, -60, 0);
	at[88] = 37.1667;
	points[89] = (8162.9136, 4606.8896, 1148.1182);
	angles[89] = (0, -60, 0);
	at[89] = 37.3333;
	points[90] = (8164.5273, 4577.9922, 1148.0394);
	angles[90] = (0, -60, 0);
	at[90] = 37.5000;
	points[91] = (8165.1182, 4567.1260, 1148.0118);
	angles[91] = (0, -60, 0);
	at[91] = 37.6667;
	points[92] = (8165.1182, 4567.1260, 1148.0118);
	angles[92] = (0, -60, 0);
	at[92] = 38.8333;
	points[93] = (8165.5122, 4559.7246, 1147.9922);
	angles[93] = (0, -60, 0);
	at[93] = 39;
	points[94] = (8167.1265, 4530.8267, 1147.9213);
	angles[94] = (0, -60, 0);
	at[94] = 39.1667;
	points[95] = (8167.7168, 4519.9604, 1147.8937);
	angles[95] = (0, -60, 0);
	at[95] = 39.3333;
	points[96] = (8167.7168, 4519.9604, 1147.8937);
	angles[96] = (0, -60, 0);
	at[96] = 39.9333;
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
	points[0] = (10974.9609, 4086.9292, 1133.1771);
	angles[0] = (0, 180, 0);
	at[0] = 0;
	points[1] = (10979.6855, 4089.3308, 1132.9607);
	angles[1] = (0, 180, 0);
	at[1] = 0.2333;
	points[2] = (11014.2520, 4107.0474, 1131.3820);
	angles[2] = (0, 180, 0);
	at[2] = 0.4667;
	points[3] = (11019.6064, 4109.8032, 1131.1339);
	angles[3] = (0, 180, 0);
	at[3] = 0.7000;
	points[4] = (11021.4971, 4110.7480, 1131.0472);
	angles[4] = (0, 180, 0);
	at[4] = 1.8667;
	points[5] = (11054.6055, 4127.7168, 1129.6851);
	angles[5] = (0, 180, 0);
	at[5] = 2.1000;
	points[6] = (11064.2529, 4132.6772, 1129.3544);
	angles[6] = (0, 180, 0);
	at[6] = 2.3333;
	points[7] = (11064.5674, 4132.8345, 1129.3425);
	angles[7] = (0, 180, 0);
	at[7] = 3.5000;
	points[8] = (11093.9756, 4147.9136, 1128.1102);
	angles[8] = (0, 180, 0);
	at[8] = 3.7333;
	points[9] = (11108.8975, 4155.5513, 1127.4331);
	angles[9] = (0, 180, 0);
	at[9] = 3.9667;
	points[10] = (11108.8975, 4155.5513, 1127.4331);
	angles[10] = (0, 180, 0);
	at[10] = 5.1333;
	points[11] = (11150.9053, 4177.0864, 1125.5315);
	angles[11] = (0, 180, 0);
	at[11] = 5.6000;
	points[12] = (11150.9053, 4177.0864, 1125.5315);
	angles[12] = (0, 180, 0);
	at[12] = 6.7667;
	points[13] = (11167.4805, 4185.5908, 1124.7834);
	angles[13] = (0, 180, 0);
	at[13] = 7;
	points[14] = (11192.9131, 4198.6221, 1123.6299);
	angles[14] = (0, 180, 0);
	at[14] = 7.2333;
	points[15] = (11192.9131, 4198.6221, 1123.6299);
	angles[15] = (0, 180, 0);
	at[15] = 8.4000;
	points[16] = (11204.2529, 4204.4097, 1123.1182);
	angles[16] = (0, 180, 0);
	at[16] = 8.6333;
	points[17] = (11234.4102, 4219.8818, 1121.7520);
	angles[17] = (0, 180, 0);
	at[17] = 8.8667;
	points[18] = (11234.9219, 4220.1577, 1121.7284);
	angles[18] = (0, 180, 0);
	at[18] = 10.0333;
	points[19] = (11241.5361, 4223.5435, 1121.4292);
	angles[19] = (0, 180, 0);
	at[19] = 10.2667;
	points[20] = (11274.6465, 4240.5117, 1119.9331);
	angles[20] = (0, 180, 0);
	at[20] = 10.5000;
	points[21] = (11276.9287, 4241.6929, 1119.8268);
	angles[21] = (0, 180, 0);
	at[21] = 10.7333;
	points[22] = (11276.9287, 4241.6929, 1119.8268);
	angles[22] = (0, 180, 0);
	at[22] = 11.6667;
	points[23] = (11280.0791, 4243.3071, 1119.6851);
	angles[23] = (0, 180, 0);
	at[23] = 11.9000;
	points[24] = (11313.2275, 4261.0239, 1118.1456);
	angles[24] = (0, 180, 0);
	at[24] = 12.1333;
	points[25] = (11318.4258, 4264.0156, 1117.8938);
	angles[25] = (0, 180, 0);
	at[25] = 12.3667;
	points[26] = (11319.3301, 4264.5278, 1117.8505);
	angles[26] = (0, 180, 0);
	at[26] = 13.5333;
	points[27] = (11349.8428, 4281.9688, 1116.3740);
	angles[27] = (0, 180, 0);
	at[27] = 13.7667;
	points[28] = (11359.2119, 4287.3228, 1115.9174);
	angles[28] = (0, 180, 0);
	at[28] = 14;
	points[29] = (11359.2119, 4287.3228, 1115.9174);
	angles[29] = (0, 180, 0);
	at[29] = 15.1667;
	points[30] = (11385.5117, 4302.4014, 1114.8070);
	angles[30] = (0, 180, 0);
	at[30] = 15.4000;
	points[31] = (11400, 4310.6694, 1114.2677);
	angles[31] = (0, 180, 0);
	at[31] = 15.6333;
	points[32] = (11400, 4310.6694, 1114.2677);
	angles[32] = (0, 180, 0);
	at[32] = 16.8000;
	points[33] = (11440.7881, 4334.0156, 1112.7441);
	angles[33] = (0, 180, 0);
	at[33] = 17.2667;
	points[34] = (11440.7881, 4334.0156, 1112.7441);
	angles[34] = (0, 180, 0);
	at[34] = 18.4333;
	points[35] = (11456.8896, 4343.2676, 1112.1458);
	angles[35] = (0, 180, 0);
	at[35] = 18.6667;
	points[36] = (11481.5361, 4357.3623, 1117.5118);
	angles[36] = (0, 180, 0);
	at[36] = 18.9000;
	points[37] = (11481.5361, 4357.3623, 1117.5118);
	angles[37] = (0, 180, 0);
	at[37] = 20.0667;
	points[38] = (11492.5596, 4363.7007, 1120.2756);
	angles[38] = (0, 180, 0);
	at[38] = 20.3000;
	points[39] = (11521.8105, 4380.4331, 1127.6141);
	angles[39] = (0, 180, 0);
	at[39] = 20.5333;
	points[40] = (11522.3223, 4380.7085, 1127.7440);
	angles[40] = (0, 180, 0);
	at[40] = 21.7000;
	points[41] = (11528.7793, 4384.4097, 1129.3544);
	angles[41] = (0, 180, 0);
	at[41] = 21.9333;
	points[42] = (11560.8662, 4402.7954, 1137.4094);
	angles[42] = (0, 180, 0);
	at[42] = 22.1667;
	points[43] = (11563.1104, 4404.0552, 1137.9724);
	angles[43] = (0, 180, 0);
	at[43] = 22.4000;
	points[44] = (11563.1104, 4404.0552, 1137.9724);
	angles[44] = (0, 180, 0);
	at[44] = 23.3333;
	points[45] = (11566.1816, 4405.8267, 1138.7401);
	angles[45] = (0, 180, 0);
	at[45] = 23.5667;
	points[46] = (11598.7012, 4424.4487, 1146.9292);
	angles[46] = (0, 180, 0);
	at[46] = 23.8000;
	points[47] = (11603.8984, 4427.4019, 1148.3188);
	angles[47] = (0, 180, 0);
	at[47] = 24.0333;
	points[48] = (11604.8428, 4427.9526, 1148.5630);
	angles[48] = (0, 180, 0);
	at[48] = 25.2000;
	points[49] = (11635.3145, 4445.3940, 1156.7047);
	angles[49] = (0, 180, 0);
	at[49] = 25.4333;
	points[50] = (11644.6846, 4450.7480, 1159.2086);
	angles[50] = (0, 180, 0);
	at[50] = 25.6667;
	points[51] = (11644.6846, 4450.7480, 1159.2086);
	angles[51] = (0, 180, 0);
	at[51] = 26.8333;
	points[52] = (11619.0156, 4436.0239, 1152.3464);
	angles[52] = (0, 180, 0);
	at[52] = 27.0667;
	points[53] = (11604.5283, 4427.7163, 1148.4843);
	angles[53] = (0, 180, 0);
	at[53] = 27.3000;
	points[54] = (11604.5283, 4427.7163, 1148.4843);
	angles[54] = (0, 180, 0);
	at[54] = 28.4667;
	points[55] = (11563.7793, 4404.3311, 1138.1300);
	angles[55] = (0, 180, 0);
	at[55] = 28.9333;
	points[56] = (11563.7793, 4404.3311, 1138.1300);
	angles[56] = (0, 180, 0);
	at[56] = 30.1000;
	points[57] = (11547.6777, 4395.0791, 1134.0906);
	angles[57] = (0, 180, 0);
	at[57] = 30.3333;
	points[58] = (11523.0312, 4380.9058, 1127.9055);
	angles[58] = (0, 180, 0);
	at[58] = 30.5667;
	points[59] = (11523.0312, 4380.9058, 1127.9055);
	angles[59] = (0, 180, 0);
	at[59] = 31.7333;
	points[60] = (11512.0078, 4374.6064, 1125.1456);
	angles[60] = (0, 180, 0);
	at[60] = 31.9667;
	points[61] = (11482.7949, 4357.7954, 1117.8071);
	angles[61] = (0, 180, 0);
	at[61] = 32.2000;
	points[62] = (11482.2832, 4357.5195, 1117.6810);
	angles[62] = (0, 180, 0);
	at[62] = 33.3667;
	points[63] = (11475.8662, 4353.8188, 1116.0709);
	angles[63] = (0, 180, 0);
	at[63] = 33.6000;
	points[64] = (11443.7402, 4335.3940, 1112.6456);
	angles[64] = (0, 180, 0);
	at[64] = 33.8333;
	points[65] = (11441.5352, 4334.1338, 1112.7323);
	angles[65] = (0, 180, 0);
	at[65] = 34.0667;
	points[66] = (11441.5352, 4334.1338, 1112.7323);
	angles[66] = (0, 180, 0);
	at[66] = 35;
	points[67] = (11438.4639, 4332.3623, 1112.8464);
	angles[67] = (0, 180, 0);
	at[67] = 35.2333;
	points[68] = (11405.9453, 4313.7007, 1114.0591);
	angles[68] = (0, 180, 0);
	at[68] = 35.4667;
	points[69] = (11400.7490, 4310.7480, 1114.2559);
	angles[69] = (0, 180, 0);
	at[69] = 35.7000;
	points[70] = (11399.8428, 4310.1968, 1114.2875);
	angles[70] = (0, 180, 0);
	at[70] = 36.8667;
	points[71] = (11369.3711, 4292.7168, 1115.4489);
	angles[71] = (0, 180, 0);
	at[71] = 37.1000;
	points[72] = (11360, 4287.3228, 1115.9055);
	angles[72] = (0, 180, 0);
	at[72] = 37.3333;
	points[73] = (11360, 4287.3228, 1115.9055);
	angles[73] = (0, 180, 0);
	at[73] = 38.5000;
	points[74] = (11333.7412, 4272.2441, 1117.1812);
	angles[74] = (0, 180, 0);
	at[74] = 38.7333;
	points[75] = (11319.2520, 4263.9370, 1117.8818);
	angles[75] = (0, 180, 0);
	at[75] = 38.9667;
	points[76] = (11319.2520, 4263.9370, 1117.8818);
	angles[76] = (0, 180, 0);
	at[76] = 40.1333;
	points[77] = (11277.7949, 4241.6143, 1119.8149);
	angles[77] = (0, 180, 0);
	at[77] = 40.6000;
	points[78] = (11277.7949, 4241.6143, 1119.8149);
	angles[78] = (0, 180, 0);
	at[78] = 41.7667;
	points[79] = (11261.1807, 4233.1104, 1120.5670);
	angles[79] = (0, 180, 0);
	at[79] = 42;
	points[80] = (11235.7480, 4220.1182, 1121.7166);
	angles[80] = (0, 180, 0);
	at[80] = 42.2333;
	points[81] = (11235.7480, 4220.1182, 1121.7166);
	angles[81] = (0, 180, 0);
	at[81] = 43.4000;
	points[82] = (11224.4102, 4214.3306, 1122.2284);
	angles[82] = (0, 180, 0);
	at[82] = 43.6333;
	points[83] = (11194.2529, 4198.8979, 1123.5906);
	angles[83] = (0, 180, 0);
	at[83] = 43.8667;
	points[84] = (11193.7012, 4198.6616, 1123.6143);
	angles[84] = (0, 180, 0);
	at[84] = 45.0333;
	points[85] = (11187.0869, 4195.2754, 1123.9133);
	angles[85] = (0, 180, 0);
	at[85] = 45.2667;
	points[86] = (11153.9766, 4178.3462, 1125.4094);
	angles[86] = (0, 180, 0);
	at[86] = 45.5000;
	points[87] = (11151.6543, 4177.1655, 1125.5157);
	angles[87] = (0, 180, 0);
	at[87] = 45.7333;
	points[88] = (11151.6543, 4177.1655, 1125.5157);
	angles[88] = (0, 180, 0);
	at[88] = 46.6667;
	points[89] = (11148.5039, 4175.5513, 1125.6575);
	angles[89] = (0, 180, 0);
	at[89] = 46.9000;
	points[90] = (11115, 4158.4253, 1127.1732);
	angles[90] = (0, 180, 0);
	at[90] = 47.1333;
	points[91] = (11109.6455, 4155.6694, 1127.4133);
	angles[91] = (0, 180, 0);
	at[91] = 47.3667;
	points[92] = (11108.7012, 4155.1968, 1127.4567);
	angles[92] = (0, 180, 0);
	at[92] = 48.5333;
	points[93] = (11077.2441, 4139.1338, 1128.8779);
	angles[93] = (0, 180, 0);
	at[93] = 48.7667;
	points[94] = (11067.5986, 4134.2129, 1129.2480);
	angles[94] = (0, 180, 0);
	at[94] = 49;
	points[95] = (11067.5986, 4134.2129, 1129.2480);
	angles[95] = (0, 180, 0);
	at[95] = 50.1667;
	points[96] = (11040.4727, 4120.3545, 1130.1890);
	angles[96] = (0, 180, 0);
	at[96] = 50.4000;
	points[97] = (11025.5518, 4112.7163, 1130.8701);
	angles[97] = (0, 180, 0);
	at[97] = 50.6333;
	points[98] = (11025.5518, 4112.7163, 1130.8701);
	angles[98] = (0, 180, 0);
	at[98] = 51.8000;
	points[99] = (10983.5039, 4091.2598, 1132.7914);
	angles[99] = (0, 180, 0);
	at[99] = 52.2667;
	points[100] = (10983.5039, 4091.2598, 1132.7914);
	angles[100] = (0, 180, 0);
	at[100] = 53.4333;
	points[101] = (10966.8896, 4082.7561, 1133.5472);
	angles[101] = (0, 180, 0);
	at[101] = 53.6667;
	points[102] = (10965.3154, 4081.9685, 1133.6182);
	angles[102] = (0, 180, 0);
	at[102] = 53.9000;
	points[103] = (10974.9609, 4086.9292, 1133.1771);
	angles[103] = (0, 180, 0);
	at[103] = 54.1333;
	points[104] = (10974.9609, 4086.9292, 1133.1771);
	angles[104] = (0, 180, 0);
	at[104] = 55.1333;
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
