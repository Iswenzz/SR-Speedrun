main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_wiiu_water_park", 0);

	setExpFog(2952.7559, 19484.2500, 0.5490, 0.8431, 1, 0);

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
	ambientPlay("iz_0_uwp", 2);
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
	level.iz_route[level.iz_route.size] = (4501, -3969, 3563);
	level.iz_route[level.iz_route.size] = (4531, -6485, 3572);
	level.iz_route[level.iz_route.size] = (4516, -7718, 3831);
	level.iz_route[level.iz_route.size] = (4515, -9289, 3711);
	level.iz_route[level.iz_route.size] = (4533, -10489, 3712);
	level.iz_route[level.iz_route.size] = (2632, -11408, 3882);
	level.iz_route[level.iz_route.size] = (440, -11450, 3706);
	level.iz_route[level.iz_route.size] = (-742, -11491, 3779);
	level.iz_route[level.iz_route.size] = (-2163, -10855, 3863);
	level.iz_route[level.iz_route.size] = (-2483, -10326, 3877);
	level.iz_route[level.iz_route.size] = (-2758, -9259, 3922);
	level.iz_route[level.iz_route.size] = (-2878, -8743, 4088);
	level.iz_route[level.iz_route.size] = (-3777, -5184, 2953);
	level.iz_route[level.iz_route.size] = (-3974, -4026, 2797);
	level.iz_route[level.iz_route.size] = (-4102, -2926, 2779);
	level.iz_route[level.iz_route.size] = (-4134, -1945, 2854);
	level.iz_route[level.iz_route.size] = (-4191, -709, 3032);
	level.iz_route[level.iz_route.size] = (-4391, 44, 3217);
	level.iz_route[level.iz_route.size] = (-4990, 772, 3593);
	level.iz_route[level.iz_route.size] = (-5855, 943, 3916);
	level.iz_route[level.iz_route.size] = (-6676, 829, 4220);
	level.iz_route[level.iz_route.size] = (-7210, 304, 4499);
	level.iz_route[level.iz_route.size] = (-7409, -347, 4733);
	level.iz_route[level.iz_route.size] = (-7210, -1271, 4982);
	level.iz_route[level.iz_route.size] = (-6791, -1879, 5108);
	level.iz_route[level.iz_route.size] = (-5975, -2292, 5190);
	level.iz_route[level.iz_route.size] = (-4745, -2443, 5277);
	level.iz_route[level.iz_route.size] = (-3375, -2380, 5251);
	level.iz_route[level.iz_route.size] = (-2368, -2016, 5129);
	level.iz_route[level.iz_route.size] = (-1835, -1275, 4893);
	level.iz_route[level.iz_route.size] = (-1625, -566, 4602);
	level.iz_route[level.iz_route.size] = (-1521, 465, 4020);
	level.iz_route[level.iz_route.size] = (-1454, 2138, 3072);
	level.iz_route[level.iz_route.size] = (-1457, 4097, 2235);
	level.iz_route[level.iz_route.size] = (-1323, 5558, 2226);
	level.iz_route[level.iz_route.size] = (-916, 5983, 2190);
	level.iz_route[level.iz_route.size] = (435, 6297, 2229);
	level.iz_route[level.iz_route.size] = (1134, 6582, 2277);
	level.iz_route[level.iz_route.size] = (1587, 7212, 2336);
	level.iz_route[level.iz_route.size] = (1598, 8236, 2385);
	level.iz_route[level.iz_route.size] = (1482, 9486, 2473);
	level.iz_route[level.iz_route.size] = (1600, 10206, 2547);
	level.iz_route[level.iz_route.size] = (2008, 10742, 2605);
	level.iz_route[level.iz_route.size] = (2507, 10963, 2622);
	level.iz_route[level.iz_route.size] = (3142, 10924, 2621);
	level.iz_route[level.iz_route.size] = (3751, 10602, 2628);
	level.iz_route[level.iz_route.size] = (4127, 10164, 2677);
	level.iz_route[level.iz_route.size] = (4415, 9362, 2784);
	level.iz_route[level.iz_route.size] = (4480, 7649, 3830);
	level.iz_route[level.iz_route.size] = (4530, 3187, 3563);
	level.iz_route[level.iz_route.size] = (3663, 2113, 3563);
	level.iz_route[level.iz_route.size] = (3687, -44, 3563);
	level.iz_route[level.iz_route.size] = (4470, -1789, 3563);
}
