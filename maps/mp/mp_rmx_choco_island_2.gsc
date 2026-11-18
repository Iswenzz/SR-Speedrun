main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_rmx_choco_island_2", 0);

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
	ambientPlay("iz_0_rci2", 2);
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
	level.iz_route[level.iz_route.size] = (1254, 3023, 2953);
	level.iz_route[level.iz_route.size] = (1263, 2005, 2953);
	level.iz_route[level.iz_route.size] = (1266, 614, 2953);
	level.iz_route[level.iz_route.size] = (865, -130, 2953);
	level.iz_route[level.iz_route.size] = (75, -479, 2953);
	level.iz_route[level.iz_route.size] = (-1460, -495, 2953);
	level.iz_route[level.iz_route.size] = (-2965, -543, 2953);
	level.iz_route[level.iz_route.size] = (-3864, -925, 2953);
	level.iz_route[level.iz_route.size] = (-4095, -1818, 2953);
	level.iz_route[level.iz_route.size] = (-3769, -2782, 2953);
	level.iz_route[level.iz_route.size] = (-3042, -3005, 2953);
	level.iz_route[level.iz_route.size] = (-2167, -3054, 2953);
	level.iz_route[level.iz_route.size] = (-1190, -3000, 2953);
	level.iz_route[level.iz_route.size] = (-394, -2816, 2953);
	level.iz_route[level.iz_route.size] = (860, -2837, 2953);
	level.iz_route[level.iz_route.size] = (1965, -2961, 2953);
	level.iz_route[level.iz_route.size] = (2719, -3192, 2953);
	level.iz_route[level.iz_route.size] = (3390, -3849, 2953);
	level.iz_route[level.iz_route.size] = (4238, -4137, 2953);
	level.iz_route[level.iz_route.size] = (4836, -4156, 2953);
	level.iz_route[level.iz_route.size] = (5254, -3785, 2953);
	level.iz_route[level.iz_route.size] = (6127, -3813, 2953);
	level.iz_route[level.iz_route.size] = (6556, -4124, 2953);
	level.iz_route[level.iz_route.size] = (7284, -4126, 3014);
	level.iz_route[level.iz_route.size] = (8829, -4128, 2953);
	level.iz_route[level.iz_route.size] = (10457, -4072, 2953);
	level.iz_route[level.iz_route.size] = (10916, -3556, 2953);
	level.iz_route[level.iz_route.size] = (10993, -2922, 2953);
	level.iz_route[level.iz_route.size] = (10836, -2489, 2953);
	level.iz_route[level.iz_route.size] = (10579, -2030, 2953);
	level.iz_route[level.iz_route.size] = (9780, -659, 2953);
	level.iz_route[level.iz_route.size] = (9458, -70, 2953);
	level.iz_route[level.iz_route.size] = (9484, 330, 2953);
	level.iz_route[level.iz_route.size] = (9164, 993, 2953);
	level.iz_route[level.iz_route.size] = (8629, 1915, 2953);
	level.iz_route[level.iz_route.size] = (8106, 2833, 3014);
	level.iz_route[level.iz_route.size] = (7520, 3849, 2953);
	level.iz_route[level.iz_route.size] = (6944, 4859, 3129);
	level.iz_route[level.iz_route.size] = (6299, 5885, 2953);
	level.iz_route[level.iz_route.size] = (5831, 6248, 2953);
	level.iz_route[level.iz_route.size] = (5128, 7437, 2953);
	level.iz_route[level.iz_route.size] = (4568, 8333, 2953);
	level.iz_route[level.iz_route.size] = (3804, 8984, 2953);
	level.iz_route[level.iz_route.size] = (3092, 9055, 2953);
	level.iz_route[level.iz_route.size] = (2339, 8940, 2953);
	level.iz_route[level.iz_route.size] = (1577, 8312, 2953);
	level.iz_route[level.iz_route.size] = (1282, 7411, 2953);
	level.iz_route[level.iz_route.size] = (1212, 6627, 2953);
	level.iz_route[level.iz_route.size] = (956, 6065, 2953);
	level.iz_route[level.iz_route.size] = (960, 5239, 2953);
	level.iz_route[level.iz_route.size] = (1217, 4334, 2953);
}
