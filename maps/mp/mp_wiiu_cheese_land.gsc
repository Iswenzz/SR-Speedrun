main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_wiiu_cheese_land", 0);

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
	ambientPlay("iz_0_ucl", 2);
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
	level.iz_route[level.iz_route.size] = (1, -1407, 9559);
	level.iz_route[level.iz_route.size] = (28, -2934, 9567);
	level.iz_route[level.iz_route.size] = (107, -3400, 9571);
	level.iz_route[level.iz_route.size] = (452, -3919, 9579);
	level.iz_route[level.iz_route.size] = (961, -4112, 9571);
	level.iz_route[level.iz_route.size] = (1529, -4086, 9547);
	level.iz_route[level.iz_route.size] = (2027, -3844, 9511);
	level.iz_route[level.iz_route.size] = (2321, -3481, 9477);
	level.iz_route[level.iz_route.size] = (2536, -2886, 9453);
	level.iz_route[level.iz_route.size] = (2718, -2060, 9486);
	level.iz_route[level.iz_route.size] = (2866, -1433, 9531);
	level.iz_route[level.iz_route.size] = (3075, -1071, 9564);
	level.iz_route[level.iz_route.size] = (3412, -880, 9582);
	level.iz_route[level.iz_route.size] = (4443, -460, 9564);
	level.iz_route[level.iz_route.size] = (5342, -60, 9505);
	level.iz_route[level.iz_route.size] = (6141, 505, 9510);
	level.iz_route[level.iz_route.size] = (7047, 1311, 9575);
	level.iz_route[level.iz_route.size] = (7595, 1560, 9619);
	level.iz_route[level.iz_route.size] = (8208, 1580, 9665);
	level.iz_route[level.iz_route.size] = (8614, 1382, 9659);
	level.iz_route[level.iz_route.size] = (8939, 985, 9594);
	level.iz_route[level.iz_route.size] = (9122, 445, 9501);
	level.iz_route[level.iz_route.size] = (9131, -266, 9395);
	level.iz_route[level.iz_route.size] = (9057, -1115, 9285);
	level.iz_route[level.iz_route.size] = (8895, -2538, 9238);
	level.iz_route[level.iz_route.size] = (8866, -3775, 9276);
	level.iz_route[level.iz_route.size] = (8936, -4437, 9340);
	level.iz_route[level.iz_route.size] = (9252, -4942, 9422);
	level.iz_route[level.iz_route.size] = (9810, -5317, 9490);
	level.iz_route[level.iz_route.size] = (10674, -5470, 9547);
	level.iz_route[level.iz_route.size] = (11493, -5360, 9638);
	level.iz_route[level.iz_route.size] = (12100, -4932, 9725);
	level.iz_route[level.iz_route.size] = (12394, -4321, 9785);
	level.iz_route[level.iz_route.size] = (12435, -3684, 9822);
	level.iz_route[level.iz_route.size] = (12317, -3166, 9846);
	level.iz_route[level.iz_route.size] = (12042, -2772, 9822);
	level.iz_route[level.iz_route.size] = (11583, -2482, 9758);
	level.iz_route[level.iz_route.size] = (10969, -2383, 9685);
	level.iz_route[level.iz_route.size] = (10270, -2388, 9699);
	level.iz_route[level.iz_route.size] = (9780, -2437, 9772);
	level.iz_route[level.iz_route.size] = (7825, -2728, 9796);
	level.iz_route[level.iz_route.size] = (6566, -2942, 9908);
	level.iz_route[level.iz_route.size] = (5872, -2951, 10081);
	level.iz_route[level.iz_route.size] = (5540, -2723, 10202);
	level.iz_route[level.iz_route.size] = (5354, -2348, 10308);
	level.iz_route[level.iz_route.size] = (5392, -1929, 10363);
	level.iz_route[level.iz_route.size] = (5650, -1517, 10360);
	level.iz_route[level.iz_route.size] = (6231, -1034, 10291);
	level.iz_route[level.iz_route.size] = (6827, -742, 10204);
	level.iz_route[level.iz_route.size] = (7627, -588, 10095);
	level.iz_route[level.iz_route.size] = (8559, -495, 10030);
	level.iz_route[level.iz_route.size] = (10482, -408, 9797);
	level.iz_route[level.iz_route.size] = (11453, -229, 9578);
	level.iz_route[level.iz_route.size] = (12137, 9, 9548);
	level.iz_route[level.iz_route.size] = (12493, 314, 9507);
	level.iz_route[level.iz_route.size] = (12755, 709, 9449);
	level.iz_route[level.iz_route.size] = (12877, 1008, 9400);
	level.iz_route[level.iz_route.size] = (12924, 1530, 9286);
	level.iz_route[level.iz_route.size] = (12847, 2064, 9148);
	level.iz_route[level.iz_route.size] = (12543, 2553, 8981);
	level.iz_route[level.iz_route.size] = (12006, 3137, 8759);
	level.iz_route[level.iz_route.size] = (11469, 3509, 8613);
	level.iz_route[level.iz_route.size] = (10647, 3763, 8508);
	level.iz_route[level.iz_route.size] = (9630, 3950, 8431);
	level.iz_route[level.iz_route.size] = (8469, 4222, 8354);
	level.iz_route[level.iz_route.size] = (7906, 4506, 8297);
	level.iz_route[level.iz_route.size] = (7474, 4861, 8228);
	level.iz_route[level.iz_route.size] = (7119, 5395, 8111);
	level.iz_route[level.iz_route.size] = (6726, 6179, 7932);
	level.iz_route[level.iz_route.size] = (6341, 7217, 7694);
	level.iz_route[level.iz_route.size] = (6092, 7639, 7627);
	level.iz_route[level.iz_route.size] = (5729, 7975, 7609);
	level.iz_route[level.iz_route.size] = (5234, 8137, 7662);
	level.iz_route[level.iz_route.size] = (4731, 8101, 7757);
	level.iz_route[level.iz_route.size] = (4241, 7863, 7876);
	level.iz_route[level.iz_route.size] = (3801, 7405, 8021);
	level.iz_route[level.iz_route.size] = (3515, 6738, 8178);
	level.iz_route[level.iz_route.size] = (3193, 5868, 8375);
	level.iz_route[level.iz_route.size] = (3017, 5607, 8456);
	level.iz_route[level.iz_route.size] = (2751, 5350, 8564);
	level.iz_route[level.iz_route.size] = (2408, 5201, 8662);
	level.iz_route[level.iz_route.size] = (1998, 5233, 8728);
	level.iz_route[level.iz_route.size] = (1428, 5467, 8777);
	level.iz_route[level.iz_route.size] = (865, 5720, 8831);
	level.iz_route[level.iz_route.size] = (574, 5765, 8877);
	level.iz_route[level.iz_route.size] = (238, 5684, 8952);
	level.iz_route[level.iz_route.size] = (32, 5462, 9021);
	level.iz_route[level.iz_route.size] = (-106, 4998, 9095);
	level.iz_route[level.iz_route.size] = (-182, 4431, 9175);
	level.iz_route[level.iz_route.size] = (-214, 3933, 9258);
	level.iz_route[level.iz_route.size] = (-211, 3383, 9356);
	level.iz_route[level.iz_route.size] = (-145, 2411, 9434);
	level.iz_route[level.iz_route.size] = (-105, 1826, 9565);
	level.iz_route[level.iz_route.size] = (-16, 247, 9540);
}
