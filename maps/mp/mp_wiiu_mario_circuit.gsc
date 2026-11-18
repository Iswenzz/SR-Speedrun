main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_wiiu_mario_circuit", 0);

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
	ambientPlay("iz_0_umc", 2);
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
	level.iz_route[level.iz_route.size] = (-11, -604, 3792);
	level.iz_route[level.iz_route.size] = (34, -1971, 3794);
	level.iz_route[level.iz_route.size] = (131, -3427, 3798);
	level.iz_route[level.iz_route.size] = (609, -4399, 3781);
	level.iz_route[level.iz_route.size] = (1339, -4794, 3686);
	level.iz_route[level.iz_route.size] = (2260, -5029, 3551);
	level.iz_route[level.iz_route.size] = (3095, -4986, 3429);
	level.iz_route[level.iz_route.size] = (3852, -4458, 3258);
	level.iz_route[level.iz_route.size] = (4142, -3827, 3113);
	level.iz_route[level.iz_route.size] = (4337, -3295, 3011);
	level.iz_route[level.iz_route.size] = (4382, -2529, 2880);
	level.iz_route[level.iz_route.size] = (4079, -1859, 2749);
	level.iz_route[level.iz_route.size] = (3581, -1198, 2616);
	level.iz_route[level.iz_route.size] = (2206, 282, 2502);
	level.iz_route[level.iz_route.size] = (1679, 1087, 2485);
	level.iz_route[level.iz_route.size] = (1121, 2051, 2472);
	level.iz_route[level.iz_route.size] = (775, 3653, 2442);
	level.iz_route[level.iz_route.size] = (186, 5357, 2339);
	level.iz_route[level.iz_route.size] = (-255, 6270, 2303);
	level.iz_route[level.iz_route.size] = (-947, 6795, 2279);
	level.iz_route[level.iz_route.size] = (-1731, 7132, 2262);
	level.iz_route[level.iz_route.size] = (-2618, 7102, 2214);
	level.iz_route[level.iz_route.size] = (-3514, 6832, 2135);
	level.iz_route[level.iz_route.size] = (-4083, 5796, 1925);
	level.iz_route[level.iz_route.size] = (-4428, 4769, 1776);
	level.iz_route[level.iz_route.size] = (-3998, 3485, 1576);
	level.iz_route[level.iz_route.size] = (-3037, 2816, 1399);
	level.iz_route[level.iz_route.size] = (-1283, 1863, 1245);
	level.iz_route[level.iz_route.size] = (349, 1082, 1307);
	level.iz_route[level.iz_route.size] = (2593, -338, 1629);
	level.iz_route[level.iz_route.size] = (3946, -1492, 1867);
	level.iz_route[level.iz_route.size] = (4241, -2629, 1956);
	level.iz_route[level.iz_route.size] = (4136, -3634, 1993);
	level.iz_route[level.iz_route.size] = (3945, -4329, 2052);
	level.iz_route[level.iz_route.size] = (3587, -4833, 2087);
	level.iz_route[level.iz_route.size] = (2899, -5063, 2059);
	level.iz_route[level.iz_route.size] = (2085, -5284, 2105);
	level.iz_route[level.iz_route.size] = (1363, -5220, 2107);
	level.iz_route[level.iz_route.size] = (684, -4795, 2055);
	level.iz_route[level.iz_route.size] = (107, -4064, 1970);
	level.iz_route[level.iz_route.size] = (-143, -3436, 1926);
	level.iz_route[level.iz_route.size] = (-158, -2652, 1847);
	level.iz_route[level.iz_route.size] = (6, -929, 1781);
	level.iz_route[level.iz_route.size] = (-1, 516, 1892);
	level.iz_route[level.iz_route.size] = (-198, 1367, 2075);
	level.iz_route[level.iz_route.size] = (-538, 1919, 2210);
	level.iz_route[level.iz_route.size] = (-1165, 2214, 2290);
	level.iz_route[level.iz_route.size] = (-2312, 2322, 2403);
	level.iz_route[level.iz_route.size] = (-3294, 2701, 2565);
	level.iz_route[level.iz_route.size] = (-4115, 3532, 2772);
	level.iz_route[level.iz_route.size] = (-4374, 4674, 2970);
	level.iz_route[level.iz_route.size] = (-4126, 5495, 3119);
	level.iz_route[level.iz_route.size] = (-3656, 6192, 3279);
	level.iz_route[level.iz_route.size] = (-2976, 6662, 3436);
	level.iz_route[level.iz_route.size] = (-2257, 6915, 3579);
	level.iz_route[level.iz_route.size] = (-1212, 6592, 3707);
	level.iz_route[level.iz_route.size] = (-445, 5970, 3786);
	level.iz_route[level.iz_route.size] = (34, 4650, 3796);
	level.iz_route[level.iz_route.size] = (135, 3649, 3794);
	level.iz_route[level.iz_route.size] = (105, 1514, 3791);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-5265.2759, 4394.4092, 5582.3228);
	angles[0] = (0, -97, 0);
	at[0] = 0;
	points[1] = (-5379.0552, 4840.7480, 5582.3228);
	angles[1] = (0, -97, 0);
	at[1] = 2.6000;
	points[2] = (-5377.0474, 4878.5039, 5582.3228);
	angles[2] = (0, -97, 0);
	at[2] = 2.8167;
	points[3] = (-5319.5674, 5258.0317, 5582.3228);
	angles[3] = (0, -97, 0);
	at[3] = 4.9833;
	points[4] = (-5310.6694, 5294.8037, 5582.3228);
	angles[4] = (0, -97, 0);
	at[4] = 5.2000;
	points[5] = (-5076.4570, 5646.1021, 5582.3228);
	angles[5] = (0, -97, 0);
	at[5] = 7.5833;
	points[6] = (-4754.8818, 5855.5513, 5582.3228);
	angles[6] = (0, -97, 0);
	at[6] = 9.7500;
	points[7] = (-4355.8267, 5993.4644, 5582.3228);
	angles[7] = (0, -97, 0);
	at[7] = 12.1333;
	points[8] = (-3936.5432, 6043.7402, 5582.3228);
	angles[8] = (0, -97, 0);
	at[8] = 14.5167;
	points[9] = (-3898.4448, 6043.1104, 5582.3228);
	angles[9] = (0, -97, 0);
	at[9] = 14.7333;
	points[10] = (-3517.5513, 5995.4727, 5582.3228);
	angles[10] = (0, -97, 0);
	at[10] = 16.9000;
	points[11] = (-3479.9331, 5988.4253, 5582.3228);
	angles[11] = (0, -97, 0);
	at[11] = 17.1167;
	points[12] = (-3074.4961, 5870.9844, 5582.3228);
	angles[12] = (0, -97, 0);
	at[12] = 19.5000;
	points[13] = (-2705.8149, 5665.1577, 5582.3228);
	angles[13] = (0, -97, 0);
	at[13] = 21.8833;
	points[14] = (-2402.6929, 5429.8428, 5582.3228);
	angles[14] = (0, -97, 0);
	at[14] = 24.0500;
	points[15] = (-2378.5435, 5400.6694, 5582.3228);
	angles[15] = (0, -97, 0);
	at[15] = 24.2667;
	points[16] = (-2192.3149, 5109.6851, 5582.3228);
	angles[16] = (0, -97, 0);
	at[16] = 26.2167;
	points[17] = (-2175.0789, 5075.7480, 5582.3228);
	angles[17] = (0, -97, 0);
	at[17] = 26.4333;
	points[18] = (-2085.6653, 4781.9683, 5582.3228);
	angles[18] = (0, -97, 0);
	at[18] = 28.1667;
	points[19] = (-2099.4055, 4398.2681, 5582.3228);
	angles[19] = (0, -97, 0);
	at[19] = 30.3333;
	points[20] = (-2212.3740, 4071.7715, 5582.3228);
	angles[20] = (0, -97, 0);
	at[20] = 32.2833;
	points[21] = (-2232.3899, 4040.4331, 5582.3228);
	angles[21] = (0, -97, 0);
	at[21] = 32.5000;
	points[22] = (-2515.8662, 3781.6023, 5582.3228);
	angles[22] = (0, -97, 0);
	at[22] = 34.6667;
	points[23] = (-2549.7915, 3765.2246, 5582.3228);
	angles[23] = (0, -97, 0);
	at[23] = 34.8833;
	points[24] = (-2950.3701, 3631.7009, 5582.3228);
	angles[24] = (0, -97, 0);
	at[24] = 37.2667;
	points[25] = (-2987.8740, 3624.3623, 5582.3228);
	angles[25] = (0, -97, 0);
	at[25] = 37.4833;
	points[26] = (-3368.7678, 3576.7522, 5582.3228);
	angles[26] = (0, -97, 0);
	at[26] = 39.6500;
	points[27] = (-3406.9688, 3575.4448, 5582.3228);
	angles[27] = (0, -97, 0);
	at[27] = 39.8667;
	points[28] = (-3828.1692, 3602.8662, 5582.3228);
	angles[28] = (0, -97, 0);
	at[28] = 42.2500;
	points[29] = (-4276.9292, 3706.8071, 5582.3228);
	angles[29] = (0, -97, 0);
	at[29] = 44.8500;
	points[30] = (-4640.1968, 3830.7561, 5582.3228);
	angles[30] = (0, -97, 0);
	at[30] = 47.0167;
	points[31] = (-5009.4487, 4105.8662, 5582.3228);
	angles[31] = (0, -97, 0);
	at[31] = 49.6167;
	points[32] = (-5239.9609, 4363.1494, 5582.3228);
	angles[32] = (0, -97, 0);
	at[32] = 51.5667;
	points[33] = (-5265.2759, 4394.4092, 5582.3228);
	angles[33] = (0, -97, 0);
	at[33] = 51.8000;
	mover = getEnt("iz_obj_0", "targetname");
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
