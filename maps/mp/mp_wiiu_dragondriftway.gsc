main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_wiiu_dragondriftway", 0);

	setExpFog(5905.5117, 14517.7158, 1, 0.7765, 0.2706, 0);

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
	ambientPlay("iz_0_udd", 2);
	level thread iz_music("iz_7_se_cr_dsy_env_birds");
}

iz_music(alias)
{
	for (;;)
	{
		level waittill("connected", player);
		player thread iz_music_player(alias);
	}
}

iz_music_player(alias)
{
	self endon("disconnect");
	self waittill("spawned_player");
	self playLocalSound(alias);
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
	level.iz_route[level.iz_route.size] = (4, 1517, 532);
	level.iz_route[level.iz_route.size] = (5, 509, 532);
	level.iz_route[level.iz_route.size] = (11, -498, 532);
	level.iz_route[level.iz_route.size] = (17, -1425, 532);
	level.iz_route[level.iz_route.size] = (21, -2045, 446);
	level.iz_route[level.iz_route.size] = (79, -3432, 530);
	level.iz_route[level.iz_route.size] = (129, -4516, 583);
	level.iz_route[level.iz_route.size] = (-3, -5106, 648);
	level.iz_route[level.iz_route.size] = (-299, -5521, 735);
	level.iz_route[level.iz_route.size] = (-698, -5816, 833);
	level.iz_route[level.iz_route.size] = (-1198, -5990, 936);
	level.iz_route[level.iz_route.size] = (-1930, -6139, 1066);
	level.iz_route[level.iz_route.size] = (-3036, -6338, 1256);
	level.iz_route[level.iz_route.size] = (-3665, -6740, 1440);
	level.iz_route[level.iz_route.size] = (-3891, -7225, 1547);
	level.iz_route[level.iz_route.size] = (-3890, -7673, 1603);
	level.iz_route[level.iz_route.size] = (-3676, -8089, 1641);
	level.iz_route[level.iz_route.size] = (-3220, -8300, 1649);
	level.iz_route[level.iz_route.size] = (-2682, -8309, 1677);
	level.iz_route[level.iz_route.size] = (-1967, -8120, 1742);
	level.iz_route[level.iz_route.size] = (-1078, -7802, 1837);
	level.iz_route[level.iz_route.size] = (-452, -7449, 1910);
	level.iz_route[level.iz_route.size] = (119, -7276, 1965);
	level.iz_route[level.iz_route.size] = (1173, -7000, 2058);
	level.iz_route[level.iz_route.size] = (1847, -6794, 2123);
	level.iz_route[level.iz_route.size] = (2444, -6586, 2197);
	level.iz_route[level.iz_route.size] = (2922, -6469, 2265);
	level.iz_route[level.iz_route.size] = (3482, -6429, 2358);
	level.iz_route[level.iz_route.size] = (3952, -6584, 2430);
	level.iz_route[level.iz_route.size] = (4220, -6894, 2443);
	level.iz_route[level.iz_route.size] = (4327, -7301, 2420);
	level.iz_route[level.iz_route.size] = (4326, -7786, 2381);
	level.iz_route[level.iz_route.size] = (4138, -8395, 2321);
	level.iz_route[level.iz_route.size] = (3662, -9033, 2333);
	level.iz_route[level.iz_route.size] = (3338, -9556, 2405);
	level.iz_route[level.iz_route.size] = (3344, -10052, 2433);
	level.iz_route[level.iz_route.size] = (3647, -10566, 2404);
	level.iz_route[level.iz_route.size] = (4164, -10966, 2375);
	level.iz_route[level.iz_route.size] = (4804, -11462, 2423);
	level.iz_route[level.iz_route.size] = (5314, -12076, 2488);
	level.iz_route[level.iz_route.size] = (5452, -12606, 2505);
	level.iz_route[level.iz_route.size] = (5399, -13082, 2526);
	level.iz_route[level.iz_route.size] = (5071, -13532, 2517);
	level.iz_route[level.iz_route.size] = (4632, -13704, 2488);
	level.iz_route[level.iz_route.size] = (4066, -13617, 2436);
	level.iz_route[level.iz_route.size] = (3637, -13517, 2415);
	level.iz_route[level.iz_route.size] = (3150, -13302, 2396);
	level.iz_route[level.iz_route.size] = (2718, -12899, 2388);
	level.iz_route[level.iz_route.size] = (2224, -12284, 2399);
	level.iz_route[level.iz_route.size] = (1720, -11668, 2400);
	level.iz_route[level.iz_route.size] = (1376, -11249, 2386);
	level.iz_route[level.iz_route.size] = (930, -10901, 2357);
	level.iz_route[level.iz_route.size] = (203, -10604, 2296);
	level.iz_route[level.iz_route.size] = (-864, -10427, 2178);
	level.iz_route[level.iz_route.size] = (-2819, -10181, 2069);
	level.iz_route[level.iz_route.size] = (-4304, -10144, 2365);
	level.iz_route[level.iz_route.size] = (-5533, -10045, 2748);
	level.iz_route[level.iz_route.size] = (-6279, -9858, 2954);
	level.iz_route[level.iz_route.size] = (-6893, -9491, 3118);
	level.iz_route[level.iz_route.size] = (-7326, -8835, 3241);
	level.iz_route[level.iz_route.size] = (-7505, -8065, 3296);
	level.iz_route[level.iz_route.size] = (-7525, -7304, 3298);
	level.iz_route[level.iz_route.size] = (-7382, -6430, 3227);
	level.iz_route[level.iz_route.size] = (-7034, -5623, 3102);
	level.iz_route[level.iz_route.size] = (-6500, -5170, 2936);
	level.iz_route[level.iz_route.size] = (-5749, -4851, 2734);
	level.iz_route[level.iz_route.size] = (-4591, -4511, 2524);
	level.iz_route[level.iz_route.size] = (-3468, -3970, 2477);
	level.iz_route[level.iz_route.size] = (-3013, -3671, 2516);
	level.iz_route[level.iz_route.size] = (-2658, -3222, 2498);
	level.iz_route[level.iz_route.size] = (-2424, -2738, 2446);
	level.iz_route[level.iz_route.size] = (-2235, -2300, 2404);
	level.iz_route[level.iz_route.size] = (-2071, -1829, 2346);
	level.iz_route[level.iz_route.size] = (-1969, -1152, 2240);
	level.iz_route[level.iz_route.size] = (-1951, -404, 2178);
	level.iz_route[level.iz_route.size] = (-1997, 1187, 1830);
	level.iz_route[level.iz_route.size] = (-2021, 2667, 1513);
	level.iz_route[level.iz_route.size] = (-2088, 4204, 1296);
	level.iz_route[level.iz_route.size] = (-2221, 5191, 1203);
	level.iz_route[level.iz_route.size] = (-2180, 6131, 1185);
	level.iz_route[level.iz_route.size] = (-1946, 6729, 1193);
	level.iz_route[level.iz_route.size] = (-1490, 7130, 1201);
	level.iz_route[level.iz_route.size] = (-885, 7227, 1163);
	level.iz_route[level.iz_route.size] = (-377, 7034, 1083);
	level.iz_route[level.iz_route.size] = (23, 6570, 950);
	level.iz_route[level.iz_route.size] = (173, 6072, 839);
	level.iz_route[level.iz_route.size] = (92, 4893, 728);
	level.iz_route[level.iz_route.size] = (95, 4062, 711);
	level.iz_route[level.iz_route.size] = (83, 3489, 709);
	level.iz_route[level.iz_route.size] = (6, 2126, 532);
}
