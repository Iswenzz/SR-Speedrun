main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_gcn_bowserscastle_b", 0);

	setExpFog(5905.5117, 64960.6250, 1, 0.4314, 0, 0);

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
	ambientPlay("iz_0_gcnboc", 2);
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
	level.iz_route[level.iz_route.size] = (-1190, -1357, 3289);
	level.iz_route[level.iz_route.size] = (-1753, -1161, 3289);
	level.iz_route[level.iz_route.size] = (-2380, -1201, 3289);
	level.iz_route[level.iz_route.size] = (-2710, -1553, 3289);
	level.iz_route[level.iz_route.size] = (-2725, -2146, 3289);
	level.iz_route[level.iz_route.size] = (-2639, -2826, 3310);
	level.iz_route[level.iz_route.size] = (-2531, -3630, 3376);
	level.iz_route[level.iz_route.size] = (-2459, -4158, 3376);
	level.iz_route[level.iz_route.size] = (-2483, -4778, 3376);
	level.iz_route[level.iz_route.size] = (-2515, -5668, 3376);
	level.iz_route[level.iz_route.size] = (-2536, -6881, 3376);
	level.iz_route[level.iz_route.size] = (-2505, -8066, 3376);
	level.iz_route[level.iz_route.size] = (-2341, -8904, 3376);
	level.iz_route[level.iz_route.size] = (-2095, -9533, 3376);
	level.iz_route[level.iz_route.size] = (-1747, -9728, 3376);
	level.iz_route[level.iz_route.size] = (-1455, -9619, 3376);
	level.iz_route[level.iz_route.size] = (-1310, -9390, 3376);
	level.iz_route[level.iz_route.size] = (-1166, -9142, 3376);
	level.iz_route[level.iz_route.size] = (-1090, -8736, 3376);
	level.iz_route[level.iz_route.size] = (-1046, -7926, 3376);
	level.iz_route[level.iz_route.size] = (-1041, -6489, 3376);
	level.iz_route[level.iz_route.size] = (-1003, -5509, 3376);
	level.iz_route[level.iz_route.size] = (-1035, -4567, 3376);
	level.iz_route[level.iz_route.size] = (-983, -3990, 3376);
	level.iz_route[level.iz_route.size] = (-923, -3387, 3376);
	level.iz_route[level.iz_route.size] = (-918, -3009, 3348);
	level.iz_route[level.iz_route.size] = (-942, -2570, 3289);
	level.iz_route[level.iz_route.size] = (-931, -2103, 3289);
	level.iz_route[level.iz_route.size] = (-916, -1752, 3289);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-1092.4528, -6212.8745, 3543.3071);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-1092.4528, -6212.8745, 3543.3071);
	angles[1] = (0, 0, 0);
	at[1] = 0.4500;
	points[2] = (-1092.4528, -6212.8745, 3550.9805);
	angles[2] = (0, 0, 0);
	at[2] = 0.5000;
	points[3] = (-1092.4528, -6212.8745, 3547.7363);
	angles[3] = (0, 0, 0);
	at[3] = 0.5500;
	points[4] = (-1092.4528, -6212.8745, 3535.6338);
	angles[4] = (0, 0, 0);
	at[4] = 0.6000;
	points[5] = (-1092.4528, -6212.8745, 3538.8779);
	angles[5] = (0, 0, 0);
	at[5] = 0.6500;
	points[6] = (-1092.4528, -6212.8745, 3550.9805);
	angles[6] = (0, 0, 0);
	at[6] = 0.7000;
	points[7] = (-1092.4528, -6212.8745, 3547.7363);
	angles[7] = (0, 0, 0);
	at[7] = 0.7500;
	points[8] = (-1092.4528, -6212.8745, 3535.6338);
	angles[8] = (0, 0, 0);
	at[8] = 0.8000;
	points[9] = (-1092.4528, -6212.8745, 3538.8779);
	angles[9] = (0, 0, 0);
	at[9] = 0.8500;
	points[10] = (-1092.4528, -6212.8745, 3550.9805);
	angles[10] = (0, 0, 0);
	at[10] = 0.9000;
	points[11] = (-1092.4528, -6212.8745, 3547.7363);
	angles[11] = (0, 0, 0);
	at[11] = 0.9500;
	points[12] = (-1092.4528, -6212.8745, 3553.6416);
	angles[12] = (0, 0, 0);
	at[12] = 1;
	points[13] = (-1092.4528, -6212.8745, 3686.5156);
	angles[13] = (0, 0, 0);
	at[13] = 1.1500;
	points[14] = (-1092.4528, -6212.8745, 3656.3977);
	angles[14] = (0, 0, 0);
	at[14] = 1.2000;
	points[15] = (-1092.4528, -6212.8745, 3581.1023);
	angles[15] = (0, 0, 0);
	at[15] = 1.2500;
	points[16] = (-1092.4528, -6212.8745, 3460.6301);
	angles[16] = (0, 0, 0);
	at[16] = 1.3000;
	points[17] = (-1092.4528, -6212.8745, 3376.3110);
	angles[17] = (0, 0, 0);
	at[17] = 1.3500;
	points[18] = (-1092.4528, -6212.8745, 3376.3110);
	angles[18] = (0, 0, 0);
	at[18] = 2.3000;
	points[19] = (-1092.4528, -6212.8745, 3379.2637);
	angles[19] = (0, 0, 0);
	at[19] = 2.3500;
	points[20] = (-1092.4528, -6212.8745, 3538.7126);
	angles[20] = (0, 0, 0);
	at[20] = 3.2500;
	points[21] = (-1092.4528, -6212.8745, 3543.3071);
	angles[21] = (0, 0, 0);
	at[21] = 3.3000;
	points[22] = (-1092.4528, -6212.8745, 3543.3071);
	angles[22] = (0, 0, 0);
	at[22] = 3.8000;
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
	points[0] = (-1092.4528, -7866.1421, 3550.9805);
	angles[0] = (0, -180, 0);
	at[0] = 0;
	points[1] = (-1092.4528, -7866.1421, 3547.7363);
	angles[1] = (0, -180, 0);
	at[1] = 0.0500;
	points[2] = (-1092.4528, -7866.1421, 3535.6338);
	angles[2] = (0, -180, 0);
	at[2] = 0.1000;
	points[3] = (-1092.4528, -7866.1421, 3538.8779);
	angles[3] = (0, -180, 0);
	at[3] = 0.1500;
	points[4] = (-1092.4528, -7866.1421, 3550.9805);
	angles[4] = (0, -180, 0);
	at[4] = 0.2000;
	points[5] = (-1092.4528, -7866.1421, 3547.7363);
	angles[5] = (0, -180, 0);
	at[5] = 0.2500;
	points[6] = (-1092.4528, -7866.1421, 3535.6338);
	angles[6] = (0, -180, 0);
	at[6] = 0.3000;
	points[7] = (-1092.4528, -7866.1421, 3538.8779);
	angles[7] = (0, -180, 0);
	at[7] = 0.3500;
	points[8] = (-1092.4528, -7866.1421, 3550.9805);
	angles[8] = (0, -180, 0);
	at[8] = 0.4000;
	points[9] = (-1092.4528, -7866.1421, 3547.7363);
	angles[9] = (0, -180, 0);
	at[9] = 0.4500;
	points[10] = (-1092.4528, -7866.1421, 3553.6416);
	angles[10] = (0, -180, 0);
	at[10] = 0.5000;
	points[11] = (-1092.4528, -7866.1421, 3686.5156);
	angles[11] = (0, -180, 0);
	at[11] = 0.6500;
	points[12] = (-1092.4528, -7866.1421, 3656.3977);
	angles[12] = (0, -180, 0);
	at[12] = 0.7000;
	points[13] = (-1092.4528, -7866.1421, 3581.1023);
	angles[13] = (0, -180, 0);
	at[13] = 0.7500;
	points[14] = (-1092.4528, -7866.1421, 3460.6301);
	angles[14] = (0, -180, 0);
	at[14] = 0.8000;
	points[15] = (-1092.4528, -7866.1421, 3376.3110);
	angles[15] = (0, -180, 0);
	at[15] = 0.8500;
	points[16] = (-1092.4528, -7866.1421, 3376.3110);
	angles[16] = (0, -180, 0);
	at[16] = 1.8000;
	points[17] = (-1092.4528, -7866.1421, 3379.2637);
	angles[17] = (0, -180, 0);
	at[17] = 1.8500;
	points[18] = (-1092.4528, -7866.1421, 3538.7126);
	angles[18] = (0, -180, 0);
	at[18] = 2.7500;
	points[19] = (-1092.4528, -7866.1421, 3543.3071);
	angles[19] = (0, -180, 0);
	at[19] = 2.8000;
	points[20] = (-1092.4528, -7866.1421, 3543.3071);
	angles[20] = (0, -180, 0);
	at[20] = 3.7500;
	points[21] = (-1092.4528, -7866.1421, 3550.9805);
	angles[21] = (0, -180, 0);
	at[21] = 3.8000;
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
	points[0] = (-2408.9961, -6170.5122, 3550.9805);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2408.9961, -6170.5122, 3547.7363);
	angles[1] = (0, 0, 0);
	at[1] = 0.0500;
	points[2] = (-2408.9961, -6170.5122, 3535.6338);
	angles[2] = (0, 0, 0);
	at[2] = 0.1000;
	points[3] = (-2408.9961, -6170.5122, 3538.8779);
	angles[3] = (0, 0, 0);
	at[3] = 0.1500;
	points[4] = (-2408.9961, -6170.5122, 3550.9805);
	angles[4] = (0, 0, 0);
	at[4] = 0.2000;
	points[5] = (-2408.9961, -6170.5122, 3547.7363);
	angles[5] = (0, 0, 0);
	at[5] = 0.2500;
	points[6] = (-2408.9961, -6170.5122, 3535.6338);
	angles[6] = (0, 0, 0);
	at[6] = 0.3000;
	points[7] = (-2408.9961, -6170.5122, 3538.8779);
	angles[7] = (0, 0, 0);
	at[7] = 0.3500;
	points[8] = (-2408.9961, -6170.5122, 3550.9805);
	angles[8] = (0, 0, 0);
	at[8] = 0.4000;
	points[9] = (-2408.9961, -6170.5122, 3547.7363);
	angles[9] = (0, 0, 0);
	at[9] = 0.4500;
	points[10] = (-2408.9961, -6170.5122, 3553.6416);
	angles[10] = (0, 0, 0);
	at[10] = 0.5000;
	points[11] = (-2408.9961, -6170.5122, 3686.5156);
	angles[11] = (0, 0, 0);
	at[11] = 0.6500;
	points[12] = (-2408.9961, -6170.5122, 3656.3977);
	angles[12] = (0, 0, 0);
	at[12] = 0.7000;
	points[13] = (-2408.9961, -6170.5122, 3581.1023);
	angles[13] = (0, 0, 0);
	at[13] = 0.7500;
	points[14] = (-2408.9961, -6170.5122, 3460.6301);
	angles[14] = (0, 0, 0);
	at[14] = 0.8000;
	points[15] = (-2408.9961, -6170.5122, 3376.3110);
	angles[15] = (0, 0, 0);
	at[15] = 0.8500;
	points[16] = (-2408.9961, -6170.5122, 3376.3110);
	angles[16] = (0, 0, 0);
	at[16] = 1.8000;
	points[17] = (-2408.9961, -6170.5122, 3379.2637);
	angles[17] = (0, 0, 0);
	at[17] = 1.8500;
	points[18] = (-2408.9961, -6170.5122, 3538.7126);
	angles[18] = (0, 0, 0);
	at[18] = 2.7500;
	points[19] = (-2408.9961, -6170.5122, 3543.3071);
	angles[19] = (0, 0, 0);
	at[19] = 2.8000;
	points[20] = (-2408.9961, -6170.5122, 3543.3071);
	angles[20] = (0, 0, 0);
	at[20] = 3.7500;
	points[21] = (-2408.9961, -6170.5122, 3550.9805);
	angles[21] = (0, 0, 0);
	at[21] = 3.8000;
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
	points[0] = (-2408.9961, -7865.5903, 3543.3071);
	angles[0] = (0, -180, 0);
	at[0] = 0;
	points[1] = (-2408.9961, -7865.5903, 3543.3071);
	angles[1] = (0, -180, 0);
	at[1] = 0.4500;
	points[2] = (-2408.9961, -7865.5903, 3550.9805);
	angles[2] = (0, -180, 0);
	at[2] = 0.5000;
	points[3] = (-2408.9961, -7865.5903, 3547.7363);
	angles[3] = (0, -180, 0);
	at[3] = 0.5500;
	points[4] = (-2408.9961, -7865.5903, 3535.6338);
	angles[4] = (0, -180, 0);
	at[4] = 0.6000;
	points[5] = (-2408.9961, -7865.5903, 3538.8779);
	angles[5] = (0, -180, 0);
	at[5] = 0.6500;
	points[6] = (-2408.9961, -7865.5903, 3550.9805);
	angles[6] = (0, -180, 0);
	at[6] = 0.7000;
	points[7] = (-2408.9961, -7865.5903, 3547.7363);
	angles[7] = (0, -180, 0);
	at[7] = 0.7500;
	points[8] = (-2408.9961, -7865.5903, 3535.6338);
	angles[8] = (0, -180, 0);
	at[8] = 0.8000;
	points[9] = (-2408.9961, -7865.5903, 3538.8779);
	angles[9] = (0, -180, 0);
	at[9] = 0.8500;
	points[10] = (-2408.9961, -7865.5903, 3550.9805);
	angles[10] = (0, -180, 0);
	at[10] = 0.9000;
	points[11] = (-2408.9961, -7865.5903, 3547.7363);
	angles[11] = (0, -180, 0);
	at[11] = 0.9500;
	points[12] = (-2408.9961, -7865.5903, 3553.6416);
	angles[12] = (0, -180, 0);
	at[12] = 1;
	points[13] = (-2408.9961, -7865.5903, 3686.5156);
	angles[13] = (0, -180, 0);
	at[13] = 1.1500;
	points[14] = (-2408.9961, -7865.5903, 3656.3977);
	angles[14] = (0, -180, 0);
	at[14] = 1.2000;
	points[15] = (-2408.9961, -7865.5903, 3581.1023);
	angles[15] = (0, -180, 0);
	at[15] = 1.2500;
	points[16] = (-2408.9961, -7865.5903, 3460.6301);
	angles[16] = (0, -180, 0);
	at[16] = 1.3000;
	points[17] = (-2408.9961, -7865.5903, 3376.3110);
	angles[17] = (0, -180, 0);
	at[17] = 1.3500;
	points[18] = (-2408.9961, -7865.5903, 3376.3110);
	angles[18] = (0, -180, 0);
	at[18] = 2.3000;
	points[19] = (-2408.9961, -7865.5903, 3379.2637);
	angles[19] = (0, -180, 0);
	at[19] = 2.3500;
	points[20] = (-2408.9961, -7865.5903, 3538.7126);
	angles[20] = (0, -180, 0);
	at[20] = 3.2500;
	points[21] = (-2408.9961, -7865.5903, 3543.3071);
	angles[21] = (0, -180, 0);
	at[21] = 3.3000;
	points[22] = (-2408.9961, -7865.5903, 3543.3071);
	angles[22] = (0, -180, 0);
	at[22] = 3.8000;
	mover = getEnt("iz_obj_3", "targetname");
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
