main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_snes_mariocircuit_2", 0);

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
	ambientPlay("iz_0_4", 2);
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
	level.iz_route[level.iz_route.size] = (-6624, -1194, 1063);
	level.iz_route[level.iz_route.size] = (-6605, -2111, 1063);
	level.iz_route[level.iz_route.size] = (-6559, -2650, 1063);
	level.iz_route[level.iz_route.size] = (-6328, -3064, 1063);
	level.iz_route[level.iz_route.size] = (-5904, -3501, 1063);
	level.iz_route[level.iz_route.size] = (-5314, -3737, 1063);
	level.iz_route[level.iz_route.size] = (-4582, -3823, 1063);
	level.iz_route[level.iz_route.size] = (-4183, -3840, 1063);
	level.iz_route[level.iz_route.size] = (-3707, -3817, 1063);
	level.iz_route[level.iz_route.size] = (-3182, -3850, 1063);
	level.iz_route[level.iz_route.size] = (-2792, -4018, 1063);
	level.iz_route[level.iz_route.size] = (-2584, -4286, 1063);
	level.iz_route[level.iz_route.size] = (-2415, -4703, 1063);
	level.iz_route[level.iz_route.size] = (-2179, -5166, 1063);
	level.iz_route[level.iz_route.size] = (-1911, -5442, 1063);
	level.iz_route[level.iz_route.size] = (-1574, -5701, 1063);
	level.iz_route[level.iz_route.size] = (-1118, -5919, 1063);
	level.iz_route[level.iz_route.size] = (-604, -6044, 1063);
	level.iz_route[level.iz_route.size] = (322, -6105, 1063);
	level.iz_route[level.iz_route.size] = (1512, -6132, 1063);
	level.iz_route[level.iz_route.size] = (2496, -6129, 1063);
	level.iz_route[level.iz_route.size] = (3297, -6176, 1063);
	level.iz_route[level.iz_route.size] = (3877, -6081, 1063);
	level.iz_route[level.iz_route.size] = (4410, -5929, 1063);
	level.iz_route[level.iz_route.size] = (4767, -5684, 1063);
	level.iz_route[level.iz_route.size] = (5049, -5292, 1063);
	level.iz_route[level.iz_route.size] = (5118, -4715, 1063);
	level.iz_route[level.iz_route.size] = (5176, -3996, 1063);
	level.iz_route[level.iz_route.size] = (5223, -3169, 1063);
	level.iz_route[level.iz_route.size] = (5258, -2531, 1063);
	level.iz_route[level.iz_route.size] = (5241, -1935, 1063);
	level.iz_route[level.iz_route.size] = (5059, -1424, 1063);
	level.iz_route[level.iz_route.size] = (4728, -1091, 1063);
	level.iz_route[level.iz_route.size] = (4255, -998, 1063);
	level.iz_route[level.iz_route.size] = (3644, -911, 1063);
	level.iz_route[level.iz_route.size] = (2961, -987, 1063);
	level.iz_route[level.iz_route.size] = (2111, -1276, 1063);
	level.iz_route[level.iz_route.size] = (1320, -1467, 1063);
	level.iz_route[level.iz_route.size] = (855, -1425, 1063);
	level.iz_route[level.iz_route.size] = (267, -1162, 1063);
	level.iz_route[level.iz_route.size] = (-75, -760, 1063);
	level.iz_route[level.iz_route.size] = (-201, -18, 1063);
	level.iz_route[level.iz_route.size] = (-223, 845, 1063);
	level.iz_route[level.iz_route.size] = (-198, 1931, 1063);
	level.iz_route[level.iz_route.size] = (-222, 3243, 1063);
	level.iz_route[level.iz_route.size] = (-192, 4079, 1063);
	level.iz_route[level.iz_route.size] = (-15, 4378, 1063);
	level.iz_route[level.iz_route.size] = (419, 4544, 1063);
	level.iz_route[level.iz_route.size] = (1077, 4690, 1063);
	level.iz_route[level.iz_route.size] = (1900, 4741, 1063);
	level.iz_route[level.iz_route.size] = (2606, 4834, 1063);
	level.iz_route[level.iz_route.size] = (3580, 4923, 1063);
	level.iz_route[level.iz_route.size] = (4362, 5056, 1063);
	level.iz_route[level.iz_route.size] = (5063, 4981, 1063);
	level.iz_route[level.iz_route.size] = (5547, 4629, 1063);
	level.iz_route[level.iz_route.size] = (5775, 4149, 1063);
	level.iz_route[level.iz_route.size] = (5616, 3669, 1063);
	level.iz_route[level.iz_route.size] = (5230, 3145, 1063);
	level.iz_route[level.iz_route.size] = (4601, 2739, 1063);
	level.iz_route[level.iz_route.size] = (4116, 2615, 1063);
	level.iz_route[level.iz_route.size] = (3490, 2585, 1063);
	level.iz_route[level.iz_route.size] = (2724, 2590, 1063);
	level.iz_route[level.iz_route.size] = (2199, 2591, 1063);
	level.iz_route[level.iz_route.size] = (1926, 2600, 1171);
	level.iz_route[level.iz_route.size] = (1385, 2589, 1408);
	level.iz_route[level.iz_route.size] = (-1270, 2663, 1181);
	level.iz_route[level.iz_route.size] = (-1991, 2586, 1063);
	level.iz_route[level.iz_route.size] = (-2902, 2558, 1063);
	level.iz_route[level.iz_route.size] = (-3739, 2571, 1063);
	level.iz_route[level.iz_route.size] = (-4891, 2610, 1063);
	level.iz_route[level.iz_route.size] = (-5480, 2446, 1063);
	level.iz_route[level.iz_route.size] = (-6088, 2153, 1063);
	level.iz_route[level.iz_route.size] = (-6539, 1621, 1063);
	level.iz_route[level.iz_route.size] = (-6693, 1132, 1063);
	level.iz_route[level.iz_route.size] = (-6666, 70, 1063);
	level.iz_route[level.iz_route.size] = (-6616, -664, 1063);
}
