main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_wiiu_electrodrome", 0);

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
	ambientPlay("iz_0_ue", 2);
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
	level.iz_route[level.iz_route.size] = (4503, -3646, 4170);
	level.iz_route[level.iz_route.size] = (4392, -2596, 3942);
	level.iz_route[level.iz_route.size] = (4311, -1845, 3784);
	level.iz_route[level.iz_route.size] = (4201, -468, 3345);
	level.iz_route[level.iz_route.size] = (3998, 501, 3348);
	level.iz_route[level.iz_route.size] = (4182, 1469, 3348);
	level.iz_route[level.iz_route.size] = (4646, 2324, 3387);
	level.iz_route[level.iz_route.size] = (5260, 2823, 3532);
	level.iz_route[level.iz_route.size] = (5920, 3285, 3555);
	level.iz_route[level.iz_route.size] = (6331, 3898, 3627);
	level.iz_route[level.iz_route.size] = (6404, 4631, 3638);
	level.iz_route[level.iz_route.size] = (6320, 5392, 3642);
	level.iz_route[level.iz_route.size] = (6043, 6134, 3643);
	level.iz_route[level.iz_route.size] = (5506, 6707, 3617);
	level.iz_route[level.iz_route.size] = (4772, 7132, 3594);
	level.iz_route[level.iz_route.size] = (3978, 7090, 3558);
	level.iz_route[level.iz_route.size] = (3142, 6742, 3515);
	level.iz_route[level.iz_route.size] = (2731, 5978, 3528);
	level.iz_route[level.iz_route.size] = (2611, 5183, 3562);
	level.iz_route[level.iz_route.size] = (2256, 4516, 3605);
	level.iz_route[level.iz_route.size] = (1670, 3998, 3683);
	level.iz_route[level.iz_route.size] = (914, 3895, 3810);
	level.iz_route[level.iz_route.size] = (310, 4285, 3950);
	level.iz_route[level.iz_route.size] = (-21, 4972, 4089);
	level.iz_route[level.iz_route.size] = (104, 5800, 4171);
	level.iz_route[level.iz_route.size] = (563, 6457, 4232);
	level.iz_route[level.iz_route.size] = (1305, 7151, 4258);
	level.iz_route[level.iz_route.size] = (2243, 7958, 4256);
	level.iz_route[level.iz_route.size] = (3050, 8564, 4218);
	level.iz_route[level.iz_route.size] = (3875, 8900, 4179);
	level.iz_route[level.iz_route.size] = (4708, 8997, 4214);
	level.iz_route[level.iz_route.size] = (5577, 8777, 4220);
	level.iz_route[level.iz_route.size] = (6409, 8205, 4234);
	level.iz_route[level.iz_route.size] = (6917, 7403, 4222);
	level.iz_route[level.iz_route.size] = (7217, 6368, 4224);
	level.iz_route[level.iz_route.size] = (7511, 5756, 4375);
	level.iz_route[level.iz_route.size] = (7650, 5097, 4451);
	level.iz_route[level.iz_route.size] = (7820, 4255, 4588);
	level.iz_route[level.iz_route.size] = (8021, 3241, 4795);
	level.iz_route[level.iz_route.size] = (8122, 2127, 5050);
	level.iz_route[level.iz_route.size] = (8077, 1358, 5228);
	level.iz_route[level.iz_route.size] = (7917, 856, 5344);
	level.iz_route[level.iz_route.size] = (7441, 143, 5511);
	level.iz_route[level.iz_route.size] = (6815, -277, 5629);
	level.iz_route[level.iz_route.size] = (6204, -462, 5672);
	level.iz_route[level.iz_route.size] = (5513, -440, 5657);
	level.iz_route[level.iz_route.size] = (4945, -272, 5589);
	level.iz_route[level.iz_route.size] = (4533, 92, 5490);
	level.iz_route[level.iz_route.size] = (4222, 640, 5370);
	level.iz_route[level.iz_route.size] = (3949, 1215, 5300);
	level.iz_route[level.iz_route.size] = (3644, 1712, 5296);
	level.iz_route[level.iz_route.size] = (3087, 2129, 5362);
	level.iz_route[level.iz_route.size] = (2441, 2336, 5409);
	level.iz_route[level.iz_route.size] = (1829, 2326, 5427);
	level.iz_route[level.iz_route.size] = (1257, 2153, 5420);
	level.iz_route[level.iz_route.size] = (749, 1884, 5382);
	level.iz_route[level.iz_route.size] = (168, 1557, 5321);
	level.iz_route[level.iz_route.size] = (-504, 1123, 5268);
	level.iz_route[level.iz_route.size] = (-1097, 757, 5233);
	level.iz_route[level.iz_route.size] = (-1992, 350, 5219);
	level.iz_route[level.iz_route.size] = (-2613, 355, 5247);
	level.iz_route[level.iz_route.size] = (-3106, 598, 5283);
	level.iz_route[level.iz_route.size] = (-3484, 1083, 5357);
	level.iz_route[level.iz_route.size] = (-3553, 1638, 5442);
	level.iz_route[level.iz_route.size] = (-3393, 2095, 5533);
	level.iz_route[level.iz_route.size] = (-2951, 2540, 5646);
	level.iz_route[level.iz_route.size] = (-2529, 2650, 5699);
	level.iz_route[level.iz_route.size] = (-2096, 2638, 5700);
	level.iz_route[level.iz_route.size] = (-1748, 2442, 5673);
	level.iz_route[level.iz_route.size] = (-1504, 2061, 5608);
	level.iz_route[level.iz_route.size] = (-1307, 1433, 5514);
	level.iz_route[level.iz_route.size] = (-658, -3356, 3804);
	level.iz_route[level.iz_route.size] = (-639, -4533, 3987);
	level.iz_route[level.iz_route.size] = (-357, -5320, 4219);
	level.iz_route[level.iz_route.size] = (-44, -6267, 4480);
	level.iz_route[level.iz_route.size] = (377, -7079, 4737);
	level.iz_route[level.iz_route.size] = (1030, -7646, 4944);
	level.iz_route[level.iz_route.size] = (2047, -7964, 5111);
	level.iz_route[level.iz_route.size] = (3081, -7796, 5144);
	level.iz_route[level.iz_route.size] = (4023, -7218, 5052);
	level.iz_route[level.iz_route.size] = (4454, -6271, 4827);
	level.iz_route[level.iz_route.size] = (4646, -5312, 4588);
}
