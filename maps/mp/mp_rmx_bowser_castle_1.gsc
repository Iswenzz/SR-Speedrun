main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_rmx_bowser_castle_1", 0);

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
	ambientPlay("iz_0_rbc1", 2);
	level thread iz_music("iz_7_se_cr_gbk_env");
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
	level.iz_route[level.iz_route.size] = (-1272, -922, 306);
	level.iz_route[level.iz_route.size] = (-1286, -2234, 306);
	level.iz_route[level.iz_route.size] = (-1300, -3667, 306);
	level.iz_route[level.iz_route.size] = (-1318, -5060, 306);
	level.iz_route[level.iz_route.size] = (-1225, -5340, 306);
	level.iz_route[level.iz_route.size] = (-598, -5531, 306);
	level.iz_route[level.iz_route.size] = (175, -5567, 306);
	level.iz_route[level.iz_route.size] = (1948, -5565, 306);
	level.iz_route[level.iz_route.size] = (2425, -5500, 306);
	level.iz_route[level.iz_route.size] = (2671, -5375, 306);
	level.iz_route[level.iz_route.size] = (2838, -4976, 306);
	level.iz_route[level.iz_route.size] = (2883, -4539, 306);
	level.iz_route[level.iz_route.size] = (2869, -3637, 306);
	level.iz_route[level.iz_route.size] = (2876, -2557, 306);
	level.iz_route[level.iz_route.size] = (2856, -1882, 306);
	level.iz_route[level.iz_route.size] = (2818, -399, 306);
	level.iz_route[level.iz_route.size] = (2785, 971, 306);
	level.iz_route[level.iz_route.size] = (2916, 1160, 306);
	level.iz_route[level.iz_route.size] = (3300, 1256, 306);
	level.iz_route[level.iz_route.size] = (4171, 1253, 306);
	level.iz_route[level.iz_route.size] = (5958, 1314, 306);
	level.iz_route[level.iz_route.size] = (6152, 1628, 306);
	level.iz_route[level.iz_route.size] = (6194, 2031, 306);
	level.iz_route[level.iz_route.size] = (6183, 3132, 306);
	level.iz_route[level.iz_route.size] = (6108, 4100, 306);
	level.iz_route[level.iz_route.size] = (6214, 4409, 306);
	level.iz_route[level.iz_route.size] = (6599, 4630, 306);
	level.iz_route[level.iz_route.size] = (6971, 4774, 306);
	level.iz_route[level.iz_route.size] = (7203, 5122, 306);
	level.iz_route[level.iz_route.size] = (7289, 5670, 306);
	level.iz_route[level.iz_route.size] = (7307, 6493, 306);
	level.iz_route[level.iz_route.size] = (7198, 6910, 306);
	level.iz_route[level.iz_route.size] = (6782, 7132, 306);
	level.iz_route[level.iz_route.size] = (6156, 7176, 306);
	level.iz_route[level.iz_route.size] = (5696, 7157, 306);
	level.iz_route[level.iz_route.size] = (4034, 7147, 306);
	level.iz_route[level.iz_route.size] = (3481, 6821, 306);
	level.iz_route[level.iz_route.size] = (2662, 6770, 306);
	level.iz_route[level.iz_route.size] = (1792, 6785, 306);
	level.iz_route[level.iz_route.size] = (1235, 6851, 306);
	level.iz_route[level.iz_route.size] = (541, 7018, 306);
	level.iz_route[level.iz_route.size] = (-265, 7025, 306);
	level.iz_route[level.iz_route.size] = (-1367, 7016, 306);
	level.iz_route[level.iz_route.size] = (-2328, 7025, 306);
	level.iz_route[level.iz_route.size] = (-2904, 7363, 306);
	level.iz_route[level.iz_route.size] = (-3512, 7411, 306);
	level.iz_route[level.iz_route.size] = (-3994, 7407, 306);
	level.iz_route[level.iz_route.size] = (-4477, 7390, 306);
	level.iz_route[level.iz_route.size] = (-5037, 7342, 306);
	level.iz_route[level.iz_route.size] = (-5656, 7253, 306);
	level.iz_route[level.iz_route.size] = (-6085, 6911, 306);
	level.iz_route[level.iz_route.size] = (-6083, 6549, 306);
	level.iz_route[level.iz_route.size] = (-6164, 5730, 306);
	level.iz_route[level.iz_route.size] = (-6194, 4693, 306);
	level.iz_route[level.iz_route.size] = (-6172, 3697, 306);
	level.iz_route[level.iz_route.size] = (-5937, 3415, 306);
	level.iz_route[level.iz_route.size] = (-5387, 3338, 306);
	level.iz_route[level.iz_route.size] = (-4530, 3361, 306);
	level.iz_route[level.iz_route.size] = (-3612, 3435, 306);
	level.iz_route[level.iz_route.size] = (-2596, 3480, 306);
	level.iz_route[level.iz_route.size] = (-1803, 3468, 306);
	level.iz_route[level.iz_route.size] = (-1478, 3330, 306);
	level.iz_route[level.iz_route.size] = (-1354, 3032, 306);
	level.iz_route[level.iz_route.size] = (-1337, 2458, 306);
	level.iz_route[level.iz_route.size] = (-1341, 1213, 306);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (1102.4055, -5348.0713, 434.0551);
	angles[0] = (0, 90, 0);
	at[0] = 0;
	points[1] = (1102.4055, -5348.0713, 434.0551);
	angles[1] = (0, 90, 0);
	at[1] = 3.4500;
	points[2] = (1102.4055, -5348.0713, 441.7284);
	angles[2] = (0, 90, 0);
	at[2] = 3.5000;
	points[3] = (1102.4055, -5348.0713, 438.4843);
	angles[3] = (0, 90, 0);
	at[3] = 3.5500;
	points[4] = (1102.4055, -5348.0713, 426.3819);
	angles[4] = (0, 90, 0);
	at[4] = 3.6000;
	points[5] = (1102.4055, -5348.0713, 429.6260);
	angles[5] = (0, 90, 0);
	at[5] = 3.6500;
	points[6] = (1102.4055, -5348.0713, 441.7284);
	angles[6] = (0, 90, 0);
	at[6] = 3.7000;
	points[7] = (1102.4055, -5348.0713, 438.4843);
	angles[7] = (0, 90, 0);
	at[7] = 3.7500;
	points[8] = (1102.4055, -5348.0713, 426.3819);
	angles[8] = (0, 90, 0);
	at[8] = 3.8000;
	points[9] = (1102.4055, -5348.0713, 429.6260);
	angles[9] = (0, 90, 0);
	at[9] = 3.8500;
	points[10] = (1102.4055, -5348.0713, 441.7284);
	angles[10] = (0, 90, 0);
	at[10] = 3.9000;
	points[11] = (1102.4055, -5348.0713, 438.4843);
	angles[11] = (0, 90, 0);
	at[11] = 3.9500;
	points[12] = (1102.4055, -5348.0713, 444.3898);
	angles[12] = (0, 90, 0);
	at[12] = 4;
	points[13] = (1102.4055, -5348.0713, 577.2638);
	angles[13] = (0, 90, 0);
	at[13] = 4.1500;
	points[14] = (1102.4055, -5348.0713, 547.1457);
	angles[14] = (0, 90, 0);
	at[14] = 4.2000;
	points[15] = (1102.4055, -5348.0713, 471.8504);
	angles[15] = (0, 90, 0);
	at[15] = 4.2500;
	points[16] = (1102.4055, -5348.0713, 351.3780);
	angles[16] = (0, 90, 0);
	at[16] = 4.3000;
	points[17] = (1102.4055, -5348.0713, 305.6677);
	angles[17] = (0, 90, 0);
	at[17] = 4.3500;
	points[18] = (1102.4055, -5348.0713, 305.6677);
	angles[18] = (0, 90, 0);
	at[18] = 5.3000;
	points[19] = (1102.4055, -5348.0713, 311.5732);
	angles[19] = (0, 90, 0);
	at[19] = 5.3500;
	points[20] = (1102.4055, -5348.0713, 426.7323);
	angles[20] = (0, 90, 0);
	at[20] = 6;
	points[21] = (1102.4055, -5348.0713, 434.0551);
	angles[21] = (0, 90, 0);
	at[21] = 6.0667;
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
	points[0] = (122.9476, -5633.6616, 434.0551);
	angles[0] = (0, 90, 0);
	at[0] = 0;
	points[1] = (122.9476, -5633.6616, 434.0551);
	angles[1] = (0, 90, 0);
	at[1] = 1.4000;
	points[2] = (122.9476, -5633.6616, 442.9134);
	angles[2] = (0, 90, 0);
	at[2] = 1.4500;
	points[3] = (122.9476, -5633.6616, 425.1969);
	angles[3] = (0, 90, 0);
	at[3] = 1.5500;
	points[4] = (122.9476, -5633.6616, 442.9134);
	angles[4] = (0, 90, 0);
	at[4] = 1.6500;
	points[5] = (122.9476, -5633.6616, 425.1969);
	angles[5] = (0, 90, 0);
	at[5] = 1.7500;
	points[6] = (122.9476, -5633.6616, 442.9134);
	angles[6] = (0, 90, 0);
	at[6] = 1.8500;
	points[7] = (122.9476, -5633.6616, 434.0551);
	angles[7] = (0, 90, 0);
	at[7] = 1.9000;
	points[8] = (122.9476, -5633.6616, 459.1536);
	angles[8] = (0, 90, 0);
	at[8] = 1.9500;
	points[9] = (122.9476, -5633.6616, 547.7363);
	angles[9] = (0, 90, 0);
	at[9] = 2.0500;
	points[10] = (122.9476, -5633.6616, 572.2441);
	angles[10] = (0, 90, 0);
	at[10] = 2.1000;
	points[11] = (122.9476, -5633.6616, 527.0670);
	angles[11] = (0, 90, 0);
	at[11] = 2.1500;
	points[12] = (122.9476, -5633.6616, 436.7126);
	angles[12] = (0, 90, 0);
	at[12] = 2.2000;
	points[13] = (122.9476, -5633.6616, 305.6677);
	angles[13] = (0, 90, 0);
	at[13] = 2.2500;
	points[14] = (122.9476, -5633.6616, 305.6677);
	angles[14] = (0, 90, 0);
	at[14] = 3.2500;
	points[15] = (122.9476, -5633.6616, 429.6850);
	angles[15] = (0, 90, 0);
	at[15] = 3.9500;
	points[16] = (122.9476, -5633.6616, 434.0551);
	angles[16] = (0, 90, 0);
	at[16] = 4;
	points[17] = (122.9476, -5633.6616, 434.0551);
	angles[17] = (0, 90, 0);
	at[17] = 6.0667;
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
	points[0] = (625.8976, 6814.6455, 434.0551);
	angles[0] = (0, -90, 0);
	at[0] = 0;
	points[1] = (625.8976, 6814.6455, 434.0551);
	angles[1] = (0, -90, 0);
	at[1] = 3.4500;
	points[2] = (625.8976, 6814.6455, 441.7284);
	angles[2] = (0, -90, 0);
	at[2] = 3.5000;
	points[3] = (625.8976, 6814.6455, 438.4843);
	angles[3] = (0, -90, 0);
	at[3] = 3.5500;
	points[4] = (625.8976, 6814.6455, 426.3819);
	angles[4] = (0, -90, 0);
	at[4] = 3.6000;
	points[5] = (625.8976, 6814.6455, 429.6260);
	angles[5] = (0, -90, 0);
	at[5] = 3.6500;
	points[6] = (625.8976, 6814.6455, 441.7284);
	angles[6] = (0, -90, 0);
	at[6] = 3.7000;
	points[7] = (625.8976, 6814.6455, 438.4843);
	angles[7] = (0, -90, 0);
	at[7] = 3.7500;
	points[8] = (625.8976, 6814.6455, 426.3819);
	angles[8] = (0, -90, 0);
	at[8] = 3.8000;
	points[9] = (625.8976, 6814.6455, 429.6260);
	angles[9] = (0, -90, 0);
	at[9] = 3.8500;
	points[10] = (625.8976, 6814.6455, 441.7284);
	angles[10] = (0, -90, 0);
	at[10] = 3.9000;
	points[11] = (625.8976, 6814.6455, 438.4843);
	angles[11] = (0, -90, 0);
	at[11] = 3.9500;
	points[12] = (625.8976, 6814.6455, 444.3898);
	angles[12] = (0, -90, 0);
	at[12] = 4;
	points[13] = (625.8976, 6814.6455, 577.2638);
	angles[13] = (0, -90, 0);
	at[13] = 4.1500;
	points[14] = (625.8976, 6814.6455, 547.1457);
	angles[14] = (0, -90, 0);
	at[14] = 4.2000;
	points[15] = (625.8976, 6814.6455, 471.8504);
	angles[15] = (0, -90, 0);
	at[15] = 4.2500;
	points[16] = (625.8976, 6814.6455, 351.3780);
	angles[16] = (0, -90, 0);
	at[16] = 4.3000;
	points[17] = (625.8976, 6814.6455, 305.6677);
	angles[17] = (0, -90, 0);
	at[17] = 4.3500;
	points[18] = (625.8976, 6814.6455, 305.6677);
	angles[18] = (0, -90, 0);
	at[18] = 5.3000;
	points[19] = (625.8976, 6814.6455, 311.5732);
	angles[19] = (0, -90, 0);
	at[19] = 5.3500;
	points[20] = (625.8976, 6814.6455, 426.7323);
	angles[20] = (0, -90, 0);
	at[20] = 6;
	points[21] = (625.8976, 6814.6455, 434.0551);
	angles[21] = (0, -90, 0);
	at[21] = 6.0667;
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
	points[0] = (-5545.9453, 7313.6226, 503.4449);
	angles[0] = (0, -90, 0);
	at[0] = 0;
	points[1] = (-5545.9453, 7313.6226, 547.7363);
	angles[1] = (0, -90, 0);
	at[1] = 0.0500;
	points[2] = (-5545.9453, 7313.6226, 572.2441);
	angles[2] = (0, -90, 0);
	at[2] = 0.1000;
	points[3] = (-5545.9453, 7313.6226, 527.0670);
	angles[3] = (0, -90, 0);
	at[3] = 0.1500;
	points[4] = (-5545.9453, 7313.6226, 436.7126);
	angles[4] = (0, -90, 0);
	at[4] = 0.2000;
	points[5] = (-5545.9453, 7313.6226, 305.6677);
	angles[5] = (0, -90, 0);
	at[5] = 0.2500;
	points[6] = (-5545.9453, 7313.6226, 305.6677);
	angles[6] = (0, -90, 0);
	at[6] = 0.5500;
	points[7] = (-5545.9453, 7313.6226, 305.6677);
	angles[7] = (0, -90, 0);
	at[7] = 1.2500;
	points[8] = (-5545.9453, 7313.6226, 429.6850);
	angles[8] = (0, -90, 0);
	at[8] = 1.9500;
	points[9] = (-5545.9453, 7313.6226, 434.0551);
	angles[9] = (0, -90, 0);
	at[9] = 2;
	points[10] = (-5545.9453, 7313.6226, 434.0551);
	angles[10] = (0, -90, 0);
	at[10] = 5.4500;
	points[11] = (-5545.9453, 7313.6226, 441.7284);
	angles[11] = (0, -90, 0);
	at[11] = 5.5000;
	points[12] = (-5545.9453, 7313.6226, 438.4843);
	angles[12] = (0, -90, 0);
	at[12] = 5.5500;
	points[13] = (-5545.9453, 7313.6226, 426.3819);
	angles[13] = (0, -90, 0);
	at[13] = 5.6000;
	points[14] = (-5545.9453, 7313.6226, 429.6260);
	angles[14] = (0, -90, 0);
	at[14] = 5.6500;
	points[15] = (-5545.9453, 7313.6226, 441.7284);
	angles[15] = (0, -90, 0);
	at[15] = 5.7000;
	points[16] = (-5545.9453, 7313.6226, 438.4843);
	angles[16] = (0, -90, 0);
	at[16] = 5.7500;
	points[17] = (-5545.9453, 7313.6226, 426.3819);
	angles[17] = (0, -90, 0);
	at[17] = 5.8000;
	points[18] = (-5545.9453, 7313.6226, 429.6260);
	angles[18] = (0, -90, 0);
	at[18] = 5.8500;
	points[19] = (-5545.9453, 7313.6226, 441.7284);
	angles[19] = (0, -90, 0);
	at[19] = 5.9000;
	points[20] = (-5545.9453, 7313.6226, 438.4843);
	angles[20] = (0, -90, 0);
	at[20] = 5.9500;
	points[21] = (-5545.9453, 7313.6226, 444.3898);
	angles[21] = (0, -90, 0);
	at[21] = 6;
	points[22] = (-5545.9453, 7313.6226, 503.4449);
	angles[22] = (0, -90, 0);
	at[22] = 6.0667;
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
	points[0] = (4364.7246, 1274.9095, 434.0551);
	angles[0] = (0, 90, 0);
	at[0] = 0;
	points[1] = (4364.7246, 1274.9095, 434.0551);
	angles[1] = (0, 90, 0);
	at[1] = 1.4000;
	points[2] = (4364.7246, 1274.9095, 442.9134);
	angles[2] = (0, 90, 0);
	at[2] = 1.4500;
	points[3] = (4364.7246, 1274.9095, 425.1969);
	angles[3] = (0, 90, 0);
	at[3] = 1.5500;
	points[4] = (4364.7246, 1274.9095, 442.9134);
	angles[4] = (0, 90, 0);
	at[4] = 1.6500;
	points[5] = (4364.7246, 1274.9095, 425.1969);
	angles[5] = (0, 90, 0);
	at[5] = 1.7500;
	points[6] = (4364.7246, 1274.9095, 442.9134);
	angles[6] = (0, 90, 0);
	at[6] = 1.8500;
	points[7] = (4364.7246, 1274.9095, 434.0551);
	angles[7] = (0, 90, 0);
	at[7] = 1.9000;
	points[8] = (4364.7246, 1274.9095, 459.1536);
	angles[8] = (0, 90, 0);
	at[8] = 1.9500;
	points[9] = (4364.7246, 1274.9095, 547.7363);
	angles[9] = (0, 90, 0);
	at[9] = 2.0500;
	points[10] = (4364.7246, 1274.9095, 572.2441);
	angles[10] = (0, 90, 0);
	at[10] = 2.1000;
	points[11] = (4364.7246, 1274.9095, 527.0670);
	angles[11] = (0, 90, 0);
	at[11] = 2.1500;
	points[12] = (4364.7246, 1274.9095, 436.7126);
	angles[12] = (0, 90, 0);
	at[12] = 2.2000;
	points[13] = (4364.7246, 1274.9095, 305.6677);
	angles[13] = (0, 90, 0);
	at[13] = 2.2500;
	points[14] = (4364.7246, 1274.9095, 305.6677);
	angles[14] = (0, 90, 0);
	at[14] = 3.2500;
	points[15] = (4364.7246, 1274.9095, 429.6850);
	angles[15] = (0, 90, 0);
	at[15] = 3.9500;
	points[16] = (4364.7246, 1274.9095, 434.0551);
	angles[16] = (0, 90, 0);
	at[16] = 4;
	points[17] = (4364.7246, 1274.9095, 434.0551);
	angles[17] = (0, 90, 0);
	at[17] = 6.0667;
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
	points[0] = (3367.6890, 3437.8191, -7882.1260);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (3367.6890, 3437.8191, -7882.1260);
	angles[1] = (0, 0, 0);
	at[1] = 0.8500;
	points[2] = (3367.6890, 3437.8191, -7185.4331);
	angles[2] = (0, 0, 0);
	at[2] = 0.9000;
	points[3] = (3367.6890, 3437.8191, -6438.0317);
	angles[3] = (0, 0, 0);
	at[3] = 0.9500;
	points[4] = (3367.6890, 3437.8191, -5730.3149);
	angles[4] = (0, 0, 0);
	at[4] = 1;
	points[5] = (3367.6890, 3437.8191, -5062.2837);
	angles[5] = (0, 0, 0);
	at[5] = 1.0500;
	points[6] = (3367.6890, 3437.8191, -4433.9370);
	angles[6] = (0, 0, 0);
	at[6] = 1.1000;
	points[7] = (3367.6890, 3437.8191, -3845.2756);
	angles[7] = (0, 0, 0);
	at[7] = 1.1500;
	points[8] = (3367.6890, 3437.8191, -3296.2991);
	angles[8] = (0, 0, 0);
	at[8] = 1.2000;
	points[9] = (3367.6890, 3437.8191, -2787.0081);
	angles[9] = (0, 0, 0);
	at[9] = 1.2500;
	points[10] = (3367.6890, 3437.8191, -2317.4016);
	angles[10] = (0, 0, 0);
	at[10] = 1.3000;
	points[11] = (3367.6890, 3437.8191, -1887.4803);
	angles[11] = (0, 0, 0);
	at[11] = 1.3500;
	points[12] = (3367.6890, 3437.8191, -1497.2440);
	angles[12] = (0, 0, 0);
	at[12] = 1.4000;
	points[13] = (3367.6890, 3437.8191, -1146.6929);
	angles[13] = (0, 0, 0);
	at[13] = 1.4500;
	points[14] = (3367.6890, 3437.8191, -835.8268);
	angles[14] = (0, 0, 0);
	at[14] = 1.5000;
	points[15] = (3367.6890, 3437.8191, -564.6457);
	angles[15] = (0, 0, 0);
	at[15] = 1.5500;
	points[16] = (3367.6890, 3437.8191, -333.1504);
	angles[16] = (0, 0, 0);
	at[16] = 1.6000;
	points[17] = (3367.6890, 3437.8191, -141.3398);
	angles[17] = (0, 0, 0);
	at[17] = 1.6500;
	points[18] = (3367.6890, 3437.8191, 10.7861);
	angles[18] = (0, 0, 0);
	at[18] = 1.7000;
	points[19] = (3367.6890, 3437.8191, 123.2272);
	angles[19] = (0, 0, 0);
	at[19] = 1.7500;
	points[20] = (3367.6890, 3437.8191, 195.9831);
	angles[20] = (0, 0, 0);
	at[20] = 1.8000;
	points[21] = (3367.6890, 3437.8191, 229.0539);
	angles[21] = (0, 0, 0);
	at[21] = 1.8500;
	points[22] = (3367.6890, 3437.8191, 231.2591);
	angles[22] = (0, 0, 0);
	at[22] = 1.9000;
	points[23] = (3367.6890, 3437.8191, -7838.0317);
	angles[23] = (0, 0, 0);
	at[23] = 4.9500;
	points[24] = (3367.6890, 3437.8191, -7882.1260);
	angles[24] = (0, 0, 0);
	at[24] = 5;
	points[25] = (3367.6890, 3437.8191, -7882.1260);
	angles[25] = (0, 0, 0);
	at[25] = 8.3167;
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
	points[0] = (1210.5197, 11160.5908, -7882.1260);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (1210.5197, 11160.5908, -7882.1260);
	angles[1] = (0, 0, 0);
	at[1] = 0.8500;
	points[2] = (1210.5197, 11160.5908, -7185.4331);
	angles[2] = (0, 0, 0);
	at[2] = 0.9000;
	points[3] = (1210.5197, 11160.5908, -6438.0317);
	angles[3] = (0, 0, 0);
	at[3] = 0.9500;
	points[4] = (1210.5197, 11160.5908, -5730.3149);
	angles[4] = (0, 0, 0);
	at[4] = 1;
	points[5] = (1210.5197, 11160.5908, -5062.2837);
	angles[5] = (0, 0, 0);
	at[5] = 1.0500;
	points[6] = (1210.5197, 11160.5908, -4433.9370);
	angles[6] = (0, 0, 0);
	at[6] = 1.1000;
	points[7] = (1210.5197, 11160.5908, -3845.2756);
	angles[7] = (0, 0, 0);
	at[7] = 1.1500;
	points[8] = (1210.5197, 11160.5908, -3296.2991);
	angles[8] = (0, 0, 0);
	at[8] = 1.2000;
	points[9] = (1210.5197, 11160.5908, -2787.0081);
	angles[9] = (0, 0, 0);
	at[9] = 1.2500;
	points[10] = (1210.5197, 11160.5908, -2317.4016);
	angles[10] = (0, 0, 0);
	at[10] = 1.3000;
	points[11] = (1210.5197, 11160.5908, -1887.4803);
	angles[11] = (0, 0, 0);
	at[11] = 1.3500;
	points[12] = (1210.5197, 11160.5908, -1497.2440);
	angles[12] = (0, 0, 0);
	at[12] = 1.4000;
	points[13] = (1210.5197, 11160.5908, -1146.6929);
	angles[13] = (0, 0, 0);
	at[13] = 1.4500;
	points[14] = (1210.5197, 11160.5908, -835.8268);
	angles[14] = (0, 0, 0);
	at[14] = 1.5000;
	points[15] = (1210.5197, 11160.5908, -564.6457);
	angles[15] = (0, 0, 0);
	at[15] = 1.5500;
	points[16] = (1210.5197, 11160.5908, -333.1504);
	angles[16] = (0, 0, 0);
	at[16] = 1.6000;
	points[17] = (1210.5197, 11160.5908, -141.3398);
	angles[17] = (0, 0, 0);
	at[17] = 1.6500;
	points[18] = (1210.5197, 11160.5908, 10.7861);
	angles[18] = (0, 0, 0);
	at[18] = 1.7000;
	points[19] = (1210.5197, 11160.5908, 123.2272);
	angles[19] = (0, 0, 0);
	at[19] = 1.7500;
	points[20] = (1210.5197, 11160.5908, 195.9831);
	angles[20] = (0, 0, 0);
	at[20] = 1.8000;
	points[21] = (1210.5197, 11160.5908, 229.0539);
	angles[21] = (0, 0, 0);
	at[21] = 1.8500;
	points[22] = (1210.5197, 11160.5908, 231.2591);
	angles[22] = (0, 0, 0);
	at[22] = 1.9000;
	points[23] = (1210.5197, 11160.5908, -7838.0317);
	angles[23] = (0, 0, 0);
	at[23] = 4.9500;
	points[24] = (1210.5197, 11160.5908, -7882.1260);
	angles[24] = (0, 0, 0);
	at[24] = 5;
	points[25] = (1210.5197, 11160.5908, -7882.1260);
	angles[25] = (0, 0, 0);
	at[25] = 8.3167;
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
	points[0] = (-3721.3660, -672.7913, -7882.1260);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-3721.3660, -672.7913, -7882.1260);
	angles[1] = (0, 0, 0);
	at[1] = 0.8500;
	points[2] = (-3721.3660, -672.7913, -7185.4331);
	angles[2] = (0, 0, 0);
	at[2] = 0.9000;
	points[3] = (-3721.3660, -672.7913, -6438.0317);
	angles[3] = (0, 0, 0);
	at[3] = 0.9500;
	points[4] = (-3721.3660, -672.7913, -5730.3149);
	angles[4] = (0, 0, 0);
	at[4] = 1;
	points[5] = (-3721.3660, -672.7913, -5062.2837);
	angles[5] = (0, 0, 0);
	at[5] = 1.0500;
	points[6] = (-3721.3660, -672.7913, -4433.9370);
	angles[6] = (0, 0, 0);
	at[6] = 1.1000;
	points[7] = (-3721.3660, -672.7913, -3845.2756);
	angles[7] = (0, 0, 0);
	at[7] = 1.1500;
	points[8] = (-3721.3660, -672.7913, -3296.2991);
	angles[8] = (0, 0, 0);
	at[8] = 1.2000;
	points[9] = (-3721.3660, -672.7913, -2787.0081);
	angles[9] = (0, 0, 0);
	at[9] = 1.2500;
	points[10] = (-3721.3660, -672.7913, -2317.4016);
	angles[10] = (0, 0, 0);
	at[10] = 1.3000;
	points[11] = (-3721.3660, -672.7913, -1887.4803);
	angles[11] = (0, 0, 0);
	at[11] = 1.3500;
	points[12] = (-3721.3660, -672.7913, -1497.2440);
	angles[12] = (0, 0, 0);
	at[12] = 1.4000;
	points[13] = (-3721.3660, -672.7913, -1146.6929);
	angles[13] = (0, 0, 0);
	at[13] = 1.4500;
	points[14] = (-3721.3660, -672.7913, -835.8268);
	angles[14] = (0, 0, 0);
	at[14] = 1.5000;
	points[15] = (-3721.3660, -672.7913, -564.6457);
	angles[15] = (0, 0, 0);
	at[15] = 1.5500;
	points[16] = (-3721.3660, -672.7913, -333.1504);
	angles[16] = (0, 0, 0);
	at[16] = 1.6000;
	points[17] = (-3721.3660, -672.7913, -141.3398);
	angles[17] = (0, 0, 0);
	at[17] = 1.6500;
	points[18] = (-3721.3660, -672.7913, 10.7861);
	angles[18] = (0, 0, 0);
	at[18] = 1.7000;
	points[19] = (-3721.3660, -672.7913, 123.2272);
	angles[19] = (0, 0, 0);
	at[19] = 1.7500;
	points[20] = (-3721.3660, -672.7913, 195.9831);
	angles[20] = (0, 0, 0);
	at[20] = 1.8000;
	points[21] = (-3721.3660, -672.7913, 229.0539);
	angles[21] = (0, 0, 0);
	at[21] = 1.8500;
	points[22] = (-3721.3660, -672.7913, 231.2591);
	angles[22] = (0, 0, 0);
	at[22] = 1.9000;
	points[23] = (-3721.3660, -672.7913, -7838.0317);
	angles[23] = (0, 0, 0);
	at[23] = 4.9500;
	points[24] = (-3721.3660, -672.7913, -7882.1260);
	angles[24] = (0, 0, 0);
	at[24] = 5;
	points[25] = (-3721.3660, -672.7913, -7882.1260);
	angles[25] = (0, 0, 0);
	at[25] = 8.3167;
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
	points[0] = (6214.5674, -2070.4568, -7882.1260);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (6214.5674, -2070.4568, -7882.1260);
	angles[1] = (0, 0, 0);
	at[1] = 0.8500;
	points[2] = (6214.5674, -2070.4568, -7185.4331);
	angles[2] = (0, 0, 0);
	at[2] = 0.9000;
	points[3] = (6214.5674, -2070.4568, -6438.0317);
	angles[3] = (0, 0, 0);
	at[3] = 0.9500;
	points[4] = (6214.5674, -2070.4568, -5730.3149);
	angles[4] = (0, 0, 0);
	at[4] = 1;
	points[5] = (6214.5674, -2070.4568, -5062.2837);
	angles[5] = (0, 0, 0);
	at[5] = 1.0500;
	points[6] = (6214.5674, -2070.4568, -4433.9370);
	angles[6] = (0, 0, 0);
	at[6] = 1.1000;
	points[7] = (6214.5674, -2070.4568, -3845.2756);
	angles[7] = (0, 0, 0);
	at[7] = 1.1500;
	points[8] = (6214.5674, -2070.4568, -3296.2991);
	angles[8] = (0, 0, 0);
	at[8] = 1.2000;
	points[9] = (6214.5674, -2070.4568, -2787.0081);
	angles[9] = (0, 0, 0);
	at[9] = 1.2500;
	points[10] = (6214.5674, -2070.4568, -2317.4016);
	angles[10] = (0, 0, 0);
	at[10] = 1.3000;
	points[11] = (6214.5674, -2070.4568, -1887.4803);
	angles[11] = (0, 0, 0);
	at[11] = 1.3500;
	points[12] = (6214.5674, -2070.4568, -1497.2440);
	angles[12] = (0, 0, 0);
	at[12] = 1.4000;
	points[13] = (6214.5674, -2070.4568, -1146.6929);
	angles[13] = (0, 0, 0);
	at[13] = 1.4500;
	points[14] = (6214.5674, -2070.4568, -835.8268);
	angles[14] = (0, 0, 0);
	at[14] = 1.5000;
	points[15] = (6214.5674, -2070.4568, -564.6457);
	angles[15] = (0, 0, 0);
	at[15] = 1.5500;
	points[16] = (6214.5674, -2070.4568, -333.1504);
	angles[16] = (0, 0, 0);
	at[16] = 1.6000;
	points[17] = (6214.5674, -2070.4568, -141.3398);
	angles[17] = (0, 0, 0);
	at[17] = 1.6500;
	points[18] = (6214.5674, -2070.4568, 10.7861);
	angles[18] = (0, 0, 0);
	at[18] = 1.7000;
	points[19] = (6214.5674, -2070.4568, 123.2272);
	angles[19] = (0, 0, 0);
	at[19] = 1.7500;
	points[20] = (6214.5674, -2070.4568, 195.9831);
	angles[20] = (0, 0, 0);
	at[20] = 1.8000;
	points[21] = (6214.5674, -2070.4568, 229.0539);
	angles[21] = (0, 0, 0);
	at[21] = 1.8500;
	points[22] = (6214.5674, -2070.4568, 231.2591);
	angles[22] = (0, 0, 0);
	at[22] = 1.9000;
	points[23] = (6214.5674, -2070.4568, -7838.0317);
	angles[23] = (0, 0, 0);
	at[23] = 4.9500;
	points[24] = (6214.5674, -2070.4568, -7882.1260);
	angles[24] = (0, 0, 0);
	at[24] = 5;
	points[25] = (6214.5674, -2070.4568, -7882.1260);
	angles[25] = (0, 0, 0);
	at[25] = 8.3167;
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
	points[0] = (12067.8740, 6678.5039, -7882.1260);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (12067.8740, 6678.5039, -7882.1260);
	angles[1] = (0, 0, 0);
	at[1] = 0.8500;
	points[2] = (12067.8740, 6678.5039, -7185.4331);
	angles[2] = (0, 0, 0);
	at[2] = 0.9000;
	points[3] = (12067.8740, 6678.5039, -6438.0317);
	angles[3] = (0, 0, 0);
	at[3] = 0.9500;
	points[4] = (12067.8740, 6678.5039, -5730.3149);
	angles[4] = (0, 0, 0);
	at[4] = 1;
	points[5] = (12067.8740, 6678.5039, -5062.2837);
	angles[5] = (0, 0, 0);
	at[5] = 1.0500;
	points[6] = (12067.8740, 6678.5039, -4433.9370);
	angles[6] = (0, 0, 0);
	at[6] = 1.1000;
	points[7] = (12067.8740, 6678.5039, -3845.2756);
	angles[7] = (0, 0, 0);
	at[7] = 1.1500;
	points[8] = (12067.8740, 6678.5039, -3296.2991);
	angles[8] = (0, 0, 0);
	at[8] = 1.2000;
	points[9] = (12067.8740, 6678.5039, -2787.0081);
	angles[9] = (0, 0, 0);
	at[9] = 1.2500;
	points[10] = (12067.8740, 6678.5039, -2317.4016);
	angles[10] = (0, 0, 0);
	at[10] = 1.3000;
	points[11] = (12067.8740, 6678.5039, -1887.4803);
	angles[11] = (0, 0, 0);
	at[11] = 1.3500;
	points[12] = (12067.8740, 6678.5039, -1497.2440);
	angles[12] = (0, 0, 0);
	at[12] = 1.4000;
	points[13] = (12067.8740, 6678.5039, -1146.6929);
	angles[13] = (0, 0, 0);
	at[13] = 1.4500;
	points[14] = (12067.8740, 6678.5039, -835.8268);
	angles[14] = (0, 0, 0);
	at[14] = 1.5000;
	points[15] = (12067.8740, 6678.5039, -564.6457);
	angles[15] = (0, 0, 0);
	at[15] = 1.5500;
	points[16] = (12067.8740, 6678.5039, -333.1504);
	angles[16] = (0, 0, 0);
	at[16] = 1.6000;
	points[17] = (12067.8740, 6678.5039, -141.3398);
	angles[17] = (0, 0, 0);
	at[17] = 1.6500;
	points[18] = (12067.8740, 6678.5039, 10.7861);
	angles[18] = (0, 0, 0);
	at[18] = 1.7000;
	points[19] = (12067.8740, 6678.5039, 123.2272);
	angles[19] = (0, 0, 0);
	at[19] = 1.7500;
	points[20] = (12067.8740, 6678.5039, 195.9831);
	angles[20] = (0, 0, 0);
	at[20] = 1.8000;
	points[21] = (12067.8740, 6678.5039, 229.0539);
	angles[21] = (0, 0, 0);
	at[21] = 1.8500;
	points[22] = (12067.8740, 6678.5039, 231.2591);
	angles[22] = (0, 0, 0);
	at[22] = 1.9000;
	points[23] = (12067.8740, 6678.5039, -7838.0317);
	angles[23] = (0, 0, 0);
	at[23] = 4.9500;
	points[24] = (12067.8740, 6678.5039, -7882.1260);
	angles[24] = (0, 0, 0);
	at[24] = 5;
	points[25] = (12067.8740, 6678.5039, -7882.1260);
	angles[25] = (0, 0, 0);
	at[25] = 8.3167;
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
	points[0] = (701.9961, -2356.3662, -7882.1260);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (701.9961, -2356.3662, -7882.1260);
	angles[1] = (0, 0, 0);
	at[1] = 0.8500;
	points[2] = (701.9961, -2356.3662, -7185.4331);
	angles[2] = (0, 0, 0);
	at[2] = 0.9000;
	points[3] = (701.9961, -2356.3662, -6438.0317);
	angles[3] = (0, 0, 0);
	at[3] = 0.9500;
	points[4] = (701.9961, -2356.3662, -5730.3149);
	angles[4] = (0, 0, 0);
	at[4] = 1;
	points[5] = (701.9961, -2356.3662, -5062.2837);
	angles[5] = (0, 0, 0);
	at[5] = 1.0500;
	points[6] = (701.9961, -2356.3662, -4433.9370);
	angles[6] = (0, 0, 0);
	at[6] = 1.1000;
	points[7] = (701.9961, -2356.3662, -3845.2756);
	angles[7] = (0, 0, 0);
	at[7] = 1.1500;
	points[8] = (701.9961, -2356.3662, -3296.2991);
	angles[8] = (0, 0, 0);
	at[8] = 1.2000;
	points[9] = (701.9961, -2356.3662, -2787.0081);
	angles[9] = (0, 0, 0);
	at[9] = 1.2500;
	points[10] = (701.9961, -2356.3662, -2317.4016);
	angles[10] = (0, 0, 0);
	at[10] = 1.3000;
	points[11] = (701.9961, -2356.3662, -1887.4803);
	angles[11] = (0, 0, 0);
	at[11] = 1.3500;
	points[12] = (701.9961, -2356.3662, -1497.2440);
	angles[12] = (0, 0, 0);
	at[12] = 1.4000;
	points[13] = (701.9961, -2356.3662, -1146.6929);
	angles[13] = (0, 0, 0);
	at[13] = 1.4500;
	points[14] = (701.9961, -2356.3662, -835.8268);
	angles[14] = (0, 0, 0);
	at[14] = 1.5000;
	points[15] = (701.9961, -2356.3662, -564.6457);
	angles[15] = (0, 0, 0);
	at[15] = 1.5500;
	points[16] = (701.9961, -2356.3662, -333.1504);
	angles[16] = (0, 0, 0);
	at[16] = 1.6000;
	points[17] = (701.9961, -2356.3662, -141.3398);
	angles[17] = (0, 0, 0);
	at[17] = 1.6500;
	points[18] = (701.9961, -2356.3662, 10.7861);
	angles[18] = (0, 0, 0);
	at[18] = 1.7000;
	points[19] = (701.9961, -2356.3662, 123.2272);
	angles[19] = (0, 0, 0);
	at[19] = 1.7500;
	points[20] = (701.9961, -2356.3662, 195.9831);
	angles[20] = (0, 0, 0);
	at[20] = 1.8000;
	points[21] = (701.9961, -2356.3662, 229.0539);
	angles[21] = (0, 0, 0);
	at[21] = 1.8500;
	points[22] = (701.9961, -2356.3662, 231.2591);
	angles[22] = (0, 0, 0);
	at[22] = 1.9000;
	points[23] = (701.9961, -2356.3662, -7838.0317);
	angles[23] = (0, 0, 0);
	at[23] = 4.9500;
	points[24] = (701.9961, -2356.3662, -7882.1260);
	angles[24] = (0, 0, 0);
	at[24] = 5;
	points[25] = (701.9961, -2356.3662, -7882.1260);
	angles[25] = (0, 0, 0);
	at[25] = 8.3167;
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
	points[0] = (-1903.4568, 5183.5039, -7882.1260);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-1903.4568, 5183.5039, -7882.1260);
	angles[1] = (0, 0, 0);
	at[1] = 0.8500;
	points[2] = (-1903.4568, 5183.5039, -7185.4331);
	angles[2] = (0, 0, 0);
	at[2] = 0.9000;
	points[3] = (-1903.4568, 5183.5039, -6438.0317);
	angles[3] = (0, 0, 0);
	at[3] = 0.9500;
	points[4] = (-1903.4568, 5183.5039, -5730.3149);
	angles[4] = (0, 0, 0);
	at[4] = 1;
	points[5] = (-1903.4568, 5183.5039, -5062.2837);
	angles[5] = (0, 0, 0);
	at[5] = 1.0500;
	points[6] = (-1903.4568, 5183.5039, -4433.9370);
	angles[6] = (0, 0, 0);
	at[6] = 1.1000;
	points[7] = (-1903.4568, 5183.5039, -3845.2756);
	angles[7] = (0, 0, 0);
	at[7] = 1.1500;
	points[8] = (-1903.4568, 5183.5039, -3296.2991);
	angles[8] = (0, 0, 0);
	at[8] = 1.2000;
	points[9] = (-1903.4568, 5183.5039, -2787.0081);
	angles[9] = (0, 0, 0);
	at[9] = 1.2500;
	points[10] = (-1903.4568, 5183.5039, -2317.4016);
	angles[10] = (0, 0, 0);
	at[10] = 1.3000;
	points[11] = (-1903.4568, 5183.5039, -1887.4803);
	angles[11] = (0, 0, 0);
	at[11] = 1.3500;
	points[12] = (-1903.4568, 5183.5039, -1497.2440);
	angles[12] = (0, 0, 0);
	at[12] = 1.4000;
	points[13] = (-1903.4568, 5183.5039, -1146.6929);
	angles[13] = (0, 0, 0);
	at[13] = 1.4500;
	points[14] = (-1903.4568, 5183.5039, -835.8268);
	angles[14] = (0, 0, 0);
	at[14] = 1.5000;
	points[15] = (-1903.4568, 5183.5039, -564.6457);
	angles[15] = (0, 0, 0);
	at[15] = 1.5500;
	points[16] = (-1903.4568, 5183.5039, -333.1504);
	angles[16] = (0, 0, 0);
	at[16] = 1.6000;
	points[17] = (-1903.4568, 5183.5039, -141.3398);
	angles[17] = (0, 0, 0);
	at[17] = 1.6500;
	points[18] = (-1903.4568, 5183.5039, 10.7861);
	angles[18] = (0, 0, 0);
	at[18] = 1.7000;
	points[19] = (-1903.4568, 5183.5039, 123.2272);
	angles[19] = (0, 0, 0);
	at[19] = 1.7500;
	points[20] = (-1903.4568, 5183.5039, 195.9831);
	angles[20] = (0, 0, 0);
	at[20] = 1.8000;
	points[21] = (-1903.4568, 5183.5039, 229.0539);
	angles[21] = (0, 0, 0);
	at[21] = 1.8500;
	points[22] = (-1903.4568, 5183.5039, 231.2591);
	angles[22] = (0, 0, 0);
	at[22] = 1.9000;
	points[23] = (-1903.4568, 5183.5039, -7838.0317);
	angles[23] = (0, 0, 0);
	at[23] = 4.9500;
	points[24] = (-1903.4568, 5183.5039, -7882.1260);
	angles[24] = (0, 0, 0);
	at[24] = 5;
	points[25] = (-1903.4568, 5183.5039, -7882.1260);
	angles[25] = (0, 0, 0);
	at[25] = 8.3167;
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
	points[0] = (-10431.0635, 5011.5356, -7882.1260);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-10431.0635, 5011.5356, -7882.1260);
	angles[1] = (0, 0, 0);
	at[1] = 0.8500;
	points[2] = (-10431.0635, 5011.5356, -7185.4331);
	angles[2] = (0, 0, 0);
	at[2] = 0.9000;
	points[3] = (-10431.0635, 5011.5356, -6438.0317);
	angles[3] = (0, 0, 0);
	at[3] = 0.9500;
	points[4] = (-10431.0635, 5011.5356, -5730.3149);
	angles[4] = (0, 0, 0);
	at[4] = 1;
	points[5] = (-10431.0635, 5011.5356, -5062.2837);
	angles[5] = (0, 0, 0);
	at[5] = 1.0500;
	points[6] = (-10431.0635, 5011.5356, -4433.9370);
	angles[6] = (0, 0, 0);
	at[6] = 1.1000;
	points[7] = (-10431.0635, 5011.5356, -3845.2756);
	angles[7] = (0, 0, 0);
	at[7] = 1.1500;
	points[8] = (-10431.0635, 5011.5356, -3296.2991);
	angles[8] = (0, 0, 0);
	at[8] = 1.2000;
	points[9] = (-10431.0635, 5011.5356, -2787.0081);
	angles[9] = (0, 0, 0);
	at[9] = 1.2500;
	points[10] = (-10431.0635, 5011.5356, -2317.4016);
	angles[10] = (0, 0, 0);
	at[10] = 1.3000;
	points[11] = (-10431.0635, 5011.5356, -1887.4803);
	angles[11] = (0, 0, 0);
	at[11] = 1.3500;
	points[12] = (-10431.0635, 5011.5356, -1497.2440);
	angles[12] = (0, 0, 0);
	at[12] = 1.4000;
	points[13] = (-10431.0635, 5011.5356, -1146.6929);
	angles[13] = (0, 0, 0);
	at[13] = 1.4500;
	points[14] = (-10431.0635, 5011.5356, -835.8268);
	angles[14] = (0, 0, 0);
	at[14] = 1.5000;
	points[15] = (-10431.0635, 5011.5356, -564.6457);
	angles[15] = (0, 0, 0);
	at[15] = 1.5500;
	points[16] = (-10431.0635, 5011.5356, -333.1504);
	angles[16] = (0, 0, 0);
	at[16] = 1.6000;
	points[17] = (-10431.0635, 5011.5356, -141.3398);
	angles[17] = (0, 0, 0);
	at[17] = 1.6500;
	points[18] = (-10431.0635, 5011.5356, 10.7861);
	angles[18] = (0, 0, 0);
	at[18] = 1.7000;
	points[19] = (-10431.0635, 5011.5356, 123.2272);
	angles[19] = (0, 0, 0);
	at[19] = 1.7500;
	points[20] = (-10431.0635, 5011.5356, 195.9831);
	angles[20] = (0, 0, 0);
	at[20] = 1.8000;
	points[21] = (-10431.0635, 5011.5356, 229.0539);
	angles[21] = (0, 0, 0);
	at[21] = 1.8500;
	points[22] = (-10431.0635, 5011.5356, 231.2591);
	angles[22] = (0, 0, 0);
	at[22] = 1.9000;
	points[23] = (-10431.0635, 5011.5356, -7838.0317);
	angles[23] = (0, 0, 0);
	at[23] = 4.9500;
	points[24] = (-10431.0635, 5011.5356, -7882.1260);
	angles[24] = (0, 0, 0);
	at[24] = 5;
	points[25] = (-10431.0635, 5011.5356, -7882.1260);
	angles[25] = (0, 0, 0);
	at[25] = 8.3167;
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
	points[0] = (10782.6777, 824, -7882.1260);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (10782.6777, 824, -7882.1260);
	angles[1] = (0, 0, 0);
	at[1] = 0.8500;
	points[2] = (10782.6777, 824, -7185.4331);
	angles[2] = (0, 0, 0);
	at[2] = 0.9000;
	points[3] = (10782.6777, 824, -6438.0317);
	angles[3] = (0, 0, 0);
	at[3] = 0.9500;
	points[4] = (10782.6777, 824, -5730.3149);
	angles[4] = (0, 0, 0);
	at[4] = 1;
	points[5] = (10782.6777, 824, -5062.2837);
	angles[5] = (0, 0, 0);
	at[5] = 1.0500;
	points[6] = (10782.6777, 824, -4433.9370);
	angles[6] = (0, 0, 0);
	at[6] = 1.1000;
	points[7] = (10782.6777, 824, -3845.2756);
	angles[7] = (0, 0, 0);
	at[7] = 1.1500;
	points[8] = (10782.6777, 824, -3296.2991);
	angles[8] = (0, 0, 0);
	at[8] = 1.2000;
	points[9] = (10782.6777, 824, -2787.0081);
	angles[9] = (0, 0, 0);
	at[9] = 1.2500;
	points[10] = (10782.6777, 824, -2317.4016);
	angles[10] = (0, 0, 0);
	at[10] = 1.3000;
	points[11] = (10782.6777, 824, -1887.4803);
	angles[11] = (0, 0, 0);
	at[11] = 1.3500;
	points[12] = (10782.6777, 824, -1497.2440);
	angles[12] = (0, 0, 0);
	at[12] = 1.4000;
	points[13] = (10782.6777, 824, -1146.6929);
	angles[13] = (0, 0, 0);
	at[13] = 1.4500;
	points[14] = (10782.6777, 824, -835.8268);
	angles[14] = (0, 0, 0);
	at[14] = 1.5000;
	points[15] = (10782.6777, 824, -564.6457);
	angles[15] = (0, 0, 0);
	at[15] = 1.5500;
	points[16] = (10782.6777, 824, -333.1504);
	angles[16] = (0, 0, 0);
	at[16] = 1.6000;
	points[17] = (10782.6777, 824, -141.3398);
	angles[17] = (0, 0, 0);
	at[17] = 1.6500;
	points[18] = (10782.6777, 824, 10.7861);
	angles[18] = (0, 0, 0);
	at[18] = 1.7000;
	points[19] = (10782.6777, 824, 123.2272);
	angles[19] = (0, 0, 0);
	at[19] = 1.7500;
	points[20] = (10782.6777, 824, 195.9831);
	angles[20] = (0, 0, 0);
	at[20] = 1.8000;
	points[21] = (10782.6777, 824, 229.0539);
	angles[21] = (0, 0, 0);
	at[21] = 1.8500;
	points[22] = (10782.6777, 824, 231.2591);
	angles[22] = (0, 0, 0);
	at[22] = 1.9000;
	points[23] = (10782.6777, 824, -7838.0317);
	angles[23] = (0, 0, 0);
	at[23] = 4.9500;
	points[24] = (10782.6777, 824, -7882.1260);
	angles[24] = (0, 0, 0);
	at[24] = 5;
	points[25] = (10782.6777, 824, -7882.1260);
	angles[25] = (0, 0, 0);
	at[25] = 8.3167;
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
	points[0] = (1815.0669, -8180.5908, -7882.1260);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (1815.0669, -8180.5908, -7882.1260);
	angles[1] = (0, 0, 0);
	at[1] = 0.8500;
	points[2] = (1815.0669, -8180.5908, -7185.4331);
	angles[2] = (0, 0, 0);
	at[2] = 0.9000;
	points[3] = (1815.0669, -8180.5908, -6438.0317);
	angles[3] = (0, 0, 0);
	at[3] = 0.9500;
	points[4] = (1815.0669, -8180.5908, -5730.3149);
	angles[4] = (0, 0, 0);
	at[4] = 1;
	points[5] = (1815.0669, -8180.5908, -5062.2837);
	angles[5] = (0, 0, 0);
	at[5] = 1.0500;
	points[6] = (1815.0669, -8180.5908, -4433.9370);
	angles[6] = (0, 0, 0);
	at[6] = 1.1000;
	points[7] = (1815.0669, -8180.5908, -3845.2756);
	angles[7] = (0, 0, 0);
	at[7] = 1.1500;
	points[8] = (1815.0669, -8180.5908, -3296.2991);
	angles[8] = (0, 0, 0);
	at[8] = 1.2000;
	points[9] = (1815.0669, -8180.5908, -2787.0081);
	angles[9] = (0, 0, 0);
	at[9] = 1.2500;
	points[10] = (1815.0669, -8180.5908, -2317.4016);
	angles[10] = (0, 0, 0);
	at[10] = 1.3000;
	points[11] = (1815.0669, -8180.5908, -1887.4803);
	angles[11] = (0, 0, 0);
	at[11] = 1.3500;
	points[12] = (1815.0669, -8180.5908, -1497.2440);
	angles[12] = (0, 0, 0);
	at[12] = 1.4000;
	points[13] = (1815.0669, -8180.5908, -1146.6929);
	angles[13] = (0, 0, 0);
	at[13] = 1.4500;
	points[14] = (1815.0669, -8180.5908, -835.8268);
	angles[14] = (0, 0, 0);
	at[14] = 1.5000;
	points[15] = (1815.0669, -8180.5908, -564.6457);
	angles[15] = (0, 0, 0);
	at[15] = 1.5500;
	points[16] = (1815.0669, -8180.5908, -333.1504);
	angles[16] = (0, 0, 0);
	at[16] = 1.6000;
	points[17] = (1815.0669, -8180.5908, -141.3398);
	angles[17] = (0, 0, 0);
	at[17] = 1.6500;
	points[18] = (1815.0669, -8180.5908, 10.7861);
	angles[18] = (0, 0, 0);
	at[18] = 1.7000;
	points[19] = (1815.0669, -8180.5908, 123.2272);
	angles[19] = (0, 0, 0);
	at[19] = 1.7500;
	points[20] = (1815.0669, -8180.5908, 195.9831);
	angles[20] = (0, 0, 0);
	at[20] = 1.8000;
	points[21] = (1815.0669, -8180.5908, 229.0539);
	angles[21] = (0, 0, 0);
	at[21] = 1.8500;
	points[22] = (1815.0669, -8180.5908, 231.2591);
	angles[22] = (0, 0, 0);
	at[22] = 1.9000;
	points[23] = (1815.0669, -8180.5908, -7838.0317);
	angles[23] = (0, 0, 0);
	at[23] = 4.9500;
	points[24] = (1815.0669, -8180.5908, -7882.1260);
	angles[24] = (0, 0, 0);
	at[24] = 5;
	points[25] = (1815.0669, -8180.5908, -7882.1260);
	angles[25] = (0, 0, 0);
	at[25] = 8.3167;
	mover = getEnt("iz_obj_14", "targetname");
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
