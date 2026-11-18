main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_ds_lava_arena", 0);

	level.iz_cue = [];
	level.iz_cue["iz_cue_boost"] = true;
	level.iz_cue["iz_cue_bounce"] = true;
	level.iz_cue["iz_cue_cannon"] = true;
	level.iz_cue["iz_cue_finish"] = true;
	level.iz_cue["iz_cue_item"] = true;
	level.iz_cue["iz_cue_jump"] = true;
	thread iz_sounds();

	thread iz_course();

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
	ambientPlay("iz_0_dsla", 2);
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
	level.iz_route[level.iz_route.size] = (915, 0, 2296);
	level.iz_route[level.iz_route.size] = (738, -531, 2296);
	level.iz_route[level.iz_route.size] = (281, -886, 2296);
	level.iz_route[level.iz_route.size] = (0, -886, 2296);
	level.iz_route[level.iz_route.size] = (0, 0, 2296);
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
	points[0] = (0, 2938.9604, 2108.6614);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, 2938.9604, 2046.6536);
	angles[1] = (0, 0, 0);
	at[1] = 0.7000;
	points[2] = (0, 2938.1140, 2042.3190);
	angles[2] = (0, -180, -83.6256);
	at[2] = 0.7500;
	points[3] = (0, 2936.1064, 2033.6930);
	angles[3] = (0, -180, -78.6704);
	at[3] = 0.8500;
	points[4] = (0, 2935.1023, 2037.1576);
	angles[4] = (0, -180, -49.9564);
	at[4] = 0.9000;
	points[5] = (0, 2934.0984, 2041.4725);
	angles[5] = (0, -180, -8.0144);
	at[5] = 0.9500;
	points[6] = (0, 2933.0986, 2045.7834);
	angles[6] = (0, -180, 28.7661);
	at[6] = 1;
	points[7] = (0, 2933.0552, 2050.2087);
	angles[7] = (0, -180, 57.0461);
	at[7] = 1.0500;
	points[8] = (0, 2933.0552, 2054.6379);
	angles[8] = (0, -180, 72.8930);
	at[8] = 1.1000;
	points[9] = (0, 2933.0552, 2059.0669);
	angles[9] = (0, -180, 81.2090);
	at[9] = 1.1500;
	points[10] = (0, 2933.0552, 2063.5708);
	angles[10] = (0, -180, 85.4948);
	at[10] = 1.2000;
	points[11] = (0, 2933.0552, 2082.2441);
	angles[11] = (0, -180, 89.3951);
	at[11] = 1.3500;
	points[12] = (0, 2933.0552, 2101.0984);
	angles[12] = (0, -180, 89.8415);
	at[12] = 1.4500;
	points[13] = (0, 2933.0552, 2127.5000);
	angles[13] = (0, -180, 89.9584);
	at[13] = 1.5500;
	points[14] = (0, 2933.0552, 2164.4646);
	angles[14] = (0, -180, 89.9892);
	at[14] = 1.6500;
	points[15] = (0, 2933.0552, 2188.1772);
	angles[15] = (0, -180, 0);
	at[15] = 1.7000;
	points[16] = (0, 2933.0552, 2216.2324);
	angles[16] = (0, -180, 0);
	at[16] = 1.7500;
	points[17] = (0, 2933.0552, 2249.4331);
	angles[17] = (0, -180, 0);
	at[17] = 1.8000;
	points[18] = (0, 2933.0552, 2288.1104);
	angles[18] = (0, -180, 0);
	at[18] = 1.8500;
	points[19] = (0, 2933.0552, 2327.2598);
	angles[19] = (0, -360, 0);
	at[19] = 1.9000;
	points[20] = (0, 2933.0552, 2440.1340);
	angles[20] = (0, -360, 0);
	at[20] = 2.0500;
	points[21] = (0, 2933.0552, 2511.3662);
	angles[21] = (0, -360, 0);
	at[21] = 2.1500;
	points[22] = (0, 2933.0552, 2571.4214);
	angles[22] = (0, -360, 0);
	at[22] = 2.2500;
	points[23] = (0, 2933.0552, 2594.7441);
	angles[23] = (0, -360, 0);
	at[23] = 2.3000;
	points[24] = (0, 2933.0552, 2611.5864);
	angles[24] = (0, -360, 0);
	at[24] = 2.3500;
	points[25] = (0, 2933.0552, 2623.3074);
	angles[25] = (0, -360, 0);
	at[25] = 2.4000;
	points[26] = (0, 2934.1616, 2631.5356);
	angles[26] = (0, -360, 85.8614);
	at[26] = 2.4500;
	points[27] = (0, 2935.7913, 2642.4409);
	angles[27] = (0, -360, 82.6518);
	at[27] = 2.5500;
	points[28] = (0, 2936.3425, 2641.6182);
	angles[28] = (0, -360, 70.5617);
	at[28] = 2.6000;
	points[29] = (0, 2937, 2637.1455);
	angles[29] = (0, -360, 39.1380);
	at[29] = 2.6500;
	points[30] = (0, 2937.8464, 2631.3977);
	angles[30] = (0, -360, -3.3331);
	at[30] = 2.7000;
	points[31] = (0, 2938.9331, 2624.0120);
	angles[31] = (0, -360, -37.9901);
	at[31] = 2.7500;
	points[32] = (0, 2938.9604, 2614.2205);
	angles[32] = (0, -360, -62.4134);
	at[32] = 2.8000;
	points[33] = (0, 2938.9604, 2600.8818);
	angles[33] = (0, -360, -75.7391);
	at[33] = 2.8500;
	points[34] = (0, 2938.9604, 2582.7639);
	angles[34] = (0, -360, -82.6799);
	at[34] = 2.9000;
	points[35] = (0, 2938.9604, 2558.4922);
	angles[35] = (0, -360, -86.2495);
	at[35] = 2.9500;
	points[36] = (0, 2938.9604, 2528.7759);
	angles[36] = (0, -360, -88.0795);
	at[36] = 3;
	points[37] = (0, 2938.9604, 2455.7283);
	angles[37] = (0, -360, -89.4965);
	at[37] = 3.1000;
	points[38] = (0, 2938.9604, 2422.8464);
	angles[38] = (0, -360, -89.7422);
	at[38] = 3.1500;
	points[39] = (0, 2938.9604, 2394.9172);
	angles[39] = (0, -360, -89.8680);
	at[39] = 3.2000;
	points[40] = (0, 2938.9604, 2351.0513);
	angles[40] = (0, -360, -89.9654);
	at[40] = 3.3000;
	points[41] = (0, 2938.9604, 2319.4094);
	angles[41] = (0, -360, -89.9910);
	at[41] = 3.4000;
	points[42] = (0, 2938.9604, 2307.0669);
	angles[42] = (0, -360, 0);
	at[42] = 3.4500;
	points[43] = (0, 2938.9604, 2296.5828);
	angles[43] = (0, -360, 0);
	at[43] = 3.5000;
	points[44] = (0, 2938.9604, 2280.1182);
	angles[44] = (0, -360, 0);
	at[44] = 3.6000;
	points[45] = (0, 2938.9604, 2268.2402);
	angles[45] = (0, -360, 0);
	at[45] = 3.7000;
	points[46] = (0, 2938.9604, 2108.6614);
	angles[46] = (0, -360, 0);
	at[46] = 5.5000;
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
	points[0] = (-2938.9604, 2938.9604, 2108.6614);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2938.9604, 2938.9604, 2046.6536);
	angles[1] = (0, 0, 0);
	at[1] = 0.7000;
	points[2] = (-2938.9604, 2938.1140, 2042.3190);
	angles[2] = (0, -180, -83.6256);
	at[2] = 0.7500;
	points[3] = (-2938.9604, 2936.1064, 2033.6930);
	angles[3] = (0, -180, -78.6704);
	at[3] = 0.8500;
	points[4] = (-2938.9604, 2935.1023, 2037.1576);
	angles[4] = (0, -180, -49.9564);
	at[4] = 0.9000;
	points[5] = (-2938.9604, 2934.0984, 2041.4725);
	angles[5] = (0, -180, -8.0144);
	at[5] = 0.9500;
	points[6] = (-2938.9604, 2933.0986, 2045.7834);
	angles[6] = (0, -180, 28.7661);
	at[6] = 1;
	points[7] = (-2938.9604, 2933.0552, 2050.2087);
	angles[7] = (0, -180, 57.0461);
	at[7] = 1.0500;
	points[8] = (-2938.9604, 2933.0552, 2054.6379);
	angles[8] = (0, -180, 72.8930);
	at[8] = 1.1000;
	points[9] = (-2938.9604, 2933.0552, 2059.0669);
	angles[9] = (0, -180, 81.2090);
	at[9] = 1.1500;
	points[10] = (-2938.9604, 2933.0552, 2063.5708);
	angles[10] = (0, -180, 85.4948);
	at[10] = 1.2000;
	points[11] = (-2938.9604, 2933.0552, 2082.2441);
	angles[11] = (0, -180, 89.3951);
	at[11] = 1.3500;
	points[12] = (-2938.9604, 2933.0552, 2101.0984);
	angles[12] = (0, -180, 89.8415);
	at[12] = 1.4500;
	points[13] = (-2938.9604, 2933.0552, 2127.5000);
	angles[13] = (0, -180, 89.9584);
	at[13] = 1.5500;
	points[14] = (-2938.9604, 2933.0552, 2164.4646);
	angles[14] = (0, -180, 89.9892);
	at[14] = 1.6500;
	points[15] = (-2938.9604, 2933.0552, 2188.1772);
	angles[15] = (0, -180, 0);
	at[15] = 1.7000;
	points[16] = (-2938.9604, 2933.0552, 2216.2324);
	angles[16] = (0, -180, 0);
	at[16] = 1.7500;
	points[17] = (-2938.9604, 2933.0552, 2249.4331);
	angles[17] = (0, -180, 0);
	at[17] = 1.8000;
	points[18] = (-2938.9604, 2933.0552, 2288.1104);
	angles[18] = (0, -180, 0);
	at[18] = 1.8500;
	points[19] = (-2938.9604, 2933.0552, 2327.2598);
	angles[19] = (0, -360, 0);
	at[19] = 1.9000;
	points[20] = (-2938.9604, 2933.0552, 2440.1340);
	angles[20] = (0, -360, 0);
	at[20] = 2.0500;
	points[21] = (-2938.9604, 2933.0552, 2511.3662);
	angles[21] = (0, -360, 0);
	at[21] = 2.1500;
	points[22] = (-2938.9604, 2933.0552, 2571.4214);
	angles[22] = (0, -360, 0);
	at[22] = 2.2500;
	points[23] = (-2938.9604, 2933.0552, 2594.7441);
	angles[23] = (0, -360, 0);
	at[23] = 2.3000;
	points[24] = (-2938.9604, 2933.0552, 2611.5864);
	angles[24] = (0, -360, 0);
	at[24] = 2.3500;
	points[25] = (-2938.9604, 2933.0552, 2623.3074);
	angles[25] = (0, -360, 0);
	at[25] = 2.4000;
	points[26] = (-2938.9604, 2934.1616, 2631.5356);
	angles[26] = (0, -360, 85.8614);
	at[26] = 2.4500;
	points[27] = (-2938.9604, 2935.7913, 2642.4409);
	angles[27] = (0, -360, 82.6518);
	at[27] = 2.5500;
	points[28] = (-2938.9604, 2936.3425, 2641.6182);
	angles[28] = (0, -360, 70.5617);
	at[28] = 2.6000;
	points[29] = (-2938.9604, 2937, 2637.1455);
	angles[29] = (0, -360, 39.1380);
	at[29] = 2.6500;
	points[30] = (-2938.9604, 2937.8464, 2631.3977);
	angles[30] = (0, -360, -3.3331);
	at[30] = 2.7000;
	points[31] = (-2938.9604, 2938.9331, 2624.0120);
	angles[31] = (0, -360, -37.9901);
	at[31] = 2.7500;
	points[32] = (-2938.9604, 2938.9604, 2614.2205);
	angles[32] = (0, -360, -62.4134);
	at[32] = 2.8000;
	points[33] = (-2938.9604, 2938.9604, 2600.8818);
	angles[33] = (0, -360, -75.7391);
	at[33] = 2.8500;
	points[34] = (-2938.9604, 2938.9604, 2582.7639);
	angles[34] = (0, -360, -82.6799);
	at[34] = 2.9000;
	points[35] = (-2938.9604, 2938.9604, 2558.4922);
	angles[35] = (0, -360, -86.2495);
	at[35] = 2.9500;
	points[36] = (-2938.9604, 2938.9604, 2528.7759);
	angles[36] = (0, -360, -88.0795);
	at[36] = 3;
	points[37] = (-2938.9604, 2938.9604, 2455.7283);
	angles[37] = (0, -360, -89.4965);
	at[37] = 3.1000;
	points[38] = (-2938.9604, 2938.9604, 2422.8464);
	angles[38] = (0, -360, -89.7422);
	at[38] = 3.1500;
	points[39] = (-2938.9604, 2938.9604, 2394.9172);
	angles[39] = (0, -360, -89.8680);
	at[39] = 3.2000;
	points[40] = (-2938.9604, 2938.9604, 2351.0513);
	angles[40] = (0, -360, -89.9654);
	at[40] = 3.3000;
	points[41] = (-2938.9604, 2938.9604, 2319.4094);
	angles[41] = (0, -360, -89.9910);
	at[41] = 3.4000;
	points[42] = (-2938.9604, 2938.9604, 2307.0669);
	angles[42] = (0, -360, 0);
	at[42] = 3.4500;
	points[43] = (-2938.9604, 2938.9604, 2296.5828);
	angles[43] = (0, -360, 0);
	at[43] = 3.5000;
	points[44] = (-2938.9604, 2938.9604, 2280.1182);
	angles[44] = (0, -360, 0);
	at[44] = 3.6000;
	points[45] = (-2938.9604, 2938.9604, 2268.2402);
	angles[45] = (0, -360, 0);
	at[45] = 3.7000;
	points[46] = (-2938.9604, 2938.9604, 2108.6614);
	angles[46] = (0, -360, 0);
	at[46] = 5.5000;
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
	points[0] = (2938.9604, 2938.9604, 2108.6614);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (2938.9604, 2938.9604, 2046.6536);
	angles[1] = (0, 0, 0);
	at[1] = 0.7000;
	points[2] = (2938.9604, 2938.1140, 2042.3190);
	angles[2] = (0, -180, -83.6256);
	at[2] = 0.7500;
	points[3] = (2938.9604, 2936.1064, 2033.6930);
	angles[3] = (0, -180, -78.6704);
	at[3] = 0.8500;
	points[4] = (2938.9604, 2935.1023, 2037.1576);
	angles[4] = (0, -180, -49.9564);
	at[4] = 0.9000;
	points[5] = (2938.9604, 2934.0984, 2041.4725);
	angles[5] = (0, -180, -8.0144);
	at[5] = 0.9500;
	points[6] = (2938.9604, 2933.0986, 2045.7834);
	angles[6] = (0, -180, 28.7661);
	at[6] = 1;
	points[7] = (2938.9604, 2933.0552, 2050.2087);
	angles[7] = (0, -180, 57.0461);
	at[7] = 1.0500;
	points[8] = (2938.9604, 2933.0552, 2054.6379);
	angles[8] = (0, -180, 72.8930);
	at[8] = 1.1000;
	points[9] = (2938.9604, 2933.0552, 2059.0669);
	angles[9] = (0, -180, 81.2090);
	at[9] = 1.1500;
	points[10] = (2938.9604, 2933.0552, 2063.5708);
	angles[10] = (0, -180, 85.4948);
	at[10] = 1.2000;
	points[11] = (2938.9604, 2933.0552, 2082.2441);
	angles[11] = (0, -180, 89.3951);
	at[11] = 1.3500;
	points[12] = (2938.9604, 2933.0552, 2101.0984);
	angles[12] = (0, -180, 89.8415);
	at[12] = 1.4500;
	points[13] = (2938.9604, 2933.0552, 2127.5000);
	angles[13] = (0, -180, 89.9584);
	at[13] = 1.5500;
	points[14] = (2938.9604, 2933.0552, 2164.4646);
	angles[14] = (0, -180, 89.9892);
	at[14] = 1.6500;
	points[15] = (2938.9604, 2933.0552, 2188.1772);
	angles[15] = (0, -180, 0);
	at[15] = 1.7000;
	points[16] = (2938.9604, 2933.0552, 2216.2324);
	angles[16] = (0, -180, 0);
	at[16] = 1.7500;
	points[17] = (2938.9604, 2933.0552, 2249.4331);
	angles[17] = (0, -180, 0);
	at[17] = 1.8000;
	points[18] = (2938.9604, 2933.0552, 2288.1104);
	angles[18] = (0, -180, 0);
	at[18] = 1.8500;
	points[19] = (2938.9604, 2933.0552, 2327.2598);
	angles[19] = (0, -360, 0);
	at[19] = 1.9000;
	points[20] = (2938.9604, 2933.0552, 2440.1340);
	angles[20] = (0, -360, 0);
	at[20] = 2.0500;
	points[21] = (2938.9604, 2933.0552, 2511.3662);
	angles[21] = (0, -360, 0);
	at[21] = 2.1500;
	points[22] = (2938.9604, 2933.0552, 2571.4214);
	angles[22] = (0, -360, 0);
	at[22] = 2.2500;
	points[23] = (2938.9604, 2933.0552, 2594.7441);
	angles[23] = (0, -360, 0);
	at[23] = 2.3000;
	points[24] = (2938.9604, 2933.0552, 2611.5864);
	angles[24] = (0, -360, 0);
	at[24] = 2.3500;
	points[25] = (2938.9604, 2933.0552, 2623.3074);
	angles[25] = (0, -360, 0);
	at[25] = 2.4000;
	points[26] = (2938.9604, 2934.1616, 2631.5356);
	angles[26] = (0, -360, 85.8614);
	at[26] = 2.4500;
	points[27] = (2938.9604, 2935.7913, 2642.4409);
	angles[27] = (0, -360, 82.6518);
	at[27] = 2.5500;
	points[28] = (2938.9604, 2936.3425, 2641.6182);
	angles[28] = (0, -360, 70.5617);
	at[28] = 2.6000;
	points[29] = (2938.9604, 2937, 2637.1455);
	angles[29] = (0, -360, 39.1380);
	at[29] = 2.6500;
	points[30] = (2938.9604, 2937.8464, 2631.3977);
	angles[30] = (0, -360, -3.3331);
	at[30] = 2.7000;
	points[31] = (2938.9604, 2938.9331, 2624.0120);
	angles[31] = (0, -360, -37.9901);
	at[31] = 2.7500;
	points[32] = (2938.9604, 2938.9604, 2614.2205);
	angles[32] = (0, -360, -62.4134);
	at[32] = 2.8000;
	points[33] = (2938.9604, 2938.9604, 2600.8818);
	angles[33] = (0, -360, -75.7391);
	at[33] = 2.8500;
	points[34] = (2938.9604, 2938.9604, 2582.7639);
	angles[34] = (0, -360, -82.6799);
	at[34] = 2.9000;
	points[35] = (2938.9604, 2938.9604, 2558.4922);
	angles[35] = (0, -360, -86.2495);
	at[35] = 2.9500;
	points[36] = (2938.9604, 2938.9604, 2528.7759);
	angles[36] = (0, -360, -88.0795);
	at[36] = 3;
	points[37] = (2938.9604, 2938.9604, 2455.7283);
	angles[37] = (0, -360, -89.4965);
	at[37] = 3.1000;
	points[38] = (2938.9604, 2938.9604, 2422.8464);
	angles[38] = (0, -360, -89.7422);
	at[38] = 3.1500;
	points[39] = (2938.9604, 2938.9604, 2394.9172);
	angles[39] = (0, -360, -89.8680);
	at[39] = 3.2000;
	points[40] = (2938.9604, 2938.9604, 2351.0513);
	angles[40] = (0, -360, -89.9654);
	at[40] = 3.3000;
	points[41] = (2938.9604, 2938.9604, 2319.4094);
	angles[41] = (0, -360, -89.9910);
	at[41] = 3.4000;
	points[42] = (2938.9604, 2938.9604, 2307.0669);
	angles[42] = (0, -360, 0);
	at[42] = 3.4500;
	points[43] = (2938.9604, 2938.9604, 2296.5828);
	angles[43] = (0, -360, 0);
	at[43] = 3.5000;
	points[44] = (2938.9604, 2938.9604, 2280.1182);
	angles[44] = (0, -360, 0);
	at[44] = 3.6000;
	points[45] = (2938.9604, 2938.9604, 2268.2402);
	angles[45] = (0, -360, 0);
	at[45] = 3.7000;
	points[46] = (2938.9604, 2938.9604, 2108.6614);
	angles[46] = (0, -360, 0);
	at[46] = 5.5000;
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
	points[0] = (-2938.9604, 0, 2108.6614);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2938.9604, 0, 2046.6536);
	angles[1] = (0, 0, 0);
	at[1] = 0.7000;
	points[2] = (-2938.1140, 0, 2042.3190);
	angles[2] = (0, -90, -83.6255);
	at[2] = 0.7500;
	points[3] = (-2936.1064, 0, 2033.6930);
	angles[3] = (0, -90, -78.6704);
	at[3] = 0.8500;
	points[4] = (-2935.1023, 0, 2037.1576);
	angles[4] = (0, -90, -49.9563);
	at[4] = 0.9000;
	points[5] = (-2934.0984, 0, 2041.4725);
	angles[5] = (0, -90, -8.0144);
	at[5] = 0.9500;
	points[6] = (-2933.0986, 0, 2045.7834);
	angles[6] = (0, -90, 28.7662);
	at[6] = 1;
	points[7] = (-2933.0552, 0, 2050.2087);
	angles[7] = (0, -90, 57.0461);
	at[7] = 1.0500;
	points[8] = (-2933.0552, 0, 2054.6379);
	angles[8] = (0, -90, 72.8932);
	at[8] = 1.1000;
	points[9] = (-2933.0552, 0, 2059.0669);
	angles[9] = (0, -90, 81.2090);
	at[9] = 1.1500;
	points[10] = (-2933.0552, 0, 2063.5708);
	angles[10] = (0, -90, 85.4946);
	at[10] = 1.2000;
	points[11] = (-2933.0552, 0, 2082.2441);
	angles[11] = (0, -90, 89.3952);
	at[11] = 1.3500;
	points[12] = (-2933.0552, 0, 2101.0984);
	angles[12] = (0, -90, 89.8415);
	at[12] = 1.4500;
	points[13] = (-2933.0552, 0, 2127.5000);
	angles[13] = (0, -90, 89.9585);
	at[13] = 1.5500;
	points[14] = (-2933.0552, 0, 2164.4646);
	angles[14] = (0, -90, 89.9890);
	at[14] = 1.6500;
	points[15] = (-2933.0552, 0, 2188.1772);
	angles[15] = (0, -90, 0);
	at[15] = 1.7000;
	points[16] = (-2933.0552, 0, 2216.2324);
	angles[16] = (0, -90, 0);
	at[16] = 1.7500;
	points[17] = (-2933.0552, 0, 2249.4331);
	angles[17] = (0, -90, 0);
	at[17] = 1.8000;
	points[18] = (-2933.0552, 0, 2288.1104);
	angles[18] = (0, -90, 0);
	at[18] = 1.8500;
	points[19] = (-2933.0552, 0, 2327.2598);
	angles[19] = (0, 0, 0);
	at[19] = 1.9000;
	points[20] = (-2933.0552, 0, 2476.2834);
	angles[20] = (0, 0, 0);
	at[20] = 2.1000;
	points[21] = (-2933.0552, 0, 2543.0750);
	angles[21] = (0, 0, 0);
	at[21] = 2.2000;
	points[22] = (-2933.0552, 0, 2571.4214);
	angles[22] = (0, 0, 0);
	at[22] = 2.2500;
	points[23] = (-2933.0552, 0, 2594.7441);
	angles[23] = (0, 0, 0);
	at[23] = 2.3000;
	points[24] = (-2933.0552, 0, 2611.5864);
	angles[24] = (0, 0, 0);
	at[24] = 2.3500;
	points[25] = (-2933.0552, 0, 2623.3074);
	angles[25] = (0, 0, 0);
	at[25] = 2.4000;
	points[26] = (-2934.1616, 0, 2631.5356);
	angles[26] = (0, 90, 85.8612);
	at[26] = 2.4500;
	points[27] = (-2935.7913, 0, 2642.4409);
	angles[27] = (0, 90, 82.6519);
	at[27] = 2.5500;
	points[28] = (-2936.3425, 0, 2641.6182);
	angles[28] = (0, 90, 70.5617);
	at[28] = 2.6000;
	points[29] = (-2937, 0, 2637.1455);
	angles[29] = (0, 90, 39.1379);
	at[29] = 2.6500;
	points[30] = (-2937.8464, 0, 2631.3977);
	angles[30] = (0, 90, -3.3331);
	at[30] = 2.7000;
	points[31] = (-2938.9331, 0, 2624.0120);
	angles[31] = (0, 90, -37.9900);
	at[31] = 2.7500;
	points[32] = (-2938.9604, 0, 2614.2205);
	angles[32] = (0, 90, -62.4134);
	at[32] = 2.8000;
	points[33] = (-2938.9604, 0, 2600.8818);
	angles[33] = (0, 90, -75.7392);
	at[33] = 2.8500;
	points[34] = (-2938.9604, 0, 2582.7639);
	angles[34] = (0, 90, -82.6797);
	at[34] = 2.9000;
	points[35] = (-2938.9604, 0, 2558.4922);
	angles[35] = (0, 90, -86.2496);
	at[35] = 2.9500;
	points[36] = (-2938.9604, 0, 2528.7759);
	angles[36] = (0, 90, -88.0794);
	at[36] = 3;
	points[37] = (-2938.9604, 0, 2455.7283);
	angles[37] = (0, 90, -89.4964);
	at[37] = 3.1000;
	points[38] = (-2938.9604, 0, 2422.8464);
	angles[38] = (0, 90, -89.7422);
	at[38] = 3.1500;
	points[39] = (-2938.9604, 0, 2394.9172);
	angles[39] = (0, 90, -89.8681);
	at[39] = 3.2000;
	points[40] = (-2938.9604, 0, 2351.0513);
	angles[40] = (0, 90, -89.9654);
	at[40] = 3.3000;
	points[41] = (-2938.9604, 0, 2319.4094);
	angles[41] = (0, 90, -89.9908);
	at[41] = 3.4000;
	points[42] = (-2938.9604, 0, 2307.0669);
	angles[42] = (0, 90, 0);
	at[42] = 3.4500;
	points[43] = (-2938.9604, 0, 2296.5828);
	angles[43] = (0, 90, 0);
	at[43] = 3.5000;
	points[44] = (-2938.9604, 0, 2280.1182);
	angles[44] = (0, 90, 0);
	at[44] = 3.6000;
	points[45] = (-2938.9604, 0, 2273.6929);
	angles[45] = (0, 0, 0);
	at[45] = 3.6500;
	points[46] = (-2938.9604, 0, 2108.6614);
	angles[46] = (0, 0, 0);
	at[46] = 5.5000;
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
	points[0] = (2938.9604, 0, 2108.6614);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (2938.9604, 0, 2046.6536);
	angles[1] = (0, 0, 0);
	at[1] = 0.7000;
	points[2] = (2938.1140, 0, 2042.3190);
	angles[2] = (0, 90, -83.6255);
	at[2] = 0.7500;
	points[3] = (2936.1064, 0, 2033.6930);
	angles[3] = (0, 90, -78.6704);
	at[3] = 0.8500;
	points[4] = (2935.1023, 0, 2037.1576);
	angles[4] = (0, 90, -49.9563);
	at[4] = 0.9000;
	points[5] = (2934.0984, 0, 2041.4725);
	angles[5] = (0, 90, -8.0144);
	at[5] = 0.9500;
	points[6] = (2933.0986, 0, 2045.7834);
	angles[6] = (0, 90, 28.7662);
	at[6] = 1;
	points[7] = (2933.0552, 0, 2050.2087);
	angles[7] = (0, 90, 57.0461);
	at[7] = 1.0500;
	points[8] = (2933.0552, 0, 2054.6379);
	angles[8] = (0, 90, 72.8932);
	at[8] = 1.1000;
	points[9] = (2933.0552, 0, 2059.0669);
	angles[9] = (0, 90, 81.2090);
	at[9] = 1.1500;
	points[10] = (2933.0552, 0, 2063.5708);
	angles[10] = (0, 90, 85.4946);
	at[10] = 1.2000;
	points[11] = (2933.0552, 0, 2082.2441);
	angles[11] = (0, 90, 89.3952);
	at[11] = 1.3500;
	points[12] = (2933.0552, 0, 2101.0984);
	angles[12] = (0, 90, 89.8415);
	at[12] = 1.4500;
	points[13] = (2933.0552, 0, 2127.5000);
	angles[13] = (0, 90, 89.9585);
	at[13] = 1.5500;
	points[14] = (2933.0552, 0, 2164.4646);
	angles[14] = (0, 90, 89.9890);
	at[14] = 1.6500;
	points[15] = (2933.0552, 0, 2188.1772);
	angles[15] = (0, 90, 0);
	at[15] = 1.7000;
	points[16] = (2933.0552, 0, 2216.2324);
	angles[16] = (0, 90, 0);
	at[16] = 1.7500;
	points[17] = (2933.0552, 0, 2249.4331);
	angles[17] = (0, 90, 0);
	at[17] = 1.8000;
	points[18] = (2933.0552, 0, 2288.1104);
	angles[18] = (0, 90, 0);
	at[18] = 1.8500;
	points[19] = (2933.0552, 0, 2327.2598);
	angles[19] = (0, 0, 0);
	at[19] = 1.9000;
	points[20] = (2933.0552, 0, 2476.2834);
	angles[20] = (0, 0, 0);
	at[20] = 2.1000;
	points[21] = (2933.0552, 0, 2543.0750);
	angles[21] = (0, 0, 0);
	at[21] = 2.2000;
	points[22] = (2933.0552, 0, 2571.4214);
	angles[22] = (0, 0, 0);
	at[22] = 2.2500;
	points[23] = (2933.0552, 0, 2594.7441);
	angles[23] = (0, 0, 0);
	at[23] = 2.3000;
	points[24] = (2933.0552, 0, 2611.5864);
	angles[24] = (0, 0, 0);
	at[24] = 2.3500;
	points[25] = (2933.0552, 0, 2623.3074);
	angles[25] = (0, 0, 0);
	at[25] = 2.4000;
	points[26] = (2934.1616, 0, 2631.5356);
	angles[26] = (0, -90, 85.8612);
	at[26] = 2.4500;
	points[27] = (2935.7913, 0, 2642.4409);
	angles[27] = (0, -90, 82.6519);
	at[27] = 2.5500;
	points[28] = (2936.3425, 0, 2641.6182);
	angles[28] = (0, -90, 70.5617);
	at[28] = 2.6000;
	points[29] = (2937, 0, 2637.1455);
	angles[29] = (0, -90, 39.1379);
	at[29] = 2.6500;
	points[30] = (2937.8464, 0, 2631.3977);
	angles[30] = (0, -90, -3.3331);
	at[30] = 2.7000;
	points[31] = (2938.9331, 0, 2624.0120);
	angles[31] = (0, -90, -37.9900);
	at[31] = 2.7500;
	points[32] = (2938.9604, 0, 2614.2205);
	angles[32] = (0, -90, -62.4134);
	at[32] = 2.8000;
	points[33] = (2938.9604, 0, 2600.8818);
	angles[33] = (0, -90, -75.7392);
	at[33] = 2.8500;
	points[34] = (2938.9604, 0, 2582.7639);
	angles[34] = (0, -90, -82.6797);
	at[34] = 2.9000;
	points[35] = (2938.9604, 0, 2558.4922);
	angles[35] = (0, -90, -86.2496);
	at[35] = 2.9500;
	points[36] = (2938.9604, 0, 2528.7759);
	angles[36] = (0, -90, -88.0794);
	at[36] = 3;
	points[37] = (2938.9604, 0, 2455.7283);
	angles[37] = (0, -90, -89.4964);
	at[37] = 3.1000;
	points[38] = (2938.9604, 0, 2422.8464);
	angles[38] = (0, -90, -89.7422);
	at[38] = 3.1500;
	points[39] = (2938.9604, 0, 2394.9172);
	angles[39] = (0, -90, -89.8681);
	at[39] = 3.2000;
	points[40] = (2938.9604, 0, 2351.0513);
	angles[40] = (0, -90, -89.9654);
	at[40] = 3.3000;
	points[41] = (2938.9604, 0, 2319.4094);
	angles[41] = (0, -90, -89.9908);
	at[41] = 3.4000;
	points[42] = (2938.9604, 0, 2307.0669);
	angles[42] = (0, -90, 0);
	at[42] = 3.4500;
	points[43] = (2938.9604, 0, 2296.5828);
	angles[43] = (0, -90, 0);
	at[43] = 3.5000;
	points[44] = (2938.9604, 0, 2280.1182);
	angles[44] = (0, -90, 0);
	at[44] = 3.6000;
	points[45] = (2938.9604, 0, 2273.6929);
	angles[45] = (0, 0, 0);
	at[45] = 3.6500;
	points[46] = (2938.9604, 0, 2108.6614);
	angles[46] = (0, 0, 0);
	at[46] = 5.5000;
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
	points[0] = (-2938.9604, -2938.9604, 2108.6614);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2938.9604, -2938.9604, 2046.6536);
	angles[1] = (0, 0, 0);
	at[1] = 0.7000;
	points[2] = (-2938.9604, -2938.1140, 2042.3190);
	angles[2] = (0, 0, -83.6256);
	at[2] = 0.7500;
	points[3] = (-2938.9604, -2936.1064, 2033.6930);
	angles[3] = (0, 0, -78.6704);
	at[3] = 0.8500;
	points[4] = (-2938.9604, -2935.1023, 2037.1576);
	angles[4] = (0, 0, -49.9564);
	at[4] = 0.9000;
	points[5] = (-2938.9604, -2934.0984, 2041.4725);
	angles[5] = (0, 0, -8.0144);
	at[5] = 0.9500;
	points[6] = (-2938.9604, -2933.0986, 2045.7834);
	angles[6] = (0, 0, 28.7661);
	at[6] = 1;
	points[7] = (-2938.9604, -2933.0552, 2050.2087);
	angles[7] = (0, 0, 57.0461);
	at[7] = 1.0500;
	points[8] = (-2938.9604, -2933.0552, 2054.6379);
	angles[8] = (0, 0, 72.8930);
	at[8] = 1.1000;
	points[9] = (-2938.9604, -2933.0552, 2059.0669);
	angles[9] = (0, 0, 81.2090);
	at[9] = 1.1500;
	points[10] = (-2938.9604, -2933.0552, 2063.5708);
	angles[10] = (0, 0, 85.4948);
	at[10] = 1.2000;
	points[11] = (-2938.9604, -2933.0552, 2082.2441);
	angles[11] = (0, 0, 89.3951);
	at[11] = 1.3500;
	points[12] = (-2938.9604, -2933.0552, 2101.0984);
	angles[12] = (0, 0, 89.8415);
	at[12] = 1.4500;
	points[13] = (-2938.9604, -2933.0552, 2127.5000);
	angles[13] = (0, 0, 89.9584);
	at[13] = 1.5500;
	points[14] = (-2938.9604, -2933.0552, 2164.4646);
	angles[14] = (0, 0, 89.9892);
	at[14] = 1.6500;
	points[15] = (-2938.9604, -2933.0552, 2188.1772);
	angles[15] = (0, 0, 0);
	at[15] = 1.7000;
	points[16] = (-2938.9604, -2933.0552, 2216.2324);
	angles[16] = (0, 0, 0);
	at[16] = 1.7500;
	points[17] = (-2938.9604, -2933.0552, 2249.4331);
	angles[17] = (0, 0, 0);
	at[17] = 1.8000;
	points[18] = (-2938.9604, -2933.0552, 2440.1340);
	angles[18] = (0, 0, 0);
	at[18] = 2.0500;
	points[19] = (-2938.9604, -2933.0552, 2511.3662);
	angles[19] = (0, 0, 0);
	at[19] = 2.1500;
	points[20] = (-2938.9604, -2933.0552, 2543.0750);
	angles[20] = (0, 0, 0);
	at[20] = 2.2000;
	points[21] = (-2938.9604, -2933.0552, 2571.4214);
	angles[21] = (0, 0, 0);
	at[21] = 2.2500;
	points[22] = (-2938.9604, -2933.0552, 2594.7441);
	angles[22] = (0, 0, 0);
	at[22] = 2.3000;
	points[23] = (-2938.9604, -2933.0552, 2611.5864);
	angles[23] = (0, 0, 0);
	at[23] = 2.3500;
	points[24] = (-2938.9604, -2933.0552, 2623.3074);
	angles[24] = (0, 0, 0);
	at[24] = 2.4000;
	points[25] = (-2938.9604, -2934.1616, 2631.5356);
	angles[25] = (0, -180, 85.8614);
	at[25] = 2.4500;
	points[26] = (-2938.9604, -2935.7913, 2642.4409);
	angles[26] = (0, -180, 82.6518);
	at[26] = 2.5500;
	points[27] = (-2938.9604, -2936.3425, 2641.6182);
	angles[27] = (0, -180, 70.5617);
	at[27] = 2.6000;
	points[28] = (-2938.9604, -2937, 2637.1455);
	angles[28] = (0, -180, 39.1380);
	at[28] = 2.6500;
	points[29] = (-2938.9604, -2937.8464, 2631.3977);
	angles[29] = (0, -180, -3.3331);
	at[29] = 2.7000;
	points[30] = (-2938.9604, -2938.9331, 2624.0120);
	angles[30] = (0, -180, -37.9901);
	at[30] = 2.7500;
	points[31] = (-2938.9604, -2938.9604, 2614.2205);
	angles[31] = (0, -180, -62.4134);
	at[31] = 2.8000;
	points[32] = (-2938.9604, -2938.9604, 2600.8818);
	angles[32] = (0, -180, -75.7391);
	at[32] = 2.8500;
	points[33] = (-2938.9604, -2938.9604, 2582.7639);
	angles[33] = (0, -180, -82.6799);
	at[33] = 2.9000;
	points[34] = (-2938.9604, -2938.9604, 2558.4922);
	angles[34] = (0, -180, -86.2495);
	at[34] = 2.9500;
	points[35] = (-2938.9604, -2938.9604, 2528.7759);
	angles[35] = (0, -180, -88.0795);
	at[35] = 3;
	points[36] = (-2938.9604, -2938.9604, 2455.7283);
	angles[36] = (0, -180, -89.4965);
	at[36] = 3.1000;
	points[37] = (-2938.9604, -2938.9604, 2422.8464);
	angles[37] = (0, -180, -89.7422);
	at[37] = 3.1500;
	points[38] = (-2938.9604, -2938.9604, 2394.9172);
	angles[38] = (0, -180, -89.8680);
	at[38] = 3.2000;
	points[39] = (-2938.9604, -2938.9604, 2351.0513);
	angles[39] = (0, -180, -89.9654);
	at[39] = 3.3000;
	points[40] = (-2938.9604, -2938.9604, 2319.4094);
	angles[40] = (0, -180, -89.9910);
	at[40] = 3.4000;
	points[41] = (-2938.9604, -2938.9604, 2307.0669);
	angles[41] = (0, -180, 0);
	at[41] = 3.4500;
	points[42] = (-2938.9604, -2938.9604, 2296.5828);
	angles[42] = (0, -180, 0);
	at[42] = 3.5000;
	points[43] = (-2938.9604, -2938.9604, 2280.1182);
	angles[43] = (0, -180, 0);
	at[43] = 3.6000;
	points[44] = (-2938.9604, -2938.9604, 2273.6929);
	angles[44] = (0, -360, 0);
	at[44] = 3.6500;
	points[45] = (-2938.9604, -2938.9604, 2108.6614);
	angles[45] = (0, -360, 0);
	at[45] = 5.5000;
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
	points[0] = (2938.9604, -2938.9604, 2108.6614);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (2938.9604, -2938.9604, 2046.6536);
	angles[1] = (0, 0, 0);
	at[1] = 0.7000;
	points[2] = (2938.9604, -2938.1140, 2042.3190);
	angles[2] = (0, 0, -83.6256);
	at[2] = 0.7500;
	points[3] = (2938.9604, -2936.1064, 2033.6930);
	angles[3] = (0, 0, -78.6704);
	at[3] = 0.8500;
	points[4] = (2938.9604, -2935.1023, 2037.1576);
	angles[4] = (0, 0, -49.9564);
	at[4] = 0.9000;
	points[5] = (2938.9604, -2934.0984, 2041.4725);
	angles[5] = (0, 0, -8.0144);
	at[5] = 0.9500;
	points[6] = (2938.9604, -2933.0986, 2045.7834);
	angles[6] = (0, 0, 28.7661);
	at[6] = 1;
	points[7] = (2938.9604, -2933.0552, 2050.2087);
	angles[7] = (0, 0, 57.0461);
	at[7] = 1.0500;
	points[8] = (2938.9604, -2933.0552, 2054.6379);
	angles[8] = (0, 0, 72.8930);
	at[8] = 1.1000;
	points[9] = (2938.9604, -2933.0552, 2059.0669);
	angles[9] = (0, 0, 81.2090);
	at[9] = 1.1500;
	points[10] = (2938.9604, -2933.0552, 2063.5708);
	angles[10] = (0, 0, 85.4948);
	at[10] = 1.2000;
	points[11] = (2938.9604, -2933.0552, 2082.2441);
	angles[11] = (0, 0, 89.3951);
	at[11] = 1.3500;
	points[12] = (2938.9604, -2933.0552, 2101.0984);
	angles[12] = (0, 0, 89.8415);
	at[12] = 1.4500;
	points[13] = (2938.9604, -2933.0552, 2127.5000);
	angles[13] = (0, 0, 89.9584);
	at[13] = 1.5500;
	points[14] = (2938.9604, -2933.0552, 2164.4646);
	angles[14] = (0, 0, 89.9892);
	at[14] = 1.6500;
	points[15] = (2938.9604, -2933.0552, 2188.1772);
	angles[15] = (0, 0, 0);
	at[15] = 1.7000;
	points[16] = (2938.9604, -2933.0552, 2216.2324);
	angles[16] = (0, 0, 0);
	at[16] = 1.7500;
	points[17] = (2938.9604, -2933.0552, 2249.4331);
	angles[17] = (0, 0, 0);
	at[17] = 1.8000;
	points[18] = (2938.9604, -2933.0552, 2440.1340);
	angles[18] = (0, 0, 0);
	at[18] = 2.0500;
	points[19] = (2938.9604, -2933.0552, 2511.3662);
	angles[19] = (0, 0, 0);
	at[19] = 2.1500;
	points[20] = (2938.9604, -2933.0552, 2543.0750);
	angles[20] = (0, 0, 0);
	at[20] = 2.2000;
	points[21] = (2938.9604, -2933.0552, 2571.4214);
	angles[21] = (0, 0, 0);
	at[21] = 2.2500;
	points[22] = (2938.9604, -2933.0552, 2594.7441);
	angles[22] = (0, 0, 0);
	at[22] = 2.3000;
	points[23] = (2938.9604, -2933.0552, 2611.5864);
	angles[23] = (0, 0, 0);
	at[23] = 2.3500;
	points[24] = (2938.9604, -2933.0552, 2623.3074);
	angles[24] = (0, 0, 0);
	at[24] = 2.4000;
	points[25] = (2938.9604, -2934.1616, 2631.5356);
	angles[25] = (0, -180, 85.8614);
	at[25] = 2.4500;
	points[26] = (2938.9604, -2935.7913, 2642.4409);
	angles[26] = (0, -180, 82.6518);
	at[26] = 2.5500;
	points[27] = (2938.9604, -2936.3425, 2641.6182);
	angles[27] = (0, -180, 70.5617);
	at[27] = 2.6000;
	points[28] = (2938.9604, -2937, 2637.1455);
	angles[28] = (0, -180, 39.1380);
	at[28] = 2.6500;
	points[29] = (2938.9604, -2937.8464, 2631.3977);
	angles[29] = (0, -180, -3.3331);
	at[29] = 2.7000;
	points[30] = (2938.9604, -2938.9331, 2624.0120);
	angles[30] = (0, -180, -37.9901);
	at[30] = 2.7500;
	points[31] = (2938.9604, -2938.9604, 2614.2205);
	angles[31] = (0, -180, -62.4134);
	at[31] = 2.8000;
	points[32] = (2938.9604, -2938.9604, 2600.8818);
	angles[32] = (0, -180, -75.7391);
	at[32] = 2.8500;
	points[33] = (2938.9604, -2938.9604, 2582.7639);
	angles[33] = (0, -180, -82.6799);
	at[33] = 2.9000;
	points[34] = (2938.9604, -2938.9604, 2558.4922);
	angles[34] = (0, -180, -86.2495);
	at[34] = 2.9500;
	points[35] = (2938.9604, -2938.9604, 2528.7759);
	angles[35] = (0, -180, -88.0795);
	at[35] = 3;
	points[36] = (2938.9604, -2938.9604, 2455.7283);
	angles[36] = (0, -180, -89.4965);
	at[36] = 3.1000;
	points[37] = (2938.9604, -2938.9604, 2422.8464);
	angles[37] = (0, -180, -89.7422);
	at[37] = 3.1500;
	points[38] = (2938.9604, -2938.9604, 2394.9172);
	angles[38] = (0, -180, -89.8680);
	at[38] = 3.2000;
	points[39] = (2938.9604, -2938.9604, 2351.0513);
	angles[39] = (0, -180, -89.9654);
	at[39] = 3.3000;
	points[40] = (2938.9604, -2938.9604, 2319.4094);
	angles[40] = (0, -180, -89.9910);
	at[40] = 3.4000;
	points[41] = (2938.9604, -2938.9604, 2307.0669);
	angles[41] = (0, -180, 0);
	at[41] = 3.4500;
	points[42] = (2938.9604, -2938.9604, 2296.5828);
	angles[42] = (0, -180, 0);
	at[42] = 3.5000;
	points[43] = (2938.9604, -2938.9604, 2280.1182);
	angles[43] = (0, -180, 0);
	at[43] = 3.6000;
	points[44] = (2938.9604, -2938.9604, 2273.6929);
	angles[44] = (0, -360, 0);
	at[44] = 3.6500;
	points[45] = (2938.9604, -2938.9604, 2108.6614);
	angles[45] = (0, -360, 0);
	at[45] = 5.5000;
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
	points[0] = (0, -2938.9604, 2108.6614);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (0, -2938.9604, 2046.6536);
	angles[1] = (0, 0, 0);
	at[1] = 0.7000;
	points[2] = (0, -2938.1140, 2042.3190);
	angles[2] = (0, 0, -83.6256);
	at[2] = 0.7500;
	points[3] = (0, -2936.1064, 2033.6930);
	angles[3] = (0, 0, -78.6704);
	at[3] = 0.8500;
	points[4] = (0, -2935.1023, 2037.1576);
	angles[4] = (0, 0, -49.9564);
	at[4] = 0.9000;
	points[5] = (0, -2934.0984, 2041.4725);
	angles[5] = (0, 0, -8.0144);
	at[5] = 0.9500;
	points[6] = (0, -2933.0986, 2045.7834);
	angles[6] = (0, 0, 28.7661);
	at[6] = 1;
	points[7] = (0, -2933.0552, 2050.2087);
	angles[7] = (0, 0, 57.0461);
	at[7] = 1.0500;
	points[8] = (0, -2933.0552, 2054.6379);
	angles[8] = (0, 0, 72.8930);
	at[8] = 1.1000;
	points[9] = (0, -2933.0552, 2059.0669);
	angles[9] = (0, 0, 81.2090);
	at[9] = 1.1500;
	points[10] = (0, -2933.0552, 2063.5708);
	angles[10] = (0, 0, 85.4948);
	at[10] = 1.2000;
	points[11] = (0, -2933.0552, 2082.2441);
	angles[11] = (0, 0, 89.3951);
	at[11] = 1.3500;
	points[12] = (0, -2933.0552, 2101.0984);
	angles[12] = (0, 0, 89.8415);
	at[12] = 1.4500;
	points[13] = (0, -2933.0552, 2127.5000);
	angles[13] = (0, 0, 89.9584);
	at[13] = 1.5500;
	points[14] = (0, -2933.0552, 2164.4646);
	angles[14] = (0, 0, 89.9892);
	at[14] = 1.6500;
	points[15] = (0, -2933.0552, 2188.1772);
	angles[15] = (0, 0, 0);
	at[15] = 1.7000;
	points[16] = (0, -2933.0552, 2216.2324);
	angles[16] = (0, 0, 0);
	at[16] = 1.7500;
	points[17] = (0, -2933.0552, 2249.4331);
	angles[17] = (0, 0, 0);
	at[17] = 1.8000;
	points[18] = (0, -2933.0552, 2440.1340);
	angles[18] = (0, 0, 0);
	at[18] = 2.0500;
	points[19] = (0, -2933.0552, 2511.3662);
	angles[19] = (0, 0, 0);
	at[19] = 2.1500;
	points[20] = (0, -2933.0552, 2543.0750);
	angles[20] = (0, 0, 0);
	at[20] = 2.2000;
	points[21] = (0, -2933.0552, 2571.4214);
	angles[21] = (0, 0, 0);
	at[21] = 2.2500;
	points[22] = (0, -2933.0552, 2594.7441);
	angles[22] = (0, 0, 0);
	at[22] = 2.3000;
	points[23] = (0, -2933.0552, 2611.5864);
	angles[23] = (0, 0, 0);
	at[23] = 2.3500;
	points[24] = (0, -2933.0552, 2623.3074);
	angles[24] = (0, 0, 0);
	at[24] = 2.4000;
	points[25] = (0, -2934.1616, 2631.5356);
	angles[25] = (0, -180, 85.8614);
	at[25] = 2.4500;
	points[26] = (0, -2935.7913, 2642.4409);
	angles[26] = (0, -180, 82.6518);
	at[26] = 2.5500;
	points[27] = (0, -2936.3425, 2641.6182);
	angles[27] = (0, -180, 70.5617);
	at[27] = 2.6000;
	points[28] = (0, -2937, 2637.1455);
	angles[28] = (0, -180, 39.1380);
	at[28] = 2.6500;
	points[29] = (0, -2937.8464, 2631.3977);
	angles[29] = (0, -180, -3.3331);
	at[29] = 2.7000;
	points[30] = (0, -2938.9331, 2624.0120);
	angles[30] = (0, -180, -37.9901);
	at[30] = 2.7500;
	points[31] = (0, -2938.9604, 2614.2205);
	angles[31] = (0, -180, -62.4134);
	at[31] = 2.8000;
	points[32] = (0, -2938.9604, 2600.8818);
	angles[32] = (0, -180, -75.7391);
	at[32] = 2.8500;
	points[33] = (0, -2938.9604, 2582.7639);
	angles[33] = (0, -180, -82.6799);
	at[33] = 2.9000;
	points[34] = (0, -2938.9604, 2558.4922);
	angles[34] = (0, -180, -86.2495);
	at[34] = 2.9500;
	points[35] = (0, -2938.9604, 2528.7759);
	angles[35] = (0, -180, -88.0795);
	at[35] = 3;
	points[36] = (0, -2938.9604, 2455.7283);
	angles[36] = (0, -180, -89.4965);
	at[36] = 3.1000;
	points[37] = (0, -2938.9604, 2422.8464);
	angles[37] = (0, -180, -89.7422);
	at[37] = 3.1500;
	points[38] = (0, -2938.9604, 2394.9172);
	angles[38] = (0, -180, -89.8680);
	at[38] = 3.2000;
	points[39] = (0, -2938.9604, 2351.0513);
	angles[39] = (0, -180, -89.9654);
	at[39] = 3.3000;
	points[40] = (0, -2938.9604, 2319.4094);
	angles[40] = (0, -180, -89.9910);
	at[40] = 3.4000;
	points[41] = (0, -2938.9604, 2307.0669);
	angles[41] = (0, -180, 0);
	at[41] = 3.4500;
	points[42] = (0, -2938.9604, 2296.5828);
	angles[42] = (0, -180, 0);
	at[42] = 3.5000;
	points[43] = (0, -2938.9604, 2280.1182);
	angles[43] = (0, -180, 0);
	at[43] = 3.6000;
	points[44] = (0, -2938.9604, 2273.6929);
	angles[44] = (0, -360, 0);
	at[44] = 3.6500;
	points[45] = (0, -2938.9604, 2108.6614);
	angles[45] = (0, -360, 0);
	at[45] = 5.5000;
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
