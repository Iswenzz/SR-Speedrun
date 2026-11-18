main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_ds_peach_gardens", 0);

	setExpFog(32480.3145, 44475.8867, 0.7020, 0.8980, 1, 0);

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
	ambientPlay("iz_0_r_ds_garden32", 2);
	level thread iz_music("iz_8_se_cr_dsp_env_birds");
	iz_emitter("iz_1_se_cc_env_lake", (3838.5828, -1771.6536, 4424.3267), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_lake", (2863.5847, -2356.5969, 4424.3267), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_lake", (1888.5869, -2941.5405, 4424.3267), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_lake", (913.5887, -3526.4836, 4424.3267), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_lake", (-61.4091, -4111.4268, 4424.3267), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_lake", (-1036.4070, -4696.3701, 4424.3267), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_lake", (3838.5828, 1771.6536, 4424.3267), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_lake", (3149.6060, 2460.6299, 4424.3267), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_lake", (2460.6299, 3149.6064, 4424.3267), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_lake", (1771.6536, 3838.5828, 4424.3267), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_lake", (-4752.8496, -406.2422, 4424.3267), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_lake", (-4156.6104, 442.7227, 4424.3267), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_lake", (-3560.3711, 1291.6877, 4424.3267), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_lake", (-2964.1318, 2140.6528, 4424.3267), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_lake", (-2367.8928, 2989.6177, 4424.3267), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_lake", (-1771.6536, 3838.5828, 4424.3267), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_lake", (-1901.7192, -3850.8984, 4424.3267), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_lake", (-2580.8831, -3152.1094, 4424.3267), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_lake", (-3260.0466, -2453.3208, 4424.3267), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_lake", (-3939.2104, -1754.5319, 4424.3267), 0, 12.0104);
}

iz_music(alias)
{
	for (;;)
	{
		level waittill("connected", player);
		player thread iz_music_player(alias);
	}
}

iz_music_player(alias)
{
	self endon("disconnect");
	self waittill("spawned_player");
	self playLocalSound(alias);
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
	level.iz_route[level.iz_route.size] = (-6, 5295, 4252);
	level.iz_route[level.iz_route.size] = (-14, 3824, 4252);
	level.iz_route[level.iz_route.size] = (-13, 2699, 4260);
	level.iz_route[level.iz_route.size] = (-12, 1991, 4252);
	level.iz_route[level.iz_route.size] = (1075, 1775, 4252);
	level.iz_route[level.iz_route.size] = (1754, 1045, 4252);
	level.iz_route[level.iz_route.size] = (2037, -9, 4252);
	level.iz_route[level.iz_route.size] = (2807, -7, 4266);
	level.iz_route[level.iz_route.size] = (4042, -3, 4252);
	level.iz_route[level.iz_route.size] = (5133, -1, 4252);
	level.iz_route[level.iz_route.size] = (6347, 1, 4252);
	level.iz_route[level.iz_route.size] = (7470, -2, 4252);
	level.iz_route[level.iz_route.size] = (8202, 674, 4252);
	level.iz_route[level.iz_route.size] = (9138, 1303, 4252);
	level.iz_route[level.iz_route.size] = (10333, 872, 4252);
	level.iz_route[level.iz_route.size] = (10644, -332, 4252);
	level.iz_route[level.iz_route.size] = (9888, -1241, 4252);
	level.iz_route[level.iz_route.size] = (9339, -1894, 4252);
	level.iz_route[level.iz_route.size] = (9353, -2764, 4441);
	level.iz_route[level.iz_route.size] = (9354, -3833, 4724);
	level.iz_route[level.iz_route.size] = (9359, -4870, 4922);
	level.iz_route[level.iz_route.size] = (9363, -5952, 4993);
	level.iz_route[level.iz_route.size] = (9842, -6762, 4993);
	level.iz_route[level.iz_route.size] = (9999, -7976, 4993);
	level.iz_route[level.iz_route.size] = (9190, -8713, 4993);
	level.iz_route[level.iz_route.size] = (8131, -8725, 4993);
	level.iz_route[level.iz_route.size] = (7060, -8718, 4808);
	level.iz_route[level.iz_route.size] = (6042, -8718, 4492);
	level.iz_route[level.iz_route.size] = (5084, -8719, 4465);
	level.iz_route[level.iz_route.size] = (4264, -9564, 4465);
	level.iz_route[level.iz_route.size] = (3131, -9566, 4465);
	level.iz_route[level.iz_route.size] = (2337, -8693, 4465);
	level.iz_route[level.iz_route.size] = (1370, -8696, 4465);
	level.iz_route[level.iz_route.size] = (427, -9564, 4465);
	level.iz_route[level.iz_route.size] = (-677, -9567, 4465);
	level.iz_route[level.iz_route.size] = (-1508, -8733, 4465);
	level.iz_route[level.iz_route.size] = (-2496, -8735, 4465);
	level.iz_route[level.iz_route.size] = (-3415, -9560, 4465);
	level.iz_route[level.iz_route.size] = (-4485, -9559, 4465);
	level.iz_route[level.iz_route.size] = (-5038, -8704, 4465);
	level.iz_route[level.iz_route.size] = (-5962, -8710, 4468);
	level.iz_route[level.iz_route.size] = (-7138, -8707, 4899);
	level.iz_route[level.iz_route.size] = (-8128, -8705, 4993);
	level.iz_route[level.iz_route.size] = (-8883, -8523, 4993);
	level.iz_route[level.iz_route.size] = (-9494, -8041, 4993);
	level.iz_route[level.iz_route.size] = (-10008, -7529, 4993);
	level.iz_route[level.iz_route.size] = (-10003, -6613, 4993);
	level.iz_route[level.iz_route.size] = (-9341, -5977, 4993);
	level.iz_route[level.iz_route.size] = (-9342, -5302, 4944);
	level.iz_route[level.iz_route.size] = (-9344, -3750, 4606);
	level.iz_route[level.iz_route.size] = (-9359, -2113, 4252);
	level.iz_route[level.iz_route.size] = (-9341, -1556, 4252);
	level.iz_route[level.iz_route.size] = (-8566, -1261, 4252);
	level.iz_route[level.iz_route.size] = (-8052, -593, 4252);
	level.iz_route[level.iz_route.size] = (-7761, 46, 4252);
	level.iz_route[level.iz_route.size] = (-7858, 623, 4252);
	level.iz_route[level.iz_route.size] = (-8198, 1113, 4252);
	level.iz_route[level.iz_route.size] = (-8765, 1413, 4252);
	level.iz_route[level.iz_route.size] = (-9377, 1774, 4252);
	level.iz_route[level.iz_route.size] = (-9641, 2407, 4252);
	level.iz_route[level.iz_route.size] = (-9950, 3076, 4252);
	level.iz_route[level.iz_route.size] = (-10263, 4023, 4252);
	level.iz_route[level.iz_route.size] = (-9584, 5018, 4252);
	level.iz_route[level.iz_route.size] = (-8883, 5630, 4252);
	level.iz_route[level.iz_route.size] = (-8477, 6237, 4252);
	level.iz_route[level.iz_route.size] = (-8757, 7168, 4252);
	level.iz_route[level.iz_route.size] = (-9243, 8089, 4252);
	level.iz_route[level.iz_route.size] = (-9499, 8940, 4252);
	level.iz_route[level.iz_route.size] = (-8952, 9718, 4252);
	level.iz_route[level.iz_route.size] = (-6653, 9708, 4465);
	level.iz_route[level.iz_route.size] = (-3912, 9696, 4465);
	level.iz_route[level.iz_route.size] = (-1953, 9747, 4465);
	level.iz_route[level.iz_route.size] = (-1286, 9744, 4465);
	level.iz_route[level.iz_route.size] = (-632, 9166, 4465);
	level.iz_route[level.iz_route.size] = (-2, 7239, 4252);
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
	points[0] = (-9228.3076, 8686.7324, 4251.9688);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-9228.3076, 8686.7324, 4251.9688);
	angles[1] = (0, 0, 0);
	at[1] = 0.6000;
	points[2] = (-9228.3076, 8686.7324, 4305.9448);
	angles[2] = (0, 0, 0);
	at[2] = 0.6500;
	points[3] = (-9228.3076, 8686.7324, 4352.7559);
	angles[3] = (0, 0, 0);
	at[3] = 0.7000;
	points[4] = (-9228.3076, 8686.7324, 4392.4019);
	angles[4] = (0, 0, 0);
	at[4] = 0.7500;
	points[5] = (-9228.3076, 8686.7324, 4424.8818);
	angles[5] = (0, 0, 0);
	at[5] = 0.8000;
	points[6] = (-9228.3076, 8686.7324, 4450.1572);
	angles[6] = (0, 0, 0);
	at[6] = 0.8500;
	points[7] = (-9228.3076, 8686.7324, 4468.2681);
	angles[7] = (0, 0, 0);
	at[7] = 0.9000;
	points[8] = (-9228.3076, 8686.7324, 4479.2129);
	angles[8] = (0, 0, 0);
	at[8] = 0.9500;
	points[9] = (-9228.3076, 8686.7324, 4482.9922);
	angles[9] = (0, 0, 0);
	at[9] = 1;
	points[10] = (-9228.3076, 8686.7324, 4479.5669);
	angles[10] = (0, 0, 0);
	at[10] = 1.0500;
	points[11] = (-9228.3076, 8686.7324, 4468.9766);
	angles[11] = (0, 0, 0);
	at[11] = 1.1000;
	points[12] = (-9228.3076, 8686.7324, 4451.2202);
	angles[12] = (0, 0, 0);
	at[12] = 1.1500;
	points[13] = (-9228.3076, 8686.7324, 4426.2993);
	angles[13] = (0, 0, 0);
	at[13] = 1.2000;
	points[14] = (-9228.3076, 8686.7324, 4394.1733);
	angles[14] = (0, 0, 0);
	at[14] = 1.2500;
	points[15] = (-9228.3076, 8686.7324, 4354.8818);
	angles[15] = (0, 0, 0);
	at[15] = 1.3000;
	points[16] = (-9228.3076, 8686.7324, 4308.4253);
	angles[16] = (0, 0, 0);
	at[16] = 1.3500;
	points[17] = (-9228.3076, 8686.7324, 4254.8032);
	angles[17] = (0, 0, 0);
	at[17] = 1.4000;
	points[18] = (-9228.3076, 8686.7324, 4074.8032);
	angles[18] = (0, 0, 0);
	at[18] = 1.4500;
	points[19] = (-9228.3076, 8686.7324, 4074.8032);
	angles[19] = (0, 0, 0);
	at[19] = 2.5000;
	points[20] = (-9228.3076, 8686.7324, 4251.9688);
	angles[20] = (0, 0, 0);
	at[20] = 2.5500;
	points[21] = (-9228.3076, 8686.7324, 4251.9688);
	angles[21] = (0, 0, 0);
	at[21] = 3.5833;
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
	points[0] = (-9990.7881, 3605.3938, 4472.7168);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-9990.7881, 3605.3938, 4481.2598);
	angles[1] = (0, 0, 0);
	at[1] = 0.0500;
	points[2] = (-9990.7881, 3605.3938, 4482.6377);
	angles[2] = (0, 0, 0);
	at[2] = 0.1000;
	points[3] = (-9990.7881, 3605.3938, 4476.8506);
	angles[3] = (0, 0, 0);
	at[3] = 0.1500;
	points[4] = (-9990.7881, 3605.3938, 4463.8584);
	angles[4] = (0, 0, 0);
	at[4] = 0.2000;
	points[5] = (-9990.7881, 3605.3938, 4443.7012);
	angles[5] = (0, 0, 0);
	at[5] = 0.2500;
	points[6] = (-9990.7881, 3605.3938, 4416.3779);
	angles[6] = (0, 0, 0);
	at[6] = 0.3000;
	points[7] = (-9990.7881, 3605.3938, 4381.8901);
	angles[7] = (0, 0, 0);
	at[7] = 0.3500;
	points[8] = (-9990.7881, 3605.3938, 4340.1968);
	angles[8] = (0, 0, 0);
	at[8] = 0.4000;
	points[9] = (-9990.7881, 3605.3938, 4291.3389);
	angles[9] = (0, 0, 0);
	at[9] = 0.4500;
	points[10] = (-9990.7881, 3605.3938, 4074.8032);
	angles[10] = (0, 0, 0);
	at[10] = 0.5000;
	points[11] = (-9990.7881, 3605.3938, 4074.8032);
	angles[11] = (0, 0, 0);
	at[11] = 2.5000;
	points[12] = (-9990.7881, 3605.3938, 4251.9688);
	angles[12] = (0, 0, 0);
	at[12] = 2.5500;
	points[13] = (-9990.7881, 3605.3938, 4251.9688);
	angles[13] = (0, 0, 0);
	at[13] = 4.1500;
	points[14] = (-9990.7881, 3605.3938, 4270.7480);
	angles[14] = (0, 0, 0);
	at[14] = 4.2000;
	points[15] = (-9990.7881, 3605.3938, 4322.3623);
	angles[15] = (0, 0, 0);
	at[15] = 4.2500;
	points[16] = (-9990.7881, 3605.3938, 4366.7715);
	angles[16] = (0, 0, 0);
	at[16] = 4.3000;
	points[17] = (-9990.7881, 3605.3938, 4404.0156);
	angles[17] = (0, 0, 0);
	at[17] = 4.3500;
	points[18] = (-9990.7881, 3605.3938, 4434.0947);
	angles[18] = (0, 0, 0);
	at[18] = 4.4000;
	points[19] = (-9990.7881, 3605.3938, 4457.0078);
	angles[19] = (0, 0, 0);
	at[19] = 4.4500;
	points[20] = (-9990.7881, 3605.3938, 4472.7168);
	angles[20] = (0, 0, 0);
	at[20] = 4.5000;
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
	points[0] = (-9322.4014, 5480.7480, 4322.3623);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-9322.4014, 5480.7480, 4366.7715);
	angles[1] = (0, 0, 0);
	at[1] = 0.0500;
	points[2] = (-9322.4014, 5480.7480, 4404.0156);
	angles[2] = (0, 0, 0);
	at[2] = 0.1000;
	points[3] = (-9322.4014, 5480.7480, 4434.0947);
	angles[3] = (0, 0, 0);
	at[3] = 0.1500;
	points[4] = (-9322.4014, 5480.7480, 4457.0078);
	angles[4] = (0, 0, 0);
	at[4] = 0.2000;
	points[5] = (-9322.4014, 5480.7480, 4472.7168);
	angles[5] = (0, 0, 0);
	at[5] = 0.2500;
	points[6] = (-9322.4014, 5480.7480, 4481.2598);
	angles[6] = (0, 0, 0);
	at[6] = 0.3000;
	points[7] = (-9322.4014, 5480.7480, 4482.6377);
	angles[7] = (0, 0, 0);
	at[7] = 0.3500;
	points[8] = (-9322.4014, 5480.7480, 4476.8506);
	angles[8] = (0, 0, 0);
	at[8] = 0.4000;
	points[9] = (-9322.4014, 5480.7480, 4463.8584);
	angles[9] = (0, 0, 0);
	at[9] = 0.4500;
	points[10] = (-9322.4014, 5480.7480, 4443.7012);
	angles[10] = (0, 0, 0);
	at[10] = 0.5000;
	points[11] = (-9322.4014, 5480.7480, 4416.3779);
	angles[11] = (0, 0, 0);
	at[11] = 0.5500;
	points[12] = (-9322.4014, 5480.7480, 4381.8901);
	angles[12] = (0, 0, 0);
	at[12] = 0.6000;
	points[13] = (-9322.4014, 5480.7480, 4340.1968);
	angles[13] = (0, 0, 0);
	at[13] = 0.6500;
	points[14] = (-9322.4014, 5480.7480, 4291.3389);
	angles[14] = (0, 0, 0);
	at[14] = 0.7000;
	points[15] = (-9322.4014, 5480.7480, 4074.8032);
	angles[15] = (0, 0, 0);
	at[15] = 0.7500;
	points[16] = (-9322.4014, 5480.7480, 4074.8032);
	angles[16] = (0, 0, 0);
	at[16] = 2.5000;
	points[17] = (-9322.4014, 5480.7480, 4251.9688);
	angles[17] = (0, 0, 0);
	at[17] = 2.5500;
	points[18] = (-9322.4014, 5480.7480, 4251.9688);
	angles[18] = (0, 0, 0);
	at[18] = 4.1500;
	points[19] = (-9322.4014, 5480.7480, 4270.7480);
	angles[19] = (0, 0, 0);
	at[19] = 4.2000;
	points[20] = (-9322.4014, 5480.7480, 4322.3623);
	angles[20] = (0, 0, 0);
	at[20] = 4.2500;
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
	points[0] = (-8733.7012, 7273.7007, 4251.9688);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-8733.7012, 7273.7007, 4251.9688);
	angles[1] = (0, 0, 0);
	at[1] = 0.3500;
	points[2] = (-8733.7012, 7273.7007, 4305.9448);
	angles[2] = (0, 0, 0);
	at[2] = 0.4000;
	points[3] = (-8733.7012, 7273.7007, 4352.7559);
	angles[3] = (0, 0, 0);
	at[3] = 0.4500;
	points[4] = (-8733.7012, 7273.7007, 4392.4019);
	angles[4] = (0, 0, 0);
	at[4] = 0.5000;
	points[5] = (-8733.7012, 7273.7007, 4424.8818);
	angles[5] = (0, 0, 0);
	at[5] = 0.5500;
	points[6] = (-8733.7012, 7273.7007, 4450.1572);
	angles[6] = (0, 0, 0);
	at[6] = 0.6000;
	points[7] = (-8733.7012, 7273.7007, 4468.2681);
	angles[7] = (0, 0, 0);
	at[7] = 0.6500;
	points[8] = (-8733.7012, 7273.7007, 4479.2129);
	angles[8] = (0, 0, 0);
	at[8] = 0.7000;
	points[9] = (-8733.7012, 7273.7007, 4482.9922);
	angles[9] = (0, 0, 0);
	at[9] = 0.7500;
	points[10] = (-8733.7012, 7273.7007, 4479.5669);
	angles[10] = (0, 0, 0);
	at[10] = 0.8000;
	points[11] = (-8733.7012, 7273.7007, 4468.9766);
	angles[11] = (0, 0, 0);
	at[11] = 0.8500;
	points[12] = (-8733.7012, 7273.7007, 4451.2202);
	angles[12] = (0, 0, 0);
	at[12] = 0.9000;
	points[13] = (-8733.7012, 7273.7007, 4426.2993);
	angles[13] = (0, 0, 0);
	at[13] = 0.9500;
	points[14] = (-8733.7012, 7273.7007, 4394.1733);
	angles[14] = (0, 0, 0);
	at[14] = 1;
	points[15] = (-8733.7012, 7273.7007, 4354.8818);
	angles[15] = (0, 0, 0);
	at[15] = 1.0500;
	points[16] = (-8733.7012, 7273.7007, 4308.4253);
	angles[16] = (0, 0, 0);
	at[16] = 1.1000;
	points[17] = (-8733.7012, 7273.7007, 4254.8032);
	angles[17] = (0, 0, 0);
	at[17] = 1.1500;
	points[18] = (-8733.7012, 7273.7007, 4074.8032);
	angles[18] = (0, 0, 0);
	at[18] = 1.2000;
	points[19] = (-8733.7012, 7273.7007, 4074.8032);
	angles[19] = (0, 0, 0);
	at[19] = 2.5000;
	points[20] = (-8733.7012, 7273.7007, 4251.9688);
	angles[20] = (0, 0, 0);
	at[20] = 2.5500;
	points[21] = (-8733.7012, 7273.7007, 4251.9688);
	angles[21] = (0, 0, 0);
	at[21] = 3.8333;
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
	points[0] = (1633.2126, 779.1457, 4251.9688);
	angles[0] = (0, -157.0812, 0);
	at[0] = 0;
	points[1] = (1647.4607, 733.4921, 4251.9688);
	angles[1] = (0, -162.2775, 0);
	at[1] = 0.1333;
	points[2] = (1670.2284, 643.1221, 4251.9688);
	angles[2] = (0, -166.3937, 0);
	at[2] = 0.4000;
	points[3] = (1726.2008, 363.7610, 4251.9688);
	angles[3] = (0, -169.8466, 0);
	at[3] = 1.2000;
	points[4] = (1761.5906, 130.2346, 4251.9688);
	angles[4] = (0, -172.7145, 0);
	at[4] = 1.8667;
	points[5] = (1770.6338, 34.1978, 4251.9688);
	angles[5] = (0, -175.5855, 0);
	at[5] = 2.1333;
	points[6] = (1771.4843, -9.5182, 4251.9688);
	angles[6] = (0, -179.2631, 0);
	at[6] = 2.2667;
	points[7] = (1768.2756, -57.6657, 4251.9688);
	angles[7] = (0, -183.6125, 0);
	at[7] = 2.4000;
	points[8] = (1756.5709, -150.6858, 4251.9688);
	angles[8] = (0, -187.8306, 0);
	at[8] = 2.6667;
	points[9] = (1723.5906, -337.6752, 4251.9688);
	angles[9] = (0, -190.9449, 0);
	at[9] = 3.2000;
	points[10] = (1683.4174, -523.2480, 4251.9688);
	angles[10] = (0, -192.9782, 0);
	at[10] = 3.7333;
	points[11] = (1634.6418, -706.9725, 4251.9688);
	angles[11] = (0, -196.6184, 0);
	at[11] = 4.2667;
	points[12] = (1620, -748.5866, 4251.9688);
	angles[12] = (0, -199.7152, 0);
	at[12] = 4.4000;
	points[13] = (1579.8583, -835.4921, 4251.9688);
	angles[13] = (0, -205.8253, 0);
	at[13] = 4.6667;
	points[14] = (1488.7126, -1000.8780, 4251.9688);
	angles[14] = (0, -210.1575, 0);
	at[14] = 5.2000;
	points[15] = (1387.5826, -1161.3308, 4251.9688);
	angles[15] = (0, -213.6420, 0);
	at[15] = 5.7333;
	points[16] = (1331.9685, -1238.2717, 4251.9688);
	angles[16] = (0, -216.8990, 0);
	at[16] = 6;
	points[17] = (1301.3386, -1274.6182, 4251.9688);
	angles[17] = (0, -220.4416, 0);
	at[17] = 6.1333;
	points[18] = (1268.7205, -1305.2205, 4251.9688);
	angles[18] = (0, -226.7566, 0);
	at[18] = 6.2667;
	points[19] = (1231.8386, -1334.6062, 4251.9688);
	angles[19] = (0, -231.1484, 0);
	at[19] = 6.4000;
	points[20] = (1115.0315, -1416.2166, 4251.9688);
	angles[20] = (0, -236.2433, 0);
	at[20] = 6.8000;
	points[21] = (953.4921, -1515.7087, 4251.9688);
	angles[21] = (0, -239.5531, 0);
	at[21] = 7.3333;
	points[22] = (828.6418, -1583.6339, 4251.9688);
	angles[22] = (0, -242.6229, 0);
	at[22] = 7.7333;
	points[23] = (742.5591, -1622.4135, 4251.9688);
	angles[23] = (0, -247.4921, 0);
	at[23] = 8;
	points[24] = (699.6299, -1636.2284, 4251.9688);
	angles[24] = (0, -251.9865, 0);
	at[24] = 8.1333;
	points[25] = (561.4606, -1669.9725, 4251.9688);
	angles[25] = (0, -257.3225, 0);
	at[25] = 8.5333;
	points[26] = (421.8465, -1698.1418, 4251.9688);
	angles[26] = (0, -259.1038, 0);
	at[26] = 8.9333;
	points[27] = (234.7236, -1730.3662, 4251.9688);
	angles[27] = (0, -260.9115, 0);
	at[27] = 9.4667;
	points[28] = (94.6346, -1749.8818, 4251.9688);
	angles[28] = (0, -262.7934, 0);
	at[28] = 9.8667;
	points[29] = (-1.1577, -1758.9253, 4251.9688);
	angles[29] = (0, -265.5235, 0);
	at[29] = 10.1333;
	points[30] = (-44.9606, -1759.9135, 4251.9688);
	angles[30] = (0, -269.0824, 0);
	at[30] = 10.2667;
	points[31] = (-92.9098, -1756.8779, 4251.9688);
	angles[31] = (0, -273.4465, 0);
	at[31] = 10.4000;
	points[32] = (-279.9276, -1730.0552, 4251.9688);
	angles[32] = (0, -279.6454, 0);
	at[32] = 10.9333;
	points[33] = (-512.6968, -1683.1141, 4251.9688);
	angles[33] = (0, -282.4285, 0);
	at[33] = 11.6000;
	points[34] = (-695.8150, -1637.2560, 4251.9688);
	angles[34] = (0, -285.4669, 0);
	at[34] = 12.1333;
	points[35] = (-740.1024, -1623.3505, 4251.9688);
	angles[35] = (0, -287.7252, 0);
	at[35] = 12.2667;
	points[36] = (-827.3228, -1587.4802, 4251.9688);
	angles[36] = (0, -293.3529, 0);
	at[36] = 12.5333;
	points[37] = (-997.2244, -1503.9922, 4251.9688);
	angles[37] = (0, -297.3672, 0);
	at[37] = 13.0667;
	points[38] = (-1162.7087, -1411.0748, 4251.9688);
	angles[38] = (0, -300.6789, 0);
	at[38] = 13.6000;
	points[39] = (-1241.9803, -1359.8110, 4251.9688);
	angles[39] = (0, -303.9565, 0);
	at[39] = 13.8667;
	points[40] = (-1279.4961, -1331.1812, 4251.9688);
	angles[40] = (0, -307.7694, 0);
	at[40] = 14;
	points[41] = (-1313.1300, -1299.2048, 4251.9688);
	angles[41] = (0, -313.2683, 0);
	at[41] = 14.1333;
	points[42] = (-1376.2363, -1229.9409, 4251.9688);
	angles[42] = (0, -318.4145, 0);
	at[42] = 14.4000;
	points[43] = (-1495.5669, -1082.0867, 4251.9688);
	angles[43] = (0, -322.3947, 0);
	at[43] = 14.9333;
	points[44] = (-1578.5433, -967.0237, 4251.9688);
	angles[44] = (0, -325.2336, 0);
	at[44] = 15.3333;
	points[45] = (-1630.0118, -886.6653, 4251.9688);
	angles[45] = (0, -328.2856, 0);
	at[45] = 15.6000;
	points[46] = (-1652.8661, -845.7677, 4251.9688);
	angles[46] = (0, -330.9361, 0);
	at[46] = 15.7333;
	points[47] = (-1671.8385, -804.1693, 4251.9688);
	angles[47] = (0, -336.0387, 0);
	at[47] = 15.8667;
	points[48] = (-1697.6141, -714.1339, 4251.9688);
	angles[48] = (0, -345.4038, 0);
	at[48] = 16.1333;
	points[49] = (-1734.7008, -527.4174, 4251.9688);
	angles[49] = (0, -349.9284, 0);
	at[49] = 16.6667;
	points[50] = (-1763.6024, -340.3665, 4251.9688);
	angles[50] = (0, -351.9095, 0);
	at[50] = 17.2000;
	points[51] = (-1781.3307, -198.6189, 4251.9688);
	angles[51] = (0, -353.3997, 0);
	at[51] = 17.6000;
	points[52] = (-1793.7125, -56.5307, 4251.9688);
	angles[52] = (0, -356.1962, 0);
	at[52] = 18;
	points[53] = (-1794.9055, -13.0211, 4251.9688);
	angles[53] = (0, -358.6518, 0);
	at[53] = 18.1333;
	points[54] = (-1793.5709, 35.6544, 4251.9688);
	angles[54] = (0, -361.4300, 0);
	at[54] = 18.2667;
	points[55] = (-1783.4252, 176.3161, 4251.9688);
	angles[55] = (0, -364.8814, 0);
	at[55] = 18.6667;
	points[56] = (-1757.2008, 412.1339, 4251.9688);
	angles[56] = (0, -367.1818, 0);
	at[56] = 19.3333;
	points[57] = (-1721.5709, 646.4055, 4251.9688);
	angles[57] = (0, -369.9212, 0);
	at[57] = 20;
	points[58] = (-1702.3347, 739.0748, 4251.9688);
	angles[58] = (0, -372.6404, 0);
	at[58] = 20.2667;
	points[59] = (-1689.8032, 783.1732, 4251.9688);
	angles[59] = (0, -376.3890, 0);
	at[59] = 20.4000;
	points[60] = (-1650.7598, 868.8032, 4251.9688);
	angles[60] = (0, -386.3341, 0);
	at[60] = 20.6667;
	points[61] = (-1603.6615, 950.9173, 4251.9688);
	angles[61] = (0, -390.6147, 0);
	at[61] = 20.9333;
	points[62] = (-1552.6891, 1030.8190, 4251.9688);
	angles[62] = (0, -393.0687, 0);
	at[62] = 21.2000;
	points[63] = (-1442.3583, 1185.1969, 4251.9688);
	angles[63] = (0, -397.1006, 0);
	at[63] = 21.7333;
	points[64] = (-1382.6260, 1258.2086, 4251.9688);
	angles[64] = (0, -400.2900, 0);
	at[64] = 22;
	points[65] = (-1350.3110, 1292.4095, 4251.9688);
	angles[65] = (0, -403.7516, 0);
	at[65] = 22.1333;
	points[66] = (-1277.4449, 1350.9686, 4251.9688);
	angles[66] = (0, -412.7276, 0);
	at[66] = 22.4000;
	points[67] = (-1159.4489, 1430.4135, 4251.9688);
	angles[67] = (0, -417.1072, 0);
	at[67] = 22.8000;
	points[68] = (-1038.1339, 1503.9370, 4251.9688);
	angles[68] = (0, -419.5700, 0);
	at[68] = 23.2000;
	points[69] = (-913.3976, 1572.0040, 4251.9688);
	angles[69] = (0, -422.4652, 0);
	at[69] = 23.6000;
	points[70] = (-826.7678, 1612.3031, 4251.9688);
	angles[70] = (0, -426.3252, 0);
	at[70] = 23.8667;
	points[71] = (-786.0984, 1626.9449, 4251.9688);
	angles[71] = (0, -430.3694, 0);
	at[71] = 24;
	points[72] = (-600.6536, 1674.4409, 4251.9688);
	angles[72] = (0, -436.9907, 0);
	at[72] = 24.5333;
	points[73] = (-462.3347, 1703.8229, 4251.9688);
	angles[73] = (0, -438.4392, 0);
	at[73] = 24.9333;
	points[74] = (-275.4996, 1738.5079, 4251.9688);
	angles[74] = (0, -440.1465, 0);
	at[74] = 25.4667;
	points[75] = (-135.7571, 1759.8346, 4251.9688);
	angles[75] = (0, -442.0671, 0);
	at[75] = 25.8667;
	points[76] = (-40.3445, 1770.0039, 4251.9688);
	angles[76] = (0, -444.8383, 0);
	at[76] = 26.1333;
	points[77] = (4.3298, 1771.6300, 4251.9688);
	angles[77] = (0, -448.3091, 0);
	at[77] = 26.2667;
	points[78] = (51.8299, 1769.1497, 4251.9688);
	angles[78] = (0, -452.7878, 0);
	at[78] = 26.4000;
	points[79] = (145.1437, 1758.2954, 4251.9688);
	angles[79] = (0, -457.3468, 0);
	at[79] = 26.6667;
	points[80] = (238.7417, 1743.5117, 4251.9688);
	angles[80] = (0, -459.3820, 0);
	at[80] = 26.9333;
	points[81] = (378.6327, 1717.0394, 4251.9688);
	angles[81] = (0, -461.2994, 0);
	at[81] = 27.3333;
	points[82] = (517.8189, 1686.3937, 4251.9688);
	angles[82] = (0, -462.9961, 0);
	at[82] = 27.7333;
	points[83] = (699.7834, 1637.4370, 4251.9688);
	angles[83] = (0, -466.9147, 0);
	at[83] = 28.2667;
	points[84] = (744.4922, 1621.6260, 4251.9688);
	angles[84] = (0, -469.8351, 0);
	at[84] = 28.4000;
	points[85] = (786.2717, 1602.2166, 4251.9688);
	angles[85] = (0, -474.8073, 0);
	at[85] = 28.5333;
	points[86] = (868.3347, 1555.8386, 4251.9688);
	angles[86] = (0, -480.3227, 0);
	at[86] = 28.8000;
	points[87] = (948.6339, 1505.3228, 4251.9688);
	angles[87] = (0, -482.6190, 0);
	at[87] = 29.0667;
	points[88] = (1144.0276, 1370.3307, 4251.9688);
	angles[88] = (0, -485.8186, 0);
	at[88] = 29.7333;
	points[89] = (1294.1299, 1253.6851, 4251.9688);
	angles[89] = (0, -489.7447, 0);
	at[89] = 30.2667;
	points[90] = (1326.4213, 1223.6102, 4251.9688);
	angles[90] = (0, -493.2486, 0);
	at[90] = 30.4000;
	points[91] = (1389.7283, 1152.7362, 4251.9688);
	angles[91] = (0, -499.2744, 0);
	at[91] = 30.6667;
	points[92] = (1504.5946, 1001.7756, 4251.9688);
	angles[92] = (0, -504.4536, 0);
	at[92] = 31.2000;
	points[93] = (1581.8701, 882.4606, 4251.9688);
	angles[93] = (0, -508.6557, 0);
	at[93] = 31.6000;
	points[94] = (1625.6732, 798.1457, 4251.9688);
	angles[94] = (0, -514.4863, 0);
	at[94] = 31.8667;
	points[95] = (1633.2126, 779.1457, 4251.9688);
	angles[95] = (0, -517.0812, 0);
	at[95] = 31.9333;
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
	points[0] = (1912.6141, -6860.7085, 4464.5669);
	angles[0] = (0, 87.7396, 0);
	at[0] = 0;
	points[1] = (1830.7953, -6866.1416, 4464.5669);
	angles[1] = (0, 94.5823, 0);
	at[1] = 0.2333;
	points[2] = (1707.0236, -6880.9053, 4464.5669);
	angles[2] = (0, 97.6350, 0);
	at[2] = 0.5833;
	points[3] = (1586.4764, -6907.4805, 4464.5669);
	angles[3] = (0, 103.9398, 0);
	at[3] = 0.9333;
	points[4] = (1467.6890, -6942.4805, 4464.5669);
	angles[4] = (0, 109.3077, 0);
	at[4] = 1.2833;
	points[5] = (1394.8623, -6982.0469, 4464.5669);
	angles[5] = (0, 119.8845, 0);
	at[5] = 1.5167;
	points[6] = (1361.0159, -7005.1973, 4464.5669);
	angles[6] = (0, 124.7151, 0);
	at[6] = 1.6333;
	points[7] = (1331.0906, -7033.7798, 4464.5669);
	angles[7] = (0, 132.5611, 0);
	at[7] = 1.7500;
	points[8] = (1276.2363, -7095.8267, 4464.5669);
	angles[8] = (0, 140.0384, 0);
	at[8] = 1.9833;
	points[9] = (1255.4370, -7131.1416, 4464.5669);
	angles[9] = (0, 148.9547, 0);
	at[9] = 2.1000;
	points[10] = (1205.7245, -7244.9214, 4464.5669);
	angles[10] = (0, 158.9517, 0);
	at[10] = 2.4500;
	points[11] = (1196.0354, -7285, 4464.5669);
	angles[11] = (0, 165.6066, 0);
	at[11] = 2.5667;
	points[12] = (1182.6023, -7366.8501, 4464.5669);
	angles[12] = (0, 171.6144, 0);
	at[12] = 2.8000;
	points[13] = (1180.0237, -7449.1338, 4464.5669);
	angles[13] = (0, 179.2115, 0);
	at[13] = 3.0333;
	points[14] = (1180.7559, -7532.2441, 4464.5669);
	angles[14] = (0, 180.5420, 0);
	at[14] = 3.2667;
	points[15] = (1180.1378, -10012.3623, 4464.5669);
	angles[15] = (0, 180.1153, 0);
	at[15] = 10.2667;
	points[16] = (1188.6141, -10094.3701, 4464.5669);
	angles[16] = (0, 187.7286, 0);
	at[16] = 10.5000;
	points[17] = (1205.2126, -10175.4727, 4464.5669);
	angles[17] = (0, 193.3116, 0);
	at[17] = 10.7333;
	points[18] = (1220.3110, -10213.6611, 4464.5669);
	angles[18] = (0, 200.5904, 0);
	at[18] = 10.8500;
	points[19] = (1256.2166, -10288.5439, 4464.5669);
	angles[19] = (0, 206.5195, 0);
	at[19] = 11.0833;
	points[20] = (1302.6063, -10356.5352, 4464.5669);
	angles[20] = (0, 215.7299, 0);
	at[20] = 11.3167;
	points[21] = (1328.5591, -10388.9766, 4464.5669);
	angles[21] = (0, 218.5309, 0);
	at[21] = 11.4333;
	points[22] = (1357.8583, -10417.4414, 4464.5669);
	angles[22] = (0, 226.6835, 0);
	at[22] = 11.5500;
	points[23] = (1392.5039, -10440.2363, 4464.5669);
	angles[23] = (0, 235.1380, 0);
	at[23] = 11.6667;
	points[24] = (1428.1810, -10461.3379, 4464.5669);
	angles[24] = (0, 238.8156, 0);
	at[24] = 11.7833;
	points[25] = (1502.0511, -10497.7559, 4464.5669);
	angles[25] = (0, 245.6241, 0);
	at[25] = 12.0167;
	points[26] = (1579.3190, -10527.6777, 4464.5669);
	angles[26] = (0, 249.2324, 0);
	at[26] = 12.2500;
	points[27] = (1658.3818, -10553.3066, 4464.5669);
	angles[27] = (0, 253.5453, 0);
	at[27] = 12.4833;
	points[28] = (1739.3583, -10565.5508, 4464.5669);
	angles[28] = (0, 262.2030, 0);
	at[28] = 12.7167;
	points[29] = (1904.7441, -10579.6455, 4464.5669);
	angles[29] = (0, 266.9704, 0);
	at[29] = 13.1833;
	points[30] = (1986.7401, -10574.2920, 4464.5669);
	angles[30] = (0, 275.0690, 0);
	at[30] = 13.4167;
	points[31] = (2150.6614, -10550.5117, 4464.5669);
	angles[31] = (0, 279.7238, 0);
	at[31] = 13.8833;
	points[32] = (2230.0789, -10529.3711, 4464.5669);
	angles[32] = (0, 286.0782, 0);
	at[32] = 14.1167;
	points[33] = (2308.8818, -10503.2285, 4464.5669);
	angles[33] = (0, 288.8149, 0);
	at[33] = 14.3500;
	points[34] = (2347.7046, -10488.6611, 4464.5669);
	angles[34] = (0, 290.6225, 0);
	at[34] = 14.4667;
	points[35] = (2383.5710, -10469.0557, 4464.5669);
	angles[35] = (0, 299.1174, 0);
	at[35] = 14.5833;
	points[36] = (2416.2205, -10443.6621, 4464.5669);
	angles[36] = (0, 306.6450, 0);
	at[36] = 14.7000;
	points[37] = (2477.5237, -10388.5430, 4464.5669);
	angles[37] = (0, 313.0212, 0);
	at[37] = 14.9333;
	points[38] = (2533.5786, -10327.2832, 4464.5669);
	angles[38] = (0, 318.4186, 0);
	at[38] = 15.1667;
	points[39] = (2557.9490, -10294.5273, 4464.5669);
	angles[39] = (0, 323.6835, 0);
	at[39] = 15.2833;
	points[40] = (2619.2363, -10186.1025, 4464.5669);
	angles[40] = (0, 332.2922, 0);
	at[40] = 15.6333;
	points[41] = (2633.4883, -10147.8350, 4464.5669);
	angles[41] = (0, 339.4595, 0);
	at[41] = 15.7500;
	points[42] = (2644.2205, -10107.7168, 4464.5669);
	angles[42] = (0, 344.2617, 0);
	at[42] = 15.8667;
	points[43] = (2658.2991, -10026.4570, 4464.5669);
	angles[43] = (0, 353.0684, 0);
	at[43] = 16.1000;
	points[44] = (2658.9290, -9985.2363, 4464.5669);
	angles[44] = (0, 358.1477, 0);
	at[44] = 16.2167;
	points[45] = (2658.1418, -9902.2842, 4464.5669);
	angles[45] = (0, 360.6215, 0);
	at[45] = 16.4500;
	points[46] = (2658.8503, -7421.7319, 4464.5669);
	angles[46] = (0, 360.0012, 0);
	at[46] = 23.4500;
	points[47] = (2657.3779, -7380.9058, 4464.5669);
	angles[47] = (0, 362.5986, 0);
	at[47] = 23.5667;
	points[48] = (2639.7795, -7300.0396, 4464.5669);
	angles[48] = (0, 373.4446, 0);
	at[48] = 23.8000;
	points[49] = (2601.7129, -7182.0474, 4464.5669);
	angles[49] = (0, 379.7706, 0);
	at[49] = 24.1500;
	points[50] = (2585.8191, -7143.7007, 4464.5669);
	angles[50] = (0, 382.6019, 0);
	at[50] = 24.2667;
	points[51] = (2563.8386, -7109.2129, 4464.5669);
	angles[51] = (0, 392.4203, 0);
	at[51] = 24.3833;
	points[52] = (2509.8623, -7046.4565, 4464.5669);
	angles[52] = (0, 401.4968, 0);
	at[52] = 24.6167;
	points[53] = (2480.5120, -7017.8350, 4464.5669);
	angles[53] = (0, 406.2912, 0);
	at[53] = 24.7333;
	points[54] = (2411.2520, -6972.2046, 4464.5669);
	angles[54] = (0, 417.5917, 0);
	at[54] = 24.9667;
	points[55] = (2337.9292, -6934.8428, 4464.5669);
	angles[55] = (0, 425.9298, 0);
	at[55] = 25.2000;
	points[56] = (2298.4172, -6921.9683, 4464.5669);
	angles[56] = (0, 430.9968, 0);
	at[56] = 25.3167;
	points[57] = (2178.6614, -6888.8188, 4464.5669);
	angles[57] = (0, 435.5935, 0);
	at[57] = 25.6667;
	points[58] = (2139.0828, -6880.6694, 4464.5669);
	angles[58] = (0, 438.6459, 0);
	at[58] = 25.7833;
	points[59] = (2056.3308, -6870.9053, 4464.5669);
	angles[59] = (0, 443.6696, 0);
	at[59] = 26.0167;
	points[60] = (1912.6141, -6860.7085, 4464.5669);
	angles[60] = (0, 447.7396, 0);
	at[60] = 26.4167;
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
	points[0] = (-2657.0671, -9152.9922, 4464.5669);
	angles[0] = (0, 136.4897, 0);
	at[0] = 0;
	points[1] = (-2681.3425, -9199.8037, 4464.5669);
	angles[1] = (0, 149.9590, 0);
	at[1] = 0.1000;
	points[2] = (-2714.8308, -9300.8662, 4464.5669);
	angles[2] = (0, 162.1890, 0);
	at[2] = 0.3000;
	points[3] = (-2740.0750, -9404.6855, 4464.5669);
	angles[3] = (0, 166.9565, 0);
	at[3] = 0.5000;
	points[4] = (-2748.1653, -9456.2207, 4464.5669);
	angles[4] = (0, 170.9975, 0);
	at[4] = 0.6000;
	points[5] = (-2751.4451, -9615.9844, 4464.5669);
	angles[5] = (0, 179.9584, 0);
	at[5] = 0.9000;
	points[6] = (-2747.7363, -9722.2832, 4464.5669);
	angles[6] = (0, 182.5589, 0);
	at[6] = 1.1000;
	points[7] = (-2741.8110, -9774.2910, 4464.5669);
	angles[7] = (0, 186.1909, 0);
	at[7] = 1.2000;
	points[8] = (-2699.5000, -9983.7012, 4464.5669);
	angles[8] = (0, 192.8317, 0);
	at[8] = 1.6000;
	points[9] = (-2685.6221, -10035.1973, 4464.5669);
	angles[9] = (0, 195.0768, 0);
	at[9] = 1.7000;
	points[10] = (-2666.8386, -10084.0557, 4464.5669);
	angles[10] = (0, 200.0530, 0);
	at[10] = 1.8000;
	points[11] = (-2622.4727, -10180.9053, 4464.5669);
	angles[11] = (0, 204.9752, 0);
	at[11] = 2;
	points[12] = (-2571.9883, -10274.8037, 4464.5669);
	angles[12] = (0, 209.4692, 0);
	at[12] = 2.2000;
	points[13] = (-2540.2441, -10316.1816, 4464.5669);
	angles[13] = (0, 216.4806, 0);
	at[13] = 2.3000;
	points[14] = (-2504.3938, -10355.7490, 4464.5669);
	angles[14] = (0, 221.0293, 0);
	at[14] = 2.4000;
	points[15] = (-2428.4331, -10430.7480, 4464.5669);
	angles[15] = (0, 226.0577, 0);
	at[15] = 2.6000;
	points[16] = (-2387.5828, -10465.3154, 4464.5669);
	angles[16] = (0, 229.5149, 0);
	at[16] = 2.7000;
	points[17] = (-2342.1416, -10491.0625, 4464.5669);
	angles[17] = (0, 240.0468, 0);
	at[17] = 2.8000;
	points[18] = (-2291.6614, -10507.1270, 4464.5669);
	angles[18] = (0, 249.7212, 0);
	at[18] = 2.9000;
	points[19] = (-2188.0591, -10532.4404, 4464.5669);
	angles[19] = (0, 256.5081, 0);
	at[19] = 3.1000;
	points[20] = (-2083.5984, -10552.6768, 4464.5669);
	angles[20] = (0, 259.5734, 0);
	at[20] = 3.3000;
	points[21] = (-2031.5237, -10558.6221, 4464.5669);
	angles[21] = (0, 263.3163, 0);
	at[21] = 3.4000;
	points[22] = (-1871.4725, -10561.3389, 4464.5669);
	angles[22] = (0, 270.0327, 0);
	at[22] = 3.7000;
	points[23] = (-1765.4646, -10556.1025, 4464.5669);
	angles[23] = (0, 274.1325, 0);
	at[23] = 3.9000;
	points[24] = (-1661.1654, -10536.7715, 4464.5669);
	angles[24] = (0, 280.9372, 0);
	at[24] = 4.1000;
	points[25] = (-1557.5276, -10511.3389, 4464.5669);
	angles[25] = (0, 284.3835, 0);
	at[25] = 4.3000;
	points[26] = (-1506.4135, -10495.2754, 4464.5669);
	angles[26] = (0, 287.2505, 0);
	at[26] = 4.4000;
	points[27] = (-1460.0197, -10471.3779, 4464.5669);
	angles[27] = (0, 297.1497, 0);
	at[27] = 4.5000;
	points[28] = (-1419.5511, -10437.1260, 4464.5669);
	angles[28] = (0, 307.5272, 0);
	at[28] = 4.6000;
	points[29] = (-1381.2283, -10400.1572, 4464.5669);
	angles[29] = (0, 312.6072, 0);
	at[29] = 4.7000;
	points[30] = (-1308.2638, -10322.1660, 4464.5669);
	angles[30] = (0, 317.4417, 0);
	at[30] = 4.9000;
	points[31] = (-1274.5276, -10281.1035, 4464.5669);
	angles[31] = (0, 320.5141, 0);
	at[31] = 5;
	points[32] = (-1247.5276, -10236.2207, 4464.5669);
	angles[32] = (0, 327.6667, 0);
	at[32] = 5.1000;
	points[33] = (-1223.4133, -10188.5439, 4464.5669);
	angles[33] = (0, 332.0336, 0);
	at[33] = 5.2000;
	points[34] = (-1179.6693, -10091.2598, 4464.5669);
	angles[34] = (0, 336.2343, 0);
	at[34] = 5.4000;
	points[35] = (-1160.4803, -10041.7324, 4464.5669);
	angles[35] = (0, 338.6952, 0);
	at[35] = 5.5000;
	points[36] = (-1133.1024, -9939.6855, 4464.5669);
	angles[36] = (0, 345.3993, 0);
	at[36] = 5.7000;
	points[37] = (-1109.7914, -9835.3936, 4464.5669);
	angles[37] = (0, 347.6360, 0);
	at[37] = 5.9000;
	points[38] = (-1091.7677, -9731.6934, 4464.5669);
	angles[38] = (0, 351.5431, 0);
	at[38] = 6.1000;
	points[39] = (-1087.0079, -9624.8428, 4464.5669);
	angles[39] = (0, 357.8503, 0);
	at[39] = 6.3000;
	points[40] = (-1087.5748, -9518.1885, 4464.5669);
	angles[40] = (0, 360.7635, 0);
	at[40] = 6.5000;
	points[41] = (-1090.5985, -9465, 4464.5669);
	angles[41] = (0, 363.1305, 0);
	at[41] = 6.6000;
	points[42] = (-1099.0355, -9413.7012, 4464.5669);
	angles[42] = (0, 368.5115, 0);
	at[42] = 6.7000;
	points[43] = (-1124.1378, -9309.8027, 4464.5669);
	angles[43] = (0, 373.9738, 0);
	at[43] = 6.9000;
	points[44] = (-1155.9449, -9207.8740, 4464.5669);
	angles[44] = (0, 378.3024, 0);
	at[44] = 7.1000;
	points[45] = (-1177.6654, -9159.0947, 4464.5669);
	angles[45] = (0, 383.9744, 0);
	at[45] = 7.2000;
	points[46] = (-1210.8071, -9119.4092, 4464.5669);
	angles[46] = (0, 397.3091, 0);
	at[46] = 7.3000;
	points[47] = (-1249.7559, -9082.7168, 4464.5669);
	angles[47] = (0, 404.6609, 0);
	at[47] = 7.4000;
	points[48] = (-1331.0039, -9013.6221, 4464.5669);
	angles[48] = (0, 409.8362, 0);
	at[48] = 7.6000;
	points[49] = (-1414.9802, -8947.4805, 4464.5669);
	angles[49] = (0, 412.1443, 0);
	at[49] = 7.8000;
	points[50] = (-1458.1063, -8918.0713, 4464.5669);
	angles[50] = (0, 415.9675, 0);
	at[50] = 7.9000;
	points[51] = (-1505.8149, -8894.2129, 4464.5669);
	angles[51] = (0, 422.1152, 0);
	at[51] = 8;
	points[52] = (-1603.4174, -8852.0078, 4464.5669);
	angles[52] = (0, 426.2772, 0);
	at[52] = 8.2000;
	points[53] = (-2132.1104, -8601.3779, 4464.5669);
	angles[53] = (0, 424.6139, 0);
	at[53] = 9.3000;
	points[54] = (-2325.6221, -8513.7402, 4464.5669);
	angles[54] = (0, 424.7355, 0);
	at[54] = 9.7000;
	points[55] = (-2372.6377, -8488.3467, 4464.5669);
	angles[55] = (0, 421.6370, 0);
	at[55] = 9.8000;
	points[56] = (-2414.8740, -8458.0713, 4464.5669);
	angles[56] = (0, 415.6885, 0);
	at[56] = 9.9000;
	points[57] = (-2498.1575, -8391.3389, 4464.5669);
	angles[57] = (0, 411.0537, 0);
	at[57] = 10.1000;
	points[58] = (-2578.4055, -8320.7080, 4464.5669);
	angles[58] = (0, 408.0192, 0);
	at[58] = 10.3000;
	points[59] = (-2615.6694, -8282.9922, 4464.5669);
	angles[59] = (0, 404.7607, 0);
	at[59] = 10.4000;
	points[60] = (-2644.5120, -8239.8037, 4464.5669);
	angles[60] = (0, 394.6941, 0);
	at[60] = 10.5000;
	points[61] = (-2687.8542, -8142.1655, 4464.5669);
	angles[61] = (0, 383.5319, 0);
	at[61] = 10.7000;
	points[62] = (-2740.1929, -7991.2207, 4464.5669);
	angles[62] = (0, 377.3846, 0);
	at[62] = 11;
	points[63] = (-2749.8662, -7939.7637, 4464.5669);
	angles[63] = (0, 370.9304, 0);
	at[63] = 11.1000;
	points[64] = (-2753.0549, -7886.3389, 4464.5669);
	angles[64] = (0, 364.9156, 0);
	at[64] = 11.2000;
	points[65] = (-2753.0867, -7779.8032, 4464.5669);
	angles[65] = (0, 359.6144, 0);
	at[65] = 11.4000;
	points[66] = (-2745.6299, -7674.4487, 4464.5669);
	angles[66] = (0, 354.3326, 0);
	at[66] = 11.6000;
	points[67] = (-2718.8660, -7571.3384, 4464.5669);
	angles[67] = (0, 344.9265, 0);
	at[67] = 11.8000;
	points[68] = (-2653.1890, -7369.6455, 4464.5669);
	angles[68] = (0, 341.1013, 0);
	at[68] = 12.2000;
	points[69] = (-2597.4055, -7219.5669, 4464.5669);
	angles[69] = (0, 338.8607, 0);
	at[69] = 12.5000;
	points[70] = (-2576.6025, -7170.2759, 4464.5669);
	angles[70] = (0, 337.2364, 0);
	at[70] = 12.6000;
	points[71] = (-2552.3740, -7123.5825, 4464.5669);
	angles[71] = (0, 332.2584, 0);
	at[71] = 12.7000;
	points[72] = (-2519.3228, -7082.3232, 4464.5669);
	angles[72] = (0, 323.3244, 0);
	at[72] = 12.8000;
	points[73] = (-2445.1575, -7005.6299, 4464.5669);
	angles[73] = (0, 315.3559, 0);
	at[73] = 13;
	points[74] = (-2405.3386, -6969.9609, 4464.5669);
	angles[74] = (0, 312.2562, 0);
	at[74] = 13.1000;
	points[75] = (-2362.4922, -6939.1338, 4464.5669);
	angles[75] = (0, 305.6128, 0);
	at[75] = 13.2000;
	points[76] = (-2313.1379, -6920.5513, 4464.5669);
	angles[76] = (0, 293.3996, 0);
	at[76] = 13.3000;
	points[77] = (-2261.8821, -6906.2603, 4464.5669);
	angles[77] = (0, 287.3104, 0);
	at[77] = 13.4000;
	points[78] = (-2105.4646, -6871.9688, 4464.5669);
	angles[78] = (0, 281.2709, 0);
	at[78] = 13.7000;
	points[79] = (-2054.1692, -6864.2524, 4464.5669);
	angles[79] = (0, 278.5338, 0);
	at[79] = 13.8000;
	points[80] = (-1893.9409, -6859.6851, 4464.5669);
	angles[80] = (0, 270.4824, 0);
	at[80] = 14.1000;
	points[81] = (-1787.4724, -6862.9131, 4464.5669);
	angles[81] = (0, 267.5825, 0);
	at[81] = 14.3000;
	points[82] = (-1735.5867, -6869.3701, 4464.5669);
	angles[82] = (0, 263.2568, 0);
	at[82] = 14.4000;
	points[83] = (-1579.4370, -6904.0557, 4464.5669);
	angles[83] = (0, 256.2509, 0);
	at[83] = 14.7000;
	points[84] = (-1527.9607, -6918.8584, 4464.5669);
	angles[84] = (0, 254.1667, 0);
	at[84] = 14.8000;
	points[85] = (-1478.4135, -6937.8740, 4464.5669);
	angles[85] = (0, 248.8078, 0);
	at[85] = 14.9000;
	points[86] = (-1436.5040, -6969.2129, 4464.5669);
	angles[86] = (0, 235.8315, 0);
	at[86] = 15;
	points[87] = (-1360.8859, -7044.4092, 4464.5669);
	angles[87] = (0, 224.6783, 0);
	at[87] = 15.2000;
	points[88] = (-1292.6102, -7126.2993, 4464.5669);
	angles[88] = (0, 218.3062, 0);
	at[88] = 15.4000;
	points[89] = (-1267.4568, -7172.2046, 4464.5669);
	angles[89] = (0, 210.2333, 0);
	at[89] = 15.5000;
	points[90] = (-1204.8188, -7319.4878, 4464.5669);
	angles[90] = (0, 202.1527, 0);
	at[90] = 15.8000;
	points[91] = (-1168.3740, -7418.3462, 4464.5669);
	angles[91] = (0, 199.7161, 0);
	at[91] = 16;
	points[92] = (-1119.4764, -7570.9448, 4464.5669);
	angles[92] = (0, 197.1484, 0);
	at[92] = 16.3000;
	points[93] = (-1092.9055, -7674.0552, 4464.5669);
	angles[93] = (0, 192.9285, 0);
	at[93] = 16.5000;
	points[94] = (-1085.5315, -7779.4097, 4464.5669);
	angles[94] = (0, 183.3805, 0);
	at[94] = 16.7000;
	points[95] = (-1085.4331, -7886.1025, 4464.5669);
	angles[95] = (0, 179.5332, 0);
	at[95] = 16.9000;
	points[96] = (-1088.3622, -7939.5669, 4464.5669);
	angles[96] = (0, 177.0729, 0);
	at[96] = 17;
	points[97] = (-1097.3820, -7991.0635, 4464.5669);
	angles[97] = (0, 170.3806, 0);
	at[97] = 17.1000;
	points[98] = (-1113.1969, -8041.5356, 4464.5669);
	angles[98] = (0, 164.2196, 0);
	at[98] = 17.2000;
	points[99] = (-1150.5748, -8141.6143, 4464.5669);
	angles[99] = (0, 159.1535, 0);
	at[99] = 17.4000;
	points[100] = (-1194.1378, -8239.2129, 4464.5669);
	angles[100] = (0, 154.9418, 0);
	at[100] = 17.6000;
	points[101] = (-1222.3386, -8282.9131, 4464.5669);
	angles[101] = (0, 147.2528, 0);
	at[101] = 17.7000;
	points[102] = (-1258.6812, -8321.5752, 4464.5669);
	angles[102] = (0, 138.8904, 0);
	at[102] = 17.8000;
	points[103] = (-1297.4213, -8358.4258, 4464.5669);
	angles[103] = (0, 134.6633, 0);
	at[103] = 17.9000;
	points[104] = (-1419.2126, -8461.5361, 4464.5669);
	angles[104] = (0, 128.7845, 0);
	at[104] = 18.2000;
	points[105] = (-1463.1732, -8490.0791, 4464.5669);
	angles[105] = (0, 123.1852, 0);
	at[105] = 18.3000;
	points[106] = (-1510.9528, -8514.2129, 4464.5669);
	angles[106] = (0, 118.1006, 0);
	at[106] = 18.4000;
	points[107] = (-1608.0513, -8558.5830, 4464.5669);
	angles[107] = (0, 114.4841, 0);
	at[107] = 18.6000;
	points[108] = (-2329.6338, -8897.0078, 4464.5669);
	angles[108] = (0, 115.7823, 0);
	at[108] = 20.1000;
	points[109] = (-2374.4409, -8923.2285, 4464.5669);
	angles[109] = (0, 120.2748, 0);
	at[109] = 20.2000;
	points[110] = (-2503.5117, -9018.4648, 4464.5669);
	angles[110] = (0, 127.1035, 0);
	at[110] = 20.5000;
	points[111] = (-2586.5237, -9085.1973, 4464.5669);
	angles[111] = (0, 129.2598, 0);
	at[111] = 20.7000;
	points[112] = (-2626.9175, -9120.9453, 4464.5669);
	angles[112] = (0, 131.3462, 0);
	at[112] = 20.8000;
	points[113] = (-2657.0671, -9152.9922, 4464.5669);
	angles[113] = (0, 136.4897, 0);
	at[113] = 20.8833;
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
	points[0] = (-4578.3467, -9148.2676, 4464.5669);
	angles[0] = (0, 17.2601, 0);
	at[0] = 0;
	points[1] = (-4630, -8946.9688, 4464.5669);
	angles[1] = (0, 13.3714, 0);
	at[1] = 0.5833;
	points[2] = (-4648.2285, -8859.8818, 4464.5669);
	angles[2] = (0, 10.9622, 0);
	at[2] = 0.8333;
	points[3] = (-4651.8896, -8832.0078, 4464.5669);
	angles[3] = (0, 7.9609, 0);
	at[3] = 0.9167;
	points[4] = (-4655.7480, -8742.9922, 4464.5669);
	angles[4] = (0, 1.8043, 0);
	at[4] = 1.1667;
	points[5] = (-4655.0396, -8624.4092, 4464.5669);
	angles[5] = (0, -1.1902, 0);
	at[5] = 1.5000;
	points[6] = (-4651.6929, -8565, 4464.5669);
	angles[6] = (0, -3.7503, 0);
	at[6] = 1.6667;
	points[7] = (-4641.6143, -8507.6377, 4464.5669);
	angles[7] = (0, -10.4630, 0);
	at[7] = 1.8333;
	points[8] = (-4580.2363, -8278.7012, 4464.5669);
	angles[8] = (0, -16.5889, 0);
	at[8] = 2.5000;
	points[9] = (-4541.6538, -8167.9922, 4464.5669);
	angles[9] = (0, -20.0199, 0);
	at[9] = 2.8333;
	points[10] = (-4496.1812, -8058.5044, 4464.5669);
	angles[10] = (0, -24.3377, 0);
	at[10] = 3.1667;
	points[11] = (-4465.3936, -8009.3701, 4464.5669);
	angles[11] = (0, -33.7979, 0);
	at[11] = 3.3333;
	points[12] = (-4427.4409, -7963.8193, 4464.5669);
	angles[12] = (0, -39.7402, 0);
	at[12] = 3.5000;
	points[13] = (-4367.0474, -7898.6221, 4464.5669);
	angles[13] = (0, -43.5921, 0);
	at[13] = 3.7500;
	points[14] = (-4301.6143, -7838.5435, 4464.5669);
	angles[14] = (0, -49.4155, 0);
	at[14] = 4;
	points[15] = (-4277.7954, -7822.8745, 4464.5669);
	angles[15] = (0, -55.9087, 0);
	at[15] = 4.0833;
	points[16] = (-4250.5513, -7811.7720, 4464.5669);
	angles[16] = (0, -64.7870, 0);
	at[16] = 4.1667;
	points[17] = (-4193.5435, -7794.7637, 4464.5669);
	angles[17] = (0, -73.2350, 0);
	at[17] = 4.3333;
	points[18] = (-4077.8743, -7768.1499, 4464.5669);
	angles[18] = (0, -77.9733, 0);
	at[18] = 4.6667;
	points[19] = (-3990.0789, -7752.4014, 4464.5669);
	angles[19] = (0, -80.6127, 0);
	at[19] = 4.9167;
	points[20] = (-3932.2324, -7747.4805, 4464.5669);
	angles[20] = (0, -85.6220, 0);
	at[20] = 5.0833;
	points[21] = (-3814.0042, -7745.5117, 4464.5669);
	angles[21] = (0, -89.8431, 0);
	at[21] = 5.4167;
	points[22] = (-3725.1023, -7747.7954, 4464.5669);
	angles[22] = (0, -92.1081, 0);
	at[22] = 5.6667;
	points[23] = (-3667.2166, -7753.5039, 4464.5669);
	angles[23] = (0, -96.6275, 0);
	at[23] = 5.8333;
	points[24] = (-3522.1614, -7783.4644, 4464.5669);
	angles[24] = (0, -103.1155, 0);
	at[24] = 6.2500;
	points[25] = (-3465.0117, -7798.7402, 4464.5669);
	angles[25] = (0, -105.3050, 0);
	at[25] = 6.4167;
	points[26] = (-3408.8660, -7818.2676, 4464.5669);
	angles[26] = (0, -110.2654, 0);
	at[26] = 6.5833;
	points[27] = (-3384.4331, -7832.1265, 4464.5669);
	angles[27] = (0, -118.0917, 0);
	at[27] = 6.6667;
	points[28] = (-3338.9136, -7870.3940, 4464.5669);
	angles[28] = (0, -129.9694, 0);
	at[28] = 6.8333;
	points[29] = (-3275.6653, -7932.9922, 4464.5669);
	angles[29] = (0, -135.3938, 0);
	at[29] = 7.0833;
	points[30] = (-3215.9331, -7998.7402, 4464.5669);
	angles[30] = (0, -138.5177, 0);
	at[30] = 7.3333;
	points[31] = (-3180.4568, -8044.8428, 4464.5669);
	angles[31] = (0, -144.1285, 0);
	at[31] = 7.5000;
	points[32] = (-3167.0042, -8071.3779, 4464.5669);
	angles[32] = (0, -150.9584, 0);
	at[32] = 7.5833;
	points[33] = (-3145.3110, -8126.5356, 4464.5669);
	angles[33] = (0, -158.5110, 0);
	at[33] = 7.7500;
	points[34] = (-3092.3542, -8294.9609, 4464.5669);
	angles[34] = (0, -163.4812, 0);
	at[34] = 8.2500;
	points[35] = (-3038.9529, -8495.7480, 4464.5669);
	angles[35] = (0, -166.3461, 0);
	at[35] = 8.8333;
	points[36] = (-3027.2207, -8553.8193, 4464.5669);
	angles[36] = (0, -169.3271, 0);
	at[36] = 9;
	points[37] = (-3022.8113, -8611.7715, 4464.5669);
	angles[37] = (0, -175.8686, 0);
	at[37] = 9.1667;
	points[38] = (-3021.1223, -8730.1963, 4464.5669);
	angles[38] = (0, -179.9373, 0);
	at[38] = 9.5000;
	points[39] = (-3025.5710, -8848.9375, 4464.5669);
	angles[39] = (0, -183.7157, 0);
	at[39] = 9.8333;
	points[40] = (-3048.6340, -8963.6221, 4464.5669);
	angles[40] = (0, -193.0073, 0);
	at[40] = 10.1667;
	points[41] = (-3094.6731, -9135.0391, 4464.5669);
	angles[41] = (0, -196.0890, 0);
	at[41] = 10.6667;
	points[42] = (-3123.4214, -9218.5820, 4464.5669);
	angles[42] = (0, -199.8082, 0);
	at[42] = 10.9167;
	points[43] = (-3168.7441, -9328.0322, 4464.5669);
	angles[43] = (0, -203.9287, 0);
	at[43] = 11.2500;
	points[44] = (-3196.6064, -9378.7793, 4464.5669);
	angles[44] = (0, -210.4680, 0);
	at[44] = 11.4167;
	points[45] = (-3232.6025, -9425.9844, 4464.5669);
	angles[45] = (0, -217.2357, 0);
	at[45] = 11.5833;
	points[46] = (-3270.5552, -9471.7324, 4464.5669);
	angles[46] = (0, -219.7536, 0);
	at[46] = 11.7500;
	points[47] = (-3350.9409, -9559.0156, 4464.5669);
	angles[47] = (0, -224.2808, 0);
	at[47] = 12.0833;
	points[48] = (-3395.7874, -9596.5352, 4464.5669);
	angles[48] = (0, -232.4352, 0);
	at[48] = 12.2500;
	points[49] = (-3422.1653, -9608.3857, 4464.5669);
	angles[49] = (0, -242.4905, 0);
	at[49] = 12.3333;
	points[50] = (-3478.9802, -9625.6299, 4464.5669);
	angles[50] = (0, -252.9726, 0);
	at[50] = 12.5000;
	points[51] = (-3594.8425, -9650.9844, 4464.5669);
	angles[51] = (0, -258.7564, 0);
	at[51] = 12.8333;
	points[52] = (-3682.2678, -9665.0400, 4464.5669);
	angles[52] = (0, -261.7780, 0);
	at[52] = 13.0833;
	points[53] = (-3799.9565, -9670.1973, 4464.5669);
	angles[53] = (0, -268.7742, 0);
	at[53] = 13.4167;
	points[54] = (-3918.5315, -9668.9766, 4464.5669);
	angles[54] = (0, -271.3736, 0);
	at[54] = 13.7500;
	points[55] = (-4005.8269, -9661.5752, 4464.5669);
	angles[55] = (0, -276.7117, 0);
	at[55] = 14;
	points[56] = (-4151.5747, -9634.6455, 4464.5669);
	angles[56] = (0, -281.6785, 0);
	at[56] = 14.4167;
	points[57] = (-4265.7876, -9603.5039, 4464.5669);
	angles[57] = (0, -288.1627, 0);
	at[57] = 14.7500;
	points[58] = (-4290.9448, -9590.7090, 4464.5669);
	angles[58] = (0, -295.7895, 0);
	at[58] = 14.8333;
	points[59] = (-4314.8032, -9572.6768, 4464.5669);
	angles[59] = (0, -304.0687, 0);
	at[59] = 14.9167;
	points[60] = (-4358.7402, -9532.9922, 4464.5669);
	angles[60] = (0, -312.0367, 0);
	at[60] = 15.0833;
	points[61] = (-4420.7876, -9469.1338, 4464.5669);
	angles[61] = (0, -316.5656, 0);
	at[61] = 15.3333;
	points[62] = (-4478.4253, -9401.1416, 4464.5669);
	angles[62] = (0, -321.1990, 0);
	at[62] = 15.5833;
	points[63] = (-4493.7007, -9376.9287, 4464.5669);
	angles[63] = (0, -326.6906, 0);
	at[63] = 15.6667;
	points[64] = (-4517.8740, -9323.2285, 4464.5669);
	angles[64] = (0, -335.7921, 0);
	at[64] = 15.8333;
	points[65] = (-4567.4409, -9183.4648, 4464.5669);
	angles[65] = (0, -341.7231, 0);
	at[65] = 16.2500;
	points[66] = (-4578.3467, -9148.2676, 4464.5669);
	angles[66] = (0, -342.7399, 0);
	at[66] = 16.3667;
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
