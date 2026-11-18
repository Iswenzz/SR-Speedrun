main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_wii_coconut_mall", 0);

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
	ambientPlay("iz_0_n_shopping32", 2);
	level thread iz_music("iz_9_se_cn_shp_gaya");
	iz_emitter("iz_1_se_cc_env_fountain", (-1331.3607, -13350.9062, 510.8568), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_fountain", (-1390.6864, -9916.5361, 393.4744), 0, 12.0104);
	iz_emitter("iz_2_se_cc_env_sea", (6016.6748, 6732.2837, 298.1693), 0, 12.0104);
	iz_emitter("iz_2_se_cc_env_sea", (3874.7959, 6732.2837, 302.6083), 0, 12.0104);
	iz_emitter("iz_2_se_cc_env_sea", (1732.9172, 6732.2837, 307.0473), 0, 12.0104);
	iz_emitter("iz_2_se_cc_env_sea", (-408.9608, 6732.2837, 311.4863), 0, 12.0104);
	iz_emitter("iz_2_se_cc_env_sea", (-2550.8394, 6732.2837, 315.9252), 0, 12.0104);
	iz_emitter("iz_2_se_cc_env_sea", (-4692.7173, 6732.2837, 320.3642), 0, 12.0104);
	iz_emitter("iz_2_se_cc_env_sea", (-6834.5962, 6732.2837, 324.8032), 0, 12.0104);
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
	level.iz_route[level.iz_route.size] = (4193, -3219, 399);
	level.iz_route[level.iz_route.size] = (4193, -3883, 472);
	level.iz_route[level.iz_route.size] = (4193, -4488, 620);
	level.iz_route[level.iz_route.size] = (4178, -5404, 901);
	level.iz_route[level.iz_route.size] = (4592, -6511, 901);
	level.iz_route[level.iz_route.size] = (4608, -7228, 901);
	level.iz_route[level.iz_route.size] = (3912, -8268, 901);
	level.iz_route[level.iz_route.size] = (3647, -10290, 901);
	level.iz_route[level.iz_route.size] = (3647, -10843, 901);
	level.iz_route[level.iz_route.size] = (3641, -11986, 895);
	level.iz_route[level.iz_route.size] = (3402, -12647, 895);
	level.iz_route[level.iz_route.size] = (2878, -13355, 895);
	level.iz_route[level.iz_route.size] = (2137, -13355, 895);
	level.iz_route[level.iz_route.size] = (1204, -13353, 652);
	level.iz_route[level.iz_route.size] = (305, -13349, 393);
	level.iz_route[level.iz_route.size] = (-761, -13984, 393);
	level.iz_route[level.iz_route.size] = (-1518, -13989, 393);
	level.iz_route[level.iz_route.size] = (-2286, -13988, 393);
	level.iz_route[level.iz_route.size] = (-3543, -13716, 393);
	level.iz_route[level.iz_route.size] = (-4336, -13723, 630);
	level.iz_route[level.iz_route.size] = (-5202, -13720, 895);
	level.iz_route[level.iz_route.size] = (-6487, -13352, 895);
	level.iz_route[level.iz_route.size] = (-7574, -13277, 863);
	level.iz_route[level.iz_route.size] = (-8471, -12673, 744);
	level.iz_route[level.iz_route.size] = (-8757, -11659, 634);
	level.iz_route[level.iz_route.size] = (-8265, -10654, 517);
	level.iz_route[level.iz_route.size] = (-7099, -10194, 388);
	level.iz_route[level.iz_route.size] = (-5674, -10088, 298);
	level.iz_route[level.iz_route.size] = (-4641, -10014, 298);
	level.iz_route[level.iz_route.size] = (-3413, -9911, 298);
	level.iz_route[level.iz_route.size] = (-2376, -9736, 298);
	level.iz_route[level.iz_route.size] = (-428, -9746, 298);
	level.iz_route[level.iz_route.size] = (610, -9868, 298);
	level.iz_route[level.iz_route.size] = (1074, -9881, 310);
	level.iz_route[level.iz_route.size] = (1772, -9647, 419);
	level.iz_route[level.iz_route.size] = (2195, -9152, 513);
	level.iz_route[level.iz_route.size] = (2379, -8505, 608);
	level.iz_route[level.iz_route.size] = (2123, -7729, 724);
	level.iz_route[level.iz_route.size] = (1420, -7275, 845);
	level.iz_route[level.iz_route.size] = (634, -7202, 895);
	level.iz_route[level.iz_route.size] = (-30, -7234, 895);
	level.iz_route[level.iz_route.size] = (-1358, -7205, 886);
	level.iz_route[level.iz_route.size] = (-2539, -7175, 886);
	level.iz_route[level.iz_route.size] = (-3280, -7264, 1001);
	level.iz_route[level.iz_route.size] = (-3993, -7221, 1075);
	level.iz_route[level.iz_route.size] = (-4665, -6821, 1190);
	level.iz_route[level.iz_route.size] = (-4813, -6171, 1290);
	level.iz_route[level.iz_route.size] = (-4902, -5344, 1393);
	level.iz_route[level.iz_route.size] = (-4927, -4415, 1571);
	level.iz_route[level.iz_route.size] = (-4949, -1760, 2188);
	level.iz_route[level.iz_route.size] = (-4969, 1318, 298);
	level.iz_route[level.iz_route.size] = (-4974, 2123, 298);
	level.iz_route[level.iz_route.size] = (-4974, 3416, 298);
	level.iz_route[level.iz_route.size] = (-4973, 4421, 298);
	level.iz_route[level.iz_route.size] = (-4887, 5582, 298);
	level.iz_route[level.iz_route.size] = (-4165, 6221, 298);
	level.iz_route[level.iz_route.size] = (-209, 6235, 298);
	level.iz_route[level.iz_route.size] = (1460, 6265, 298);
	level.iz_route[level.iz_route.size] = (3117, 6260, 298);
	level.iz_route[level.iz_route.size] = (4575, 5917, 298);
	level.iz_route[level.iz_route.size] = (4636, 4488, 295);
	level.iz_route[level.iz_route.size] = (4630, 2987, 298);
	level.iz_route[level.iz_route.size] = (4636, 1491, 295);
	level.iz_route[level.iz_route.size] = (4636, 443, 295);
	level.iz_route[level.iz_route.size] = (4222, -89, 295);
	level.iz_route[level.iz_route.size] = (4219, -564, 295);
	level.iz_route[level.iz_route.size] = (4267, -901, 295);
	level.iz_route[level.iz_route.size] = (4296, -2377, 399);
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
	points[0] = (2700.3662, 6529.8032, 298.1693);
	angles[0] = (0, 180, 0);
	at[0] = 0;
	points[1] = (2700.3662, 6529.0947, 298.1693);
	angles[1] = (0, 180, 0);
	at[1] = 0.5500;
	points[2] = (2700.3662, 6520.5908, 298.1693);
	angles[2] = (0, 180, 0);
	at[2] = 0.7000;
	points[3] = (2700.3662, 6502.5200, 298.1693);
	angles[3] = (0, 180, 0);
	at[3] = 0.8500;
	points[4] = (2700.3662, 6474.8823, 298.1693);
	angles[4] = (0, 180, 0);
	at[4] = 1;
	points[5] = (2700.3662, 6437.6772, 298.1693);
	angles[5] = (0, 180, 0);
	at[5] = 1.1500;
	points[6] = (2700.3662, 6390.9053, 298.1693);
	angles[6] = (0, 180, 0);
	at[6] = 1.3000;
	points[7] = (2700.3662, 6251.7715, 298.1693);
	angles[7] = (0, 180, 0);
	at[7] = 1.7000;
	points[8] = (2700.3662, 6223.0708, 298.1693);
	angles[8] = (0, 180, 0);
	at[8] = 1.8000;
	points[9] = (2700.3662, 6198.6226, 298.1693);
	angles[9] = (0, 180, 0);
	at[9] = 1.9000;
	points[10] = (2700.3662, 6178.4258, 298.1693);
	angles[10] = (0, 180, 0);
	at[10] = 2;
	points[11] = (2700.3701, 6156.1025, 298.1693);
	angles[11] = (0, 180, 0);
	at[11] = 2.1500;
	points[12] = (2700.3662, 6143.3467, 298.1693);
	angles[12] = (0, 180, 0);
	at[12] = 2.3000;
	points[13] = (2700.3662, 6140.9058, 298.1693);
	angles[13] = (0, 180, 0);
	at[13] = 2.4000;
	points[14] = (2700.3662, 6141.6138, 298.1693);
	angles[14] = (0, 180, 0);
	at[14] = 2.9500;
	points[15] = (2700.3662, 6150.1182, 298.1693);
	angles[15] = (0, 180, 0);
	at[15] = 3.1000;
	points[16] = (2700.3662, 6168.1890, 298.1693);
	angles[16] = (0, 180, 0);
	at[16] = 3.2500;
	points[17] = (2700.3662, 6195.8267, 298.1693);
	angles[17] = (0, 180, 0);
	at[17] = 3.4000;
	points[18] = (2700.3662, 6233.0317, 298.1693);
	angles[18] = (0, 180, 0);
	at[18] = 3.5500;
	points[19] = (2700.3662, 6279.8032, 298.1693);
	angles[19] = (0, 180, 0);
	at[19] = 3.7000;
	points[20] = (2700.3662, 6418.9370, 298.1693);
	angles[20] = (0, 180, 0);
	at[20] = 4.1000;
	points[21] = (2700.3662, 6447.6382, 298.1693);
	angles[21] = (0, 180, 0);
	at[21] = 4.2000;
	points[22] = (2700.3662, 6472.0869, 298.1693);
	angles[22] = (0, 180, 0);
	at[22] = 4.3000;
	points[23] = (2700.3662, 6500.7871, 298.1693);
	angles[23] = (0, 180, 0);
	at[23] = 4.4500;
	points[24] = (2700.3701, 6514.6060, 298.1693);
	angles[24] = (0, 180, 0);
	at[24] = 4.5500;
	points[25] = (2700.3662, 6527.3623, 298.1693);
	angles[25] = (0, 180, 0);
	at[25] = 4.7000;
	points[26] = (2700.3662, 6529.8032, 298.1693);
	angles[26] = (0, 180, 0);
	at[26] = 4.8000;
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
	points[0] = (347.8347, 5813.6616, 298.1693);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (347.8347, 5813.6616, 298.1693);
	angles[1] = (0, 0, 0);
	at[1] = 0.5000;
	points[2] = (347.8347, 5816.1416, 298.1693);
	angles[2] = (0, 0, 0);
	at[2] = 0.6000;
	points[3] = (347.8347, 5822.8740, 298.1693);
	angles[3] = (0, 0, 0);
	at[3] = 0.7000;
	points[4] = (347.8347, 5833.8579, 298.1693);
	angles[4] = (0, 0, 0);
	at[4] = 0.8000;
	points[5] = (347.8347, 5858.3071, 298.1693);
	angles[5] = (0, 0, 0);
	at[5] = 0.9500;
	points[6] = (347.8347, 5892.3228, 298.1693);
	angles[6] = (0, 0, 0);
	at[6] = 1.1000;
	points[7] = (347.8347, 5935.9058, 298.1693);
	angles[7] = (0, 0, 0);
	at[7] = 1.2500;
	points[8] = (347.8347, 6182.6377, 298.1693);
	angles[8] = (0, 0, 0);
	at[8] = 1.9500;
	points[9] = (347.8347, 6229.4097, 298.1693);
	angles[9] = (0, 0, 0);
	at[9] = 2.1000;
	points[10] = (347.8347, 6266.6143, 298.1693);
	angles[10] = (0, 0, 0);
	at[10] = 2.2500;
	points[11] = (347.8347, 6286.1025, 298.1693);
	angles[11] = (0, 0, 0);
	at[11] = 2.3500;
	points[12] = (347.8347, 6301.3389, 298.1693);
	angles[12] = (0, 0, 0);
	at[12] = 2.4500;
	points[13] = (347.8347, 6316.2207, 298.1693);
	angles[13] = (0, 0, 0);
	at[13] = 2.6000;
	points[14] = (347.8347, 6314.8428, 298.1693);
	angles[14] = (0, 0, 0);
	at[14] = 3.2000;
	points[15] = (347.8347, 6309.5273, 298.1693);
	angles[15] = (0, 0, 0);
	at[15] = 3.3000;
	points[16] = (347.8347, 6299.9604, 298.1693);
	angles[16] = (0, 0, 0);
	at[16] = 3.4000;
	points[17] = (347.8347, 6277.6377, 298.1693);
	angles[17] = (0, 0, 0);
	at[17] = 3.5500;
	points[18] = (347.8347, 6245.7480, 298.1693);
	angles[18] = (0, 0, 0);
	at[18] = 3.7000;
	points[19] = (347.8347, 6204.2915, 298.1693);
	angles[19] = (0, 0, 0);
	at[19] = 3.8500;
	points[20] = (347.8347, 6171.3384, 298.1693);
	angles[20] = (0, 0, 0);
	at[20] = 3.9500;
	points[21] = (347.8347, 5941.3779, 298.1693);
	angles[21] = (0, 0, 0);
	at[21] = 4.6000;
	points[22] = (347.8347, 5895.6694, 298.1693);
	angles[22] = (0, 0, 0);
	at[22] = 4.7500;
	points[23] = (347.8347, 5859.5278, 298.1693);
	angles[23] = (0, 0, 0);
	at[23] = 4.9000;
	points[24] = (347.8347, 5840.7480, 298.1693);
	angles[24] = (0, 0, 0);
	at[24] = 5;
	points[25] = (347.8347, 5820.5513, 298.1693);
	angles[25] = (0, 0, 0);
	at[25] = 5.1500;
	points[26] = (347.8347, 5813.6616, 298.1693);
	angles[26] = (0, 0, 0);
	at[26] = 5.2667;
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
	points[0] = (-1979.5276, 6513.5435, 298.1693);
	angles[0] = (0, 180, 0);
	at[0] = 0;
	points[1] = (-1979.5276, 6513.4253, 298.1693);
	angles[1] = (0, 180, 0);
	at[1] = 0.3500;
	points[2] = (-1979.5276, 6507.0474, 298.1693);
	angles[2] = (0, 180, 0);
	at[2] = 0.5000;
	points[3] = (-1979.5276, 6491.1021, 298.1693);
	angles[3] = (0, 180, 0);
	at[3] = 0.6500;
	points[4] = (-1979.5276, 6475.1572, 298.1693);
	angles[4] = (0, 180, 0);
	at[4] = 0.7500;
	points[5] = (-1979.5276, 6454.9604, 298.1693);
	angles[5] = (0, 180, 0);
	at[5] = 0.8500;
	points[6] = (-1979.5276, 6416.6929, 298.1693);
	angles[6] = (0, 180, 0);
	at[6] = 1;
	points[7] = (-1979.5276, 6385.8662, 298.1693);
	angles[7] = (0, 180, 0);
	at[7] = 1.1000;
	points[8] = (-1979.5276, 6085.3936, 298.1693);
	angles[8] = (0, 180, 0);
	at[8] = 1.9500;
	points[9] = (-1979.5276, 6037.5591, 298.1693);
	angles[9] = (0, 180, 0);
	at[9] = 2.1000;
	points[10] = (-1979.5276, 6010.9844, 298.1693);
	angles[10] = (0, 180, 0);
	at[10] = 2.2000;
	points[11] = (-1979.5276, 5979.0947, 298.1693);
	angles[11] = (0, 180, 0);
	at[11] = 2.3500;
	points[12] = (-1979.5276, 5956.7720, 298.1693);
	angles[12] = (0, 180, 0);
	at[12] = 2.5000;
	points[13] = (-1979.5276, 5944.0156, 298.1693);
	angles[13] = (0, 180, 0);
	at[13] = 2.6500;
	points[14] = (-1979.5276, 5944.4883, 298.1693);
	angles[14] = (0, 180, 0);
	at[14] = 3.0500;
	points[15] = (-1979.5276, 5948.3862, 298.1693);
	angles[15] = (0, 180, 0);
	at[15] = 3.1500;
	points[16] = (-1979.5276, 5956.5356, 298.1693);
	angles[16] = (0, 180, 0);
	at[16] = 3.2500;
	points[17] = (-1979.5276, 5968.9370, 298.1693);
	angles[17] = (0, 180, 0);
	at[17] = 3.3500;
	points[18] = (-1979.5276, 5995.5117, 298.1693);
	angles[18] = (0, 180, 0);
	at[18] = 3.5000;
	points[19] = (-1979.5276, 6031.6533, 298.1693);
	angles[19] = (0, 180, 0);
	at[19] = 3.6500;
	points[20] = (-1979.5276, 6077.3623, 298.1693);
	angles[20] = (0, 180, 0);
	at[20] = 3.8000;
	points[21] = (-1979.5276, 6378.0713, 298.1693);
	angles[21] = (0, 180, 0);
	at[21] = 4.6500;
	points[22] = (-1979.5276, 6424.8423, 298.1693);
	angles[22] = (0, 180, 0);
	at[22] = 4.8000;
	points[23] = (-1979.5276, 6462.0474, 298.1693);
	angles[23] = (0, 180, 0);
	at[23] = 4.9500;
	points[24] = (-1979.5276, 6489.6851, 298.1693);
	angles[24] = (0, 180, 0);
	at[24] = 5.1000;
	points[25] = (-1979.5276, 6507.7559, 298.1693);
	angles[25] = (0, 180, 0);
	at[25] = 5.2500;
	points[26] = (-1979.5276, 6513.5435, 298.1693);
	angles[26] = (0, 180, 0);
	at[26] = 5.3667;
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
