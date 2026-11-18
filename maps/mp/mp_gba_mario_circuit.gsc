main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_gba_mario_circuit", 0);

	setExpFog(7381.8896, 21991.8789, 0.8039, 0.6000, 0.4510, 0);

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
	ambientPlay("iz_0_40", 2);
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
	level.iz_route[level.iz_route.size] = (38, -573, 825);
	level.iz_route[level.iz_route.size] = (53, -1593, 825);
	level.iz_route[level.iz_route.size] = (88, -2579, 825);
	level.iz_route[level.iz_route.size] = (156, -2932, 825);
	level.iz_route[level.iz_route.size] = (343, -3310, 825);
	level.iz_route[level.iz_route.size] = (620, -3535, 825);
	level.iz_route[level.iz_route.size] = (984, -3693, 825);
	level.iz_route[level.iz_route.size] = (1480, -3817, 825);
	level.iz_route[level.iz_route.size] = (1920, -3817, 825);
	level.iz_route[level.iz_route.size] = (2491, -3620, 825);
	level.iz_route[level.iz_route.size] = (3199, -3374, 825);
	level.iz_route[level.iz_route.size] = (3821, -3283, 825);
	level.iz_route[level.iz_route.size] = (4343, -3276, 826);
	level.iz_route[level.iz_route.size] = (5002, -3369, 828);
	level.iz_route[level.iz_route.size] = (5606, -3594, 828);
	level.iz_route[level.iz_route.size] = (6974, -4142, 807);
	level.iz_route[level.iz_route.size] = (8080, -4552, 796);
	level.iz_route[level.iz_route.size] = (8597, -4635, 798);
	level.iz_route[level.iz_route.size] = (9058, -4626, 802);
	level.iz_route[level.iz_route.size] = (9401, -4478, 804);
	level.iz_route[level.iz_route.size] = (9610, -4249, 803);
	level.iz_route[level.iz_route.size] = (9772, -3910, 804);
	level.iz_route[level.iz_route.size] = (9778, -3565, 802);
	level.iz_route[level.iz_route.size] = (9681, -3199, 801);
	level.iz_route[level.iz_route.size] = (9492, -2858, 799);
	level.iz_route[level.iz_route.size] = (8993, -2475, 790);
	level.iz_route[level.iz_route.size] = (8030, -2004, 805);
	level.iz_route[level.iz_route.size] = (7005, -1345, 840);
	level.iz_route[level.iz_route.size] = (6772, -1066, 840);
	level.iz_route[level.iz_route.size] = (6649, -763, 840);
	level.iz_route[level.iz_route.size] = (6631, -462, 841);
	level.iz_route[level.iz_route.size] = (6660, -181, 844);
	level.iz_route[level.iz_route.size] = (6803, 131, 848);
	level.iz_route[level.iz_route.size] = (7180, 515, 842);
	level.iz_route[level.iz_route.size] = (7873, 999, 830);
	level.iz_route[level.iz_route.size] = (8661, 1442, 831);
	level.iz_route[level.iz_route.size] = (9412, 1886, 840);
	level.iz_route[level.iz_route.size] = (9732, 2181, 841);
	level.iz_route[level.iz_route.size] = (9983, 2453, 844);
	level.iz_route[level.iz_route.size] = (10083, 2775, 842);
	level.iz_route[level.iz_route.size] = (10087, 3207, 846);
	level.iz_route[level.iz_route.size] = (9992, 3546, 852);
	level.iz_route[level.iz_route.size] = (9715, 3857, 856);
	level.iz_route[level.iz_route.size] = (9288, 4165, 856);
	level.iz_route[level.iz_route.size] = (8410, 4471, 837);
	level.iz_route[level.iz_route.size] = (7517, 4717, 826);
	level.iz_route[level.iz_route.size] = (6804, 4989, 825);
	level.iz_route[level.iz_route.size] = (6496, 5198, 825);
	level.iz_route[level.iz_route.size] = (6188, 5510, 825);
	level.iz_route[level.iz_route.size] = (5575, 6180, 825);
	level.iz_route[level.iz_route.size] = (4981, 6583, 825);
	level.iz_route[level.iz_route.size] = (4359, 6798, 825);
	level.iz_route[level.iz_route.size] = (3704, 6772, 825);
	level.iz_route[level.iz_route.size] = (3109, 6611, 825);
	level.iz_route[level.iz_route.size] = (2172, 6293, 824);
	level.iz_route[level.iz_route.size] = (1760, 6195, 822);
	level.iz_route[level.iz_route.size] = (1409, 6177, 817);
	level.iz_route[level.iz_route.size] = (1050, 6263, 813);
	level.iz_route[level.iz_route.size] = (362, 6576, 812);
	level.iz_route[level.iz_route.size] = (-114, 6664, 805);
	level.iz_route[level.iz_route.size] = (-469, 6603, 797);
	level.iz_route[level.iz_route.size] = (-829, 6372, 793);
	level.iz_route[level.iz_route.size] = (-1102, 5939, 793);
	level.iz_route[level.iz_route.size] = (-1176, 5445, 791);
	level.iz_route[level.iz_route.size] = (-1119, 4971, 790);
	level.iz_route[level.iz_route.size] = (-946, 4556, 789);
	level.iz_route[level.iz_route.size] = (-651, 4187, 792);
	level.iz_route[level.iz_route.size] = (-354, 3709, 800);
	level.iz_route[level.iz_route.size] = (-137, 3203, 812);
	level.iz_route[level.iz_route.size] = (-66, 2682, 820);
	level.iz_route[level.iz_route.size] = (21, 1386, 825);
	level.iz_route[level.iz_route.size] = (38, 296, 825);
}
