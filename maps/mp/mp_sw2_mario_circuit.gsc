main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_sw2_mario_circuit", 0);

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
	ambientPlay("iz_0_sw2mc", 2);
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
	level.iz_route[level.iz_route.size] = (3775, 5366, 443);
	level.iz_route[level.iz_route.size] = (4173, 5397, 443);
	level.iz_route[level.iz_route.size] = (4561, 5568, 443);
	level.iz_route[level.iz_route.size] = (4715, 5934, 443);
	level.iz_route[level.iz_route.size] = (4749, 6407, 443);
	level.iz_route[level.iz_route.size] = (4760, 6872, 443);
	level.iz_route[level.iz_route.size] = (4711, 7418, 443);
	level.iz_route[level.iz_route.size] = (4577, 7813, 443);
	level.iz_route[level.iz_route.size] = (4151, 8011, 443);
	level.iz_route[level.iz_route.size] = (3768, 7965, 443);
	level.iz_route[level.iz_route.size] = (3500, 7760, 443);
	level.iz_route[level.iz_route.size] = (3469, 7478, 443);
	level.iz_route[level.iz_route.size] = (3514, 7198, 443);
	level.iz_route[level.iz_route.size] = (3536, 6358, 443);
	level.iz_route[level.iz_route.size] = (3534, 5567, 443);
	level.iz_route[level.iz_route.size] = (3635, 4979, 443);
	level.iz_route[level.iz_route.size] = (3813, 4618, 443);
	level.iz_route[level.iz_route.size] = (4272, 4208, 443);
	level.iz_route[level.iz_route.size] = (4986, 3816, 443);
	level.iz_route[level.iz_route.size] = (8405, 2468, 443);
	level.iz_route[level.iz_route.size] = (11535, 1175, 443);
	level.iz_route[level.iz_route.size] = (12247, 1040, 443);
	level.iz_route[level.iz_route.size] = (12714, 1113, 443);
	level.iz_route[level.iz_route.size] = (13188, 1295, 443);
	level.iz_route[level.iz_route.size] = (13520, 1602, 443);
	level.iz_route[level.iz_route.size] = (13671, 2006, 443);
	level.iz_route[level.iz_route.size] = (13754, 2674, 443);
	level.iz_route[level.iz_route.size] = (13764, 3314, 443);
	level.iz_route[level.iz_route.size] = (13791, 4668, 443);
	level.iz_route[level.iz_route.size] = (13785, 5942, 443);
	level.iz_route[level.iz_route.size] = (13753, 6441, 443);
	level.iz_route[level.iz_route.size] = (13630, 6899, 443);
	level.iz_route[level.iz_route.size] = (13379, 7337, 443);
	level.iz_route[level.iz_route.size] = (13029, 7502, 443);
	level.iz_route[level.iz_route.size] = (12458, 7508, 443);
	level.iz_route[level.iz_route.size] = (11489, 7224, 443);
	level.iz_route[level.iz_route.size] = (9927, 6713, 443);
	level.iz_route[level.iz_route.size] = (9035, 6455, 443);
	level.iz_route[level.iz_route.size] = (8614, 6436, 443);
	level.iz_route[level.iz_route.size] = (8223, 6581, 443);
	level.iz_route[level.iz_route.size] = (7887, 6941, 443);
	level.iz_route[level.iz_route.size] = (7057, 8294, 443);
	level.iz_route[level.iz_route.size] = (6478, 9206, 443);
	level.iz_route[level.iz_route.size] = (6206, 9478, 443);
	level.iz_route[level.iz_route.size] = (5886, 9641, 443);
	level.iz_route[level.iz_route.size] = (5455, 9681, 443);
	level.iz_route[level.iz_route.size] = (4955, 9636, 443);
	level.iz_route[level.iz_route.size] = (4496, 9476, 443);
	level.iz_route[level.iz_route.size] = (4087, 9143, 443);
	level.iz_route[level.iz_route.size] = (3604, 8607, 443);
	level.iz_route[level.iz_route.size] = (2756, 7628, 443);
	level.iz_route[level.iz_route.size] = (2105, 6971, 443);
	level.iz_route[level.iz_route.size] = (1447, 6765, 443);
	level.iz_route[level.iz_route.size] = (861, 6752, 443);
	level.iz_route[level.iz_route.size] = (164, 6867, 443);
	level.iz_route[level.iz_route.size] = (-391, 7071, 443);
	level.iz_route[level.iz_route.size] = (-877, 7415, 443);
	level.iz_route[level.iz_route.size] = (-1488, 7915, 443);
	level.iz_route[level.iz_route.size] = (-2346, 8278, 443);
	level.iz_route[level.iz_route.size] = (-3544, 8420, 443);
	level.iz_route[level.iz_route.size] = (-5056, 8394, 443);
	level.iz_route[level.iz_route.size] = (-6581, 8405, 443);
	level.iz_route[level.iz_route.size] = (-7173, 8502, 443);
	level.iz_route[level.iz_route.size] = (-7419, 8686, 443);
	level.iz_route[level.iz_route.size] = (-7539, 8918, 443);
	level.iz_route[level.iz_route.size] = (-7660, 9313, 443);
	level.iz_route[level.iz_route.size] = (-7722, 9620, 443);
	level.iz_route[level.iz_route.size] = (-7865, 10032, 443);
	level.iz_route[level.iz_route.size] = (-8044, 10402, 443);
	level.iz_route[level.iz_route.size] = (-8290, 10650, 443);
	level.iz_route[level.iz_route.size] = (-8597, 10761, 443);
	level.iz_route[level.iz_route.size] = (-9119, 10782, 443);
	level.iz_route[level.iz_route.size] = (-11003, 10808, 443);
	level.iz_route[level.iz_route.size] = (-12059, 10808, 443);
	level.iz_route[level.iz_route.size] = (-12513, 10733, 443);
	level.iz_route[level.iz_route.size] = (-12887, 10595, 443);
	level.iz_route[level.iz_route.size] = (-13172, 10379, 443);
	level.iz_route[level.iz_route.size] = (-13338, 10201, 443);
	level.iz_route[level.iz_route.size] = (-13477, 9985, 443);
	level.iz_route[level.iz_route.size] = (-13568, 9733, 443);
	level.iz_route[level.iz_route.size] = (-13627, 9454, 443);
	level.iz_route[level.iz_route.size] = (-13634, 8898, 443);
	level.iz_route[level.iz_route.size] = (-13700, 7130, 443);
	level.iz_route[level.iz_route.size] = (-13649, 6128, 443);
	level.iz_route[level.iz_route.size] = (-13494, 5665, 443);
	level.iz_route[level.iz_route.size] = (-13108, 5458, 443);
	level.iz_route[level.iz_route.size] = (-12718, 5362, 443);
	level.iz_route[level.iz_route.size] = (-12196, 5311, 443);
	level.iz_route[level.iz_route.size] = (-11647, 5375, 443);
	level.iz_route[level.iz_route.size] = (-10889, 5571, 443);
	level.iz_route[level.iz_route.size] = (-9776, 6018, 443);
	level.iz_route[level.iz_route.size] = (-8966, 6124, 443);
	level.iz_route[level.iz_route.size] = (-8536, 6091, 443);
	level.iz_route[level.iz_route.size] = (-8199, 5942, 443);
	level.iz_route[level.iz_route.size] = (-7901, 5654, 443);
	level.iz_route[level.iz_route.size] = (-7739, 5236, 443);
	level.iz_route[level.iz_route.size] = (-7719, 4431, 443);
	level.iz_route[level.iz_route.size] = (-7735, 1872, 443);
	level.iz_route[level.iz_route.size] = (-7811, 1405, 443);
	level.iz_route[level.iz_route.size] = (-8046, 1009, 443);
	level.iz_route[level.iz_route.size] = (-8420, 749, 443);
	level.iz_route[level.iz_route.size] = (-8890, 540, 443);
	level.iz_route[level.iz_route.size] = (-9710, 484, 443);
	level.iz_route[level.iz_route.size] = (-10591, 530, 443);
	level.iz_route[level.iz_route.size] = (-11215, 470, 443);
	level.iz_route[level.iz_route.size] = (-12056, 238, 443);
	level.iz_route[level.iz_route.size] = (-12762, 92, 443);
	level.iz_route[level.iz_route.size] = (-13151, 279, 443);
	level.iz_route[level.iz_route.size] = (-13305, 647, 443);
	level.iz_route[level.iz_route.size] = (-13299, 1074, 443);
	level.iz_route[level.iz_route.size] = (-13024, 1607, 443);
	level.iz_route[level.iz_route.size] = (-12615, 2126, 443);
	level.iz_route[level.iz_route.size] = (-12232, 2522, 443);
	level.iz_route[level.iz_route.size] = (-11710, 2671, 443);
	level.iz_route[level.iz_route.size] = (-10900, 2734, 443);
	level.iz_route[level.iz_route.size] = (-10132, 2749, 443);
	level.iz_route[level.iz_route.size] = (-9141, 2732, 462);
	level.iz_route[level.iz_route.size] = (-8855, 2741, 721);
	level.iz_route[level.iz_route.size] = (-7043, 2732, 704);
	level.iz_route[level.iz_route.size] = (-6132, 2754, 443);
	level.iz_route[level.iz_route.size] = (-5215, 2764, 443);
	level.iz_route[level.iz_route.size] = (-4604, 2760, 443);
	level.iz_route[level.iz_route.size] = (-4278, 2539, 443);
	level.iz_route[level.iz_route.size] = (-3819, 2077, 443);
	level.iz_route[level.iz_route.size] = (-3446, 1803, 443);
	level.iz_route[level.iz_route.size] = (-2989, 1585, 443);
	level.iz_route[level.iz_route.size] = (-2113, 1431, 443);
	level.iz_route[level.iz_route.size] = (-1481, 1362, 464);
	level.iz_route[level.iz_route.size] = (-659, 1320, 509);
	level.iz_route[level.iz_route.size] = (830, 1245, 592);
	level.iz_route[level.iz_route.size] = (1809, 1045, 620);
	level.iz_route[level.iz_route.size] = (2503, 650, 620);
	level.iz_route[level.iz_route.size] = (3010, 235, 620);
	level.iz_route[level.iz_route.size] = (3335, -136, 620);
	level.iz_route[level.iz_route.size] = (3705, -748, 620);
	level.iz_route[level.iz_route.size] = (4150, -1569, 620);
	level.iz_route[level.iz_route.size] = (4399, -2338, 620);
	level.iz_route[level.iz_route.size] = (4338, -2893, 620);
	level.iz_route[level.iz_route.size] = (4080, -3481, 620);
	level.iz_route[level.iz_route.size] = (3660, -3925, 620);
	level.iz_route[level.iz_route.size] = (3092, -4181, 620);
	level.iz_route[level.iz_route.size] = (2494, -4518, 620);
	level.iz_route[level.iz_route.size] = (2198, -4880, 620);
	level.iz_route[level.iz_route.size] = (2049, -5164, 620);
	level.iz_route[level.iz_route.size] = (1967, -5446, 620);
	level.iz_route[level.iz_route.size] = (1964, -5810, 620);
	level.iz_route[level.iz_route.size] = (2001, -6260, 620);
	level.iz_route[level.iz_route.size] = (2112, -6810, 620);
	level.iz_route[level.iz_route.size] = (2418, -7262, 620);
	level.iz_route[level.iz_route.size] = (2780, -7577, 620);
	level.iz_route[level.iz_route.size] = (3178, -7828, 620);
	level.iz_route[level.iz_route.size] = (3712, -8198, 620);
	level.iz_route[level.iz_route.size] = (3924, -8514, 620);
	level.iz_route[level.iz_route.size] = (4042, -8874, 620);
	level.iz_route[level.iz_route.size] = (4115, -9245, 620);
	level.iz_route[level.iz_route.size] = (4107, -9591, 620);
	level.iz_route[level.iz_route.size] = (4077, -9993, 620);
	level.iz_route[level.iz_route.size] = (3874, -10281, 620);
	level.iz_route[level.iz_route.size] = (3536, -10525, 620);
	level.iz_route[level.iz_route.size] = (3167, -10659, 620);
	level.iz_route[level.iz_route.size] = (2681, -10729, 620);
	level.iz_route[level.iz_route.size] = (2273, -10735, 620);
	level.iz_route[level.iz_route.size] = (1884, -10690, 620);
	level.iz_route[level.iz_route.size] = (1577, -10626, 620);
	level.iz_route[level.iz_route.size] = (1341, -10485, 620);
	level.iz_route[level.iz_route.size] = (1046, -10272, 620);
	level.iz_route[level.iz_route.size] = (772, -9973, 620);
	level.iz_route[level.iz_route.size] = (609, -9670, 620);
	level.iz_route[level.iz_route.size] = (376, -8933, 620);
	level.iz_route[level.iz_route.size] = (-25, -7511, 620);
	level.iz_route[level.iz_route.size] = (-401, -6204, 620);
	level.iz_route[level.iz_route.size] = (-676, -5230, 620);
	level.iz_route[level.iz_route.size] = (-941, -4721, 620);
	level.iz_route[level.iz_route.size] = (-1188, -4526, 620);
	level.iz_route[level.iz_route.size] = (-1514, -4406, 620);
	level.iz_route[level.iz_route.size] = (-1835, -4483, 620);
	level.iz_route[level.iz_route.size] = (-2026, -4730, 620);
	level.iz_route[level.iz_route.size] = (-2180, -5079, 620);
	level.iz_route[level.iz_route.size] = (-2216, -5530, 620);
	level.iz_route[level.iz_route.size] = (-2218, -6476, 620);
	level.iz_route[level.iz_route.size] = (-2193, -8587, 620);
	level.iz_route[level.iz_route.size] = (-2219, -9430, 620);
	level.iz_route[level.iz_route.size] = (-2371, -9929, 620);
	level.iz_route[level.iz_route.size] = (-2596, -10342, 620);
	level.iz_route[level.iz_route.size] = (-2927, -10599, 620);
	level.iz_route[level.iz_route.size] = (-3385, -10731, 620);
	level.iz_route[level.iz_route.size] = (-3873, -10723, 620);
	level.iz_route[level.iz_route.size] = (-4362, -10643, 620);
	level.iz_route[level.iz_route.size] = (-4781, -10361, 620);
	level.iz_route[level.iz_route.size] = (-5069, -9975, 620);
	level.iz_route[level.iz_route.size] = (-5267, -9593, 620);
	level.iz_route[level.iz_route.size] = (-5340, -9168, 620);
	level.iz_route[level.iz_route.size] = (-5369, -8586, 620);
	level.iz_route[level.iz_route.size] = (-5207, -8035, 620);
	level.iz_route[level.iz_route.size] = (-4971, -7776, 620);
	level.iz_route[level.iz_route.size] = (-4692, -7596, 620);
	level.iz_route[level.iz_route.size] = (-4402, -7351, 620);
	level.iz_route[level.iz_route.size] = (-4220, -7071, 620);
	level.iz_route[level.iz_route.size] = (-4174, -6730, 620);
	level.iz_route[level.iz_route.size] = (-4168, -6162, 620);
	level.iz_route[level.iz_route.size] = (-4180, -5471, 620);
	level.iz_route[level.iz_route.size] = (-4309, -5171, 620);
	level.iz_route[level.iz_route.size] = (-4551, -4793, 620);
	level.iz_route[level.iz_route.size] = (-5062, -4243, 620);
	level.iz_route[level.iz_route.size] = (-5282, -3929, 620);
	level.iz_route[level.iz_route.size] = (-5493, -3444, 620);
	level.iz_route[level.iz_route.size] = (-5624, -2885, 620);
	level.iz_route[level.iz_route.size] = (-5590, -2288, 620);
	level.iz_route[level.iz_route.size] = (-5450, -1688, 620);
	level.iz_route[level.iz_route.size] = (-5080, -1343, 620);
	level.iz_route[level.iz_route.size] = (-4665, -1157, 620);
	level.iz_route[level.iz_route.size] = (-3852, -1038, 620);
	level.iz_route[level.iz_route.size] = (-2311, -1021, 620);
	level.iz_route[level.iz_route.size] = (920, -1013, 620);
	level.iz_route[level.iz_route.size] = (2380, -1063, 620);
	level.iz_route[level.iz_route.size] = (3233, -1180, 620);
	level.iz_route[level.iz_route.size] = (3745, -1357, 620);
}
