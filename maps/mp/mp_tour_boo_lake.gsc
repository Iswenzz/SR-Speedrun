main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_tour_boo_lake", 0);

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
	ambientPlay("iz_0_trbl", 2);
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
	level.iz_route[level.iz_route.size] = (4229, 328, 5949);
	level.iz_route[level.iz_route.size] = (4234, -1582, 5949);
	level.iz_route[level.iz_route.size] = (4208, -2554, 5949);
	level.iz_route[level.iz_route.size] = (4206, -2855, 5949);
	level.iz_route[level.iz_route.size] = (4099, -3131, 5949);
	level.iz_route[level.iz_route.size] = (3862, -3397, 5949);
	level.iz_route[level.iz_route.size] = (3626, -3601, 5949);
	level.iz_route[level.iz_route.size] = (3331, -3742, 5949);
	level.iz_route[level.iz_route.size] = (2890, -3780, 5949);
	level.iz_route[level.iz_route.size] = (2252, -3805, 6037);
	level.iz_route[level.iz_route.size] = (1561, -3796, 5824);
	level.iz_route[level.iz_route.size] = (816, -3792, 5881);
	level.iz_route[level.iz_route.size] = (181, -3794, 6019);
	level.iz_route[level.iz_route.size] = (-1013, -3779, 5914);
	level.iz_route[level.iz_route.size] = (-2758, -3805, 5914);
	level.iz_route[level.iz_route.size] = (-3265, -3821, 5914);
	level.iz_route[level.iz_route.size] = (-3636, -3812, 5914);
	level.iz_route[level.iz_route.size] = (-3956, -3756, 5914);
	level.iz_route[level.iz_route.size] = (-4209, -3603, 5914);
	level.iz_route[level.iz_route.size] = (-4406, -3391, 5914);
	level.iz_route[level.iz_route.size] = (-4558, -3121, 5914);
	level.iz_route[level.iz_route.size] = (-4629, -2901, 5914);
	level.iz_route[level.iz_route.size] = (-4698, -2584, 5914);
	level.iz_route[level.iz_route.size] = (-4713, -2278, 5914);
	level.iz_route[level.iz_route.size] = (-4743, -1912, 5914);
	level.iz_route[level.iz_route.size] = (-4768, -1573, 5914);
	level.iz_route[level.iz_route.size] = (-4759, -1176, 5914);
	level.iz_route[level.iz_route.size] = (-4693, -1010, 5914);
	level.iz_route[level.iz_route.size] = (-4471, -765, 5914);
	level.iz_route[level.iz_route.size] = (-4260, -595, 5914);
	level.iz_route[level.iz_route.size] = (-4092, -396, 5914);
	level.iz_route[level.iz_route.size] = (-4007, -172, 5914);
	level.iz_route[level.iz_route.size] = (-3969, 91, 5914);
	level.iz_route[level.iz_route.size] = (-3963, 381, 5914);
	level.iz_route[level.iz_route.size] = (-3959, 1033, 5914);
	level.iz_route[level.iz_route.size] = (-3972, 1686, 5914);
	level.iz_route[level.iz_route.size] = (-3961, 2174, 5914);
	level.iz_route[level.iz_route.size] = (-4026, 2351, 5914);
	level.iz_route[level.iz_route.size] = (-4190, 2525, 5914);
	level.iz_route[level.iz_route.size] = (-4422, 2699, 5914);
	level.iz_route[level.iz_route.size] = (-4646, 2895, 5914);
	level.iz_route[level.iz_route.size] = (-5060, 3074, 5914);
	level.iz_route[level.iz_route.size] = (-5174, 3241, 5915);
	level.iz_route[level.iz_route.size] = (-5369, 3512, 5975);
	level.iz_route[level.iz_route.size] = (-5745, 4012, 6140);
	level.iz_route[level.iz_route.size] = (-6098, 4456, 6290);
	level.iz_route[level.iz_route.size] = (-6589, 5022, 6489);
	level.iz_route[level.iz_route.size] = (-6821, 5322, 6590);
	level.iz_route[level.iz_route.size] = (-6870, 5473, 6627);
	level.iz_route[level.iz_route.size] = (-6835, 5708, 6662);
	level.iz_route[level.iz_route.size] = (-6720, 6004, 6693);
	level.iz_route[level.iz_route.size] = (-6475, 6371, 6713);
	level.iz_route[level.iz_route.size] = (-6172, 6543, 6686);
	level.iz_route[level.iz_route.size] = (-5802, 6529, 6612);
	level.iz_route[level.iz_route.size] = (-5367, 6294, 6483);
	level.iz_route[level.iz_route.size] = (-4825, 5696, 6414);
	level.iz_route[level.iz_route.size] = (-4313, 5168, 5638);
	level.iz_route[level.iz_route.size] = (-3924, 4785, 5471);
	level.iz_route[level.iz_route.size] = (-3603, 4471, 5334);
	level.iz_route[level.iz_route.size] = (-3316, 4186, 5210);
	level.iz_route[level.iz_route.size] = (-3086, 3940, 5107);
	level.iz_route[level.iz_route.size] = (-2866, 3686, 5103);
	level.iz_route[level.iz_route.size] = (-2577, 3378, 5277);
	level.iz_route[level.iz_route.size] = (-1978, 2770, 5102);
	level.iz_route[level.iz_route.size] = (-1584, 2400, 5102);
	level.iz_route[level.iz_route.size] = (-1120, 1940, 5102);
	level.iz_route[level.iz_route.size] = (-251, 1045, 5102);
	level.iz_route[level.iz_route.size] = (82, 699, 5102);
	level.iz_route[level.iz_route.size] = (264, 553, 5112);
	level.iz_route[level.iz_route.size] = (516, 479, 5183);
	level.iz_route[level.iz_route.size] = (1055, 500, 5276);
	level.iz_route[level.iz_route.size] = (1434, 611, 5312);
	level.iz_route[level.iz_route.size] = (1762, 886, 5283);
	level.iz_route[level.iz_route.size] = (2018, 1172, 5233);
	level.iz_route[level.iz_route.size] = (2244, 1557, 5150);
	level.iz_route[level.iz_route.size] = (2309, 2067, 4998);
	level.iz_route[level.iz_route.size] = (2343, 2748, 4785);
	level.iz_route[level.iz_route.size] = (2339, 4595, 4190);
	level.iz_route[level.iz_route.size] = (2363, 5167, 4011);
	level.iz_route[level.iz_route.size] = (2108, 5608, 3840);
	level.iz_route[level.iz_route.size] = (1606, 5879, 3731);
	level.iz_route[level.iz_route.size] = (973, 6134, 3675);
	level.iz_route[level.iz_route.size] = (560, 6486, 3600);
	level.iz_route[level.iz_route.size] = (414, 6923, 3507);
	level.iz_route[level.iz_route.size] = (411, 7875, 3304);
	level.iz_route[level.iz_route.size] = (470, 8296, 3214);
	level.iz_route[level.iz_route.size] = (743, 8674, 3132);
	level.iz_route[level.iz_route.size] = (1184, 8825, 3098);
	level.iz_route[level.iz_route.size] = (1929, 8839, 3095);
	level.iz_route[level.iz_route.size] = (2763, 8845, 3093);
	level.iz_route[level.iz_route.size] = (3083, 8729, 3122);
	level.iz_route[level.iz_route.size] = (3367, 8547, 3170);
	level.iz_route[level.iz_route.size] = (3780, 8160, 3254);
	level.iz_route[level.iz_route.size] = (4151, 7728, 3349);
	level.iz_route[level.iz_route.size] = (4186, 7560, 3410);
	level.iz_route[level.iz_route.size] = (4198, 7197, 3637);
	level.iz_route[level.iz_route.size] = (4369, 6538, 4285);
	level.iz_route[level.iz_route.size] = (4425, 6074, 4223);
	level.iz_route[level.iz_route.size] = (4442, 5681, 4490);
	level.iz_route[level.iz_route.size] = (4406, 5338, 4955);
	level.iz_route[level.iz_route.size] = (4091, 4517, 5143);
	level.iz_route[level.iz_route.size] = (4117, 4210, 5399);
	level.iz_route[level.iz_route.size] = (4118, 3772, 6004);
	level.iz_route[level.iz_route.size] = (4184, 2757, 5949);
	level.iz_route[level.iz_route.size] = (4231, 1624, 5949);
}
