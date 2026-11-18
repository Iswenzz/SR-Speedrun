main()
{
	setDvar("bg_falldamagemaxheight", 2000000000);
	setDvar("bg_falldamageminheight", 1500000000);

	visionSetNaked("mp_gp_rainbow_coaster", 0);

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
	ambientPlay("iz_0_gprc", 2);
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
	level.iz_route[level.iz_route.size] = (-36872, 2567, 9607);
	level.iz_route[level.iz_route.size] = (-36830, -172, 9607);
	level.iz_route[level.iz_route.size] = (-36686, -3097, 9221);
	level.iz_route[level.iz_route.size] = (-36608, -5780, 8969);
	level.iz_route[level.iz_route.size] = (-36678, -7737, 8969);
	level.iz_route[level.iz_route.size] = (-36799, -9459, 9071);
	level.iz_route[level.iz_route.size] = (-36156, -10543, 9374);
	level.iz_route[level.iz_route.size] = (-34508, -11309, 9663);
	level.iz_route[level.iz_route.size] = (-33036, -10906, 9487);
	level.iz_route[level.iz_route.size] = (-31860, -9885, 9047);
	level.iz_route[level.iz_route.size] = (-31629, -8351, 8808);
	level.iz_route[level.iz_route.size] = (-31712, -6944, 8809);
	level.iz_route[level.iz_route.size] = (-32431, -6163, 8809);
	level.iz_route[level.iz_route.size] = (-32441, -4872, 8809);
	level.iz_route[level.iz_route.size] = (-32449, -3619, 8809);
	level.iz_route[level.iz_route.size] = (-31324, -1725, 8809);
	level.iz_route[level.iz_route.size] = (-31290, 692, 9121);
	level.iz_route[level.iz_route.size] = (-31305, 3420, 9128);
	level.iz_route[level.iz_route.size] = (-31288, 6383, 9131);
	level.iz_route[level.iz_route.size] = (-31218, 9532, 9915);
	level.iz_route[level.iz_route.size] = (23754, 9831, 10069);
	level.iz_route[level.iz_route.size] = (26446, 9848, 10069);
	level.iz_route[level.iz_route.size] = (29173, 9827, 10069);
	level.iz_route[level.iz_route.size] = (30572, 9796, 10013);
	level.iz_route[level.iz_route.size] = (32276, 9875, 9824);
	level.iz_route[level.iz_route.size] = (33674, 10475, 9734);
	level.iz_route[level.iz_route.size] = (34954, 10596, 9718);
	level.iz_route[level.iz_route.size] = (35978, 9832, 9695);
	level.iz_route[level.iz_route.size] = (36241, 8186, 9715);
	level.iz_route[level.iz_route.size] = (35207, 7134, 9713);
	level.iz_route[level.iz_route.size] = (33746, 7165, 9720);
	level.iz_route[level.iz_route.size] = (32108, 7869, 9844);
	level.iz_route[level.iz_route.size] = (29834, 7907, 10057);
	level.iz_route[level.iz_route.size] = (28669, 7833, 10041);
	level.iz_route[level.iz_route.size] = (26760, 7865, 9779);
	level.iz_route[level.iz_route.size] = (25346, 7139, 9692);
	level.iz_route[level.iz_route.size] = (25126, 5921, 9672);
	level.iz_route[level.iz_route.size] = (25740, 4859, 9711);
	level.iz_route[level.iz_route.size] = (26944, 4581, 9806);
	level.iz_route[level.iz_route.size] = (28331, 4559, 10008);
	level.iz_route[level.iz_route.size] = (29707, 4590, 10069);
	level.iz_route[level.iz_route.size] = (30974, 4575, 10082);
	level.iz_route[level.iz_route.size] = (32069, 4521, 10155);
	level.iz_route[level.iz_route.size] = (32825, 3837, 10171);
	level.iz_route[level.iz_route.size] = (33028, 2607, 10092);
	level.iz_route[level.iz_route.size] = (33025, 1119, 10069);
	level.iz_route[level.iz_route.size] = (33265, -304, 10084);
	level.iz_route[level.iz_route.size] = (33708, -1092, 10127);
	level.iz_route[level.iz_route.size] = (32885, -3272, 10154);
	level.iz_route[level.iz_route.size] = (33704, -4920, 10126);
	level.iz_route[level.iz_route.size] = (32959, -6856, 10125);
	level.iz_route[level.iz_route.size] = (33462, -9528, 10069);
	level.iz_route[level.iz_route.size] = (33427, -12533, 11016);
	level.iz_route[level.iz_route.size] = (33421, -14341, 11050);
	level.iz_route[level.iz_route.size] = (33583, -16290, 11109);
	level.iz_route[level.iz_route.size] = (34267, -17276, 11010);
	level.iz_route[level.iz_route.size] = (35817, -17328, 10677);
	level.iz_route[level.iz_route.size] = (36797, -16357, 10376);
	level.iz_route[level.iz_route.size] = (36701, -15093, 10145);
	level.iz_route[level.iz_route.size] = (35805, -14193, 9742);
	level.iz_route[level.iz_route.size] = (34407, -14116, 9457);
	level.iz_route[level.iz_route.size] = (32259, -14091, 9419);
	level.iz_route[level.iz_route.size] = (30182, -14092, 9419);
	level.iz_route[level.iz_route.size] = (26577, -14123, 9419);
	level.iz_route[level.iz_route.size] = (-33470, -15964, 11674);
	level.iz_route[level.iz_route.size] = (-33495, -14980, 11674);
	level.iz_route[level.iz_route.size] = (-33595, -12206, 11103);
	level.iz_route[level.iz_route.size] = (-33686, -10087, 10882);
	level.iz_route[level.iz_route.size] = (-33735, -8647, 10679);
	level.iz_route[level.iz_route.size] = (-33781, -7815, 10566);
	level.iz_route[level.iz_route.size] = (-33776, -7245, 10566);
	level.iz_route[level.iz_route.size] = (-33745, -6873, 10566);
	level.iz_route[level.iz_route.size] = (-33739, -6580, 10567);
	level.iz_route[level.iz_route.size] = (-33728, -6113, 10566);
	level.iz_route[level.iz_route.size] = (-33702, -5613, 10714);
	level.iz_route[level.iz_route.size] = (-33711, -4685, 10566);
	level.iz_route[level.iz_route.size] = (-33717, -3965, 10566);
	level.iz_route[level.iz_route.size] = (-33713, -3041, 10566);
	level.iz_route[level.iz_route.size] = (-33716, -2281, 10566);
	level.iz_route[level.iz_route.size] = (-33714, -1573, 10566);
	level.iz_route[level.iz_route.size] = (-33711, -874, 10532);
	level.iz_route[level.iz_route.size] = (-33789, -165, 10299);
	level.iz_route[level.iz_route.size] = (-33941, 556, 10247);
	level.iz_route[level.iz_route.size] = (-34404, 1335, 10247);
	level.iz_route[level.iz_route.size] = (-34394, 2043, 10247);
	level.iz_route[level.iz_route.size] = (-34265, 3064, 10247);
	level.iz_route[level.iz_route.size] = (-33831, 3923, 10246);
	level.iz_route[level.iz_route.size] = (-33865, 4494, 10241);
	level.iz_route[level.iz_route.size] = (-33873, 5051, 10233);
	level.iz_route[level.iz_route.size] = (-33879, 5559, 10224);
	level.iz_route[level.iz_route.size] = (-34014, 6124, 10203);
	level.iz_route[level.iz_route.size] = (-34341, 6603, 10175);
	level.iz_route[level.iz_route.size] = (-34798, 6845, 10125);
	level.iz_route[level.iz_route.size] = (-35295, 6919, 10067);
	level.iz_route[level.iz_route.size] = (-35805, 6920, 10010);
	level.iz_route[level.iz_route.size] = (-36233, 6633, 9883);
	level.iz_route[level.iz_route.size] = (-36625, 6137, 9727);
	level.iz_route[level.iz_route.size] = (-36844, 4555, 9607);
}
