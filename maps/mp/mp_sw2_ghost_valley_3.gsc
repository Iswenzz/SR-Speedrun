main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_sw2_ghost_valley_3", 0);

	setExpFog(-1476.3779, 29896.6523, 0.3451, 0.3216, 0.3569, 0);

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
	ambientPlay("iz_0_sw2gv3", 2);
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
	level.iz_route[level.iz_route.size] = (3001, 31541, 2279);
	level.iz_route[level.iz_route.size] = (3026, 32394, 2279);
	level.iz_route[level.iz_route.size] = (3239, 32680, 2279);
	level.iz_route[level.iz_route.size] = (3703, 32890, 2279);
	level.iz_route[level.iz_route.size] = (4316, 32908, 2279);
	level.iz_route[level.iz_route.size] = (5158, 32894, 2279);
	level.iz_route[level.iz_route.size] = (6193, 32837, 2096);
	level.iz_route[level.iz_route.size] = (7170, 32871, 1921);
	level.iz_route[level.iz_route.size] = (8306, 32849, 1921);
	level.iz_route[level.iz_route.size] = (9637, 32806, 2078);
	level.iz_route[level.iz_route.size] = (10580, 32816, 2266);
	level.iz_route[level.iz_route.size] = (11540, 32862, 2279);
	level.iz_route[level.iz_route.size] = (12540, 32883, 2279);
	level.iz_route[level.iz_route.size] = (12997, 32695, 2279);
	level.iz_route[level.iz_route.size] = (13204, 32168, 2279);
	level.iz_route[level.iz_route.size] = (13207, 31635, 2279);
	level.iz_route[level.iz_route.size] = (12926, 31160, 2279);
	level.iz_route[level.iz_route.size] = (12170, 30828, 2279);
	level.iz_route[level.iz_route.size] = (11452, 30697, 2279);
	level.iz_route[level.iz_route.size] = (11096, 30390, 2279);
	level.iz_route[level.iz_route.size] = (10630, 29795, 2279);
	level.iz_route[level.iz_route.size] = (10109, 29230, 2279);
	level.iz_route[level.iz_route.size] = (9518, 28937, 2279);
	level.iz_route[level.iz_route.size] = (8677, 28859, 2279);
	level.iz_route[level.iz_route.size] = (6996, 28828, 2279);
	level.iz_route[level.iz_route.size] = (6391, 28534, 2279);
	level.iz_route[level.iz_route.size] = (6149, 27892, 2279);
	level.iz_route[level.iz_route.size] = (6167, 27506, 2279);
	level.iz_route[level.iz_route.size] = (6349, 26984, 2279);
	level.iz_route[level.iz_route.size] = (6750, 26709, 2279);
	level.iz_route[level.iz_route.size] = (7321, 26595, 2279);
	level.iz_route[level.iz_route.size] = (7858, 26434, 2279);
	level.iz_route[level.iz_route.size] = (8407, 26228, 2279);
	level.iz_route[level.iz_route.size] = (8835, 25861, 2279);
	level.iz_route[level.iz_route.size] = (9350, 25620, 2279);
	level.iz_route[level.iz_route.size] = (10226, 25625, 2279);
	level.iz_route[level.iz_route.size] = (11044, 25606, 2279);
	level.iz_route[level.iz_route.size] = (11840, 25598, 2279);
	level.iz_route[level.iz_route.size] = (12820, 25505, 2279);
	level.iz_route[level.iz_route.size] = (13108, 25039, 2279);
	level.iz_route[level.iz_route.size] = (13225, 24319, 2279);
	level.iz_route[level.iz_route.size] = (13294, 23448, 2279);
	level.iz_route[level.iz_route.size] = (13083, 22897, 2279);
	level.iz_route[level.iz_route.size] = (12773, 22635, 2279);
	level.iz_route[level.iz_route.size] = (12064, 22570, 2279);
	level.iz_route[level.iz_route.size] = (10684, 22614, 2279);
	level.iz_route[level.iz_route.size] = (8838, 22595, 2279);
	level.iz_route[level.iz_route.size] = (7719, 22580, 2279);
	level.iz_route[level.iz_route.size] = (7186, 22736, 2279);
	level.iz_route[level.iz_route.size] = (6729, 23090, 2279);
	level.iz_route[level.iz_route.size] = (6235, 23445, 2279);
	level.iz_route[level.iz_route.size] = (5847, 23580, 2279);
	level.iz_route[level.iz_route.size] = (5430, 23661, 2279);
	level.iz_route[level.iz_route.size] = (4981, 23960, 2279);
	level.iz_route[level.iz_route.size] = (4552, 24282, 2279);
	level.iz_route[level.iz_route.size] = (4029, 24570, 2279);
	level.iz_route[level.iz_route.size] = (3511, 24616, 2279);
	level.iz_route[level.iz_route.size] = (3142, 24805, 2279);
	level.iz_route[level.iz_route.size] = (2977, 25227, 2279);
	level.iz_route[level.iz_route.size] = (2981, 26809, 2279);
	level.iz_route[level.iz_route.size] = (2992, 29291, 2279);
}
