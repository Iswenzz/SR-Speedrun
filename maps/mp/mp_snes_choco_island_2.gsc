main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_snes_choco_island_2", 0);

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

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
}

iz_sounds()
{
	ambientPlay("iz_0_11", 2);
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
	level.iz_route[level.iz_route.size] = (-2412, 4642, 343);
	level.iz_route[level.iz_route.size] = (-988, 4550, 343);
	level.iz_route[level.iz_route.size] = (-93, 4341, 343);
	level.iz_route[level.iz_route.size] = (324, 4287, 343);
	level.iz_route[level.iz_route.size] = (694, 4351, 343);
	level.iz_route[level.iz_route.size] = (1285, 4633, 343);
	level.iz_route[level.iz_route.size] = (2523, 5389, 343);
	level.iz_route[level.iz_route.size] = (3092, 5536, 343);
	level.iz_route[level.iz_route.size] = (3639, 5531, 343);
	level.iz_route[level.iz_route.size] = (4110, 5321, 343);
	level.iz_route[level.iz_route.size] = (4390, 4811, 343);
	level.iz_route[level.iz_route.size] = (4483, 4284, 343);
	level.iz_route[level.iz_route.size] = (4501, 3140, 343);
	level.iz_route[level.iz_route.size] = (4487, 2049, 343);
	level.iz_route[level.iz_route.size] = (4479, 1146, 343);
	level.iz_route[level.iz_route.size] = (4434, 651, 343);
	level.iz_route[level.iz_route.size] = (4251, 267, 343);
	level.iz_route[level.iz_route.size] = (3881, -79, 343);
	level.iz_route[level.iz_route.size] = (2970, -860, 343);
	level.iz_route[level.iz_route.size] = (2572, -1467, 343);
	level.iz_route[level.iz_route.size] = (2484, -2065, 343);
	level.iz_route[level.iz_route.size] = (2654, -2599, 343);
	level.iz_route[level.iz_route.size] = (3092, -3000, 343);
	level.iz_route[level.iz_route.size] = (4004, -3511, 343);
	level.iz_route[level.iz_route.size] = (4319, -3879, 343);
	level.iz_route[level.iz_route.size] = (4367, -4369, 343);
	level.iz_route[level.iz_route.size] = (4262, -4884, 343);
	level.iz_route[level.iz_route.size] = (3929, -5203, 343);
	level.iz_route[level.iz_route.size] = (3354, -5434, 343);
	level.iz_route[level.iz_route.size] = (2857, -5457, 343);
	level.iz_route[level.iz_route.size] = (2207, -5319, 343);
	level.iz_route[level.iz_route.size] = (893, -5030, 343);
	level.iz_route[level.iz_route.size] = (590, -4991, 343);
	level.iz_route[level.iz_route.size] = (298, -5019, 343);
	level.iz_route[level.iz_route.size] = (-1259, -5272, 343);
	level.iz_route[level.iz_route.size] = (-3294, -5602, 343);
	level.iz_route[level.iz_route.size] = (-4296, -5547, 343);
	level.iz_route[level.iz_route.size] = (-4774, -5332, 343);
	level.iz_route[level.iz_route.size] = (-5025, -4965, 343);
	level.iz_route[level.iz_route.size] = (-5043, -4593, 343);
	level.iz_route[level.iz_route.size] = (-4960, -4239, 343);
	level.iz_route[level.iz_route.size] = (-4676, -3864, 343);
	level.iz_route[level.iz_route.size] = (-4213, -3343, 343);
	level.iz_route[level.iz_route.size] = (-3867, -3046, 343);
	level.iz_route[level.iz_route.size] = (-3676, -2761, 343);
	level.iz_route[level.iz_route.size] = (-3572, -2446, 343);
	level.iz_route[level.iz_route.size] = (-3487, -1836, 330);
	level.iz_route[level.iz_route.size] = (-3478, -1108, 330);
	level.iz_route[level.iz_route.size] = (-3543, -422, 330);
	level.iz_route[level.iz_route.size] = (-3598, 303, 330);
	level.iz_route[level.iz_route.size] = (-3667, 966, 330);
	level.iz_route[level.iz_route.size] = (-3764, 1837, 330);
	level.iz_route[level.iz_route.size] = (-3800, 2733, 330);
	level.iz_route[level.iz_route.size] = (-3720, 3404, 343);
	level.iz_route[level.iz_route.size] = (-3378, 4243, 343);
	level.iz_route[level.iz_route.size] = (-3005, 4559, 343);
}
