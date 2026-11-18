main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_gba_shy_guy_beach", 0);

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
	ambientPlay("iz_0_r_agb_beach32", 2);
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
	level.iz_route[level.iz_route.size] = (-5463, 1255, 886);
	level.iz_route[level.iz_route.size] = (-5330, -517, 886);
	level.iz_route[level.iz_route.size] = (-5315, -2333, 886);
	level.iz_route[level.iz_route.size] = (-5728, -3632, 886);
	level.iz_route[level.iz_route.size] = (-5640, -5271, 886);
	level.iz_route[level.iz_route.size] = (-5404, -6097, 886);
	level.iz_route[level.iz_route.size] = (-4577, -6437, 886);
	level.iz_route[level.iz_route.size] = (-3484, -6437, 886);
	level.iz_route[level.iz_route.size] = (-2274, -6452, 886);
	level.iz_route[level.iz_route.size] = (-1225, -6555, 886);
	level.iz_route[level.iz_route.size] = (148, -6791, 886);
	level.iz_route[level.iz_route.size] = (1816, -6909, 886);
	level.iz_route[level.iz_route.size] = (2879, -6836, 886);
	level.iz_route[level.iz_route.size] = (3853, -6806, 886);
	level.iz_route[level.iz_route.size] = (4769, -6806, 886);
	level.iz_route[level.iz_route.size] = (5861, -6540, 886);
	level.iz_route[level.iz_route.size] = (7028, -5906, 886);
	level.iz_route[level.iz_route.size] = (7028, -4636, 886);
	level.iz_route[level.iz_route.size] = (6909, -3307, 886);
	level.iz_route[level.iz_route.size] = (6658, -2318, 886);
	level.iz_route[level.iz_route.size] = (7175, -1048, 886);
	level.iz_route[level.iz_route.size] = (7958, 30, 886);
	level.iz_route[level.iz_route.size] = (8445, 871, 886);
	level.iz_route[level.iz_route.size] = (8563, 1535, 886);
	level.iz_route[level.iz_route.size] = (8519, 2864, 886);
	level.iz_route[level.iz_route.size] = (8607, 3839, 880);
	level.iz_route[level.iz_route.size] = (8031, 5020, 886);
	level.iz_route[level.iz_route.size] = (7382, 5950, 886);
	level.iz_route[level.iz_route.size] = (6540, 6304, 886);
	level.iz_route[level.iz_route.size] = (5463, 6629, 886);
	level.iz_route[level.iz_route.size] = (3927, 6496, 886);
	level.iz_route[level.iz_route.size] = (2968, 6481, 886);
	level.iz_route[level.iz_route.size] = (1905, 6585, 886);
	level.iz_route[level.iz_route.size] = (1019, 6983, 886);
	level.iz_route[level.iz_route.size] = (-517, 7101, 886);
	level.iz_route[level.iz_route.size] = (-1890, 7382, 886);
	level.iz_route[level.iz_route.size] = (-3484, 7205, 886);
	level.iz_route[level.iz_route.size] = (-4341, 6334, 886);
	level.iz_route[level.iz_route.size] = (-4887, 5551, 886);
	level.iz_route[level.iz_route.size] = (-5477, 4621, 886);
	level.iz_route[level.iz_route.size] = (-5714, 4208, 886);
	level.iz_route[level.iz_route.size] = (-5728, 3455, 886);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-5930.9448, -6036.7319, 879.9646);
	angles[0] = (0, 22.0679, 0);
	at[0] = 0;
	points[1] = (-5389.1338, -5817.0864, 885.8229);
	angles[1] = (0, 22.0679, 0);
	at[1] = 2.2000;
	points[2] = (-5385.0396, -5815.4336, 885.8661);
	angles[2] = (0, 22.0679, 0);
	at[2] = 2.2500;
	points[3] = (-5385.0396, -5815.4336, 885.8661);
	angles[3] = (0, 22.0679, 0);
	at[3] = 2.9500;
	points[4] = (-5938.7798, -6039.8818, 879.8820);
	angles[4] = (0, 22.0679, 0);
	at[4] = 5.2000;
	points[5] = (-5938.7798, -6039.8818, 879.8820);
	angles[5] = (0, 22.0679, 0);
	at[5] = 6.7000;
	points[6] = (-5930.9448, -6036.7319, 879.9646);
	angles[6] = (0, 22.0679, 0);
	at[6] = 6.7167;
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
	points[0] = (-4947.9136, -5865.1577, 879.9567);
	angles[0] = (0, 62.4472, 0);
	at[0] = 0;
	points[1] = (-5163.0317, -6277.4414, 883.5394);
	angles[1] = (0, 62.4472, 0);
	at[1] = 1.7500;
	points[2] = (-5167.1260, -6285.3149, 883.6103);
	angles[2] = (0, 62.4472, 0);
	at[2] = 1.8000;
	points[3] = (-5167.1260, -6285.3149, 883.6103);
	angles[3] = (0, 62.4472, 0);
	at[3] = 2.5000;
	points[4] = (-5169.1733, -6289.2129, 883.6417);
	angles[4] = (0, 62.4472, 0);
	at[4] = 2.5500;
	points[5] = (-5298.2285, -6536.6143, 885.7953);
	angles[5] = (0, 62.4472, 0);
	at[5] = 3.6000;
	points[6] = (-5300.2754, -6540.5513, 885.8268);
	angles[6] = (0, 62.4472, 0);
	at[6] = 3.6500;
	points[7] = (-5300.2754, -6540.5513, 885.8268);
	angles[7] = (0, 62.4472, 0);
	at[7] = 4.3500;
	points[8] = (-5296.1021, -6532.5195, 885.7599);
	angles[8] = (0, 62.4472, 0);
	at[8] = 4.4000;
	points[9] = (-5167.0474, -6285.1182, 883.6063);
	angles[9] = (0, 62.4472, 0);
	at[9] = 5.4500;
	points[10] = (-5165, -6281.1816, 883.5748);
	angles[10] = (0, 62.4472, 0);
	at[10] = 5.5000;
	points[11] = (-5165, -6281.1816, 883.5748);
	angles[11] = (0, 62.4472, 0);
	at[11] = 6.2000;
	points[12] = (-5160.8662, -6273.3467, 883.5040);
	angles[12] = (0, 62.4472, 0);
	at[12] = 6.2500;
	points[13] = (-4945.7876, -5861.0234, 879.9213);
	angles[13] = (0, 62.4472, 0);
	at[13] = 8;
	points[14] = (-4945.7876, -5861.0234, 879.9213);
	angles[14] = (0, 62.4472, 0);
	at[14] = 9.5000;
	points[15] = (-4947.9136, -5865.1577, 879.9567);
	angles[15] = (0, 62.4472, 0);
	at[15] = 9.5167;
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
	points[0] = (4987.0078, -5208.4644, 885.8268);
	angles[0] = (0, 135, 0);
	at[0] = 0;
	points[1] = (4789.7241, -5011.1812, 885.8268);
	angles[1] = (0, 135, 0);
	at[1] = 1.0500;
	points[2] = (4783.4648, -5004.9214, 885.8268);
	angles[2] = (0, 135, 0);
	at[2] = 1.1000;
	points[3] = (4783.4648, -5004.9214, 885.8268);
	angles[3] = (0, 135, 0);
	at[3] = 1.8000;
	points[4] = (4786.6143, -5008.0708, 885.8268);
	angles[4] = (0, 135, 0);
	at[4] = 1.8500;
	points[5] = (4983.8979, -5205.3545, 885.8268);
	angles[5] = (0, 135, 0);
	at[5] = 2.9000;
	points[6] = (4990.1577, -5211.6143, 885.8268);
	angles[6] = (0, 135, 0);
	at[6] = 2.9500;
	points[7] = (4990.1577, -5211.6143, 885.8268);
	angles[7] = (0, 135, 0);
	at[7] = 4.4000;
	points[8] = (4987.0078, -5208.4644, 885.8268);
	angles[8] = (0, 135, 0);
	at[8] = 4.4500;
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
	points[0] = (6523.1499, -6758.1104, 885.8268);
	angles[0] = (0, 123.1785, 0);
	at[0] = 0;
	points[1] = (6275.9448, -6380, 885.8268);
	angles[1] = (0, 123.1785, 0);
	at[1] = 1.7000;
	points[2] = (6273.5039, -6376.2598, 885.8268);
	angles[2] = (0, 122.4712, 0);
	at[2] = 1.7500;
	points[3] = (6273.5039, -6376.2598, 885.8268);
	angles[3] = (0, 122.4712, 0);
	at[3] = 2.4500;
	points[4] = (6268.7798, -6368.7793, 885.8268);
	angles[4] = (0, 122.4712, 0);
	at[4] = 2.5000;
	points[5] = (6069.0156, -6054.9214, 885.8268);
	angles[5] = (0, 122.4712, 0);
	at[5] = 3.9000;
	points[6] = (6066.6538, -6051.1812, 885.8268);
	angles[6] = (0, 122.4712, 0);
	at[6] = 3.9500;
	points[7] = (6066.6538, -6051.1812, 885.8268);
	angles[7] = (0, 122.4712, 0);
	at[7] = 4.0500;
	points[8] = (6066.6538, -6051.1812, 885.8268);
	angles[8] = (0, 122.4712, 0);
	at[8] = 4.6500;
	points[9] = (6072.6772, -6060.6299, 885.8268);
	angles[9] = (0, 122.4712, 0);
	at[9] = 4.7000;
	points[10] = (6272.4019, -6374.4883, 885.8268);
	angles[10] = (0, 122.4712, 0);
	at[10] = 6.1000;
	points[11] = (6274.8032, -6378.2285, 885.8268);
	angles[11] = (0, 123.1785, 0);
	at[11] = 6.1500;
	points[12] = (6274.8032, -6378.2285, 885.8268);
	angles[12] = (0, 123.1785, 0);
	at[12] = 6.8500;
	points[13] = (6279.6460, -6385.6694, 885.8268);
	angles[13] = (0, 123.1785, 0);
	at[13] = 6.9000;
	points[14] = (6526.8901, -6763.7798, 885.8268);
	angles[14] = (0, 123.1785, 0);
	at[14] = 8.6000;
	points[15] = (6526.8901, -6763.7798, 885.8268);
	angles[15] = (0, 123.1785, 0);
	at[15] = 10.1000;
	points[16] = (6523.1499, -6758.1104, 885.8268);
	angles[16] = (0, 123.1785, 0);
	at[16] = 10.1167;
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
	points[0] = (6766.2207, -4030.5120, 885.8268);
	angles[0] = (0, 180, 0);
	at[0] = 0;
	points[1] = (6952.2446, -4030.5120, 885.8268);
	angles[1] = (0, 180, 0);
	at[1] = 0.7000;
	points[2] = (6956.6929, -4030.5120, 885.8268);
	angles[2] = (0, 180, 0);
	at[2] = 0.7500;
	points[3] = (6956.6929, -4030.5120, 885.8268);
	angles[3] = (0, 180, 0);
	at[3] = 1.4500;
	points[4] = (6965.5513, -4030.5120, 885.8268);
	angles[4] = (0, 180, 0);
	at[4] = 1.5000;
	points[5] = (7125, -4030.5120, 885.8268);
	angles[5] = (0, 180, 0);
	at[5] = 2.1000;
	points[6] = (7133.8584, -4030.5120, 885.8268);
	angles[6] = (0, 180, 0);
	at[6] = 2.1500;
	points[7] = (7133.8584, -4030.5120, 885.8268);
	angles[7] = (0, 180, 0);
	at[7] = 2.8500;
	points[8] = (7126.4565, -4030.5120, 885.8268);
	angles[8] = (0, 180, 0);
	at[8] = 2.9000;
	points[9] = (6953.7402, -4030.5120, 885.8268);
	angles[9] = (0, 180, 0);
	at[9] = 3.5500;
	points[10] = (6949.2910, -4030.5120, 885.8268);
	angles[10] = (0, 180, 0);
	at[10] = 3.6000;
	points[11] = (6949.2910, -4030.5120, 885.8268);
	angles[11] = (0, 180, 0);
	at[11] = 4.3000;
	points[12] = (6940.4331, -4030.5120, 885.8268);
	angles[12] = (0, 180, 0);
	at[12] = 4.3500;
	points[13] = (6767.7163, -4030.5120, 885.8268);
	angles[13] = (0, 180, 0);
	at[13] = 5;
	points[14] = (6758.8584, -4030.5120, 885.8268);
	angles[14] = (0, 180, 0);
	at[14] = 5.0500;
	points[15] = (6758.8584, -4030.5120, 885.8268);
	angles[15] = (0, 180, 0);
	at[15] = 6.5000;
	points[16] = (6766.2207, -4030.5120, 885.8268);
	angles[16] = (0, 180, 0);
	at[16] = 6.5500;
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
	points[0] = (6529.9214, -2702.6418, 885.8268);
	angles[0] = (0, 168.6901, 0);
	at[0] = 0;
	points[1] = (6738.3857, -2744.3347, 885.8268);
	angles[1] = (0, 168.6901, 0);
	at[1] = 0.8000;
	points[2] = (6747.0869, -2746.0708, 885.8268);
	angles[2] = (0, 169.3804, 0);
	at[2] = 0.8500;
	points[3] = (6747.0869, -2746.0708, 885.8268);
	angles[3] = (0, 169.3804, 0);
	at[3] = 1.5500;
	points[4] = (6751.4565, -2746.8857, 885.8268);
	angles[4] = (0, 169.3804, 0);
	at[4] = 1.6000;
	points[5] = (6986.5352, -2790.9646, 885.8268);
	angles[5] = (0, 169.3804, 0);
	at[5] = 2.5000;
	points[6] = (6986.5352, -2790.9646, 885.8268);
	angles[6] = (0, 169.3804, 0);
	at[6] = 3.2500;
	points[7] = (6970.1968, -2787.9055, 885.8268);
	angles[7] = (0, 169.3804, 0);
	at[7] = 3.3000;
	points[8] = (6748.1895, -2746.2756, 885.8268);
	angles[8] = (0, 169.3804, 0);
	at[8] = 4.1500;
	points[9] = (6743.8188, -2745.4607, 885.8268);
	angles[9] = (0, 168.6901, 0);
	at[9] = 4.2000;
	points[10] = (6743.8188, -2745.4607, 885.8268);
	angles[10] = (0, 168.6901, 0);
	at[10] = 4.9000;
	points[11] = (6735.1577, -2743.6851, 885.8268);
	angles[11] = (0, 168.6901, 0);
	at[11] = 4.9500;
	points[12] = (6526.6929, -2701.9922, 885.8268);
	angles[12] = (0, 168.6901, 0);
	at[12] = 5.7500;
	points[13] = (6522.3623, -2701.1221, 885.8268);
	angles[13] = (0, 168.6901, 0);
	at[13] = 5.8000;
	points[14] = (6522.3623, -2701.1221, 885.8268);
	angles[14] = (0, 168.6901, 0);
	at[14] = 7.2500;
	points[15] = (6529.9214, -2702.6418, 885.8268);
	angles[15] = (0, 168.6901, 0);
	at[15] = 7.2833;
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
	points[0] = (7554.8818, -1091.0551, 885.8268);
	angles[0] = (0, 160.7099, 0);
	at[0] = 0;
	points[1] = (7266.4175, -990.0984, 885.8268);
	angles[1] = (0, 160.7099, 0);
	at[1] = 1.1500;
	points[2] = (7262.2441, -988.6339, 885.8268);
	angles[2] = (0, 160.7099, 0);
	at[2] = 1.2000;
	points[3] = (7262.2441, -988.6339, 885.8268);
	angles[3] = (0, 160.7099, 0);
	at[3] = 1.9000;
	points[4] = (7253.8975, -985.7087, 885.8268);
	angles[4] = (0, 160.7099, 0);
	at[4] = 1.9500;
	points[5] = (6965.4331, -884.7481, 885.8268);
	angles[5] = (0, 160.7099, 0);
	at[5] = 3.1000;
	points[6] = (6965.4331, -884.7481, 885.8268);
	angles[6] = (0, 160.7099, 0);
	at[6] = 3.8500;
	points[7] = (6981.0630, -890.2166, 885.8268);
	angles[7] = (0, 160.7099, 0);
	at[7] = 3.9000;
	points[8] = (7256.9683, -986.7835, 885.8268);
	angles[8] = (0, 160.7099, 0);
	at[8] = 5;
	points[9] = (7265.3149, -989.7126, 885.8268);
	angles[9] = (0, 160.7099, 0);
	at[9] = 5.0500;
	points[10] = (7265.3149, -989.7126, 885.8268);
	angles[10] = (0, 160.7099, 0);
	at[10] = 5.7500;
	points[11] = (7269.4883, -991.1733, 885.8268);
	angles[11] = (0, 160.7099, 0);
	at[11] = 5.8000;
	points[12] = (7557.9526, -1092.1339, 885.8268);
	angles[12] = (0, 160.7099, 0);
	at[12] = 6.9500;
	points[13] = (7562.1260, -1093.5984, 885.8268);
	angles[13] = (0, 160.7099, 0);
	at[13] = 7;
	points[14] = (7562.1260, -1093.5984, 885.8268);
	angles[14] = (0, 160.7099, 0);
	at[14] = 8.4500;
	points[15] = (7554.8818, -1091.0551, 885.8268);
	angles[15] = (0, 160.7099, 0);
	at[15] = 8.4833;
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
	points[0] = (8337.5596, 223.4374, 885.8268);
	angles[0] = (0, 153.4349, 0);
	at[0] = 0;
	points[1] = (8183.0713, 300.6874, 885.8268);
	angles[1] = (0, 153.4349, 0);
	at[1] = 0.6500;
	points[2] = (8183.0713, 300.6874, 885.8268);
	angles[2] = (0, 153.4349, 0);
	at[2] = 1.4000;
	points[3] = (7992.9136, 395.7638, 885.8268);
	angles[3] = (0, 153.4349, 0);
	at[3] = 2.2000;
	points[4] = (7985, 399.7244, 885.8268);
	angles[4] = (0, 153.4349, 0);
	at[4] = 2.2500;
	points[5] = (7985, 399.7244, 885.8268);
	angles[5] = (0, 153.4349, 0);
	at[5] = 2.9500;
	points[6] = (7991.1812, 396.6418, 885.8268);
	angles[6] = (0, 153.4349, 0);
	at[6] = 3;
	points[7] = (8181.3389, 301.5642, 885.8268);
	angles[7] = (0, 153.4349, 0);
	at[7] = 3.8000;
	points[8] = (8185.2759, 299.5835, 885.8268);
	angles[8] = (0, 153.4349, 0);
	at[8] = 3.8500;
	points[9] = (8185.2759, 299.5835, 885.8268);
	angles[9] = (0, 153.4349, 0);
	at[9] = 4.5500;
	points[10] = (8193.1885, 295.6220, 885.8268);
	angles[10] = (0, 153.4349, 0);
	at[10] = 4.6000;
	points[11] = (8335.8271, 224.3142, 885.8268);
	angles[11] = (0, 153.4349, 0);
	at[11] = 5.2000;
	points[12] = (8343.7402, 220.3528, 885.8268);
	angles[12] = (0, 153.4349, 0);
	at[12] = 5.2500;
	points[13] = (8343.7402, 220.3528, 885.8268);
	angles[13] = (0, 153.4349, 0);
	at[13] = 5.9500;
	points[14] = (8337.5596, 223.4374, 885.8268);
	angles[14] = (0, 153.4349, 0);
	at[14] = 6;
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
	points[0] = (-7826.1812, -11840.4717, 885.8268);
	angles[0] = (0, -27.0395, 0);
	at[0] = 0;
	points[1] = (-7668.0708, -11920.5898, 913.9134);
	angles[1] = (0, -27.0396, 0);
	at[1] = 0.5000;
	points[2] = (-7510.2759, -12001.1025, 868.4882);
	angles[2] = (0, -27.0396, 0);
	at[2] = 1;
	points[3] = (-7352.4805, -12081.6533, 868.4449);
	angles[3] = (0, -27.0396, 0);
	at[3] = 1.5000;
	points[4] = (-7194.6851, -12162.2051, 913.8937);
	angles[4] = (0, -27.0396, 0);
	at[4] = 2;
	points[5] = (-6879.0552, -12323.2676, 857.7244);
	angles[5] = (0, -27.0396, 0);
	at[5] = 3;
	points[6] = (-6721.2598, -12403.8193, 903.1221);
	angles[6] = (0, -27.0396, 0);
	at[6] = 3.5000;
	points[7] = (-6563.4648, -12484.3701, 903.2520);
	angles[7] = (0, -27.0396, 0);
	at[7] = 4;
	points[8] = (-6405.6689, -12564.8828, 857.7756);
	angles[8] = (0, -27.0396, 0);
	at[8] = 4.5000;
	points[9] = (-6078.5435, -12701.0234, 913.9449);
	angles[9] = (0, -27.0396, 0);
	at[9] = 5.5000;
	points[10] = (-5915, -12769.1738, 868.5748);
	angles[10] = (0, -27.0396, 0);
	at[10] = 6;
	points[11] = (-5751.4570, -12837.3223, 868.3583);
	angles[11] = (0, -27.0396, 0);
	at[11] = 6.5000;
	points[12] = (-5587.9136, -12905.4727, 913.8622);
	angles[12] = (0, -27.0396, 0);
	at[12] = 7;
	points[13] = (-5260.8267, -13041.7324, 857.6929);
	angles[13] = (0, -27.0396, 0);
	at[13] = 8;
	points[14] = (-5097.3228, -13109.8818, 903.0315);
	angles[14] = (0, -27.0396, 0);
	at[14] = 8.5000;
	points[15] = (-4933.7798, -13178.0312, 903.3386);
	angles[15] = (0, -27.0396, 0);
	at[15] = 9;
	points[16] = (-4770.2363, -13246.1816, 857.8071);
	angles[16] = (0, -27.0396, 0);
	at[16] = 9.5000;
	points[17] = (-4443.0312, -13382.1660, 913.9803);
	angles[17] = (0, -27.0396, 0);
	at[17] = 10.5000;
	points[18] = (-4278.3071, -13447.3623, 868.6654);
	angles[18] = (0, -27.0396, 0);
	at[18] = 11;
	points[19] = (-4113.5825, -13512.5586, 868.2717);
	angles[19] = (0, -27.0396, 0);
	at[19] = 11.5000;
	points[20] = (-3948.8584, -13577.7959, 913.8268);
	angles[20] = (0, -27.0396, 0);
	at[20] = 12;
	points[21] = (-3619.3977, -13708.1885, 857.6575);
	angles[21] = (0, -27.0396, 0);
	at[21] = 13;
	points[22] = (-3454.6692, -13773.3857, 902.9449);
	angles[22] = (0, -27.0396, 0);
	at[22] = 13.5000;
	points[23] = (-3289.9409, -13838.5830, 903.4291);
	angles[23] = (0, -27.0396, 0);
	at[23] = 14;
	points[24] = (-3125.2126, -13903.8193, 857.8425);
	angles[24] = (0, -27.0396, 0);
	at[24] = 14.5000;
	points[25] = (-2956.3977, -13955.6299, 885.5000);
	angles[25] = (0, -27.0396, 0);
	at[25] = 15;
	points[26] = (-2783.3425, -13993.5830, 914.0118);
	angles[26] = (0, -27.0396, 0);
	at[26] = 15.5000;
	points[27] = (-2610.2913, -14031.5352, 868.7520);
	angles[27] = (0, -27.0396, 0);
	at[27] = 16;
	points[28] = (-2437.2402, -14069.4883, 868.1811);
	angles[28] = (0, -27.0396, 0);
	at[28] = 16.5000;
	points[29] = (-2264.1851, -14107.4414, 913.7914);
	angles[29] = (0, -27.0396, 0);
	at[29] = 17;
	points[30] = (-1918.0787, -14183.3457, 857.6260);
	angles[30] = (0, -27.0396, 0);
	at[30] = 18;
	points[31] = (-1745.0276, -14221.2998, 902.8583);
	angles[31] = (0, -27.0396, 0);
	at[31] = 18.5000;
	points[32] = (-1571.9725, -14259.2520, 903.5158);
	angles[32] = (0, -27.0396, 0);
	at[32] = 19;
	points[33] = (-1398.9213, -14297.2041, 857.8780);
	angles[33] = (0, -27.0396, 0);
	at[33] = 19.5000;
	points[34] = (-1222.8583, -14312.2051, 885.3937);
	angles[34] = (0, -27.0396, 0);
	at[34] = 20;
	points[35] = (-1045.8740, -14320.1973, 914.0433);
	angles[35] = (0, -27.0396, 0);
	at[35] = 20.5000;
	points[36] = (-868.8898, -14328.1895, 868.8425);
	angles[36] = (0, -27.0396, 0);
	at[36] = 21;
	points[37] = (-691.9016, -14336.1816, 868.0945);
	angles[37] = (0, -27.0396, 0);
	at[37] = 21.5000;
	points[38] = (-514.9174, -14344.1338, 913.7598);
	angles[38] = (0, -27.0396, 0);
	at[38] = 22;
	points[39] = (-160.9453, -14360.1182, 857.5945);
	angles[39] = (0, -27.0396, 0);
	at[39] = 23;
	points[40] = (16.0417, -14368.1113, 902.7677);
	angles[40] = (0, -27.0396, 0);
	at[40] = 23.5000;
	points[41] = (193.0287, -14376.1035, 903.6024);
	angles[41] = (0, -27.0396, 0);
	at[41] = 24;
	points[42] = (370.0158, -14384.0557, 857.9134);
	angles[42] = (0, -27.0396, 0);
	at[42] = 24.5000;
	points[43] = (547.0040, -14392.0479, 885.2835);
	angles[43] = (0, -27.0396, 0);
	at[43] = 25;
	points[44] = (723.6418, -14384.1738, 914.0748);
	angles[44] = (0, -27.0396, 0);
	at[44] = 25.5000;
	points[45] = (900.1142, -14368.4648, 868.9292);
	angles[45] = (0, -27.0396, 0);
	at[45] = 26;
	points[46] = (1076.5826, -14352.7959, 868.0079);
	angles[46] = (0, -27.0396, 0);
	at[46] = 26.5000;
	points[47] = (1253.0511, -14337.1260, 913.7244);
	angles[47] = (0, -27.0396, 0);
	at[47] = 27;
	points[48] = (1605.9882, -14305.7480, 857.5630);
	angles[48] = (0, -27.0396, 0);
	at[48] = 28;
	points[49] = (1782.4607, -14290.0400, 902.6772);
	angles[49] = (0, -27.0396, 0);
	at[49] = 28.5000;
	points[50] = (1958.9292, -14274.3701, 903.6890);
	angles[50] = (0, -27.0396, 0);
	at[50] = 29;
	points[51] = (2135.3977, -14258.6621, 857.9489);
	angles[51] = (0, -27.0396, 0);
	at[51] = 29.5000;
	points[52] = (2488.3386, -14227.3223, 914.1063);
	angles[52] = (0, -27.0396, 0);
	at[52] = 30.5000;
	points[53] = (2664.1455, -14206.4961, 869.0197);
	angles[53] = (0, -27.0396, 0);
	at[53] = 31;
	points[54] = (2838.8662, -14177.1260, 867.9213);
	angles[54] = (0, -27.0396, 0);
	at[54] = 31.5000;
	points[55] = (3013.5825, -14147.7559, 913.6851);
	angles[55] = (0, -27.0396, 0);
	at[55] = 32;
	points[56] = (3363.0159, -14089.0557, 857.5315);
	angles[56] = (0, -27.0396, 0);
	at[56] = 33;
	points[57] = (3537.7322, -14059.7246, 902.5906);
	angles[57] = (0, -27.0396, 0);
	at[57] = 33.5000;
	points[58] = (3712.4490, -14030.3545, 903.7716);
	angles[58] = (0, -27.0396, 0);
	at[58] = 34;
	points[59] = (3887.1655, -14001.0244, 857.9843);
	angles[59] = (0, -27.0396, 0);
	at[59] = 34.5000;
	points[60] = (4236.6143, -13942.3232, 914.1378);
	angles[60] = (0, -27.0396, 0);
	at[60] = 35.5000;
	points[61] = (4411.2993, -13912.9531, 869.1102);
	angles[61] = (0, -27.0396, 0);
	at[61] = 36;
	points[62] = (4579.4097, -13858.4648, 867.8386);
	angles[62] = (0, -27.0396, 0);
	at[62] = 36.5000;
	points[63] = (4746.0239, -13798.1895, 913.6496);
	angles[63] = (0, -27.0396, 0);
	at[63] = 37;
	points[64] = (5079.2520, -13677.6768, 857.5000);
	angles[64] = (0, -27.0396, 0);
	at[64] = 38;
	points[65] = (5245.8271, -13617.4014, 902.5000);
	angles[65] = (0, -27.0396, 0);
	at[65] = 38.5000;
	points[66] = (5412.4409, -13557.1650, 903.8583);
	angles[66] = (0, -27.0396, 0);
	at[66] = 39;
	points[67] = (5579.0547, -13496.8906, 858.0197);
	angles[67] = (0, -27.0396, 0);
	at[67] = 39.5000;
	points[68] = (5911.4170, -13374.1738, 914.1693);
	angles[68] = (0, -27.0396, 0);
	at[68] = 40.5000;
	points[69] = (6076.3389, -13309.4092, 869.1969);
	angles[69] = (0, -27.0396, 0);
	at[69] = 41;
	points[70] = (6241.2202, -13244.6455, 867.7520);
	angles[70] = (0, -27.0396, 0);
	at[70] = 41.5000;
	points[71] = (6406.1025, -13179.8428, 913.6141);
	angles[71] = (0, -27.0396, 0);
	at[71] = 42;
	points[72] = (6735.9053, -13050.2754, 857.4685);
	angles[72] = (0, -27.0396, 0);
	at[72] = 43;
	points[73] = (6900.7876, -12985.5117, 902.4094);
	angles[73] = (0, -27.0396, 0);
	at[73] = 43.5000;
	points[74] = (7065.7085, -12920.7090, 903.9449);
	angles[74] = (0, -27.0396, 0);
	at[74] = 44;
	points[75] = (7214.3701, -12824.6455, 858.0591);
	angles[75] = (0, -27.0396, 0);
	at[75] = 44.5000;
	points[76] = (7510.5117, -12630.0400, 914.1968);
	angles[76] = (0, -27.0396, 0);
	at[76] = 45.5000;
	points[77] = (7658.5430, -12532.7559, 869.2874);
	angles[77] = (0, -27.0396, 0);
	at[77] = 46;
	points[78] = (7806.6143, -12435.4727, 867.6653);
	angles[78] = (0, -27.0396, 0);
	at[78] = 46.5000;
	points[79] = (7954.6851, -12338.1504, 913.5788);
	angles[79] = (0, -27.0396, 0);
	at[79] = 47;
	points[80] = (8249.5674, -12141.7324, 857.4409);
	angles[80] = (0, -27.0396, 0);
	at[80] = 48;
	points[81] = (8396.3389, -12042.5205, 902.3229);
	angles[81] = (0, -27.0396, 0);
	at[81] = 48.5000;
	points[82] = (8543.1494, -11943.3467, 904.0315);
	angles[82] = (0, -27.0396, 0);
	at[82] = 49;
	points[83] = (8689.9609, -11844.1338, 858.0945);
	angles[83] = (0, -27.0396, 0);
	at[83] = 49.5000;
	points[84] = (8983.5439, -11645.7881, 914.2283);
	angles[84] = (0, -27.0396, 0);
	at[84] = 50.5000;
	points[85] = (9130.3545, -11546.5742, 869.3779);
	angles[85] = (0, -27.0396, 0);
	at[85] = 51;
	points[86] = (9268.6611, -11436.6143, 867.5788);
	angles[86] = (0, -27.0396, 0);
	at[86] = 51.5000;
	points[87] = (9399.7637, -11317.4414, 913.5394);
	angles[87] = (0, -27.0396, 0);
	at[87] = 52;
	points[88] = (9661.9287, -11079.0947, 857.4095);
	angles[88] = (0, -27.0396, 0);
	at[88] = 53;
	points[89] = (9793.0312, -10959.9209, 902.2323);
	angles[89] = (0, -27.0396, 0);
	at[89] = 53.5000;
	points[90] = (9924.0947, -10840.7490, 904.1142);
	angles[90] = (0, -27.0396, 0);
	at[90] = 54;
	points[91] = (10055.1963, -10721.5752, 858.1299);
	angles[91] = (0, -27.0396, 0);
	at[91] = 54.5000;
	points[92] = (10183.8594, -10600.1572, 884.6339);
	angles[92] = (0, -27.0396, 0);
	at[92] = 55;
	points[93] = (10292.2842, -10460.0391, 914.2559);
	angles[93] = (0, -27.0396, 0);
	at[93] = 55.5000;
	points[94] = (10400.7090, -10319.9219, 869.4685);
	angles[94] = (0, -27.0396, 0);
	at[94] = 56;
	points[95] = (10509.1338, -10179.8027, 867.4961);
	angles[95] = (0, -27.0396, 0);
	at[95] = 56.5000;
	points[96] = (10617.5596, -10039.6846, 913.5039);
	angles[96] = (0, -27.0396, 0);
	at[96] = 57;
	points[97] = (10834.4092, -9759.4492, 857.3819);
	angles[97] = (0, -27.0396, 0);
	at[97] = 58;
	points[98] = (10942.8350, -9619.3311, 902.1417);
	angles[98] = (0, -27.0396, 0);
	at[98] = 58.5000;
	points[99] = (11051.2598, -9479.2129, 904.2008);
	angles[99] = (0, -27.0396, 0);
	at[99] = 59;
	points[100] = (11159.4102, -9338.9375, 858.1693);
	angles[100] = (0, -27.0396, 0);
	at[100] = 59.5000;
	points[101] = (11374.3701, -9057.2441, 914.2874);
	angles[101] = (0, -27.0396, 0);
	at[101] = 60.5000;
	points[102] = (11481.8506, -8916.4180, 869.5590);
	angles[102] = (0, -27.0396, 0);
	at[102] = 61;
	points[103] = (11589.3301, -8775.5518, 867.4094);
	angles[103] = (0, -27.0396, 0);
	at[103] = 61.5000;
	points[104] = (11696.8506, -8634.7246, 913.4645);
	angles[104] = (0, -27.0396, 0);
	at[104] = 62;
	points[105] = (11911.8115, -8353.0713, 857.3544);
	angles[105] = (0, -27.0396, 0);
	at[105] = 63;
	points[106] = (12015.5518, -8209.6455, 902.0512);
	angles[106] = (0, -27.0396, 0);
	at[106] = 63.5000;
	points[107] = (12110.1572, -8059.8428, 904.2874);
	angles[107] = (0, -27.0396, 0);
	at[107] = 64;
	points[108] = (12204.7646, -7910.0391, 858.2087);
	angles[108] = (0, -27.0396, 0);
	at[108] = 64.5000;
	points[109] = (12393.9766, -7610.4727, 914.3150);
	angles[109] = (0, -27.0396, 0);
	at[109] = 65.5000;
	points[110] = (12488.5820, -7460.6694, 869.6496);
	angles[110] = (0, -27.0396, 0);
	at[110] = 66;
	points[111] = (12583.1895, -7310.8662, 867.3268);
	angles[111] = (0, -27.0396, 0);
	at[111] = 66.5000;
	points[112] = (12677.7949, -7161.1025, 913.4252);
	angles[112] = (0, -27.0396, 0);
	at[112] = 67;
	points[113] = (12867.0078, -6861.4961, 857.3228);
	angles[113] = (0, -27.0396, 0);
	at[113] = 68;
	points[114] = (12932.0469, -6696.9683, 901.9606);
	angles[114] = (0, -27.0396, 0);
	at[114] = 68.5000;
	points[115] = (12994.6855, -6531.2598, 904.3701);
	angles[115] = (0, -27.0396, 0);
	at[115] = 69;
	points[116] = (13057.3633, -6365.5513, 858.2480);
	angles[116] = (0, -27.0396, 0);
	at[116] = 69.5000;
	points[117] = (13120.0391, -6199.8423, 884.3110);
	angles[117] = (0, -27.0396, 0);
	at[117] = 70;
	points[118] = (13182.6768, -6034.1338, 914.3425);
	angles[118] = (0, -27.0396, 0);
	at[118] = 70.5000;
	points[119] = (13245.3545, -5868.4253, 869.7402);
	angles[119] = (0, -27.0396, 0);
	at[119] = 71;
	points[120] = (13308.0312, -5702.7168, 867.2402);
	angles[120] = (0, -27.0396, 0);
	at[120] = 71.5000;
	points[121] = (13370.6689, -5537.0078, 913.3859);
	angles[121] = (0, -27.0396, 0);
	at[121] = 72;
	points[122] = (13433.3467, -5371.2993, 887.3976);
	angles[122] = (0, -27.0396, 0);
	at[122] = 72.5000;
	points[123] = (13496.0244, -5205.5508, 857.2952);
	angles[123] = (0, -27.0396, 0);
	at[123] = 73;
	points[124] = (13558.6621, -5039.8423, 901.8701);
	angles[124] = (0, -27.0396, 0);
	at[124] = 73.5000;
	points[125] = (13621.3389, -4874.1338, 904.4528);
	angles[125] = (0, -27.0396, 0);
	at[125] = 74;
	points[126] = (13684.0166, -4708.4253, 858.2834);
	angles[126] = (0, -27.0396, 0);
	at[126] = 74.5000;
	points[127] = (13746.6543, -4542.7168, 884.2008);
	angles[127] = (0, -27.0396, 0);
	at[127] = 75;
	points[128] = (13809.3301, -4377.0078, 914.3701);
	angles[128] = (0, -27.0396, 0);
	at[128] = 75.5000;
	points[129] = (13872.0078, -4211.2993, 869.8307);
	angles[129] = (0, -27.0396, 0);
	at[129] = 76;
	points[130] = (13934.6455, -4045.5908, 867.1575);
	angles[130] = (0, -27.0396, 0);
	at[130] = 76.5000;
	points[131] = (13997.3232, -3879.8821, 913.3504);
	angles[131] = (0, -27.0396, 0);
	at[131] = 77;
	points[132] = (14060, -3714.1692, 887.5079);
	angles[132] = (0, -27.0396, 0);
	at[132] = 77.5000;
	points[133] = (14122.6377, -3548.4568, 857.2677);
	angles[133] = (0, -27.0396, 0);
	at[133] = 78;
	points[134] = (14185.3154, -3382.7480, 901.7756);
	angles[134] = (0, -27.0396, 0);
	at[134] = 78.5000;
	points[135] = (14209.2910, -3208.9373, 904.5394);
	angles[135] = (0, -27.0396, 0);
	at[135] = 79;
	points[136] = (14218.3857, -3032.0039, 858.3228);
	angles[136] = (0, -27.0396, 0);
	at[136] = 79.5000;
	points[137] = (14227.4414, -2855.0708, 884.0945);
	angles[137] = (0, -27.0396, 0);
	at[137] = 80;
	points[138] = (14236.5361, -2678.1377, 914.3976);
	angles[138] = (0, -27.0396, 0);
	at[138] = 80.5000;
	points[139] = (14245.5908, -2501.2087, 869.9213);
	angles[139] = (0, -27.0396, 0);
	at[139] = 81;
	points[140] = (14254.6855, -2324.2756, 867.0748);
	angles[140] = (0, -27.0396, 0);
	at[140] = 81.5000;
	points[141] = (14263.7412, -2147.3425, 913.3110);
	angles[141] = (0, -27.0396, 0);
	at[141] = 82;
	points[142] = (14272.8350, -1970.4095, 887.6142);
	angles[142] = (0, -27.0396, 0);
	at[142] = 82.5000;
	points[143] = (14281.8906, -1793.4763, 857.2401);
	angles[143] = (0, -27.0396, 0);
	at[143] = 83;
	points[144] = (14290.9844, -1616.5433, 901.6851);
	angles[144] = (0, -27.0396, 0);
	at[144] = 83.5000;
	points[145] = (14300.0400, -1439.6104, 904.6221);
	angles[145] = (0, -27.0396, 0);
	at[145] = 84;
	points[146] = (14309.0938, -1262.6771, 858.3661);
	angles[146] = (0, -27.0396, 0);
	at[146] = 84.5000;
	points[147] = (14318.1895, -1085.7441, 883.9843);
	angles[147] = (0, -27.0396, 0);
	at[147] = 85;
	points[148] = (14319.8027, -908.6536, 914.4252);
	angles[148] = (0, -27.0396, 0);
	at[148] = 85.5000;
	points[149] = (14318.3076, -731.4961, 870.0118);
	angles[149] = (0, -27.0396, 0);
	at[149] = 86;
	points[150] = (14316.8115, -554.3347, 866.9882);
	angles[150] = (0, -27.0396, 0);
	at[150] = 86.5000;
	points[151] = (14315.3154, -377.1756, 913.2678);
	angles[151] = (0, -27.0396, 0);
	at[151] = 87;
	points[152] = (14313.8193, -200.0161, 887.7244);
	angles[152] = (0, -27.0396, 0);
	at[152] = 87.5000;
	points[153] = (14312.2842, -22.8570, 857.2126);
	angles[153] = (0, -27.0396, 0);
	at[153] = 88;
	points[154] = (14310.7871, 154.3024, 901.5945);
	angles[154] = (0, -27.0396, 0);
	at[154] = 88.5000;
	points[155] = (14309.2910, 331.4618, 904.7047);
	angles[155] = (0, -27.0396, 0);
	at[155] = 89;
	points[156] = (14307.7959, 508.6220, 858.4055);
	angles[156] = (0, -27.0396, 0);
	at[156] = 89.5000;
	points[157] = (14306.2998, 685.7795, 883.8780);
	angles[157] = (0, -27.0396, 0);
	at[157] = 90;
	points[158] = (14302.4414, 862.9016, 914.4528);
	angles[158] = (0, -27.0396, 0);
	at[158] = 90.5000;
	points[159] = (14298.2285, 1040.0157, 870.1063);
	angles[159] = (0, -27.0396, 0);
	at[159] = 91;
	points[160] = (14294.0156, 1217.1338, 866.9055);
	angles[160] = (0, -27.0396, 0);
	at[160] = 91.5000;
	points[161] = (14289.7637, 1394.2480, 913.2283);
	angles[161] = (0, -27.0396, 0);
	at[161] = 92;
	points[162] = (14285.5508, 1571.3623, 887.8307);
	angles[162] = (0, -27.0396, 0);
	at[162] = 92.5000;
	points[163] = (14281.3389, 1748.4803, 857.1890);
	angles[163] = (0, -27.0396, 0);
	at[163] = 93;
	points[164] = (14277.1260, 1925.5945, 901.5039);
	angles[164] = (0, -27.0396, 0);
	at[164] = 93.5000;
	points[165] = (14272.9141, 2102.7085, 904.7874);
	angles[165] = (0, -27.0396, 0);
	at[165] = 94;
	points[166] = (14268.7002, 2279.8230, 858.4449);
	angles[166] = (0, -27.0396, 0);
	at[166] = 94.5000;
	points[167] = (14264.4883, 2456.9409, 883.7678);
	angles[167] = (0, -27.0396, 0);
	at[167] = 95;
	points[168] = (14256.6934, 2633.8740, 914.4803);
	angles[168] = (0, -27.0396, 0);
	at[168] = 95.5000;
	points[169] = (14242.7949, 2810.4919, 870.1969);
	angles[169] = (0, -27.0396, 0);
	at[169] = 96;
	points[170] = (14228.8975, 2987.1101, 866.8228);
	angles[170] = (0, -27.0396, 0);
	at[170] = 96.5000;
	points[171] = (14214.9609, 3163.7285, 913.1890);
	angles[171] = (0, -27.0396, 0);
	at[171] = 97;
	points[172] = (14201.0635, 3340.3467, 887.9370);
	angles[172] = (0, -27.0396, 0);
	at[172] = 97.5000;
	points[173] = (14187.1660, 3516.9646, 857.1614);
	angles[173] = (0, -27.0396, 0);
	at[173] = 98;
	points[174] = (14173.2686, 3693.5867, 901.4135);
	angles[174] = (0, -27.0396, 0);
	at[174] = 98.5000;
	points[175] = (14159.3311, 3870.2048, 904.8741);
	angles[175] = (0, -27.0396, 0);
	at[175] = 99;
	points[176] = (14145.4336, 4046.8110, 858.4843);
	angles[176] = (0, -27.0396, 0);
	at[176] = 99.5000;
	points[177] = (14131.5361, 4223.4648, 883.6614);
	angles[177] = (0, -27.0396, 0);
	at[177] = 100;
	points[178] = (14117.6387, 4400.0786, 914.5039);
	angles[178] = (0, -27.0396, 0);
	at[178] = 100.5000;
	points[179] = (14079.8428, 4572.5981, 870.2875);
	angles[179] = (0, -27.0396, 0);
	at[179] = 101;
	points[180] = (14034.2129, 4743.7793, 866.7402);
	angles[180] = (0, -27.0396, 0);
	at[180] = 101.5000;
	points[181] = (13988.5430, 4914.9604, 913.1496);
	angles[181] = (0, -27.0396, 0);
	at[181] = 102;
	points[182] = (13942.9131, 5086.1421, 888.0472);
	angles[182] = (0, -27.0396, 0);
	at[182] = 102.5000;
	points[183] = (13897.2441, 5257.3228, 857.1339);
	angles[183] = (0, -27.0396, 0);
	at[183] = 103;
	points[184] = (13851.6143, 5428.5039, 901.3189);
	angles[184] = (0, -27.0396, 0);
	at[184] = 103.5000;
	points[185] = (13805.9443, 5599.6851, 904.9567);
	angles[185] = (0, -27.0396, 0);
	at[185] = 104;
	points[186] = (13760.3145, 5770.8662, 858.5276);
	angles[186] = (0, -27.0396, 0);
	at[186] = 104.5000;
	points[187] = (13714.6455, 5942.0869, 883.5512);
	angles[187] = (0, -27.0396, 0);
	at[187] = 105;
	points[188] = (13669.0156, 6113.2676, 914.5315);
	angles[188] = (0, -27.0396, 0);
	at[188] = 105.5000;
	points[189] = (13611.8896, 6280.3154, 870.3819);
	angles[189] = (0, -27.0396, 0);
	at[189] = 106;
	points[190] = (13537.7568, 6441.2202, 866.6575);
	angles[190] = (0, -27.0396, 0);
	at[190] = 106.5000;
	points[191] = (13463.6230, 6602.1260, 913.1063);
	angles[191] = (0, -27.0396, 0);
	at[191] = 107;
	points[192] = (13389.4492, 6763.0317, 888.1535);
	angles[192] = (0, -27.0396, 0);
	at[192] = 107.5000;
	points[193] = (13315.3154, 6923.9370, 857.1102);
	angles[193] = (0, -27.0396, 0);
	at[193] = 108;
	points[194] = (13241.1807, 7084.8428, 901.2244);
	angles[194] = (0, -27.0396, 0);
	at[194] = 108.5000;
	points[195] = (13167.0469, 7245.7485, 905.0355);
	angles[195] = (0, -27.0396, 0);
	at[195] = 109;
	points[196] = (13092.9131, 7406.6533, 858.5670);
	angles[196] = (0, -27.0396, 0);
	at[196] = 109.5000;
	points[197] = (13018.7402, 7567.5591, 883.4449);
	angles[197] = (0, -27.0396, 0);
	at[197] = 110;
	points[198] = (12943.7002, 7727.9526, 914.5551);
	angles[198] = (0, -27.0396, 0);
	at[198] = 110.5000;
	points[199] = (12848.5830, 7877.4414, 870.4725);
	angles[199] = (0, -27.0396, 0);
	at[199] = 111;
	points[200] = (12753.4639, 8026.8896, 866.5748);
	angles[200] = (0, -27.0396, 0);
	at[200] = 111.5000;
	points[201] = (12658.3467, 8176.3389, 913.0630);
	angles[201] = (0, -27.0396, 0);
	at[201] = 112;
	points[202] = (12563.2275, 8325.8271, 888.2637);
	angles[202] = (0, -27.0396, 0);
	at[202] = 112.5000;
	points[203] = (12468.1104, 8475.2754, 857.0867);
	angles[203] = (0, -27.0396, 0);
	at[203] = 113;
	points[204] = (12372.9922, 8624.7637, 901.1339);
	angles[204] = (0, -27.0396, 0);
	at[204] = 113.5000;
	points[205] = (12277.8740, 8774.2129, 905.1181);
	angles[205] = (0, -27.0396, 0);
	at[205] = 114;
	points[206] = (12182.7559, 8923.7012, 858.6103);
	angles[206] = (0, -27.0396, 0);
	at[206] = 114.5000;
	points[207] = (12087.6377, 9073.1494, 883.3347);
	angles[207] = (0, -27.0396, 0);
	at[207] = 115;
	points[208] = (11989.1729, 9220.2764, 914.5827);
	angles[208] = (0, -27.0396, 0);
	at[208] = 115.5000;
	points[209] = (11881.3779, 9360.8662, 870.5670);
	angles[209] = (0, -27.0396, 0);
	at[209] = 116;
	points[210] = (11773.5830, 9501.4961, 866.4921);
	angles[210] = (0, -27.0396, 0);
	at[210] = 116.5000;
	points[211] = (11665.8271, 9642.0869, 913.0236);
	angles[211] = (0, -27.0396, 0);
	at[211] = 117;
	points[212] = (11558.0322, 9782.6768, 888.3701);
	angles[212] = (0, -27.0396, 0);
	at[212] = 117.5000;
	points[213] = (11450.2363, 9923.2676, 857.0591);
	angles[213] = (0, -27.0396, 0);
	at[213] = 118;
	points[214] = (11342.4404, 10063.8975, 901.0394);
	angles[214] = (0, -27.0396, 0);
	at[214] = 118.5000;
	points[215] = (11234.6455, 10204.4883, 905.2008);
	angles[215] = (0, -27.0396, 0);
	at[215] = 119;
	points[216] = (11126.8506, 10345.0791, 858.6535);
	angles[216] = (0, -27.0396, 0);
	at[216] = 119.5000;
	points[217] = (11019.0557, 10485.6689, 883.2283);
	angles[217] = (0, -27.0396, 0);
	at[217] = 120;
	points[218] = (10894.7637, 10611.4971, 914.6063);
	angles[218] = (0, -27.0396, 0);
	at[218] = 120.5000;
	points[219] = (10766.6934, 10733.8975, 870.6575);
	angles[219] = (0, -27.0396, 0);
	at[219] = 121;
	points[220] = (10638.6221, 10856.2998, 866.4135);
	angles[220] = (0, -27.0396, 0);
	at[220] = 121.5000;
	points[221] = (10510.5508, 10978.7393, 912.9803);
	angles[221] = (0, -27.0396, 0);
	at[221] = 122;
	points[222] = (10382.4805, 11101.1416, 888.4803);
	angles[222] = (0, -27.0396, 0);
	at[222] = 122.5000;
	points[223] = (10254.4102, 11223.5830, 857.0354);
	angles[223] = (0, -27.0396, 0);
	at[223] = 123;
	points[224] = (10126.3389, 11345.9844, 900.9489);
	angles[224] = (0, -27.0396, 0);
	at[224] = 123.5000;
	points[225] = (9998.2676, 11468.4258, 905.2834);
	angles[225] = (0, -27.0396, 0);
	at[225] = 124;
	points[226] = (9853.5430, 11570.5117, 858.6929);
	angles[226] = (0, -27.0396, 0);
	at[226] = 124.5000;
	points[227] = (9708.4248, 11672.1260, 883.1220);
	angles[227] = (0, -27.0396, 0);
	at[227] = 125;
	points[228] = (9563.2676, 11773.7012, 914.6299);
	angles[228] = (0, -27.0396, 0);
	at[228] = 125.5000;
	points[229] = (9418.1494, 11875.3145, 870.7520);
	angles[229] = (0, -27.0396, 0);
	at[229] = 126;
	points[230] = (9272.9922, 11976.9287, 866.3307);
	angles[230] = (0, -27.0396, 0);
	at[230] = 126.5000;
	points[231] = (9127.8740, 12078.5039, 912.9370);
	angles[231] = (0, -27.0396, 0);
	at[231] = 127;
	points[232] = (8982.7168, 12180.1182, 888.5867);
	angles[232] = (0, -27.0396, 0);
	at[232] = 127.5000;
	points[233] = (8837.5986, 12281.6924, 857.0118);
	angles[233] = (0, -27.0396, 0);
	at[233] = 128;
	points[234] = (8681.0234, 12364.0547, 900.8544);
	angles[234] = (0, -27.0396, 0);
	at[234] = 128.5000;
	points[235] = (8522.2441, 12442.6377, 905.3661);
	angles[235] = (0, -27.0396, 0);
	at[235] = 129;
	points[236] = (8363.4648, 12521.2607, 858.7362);
	angles[236] = (0, -27.0396, 0);
	at[236] = 129.5000;
	points[237] = (8204.6855, 12599.8428, 883.0118);
	angles[237] = (0, -27.0396, 0);
	at[237] = 130;
	points[238] = (8045.9453, 12678.4639, 914.6536);
	angles[238] = (0, -27.0396, 0);
	at[238] = 130.5000;
	points[239] = (7887.1655, 12757.0469, 870.8464);
	angles[239] = (0, -27.0396, 0);
	at[239] = 131;
	points[240] = (7728.3857, 12835.6699, 866.2480);
	angles[240] = (0, -27.0396, 0);
	at[240] = 131.5000;
	points[241] = (7569.6064, 12914.2520, 912.8937);
	angles[241] = (0, -27.0396, 0);
	at[241] = 132;
	points[242] = (7410.8267, 12992.8750, 888.6929);
	angles[242] = (0, -27.0396, 0);
	at[242] = 132.5000;
	points[243] = (7247.0869, 13058.7793, 856.9882);
	angles[243] = (0, -27.0396, 0);
	at[243] = 133;
	points[244] = (7077.1650, 13108.9756, 900.7598);
	angles[244] = (0, -27.0396, 0);
	at[244] = 133.5000;
	points[245] = (6907.2837, 13159.1338, 905.4449);
	angles[245] = (0, -27.0396, 0);
	at[245] = 134;
	points[246] = (6737.3623, 13209.3311, 858.7795);
	angles[246] = (0, -27.0396, 0);
	at[246] = 134.5000;
	points[247] = (6567.4414, 13259.5273, 882.9055);
	angles[247] = (0, -27.0396, 0);
	at[247] = 135;
	points[248] = (6397.5195, 13309.6855, 914.6772);
	angles[248] = (0, -27.0396, 0);
	at[248] = 135.5000;
	points[249] = (6227.6382, 13359.8818, 870.9370);
	angles[249] = (0, -27.0396, 0);
	at[249] = 136;
	points[250] = (6057.7163, 13410.0391, 866.1693);
	angles[250] = (0, -27.0396, 0);
	at[250] = 136.5000;
	points[251] = (5887.7954, 13460.2373, 912.8504);
	angles[251] = (0, -27.0396, 0);
	at[251] = 137;
	points[252] = (5717.9136, 13510.3936, 888.8032);
	angles[252] = (0, -27.0396, 0);
	at[252] = 137.5000;
	points[253] = (5547.9927, 13560.5908, 856.9645);
	angles[253] = (0, -27.0396, 0);
	at[253] = 138;
	points[254] = (5378.0708, 13610.7871, 900.6693);
	angles[254] = (0, -27.0396, 0);
	at[254] = 138.5000;
	points[255] = (5208.1890, 13660.9453, 905.5276);
	angles[255] = (0, -27.0396, 0);
	at[255] = 139;
	points[256] = (5038.2676, 13711.1416, 858.8229);
	angles[256] = (0, -27.0396, 0);
	at[256] = 139.5000;
	points[257] = (4868.3467, 13761.2988, 882.7953);
	angles[257] = (0, -27.0396, 0);
	at[257] = 140;
	points[258] = (4698.4648, 13811.4971, 914.7008);
	angles[258] = (0, -27.0396, 0);
	at[258] = 140.5000;
	points[259] = (4528.5435, 13861.6533, 871.0316);
	angles[259] = (0, -27.0396, 0);
	at[259] = 141;
	points[260] = (4354.1338, 13887.4805, 866.0866);
	angles[260] = (0, -27.0396, 0);
	at[260] = 141.5000;
	points[261] = (4177.5200, 13901.6152, 912.8071);
	angles[261] = (0, -27.0396, 0);
	at[261] = 142;
	points[262] = (4000.9055, 13915.7480, 888.9095);
	angles[262] = (0, -27.0396, 0);
	at[262] = 142.5000;
	points[263] = (3824.3152, 13929.8818, 856.9410);
	angles[263] = (0, -27.0396, 0);
	at[263] = 143;
	points[264] = (3647.7126, 13944.0166, 900.5748);
	angles[264] = (0, -27.0396, 0);
	at[264] = 143.5000;
	points[265] = (3471.1101, 13958.1494, 905.6063);
	angles[265] = (0, -27.0396, 0);
	at[265] = 144;
	points[266] = (3294.5078, 13972.2832, 858.8701);
	angles[266] = (0, -27.0396, 0);
	at[266] = 144.5000;
	points[267] = (3117.9055, 13986.3779, 882.6890);
	angles[267] = (0, -27.0396, 0);
	at[267] = 145;
	points[268] = (2941.3032, 14000.5127, 914.7205);
	angles[268] = (0, -27.0396, 0);
	at[268] = 145.5000;
	points[269] = (2764.7007, 14014.6455, 871.1260);
	angles[269] = (0, -27.0396, 0);
	at[269] = 146;
	points[270] = (2588.0986, 14028.7793, 866.0079);
	angles[270] = (0, -27.0396, 0);
	at[270] = 146.5000;
	points[271] = (2411.4961, 14042.9141, 912.7638);
	angles[271] = (0, -27.0396, 0);
	at[271] = 147;
	points[272] = (2234.8977, 14057.0479, 889.0197);
	angles[272] = (0, -27.0396, 0);
	at[272] = 147.5000;
	points[273] = (2058.2954, 14071.1807, 856.9213);
	angles[273] = (0, -27.0396, 0);
	at[273] = 148;
	points[274] = (1881.6772, 14085.0400, 900.4803);
	angles[274] = (0, -27.0396, 0);
	at[274] = 148.5000;
	points[275] = (1704.7244, 14093.7402, 905.6890);
	angles[275] = (0, -27.0396, 0);
	at[275] = 149;
	points[276] = (1527.7717, 14102.4805, 858.9134);
	angles[276] = (0, -27.0396, 0);
	at[276] = 149.5000;
	points[277] = (1350.8229, 14111.1816, 882.5827);
	angles[277] = (0, -27.0396, 0);
	at[277] = 150;
	points[278] = (1173.8701, 14119.8818, 914.7441);
	angles[278] = (0, -27.0396, 0);
	at[278] = 150.5000;
	points[279] = (996.9213, 14128.5830, 871.2205);
	angles[279] = (0, -27.0396, 0);
	at[279] = 151;
	points[280] = (819.9685, 14137.3232, 865.9252);
	angles[280] = (0, -27.0396, 0);
	at[280] = 151.5000;
	points[281] = (643.0157, 14146.0234, 912.7166);
	angles[281] = (0, -27.0396, 0);
	at[281] = 152;
	points[282] = (466.0670, 14154.7246, 889.1260);
	angles[282] = (0, -27.0396, 0);
	at[282] = 152.5000;
	points[283] = (289.1185, 14163.4258, 856.8976);
	angles[283] = (0, -27.0396, 0);
	at[283] = 153;
	points[284] = (112.1697, 14172.1650, 900.3859);
	angles[284] = (0, -27.0396, 0);
	at[284] = 153.5000;
	points[285] = (-64.7791, 14180.8662, 905.7678);
	angles[285] = (0, -27.0396, 0);
	at[285] = 154;
	points[286] = (-241.7280, 14189.5674, 858.9567);
	angles[286] = (0, -27.0396, 0);
	at[286] = 154.5000;
	points[287] = (-418.6772, 14198.3066, 882.4725);
	angles[287] = (0, -27.0396, 0);
	at[287] = 155;
	points[288] = (-595.6260, 14207.0078, 914.7677);
	angles[288] = (0, -27.0396, 0);
	at[288] = 155.5000;
	points[289] = (-772.5748, 14215.7090, 871.3149);
	angles[289] = (0, -27.0396, 0);
	at[289] = 156;
	points[290] = (-949.4843, 14215.8662, 865.8465);
	angles[290] = (0, -27.0396, 0);
	at[290] = 156.5000;
	points[291] = (-1126.3386, 14205.4326, 912.6732);
	angles[291] = (0, -27.0396, 0);
	at[291] = 157;
	points[292] = (-1303.1969, 14195.0391, 889.2323);
	angles[292] = (0, -27.0396, 0);
	at[292] = 157.5000;
	points[293] = (-1480.0551, 14184.6064, 856.8780);
	angles[293] = (0, -27.0396, 0);
	at[293] = 158;
	points[294] = (-1656.9135, 14174.1729, 900.2913);
	angles[294] = (0, -27.0396, 0);
	at[294] = 158.5000;
	points[295] = (-1833.7717, 14163.7402, 905.8464);
	angles[295] = (0, -27.0396, 0);
	at[295] = 159;
	points[296] = (-2010.6299, 14153.3066, 859.0040);
	angles[296] = (0, -27.0396, 0);
	at[296] = 159.5000;
	points[297] = (-2187.4883, 14142.8740, 882.3661);
	angles[297] = (0, -27.0396, 0);
	at[297] = 160;
	points[298] = (-2364.3503, 14132.4404, 914.7874);
	angles[298] = (0, -27.0396, 0);
	at[298] = 160.5000;
	points[299] = (-2541.2087, 14122.0078, 871.4095);
	angles[299] = (0, -27.0396, 0);
	at[299] = 161;
	points[300] = (-2718.0671, 14111.5742, 865.7677);
	angles[300] = (0, -27.0396, 0);
	at[300] = 161.5000;
	points[301] = (-2894.9250, 14101.1426, 912.6260);
	angles[301] = (0, -27.0396, 0);
	at[301] = 162;
	points[302] = (-3071.7834, 14090.7480, 889.3425);
	angles[302] = (0, -27.0396, 0);
	at[302] = 162.5000;
	points[303] = (-3248.6418, 14080.3154, 856.8543);
	angles[303] = (0, -27.0396, 0);
	at[303] = 163;
	points[304] = (-3425.5039, 14069.8818, 900.1968);
	angles[304] = (0, -27.0396, 0);
	at[304] = 163.5000;
	points[305] = (-3602.3623, 14059.4482, 905.9252);
	angles[305] = (0, -27.0396, 0);
	at[305] = 164;
	points[306] = (-3779.2207, 14049.0156, 859.0472);
	angles[306] = (0, -27.0396, 0);
	at[306] = 164.5000;
	points[307] = (-3956.0630, 14038.5820, 882.2599);
	angles[307] = (0, -27.0396, 0);
	at[307] = 165;
	points[308] = (-4128.7402, 14009.8428, 914.8071);
	angles[308] = (0, -27.0396, 0);
	at[308] = 165.5000;
	points[309] = (-4292.4805, 13942.2041, 871.5040);
	angles[309] = (0, -27.0396, 0);
	at[309] = 166;
	points[310] = (-4456.2207, 13874.5674, 865.6851);
	angles[310] = (0, -27.0396, 0);
	at[310] = 166.5000;
	points[311] = (-4619.9604, 13806.9297, 912.5827);
	angles[311] = (0, -27.0396, 0);
	at[311] = 167;
	points[312] = (-4783.7402, 13739.2910, 889.4488);
	angles[312] = (0, -27.0396, 0);
	at[312] = 167.5000;
	points[313] = (-4947.4805, 13671.6543, 856.8347);
	angles[313] = (0, -27.0396, 0);
	at[313] = 168;
	points[314] = (-5111.2202, 13604.0156, 900.1024);
	angles[314] = (0, -27.0396, 0);
	at[314] = 168.5000;
	points[315] = (-5274.9604, 13536.3779, 906.0040);
	angles[315] = (0, -27.0396, 0);
	at[315] = 169;
	points[316] = (-5438.7012, 13468.7402, 859.0945);
	angles[316] = (0, -27.0396, 0);
	at[316] = 169.5000;
	points[317] = (-5602.4409, 13401.1025, 882.1497);
	angles[317] = (0, -27.0396, 0);
	at[317] = 170;
	points[318] = (-5766.2207, 13333.4648, 914.8307);
	angles[318] = (0, -27.0396, 0);
	at[318] = 170.5000;
	points[319] = (-5929.9609, 13265.8662, 871.5984);
	angles[319] = (0, -27.0396, 0);
	at[319] = 171;
	points[320] = (-6093.7007, 13198.2275, 865.6063);
	angles[320] = (0, -27.0396, 0);
	at[320] = 171.5000;
	points[321] = (-6257.4409, 13130.5908, 912.5355);
	angles[321] = (0, -27.0396, 0);
	at[321] = 172;
	points[322] = (-6421.1816, 13062.9531, 889.5551);
	angles[322] = (0, -27.0396, 0);
	at[322] = 172.5000;
	points[323] = (-6584.9214, 12995.3145, 856.8149);
	angles[323] = (0, -27.0396, 0);
	at[323] = 173;
	points[324] = (-6748.7012, 12927.6777, 900.0079);
	angles[324] = (0, -27.0396, 0);
	at[324] = 173.5000;
	points[325] = (-6912.4414, 12860.0391, 906.0867);
	angles[325] = (0, -27.0396, 0);
	at[325] = 174;
	points[326] = (-7076.1812, 12792.4014, 859.1418);
	angles[326] = (0, -27.0396, 0);
	at[326] = 174.5000;
	points[327] = (-7239.9214, 12724.7646, 882.0433);
	angles[327] = (0, -27.0396, 0);
	at[327] = 175;
	points[328] = (-7403.6611, 12657.1260, 914.8504);
	angles[328] = (0, -27.0396, 0);
	at[328] = 175.5000;
	points[329] = (-7567.4019, 12589.4883, 871.6929);
	angles[329] = (0, -27.0396, 0);
	at[329] = 176;
	points[330] = (-7731.1812, 12521.8506, 865.5316);
	angles[330] = (0, -27.0396, 0);
	at[330] = 176.5000;
	points[331] = (-7894.9214, 12454.2529, 912.4882);
	angles[331] = (0, -27.0396, 0);
	at[331] = 177;
	points[332] = (-8058.6616, 12386.6143, 889.6653);
	angles[332] = (0, -27.0396, 0);
	at[332] = 177.5000;
	points[333] = (-8222.4014, 12318.9766, 856.7953);
	angles[333] = (0, -27.0396, 0);
	at[333] = 178;
	points[334] = (-8386.1416, 12251.3379, 899.9134);
	angles[334] = (0, -27.0396, 0);
	at[334] = 178.5000;
	points[335] = (-8549.8818, 12183.7012, 906.1653);
	angles[335] = (0, -27.0396, 0);
	at[335] = 179;
	points[336] = (-8677.5195, 12061.7715, 859.1890);
	angles[336] = (0, -27.0396, 0);
	at[336] = 179.5000;
	points[337] = (-8803.1504, 11936.8516, 881.9370);
	angles[337] = (0, -27.0396, 0);
	at[337] = 180;
	points[338] = (-8928.7402, 11811.9297, 914.8701);
	angles[338] = (0, -27.0396, 0);
	at[338] = 180.5000;
	points[339] = (-9054.3701, 11686.9688, 871.7913);
	angles[339] = (0, -27.0396, 0);
	at[339] = 181;
	points[340] = (-9179.9609, 11562.0469, 865.4528);
	angles[340] = (0, -27.0396, 0);
	at[340] = 181.5000;
	points[341] = (-9305.5908, 11437.1260, 912.4410);
	angles[341] = (0, -27.0396, 0);
	at[341] = 182;
	points[342] = (-9431.2207, 11312.1660, 889.7717);
	angles[342] = (0, -27.0396, 0);
	at[342] = 182.5000;
	points[343] = (-9556.8105, 11187.2441, 856.7756);
	angles[343] = (0, -27.0396, 0);
	at[343] = 183;
	points[344] = (-9682.4414, 11062.2832, 899.8150);
	angles[344] = (0, -27.0396, 0);
	at[344] = 183.5000;
	points[345] = (-9808.0312, 10937.3623, 906.2441);
	angles[345] = (0, -27.0396, 0);
	at[345] = 184;
	points[346] = (-9933.6621, 10812.4023, 859.2322);
	angles[346] = (0, -27.0396, 0);
	at[346] = 184.5000;
	points[347] = (-10059.2520, 10687.4805, 881.8268);
	angles[347] = (0, -27.0396, 0);
	at[347] = 185;
	points[348] = (-10184.8828, 10562.5596, 914.8898);
	angles[348] = (0, -27.0396, 0);
	at[348] = 185.5000;
	points[349] = (-10310.5117, 10437.5986, 871.8819);
	angles[349] = (0, -27.0396, 0);
	at[349] = 186;
	points[350] = (-10436.1025, 10312.6768, 865.3701);
	angles[350] = (0, -27.0396, 0);
	at[350] = 186.5000;
	points[351] = (-10561.7324, 10187.7168, 912.3937);
	angles[351] = (0, -27.0396, 0);
	at[351] = 187;
	points[352] = (-10687.3232, 10062.7959, 889.8779);
	angles[352] = (0, -27.0396, 0);
	at[352] = 187.5000;
	points[353] = (-10812.9521, 9937.8740, 856.7559);
	angles[353] = (0, -27.0396, 0);
	at[353] = 188;
	points[354] = (-10938.5430, 9812.9131, 899.7205);
	angles[354] = (0, -27.0396, 0);
	at[354] = 188.5000;
	points[355] = (-11064.1729, 9687.9922, 906.3228);
	angles[355] = (0, -27.0396, 0);
	at[355] = 189;
	points[356] = (-11189.7637, 9563.0312, 859.2795);
	angles[356] = (0, -27.0396, 0);
	at[356] = 189.5000;
	points[357] = (-11315.3945, 9438.1104, 881.7205);
	angles[357] = (0, -27.0396, 0);
	at[357] = 190;
	points[358] = (-11441.0234, 9313.1885, 914.9055);
	angles[358] = (0, -27.0396, 0);
	at[358] = 190.5000;
	points[359] = (-11566.6143, 9188.2285, 871.9803);
	angles[359] = (0, -27.0396, 0);
	at[359] = 191;
	points[360] = (-11642.0078, 9029.2129, 865.2953);
	angles[360] = (0, -27.0396, 0);
	at[360] = 191.5000;
	points[361] = (-11711.8115, 8866.3779, 912.3464);
	angles[361] = (0, -27.0396, 0);
	at[361] = 192;
	points[362] = (-11781.5752, 8703.5039, 889.9843);
	angles[362] = (0, -27.0396, 0);
	at[362] = 192.5000;
	points[363] = (-11851.3779, 8540.6689, 856.7363);
	angles[363] = (0, -27.0396, 0);
	at[363] = 193;
	points[364] = (-11921.1816, 8377.8350, 899.6260);
	angles[364] = (0, -27.0396, 0);
	at[364] = 193.5000;
	points[365] = (-11990.9453, 8215, 906.3976);
	angles[365] = (0, -27.0396, 0);
	at[365] = 194;
	points[366] = (-12060.7480, 8052.1650, 859.3307);
	angles[366] = (0, -27.0396, 0);
	at[366] = 194.5000;
	points[367] = (-12130.5508, 7889.3311, 881.6142);
	angles[367] = (0, -27.0396, 0);
	at[367] = 195;
	points[368] = (-12200.3154, 7726.4966, 914.9252);
	angles[368] = (0, -27.0396, 0);
	at[368] = 195.5000;
	points[369] = (-12270.1191, 7563.6221, 872.0748);
	angles[369] = (0, -27.0396, 0);
	at[369] = 196;
	points[370] = (-12339.8828, 7400.7871, 865.2166);
	angles[370] = (0, -27.0396, 0);
	at[370] = 196.5000;
	points[371] = (-12409.6846, 7237.9526, 912.2992);
	angles[371] = (0, -27.0396, 0);
	at[371] = 197;
	points[372] = (-12479.3711, 7075.0786, 890.0945);
	angles[372] = (0, -27.0396, 0);
	at[372] = 197.5000;
	points[373] = (-12548.8184, 6912.0869, 856.7205);
	angles[373] = (0, -27.0396, 0);
	at[373] = 198;
	points[374] = (-12618.2676, 6749.0947, 899.5275);
	angles[374] = (0, -27.0396, 0);
	at[374] = 198.5000;
	points[375] = (-12687.7168, 6586.1025, 906.4764);
	angles[375] = (0, -27.0396, 0);
	at[375] = 199;
	points[376] = (-12757.1660, 6423.1104, 859.3779);
	angles[376] = (0, -27.0396, 0);
	at[376] = 199.5000;
	points[377] = (-12826.6143, 6260.1182, 881.5039);
	angles[377] = (0, -27.0396, 0);
	at[377] = 200;
	points[378] = (-12896.0635, 6097.1650, 914.9449);
	angles[378] = (0, -27.0396, 0);
	at[378] = 200.5000;
	points[379] = (-12965.4727, 5934.1733, 872.1732);
	angles[379] = (0, -27.0396, 0);
	at[379] = 201;
	points[380] = (-13034.9219, 5771.1812, 865.1378);
	angles[380] = (0, -27.0396, 0);
	at[380] = 201.5000;
	points[381] = (-13104.3711, 5608.1890, 912.2520);
	angles[381] = (0, -27.0396, 0);
	at[381] = 202;
	points[382] = (-13173.8184, 5445.1968, 890.2007);
	angles[382] = (0, -27.0396, 0);
	at[382] = 202.5000;
	points[383] = (-13243.2676, 5282.2046, 856.7008);
	angles[383] = (0, -27.0396, 0);
	at[383] = 203;
	points[384] = (-13264.7246, 5107.3623, 899.4331);
	angles[384] = (0, -27.0396, 0);
	at[384] = 203.5000;
	points[385] = (-13279.2920, 4930.7871, 906.5511);
	angles[385] = (0, -27.0396, 0);
	at[385] = 204;
	points[386] = (-13293.8584, 4754.2129, 859.4252);
	angles[386] = (0, -27.0396, 0);
	at[386] = 204.5000;
	points[387] = (-13308.4248, 4577.6382, 881.3977);
	angles[387] = (0, -27.0396, 0);
	at[387] = 205;
	points[388] = (-13322.9922, 4401.1025, 914.9606);
	angles[388] = (0, -27.0396, 0);
	at[388] = 205.5000;
	points[389] = (-13337.5586, 4224.5278, 872.2677);
	angles[389] = (0, -27.0396, 0);
	at[389] = 206;
	points[390] = (-13352.1270, 4047.9529, 865.0630);
	angles[390] = (0, -27.0396, 0);
	at[390] = 206.5000;
	points[391] = (-13366.6934, 3871.3857, 912.2047);
	angles[391] = (0, -27.0396, 0);
	at[391] = 207;
	points[392] = (-13381.2598, 3694.8230, 890.3071);
	angles[392] = (0, -27.0396, 0);
	at[392] = 207.5000;
	points[393] = (-13395.8271, 3518.2561, 856.6812);
	angles[393] = (0, -27.0396, 0);
	at[393] = 208;
	points[394] = (-13410.3936, 3341.6890, 899.3386);
	angles[394] = (0, -27.0396, 0);
	at[394] = 208.5000;
	points[395] = (-13424.9600, 3165.1262, 906.6299);
	angles[395] = (0, -27.0396, 0);
	at[395] = 209;
	points[396] = (-13439.5283, 2988.5591, 859.4764);
	angles[396] = (0, -27.0396, 0);
	at[396] = 209.5000;
	points[397] = (-13454.0947, 2811.9961, 881.2913);
	angles[397] = (0, -27.0396, 0);
	at[397] = 210;
	points[398] = (-13468.6621, 2635.4292, 914.9803);
	angles[398] = (0, -27.0396, 0);
	at[398] = 210.5000;
	points[399] = (-13483.2285, 2458.8623, 872.3661);
	angles[399] = (0, -27.0396, 0);
	at[399] = 211;
	points[400] = (-13497.7949, 2282.2993, 864.9843);
	angles[400] = (0, -27.0396, 0);
	at[400] = 211.5000;
	points[401] = (-13512.3623, 2105.7322, 912.1535);
	angles[401] = (0, -27.0396, 0);
	at[401] = 212;
	points[402] = (-13526.9297, 1929.1654, 890.4174);
	angles[402] = (0, -27.0396, 0);
	at[402] = 212.5000;
	points[403] = (-13541.4971, 1752.6024, 856.6653);
	angles[403] = (0, -27.0396, 0);
	at[403] = 213;
	points[404] = (-13556.0635, 1576.0354, 899.2402);
	angles[404] = (0, -27.0396, 0);
	at[404] = 213.5000;
	points[405] = (-13570.6299, 1399.4724, 906.7086);
	angles[405] = (0, -27.0396, 0);
	at[405] = 214;
	points[406] = (-13585.1973, 1222.9094, 859.5236);
	angles[406] = (0, -27.0396, 0);
	at[406] = 214.5000;
	points[407] = (-13599.7637, 1046.3464, 881.1850);
	angles[407] = (0, -27.0396, 0);
	at[407] = 215;
	points[408] = (-13614.3301, 869.7835, 914.9961);
	angles[408] = (0, -27.0396, 0);
	at[408] = 215.5000;
	points[409] = (-13628.8984, 693.2166, 872.4606);
	angles[409] = (0, -27.0396, 0);
	at[409] = 216;
	points[410] = (-13643.4648, 516.6536, 864.9095);
	angles[410] = (0, -27.0396, 0);
	at[410] = 216.5000;
	points[411] = (-13658.0312, 340.0910, 912.1063);
	angles[411] = (0, -27.0396, 0);
	at[411] = 217;
	points[412] = (-13634.2920, 164.5047, 890.5237);
	angles[412] = (0, -27.0396, 0);
	at[412] = 217.5000;
	points[413] = (-13610.7090, -11.0867, 856.6496);
	angles[413] = (0, -27.0396, 0);
	at[413] = 218;
	points[414] = (-13587.1660, -186.6787, 899.1417);
	angles[414] = (0, -27.0396, 0);
	at[414] = 218.5000;
	points[415] = (-13563.5830, -362.2709, 906.7835);
	angles[415] = (0, -27.0396, 0);
	at[415] = 219;
	points[416] = (-13540.0391, -537.8622, 859.5709);
	angles[416] = (0, -27.0396, 0);
	at[416] = 219.5000;
	points[417] = (-13516.4570, -713.4528, 881.0787);
	angles[417] = (0, -27.0396, 0);
	at[417] = 220;
	points[418] = (-13492.9141, -889.0473, 915.0118);
	angles[418] = (0, -27.0396, 0);
	at[418] = 220.5000;
	points[419] = (-13469.3711, -1064.6378, 872.5591);
	angles[419] = (0, -27.0396, 0);
	at[419] = 221;
	points[420] = (-13445.7881, -1240.2284, 864.8307);
	angles[420] = (0, -27.0396, 0);
	at[420] = 221.5000;
	points[421] = (-13422.2441, -1415.8188, 912.0552);
	angles[421] = (0, -27.0396, 0);
	at[421] = 222;
	points[422] = (-13398.6611, -1591.4055, 890.6299);
	angles[422] = (0, -27.0396, 0);
	at[422] = 222.5000;
	points[423] = (-13375.1182, -1766.9960, 856.6339);
	angles[423] = (0, -27.0396, 0);
	at[423] = 223;
	points[424] = (-13351.5352, -1942.5867, 899.0472);
	angles[424] = (0, -27.0396, 0);
	at[424] = 223.5000;
	points[425] = (-13327.9922, -2118.1772, 906.8583);
	angles[425] = (0, -27.0396, 0);
	at[425] = 224;
	points[426] = (-13304.4102, -2293.7639, 859.6221);
	angles[426] = (0, -27.0396, 0);
	at[426] = 224.5000;
	points[427] = (-13280.8672, -2469.3542, 880.9724);
	angles[427] = (0, -27.0396, 0);
	at[427] = 225;
	points[428] = (-13257.2832, -2644.9451, 915.0275);
	angles[428] = (0, -27.0396, 0);
	at[428] = 225.5000;
	points[429] = (-13233.7402, -2820.5396, 872.6536);
	angles[429] = (0, -27.0396, 0);
	at[429] = 226;
	points[430] = (-13210.1572, -2996.1299, 864.7559);
	angles[430] = (0, -27.0396, 0);
	at[430] = 226.5000;
	points[431] = (-13186.6143, -3171.7205, 912.0079);
	angles[431] = (0, -27.0396, 0);
	at[431] = 227;
	points[432] = (-13163.0322, -3347.3110, 890.7363);
	angles[432] = (0, -27.0396, 0);
	at[432] = 227.5000;
	points[433] = (-13139.4893, -3522.9055, 856.6182);
	angles[433] = (0, -27.0396, 0);
	at[433] = 228;
	points[434] = (-13115.9062, -3698.4963, 898.9488);
	angles[434] = (0, -27.0396, 0);
	at[434] = 228.5000;
	points[435] = (-13092.3623, -3874.0906, 906.9370);
	angles[435] = (0, -27.0396, 0);
	at[435] = 229;
	points[436] = (-13068.8193, -4049.6851, 859.6732);
	angles[436] = (0, -27.0396, 0);
	at[436] = 229.5000;
	points[437] = (-13045.2363, -4225.2754, 880.8622);
	angles[437] = (0, -27.0396, 0);
	at[437] = 230;
	points[438] = (-13021.6934, -4400.8662, 915.0433);
	angles[438] = (0, -27.0396, 0);
	at[438] = 230.5000;
	points[439] = (-12998.1104, -4576.4565, 872.7520);
	angles[439] = (0, -27.0396, 0);
	at[439] = 231;
	points[440] = (-12971.6543, -4751.2207, 864.6811);
	angles[440] = (0, -27.0396, 0);
	at[440] = 231.5000;
	points[441] = (-12896.6143, -4911.6934, 911.9567);
	angles[441] = (0, -27.0396, 0);
	at[441] = 232;
	points[442] = (-12821.6143, -5072.2046, 890.8425);
	angles[442] = (0, -27.0396, 0);
	at[442] = 232.5000;
	points[443] = (-12746.5752, -5232.6772, 856.6024);
	angles[443] = (0, -27.0396, 0);
	at[443] = 233;
	points[444] = (-12671.5752, -5393.1890, 898.8544);
	angles[444] = (0, -27.0396, 0);
	at[444] = 233.5000;
	points[445] = (-12596.5352, -5553.7007, 907.0118);
	angles[445] = (0, -27.0396, 0);
	at[445] = 234;
	points[446] = (-12521.4961, -5714.1733, 859.7244);
	angles[446] = (0, -27.0396, 0);
	at[446] = 234.5000;
	points[447] = (-12446.4961, -5874.6851, 880.7559);
	angles[447] = (0, -27.0396, 0);
	at[447] = 235;
	points[448] = (-12371.4561, -6035.1973, 915.0591);
	angles[448] = (0, -27.0396, 0);
	at[448] = 235.5000;
	points[449] = (-12296.4561, -6195.6689, 872.8504);
	angles[449] = (0, -27.0396, 0);
	at[449] = 236;
	points[450] = (-12221.4180, -6356.1816, 864.6063);
	angles[450] = (0, -27.0396, 0);
	at[450] = 236.5000;
	points[451] = (-12146.4180, -6516.6929, 911.9055);
	angles[451] = (0, -27.0396, 0);
	at[451] = 237;
	points[452] = (-12071.3779, -6677.1655, 890.9489);
	angles[452] = (0, -27.0396, 0);
	at[452] = 237.5000;
	points[453] = (-11996.3389, -6837.6772, 856.5866);
	angles[453] = (0, -27.0396, 0);
	at[453] = 238;
	points[454] = (-11921.3389, -6998.1890, 898.7559);
	angles[454] = (0, -27.0396, 0);
	at[454] = 238.5000;
	points[455] = (-11846.2988, -7158.6616, 907.0867);
	angles[455] = (0, -27.0396, 0);
	at[455] = 239;
	points[456] = (-11771.2988, -7319.1733, 859.7756);
	angles[456] = (0, -27.0396, 0);
	at[456] = 239.5000;
	points[457] = (-11696.2598, -7479.6460, 880.6496);
	angles[457] = (0, -27.0396, 0);
	at[457] = 240;
	points[458] = (-11621.2598, -7640.1577, 915.0748);
	angles[458] = (0, -27.0396, 0);
	at[458] = 240.5000;
	points[459] = (-11546.2197, -7800.6689, 872.9488);
	angles[459] = (0, -27.0396, 0);
	at[459] = 241;
	points[460] = (-11471.2197, -7961.1416, 864.5275);
	angles[460] = (0, -27.0396, 0);
	at[460] = 241.5000;
	points[461] = (-11396.1816, -8121.6533, 911.8544);
	angles[461] = (0, -27.0396, 0);
	at[461] = 242;
	points[462] = (-11321.1816, -8282.1660, 891.0551);
	angles[462] = (0, -27.0396, 0);
	at[462] = 242.5000;
	points[463] = (-11246.1426, -8442.6377, 856.5709);
	angles[463] = (0, -27.0396, 0);
	at[463] = 243;
	points[464] = (-11171.1025, -8603.1494, 898.6575);
	angles[464] = (0, -27.0396, 0);
	at[464] = 243.5000;
	points[465] = (-11096.1025, -8763.6221, 907.1614);
	angles[465] = (0, -27.0396, 0);
	at[465] = 244;
	points[466] = (-11021.0635, -8924.1338, 859.8229);
	angles[466] = (0, -27.0396, 0);
	at[466] = 244.5000;
	points[467] = (-10909.5273, -9057.5986, 880.5433);
	angles[467] = (0, -27.0396, 0);
	at[467] = 245;
	points[468] = (-10777.9922, -9176.2998, 915.0905);
	angles[468] = (0, -27.0396, 0);
	at[468] = 245.5000;
	points[469] = (-10646.4961, -9295, 873.0472);
	angles[469] = (0, -27.0396, 0);
	at[469] = 246;
	points[470] = (-10514.9600, -9413.7012, 864.4528);
	angles[470] = (0, -27.0396, 0);
	at[470] = 246.5000;
	points[471] = (-10383.4258, -9532.4014, 911.8032);
	angles[471] = (0, -27.0396, 0);
	at[471] = 247;
	points[472] = (-10251.9287, -9651.1025, 891.1653);
	angles[472] = (0, -27.0396, 0);
	at[472] = 247.5000;
	points[473] = (-10120.3945, -9769.8037, 856.5551);
	angles[473] = (0, -27.0396, 0);
	at[473] = 248;
	points[474] = (-9988.8975, -9888.5039, 898.5591);
	angles[474] = (0, -27.0396, 0);
	at[474] = 248.5000;
	points[475] = (-9857.3623, -10007.2051, 907.2363);
	angles[475] = (0, -27.0396, 0);
	at[475] = 249;
	points[476] = (-9725.8662, -10125.9453, 859.8780);
	angles[476] = (0, -27.0396, 0);
	at[476] = 249.5000;
	points[477] = (-9594.3311, -10244.6455, 880.4370);
	angles[477] = (0, -27.0396, 0);
	at[477] = 250;
	points[478] = (-9462.7949, -10363.3467, 915.1063);
	angles[478] = (0, -27.0396, 0);
	at[478] = 250.5000;
	points[479] = (-9331.2988, -10482.0469, 873.1417);
	angles[479] = (0, -27.0396, 0);
	at[479] = 251;
	points[480] = (-9199.7637, -10600.7480, 864.3780);
	angles[480] = (0, -27.0396, 0);
	at[480] = 251.5000;
	points[481] = (-9068.2676, -10719.4482, 911.7520);
	angles[481] = (0, -27.0396, 0);
	at[481] = 252;
	points[482] = (-8936.7324, -10838.1494, 891.2678);
	angles[482] = (0, -27.0396, 0);
	at[482] = 252.5000;
	points[483] = (-8805.2363, -10956.8496, 856.5433);
	angles[483] = (0, -27.0396, 0);
	at[483] = 253;
	points[484] = (-8673.7012, -11075.5518, 898.4606);
	angles[484] = (0, -27.0396, 0);
	at[484] = 253.5000;
	points[485] = (-8542.1650, -11194.2529, 907.3110);
	angles[485] = (0, -27.0396, 0);
	at[485] = 254;
	points[486] = (-8410.6689, -11312.9531, 859.9291);
	angles[486] = (0, -27.0396, 0);
	at[486] = 254.5000;
	points[487] = (-8279.1338, -11431.6543, 880.3307);
	angles[487] = (0, -27.0396, 0);
	at[487] = 255;
	points[488] = (-8147.6377, -11550.3545, 915.1181);
	angles[488] = (0, -27.0396, 0);
	at[488] = 255.5000;
	points[489] = (-8016.1021, -11669.0938, 873.2402);
	angles[489] = (0, -27.0396, 0);
	at[489] = 256;
	points[490] = (-7884.5674, -11787.7959, 864.3071);
	angles[490] = (0, -27.0396, 0);
	at[490] = 256.5000;
	points[491] = (-7826.1812, -11840.4717, 885.8268);
	angles[491] = (0, -27.0396, 0);
	at[491] = 256.7170;
	mover = getEnt("iz_obj_8", "targetname");
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
