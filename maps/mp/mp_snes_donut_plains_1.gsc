main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_snes_donut_plains_1", 0);

	setExpFog(32480.3145, 44475.8867, 0.7020, 0.8980, 1, 0);

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
	ambientPlay("iz_0_1", 2);
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
	level.iz_route[level.iz_route.size] = (4165, 218, 335);
	level.iz_route[level.iz_route.size] = (4293, -907, 335);
	level.iz_route[level.iz_route.size] = (4327, -1864, 336);
	level.iz_route[level.iz_route.size] = (4286, -2254, 336);
	level.iz_route[level.iz_route.size] = (4107, -2663, 335);
	level.iz_route[level.iz_route.size] = (3510, -3449, 335);
	level.iz_route[level.iz_route.size] = (3076, -3941, 335);
	level.iz_route[level.iz_route.size] = (2647, -4219, 335);
	level.iz_route[level.iz_route.size] = (2060, -4437, 335);
	level.iz_route[level.iz_route.size] = (1517, -4580, 344);
	level.iz_route[level.iz_route.size] = (955, -4618, 346);
	level.iz_route[level.iz_route.size] = (-9, -4614, 328);
	level.iz_route[level.iz_route.size] = (-1467, -4611, 346);
	level.iz_route[level.iz_route.size] = (-2263, -4697, 336);
	level.iz_route[level.iz_route.size] = (-2936, -4833, 344);
	level.iz_route[level.iz_route.size] = (-3577, -4762, 361);
	level.iz_route[level.iz_route.size] = (-4137, -4441, 373);
	level.iz_route[level.iz_route.size] = (-4486, -3892, 369);
	level.iz_route[level.iz_route.size] = (-4704, -3276, 355);
	level.iz_route[level.iz_route.size] = (-4655, -2675, 340);
	level.iz_route[level.iz_route.size] = (-4404, -2132, 333);
	level.iz_route[level.iz_route.size] = (-4021, -1706, 334);
	level.iz_route[level.iz_route.size] = (-3567, -1360, 335);
	level.iz_route[level.iz_route.size] = (-3252, -858, 335);
	level.iz_route[level.iz_route.size] = (-3176, -333, 336);
	level.iz_route[level.iz_route.size] = (-3277, 224, 334);
	level.iz_route[level.iz_route.size] = (-3714, 767, 335);
	level.iz_route[level.iz_route.size] = (-4192, 1316, 337);
	level.iz_route[level.iz_route.size] = (-4581, 1739, 338);
	level.iz_route[level.iz_route.size] = (-4753, 2253, 335);
	level.iz_route[level.iz_route.size] = (-4865, 2917, 340);
	level.iz_route[level.iz_route.size] = (-4771, 3587, 358);
	level.iz_route[level.iz_route.size] = (-4449, 4012, 366);
	level.iz_route[level.iz_route.size] = (-3923, 4226, 354);
	level.iz_route[level.iz_route.size] = (-3323, 4181, 339);
	level.iz_route[level.iz_route.size] = (-2859, 3898, 342);
	level.iz_route[level.iz_route.size] = (-2445, 3348, 347);
	level.iz_route[level.iz_route.size] = (-2039, 2302, 351);
	level.iz_route[level.iz_route.size] = (-1680, 1086, 341);
	level.iz_route[level.iz_route.size] = (-1391, 95, 335);
	level.iz_route[level.iz_route.size] = (-938, -703, 335);
	level.iz_route[level.iz_route.size] = (-414, -1231, 336);
	level.iz_route[level.iz_route.size] = (190, -1519, 338);
	level.iz_route[level.iz_route.size] = (690, -1551, 338);
	level.iz_route[level.iz_route.size] = (1192, -1315, 340);
	level.iz_route[level.iz_route.size] = (1433, -844, 344);
	level.iz_route[level.iz_route.size] = (1397, -147, 340);
	level.iz_route[level.iz_route.size] = (993, 465, 335);
	level.iz_route[level.iz_route.size] = (555, 1006, 339);
	level.iz_route[level.iz_route.size] = (314, 1682, 345);
	level.iz_route[level.iz_route.size] = (148, 2491, 355);
	level.iz_route[level.iz_route.size] = (104, 3328, 358);
	level.iz_route[level.iz_route.size] = (259, 4054, 356);
	level.iz_route[level.iz_route.size] = (571, 4431, 354);
	level.iz_route[level.iz_route.size] = (912, 4629, 349);
	level.iz_route[level.iz_route.size] = (1502, 4810, 338);
	level.iz_route[level.iz_route.size] = (2112, 4843, 340);
	level.iz_route[level.iz_route.size] = (2821, 4720, 363);
	level.iz_route[level.iz_route.size] = (3424, 4451, 388);
	level.iz_route[level.iz_route.size] = (3791, 4050, 397);
	level.iz_route[level.iz_route.size] = (4046, 3506, 379);
	level.iz_route[level.iz_route.size] = (4198, 2790, 350);
	level.iz_route[level.iz_route.size] = (4178, 1963, 335);
	level.iz_route[level.iz_route.size] = (4150, 1004, 334);
}
