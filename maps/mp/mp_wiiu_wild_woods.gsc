main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_wiiu_wild_woods", 0);

	setExpFog(2952.7559, 19484.2500, 0.9373, 1, 0.5490, 0);

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
	ambientPlay("iz_0_uww", 2);
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
	level.iz_route[level.iz_route.size] = (6713, -15244, 10349);
	level.iz_route[level.iz_route.size] = (6696, -16849, 10783);
	level.iz_route[level.iz_route.size] = (6407, -17942, 10979);
	level.iz_route[level.iz_route.size] = (5475, -18689, 11136);
	level.iz_route[level.iz_route.size] = (4629, -18994, 11210);
	level.iz_route[level.iz_route.size] = (3633, -19044, 11244);
	level.iz_route[level.iz_route.size] = (1352, -17939, 11196);
	level.iz_route[level.iz_route.size] = (-3, -17352, 11319);
	level.iz_route[level.iz_route.size] = (-1129, -16668, 11082);
	level.iz_route[level.iz_route.size] = (-1967, -16167, 11018);
	level.iz_route[level.iz_route.size] = (-2736, -16003, 11001);
	level.iz_route[level.iz_route.size] = (-3530, -15879, 10996);
	level.iz_route[level.iz_route.size] = (-4090, -15565, 10961);
	level.iz_route[level.iz_route.size] = (-4519, -14825, 10881);
	level.iz_route[level.iz_route.size] = (-5000, -13125, 10756);
	level.iz_route[level.iz_route.size] = (-5340, -12435, 10728);
	level.iz_route[level.iz_route.size] = (-6180, -12000, 11016);
	level.iz_route[level.iz_route.size] = (-7673, -10851, 10818);
	level.iz_route[level.iz_route.size] = (-9324, -9905, 10471);
	level.iz_route[level.iz_route.size] = (-10283, -9178, 10399);
	level.iz_route[level.iz_route.size] = (-10853, -8144, 10441);
	level.iz_route[level.iz_route.size] = (-10978, -7286, 10607);
	level.iz_route[level.iz_route.size] = (-10610, -5968, 10903);
	level.iz_route[level.iz_route.size] = (-10225, -5478, 11036);
	level.iz_route[level.iz_route.size] = (-9361, -5115, 11018);
	level.iz_route[level.iz_route.size] = (-8301, -5176, 10928);
	level.iz_route[level.iz_route.size] = (-7900, -5283, 10992);
	level.iz_route[level.iz_route.size] = (-5228, -5739, 9974);
	level.iz_route[level.iz_route.size] = (-4181, -6038, 9560);
	level.iz_route[level.iz_route.size] = (-2857, -6304, 9560);
	level.iz_route[level.iz_route.size] = (-1326, -6360, 9493);
	level.iz_route[level.iz_route.size] = (-474, -6276, 9458);
	level.iz_route[level.iz_route.size] = (48, -6129, 9429);
	level.iz_route[level.iz_route.size] = (324, -5947, 9480);
	level.iz_route[level.iz_route.size] = (687, -5414, 9259);
	level.iz_route[level.iz_route.size] = (752, -4928, 9255);
	level.iz_route[level.iz_route.size] = (621, -4457, 9247);
	level.iz_route[level.iz_route.size] = (45, -3723, 9233);
	level.iz_route[level.iz_route.size] = (-301, -3325, 9307);
	level.iz_route[level.iz_route.size] = (-918, -2571, 9106);
	level.iz_route[level.iz_route.size] = (-1181, -2218, 9083);
	level.iz_route[level.iz_route.size] = (-1455, -1691, 9046);
	level.iz_route[level.iz_route.size] = (-1568, -1215, 9022);
	level.iz_route[level.iz_route.size] = (-1553, -630, 8999);
	level.iz_route[level.iz_route.size] = (-1289, -41, 8972);
	level.iz_route[level.iz_route.size] = (-857, 304, 8942);
	level.iz_route[level.iz_route.size] = (256, 773, 8875);
	level.iz_route[level.iz_route.size] = (1013, 1102, 8881);
	level.iz_route[level.iz_route.size] = (1586, 1238, 8732);
	level.iz_route[level.iz_route.size] = (2272, 1452, 8713);
	level.iz_route[level.iz_route.size] = (3154, 1608, 8698);
	level.iz_route[level.iz_route.size] = (4021, 1604, 8682);
	level.iz_route[level.iz_route.size] = (4528, 1427, 8701);
	level.iz_route[level.iz_route.size] = (5076, 964, 8713);
	level.iz_route[level.iz_route.size] = (5348, 340, 8643);
	level.iz_route[level.iz_route.size] = (5440, -379, 8629);
	level.iz_route[level.iz_route.size] = (5451, -1157, 8664);
	level.iz_route[level.iz_route.size] = (5469, -3084, 8727);
	level.iz_route[level.iz_route.size] = (4951, -5803, 8786);
	level.iz_route[level.iz_route.size] = (4817, -6613, 8855);
	level.iz_route[level.iz_route.size] = (4220, -7790, 9075);
	level.iz_route[level.iz_route.size] = (3991, -8503, 9205);
	level.iz_route[level.iz_route.size] = (4390, -9108, 9264);
	level.iz_route[level.iz_route.size] = (5745, -9599, 9259);
	level.iz_route[level.iz_route.size] = (6434, -10042, 9313);
	level.iz_route[level.iz_route.size] = (6672, -11409, 9599);
}
