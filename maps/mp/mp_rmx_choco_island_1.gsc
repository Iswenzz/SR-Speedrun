main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_rmx_choco_island_1", 0);

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
	ambientPlay("iz_0_rci1", 2);
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
	level.iz_route[level.iz_route.size] = (-5950, -1007, 394);
	level.iz_route[level.iz_route.size] = (-5960, -3709, 394);
	level.iz_route[level.iz_route.size] = (-5910, -4779, 394);
	level.iz_route[level.iz_route.size] = (-5756, -5440, 394);
	level.iz_route[level.iz_route.size] = (-5255, -5896, 394);
	level.iz_route[level.iz_route.size] = (-4698, -6075, 394);
	level.iz_route[level.iz_route.size] = (-3720, -6210, 394);
	level.iz_route[level.iz_route.size] = (-2804, -6267, 426);
	level.iz_route[level.iz_route.size] = (-1709, -6299, 482);
	level.iz_route[level.iz_route.size] = (-195, -6287, 400);
	level.iz_route[level.iz_route.size] = (412, -6294, 552);
	level.iz_route[level.iz_route.size] = (3286, -6292, 394);
	level.iz_route[level.iz_route.size] = (4319, -6239, 394);
	level.iz_route[level.iz_route.size] = (4875, -6176, 394);
	level.iz_route[level.iz_route.size] = (5192, -5988, 394);
	level.iz_route[level.iz_route.size] = (5430, -5668, 394);
	level.iz_route[level.iz_route.size] = (5631, -5144, 394);
	level.iz_route[level.iz_route.size] = (5538, -4370, 394);
	level.iz_route[level.iz_route.size] = (5024, -3781, 394);
	level.iz_route[level.iz_route.size] = (4103, -3497, 394);
	level.iz_route[level.iz_route.size] = (2486, -3463, 440);
	level.iz_route[level.iz_route.size] = (844, -3450, 410);
	level.iz_route[level.iz_route.size] = (95, -3428, 504);
	level.iz_route[level.iz_route.size] = (-2197, -3404, 394);
	level.iz_route[level.iz_route.size] = (-3199, -3324, 394);
	level.iz_route[level.iz_route.size] = (-3837, -3104, 394);
	level.iz_route[level.iz_route.size] = (-4211, -2665, 394);
	level.iz_route[level.iz_route.size] = (-4310, -2042, 394);
	level.iz_route[level.iz_route.size] = (-4179, -1414, 394);
	level.iz_route[level.iz_route.size] = (-3810, -925, 394);
	level.iz_route[level.iz_route.size] = (-3013, -685, 394);
	level.iz_route[level.iz_route.size] = (-2096, -692, 394);
	level.iz_route[level.iz_route.size] = (-1331, -710, 446);
	level.iz_route[level.iz_route.size] = (-471, -694, 448);
	level.iz_route[level.iz_route.size] = (-48, -692, 568);
	level.iz_route[level.iz_route.size] = (1274, -683, 394);
	level.iz_route[level.iz_route.size] = (2323, -708, 394);
	level.iz_route[level.iz_route.size] = (3112, -576, 394);
	level.iz_route[level.iz_route.size] = (3464, -267, 394);
	level.iz_route[level.iz_route.size] = (3622, 243, 394);
	level.iz_route[level.iz_route.size] = (3634, 840, 394);
	level.iz_route[level.iz_route.size] = (3466, 1525, 394);
	level.iz_route[level.iz_route.size] = (2954, 1962, 394);
	level.iz_route[level.iz_route.size] = (2010, 2630, 394);
	level.iz_route[level.iz_route.size] = (1417, 3041, 430);
	level.iz_route[level.iz_route.size] = (204, 3832, 394);
	level.iz_route[level.iz_route.size] = (-563, 4257, 394);
	level.iz_route[level.iz_route.size] = (-1435, 4756, 394);
	level.iz_route[level.iz_route.size] = (-1875, 4998, 430);
	level.iz_route[level.iz_route.size] = (-2847, 5510, 394);
	level.iz_route[level.iz_route.size] = (-3883, 6055, 394);
	level.iz_route[level.iz_route.size] = (-4683, 6329, 394);
	level.iz_route[level.iz_route.size] = (-5084, 6290, 394);
	level.iz_route[level.iz_route.size] = (-5459, 6172, 394);
	level.iz_route[level.iz_route.size] = (-5710, 5907, 394);
	level.iz_route[level.iz_route.size] = (-5851, 5537, 394);
	level.iz_route[level.iz_route.size] = (-5905, 4891, 394);
	level.iz_route[level.iz_route.size] = (-5937, 2973, 394);
	level.iz_route[level.iz_route.size] = (-5972, -45, 394);
}
