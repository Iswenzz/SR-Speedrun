main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_sw_peach_gardens", 0);

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
	ambientPlay("iz_0_swpg", 2);
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
	level.iz_route[level.iz_route.size] = (16, 5359, 4268);
	level.iz_route[level.iz_route.size] = (9, 3695, 4272);
	level.iz_route[level.iz_route.size] = (36, 2411, 4268);
	level.iz_route[level.iz_route.size] = (868, 1725, 4268);
	level.iz_route[level.iz_route.size] = (1676, 783, 4268);
	level.iz_route[level.iz_route.size] = (2521, 183, 4268);
	level.iz_route[level.iz_route.size] = (3822, -12, 4272);
	level.iz_route[level.iz_route.size] = (5998, -4, 4268);
	level.iz_route[level.iz_route.size] = (6912, 171, 4266);
	level.iz_route[level.iz_route.size] = (7594, -581, 4275);
	level.iz_route[level.iz_route.size] = (8507, -1995, 4270);
	level.iz_route[level.iz_route.size] = (8480, -2527, 4364);
	level.iz_route[level.iz_route.size] = (8474, -3357, 4652);
	level.iz_route[level.iz_route.size] = (8459, -4092, 4846);
	level.iz_route[level.iz_route.size] = (8447, -5030, 4998);
	level.iz_route[level.iz_route.size] = (8510, -6398, 5012);
	level.iz_route[level.iz_route.size] = (8133, -7242, 5012);
	level.iz_route[level.iz_route.size] = (6781, -7954, 5012);
	level.iz_route[level.iz_route.size] = (5011, -7962, 4482);
	level.iz_route[level.iz_route.size] = (3414, -7233, 4482);
	level.iz_route[level.iz_route.size] = (2162, -7153, 4482);
	level.iz_route[level.iz_route.size] = (486, -7978, 4482);
	level.iz_route[level.iz_route.size] = (-575, -7999, 4482);
	level.iz_route[level.iz_route.size] = (-2096, -7130, 4482);
	level.iz_route[level.iz_route.size] = (-3193, -7137, 4482);
	level.iz_route[level.iz_route.size] = (-4597, -7958, 4482);
	level.iz_route[level.iz_route.size] = (-5365, -7960, 4579);
	level.iz_route[level.iz_route.size] = (-6739, -7951, 5006);
	level.iz_route[level.iz_route.size] = (-7605, -8015, 5012);
	level.iz_route[level.iz_route.size] = (-8334, -7284, 5012);
	level.iz_route[level.iz_route.size] = (-8451, -6139, 5012);
	level.iz_route[level.iz_route.size] = (-8448, -5123, 5005);
	level.iz_route[level.iz_route.size] = (-8459, -4287, 4885);
	level.iz_route[level.iz_route.size] = (-8467, -3319, 4641);
	level.iz_route[level.iz_route.size] = (-8456, -2119, 4278);
	level.iz_route[level.iz_route.size] = (-9438, -694, 4269);
	level.iz_route[level.iz_route.size] = (-9565, 377, 4269);
	level.iz_route[level.iz_route.size] = (-8546, 1797, 4273);
	level.iz_route[level.iz_route.size] = (-8488, 2493, 4269);
	level.iz_route[level.iz_route.size] = (-8133, 3331, 4268);
	level.iz_route[level.iz_route.size] = (-7941, 4256, 4268);
	level.iz_route[level.iz_route.size] = (-8101, 5998, 4282);
	level.iz_route[level.iz_route.size] = (-8196, 8936, 4272);
	level.iz_route[level.iz_route.size] = (-7499, 9322, 4325);
	level.iz_route[level.iz_route.size] = (-6653, 9451, 4408);
	level.iz_route[level.iz_route.size] = (-5918, 9479, 4480);
	level.iz_route[level.iz_route.size] = (-1932, 9542, 4482);
	level.iz_route[level.iz_route.size] = (-1163, 9552, 4482);
	level.iz_route[level.iz_route.size] = (-790, 8970, 4485);
	level.iz_route[level.iz_route.size] = (14, 7272, 4268);
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
	points[0] = (-9228.3076, 8686.7324, 4268.1890);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-9228.3076, 8686.7324, 4268.1890);
	angles[1] = (0, 0, 0);
	at[1] = 0.6000;
	points[2] = (-9228.3076, 8686.7324, 4322.2046);
	angles[2] = (0, 0, 0);
	at[2] = 0.6500;
	points[3] = (-9228.3076, 8686.7324, 4369.0156);
	angles[3] = (0, 0, 0);
	at[3] = 0.7000;
	points[4] = (-9228.3076, 8686.7324, 4408.6616);
	angles[4] = (0, 0, 0);
	at[4] = 0.7500;
	points[5] = (-9228.3076, 8686.7324, 4441.1025);
	angles[5] = (0, 0, 0);
	at[5] = 0.8000;
	points[6] = (-9228.3076, 8686.7324, 4466.4175);
	angles[6] = (0, 0, 0);
	at[6] = 0.8500;
	points[7] = (-9228.3076, 8686.7324, 4484.5273);
	angles[7] = (0, 0, 0);
	at[7] = 0.9000;
	points[8] = (-9228.3076, 8686.7324, 4495.4722);
	angles[8] = (0, 0, 0);
	at[8] = 0.9500;
	points[9] = (-9228.3076, 8686.7324, 4499.2520);
	angles[9] = (0, 0, 0);
	at[9] = 1;
	points[10] = (-9228.3076, 8686.7324, 4495.8267);
	angles[10] = (0, 0, 0);
	at[10] = 1.0500;
	points[11] = (-9228.3076, 8686.7324, 4485.2363);
	angles[11] = (0, 0, 0);
	at[11] = 1.1000;
	points[12] = (-9228.3076, 8686.7324, 4467.4805);
	angles[12] = (0, 0, 0);
	at[12] = 1.1500;
	points[13] = (-9228.3076, 8686.7324, 4442.5195);
	angles[13] = (0, 0, 0);
	at[13] = 1.2000;
	points[14] = (-9228.3076, 8686.7324, 4410.4331);
	angles[14] = (0, 0, 0);
	at[14] = 1.2500;
	points[15] = (-9228.3076, 8686.7324, 4371.1416);
	angles[15] = (0, 0, 0);
	at[15] = 1.3000;
	points[16] = (-9228.3076, 8686.7324, 4324.6851);
	angles[16] = (0, 0, 0);
	at[16] = 1.3500;
	points[17] = (-9228.3076, 8686.7324, 4271.0239);
	angles[17] = (0, 0, 0);
	at[17] = 1.4000;
	points[18] = (-9228.3076, 8686.7324, 4091.0237);
	angles[18] = (0, 0, 0);
	at[18] = 1.4500;
	points[19] = (-9228.3076, 8686.7324, 4091.0237);
	angles[19] = (0, 0, 0);
	at[19] = 2.5000;
	points[20] = (-9228.3076, 8686.7324, 4268.1890);
	angles[20] = (0, 0, 0);
	at[20] = 2.5500;
	points[21] = (-9228.3076, 8686.7324, 4268.1890);
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
	points[0] = (-9990.7881, 3605.3938, 4488.9761);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-9990.7881, 3605.3938, 4497.5195);
	angles[1] = (0, 0, 0);
	at[1] = 0.0500;
	points[2] = (-9990.7881, 3605.3938, 4498.8979);
	angles[2] = (0, 0, 0);
	at[2] = 0.1000;
	points[3] = (-9990.7881, 3605.3938, 4493.0708);
	angles[3] = (0, 0, 0);
	at[3] = 0.1500;
	points[4] = (-9990.7881, 3605.3938, 4480.1182);
	angles[4] = (0, 0, 0);
	at[4] = 0.2000;
	points[5] = (-9990.7881, 3605.3938, 4459.9604);
	angles[5] = (0, 0, 0);
	at[5] = 0.2500;
	points[6] = (-9990.7881, 3605.3938, 4432.6377);
	angles[6] = (0, 0, 0);
	at[6] = 0.3000;
	points[7] = (-9990.7881, 3605.3938, 4398.1104);
	angles[7] = (0, 0, 0);
	at[7] = 0.3500;
	points[8] = (-9990.7881, 3605.3938, 4356.4565);
	angles[8] = (0, 0, 0);
	at[8] = 0.4000;
	points[9] = (-9990.7881, 3605.3938, 4307.5986);
	angles[9] = (0, 0, 0);
	at[9] = 0.4500;
	points[10] = (-9990.7881, 3605.3938, 4091.0237);
	angles[10] = (0, 0, 0);
	at[10] = 0.5000;
	points[11] = (-9990.7881, 3605.3938, 4091.0237);
	angles[11] = (0, 0, 0);
	at[11] = 2.5000;
	points[12] = (-9990.7881, 3605.3938, 4268.1890);
	angles[12] = (0, 0, 0);
	at[12] = 2.5500;
	points[13] = (-9990.7881, 3605.3938, 4268.1890);
	angles[13] = (0, 0, 0);
	at[13] = 4.1500;
	points[14] = (-9990.7881, 3605.3938, 4287.0078);
	angles[14] = (0, 0, 0);
	at[14] = 4.2000;
	points[15] = (-9990.7881, 3605.3938, 4338.6221);
	angles[15] = (0, 0, 0);
	at[15] = 4.2500;
	points[16] = (-9990.7881, 3605.3938, 4383.0317);
	angles[16] = (0, 0, 0);
	at[16] = 4.3000;
	points[17] = (-9990.7881, 3605.3938, 4420.2759);
	angles[17] = (0, 0, 0);
	at[17] = 4.3500;
	points[18] = (-9990.7881, 3605.3938, 4450.3545);
	angles[18] = (0, 0, 0);
	at[18] = 4.4000;
	points[19] = (-9990.7881, 3605.3938, 4473.2285);
	angles[19] = (0, 0, 0);
	at[19] = 4.4500;
	points[20] = (-9990.7881, 3605.3938, 4488.9761);
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
	points[0] = (-9322.4014, 5480.7480, 4338.6221);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-9322.4014, 5480.7480, 4383.0317);
	angles[1] = (0, 0, 0);
	at[1] = 0.0500;
	points[2] = (-9322.4014, 5480.7480, 4420.2759);
	angles[2] = (0, 0, 0);
	at[2] = 0.1000;
	points[3] = (-9322.4014, 5480.7480, 4450.3545);
	angles[3] = (0, 0, 0);
	at[3] = 0.1500;
	points[4] = (-9322.4014, 5480.7480, 4473.2285);
	angles[4] = (0, 0, 0);
	at[4] = 0.2000;
	points[5] = (-9322.4014, 5480.7480, 4488.9761);
	angles[5] = (0, 0, 0);
	at[5] = 0.2500;
	points[6] = (-9322.4014, 5480.7480, 4497.5195);
	angles[6] = (0, 0, 0);
	at[6] = 0.3000;
	points[7] = (-9322.4014, 5480.7480, 4498.8979);
	angles[7] = (0, 0, 0);
	at[7] = 0.3500;
	points[8] = (-9322.4014, 5480.7480, 4493.0708);
	angles[8] = (0, 0, 0);
	at[8] = 0.4000;
	points[9] = (-9322.4014, 5480.7480, 4480.1182);
	angles[9] = (0, 0, 0);
	at[9] = 0.4500;
	points[10] = (-9322.4014, 5480.7480, 4459.9604);
	angles[10] = (0, 0, 0);
	at[10] = 0.5000;
	points[11] = (-9322.4014, 5480.7480, 4432.6377);
	angles[11] = (0, 0, 0);
	at[11] = 0.5500;
	points[12] = (-9322.4014, 5480.7480, 4398.1104);
	angles[12] = (0, 0, 0);
	at[12] = 0.6000;
	points[13] = (-9322.4014, 5480.7480, 4356.4565);
	angles[13] = (0, 0, 0);
	at[13] = 0.6500;
	points[14] = (-9322.4014, 5480.7480, 4307.5986);
	angles[14] = (0, 0, 0);
	at[14] = 0.7000;
	points[15] = (-9322.4014, 5480.7480, 4091.0237);
	angles[15] = (0, 0, 0);
	at[15] = 0.7500;
	points[16] = (-9322.4014, 5480.7480, 4091.0237);
	angles[16] = (0, 0, 0);
	at[16] = 2.5000;
	points[17] = (-9322.4014, 5480.7480, 4268.1890);
	angles[17] = (0, 0, 0);
	at[17] = 2.5500;
	points[18] = (-9322.4014, 5480.7480, 4268.1890);
	angles[18] = (0, 0, 0);
	at[18] = 4.1500;
	points[19] = (-9322.4014, 5480.7480, 4287.0078);
	angles[19] = (0, 0, 0);
	at[19] = 4.2000;
	points[20] = (-9322.4014, 5480.7480, 4338.6221);
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
	points[0] = (-8733.7012, 7273.7007, 4268.1890);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-8733.7012, 7273.7007, 4268.1890);
	angles[1] = (0, 0, 0);
	at[1] = 0.3500;
	points[2] = (-8733.7012, 7273.7007, 4322.2046);
	angles[2] = (0, 0, 0);
	at[2] = 0.4000;
	points[3] = (-8733.7012, 7273.7007, 4369.0156);
	angles[3] = (0, 0, 0);
	at[3] = 0.4500;
	points[4] = (-8733.7012, 7273.7007, 4408.6616);
	angles[4] = (0, 0, 0);
	at[4] = 0.5000;
	points[5] = (-8733.7012, 7273.7007, 4441.1025);
	angles[5] = (0, 0, 0);
	at[5] = 0.5500;
	points[6] = (-8733.7012, 7273.7007, 4466.4175);
	angles[6] = (0, 0, 0);
	at[6] = 0.6000;
	points[7] = (-8733.7012, 7273.7007, 4484.5273);
	angles[7] = (0, 0, 0);
	at[7] = 0.6500;
	points[8] = (-8733.7012, 7273.7007, 4495.4722);
	angles[8] = (0, 0, 0);
	at[8] = 0.7000;
	points[9] = (-8733.7012, 7273.7007, 4499.2520);
	angles[9] = (0, 0, 0);
	at[9] = 0.7500;
	points[10] = (-8733.7012, 7273.7007, 4495.8267);
	angles[10] = (0, 0, 0);
	at[10] = 0.8000;
	points[11] = (-8733.7012, 7273.7007, 4485.2363);
	angles[11] = (0, 0, 0);
	at[11] = 0.8500;
	points[12] = (-8733.7012, 7273.7007, 4467.4805);
	angles[12] = (0, 0, 0);
	at[12] = 0.9000;
	points[13] = (-8733.7012, 7273.7007, 4442.5195);
	angles[13] = (0, 0, 0);
	at[13] = 0.9500;
	points[14] = (-8733.7012, 7273.7007, 4410.4331);
	angles[14] = (0, 0, 0);
	at[14] = 1;
	points[15] = (-8733.7012, 7273.7007, 4371.1416);
	angles[15] = (0, 0, 0);
	at[15] = 1.0500;
	points[16] = (-8733.7012, 7273.7007, 4324.6851);
	angles[16] = (0, 0, 0);
	at[16] = 1.1000;
	points[17] = (-8733.7012, 7273.7007, 4271.0239);
	angles[17] = (0, 0, 0);
	at[17] = 1.1500;
	points[18] = (-8733.7012, 7273.7007, 4091.0237);
	angles[18] = (0, 0, 0);
	at[18] = 1.2000;
	points[19] = (-8733.7012, 7273.7007, 4091.0237);
	angles[19] = (0, 0, 0);
	at[19] = 2.5000;
	points[20] = (-8733.7012, 7273.7007, 4268.1890);
	angles[20] = (0, 0, 0);
	at[20] = 2.5500;
	points[21] = (-8733.7012, 7273.7007, 4268.1890);
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
	points[0] = (2314.2915, -6932.5986, 4488.1890);
	angles[0] = (0, 88.5201, 0);
	at[0] = 0;
	points[1] = (2208.9883, -6936.8506, 4488.1890);
	angles[1] = (0, 94.2041, 0);
	at[1] = 0.3000;
	points[2] = (2069.5120, -6959.7637, 4488.1890);
	angles[2] = (0, 101.0076, 0);
	at[2] = 0.7000;
	points[3] = (1897.5079, -7004.5669, 4488.1890);
	angles[3] = (0, 106.1592, 0);
	at[3] = 1.2000;
	points[4] = (1864.9213, -7016.5747, 4488.1890);
	angles[4] = (0, 110.3083, 0);
	at[4] = 1.3000;
	points[5] = (1833.2521, -7032.7163, 4488.1890);
	angles[5] = (0, 115.7763, 0);
	at[5] = 1.4000;
	points[6] = (1772.7637, -7069.8818, 4488.1890);
	angles[6] = (0, 122.6563, 0);
	at[6] = 1.6000;
	points[7] = (1746.1221, -7092.7563, 4488.1890);
	angles[7] = (0, 129.7547, 0);
	at[7] = 1.7000;
	points[8] = (1697.4646, -7144.6064, 4488.1890);
	angles[8] = (0, 137.3036, 0);
	at[8] = 1.9000;
	points[9] = (1675.0433, -7172.3618, 4488.1890);
	angles[9] = (0, 140.8972, 0);
	at[9] = 2;
	points[10] = (1657.8544, -7202.6382, 4488.1890);
	angles[10] = (0, 148.8878, 0);
	at[10] = 2.1000;
	points[11] = (1614.0591, -7300.1182, 4488.1890);
	angles[11] = (0, 157.1032, 0);
	at[11] = 2.4000;
	points[12] = (1596.0551, -7368.1499, 4488.1890);
	angles[12] = (0, 166.8068, 0);
	at[12] = 2.6000;
	points[13] = (1584.8938, -7438.3467, 4488.1890);
	angles[13] = (0, 171.5855, 0);
	at[13] = 2.8000;
	points[14] = (1582.5631, -7472.9922, 4488.1890);
	angles[14] = (0, 175.7627, 0);
	at[14] = 2.9000;
	points[15] = (1583.1221, -7615.2754, 4488.1890);
	angles[15] = (0, 180.5714, 0);
	at[15] = 3.3000;
	points[16] = (1583.2559, -7792.2832, 4488.1890);
	angles[16] = (0, 180.0999, 0);
	at[16] = 3.8000;
	points[17] = (1583.3779, -7825.2363, 4488.1890);
	angles[17] = (0, 180.1850, 0);
	at[17] = 3.9000;
	points[18] = (1586.5906, -8503.6611, 4488.1890);
	angles[18] = (0, 180.7952, 0);
	at[18] = 5.8000;
	points[19] = (1590.0669, -8571.8115, 4488.1890);
	angles[19] = (0, 183.9516, 0);
	at[19] = 6;
	points[20] = (1604.0591, -8641.1807, 4488.1890);
	angles[20] = (0, 193.7752, 0);
	at[20] = 6.2000;
	points[21] = (1629.1614, -8707.2051, 4488.1890);
	angles[21] = (0, 201.8633, 0);
	at[21] = 6.4000;
	points[22] = (1659.9567, -8771.3389, 4488.1890);
	angles[22] = (0, 206.2048, 0);
	at[22] = 6.6000;
	points[23] = (1698.6417, -8830.3545, 4488.1890);
	angles[23] = (0, 214.5352, 0);
	at[23] = 6.8000;
	points[24] = (1743.1614, -8885.8662, 4488.1890);
	angles[24] = (0, 219.8116, 0);
	at[24] = 7;
	points[25] = (1769.5433, -8908.5430, 4488.1890);
	angles[25] = (0, 228.6465, 0);
	at[25] = 7.1000;
	points[26] = (1799.4961, -8927.9531, 4488.1890);
	angles[26] = (0, 235.2751, 0);
	at[26] = 7.2000;
	points[27] = (1861.1024, -8963.2285, 4488.1890);
	angles[27] = (0, 240.6928, 0);
	at[27] = 7.4000;
	points[28] = (1958.5906, -9004.8428, 4488.1890);
	angles[28] = (0, 248.3467, 0);
	at[28] = 7.7000;
	points[29] = (2059.6260, -9039.2129, 4488.1890);
	angles[29] = (0, 252.9936, 0);
	at[29] = 8;
	points[30] = (2128.7598, -9051.8506, 4488.1890);
	angles[30] = (0, 260.3169, 0);
	at[30] = 8.2000;
	points[31] = (2234.5396, -9063.1104, 4488.1890);
	angles[31] = (0, 265.0056, 0);
	at[31] = 8.5000;
	points[32] = (2305.3071, -9066.5352, 4488.1890);
	angles[32] = (0, 267.6671, 0);
	at[32] = 8.7000;
	points[33] = (2337.6733, -9067.0078, 4488.1890);
	angles[33] = (0, 268.9777, 0);
	at[33] = 8.8000;
	points[34] = (2447.0867, -9066.7715, 4488.1890);
	angles[34] = (0, 270.2378, 0);
	at[34] = 9.1000;
	points[35] = (2872.4214, -9062.0869, 4488.1890);
	angles[35] = (0, 270.8694, 0);
	at[35] = 10.3000;
	points[36] = (3122.5315, -9056.6924, 4488.1890);
	angles[36] = (0, 271.6909, 0);
	at[36] = 11;
	points[37] = (3158.9409, -9055.3154, 4488.1890);
	angles[37] = (0, 272.1266, 0);
	at[37] = 11.1000;
	points[38] = (3226.4685, -9048.9375, 4488.1890);
	angles[38] = (0, 276.9099, 0);
	at[38] = 11.3000;
	points[39] = (3261.0908, -9041.4570, 4488.1890);
	angles[39] = (0, 281.4802, 0);
	at[39] = 11.4000;
	points[40] = (3327.6299, -9017.5195, 4488.1890);
	angles[40] = (0, 291.4721, 0);
	at[40] = 11.6000;
	points[41] = (3390.0867, -8984.9609, 4488.1890);
	angles[41] = (0, 297.8759, 0);
	at[41] = 11.8000;
	points[42] = (3446.8386, -8942.1260, 4488.1890);
	angles[42] = (0, 308.2091, 0);
	at[42] = 12;
	points[43] = (3499.0513, -8894.6455, 4488.1890);
	angles[43] = (0, 313.0436, 0);
	at[43] = 12.2000;
	points[44] = (3569.9331, -8814.8428, 4488.1890);
	angles[44] = (0, 320.6122, 0);
	at[44] = 12.5000;
	points[45] = (3588.7913, -8785.5117, 4488.1890);
	angles[45] = (0, 326.0734, 0);
	at[45] = 12.6000;
	points[46] = (3640.7480, -8692.1660, 4488.1890);
	angles[46] = (0, 332.2981, 0);
	at[46] = 12.9000;
	points[47] = (3662.8425, -8625.3145, 4488.1890);
	angles[47] = (0, 343.2079, 0);
	at[47] = 13.1000;
	points[48] = (3677.6340, -8555.9453, 4488.1890);
	angles[48] = (0, 348.9890, 0);
	at[48] = 13.3000;
	points[49] = (3680.4685, -8485.3945, 4488.1890);
	angles[49] = (0, 358.6356, 0);
	at[49] = 13.5000;
	points[50] = (3679.5747, -8414.5273, 4488.1890);
	angles[50] = (0, 360.6440, 0);
	at[50] = 13.7000;
	points[51] = (3678.9370, -8345.7090, 4488.1890);
	angles[51] = (0, 360.3983, 0);
	at[51] = 13.9000;
	points[52] = (3675.5354, -7739.0156, 4488.1890);
	angles[52] = (0, 360.3148, 0);
	at[52] = 15.6000;
	points[53] = (3676.2876, -7492.9136, 4488.1890);
	angles[53] = (0, 360.3740, 0);
	at[53] = 16.3000;
	points[54] = (3673.1023, -7458.0708, 4488.1890);
	angles[54] = (0, 365.2271, 0);
	at[54] = 16.4000;
	points[55] = (3665.7283, -7423.3071, 4488.1890);
	angles[55] = (0, 370.6532, 0);
	at[55] = 16.5000;
	points[56] = (3647.2874, -7354.5273, 4488.1890);
	angles[56] = (0, 375.3376, 0);
	at[56] = 16.7000;
	points[57] = (3624.9094, -7287.6382, 4488.1890);
	angles[57] = (0, 379.0511, 0);
	at[57] = 16.9000;
	points[58] = (3597.1890, -7222.1260, 4488.1890);
	angles[58] = (0, 384.9073, 0);
	at[58] = 17.1000;
	points[59] = (3576.6536, -7193.8979, 4488.1890);
	angles[59] = (0, 394.0356, 0);
	at[59] = 17.2000;
	points[60] = (3530.1338, -7140.0791, 4488.1890);
	angles[60] = (0, 401.2405, 0);
	at[60] = 17.4000;
	points[61] = (3505.0947, -7114.6460, 4488.1890);
	angles[61] = (0, 404.3782, 0);
	at[61] = 17.5000;
	points[62] = (3477.2717, -7093.6221, 4488.1890);
	angles[62] = (0, 411.6655, 0);
	at[62] = 17.6000;
	points[63] = (3385.6968, -7038.8584, 4488.1890);
	angles[63] = (0, 420.9448, 0);
	at[63] = 17.9000;
	points[64] = (3321.3191, -7010.5117, 4488.1890);
	angles[64] = (0, 426.5995, 0);
	at[64] = 18.1000;
	points[65] = (3254.0276, -6988.1890, 4488.1890);
	angles[65] = (0, 433.0226, 0);
	at[65] = 18.3000;
	points[66] = (3184.5471, -6975.0396, 4488.1890);
	angles[66] = (0, 440.4771, 0);
	at[66] = 18.5000;
	points[67] = (3152.3191, -6971.8506, 4488.1890);
	angles[67] = (0, 443.7554, 0);
	at[67] = 18.6000;
	points[68] = (3114.4175, -6969.2129, 4488.1890);
	angles[68] = (0, 445.5212, 0);
	at[68] = 18.7000;
	points[69] = (3081.0354, -6967.1655, 4488.1890);
	angles[69] = (0, 446.2636, 0);
	at[69] = 18.8000;
	points[70] = (3043.2244, -6964.9609, 4488.1890);
	angles[70] = (0, 446.6138, 0);
	at[70] = 18.9000;
	points[71] = (2617.8425, -6944.2124, 4488.1890);
	angles[71] = (0, 447.4489, 0);
	at[71] = 20.1000;
	points[72] = (2314.2915, -6932.5986, 4488.1890);
	angles[72] = (0, 448.5201, 0);
	at[72] = 20.9500;
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
	points[0] = (-732.7205, -8498.1494, 4481.7324);
	angles[0] = (0, 137.2742, 0);
	at[0] = 0;
	points[1] = (-759.7322, -8553.6611, 4481.7324);
	angles[1] = (0, 152.2754, 0);
	at[1] = 0.1167;
	points[2] = (-779.7992, -8612.6768, 4481.7324);
	angles[2] = (0, 159.9355, 0);
	at[2] = 0.2333;
	points[3] = (-811, -8732.7959, 4481.7324);
	angles[3] = (0, 166.3423, 0);
	at[3] = 0.4667;
	points[4] = (-821.6654, -8793.3467, 4481.7324);
	angles[4] = (0, 170.3888, 0);
	at[4] = 0.5833;
	points[5] = (-824.2520, -8855.6299, 4481.7324);
	angles[5] = (0, 176.7865, 0);
	at[5] = 0.7000;
	points[6] = (-822.3661, -8979.7246, 4481.7324);
	angles[6] = (0, 181.0736, 0);
	at[6] = 0.9333;
	points[7] = (-819.9803, -9100.7480, 4481.7324);
	angles[7] = (0, 180.7698, 0);
	at[7] = 1.1667;
	points[8] = (-817.7834, -9600.5518, 4481.7324);
	angles[8] = (0, 180.5953, 0);
	at[8] = 2.1000;
	points[9] = (-810.0079, -9850.5908, 4481.7324);
	angles[9] = (0, 183.4449, 0);
	at[9] = 2.5667;
	points[10] = (-799.0433, -9908.5439, 4481.7324);
	angles[10] = (0, 190.7825, 0);
	at[10] = 2.6833;
	points[11] = (-777.1457, -9966.6143, 4481.7324);
	angles[11] = (0, 199.8428, 0);
	at[11] = 2.8000;
	points[12] = (-748.2559, -10021.6143, 4481.7324);
	angles[12] = (0, 206.9380, 0);
	at[12] = 2.9167;
	points[13] = (-714.7402, -10073.8584, 4481.7324);
	angles[13] = (0, 212.0942, 0);
	at[13] = 3.0333;
	points[14] = (-678.6929, -10123.3467, 4481.7324);
	angles[14] = (0, 215.8865, 0);
	at[14] = 3.1500;
	points[15] = (-637.5670, -10170.2764, 4481.7324);
	angles[15] = (0, 220.6426, 0);
	at[15] = 3.2667;
	points[16] = (-549.4055, -10257.7959, 4481.7324);
	angles[16] = (0, 226.3076, 0);
	at[16] = 3.5000;
	points[17] = (-501.2401, -10297.0859, 4481.7324);
	angles[17] = (0, 231.0366, 0);
	at[17] = 3.6167;
	points[18] = (-445.5551, -10322.4414, 4481.7324);
	angles[18] = (0, 244.8094, 0);
	at[18] = 3.7333;
	points[19] = (-385.9126, -10339.5674, 4481.7324);
	angles[19] = (0, 252.5491, 0);
	at[19] = 3.8500;
	points[20] = (-325.3764, -10354.1338, 4481.7324);
	angles[20] = (0, 255.9380, 0);
	at[20] = 3.9667;
	points[21] = (-203.1606, -10377.5586, 4481.7324);
	angles[21] = (0, 260.0719, 0);
	at[21] = 4.2000;
	points[22] = (-142.8665, -10383.3066, 4481.7324);
	angles[22] = (0, 264.3853, 0);
	at[22] = 4.3167;
	points[23] = (44.1091, -10388.4248, 4481.7324);
	angles[23] = (0, 269.1838, 0);
	at[23] = 4.6667;
	points[24] = (168.4244, -10386.8896, 4481.7324);
	angles[24] = (0, 271.4044, 0);
	at[24] = 4.9000;
	points[25] = (229.1413, -10380.5908, 4481.7324);
	angles[25] = (0, 276.0466, 0);
	at[25] = 5.0167;
	points[26] = (290.3803, -10369.0947, 4481.7324);
	angles[26] = (0, 280.0780, 0);
	at[26] = 5.1333;
	points[27] = (411.0473, -10339.1729, 4481.7324);
	angles[27] = (0, 284.9074, 0);
	at[27] = 5.3667;
	points[28] = (469.7677, -10319.0947, 4481.7324);
	angles[28] = (0, 289.1002, 0);
	at[28] = 5.4833;
	points[29] = (521.0905, -10285.5908, 4481.7324);
	angles[29] = (0, 302.7115, 0);
	at[29] = 5.6000;
	points[30] = (566.8543, -10243.5830, 4481.7324);
	angles[30] = (0, 311.0569, 0);
	at[30] = 5.7167;
	points[31] = (652.6024, -10153.2285, 4481.7324);
	angles[31] = (0, 317.3254, 0);
	at[31] = 5.9500;
	points[32] = (691.2402, -10105.7881, 4481.7324);
	angles[32] = (0, 321.2388, 0);
	at[32] = 6.0667;
	points[33] = (722.1654, -10051.9688, 4481.7324);
	angles[33] = (0, 329.1778, 0);
	at[33] = 6.1833;
	points[34] = (749.5197, -9996.1025, 4481.7324);
	angles[34] = (0, 333.2551, 0);
	at[34] = 6.3000;
	points[35] = (798.4016, -9881.5752, 4481.7324);
	angles[35] = (0, 337.9244, 0);
	at[35] = 6.5333;
	points[36] = (835.4370, -9763.8984, 4481.7324);
	angles[36] = (0, 343.2754, 0);
	at[36] = 6.7667;
	points[37] = (862.6890, -9642.7959, 4481.7324);
	angles[37] = (0, 348.7870, 0);
	at[37] = 7;
	points[38] = (869.7086, -9581.0234, 4481.7324);
	angles[38] = (0, 353.4401, 0);
	at[38] = 7.1167;
	points[39] = (868.8583, -9457.4014, 4481.7324);
	angles[39] = (0, 360.8607, 0);
	at[39] = 7.3500;
	points[40] = (859.1260, -9209.6455, 4481.7324);
	angles[40] = (0, 362.5615, 0);
	at[40] = 7.8167;
	points[41] = (842.1299, -8899.4092, 4481.7324);
	angles[41] = (0, 363.6018, 0);
	at[41] = 8.4000;
	points[42] = (831.5000, -8776.4961, 4481.7324);
	angles[42] = (0, 366.0502, 0);
	at[42] = 8.6333;
	points[43] = (820.7756, -8715.2754, 4481.7324);
	angles[43] = (0, 369.7021, 0);
	at[43] = 8.7500;
	points[44] = (788.5236, -8595.4727, 4481.7324);
	angles[44] = (0, 376.5021, 0);
	at[44] = 8.9833;
	points[45] = (766.4685, -8537.5596, 4481.7324);
	angles[45] = (0, 380.7859, 0);
	at[45] = 9.1000;
	points[46] = (736.0552, -8484.8818, 4481.7324);
	angles[46] = (0, 390.8434, 0);
	at[46] = 9.2167;
	points[47] = (692.3622, -8440.3545, 4481.7324);
	angles[47] = (0, 402.5510, 0);
	at[47] = 9.3333;
	points[48] = (645.6811, -8398.8584, 4481.7324);
	angles[48] = (0, 407.4781, 0);
	at[48] = 9.4500;
	points[49] = (499.6693, -8281.9287, 4481.7324);
	angles[49] = (0, 412.5339, 0);
	at[49] = 9.8000;
	points[50] = (447.7638, -8250.3154, 4481.7324);
	angles[50] = (0, 418.8804, 0);
	at[50] = 9.9167;
	points[51] = (334.0713, -8199.9609, 4481.7324);
	angles[51] = (0, 426.3470, 0);
	at[51] = 10.1500;
	points[52] = (-225.8232, -7935.1182, 4481.7324);
	angles[52] = (0, 424.9073, 0);
	at[52] = 11.3167;
	points[53] = (-339.7339, -7884.7637, 4481.7324);
	angles[53] = (0, 425.9551, 0);
	at[53] = 11.5500;
	points[54] = (-450.6654, -7828.7407, 4481.7324);
	angles[54] = (0, 421.0286, 0);
	at[54] = 11.7833;
	points[55] = (-499.9803, -7792.4409, 4481.7324);
	angles[55] = (0, 414.6945, 0);
	at[55] = 11.9000;
	points[56] = (-596.4252, -7713.7007, 4481.7324);
	angles[56] = (0, 410.2508, 0);
	at[56] = 12.1333;
	points[57] = (-686.9095, -7628.9766, 4481.7324);
	angles[57] = (0, 405.1458, 0);
	at[57] = 12.3667;
	points[58] = (-722.5040, -7578.9375, 4481.7324);
	angles[58] = (0, 395.7644, 0);
	at[58] = 12.4833;
	points[59] = (-751.9213, -7524.1343, 4481.7324);
	angles[59] = (0, 389.0776, 0);
	at[59] = 12.6000;
	points[60] = (-776.8937, -7467.4014, 4481.7324);
	angles[60] = (0, 384.2211, 0);
	at[60] = 12.7167;
	points[61] = (-797.5158, -7408.8584, 4481.7324);
	angles[61] = (0, 379.7201, 0);
	at[61] = 12.8333;
	points[62] = (-813.1890, -7348.7402, 4481.7324);
	angles[62] = (0, 374.8960, 0);
	at[62] = 12.9500;
	points[63] = (-822.5552, -7291.4961, 4481.7324);
	angles[63] = (0, 369.6165, 0);
	at[63] = 13.0667;
	points[64] = (-835.1614, -7164.6064, 4481.7324);
	angles[64] = (0, 365.4907, 0);
	at[64] = 13.3000;
	points[65] = (-868.3150, -6730.8662, 4481.7324);
	angles[65] = (0, 363.9470, 0);
	at[65] = 14.1167;
	points[66] = (-886.8228, -6418.6611, 4481.7324);
	angles[66] = (0, 362.8577, 0);
	at[66] = 14.7000;
	points[67] = (-889.1535, -6356.5352, 4481.7324);
	angles[67] = (0, 362.1359, 0);
	at[67] = 14.8167;
	points[68] = (-888.2992, -6297.5986, 4481.7324);
	angles[68] = (0, 358.7031, 0);
	at[68] = 14.9333;
	points[69] = (-877.0709, -6236.7720, 4481.7324);
	angles[69] = (0, 349.8081, 0);
	at[69] = 15.0500;
	points[70] = (-854.9922, -6178.9375, 4481.7324);
	angles[70] = (0, 339.9177, 0);
	at[70] = 15.1667;
	points[71] = (-825.4371, -6124.4492, 4481.7324);
	angles[71] = (0, 332.6228, 0);
	at[71] = 15.2833;
	points[72] = (-797.8622, -6070.0786, 4481.7324);
	angles[72] = (0, 334.8643, 0);
	at[72] = 15.4000;
	points[73] = (-776.2874, -6011.2993, 4481.7324);
	angles[73] = (0, 338.8442, 0);
	at[73] = 15.5167;
	points[74] = (-731.9133, -5895.0391, 4481.7324);
	angles[74] = (0, 338.5109, 0);
	at[74] = 15.7500;
	points[75] = (-706.6417, -5838.4253, 4481.7324);
	angles[75] = (0, 335.7084, 0);
	at[75] = 15.8667;
	points[76] = (-671.9686, -5787.7949, 4481.7324);
	angles[76] = (0, 325.9572, 0);
	at[76] = 15.9833;
	points[77] = (-587.6653, -5696.5747, 4481.7324);
	angles[77] = (0, 315.9207, 0);
	at[77] = 16.2167;
	points[78] = (-540.6772, -5655.8662, 4481.7324);
	angles[78] = (0, 310.8914, 0);
	at[78] = 16.3333;
	points[79] = (-486.2795, -5628.3857, 4481.7324);
	angles[79] = (0, 295.7598, 0);
	at[79] = 16.4500;
	points[80] = (-425.1772, -5618.1890, 4481.7324);
	angles[80] = (0, 282.1040, 0);
	at[80] = 16.5667;
	points[81] = (-363.2768, -5611.6533, 4481.7324);
	angles[81] = (0, 277.0086, 0);
	at[81] = 16.6833;
	points[82] = (-177.3347, -5599.2520, 4481.7324);
	angles[82] = (0, 273.2559, 0);
	at[82] = 17.0333;
	points[83] = (-53.7988, -5595.2363, 4481.7324);
	angles[83] = (0, 271.2818, 0);
	at[83] = 17.2667;
	points[84] = (133.0500, -5597.3228, 4481.7324);
	angles[84] = (0, 268.1895, 0);
	at[84] = 17.6167;
	points[85] = (317.7154, -5612.1260, 4481.7324);
	angles[85] = (0, 264.8787, 0);
	at[85] = 17.9667;
	points[86] = (441.2795, -5626.3384, 4481.7324);
	angles[86] = (0, 262.8359, 0);
	at[86] = 18.2000;
	points[87] = (502.9291, -5636.9292, 4481.7324);
	angles[87] = (0, 260.0820, 0);
	at[87] = 18.3167;
	points[88] = (558.5275, -5660.1968, 4481.7324);
	angles[88] = (0, 246.0638, 0);
	at[88] = 18.4333;
	points[89] = (605.6575, -5700.7876, 4481.7324);
	angles[89] = (0, 231.5248, 0);
	at[89] = 18.5500;
	points[90] = (648.3386, -5746.1416, 4481.7324);
	angles[90] = (0, 224.3775, 0);
	at[90] = 18.6667;
	points[91] = (688.1654, -5794.0156, 4481.7324);
	angles[91] = (0, 220.2487, 0);
	at[91] = 18.7833;
	points[92] = (723.6890, -5843.3857, 4481.7324);
	angles[92] = (0, 215.4172, 0);
	at[92] = 18.9000;
	points[93] = (777.4567, -5955.9058, 4481.7324);
	angles[93] = (0, 204.5897, 0);
	at[93] = 19.1333;
	points[94] = (822.9645, -6071.4175, 4481.7324);
	angles[94] = (0, 200.5842, 0);
	at[94] = 19.3667;
	points[95] = (840.5040, -6130.5513, 4481.7324);
	angles[95] = (0, 196.8203, 0);
	at[95] = 19.4833;
	points[96] = (853.9016, -6191.0234, 4481.7324);
	angles[96] = (0, 192.6381, 0);
	at[96] = 19.6000;
	points[97] = (862.0866, -6252.4019, 4481.7324);
	angles[97] = (0, 187.9331, 0);
	at[97] = 19.7167;
	points[98] = (865.5709, -6314.2520, 4481.7324);
	angles[98] = (0, 183.6017, 0);
	at[98] = 19.8333;
	points[99] = (864.6890, -6435.6694, 4481.7324);
	angles[99] = (0, 179.4046, 0);
	at[99] = 20.0667;
	points[100] = (853.9055, -6872.9526, 4481.7324);
	angles[100] = (0, 178.2938, 0);
	at[100] = 20.8833;
	points[101] = (838.8189, -7246.1421, 4481.7324);
	angles[101] = (0, 176.8879, 0);
	at[101] = 21.5833;
	points[102] = (834.0945, -7308.1494, 4481.7324);
	angles[102] = (0, 175.4623, 0);
	at[102] = 21.7000;
	points[103] = (824.1457, -7367.3232, 4481.7324);
	angles[103] = (0, 170.5165, 0);
	at[103] = 21.8167;
	points[104] = (807.1575, -7426.9292, 4481.7324);
	angles[104] = (0, 164.5515, 0);
	at[104] = 21.9333;
	points[105] = (784.6260, -7484.8032, 4481.7324);
	angles[105] = (0, 159.1992, 0);
	at[105] = 22.0500;
	points[106] = (757.4803, -7540.6694, 4481.7324);
	angles[106] = (0, 154.4966, 0);
	at[106] = 22.1667;
	points[107] = (726.3543, -7594.0156, 4481.7324);
	angles[107] = (0, 150.0382, 0);
	at[107] = 22.2833;
	points[108] = (688.7441, -7642.4805, 4481.7324);
	angles[108] = (0, 142.0878, 0);
	at[108] = 22.4000;
	points[109] = (598.4961, -7728.3467, 4481.7324);
	angles[109] = (0, 132.7714, 0);
	at[109] = 22.6333;
	points[110] = (502.5827, -7807.5986, 4481.7324);
	angles[110] = (0, 128.5290, 0);
	at[110] = 22.8667;
	points[111] = (450.3149, -7839.6064, 4481.7324);
	angles[111] = (0, 121.5532, 0);
	at[111] = 22.9833;
	points[112] = (337.9547, -7892.5591, 4481.7324);
	angles[112] = (0, 114.8525, 0);
	at[112] = 23.2167;
	points[113] = (225.3799, -7943.3071, 4481.7324);
	angles[113] = (0, 114.7878, 0);
	at[113] = 23.4500;
	points[114] = (-223.3445, -8157.5986, 4481.7324);
	angles[114] = (0, 115.5282, 0);
	at[114] = 24.3833;
	points[115] = (-392.2725, -8234.1338, 4481.7324);
	angles[115] = (0, 115.2563, 0);
	at[115] = 24.7333;
	points[116] = (-445.5394, -8264.1338, 4481.7324);
	angles[116] = (0, 119.8166, 0);
	at[116] = 24.8500;
	points[117] = (-496.1496, -8300.1182, 4481.7324);
	angles[117] = (0, 124.5077, 0);
	at[117] = 24.9667;
	points[118] = (-595.4606, -8375.3154, 4481.7324);
	angles[118] = (0, 127.4977, 0);
	at[118] = 25.2000;
	points[119] = (-690.9173, -8454.5674, 4481.7324);
	angles[119] = (0, 130.6793, 0);
	at[119] = 25.4333;
	points[120] = (-732.7205, -8498.1494, 4481.7324);
	angles[120] = (0, 137.2742, 0);
	at[120] = 25.5500;
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
	points[0] = (-3463.0747, -8578.3857, 4481.7324);
	angles[0] = (0, 17.4508, 0);
	at[0] = 0;
	points[1] = (-3517.2285, -8378.5439, 4481.7324);
	angles[1] = (0, 13.5736, 0);
	at[1] = 0.5833;
	points[2] = (-3534.0474, -8291.2988, 4481.7324);
	angles[2] = (0, 9.6227, 0);
	at[2] = 0.8333;
	points[3] = (-3537.0039, -8263.8584, 4481.7324);
	angles[3] = (0, 6.7650, 0);
	at[3] = 0.9167;
	points[4] = (-3540.8779, -8174.6851, 4481.7324);
	angles[4] = (0, 2.1123, 0);
	at[4] = 1.1667;
	points[5] = (-3544.0471, -7967.0078, 4481.7324);
	angles[5] = (0, 0.4198, 0);
	at[5] = 1.7500;
	points[6] = (-3541.3701, -7729.0161, 4481.7324);
	angles[6] = (0, -2.0219, 0);
	at[6] = 2.4167;
	points[7] = (-3539.3071, -7702.0078, 4481.7324);
	angles[7] = (0, -4.0820, 0);
	at[7] = 2.5000;
	points[8] = (-3522.6182, -7614.6851, 4481.7324);
	angles[8] = (0, -12.2325, 0);
	at[8] = 2.7500;
	points[9] = (-3481.9172, -7472.4014, 4481.7324);
	angles[9] = (0, -17.1410, 0);
	at[9] = 3.1667;
	points[10] = (-3434.4451, -7332.9922, 4481.7324);
	angles[10] = (0, -19.8449, 0);
	at[10] = 3.5833;
	points[11] = (-3389.8308, -7223.5435, 4481.7324);
	angles[11] = (0, -23.7236, 0);
	at[11] = 3.9167;
	points[12] = (-3376.2600, -7196.8110, 4481.7324);
	angles[12] = (0, -26.4298, 0);
	at[12] = 4;
	points[13] = (-3341.8701, -7149.6064, 4481.7324);
	angles[13] = (0, -36.6324, 0);
	at[13] = 4.1667;
	points[14] = (-3241.9253, -7040.5513, 4481.7324);
	angles[14] = (0, -44.4909, 0);
	at[14] = 4.5833;
	points[15] = (-3197.9963, -7000.5908, 4481.7324);
	angles[15] = (0, -48.4043, 0);
	at[15] = 4.7500;
	points[16] = (-3174.2283, -6983.2676, 4481.7324);
	angles[16] = (0, -53.2282, 0);
	at[16] = 4.8333;
	points[17] = (-3148.3467, -6971.1421, 4481.7324);
	angles[17] = (0, -62.0567, 0);
	at[17] = 4.9167;
	points[18] = (-3092.0708, -6952.7168, 4481.7324);
	angles[18] = (0, -71.7676, 0);
	at[18] = 5.0833;
	points[19] = (-3005.9175, -6931.1416, 4481.7324);
	angles[19] = (0, -76.6704, 0);
	at[19] = 5.3333;
	points[20] = (-2918.6101, -6914.2915, 4481.7324);
	angles[20] = (0, -79.8497, 0);
	at[20] = 5.5833;
	points[21] = (-2861.8267, -6907.0474, 4481.7324);
	angles[21] = (0, -83.4746, 0);
	at[21] = 5.7500;
	points[22] = (-2772.8386, -6903.0708, 4481.7324);
	angles[22] = (0, -87.8688, 0);
	at[22] = 6;
	points[23] = (-2594.5786, -6900.3545, 4481.7324);
	angles[23] = (0, -89.5712, 0);
	at[23] = 6.5000;
	points[24] = (-2416.2007, -6901.7324, 4481.7324);
	angles[24] = (0, -91.1807, 0);
	at[24] = 7;
	points[25] = (-2358.8896, -6904.6460, 4481.7324);
	angles[25] = (0, -93.6048, 0);
	at[25] = 7.1667;
	points[26] = (-2242.2876, -6924.6851, 4481.7324);
	angles[26] = (0, -101.5334, 0);
	at[26] = 7.5000;
	points[27] = (-2156.1890, -6946.7715, 4481.7324);
	angles[27] = (0, -105.3026, 0);
	at[27] = 7.7500;
	points[28] = (-2100.0120, -6965.7480, 4481.7324);
	angles[28] = (0, -109.3712, 0);
	at[28] = 7.9167;
	points[29] = (-2073.6929, -6977.9531, 4481.7324);
	angles[29] = (0, -114.2347, 0);
	at[29] = 8;
	points[30] = (-2050.1221, -6994.6460, 4481.7324);
	angles[30] = (0, -122.5690, 0);
	at[30] = 8.0833;
	points[31] = (-2005.6458, -7034.0161, 4481.7324);
	angles[31] = (0, -131.4464, 0);
	at[31] = 8.2500;
	points[32] = (-1903.1023, -7141.1416, 4481.7324);
	angles[32] = (0, -137.9366, 0);
	at[32] = 8.6667;
	points[33] = (-1865.4607, -7187.2046, 4481.7324);
	angles[33] = (0, -141.5142, 0);
	at[33] = 8.8333;
	points[34] = (-1850.9371, -7211.5356, 4481.7324);
	angles[34] = (0, -147.7600, 0);
	at[34] = 8.9167;
	points[35] = (-1828.0669, -7266.0239, 4481.7324);
	angles[35] = (0, -157.2755, 0);
	at[35] = 9.0833;
	points[36] = (-1808.6771, -7322.0474, 4481.7324);
	angles[36] = (0, -160.9440, 0);
	at[36] = 9.2500;
	points[37] = (-1731.9922, -7576.4170, 4481.7324);
	angles[37] = (0, -164.4291, 0);
	at[37] = 10;
	points[38] = (-1711.5906, -7662.9136, 4481.7324);
	angles[38] = (0, -167.7674, 0);
	at[38] = 10.2500;
	points[39] = (-1703.6810, -7719.4492, 4481.7324);
	angles[39] = (0, -173.0895, 0);
	at[39] = 10.4167;
	points[40] = (-1700.7992, -7778.7007, 4481.7324);
	angles[40] = (0, -177.1365, 0);
	at[40] = 10.5833;
	points[41] = (-1697.5355, -7927.6377, 4481.7324);
	angles[41] = (0, -179.1075, 0);
	at[41] = 11;
	points[42] = (-1697.3818, -8193.7012, 4481.7324);
	angles[42] = (0, -180.7050, 0);
	at[42] = 11.7500;
	points[43] = (-1700.5354, -8281.8896, 4481.7324);
	angles[43] = (0, -183.1117, 0);
	at[43] = 12;
	points[44] = (-1709.2795, -8340.3145, 4481.7324);
	angles[44] = (0, -189.0522, 0);
	at[44] = 12.1667;
	points[45] = (-1722.2283, -8397.8740, 4481.7324);
	angles[45] = (0, -192.8156, 0);
	at[45] = 12.3333;
	points[46] = (-1771.8112, -8568.7793, 4481.7324);
	angles[46] = (0, -197.4553, 0);
	at[46] = 12.8333;
	points[47] = (-1823.0197, -8706.4961, 4481.7324);
	angles[47] = (0, -201.9364, 0);
	at[47] = 13.2500;
	points[48] = (-1847.1537, -8760.3945, 4481.7324);
	angles[48] = (0, -204.5563, 0);
	at[48] = 13.4167;
	points[49] = (-1876.9172, -8810.6299, 4481.7324);
	angles[49] = (0, -212.2945, 0);
	at[49] = 13.5833;
	points[50] = (-1951.4094, -8902.7559, 4481.7324);
	angles[50] = (0, -220.0926, 0);
	at[50] = 13.9167;
	points[51] = (-2032.2167, -8989.0156, 4481.7324);
	angles[51] = (0, -224.9933, 0);
	at[51] = 14.2500;
	points[52] = (-2054.5669, -9008.7012, 4481.7324);
	angles[52] = (0, -228.0835, 0);
	at[52] = 14.3333;
	points[53] = (-2078.5276, -9024.1338, 4481.7324);
	angles[53] = (0, -236.0041, 0);
	at[53] = 14.4167;
	points[54] = (-2134.4133, -9044.5273, 4481.7324);
	angles[54] = (0, -250.0370, 0);
	at[54] = 14.5833;
	points[55] = (-2191.5906, -9059.5273, 4481.7324);
	angles[55] = (0, -255.3543, 0);
	at[55] = 14.7500;
	points[56] = (-2278.7244, -9077.2441, 4481.7324);
	angles[56] = (0, -259.2840, 0);
	at[56] = 15;
	points[57] = (-2337.2834, -9085.9453, 4481.7324);
	angles[57] = (0, -261.8573, 0);
	at[57] = 15.1667;
	points[58] = (-2395.0120, -9090.4336, 4481.7324);
	angles[58] = (0, -265.9952, 0);
	at[58] = 15.3333;
	points[59] = (-2691.4646, -9095.1973, 4481.7324);
	angles[59] = (0, -269.9374, 0);
	at[59] = 16.1667;
	points[60] = (-2867.8228, -9091.2207, 4481.7324);
	angles[60] = (0, -273.2562, 0);
	at[60] = 16.6667;
	points[61] = (-2926.5432, -9083.8193, 4481.7324);
	angles[61] = (0, -277.4448, 0);
	at[61] = 16.8333;
	points[62] = (-3013.8230, -9067.8350, 4481.7324);
	angles[62] = (0, -281.0625, 0);
	at[62] = 17.0833;
	points[63] = (-3128.4727, -9038.3857, 4481.7324);
	angles[63] = (0, -286.4192, 0);
	at[63] = 17.4167;
	points[64] = (-3156.5081, -9027.9531, 4481.7324);
	angles[64] = (0, -289.7779, 0);
	at[64] = 17.5000;
	points[65] = (-3181.1614, -9014.0156, 4481.7324);
	angles[65] = (0, -297.7157, 0);
	at[65] = 17.5833;
	points[66] = (-3226.8386, -8976.0234, 4481.7324);
	angles[66] = (0, -309.7117, 0);
	at[66] = 17.7500;
	points[67] = (-3310.0276, -8891.7324, 4481.7324);
	angles[67] = (0, -316.7583, 0);
	at[67] = 18.0833;
	points[68] = (-3367.1892, -8823.4648, 4481.7324);
	angles[68] = (0, -321.7793, 0);
	at[68] = 18.3333;
	points[69] = (-3381.7126, -8799.0557, 4481.7324);
	angles[69] = (0, -327.7822, 0);
	at[69] = 18.4167;
	points[70] = (-3405.5630, -8744.9219, 4481.7324);
	angles[70] = (0, -336.2197, 0);
	at[70] = 18.5833;
	points[71] = (-3463.0747, -8578.3857, 4481.7324);
	angles[71] = (0, -342.5492, 0);
	at[71] = 19.0833;
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
