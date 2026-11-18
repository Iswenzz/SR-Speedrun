main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_gba_broken_pier", 0);

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
	ambientPlay("iz_0_53", 2);
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
	level.iz_route[level.iz_route.size] = (36, 463, 745);
	level.iz_route[level.iz_route.size] = (42, -298, 745);
	level.iz_route[level.iz_route.size] = (47, -662, 745);
	level.iz_route[level.iz_route.size] = (5, -791, 745);
	level.iz_route[level.iz_route.size] = (-127, -964, 745);
	level.iz_route[level.iz_route.size] = (-962, -1665, 745);
	level.iz_route[level.iz_route.size] = (-1487, -2191, 745);
	level.iz_route[level.iz_route.size] = (-1528, -2286, 745);
	level.iz_route[level.iz_route.size] = (-1550, -2415, 745);
	level.iz_route[level.iz_route.size] = (-1556, -2756, 745);
	level.iz_route[level.iz_route.size] = (-1567, -3795, 745);
	level.iz_route[level.iz_route.size] = (-1587, -3957, 745);
	level.iz_route[level.iz_route.size] = (-1611, -4081, 745);
	level.iz_route[level.iz_route.size] = (-1669, -4273, 745);
	level.iz_route[level.iz_route.size] = (-1861, -4512, 745);
	level.iz_route[level.iz_route.size] = (-2178, -4925, 745);
	level.iz_route[level.iz_route.size] = (-2328, -5072, 745);
	level.iz_route[level.iz_route.size] = (-2475, -5163, 745);
	level.iz_route[level.iz_route.size] = (-2756, -5225, 745);
	level.iz_route[level.iz_route.size] = (-3442, -5190, 745);
	level.iz_route[level.iz_route.size] = (-3927, -5117, 745);
	level.iz_route[level.iz_route.size] = (-4058, -5066, 745);
	level.iz_route[level.iz_route.size] = (-4245, -4975, 745);
	level.iz_route[level.iz_route.size] = (-5047, -4759, 745);
	level.iz_route[level.iz_route.size] = (-5215, -4727, 745);
	level.iz_route[level.iz_route.size] = (-5599, -4670, 745);
	level.iz_route[level.iz_route.size] = (-6262, -4614, 745);
	level.iz_route[level.iz_route.size] = (-7289, -4614, 745);
	level.iz_route[level.iz_route.size] = (-7508, -4644, 745);
	level.iz_route[level.iz_route.size] = (-7675, -4774, 745);
	level.iz_route[level.iz_route.size] = (-7940, -5018, 745);
	level.iz_route[level.iz_route.size] = (-8251, -5298, 745);
	level.iz_route[level.iz_route.size] = (-8545, -5388, 745);
	level.iz_route[level.iz_route.size] = (-9132, -5335, 745);
	level.iz_route[level.iz_route.size] = (-9465, -5176, 745);
	level.iz_route[level.iz_route.size] = (-9695, -4933, 745);
	level.iz_route[level.iz_route.size] = (-9759, -4567, 745);
	level.iz_route[level.iz_route.size] = (-9727, -4120, 745);
	level.iz_route[level.iz_route.size] = (-9628, -3546, 745);
	level.iz_route[level.iz_route.size] = (-9478, -2885, 745);
	level.iz_route[level.iz_route.size] = (-9338, -2133, 745);
	level.iz_route[level.iz_route.size] = (-9362, -1447, 745);
	level.iz_route[level.iz_route.size] = (-9444, -1184, 745);
	level.iz_route[level.iz_route.size] = (-9576, -960, 745);
	level.iz_route[level.iz_route.size] = (-10003, -463, 745);
	level.iz_route[level.iz_route.size] = (-10574, 33, 745);
	level.iz_route[level.iz_route.size] = (-10789, 166, 745);
	level.iz_route[level.iz_route.size] = (-11015, 290, 745);
	level.iz_route[level.iz_route.size] = (-11679, 906, 745);
	level.iz_route[level.iz_route.size] = (-11981, 1237, 745);
	level.iz_route[level.iz_route.size] = (-12084, 1387, 745);
	level.iz_route[level.iz_route.size] = (-12146, 1625, 745);
	level.iz_route[level.iz_route.size] = (-12496, 2301, 745);
	level.iz_route[level.iz_route.size] = (-12597, 2880, 745);
	level.iz_route[level.iz_route.size] = (-12772, 3266, 745);
	level.iz_route[level.iz_route.size] = (-13127, 3473, 745);
	level.iz_route[level.iz_route.size] = (-13595, 3848, 745);
	level.iz_route[level.iz_route.size] = (-14109, 4232, 745);
	level.iz_route[level.iz_route.size] = (-14718, 4524, 745);
	level.iz_route[level.iz_route.size] = (-14980, 4819, 745);
	level.iz_route[level.iz_route.size] = (-15058, 5043, 745);
	level.iz_route[level.iz_route.size] = (-15070, 5389, 745);
	level.iz_route[level.iz_route.size] = (-15087, 6530, 745);
	level.iz_route[level.iz_route.size] = (-15093, 7504, 745);
	level.iz_route[level.iz_route.size] = (-15093, 7850, 745);
	level.iz_route[level.iz_route.size] = (-14873, 8294, 745);
	level.iz_route[level.iz_route.size] = (-14502, 8788, 745);
	level.iz_route[level.iz_route.size] = (-13951, 9432, 745);
	level.iz_route[level.iz_route.size] = (-13602, 9858, 745);
	level.iz_route[level.iz_route.size] = (-13327, 10026, 745);
	level.iz_route[level.iz_route.size] = (-12771, 10068, 745);
	level.iz_route[level.iz_route.size] = (-11493, 10055, 745);
	level.iz_route[level.iz_route.size] = (-11204, 10202, 745);
	level.iz_route[level.iz_route.size] = (-10989, 10415, 745);
	level.iz_route[level.iz_route.size] = (-10883, 10832, 745);
	level.iz_route[level.iz_route.size] = (-10801, 11404, 745);
	level.iz_route[level.iz_route.size] = (-10795, 12019, 745);
	level.iz_route[level.iz_route.size] = (-10780, 12654, 745);
	level.iz_route[level.iz_route.size] = (-10587, 12963, 745);
	level.iz_route[level.iz_route.size] = (-10326, 13101, 745);
	level.iz_route[level.iz_route.size] = (-9974, 13144, 745);
	level.iz_route[level.iz_route.size] = (-9570, 13160, 745);
	level.iz_route[level.iz_route.size] = (-9087, 13097, 745);
	level.iz_route[level.iz_route.size] = (-8643, 12823, 745);
	level.iz_route[level.iz_route.size] = (-8154, 12433, 745);
	level.iz_route[level.iz_route.size] = (-8050, 12226, 745);
	level.iz_route[level.iz_route.size] = (-8001, 11964, 745);
	level.iz_route[level.iz_route.size] = (-7988, 11560, 745);
	level.iz_route[level.iz_route.size] = (-8003, 10652, 745);
	level.iz_route[level.iz_route.size] = (-8067, 9533, 745);
	level.iz_route[level.iz_route.size] = (-8077, 9034, 745);
	level.iz_route[level.iz_route.size] = (-8023, 8457, 745);
	level.iz_route[level.iz_route.size] = (-7950, 8016, 745);
	level.iz_route[level.iz_route.size] = (-7894, 7347, 745);
	level.iz_route[level.iz_route.size] = (-7889, 6565, 745);
	level.iz_route[level.iz_route.size] = (-8033, 6109, 745);
	level.iz_route[level.iz_route.size] = (-8179, 5848, 745);
	level.iz_route[level.iz_route.size] = (-8467, 5612, 745);
	level.iz_route[level.iz_route.size] = (-8695, 5371, 745);
	level.iz_route[level.iz_route.size] = (-8830, 5073, 745);
	level.iz_route[level.iz_route.size] = (-8867, 4638, 745);
	level.iz_route[level.iz_route.size] = (-8826, 3704, 745);
	level.iz_route[level.iz_route.size] = (-8757, 3310, 745);
	level.iz_route[level.iz_route.size] = (-8596, 2996, 745);
	level.iz_route[level.iz_route.size] = (-8179, 2579, 745);
	level.iz_route[level.iz_route.size] = (-7669, 2270, 745);
	level.iz_route[level.iz_route.size] = (-6950, 2118, 745);
	level.iz_route[level.iz_route.size] = (-6302, 2099, 745);
	level.iz_route[level.iz_route.size] = (-5652, 2299, 745);
	level.iz_route[level.iz_route.size] = (-5135, 2565, 745);
	level.iz_route[level.iz_route.size] = (-4550, 2617, 745);
	level.iz_route[level.iz_route.size] = (-3978, 2685, 745);
	level.iz_route[level.iz_route.size] = (-3685, 2815, 745);
	level.iz_route[level.iz_route.size] = (-3433, 3048, 745);
	level.iz_route[level.iz_route.size] = (-3300, 3402, 745);
	level.iz_route[level.iz_route.size] = (-3224, 3759, 745);
	level.iz_route[level.iz_route.size] = (-3218, 4248, 745);
	level.iz_route[level.iz_route.size] = (-3352, 4659, 745);
	level.iz_route[level.iz_route.size] = (-3871, 5294, 745);
	level.iz_route[level.iz_route.size] = (-4221, 5713, 745);
	level.iz_route[level.iz_route.size] = (-4547, 6113, 745);
	level.iz_route[level.iz_route.size] = (-4769, 6423, 745);
	level.iz_route[level.iz_route.size] = (-4965, 6851, 745);
	level.iz_route[level.iz_route.size] = (-4982, 7240, 745);
	level.iz_route[level.iz_route.size] = (-4926, 7533, 745);
	level.iz_route[level.iz_route.size] = (-4817, 7879, 745);
	level.iz_route[level.iz_route.size] = (-4764, 8167, 745);
	level.iz_route[level.iz_route.size] = (-4769, 8619, 745);
	level.iz_route[level.iz_route.size] = (-4836, 8983, 745);
	level.iz_route[level.iz_route.size] = (-4896, 9410, 745);
	level.iz_route[level.iz_route.size] = (-4914, 9758, 745);
	level.iz_route[level.iz_route.size] = (-4835, 10071, 745);
	level.iz_route[level.iz_route.size] = (-4677, 10290, 745);
	level.iz_route[level.iz_route.size] = (-4353, 10406, 745);
	level.iz_route[level.iz_route.size] = (-3958, 10438, 745);
	level.iz_route[level.iz_route.size] = (-3449, 10434, 745);
	level.iz_route[level.iz_route.size] = (-3052, 10390, 745);
	level.iz_route[level.iz_route.size] = (-2652, 10227, 745);
	level.iz_route[level.iz_route.size] = (-2274, 9960, 745);
	level.iz_route[level.iz_route.size] = (-1827, 9550, 745);
	level.iz_route[level.iz_route.size] = (-1734, 9370, 745);
	level.iz_route[level.iz_route.size] = (-1686, 9058, 745);
	level.iz_route[level.iz_route.size] = (-1673, 8351, 745);
	level.iz_route[level.iz_route.size] = (-1610, 7241, 745);
	level.iz_route[level.iz_route.size] = (-1487, 6720, 745);
	level.iz_route[level.iz_route.size] = (-1177, 6213, 745);
	level.iz_route[level.iz_route.size] = (-855, 5662, 745);
	level.iz_route[level.iz_route.size] = (-663, 5265, 745);
	level.iz_route[level.iz_route.size] = (-218, 4889, 745);
	level.iz_route[level.iz_route.size] = (-49, 4578, 745);
	level.iz_route[level.iz_route.size] = (10, 3659, 745);
	level.iz_route[level.iz_route.size] = (26, 2141, 745);
}
