main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_gba_riverside_park", 0);

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
	ambientPlay("iz_0_38", 2);
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
	level.iz_route[level.iz_route.size] = (5193, -1215, 1116);
	level.iz_route[level.iz_route.size] = (5231, -2696, 1116);
	level.iz_route[level.iz_route.size] = (5321, -2974, 1116);
	level.iz_route[level.iz_route.size] = (5544, -3299, 1116);
	level.iz_route[level.iz_route.size] = (6477, -4392, 1116);
	level.iz_route[level.iz_route.size] = (7036, -5027, 1116);
	level.iz_route[level.iz_route.size] = (7538, -5919, 1120);
	level.iz_route[level.iz_route.size] = (7488, -6338, 1131);
	level.iz_route[level.iz_route.size] = (7391, -6621, 1139);
	level.iz_route[level.iz_route.size] = (7192, -6787, 1141);
	level.iz_route[level.iz_route.size] = (6821, -6924, 1138);
	level.iz_route[level.iz_route.size] = (6371, -6983, 1130);
	level.iz_route[level.iz_route.size] = (6013, -6965, 1123);
	level.iz_route[level.iz_route.size] = (5551, -6829, 1117);
	level.iz_route[level.iz_route.size] = (5062, -6427, 1116);
	level.iz_route[level.iz_route.size] = (4541, -5884, 1117);
	level.iz_route[level.iz_route.size] = (2758, -4155, 1124);
	level.iz_route[level.iz_route.size] = (2230, -3624, 1131);
	level.iz_route[level.iz_route.size] = (1956, -3343, 1137);
	level.iz_route[level.iz_route.size] = (1732, -3248, 1138);
	level.iz_route[level.iz_route.size] = (1377, -3200, 1138);
	level.iz_route[level.iz_route.size] = (995, -3341, 1133);
	level.iz_route[level.iz_route.size] = (-492, -4333, 1117);
	level.iz_route[level.iz_route.size] = (-1219, -5389, 1116);
	level.iz_route[level.iz_route.size] = (-1563, -5815, 1116);
	level.iz_route[level.iz_route.size] = (-1930, -6245, 1116);
	level.iz_route[level.iz_route.size] = (-2327, -6481, 1116);
	level.iz_route[level.iz_route.size] = (-2671, -6682, 1116);
	level.iz_route[level.iz_route.size] = (-3276, -6697, 1116);
	level.iz_route[level.iz_route.size] = (-3833, -6619, 1116);
	level.iz_route[level.iz_route.size] = (-4192, -6414, 1116);
	level.iz_route[level.iz_route.size] = (-4357, -6029, 1116);
	level.iz_route[level.iz_route.size] = (-4397, -5504, 1116);
	level.iz_route[level.iz_route.size] = (-4405, -4908, 1146);
	level.iz_route[level.iz_route.size] = (-4409, -4282, 1175);
	level.iz_route[level.iz_route.size] = (-4457, -2957, 769);
	level.iz_route[level.iz_route.size] = (-4370, -415, 776);
	level.iz_route[level.iz_route.size] = (-4310, 199, 782);
	level.iz_route[level.iz_route.size] = (-4088, 661, 788);
	level.iz_route[level.iz_route.size] = (-3630, 807, 785);
	level.iz_route[level.iz_route.size] = (-3064, 768, 780);
	level.iz_route[level.iz_route.size] = (-2668, 518, 773);
	level.iz_route[level.iz_route.size] = (-2198, 62, 768);
	level.iz_route[level.iz_route.size] = (-1901, -268, 768);
	level.iz_route[level.iz_route.size] = (-1450, -670, 768);
	level.iz_route[level.iz_route.size] = (-931, -861, 768);
	level.iz_route[level.iz_route.size] = (-423, -856, 768);
	level.iz_route[level.iz_route.size] = (175, -643, 768);
	level.iz_route[level.iz_route.size] = (1460, 70, 772);
	level.iz_route[level.iz_route.size] = (1821, 269, 774);
	level.iz_route[level.iz_route.size] = (1998, 485, 776);
	level.iz_route[level.iz_route.size] = (2080, 759, 777);
	level.iz_route[level.iz_route.size] = (2104, 1018, 777);
	level.iz_route[level.iz_route.size] = (2092, 1298, 776);
	level.iz_route[level.iz_route.size] = (1975, 1599, 774);
	level.iz_route[level.iz_route.size] = (1596, 1843, 770);
	level.iz_route[level.iz_route.size] = (847, 2098, 768);
	level.iz_route[level.iz_route.size] = (488, 2314, 768);
	level.iz_route[level.iz_route.size] = (91, 2677, 768);
	level.iz_route[level.iz_route.size] = (-1054, 3811, 768);
	level.iz_route[level.iz_route.size] = (-1872, 4553, 768);
	level.iz_route[level.iz_route.size] = (-2148, 4822, 768);
	level.iz_route[level.iz_route.size] = (-2458, 5004, 768);
	level.iz_route[level.iz_route.size] = (-2891, 5097, 768);
	level.iz_route[level.iz_route.size] = (-4702, 5138, 779);
	level.iz_route[level.iz_route.size] = (-5110, 5218, 785);
	level.iz_route[level.iz_route.size] = (-5418, 5406, 791);
	level.iz_route[level.iz_route.size] = (-5562, 5693, 791);
	level.iz_route[level.iz_route.size] = (-5535, 5989, 788);
	level.iz_route[level.iz_route.size] = (-5363, 6304, 780);
	level.iz_route[level.iz_route.size] = (-4621, 7120, 768);
	level.iz_route[level.iz_route.size] = (-3787, 7977, 768);
	level.iz_route[level.iz_route.size] = (-3440, 8215, 768);
	level.iz_route[level.iz_route.size] = (-3089, 8298, 768);
	level.iz_route[level.iz_route.size] = (-2737, 8285, 768);
	level.iz_route[level.iz_route.size] = (-2328, 8130, 768);
	level.iz_route[level.iz_route.size] = (-1730, 7716, 768);
	level.iz_route[level.iz_route.size] = (-405, 6358, 768);
	level.iz_route[level.iz_route.size] = (231, 5668, 768);
	level.iz_route[level.iz_route.size] = (938, 4882, 768);
	level.iz_route[level.iz_route.size] = (2040, 3971, 768);
	level.iz_route[level.iz_route.size] = (2768, 3708, 768);
	level.iz_route[level.iz_route.size] = (3926, 3661, 768);
	level.iz_route[level.iz_route.size] = (5599, 3682, 768);
	level.iz_route[level.iz_route.size] = (6940, 3723, 780);
	level.iz_route[level.iz_route.size] = (7266, 3873, 803);
	level.iz_route[level.iz_route.size] = (7582, 4242, 850);
	level.iz_route[level.iz_route.size] = (7767, 4664, 895);
	level.iz_route[level.iz_route.size] = (7840, 5180, 943);
	level.iz_route[level.iz_route.size] = (7757, 5690, 990);
	level.iz_route[level.iz_route.size] = (7465, 6112, 1038);
	level.iz_route[level.iz_route.size] = (6959, 6306, 1073);
	level.iz_route[level.iz_route.size] = (6366, 6274, 1096);
	level.iz_route[level.iz_route.size] = (5784, 6036, 1149);
	level.iz_route[level.iz_route.size] = (5426, 5663, 1198);
	level.iz_route[level.iz_route.size] = (5273, 5295, 1220);
	level.iz_route[level.iz_route.size] = (5208, 4687, 1281);
	level.iz_route[level.iz_route.size] = (5202, 4205, 1354);
	level.iz_route[level.iz_route.size] = (5215, 2333, 1116);
	level.iz_route[level.iz_route.size] = (5212, 258, 1116);
}
