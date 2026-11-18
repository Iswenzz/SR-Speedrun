main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_gba_bowser_castle_4", 0);

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

	thread iz_anims();

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
}

iz_sounds()
{
	ambientPlay("iz_0_54", 2);
	level thread iz_music("iz_7_se_cr_gbk_env");
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
	level.iz_route[level.iz_route.size] = (-8672, -1450, 564);
	level.iz_route[level.iz_route.size] = (-8634, -4950, 564);
	level.iz_route[level.iz_route.size] = (-8545, -5371, 564);
	level.iz_route[level.iz_route.size] = (-8292, -5671, 564);
	level.iz_route[level.iz_route.size] = (-7938, -5884, 564);
	level.iz_route[level.iz_route.size] = (-7607, -6127, 564);
	level.iz_route[level.iz_route.size] = (-7414, -6467, 564);
	level.iz_route[level.iz_route.size] = (-7296, -7000, 564);
	level.iz_route[level.iz_route.size] = (-7296, -7666, 564);
	level.iz_route[level.iz_route.size] = (-7275, -9699, 564);
	level.iz_route[level.iz_route.size] = (-7149, -10013, 564);
	level.iz_route[level.iz_route.size] = (-6898, -10285, 564);
	level.iz_route[level.iz_route.size] = (-6522, -10410, 564);
	level.iz_route[level.iz_route.size] = (-3888, -10410, 564);
	level.iz_route[level.iz_route.size] = (-3575, -10347, 564);
	level.iz_route[level.iz_route.size] = (-3240, -10117, 564);
	level.iz_route[level.iz_route.size] = (-3060, -9802, 564);
	level.iz_route[level.iz_route.size] = (-3010, -9411, 564);
	level.iz_route[level.iz_route.size] = (-2989, -7860, 564);
	level.iz_route[level.iz_route.size] = (-2759, -7567, 564);
	level.iz_route[level.iz_route.size] = (-2508, -7295, 564);
	level.iz_route[level.iz_route.size] = (-2258, -6794, 564);
	level.iz_route[level.iz_route.size] = (-2132, -6292, 564);
	level.iz_route[level.iz_route.size] = (-2174, -5895, 564);
	level.iz_route[level.iz_route.size] = (-2404, -5498, 564);
	level.iz_route[level.iz_route.size] = (-2613, -5142, 564);
	level.iz_route[level.iz_route.size] = (-2738, -4766, 564);
	level.iz_route[level.iz_route.size] = (-2780, -4379, 564);
	level.iz_route[level.iz_route.size] = (-2619, -4084, 564);
	level.iz_route[level.iz_route.size] = (-2471, -3744, 564);
	level.iz_route[level.iz_route.size] = (-2368, -3359, 564);
	level.iz_route[level.iz_route.size] = (-2368, -2930, 564);
	level.iz_route[level.iz_route.size] = (-2531, -2619, 564);
	level.iz_route[level.iz_route.size] = (-2827, -2161, 564);
	level.iz_route[level.iz_route.size] = (-3049, -1886, 564);
	level.iz_route[level.iz_route.size] = (-3049, -1236, 564);
	level.iz_route[level.iz_route.size] = (-3122, -1037, 564);
	level.iz_route[level.iz_route.size] = (-3248, -911, 564);
	level.iz_route[level.iz_route.size] = (-3499, -817, 564);
	level.iz_route[level.iz_route.size] = (-5524, -826, 564);
	level.iz_route[level.iz_route.size] = (-5818, -766, 564);
	level.iz_route[level.iz_route.size] = (-6122, -657, 564);
	level.iz_route[level.iz_route.size] = (-6294, -520, 564);
	level.iz_route[level.iz_route.size] = (-6422, -315, 564);
	level.iz_route[level.iz_route.size] = (-6543, -110, 564);
	level.iz_route[level.iz_route.size] = (-6626, 78, 564);
	level.iz_route[level.iz_route.size] = (-6714, 280, 564);
	level.iz_route[level.iz_route.size] = (-6780, 467, 564);
	level.iz_route[level.iz_route.size] = (-6797, 663, 564);
	level.iz_route[level.iz_route.size] = (-6820, 3525, 564);
	level.iz_route[level.iz_route.size] = (-6789, 3900, 564);
	level.iz_route[level.iz_route.size] = (-6579, 4184, 564);
	level.iz_route[level.iz_route.size] = (-5957, 4650, 564);
	level.iz_route[level.iz_route.size] = (-5641, 4834, 564);
	level.iz_route[level.iz_route.size] = (-5255, 4998, 564);
	level.iz_route[level.iz_route.size] = (-4861, 5144, 564);
	level.iz_route[level.iz_route.size] = (-1697, 5144, 564);
	level.iz_route[level.iz_route.size] = (-1404, 5113, 564);
	level.iz_route[level.iz_route.size] = (-1090, 4956, 564);
	level.iz_route[level.iz_route.size] = (-849, 4673, 564);
	level.iz_route[level.iz_route.size] = (-765, 4243, 564);
	level.iz_route[level.iz_route.size] = (-744, 2871, 564);
	level.iz_route[level.iz_route.size] = (-712, 2546, 564);
	level.iz_route[level.iz_route.size] = (-576, 2242, 564);
	level.iz_route[level.iz_route.size] = (-335, 1959, 564);
	level.iz_route[level.iz_route.size] = (52, 1676, 564);
	level.iz_route[level.iz_route.size] = (492, 1488, 564);
	level.iz_route[level.iz_route.size] = (1069, 1413, 564);
	level.iz_route[level.iz_route.size] = (2263, 1383, 564);
	level.iz_route[level.iz_route.size] = (7260, 1393, 564);
	level.iz_route[level.iz_route.size] = (7543, 1289, 564);
	level.iz_route[level.iz_route.size] = (7763, 1090, 564);
	level.iz_route[level.iz_route.size] = (7899, 817, 564);
	level.iz_route[level.iz_route.size] = (7983, 430, 564);
	level.iz_route[level.iz_route.size] = (8028, 123, 564);
	level.iz_route[level.iz_route.size] = (8036, -86, 564);
	level.iz_route[level.iz_route.size] = (7873, -269, 564);
	level.iz_route[level.iz_route.size] = (7670, -633, 564);
	level.iz_route[level.iz_route.size] = (7606, -932, 564);
	level.iz_route[level.iz_route.size] = (7585, -1477, 564);
	level.iz_route[level.iz_route.size] = (7621, -5683, 564);
	level.iz_route[level.iz_route.size] = (7740, -6112, 564);
	level.iz_route[level.iz_route.size] = (8036, -6526, 564);
	level.iz_route[level.iz_route.size] = (8347, -6955, 564);
	level.iz_route[level.iz_route.size] = (8421, -7488, 564);
	level.iz_route[level.iz_route.size] = (8628, -7814, 564);
	level.iz_route[level.iz_route.size] = (8628, -8509, 564);
	level.iz_route[level.iz_route.size] = (8480, -8879, 564);
	level.iz_route[level.iz_route.size] = (8213, -9146, 564);
	level.iz_route[level.iz_route.size] = (7814, -9382, 564);
	level.iz_route[level.iz_route.size] = (7429, -9530, 564);
	level.iz_route[level.iz_route.size] = (6926, -9649, 564);
	level.iz_route[level.iz_route.size] = (3611, -9634, 564);
	level.iz_route[level.iz_route.size] = (3226, -9530, 564);
	level.iz_route[level.iz_route.size] = (3004, -9382, 564);
	level.iz_route[level.iz_route.size] = (2738, -9086, 564);
	level.iz_route[level.iz_route.size] = (2575, -8791, 564);
	level.iz_route[level.iz_route.size] = (2560, -8273, 564);
	level.iz_route[level.iz_route.size] = (2605, -7621, 564);
	level.iz_route[level.iz_route.size] = (2670, -7253, 564);
	level.iz_route[level.iz_route.size] = (2708, -6941, 564);
	level.iz_route[level.iz_route.size] = (2713, -6569, 564);
	level.iz_route[level.iz_route.size] = (2903, -6393, 564);
	level.iz_route[level.iz_route.size] = (3017, -5877, 564);
	level.iz_route[level.iz_route.size] = (3154, -5521, 564);
	level.iz_route[level.iz_route.size] = (3237, -5228, 564);
	level.iz_route[level.iz_route.size] = (3269, -4903, 564);
	level.iz_route[level.iz_route.size] = (3321, -4442, 564);
	level.iz_route[level.iz_route.size] = (3468, -4023, 564);
	level.iz_route[level.iz_route.size] = (3635, -3709, 564);
	level.iz_route[level.iz_route.size] = (3677, -3415, 564);
	level.iz_route[level.iz_route.size] = (3688, -3091, 564);
	level.iz_route[level.iz_route.size] = (3730, -2776, 564);
	level.iz_route[level.iz_route.size] = (3824, -2368, 564);
	level.iz_route[level.iz_route.size] = (3960, -2158, 564);
	level.iz_route[level.iz_route.size] = (4233, -1917, 564);
	level.iz_route[level.iz_route.size] = (4421, -1708, 564);
	level.iz_route[level.iz_route.size] = (4536, -1477, 564);
	level.iz_route[level.iz_route.size] = (4536, -1184, 564);
	level.iz_route[level.iz_route.size] = (4348, -1016, 564);
	level.iz_route[level.iz_route.size] = (4358, -712, 564);
	level.iz_route[level.iz_route.size] = (4369, -314, 564);
	level.iz_route[level.iz_route.size] = (4379, 84, 564);
	level.iz_route[level.iz_route.size] = (4390, 430, 650);
	level.iz_route[level.iz_route.size] = (4390, 786, 768);
	level.iz_route[level.iz_route.size] = (4400, 1310, 768);
	level.iz_route[level.iz_route.size] = (4411, 2116, 768);
	level.iz_route[level.iz_route.size] = (4400, 2347, 709);
	level.iz_route[level.iz_route.size] = (4400, 2693, 564);
	level.iz_route[level.iz_route.size] = (4400, 3049, 564);
	level.iz_route[level.iz_route.size] = (4396, 3329, 564);
	level.iz_route[level.iz_route.size] = (4416, 4310, 564);
	level.iz_route[level.iz_route.size] = (4569, 4536, 564);
	level.iz_route[level.iz_route.size] = (4843, 4813, 564);
	level.iz_route[level.iz_route.size] = (5123, 5186, 564);
	level.iz_route[level.iz_route.size] = (5238, 5511, 564);
	level.iz_route[level.iz_route.size] = (5280, 5898, 564);
	level.iz_route[level.iz_route.size] = (5298, 8421, 564);
	level.iz_route[level.iz_route.size] = (5194, 8717, 564);
	level.iz_route[level.iz_route.size] = (4972, 8998, 564);
	level.iz_route[level.iz_route.size] = (4632, 9308, 564);
	level.iz_route[level.iz_route.size] = (4321, 9501, 564);
	level.iz_route[level.iz_route.size] = (3951, 9619, 564);
	level.iz_route[level.iz_route.size] = (1495, 9619, 564);
	level.iz_route[level.iz_route.size] = (1080, 9456, 564);
	level.iz_route[level.iz_route.size] = (681, 9101, 564);
	level.iz_route[level.iz_route.size] = (370, 8613, 564);
	level.iz_route[level.iz_route.size] = (-15, 8228, 564);
	level.iz_route[level.iz_route.size] = (-592, 8036, 564);
	level.iz_route[level.iz_route.size] = (-1140, 7784, 564);
	level.iz_route[level.iz_route.size] = (-1583, 7459, 564);
	level.iz_route[level.iz_route.size] = (-1968, 7222, 564);
	level.iz_route[level.iz_route.size] = (-2427, 7192, 564);
	level.iz_route[level.iz_route.size] = (-4972, 7192, 564);
	level.iz_route[level.iz_route.size] = (-5254, 7311, 564);
	level.iz_route[level.iz_route.size] = (-5476, 7592, 564);
	level.iz_route[level.iz_route.size] = (-5624, 7991, 564);
	level.iz_route[level.iz_route.size] = (-5653, 9190, 564);
	level.iz_route[level.iz_route.size] = (-5772, 9530, 564);
	level.iz_route[level.iz_route.size] = (-6038, 9826, 564);
	level.iz_route[level.iz_route.size] = (-6364, 9989, 564);
	level.iz_route[level.iz_route.size] = (-6778, 10048, 564);
	level.iz_route[level.iz_route.size] = (-7947, 10004, 564);
	level.iz_route[level.iz_route.size] = (-8361, 9856, 564);
	level.iz_route[level.iz_route.size] = (-8746, 9501, 564);
	level.iz_route[level.iz_route.size] = (-8909, 9012, 564);
	level.iz_route[level.iz_route.size] = (-8968, 8139, 564);
	level.iz_route[level.iz_route.size] = (-8924, 4025, 564);
	level.iz_route[level.iz_route.size] = (-8894, 2397, 564);
	level.iz_route[level.iz_route.size] = (-8835, 1909, 564);
	level.iz_route[level.iz_route.size] = (-8737, 1463, 564);
	level.iz_route[level.iz_route.size] = (-8655, 932, 564);
	level.iz_route[level.iz_route.size] = (-8675, -1440, 564);
}

iz_move(origin, angles, frames)
{
	if (!isDefined(self.iz_step))
	{
		self.iz_step = (0, 0, 0);
		self.iz_turn = (0, 0, 0);
	}
	time = frames * 0.05 + 0.0005;
	if (isDefined(origin))
	{
		to = origin - self.iz_step;
		self.iz_step = (to - self.origin) * (1.0 / frames);
		self moveTo(to, time);
	}
	if (isDefined(angles))
	{
		turn = angles - self.iz_turn - self.angles;
		turn = (iz_wrap(turn[0]), iz_wrap(turn[1]), iz_wrap(turn[2]));
		self.iz_turn = turn * (1.0 / frames);
		self rotateTo(self.angles + turn, time);
	}
}

iz_wrap(angle)
{
	return angle - 360 * floor(angle / 360 + 0.5);
}

iz_place(origin, angles)
{
	self.origin = origin;
	if (isDefined(angles))
		self.angles = angles;
	self.iz_step = (0, 0, 0);
	self.iz_turn = (0, 0, 0);
}

iz_stop(origin, angles)
{
	self iz_move(origin, angles, 1);
	wait 0.05;
	self iz_move(origin, angles, 1);
}

iz_anims()
{
	thread iz_obj_0();
	thread iz_obj_1();
	thread iz_obj_2();
	thread iz_obj_3();
	thread iz_obj_4();
	thread iz_obj_5();
	thread iz_obj_6();
	thread iz_obj_7();
	thread iz_obj_8();
	thread iz_obj_9();
	thread iz_obj_10();
	thread iz_obj_11();
	thread iz_obj_12();
	thread iz_obj_13();
	thread iz_obj_14();
	thread iz_obj_15();
	thread iz_obj_16();
	thread iz_obj_17();
	thread iz_obj_18();
	thread iz_obj_19();
	thread iz_obj_20();
	thread iz_obj_21();
	thread iz_obj_22();
	thread iz_obj_23();
	thread iz_obj_24();
	thread iz_obj_25();
	thread iz_obj_26();
	thread iz_obj_27();
	thread iz_obj_28();
}

iz_obj_0()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (4171.0630, 3711.9961, 563.9016);
	angles[0] = (0, 24.3722, 0);
	at[0] = 0;
	points[1] = (4067.4014, 3945.1182, 563.9016);
	angles[1] = (0, 23.9777, 0);
	at[1] = 1.2000;
	points[2] = (4062.3228, 3961.6929, 563.9016);
	angles[2] = (0, 10.7648, 0);
	at[2] = 1.3000;
	points[3] = (4062.9526, 3972.2837, 563.9016);
	angles[3] = (0, 0.3468, 0);
	at[3] = 1.4000;
	points[4] = (4064.2126, 3993.5039, 563.9016);
	angles[4] = (0, -3.1149, 0);
	at[4] = 1.6000;
	points[5] = (4081.6931, 4290.6299, 563.9016);
	angles[5] = (0, -3.3703, 0);
	at[5] = 4.4000;
	points[6] = (4083.9766, 4300.5908, 563.9016);
	angles[6] = (0, -15.9534, 0);
	at[6] = 4.5000;
	points[7] = (4090.7087, 4308.8188, 563.9016);
	angles[7] = (0, -33.0224, 0);
	at[7] = 4.6000;
	points[8] = (4104.1338, 4325.3149, 563.9016);
	angles[8] = (0, -38.7357, 0);
	at[8] = 4.8000;
	points[9] = (4278.6616, 4539.6064, 563.9016);
	angles[9] = (0, -39.1576, 0);
	at[9] = 7.4000;
	points[10] = (4288.4253, 4540.6299, 563.9016);
	angles[10] = (0, -75.6251, 0);
	at[10] = 7.5000;
	points[11] = (4299.0156, 4539.7637, 563.9016);
	angles[11] = (0, -89.7265, 0);
	at[11] = 7.6000;
	points[12] = (4309.6455, 4538.8584, 563.9016);
	angles[12] = (0, -93.4518, 0);
	at[12] = 7.7000;
	points[13] = (4521.4961, 4521.1416, 563.9016);
	angles[13] = (0, -94.7761, 0);
	at[13] = 9.7000;
	points[14] = (4535.1968, 4510.9058, 563.9016);
	angles[14] = (0, -120.5405, 0);
	at[14] = 9.8000;
	points[15] = (4550.6299, 4496.2598, 563.9016);
	angles[15] = (0, -130.1261, 0);
	at[15] = 9.9000;
	points[16] = (4581.4170, 4466.9683, 563.9016);
	angles[16] = (0, -133.3091, 0);
	at[16] = 10.1000;
	points[17] = (4704.7246, 4349.8032, 563.9016);
	angles[17] = (0, -133.5440, 0);
	at[17] = 10.9000;
	points[18] = (4715.6299, 4335.2363, 563.9016);
	angles[18] = (0, -151.7322, 0);
	at[18] = 11;
	points[19] = (4714.3311, 4324.6455, 563.9016);
	angles[19] = (0, -177.5113, 0);
	at[19] = 11.1000;
	points[20] = (4713.0708, 4314.0947, 563.9016);
	angles[20] = (0, -184.4519, 0);
	at[20] = 11.2000;
	points[21] = (4711.7720, 4303.5435, 563.9016);
	angles[21] = (0, -186.2747, 0);
	at[21] = 11.3000;
	points[22] = (4673.3467, 3986.9685, 563.9016);
	angles[22] = (0, -186.9224, 0);
	at[22] = 14.3000;
	points[23] = (4670.1968, 3976.9292, 563.9016);
	angles[23] = (0, -196.1959, 0);
	at[23] = 14.4000;
	points[24] = (4662.0078, 3957.3228, 563.9016);
	angles[24] = (0, -202.2228, 0);
	at[24] = 14.6000;
	points[25] = (4522.7163, 3623.8110, 563.9016);
	angles[25] = (0, -202.6679, 0);
	at[25] = 18;
	points[26] = (4514.9214, 3619.9805, 563.9016);
	angles[26] = (0, -242.2769, 0);
	at[26] = 18.1000;
	points[27] = (4504.2910, 3620.6772, 563.9016);
	angles[27] = (0, -265.3781, 0);
	at[27] = 18.2000;
	points[28] = (4493.7007, 3621.3743, 563.9016);
	angles[28] = (0, -271.5641, 0);
	at[28] = 18.3000;
	points[29] = (4207.3228, 3640.2244, 563.9016);
	angles[29] = (0, -273.7651, 0);
	at[29] = 21;
	points[30] = (4198.4253, 3650.4841, 563.9016);
	angles[30] = (0, -308.9834, 0);
	at[30] = 21.1000;
	points[31] = (4189.8032, 3669.9094, 563.9016);
	angles[31] = (0, -328.8509, 0);
	at[31] = 21.2000;
	points[32] = (4181.1416, 3689.3347, 563.9016);
	angles[32] = (0, -334.1408, 0);
	at[32] = 21.3000;
	points[33] = (4171.0630, 3711.9961, 563.9016);
	angles[33] = (0, -335.6278, 0);
	at[33] = 21.4167;
	mover = getEnt("iz_obj_0", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_1()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (5683.8979, 5943.7397, 563.9016);
	angles[0] = (0, -9.3298, 0);
	at[0] = 0;
	points[1] = (5735.5122, 6262.0078, 563.9016);
	angles[1] = (0, -9.2142, 0);
	at[1] = 1.5167;
	points[2] = (5736.1025, 6281.1416, 563.9016);
	angles[2] = (0, 3.7986, 0);
	at[2] = 1.6333;
	points[3] = (5733.3467, 6293.2285, 563.9016);
	angles[3] = (0, 11.0155, 0);
	at[3] = 1.7500;
	points[4] = (5730.5513, 6305.3149, 563.9016);
	angles[4] = (0, 12.5315, 0);
	at[4] = 1.8667;
	points[5] = (5658.3862, 6619.6064, 563.9016);
	angles[5] = (0, 12.9339, 0);
	at[5] = 4.9000;
	points[6] = (5654.3701, 6631.0234, 563.9016);
	angles[6] = (0, 23.1722, 0);
	at[6] = 5.0167;
	points[7] = (5646.1021, 6640.2754, 563.9016);
	angles[7] = (0, 37.8777, 0);
	at[7] = 5.1333;
	points[8] = (5637.8350, 6649.5273, 563.9016);
	angles[8] = (0, 40.9836, 0);
	at[8] = 5.2500;
	points[9] = (5447.6772, 6862.1265, 563.9016);
	angles[9] = (0, 41.8081, 0);
	at[9] = 7.9333;
	points[10] = (5435.9844, 6864.0156, 563.9016);
	angles[10] = (0, 75.4250, 0);
	at[10] = 8.0500;
	points[11] = (5423.5830, 6864.4487, 563.9016);
	angles[11] = (0, 85.3182, 0);
	at[11] = 8.1667;
	points[12] = (5398.7793, 6865.3545, 563.9016);
	angles[12] = (0, 87.8361, 0);
	at[12] = 8.4000;
	points[13] = (5212.8740, 6872.0078, 563.9016);
	angles[13] = (0, 87.9520, 0);
	at[13] = 10.1500;
	points[14] = (5203.3071, 6855.3149, 563.9016);
	angles[14] = (0, 138.9707, 0);
	at[14] = 10.2667;
	points[15] = (5194.6060, 6832.0869, 563.9016);
	angles[15] = (0, 155.1425, 0);
	at[15] = 10.3833;
	points[16] = (5177.2051, 6785.6299, 563.9016);
	angles[16] = (0, 159.2810, 0);
	at[16] = 10.6167;
	points[17] = (5081.5356, 6530.1182, 563.9016);
	angles[17] = (0, 159.4714, 0);
	at[17] = 11.9000;
	points[18] = (5072.8350, 6506.8896, 563.9016);
	angles[18] = (0, 163.6186, 0);
	at[18] = 12.0167;
	points[19] = (5073.3467, 6494.4092, 563.9016);
	angles[19] = (0, 176.8909, 0);
	at[19] = 12.1333;
	points[20] = (5073.5044, 6469.6064, 563.9016);
	angles[20] = (0, 180.2777, 0);
	at[20] = 12.3667;
	points[21] = (5075.9448, 6147.1655, 563.9016);
	angles[21] = (0, 180.4335, 0);
	at[21] = 15.4000;
	points[22] = (5077.9136, 6135.0396, 563.9016);
	angles[22] = (0, 189.8976, 0);
	at[22] = 15.5167;
	points[23] = (5081.4565, 6123.1499, 563.9016);
	angles[23] = (0, 195.1178, 0);
	at[23] = 15.6333;
	points[24] = (5084.9609, 6111.2598, 563.9016);
	angles[24] = (0, 196.2135, 0);
	at[24] = 15.7500;
	points[25] = (5194.1733, 5742.6382, 563.9016);
	angles[25] = (0, 196.5043, 0);
	at[25] = 19.3667;
	points[26] = (5205.7876, 5744.4487, 563.9016);
	angles[26] = (0, 261.6475, 0);
	at[26] = 19.4833;
	points[27] = (5217.9136, 5747.0864, 563.9016);
	angles[27] = (0, 277.9696, 0);
	at[27] = 19.6000;
	points[28] = (5230, 5749.7246, 563.9016);
	angles[28] = (0, 281.4226, 0);
	at[28] = 19.7167;
	points[29] = (5666.1812, 5845.1572, 563.9016);
	angles[29] = (0, 282.3394, 0);
	at[29] = 23.9167;
	points[30] = (5670.8267, 5863.2681, 563.9016);
	angles[30] = (0, 331.3274, 0);
	at[30] = 24.0333;
	points[31] = (5674.8032, 5887.7559, 563.9016);
	angles[31] = (0, 346.6798, 0);
	at[31] = 24.1500;
	points[32] = (5683.8979, 5943.7397, 563.9016);
	angles[32] = (0, 350.6702, 0);
	at[32] = 24.4167;
	mover = getEnt("iz_obj_1", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_2()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (5030.6299, 7783.7793, 563.9016);
	angles[0] = (0, 12.7793, 0);
	at[0] = 0;
	points[1] = (4973.4644, 8050.5508, 563.9016);
	angles[1] = (0, 12.0948, 0);
	at[1] = 1.2833;
	points[2] = (4971.2993, 8068.0312, 563.9016);
	angles[2] = (0, 4.0135, 0);
	at[2] = 1.4000;
	points[3] = (4971.2598, 8105.2363, 563.9016);
	angles[3] = (0, 0.0984, 0);
	at[3] = 1.7500;
	points[4] = (4970.9058, 8440.0791, 563.9016);
	angles[4] = (0, 0.0619, 0);
	at[4] = 4.9000;
	points[5] = (4970.9058, 8452.4805, 563.9016);
	angles[5] = (0, -6.2148, 0);
	at[5] = 5.0167;
	points[6] = (4978.1890, 8462.7959, 563.9016);
	angles[6] = (0, -26.6493, 0);
	at[6] = 5.1333;
	points[7] = (4991.4175, 8483.7803, 563.9016);
	angles[7] = (0, -31.9062, 0);
	at[7] = 5.3667;
	points[8] = (5169.5674, 8767.2832, 563.9016);
	angles[8] = (0, -32.1481, 0);
	at[8] = 8.5167;
	points[9] = (5181.2202, 8768.7012, 563.9016);
	angles[9] = (0, -77.0986, 0);
	at[9] = 8.6333;
	points[10] = (5193.6221, 8768.7012, 563.9016);
	angles[10] = (0, -87.2392, 0);
	at[10] = 8.7500;
	points[11] = (5218.4253, 8768.7402, 563.9016);
	angles[11] = (0, -89.8205, 0);
	at[11] = 8.9833;
	points[12] = (5429.2520, 8768.9375, 563.9016);
	angles[12] = (0, -89.9391, 0);
	at[12] = 10.9667;
	points[13] = (5442.3618, 8759.5664, 563.9016);
	angles[13] = (0, -119.9010, 0);
	at[13] = 11.0833;
	points[14] = (5457.5591, 8740, 563.9016);
	angles[14] = (0, -137.4703, 0);
	at[14] = 11.2000;
	points[15] = (5487.9922, 8700.7871, 563.9016);
	angles[15] = (0, -141.9734, 0);
	at[15] = 11.4333;
	points[16] = (5624.8818, 8524.4492, 563.9016);
	angles[16] = (0, -142.1807, 0);
	at[16] = 12.4833;
	points[17] = (5634.9214, 8506.4180, 563.9016);
	angles[17] = (0, -156.6477, 0);
	at[17] = 12.6000;
	points[18] = (5636.6143, 8494.1338, 563.9016);
	angles[18] = (0, -168.9157, 0);
	at[18] = 12.7167;
	points[19] = (5639.9609, 8469.5674, 563.9016);
	angles[19] = (0, -172.0435, 0);
	at[19] = 12.9500;
	points[20] = (5685.5122, 8137.8350, 563.9016);
	angles[20] = (0, -172.1874, 0);
	at[20] = 16.1000;
	points[21] = (5681.5356, 8126.1421, 563.9016);
	angles[21] = (0, -194.0021, 0);
	at[21] = 16.2167;
	points[22] = (5673.1104, 8102.7954, 563.9016);
	angles[22] = (0, -199.6253, 0);
	at[22] = 16.4500;
	points[23] = (5542.3623, 7741.2603, 563.9016);
	angles[23] = (0, -199.8842, 0);
	at[23] = 20.0667;
	points[24] = (5530.0791, 7740.3545, 563.9016);
	angles[24] = (0, -251.3376, 0);
	at[24] = 20.1833;
	points[25] = (5517.7163, 7739.5674, 563.9016);
	angles[25] = (0, -263.2549, 0);
	at[25] = 20.3000;
	points[26] = (5505.3154, 7738.8188, 563.9016);
	angles[26] = (0, -265.7658, 0);
	at[26] = 20.4167;
	points[27] = (5047.3623, 7710.2363, 563.9016);
	angles[27] = (0, -266.4323, 0);
	at[27] = 24.7333;
	points[28] = (5041.7720, 7731.8110, 563.9016);
	angles[28] = (0, -328.5747, 0);
	at[28] = 24.8500;
	points[29] = (5036.5747, 7756.0630, 563.9016);
	angles[29] = (0, -343.8265, 0);
	at[29] = 24.9667;
	points[30] = (5030.6299, 7783.7793, 563.9016);
	angles[30] = (0, -347.2207, 0);
	at[30] = 25.1000;
	mover = getEnt("iz_obj_2", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_3()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-825.5787, 2306.2993, 770.5945);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-825.5787, 2306.2993, 770.5945);
	angles[1] = (0, 0, 0);
	at[1] = 0.9500;
	points[2] = (-825.5787, 2306.2993, 778.2677);
	angles[2] = (0, 0, 0);
	at[2] = 1;
	points[3] = (-825.5787, 2306.2993, 775.0236);
	angles[3] = (0, 0, 0);
	at[3] = 1.0500;
	points[4] = (-825.5787, 2306.2993, 762.9252);
	angles[4] = (0, 0, 0);
	at[4] = 1.1000;
	points[5] = (-825.5787, 2306.2993, 766.1653);
	angles[5] = (0, 0, 0);
	at[5] = 1.1500;
	points[6] = (-825.5787, 2306.2993, 778.2677);
	angles[6] = (0, 0, 0);
	at[6] = 1.2000;
	points[7] = (-825.5787, 2306.2993, 775.0236);
	angles[7] = (0, 0, 0);
	at[7] = 1.2500;
	points[8] = (-825.5787, 2306.2993, 762.9252);
	angles[8] = (0, 0, 0);
	at[8] = 1.3000;
	points[9] = (-825.5787, 2306.2993, 766.1653);
	angles[9] = (0, 0, 0);
	at[9] = 1.3500;
	points[10] = (-825.5787, 2306.2993, 778.2677);
	angles[10] = (0, 0, 0);
	at[10] = 1.4000;
	points[11] = (-825.5787, 2306.2993, 775.0236);
	angles[11] = (0, 0, 0);
	at[11] = 1.4500;
	points[12] = (-825.5787, 2306.2993, 780.9291);
	angles[12] = (0, 0, 0);
	at[12] = 1.5000;
	points[13] = (-825.5787, 2306.2993, 913.8032);
	angles[13] = (0, 0, 0);
	at[13] = 1.6500;
	points[14] = (-825.5787, 2306.2993, 883.6851);
	angles[14] = (0, 0, 0);
	at[14] = 1.7000;
	points[15] = (-825.5787, 2306.2993, 808.3898);
	angles[15] = (0, 0, 0);
	at[15] = 1.7500;
	points[16] = (-825.5787, 2306.2993, 563.9016);
	angles[16] = (0, 0, 0);
	at[16] = 1.8500;
	points[17] = (-825.5787, 2306.2993, 563.9016);
	angles[17] = (0, 0, 0);
	at[17] = 2.8500;
	points[18] = (-825.5787, 2306.2993, 767.6417);
	angles[18] = (0, 0, 0);
	at[18] = 4;
	points[19] = (-825.5787, 2306.2993, 770.5945);
	angles[19] = (0, 0, 0);
	at[19] = 4.0333;
	mover = getEnt("iz_obj_3", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_4()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-166.7661, 2306.2993, 779.4528);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-166.7661, 2306.2993, 770.5945);
	angles[1] = (0, 0, 0);
	at[1] = 0.0500;
	points[2] = (-166.7661, 2306.2993, 795.6929);
	angles[2] = (0, 0, 0);
	at[2] = 0.1000;
	points[3] = (-166.7661, 2306.2993, 884.2756);
	angles[3] = (0, 0, 0);
	at[3] = 0.2000;
	points[4] = (-166.7661, 2306.2993, 908.7834);
	angles[4] = (0, 0, 0);
	at[4] = 0.2500;
	points[5] = (-166.7661, 2306.2993, 863.6063);
	angles[5] = (0, 0, 0);
	at[5] = 0.3000;
	points[6] = (-166.7661, 2306.2993, 773.2520);
	angles[6] = (0, 0, 0);
	at[6] = 0.3500;
	points[7] = (-166.7661, 2306.2993, 637.7205);
	angles[7] = (0, 0, 0);
	at[7] = 0.4000;
	points[8] = (-166.7661, 2306.2993, 563.9016);
	angles[8] = (0, 0, 0);
	at[8] = 0.4500;
	points[9] = (-166.7661, 2306.2993, 563.9016);
	angles[9] = (0, 0, 0);
	at[9] = 0.6000;
	points[10] = (-166.7661, 2306.2993, 563.9016);
	angles[10] = (0, 0, 0);
	at[10] = 1.4000;
	points[11] = (-166.7661, 2306.2993, 566.8543);
	angles[11] = (0, 0, 0);
	at[11] = 1.4500;
	points[12] = (-166.7661, 2306.2993, 770.5945);
	angles[12] = (0, 0, 0);
	at[12] = 2.6000;
	points[13] = (-166.7661, 2306.2993, 770.5945);
	angles[13] = (0, 0, 0);
	at[13] = 3.5500;
	points[14] = (-166.7661, 2306.2993, 778.2677);
	angles[14] = (0, 0, 0);
	at[14] = 3.6500;
	points[15] = (-166.7661, 2306.2993, 766.1653);
	angles[15] = (0, 0, 0);
	at[15] = 3.7000;
	points[16] = (-166.7661, 2306.2993, 762.9252);
	angles[16] = (0, 0, 0);
	at[16] = 3.7500;
	points[17] = (-166.7661, 2306.2993, 775.0236);
	angles[17] = (0, 0, 0);
	at[17] = 3.8000;
	points[18] = (-166.7661, 2306.2993, 778.2677);
	angles[18] = (0, 0, 0);
	at[18] = 3.8500;
	points[19] = (-166.7661, 2306.2993, 766.1653);
	angles[19] = (0, 0, 0);
	at[19] = 3.9000;
	points[20] = (-166.7661, 2306.2993, 762.9252);
	angles[20] = (0, 0, 0);
	at[20] = 3.9500;
	points[21] = (-166.7661, 2306.2993, 775.0236);
	angles[21] = (0, 0, 0);
	at[21] = 4;
	points[22] = (-166.7661, 2306.2993, 779.4528);
	angles[22] = (0, 0, 0);
	at[22] = 4.0333;
	mover = getEnt("iz_obj_4", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_5()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-7208.1104, 9571.1025, 770.5945);
	angles[0] = (0, -90, 0);
	at[0] = 0;
	points[1] = (-7208.1104, 9571.1025, 770.5945);
	angles[1] = (0, -90, 0);
	at[1] = 0.9500;
	points[2] = (-7208.1104, 9571.1025, 778.2677);
	angles[2] = (0, -90, 0);
	at[2] = 1;
	points[3] = (-7208.1104, 9571.1025, 775.0236);
	angles[3] = (0, -90, 0);
	at[3] = 1.0500;
	points[4] = (-7208.1104, 9571.1025, 762.9252);
	angles[4] = (0, -90, 0);
	at[4] = 1.1000;
	points[5] = (-7208.1104, 9571.1025, 766.1653);
	angles[5] = (0, -90, 0);
	at[5] = 1.1500;
	points[6] = (-7208.1104, 9571.1025, 778.2677);
	angles[6] = (0, -90, 0);
	at[6] = 1.2000;
	points[7] = (-7208.1104, 9571.1025, 775.0236);
	angles[7] = (0, -90, 0);
	at[7] = 1.2500;
	points[8] = (-7208.1104, 9571.1025, 762.9252);
	angles[8] = (0, -90, 0);
	at[8] = 1.3000;
	points[9] = (-7208.1104, 9571.1025, 766.1653);
	angles[9] = (0, -90, 0);
	at[9] = 1.3500;
	points[10] = (-7208.1104, 9571.1025, 778.2677);
	angles[10] = (0, -90, 0);
	at[10] = 1.4000;
	points[11] = (-7208.1104, 9571.1025, 775.0236);
	angles[11] = (0, -90, 0);
	at[11] = 1.4500;
	points[12] = (-7208.1104, 9571.1025, 780.9291);
	angles[12] = (0, -90, 0);
	at[12] = 1.5000;
	points[13] = (-7208.1104, 9571.1025, 913.8032);
	angles[13] = (0, -90, 0);
	at[13] = 1.6500;
	points[14] = (-7208.1104, 9571.1025, 883.6851);
	angles[14] = (0, -90, 0);
	at[14] = 1.7000;
	points[15] = (-7208.1104, 9571.1025, 808.3898);
	angles[15] = (0, -90, 0);
	at[15] = 1.7500;
	points[16] = (-7208.1104, 9571.1025, 563.9016);
	angles[16] = (0, -90, 0);
	at[16] = 1.8500;
	points[17] = (-7208.1104, 9571.1025, 563.9016);
	angles[17] = (0, -90, 0);
	at[17] = 2.8500;
	points[18] = (-7208.1104, 9571.1025, 767.6417);
	angles[18] = (0, -90, 0);
	at[18] = 4;
	points[19] = (-7208.1104, 9571.1025, 770.5945);
	angles[19] = (0, -90, 0);
	at[19] = 4.0333;
	mover = getEnt("iz_obj_5", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_6()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-1640.3779, 5149.7241, 766.1653);
	angles[0] = (0, 90, 0);
	at[0] = 0;
	points[1] = (-1640.3779, 5149.7241, 778.2677);
	angles[1] = (0, 90, 0);
	at[1] = 0.0500;
	points[2] = (-1640.3779, 5149.7241, 775.0236);
	angles[2] = (0, 90, 0);
	at[2] = 0.1000;
	points[3] = (-1640.3779, 5149.7241, 762.9252);
	angles[3] = (0, 90, 0);
	at[3] = 0.1500;
	points[4] = (-1640.3779, 5149.7241, 766.1653);
	angles[4] = (0, 90, 0);
	at[4] = 0.2000;
	points[5] = (-1640.3779, 5149.7241, 778.2677);
	angles[5] = (0, 90, 0);
	at[5] = 0.2500;
	points[6] = (-1640.3779, 5149.7241, 775.0236);
	angles[6] = (0, 90, 0);
	at[6] = 0.3000;
	points[7] = (-1640.3779, 5149.7241, 780.9291);
	angles[7] = (0, 90, 0);
	at[7] = 0.3500;
	points[8] = (-1640.3779, 5149.7241, 913.8032);
	angles[8] = (0, 90, 0);
	at[8] = 0.5000;
	points[9] = (-1640.3779, 5149.7241, 883.6851);
	angles[9] = (0, 90, 0);
	at[9] = 0.5500;
	points[10] = (-1640.3779, 5149.7241, 808.3898);
	angles[10] = (0, 90, 0);
	at[10] = 0.6000;
	points[11] = (-1640.3779, 5149.7241, 563.9016);
	angles[11] = (0, 90, 0);
	at[11] = 0.7000;
	points[12] = (-1640.3779, 5149.7241, 563.9016);
	angles[12] = (0, 90, 0);
	at[12] = 1.7000;
	points[13] = (-1640.3779, 5149.7241, 767.6417);
	angles[13] = (0, 90, 0);
	at[13] = 2.8500;
	points[14] = (-1640.3779, 5149.7241, 770.5945);
	angles[14] = (0, 90, 0);
	at[14] = 2.9000;
	points[15] = (-1640.3779, 5149.7241, 770.5945);
	angles[15] = (0, 90, 0);
	at[15] = 3.8500;
	points[16] = (-1640.3779, 5149.7241, 779.4528);
	angles[16] = (0, 90, 0);
	at[16] = 3.9000;
	points[17] = (-1640.3779, 5149.7241, 761.7363);
	angles[17] = (0, 90, 0);
	at[17] = 4;
	points[18] = (-1640.3779, 5149.7241, 766.1653);
	angles[18] = (0, 90, 0);
	at[18] = 4.0333;
	mover = getEnt("iz_obj_6", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_7()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-7208.1104, 10307.7949, 779.4528);
	angles[0] = (0, -90, 0);
	at[0] = 0;
	points[1] = (-7208.1104, 10307.7949, 770.5945);
	angles[1] = (0, -90, 0);
	at[1] = 0.0500;
	points[2] = (-7208.1104, 10307.7949, 795.6929);
	angles[2] = (0, -90, 0);
	at[2] = 0.1000;
	points[3] = (-7208.1104, 10307.7949, 884.2756);
	angles[3] = (0, -90, 0);
	at[3] = 0.2000;
	points[4] = (-7208.1104, 10307.7949, 908.7834);
	angles[4] = (0, -90, 0);
	at[4] = 0.2500;
	points[5] = (-7208.1104, 10307.7949, 863.6063);
	angles[5] = (0, -90, 0);
	at[5] = 0.3000;
	points[6] = (-7208.1104, 10307.7949, 773.2520);
	angles[6] = (0, -90, 0);
	at[6] = 0.3500;
	points[7] = (-7208.1104, 10307.7949, 637.7205);
	angles[7] = (0, -90, 0);
	at[7] = 0.4000;
	points[8] = (-7208.1104, 10307.7949, 563.9016);
	angles[8] = (0, -90, 0);
	at[8] = 0.4500;
	points[9] = (-7208.1104, 10307.7949, 563.9016);
	angles[9] = (0, -90, 0);
	at[9] = 0.6000;
	points[10] = (-7208.1104, 10307.7949, 563.9016);
	angles[10] = (0, -90, 0);
	at[10] = 1.4000;
	points[11] = (-7208.1104, 10307.7949, 566.8543);
	angles[11] = (0, -90, 0);
	at[11] = 1.4500;
	points[12] = (-7208.1104, 10307.7949, 770.5945);
	angles[12] = (0, -90, 0);
	at[12] = 2.6000;
	points[13] = (-7208.1104, 10307.7949, 770.5945);
	angles[13] = (0, -90, 0);
	at[13] = 3.5500;
	points[14] = (-7208.1104, 10307.7949, 778.2677);
	angles[14] = (0, -90, 0);
	at[14] = 3.6500;
	points[15] = (-7208.1104, 10307.7949, 766.1653);
	angles[15] = (0, -90, 0);
	at[15] = 3.7000;
	points[16] = (-7208.1104, 10307.7949, 762.9252);
	angles[16] = (0, -90, 0);
	at[16] = 3.7500;
	points[17] = (-7208.1104, 10307.7949, 775.0236);
	angles[17] = (0, -90, 0);
	at[17] = 3.8000;
	points[18] = (-7208.1104, 10307.7949, 778.2677);
	angles[18] = (0, -90, 0);
	at[18] = 3.8500;
	points[19] = (-7208.1104, 10307.7949, 766.1653);
	angles[19] = (0, -90, 0);
	at[19] = 3.9000;
	points[20] = (-7208.1104, 10307.7949, 762.9252);
	angles[20] = (0, -90, 0);
	at[20] = 3.9500;
	points[21] = (-7208.1104, 10307.7949, 775.0236);
	angles[21] = (0, -90, 0);
	at[21] = 4;
	points[22] = (-7208.1104, 10307.7949, 779.4528);
	angles[22] = (0, -90, 0);
	at[22] = 4.0333;
	mover = getEnt("iz_obj_7", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_8()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (2650.8977, -7220.3936, 119.8327);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (2650.8977, -7220.3936, 31.2497);
	angles[1] = (0, 0, 0);
	at[1] = 1;
	points[2] = (2650.8977, -7220.3936, 32.2345);
	angles[2] = (0, 0, 0);
	at[2] = 1.0500;
	points[3] = (2650.8977, -7220.3936, 272.5850);
	angles[3] = (0, 0, 0);
	at[3] = 3.7500;
	points[4] = (2650.8977, -7220.3936, 292.6276);
	angles[4] = (0, 0, 0);
	at[4] = 3.8500;
	points[5] = (2650.8977, -7220.3936, 309.9228);
	angles[5] = (0, 0, 0);
	at[5] = 3.9000;
	points[6] = (2650.8977, -7220.3936, 335.0992);
	angles[6] = (0, 0, 0);
	at[6] = 3.9500;
	points[7] = (2650.8977, -7220.3936, 446.0591);
	angles[7] = (0, 0, 0);
	at[7] = 4.1000;
	points[8] = (2650.8977, -7220.3936, 512.1968);
	angles[8] = (0, 0, 0);
	at[8] = 4.2000;
	points[9] = (2650.8977, -7220.3936, 569.0157);
	angles[9] = (0, 0, 0);
	at[9] = 4.3000;
	points[10] = (2650.8977, -7220.3936, 593.1457);
	angles[10] = (0, 0, 0);
	at[10] = 4.3500;
	points[11] = (2650.8977, -7220.3936, 631.5669);
	angles[11] = (0, 0, 0);
	at[11] = 4.4500;
	points[12] = (2650.8977, -7220.3936, 646.7756);
	angles[12] = (0, 0, 0);
	at[12] = 4.5000;
	points[13] = (2650.8977, -7220.3936, 670.9921);
	angles[13] = (0, 0, 0);
	at[13] = 4.6000;
	points[14] = (2650.8977, -7220.3936, 696.7756);
	angles[14] = (0, 0, 0);
	at[14] = 4.7500;
	points[15] = (2650.8977, -7220.3936, 721.5079);
	angles[15] = (0, 0, 0);
	at[15] = 4.9500;
	points[16] = (2650.8977, -7220.3936, 738.6693);
	angles[16] = (0, 0, 0);
	at[16] = 5.1500;
	points[17] = (2650.8977, -7220.3936, 716.4803);
	angles[17] = (0, 0, 0);
	at[17] = 5.4000;
	points[18] = (2650.8977, -7220.3936, 693.1299);
	angles[18] = (0, 0, 0);
	at[18] = 5.6000;
	points[19] = (2650.8977, -7220.3936, 662.0945);
	angles[19] = (0, 0, 0);
	at[19] = 5.8000;
	points[20] = (2650.8977, -7220.3936, 629.8819);
	angles[20] = (0, 0, 0);
	at[20] = 5.9500;
	points[21] = (2650.8977, -7220.3936, 584.0472);
	angles[21] = (0, 0, 0);
	at[21] = 6.1000;
	points[22] = (2650.8977, -7220.3936, 506.1339);
	angles[22] = (0, 0, 0);
	at[22] = 6.3000;
	points[23] = (2650.8977, -7220.3936, 438.3504);
	angles[23] = (0, 0, 0);
	at[23] = 6.4500;
	points[24] = (2650.8977, -7220.3936, 388.1051);
	angles[24] = (0, 0, 0);
	at[24] = 6.5500;
	points[25] = (2650.8977, -7220.3936, 358.7945);
	angles[25] = (0, 0, 0);
	at[25] = 6.6000;
	points[26] = (2650.8977, -7220.3936, 383.4666);
	angles[26] = (0, 0, 0);
	at[26] = 6.6500;
	points[27] = (2650.8977, -7220.3936, 401.6693);
	angles[27] = (0, 0, 0);
	at[27] = 6.7000;
	points[28] = (2650.8977, -7220.3936, 410.9882);
	angles[28] = (0, 0, 0);
	at[28] = 6.7500;
	points[29] = (2650.8977, -7220.3936, 410.6811);
	angles[29] = (0, 0, 0);
	at[29] = 6.8000;
	points[30] = (2650.8977, -7220.3936, 119.8327);
	angles[30] = (0, 0, 0);
	at[30] = 10.0833;
	mover = getEnt("iz_obj_8", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_9()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (3196.5471, -5534.7637, 119.8327);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (3196.5471, -5534.7637, 31.2497);
	angles[1] = (0, 0, 0);
	at[1] = 1;
	points[2] = (3196.5471, -5534.7637, 32.2345);
	angles[2] = (0, 0, 0);
	at[2] = 1.0500;
	points[3] = (3196.5471, -5534.7637, 272.5850);
	angles[3] = (0, 0, 0);
	at[3] = 3.7500;
	points[4] = (3196.5471, -5534.7637, 292.6276);
	angles[4] = (0, 0, 0);
	at[4] = 3.8500;
	points[5] = (3196.5471, -5534.7637, 309.9228);
	angles[5] = (0, 0, 0);
	at[5] = 3.9000;
	points[6] = (3196.5471, -5534.7637, 335.0992);
	angles[6] = (0, 0, 0);
	at[6] = 3.9500;
	points[7] = (3196.5471, -5534.7637, 446.0591);
	angles[7] = (0, 0, 0);
	at[7] = 4.1000;
	points[8] = (3196.5471, -5534.7637, 512.1968);
	angles[8] = (0, 0, 0);
	at[8] = 4.2000;
	points[9] = (3196.5471, -5534.7637, 569.0157);
	angles[9] = (0, 0, 0);
	at[9] = 4.3000;
	points[10] = (3196.5471, -5534.7637, 593.1457);
	angles[10] = (0, 0, 0);
	at[10] = 4.3500;
	points[11] = (3196.5471, -5534.7637, 631.5669);
	angles[11] = (0, 0, 0);
	at[11] = 4.4500;
	points[12] = (3196.5471, -5534.7637, 646.7756);
	angles[12] = (0, 0, 0);
	at[12] = 4.5000;
	points[13] = (3196.5471, -5534.7637, 670.9921);
	angles[13] = (0, 0, 0);
	at[13] = 4.6000;
	points[14] = (3196.5471, -5534.7637, 696.7756);
	angles[14] = (0, 0, 0);
	at[14] = 4.7500;
	points[15] = (3196.5471, -5534.7637, 721.5079);
	angles[15] = (0, 0, 0);
	at[15] = 4.9500;
	points[16] = (3196.5471, -5534.7637, 738.6693);
	angles[16] = (0, 0, 0);
	at[16] = 5.1500;
	points[17] = (3196.5471, -5534.7637, 716.4803);
	angles[17] = (0, 0, 0);
	at[17] = 5.4000;
	points[18] = (3196.5471, -5534.7637, 693.1299);
	angles[18] = (0, 0, 0);
	at[18] = 5.6000;
	points[19] = (3196.5471, -5534.7637, 662.0945);
	angles[19] = (0, 0, 0);
	at[19] = 5.8000;
	points[20] = (3196.5471, -5534.7637, 629.8819);
	angles[20] = (0, 0, 0);
	at[20] = 5.9500;
	points[21] = (3196.5471, -5534.7637, 584.0472);
	angles[21] = (0, 0, 0);
	at[21] = 6.1000;
	points[22] = (3196.5471, -5534.7637, 506.1339);
	angles[22] = (0, 0, 0);
	at[22] = 6.3000;
	points[23] = (3196.5471, -5534.7637, 438.3504);
	angles[23] = (0, 0, 0);
	at[23] = 6.4500;
	points[24] = (3196.5471, -5534.7637, 388.1051);
	angles[24] = (0, 0, 0);
	at[24] = 6.5500;
	points[25] = (3196.5471, -5534.7637, 358.7945);
	angles[25] = (0, 0, 0);
	at[25] = 6.6000;
	points[26] = (3196.5471, -5534.7637, 383.4666);
	angles[26] = (0, 0, 0);
	at[26] = 6.6500;
	points[27] = (3196.5471, -5534.7637, 401.6693);
	angles[27] = (0, 0, 0);
	at[27] = 6.7000;
	points[28] = (3196.5471, -5534.7637, 410.9882);
	angles[28] = (0, 0, 0);
	at[28] = 6.7500;
	points[29] = (3196.5471, -5534.7637, 410.6811);
	angles[29] = (0, 0, 0);
	at[29] = 6.8000;
	points[30] = (3196.5471, -5534.7637, 119.8327);
	angles[30] = (0, 0, 0);
	at[30] = 10.0833;
	mover = getEnt("iz_obj_9", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_10()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (2378.8938, -5530.9844, 119.8327);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (2378.8938, -5530.9844, 31.2497);
	angles[1] = (0, 0, 0);
	at[1] = 1;
	points[2] = (2378.8938, -5530.9844, 32.2345);
	angles[2] = (0, 0, 0);
	at[2] = 1.0500;
	points[3] = (2378.8938, -5530.9844, 272.5850);
	angles[3] = (0, 0, 0);
	at[3] = 3.7500;
	points[4] = (2378.8938, -5530.9844, 292.6276);
	angles[4] = (0, 0, 0);
	at[4] = 3.8500;
	points[5] = (2378.8938, -5530.9844, 309.9228);
	angles[5] = (0, 0, 0);
	at[5] = 3.9000;
	points[6] = (2378.8938, -5530.9844, 335.0992);
	angles[6] = (0, 0, 0);
	at[6] = 3.9500;
	points[7] = (2378.8938, -5530.9844, 446.0591);
	angles[7] = (0, 0, 0);
	at[7] = 4.1000;
	points[8] = (2378.8938, -5530.9844, 512.1968);
	angles[8] = (0, 0, 0);
	at[8] = 4.2000;
	points[9] = (2378.8938, -5530.9844, 569.0157);
	angles[9] = (0, 0, 0);
	at[9] = 4.3000;
	points[10] = (2378.8938, -5530.9844, 593.1457);
	angles[10] = (0, 0, 0);
	at[10] = 4.3500;
	points[11] = (2378.8938, -5530.9844, 631.5669);
	angles[11] = (0, 0, 0);
	at[11] = 4.4500;
	points[12] = (2378.8938, -5530.9844, 646.7756);
	angles[12] = (0, 0, 0);
	at[12] = 4.5000;
	points[13] = (2378.8938, -5530.9844, 670.9921);
	angles[13] = (0, 0, 0);
	at[13] = 4.6000;
	points[14] = (2378.8938, -5530.9844, 696.7756);
	angles[14] = (0, 0, 0);
	at[14] = 4.7500;
	points[15] = (2378.8938, -5530.9844, 721.5079);
	angles[15] = (0, 0, 0);
	at[15] = 4.9500;
	points[16] = (2378.8938, -5530.9844, 738.6693);
	angles[16] = (0, 0, 0);
	at[16] = 5.1500;
	points[17] = (2378.8938, -5530.9844, 716.4803);
	angles[17] = (0, 0, 0);
	at[17] = 5.4000;
	points[18] = (2378.8938, -5530.9844, 693.1299);
	angles[18] = (0, 0, 0);
	at[18] = 5.6000;
	points[19] = (2378.8938, -5530.9844, 662.0945);
	angles[19] = (0, 0, 0);
	at[19] = 5.8000;
	points[20] = (2378.8938, -5530.9844, 629.8819);
	angles[20] = (0, 0, 0);
	at[20] = 5.9500;
	points[21] = (2378.8938, -5530.9844, 584.0472);
	angles[21] = (0, 0, 0);
	at[21] = 6.1000;
	points[22] = (2378.8938, -5530.9844, 506.1339);
	angles[22] = (0, 0, 0);
	at[22] = 6.3000;
	points[23] = (2378.8938, -5530.9844, 438.3504);
	angles[23] = (0, 0, 0);
	at[23] = 6.4500;
	points[24] = (2378.8938, -5530.9844, 388.1051);
	angles[24] = (0, 0, 0);
	at[24] = 6.5500;
	points[25] = (2378.8938, -5530.9844, 358.7945);
	angles[25] = (0, 0, 0);
	at[25] = 6.6000;
	points[26] = (2378.8938, -5530.9844, 383.4666);
	angles[26] = (0, 0, 0);
	at[26] = 6.6500;
	points[27] = (2378.8938, -5530.9844, 401.6693);
	angles[27] = (0, 0, 0);
	at[27] = 6.7000;
	points[28] = (2378.8938, -5530.9844, 410.9882);
	angles[28] = (0, 0, 0);
	at[28] = 6.7500;
	points[29] = (2378.8938, -5530.9844, 410.6811);
	angles[29] = (0, 0, 0);
	at[29] = 6.8000;
	points[30] = (2378.8938, -5530.9844, 119.8327);
	angles[30] = (0, 0, 0);
	at[30] = 10.0833;
	mover = getEnt("iz_obj_10", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_11()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (3459, -4039.8818, 119.8327);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (3459, -4039.8818, 31.2497);
	angles[1] = (0, 0, 0);
	at[1] = 1;
	points[2] = (3459, -4039.8818, 32.2345);
	angles[2] = (0, 0, 0);
	at[2] = 1.0500;
	points[3] = (3459, -4039.8818, 272.5850);
	angles[3] = (0, 0, 0);
	at[3] = 3.7500;
	points[4] = (3459, -4039.8818, 292.6276);
	angles[4] = (0, 0, 0);
	at[4] = 3.8500;
	points[5] = (3459, -4039.8818, 309.9228);
	angles[5] = (0, 0, 0);
	at[5] = 3.9000;
	points[6] = (3459, -4039.8818, 335.0992);
	angles[6] = (0, 0, 0);
	at[6] = 3.9500;
	points[7] = (3459, -4039.8818, 446.0591);
	angles[7] = (0, 0, 0);
	at[7] = 4.1000;
	points[8] = (3459, -4039.8818, 512.1968);
	angles[8] = (0, 0, 0);
	at[8] = 4.2000;
	points[9] = (3459, -4039.8818, 569.0157);
	angles[9] = (0, 0, 0);
	at[9] = 4.3000;
	points[10] = (3459, -4039.8818, 593.1457);
	angles[10] = (0, 0, 0);
	at[10] = 4.3500;
	points[11] = (3459, -4039.8818, 631.5669);
	angles[11] = (0, 0, 0);
	at[11] = 4.4500;
	points[12] = (3459, -4039.8818, 646.7756);
	angles[12] = (0, 0, 0);
	at[12] = 4.5000;
	points[13] = (3459, -4039.8818, 670.9921);
	angles[13] = (0, 0, 0);
	at[13] = 4.6000;
	points[14] = (3459, -4039.8818, 696.7756);
	angles[14] = (0, 0, 0);
	at[14] = 4.7500;
	points[15] = (3459, -4039.8818, 721.5079);
	angles[15] = (0, 0, 0);
	at[15] = 4.9500;
	points[16] = (3459, -4039.8818, 738.6693);
	angles[16] = (0, 0, 0);
	at[16] = 5.1500;
	points[17] = (3459, -4039.8818, 716.4803);
	angles[17] = (0, 0, 0);
	at[17] = 5.4000;
	points[18] = (3459, -4039.8818, 693.1299);
	angles[18] = (0, 0, 0);
	at[18] = 5.6000;
	points[19] = (3459, -4039.8818, 662.0945);
	angles[19] = (0, 0, 0);
	at[19] = 5.8000;
	points[20] = (3459, -4039.8818, 629.8819);
	angles[20] = (0, 0, 0);
	at[20] = 5.9500;
	points[21] = (3459, -4039.8818, 584.0472);
	angles[21] = (0, 0, 0);
	at[21] = 6.1000;
	points[22] = (3459, -4039.8818, 506.1339);
	angles[22] = (0, 0, 0);
	at[22] = 6.3000;
	points[23] = (3459, -4039.8818, 438.3504);
	angles[23] = (0, 0, 0);
	at[23] = 6.4500;
	points[24] = (3459, -4039.8818, 388.1051);
	angles[24] = (0, 0, 0);
	at[24] = 6.5500;
	points[25] = (3459, -4039.8818, 358.7945);
	angles[25] = (0, 0, 0);
	at[25] = 6.6000;
	points[26] = (3459, -4039.8818, 383.4666);
	angles[26] = (0, 0, 0);
	at[26] = 6.6500;
	points[27] = (3459, -4039.8818, 401.6693);
	angles[27] = (0, 0, 0);
	at[27] = 6.7000;
	points[28] = (3459, -4039.8818, 410.9882);
	angles[28] = (0, 0, 0);
	at[28] = 6.7500;
	points[29] = (3459, -4039.8818, 410.6811);
	angles[29] = (0, 0, 0);
	at[29] = 6.8000;
	points[30] = (3459, -4039.8818, 119.8327);
	angles[30] = (0, 0, 0);
	at[30] = 10.0833;
	mover = getEnt("iz_obj_11", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_12()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (2134.5393, -3584.8936, 119.8327);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (2134.5393, -3584.8936, 31.2497);
	angles[1] = (0, 0, 0);
	at[1] = 1;
	points[2] = (2134.5393, -3584.8936, 32.2345);
	angles[2] = (0, 0, 0);
	at[2] = 1.0500;
	points[3] = (2134.5393, -3584.8936, 272.5850);
	angles[3] = (0, 0, 0);
	at[3] = 3.7500;
	points[4] = (2134.5393, -3584.8936, 292.6276);
	angles[4] = (0, 0, 0);
	at[4] = 3.8500;
	points[5] = (2134.5393, -3584.8936, 309.9228);
	angles[5] = (0, 0, 0);
	at[5] = 3.9000;
	points[6] = (2134.5393, -3584.8936, 335.0992);
	angles[6] = (0, 0, 0);
	at[6] = 3.9500;
	points[7] = (2134.5393, -3584.8936, 446.0591);
	angles[7] = (0, 0, 0);
	at[7] = 4.1000;
	points[8] = (2134.5393, -3584.8936, 512.1968);
	angles[8] = (0, 0, 0);
	at[8] = 4.2000;
	points[9] = (2134.5393, -3584.8936, 569.0157);
	angles[9] = (0, 0, 0);
	at[9] = 4.3000;
	points[10] = (2134.5393, -3584.8936, 593.1457);
	angles[10] = (0, 0, 0);
	at[10] = 4.3500;
	points[11] = (2134.5393, -3584.8936, 631.5669);
	angles[11] = (0, 0, 0);
	at[11] = 4.4500;
	points[12] = (2134.5393, -3584.8936, 646.7756);
	angles[12] = (0, 0, 0);
	at[12] = 4.5000;
	points[13] = (2134.5393, -3584.8936, 670.9921);
	angles[13] = (0, 0, 0);
	at[13] = 4.6000;
	points[14] = (2134.5393, -3584.8936, 696.7756);
	angles[14] = (0, 0, 0);
	at[14] = 4.7500;
	points[15] = (2134.5393, -3584.8936, 721.5079);
	angles[15] = (0, 0, 0);
	at[15] = 4.9500;
	points[16] = (2134.5393, -3584.8936, 738.6693);
	angles[16] = (0, 0, 0);
	at[16] = 5.1500;
	points[17] = (2134.5393, -3584.8936, 716.4803);
	angles[17] = (0, 0, 0);
	at[17] = 5.4000;
	points[18] = (2134.5393, -3584.8936, 693.1299);
	angles[18] = (0, 0, 0);
	at[18] = 5.6000;
	points[19] = (2134.5393, -3584.8936, 662.0945);
	angles[19] = (0, 0, 0);
	at[19] = 5.8000;
	points[20] = (2134.5393, -3584.8936, 629.8819);
	angles[20] = (0, 0, 0);
	at[20] = 5.9500;
	points[21] = (2134.5393, -3584.8936, 584.0472);
	angles[21] = (0, 0, 0);
	at[21] = 6.1000;
	points[22] = (2134.5393, -3584.8936, 506.1339);
	angles[22] = (0, 0, 0);
	at[22] = 6.3000;
	points[23] = (2134.5393, -3584.8936, 438.3504);
	angles[23] = (0, 0, 0);
	at[23] = 6.4500;
	points[24] = (2134.5393, -3584.8936, 388.1051);
	angles[24] = (0, 0, 0);
	at[24] = 6.5500;
	points[25] = (2134.5393, -3584.8936, 358.7945);
	angles[25] = (0, 0, 0);
	at[25] = 6.6000;
	points[26] = (2134.5393, -3584.8936, 383.4666);
	angles[26] = (0, 0, 0);
	at[26] = 6.6500;
	points[27] = (2134.5393, -3584.8936, 401.6693);
	angles[27] = (0, 0, 0);
	at[27] = 6.7000;
	points[28] = (2134.5393, -3584.8936, 410.9882);
	angles[28] = (0, 0, 0);
	at[28] = 6.7500;
	points[29] = (2134.5393, -3584.8936, 410.6811);
	angles[29] = (0, 0, 0);
	at[29] = 6.8000;
	points[30] = (2134.5393, -3584.8936, 119.8327);
	angles[30] = (0, 0, 0);
	at[30] = 10.0833;
	mover = getEnt("iz_obj_12", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_13()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (3692.3464, -2782.4646, 119.8327);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (3692.3464, -2782.4646, 31.2497);
	angles[1] = (0, 0, 0);
	at[1] = 1;
	points[2] = (3692.3425, -2782.4646, 32.2345);
	angles[2] = (0, 0, 0);
	at[2] = 1.0500;
	points[3] = (3692.3464, -2782.4646, 272.5850);
	angles[3] = (0, 0, 0);
	at[3] = 3.7500;
	points[4] = (3692.3464, -2782.4646, 292.6276);
	angles[4] = (0, 0, 0);
	at[4] = 3.8500;
	points[5] = (3692.3464, -2782.4646, 309.9228);
	angles[5] = (0, 0, 0);
	at[5] = 3.9000;
	points[6] = (3692.3464, -2782.4646, 335.0992);
	angles[6] = (0, 0, 0);
	at[6] = 3.9500;
	points[7] = (3692.3464, -2782.4646, 446.0591);
	angles[7] = (0, 0, 0);
	at[7] = 4.1000;
	points[8] = (3692.3464, -2782.4646, 512.1968);
	angles[8] = (0, 0, 0);
	at[8] = 4.2000;
	points[9] = (3692.3464, -2782.4646, 569.0157);
	angles[9] = (0, 0, 0);
	at[9] = 4.3000;
	points[10] = (3692.3464, -2782.4646, 593.1457);
	angles[10] = (0, 0, 0);
	at[10] = 4.3500;
	points[11] = (3692.3464, -2782.4646, 631.5669);
	angles[11] = (0, 0, 0);
	at[11] = 4.4500;
	points[12] = (3692.3464, -2782.4646, 646.7756);
	angles[12] = (0, 0, 0);
	at[12] = 4.5000;
	points[13] = (3692.3464, -2782.4646, 670.9921);
	angles[13] = (0, 0, 0);
	at[13] = 4.6000;
	points[14] = (3692.3464, -2782.4646, 696.7756);
	angles[14] = (0, 0, 0);
	at[14] = 4.7500;
	points[15] = (3692.3464, -2782.4646, 721.5079);
	angles[15] = (0, 0, 0);
	at[15] = 4.9500;
	points[16] = (3692.3464, -2782.4646, 738.6693);
	angles[16] = (0, 0, 0);
	at[16] = 5.1500;
	points[17] = (3692.3464, -2782.4646, 716.4803);
	angles[17] = (0, 0, 0);
	at[17] = 5.4000;
	points[18] = (3692.3464, -2782.4646, 693.1299);
	angles[18] = (0, 0, 0);
	at[18] = 5.6000;
	points[19] = (3692.3464, -2782.4646, 662.0945);
	angles[19] = (0, 0, 0);
	at[19] = 5.8000;
	points[20] = (3692.3464, -2782.4646, 629.8819);
	angles[20] = (0, 0, 0);
	at[20] = 5.9500;
	points[21] = (3692.3464, -2782.4646, 584.0472);
	angles[21] = (0, 0, 0);
	at[21] = 6.1000;
	points[22] = (3692.3464, -2782.4646, 506.1339);
	angles[22] = (0, 0, 0);
	at[22] = 6.3000;
	points[23] = (3692.3464, -2782.4646, 438.3504);
	angles[23] = (0, 0, 0);
	at[23] = 6.4500;
	points[24] = (3692.3464, -2782.4646, 388.1051);
	angles[24] = (0, 0, 0);
	at[24] = 6.5500;
	points[25] = (3692.3464, -2782.4646, 358.7945);
	angles[25] = (0, 0, 0);
	at[25] = 6.6000;
	points[26] = (3692.3464, -2782.4646, 383.4666);
	angles[26] = (0, 0, 0);
	at[26] = 6.6500;
	points[27] = (3692.3464, -2782.4646, 401.6693);
	angles[27] = (0, 0, 0);
	at[27] = 6.7000;
	points[28] = (3692.3464, -2782.4646, 410.9882);
	angles[28] = (0, 0, 0);
	at[28] = 6.7500;
	points[29] = (3692.3464, -2782.4646, 410.6811);
	angles[29] = (0, 0, 0);
	at[29] = 6.8000;
	points[30] = (3692.3464, -2782.4646, 119.8327);
	angles[30] = (0, 0, 0);
	at[30] = 10.0833;
	mover = getEnt("iz_obj_13", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_14()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-3556.2954, -8150.1968, -130.9398);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-3556.2954, -8150.1968, -130.9398);
	angles[1] = (0, 0, 0);
	at[1] = 0.8500;
	points[2] = (-3556.2954, -8150.1968, -87.6622);
	angles[2] = (0, 0, 0);
	at[2] = 0.9000;
	points[3] = (-3556.2954, -8150.1968, 16.2746);
	angles[3] = (0, 0, 0);
	at[3] = 1;
	points[4] = (-3556.2954, -8150.1968, 63.9913);
	angles[4] = (0, 0, 0);
	at[4] = 1.0500;
	points[5] = (-3556.2954, -8150.1968, 150.9201);
	angles[5] = (0, 0, 0);
	at[5] = 1.1500;
	points[6] = (-3556.2954, -8150.1968, 226.5110);
	angles[6] = (0, 0, 0);
	at[6] = 1.2500;
	points[7] = (-3556.2954, -8150.1968, 260.0540);
	angles[7] = (0, 0, 0);
	at[7] = 1.3000;
	points[8] = (-3556.2954, -8150.1968, 318.6370);
	angles[8] = (0, 0, 0);
	at[8] = 1.4000;
	points[9] = (-3556.2954, -8150.1968, 365.8807);
	angles[9] = (0, 0, 0);
	at[9] = 1.5000;
	points[10] = (-3556.2954, -8150.1968, 401.7874);
	angles[10] = (0, 0, 0);
	at[10] = 1.6000;
	points[11] = (-3556.2954, -8150.1968, 415.4882);
	angles[11] = (0, 0, 0);
	at[11] = 1.6500;
	points[12] = (-3556.2954, -8150.1968, 434.3858);
	angles[12] = (0, 0, 0);
	at[12] = 1.7500;
	points[13] = (-3556.2954, -8150.1968, 445.1693);
	angles[13] = (0, 0, 0);
	at[13] = 1.9000;
	points[14] = (-3556.2954, -8150.1968, 453.0748);
	angles[14] = (0, 0, 0);
	at[14] = 1.9500;
	points[15] = (-3556.2954, -8150.1968, 456.7834);
	angles[15] = (0, 0, 0);
	at[15] = 2;
	points[16] = (-3556.2954, -8150.1968, 454.8858);
	angles[16] = (0, 0, 0);
	at[16] = 2.0500;
	points[17] = (-3556.2954, -8150.1968, 448.5866);
	angles[17] = (0, 0, 0);
	at[17] = 2.1000;
	points[18] = (-3556.2954, -8150.1968, -127.7902);
	angles[18] = (0, 0, 0);
	at[18] = 5.1500;
	points[19] = (-3556.2954, -8150.1968, -130.9398);
	angles[19] = (0, 0, 0);
	at[19] = 5.2000;
	points[20] = (-3556.2954, -8150.1968, -130.9398);
	angles[20] = (0, 0, 0);
	at[20] = 8.5167;
	mover = getEnt("iz_obj_14", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_15()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-2495.6104, -7961.7720, 180.8713);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2495.6104, -7961.7720, -130.9398);
	angles[1] = (0, 0, 0);
	at[1] = 1.6500;
	points[2] = (-2495.6104, -7961.7720, -130.9398);
	angles[2] = (0, 0, 0);
	at[2] = 5.8500;
	points[3] = (-2495.6104, -7961.7720, -87.6622);
	angles[3] = (0, 0, 0);
	at[3] = 5.9000;
	points[4] = (-2495.6104, -7961.7720, 16.2746);
	angles[4] = (0, 0, 0);
	at[4] = 6;
	points[5] = (-2495.6104, -7961.7720, 63.9913);
	angles[5] = (0, 0, 0);
	at[5] = 6.0500;
	points[6] = (-2495.6104, -7961.7720, 150.9201);
	angles[6] = (0, 0, 0);
	at[6] = 6.1500;
	points[7] = (-2495.6104, -7961.7720, 226.5110);
	angles[7] = (0, 0, 0);
	at[7] = 6.2500;
	points[8] = (-2495.6104, -7961.7720, 260.0540);
	angles[8] = (0, 0, 0);
	at[8] = 6.3000;
	points[9] = (-2495.6104, -7961.7720, 318.6370);
	angles[9] = (0, 0, 0);
	at[9] = 6.4000;
	points[10] = (-2495.6104, -7961.7720, 365.8807);
	angles[10] = (0, 0, 0);
	at[10] = 6.5000;
	points[11] = (-2495.6104, -7961.7720, 401.7874);
	angles[11] = (0, 0, 0);
	at[11] = 6.6000;
	points[12] = (-2495.6104, -7961.7720, 415.4882);
	angles[12] = (0, 0, 0);
	at[12] = 6.6500;
	points[13] = (-2495.6104, -7961.7720, 434.3858);
	angles[13] = (0, 0, 0);
	at[13] = 6.7500;
	points[14] = (-2495.6104, -7961.7720, 445.1693);
	angles[14] = (0, 0, 0);
	at[14] = 6.9000;
	points[15] = (-2495.6104, -7961.7720, 453.0748);
	angles[15] = (0, 0, 0);
	at[15] = 6.9500;
	points[16] = (-2495.6104, -7961.7720, 456.7834);
	angles[16] = (0, 0, 0);
	at[16] = 7;
	points[17] = (-2495.6104, -7961.7720, 454.8858);
	angles[17] = (0, 0, 0);
	at[17] = 7.0500;
	points[18] = (-2495.6104, -7961.7720, 448.5866);
	angles[18] = (0, 0, 0);
	at[18] = 7.1000;
	points[19] = (-2495.6104, -7961.7720, 180.8713);
	angles[19] = (0, 0, 0);
	at[19] = 8.5167;
	mover = getEnt("iz_obj_15", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_16()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-3206.0435, -6985.1182, 441.9449);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-3206.0435, -6985.1182, 456.7834);
	angles[1] = (0, 0, 0);
	at[1] = 0.1500;
	points[2] = (-3206.0435, -6985.1182, 454.8858);
	angles[2] = (0, 0, 0);
	at[2] = 0.2000;
	points[3] = (-3206.0435, -6985.1182, 448.5866);
	angles[3] = (0, 0, 0);
	at[3] = 0.2500;
	points[4] = (-3206.0435, -6985.1182, -127.7902);
	angles[4] = (0, 0, 0);
	at[4] = 3.3000;
	points[5] = (-3206.0435, -6985.1182, -130.9398);
	angles[5] = (0, 0, 0);
	at[5] = 3.3500;
	points[6] = (-3206.0435, -6985.1182, -130.9398);
	angles[6] = (0, 0, 0);
	at[6] = 7.5000;
	points[7] = (-3206.0435, -6985.1182, -106.0874);
	angles[7] = (0, 0, 0);
	at[7] = 7.5500;
	points[8] = (-3206.0435, -6985.1182, -0.2608);
	angles[8] = (0, 0, 0);
	at[8] = 7.6500;
	points[9] = (-3206.0435, -6985.1182, 48.4008);
	angles[9] = (0, 0, 0);
	at[9] = 7.7000;
	points[10] = (-3206.0435, -6985.1182, 94.2276);
	angles[10] = (0, 0, 0);
	at[10] = 7.7500;
	points[11] = (-3206.0435, -6985.1182, 177.3768);
	angles[11] = (0, 0, 0);
	at[11] = 7.8500;
	points[12] = (-3206.0435, -6985.1182, 249.1878);
	angles[12] = (0, 0, 0);
	at[12] = 7.9500;
	points[13] = (-3206.0435, -6985.1182, 309.6602);
	angles[13] = (0, 0, 0);
	at[13] = 8.0500;
	points[14] = (-3206.0435, -6985.1182, 358.7941);
	angles[14] = (0, 0, 0);
	at[14] = 8.1500;
	points[15] = (-3206.0435, -6985.1182, 396.5905);
	angles[15] = (0, 0, 0);
	at[15] = 8.2500;
	points[16] = (-3206.0435, -6985.1182, 411.2362);
	angles[16] = (0, 0, 0);
	at[16] = 8.3000;
	points[17] = (-3206.0435, -6985.1182, 432.0236);
	angles[17] = (0, 0, 0);
	at[17] = 8.4000;
	points[18] = (-3206.0435, -6985.1182, 441.9449);
	angles[18] = (0, 0, 0);
	at[18] = 8.5167;
	mover = getEnt("iz_obj_16", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_17()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-2584.4883, -6103.5044, -11.2546);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2584.4883, -6103.5044, -124.6405);
	angles[1] = (0, 0, 0);
	at[1] = 0.6000;
	points[2] = (-2584.4883, -6103.5044, -130.9398);
	angles[2] = (0, 0, 0);
	at[2] = 0.6500;
	points[3] = (-2584.4883, -6103.5044, -130.9398);
	angles[3] = (0, 0, 0);
	at[3] = 4.8000;
	points[4] = (-2584.4883, -6103.5044, -124.8276);
	angles[4] = (0, 0, 0);
	at[4] = 4.8500;
	points[5] = (-2584.4883, -6103.5044, -17.1112);
	angles[5] = (0, 0, 0);
	at[5] = 4.9500;
	points[6] = (-2584.4883, -6103.5044, 32.4951);
	angles[6] = (0, 0, 0);
	at[6] = 5;
	points[7] = (-2584.4883, -6103.5044, 123.2035);
	angles[7] = (0, 0, 0);
	at[7] = 5.1000;
	points[8] = (-2584.4883, -6103.5044, 164.3063);
	angles[8] = (0, 0, 0);
	at[8] = 5.1500;
	points[9] = (-2584.4883, -6103.5044, 238.0071);
	angles[9] = (0, 0, 0);
	at[9] = 5.2500;
	points[10] = (-2584.4883, -6103.5044, 270.6051);
	angles[10] = (0, 0, 0);
	at[10] = 5.3000;
	points[11] = (-2584.4883, -6103.5044, 327.2980);
	angles[11] = (0, 0, 0);
	at[11] = 5.4000;
	points[12] = (-2584.4883, -6103.5044, 351.3925);
	angles[12] = (0, 0, 0);
	at[12] = 5.4500;
	points[13] = (-2584.4883, -6103.5044, 391.0775);
	angles[13] = (0, 0, 0);
	at[13] = 5.5500;
	points[14] = (-2584.4883, -6103.5044, 419.4252);
	angles[14] = (0, 0, 0);
	at[14] = 5.6500;
	points[15] = (-2584.4883, -6103.5044, 436.4331);
	angles[15] = (0, 0, 0);
	at[15] = 5.7500;
	points[16] = (-2584.4883, -6103.5044, 442.1024);
	angles[16] = (0, 0, 0);
	at[16] = 5.8500;
	points[17] = (-2584.4883, -6103.5044, 454.8858);
	angles[17] = (0, 0, 0);
	at[17] = 5.9500;
	points[18] = (-2584.4883, -6103.5044, 456.7834);
	angles[18] = (0, 0, 0);
	at[18] = 6;
	points[19] = (-2584.4883, -6103.5044, 454.8858);
	angles[19] = (0, 0, 0);
	at[19] = 6.0500;
	points[20] = (-2584.4883, -6103.5044, -11.2546);
	angles[20] = (0, 0, 0);
	at[20] = 8.5167;
	mover = getEnt("iz_obj_17", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_18()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-3728.9412, -5837.4409, -130.9398);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-3728.9412, -5837.4409, -130.9398);
	angles[1] = (0, 0, 0);
	at[1] = 1.5000;
	points[2] = (-3728.9412, -5837.4409, -87.6622);
	angles[2] = (0, 0, 0);
	at[2] = 1.5500;
	points[3] = (-3728.9412, -5837.4409, 16.2746);
	angles[3] = (0, 0, 0);
	at[3] = 1.6500;
	points[4] = (-3728.9412, -5837.4409, 63.9913);
	angles[4] = (0, 0, 0);
	at[4] = 1.7000;
	points[5] = (-3728.9412, -5837.4409, 150.9201);
	angles[5] = (0, 0, 0);
	at[5] = 1.8000;
	points[6] = (-3728.9412, -5837.4409, 226.5110);
	angles[6] = (0, 0, 0);
	at[6] = 1.9000;
	points[7] = (-3728.9412, -5837.4409, 260.0540);
	angles[7] = (0, 0, 0);
	at[7] = 1.9500;
	points[8] = (-3728.9412, -5837.4409, 318.6370);
	angles[8] = (0, 0, 0);
	at[8] = 2.0500;
	points[9] = (-3728.9412, -5837.4409, 365.8807);
	angles[9] = (0, 0, 0);
	at[9] = 2.1500;
	points[10] = (-3728.9412, -5837.4409, 401.7874);
	angles[10] = (0, 0, 0);
	at[10] = 2.2500;
	points[11] = (-3728.9412, -5837.4409, 415.4882);
	angles[11] = (0, 0, 0);
	at[11] = 2.3000;
	points[12] = (-3728.9412, -5837.4409, 434.3858);
	angles[12] = (0, 0, 0);
	at[12] = 2.4000;
	points[13] = (-3728.9412, -5837.4409, 445.1693);
	angles[13] = (0, 0, 0);
	at[13] = 2.5500;
	points[14] = (-3728.9412, -5837.4409, 453.0748);
	angles[14] = (0, 0, 0);
	at[14] = 2.6000;
	points[15] = (-3728.9412, -5837.4409, 456.7834);
	angles[15] = (0, 0, 0);
	at[15] = 2.6500;
	points[16] = (-3728.9412, -5837.4409, 454.8858);
	angles[16] = (0, 0, 0);
	at[16] = 2.7000;
	points[17] = (-3728.9412, -5837.4409, 448.5866);
	angles[17] = (0, 0, 0);
	at[17] = 2.7500;
	points[18] = (-3728.9412, -5837.4409, -127.7902);
	angles[18] = (0, 0, 0);
	at[18] = 5.8000;
	points[19] = (-3728.9412, -5837.4409, -130.9398);
	angles[19] = (0, 0, 0);
	at[19] = 5.8500;
	points[20] = (-3728.9412, -5837.4409, -130.9398);
	angles[20] = (0, 0, 0);
	at[20] = 8.5167;
	mover = getEnt("iz_obj_18", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_19()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-2226.5828, -5031.8506, 190.1327);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2226.5828, -5031.8506, 260.0540);
	angles[1] = (0, 0, 0);
	at[1] = 0.1000;
	points[2] = (-2226.5828, -5031.8506, 318.6370);
	angles[2] = (0, 0, 0);
	at[2] = 0.2000;
	points[3] = (-2226.5828, -5031.8506, 365.8807);
	angles[3] = (0, 0, 0);
	at[3] = 0.3000;
	points[4] = (-2226.5828, -5031.8506, 401.7874);
	angles[4] = (0, 0, 0);
	at[4] = 0.4000;
	points[5] = (-2226.5828, -5031.8506, 415.4882);
	angles[5] = (0, 0, 0);
	at[5] = 0.4500;
	points[6] = (-2226.5828, -5031.8506, 434.3858);
	angles[6] = (0, 0, 0);
	at[6] = 0.5500;
	points[7] = (-2226.5828, -5031.8506, 445.1693);
	angles[7] = (0, 0, 0);
	at[7] = 0.7000;
	points[8] = (-2226.5828, -5031.8506, 453.0748);
	angles[8] = (0, 0, 0);
	at[8] = 0.7500;
	points[9] = (-2226.5828, -5031.8506, 456.7834);
	angles[9] = (0, 0, 0);
	at[9] = 0.8000;
	points[10] = (-2226.5828, -5031.8506, 454.8858);
	angles[10] = (0, 0, 0);
	at[10] = 0.8500;
	points[11] = (-2226.5828, -5031.8506, 448.5866);
	angles[11] = (0, 0, 0);
	at[11] = 0.9000;
	points[12] = (-2226.5828, -5031.8506, -127.7902);
	angles[12] = (0, 0, 0);
	at[12] = 3.9500;
	points[13] = (-2226.5828, -5031.8506, -130.9398);
	angles[13] = (0, 0, 0);
	at[13] = 4;
	points[14] = (-2226.5828, -5031.8506, -130.9398);
	angles[14] = (0, 0, 0);
	at[14] = 8.1500;
	points[15] = (-2226.5828, -5031.8506, -106.0874);
	angles[15] = (0, 0, 0);
	at[15] = 8.2000;
	points[16] = (-2226.5828, -5031.8506, -0.2608);
	angles[16] = (0, 0, 0);
	at[16] = 8.3000;
	points[17] = (-2226.5828, -5031.8506, 48.4008);
	angles[17] = (0, 0, 0);
	at[17] = 8.3500;
	points[18] = (-2226.5828, -5031.8506, 137.2193);
	angles[18] = (0, 0, 0);
	at[18] = 8.4500;
	points[19] = (-2226.5828, -5031.8506, 190.1327);
	angles[19] = (0, 0, 0);
	at[19] = 8.5167;
	mover = getEnt("iz_obj_19", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_20()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-3380.8425, -4417.3623, -130.9398);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-3380.8425, -4417.3623, -130.9398);
	angles[1] = (0, 0, 0);
	at[1] = 2.5000;
	points[2] = (-3380.8425, -4417.3623, -106.0874);
	angles[2] = (0, 0, 0);
	at[2] = 2.5500;
	points[3] = (-3380.8425, -4417.3623, -0.2608);
	angles[3] = (0, 0, 0);
	at[3] = 2.6500;
	points[4] = (-3380.8425, -4417.3623, 48.4008);
	angles[4] = (0, 0, 0);
	at[4] = 2.7000;
	points[5] = (-3380.8425, -4417.3623, 94.2276);
	angles[5] = (0, 0, 0);
	at[5] = 2.7500;
	points[6] = (-3380.8425, -4417.3623, 177.3768);
	angles[6] = (0, 0, 0);
	at[6] = 2.8500;
	points[7] = (-3380.8425, -4417.3623, 214.7000);
	angles[7] = (0, 0, 0);
	at[7] = 2.9000;
	points[8] = (-3380.8425, -4417.3623, 280.8417);
	angles[8] = (0, 0, 0);
	at[8] = 3;
	points[9] = (-3380.8425, -4417.3623, 335.6445);
	angles[9] = (0, 0, 0);
	at[9] = 3.1000;
	points[10] = (-3380.8425, -4417.3623, 358.7941);
	angles[10] = (0, 0, 0);
	at[10] = 3.1500;
	points[11] = (-3380.8425, -4417.3623, 396.5905);
	angles[11] = (0, 0, 0);
	at[11] = 3.2500;
	points[12] = (-3380.8425, -4417.3623, 423.0473);
	angles[12] = (0, 0, 0);
	at[12] = 3.3500;
	points[13] = (-3380.8425, -4417.3623, 438.1654);
	angles[13] = (0, 0, 0);
	at[13] = 3.4500;
	points[14] = (-3380.8425, -4417.3623, 442.1024);
	angles[14] = (0, 0, 0);
	at[14] = 3.5500;
	points[15] = (-3380.8425, -4417.3623, 456.1418);
	angles[15] = (0, 0, 0);
	at[15] = 3.6500;
	points[16] = (-3380.8425, -4417.3623, 456.1418);
	angles[16] = (0, 0, 0);
	at[16] = 3.7000;
	points[17] = (-3380.8425, -4417.3623, 451.7362);
	angles[17] = (0, 0, 0);
	at[17] = 3.7500;
	points[18] = (-3380.8425, -4417.3623, -124.6405);
	angles[18] = (0, 0, 0);
	at[18] = 6.8000;
	points[19] = (-3380.8425, -4417.3623, -130.9398);
	angles[19] = (0, 0, 0);
	at[19] = 6.8500;
	points[20] = (-3380.8425, -4417.3623, -130.9398);
	angles[20] = (0, 0, 0);
	at[20] = 8.5167;
	mover = getEnt("iz_obj_20", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_21()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-2853.2834, -3276.2402, 94.2276);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-2853.2834, -3276.2402, 137.2193);
	angles[1] = (0, 0, 0);
	at[1] = 0.0500;
	points[2] = (-2853.2834, -3276.2402, 214.7000);
	angles[2] = (0, 0, 0);
	at[2] = 0.1500;
	points[3] = (-2853.2834, -3276.2402, 280.8417);
	angles[3] = (0, 0, 0);
	at[3] = 0.2500;
	points[4] = (-2853.2834, -3276.2402, 335.6445);
	angles[4] = (0, 0, 0);
	at[4] = 0.3500;
	points[5] = (-2853.2834, -3276.2402, 379.1090);
	angles[5] = (0, 0, 0);
	at[5] = 0.4500;
	points[6] = (-2853.2834, -3276.2402, 411.2362);
	angles[6] = (0, 0, 0);
	at[6] = 0.5500;
	points[7] = (-2853.2834, -3276.2402, 432.0236);
	angles[7] = (0, 0, 0);
	at[7] = 0.6500;
	points[8] = (-2853.2834, -3276.2402, 438.1654);
	angles[8] = (0, 0, 0);
	at[8] = 0.7000;
	points[9] = (-2853.2834, -3276.2402, 442.1024);
	angles[9] = (0, 0, 0);
	at[9] = 0.8000;
	points[10] = (-2853.2834, -3276.2402, 456.1418);
	angles[10] = (0, 0, 0);
	at[10] = 0.9000;
	points[11] = (-2853.2834, -3276.2402, 456.1418);
	angles[11] = (0, 0, 0);
	at[11] = 0.9500;
	points[12] = (-2853.2834, -3276.2402, 451.7362);
	angles[12] = (0, 0, 0);
	at[12] = 1;
	points[13] = (-2853.2834, -3276.2402, -124.6405);
	angles[13] = (0, 0, 0);
	at[13] = 4.0500;
	points[14] = (-2853.2834, -3276.2402, -130.9398);
	angles[14] = (0, 0, 0);
	at[14] = 4.1000;
	points[15] = (-2853.2834, -3276.2402, -130.9398);
	angles[15] = (0, 0, 0);
	at[15] = 8.2500;
	points[16] = (-2853.2834, -3276.2402, -124.8276);
	angles[16] = (0, 0, 0);
	at[16] = 8.3000;
	points[17] = (-2853.2834, -3276.2402, -17.1112);
	angles[17] = (0, 0, 0);
	at[17] = 8.4000;
	points[18] = (-2853.2834, -3276.2402, 94.2276);
	angles[18] = (0, 0, 0);
	at[18] = 8.5167;
	mover = getEnt("iz_obj_21", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_22()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-6659.3311, 4887.3623, -130.9398);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-6659.3311, 4887.3623, -130.9398);
	angles[1] = (0, 0, 0);
	at[1] = 0.8500;
	points[2] = (-6659.3311, 4887.3623, -87.6622);
	angles[2] = (0, 0, 0);
	at[2] = 0.9000;
	points[3] = (-6659.3311, 4887.3623, 16.2746);
	angles[3] = (0, 0, 0);
	at[3] = 1;
	points[4] = (-6659.3311, 4887.3623, 63.9913);
	angles[4] = (0, 0, 0);
	at[4] = 1.0500;
	points[5] = (-6659.3311, 4887.3623, 150.9201);
	angles[5] = (0, 0, 0);
	at[5] = 1.1500;
	points[6] = (-6659.3311, 4887.3623, 226.5110);
	angles[6] = (0, 0, 0);
	at[6] = 1.2500;
	points[7] = (-6659.3311, 4887.3623, 260.0540);
	angles[7] = (0, 0, 0);
	at[7] = 1.3000;
	points[8] = (-6659.3311, 4887.3623, 318.6370);
	angles[8] = (0, 0, 0);
	at[8] = 1.4000;
	points[9] = (-6659.3311, 4887.3623, 365.8807);
	angles[9] = (0, 0, 0);
	at[9] = 1.5000;
	points[10] = (-6659.3311, 4887.3623, 401.7874);
	angles[10] = (0, 0, 0);
	at[10] = 1.6000;
	points[11] = (-6659.3311, 4887.3623, 415.4882);
	angles[11] = (0, 0, 0);
	at[11] = 1.6500;
	points[12] = (-6659.3311, 4887.3623, 434.3858);
	angles[12] = (0, 0, 0);
	at[12] = 1.7500;
	points[13] = (-6659.3311, 4887.3623, 445.1693);
	angles[13] = (0, 0, 0);
	at[13] = 1.9000;
	points[14] = (-6659.3311, 4887.3623, 453.0748);
	angles[14] = (0, 0, 0);
	at[14] = 1.9500;
	points[15] = (-6659.3311, 4887.3623, 456.7834);
	angles[15] = (0, 0, 0);
	at[15] = 2;
	points[16] = (-6659.3311, 4887.3623, 454.8858);
	angles[16] = (0, 0, 0);
	at[16] = 2.0500;
	points[17] = (-6659.3311, 4887.3623, 448.5866);
	angles[17] = (0, 0, 0);
	at[17] = 2.1000;
	points[18] = (-6659.3311, 4887.3623, -127.7902);
	angles[18] = (0, 0, 0);
	at[18] = 5.1500;
	points[19] = (-6659.3311, 4887.3623, -130.9398);
	angles[19] = (0, 0, 0);
	at[19] = 5.2000;
	points[20] = (-6659.3311, 4887.3623, -130.9398);
	angles[20] = (0, 0, 0);
	at[20] = 8.5167;
	mover = getEnt("iz_obj_22", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_23()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (8573.3467, -9730.5908, -130.9398);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (8573.3467, -9730.5908, -130.9398);
	angles[1] = (0, 0, 0);
	at[1] = 0.8500;
	points[2] = (8573.3467, -9730.5908, -87.6622);
	angles[2] = (0, 0, 0);
	at[2] = 0.9000;
	points[3] = (8573.3467, -9730.5908, 16.2746);
	angles[3] = (0, 0, 0);
	at[3] = 1;
	points[4] = (8573.3467, -9730.5908, 63.9913);
	angles[4] = (0, 0, 0);
	at[4] = 1.0500;
	points[5] = (8573.3467, -9730.5908, 150.9201);
	angles[5] = (0, 0, 0);
	at[5] = 1.1500;
	points[6] = (8573.3467, -9730.5908, 226.5110);
	angles[6] = (0, 0, 0);
	at[6] = 1.2500;
	points[7] = (8573.3467, -9730.5908, 260.0540);
	angles[7] = (0, 0, 0);
	at[7] = 1.3000;
	points[8] = (8573.3467, -9730.5908, 318.6370);
	angles[8] = (0, 0, 0);
	at[8] = 1.4000;
	points[9] = (8573.3467, -9730.5908, 365.8807);
	angles[9] = (0, 0, 0);
	at[9] = 1.5000;
	points[10] = (8573.3467, -9730.5908, 401.7874);
	angles[10] = (0, 0, 0);
	at[10] = 1.6000;
	points[11] = (8573.3467, -9730.5908, 415.4882);
	angles[11] = (0, 0, 0);
	at[11] = 1.6500;
	points[12] = (8573.3467, -9730.5908, 434.3858);
	angles[12] = (0, 0, 0);
	at[12] = 1.7500;
	points[13] = (8573.3467, -9730.5908, 445.1693);
	angles[13] = (0, 0, 0);
	at[13] = 1.9000;
	points[14] = (8573.3467, -9730.5908, 453.0748);
	angles[14] = (0, 0, 0);
	at[14] = 1.9500;
	points[15] = (8573.3467, -9730.5908, 456.7834);
	angles[15] = (0, 0, 0);
	at[15] = 2;
	points[16] = (8573.3467, -9730.5908, 454.8858);
	angles[16] = (0, 0, 0);
	at[16] = 2.0500;
	points[17] = (8573.3467, -9730.5908, 448.5866);
	angles[17] = (0, 0, 0);
	at[17] = 2.1000;
	points[18] = (8573.3467, -9730.5908, -127.7902);
	angles[18] = (0, 0, 0);
	at[18] = 5.1500;
	points[19] = (8573.3467, -9730.5908, -130.9398);
	angles[19] = (0, 0, 0);
	at[19] = 5.2000;
	points[20] = (8573.3467, -9730.5908, -130.9398);
	angles[20] = (0, 0, 0);
	at[20] = 8.5167;
	mover = getEnt("iz_obj_23", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_24()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (5475.9844, 9668.9766, -130.9398);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (5475.9844, 9668.9766, -130.9398);
	angles[1] = (0, 0, 0);
	at[1] = 0.8500;
	points[2] = (5475.9844, 9668.9766, -87.6622);
	angles[2] = (0, 0, 0);
	at[2] = 0.9000;
	points[3] = (5475.9844, 9668.9766, 16.2746);
	angles[3] = (0, 0, 0);
	at[3] = 1;
	points[4] = (5475.9844, 9668.9766, 63.9913);
	angles[4] = (0, 0, 0);
	at[4] = 1.0500;
	points[5] = (5475.9844, 9668.9766, 150.9201);
	angles[5] = (0, 0, 0);
	at[5] = 1.1500;
	points[6] = (5475.9844, 9668.9766, 226.5110);
	angles[6] = (0, 0, 0);
	at[6] = 1.2500;
	points[7] = (5475.9844, 9668.9766, 260.0540);
	angles[7] = (0, 0, 0);
	at[7] = 1.3000;
	points[8] = (5475.9844, 9668.9766, 318.6370);
	angles[8] = (0, 0, 0);
	at[8] = 1.4000;
	points[9] = (5475.9844, 9668.9766, 365.8807);
	angles[9] = (0, 0, 0);
	at[9] = 1.5000;
	points[10] = (5475.9844, 9668.9766, 401.7874);
	angles[10] = (0, 0, 0);
	at[10] = 1.6000;
	points[11] = (5475.9844, 9668.9766, 415.4882);
	angles[11] = (0, 0, 0);
	at[11] = 1.6500;
	points[12] = (5475.9844, 9668.9766, 434.3858);
	angles[12] = (0, 0, 0);
	at[12] = 1.7500;
	points[13] = (5475.9844, 9668.9766, 445.1693);
	angles[13] = (0, 0, 0);
	at[13] = 1.9000;
	points[14] = (5475.9844, 9668.9766, 453.0748);
	angles[14] = (0, 0, 0);
	at[14] = 1.9500;
	points[15] = (5475.9844, 9668.9766, 456.7834);
	angles[15] = (0, 0, 0);
	at[15] = 2;
	points[16] = (5475.9844, 9668.9766, 454.8858);
	angles[16] = (0, 0, 0);
	at[16] = 2.0500;
	points[17] = (5475.9844, 9668.9766, 448.5866);
	angles[17] = (0, 0, 0);
	at[17] = 2.1000;
	points[18] = (5475.9844, 9668.9766, -127.7902);
	angles[18] = (0, 0, 0);
	at[18] = 5.1500;
	points[19] = (5475.9844, 9668.9766, -130.9398);
	angles[19] = (0, 0, 0);
	at[19] = 5.2000;
	points[20] = (5475.9844, 9668.9766, -130.9398);
	angles[20] = (0, 0, 0);
	at[20] = 8.5167;
	mover = getEnt("iz_obj_24", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_25()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-7023.5430, -10424.4492, -130.9398);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-7023.5430, -10424.4492, -130.9398);
	angles[1] = (0, 0, 0);
	at[1] = 0.8500;
	points[2] = (-7023.5430, -10424.4492, -87.6622);
	angles[2] = (0, 0, 0);
	at[2] = 0.9000;
	points[3] = (-7023.5430, -10424.4492, 16.2746);
	angles[3] = (0, 0, 0);
	at[3] = 1;
	points[4] = (-7023.5430, -10424.4492, 63.9913);
	angles[4] = (0, 0, 0);
	at[4] = 1.0500;
	points[5] = (-7023.5430, -10424.4492, 150.9201);
	angles[5] = (0, 0, 0);
	at[5] = 1.1500;
	points[6] = (-7023.5430, -10424.4492, 226.5110);
	angles[6] = (0, 0, 0);
	at[6] = 1.2500;
	points[7] = (-7023.5430, -10424.4492, 260.0540);
	angles[7] = (0, 0, 0);
	at[7] = 1.3000;
	points[8] = (-7023.5430, -10424.4492, 318.6370);
	angles[8] = (0, 0, 0);
	at[8] = 1.4000;
	points[9] = (-7023.5430, -10424.4492, 365.8807);
	angles[9] = (0, 0, 0);
	at[9] = 1.5000;
	points[10] = (-7023.5430, -10424.4492, 401.7874);
	angles[10] = (0, 0, 0);
	at[10] = 1.6000;
	points[11] = (-7023.5430, -10424.4492, 415.4882);
	angles[11] = (0, 0, 0);
	at[11] = 1.6500;
	points[12] = (-7023.5430, -10424.4492, 434.3858);
	angles[12] = (0, 0, 0);
	at[12] = 1.7500;
	points[13] = (-7023.5430, -10424.4492, 445.1693);
	angles[13] = (0, 0, 0);
	at[13] = 1.9000;
	points[14] = (-7023.5430, -10424.4492, 453.0748);
	angles[14] = (0, 0, 0);
	at[14] = 1.9500;
	points[15] = (-7023.5430, -10424.4492, 456.7834);
	angles[15] = (0, 0, 0);
	at[15] = 2;
	points[16] = (-7023.5430, -10424.4492, 454.8858);
	angles[16] = (0, 0, 0);
	at[16] = 2.0500;
	points[17] = (-7023.5430, -10424.4492, 448.5866);
	angles[17] = (0, 0, 0);
	at[17] = 2.1000;
	points[18] = (-7023.5430, -10424.4492, -127.7902);
	angles[18] = (0, 0, 0);
	at[18] = 5.1500;
	points[19] = (-7023.5430, -10424.4492, -130.9398);
	angles[19] = (0, 0, 0);
	at[19] = 5.2000;
	points[20] = (-7023.5430, -10424.4492, -130.9398);
	angles[20] = (0, 0, 0);
	at[20] = 8.5167;
	mover = getEnt("iz_obj_25", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_26()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-7701.5747, -10424.4492, -130.9398);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-7701.5747, -10424.4492, -130.9398);
	angles[1] = (0, 0, 0);
	at[1] = 0.8500;
	points[2] = (-7701.5747, -10424.4492, -87.6622);
	angles[2] = (0, 0, 0);
	at[2] = 0.9000;
	points[3] = (-7701.5747, -10424.4492, 16.2746);
	angles[3] = (0, 0, 0);
	at[3] = 1;
	points[4] = (-7701.5747, -10424.4492, 63.9913);
	angles[4] = (0, 0, 0);
	at[4] = 1.0500;
	points[5] = (-7701.5747, -10424.4492, 150.9201);
	angles[5] = (0, 0, 0);
	at[5] = 1.1500;
	points[6] = (-7701.5747, -10424.4492, 226.5110);
	angles[6] = (0, 0, 0);
	at[6] = 1.2500;
	points[7] = (-7701.5747, -10424.4492, 260.0540);
	angles[7] = (0, 0, 0);
	at[7] = 1.3000;
	points[8] = (-7701.5747, -10424.4492, 318.6370);
	angles[8] = (0, 0, 0);
	at[8] = 1.4000;
	points[9] = (-7701.5747, -10424.4492, 365.8807);
	angles[9] = (0, 0, 0);
	at[9] = 1.5000;
	points[10] = (-7701.5747, -10424.4492, 401.7874);
	angles[10] = (0, 0, 0);
	at[10] = 1.6000;
	points[11] = (-7701.5747, -10424.4492, 415.4882);
	angles[11] = (0, 0, 0);
	at[11] = 1.6500;
	points[12] = (-7701.5747, -10424.4492, 434.3858);
	angles[12] = (0, 0, 0);
	at[12] = 1.7500;
	points[13] = (-7701.5747, -10424.4492, 445.1693);
	angles[13] = (0, 0, 0);
	at[13] = 1.9000;
	points[14] = (-7701.5747, -10424.4492, 453.0748);
	angles[14] = (0, 0, 0);
	at[14] = 1.9500;
	points[15] = (-7701.5747, -10424.4492, 456.7834);
	angles[15] = (0, 0, 0);
	at[15] = 2;
	points[16] = (-7701.5747, -10424.4492, 454.8858);
	angles[16] = (0, 0, 0);
	at[16] = 2.0500;
	points[17] = (-7701.5747, -10424.4492, 448.5866);
	angles[17] = (0, 0, 0);
	at[17] = 2.1000;
	points[18] = (-7701.5747, -10424.4492, -127.7902);
	angles[18] = (0, 0, 0);
	at[18] = 5.1500;
	points[19] = (-7701.5747, -10424.4492, -130.9398);
	angles[19] = (0, 0, 0);
	at[19] = 5.2000;
	points[20] = (-7701.5747, -10424.4492, -130.9398);
	angles[20] = (0, 0, 0);
	at[20] = 8.5167;
	mover = getEnt("iz_obj_26", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_27()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-1947.4568, 6741.4170, -130.9398);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-1947.4568, 6741.4170, -130.9398);
	angles[1] = (0, 0, 0);
	at[1] = 0.8500;
	points[2] = (-1947.4568, 6741.4170, -87.6622);
	angles[2] = (0, 0, 0);
	at[2] = 0.9000;
	points[3] = (-1947.4568, 6741.4170, 16.2746);
	angles[3] = (0, 0, 0);
	at[3] = 1;
	points[4] = (-1947.4568, 6741.4170, 63.9913);
	angles[4] = (0, 0, 0);
	at[4] = 1.0500;
	points[5] = (-1947.4568, 6741.4170, 150.9201);
	angles[5] = (0, 0, 0);
	at[5] = 1.1500;
	points[6] = (-1947.4568, 6741.4170, 226.5110);
	angles[6] = (0, 0, 0);
	at[6] = 1.2500;
	points[7] = (-1947.4568, 6741.4170, 260.0540);
	angles[7] = (0, 0, 0);
	at[7] = 1.3000;
	points[8] = (-1947.4568, 6741.4170, 318.6370);
	angles[8] = (0, 0, 0);
	at[8] = 1.4000;
	points[9] = (-1947.4568, 6741.4170, 365.8807);
	angles[9] = (0, 0, 0);
	at[9] = 1.5000;
	points[10] = (-1947.4568, 6741.4170, 401.7874);
	angles[10] = (0, 0, 0);
	at[10] = 1.6000;
	points[11] = (-1947.4568, 6741.4170, 415.4882);
	angles[11] = (0, 0, 0);
	at[11] = 1.6500;
	points[12] = (-1947.4568, 6741.4170, 434.3858);
	angles[12] = (0, 0, 0);
	at[12] = 1.7500;
	points[13] = (-1947.4568, 6741.4170, 445.1693);
	angles[13] = (0, 0, 0);
	at[13] = 1.9000;
	points[14] = (-1947.4568, 6741.4170, 453.0748);
	angles[14] = (0, 0, 0);
	at[14] = 1.9500;
	points[15] = (-1947.4568, 6741.4170, 456.7834);
	angles[15] = (0, 0, 0);
	at[15] = 2;
	points[16] = (-1947.4568, 6741.4170, 454.8858);
	angles[16] = (0, 0, 0);
	at[16] = 2.0500;
	points[17] = (-1947.4568, 6741.4170, 448.5866);
	angles[17] = (0, 0, 0);
	at[17] = 2.1000;
	points[18] = (-1947.4568, 6741.4170, -127.7902);
	angles[18] = (0, 0, 0);
	at[18] = 5.1500;
	points[19] = (-1947.4568, 6741.4170, -130.9398);
	angles[19] = (0, 0, 0);
	at[19] = 5.2000;
	points[20] = (-1947.4568, 6741.4170, -130.9398);
	angles[20] = (0, 0, 0);
	at[20] = 8.5167;
	mover = getEnt("iz_obj_27", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_obj_28()
{
	points = [];
	angles = [];
	at = [];
	points[0] = (-4929.8818, 6741.4170, -130.9398);
	angles[0] = (0, 0, 0);
	at[0] = 0;
	points[1] = (-4929.8818, 6741.4170, -130.9398);
	angles[1] = (0, 0, 0);
	at[1] = 0.8500;
	points[2] = (-4929.8818, 6741.4170, -87.6622);
	angles[2] = (0, 0, 0);
	at[2] = 0.9000;
	points[3] = (-4929.8818, 6741.4170, 16.2746);
	angles[3] = (0, 0, 0);
	at[3] = 1;
	points[4] = (-4929.8818, 6741.4170, 63.9913);
	angles[4] = (0, 0, 0);
	at[4] = 1.0500;
	points[5] = (-4929.8818, 6741.4170, 150.9201);
	angles[5] = (0, 0, 0);
	at[5] = 1.1500;
	points[6] = (-4929.8818, 6741.4170, 226.5110);
	angles[6] = (0, 0, 0);
	at[6] = 1.2500;
	points[7] = (-4929.8818, 6741.4170, 260.0540);
	angles[7] = (0, 0, 0);
	at[7] = 1.3000;
	points[8] = (-4929.8818, 6741.4170, 318.6370);
	angles[8] = (0, 0, 0);
	at[8] = 1.4000;
	points[9] = (-4929.8818, 6741.4170, 365.8807);
	angles[9] = (0, 0, 0);
	at[9] = 1.5000;
	points[10] = (-4929.8818, 6741.4170, 401.7874);
	angles[10] = (0, 0, 0);
	at[10] = 1.6000;
	points[11] = (-4929.8818, 6741.4170, 415.4882);
	angles[11] = (0, 0, 0);
	at[11] = 1.6500;
	points[12] = (-4929.8818, 6741.4170, 434.3858);
	angles[12] = (0, 0, 0);
	at[12] = 1.7500;
	points[13] = (-4929.8818, 6741.4170, 445.1693);
	angles[13] = (0, 0, 0);
	at[13] = 1.9000;
	points[14] = (-4929.8818, 6741.4170, 453.0748);
	angles[14] = (0, 0, 0);
	at[14] = 1.9500;
	points[15] = (-4929.8818, 6741.4170, 456.7834);
	angles[15] = (0, 0, 0);
	at[15] = 2;
	points[16] = (-4929.8818, 6741.4170, 454.8858);
	angles[16] = (0, 0, 0);
	at[16] = 2.0500;
	points[17] = (-4929.8818, 6741.4170, 448.5866);
	angles[17] = (0, 0, 0);
	at[17] = 2.1000;
	points[18] = (-4929.8818, 6741.4170, -127.7902);
	angles[18] = (0, 0, 0);
	at[18] = 5.1500;
	points[19] = (-4929.8818, 6741.4170, -130.9398);
	angles[19] = (0, 0, 0);
	at[19] = 5.2000;
	points[20] = (-4929.8818, 6741.4170, -130.9398);
	angles[20] = (0, 0, 0);
	at[20] = 8.5167;
	mover = getEnt("iz_obj_28", "targetname");
	if (!isDefined(mover))
		return;
	mover thread iz_mover_loop(points, angles, at, false, true);
}

iz_mover_loop(points, angles, at, once, closed)
{
	wait 0.05;
	self iz_place(points[0], iz_pose(angles, 0));
	period = at[at.size - 1];
	if (period < 0.05)
		return;
	done = 0;
	for (pass = 0; !once || pass < 1; pass++)
	{
		if (pass && !closed)
			self iz_place(points[0], iz_pose(angles, 0));
		for (i = 1; i < points.size; i++)
		{
			if (at[i] == at[i - 1])
			{
				self iz_place(points[i], iz_pose(angles, i));
				continue;
			}
			due = int((pass * period + at[i]) * 20 + 0.5);
			if (due <= done)
				continue;
			self iz_move(points[i], iz_pose(angles, i), due - done);
			wait 0.05 * (due - done);
			done = due;
		}
	}
	last = points.size - 1;
	self iz_stop(points[last], iz_pose(angles, last));
}

iz_pose(angles, i)
{
	if (isDefined(angles))
		return angles[i];
}
