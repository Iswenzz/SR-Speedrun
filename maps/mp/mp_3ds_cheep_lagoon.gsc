main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_3ds_cheep_lagoon", 0);

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
	ambientPlay("iz_0_106", 2);
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
	level.iz_route[level.iz_route.size] = (8099, 3793, 4273);
	level.iz_route[level.iz_route.size] = (8095, 2716, 4265);
	level.iz_route[level.iz_route.size] = (8071, 1710, 4302);
	level.iz_route[level.iz_route.size] = (8095, 807, 4344);
	level.iz_route[level.iz_route.size] = (8095, 18, 4379);
	level.iz_route[level.iz_route.size] = (7871, -519, 4374);
	level.iz_route[level.iz_route.size] = (7410, -977, 4353);
	level.iz_route[level.iz_route.size] = (6867, -1327, 4313);
	level.iz_route[level.iz_route.size] = (5859, -1763, 4265);
	level.iz_route[level.iz_route.size] = (4943, -2196, 4265);
	level.iz_route[level.iz_route.size] = (4314, -2481, 4265);
	level.iz_route[level.iz_route.size] = (3594, -2810, 4310);
	level.iz_route[level.iz_route.size] = (3027, -2957, 2868);
	level.iz_route[level.iz_route.size] = (2552, -3066, 2829);
	level.iz_route[level.iz_route.size] = (1753, -3329, 2749);
	level.iz_route[level.iz_route.size] = (809, -3620, 2595);
	level.iz_route[level.iz_route.size] = (-158, -3906, 2587);
	level.iz_route[level.iz_route.size] = (-239, -4229, 2575);
	level.iz_route[level.iz_route.size] = (-455, -4513, 2619);
	level.iz_route[level.iz_route.size] = (-908, -4709, 2568);
	level.iz_route[level.iz_route.size] = (-1380, -4695, 2376);
	level.iz_route[level.iz_route.size] = (-1744, -4652, 2247);
	level.iz_route[level.iz_route.size] = (-2074, -4614, 2195);
	level.iz_route[level.iz_route.size] = (-2436, -4749, 2200);
	level.iz_route[level.iz_route.size] = (-2881, -4903, 2321);
	level.iz_route[level.iz_route.size] = (-3265, -5093, 2407);
	level.iz_route[level.iz_route.size] = (-3720, -5281, 2331);
	level.iz_route[level.iz_route.size] = (-4173, -5546, 2214);
	level.iz_route[level.iz_route.size] = (-4720, -5708, 2089);
	level.iz_route[level.iz_route.size] = (-5125, -5755, 2052);
	level.iz_route[level.iz_route.size] = (-5538, -5747, 2066);
	level.iz_route[level.iz_route.size] = (-6231, -5514, 2115);
	level.iz_route[level.iz_route.size] = (-6675, -5283, 2179);
	level.iz_route[level.iz_route.size] = (-7263, -4976, 2280);
	level.iz_route[level.iz_route.size] = (-7677, -4558, 2373);
	level.iz_route[level.iz_route.size] = (-7928, -4129, 2434);
	level.iz_route[level.iz_route.size] = (-7930, -3702, 2493);
	level.iz_route[level.iz_route.size] = (-7764, -3265, 2566);
	level.iz_route[level.iz_route.size] = (-7640, -2756, 2688);
	level.iz_route[level.iz_route.size] = (-7751, -2326, 2850);
	level.iz_route[level.iz_route.size] = (-7974, -1918, 2994);
	level.iz_route[level.iz_route.size] = (-8099, -1515, 3110);
	level.iz_route[level.iz_route.size] = (-8081, -1226, 3187);
	level.iz_route[level.iz_route.size] = (-7960, -711, 3337);
	level.iz_route[level.iz_route.size] = (-7657, -191, 3496);
	level.iz_route[level.iz_route.size] = (-7335, 244, 3623);
	level.iz_route[level.iz_route.size] = (-6763, 852, 3790);
	level.iz_route[level.iz_route.size] = (-6081, 1393, 3893);
	level.iz_route[level.iz_route.size] = (-5786, 1630, 3906);
	level.iz_route[level.iz_route.size] = (-5459, 1650, 3906);
	level.iz_route[level.iz_route.size] = (-4860, 1783, 3922);
	level.iz_route[level.iz_route.size] = (-4422, 2003, 3959);
	level.iz_route[level.iz_route.size] = (-4195, 2300, 3986);
	level.iz_route[level.iz_route.size] = (-3963, 2534, 4009);
	level.iz_route[level.iz_route.size] = (-3659, 2696, 4033);
	level.iz_route[level.iz_route.size] = (-3272, 2866, 4064);
	level.iz_route[level.iz_route.size] = (-2777, 3074, 4198);
	level.iz_route[level.iz_route.size] = (-2516, 3311, 3633);
	level.iz_route[level.iz_route.size] = (-2064, 3603, 3582);
	level.iz_route[level.iz_route.size] = (-1579, 3898, 3476);
	level.iz_route[level.iz_route.size] = (-1124, 4090, 3383);
	level.iz_route[level.iz_route.size] = (-567, 4410, 3216);
	level.iz_route[level.iz_route.size] = (-122, 4372, 3166);
	level.iz_route[level.iz_route.size] = (335, 4570, 3110);
	level.iz_route[level.iz_route.size] = (685, 5069, 3068);
	level.iz_route[level.iz_route.size] = (1072, 5550, 3054);
	level.iz_route[level.iz_route.size] = (1550, 6009, 3062);
	level.iz_route[level.iz_route.size] = (2199, 6331, 3183);
	level.iz_route[level.iz_route.size] = (2614, 6606, 3439);
	level.iz_route[level.iz_route.size] = (3204, 7001, 3952);
	level.iz_route[level.iz_route.size] = (3964, 7457, 4258);
	level.iz_route[level.iz_route.size] = (4706, 7799, 4423);
	level.iz_route[level.iz_route.size] = (5741, 8183, 4518);
	level.iz_route[level.iz_route.size] = (6537, 8364, 4542);
	level.iz_route[level.iz_route.size] = (7206, 8257, 4498);
	level.iz_route[level.iz_route.size] = (7569, 7908, 4431);
	level.iz_route[level.iz_route.size] = (7873, 7350, 4373);
	level.iz_route[level.iz_route.size] = (7936, 6780, 4331);
	level.iz_route[level.iz_route.size] = (8040, 5977, 4286);
	level.iz_route[level.iz_route.size] = (8083, 5004, 4274);
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
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (1604.8386, 5345.1577, 3049.5825);
	angles[0] = (0, 117.3793, 0);
	at[0] = 0;
	points[1] = (1599.7834, 5354.9214, 3049.5747);
	angles[1] = (0, 297.3792, 0);
	at[1] = 0.0500;
	points[2] = (1434.7993, 5673.4648, 3049.2756);
	angles[2] = (0, 297.3792, 0);
	at[2] = 1.4000;
	points[3] = (1439.8544, 5663.7397, 3049.2834);
	angles[3] = (0, 117.3793, 0);
	at[3] = 1.4500;
	points[4] = (1604.8386, 5345.1577, 3049.5825);
	angles[4] = (0, 117.3793, 0);
	at[4] = 2.8000;
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
	points[0] = (206.1008, 4995, 3099.4214);
	angles[0] = (0, 117.3791, 0);
	at[0] = 0;
	points[1] = (211.1295, 4985.2754, 3099.4724);
	angles[1] = (0, -62.6209, 0);
	at[1] = 0.0500;
	points[2] = (376.1126, 4666.7324, 3101.0591);
	angles[2] = (0, -62.6209, 0);
	at[2] = 1.4000;
	points[3] = (371.0839, 4676.4175, 3101.0120);
	angles[3] = (0, -242.6209, 0);
	at[3] = 1.4500;
	points[4] = (206.1008, 4995, 3099.4214);
	angles[4] = (0, -242.6209, 0);
	at[4] = 2.8000;
	mover = getEnt("iz_obj_1", "targetname");
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
