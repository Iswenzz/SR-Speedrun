main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_3ds_toad_circuit", 0);

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
	ambientPlay("iz_0_104", 2);
	iz_emitter("iz_1_se_cc_env_audience", (7270.3970, 10464.9922, 599.1998), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_audience", (5701.7427, 10465.3525, 599.1998), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_audience", (4133.0889, 10465.7119, 599.1998), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_audience", (2564.4353, 10466.0713, 599.1998), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_audience", (995.7814, 10466.4316, 599.1998), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_audience", (-1204.9666, 4274.9673, 599.1998), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_audience", (-1209.1270, 6132.2393, 599.1998), 0, 12.0104);
	iz_emitter("iz_1_se_cc_env_audience", (-1213.2874, 7989.5112, 599.1998), 0, 12.0104);
}

iz_emitter(alias, origin, interval, length)
{
	ent = spawn("script_origin", origin);
	if (interval <= 0)
		ent playLoopSound(alias);
	else
		ent thread iz_emitter_random(alias, interval, length);
}

// One play at a time: copies started over one another ran out the
// engine's 32 voices, and the sounds that lost theirs restarted.
iz_emitter_random(alias, interval, length)
{
	for (;;)
	{
		wait(randomFloatRange(interval * 0.25, interval));
		self playSound(alias);
		wait(length);
	}
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
	level.iz_route[level.iz_route.size] = (488, 3185, 295);
	level.iz_route[level.iz_route.size] = (488, 2398, 295);
	level.iz_route[level.iz_route.size] = (487, 1627, 295);
	level.iz_route[level.iz_route.size] = (465, 371, 295);
	level.iz_route[level.iz_route.size] = (443, -1609, 295);
	level.iz_route[level.iz_route.size] = (151, -2882, 309);
	level.iz_route[level.iz_route.size] = (-4, -3615, 317);
	level.iz_route[level.iz_route.size] = (-426, -4398, 376);
	level.iz_route[level.iz_route.size] = (-1081, -4934, 452);
	level.iz_route[level.iz_route.size] = (-2152, -5331, 528);
	level.iz_route[level.iz_route.size] = (-3204, -5073, 505);
	level.iz_route[level.iz_route.size] = (-4038, -4418, 448);
	level.iz_route[level.iz_route.size] = (-4454, -3624, 379);
	level.iz_route[level.iz_route.size] = (-4534, -2552, 293);
	level.iz_route[level.iz_route.size] = (-4077, -1659, 185);
	level.iz_route[level.iz_route.size] = (-3303, -925, 94);
	level.iz_route[level.iz_route.size] = (-2218, -905, 32);
	level.iz_route[level.iz_route.size] = (-942, -905, 30);
	level.iz_route[level.iz_route.size] = (368, -905, 30);
	level.iz_route[level.iz_route.size] = (1479, -905, 31);
	level.iz_route[level.iz_route.size] = (2749, -846, 79);
	level.iz_route[level.iz_route.size] = (4377, -746, 164);
	level.iz_route[level.iz_route.size] = (6099, -711, 271);
	level.iz_route[level.iz_route.size] = (6487, -654, 299);
	level.iz_route[level.iz_route.size] = (7427, -298, 379);
	level.iz_route[level.iz_route.size] = (7643, 70, 384);
	level.iz_route[level.iz_route.size] = (7849, 781, 407);
	level.iz_route[level.iz_route.size] = (7705, 1476, 388);
	level.iz_route[level.iz_route.size] = (7253, 2118, 373);
	level.iz_route[level.iz_route.size] = (6905, 2251, 351);
	level.iz_route[level.iz_route.size] = (6171, 2364, 319);
	level.iz_route[level.iz_route.size] = (5490, 2597, 330);
	level.iz_route[level.iz_route.size] = (4967, 3019, 347);
	level.iz_route[level.iz_route.size] = (4643, 3749, 364);
	level.iz_route[level.iz_route.size] = (4654, 4388, 363);
	level.iz_route[level.iz_route.size] = (4910, 5074, 364);
	level.iz_route[level.iz_route.size] = (5053, 5623, 372);
	level.iz_route[level.iz_route.size] = (5094, 6260, 400);
	level.iz_route[level.iz_route.size] = (5162, 6949, 445);
	level.iz_route[level.iz_route.size] = (4765, 7545, 483);
	level.iz_route[level.iz_route.size] = (3996, 8364, 534);
	level.iz_route[level.iz_route.size] = (3475, 8785, 570);
	level.iz_route[level.iz_route.size] = (2507, 9282, 671);
	level.iz_route[level.iz_route.size] = (1489, 9058, 672);
	level.iz_route[level.iz_route.size] = (770, 8364, 510);
	level.iz_route[level.iz_route.size] = (527, 7619, 383);
	level.iz_route[level.iz_route.size] = (432, 6899, 341);
	level.iz_route[level.iz_route.size] = (442, 5981, 307);
	level.iz_route[level.iz_route.size] = (447, 5112, 295);
	level.iz_route[level.iz_route.size] = (474, 4048, 295);
	level.iz_route[level.iz_route.size] = (481, 3776, 295);
}
