main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_ds_rainbow_road", 0);

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
	ambientPlay("iz_0_87", 2);
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
	level.iz_route[level.iz_route.size] = (6623, 3227, 4563);
	level.iz_route[level.iz_route.size] = (6061, 3794, 4558);
	level.iz_route[level.iz_route.size] = (5538, 4308, 4509);
	level.iz_route[level.iz_route.size] = (5203, 4649, 4389);
	level.iz_route[level.iz_route.size] = (4726, 5140, 4122);
	level.iz_route[level.iz_route.size] = (4099, 5790, 3779);
	level.iz_route[level.iz_route.size] = (3473, 6423, 3529);
	level.iz_route[level.iz_route.size] = (2617, 7294, 3262);
	level.iz_route[level.iz_route.size] = (1694, 8212, 3089);
	level.iz_route[level.iz_route.size] = (735, 9046, 3122);
	level.iz_route[level.iz_route.size] = (-534, 9610, 3226);
	level.iz_route[level.iz_route.size] = (-1691, 9289, 3529);
	level.iz_route[level.iz_route.size] = (-2243, 8811, 3721);
	level.iz_route[level.iz_route.size] = (-2422, 7878, 3867);
	level.iz_route[level.iz_route.size] = (-2124, 7255, 3934);
	level.iz_route[level.iz_route.size] = (-1492, 6699, 4064);
	level.iz_route[level.iz_route.size] = (-589, 6365, 4245);
	level.iz_route[level.iz_route.size] = (372, 6415, 4409);
	level.iz_route[level.iz_route.size] = (1000, 6747, 4533);
	level.iz_route[level.iz_route.size] = (1579, 7373, 4740);
	level.iz_route[level.iz_route.size] = (1769, 8141, 4940);
	level.iz_route[level.iz_route.size] = (1503, 8969, 5127);
	level.iz_route[level.iz_route.size] = (968, 9556, 5349);
	level.iz_route[level.iz_route.size] = (99, 9933, 5603);
	level.iz_route[level.iz_route.size] = (-760, 9847, 5668);
	level.iz_route[level.iz_route.size] = (-1381, 9577, 5682);
	level.iz_route[level.iz_route.size] = (-1762, 9115, 5617);
	level.iz_route[level.iz_route.size] = (-1871, 8586, 5510);
	level.iz_route[level.iz_route.size] = (-1782, 8072, 5406);
	level.iz_route[level.iz_route.size] = (-1593, 7431, 5323);
	level.iz_route[level.iz_route.size] = (-1436, 6827, 5164);
	level.iz_route[level.iz_route.size] = (-1443, 6310, 4816);
	level.iz_route[level.iz_route.size] = (-1427, 5499, 4101);
	level.iz_route[level.iz_route.size] = (-1448, 4187, 3481);
	level.iz_route[level.iz_route.size] = (-1449, 2482, 3168);
	level.iz_route[level.iz_route.size] = (-956, 1303, 3508);
	level.iz_route[level.iz_route.size] = (-63, 1058, 3931);
	level.iz_route[level.iz_route.size] = (695, 1379, 4220);
	level.iz_route[level.iz_route.size] = (1099, 1992, 4480);
	level.iz_route[level.iz_route.size] = (1026, 2767, 4717);
	level.iz_route[level.iz_route.size] = (462, 3416, 4996);
	level.iz_route[level.iz_route.size] = (-305, 3535, 5220);
	level.iz_route[level.iz_route.size] = (-1071, 3046, 5389);
	level.iz_route[level.iz_route.size] = (-1534, 2244, 5360);
	level.iz_route[level.iz_route.size] = (-1967, 1074, 5172);
	level.iz_route[level.iz_route.size] = (-2245, -21, 4923);
	level.iz_route[level.iz_route.size] = (-2416, -1072, 4574);
	level.iz_route[level.iz_route.size] = (-2488, -2258, 4532);
	level.iz_route[level.iz_route.size] = (-2485, -2793, 4719);
	level.iz_route[level.iz_route.size] = (-2486, -3226, 4819);
	level.iz_route[level.iz_route.size] = (-2501, -3886, 4914);
	level.iz_route[level.iz_route.size] = (-2509, -4692, 4985);
	level.iz_route[level.iz_route.size] = (-2546, -6043, 5073);
	level.iz_route[level.iz_route.size] = (-2628, -6622, 5120);
	level.iz_route[level.iz_route.size] = (-2832, -7020, 5161);
	level.iz_route[level.iz_route.size] = (-3183, -7234, 5186);
	level.iz_route[level.iz_route.size] = (-3616, -7307, 5202);
	level.iz_route[level.iz_route.size] = (-4077, -7177, 5184);
	level.iz_route[level.iz_route.size] = (-4476, -6798, 5132);
	level.iz_route[level.iz_route.size] = (-4788, -6240, 5068);
	level.iz_route[level.iz_route.size] = (-5178, -5539, 5162);
	level.iz_route[level.iz_route.size] = (-5855, -4014, 4469);
	level.iz_route[level.iz_route.size] = (-6097, -3499, 4390);
	level.iz_route[level.iz_route.size] = (-6265, -3092, 4347);
	level.iz_route[level.iz_route.size] = (-6338, -2654, 4326);
	level.iz_route[level.iz_route.size] = (-6175, -2282, 4334);
	level.iz_route[level.iz_route.size] = (-5814, -1851, 4383);
	level.iz_route[level.iz_route.size] = (-5612, -1441, 4445);
	level.iz_route[level.iz_route.size] = (-5608, -1087, 4472);
	level.iz_route[level.iz_route.size] = (-5862, -752, 4426);
	level.iz_route[level.iz_route.size] = (-6211, -524, 4377);
	level.iz_route[level.iz_route.size] = (-6668, -427, 4334);
	level.iz_route[level.iz_route.size] = (-7457, -374, 4306);
	level.iz_route[level.iz_route.size] = (-8798, -296, 4323);
	level.iz_route[level.iz_route.size] = (-9559, -2, 4455);
	level.iz_route[level.iz_route.size] = (-9892, 508, 4493);
	level.iz_route[level.iz_route.size] = (-10010, 1122, 4507);
	level.iz_route[level.iz_route.size] = (-9521, 1663, 4400);
	level.iz_route[level.iz_route.size] = (-9012, 1982, 4348);
	level.iz_route[level.iz_route.size] = (-8204, 2007, 4156);
	level.iz_route[level.iz_route.size] = (-7334, 1983, 4010);
	level.iz_route[level.iz_route.size] = (-6852, 1975, 3975);
	level.iz_route[level.iz_route.size] = (-6128, 2040, 3955);
	level.iz_route[level.iz_route.size] = (-5217, 2248, 3916);
	level.iz_route[level.iz_route.size] = (-3256, 2614, 3923);
	level.iz_route[level.iz_route.size] = (-1650, 3019, 3927);
	level.iz_route[level.iz_route.size] = (132, 3454, 4022);
	level.iz_route[level.iz_route.size] = (1517, 3537, 3961);
	level.iz_route[level.iz_route.size] = (2584, 3491, 4028);
	level.iz_route[level.iz_route.size] = (3497, 3428, 4165);
	level.iz_route[level.iz_route.size] = (4143, 3226, 4239);
	level.iz_route[level.iz_route.size] = (4595, 3007, 4270);
	level.iz_route[level.iz_route.size] = (4900, 2739, 4259);
	level.iz_route[level.iz_route.size] = (5164, 2420, 4271);
	level.iz_route[level.iz_route.size] = (5310, 1947, 4252);
	level.iz_route[level.iz_route.size] = (5369, 1414, 4240);
	level.iz_route[level.iz_route.size] = (5381, 537, 4319);
	level.iz_route[level.iz_route.size] = (5548, -82, 4477);
	level.iz_route[level.iz_route.size] = (5971, -393, 4625);
	level.iz_route[level.iz_route.size] = (6413, -597, 4751);
	level.iz_route[level.iz_route.size] = (6954, -677, 4860);
	level.iz_route[level.iz_route.size] = (7562, -627, 4978);
	level.iz_route[level.iz_route.size] = (8174, -303, 5067);
	level.iz_route[level.iz_route.size] = (8420, 156, 5038);
	level.iz_route[level.iz_route.size] = (8521, 730, 4963);
	level.iz_route[level.iz_route.size] = (8461, 1263, 4867);
	level.iz_route[level.iz_route.size] = (8094, 1837, 4694);
	level.iz_route[level.iz_route.size] = (7283, 2582, 4568);
}
