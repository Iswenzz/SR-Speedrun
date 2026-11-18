main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_wiiu_ticktockclock", 0);

	setExpFog(0, 61515.7461, 1, 0.7451, 0, 0);

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
	ambientPlay("iz_0_uttc", 2);
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
	level.iz_route[level.iz_route.size] = (4917, 9400, 2411);
	level.iz_route[level.iz_route.size] = (3792, 9407, 2411);
	level.iz_route[level.iz_route.size] = (2115, 9414, 2411);
	level.iz_route[level.iz_route.size] = (1214, 9296, 2411);
	level.iz_route[level.iz_route.size] = (701, 8949, 2411);
	level.iz_route[level.iz_route.size] = (492, 8246, 2453);
	level.iz_route[level.iz_route.size] = (471, 6901, 2776);
	level.iz_route[level.iz_route.size] = (473, 5734, 3056);
	level.iz_route[level.iz_route.size] = (479, 4716, 3300);
	level.iz_route[level.iz_route.size] = (506, 4417, 3368);
	level.iz_route[level.iz_route.size] = (508, 3603, 3381);
	level.iz_route[level.iz_route.size] = (506, 3279, 3364);
	level.iz_route[level.iz_route.size] = (521, 2705, 3278);
	level.iz_route[level.iz_route.size] = (526, 2092, 3157);
	level.iz_route[level.iz_route.size] = (1348, 1565, 3093);
	level.iz_route[level.iz_route.size] = (1963, 1060, 3093);
	level.iz_route[level.iz_route.size] = (2246, 586, 3093);
	level.iz_route[level.iz_route.size] = (2425, 115, 3093);
	level.iz_route[level.iz_route.size] = (2482, -393, 3093);
	level.iz_route[level.iz_route.size] = (2472, -986, 3093);
	level.iz_route[level.iz_route.size] = (2322, -1494, 3093);
	level.iz_route[level.iz_route.size] = (1987, -2005, 3093);
	level.iz_route[level.iz_route.size] = (1538, -2283, 3093);
	level.iz_route[level.iz_route.size] = (1087, -2523, 3093);
	level.iz_route[level.iz_route.size] = (532, -3146, 3168);
	level.iz_route[level.iz_route.size] = (517, -3458, 3234);
	level.iz_route[level.iz_route.size] = (511, -3559, 3255);
	level.iz_route[level.iz_route.size] = (503, -4009, 3259);
	level.iz_route[level.iz_route.size] = (502, -4368, 3217);
	level.iz_route[level.iz_route.size] = (3, -5213, 3049);
	level.iz_route[level.iz_route.size] = (-42, -7268, 2643);
	level.iz_route[level.iz_route.size] = (473, -8365, 2426);
	level.iz_route[level.iz_route.size] = (338, -9140, 2344);
	level.iz_route[level.iz_route.size] = (9, -9810, 2344);
	level.iz_route[level.iz_route.size] = (-489, -10011, 2344);
	level.iz_route[level.iz_route.size] = (-769, -9999, 2342);
	level.iz_route[level.iz_route.size] = (-1429, -10013, 2273);
	level.iz_route[level.iz_route.size] = (-2212, -10030, 2194);
	level.iz_route[level.iz_route.size] = (-3432, -10045, 2194);
	level.iz_route[level.iz_route.size] = (-5209, -10090, 2194);
	level.iz_route[level.iz_route.size] = (-6131, -9974, 2194);
	level.iz_route[level.iz_route.size] = (-6415, -9686, 2194);
	level.iz_route[level.iz_route.size] = (-6485, -9236, 2194);
	level.iz_route[level.iz_route.size] = (-6422, -8837, 2194);
	level.iz_route[level.iz_route.size] = (-6264, -8473, 2194);
	level.iz_route[level.iz_route.size] = (-5890, -8017, 2187);
	level.iz_route[level.iz_route.size] = (-5471, -7579, 2134);
	level.iz_route[level.iz_route.size] = (-4222, -6341, 1721);
	level.iz_route[level.iz_route.size] = (-3337, -5473, 1425);
	level.iz_route[level.iz_route.size] = (-2497, -4654, 1114);
	level.iz_route[level.iz_route.size] = (-1897, -4390, 901);
	level.iz_route[level.iz_route.size] = (-1350, -4412, 901);
	level.iz_route[level.iz_route.size] = (-893, -4222, 901);
	level.iz_route[level.iz_route.size] = (-528, -3776, 901);
	level.iz_route[level.iz_route.size] = (11, -2801, 843);
	level.iz_route[level.iz_route.size] = (553, -2536, 843);
	level.iz_route[level.iz_route.size] = (935, -2079, 843);
	level.iz_route[level.iz_route.size] = (873, -555, 812);
	level.iz_route[level.iz_route.size] = (1294, -96, 812);
	level.iz_route[level.iz_route.size] = (1924, 72, 812);
	level.iz_route[level.iz_route.size] = (3254, 76, 758);
	level.iz_route[level.iz_route.size] = (3880, 264, 758);
	level.iz_route[level.iz_route.size] = (4262, 637, 758);
	level.iz_route[level.iz_route.size] = (4370, 1167, 758);
	level.iz_route[level.iz_route.size] = (4459, 2035, 758);
	level.iz_route[level.iz_route.size] = (4994, 2636, 712);
	level.iz_route[level.iz_route.size] = (5427, 3086, 764);
	level.iz_route[level.iz_route.size] = (6292, 3946, 1021);
	level.iz_route[level.iz_route.size] = (6613, 4269, 1114);
	level.iz_route[level.iz_route.size] = (7057, 4443, 1114);
	level.iz_route[level.iz_route.size] = (7582, 4110, 1114);
	level.iz_route[level.iz_route.size] = (8349, 3383, 1114);
	level.iz_route[level.iz_route.size] = (8714, 3039, 1114);
	level.iz_route[level.iz_route.size] = (9166, 3072, 1114);
	level.iz_route[level.iz_route.size] = (9424, 3176, 1108);
	level.iz_route[level.iz_route.size] = (10022, 3667, 1005);
	level.iz_route[level.iz_route.size] = (10423, 4093, 934);
	level.iz_route[level.iz_route.size] = (10488, 4567, 934);
	level.iz_route[level.iz_route.size] = (10665, 5199, 934);
	level.iz_route[level.iz_route.size] = (11034, 5847, 934);
	level.iz_route[level.iz_route.size] = (11390, 6437, 937);
	level.iz_route[level.iz_route.size] = (11345, 7384, 1227);
	level.iz_route[level.iz_route.size] = (11349, 8334, 1518);
	level.iz_route[level.iz_route.size] = (11283, 8661, 1546);
	level.iz_route[level.iz_route.size] = (11038, 8928, 1546);
	level.iz_route[level.iz_route.size] = (10733, 9130, 1546);
	level.iz_route[level.iz_route.size] = (10234, 9329, 1635);
	level.iz_route[level.iz_route.size] = (9451, 9339, 1883);
	level.iz_route[level.iz_route.size] = (7774, 9333, 2411);
	level.iz_route[level.iz_route.size] = (6696, 9373, 2411);
}
