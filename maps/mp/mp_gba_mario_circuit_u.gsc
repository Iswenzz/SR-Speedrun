main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_gba_mario_circuit_u", 0);

	setExpFog(8858.2676, 23314.4688, 0.5882, 0.8314, 1, 0);

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
	ambientPlay("iz_0_gmc", 2);
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
	level.iz_route[level.iz_route.size] = (-1318, 3348, 155);
	level.iz_route[level.iz_route.size] = (-4028, 3338, 155);
	level.iz_route[level.iz_route.size] = (-4605, 3320, 155);
	level.iz_route[level.iz_route.size] = (-5051, 3189, 155);
	level.iz_route[level.iz_route.size] = (-5409, 2953, 155);
	level.iz_route[level.iz_route.size] = (-5619, 2639, 155);
	level.iz_route[level.iz_route.size] = (-5732, 2307, 155);
	level.iz_route[level.iz_route.size] = (-5741, 1887, 155);
	level.iz_route[level.iz_route.size] = (-5671, 1529, 155);
	level.iz_route[level.iz_route.size] = (-5496, 1223, 155);
	level.iz_route[level.iz_route.size] = (-5243, 970, 155);
	level.iz_route[level.iz_route.size] = (-4605, 568, 155);
	level.iz_route[level.iz_route.size] = (-4343, 280, 155);
	level.iz_route[level.iz_route.size] = (-4194, -52, 155);
	level.iz_route[level.iz_route.size] = (-4142, -384, 155);
	level.iz_route[level.iz_route.size] = (-4168, -725, 155);
	level.iz_route[level.iz_route.size] = (-4308, -1066, 155);
	level.iz_route[level.iz_route.size] = (-5059, -2263, 155);
	level.iz_route[level.iz_route.size] = (-5391, -2814, 252);
	level.iz_route[level.iz_route.size] = (-5802, -3478, 389);
	level.iz_route[level.iz_route.size] = (-7305, -5933, 1731);
	level.iz_route[level.iz_route.size] = (-7441, -6265, 1896);
	level.iz_route[level.iz_route.size] = (-7471, -6608, 2040);
	level.iz_route[level.iz_route.size] = (-7383, -6951, 2154);
	level.iz_route[level.iz_route.size] = (-7157, -7216, 2204);
	level.iz_route[level.iz_route.size] = (-6863, -7402, 2207);
	level.iz_route[level.iz_route.size] = (-6490, -7500, 2155);
	level.iz_route[level.iz_route.size] = (-6147, -7481, 2063);
	level.iz_route[level.iz_route.size] = (-5834, -7334, 1928);
	level.iz_route[level.iz_route.size] = (-5598, -7079, 1769);
	level.iz_route[level.iz_route.size] = (-4500, -5343, 812);
	level.iz_route[level.iz_route.size] = (-4284, -4981, 660);
	level.iz_route[level.iz_route.size] = (-3569, -3784, 155);
	level.iz_route[level.iz_route.size] = (-2912, -2765, 155);
	level.iz_route[level.iz_route.size] = (-2539, -2363, 155);
	level.iz_route[level.iz_route.size] = (-2167, -2118, 155);
	level.iz_route[level.iz_route.size] = (-1765, -1941, 155);
	level.iz_route[level.iz_route.size] = (-1275, -1882, 155);
	level.iz_route[level.iz_route.size] = (-745, -1892, 155);
	level.iz_route[level.iz_route.size] = (-206, -2039, 155);
	level.iz_route[level.iz_route.size] = (176, -2275, 155);
	level.iz_route[level.iz_route.size] = (500, -2579, 155);
	level.iz_route[level.iz_route.size] = (755, -2990, 155);
	level.iz_route[level.iz_route.size] = (951, -3510, 155);
	level.iz_route[level.iz_route.size] = (1069, -4049, 155);
	level.iz_route[level.iz_route.size] = (1059, -4647, 155);
	level.iz_route[level.iz_route.size] = (1069, -5304, 155);
	level.iz_route[level.iz_route.size] = (1137, -5785, 155);
	level.iz_route[level.iz_route.size] = (1324, -6206, 155);
	level.iz_route[level.iz_route.size] = (1637, -6608, 155);
	level.iz_route[level.iz_route.size] = (2118, -6853, 155);
	level.iz_route[level.iz_route.size] = (2618, -6961, 155);
	level.iz_route[level.iz_route.size] = (3118, -6932, 155);
	level.iz_route[level.iz_route.size] = (3618, -6785, 155);
	level.iz_route[level.iz_route.size] = (4020, -6549, 155);
	level.iz_route[level.iz_route.size] = (4314, -6216, 155);
	level.iz_route[level.iz_route.size] = (4530, -5843, 155);
	level.iz_route[level.iz_route.size] = (4686, -5441, 155);
	level.iz_route[level.iz_route.size] = (5530, -3657, 155);
	level.iz_route[level.iz_route.size] = (5863, -3177, 155);
	level.iz_route[level.iz_route.size] = (6324, -2716, 155);
	level.iz_route[level.iz_route.size] = (6706, -2382, 155);
	level.iz_route[level.iz_route.size] = (7490, -1882, 155);
	level.iz_route[level.iz_route.size] = (8108, -1078, 155);
	level.iz_route[level.iz_route.size] = (8245, -637, 155);
	level.iz_route[level.iz_route.size] = (8226, -167, 155);
	level.iz_route[level.iz_route.size] = (8108, 275, 155);
	level.iz_route[level.iz_route.size] = (7843, 676, 155);
	level.iz_route[level.iz_route.size] = (7481, 1039, 155);
	level.iz_route[level.iz_route.size] = (7275, 1402, 155);
	level.iz_route[level.iz_route.size] = (7187, 1775, 155);
	level.iz_route[level.iz_route.size] = (7236, 2137, 155);
	level.iz_route[level.iz_route.size] = (7422, 2461, 155);
	level.iz_route[level.iz_route.size] = (7667, 2726, 155);
	level.iz_route[level.iz_route.size] = (7804, 3030, 155);
	level.iz_route[level.iz_route.size] = (7824, 3382, 155);
	level.iz_route[level.iz_route.size] = (7667, 3716, 155);
	level.iz_route[level.iz_route.size] = (7392, 3932, 155);
	level.iz_route[level.iz_route.size] = (7049, 4039, 155);
	level.iz_route[level.iz_route.size] = (6745, 4000, 155);
	level.iz_route[level.iz_route.size] = (6167, 3765, 155);
	level.iz_route[level.iz_route.size] = (5598, 3569, 155);
	level.iz_route[level.iz_route.size] = (5039, 3461, 155);
	level.iz_route[level.iz_route.size] = (4609, 3412, 155);
	level.iz_route[level.iz_route.size] = (4064, 3373, 155);
	level.iz_route[level.iz_route.size] = (-863, 3353, 155);
}
