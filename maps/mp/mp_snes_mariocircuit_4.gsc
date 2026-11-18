main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_snes_mariocircuit_4", 0);

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
	ambientPlay("iz_0_14", 2);
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
	level.iz_route[level.iz_route.size] = (11, -2154, 182);
	level.iz_route[level.iz_route.size] = (40, -5770, 182);
	level.iz_route[level.iz_route.size] = (232, -6504, 182);
	level.iz_route[level.iz_route.size] = (648, -7019, 182);
	level.iz_route[level.iz_route.size] = (1186, -7180, 182);
	level.iz_route[level.iz_route.size] = (1791, -7177, 182);
	level.iz_route[level.iz_route.size] = (2374, -6810, 182);
	level.iz_route[level.iz_route.size] = (2709, -6086, 182);
	level.iz_route[level.iz_route.size] = (3190, -3916, 182);
	level.iz_route[level.iz_route.size] = (3417, -2958, 182);
	level.iz_route[level.iz_route.size] = (3797, -2602, 182);
	level.iz_route[level.iz_route.size] = (4559, -2462, 182);
	level.iz_route[level.iz_route.size] = (5995, -2397, 182);
	level.iz_route[level.iz_route.size] = (6482, -2562, 182);
	level.iz_route[level.iz_route.size] = (6731, -2928, 182);
	level.iz_route[level.iz_route.size] = (6802, -3711, 182);
	level.iz_route[level.iz_route.size] = (6755, -4440, 182);
	level.iz_route[level.iz_route.size] = (6594, -4753, 182);
	level.iz_route[level.iz_route.size] = (5560, -6164, 182);
	level.iz_route[level.iz_route.size] = (5387, -6530, 182);
	level.iz_route[level.iz_route.size] = (5350, -6863, 182);
	level.iz_route[level.iz_route.size] = (5408, -7189, 182);
	level.iz_route[level.iz_route.size] = (5723, -7472, 182);
	level.iz_route[level.iz_route.size] = (6133, -7622, 182);
	level.iz_route[level.iz_route.size] = (7486, -7670, 182);
	level.iz_route[level.iz_route.size] = (8247, -7630, 182);
	level.iz_route[level.iz_route.size] = (8570, -7443, 182);
	level.iz_route[level.iz_route.size] = (8837, -7125, 182);
	level.iz_route[level.iz_route.size] = (9014, -6769, 182);
	level.iz_route[level.iz_route.size] = (9086, -6382, 182);
	level.iz_route[level.iz_route.size] = (9123, -4499, 182);
	level.iz_route[level.iz_route.size] = (9114, -2468, 182);
	level.iz_route[level.iz_route.size] = (8950, -1658, 182);
	level.iz_route[level.iz_route.size] = (8692, -1288, 182);
	level.iz_route[level.iz_route.size] = (8204, -1094, 182);
	level.iz_route[level.iz_route.size] = (7303, -1014, 182);
	level.iz_route[level.iz_route.size] = (5476, -1004, 182);
	level.iz_route[level.iz_route.size] = (3271, -990, 182);
	level.iz_route[level.iz_route.size] = (2607, -826, 182);
	level.iz_route[level.iz_route.size] = (2119, -431, 182);
	level.iz_route[level.iz_route.size] = (1879, 220, 182);
	level.iz_route[level.iz_route.size] = (1911, 897, 182);
	level.iz_route[level.iz_route.size] = (2120, 1316, 182);
	level.iz_route[level.iz_route.size] = (2442, 1556, 182);
	level.iz_route[level.iz_route.size] = (3073, 1572, 182);
	level.iz_route[level.iz_route.size] = (3867, 1367, 182);
	level.iz_route[level.iz_route.size] = (5023, 951, 182);
	level.iz_route[level.iz_route.size] = (6170, 831, 182);
	level.iz_route[level.iz_route.size] = (7136, 925, 182);
	level.iz_route[level.iz_route.size] = (7698, 1306, 182);
	level.iz_route[level.iz_route.size] = (8355, 2163, 182);
	level.iz_route[level.iz_route.size] = (8734, 3124, 182);
	level.iz_route[level.iz_route.size] = (8727, 3729, 182);
	level.iz_route[level.iz_route.size] = (8527, 4220, 182);
	level.iz_route[level.iz_route.size] = (8041, 4415, 182);
	level.iz_route[level.iz_route.size] = (7368, 4383, 182);
	level.iz_route[level.iz_route.size] = (6474, 4133, 182);
	level.iz_route[level.iz_route.size] = (5075, 3059, 182);
	level.iz_route[level.iz_route.size] = (4674, 2764, 182);
	level.iz_route[level.iz_route.size] = (4197, 2765, 182);
	level.iz_route[level.iz_route.size] = (3645, 3040, 182);
	level.iz_route[level.iz_route.size] = (2009, 4178, 182);
	level.iz_route[level.iz_route.size] = (1193, 4298, 182);
	level.iz_route[level.iz_route.size] = (494, 4091, 182);
	level.iz_route[level.iz_route.size] = (145, 3504, 182);
	level.iz_route[level.iz_route.size] = (9, 2440, 182);
	level.iz_route[level.iz_route.size] = (-2, -709, 182);
}
